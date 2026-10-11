package com.utp.reservas.dto;

/**
 * DTO para la entidad TipoEstudiante (prioridad jerárquica y cupos)
 */
public class TipoEstudiante {
    private int idTipo;
    private String nombre;
    private int nivelPrioridad;
    private int horasMaxDia;
    private int diasAnticipacion;

    public TipoEstudiante() {
    }

    public TipoEstudiante(int idTipo, String nombre, int nivelPrioridad, int horasMaxDia, int diasAnticipacion) {
        this.idTipo = idTipo;
        this.nombre = nombre;
        this.nivelPrioridad = nivelPrioridad;
        this.horasMaxDia = horasMaxDia;
        this.diasAnticipacion = diasAnticipacion;
    }

    public int getIdTipo() { return idTipo; }
    public void setIdTipo(int idTipo) { this.idTipo = idTipo; }

    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }

    public int getNivelPrioridad() { return nivelPrioridad; }
    public void setNivelPrioridad(int nivelPrioridad) { this.nivelPrioridad = nivelPrioridad; }

    public int getHorasMaxDia() { return horasMaxDia; }
    public void setHorasMaxDia(int horasMaxDia) { this.horasMaxDia = horasMaxDia; }

    public int getDiasAnticipacion() { return diasAnticipacion; }
    public void setDiasAnticipacion(int diasAnticipacion) { this.diasAnticipacion = diasAnticipacion; }
}
