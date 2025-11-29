# Diccionario de Datos - Cursito-DB

Este documento describe la estructura detallada de todas las tablas en la base de datos del sistema Cursito.

---

## Tabla: departments

**Descripción**: Almacena la información de los departamentos de la institución educativa.

| Nombre Columna | Descripción | Tipo de Dato | Longitud | Dominio/Restricción | Tipo de Índice | Nullable |
|----------------|-------------|--------------|----------|---------------------|----------------|----------|
| id | Identificador único del departamento | UUID | - | UUID válido | PRIMARY KEY | NO |
| name | Nombre del departamento | VARCHAR | 100 | Cadena de texto | - | NO |

**Valores por defecto**:
- `id`: `gen_random_uuid()`

---

## Tabla: periods

**Descripción**: Almacena los periodos académicos durante los cuales se ofertan los cursos.

| Nombre Columna | Descripción | Tipo de Dato | Longitud | Dominio/Restricción | Tipo de Índice | Nullable |
|----------------|-------------|--------------|----------|---------------------|----------------|----------|
| id | Identificador único del periodo | UUID | - | UUID válido | PRIMARY KEY | NO |
| name | Nombre descriptivo del periodo | VARCHAR | 100 | Cadena de texto | - | NO |
| start_date | Fecha de inicio del periodo | DATE | - | Fecha válida (YYYY-MM-DD) | - | NO |
| end_date | Fecha de finalización del periodo | DATE | - | Fecha válida (YYYY-MM-DD) | - | NO |

**Valores por defecto**:
- `id`: `gen_random_uuid()`

**Restricciones de negocio**:
- La fecha de finalización (`end_date`) debe ser posterior a la fecha de inicio (`start_date`)

---

## Tabla: surveys

**Descripción**: Almacena las encuestas de evaluación que pueden aplicarse a los cursos.

| Nombre Columna | Descripción | Tipo de Dato | Longitud | Dominio/Restricción | Tipo de Índice | Nullable |
|----------------|-------------|--------------|----------|---------------------|----------------|----------|
| id | Identificador único de la encuesta | UUID | - | UUID válido | PRIMARY KEY | NO |
| name | Nombre de la encuesta | VARCHAR | 100 | Cadena de texto | - | NO |
| created_at | Fecha de creación de la encuesta | DATE | - | Fecha válida (YYYY-MM-DD) | - | NO |

**Valores por defecto**:
- `id`: `gen_random_uuid()`
- `created_at`: `CURRENT_DATE`

---

## Tabla: workers

**Descripción**: Almacena la información personal y laboral de los trabajadores de la institución, incluyendo docentes y personal administrativo.

| Nombre Columna | Descripción | Tipo de Dato | Longitud | Dominio/Restricción | Tipo de Índice | Nullable |
|----------------|-------------|--------------|----------|---------------------|----------------|----------|
| id | Identificador único del trabajador | UUID | - | UUID válido | PRIMARY KEY | NO |
| department_id | Referencia al departamento al que pertenece | UUID | - | UUID válido existente en `departments` | FOREIGN KEY | NO |
| rfc | Registro Federal de Contribuyentes | VARCHAR | 13 | Patrón RFC: `^[A-ZÑ&]{3,4}\d{6}[A-Z0-9]{3}$` | UNIQUE | NO |
| curp | Clave Única de Registro de Población | VARCHAR | 18 | Patrón CURP: `^[A-Z]{4}\d{6}[HM][A-Z]{5}[0-9A-Z]\d$` | UNIQUE | NO |
| sex | Sexo del trabajador | SMALLINT | - | 0 = Mujer, 1 = Hombre | - | NO |
| telephone | Número telefónico | VARCHAR | 10 | Patrón: `^\d{10}$` | - | SÍ |
| email | Correo electrónico institucional | VARCHAR | 64 | Patrón email: `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$` | UNIQUE | NO |
| password | Contraseña hasheada | VARCHAR | 255 | Hash (bcrypt, argon2, etc.) | - | NO |
| name | Nombre(s) del trabajador | VARCHAR | 45 | Cadena de texto | - | NO |
| father_surname | Apellido paterno | VARCHAR | 40 | Cadena de texto | - | NO |
| mother_surname | Apellido materno | VARCHAR | 40 | Cadena de texto | - | NO |
| position | Puesto del trabajador | SMALLINT | - | 0 = Docente, 1 = Jefe de departamento | - | NO |

