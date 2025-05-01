/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controladores;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import Conexion.conexionBd;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

/**
 *
 * @author jolma
 */
public class VentaController {
    private Connection conexion;
    private List<Object[]> productosTemporales;
    private int contadorId;
    
    public VentaController() {
        conexion = conexionBd.ConectarBD();
        productosTemporales = new ArrayList<>();
        contadorId = 1;
    }
    
    public boolean validarNumeroFactura(String numeroFactura) {
        try {
            int num = Integer.parseInt(numeroFactura);
            return num > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }
    
    public Object[] buscarProductoPorReferencia(String referencia) {
        String sql = "SELECT IdProducto, Referencia, Nombre, ValorUnitario FROM Productos WHERE Referencia = ?";
        
        try (PreparedStatement pstmt = conexion.prepareStatement(sql)) {
            pstmt.setString(1, referencia);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Object[] producto = new Object[4];
                    producto[0] = rs.getInt("IdProducto");
                    producto[1] = rs.getString("Referencia");
                    producto[2] = rs.getString("Nombre");
                    producto[3] = rs.getInt("ValorUnitario");
                    return producto;
                }
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error al buscar el producto: " + e.getMessage());
        }
        return null;
    }
    
    public boolean validarProductoExistente(String referencia) {
        for (Object[] producto : productosTemporales) {
            if (producto[1].equals(referencia)) {
                return true;
            }
        }
        return false;
    }
    
    public void agregarProductoATabla(String numeroFactura, String fecha, String referencia, int cantidad) {
        // Validar que no exista el producto en la tabla temporal
        if (validarProductoExistente(referencia)) {
            JOptionPane.showMessageDialog(null, "Este producto ya fue ingresado");
            return;
        }
        
        // Validar que la fecha y número de factura coincidan con los productos existentes
        if (!productosTemporales.isEmpty()) {
            Object[] primerProducto = productosTemporales.get(0);
            if (!primerProducto[5].equals(numeroFactura) || !primerProducto[6].equals(fecha)) {
                JOptionPane.showMessageDialog(null, "La fecha y número de factura deben coincidir con los productos ya ingresados");
                return;
            }
        }
        
        // Buscar el producto en la base de datos
        Object[] producto = buscarProductoPorReferencia(referencia);
        if (producto == null) {
            JOptionPane.showMessageDialog(null, "Producto no encontrado");
            return;
        }
        
        // Calcular valor total
        int valorUnitario = (int) producto[3];
        int valorTotal = cantidad * valorUnitario;
        
        // Crear nueva fila para la tabla
        Object[] nuevaFila = new Object[9];
        nuevaFila[0] = contadorId++;
        nuevaFila[1] = producto[1]; // Referencia
        nuevaFila[2] = producto[2]; // Nombre
        nuevaFila[3] = cantidad;
        nuevaFila[4] = valorUnitario;
        nuevaFila[5] = valorTotal;
        nuevaFila[6] = Integer.parseInt(numeroFactura);
        nuevaFila[7] = fecha;
        nuevaFila[8] = producto[0];
        
        productosTemporales.add(nuevaFila);
    }
    
    public void eliminarProducto(int id) {
        for (int i = 0; i < productosTemporales.size(); i++) {
            if ((int) productosTemporales.get(i)[0] == id) {
                productosTemporales.remove(i);
                reordenarIds();
                return;
            }
        }
        JOptionPane.showMessageDialog(null, "No se encontró el producto con ID: " + id);
    }
    
    private void reordenarIds() {
        contadorId = 1;
        for (Object[] producto : productosTemporales) {
            producto[0] = contadorId++;
        }
    }
    
    public void limpiarTabla() {
        productosTemporales.clear();
        contadorId = 1;
    }
    
    public boolean registrarVenta() {
        if (productosTemporales.isEmpty()) {
            JOptionPane.showMessageDialog(null, "No hay productos para registrar");
            return false;
        }
        
        try {
            conexion.setAutoCommit(false);
            
            // Insertar en tabla Venta
            String sqlVenta = "INSERT INTO Venta (Fecha, Cantidad) VALUES (?, ?)";
            PreparedStatement pstmtVenta = conexion.prepareStatement(sqlVenta, PreparedStatement.RETURN_GENERATED_KEYS);
            
            // Insertar en tabla Salida
            String sqlSalida = "INSERT INTO Salida (IdSalida, IdVenta, IdProducto) VALUES (?, ?, ?)";
            PreparedStatement pstmtSalida = conexion.prepareStatement(sqlSalida);
            
            for (Object[] producto : productosTemporales) {
                // Insertar en Venta
                java.sql.Date fechaSql = java.sql.Date.valueOf((String) producto[7]);
                pstmtVenta.setDate(1, fechaSql); // Fecha
                pstmtVenta.setInt(2, (int) producto[3]); // Cantidad
                pstmtVenta.executeUpdate();
                
                // Obtener el ID de la venta generado
                ResultSet rs = pstmtVenta.getGeneratedKeys();
                int idVenta = 0;
                if (rs.next()) {
                    idVenta = rs.getInt(1);
                }
                
                // Insertar en Salida
                pstmtSalida.setInt(1, (int) producto[6]); // IdSalida (número de factura)
                pstmtSalida.setInt(2, idVenta);
                pstmtSalida.setInt(3, (int) producto[8]); // IdProducto
                pstmtSalida.executeUpdate();
            }
            
            conexion.commit();
            limpiarTabla();
            JOptionPane.showMessageDialog(null, "La venta se registró correctamente");
            return true;
            
        } catch (SQLException e) {
            try {
                conexion.rollback();
            } catch (SQLException ex) {
                JOptionPane.showMessageDialog(null, "Error al revertir la transacción: " + ex.getMessage());
            }
            JOptionPane.showMessageDialog(null, "Error al registrar la venta: " + e.getMessage());
            return false;
        } finally {
            try {
                conexion.setAutoCommit(true);
            } catch (SQLException e) {
                JOptionPane.showMessageDialog(null, "Error al restaurar auto-commit: " + e.getMessage());
            }
        }
    }
    
    public Object[][] getDatosTabla() {
        Object[][] datos = new Object[productosTemporales.size()][6];
        for (int i = 0; i < productosTemporales.size(); i++) {
            Object[] producto = productosTemporales.get(i);
            datos[i][0] = producto[0]; // ID
            datos[i][1] = producto[1]; // Referencia
            datos[i][2] = producto[2]; // Nombre
            datos[i][3] = producto[3]; // Cantidad
            datos[i][4] = producto[4]; // Valor Unitario
            datos[i][5] = producto[5]; // Valor Total
        }
        return datos;
    }
    
    public String[] getNombresColumnas() {
        return new String[]{"ID", "Referencia", "Nombre", "Cantidad", "Valor Unitario", "Valor Total"};
    }
}
