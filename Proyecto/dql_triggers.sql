use parques_db;

-- 1. Restricción para Visitantes (Solo personal tipo '001')
DELIMITER $$
CREATE TRIGGER trg_restriccion_visitantes
BEFORE INSERT ON gestion_visitantes
FOR EACH ROW
BEGIN
    DECLARE tipo_actual ENUM('001', '002', '003', '004');

    -- Obtener el tipo de personal
    select tipo_personal INTO tipo_actual
    FROM personal p
    WHERE cedula = NEW.id_personalEntrada;

    -- Verificar que solo el tipo '001' pueda ingresar a visitantes
    IF tipo_actual <> '001' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Solo el personal tipo 001 puede ser asignado a visitantes';
    END IF;
END $$
DELIMITER ;

INSERT INTO gestion_visitantes(id_personalEntrada, id_parque)
VALUES ("1098407324", 3);

-- 2. Restricción para Investigador Proyecto (Solo personal tipo '002')
DELIMITER $$
CREATE TRIGGER trg_restriccion_investigador_proyecto
BEFORE INSERT ON investigador_proyecto
FOR EACH ROW
BEGIN
    DECLARE tipo_actual ENUM('001', '002', '003', '004');

    -- Obtener el tipo de personal
    SELECT tipo_personal INTO tipo_actual
    FROM personal
    WHERE cedula = NEW.id_investigador;

    -- Verificar que solo el tipo '002' pueda ingresar a investigación de proyectos
    IF tipo_actual <> '002' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Solo el personal tipo 002 puede ser asignado a investigador proyecto';
    END IF;
END $$
DELIMITER ;

INSERT INTO investigador_Proyecto(id_investigador, id_proyecto)
VALUES ("1005212356", 5);

-- 3. Restricción para Conservación (Solo personal tipo '003')
DELIMITER $$
CREATE TRIGGER trg_restriccion_conservacion
BEFORE INSERT ON gestion_conservacion
FOR EACH ROW
BEGIN
    DECLARE tipo_actual ENUM('001', '002', '003', '004');

    -- Obtener el tipo de personal
    SELECT tipo_personal INTO tipo_actual
    FROM personal
    WHERE cedula = NEW.id_personalConservacion;

    -- Verificar que solo el tipo '003' pueda ingresar a conservación
    IF tipo_actual <> '003' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Solo el personal tipo 003 puede ser asignado a conservación';
    END IF;
END $$
DELIMITER ;

INSERT INTO gestion_conservacion(id_personalConservacion, id_area)
VALUES ("1098407324", 3);

-- 4. Restricción para Vigilancia (Solo personal tipo '004')
DELIMITER $$
CREATE TRIGGER trg_restriccion_vigilancia
BEFORE INSERT ON gestion_vigilancia
FOR EACH ROW
BEGIN
    DECLARE tipo_actual ENUM('001', '002', '003', '004');

    -- Obtener el tipo de personal
    SELECT tipo_personal INTO tipo_actual
    FROM personal
    WHERE cedula = NEW.id_personalVigilancia;

    -- Verificar que solo el tipo '004' pueda ingresar a vigilancia
    IF tipo_actual <> '004' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Solo el personal tipo 004 puede ser asignado a vigilancia';
    END IF;
END $$
DELIMITER ;

INSERT INTO gestion_vigilancia(id_personalVigilancia, id_area)
VALUES ("1007112375", 3);

-- 5. Evita que un parque tenga áreas con la misma denominación

DELIMITER $$
CREATE TRIGGER before_insert_area
BEFORE INSERT ON area
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM area WHERE nombre = NEW.nombre AND id_parque = NEW.id_parque) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El parque ya tiene un área con este nombre';
    END IF;
end $$
DELIMITER ;

-- 6. Evita sueldos negativos en el personal
DELIMITER $$
CREATE TRIGGER before_insert_personal
BEFORE INSERT ON personal
FOR EACH ROW
BEGIN
    IF NEW.sueldo < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El sueldo no puede ser negativo';
    END IF;
end $$
DELIMITER ;
INSERT INTO area (id_area, nombre, id_parque, extension) 
VALUES (52, 'Zona Verde', 3, 10000);

INSERT INTO area (id_area, nombre, id_parque, extension) 
VALUES (52, 'Zona Verde', 3, 10000);

-- 7. Controla actualizaciones en los sueldos del personal
DELIMITER //
CREATE TRIGGER before_update_sueldo
BEFORE UPDATE ON personal
FOR EACH ROW
BEGIN
    IF NEW.sueldo < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El sueldo no puede ser negativo';
    END IF;
end //
DELIMITER ;

UPDATE personal 
SET sueldo = -500 
WHERE cedula = 1098407324;

