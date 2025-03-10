use parques_db;

-- 1. Obtener la cantidad de parques por departamento.
SELECT d.nombre AS departamento, COUNT(dp.id_parque) AS cantidad_parques
FROM departamento d
JOIN departamento_parque dp ON d.id_departamento = dp.id_departamento
GROUP BY d.nombre
order by cantidad_parques desc;

-- 2. Listar los parques donde la fecha de declaracion sean despues de 1978
SELECT nombre, fecha_declaracion 
FROM parque_natural 
WHERE fecha_declaracion > '1978-12-31'
order by fecha_declaracion asc;

-- 3. Calcular la superficie total declarada por parque.
SELECT p.nombre AS parque, SUM(a.extension) AS superficie_total
FROM parque_natural p
JOIN area a ON p.id_parque = a.id_parque
GROUP BY p.nombre
order by superficie_total desc;

-- 4. Identificar el parque más grande en superficie.
SELECT p.nombre AS parque, SUM(a.extension) AS superficie_total
FROM parque_natural p
JOIN area a ON p.id_parque = a.id_parque
GROUP BY p.nombre
ORDER BY superficie_total desc
LIMIT 1;

-- 5. Listar los parques con más de 35.000 hectáreas de superficie.
SELECT p.nombre AS parque, SUM(a.extension) AS superficie_total
FROM parque_natural p
JOIN area a ON p.id_parque = a.id_parque
GROUP BY p.nombre
HAVING superficie_total > 35000;

-- 6. Identificar el departamento con más parques.
SELECT d.nombre AS departamento, COUNT(dp.id_parque) AS cantidad_parques
FROM departamento d
JOIN departamento_parque dp ON d.id_departamento = dp.id_departamento
GROUP BY d.nombre
ORDER BY cantidad_parques DESC
LIMIT 1;

-- 7. Promedio de superficie de los parques.
SELECT AVG(superficie_total) AS promedio_superficie
FROM (SELECT SUM(a.extension) AS superficie_total
      FROM parque_natural p
      JOIN area a ON p.id_parque = a.id_parque
      GROUP BY p.id_parque) AS sub;

-- 8. Cantidad de parques por entidad responsable.
SELECT e.nombre AS entidad, COUNT(d.id_departamento) AS cantidad_parques
FROM entidad_responsable e
JOIN departamento d ON e.id_entidad = d.id_entidad
JOIN departamento_parque dp ON d.id_departamento = dp.id_departamento
GROUP BY e.nombre
order by cantidad_parques asc;

-- 9. Obtener los parques con más de 1 departamentos asociados.
SELECT p.nombre AS parque, COUNT(dp.id_departamento) AS cantidad_departamentos
FROM parque_natural p
JOIN departamento_parque dp ON p.id_parque = dp.id_parque
GROUP BY p.nombre
HAVING cantidad_departamentos > 1;

-- 10. Parques ordenados por antigüedad.
SELECT nombre, fecha_declaracion
FROM parque_natural
ORDER BY fecha_declaracion ASC;

-- 11. Obtener la cantidad de especies en cada parque. 
SELECT p.nombre AS parque, COUNT(ae.id_especie) AS total_especies
FROM parque_natural p
JOIN area a ON p.id_parque = a.id_parque
JOIN area_especie ae ON a.id_area = ae.id_area
GROUP BY p.nombre
order by total_especies desc;

-- 12. Listar las especies presentes en un parque específico.
SELECT e.denominacion_vulgar, e.tipo, a.nombre AS area
FROM especie e
JOIN area_especie ae ON e.id_especie = ae.id_especie
JOIN area a ON ae.id_area = a.id_area
JOIN parque_natural p ON a.id_parque = p.id_parque
WHERE p.nombre = 'Parque Nacional Natural Estrella Fluvial del Inírida';

-- 13. Contar el número de individuos por especie en cada área.
SELECT a.nombre AS area, e.denominacion_vulgar, SUM(ae.numero_individuos) AS total_individuos
FROM area a
JOIN area_especie ae ON a.id_area = ae.id_area
JOIN especie e ON ae.id_especie = e.id_especie
GROUP BY a.nombre, e.denominacion_vulgar;

-- 14. Obtener el parque con mayor número de individuos de especies.
SELECT p.nombre AS parque, SUM(ae.numero_individuos) AS total_individuos
FROM parque_natural p
JOIN area a ON p.id_parque = a.id_parque
JOIN area_especie ae ON a.id_area = ae.id_area
GROUP BY p.nombre
ORDER BY total_individuos DESC
LIMIT 1;

