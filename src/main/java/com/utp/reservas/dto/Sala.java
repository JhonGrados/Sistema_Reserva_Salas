package com.utp.reservas.dto;

public class Sala {
    private int idSala;
    private String codigoSala;
    private int capacidad;
    private int esSilenciosa; 
    private String ubicacion;
    private String recursos;
    private String estado;

    public Sala() {
    }

    public Sala(int idSala, String codigoSala, int capacidad, int esSilenciosa, String ubicacion, String recursos, String estado) {
        this.idSala = idSala;
        this.codigoSala = codigoSala;
        this.capacidad = capacidad;
        this.esSilenciosa = esSilenciosa;
        this.ubicacion = ubicacion;
        this.recursos = recursos;
        this.estado = estado;
    }

    public int getIdSala() { return idSala; }
    public void setIdSala(int idSala) { this.idSala = idSala; }

    public String getCodigoSala() { return codigoSala; }
    public void setCodigoSala(String codigoSala) { this.codigoSala = codigoSala; }

    public int getCapacidad() { return capacidad; }
    public void setCapacidad(int capacidad) { this.capacidad = capacidad; }

    public int getEsSilenciosa() { return esSilenciosa; }
    public void setEsSilenciosa(int esSilenciosa) { this.esSilenciosa = esSilenciosa; }

    public String getUbicacion() { return ubicacion; }
    public void setUbicacion(String ubicacion) { this.ubicacion = ubicacion; }

    public String getRecursos() { return recursos; }
    public void setRecursos(String recursos) { this.recursos = recursos; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}