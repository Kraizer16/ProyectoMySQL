use parques_db;

-- 1. Registrar un nuevo parque
DELIMITER //
CREATE PROCEDURE RegistrarParque(
    IN p_nombre VARCHAR(100),
    IN p_fecha_declaracion DATE
)
BEGIN
    INSERT INTO parque_natural (nombre, fecha_declaracion) 
    VALUES (p_nombre, p_fecha_declaracion);
END //
DELIMITER ;

call RegistrarParque("Parque Jose Antonio Galan", "2007-03-16");

-- 2. Actualizar un parque natural
DELIMITER //
CREATE PROCEDURE ActualizarParque(
    IN p_id_parque INT,
    IN p_nombre VARCHAR(100),
    IN p_fecha_declaracion DATE
)
BEGIN
    UPDATE parque_natural
    SET nombre = p_nombre, fecha_declaracion = p_fecha_declaracion
    WHERE id_parque = p_id_parque;
END //
DELIMITER ;

call ActualizarParque(51, "Parque José Antonio Galán", "2007-02-16");

-- 3. Registrar una nueva área
DELIMITER //
CREATE PROCEDURE RegistrarArea(
    IN p_nombre VARCHAR(100),
    IN p_extension DECIMAL(10, 2),
    IN p_id_parque INT
)
BEGIN
    INSERT INTO area (nombre, extension, id_parque) 
    VALUES (p_nombre, p_extension, p_id_parque);
END //
DELIMITER ;

call RegistrarArea("Zona de Recreacion", 1000.50, 51);

-- 4 Actualizar un área existente
DELIMITER //
CREATE PROCEDURE ActualizarArea(
    IN p_id_area INT,
    IN p_nombre VARCHAR(100),
    IN p_extension DECIMAL(10, 2)
)
BEGIN
    UPDATE area
    SET nombre = p_nombre, extension = p_extension
    WHERE id_area = p_id_area;
END //
DELIMITER ;

call ActualizarArea(51, "Zona Recreativa", 10000);

-- 5. Registrar una especie en un área
DELIMITER //
CREATE PROCEDURE RegistrarEspecie(
    IN p_denominacion_cientifica VARCHAR(50),
    IN p_denominacion_vulgar VARCHAR(50),
    IN p_tipo ENUM('vegetal', 'animal', 'mineral')
)
BEGIN
    INSERT INTO especie (denominacion_cientifica, denominacion_vulgar, tipo) 
    VALUES (p_denominacion_cientifica, p_denominacion_vulgar, p_tipo);
END //
DELIMITER ;

call RegistrarEspecie("Didelphis marsupialis", "Fara", "animal");

-- 6. Procesamiento de datos de visitantes y asignación de alojamientos
DELIMITER //
CREATE PROCEDURE RegistrarVisitante(
    IN p_cedula VARCHAR(15),
    IN p_nombre VARCHAR(50),
    IN p_apellido1 VARCHAR(50),
    IN p_apellido2 VARCHAR(50),
    IN p_direccion VARCHAR(100),
    IN p_profesion VARCHAR(30)
)
BEGIN
    INSERT INTO visitantes (cedula, nombre, apellido1, apellido2, direccion, profesion) 
    VALUES (p_cedula, p_nombre, p_apellido1, p_apellido2, p_direccion, p_profesion);
END //
DELIMITER ;

call RegistrarVisitante("37705895", "Yolanda", "Gallo", "Cáceres", "Cra12A #22-37 Charalá-Santander", "Secretaria");}

-- 7. Registrar una estancia de visitante en un alojamiento
DELIMITER //
CREATE PROCEDURE RegistrarEstancia(
    IN p_cedula VARCHAR(15),
    IN p_id_alojamiento INT,
    IN p_fecha_ingreso DATE,
    IN p_fecha_salida DATE
)
BEGIN
    INSERT INTO estancia (id_visitante, id_alojamiento, fecha_ingreso, fecha_salida) 
    VALUES (p_cedula, p_id_alojamiento, p_fecha_ingreso, p_fecha_salida);
