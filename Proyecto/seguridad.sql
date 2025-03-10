use parques_db;

-- Crear los roles
CREATE ROLE 'Administrador';
CREATE ROLE 'Gestor_de_parques';
CREATE ROLE 'Investigador';
CREATE ROLE 'Auditor';
CREATE ROLE 'Encargado_de_visitantes';

-- Crear los usuarios
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'admin_password';
CREATE USER 'gestor_parques_user'@'localhost' IDENTIFIED BY 'gestor_parques_password';
CREATE USER 'investigador_user'@'localhost' IDENTIFIED BY 'investigador_password';
CREATE USER 'auditor_user'@'localhost' IDENTIFIED BY 'auditor_password';
CREATE USER 'encargado_visitantes_user'@'localhost' IDENTIFIED BY 'encargado_visitantes_password';

-- Asignar roles a los usuarios
GRANT 'Administrador' TO 'admin_user'@'localhost';
GRANT 'Gestor_de_parques' TO 'gestor_parques_user'@'localhost';
GRANT 'Investigador' TO 'investigador_user'@'localhost';
GRANT 'Auditor' TO 'auditor_user'@'localhost';
GRANT 'Encargado_de_visitantes' TO 'encargado_visitantes_user'@'localhost';

-- Asignar privilegios de administrador
GRANT ALL PRIVILEGES ON *.* TO 'Administrador' WITH GRANT OPTION;

-- Asignar privilegios al gestor de parques
GRANT SELECT, INSERT, UPDATE, DELETE ON parques_db.parque_natural TO 'Gestor_de_parques';
GRANT SELECT, INSERT, UPDATE, DELETE ON parques_db.area TO 'Gestor_de_parques';
GRANT SELECT, INSERT, UPDATE, DELETE ON parques_db.especie TO 'Gestor_de_parques';

-- Asignar privilegios al investigador
GRANT SELECT ON parques_db.proyecto_investigacion TO 'Investigador';
GRANT SELECT ON parques_db.especie TO 'Investigador';

-- Asignar privilegios al auditor
GRANT SELECT ON parques_db.proyecto_investigacion TO 'Auditor';
GRANT SELECT ON parques_db.gestion_visitantes TO 'Auditor';

-- Asignar privilegios al encargado de visitantes
GRANT SELECT, INSERT, UPDATE, DELETE ON parques_db.visitantes TO 'Encargado_de_visitantes';
GRANT SELECT, INSERT, UPDATE, DELETE ON parques_db.alojamiento TO 'Encargado_de_visitantes';

-- Habilitar los roles
SET DEFAULT ROLE 'Administrador' TO 'admin_user'@'localhost';
SET DEFAULT ROLE 'Gestor_de_parques' TO 'gestor_parques_user'@'localhost';
SET DEFAULT ROLE 'Investigador' TO 'investigador_user'@'localhost';
SET DEFAULT ROLE 'Auditor' TO 'auditor_user'@'localhost';
SET DEFAULT ROLE 'Encargado_de_visitantes' TO 'encargado_visitantes_user'@'localhost';

SHOW GRANTS FOR 'admin_user'@'localhost';
SHOW GRANTS FOR 'gestor_parques_user'@'localhost';
SHOW GRANTS FOR 'investigador_user'@'localhost';
SHOW GRANTS FOR 'auditor_user'@'localhost';
SHOW GRANTS FOR 'encargado_visitantes_user'@'localhost';




