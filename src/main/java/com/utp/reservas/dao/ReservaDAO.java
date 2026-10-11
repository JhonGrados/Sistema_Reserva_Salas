package com.utp.reservas.dao;

import com.utp.reservas.dto.Reserva;
import com.utp.reservas.util.ConexionDB;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object (DAO) para la entidad Reserva
 */
public class ReservaDAO {

    public List<Reserva> listarPorUsuario(int idUsuario) {
        List<Reserva> lista = new ArrayList<>();
        String sql = "SELECT r.id_reserva, r.id_usuario, r.id_sala, r.fecha_reserva, r.hora_inicio, r.hora_fin, "
                + "       r.num_integrantes, r.motivo, r.estado, r.hora_check_in, r.fecha_creacion, "
                + "       s.codigo_sala, s.capacidad, s.es_silenciosa, s.ubicacion, s.recursos, "
                + "       CONCAT(u.nombre, ' ', u.apellidos) AS nombre_usuario "
                + "FROM reserva r "
                + "INNER JOIN sala s ON r.id_sala = s.id_sala "
                + "INNER JOIN usuario u ON r.id_usuario = u.id_usuario "
                + "WHERE r.id_usuario = ? "
                + "ORDER BY r.fecha_reserva DESC, r.hora_inicio DESC";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(mapearReserva(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al listar reservas por usuario en ReservaDAO: " + e.getMessage());
        }
        return lista;
    }

    public Reserva obtenerProximaReserva(int idUsuario) {
        String sql = "SELECT r.id_reserva, r.id_usuario, r.id_sala, r.fecha_reserva, r.hora_inicio, r.hora_fin, "
                + "       r.num_integrantes, r.motivo, r.estado, r.hora_check_in, r.fecha_creacion, "
                + "       s.codigo_sala, s.capacidad, s.es_silenciosa, s.ubicacion, s.recursos, "
                + "       CONCAT(u.nombre, ' ', u.apellidos) AS nombre_usuario "
                + "FROM reserva r "
                + "INNER JOIN sala s ON r.id_sala = s.id_sala "
                + "INNER JOIN usuario u ON r.id_usuario = u.id_usuario "
                + "WHERE r.id_usuario = ? "
                + "  AND r.estado IN ('RESERVADO', 'OCUPADO') "
                + "  AND (r.fecha_reserva > CURDATE() OR (r.fecha_reserva = CURDATE() AND r.hora_fin >= CURTIME())) "
                + "ORDER BY r.fecha_reserva ASC, r.hora_inicio ASC "
                + "LIMIT 1";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearReserva(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener próxima reserva en ReservaDAO: " + e.getMessage());
        }
        return null;
    }

    public int contarReservasActivas(int idUsuario) {
        String sql = "SELECT COUNT(*) FROM reserva "
                + "WHERE id_usuario = ? "
                + "  AND estado IN ('RESERVADO', 'OCUPADO') "
                + "  AND (fecha_reserva > CURDATE() OR (fecha_reserva = CURDATE() AND hora_fin >= CURTIME()))";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al contar reservas activas en ReservaDAO: " + e.getMessage());
        }
        return 0;
    }