-- 8. Registra los cambios salariales en una tabla de auditoría
CREATE TABLE IF NOT EXISTS auditoria_sueldos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cedula VARCHAR(15) NOT NULL,
    sueldo_anterior DECIMAL(10,2) NOT NULL,
    sueldo_nuevo DECIMAL(10,2) NOT NULL,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER after_update_sueldo
AFTER UPDATE ON personal
FOR EACH ROW
BEGIN
    IF OLD.sueldo <> NEW.sueldo THEN
        INSERT INTO auditoria_sueldos (cedula, sueldo_anterior, sueldo_nuevo)
        VALUES (OLD.cedula, OLD.sueldo, NEW.sueldo);
    END IF;
end //
DELIMITER ;

UPDATE personal 
SET sueldo = 100000 
WHERE cedula = '1098407324';

-- 9. Evita la eliminación de una entidad responsable si tiene departamentos asociados
DELIMITER //
CREATE TRIGGER before_delete_entidad
BEFORE DELETE ON entidad_responsable
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM departamento WHERE id_entidad = OLD.id_entidad) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar la entidad porque tiene departamentos asociados';
    END IF;
end //
DELIMITER ;

DELETE FROM entidad_responsable WHERE id_entidad = 5;

-- 10. Evita la asignación de un personal a dos funciones en la misma área
DELIMITER //
CREATE TRIGGER before_insert_gestion_conservacion
BEFORE INSERT ON gestion_conservacion
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM gestion_vigilancia 
        WHERE id_personalVigilancia = NEW.id_personalConservacion 
        AND id_area = NEW.id_area
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El personal ya está asignado a vigilancia en esta área';
    END IF;
end //
DELIMITER ;

INSERT INTO gestion_conservacion(id_personalConservacion, id_area) 
VALUES ("1000234567", 4);

-- 11. Registra la eliminación de especies en un log
CREATE TABLE IF NOT EXISTS auditoria_especies (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_especie INT NOT NULL,
    denominacion_cientifica VARCHAR(50) NOT NULL,
    fecha_eliminacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //
CREATE TRIGGER after_delete_especie
AFTER DELETE ON especie
FOR EACH ROW
BEGIN
    INSERT INTO auditoria_especies (id_especie, denominacion_cientifica)
    VALUES (OLD.id_especie, OLD.denominacion_cientifica);
end //
DELIMITER ;

DELETE FROM especie WHERE id_especie = 10;

-- 12. Evita que un visitante se aloje en más de un alojamiento a la vez
DELIMITER //
CREATE TRIGGER before_insert_estancia
BEFORE INSERT ON estancia
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM estancia WHERE id_visitante = NEW.id_visitante AND fecha_salida > NOW()) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El visitante ya tiene una estancia activa';
    END IF;
end //
DELIMITER ;

INSERT INTO estancia (id_visitante, id_alojamiento, fecha_ingreso, fecha_salida) 
VALUES (37705895, 2, '2025-03-11', '2025-03-20');

-- 13. Evita que un parque tenga dos registros con el mismo nombre
DELIMITER //
CREATE TRIGGER before_insert_parque
BEFORE INSERT ON parque_natural
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM parque_natural WHERE nombre = NEW.nombre) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ya existe un parque con este nombre';
    END IF;
end //
DELIMITER ; 

INSERT INTO parque_natural (nombre) 
VALUES ('Parque Nacional Natural Amacayacu');

-- 14. Controla la capacidad de los alojamientos
DELIMITER //
CREATE TRIGGER before_insert_estancia_capacidad
BEFORE INSERT ON estancia
FOR EACH ROW
BEGIN
    DECLARE capacidad_actual INT;
    DECLARE ocupacion_actual INT;
    
    SELECT capacidad INTO capacidad_actual FROM alojamiento WHERE id_alojamiento = NEW.id_alojamiento;
    SELECT COUNT(*) INTO ocupacion_actual FROM estancia WHERE id_alojamiento = NEW.id_alojamiento AND fecha_salida > NOW();
    
    IF ocupacion_actual >= capacidad_actual THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El alojamiento está lleno';
    END IF;
end //
DELIMITER ;

-- 15. Registrar cambios de sueldo en una tabla histórica
DROP TABLE IF EXISTS historial_sueldos;
CREATE TABLE historial_sueldos (
    id_historial INT PRIMARY KEY AUTO_INCREMENT,
    cedula VARCHAR(15) NOT NULL,
    sueldo_anterior DECIMAL(10,2) NOT NULL,
    sueldo_nuevo DECIMAL(10,2) NOT NULL,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cedula) REFERENCES personal(cedula)
);