-- 15. Obtener el número total de especies de cada tipo.
SELECT tipo, COUNT(*) AS total_especies
FROM especie
GROUP BY tipo;

-- 16. Obtener la cantidad de especies animales en cada parque.
SELECT p.nombre AS parque, COUNT(DISTINCT ae.id_especie) AS total_animales
FROM parque_natural p
JOIN area a ON p.id_parque = a.id_parque
JOIN area_especie ae ON a.id_area = ae.id_area
JOIN especie e ON ae.id_especie = e.id_especie
WHERE e.tipo = 'animal'
GROUP BY p.nombre
order by total_animales desc;

-- 17. Listar las 5 especies con más individuos registrados.
SELECT e.denominacion_vulgar, SUM(ae.numero_individuos) AS total_individuos
FROM especie e
JOIN area_especie ae ON e.id_especie = ae.id_especie
GROUP BY e.denominacion_vulgar
ORDER BY total_individuos DESC
LIMIT 5;

-- 18. Contar la cantidad de personal por tipo.
SELECT p.tipo_personal, COUNT(*) AS cantidad_personal
FROM personal p
GROUP BY tipo_personal;

-- 19. Obtener el sueldo promedio por tipo de personal.
SELECT p.tipo_personal, AVG(sueldo) AS sueldo_promedio
FROM personal p
GROUP BY tipo_personal;

-- 20. Listar todos los empleados con su tipo de cargo y sueldo.
SELECT p.nombre, p.apellido1, p.apellido2, p.sueldo,
       CASE 
           WHEN p.tipo_personal = '001' THEN 'Gestión' 
           WHEN p.tipo_personal = '002' THEN 'Vigilancia' 
           WHEN p.tipo_personal = '003' THEN 'Conservación' 
           WHEN p.tipo_personal = '004' THEN 'Investigador' 
           ELSE 'Otro' 
       END AS cargo
FROM personal p;

-- 21. Listar los empleados que ganan más de 3´000.000.
SELECT p.nombre, 
       p.apellido1, 
       p.apellido2, 
       p.sueldo, 
       CASE 
           WHEN p.tipo_Personal = '001' THEN 'Gestión' 
           WHEN p.tipo_Personal = '002' THEN 'Vigilancia' 
           WHEN p.tipo_Personal = '003' THEN 'Conservación' 
           WHEN p.tipo_Personal = '004' THEN 'Investigador' 
           ELSE 'Otro' 
       END AS cargo
FROM personal p
WHERE p.sueldo > 3000000;

-- 22. Listar los visitantes con su profesión.
SELECT nombre, apellido1, apellido2, profesion 
FROM visitantes;

-- 23. Contar cuántos visitantes han registrado una estancia en algún parque.
SELECT COUNT(DISTINCT id_visitante) AS total_visitantes_con_estancia 
FROM estancia;

-- 24. Obtener la capacidad total de alojamiento por parque.
SELECT p.nombre AS parque, SUM(a.capacidad) AS capacidad_total
FROM alojamiento a
JOIN parque_natural p ON a.id_parque = p.id_parque
GROUP BY p.nombre
order by capacidad_total desc;

-- 25. Listar los proyectos de investigación con su presupuesto y fechas.
SELECT id_proyecto, presupuesto, fecha_inicio, fecha_fin 
FROM proyecto_investigacion;

-- 26. Obtener el presupuesto total de todos los proyectos de investigación.
SELECT SUM(presupuesto) AS presupuesto_total 
FROM proyecto_investigacion;

-- 27. Listar los investigadores que han trabajado en cada proyecto.
SELECT p.nombre AS investigador, pi.id_proyecto
FROM investigador_proyecto ip
JOIN personal p ON ip.id_investigador = p.cedula
JOIN proyecto_investigacion pi ON ip.id_proyecto = pi.id_proyecto
order by pi.id_proyecto;

-- 28. Mostrar qué especies de tipo "animal" están siendo investigadas en cada proyecto.
SELECT pe.id_proyecto, e.denominacion_cientifica AS especie
FROM proyecto_especie pe
JOIN especie e ON pe.id_especie = e.id_especie
where e.tipo = "animal";

