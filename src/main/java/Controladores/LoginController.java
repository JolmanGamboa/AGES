package Controladores;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import Conexion.conexionBd;
import javax.swing.JOptionPane;

/**
 *
 * @author jolma
 */
public class LoginController {
    private Connection conexion;
    
    public LoginController() {
        conexion = conexionBd.ConectarBD();
    }
    
    public boolean validarCredenciales(String usuario, String contraseña) {
        try {
            // Preparar la llamada al procedimiento almacenado
            String sql = "{CALL spValidarContraseña(?, ?, ?)}";
            CallableStatement cstmt = conexion.prepareCall(sql);
            
            // Establecer los parámetros de entrada
            cstmt.setString(1, usuario);
            cstmt.setString(2, contraseña);
            
            // Registrar el parámetro de salida
            cstmt.registerOutParameter(3, java.sql.Types.INTEGER);
            
            // Ejecutar el procedimiento
            cstmt.execute();
            
            // Obtener el resultado
            int resultado = cstmt.getInt(3);
            
            // Cerrar el statement
            cstmt.close();
            
            // Retornar true si el resultado es 1, false si es 0
            return resultado == 1;
            
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error al validar las credenciales: " + e.getMessage(), 
                    "Error", JOptionPane.ERROR_MESSAGE);
            return false;
        }
    }
}
