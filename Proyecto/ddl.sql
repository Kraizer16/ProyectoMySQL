-- Elimina la base de datos si ya existe
DROP DATABASE IF EXISTS parques_db;
-- Crea la base de datos si no existe y define su codificación
CREATE DATABASE IF NOT EXISTS parques_db CHARACTER SET utf8mb4;
-- Usa la base de datos recién creada
USE parques_db;

-- Tabla que almacena las entidades responsables de los parques
DROP TABLE IF EXISTS entidad_responsable;
CREATE TABLE IF NOT EXISTS entidad_responsable (
    id_entidad INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(15) NOT NULL
);

-- Tabla que almacena los departamentos donde se ubican los parques
DROP TABLE IF EXISTS departamento;
CREATE TABLE IF NOT EXISTS departamento (
    id_departamento INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    id_entidad INT NOT NULL,
    FOREIGN KEY (id_entidad) REFERENCES entidad_responsable(id_entidad) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla que almacena los parques naturales
DROP TABLE IF EXISTS parque_natural;
CREATE TABLE IF NOT EXISTS parque_natural (
    id_parque INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    fecha_declaracion DATE NOT NULL
);

-- Tabla intermedia para la relación muchos a muchos entre departamentos y parques
DROP TABLE IF EXISTS departamento_parque;
CREATE TABLE IF NOT EXISTS departamento_parque (
    id_departamento INT NOT NULL,
    id_parque INT NOT NULL,
    PRIMARY KEY(id_departamento, id_parque),
    FOREIGN KEY (id_departamento) REFERENCES departamento(id_departamento) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_parque) REFERENCES parque_natural(id_parque) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla que almacena las áreas de los parques naturales
DROP TABLE IF EXISTS area;
CREATE TABLE IF NOT EXISTS area (
    id_area INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    extension DECIMAL(10, 2) NOT null,
    id_parque INT NOT NULL,
    FOREIGN KEY (id_parque) REFERENCES parque_natural(id_parque) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla para almacenar información del personal que trabaja en los parques
DROP TABLE IF EXISTS personal;
CREATE TABLE IF NOT EXISTS personal (
    cedula VARCHAR(15) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    sueldo DECIMAL(10,2) NOT NULL,
    tipo_personal ENUM('001', '002', '003', '004') NOT NULL
);

-- Tabla para la gestión de visitantes en los parques
DROP TABLE IF EXISTS gestion_visitantes;
CREATE TABLE IF NOT EXISTS gestion_visitantes (
    id_parque INT NOT NULL,
    id_personalEntrada VARCHAR(15) NOT NULL,
    PRIMARY KEY(id_personalEntrada, id_parque),
    FOREIGN KEY (id_parque) REFERENCES parque_natural(id_parque) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_personalEntrada) REFERENCES personal(cedula) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla para la gestión de conservación de áreas
DROP TABLE IF EXISTS gestion_conservacion;
CREATE TABLE IF NOT EXISTS gestion_conservacion (
    id_personalConservacion VARCHAR(15) NOT NULL,
    id_area INT NOT NULL,
    especialidad VARCHAR(50) NOT NULL,
    PRIMARY KEY(id_personalConservacion, id_area),
    FOREIGN KEY (id_personalConservacion) REFERENCES personal(cedula) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_area) REFERENCES area(id_area) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla para la gestión de vigilancia de áreas
drop DROP TABLE IF EXISTS gestion_vigilancia;
CREATE TABLE IF NOT EXISTS gestion_vigilancia (
    id_personalVigilancia VARCHAR(15) NOT NULL,
    id_area INT NOT NULL,
    tipo_vehiculo VARCHAR(50) NOT NULL,
    marca_vehiculo VARCHAR(50) NOT NULL,
    PRIMARY KEY(id_personalVigilancia, id_area),
    FOREIGN KEY (id_personalVigilancia) REFERENCES personal(cedula) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_area) REFERENCES area(id_area) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla para almacenar especies en los parques
DROP TABLE IF EXISTS especie;
CREATE TABLE IF NOT EXISTS especie (
    id_especie INT PRIMARY KEY AUTO_INCREMENT,
    denominacion_cientifica VARCHAR(50) NOT NULL,
    denominacion_vulgar VARCHAR(50) NOT NULL,
    tipo ENUM('vegetal', 'animal', 'mineral') NOT NULL
);

-- Tabla intermedia para la relación entre áreas y especies
DROP TABLE IF EXISTS area_especie;
CREATE TABLE IF NOT EXISTS area_especie (
    id_area INT NOT NULL,
    id_especie INT NOT NULL,
    numero_individuos INT NOT NULL,
    PRIMARY KEY(id_area, id_especie),
    FOREIGN KEY (id_area) REFERENCES area(id_area) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_especie) REFERENCES especie(id_especie) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla para almacenar proyectos de investigación en los parques
DROP TABLE IF EXISTS proyecto_investigacion;
CREATE TABLE IF NOT EXISTS proyecto_investigacion (
    id_proyecto INT PRIMARY KEY AUTO_INCREMENT,
    presupuesto DECIMAL(12,2) NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL
);

-- Tabla intermedia para la relación entre proyectos e investigaciones de especies
DROP TABLE IF EXISTS proyecto_especie;
CREATE TABLE IF NOT EXISTS proyecto_especie (
    id_proyecto INT NOT NULL,
    id_especie INT NOT NULL,
    PRIMARY KEY(id_proyecto, id_especie),
    FOREIGN KEY (id_proyecto) REFERENCES proyecto_investigacion(id_proyecto) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_especie) REFERENCES especie(id_especie) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla para registrar los investigadores en los proyectos
DROP TABLE IF EXISTS investigador_proyecto;
CREATE TABLE IF NOT EXISTS investigador_proyecto (
    id_proyecto INT NOT NULL,
    id_investigador VARCHAR(15) NOT NULL,
    PRIMARY KEY(id_proyecto, id_investigador),
    FOREIGN KEY (id_proyecto) REFERENCES proyecto_investigacion(id_proyecto) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_investigador) REFERENCES personal(cedula) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla para almacenar los visitantes de los parques
DROP TABLE IF EXISTS visitantes;
CREATE TABLE IF NOT EXISTS visitantes (
    cedula VARCHAR(15) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido1 VARCHAR(50) NOT NULL,
    apellido2 VARCHAR(50) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    profesion VARCHAR(30) NOT NULL
);

-- Tabla para gestionar los alojamientos en los parques
DROP TABLE IF EXISTS alojamiento;
CREATE TABLE IF NOT EXISTS alojamiento (
    id_alojamiento INT PRIMARY KEY AUTO_INCREMENT,
    id_parque INT NOT NULL,
    capacidad INT NOT NULL,
    categoria VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_parque) REFERENCES parque_natural(id_parque) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

-- Tabla para registrar la estancia de los visitantes en los alojamientos
DROP TABLE IF EXISTS estancia;
CREATE TABLE IF NOT EXISTS estancia (
    id_visitante VARCHAR(15) NOT NULL,
    id_alojamiento INT NOT NULL,
    fecha_ingreso DATETIME NOT null default CURRENT_TIMESTAMP,
    fecha_salida DATETIME NOT null default (CURRENT_TIMESTAMP + interval 1 DAY),
    PRIMARY KEY(id_visitante, id_alojamiento),
    FOREIGN KEY (id_visitante) REFERENCES visitantes(cedula) 
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_alojamiento) REFERENCES alojamiento(id_alojamiento) 
    ON DELETE CASCADE ON UPDATE CASCADE
);