END //
DELIMITER ;

call RegistrarEstancia("37705895", 3, "2025-03-01", "2025-03-16");

-- 8. Consultar la disponibilidad de un alojamiento
DELIMITER //
CREATE PROCEDURE ConsultarDisponibilidadAlojamiento(
    IN p_id_parque INT,
    IN p_fecha_ingreso DATE,
    IN p_fecha_salida DATE
)
BEGIN
    SELECT * FROM alojamiento
    WHERE id_parque = p_id_parque AND id_alojamiento NOT IN (
        SELECT id_alojamiento FROM estancia
        WHERE (fecha_ingreso BETWEEN p_fecha_ingreso AND p_fecha_salida)
        OR (fecha_salida BETWEEN p_fecha_ingreso AND p_fecha_salida)
    );
END //
DELIMITER ;

call ConsultarDisponibilidadAlojamiento(6, "2024-03-01", "2024-03-16");

-- 9. Asignar un alojamiento a un visitante
DELIMITER //
CREATE PROCEDURE AsignarAlojamiento(
    IN p_id_visitante VARCHAR(15),
    IN p_id_alojamiento INT
)
BEGIN
    INSERT INTO estancia (id_visitante, id_alojamiento) 
    VALUES (p_id_visitante, p_id_alojamiento);
END //
DELIMITER ;

call AsignarAlojamiento("37705895", 5);

-- 10. Asignar personal a un área de conservación
DELIMITER //
CREATE PROCEDURE AsignarPersonalConservacion(
    IN p_id_personal VARCHAR(15),
    IN p_id_area INT,
    IN p_especialidad VARCHAR(50)
)
BEGIN
    INSERT INTO gestion_conservacion (id_personalConservacion, id_area, especialidad) 
    VALUES (p_id_personal, p_id_area, p_especialidad);
END //
DELIMITER ;

call AsignarPersonalConservacion("1000345678", 4, "Pintor de Paredes");

-- 11. Asignar personal a vigilancia en un área
DELIMITER //
CREATE PROCEDURE AsignarPersonalVigilancia(
    IN p_id_personal VARCHAR(15),
    IN p_id_area INT,
    IN p_tipo_vehiculo VARCHAR(50),
    IN p_marca_vehiculo VARCHAR(50)
)
BEGIN
    INSERT INTO gestion_vigilancia (id_personalVigilancia, id_area, tipo_vehiculo, marca_vehiculo) 
    VALUES (p_id_personal, p_id_area, p_tipo_vehiculo, p_marca_vehiculo);
END //
DELIMITER ;

call AsignarPersonalVigilancia("1000234567", 4, "Camioneta 4x4", "Toyota TXL");

-- 12. Asignar un investigador a un proyecto
DELIMITER //
CREATE PROCEDURE AsignarInvestigador(
    IN p_id_investigador VARCHAR(15),
    IN p_id_proyecto INT
)
BEGIN
    INSERT INTO investigador_proyecto (id_investigador, id_proyecto) 
    VALUES (p_id_investigador, p_id_proyecto);
END //
DELIMITER ;

call AsignarInvestigador("1000456789", 4);

-- 13. Registrar un nuevo proyecto de investigación
DELIMITER //
CREATE PROCEDURE RegistrarProyectoInvestigacion(
    IN p_presupuesto DECIMAL(12, 2),
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE
)
BEGIN
    INSERT INTO proyecto_investigacion (presupuesto, fecha_inicio, fecha_fin) 
    VALUES (p_presupuesto, p_fecha_inicio, p_fecha_fin);
END //
DELIMITER ;

call RegistrarProyectoInvestigacion(1000000, "2025-03-01", "2025-03-16");