-- 29. Listar los parques y la cantidad de personal_Entradas que trabajan en ellos
SELECT pn.nombre AS parque, COUNT(p.cedula) AS cantidad_personal
FROM parque_natural pn
JOIN gestion_visitantes gv ON pn.id_parque = gv.id_parque
JOIN personal p ON gv.id_personalEntrada = p.cedula
GROUP BY pn.id_parque
ORDER BY cantidad_personal DESC;

-- 30. Mostrar los parques que tienen más de un tipo de especie registrada
SELECT pn.nombre AS parque, COUNT(DISTINCT e.tipo) AS cantidad_tipos_especies
FROM parque_natural pn
JOIN area a ON pn.id_parque = a.id_parque
JOIN area_especie ae ON a.id_area = ae.id_area
JOIN especie e ON ae.id_especie = e.id_especie
GROUP BY pn.id_parque
HAVING cantidad_tipos_especies > 1
ORDER BY cantidad_tipos_especies DESC;

-- 31. Obtener los visitantes que han estado en más de un parque y la cantidad de días que se han alojado
SELECT v.nombre, v.apellido1, v.apellido2, COUNT(DISTINCT e.id_alojamiento) AS cantidad_parques, SUM(DATEDIFF(e.fecha_salida, e.fecha_ingreso)) AS total_dias
FROM visitantes v
JOIN estancia e ON v.cedula = e.id_visitante
GROUP BY v.cedula
HAVING cantidad_parques > 1
ORDER BY total_dias DESC;

-- 32. Obtener el presupuesto total de los proyectos de investigación agrupados por especie
SELECT e.denominacion_cientifica AS especie, SUM(pi.presupuesto) AS presupuesto_total
FROM proyecto_investigacion pi
JOIN proyecto_especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN especie e ON pe.id_especie = e.id_especie
GROUP BY e.id_especie
ORDER BY presupuesto_total DESC;

-- 33. Listar las áreas con más de 50 individuos de especies animales
SELECT a.nombre AS area, e.denominacion_vulgar AS especie, ae.numero_individuos
FROM area a
JOIN area_especie ae ON a.id_area = ae.id_area
JOIN especie e ON ae.id_especie = e.id_especie
WHERE e.tipo = 'animal' AND ae.numero_individuos > 50
ORDER BY ae.numero_individuos DESC;

-- 34. Mostrar las entidades responsables y la cantidad de parques a su cargo
SELECT er.nombre AS entidad_responsable, COUNT(dp.id_parque) AS cantidad_parques
FROM entidad_responsable er
JOIN departamento d ON er.id_entidad = d.id_entidad
JOIN departamento_parque dp ON d.id_departamento = dp.id_departamento
GROUP BY er.id_entidad
ORDER BY cantidad_parques DESC;

-- 35. Obtener los departamentos que tienen parques con más de 50000 hectáreas
SELECT d.nombre AS departamento, pn.nombre AS parque, SUM(a.extension) AS extension_total_hectareas
FROM departamento d
JOIN departamento_parque dp ON d.id_departamento = dp.id_departamento
JOIN parque_natural pn ON dp.id_parque = pn.id_parque
JOIN area a ON pn.id_parque = a.id_parque
GROUP BY d.id_departamento, pn.id_parque
HAVING extension_total_hectareas > 50000
ORDER BY extension_total_hectareas DESC;

-- 36. Mostrar el personal que está a cargo de la vigilancia en áreas con vehículos
SELECT p.nombre, p.apellido1, p.apellido2, a.nombre AS area, gv.tipo_vehiculo
FROM personal p
JOIN gestion_vigilancia gv ON p.cedula = gv.id_personalVigilancia
JOIN area a ON gv.id_area = a.id_area
WHERE gv.tipo_vehiculo IS NOT NULL
ORDER BY p.nombre;

-- 37. Obtener los proyectos de investigación que están relacionados con especies vegetales
SELECT pi.id_proyecto, pi.presupuesto, e.denominacion_cientifica AS especie_vegetal
FROM proyecto_investigacion pi
JOIN proyecto_especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN especie e ON pe.id_especie = e.id_especie
WHERE e.tipo = 'vegetal'
ORDER BY pi.presupuesto DESC;

-- 38. Listar los parques con mayor cantidad de áreas:
SELECT pn.nombre, COUNT(a.id_area) AS total_areas
FROM parque_natural pn
JOIN area a ON pn.id_parque = a.id_parque
GROUP BY pn.id_parque
ORDER BY total_areas DESC;

