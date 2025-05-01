package Controladores;

import Conexion.conexionBd;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.swing.JOptionPane;

/**
 *
 * @author jolma
 */
public class CompraController {
    private Connection conexion;
    private List<Object[]> productosTemporales;
    
    public CompraController() {
        try {
            conexion = conexionBd.ConectarBD();
            productosTemporales = new ArrayList<>();
        } catch (Exception e) {
            JOptionPane.showMessageDialog(null, "Error al conectar con la base de datos: " + e.getMessage());
        }
    }
    
    public boolean validarNumeroFactura(String numeroFactura) {
        try {
            int numero = Integer.parseInt(numeroFactura);
            return numero > 0;
        } catch (NumberFormatException e) {
            return false;
        }
    }
    
    public Object[] buscarProductoPorReferencia(String referencia) {
        try {
            String sql = "SELECT IdProducto, Referencia, Nombre, Cantidad, ValorUnitario FROM Productos WHERE Referencia = ?";
            PreparedStatement ps = conexion.prepareStatement(sql);
            ps.setString(1, referencia);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return new Object[]{
                    rs.getInt("IdProducto"),
                    rs.getString("Referencia"),
                    rs.getString("Nombre"),
                    rs.getInt("Cantidad"),
                    rs.getInt("ValorUnitario")
                };
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error al buscar producto: " + e.getMessage());
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
    
    public void agregarProductoATabla(String numeroFactura, String fecha, String referencia, int cantidad, int valorUnitario) {
        Object[] producto = buscarProductoPorReferencia(referencia);
        if (producto != null) {            
            if (!validarProductoExistente(referencia)) {
                int valorTotal = cantidad * valorUnitario;
                
                Object[] nuevaFila = new Object[9];
                nuevaFila[0] = productosTemporales.size() + 1;
                nuevaFila[1] = Integer.parseInt(numeroFactura);
                nuevaFila[2] = fecha;
                nuevaFila[3] = producto[1]; // Referencia
                nuevaFila[4] = producto[2]; // Nombre
                nuevaFila[5] = cantidad;
                nuevaFila[6] = valorUnitario;
                nuevaFila[7] = valorTotal; // IdProducto
                nuevaFila[8] = producto[0];
                productosTemporales.add(nuevaFila);
            } else {
                JOptionPane.showMessageDialog(null, "El producto ya está en la tabla");
            }
        } else {
            JOptionPane.showMessageDialog(null, "Producto no encontrado");
        }
    }
    
    public void eliminarProducto(int id) {
        if (id > 0 && id <= productosTemporales.size()) {
            productosTemporales.remove(id - 1);
            // Reindexar los IDs
            for (int i = 0; i < productosTemporales.size(); i++) {
                productosTemporales.get(i)[0] = i + 1;
            }
        } else {
            JOptionPane.showMessageDialog(null, "ID inválido");
        }
    }
    
    public void limpiarTabla() {
        productosTemporales.clear();
    }
    
    public boolean registrarCompra() {
        if (productosTemporales.isEmpty()) {
            JOptionPane.showMessageDialog(null, "No hay productos para registrar");
            return false;
        }
        
        try {
            conexion.setAutoCommit(false);
            
            for (Object[] producto : productosTemporales) {
                // Insertar en tabla Compra
                String sqlCompra = "INSERT INTO Compra (Cantidad, ValorUnitario, Fecha) VALUES (?, ?, ?)";
                PreparedStatement psCompra = conexion.prepareStatement(sqlCompra, PreparedStatement.RETURN_GENERATED_KEYS);
                psCompra.setInt(1, (int)producto[5]); // Cantidad
                psCompra.setInt(2, (int)producto[6]); // ValorUnitario
                psCompra.setString(3, (String)producto[2]); // Fecha
                psCompra.executeUpdate();
                
                ResultSet rs = psCompra.getGeneratedKeys();
                if (rs.next()) {
                    int idCompra = rs.getInt(1);
                    
                    // Insertar en tabla Ingreso
                    String sqlIngreso = "INSERT INTO Ingreso (idIngreso, IdProducto, IdCompra) VALUES (?, ?, ?)";
                    PreparedStatement psIngreso = conexion.prepareStatement(sqlIngreso);
                    psIngreso.setInt(1, (int)producto[1]);
                    psIngreso.setInt(2, (int)producto[8]); // IdProducto
                    psIngreso.setInt(3, idCompra);
                    psIngreso.executeUpdate();
                }
            }
            
            conexion.commit();
            JOptionPane.showMessageDialog(null, "Compra registrada exitosamente");
            limpiarTabla();
            return true;
            
        } catch (SQLException e) {
            try {
                conexion.rollback();
            } catch (SQLException ex) {
                JOptionPane.showMessageDialog(null, "Error al revertir la transacción: " + ex.getMessage());
            }
            JOptionPane.showMessageDialog(null, "Error al registrar la compra: " + e.getMessage());
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
        return productosTemporales.toArray(new Object[0][]);
    }
    
    public String[] getNombresColumnas() {
        return new String[]{"ID", "N° Factura", "Fecha", "Referencia", "Nombre", "Cantidad", "Valor Unitario", "Valor Total"};
    }
}
