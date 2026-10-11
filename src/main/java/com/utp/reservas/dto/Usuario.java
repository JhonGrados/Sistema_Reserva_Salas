package com.utp.reservas.dto;

/**
 * DTO para la entidad Usuario
 */
public class Usuario {
    private int idUsuario;
    private String codigoUniversitario;
    private String nombre;
    private String apellidos;
    private String email;
    private String contrasena;
    private int idRol;
    private Integer idTipoEstudiante;

    // Campos auxiliares para relaciones con Rol y TipoEstudiante
    private String nombreRol;
    private String nombreTipoEstudiante;
    private Integer nivelPrioridad;
    private Integer horasMaxDia;
    private Integer diasAnticipacion;

    public Usuario() {
    }

    public Usuario(int idUsuario, String codigoUniversitario, String nombre, String apellidos,
            String email, String contrasena, int idRol, Integer idTipoEstudiante) {
        this.idUsuario = idUsuario;
        this.codigoUniversitario = codigoUniversitario;
        this.nombre = nombre;
        this.apellidos = apellidos;
        this.email = email;
        this.contrasena = contrasena;
        this.idRol = idRol;
        this.idTipoEstudiante = idTipoEstudiante;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public String getCodigoUniversitario() {
        return codigoUniversitario;
    }

    public void setCodigoUniversitario(String codigoUniversitario) {
        this.codigoUniversitario = codigoUniversitario;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getApellidos() {
        return apellidos;
    }

    public void setApellidos(String apellidos) {
        this.apellidos = apellidos;
    }

    public String getNombreCompleto() {
        return ((nombre != null ? nombre : "") + " " + (apellidos != null ? apellidos : "")).trim();
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getContrasena() {
        return contrasena;
    }

    public void setContrasena(String contrasena) {
        this.contrasena = contrasena;
    }

    public int getIdRol() {
        return idRol;
    }

    public void setIdRol(int idRol) {
        this.idRol = idRol;
    }

    public Integer getIdTipoEstudiante() {
        return idTipoEstudiante;
    }

    public void setIdTipoEstudiante(Integer idTipoEstudiante) {
        this.idTipoEstudiante = idTipoEstudiante;
    }

    public String getNombreRol() {
        return nombreRol;
    }

    public void setNombreRol(String nombreRol) {
        this.nombreRol = nombreRol;
    }

    public String getNombreTipoEstudiante() {
        return nombreTipoEstudiante;
    }

    public void setNombreTipoEstudiante(String nombreTipoEstudiante) {
        this.nombreTipoEstudiante = nombreTipoEstudiante;
    }

    public Integer getNivelPrioridad() {
        return nivelPrioridad;
    }

    public void setNivelPrioridad(Integer nivelPrioridad) {
        this.nivelPrioridad = nivelPrioridad;
    }

    public Integer getHorasMaxDia() {
        return horasMaxDia;
    }

    public void setHorasMaxDia(Integer horasMaxDia) {
        this.horasMaxDia = horasMaxDia;
    }

    public Integer getDiasAnticipacion() {
        return diasAnticipacion;
    }

    public void setDiasAnticipacion(Integer diasAnticipacion) {
        this.diasAnticipacion = diasAnticipacion;
    }
}