-- 39. Mostrar el parque con la mayor extensión total:
SELECT pn.nombre, SUM(a.extension) AS total_extension
FROM parque_natural pn
JOIN area a ON pn.id_parque = a.id_parque
GROUP BY pn.id_parque
ORDER BY total_extension DESC
LIMIT 1;

-- 40. Departamentos con más de 3 parques:
SELECT d.nombre, COUNT(dp.id_parque) AS cantidad_parques
FROM departamento d
JOIN departamento_parque dp ON d.id_departamento = dp.id_departamento
GROUP BY d.id_departamento
HAVING cantidad_parques > 3;

-- 41. Especies con más de 200 individuos por área:
SELECT e.denominacion_cientifica, ae.numero_individuos
FROM especie e
JOIN area_especie ae ON e.id_especie = ae.id_especie
WHERE ae.numero_individuos > 200
ORDER BY ae.numero_individuos DESC;

-- 42. Parques con más especies vegetales:
SELECT pn.nombre, COUNT(DISTINCT e.id_especie) AS total_animales
FROM parque_natural pn
JOIN area a ON pn.id_parque = a.id_parque
JOIN area_especie ae ON a.id_area = ae.id_area
JOIN especie e ON ae.id_especie = e.id_especie
WHERE e.tipo = 'vegetal'
GROUP BY pn.id_parque
ORDER BY total_animales DESC;

-- 43. Personal con sueldo mayor al promedio:
SELECT nombre, apellido1, apellido2, sueldo
FROM personal
WHERE sueldo > (SELECT AVG(sueldo) FROM personal)
ORDER BY sueldo DESC;

-- 44. Personal de vigilancia con más de un vehículo asignado:
SELECT p.nombre, p.apellido1, COUNT(gv.tipo_vehiculo) AS total_vehiculos
FROM personal p
JOIN gestion_vigilancia gv ON p.cedula = gv.id_personalVigilancia
GROUP BY p.cedula
HAVING total_vehiculos > 5;

-- 45. Presupuesto promedio de los proyectos:
SELECT AVG(presupuesto) AS presupuesto_promedio
FROM proyecto_investigacion;

-- 46. Proyectos con especies animales involucradas:
SELECT pi.id_proyecto, e.denominacion_cientifica
FROM proyecto_investigacion pi
JOIN proyecto_especie pe ON pi.id_proyecto = pe.id_proyecto
JOIN especie e ON pe.id_especie = e.id_especie
WHERE e.tipo = 'animal';

-- 47. Visitantes con más de 2 estancias:
SELECT v.nombre, v.apellido1, COUNT(e.id_alojamiento) AS total_estancias
FROM visitantes v
JOIN estancia e ON v.cedula = e.id_visitante
GROUP BY v.cedula
HAVING total_estancias > 2;

-- 48. Ocupación total por categoría de alojamiento:
SELECT a.categoria, SUM(a.capacidad) AS total_capacidad
FROM alojamiento a
GROUP BY a.categoria
ORDER BY total_capacidad DESC;

-- 49. Parques con áreas con más de 500 individuos:
SELECT pn.nombre
FROM parque_natural pn
WHERE pn.id_parque IN (
    SELECT a.id_parque
    FROM area a
    JOIN area_especie ae ON a.id_area = ae.id_area
    GROUP BY a.id_area
    HAVING SUM(ae.numero_individuos) > 500
);

-- 50. Visitantes que se han alojado más de 5 días:
SELECT v.nombre, v.apellido1, DATEDIFF(e.fecha_salida, e.fecha_ingreso) AS dias
FROM visitantes v
JOIN estancia e ON v.cedula = e.id_visitante
WHERE DATEDIFF(e.fecha_salida, e.fecha_ingreso) > 5;

-- 51. Listar las especies con el menor número de individuos
SELECT e.denominacion_cientifica, ae.numero_individuos
FROM especie e
JOIN area_especie ae ON e.id_especie = ae.id_especie
ORDER BY ae.numero_individuos ASC
LIMIT 10;

-- 52. Investigadores asignados a más de un proyecto:
SELECT p.nombre, COUNT(ip.id_proyecto) AS cantidad_proyectos
FROM personal p
JOIN investigador_proyecto ip ON p.cedula = ip.id_investigador
GROUP BY p.cedula
HAVING cantidad_proyectos > 1;

