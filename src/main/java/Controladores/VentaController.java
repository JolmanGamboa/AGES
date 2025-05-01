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
import javax.swing.JOptionPane;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;
import tesis.ages.Ventanas.frmVenta;
import Conexion.conexionBd;

/**
 *
 * @author jolma
 */
public class VentaController {
    private frmVenta vista;
    private Connection conexion;
    private List<Object[]> productosTemporales;
    private int numeroFactura;
    private String fecha;

    public VentaController(frmVenta vista) {
        this.vista = vista;
        this.conexion = conexionBd.getConnection();
        this.productosTemporales = new ArrayList<>();
        inicializarEventos();
    }

    private void inicializarEventos() {
        vista.getBtnAgregarProducto().addActionListener(e -> agregarProducto());
        vista.getBtnEliminarProducto().addActionListener(e -> eliminarProducto());
        vista.getBtnCancelarVenta().addActionListener(e -> cancelarVenta());
        vista.getBtnRegistrarVenta().addActionListener(e -> registrarVenta());
    }

    private void agregarProducto() {
        try {
            String referencia = vista.getTxtReferencia().getText();
            int cantidad = Integer.parseInt(vista.getTxtCantidad().getText());
            int factura = Integer.parseInt(vista.getTxtNumeroFactura().getText());
            String fechaVenta = vista.getDateChooser().getDate().toString();

            if (cantidad <= 0) {
                JOptionPane.showMessageDialog(vista, "La cantidad debe ser un número positivo");
                return;
            }

            if (productosTemporales.isEmpty()) {
                this.numeroFactura = factura;
                this.fecha = fechaVenta;
            } else if (factura != numeroFactura || !fechaVenta.equals(fecha)) {
                JOptionPane.showMessageDialog(vista, "La factura y fecha deben coincidir con los productos ya agregados");
                return;
            }

            // Verificar si la referencia ya existe
            for (Object[] producto : productosTemporales) {
                if (producto[1].equals(referencia)) {
                    JOptionPane.showMessageDialog(vista, "Este producto ya fue agregado");
                    return;
                }
            }

            // Obtener información del producto
            String sql = "SELECT p.Referencia, p.Nombre, p.ValorUnitario FROM Producto p WHERE p.Referencia = ?";
            PreparedStatement pst = conexion.prepareStatement(sql);
            pst.setString(1, referencia);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                String nombre = rs.getString("Nombre");
                double valorUnitario = rs.getDouble("ValorUnitario");
                double valorTotal = cantidad * valorUnitario;

                Object[] nuevoProducto = {
                    productosTemporales.size() + 1,
                    referencia,
                    nombre,
                    cantidad,
                    valorUnitario,
                    valorTotal
                };

                productosTemporales.add(nuevoProducto);
                actualizarTabla();
            } else {
                JOptionPane.showMessageDialog(vista, "Producto no encontrado");
            }

        } catch (NumberFormatException e) {
            JOptionPane.showMessageDialog(vista, "Ingrese valores numéricos válidos");
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(vista, "Error al consultar la base de datos");
        }
    }

    private void eliminarProducto() {
        String idStr = JOptionPane.showInputDialog(vista, "Ingrese el ID del producto a eliminar:");
        if (idStr == null || idStr.isEmpty()) return;

        try {
            int id = Integer.parseInt(idStr);
            boolean encontrado = false;

            for (int i = 0; i < productosTemporales.size(); i++) {
                if ((int) productosTemporales.get(i)[0] == id) {
                    productosTemporales.remove(i);
                    encontrado = true;
                    break;
                }
            }

            if (encontrado) {
                // Reordenar IDs
                for (int i = 0; i < productosTemporales.size(); i++) {
                    productosTemporales.get(i)[0] = i + 1;
                }
                actualizarTabla();
            } else {
                JOptionPane.showMessageDialog(vista, "ID no encontrado");
            }
        } catch (NumberFormatException e) {
            JOptionPane.showMessageDialog(vista, "Ingrese un ID válido");
        }
    }

    private void cancelarVenta() {
        productosTemporales.clear();
        actualizarTabla();
        vista.getTxtNumeroFactura().setText("");
        vista.getTxtReferencia().setText("");
        vista.getTxtCantidad().setText("");
    }

    private void registrarVenta() {
        if (productosTemporales.isEmpty()) {
            JOptionPane.showMessageDialog(vista, "No hay productos para registrar");
            return;
        }

        try {
            conexion.setAutoCommit(false);

            for (Object[] producto : productosTemporales) {
                // Insertar en tabla Venta
                String sqlVenta = "INSERT INTO Venta (Cantidad, Fecha) VALUES (?, ?)";
                PreparedStatement pstVenta = conexion.prepareStatement(sqlVenta, PreparedStatement.RETURN_GENERATED_KEYS);
                pstVenta.setInt(1, (int) producto[3]);
                pstVenta.setString(2, fecha);
                pstVenta.executeUpdate();

                ResultSet rs = pstVenta.getGeneratedKeys();
                int idVenta = 0;
                if (rs.next()) {
                    idVenta = rs.getInt(1);
                }

                // Insertar en tabla Salida
                String sqlSalida = "INSERT INTO Salida (IdSalida, IdProducto, IdVenta, IdIngreso) VALUES (?, ?, ?, ?)";
                PreparedStatement pstSalida = conexion.prepareStatement(sqlSalida);
                pstSalida.setInt(1, numeroFactura);
                pstSalida.setString(2, (String) producto[1]);
                pstSalida.setInt(3, idVenta);
                pstSalida.setInt(4, numeroFactura);
                pstSalida.executeUpdate();
            }

            conexion.commit();
            JOptionPane.showMessageDialog(vista, "La venta se registró correctamente");
            cancelarVenta();

        } catch (SQLException e) {
            try {
                conexion.rollback();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            JOptionPane.showMessageDialog(vista, "Error al registrar la venta");
        } finally {
            try {
                conexion.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private void actualizarTabla() {
        DefaultTableModel model = (DefaultTableModel) vista.getTblProductos().getModel();
        model.setRowCount(0);

        for (Object[] producto : productosTemporales) {
            model.addRow(producto);
        }
    }
}
