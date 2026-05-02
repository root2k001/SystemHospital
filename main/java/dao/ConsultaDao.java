package dao;

import configuraciones.SqlServerConexion;
import models.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ConsultaDao {

    // ================================================================
    // Registrar una nueva cita en la tabla Consultas
    // Retorna el ID generado, o -1 si falla.
    // ================================================================
    public static int registrarCita(Consulta consulta) throws SQLException {

        String sql = "INSERT INTO Consultas "
                   + "(paciente_id, doctor_id, fecha, hora, motivo, codigo_reserva, "
                   + " metodo_pago, estado, tipo_reserva) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?); "
                   + "SELECT SCOPE_IDENTITY();";

        try (Connection con = SqlServerConexion.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1,    consulta.getPacienteId());
            ps.setInt(2,    consulta.getDoctorId());
            ps.setString(3, consulta.getFecha());
            ps.setString(4, consulta.getHora());
            ps.setString(5, consulta.getMotivo());
            ps.setString(6, consulta.getCodigoReserva());
            ps.setString(7, consulta.getMetodoPago());
            ps.setString(8, consulta.getEstado());
            ps.setString(9, consulta.getTipoReserva());

            // Ejecutar y obtener ID generado
            boolean hasResults = ps.execute();
            if (hasResults) {
                try (ResultSet rs = ps.getResultSet()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
            // fallback: next result set
            if (ps.getMoreResults()) {
                try (ResultSet rs = ps.getResultSet()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    // ================================================================
    // Buscar o crear Paciente para el Titular
    // Si el usuario ya tiene un registro en Pacientes, retorna su ID.
    // Si no, crea uno y retorna el nuevo ID.
    // ================================================================
    public static int obtenerOCrearPacienteTitular(Usuario usuario) throws SQLException {

        // 1. Buscar si ya tiene registro en Pacientes
        String sqlBuscar = "SELECT TOP 1 ID FROM Pacientes WHERE usuario_id = ? AND Parentesco = 'Titular'";
        try (Connection con = SqlServerConexion.conectar();
             PreparedStatement ps = con.prepareStatement(sqlBuscar)) {

            ps.setInt(1, usuario.getId());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    System.out.println(">>> Titular ya existe como Paciente ID: " + rs.getInt(1));
                    return rs.getInt(1);
                }
            }
        }

        // 2. No existe, crearlo como Paciente usando datos del Usuario
        String sqlInsertar = "INSERT INTO Pacientes "
                           + "(Parentesco, DNI, Genero, ApellidoPat, ApellidoMat, Nombre, "
                           + " FechaNacimiento, Correo, Telefono, Direccion, Motivo_consulta, usuario_id) "
                           + "VALUES ('Titular', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?); "
                           + "SELECT SCOPE_IDENTITY();";

        try (Connection con = SqlServerConexion.conectar();
             PreparedStatement ps = con.prepareStatement(sqlInsertar)) {

            ps.setString(1, usuario.getDni()      != null ? usuario.getDni()      : "");
            ps.setString(2, usuario.getSexo()     != null ? usuario.getSexo()     : "");
            ps.setString(3, usuario.getApellido() != null ? usuario.getApellido() : "");
            ps.setString(4, "");  // ApellidoMat no está en Usuario
            ps.setString(5, usuario.getNombre()   != null ? usuario.getNombre()   : "");
            ps.setString(6, usuario.getFechNac()  != null ? usuario.getFechNac()  : "");
            ps.setString(7, usuario.getCorreo()   != null ? usuario.getCorreo()   : "");
            ps.setString(8, "");  // Telefono no está en Usuario
            ps.setString(9, "");  // Dirección
            ps.setString(10, "Consulta Médica");
            ps.setInt(11, usuario.getId());

            boolean hasResults = ps.execute();
            if (hasResults) {
                try (ResultSet rs = ps.getResultSet()) {
                    if (rs.next()) {
                        int newId = rs.getInt(1);
                        System.out.println(">>> Titular creado como Paciente ID: " + newId);
                        return newId;
                    }
                }
            }
            if (ps.getMoreResults()) {
                try (ResultSet rs = ps.getResultSet()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    // ================================================================
    // Listar todas las consultas de un usuario (por sus pacientes)
    // ================================================================
    public static java.util.List<java.util.Map<String, Object>> listarPorUsuario(int usuarioId)
            throws java.sql.SQLException {

        String sql = "SELECT c.ID, c.codigo_reserva, c.fecha, c.hora, c.motivo, "
                   + "c.estado, c.metodo_pago, c.tipo_reserva, "
                   + "d.nombre AS doctor_nombre, d.especialidad, "
                   + "p.Nombre AS pac_nombre, p.ApellidoPat AS pac_apellido, "
                   + "p.Parentesco "
                   + "FROM Consultas c "
                   + "LEFT JOIN Doctores d ON c.doctor_id = d.ID "
                   + "LEFT JOIN Pacientes p ON c.paciente_id = p.ID "
                   + "WHERE p.usuario_id = ? "
                   + "ORDER BY c.fecha DESC, c.hora DESC";

        java.util.List<java.util.Map<String, Object>> lista = new java.util.ArrayList<>();

        try (java.sql.Connection con = configuraciones.SqlServerConexion.conectar();
             java.sql.PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, usuarioId);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    java.util.Map<String, Object> row = new java.util.LinkedHashMap<>();
                    row.put("id",            rs.getInt("ID"));
                    row.put("codigo",        rs.getString("codigo_reserva"));
                    row.put("fecha",         rs.getString("fecha"));
                    row.put("hora",          rs.getString("hora"));
                    row.put("motivo",        rs.getString("motivo"));
                    row.put("estado",        rs.getString("estado"));
                    row.put("metodoPago",    rs.getString("metodo_pago"));
                    row.put("tipoReserva",   rs.getString("tipo_reserva"));
                    row.put("doctorNombre",  rs.getString("doctor_nombre"));
                    row.put("especialidad",  rs.getString("especialidad"));
                    row.put("pacNombre",     rs.getString("pac_nombre"));
                    row.put("pacApellido",   rs.getString("pac_apellido"));
                    row.put("parentesco",    rs.getString("Parentesco"));
                    lista.add(row);
                }
            }
        }
        return lista;
    }

    // ================================================================
    // Cancelar una cita
    // ================================================================
    public static boolean cancelarCita(String codigo) throws java.sql.SQLException {
        String sql = "UPDATE Consultas SET estado = 'Cancelada' WHERE codigo_reserva = ?";
        try (java.sql.Connection con = configuraciones.SqlServerConexion.conectar();
             java.sql.PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, codigo);
            return ps.executeUpdate() > 0;
        }
    }
}