-- 53. Total de sueldos por tipo de personal:
SELECT tipo_personal, SUM(sueldo) AS total_sueldo
FROM personal
GROUP BY tipo_personal
ORDER BY total_sueldo DESC;

-- 54. Mostrar el nombre del parque y la cantidad de vehículos de vigilancia que tiene
SELECT pn.nombre AS parque, COUNT(gv.tipo_vehiculo) AS total_vehiculos
FROM parque_natural pn
JOIN area a ON pn.id_parque = a.id_parque
JOIN gestion_vigilancia gv ON a.id_area = gv.id_area
GROUP BY pn.id_parque
ORDER BY total_vehiculos DESC;

-- 55. Visitantes que se han alojado en más de una categoría:
SELECT v.nombre, COUNT(DISTINCT a.categoria) AS categorias
FROM visitantes v
JOIN estancia e ON v.cedula = e.id_visitante
JOIN alojamiento a ON e.id_alojamiento = a.id_alojamiento
GROUP BY v.cedula
HAVING categorias > 1;

-- 56. Listar los proyectos que duran más de 2 años
SELECT id_proyecto, fecha_inicio, fecha_fin, DATEDIFF(fecha_fin, fecha_inicio) AS duracion_dias
FROM proyecto_investigacion
WHERE DATEDIFF(fecha_fin, fecha_inicio) > 730;

-- 57. Listar los visitantes que se han alojado en más de un parque
SELECT v.nombre, v.apellido1, COUNT(DISTINCT a.id_parque) AS parques_visitados
FROM visitantes v
JOIN estancia e ON v.cedula = e.id_visitante
JOIN alojamiento a ON e.id_alojamiento = a.id_alojamiento
GROUP BY v.cedula
HAVING parques_visitados > 1;

-- 58. Listar los alojamientos con mayor capacidad en cada parque
SELECT a.id_alojamiento, pn.nombre AS parque, a.capacidad
FROM alojamiento a
JOIN parque_natural pn ON a.id_parque = pn.id_parque
WHERE a.capacidad = (SELECT MAX(capacidad) FROM alojamiento WHERE id_parque = pn.id_parque);

-- 59. Contar cuántos parques tienen más de 5 áreas
SELECT COUNT(*) AS parques_con_mas_de_5_areas
FROM (
    SELECT pn.id_parque
    FROM parque_natural pn
    JOIN area a ON pn.id_parque = a.id_parque
    GROUP BY pn.id_parque
    HAVING COUNT(a.id_area) > 5
) subquery;

-- 60. Mostrar los parques donde hay más de 3 tipos de especies diferentes
SELECT pn.nombre AS parque, COUNT(DISTINCT e.tipo) AS tipos_especies
FROM parque_natural pn
JOIN area a ON pn.id_parque = a.id_parque
JOIN area_especie ae ON a.id_area = ae.id_area
JOIN especie e ON ae.id_especie = e.id_especie
GROUP BY pn.id_parque
HAVING tipos_especies > 3;

-- 61. Mostrar el parque con mayor número de visitantes en el último año
SELECT pn.nombre AS parque, COUNT(e.id_visitante) AS total_visitantes
FROM parque_natural pn
JOIN alojamiento a ON pn.id_parque = a.id_parque
JOIN estancia e ON a.id_alojamiento = e.id_alojamiento
WHERE YEAR(e.fecha_ingreso) = YEAR(CURDATE())
GROUP BY pn.id_parque
ORDER BY total_visitantes DESC
LIMIT 1;

-- 62. Obtener los parques con más de 2 proyectos de investigación activos
SELECT pn.nombre AS parque, COUNT(pi.id_proyecto) AS proyectos_activos
FROM parque_natural pn
JOIN area a ON pn.id_parque = a.id_parque
JOIN proyecto_investigacion pi ON a.id_area = pi.id_proyecto
WHERE pi.fecha_fin > CURDATE()
GROUP BY pn.id_parque
HAVING proyectos_activos > 1;

-- 63. Mostrar el visitante que ha pasado más días en parques
SELECT v.nombre, v.apellido1, SUM(DATEDIFF(e.fecha_salida, e.fecha_ingreso)) AS total_dias
FROM visitantes v
JOIN estancia e ON v.cedula = e.id_visitante
GROUP BY v.cedula
ORDER BY total_dias DESC
LIMIT 1;