**Valores por defecto**:
- `id`: `gen_random_uuid()`

**Relaciones**:
- `department_id` → `departments(id)` (FOREIGN KEY: fk_department)

**Restricciones de seguridad**:
- El campo `password` debe almacenar únicamente contraseñas hasheadas, nunca texto plano
- Se recomienda usar algoritmos como bcrypt, argon2 o PBKDF2

---

## Tabla: courses

**Descripción**: Almacena la información completa de los cursos ofertados, incluyendo detalles académicos, horarios y objetivos.

| Nombre Columna | Descripción | Tipo de Dato | Longitud | Dominio/Restricción | Tipo de Índice | Nullable |
|----------------|-------------|--------------|----------|---------------------|----------------|----------|
| id | Identificador único del curso | UUID | - | UUID válido | PRIMARY KEY | NO |
| period_id | Referencia al periodo académico | UUID | - | UUID válido existente en `periods` | FOREIGN KEY | NO |
| target | Público objetivo del curso | VARCHAR | 255 | Cadena de texto | - | NO |
| name | Nombre del curso | VARCHAR | 150 | Cadena de texto | - | NO |
| start_date | Fecha de inicio del curso | DATE | - | Fecha válida (YYYY-MM-DD) | - | NO |
| end_date | Fecha de finalización del curso | DATE | - | Fecha válida (YYYY-MM-DD) | - | NO |
| start_time | Hora de inicio de las sesiones | TIME | - | Hora válida (HH:MM:SS) | - | NO |
| end_time | Hora de finalización de las sesiones | TIME | - | Hora válida (HH:MM:SS) | - | NO |
| course_type | Tipo de curso | SMALLINT | - | 0 = Diplomado, 1 = Taller | - | NO |
| modality | Modalidad de impartición | SMALLINT | - | 0 = Virtual, 1 = Presencial | - | NO |
| course_profile | Perfil del curso | SMALLINT | - | 0 = Formación, 1 = Actualización docente | - | NO |
| goal | Objetivo del curso | TEXT | - | Cadena de texto sin límite | - | NO |
| details | Detalles adicionales del curso | TEXT | - | Cadena de texto sin límite | - | SÍ |

**Valores por defecto**:
- `id`: `gen_random_uuid()`

**Relaciones**:
- `period_id` → `periods(id)` (FOREIGN KEY: fk_period)

**Restricciones de negocio**:
- La fecha de finalización (`end_date`) debe ser posterior a la fecha de inicio (`start_date`)
- La hora de finalización (`end_time`) debe ser posterior a la hora de inicio (`start_time`)

---

## Tabla: questions

**Descripción**: Almacena las preguntas asociadas a cada encuesta, con un orden específico de presentación.

| Nombre Columna | Descripción | Tipo de Dato | Longitud | Dominio/Restricción | Tipo de Índice | Nullable |
|----------------|-------------|--------------|----------|---------------------|----------------|----------|
| id | Identificador único de la pregunta | UUID | - | UUID válido | PRIMARY KEY | NO |
| survey_id | Referencia a la encuesta | UUID | - | UUID válido existente en `surveys` | FOREIGN KEY | NO |
| question | Texto de la pregunta | VARCHAR | 255 | Cadena de texto | - | NO |
| question_order | Orden de presentación de la pregunta | SMALLINT | - | Número entero positivo | - | NO |

**Valores por defecto**:
- `id`: `gen_random_uuid()`

**Relaciones**:
- `survey_id` → `surveys(id)` (FOREIGN KEY: fk_survey)

**Restricciones de negocio**:
- El orden de las preguntas (`question_order`) debe ser único dentro de cada encuesta

---

## Tabla: instructors

**Descripción**: Tabla de relación muchos a muchos entre trabajadores y cursos. Indica qué trabajadores son instructores de qué cursos.

