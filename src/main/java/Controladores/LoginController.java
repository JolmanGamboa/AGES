package Controladores;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
            // Convertir usuario a minúsculas
            usuario = usuario.toLowerCase();
            
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

    public boolean cambiarPassword(String usuario, String claveAntigua, String claveNueva) {
        if (claveAntigua.equals(claveNueva)) {
            JOptionPane.showMessageDialog(null, "La nueva contraseña no puede ser igual a la anterior");
            return false;
        }

        try {
            String sql = "{call spUsuariosSetPassword(?, ?, ?)}";
            CallableStatement cstmt = conexion.prepareCall(sql);
            
            cstmt.setString(1, usuario);
            cstmt.setString(2, claveAntigua);
            cstmt.setString(3, claveNueva);
            
            ResultSet rs = cstmt.executeQuery();
            
            if (rs.next()) {
                int resultado = rs.getInt("Resultado");
                if (resultado == 1) {
                    JOptionPane.showMessageDialog(null, "El cambio de contraseña ha sido correcto");
                    return true;
                }
            }
            
            JOptionPane.showMessageDialog(null, "Los datos no coinciden. Verifique su usuario y contraseña actual");
            return false;
            
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error al cambiar la contraseña: " + e.getMessage());
            return false;
        }
    }

    public boolean validarAdmin(String usuario, String contraseña) {
        try {
            // Convertir usuario a minúsculas
            usuario = usuario.toLowerCase();
            
            // Primero validar las credenciales
            String sqlValidar = "{CALL spValidarContraseña(?, ?, ?)}";
            CallableStatement cstmt = conexion.prepareCall(sqlValidar);
            
            cstmt.setString(1, usuario);
            cstmt.setString(2, contraseña);
            cstmt.registerOutParameter(3, java.sql.Types.INTEGER);
            
            cstmt.execute();
            
            int resultado = cstmt.getInt(3);
            
            if (resultado != 1) {
                JOptionPane.showMessageDialog(null, "Las credenciales no son correctas");
                return false;
            }
            
            // Si las credenciales son correctas, verificar el cargo
            String sqlCargo = "SELECT cargo FROM usuario WHERE usuario = ? AND cargo = 'admin'";
            PreparedStatement pstmt = conexion.prepareStatement(sqlCargo);
            pstmt.setString(1, usuario);
            
            ResultSet rs = pstmt.executeQuery();
            
            if (!rs.next()) {
                JOptionPane.showMessageDialog(null, "No está autorizado para realizar esta acción");
                return false;
            }
            
            return true;
            
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error al validar administrador: " + e.getMessage());
            return false;
        }
    }

    public boolean registrarUsuario(String usuario, String contraseña, String cargo) {
        try {
            // Convertir usuario a minúsculas
            usuario = usuario.toLowerCase();
            
            // Llamar al procedimiento almacenado
            String sql = "{call spUsuariosInsert(?, ?, ?)}";
            CallableStatement cstmt = conexion.prepareCall(sql);
            
            cstmt.setString(1, usuario);
            cstmt.setString(2, contraseña);
            cstmt.setString(3, cargo);
            
            int filasAfectadas = cstmt.executeUpdate();
            
            if (filasAfectadas > 0) {
                JOptionPane.showMessageDialog(null, "Usuario registrado exitosamente");
                return true;
            } else {
                JOptionPane.showMessageDialog(null, "Error al registrar el usuario");
                return false;
            }
            
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error al registrar el usuario: " + e.getMessage());
            return false;
        }
    }
}