-- 14. Actualizar un proyecto de investigación
DELIMITER //
CREATE PROCEDURE ActualizarProyectoInvestigacion(
    IN p_id_proyecto INT,
    IN p_presupuesto DECIMAL(12, 2),
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE
)
BEGIN
    UPDATE proyecto_investigacion
    SET presupuesto = p_presupuesto, fecha_inicio = p_fecha_inicio, fecha_fin = p_fecha_fin
    WHERE id_proyecto = p_id_proyecto;
END //
DELIMITER ;

call ActualizarProyectoInvestigacion(48, 10000000, "2025-03-01", "2025-03-16");

-- 15. Consultar los proyectos relacionados con una especie
DELIMITER //
CREATE PROCEDURE ConsultarProyectosPorEspecie(
    IN p_id_especie INT
)
BEGIN
    SELECT p.id_proyecto, p.presupuesto, p.fecha_inicio, p.fecha_fin 
    FROM proyecto_investigacion p
    JOIN proyecto_especie pe ON p.id_proyecto = pe.id_proyecto
    WHERE pe.id_especie = p_id_especie;
END //
DELIMITER ;

call ConsultarProyectosPorEspecie(2);

-- 16. Registrar una especie en un área
DELIMITER //
CREATE PROCEDURE RegistrarEspecieEnArea(
    IN p_id_area INT,
    IN p_id_especie INT,
    IN p_numero_individuos INT
)
BEGIN
    INSERT INTO area_especie (id_area, id_especie, numero_individuos) 
    VALUES (p_id_area, p_id_especie, p_numero_individuos);
END //
DELIMITER ;

call RegistrarEspecieEnArea(1,4,400);

-- 17. Consultar especies en un área
DELIMITER //
CREATE PROCEDURE ConsultarEspeciesEnArea(
    IN p_id_area INT
)
BEGIN
    SELECT e.denominacion_cientifica, e.denominacion_vulgar, ae.numero_individuos 
    FROM especie e
    JOIN area_especie ae ON e.id_especie = ae.id_especie
    WHERE ae.id_area = p_id_area;
END //
DELIMITER ;

call ConsultarEspeciesEnArea(3);

-- 18. Actualizar el número de individuos de una especie en un área
DELIMITER //
CREATE PROCEDURE ActualizarNumeroIndividuos(
    IN p_id_area INT,
    IN p_id_especie INT,
    IN p_numero_individuos INT
)
BEGIN
    UPDATE area_especie 
    SET numero_individuos = p_numero_individuos
    WHERE id_area = p_id_area AND id_especie = p_id_especie;
END //
DELIMITER ;

call ActualizarNumeroIndividuos(3,3,10);

-- 19. agregar un nuevo personal
DELIMITER $$
CREATE PROCEDURE agregar_personal(
    IN p_cedula VARCHAR(15),
    IN p_nombre VARCHAR(50),
    IN p_apellido1 VARCHAR(50),
    IN p_apellido2 VARCHAR(50),
    IN p_direccion VARCHAR(100),
    IN p_telefono VARCHAR(15),
    IN p_sueldo DECIMAL(10, 2),
    IN p_tipo_personal ENUM('001', '002', '003', '004')
)
BEGIN
    INSERT INTO personal (cedula, nombre, apellido1, apellido2, direccion, telefono, sueldo, tipo_personal)
    VALUES (p_cedula, p_nombre, p_apellido1, p_apellido2, p_direccion, p_telefono, p_sueldo, p_tipo_personal);
END $$
DELIMITER ;

call agregar_personal("1098407324", "Marlon", "Chacon", "Gallo", "Pinares Condominio Club", "3012787477", 10000000, "004");

-- 20. agregar una nueva entidad responsable
DELIMITER $$
CREATE PROCEDURE agregar_entidad_responsable(
    IN p_nombre VARCHAR(100),
    IN p_direccion VARCHAR(100),
    IN p_telefono VARCHAR(15)
)
BEGIN
    INSERT INTO entidad_responsable (nombre, direccion, telefono)
    VALUES (p_nombre, p_direccion, p_telefono);
END $$
DELIMITER ;

call agregar_entidad_responsable("Campuslands", "Km 6 Anillo Vial", "067324789");

