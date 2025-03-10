use parques_db;

-- 1. Evento para generar un reporte semanal de visitantes
DELIMITER //
CREATE EVENT generar_reporte_visitantes
ON SCHEDULE EVERY 1 WEEK STARTS '2025-03-10 00:00:00'
DO
BEGIN
    INSERT INTO reporte_visitantes (fecha_reporte, total_visitantes)
    SELECT CURRENT_DATE, COUNT(*) 
    FROM estancia;
END;
//
DELIMITER ;

-- 2. Evento para generar un reporte semanal de alojamientos
DELIMITER //
CREATE EVENT generar_reporte_alojamientos
ON SCHEDULE EVERY 1 WEEK STARTS '2025-03-10 00:00:00'
DO
BEGIN
    INSERT INTO reporte_alojamientos (fecha_reporte, total_alojamientos)
    SELECT CURRENT_DATE, COUNT(*) 
    FROM estancia;
END;
//
DELIMITER ;

-- 3. Evento para actualizar inventarios de especies cada mes
DELIMITER //
CREATE EVENT actualizar_inventario_especies
ON SCHEDULE EVERY 1 MONTH STARTS '2025-03-10 00:00:00'
DO
BEGIN
    UPDATE area_especie
    SET numero_individuos = numero_individuos * 1.05; -- Suponiendo que la población aumenta un 5%
END;
//
DELIMITER ;

-- 4. Evento para generar reporte de especies por área cada semana
DELIMITER //
CREATE EVENT generar_reporte_especies_area
ON SCHEDULE EVERY 1 WEEK STARTS '2025-03-10 00:00:00'
DO
BEGIN
    INSERT INTO reporte_especies_area (fecha_reporte, id_area, total_especies)
    SELECT CURRENT_DATE, id_area, COUNT(*)
    FROM area_especie
    GROUP BY id_area;
END;
//
DELIMITER ;

-- 5. Evento para actualizar la información de conservación de áreas cada mes
DELIMITER //
CREATE EVENT actualizar_informacion_conservacion
ON SCHEDULE EVERY 1 MONTH STARTS '2025-03-10 00:00:00'
DO
BEGIN
    UPDATE gestion_conservacion
    SET especialidad = CONCAT(especialidad, ' - Actualizado');
END;
//
DELIMITER ;

-- 6. Evento para registrar la cantidad de visitantes por parque cada semana
DELIMITER //
CREATE EVENT registrar_visitantes_parque
ON SCHEDULE EVERY 1 WEEK STARTS '2025-03-10 00:00:00'
DO
BEGIN
    INSERT INTO reporte_visitantes_parque (fecha_reporte, id_parque, total_visitantes)
    SELECT CURRENT_DATE, id_parque, COUNT(*)
    FROM estancia
    GROUP BY id_parque;
END;
//
DELIMITER ;

-- 7. Evento para generar el reporte mensual de personal asignado a cada parque
DELIMITER //
CREATE EVENT generar_reporte_personal_parque
ON SCHEDULE EVERY 1 MONTH STARTS '2025-03-10 00:00:00'
DO
BEGIN
    INSERT INTO reporte_personal_parque (fecha_reporte, id_parque, total_personal)
    SELECT CURRENT_DATE, id_parque, COUNT(*)
    FROM gestion_visitantes
    GROUP BY id_parque;
END;
//
DELIMITER ;

-- 8. Evento para limpiar datos antiguos de visitantes después de 6 meses
DELIMITER //
CREATE EVENT limpiar_visitantes_antiguos
ON SCHEDULE EVERY 1 DAY STARTS '2025-03-10 00:00:00'
DO
BEGIN
    DELETE FROM visitantes
    WHERE TIMESTAMPDIFF(MONTH, fecha_ingreso, CURRENT_DATE) > 6;
END;
//
DELIMITER ;

-- 9. Evento para actualizar el inventario de especies cada dos semanas
DELIMITER //
CREATE EVENT actualizar_inventario_especies_bimensual
ON SCHEDULE EVERY 2 WEEK STARTS '2025-03-10 00:00:00'
DO
BEGIN
    UPDATE area_especie
    SET numero_individuos = numero_individuos * 1.03; -- Incremento del 3% cada dos semanas
END;
//
DELIMITER ;

-- 10. Evento para limpiar datos antiguos de estancias después de 1 año
DELIMITER //
CREATE EVENT limpiar_estancias_antiguas
ON SCHEDULE EVERY 1 DAY STARTS '2025-03-10 00:00:00'
DO
BEGIN
    DELETE FROM estancia
    WHERE TIMESTAMPDIFF(YEAR, fecha_ingreso, CURRENT_DATE) > 1;
END;
//
DELIMITER ;

