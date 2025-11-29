# Cursito-DB

Sistema de gestión de base de datos para el control de cursos, trabajadores, inscripciones, asistencias y encuestas.

## Descripción del Proyecto

Cursito-DB es un sistema de base de datos diseñado para gestionar de manera integral cursos de formación y actualización docente, incluyendo:

- Gestión de trabajadores y departamentos
- Administración de periodos y cursos
- Control de inscripciones y asistencias
- Sistema de encuestas y respuestas
- Relación de instructores con cursos

## Estructura de la Base de Datos

El sistema cuenta con las siguientes tablas principales:

- **departments**: Almacena los departamentos de la institución
- **periods**: Define los periodos académicos de los cursos
- **surveys**: Gestiona las encuestas de evaluación
- **workers**: Información de los trabajadores (docentes y personal administrativo)
- **courses**: Detalles de los cursos ofertados
- **questions**: Preguntas asociadas a las encuestas
- **instructors**: Relación muchos a muchos entre trabajadores y cursos (como instructores)
- **enrollings**: Inscripciones de trabajadores a cursos
- **attendances**: Registro de asistencias de trabajadores a cursos
- **answers**: Respuestas de trabajadores a encuestas de cursos

## Requisitos Previos

### Para PostgreSQL
- PostgreSQL 12 o superior
- Permisos de superusuario para crear bases de datos y usuarios

### Para MySQL
- MySQL 8.0 o superior
- Permisos de root para crear bases de datos y usuarios

## Instalación y Despliegue

### Opción 1: PostgreSQL

#### 1. Crear el usuario cursito

```bash
# Acceder a PostgreSQL como superusuario
psql -U postgres

# Crear el usuario cursito con contraseña
CREATE USER cursito WITH PASSWORD 'tu_contraseña_segura';
```

#### 2. Crear la base de datos

```sql
# Crear la base de datos
CREATE DATABASE cursito;

# Cambiar el propietario de la base de datos al usuario cursito
ALTER DATABASE cursito OWNER TO cursito;
```

#### 3. Asignar permisos

```sql
# Conceder todos los privilegios en la base de datos cursito al usuario cursito
GRANT ALL PRIVILEGES ON DATABASE cursito TO cursito;

# Conectarse a la base de datos cursito
\c cursito

# Otorgar permisos sobre el esquema public
GRANT ALL ON SCHEMA public TO cursito;

# Otorgar permisos para crear tablas
GRANT CREATE ON SCHEMA public TO cursito;

# Salir de PostgreSQL
\q
```

#### 4. Ejecutar el esquema

```bash
# Conectarse como usuario cursito y ejecutar el esquema
psql -U cursito -d cursito -f src/pg_schema.sql
```

#### 5. Cargar datos desde CSV

```bash
# Conectarse a la base de datos
psql -U cursito -d cursito
```

```sql
-- Cargar departamentos
COPY departments(id, name)
FROM 'C:/Users/kevin/cursito-project/cursito-db/csv/department.csv'
DELIMITER ','
CSV HEADER;

-- Cargar periodos
COPY periods(id, name, start_date, end_date)
FROM 'C:/Users/kevin/cursito-project/cursito-db/csv/period.csv'
DELIMITER ','
CSV HEADER;

-- Cargar encuestas
COPY surveys(id, name, created_at)
FROM 'C:/Users/kevin/cursito-project/cursito-db/csv/surveys.csv'
DELIMITER ','
CSV HEADER;

-- Cargar trabajadores
COPY workers(id, department_id, rfc, curp, sex, telephone, email, password, name, father_surname, mother_surname, position)
FROM 'C:/Users/kevin/cursito-project/cursito-db/csv/worker.csv'
DELIMITER ','
CSV HEADER;

-- Cargar cursos
COPY courses(id, period_id, target, name, start_date, end_date, start_time, end_time, course_type, modality, course_profile, goal, details)
FROM 'C:/Users/kevin/cursito-project/cursito-db/csv/course.csv'
DELIMITER ','
CSV HEADER;

-- Cargar preguntas
COPY questions(id, survey_id, question, question_order)
FROM 'C:/Users/kevin/cursito-project/cursito-db/csv/questions.csv'
DELIMITER ','
CSV HEADER;

-- Cargar instructores
COPY instructors(id, worker_id, course_id)
FROM 'C:/Users/kevin/cursito-project/cursito-db/csv/instructors.csv'
DELIMITER ','
CSV HEADER;

-- Cargar inscripciones
COPY enrollings(id, worker_id, course_id, final_grade)
FROM 'C:/Users/kevin/cursito-project/cursito-db/csv/enrollings.csv'
DELIMITER ','
CSV HEADER;

-- Cargar asistencias
COPY attendances(id, worker_id, course_id, attendance_date)
FROM 'C:/Users/kevin/cursito-project/cursito-db/csv/attendances.csv'
DELIMITER ','
CSV HEADER;
```

