package Controladores;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import Conexion.conexionBd;
import javax.swing.JOptionPane;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author jolma
 */
public class ProductoController {
    private Connection conexion;
    
    public ProductoController() {
        conexion = conexionBd.ConectarBD();
    }

    public Object[][] getDatosProductos() {
        List<Object[]> filas = new ArrayList<>();
        String sql = "SELECT IdProducto, Referencia, Nombre, Cantidad, Alerta, ValorUnitario, eliminado FROM Productos ORDER BY IdProducto";
        
        try (PreparedStatement pstmt = conexion.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                Object[] fila = new Object[7];
                fila[0] = rs.getInt("IdProducto");
                fila[1] = rs.getString("Referencia");
                fila[2] = rs.getString("Nombre");
                fila[3] = rs.getInt("Cantidad");
                fila[4] = rs.getInt("Alerta");
                fila[5] = rs.getInt("ValorUnitario");
                fila[6] = rs.getBoolean("eliminado");
                filas.add(fila);
            }
            
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error al listar los productos: " + e.getMessage(), 
                    "Error", JOptionPane.ERROR_MESSAGE);
        }
        
        return filas.toArray(new Object[0][]);
    }
    
    public String[] getNombresColumnas() {
        return new String[]{"ID", "Referencia", "Nombre", "Cantidad", "Alerta", "Valor Unitario", "Eliminado"};
    }
    
    public boolean insertarProducto(String referencia, String nombre, int cantidad, int alerta, int valorUnitario) {
        String sql = "INSERT INTO Productos (Referencia, Nombre, Cantidad, Alerta, ValorUnitario) VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement pstmt = conexion.prepareStatement(sql)) {
            pstmt.setString(1, referencia);
            pstmt.setString(2, nombre);
            pstmt.setInt(3, cantidad);
            pstmt.setInt(4, alerta);
            pstmt.setInt(5, valorUnitario);
            
            int filasAfectadas = pstmt.executeUpdate();
            return filasAfectadas > 0;
            
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error al insertar el producto: " + e.getMessage(), 
                    "Error", JOptionPane.ERROR_MESSAGE);
            return false;
        }
    }
    
    public void validarYGuardarProducto(String codigo, String nombre, String cantidadStr, 
            String valorUStr, String alertaStr) {
        try {
            // Validar que los campos no estén vacíos
            if (codigo.isEmpty() || nombre.isEmpty() || cantidadStr.isEmpty() || 
                valorUStr.isEmpty() || alertaStr.isEmpty()) {
                JOptionPane.showMessageDialog(null, "Todos los campos son obligatorios", 
                        "Error", JOptionPane.ERROR_MESSAGE);
                return;
            }
            
            // Convertir y validar valores numéricos
            int cantidad = Integer.parseInt(cantidadStr);
            int valorUnitario = Integer.parseInt(valorUStr);
            int alerta = Integer.parseInt(alertaStr);
            
            // Validar que la cantidad no sea negativa
            if (cantidad < 0) {
                JOptionPane.showMessageDialog(null, "La cantidad no puede ser negativa", 
                        "Error", JOptionPane.ERROR_MESSAGE);
                return;
            }
            
            // Intentar insertar el producto
            if (insertarProducto(codigo, nombre, cantidad, alerta, valorUnitario)) {
                JOptionPane.showMessageDialog(null, "Producto guardado exitosamente", 
                        "Éxito", JOptionPane.INFORMATION_MESSAGE);
            }
            
        } catch (NumberFormatException e) {
            JOptionPane.showMessageDialog(null, "Los campos de cantidad, valor unitario y alerta deben ser números", 
                    "Error", JOptionPane.ERROR_MESSAGE);
        }
    }
    
    public boolean eliminarProducto(int id) {
        try {
            // Obtener el estado actual del producto
            String sqlEstado = "SELECT eliminado FROM productos WHERE IdProducto = ?";
            PreparedStatement pstEstado = conexion.prepareStatement(sqlEstado);
            pstEstado.setInt(1, id);
            ResultSet rs = pstEstado.executeQuery();
            
            if (rs.next()) {
                boolean estadoActual = rs.getBoolean("eliminado");
                boolean nuevoEstado = !estadoActual;
                
                // Actualizar el estado
                String sql = "UPDATE productos SET eliminado = ? WHERE IdProducto = ?";
                PreparedStatement pst = conexion.prepareStatement(sql);
                pst.setBoolean(1, nuevoEstado);
                pst.setInt(2, id);
                
                int filasAfectadas = pst.executeUpdate();
                
                if (filasAfectadas > 0) {
                    if (nuevoEstado) {
                        JOptionPane.showMessageDialog(null, "El producto se eliminó correctamente");
                    } else {
                        JOptionPane.showMessageDialog(null, "El producto se restauró correctamente");
                    }
                    return true;
                }
            } else {
                JOptionPane.showMessageDialog(null, "No se encontró el producto con ID: " + id);
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error al actualizar el estado del producto: " + e.getMessage());
        }
        return false;
    }
    
    public Object[] buscarProducto(int idProducto) {
        String sql = "SELECT Referencia, Nombre, Cantidad, Alerta, ValorUnitario FROM Productos WHERE IdProducto = ?";
        
        try (PreparedStatement pstmt = conexion.prepareStatement(sql)) {
            pstmt.setInt(1, idProducto);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Object[] producto = new Object[5];
                    producto[0] = rs.getString("Referencia");
                    producto[1] = rs.getString("Nombre");
                    producto[2] = rs.getInt("Cantidad");
                    producto[3] = rs.getInt("Alerta");
                    producto[4] = rs.getInt("ValorUnitario");
                    return producto;
                }
            }
            
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error al buscar el producto: " + e.getMessage(), 
                    "Error", JOptionPane.ERROR_MESSAGE);
        }
        
        return null;
    }
    
    public boolean actualizarProducto(int idProducto, String referencia, String nombre, int cantidad, int alerta, int valorUnitario) {
        String sql = "UPDATE Productos SET Referencia = ?, Nombre = ?, Cantidad = ?, Alerta = ?, ValorUnitario = ? WHERE IdProducto = ?";
        
        try (PreparedStatement pstmt = conexion.prepareStatement(sql)) {
            pstmt.setString(1, referencia);
            pstmt.setString(2, nombre);
            pstmt.setInt(3, cantidad);
            pstmt.setInt(4, alerta);
            pstmt.setInt(5, valorUnitario);
            pstmt.setInt(6, idProducto);
            
            int filasAfectadas = pstmt.executeUpdate();
            if (filasAfectadas > 0) {
                JOptionPane.showMessageDialog(null, "Producto actualizado exitosamente", 
                        "Éxito", JOptionPane.INFORMATION_MESSAGE);
                return true;
            } else {
                JOptionPane.showMessageDialog(null, "No se encontró el producto con el ID especificado", 
                        "Error", JOptionPane.ERROR_MESSAGE);
                return false;
            }
            
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error al actualizar el producto: " + e.getMessage(), 
                    "Error", JOptionPane.ERROR_MESSAGE);
            return false;
        }
        }
}