DELIMITER //
CREATE TRIGGER after_update_sueldo
AFTER UPDATE ON personal
FOR EACH ROW
BEGIN
    IF OLD.sueldo <> NEW.sueldo THEN
        INSERT INTO historial_sueldos (cedula, sueldo_anterior, sueldo_nuevo)
        VALUES (OLD.cedula, OLD.sueldo, NEW.sueldo);
    END IF;
END;
//
DELIMITER ;

-- 16. Registrar cambios en los salarios del personal
DROP TABLE IF EXISTS historial_salarial;
CREATE TABLE historial_salarial (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    cedula VARCHAR(15) NOT NULL,
    sueldo_anterior DECIMAL(10,2) NOT NULL,
    sueldo_nuevo DECIMAL(10,2) NOT NULL,
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cedula) REFERENCES personal(cedula) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TRIGGER IF EXISTS after_salary_update;
DELIMITER //
CREATE TRIGGER after_salary_update
AFTER UPDATE ON personal
FOR EACH ROW
BEGIN
    IF OLD.sueldo <> NEW.sueldo THEN
        INSERT INTO historial_salarial (cedula, sueldo_anterior, sueldo_nuevo, fecha_cambio)
        VALUES (NEW.cedula, OLD.sueldo, NEW.sueldo, NOW());
    END IF;
end //
DELIMITER ;

-- 17. Registrar Actualización de Áreas en el Inventario
DROP TABLE IF EXISTS historial_inventario;
CREATE TABLE historial_inventario (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_area INT NOT NULL,
    accion VARCHAR(50) NOT NULL,
    descripcion TEXT NOT NULL,
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_area) REFERENCES area(id_area) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TRIGGER IF EXISTS after_area_update;
DELIMITER //
CREATE TRIGGER after_area_update
AFTER UPDATE ON area
FOR EACH ROW
BEGIN
    INSERT INTO historial_inventario (id_area, accion, descripcion, fecha_cambio)
    VALUES (NEW.id_area, 'Actualización', CONCAT('Cambio en área: ', OLD.nombre, ' -> ', NEW.nombre), NOW());
END;
//
DELIMITER ;

-- 18. Registrar Movimiento de Personal
DROP TABLE IF EXISTS historial_personal;
CREATE TABLE historial_personal (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    cedula VARCHAR(15) NOT NULL,
    cambio TEXT NOT NULL,
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cedula) REFERENCES personal(cedula) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TRIGGER IF EXISTS after_personal_update;
DELIMITER //
CREATE TRIGGER after_personal_update
AFTER UPDATE ON personal
FOR EACH ROW
BEGIN
    INSERT INTO historial_personal (cedula, cambio, fecha_cambio)
    VALUES (NEW.cedula, CONCAT('Cambio en datos personales: ', OLD.nombre, ' -> ', NEW.nombre), NOW());
END;
//
DELIMITER ;

-- 19. Restricción de Personal en Gestiones Específicas
DROP TABLE IF EXISTS historial_errores_gestion;
CREATE TABLE historial_errores_gestion (
    id_error INT AUTO_INCREMENT PRIMARY KEY,
    id_personal VARCHAR(15) NOT NULL,
    gestion VARCHAR(50) NOT NULL,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_personal) REFERENCES personal(cedula) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TRIGGER IF EXISTS before_insert_gestion;
DELIMITER //
CREATE TRIGGER before_insert_gestion
BEFORE INSERT ON gestion_visitantes
FOR EACH ROW
BEGIN
    IF (SELECT tipo_personal FROM personal WHERE cedula = NEW.id_personalEntrada) <> '001' THEN
        INSERT INTO historial_errores_gestion (id_personal, gestion, fecha_registro)
        VALUES (NEW.id_personalEntrada, 'gestion_visitantes', NOW());
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Solo el personal de tipo 001 puede gestionar visitantes.';
    END IF;
END;
//
DELIMITER ;

-- 20. Registrar Cambios en Proyectos de Investigación
DROP TABLE IF EXISTS historial_proyectos;
CREATE TABLE historial_proyectos (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_proyecto INT NOT NULL,
    cambio TEXT NOT NULL,
    fecha_cambio DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_proyecto) REFERENCES proyecto_investigacion(id_proyecto) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TRIGGER IF EXISTS after_proyecto_update;
DELIMITER //
CREATE TRIGGER after_proyecto_update
AFTER UPDATE ON proyecto
FOR EACH ROW
BEGIN
    INSERT INTO historial_proyectos (id_proyecto, cambio, fecha_cambio)
    VALUES (NEW.id_proyecto, CONCAT('Cambio en proyecto: ', OLD.nombre, ' -> ', NEW.nombre), NOW());
END;
//
DELIMITER ;


