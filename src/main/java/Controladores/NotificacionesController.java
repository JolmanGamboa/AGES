package Controladores;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import Conexion.conexionBd;
import javax.swing.JOptionPane;

public class NotificacionesController {
    private Connection conexion;
    
    public NotificacionesController() {
        conexion = conexionBd.ConectarBD();
    }
    
    public List<String> obtenerNotificaciones() {
        List<String> notificaciones = new ArrayList<>();
        
        try {
            String sql = "SELECT nombre, Referencia, cantidad, alerta FROM Productos WHERE cantidad <= alerta order by cantidad asc";
            PreparedStatement pstmt = conexion.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                String nombre = rs.getString("nombre");
                String Referencia = rs.getString("Referencia");
                int cantidad = rs.getInt("cantidad");
                int alerta = rs.getInt("alerta");
                
                String mensaje = String.format("El producto \"%s\" con referencia \"%s\" se está agotando, actualmente quedan %d unidades", 
                                             nombre, Referencia, cantidad);
                notificaciones.add(mensaje);
            }
            
            rs.close();
            pstmt.close();
            
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error al obtener las notificaciones: " + e.getMessage(), 
                    "Error", JOptionPane.ERROR_MESSAGE);
        }
        
        return notificaciones;
    }
}