-- 11. Evento para actualizar la cantidad de especies en áreas cada trimestre
DELIMITER //
CREATE EVENT actualizar_especies_area_trimestral
ON SCHEDULE EVERY 3 MONTH STARTS '2025-03-10 00:00:00'
DO
BEGIN
    UPDATE area_especie
    SET numero_individuos = numero_individuos * 1.07; -- Incremento del 7% trimestral
END;
//
DELIMITER ;

-- 12. Evento para generar un reporte trimestral de las especies más vistas
DELIMITER //
CREATE EVENT reporte_especies_vistas_trimestral
ON SCHEDULE EVERY 3 MONTH STARTS '2025-03-10 00:00:00'
DO
BEGIN
    INSERT INTO reporte_especies_vistas (fecha_reporte, id_especie, total_vistas)
    SELECT CURRENT_DATE, id_especie, SUM(numero_individuos)
    FROM area_especie
    GROUP BY id_especie;
END;
//
DELIMITER ;

-- 13. Evento para generar reporte de personal por tipo de tarea cada mes
DELIMITER //
CREATE EVENT reporte_personal_tipo_tarea
ON SCHEDULE EVERY 1 MONTH STARTS '2025-03-10 00:00:00'
DO
BEGIN
    INSERT INTO reporte_personal_tipo_tarea (fecha_reporte, tipo_personal, total_personal)
    SELECT CURRENT_DATE, tipo_personal, COUNT(*)
    FROM personal
    GROUP BY tipo_personal;
END;
//
DELIMITER ;

-- 14. Evento para actualizar los datos de la conservación de un área cada dos semanas
DELIMITER //
CREATE EVENT actualizar_conservacion_area_bimensual
ON SCHEDULE EVERY 2 WEEK STARTS '2025-03-10 00:00:00'
DO
BEGIN
    UPDATE gestion_conservacion
    SET especialidad = CONCAT(especialidad, ' - Actualización');
END;
//
DELIMITER ;

-- 15. Evento para generar un reporte de las visitas diarias por parque
DELIMITER //
CREATE EVENT reporte_visitas_diarias_parque
ON SCHEDULE EVERY 1 DAY STARTS '2025-03-10 00:00:00'
DO
BEGIN
    INSERT INTO reporte_visitas_diarias (fecha_reporte, id_parque, total_visitas)
    SELECT CURRENT_DATE, id_parque, COUNT(*)
    FROM estancia
    GROUP BY id_parque;
END;
//
DELIMITER ;

-- 16. Evento para generar reporte semanal de especies por parque
DELIMITER //
CREATE EVENT reporte_semanal_especies_parque
ON SCHEDULE EVERY 1 WEEK STARTS '2025-03-10 00:00:00'
DO
BEGIN
    INSERT INTO reporte_semanal_especies (fecha_reporte, id_parque, total_especies)
    SELECT CURRENT_DATE, id_parque, COUNT(*)
    FROM area_especie
    GROUP BY id_parque;
END;
//
DELIMITER ;

-- 17. Evento para registrar la cantidad de personal asignado a áreas cada mes
DELIMITER //
CREATE EVENT registrar_personal_asignado_area
ON SCHEDULE EVERY 1 MONTH STARTS '2025-03-10 00:00:00'
DO
BEGIN
    INSERT INTO reporte_personal_area (fecha_reporte, id_area, total_personal)
    SELECT CURRENT_DATE, id_area, COUNT(*)
    FROM gestion_conservacion
    GROUP BY id_area;
END;
//
DELIMITER ;

-- 18. Evento para actualizar el inventario de parques cada trimestre
DELIMITER //
CREATE EVENT actualizar_inventario_parques_trimestral
ON SCHEDULE EVERY 3 MONTH STARTS '2025-03-10 00:00:00'
DO
BEGIN
    UPDATE parque_natural
    SET nombre = CONCAT(nombre, ' - Inventario actualizado');
END;
//
DELIMITER ;

-- 19. Evento para actualizar los alojamientos disponibles en los parques cada semana
DELIMITER //
CREATE EVENT actualizar_alojamientos_disponibles
ON SCHEDULE EVERY 1 WEEK STARTS '2025-03-10 00:00:00'
DO
BEGIN
    UPDATE alojamiento
    SET capacidad = capacidad - (SELECT COUNT(*) FROM estancia WHERE estancia.id_alojamiento = alojamiento.id_alojamiento);
END;
//
DELIMITER ;

-- 20. Evento para enviar un recordatorio mensual de conservación de especies
DELIMITER //
CREATE EVENT recordatorio_conservacion_especies
ON SCHEDULE EVERY 1 MONTH STARTS '2025-03-10 00:00:00'
DO
BEGIN
    INSERT INTO recordatorio_conservacion (fecha_recordatorio, mensaje)
    VALUES (CURRENT_DATE, 'Recordatorio: Conservación de especies pendiente');
END;
//
DELIMITER ;