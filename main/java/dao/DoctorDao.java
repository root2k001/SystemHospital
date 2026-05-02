package dao;

import configuraciones.SqlServerConexion;
import models.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class DoctorDao {

    // ================================================================
    // Obtener especialidades únicas activas
    // ================================================================
    public static List<String> listarEspecialidades() throws SQLException {
        List<String> lista = new ArrayList<String>();
        String sql = "SELECT DISTINCT especialidad FROM Doctores WHERE activo = 1 ORDER BY especialidad";

        try (Connection con = SqlServerConexion.conectar();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                lista.add(rs.getString("especialidad"));
            }
        }
        return lista;
    }

    // ================================================================
    // Obtener doctores por especialidad
    // ================================================================
    public static List<Map<String, Object>> listarDoctoresPorEspecialidad(String especialidad)
            throws SQLException {

        List<Map<String, Object>> lista = new ArrayList<Map<String, Object>>();
        String sql = "SELECT ID, nombre, especialidad, bio, rating, precio, avatar_emoji, duracion_min "
                   + "FROM Doctores WHERE especialidad = ? AND activo = 1";

        try (Connection con = SqlServerConexion.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, especialidad);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> doc = new HashMap<String, Object>();
                    doc.put("id",           rs.getInt("ID"));
                    doc.put("nombre",       rs.getString("nombre"));
                    doc.put("especialidad", rs.getString("especialidad"));
                    doc.put("bio",          rs.getString("bio"));
                    doc.put("rating",       rs.getDouble("rating"));
                    doc.put("precio",       rs.getDouble("precio"));
                    doc.put("avatarEmoji",  rs.getString("avatar_emoji"));
                    doc.put("duracion",     rs.getInt("duracion_min"));
                    lista.add(doc);
                }
            }
        }
        return lista;
    }

    // ================================================================
    // Obtener horarios de un doctor agrupados por día de semana
    // Retorna: { "Lunes": ["08:00","08:30",...], "Martes": [...], ... }
    // ================================================================
    public static Map<String, List<String>> listarHorariosPorDoctor(int doctorId)
            throws SQLException {

        // LinkedHashMap mantiene el orden de inserción (días de la semana)
        Map<String, List<String>> horarios = new LinkedHashMap<String, List<String>>();
        String sql = "SELECT dia_semana, hora_inicio FROM Horarios "
                   + "WHERE doctor_id = ? AND activo = 1 "
                   + "ORDER BY dia_semana, hora_inicio";

        try (Connection con = SqlServerConexion.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, doctorId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String dia  = rs.getString("dia_semana");
                    String hora = rs.getString("hora_inicio");

                    if (!horarios.containsKey(dia)) {
                        horarios.put(dia, new ArrayList<String>());
                    }
                    horarios.get(dia).add(hora);
                }
            }
        }
        return horarios;
    }

    // ================================================================
    // Verificar si un slot ya está reservado en Consultas
    // ================================================================
    public static boolean estaOcupado(int doctorId, String fecha, String hora)
            throws SQLException {

        String sql = "SELECT COUNT(*) FROM Consultas "
                   + "WHERE doctor_id = ? AND fecha = ? AND hora = ? AND estado != 'Cancelada'";

        try (Connection con = SqlServerConexion.conectar();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, doctorId);
            ps.setString(2, fecha);
            ps.setString(3, hora);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        }
        return false;
    }
}