-- 64. Estado actual de parques: cantidad por departamento y superficies declaradas
SELECT 
    d.nombre AS departamento,
    COUNT(dp.id_parque) AS cantidad_parques,
    COALESCE(SUM(a.extension), 0) AS superficie_total
FROM departamento d
LEFT JOIN departamento_parque dp ON d.id_departamento = dp.id_departamento
LEFT JOIN area a ON dp.id_parque = a.id_parque
GROUP BY d.nombre
ORDER BY cantidad_parques DESC, superficie_total DESC;

-- 65. Inventarios de especies por áreas y tipos
SELECT 
    e.tipo,
    a.nombre AS nombre_area,
    SUM(ae.numero_individuos) AS total_especies
FROM area_especie ae
JOIN especie e ON ae.id_especie = e.id_especie
JOIN area a ON ae.id_area = a.id_area
GROUP BY e.tipo, a.nombre
ORDER BY e.tipo, total_especies DESC;

-- 66. Actividades del personal según tipo, áreas asignadas y sueldos
SELECT 
    p.tipo_personal,
    COUNT(DISTINCT gc.id_personalConservacion) AS cantidad_conservacion,
    COUNT(DISTINCT gv.id_personalVigilancia) AS cantidad_vigilancia,
    ROUND(AVG(p.sueldo), 2) AS sueldo_promedio
FROM personal p
LEFT JOIN gestion_conservacion gc ON p.cedula = gc.id_personalConservacion
LEFT JOIN gestion_vigilancia gv ON p.cedula = gv.id_personalVigilancia
GROUP BY p.tipo_personal
ORDER BY sueldo_promedio DESC;

-- 67. Estadísticas de proyectos de investigación: costos, especies involucradas y equipos
SELECT 
    pi.id_proyecto,
    COUNT(DISTINCT pe.id_especie) AS especies_involucradas,
    COUNT(DISTINCT ip.id_investigador) AS cantidad_investigadores,
    ROUND(AVG(pi.presupuesto), 2) AS presupuesto_promedio
FROM proyecto_investigacion pi
LEFT JOIN proyecto_especie pe ON pi.id_proyecto = pe.id_proyecto
LEFT JOIN investigador_proyecto ip ON pi.id_proyecto = ip.id_proyecto
GROUP BY pi.id_proyecto
HAVING COUNT(DISTINCT pe.id_especie) > 1
ORDER BY presupuesto_promedio DESC;

-- 68. Gestión de visitantes y ocupación de alojamientos
SELECT 
    v.profesion,
    COUNT(DISTINCT e.id_visitante) AS total_visitantes,
    COUNT(DISTINCT e.id_alojamiento) AS alojamientos_usados,
    ROUND(AVG(DATEDIFF(e.fecha_salida, e.fecha_ingreso)), 1) AS promedio_estadia
FROM visitantes v
LEFT JOIN estancia e ON v.cedula = e.id_visitante
GROUP BY v.profesion
ORDER BY total_visitantes DESC, promedio_estadia DESC;

-- 69. Parque con más conservación activa
SELECT p.nombre, COUNT(gc.id_area) AS areas_conservadas
FROM parque_natural p
JOIN area a ON p.id_parque = a.id_parque
JOIN gestion_conservacion gc ON a.id_area = gc.id_area
GROUP BY p.nombre
ORDER BY areas_conservadas DESC
LIMIT 1;

-- 70. ¿Qué parque tiene más especies con nombre científico empezando con "A"?
SELECT p.nombre, COUNT(e.id_especie) AS total_especies
FROM parque_natural p
JOIN area a ON p.id_parque = a.id_parque
JOIN area_especie ae ON a.id_area = ae.id_area
JOIN especie e ON ae.id_especie = e.id_especie
WHERE e.denominacion_cientifica LIKE 'A%'
GROUP BY p.nombre
ORDER BY total_especies DESC
LIMIT 1;

-- 71. Buscar en qué parques ha trabajado un empleado con cédula específica en la gestión de visitantes
SELECT p.nombre AS parque, g.id_personalEntrada 
FROM gestion_visitantes g
JOIN parque_natural p ON g.id_parque = p.id_parque
WHERE g.id_personalEntrada = '1004512349';

