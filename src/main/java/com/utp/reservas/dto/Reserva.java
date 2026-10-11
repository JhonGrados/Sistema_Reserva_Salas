package com.utp.reservas.dto;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

/**
 * DTO para la entidad Reserva con datos enriquecidos de Sala y Usuario
 */
public class Reserva {

    private int idReserva;
    private int idUsuario;
    private int idSala;
    private Date fechaReserva;
    private Time horaInicio;
    private Time horaFin;
    private int numIntegrantes;
    private String motivo;
    private String estado;
    private Timestamp horaCheckIn;
    private Timestamp fechaCreacion;

    // Campos relacionados (JOIN con sala)
    private String codigoSala;
    private int capacidadSala;
    private int esSilenciosa;
    private String ubicacionSala;
    private String recursosSala;

    // Campo relacionado (JOIN con usuario)
    private String nombreUsuario;

    public Reserva() {
    }

    public Reserva(int idReserva, int idUsuario, int idSala, Date fechaReserva,
                   Time horaInicio, Time horaFin, int numIntegrantes, String motivo, String estado) {
        this.idReserva = idReserva;
        this.idUsuario = idUsuario;
        this.idSala = idSala;
        this.fechaReserva = fechaReserva;
        this.horaInicio = horaInicio;
        this.horaFin = horaFin;
        this.numIntegrantes = numIntegrantes;
        this.motivo = motivo;
        this.estado = estado;
    }

    // Getters y Setters
    public int getIdReserva() {
        return idReserva;
    }

    public void setIdReserva(int idReserva) {
        this.idReserva = idReserva;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getIdSala() {
        return idSala;
    }

    public void setIdSala(int idSala) {
        this.idSala = idSala;
    }

    public Date getFechaReserva() {
        return fechaReserva;
    }

    public void setFechaReserva(Date fechaReserva) {
        this.fechaReserva = fechaReserva;
    }

    public Time getHoraInicio() {
        return horaInicio;
    }

    public void setHoraInicio(Time horaInicio) {
        this.horaInicio = horaInicio;
    }

    public Time getHoraFin() {
        return horaFin;
    }

    public void setHoraFin(Time horaFin) {
        this.horaFin = horaFin;
    }

    public int getNumIntegrantes() {
        return numIntegrantes;
    }

    public void setNumIntegrantes(int numIntegrantes) {
        this.numIntegrantes = numIntegrantes;
    }

    public String getMotivo() {
        return motivo;
    }

    public void setMotivo(String motivo) {
        this.motivo = motivo;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public Timestamp getHoraCheckIn() {
        return horaCheckIn;
    }

    public void setHoraCheckIn(Timestamp horaCheckIn) {
        this.horaCheckIn = horaCheckIn;
    }

    public Timestamp getFechaCreacion() {
        return fechaCreacion;
    }

    public void setFechaCreacion(Timestamp fechaCreacion) {
        this.fechaCreacion = fechaCreacion;
    }

    public String getCodigoSala() {
        return codigoSala;
    }

    public void setCodigoSala(String codigoSala) {
        this.codigoSala = codigoSala;
    }

    public int getCapacidadSala() {
        return capacidadSala;
    }

    public void setCapacidadSala(int capacidadSala) {
        this.capacidadSala = capacidadSala;
    }

    public int getEsSilenciosa() {
        return esSilenciosa;
    }

    public void setEsSilenciosa(int esSilenciosa) {
        this.esSilenciosa = esSilenciosa;
    }

    public String getUbicacionSala() {
        return ubicacionSala;
    }

    public void setUbicacionSala(String ubicacionSala) {
        this.ubicacionSala = ubicacionSala;
    }

    public String getRecursosSala() {
        return recursosSala;
    }

    public void setRecursosSala(String recursosSala) {
        this.recursosSala = recursosSala;
    }

    public String getNombreUsuario() {
        return nombreUsuario;
    }

    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }

    /**
     * Helper para verificar si la reserva puede cancelarse desde el portal del alumno
     */
    public boolean isCancelable() {
        return "RESERVADO".equalsIgnoreCase(this.estado);
    }

    /**
     * Formato de horario amigable: Ej. "08:00 - 10:00"
     */
    public String getRangoHorario() {
        String ini = horaInicio != null ? horaInicio.toString().substring(0, 5) : "";
        String fin = horaFin != null ? horaFin.toString().substring(0, 5) : "";
        return ini + " - " + fin;
    }
}
