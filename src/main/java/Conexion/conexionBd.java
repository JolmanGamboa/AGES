
package Conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class conexionBd {
    
    public static Connection ConectarBD(){
        Connection conexion;
        String host = "jdbc:mysql://localhost:3306/ages";
        String user = "root";
        String pass = "123456";

        System.out.println("Conectando a la base de datos...");

        try{
        conexion = DriverManager.getConnection(host, user, pass);
        System.out.println("Conexion exitosa");
        } catch (SQLException e){
            System.out.println("Error de conexion: " + e.getMessage());
            throw new RuntimeException(e);
        }
        return conexion;
        
        
    }
    
  //  public static void main(String[] args) {
  //      Connection con = ConectarBD();
  //  }

}