-- 72. Obtener la cantidad de individuos de una especie específica en un área determinada
SELECT ae.numero_individuos, e.denominacion_cientifica, a.nombre AS area 
FROM area_especie ae
JOIN especie e ON ae.id_especie = e.id_especie
JOIN area a ON ae.id_area = a.id_area
WHERE ae.id_especie = 7 AND ae.id_area = 2;

-- 73. Buscar visitantes que han estado en un alojamiento en una fecha específica
SELECT v.nombre, v.apellido1, v.apellido2, e.fecha_ingreso, e.fecha_salida 
FROM estancia e
JOIN visitantes v ON e.id_visitante = v.cedula
WHERE '2025-03-01' BETWEEN e.fecha_ingreso AND e.fecha_salida;

-- 74. Encontrar los visitantes que estuvieron en un alojamiento en marzo de 2025
SELECT v.nombre, v.apellido1, e.fecha_ingreso, e.fecha_salida 
FROM estancia e
JOIN visitantes v ON e.id_visitante = v.cedula
WHERE e.fecha_ingreso BETWEEN '2025-03-01' AND '2025-03-28';

-- 75. Convertir los nombres de los visitantes en mayúsculas
SELECT UPPER(nombre) AS nombre_mayusculas, UPPER(apellido1) AS apellido_mayusculas 
FROM visitantes;

-- 76. Convertir los nombres de los parques en minúsculas
SELECT LOWER(nombre) AS parque_minusculas 
FROM parque_natural;

-- 77. Concatenar nombres y apellidos de los visitantes en un solo campo
SELECT CONCAT(nombre, ' ', apellido1, ' ', apellido2) AS nombre_completo 
FROM visitantes;

-- 78. Extraer las primeras tres letras del nombre de cada visitante
SELECT nombre, LEFT(nombre, 3) AS iniciales 
FROM visitantes;

-- 79. Extraer los últimos 4 caracteres del documento de los visitantes
SELECT cedula, RIGHT(cedula, 4) AS ultimos_digitos 
FROM visitantes;

-- 80. Extraer el mes y día de la fecha de ingreso de los visitantes
SELECT nombre, MONTH(fecha_ingreso) AS mes_ingreso, DAY(fecha_ingreso) AS dia_ingreso 
FROM estancia 
JOIN visitantes ON estancia.id_visitante = visitantes.cedula;

-- 81. Extraer los ultimos 8 caracteres del nombre de los parques
SELECT nombre, RIGHT(nombre, 8) AS abreviatura 
FROM parque_natural;

-- 82. Obtener los 3 caracteres centrales de cada nombre de especie (ajustado a nombres largos)
SELECT denominacion_cientifica, 
       SUBSTRING(denominacion_cientifica, (CHAR_LENGTH(denominacion_cientifica)/2)-1, 3) AS central 
FROM especie;

-- 83. Obtener la última palabra del nombre completo de cada visitante
SELECT nombre, apellido1, apellido2, 
       SUBSTRING_INDEX(CONCAT(nombre, ' ', apellido1, ' ', apellido2), ' ', -1) AS ultima_palabra
FROM visitantes;

-- 84. Reemplazar guiones por espacios en los nombres de los parques
SELECT nombre, REPLACE(nombre, '-', ' ') AS nombre_limpio 
FROM parque_natural;

-- 85. Reemplazar la palabra 'RESERVA' por 'PARQUE' en los nombres de los parques
SELECT nombre, REPLACE(nombre, 'Reserva', 'Parque') AS nuevo_nombre 
FROM parque_natural;

-- 86. Seleccionar los visitantes cuyo apellido comienza con 'G'
SELECT * 
FROM visitantes 
WHERE apellido1 LIKE 'G%';

-- 87. Seleccionar los visitantes cuyo nombre contiene la letra 'z'
SELECT * 
FROM visitantes 
WHERE nombre LIKE '%z%';

-- 88. Contar cuántos visitantes tienen nombres con más de 6 caracteres
SELECT COUNT(*) AS visitantes_nombres_largos 
FROM visitantes 
WHERE CHAR_LENGTH(nombre) > 6;

-- 89. Mostrar las especies con nombres científicos de más de 20 caracteres
SELECT denominacion_cientifica 
FROM especie 
WHERE CHAR_LENGTH(denominacion_cientifica) > 20;

-- 90.  Mostrar visitantes cuyo nombre termina en 'o'
SELECT * 
FROM visitantes 
WHERE nombre LIKE '%o';