| Nombre Columna | Descripción | Tipo de Dato | Longitud | Dominio/Restricción | Tipo de Índice | Nullable |
|----------------|-------------|--------------|----------|---------------------|----------------|----------|
| id | Identificador único de la relación | UUID | - | UUID válido | PRIMARY KEY | NO |
| worker_id | Referencia al trabajador que es instructor | UUID | - | UUID válido existente en `workers` | FOREIGN KEY | NO |
| course_id | Referencia al curso impartido | UUID | - | UUID válido existente en `courses` | FOREIGN KEY | NO |

**Valores por defecto**:
- `id`: `gen_random_uuid()`

**Relaciones**:
- `worker_id` → `workers(id)` (FOREIGN KEY: fk_worker)
- `course_id` → `courses(id)` (FOREIGN KEY: fk_course)

**Restricciones de unicidad**:
- UNIQUE (`worker_id`, `course_id`): Un instructor solo puede estar asignado una vez al mismo curso

---

## Tabla: enrollings

**Descripción**: Gestiona las inscripciones de los trabajadores a los cursos y almacena su calificación final.

| Nombre Columna | Descripción | Tipo de Dato | Longitud | Dominio/Restricción | Tipo de Índice | Nullable |
|----------------|-------------|--------------|----------|---------------------|----------------|----------|
| id | Identificador único de la inscripción | UUID | - | UUID válido | PRIMARY KEY | NO |
| worker_id | Referencia al trabajador inscrito | UUID | - | UUID válido existente en `workers` | FOREIGN KEY | NO |
| course_id | Referencia al curso | UUID | - | UUID válido existente en `courses` | FOREIGN KEY | NO |
| final_grade | Calificación final del trabajador | DECIMAL | (5,2) | Valor numérico: 0.00 - 100.00 | - | SÍ |

**Valores por defecto**:
- `id`: `gen_random_uuid()`

**Relaciones**:
- `worker_id` → `workers(id)` (FOREIGN KEY: fk_worker)
- `course_id` → `courses(id)` (FOREIGN KEY: fk_course)

**Restricciones de unicidad**:
- UNIQUE (`worker_id`, `course_id`): Un trabajador solo puede inscribirse una vez al mismo curso

**Restricciones de negocio**:
- La calificación final (`final_grade`) debe estar en el rango 0.00 a 100.00

---

## Tabla: attendances

**Descripción**: Registra la asistencia diaria de los trabajadores a los cursos en los que están inscritos.

| Nombre Columna | Descripción | Tipo de Dato | Longitud | Dominio/Restricción | Tipo de Índice | Nullable |
|----------------|-------------|--------------|----------|---------------------|----------------|----------|
| id | Identificador único del registro de asistencia | UUID | - | UUID válido | PRIMARY KEY | NO |
| worker_id | Referencia al trabajador | UUID | - | UUID válido existente en `workers` | FOREIGN KEY | NO |
| course_id | Referencia al curso | UUID | - | UUID válido existente en `courses` | FOREIGN KEY | NO |
| attendance_date | Fecha en la que se registró la asistencia | DATE | - | Fecha válida (YYYY-MM-DD) | - | NO |

**Valores por defecto**:
- `id`: `gen_random_uuid()`

**Relaciones**:
- `worker_id` → `workers(id)` (FOREIGN KEY: fk_worker)
- `course_id` → `courses(id)` (FOREIGN KEY: fk_course)

**Restricciones de unicidad**:
- UNIQUE (`worker_id`, `course_id`, `attendance_date`): Solo puede existir un registro de asistencia por trabajador, por curso, por día

**Restricciones de negocio**:
- La fecha de asistencia debe estar dentro del rango de fechas del curso correspondiente

---

## Tabla: answers

**Descripción**: Almacena las respuestas de los trabajadores a las preguntas de las encuestas aplicadas en los cursos.