**Nota para Windows**: Asegúrate de usar la ruta completa con formato Windows en los comandos COPY. Si estás en Linux/Mac, ajusta las rutas según corresponda.

**Alternativa usando rutas relativas**: Primero coloca los archivos CSV en una ubicación accesible por PostgreSQL (por ejemplo, `/tmp` en Linux o `C:\temp` en Windows).

#### 6. Verificar la carga de datos

```sql
-- Verificar que se hayan cargado los datos
SELECT COUNT(*) FROM departments;
SELECT COUNT(*) FROM periods;
SELECT COUNT(*) FROM workers;
SELECT COUNT(*) FROM courses;
```

### Opción 2: MySQL

#### 1. Crear el usuario cursito

```bash
# Acceder a MySQL como root
mysql -u root -p
```

```sql
# Crear el usuario cursito con contraseña
CREATE USER 'cursito'@'localhost' IDENTIFIED BY 'tu_contraseña_segura';

# Si necesitas acceso remoto, también crea:
CREATE USER 'cursito'@'%' IDENTIFIED BY 'tu_contraseña_segura';
```

#### 2. Crear la base de datos y asignar permisos

```sql
# Crear la base de datos
CREATE DATABASE cursito;

# Conceder todos los privilegios
GRANT ALL PRIVILEGES ON cursito.* TO 'cursito'@'localhost';

# Si creaste el usuario remoto, también otorga permisos:
GRANT ALL PRIVILEGES ON cursito.* TO 'cursito'@'%';

# Aplicar los cambios
FLUSH PRIVILEGES;

# Salir de MySQL
EXIT;
```

#### 3. Ejecutar el esquema

```bash
# Conectarse como usuario cursito y ejecutar el esquema
mysql -u cursito -p cursito < src/mysql_schema.sql
```

#### 4. Cargar datos desde CSV

```bash
# Conectarse a la base de datos
mysql -u cursito -p cursito
```

```sql
-- Permitir carga de archivos locales (si es necesario)
SET GLOBAL local_infile = 1;

-- Cargar departamentos
LOAD DATA LOCAL INFILE 'C:/Users/kevin/cursito-project/cursito-db/csv/department.csv'
INTO TABLE departments
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, name);

-- Cargar periodos
LOAD DATA LOCAL INFILE 'C:/Users/kevin/cursito-project/cursito-db/csv/period.csv'
INTO TABLE periods
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, name, start_date, end_date);

-- Cargar encuestas
LOAD DATA LOCAL INFILE 'C:/Users/kevin/cursito-project/cursito-db/csv/surveys.csv'
INTO TABLE surveys
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, name, created_at);

-- Cargar trabajadores
LOAD DATA LOCAL INFILE 'C:/Users/kevin/cursito-project/cursito-db/csv/worker.csv'
INTO TABLE workers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, department_id, rfc, curp, sex, telephone, email, password, name, father_surname, mother_surname, position);

-- Cargar cursos
LOAD DATA LOCAL INFILE 'C:/Users/kevin/cursito-project/cursito-db/csv/course.csv'
INTO TABLE courses
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, period_id, target, name, start_date, end_date, start_time, end_time, course_type, modality, course_profile, goal, details);

-- Cargar preguntas
LOAD DATA LOCAL INFILE 'C:/Users/kevin/cursito-project/cursito-db/csv/questions.csv'
INTO TABLE questions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, survey_id, question, question_order);

-- Cargar instructores
LOAD DATA LOCAL INFILE 'C:/Users/kevin/cursito-project/cursito-db/csv/instructors.csv'
INTO TABLE instructors
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, worker_id, course_id);

-- Cargar inscripciones
LOAD DATA LOCAL INFILE 'C:/Users/kevin/cursito-project/cursito-db/csv/enrollings.csv'
INTO TABLE enrollings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, worker_id, course_id, final_grade);

-- Cargar asistencias
LOAD DATA LOCAL INFILE 'C:/Users/kevin/cursito-project/cursito-db/csv/attendances.csv'
INTO TABLE attendances
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, worker_id, course_id, attendance_date);
```

**Nota**: Si encuentras errores con `LOAD DATA LOCAL INFILE`, asegúrate de conectarte con el flag `--local-infile=1`:

```bash
mysql --local-infile=1 -u cursito -p cursito
```

#### 5. Verificar la carga de datos

```sql
-- Verificar que se hayan cargado los datos
SELECT COUNT(*) FROM departments;
SELECT COUNT(*) FROM periods;
SELECT COUNT(*) FROM workers;
SELECT COUNT(*) FROM courses;
```

## Datos de Prueba

El proyecto incluye archivos CSV con datos de prueba precargados en el directorio [csv/](csv/):

