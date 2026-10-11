package com.utp.reservas.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class ConexionDB {

    public static Connection getConexion() {
        Connection conexion = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            String url = "jdbc:mysql://localhost:3306/reservas_salas_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=America/Lima&useUnicode=true&characterEncoding=UTF-8";
            String usuario = "root";
            String contrasena = "root";

            Properties propiedades = new Properties();
            InputStream entrada = ConexionDB.class.getClassLoader().getResourceAsStream("db.properties");
            if (entrada == null) {
                entrada = Thread.currentThread().getContextClassLoader().getResourceAsStream("db.properties");
            }

            if (entrada != null) {
                propiedades.load(entrada);
                if (propiedades.getProperty("db.url") != null) {
                    url = propiedades.getProperty("db.url");
                }
                if (propiedades.getProperty("db.user") != null) {
                    usuario = propiedades.getProperty("db.user");
                }
                if (propiedades.getProperty("db.password") != null) {
                    contrasena = propiedades.getProperty("db.password");
                }
            } else {
                System.out.println("Aviso: db.properties no detectado directamente, usando configuración por defecto.");
            }

            conexion = DriverManager.getConnection(url, usuario, contrasena);
            System.out.println("Conexión a BD reservas_salas_db exitosa.");

        } catch (ClassNotFoundException e) {
            System.err.println("Driver de MySQL no encontrado en el pom.xml -> " + e.getMessage());
        } catch (SQLException e) {
            System.err.println("Error de SQL al conectar: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Error general: " + e.getMessage());
        }

        return conexion;
    }

    public static void main(String[] args) {
        Connection c = getConexion();
        if (c != null) {
            System.out.println("¡Prueba de conexión local completada con éxito!");
        } else {
            System.err.println("Falló la conexión de prueba.");
        }
    }
}