-- 91. Generar un alias para los visitantes usando las tres primeras letras del nombre y las tres últimas de la cédula
SELECT nombre, cedula, 
       CONCAT(LEFT(nombre, 3), RIGHT(cedula, 3)) AS alias 
FROM visitantes;

-- 92. Obtener una versión invertida de los nombres de los visitantes
SELECT nombre, REVERSE(nombre) AS nombre_invertido 
FROM visitantes;

-- 93. Contar cuántos visitantes tienen nombres que contienen más de una 'a'
SELECT COUNT(*) AS visitantes_con_multiples_a 
FROM visitantes 
WHERE CHAR_LENGTH(nombre) - CHAR_LENGTH(REPLACE(nombre, 'a', '')) > 1;

-- 94.  Obtener el nombre del visitante con el apellido más largo
SELECT nombre, apellido1, apellido2 
FROM visitantes 
ORDER BY CHAR_LENGTH(apellido1) DESC 
LIMIT 1;

-- 95. Generar correos electrónicos ficticios para los visitantes basados en su nombre y cédula
SELECT nombre, cedula, 
       CONCAT(LOWER(nombre), '.', RIGHT(cedula, 4), '@parques.com') AS email_generado 
FROM visitantes;

-- 96. Listar visitantes con nombres en los que todas las vocales han sido reemplazadas por '*'
SELECT nombre, 
       REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(nombre, 'a', '*'), 'e', '*'), 'i', '*'), 'o', '*'), 'u', '*') AS nombre_censurado 
FROM visitantes;

-- 97. Mostrar visitantes con un resumen de su cédula enmascarada (ejemplo: '1095******')
SELECT cedula, 
       CONCAT(LEFT(cedula, 4), '******') AS cedula_oculta 
FROM visitantes;

-- 98. Mostrar visitantes cuyo nombre sea un palíndromo
SELECT nombre 
FROM visitantes 
WHERE nombre = REVERSE(nombre);

-- 99. Generación de una Clave Única para cada Visitante con Formato Especial
SELECT 
    nombre, 
    cedula, 
    fecha_ingreso,
    CONCAT(
        UPPER(LEFT(nombre, 3)), '-', 
        RIGHT(cedula, 2), '-', 
        (CHAR_LENGTH(nombre) - CHAR_LENGTH(REPLACE(LOWER(nombre), 'a', '')) 
                           - CHAR_LENGTH(REPLACE(LOWER(nombre), 'e', '')) 
                           - CHAR_LENGTH(REPLACE(LOWER(nombre), 'i', '')) 
                           - CHAR_LENGTH(REPLACE(LOWER(nombre), 'o', '')) 
                           - CHAR_LENGTH(REPLACE(LOWER(nombre), 'u', ''))), '-',
        CASE MONTH(fecha_ingreso)
            WHEN 1 THEN 'ENE'
            WHEN 2 THEN 'FEB'
            WHEN 3 THEN 'MAR'
            WHEN 4 THEN 'ABR'
            WHEN 5 THEN 'MAY'
            WHEN 6 THEN 'JUN'
            WHEN 7 THEN 'JUL'
            WHEN 8 THEN 'AGO'
            WHEN 9 THEN 'SEP'
            WHEN 10 THEN 'OCT'
            WHEN 11 THEN 'NOV'
            WHEN 12 THEN 'DIC'
        END
    ) AS clave_unica
FROM visitantes 
JOIN estancia ON estancia.id_visitante = visitantes.cedula;

-- 100. Creación de un Nombre de Usuario Único para Visitantes
WITH base AS (
    SELECT 
        nombre, 
        apellido1, 
        cedula, 
        LOWER(CONCAT(
            LEFT(nombre, 2), 
            RIGHT(apellido1, 1), 
            RIGHT(cedula, 2), 
            CHAR_LENGTH(CONCAT(nombre, ' ', apellido1, ' ', apellido2))
        )) AS username_base
    FROM visitantes
)
SELECT 
    base.*, 
    CONCAT(username_base, 
           (SELECT COUNT(*) FROM visitantes v2 
            WHERE LOWER(CONCAT(LEFT(v2.nombre, 2), RIGHT(v2.apellido1, 1), RIGHT(v2.cedula, 2), CHAR_LENGTH(CONCAT(v2.nombre, ' ', v2.apellido1, ' ', v2.apellido2)))) = base.username_base)
    ) AS username_final
FROM base;




