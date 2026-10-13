-- =============================================================================
-- SISTEMA DE RESERVAS DE SALAS DE ESTUDIO UNIVERSITARIO 
-- Base de Datos: reservas_salas_db
-- =============================================================================

CREATE DATABASE IF NOT EXISTS reservas_salas_db
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE reservas_salas_db;

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- -----------------------------------------------------------------------------
-- 1. TABLA: rol
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS rol (
    id_rol INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 2. TABLA: tipo_estudiante 
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tipo_estudiante (
    id_tipo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,          -- 'PREGRADO', 'MAESTRIA', 'DOCTORADO'
    nivel_prioridad INT NOT NULL,                 -- A mayor número, mayor prioridad (1, 2, 3)
    horas_max_dia INT NOT NULL DEFAULT 2,         -- Regla de cupo: Máximo de horas de reserva por día
    dias_anticipacion INT NOT NULL DEFAULT 3      -- Días previos permitidos para reservar
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 3. TABLA: usuario 
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    codigo_universitario VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NULL,
    contrasena VARCHAR(255) NOT NULL,
    id_rol INT NOT NULL,
    id_tipo_estudiante INT NULL,                  -- NULL para Administradores y Encargados
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO', -- 'ACTIVO', 'INACTIVO', 'SANCIONADO'
    telefono VARCHAR(20) NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_rol) REFERENCES rol(id_rol) ON UPDATE CASCADE,
    FOREIGN KEY (id_tipo_estudiante) REFERENCES tipo_estudiante(id_tipo) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 4. TABLA: sala 
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS sala (
    id_sala INT AUTO_INCREMENT PRIMARY KEY,
    codigo_sala VARCHAR(20) UNIQUE NOT NULL,      
    capacidad INT NOT NULL,                      
    es_silenciosa INT NOT NULL DEFAULT 0,         -- 0 = Sala grupal / debate, 1 = Silenciosa
    ubicacion VARCHAR(100) NOT NULL DEFAULT 'Piso 2 - Biblioteca Central',
    recursos VARCHAR(255) NOT NULL DEFAULT 'Pizarra acrílica, Tomas eléctricas, Wi-Fi 6',
    estado VARCHAR(20) NOT NULL DEFAULT 'DISPONIBLE' -- 'DISPONIBLE', 'MANTENIMIENTO', 'INHABILITADO'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 5. TABLA: reserva 
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS reserva (
    id_reserva INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_sala INT NOT NULL,
    fecha_reserva DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    num_integrantes INT NOT NULL,                 
    motivo VARCHAR(200) NULL,                  
    estado VARCHAR(20) NOT NULL DEFAULT 'RESERVADO', -- 'RESERVADO', 'OCUPADO', 'FINALIZADO', 'CANCELADO', 'NO_ASISTIO'
    hora_check_in DATETIME NULL,                  -- Registra el check-in presencial
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON UPDATE CASCADE,
    FOREIGN KEY (id_sala) REFERENCES sala(id_sala) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================================
-- DATOS DE PRUEBA
-- =============================================================================

-- 1. Roles
INSERT INTO rol (id_rol, nombre) VALUES 
(1, 'ADMINISTRADOR'),
(2, 'ESTUDIANTE'),
(3, 'ENCARGADO')
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);

-- 2. Jerarquía de Estudiantes (Prioridad y Cupos)
INSERT INTO tipo_estudiante (id_tipo, nombre, nivel_prioridad, horas_max_dia, dias_anticipacion) VALUES
(1, 'PREGRADO',  1, 2, 3),
(2, 'MAESTRIA',  2, 3, 5),
(3, 'DOCTORADO', 3, 4, 7)
ON DUPLICATE KEY UPDATE 
  nivel_prioridad = VALUES(nivel_prioridad),
  horas_max_dia = VALUES(horas_max_dia),
  dias_anticipacion = VALUES(dias_anticipacion);

-- 3. Usuarios de prueba (Admin, Encargado, Estudiantes de distintas jerarquías)
INSERT INTO usuario (id_usuario, codigo_universitario, nombre, apellidos, email, contrasena, id_rol, id_tipo_estudiante, estado, telefono) VALUES
(1, 'ADMIN01',   'Administrador', 'TI',             'admin@utp.edu.pe',     'admin123',     1, NULL, 'ACTIVO', '987654321'),
(2, 'U20240001', 'Carlos',        'Mendoza Flores', 'u20240001@utp.edu.pe', 'utp2024',      2, 1,    'ACTIVO', '999123456'),
(3, 'U20240002', 'Valeria',       'Gómez Ríos',     'u20240002@utp.edu.pe', 'utp2024',      2, 1,    'ACTIVO', '999654321'),
(4, 'ENC01',     'Marcos',        'Rojas Silva',    'encargado@utp.edu.pe', 'encargado123', 3, NULL, 'ACTIVO', '987111222'),
(5, 'U20230055', 'Fernando',      'Castro Paredes', 'maestria@utp.edu.pe',  'utp2024',      2, 2,    'ACTIVO', '998877665'),
(6, 'U20220010', 'Lucía',         'Vargas Medina',  'doctorado@utp.edu.pe', 'utp2024',      2, 3,    'ACTIVO', '997788990')
ON DUPLICATE KEY UPDATE 
  nombre = VALUES(nombre),
  apellidos = VALUES(apellidos),
  email = VALUES(email),
  contrasena = VALUES(contrasena),
  id_rol = VALUES(id_rol),
  id_tipo_estudiante = VALUES(id_tipo_estudiante),
  estado = VALUES(estado),
  telefono = VALUES(telefono);

-- 4. Cubículos y Salas de Estudio
INSERT INTO sala (id_sala, codigo_sala, capacidad, es_silenciosa, ubicacion, recursos, estado) VALUES
(1, 'CUB-01', 4, 0, 'Piso 2 - Pabellón A', 'Pizarra acrílica, Tomas eléctricas, Wi-Fi 6', 'DISPONIBLE'),
(2, 'CUB-02', 6, 0, 'Piso 2 - Pabellón A', 'Pizarra acrílica, Smart TV 50 pulgadas, Tomas eléctricas', 'DISPONIBLE'),
(3, 'CUB-03', 4, 1, 'Piso 3 - Zona Silenciosa', 'Aislamiento acústico, Lámparas regulables, Wi-Fi 6', 'DISPONIBLE'),
(4, 'CUB-04', 8, 0, 'Piso 2 - Pabellón B', 'Pizarra acrílica gigante, Proyector HDMI, Mesa de debate', 'DISPONIBLE'),
(5, 'CUB-05', 2, 1, 'Piso 3 - Zona Silenciosa', 'Cabina individual doble, Escritorios ergonómicos', 'DISPONIBLE'),
(6, 'CUB-06', 6, 0, 'Piso 1 - Hemeroteca', 'Pizarra acrílica, Tomas eléctricas', 'MANTENIMIENTO')
ON DUPLICATE KEY UPDATE 
  codigo_sala = VALUES(codigo_sala),
  capacidad = VALUES(capacidad),
  es_silenciosa = VALUES(es_silenciosa),
  ubicacion = VALUES(ubicacion),
  recursos = VALUES(recursos),
  estado = VALUES(estado);

-- 5. Reservas de prueba para simular los estados del sistema
DELETE FROM reserva;
INSERT INTO reserva (id_reserva, id_usuario, id_sala, fecha_reserva, hora_inicio, hora_fin, num_integrantes, motivo, estado, hora_check_in) VALUES
(1, 2, 1, CURDATE(), '08:00:00', '09:00:00', 3, 'Proyecto Integrador Java Web', 'OCUPADO', NOW()),
(2, 2, 2, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '14:00:00', '15:00:00', 4, 'Repaso Examen Final Cálculo', 'RESERVADO', NULL),
(3, 3, 3, CURDATE(), '16:00:00', '18:00:00', 2, 'Redacción Artículo Científico', 'RESERVADO', NULL),
(4, 5, 4, DATE_SUB(CURDATE(), INTERVAL 1 DAY), '18:00:00', '20:00:00', 6, 'Sustentación Tesis Maestría', 'FINALIZADO', DATE_SUB(NOW(), INTERVAL 1 DAY)),
(5, 6, 5, DATE_SUB(CURDATE(), INTERVAL 2 DAY), '10:00:00', '12:00:00', 2, 'Investigación Doctoral en IA', 'CANCELADO', NULL);

ALTER TABLE reserva AUTO_INCREMENT = 6;