- [department.csv](csv/department.csv) - 25 departamentos
- [period.csv](csv/period.csv) - 100 periodos académicos
- [surveys.csv](csv/surveys.csv) - Encuestas
- [worker.csv](csv/worker.csv) - Trabajadores
- [course.csv](csv/course.csv) - Cursos
- [questions.csv](csv/questions.csv) - Preguntas de encuestas
- [instructors.csv](csv/instructors.csv) - Relación instructores-cursos
- [enrollings.csv](csv/enrollings.csv) - Inscripciones
- [attendances.csv](csv/attendances.csv) - Asistencias

## Esquemas de Base de Datos

El proyecto proporciona esquemas para dos motores de bases de datos:

- [src/pg_schema.sql](src/pg_schema.sql) - Esquema para PostgreSQL
- [src/mysql_schema.sql](src/mysql_schema.sql) - Esquema para MySQL

### Diferencias principales entre esquemas:

| Característica | PostgreSQL | MySQL |
|----------------|------------|-------|
| Tipo UUID | `UUID` con `gen_random_uuid()` | `CHAR(36)` con `UUID()` |
| Tipo entero pequeño | `SMALLINT` | `TINYINT` |
| Fecha actual | `CURRENT_DATE` | `CURRENT_DATE` (envuelto en función) |

## Catálogos de Valores

### Sexo (sex)
- `0` - Mujer
- `1` - Hombre

### Posición (position)
- `0` - Docente
- `1` - Jefe de departamento

### Tipo de Curso (course_type)
- `0` - Diplomado
- `1` - Taller

### Modalidad (modality)
- `0` - Virtual
- `1` - Presencial

### Perfil del Curso (course_profile)
- `0` - Formación
- `1` - Actualización docente

## Diagrama Entidad-Relación (E-R)

<!-- Agregar imagen del diagrama E-R aquí -->

![Diagrama E-R](docs/entity-relationship.svg)

## Diagrama Relacional

<!-- Agregar imagen del diagrama relacional aquí -->

![Diagrama Relacional](docs/Relational.svg)

## Estructura de Directorios

```
cursito-db/
├── src/
│   ├── pg_schema.sql       # Esquema para PostgreSQL
│   └── mysql_schema.sql    # Esquema para MySQL
├── csv/
│   ├── department.csv      # Datos de departamentos
│   ├── period.csv          # Datos de periodos
│   ├── surveys.csv         # Datos de encuestas
│   ├── worker.csv          # Datos de trabajadores
│   ├── course.csv          # Datos de cursos
│   ├── questions.csv       # Preguntas de encuestas
│   ├── instructors.csv     # Relación instructores-cursos
│   ├── enrollings.csv      # Inscripciones
│   └── attendances.csv     # Asistencias
└── README.md               # Este archivo
```

## Seguridad

### Recomendaciones de Seguridad

1. **Contraseñas**: Usa contraseñas seguras para el usuario `cursito` en producción
2. **Hashing de contraseñas**: Las contraseñas en la tabla `workers` deben almacenarse usando un algoritmo de hashing seguro (bcrypt, argon2, etc.)
3. **Conexiones SSL/TLS**: Configura conexiones cifradas entre la aplicación y la base de datos
4. **Permisos mínimos**: En producción, revisa y ajusta los permisos del usuario según las necesidades reales
5. **Backups**: Implementa una estrategia de respaldos regulares

## Mantenimiento

### Respaldos en PostgreSQL

```bash
# Crear respaldo completo
pg_dump -U cursito -d cursito -F c -f cursito_backup.dump

# Restaurar respaldo
pg_restore -U cursito -d cursito cursito_backup.dump
```

### Respaldos en MySQL

```bash
# Crear respaldo completo
mysqldump -u cursito -p cursito > cursito_backup.sql

# Restaurar respaldo
mysql -u cursito -p cursito < cursito_backup.sql
```

## Solución de Problemas

### Error: Permission denied al cargar CSV

**PostgreSQL**: Asegúrate de que el usuario PostgreSQL tenga permisos de lectura sobre los archivos CSV o copia los archivos a una ubicación accesible.

**MySQL**: Verifica que `local_infile` esté habilitado y que te conectes con el flag `--local-infile=1`.

### Error: Cannot find file

Verifica que las rutas de los archivos CSV sean absolutas y correctas para tu sistema operativo.

### Error: Duplicate key

Si intentas cargar datos que ya existen, primero limpia las tablas:

```sql
-- PostgreSQL
TRUNCATE TABLE attendances, enrollings, instructors, questions, courses, workers, surveys, periods, departments CASCADE;

-- MySQL
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE attendances;
TRUNCATE TABLE enrollings;
TRUNCATE TABLE instructors;
TRUNCATE TABLE questions;
TRUNCATE TABLE courses;
TRUNCATE TABLE workers;
TRUNCATE TABLE surveys;
TRUNCATE TABLE periods;
TRUNCATE TABLE departments;
SET FOREIGN_KEY_CHECKS = 1;
```

## Licencia

[Especificar licencia del proyecto]

## Contribuciones

[Instrucciones para contribuir al proyecto]

## Contacto

[Información de contacto del equipo]
