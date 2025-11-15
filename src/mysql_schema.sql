CREATE DATABASE cursito;

USE cursito;

-- Tabla para almacenar los departamentos
CREATE TABLE departments (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(100) NOT NULL
);

-- Tabla para almacenar los periodos de los cursos
CREATE TABLE periods (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL
);

-- Tabla para almacenar las encuestas
CREATE TABLE surveys (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(100) NOT NULL,
    created_at DATE NOT NULL DEFAULT (CURRENT_DATE)
);

-- Tabla para almacenar la información de los trabajadores (docentes/personal)
CREATE TABLE workers (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    department_id CHAR(36) NOT NULL,
    rfc VARCHAR(13) NOT NULL UNIQUE,
    curp VARCHAR(18) NOT NULL UNIQUE,
    sex TINYINT NOT NULL, -- 0 = mujer, 1 = hombre
    telephone VARCHAR(10),
    email VARCHAR(64) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Almacenar como hash
    name VARCHAR(45) NOT NULL,
    fathers_surname VARCHAR(40) NOT NULL,
    mother_surname VARCHAR(40),
    position TINYINT NOT NULL, -- 0 = docente, 1 = jefe de departamento
    CONSTRAINT fk_department
        FOREIGN KEY(department_id) 
        REFERENCES departments(id)
);

-- Tabla para almacenar la información de los cursos
CREATE TABLE courses (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    period_id CHAR(36) NOT NULL,
    target VARCHAR(255) NOT NULL,
    name VARCHAR(150) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    course_type TINYINT NOT NULL, -- 0 = diplomado, 1 = taller
    modality TINYINT NOT NULL, -- 0 = virtual, 1 = presencial
    course_profile TINYINT NOT NULL, -- 0 = formacion, 1 = actualización docente
    goal TEXT NOT NULL,
    details TEXT,
    CONSTRAINT fk_period
        FOREIGN KEY(period_id) 
        REFERENCES periods(id)
);

-- Tabla para almacenar las preguntas de las encuestas
CREATE TABLE questions (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    survey_id CHAR(36) NOT NULL,
    question VARCHAR(100) NOT NULL,
    question_order SMALLINT NOT NULL,
    CONSTRAINT fk_survey
        FOREIGN KEY(survey_id) 
        REFERENCES surveys(id)
);

-- Tabla de relación para instructores y cursos (Muchos a Muchos)
CREATE TABLE instructors (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    worker_id CHAR(36) NOT NULL,
    course_id CHAR(36) NOT NULL,
    CONSTRAINT fk_instructor_worker
        FOREIGN KEY(worker_id) 
        REFERENCES workers(id),
    CONSTRAINT fk_instructor_course
        FOREIGN KEY(course_id) 
        REFERENCES courses(id),
    UNIQUE (worker_id, course_id) -- Un instructor solo puede estar una vez en un curso
);

-- Tabla para gestionar las inscripciones de los trabajadores a los cursos
CREATE TABLE enrollings (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    worker_id CHAR(36) NOT NULL,
    course_id CHAR(36) NOT NULL,
    final_grade DECIMAL(5, 2),
    CONSTRAINT fk_enrolling_worker
        FOREIGN KEY(worker_id) 
        REFERENCES workers(id),
    CONSTRAINT fk_enrolling_course
        FOREIGN KEY(course_id) 
        REFERENCES courses(id),
    UNIQUE (worker_id, course_id) -- Un trabajador solo puede inscribirse una vez al mismo curso
);

-- Tabla para registrar la asistencia de los trabajadores a los cursos
CREATE TABLE attendances (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    worker_id CHAR(36) NOT NULL,
    course_id CHAR(36) NOT NULL,
    attendance_date DATE NOT NULL,
    CONSTRAINT fk_attendance_worker
        FOREIGN KEY(worker_id) 
        REFERENCES workers(id),
    CONSTRAINT fk_attendance_course
        FOREIGN KEY(course_id) 
        REFERENCES courses(id),
    UNIQUE(worker_id, course_id, attendance_date) -- Solo un registro de asistencia por día por trabajador por curso
);

-- Tabla para almacenar las respuestas a las encuestas
CREATE TABLE answers (
    id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    worker_id CHAR(36) NOT NULL,
    course_id CHAR(36) NOT NULL,
    question_id CHAR(36) NOT NULL,
    answer TEXT NOT NULL,
    CONSTRAINT fk_answer_worker
        FOREIGN KEY(worker_id) 
        REFERENCES workers(id),
    CONSTRAINT fk_answer_course
        FOREIGN KEY(course_id) 
        REFERENCES courses(id),
    CONSTRAINT fk_answer_question
        FOREIGN KEY(question_id) 
        REFERENCES questions(id),
    UNIQUE(worker_id, course_id, question_id) -- Un trabajador solo puede responder una vez a una pregunta por curso
);