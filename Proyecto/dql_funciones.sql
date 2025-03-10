use parques_db;

-- 1. Superficie total de parques por departamento
DELIMITER $$
CREATE FUNCTION superficie_total_por_departamento(p_id_departamento INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE superficie_total DECIMAL(12,2);

    SELECT SUM(a.extension) 
    INTO superficie_total
    FROM area a
    JOIN parque_natural p ON a.id_parque = p.id_parque
    JOIN departamento_parque dp ON dp.id_parque = p.id_parque
    WHERE dp.id_departamento = p_id_departamento;

    RETURN superficie_total;
END $$
DELIMITER ;

SELECT superficie_total_por_departamento(2) AS superficie_total;

-- 2. Inventario de especies por área y tipo
DELIMITER $$
CREATE FUNCTION inventario_especies_por_area_y_tipo(p_id_area INT, p_tipo_especie ENUM('vegetal', 'animal', 'mineral'))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_especies INT;
    
    SELECT SUM(aspec.numero_individuos) 
    INTO total_especies
    FROM area_especie aspec
    JOIN especie e ON aspec.id_especie = e.id_especie
    WHERE aspec.id_area = p_id_area AND e.tipo = p_tipo_especie;

    RETURN total_especies;
END $$
DELIMITER ;

SELECT inventario_especies_por_area_y_tipo(1, 'vegetal') AS total_especies_vegetales;

-- 3. Costo total de un proyecto de investigación
DELIMITER $$
CREATE FUNCTION costo_total_proyecto(p_id_proyecto INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE costo DECIMAL(12,2);

    SELECT SUM(p.presupuesto) 
    INTO costo
    FROM proyecto_investigacion p
    WHERE p.id_proyecto = p_id_proyecto;

    RETURN costo;
END $$
DELIMITER ;

SELECT costo_total_proyecto(3) AS costo_total;

-- 4. Promedio de sueldo por tipo de personal
DELIMITER $$
CREATE FUNCTION promedio_sueldo_por_tipo(tipo_personal ENUM('001', '002', '003', '004'))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(10,2);

    SELECT AVG(p.sueldo) 
    INTO promedio
    FROM personal p
    WHERE p.tipo_personal = tipo_personal;

    RETURN promedio;
END $$
DELIMITER ;

SELECT promedio_sueldo_por_tipo('002') AS promedio_sueldo;

-- 5. Número de visitantes en un parque específico
DELIMITER $$
CREATE FUNCTION num_visitantes_por_parque(p_id_parque INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE num_visitantes INT;

    SELECT COUNT(DISTINCT v.cedula) 
    INTO num_visitantes
    FROM visitantes v
    JOIN estancia e ON v.cedula = e.id_visitante
    JOIN alojamiento a ON e.id_alojamiento = a.id_alojamiento
    WHERE a.id_parque = p_id_parque;

    RETURN num_visitantes;
END $$
DELIMITER ;

SELECT num_visitantes_por_parque(1) AS total_visitantes;

-- 6. Costo promedio de alojamiento por parque
DELIMITER $$
CREATE FUNCTION costo_promedio_alojamiento_por_parque(p_id_parque INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE costo_promedio DECIMAL(12,2);

    SELECT AVG(a.capacidad * 100) -- Suponiendo un costo de 100 por persona
    INTO costo_promedio
    FROM alojamiento a
    WHERE a.id_parque = p_id_parque;

    RETURN costo_promedio;
END $$
DELIMITER ;

SELECT costo_promedio_alojamiento_por_parque(3) AS costo_promedio;

-- 7. Número de proyectos de investigación por especie
DELIMITER $$
CREATE FUNCTION num_proyectos_por_especie(p_id_especie INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE num_proyectos INT;

    SELECT COUNT(DISTINCT pe.id_proyecto)
    INTO num_proyectos
    FROM proyecto_especie pe
    WHERE pe.id_especie = p_id_especie;

    RETURN num_proyectos;
END $$
DELIMITER ;

SELECT num_proyectos_por_especie(7) AS num_proyectos;

-- 8. Promedio de duración de los proyectos de investigación
DELIMITER $$
CREATE FUNCTION promedio_duracion_proyectos()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE promedio INT;

    SELECT AVG(DATEDIFF(p.fecha_fin, p.fecha_inicio))
    INTO promedio
    FROM proyecto_investigacion p;

    RETURN promedio;
END $$
DELIMITER ;

SELECT promedio_duracion_proyectos() AS promedio_duracion;

-- 9. Número de alojamientos disponibles en un parque
DELIMITER $$
CREATE FUNCTION num_alojamientos_disponibles(p_id_parque INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE alojamientos_disponibles INT;

    SELECT COUNT(a.id_alojamiento)
    INTO alojamientos_disponibles
    FROM alojamiento a
    WHERE a.id_parque = p_id_parque;

    RETURN alojamientos_disponibles;
END $$
DELIMITER ;

SELECT num_alojamientos_disponibles(2) AS alojamientos_disponibles;

-- 10. Cantidad de especies por tipo en un área específica
DELIMITER $$
CREATE FUNCTION cantidad_especies_por_tipo(p_id_area INT, p_tipo_especie ENUM('vegetal', 'animal', 'mineral'))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE cantidad INT;

    SELECT COUNT(DISTINCT e.id_especie)
    INTO cantidad
    FROM area_especie ae
    JOIN especie e ON ae.id_especie = e.id_especie
    WHERE ae.id_area = p_id_area AND e.tipo = p_tipo_especie;

    RETURN cantidad;
END $$
DELIMITER ;

SELECT cantidad_especies_por_tipo(1, 'animal') AS num_especies_animales;

-- 11. Total de presupuesto asignado a proyectos de investigación en un parque
DELIMITER $$
CREATE FUNCTION presupuesto_total_por_parque(p_id_parque INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE presupuesto_total DECIMAL(12,2);

    SELECT SUM(p.presupuesto)
    INTO presupuesto_total
    FROM proyecto_investigacion p
    JOIN proyecto_especie pe ON p.id_proyecto = pe.id_proyecto
    JOIN area_especie ae ON pe.id_especie = ae.id_especie
    JOIN area a ON ae.id_area = a.id_area
    JOIN parque_natural pn ON a.id_parque = pn.id_parque
    WHERE pn.id_parque = p_id_parque;

    RETURN presupuesto_total;
END $$
DELIMITER ;

SELECT presupuesto_total_por_parque(4) AS presupuesto_total;

-- 12. Total de especies en todos los parques
DELIMITER $$
CREATE FUNCTION total_especies_en_parques()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT SUM(numero_individuos)
    INTO total
    FROM area_especie;

    RETURN total;
END $$
DELIMITER ;

select total_especies_en_parques();

-- 13. Número de especies animales en un parque específico
DELIMITER $$
CREATE FUNCTION num_especies_animales_por_parque(p_id_parque INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE num_animales INT;

    SELECT COUNT(DISTINCT e.id_especie)
    INTO num_animales
    FROM area_especie ae
    JOIN especie e ON ae.id_especie = e.id_especie
    JOIN area a ON ae.id_area = a.id_area
    JOIN parque_natural p ON a.id_parque = p.id_parque
    WHERE p.id_parque = p_id_parque AND e.tipo = 'animal';

    RETURN num_animales;
END $$
DELIMITER ;

select num_especies_animales_por_parque(25);

-- 14. Costo de operación por tipo de personal
DELIMITER $$
CREATE FUNCTION costo_operacion_por_tipo_personal(p_tipo_personal ENUM('001', '002', '003', '004'))
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE costo_total DECIMAL(12,2);

    SELECT SUM(p.sueldo)
    INTO costo_total
    FROM personal p
    WHERE p.tipo_personal = p_tipo_personal;

    RETURN costo_total;
END $$
DELIMITER ;

select costo_operacion_por_tipo_personal("001");

-- 15. Número de visitantes por alojamiento
DELIMITER $$
CREATE FUNCTION num_visitantes_por_alojamiento(p_id_alojamiento INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE num_visitantes INT;

    SELECT COUNT(DISTINCT s.id_visitante)
    INTO num_visitantes
    FROM estancia s
    WHERE s.id_alojamiento = p_id_alojamiento;

    RETURN num_visitantes;
END $$
DELIMITER ;

select num_visitantes_por_alojamiento(3);

-- 16. Promedio de capacidad de alojamiento por parque
DELIMITER $$
CREATE FUNCTION promedio_capacidad_alojamiento_por_parque(p_id_parque INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE promedio_capacidad DECIMAL(12,2);

    SELECT AVG(a.capacidad)
    INTO promedio_capacidad
    FROM alojamiento a
    WHERE a.id_parque = p_id_parque;

    RETURN promedio_capacidad;
END $$
DELIMITER ;

select promedio_capacidad_alojamiento_por_parque(5);

-- 17. Número de personal asignado a conservación en un parque
DELIMITER $$
CREATE FUNCTION num_personal_conservacion_por_parque(p_id_parque INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE num_personal INT;

    SELECT COUNT(DISTINCT g.id_personalConservacion)
    INTO num_personal
    FROM gestion_conservacion g
    JOIN area a ON g.id_area = a.id_area
    JOIN parque_natural p ON a.id_parque = p.id_parque
    WHERE p.id_parque = p_id_parque;

    RETURN num_personal;
END $$
DELIMITER ;

select num_personal_conservacion_por_parque(10);

-- 18. Total de personal asignado a vigilancia por parque
DELIMITER $$
CREATE FUNCTION total_personal_vigilancia_por_parque(p_id_parque INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_personal INT;

    SELECT COUNT(DISTINCT gv.id_personalVigilancia)
    INTO total_personal
    FROM gestion_vigilancia gv
    JOIN area a ON gv.id_area = a.id_area
    JOIN parque_natural p ON a.id_parque = p.id_parque
    WHERE p.id_parque = p_id_parque;

    RETURN total_personal;
END $$
DELIMITER ;

select total_personal_vigilancia_por_parque(15);

-- 19. Promedio de duración de estancia de visitantes en alojamientos
DELIMITER $$
CREATE FUNCTION promedio_duracion_estancia(p_id_parque INT)
RETURNS double
DETERMINISTIC
BEGIN
    DECLARE promedio double;

    SELECT AVG(DATEDIFF(s.fecha_salida, s.fecha_ingreso))
    INTO promedio
    FROM estancia s
    JOIN alojamiento a ON s.id_alojamiento = a.id_alojamiento
    JOIN parque_natural p ON a.id_parque = p.id_parque
    WHERE p.id_parque = p_id_parque;

    RETURN promedio;
END $$
DELIMITER ;

select promedio_duracion_estancia(28);

-- 20. Número de especies vegetales en un parque específico
DELIMITER $$
CREATE FUNCTION num_especies_vegetales_por_parque(p_id_parque INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE num_vegetales INT;

    SELECT COUNT(DISTINCT e.id_especie)
    INTO num_vegetales
    FROM area_especie ae
    JOIN especie e ON ae.id_especie = e.id_especie
    JOIN area a ON ae.id_area = a.id_area
    JOIN parque_natural p ON a.id_parque = p.id_parque
    WHERE p.id_parque = p_id_parque AND e.tipo = 'vegetal';

    RETURN num_vegetales;
END $$
DELIMITER ;

select num_especies_vegetales_por_parque(37);