| Nombre Columna | Descripción | Tipo de Dato | Longitud | Dominio/Restricción | Tipo de Índice | Nullable |
|----------------|-------------|--------------|----------|---------------------|----------------|----------|
| id | Identificador único de la respuesta | UUID | - | UUID válido | PRIMARY KEY | NO |
| worker_id | Referencia al trabajador que responde | UUID | - | UUID válido existente en `workers` | FOREIGN KEY | NO |
| course_id | Referencia al curso evaluado | UUID | - | UUID válido existente en `courses` | FOREIGN KEY | NO |
| question_id | Referencia a la pregunta respondida | UUID | - | UUID válido existente en `questions` | FOREIGN KEY | NO |
| value | Respuesta del trabajador | TEXT | - | Cadena de texto sin límite | - | NO |

**Valores por defecto**:
- `id`: `gen_random_uuid()`

**Relaciones**:
- `worker_id` → `workers(id)` (FOREIGN KEY: fk_worker)
- `course_id` → `courses(id)` (FOREIGN KEY: fk_course)
- `question_id` → `questions(id)` (FOREIGN KEY: fk_question)

**Restricciones de unicidad**:
- UNIQUE (`worker_id`, `course_id`, `question_id`): Un trabajador solo puede responder una vez a una pregunta específica por curso

---

## Catálogos de Valores

### Tabla workers - Campo sex
| Valor | Significado |
|-------|-------------|
| 0 | Mujer |
| 1 | Hombre |

### Tabla workers - Campo position
| Valor | Significado |
|-------|-------------|
| 0 | Docente |
| 1 | Jefe de departamento |

### Tabla courses - Campo course_type
| Valor | Significado |
|-------|-------------|
| 0 | Diplomado |
| 1 | Taller |

### Tabla courses - Campo modality
| Valor | Significado |
|-------|-------------|
| 0 | Virtual |
| 1 | Presencial |

### Tabla courses - Campo course_profile
| Valor | Significado |
|-------|-------------|
| 0 | Formación |
| 1 | Actualización docente |

---

## Patrones de Validación Recomendados

### RFC (Registro Federal de Contribuyentes)
```regex
^[A-ZÑ&]{3,4}\d{6}[A-Z0-9]{3}$
```
**Descripción**: 3-4 letras + 6 dígitos (fecha) + 3 caracteres alfanuméricos (homoclave)

### CURP (Clave Única de Registro de Población)
```regex
^[A-Z]{4}\d{6}[HM][A-Z]{5}[0-9A-Z]\d$
```
**Descripción**: 4 letras + 6 dígitos (fecha) + H/M (sexo) + 5 letras (lugar) + 2 caracteres verificadores

### Teléfono
```regex
^\d{10}$
```
**Descripción**: 10 dígitos numéricos

### Email
```regex
^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$
```
**Descripción**: Formato estándar de correo electrónico

---

## Diagrama de Relaciones

```
departments (1) ----< (N) workers
periods (1) ----< (N) courses
surveys (1) ----< (N) questions

workers (N) >----< (N) courses  [a través de instructors]
workers (N) >----< (N) courses  [a través de enrollings]
workers (N) >----< (N) courses  [a través de attendances]
workers + courses + questions (N) >----< (N) answers
```

---

## Notas Técnicas

1. **Tipo UUID**: Se utiliza el tipo nativo `UUID` de PostgreSQL con generación automática mediante `gen_random_uuid()`

2. **Integridad Referencial**: Todas las relaciones están protegidas con FOREIGN KEYS que garantizan la integridad referencial

3. **Restricciones UNIQUE**: Se implementan restricciones de unicidad para evitar duplicados en:
   - Datos de identificación (RFC, CURP, email)
   - Relaciones compuestas (inscripciones, asistencias, respuestas)

4. **Seguridad**:
   - Las contraseñas deben almacenarse hasheadas
   - Se recomienda implementar validaciones a nivel de aplicación para los patrones regex
   - Considerar encriptación para datos sensibles (CURP, RFC)

5. **Escalabilidad**:
   - Considerar índices adicionales en campos de búsqueda frecuente
   - Evaluar particionamiento de tablas con alto volumen (attendances, answers)

---

**Última actualización**: 2025-11-28
**Versión del esquema**: 1.0
**Motor de base de datos**: PostgreSQL 12+
