package com.utp.reservas.dao;

import com.utp.reservas.dto.Sala;
import com.utp.reservas.util.ConexionDB;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SalaDAO {

    public List<Sala> listarSalas() {
        List<Sala> listaSalas = new ArrayList<>();
        String sql = "SELECT id_sala, codigo_sala, capacidad, es_silenciosa, ubicacion, recursos, estado FROM sala ORDER BY codigo_sala ASC";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                listaSalas.add(mapearSala(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar salas: " + e.getMessage());
        }
        return listaSalas;
    }

    public List<Sala> listarSalasDisponibles() {
        List<Sala> listaSalas = new ArrayList<>();
        String sql = "SELECT id_sala, codigo_sala, capacidad, es_silenciosa, ubicacion, recursos, estado FROM sala WHERE estado = 'DISPONIBLE' ORDER BY codigo_sala ASC";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                listaSalas.add(mapearSala(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error al listar salas disponibles: " + e.getMessage());
        }
        return listaSalas;
    }

    public Sala obtenerPorId(int idSala) {
        String sql = "SELECT id_sala, codigo_sala, capacidad, es_silenciosa, ubicacion, recursos, estado FROM sala WHERE id_sala = ?";

        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idSala);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapearSala(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al obtener sala por ID: " + e.getMessage());
        }
        return null;
    }

    public boolean registrarSala(Sala sala) {
        String sql = "INSERT INTO sala (codigo_sala, capacidad, es_silenciosa, ubicacion, recursos, estado) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setString(1, sala.getCodigoSala());
            ps.setInt(2, sala.getCapacidad());
            ps.setInt(3, sala.getEsSilenciosa());
            ps.setString(4, sala.getUbicacion() != null ? sala.getUbicacion() : "Piso 2 - Biblioteca Central");
            ps.setString(5, sala.getRecursos() != null ? sala.getRecursos() : "Pizarra acrílica, Tomas eléctricas, Wi-Fi 6");
            ps.setString(6, sala.getEstado());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al registrar sala: " + e.getMessage());
            return false;
        }
    }

    public boolean actualizarSala(Sala sala) {
        String sql = "UPDATE sala SET codigo_sala = ?, capacidad = ?, es_silenciosa = ?, ubicacion = ?, recursos = ?, estado = ? WHERE id_sala = ?";
        
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
             
            ps.setString(1, sala.getCodigoSala());
            ps.setInt(2, sala.getCapacidad());
            ps.setInt(3, sala.getEsSilenciosa());
            ps.setString(4, sala.getUbicacion());
            ps.setString(5, sala.getRecursos());
            ps.setString(6, sala.getEstado());
            ps.setInt(7, sala.getIdSala());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al actualizar sala: " + e.getMessage());
            return false;
        }
    }

    public boolean inhabilitarSala(int idSala) {
        return cambiarEstado(idSala, "INHABILITADO");
    }

    public boolean cambiarEstado(int idSala, String nuevoEstado) {
        String sql = "UPDATE sala SET estado = ? WHERE id_sala = ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, nuevoEstado);
            ps.setInt(2, idSala);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error al cambiar estado de sala: " + e.getMessage());
            return false;
        }
    }

    public int contarTotalSalas() {
        String sql = "SELECT COUNT(*) FROM sala";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error al contar total de salas: " + e.getMessage());
        }
        return 0;
    }

    public int contarSalasPorEstado(String estado) {
        String sql = "SELECT COUNT(*) FROM sala WHERE estado = ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, estado);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al contar salas por estado (" + estado + "): " + e.getMessage());
        }
        return 0;
    }

    public boolean existeCodigoSala(String codigoSala, int idSalaExcluir) {
        String sql = "SELECT COUNT(*) FROM sala WHERE codigo_sala = ? AND id_sala != ?";
        try (Connection con = ConexionDB.getConexion();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, codigoSala.trim());
            ps.setInt(2, idSalaExcluir);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error al verificar código de sala: " + e.getMessage());
        }
        return false;
    }

    private Sala mapearSala(ResultSet rs) throws SQLException {
        Sala sala = new Sala();
        sala.setIdSala(rs.getInt("id_sala"));
        sala.setCodigoSala(rs.getString("codigo_sala"));
        sala.setCapacidad(rs.getInt("capacidad"));
        sala.setEsSilenciosa(rs.getInt("es_silenciosa"));
        sala.setUbicacion(rs.getString("ubicacion"));
        sala.setRecursos(rs.getString("recursos"));
        sala.setEstado(rs.getString("estado"));
        return sala;
    }
}