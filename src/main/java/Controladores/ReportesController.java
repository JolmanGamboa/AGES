package Controladores;

import java.io.FileWriter;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import Conexion.conexionBd;

public class ReportesController {
    private Connection conexion;
    private SimpleDateFormat dateFormat;

    public ReportesController() {
        conexion = conexionBd.ConectarBD();
        dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    }

    public void generarReporteCompras(Date fechaInicio, Date fechaFin, String rutaArchivo) throws SQLException, IOException {
        String query = "SELECT i.IdIngreso AS NumeroFactura, c.Fecha, p.Referencia, p.Nombre, " +
                      "c.Cantidad, c.ValorUnitario, (c.Cantidad * c.ValorUnitario) AS ValorTotal " +
                      "FROM Ingreso i " +
                      "INNER JOIN Compra c ON i.IdCompra = c.IdCompra " +
                      "INNER JOIN Productos p ON i.IdProducto = p.IdProducto " +
                      "WHERE c.Fecha BETWEEN ? AND ? " +
                      "ORDER BY i.IdIngreso";

        try (PreparedStatement ps = conexion.prepareStatement(query)) {
            ps.setString(1, dateFormat.format(fechaInicio));
            ps.setString(2, dateFormat.format(fechaFin));
            
            try (ResultSet rs = ps.executeQuery();
                 FileWriter writer = new FileWriter(rutaArchivo)) {
                
                // Escribir encabezados
                writer.append("NumeroFactura,Fecha,Referencia,Nombre,Cantidad,ValorUnitario,ValorTotal\n");
                
                // Escribir datos
                while (rs.next()) {
                    writer.append(rs.getString("NumeroFactura")).append(",")
                          .append(rs.getString("Fecha")).append(",")
                          .append(rs.getString("Referencia")).append(",")
                          .append(rs.getString("Nombre")).append(",")
                          .append(rs.getString("Cantidad")).append(",")
                          .append(rs.getString("ValorUnitario")).append(",")
                          .append(rs.getString("ValorTotal")).append("\n");
                }
            }
        }
    }

    public void generarReporteVentas(Date fechaInicio, Date fechaFin, String rutaArchivo) throws SQLException, IOException {
        String query = "SELECT s.IdSalida AS NumeroFactura, v.Fecha, p.Referencia, p.Nombre, " +
                      "v.Cantidad, p.ValorUnitario, (v.Cantidad * p.ValorUnitario) AS ValorTotal " +
                      "FROM Salida s " +
                      "INNER JOIN Venta v ON s.IdVenta = v.IdVenta " +
                      "INNER JOIN Productos p ON s.IdProducto = p.IdProducto " +
                      "WHERE v.Fecha BETWEEN ? AND ? " +
                      "ORDER BY s.IdSalida";

        try (PreparedStatement ps = conexion.prepareStatement(query)) {
            ps.setString(1, dateFormat.format(fechaInicio));
            ps.setString(2, dateFormat.format(fechaFin));
            
            try (ResultSet rs = ps.executeQuery();
                 FileWriter writer = new FileWriter(rutaArchivo)) {
                
                // Escribir encabezados
                writer.append("NumeroFactura,Fecha,Referencia,Nombre,Cantidad,ValorUnitario,ValorTotal\n");
                
                // Escribir datos
                while (rs.next()) {
                    writer.append(rs.getString("NumeroFactura")).append(",")
                          .append(rs.getString("Fecha")).append(",")
                          .append(rs.getString("Referencia")).append(",")
                          .append(rs.getString("Nombre")).append(",")
                          .append(rs.getString("Cantidad")).append(",")
                          .append(rs.getString("ValorUnitario")).append(",")
                          .append(rs.getString("ValorTotal")).append("\n");
                }
            }
        }
    }

    public void generarReporteProductos(String rutaArchivo) throws SQLException, IOException {
        String query = "SELECT IdProducto, Referencia, Nombre, Cantidad, ValorUnitario " +
                      "FROM productos WHERE eliminado='false'";

        try (PreparedStatement ps = conexion.prepareStatement(query);
             ResultSet rs = ps.executeQuery();
             FileWriter writer = new FileWriter(rutaArchivo)) {
            
            // Escribir encabezados
            writer.append("IdProducto,Referencia,Nombre,Cantidad,ValorUnitario\n");
            
            // Escribir datos
            while (rs.next()) {
                writer.append(rs.getString("IdProducto")).append(",")
                      .append(rs.getString("Referencia")).append(",")
                      .append(rs.getString("Nombre")).append(",")
                      .append(rs.getString("Cantidad")).append(",")
                      .append(rs.getString("ValorUnitario")).append("\n");
            }
        }
    }
} 