    public int contarTotalReservas(int idUsuario) {
        String sql = "SELECT COUNT(*) FROM reserva WHERE id_usuario = ?";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al contar total de reservas en ReservaDAO: " + e.getMessage());
        }
        return 0;
    }

    public int obtenerHorasReservadasHoy(int idUsuario) {
        String sql = "SELECT IFNULL(SUM(TIMESTAMPDIFF(HOUR, hora_inicio, hora_fin)), 0) "
                + "FROM reserva "
                + "WHERE id_usuario = ? "
                + "  AND fecha_reserva = CURDATE() "
                + "  AND estado IN ('RESERVADO', 'OCUPADO', 'FINALIZADO')";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al calcular horas de hoy en ReservaDAO: " + e.getMessage());
        }
        return 0;
    }

    public boolean cancelarReserva(int idReserva, int idUsuario) {
        String sql = "UPDATE reserva SET estado = 'CANCELADO' "
                + "WHERE id_reserva = ? AND id_usuario = ? AND estado = 'RESERVADO'";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idReserva);
            ps.setInt(2, idUsuario);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al cancelar reserva en ReservaDAO: " + e.getMessage());
            return false;
        }
    }

    public int contarReservasHoy() {
        String sql = "SELECT COUNT(*) FROM reserva WHERE fecha_reserva = CURDATE()";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error al contar reservas de hoy: " + e.getMessage());
        }
        return 0;
    }

    public int contarReservasActivasGlobal() {
        String sql = "SELECT COUNT(*) FROM reserva WHERE estado IN ('RESERVADO', 'OCUPADO') AND fecha_reserva >= CURDATE()";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error al contar reservas activas globales: " + e.getMessage());
        }
        return 0;
    }

    public boolean registrarReserva(Reserva r) {
        String sql = "INSERT INTO reserva (id_usuario, id_sala, fecha_reserva, hora_inicio, hora_fin, num_integrantes, motivo, estado) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, 'RESERVADO')";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, r.getIdUsuario());
            ps.setInt(2, r.getIdSala());
            ps.setDate(3, r.getFechaReserva());
            ps.setTime(4, r.getHoraInicio());
            ps.setTime(5, r.getHoraFin());
            ps.setInt(6, r.getNumIntegrantes());
            ps.setString(7, r.getMotivo());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al registrar reserva en ReservaDAO: " + e.getMessage());
            return false;
        }
    }

    public boolean existeSolapamiento(int idSala, Date fecha, Time horaInicio, Time horaFin) {
        String sql = "SELECT COUNT(*) FROM reserva "
                + "WHERE id_sala = ? AND fecha_reserva = ? "
                + "  AND estado IN ('RESERVADO', 'OCUPADO') "
                + "  AND NOT (hora_fin <= ? OR hora_inicio >= ?)";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idSala);
            ps.setDate(2, fecha);
            ps.setTime(3, horaInicio);
            ps.setTime(4, horaFin);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al verificar solapamiento en ReservaDAO: " + e.getMessage());
        }
        return false;
    }

    public int obtenerHorasReservadasPorFecha(int idUsuario, Date fecha) {
        String sql = "SELECT IFNULL(SUM(TIMESTAMPDIFF(HOUR, hora_inicio, hora_fin)), 0) "
                + "FROM reserva "
                + "WHERE id_usuario = ? AND fecha_reserva = ? "
                + "  AND estado IN ('RESERVADO', 'OCUPADO', 'FINALIZADO')";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idUsuario);
            ps.setDate(2, fecha);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al calcular horas reservadas por fecha en ReservaDAO: " + e.getMessage());
        }
        return 0;
    }

    private Reserva mapearReserva(ResultSet rs) throws SQLException {
        Reserva r = new Reserva();
        r.setIdReserva(rs.getInt("id_reserva"));
        r.setIdUsuario(rs.getInt("id_usuario"));
        r.setIdSala(rs.getInt("id_sala"));
        r.setFechaReserva(rs.getDate("fecha_reserva"));
        r.setHoraInicio(rs.getTime("hora_inicio"));
        r.setHoraFin(rs.getTime("hora_fin"));
        r.setNumIntegrantes(rs.getInt("num_integrantes"));
        r.setMotivo(rs.getString("motivo"));
        r.setEstado(rs.getString("estado"));
        r.setHoraCheckIn(rs.getTimestamp("hora_check_in"));
        r.setFechaCreacion(rs.getTimestamp("fecha_creacion"));

        // Enriquecidos con sala y usuario
        r.setCodigoSala(rs.getString("codigo_sala"));
        r.setCapacidadSala(rs.getInt("capacidad"));
        r.setEsSilenciosa(rs.getInt("es_silenciosa"));
        r.setUbicacionSala(rs.getString("ubicacion"));
        r.setRecursosSala(rs.getString("recursos"));
        r.setNombreUsuario(rs.getString("nombre_usuario"));

        return r;
    }
}
