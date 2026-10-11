package com.utp.reservas.dao;

import com.utp.reservas.dto.Usuario;
import com.utp.reservas.util.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object (DAO) para la entidad Usuario.
 */
public class UsuarioDAO {

    public Usuario validarUsuario(String identificador, String contrasena) {
        if (identificador == null || contrasena == null) {
            return null;
        }

        String sql = "SELECT u.id_usuario, u.codigo_universitario, u.nombre, u.apellidos, u.email, "
                + "       u.contrasena, u.id_rol, u.id_tipo_estudiante, "
                + "       r.nombre AS nombre_rol, "
                + "       te.nombre AS nombre_tipo_estudiante, "
                + "       te.nivel_prioridad, "
                + "       te.horas_max_dia, "
                + "       te.dias_anticipacion "
                + "FROM usuario u "
                + "INNER JOIN rol r ON u.id_rol = r.id_rol "
                + "LEFT JOIN tipo_estudiante te ON u.id_tipo_estudiante = te.id_tipo "
                + "WHERE (u.codigo_universitario = ? OR u.email = ?) AND u.contrasena = ?";

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            if (con == null) {
                System.err.println("Error: No se pudo obtener conexión con la base de datos.");
                return null;
            }

            String idLimpio = identificador.trim();
            ps.setString(1, idLimpio);
            ps.setString(2, idLimpio);
            ps.setString(3, contrasena);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearUsuario(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al validar usuario en UsuarioDAO: " + e.getMessage());
        }

        return null;
    }

    public Usuario obtenerPorId(int idUsuario) {
        String sql = "SELECT u.id_usuario, u.codigo_universitario, u.nombre, u.apellidos, u.email, "
                + "       u.contrasena, u.id_rol, u.id_tipo_estudiante, "
                + "       r.nombre AS nombre_rol, "
                + "       te.nombre AS nombre_tipo_estudiante, "
                + "       te.nivel_prioridad, "
                + "       te.horas_max_dia, "
                + "       te.dias_anticipacion "
                + "FROM usuario u "
                + "INNER JOIN rol r ON u.id_rol = r.id_rol "
                + "LEFT JOIN tipo_estudiante te ON u.id_tipo_estudiante = te.id_tipo "
                + "WHERE u.id_usuario = ?";

        try (Connection con = ConexionDB.getConexion();
                PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearUsuario(rs);
                }
            }

        } catch (SQLException e) {
            System.err.println("Error al obtener usuario por ID: " + e.getMessage());
        }

        return null;
    }

    private Usuario mapearUsuario(ResultSet rs) throws SQLException {
        Usuario u = new Usuario();
        u.setIdUsuario(rs.getInt("id_usuario"));
        u.setCodigoUniversitario(rs.getString("codigo_universitario"));
        u.setNombre(rs.getString("nombre"));
        u.setApellidos(rs.getString("apellidos"));
        u.setEmail(rs.getString("email"));
        u.setContrasena(rs.getString("contrasena"));
        u.setIdRol(rs.getInt("id_rol"));

        int idTipo = rs.getInt("id_tipo_estudiante");
        if (!rs.wasNull()) {
            u.setIdTipoEstudiante(idTipo);
        } else {
            u.setIdTipoEstudiante(null);
        }

        u.setNombreRol(rs.getString("nombre_rol"));
        u.setNombreTipoEstudiante(rs.getString("nombre_tipo_estudiante"));

        int nivel = rs.getInt("nivel_prioridad");
        if (!rs.wasNull()) {
            u.setNivelPrioridad(nivel);
        }

        int horasMax = rs.getInt("horas_max_dia");
        if (!rs.wasNull()) {
            u.setHorasMaxDia(horasMax);
        }

        int diasAnt = rs.getInt("dias_anticipacion");
        if (!rs.wasNull()) {
            u.setDiasAnticipacion(diasAnt);
        }

        return u;
    }

    public int contarTotalEstudiantes() {
        String sql = "SELECT COUNT(*) FROM usuario WHERE id_rol = 2";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error al contar total de estudiantes: " + e.getMessage());
        }
        return 0;
    }
}
