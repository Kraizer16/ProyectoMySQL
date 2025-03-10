# ProyectoMySQL

# Proyecto: Gestión de Parques Naturales

## Descripción del Proyecto

El proyecto tiene como objetivo diseñar y desarrollar una base de datos que permita gestionar eficientemente las operaciones relacionadas con los parques naturales bajo la supervisión del Ministerio del Medio Ambiente. El sistema abarca la administración de departamentos, parques, áreas, especies, personal, proyectos de investigación, visitantes y alojamientos. Su propósito es proporcionar una solución robusta, optimizada y capaz de facilitar consultas críticas para la toma de decisiones.

### Funcionalidades Implementadas

1. **Gestión de Parques y Áreas**: Incluye la administración de parques naturales, sus áreas y las entidades responsables de la gestión de los mismos.
2. **Gestión de Especies**: Almacenamiento de especies, clasificadas en vegetales, animales y minerales, y su asignación a diferentes áreas de los parques.
3. **Gestión del Personal**: Registro y seguimiento del personal involucrado en la gestión de los parques, incluyendo personal de gestión, vigilancia, conservación e investigación.
4. **Proyectos de Investigación**: Gestión de proyectos de investigación sobre especies y su relación con el personal investigador.
5. **Gestión de Visitantes y Alojamientos**: Administración de los visitantes, registro de estancias y gestión de alojamientos dentro de los parques.

---

## Requisitos del Sistema

Para ejecutar los scripts y trabajar con la base de datos, es necesario contar con:

- **MySQL** versión 5.7 o superior.
- **Cliente MySQL** (por ejemplo, MySQL Workbench, DBeaver, etc.).
- **Herramientas**: Herramientas para ejecutar consultas SQL y gestionar bases de datos.

---

## Instalación y Configuración

### Paso 1: Crear la base de datos

Ejecuta el archivo `ddl.sql` para crear la estructura de la base de datos. Este archivo contiene todas las instrucciones necesarias para crear las tablas y establecer las relaciones entre ellas.

```bash
mysql -u root -p < ddl.sql
```

### Paso 2: Cargar datos iniciales

Una vez que la base de datos está configurada, utiliza el archivo dml.sql para insertar registros iniciales en las tablas de la base de datos.

```bash
mysql -u root -p < dml.sql
```

### Paso 3: Consultas y Scripts

Para ejecutar las consultas SQL, los procedimientos almacenados, las funciones, los triggers y los eventos, puedes usar los siguientes archivos:

- dql_select.sql — Consultas básicas y avanzadas.
- dql_procedimientos.sql — Procedimientos almacenados.
- dql_funciones.sql — Funciones SQL.
-  ql_triggers.sql — Triggers SQL.
- dql_eventos.sql — Eventos automáticos.
  
## Estructura de la Base de Datos

La base de datos parques_db contiene las siguientes tablas:

- entidad_responsable: Información de las entidades responsables de la gestión de parques.
- departamento: Departamentos donde se encuentran los parques naturales.
- parque_natural: Parques naturales registrados.
- departamento_parque: Relación muchos a muchos entre departamentos y parques.
- area: Áreas dentro de los parques.
- personal: Información sobre el personal trabajando en los parques.
- gestion_visitantes: Registro de los visitantes y su relación con el personal.
- gestion_conservacion: Información sobre el personal encargado de la conservación de áreas.
- gestion_vigilancia: Registro del personal y vehículos responsables de la vigilancia.
- especie: Registro de las especies en el parque (vegetales, animales y minerales).
- area_especie: Relación entre áreas y especies.
- proyecto_investigacion: Información sobre proyectos de investigación en el parque.
- proyecto_especie: Relación entre proyectos y especies.
- investigador_proyecto: Registro de los investigadores asignados a los proyectos.
- visitantes: Información de los visitantes de los parques.
- alojamiento: Alojamiento disponible en los parques.
- estancia: Registro de la estancia de los visitantes en los alojamientos.
  
### Ejemplos de Consultas

#### Consulta 1: Obtener el número de parques por departamento
```sql
SELECT d.nombre AS Departamento, COUNT(p.id_parque) AS NumeroDeParques
FROM departamento d
JOIN departamento_parque dp ON d.id_departamento = dp.id_departamento
JOIN parque_natural p ON dp.id_parque = p.id_parque
GROUP BY d.id_departamento;
```
#### Consulta 2: Obtener el inventario de especies por área
```sql
SELECT a.nombre AS Area, e.denominacion_vulgar AS Especie, ae.numero_individuos
FROM area a
JOIN area_especie ae ON a.id_area = ae.id_area
JOIN especie e ON ae.id_especie = e.id_especie;
```

#### Consulta 3: Obtener el presupuesto total de los proyectos de investigación
```sql
SELECT SUM(p.presupuesto) AS PresupuestoTotal
FROM proyecto_investigacion p;
```

### Procedimientos, Funciones, Triggers y Eventos

- Procedimiento 1: Registro de nuevos parques
```sql
CREATE PROCEDURE registrar_parque(IN nombre_parque VARCHAR(100), IN fecha DATE)
BEGIN
    INSERT INTO parque_natural (nombre, fecha_declaracion) VALUES (nombre_parque, fecha);
END;
```

- Función 1: Calcular la superficie total de un parque
```sql
CREATE FUNCTION calcular_superficie_parque(id_parque INT) RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE superficie_total DECIMAL(10, 2);
    SELECT SUM(extension) INTO superficie_total
    FROM area
    WHERE id_parque = id_parque;
    RETURN superficie_total;
END;
```

- Trigger 1: Actualizar inventario de especies cuando se modifique un área
```sql
CREATE TRIGGER actualizar_inventario_especies
AFTER UPDATE ON area
FOR EACH ROW
BEGIN
    UPDATE area_especie SET numero_individuos = numero_individuos * 1.05
    WHERE id_area = NEW.id_area;
END;
```

### Roles de Usuario y Permisos

Se han definido los siguientes roles con permisos específicos:

- Administrador: Acceso total a todas las tablas y funcionalidades.
- Gestor de parques: Puede gestionar parques, áreas y especies.
- Investigador: Acceso a proyectos e investigación de especies.
- Auditor: Acceso a reportes financieros y de presupuesto.
- Encargado de visitantes: Gestión de visitantes y alojamiento.

## Conclusión
Este proyecto proporciona una solución eficiente para la gestión de parques naturales, facilitando la administración de parques, especies, personal y visitantes mediante una base de datos bien estructurada. Con consultas, procedimientos y triggers automatizados, el sistema optimiza el manejo de la información. Los roles de usuario permiten un control adecuado de permisos según las responsabilidades. Es una base sólida y escalable para futuras mejoras y desarrollos en la gestión de parques naturales.
