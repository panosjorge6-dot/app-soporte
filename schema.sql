-- Esquema PostgreSQL 16 para Soporte >_ Aula (Autenticación + Prueba de 7 días + Aislamiento por Usuario)
CREATE TABLE IF NOT EXISTS usuarios (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(160) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,          -- Hash BCrypt / PBKDF2 (nunca texto plano)
    rol VARCHAR(40) NOT NULL DEFAULT 'DOCENTE_TITULAR',
    es_demo BOOLEAN NOT NULL DEFAULT FALSE,
    acepta_terminos BOOLEAN NOT NULL DEFAULT TRUE,
    email_verificado BOOLEAN NOT NULL DEFAULT FALSE,
    trial_start_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    trial_ends_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (CURRENT_TIMESTAMP + INTERVAL '7 days'),
    creado_en TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS incidencias (
    id VARCHAR(24) NOT NULL,
    usuario_id UUID NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
    aula VARCHAR(80) NOT NULL,
    tipo VARCHAR(60) NOT NULL,
    prioridad VARCHAR(20) NOT NULL,
    titulo VARCHAR(160) NOT NULL,
    descripcion TEXT NOT NULL,
    estado VARCHAR(30) NOT NULL DEFAULT 'Pendiente',
    nota_tecnica TEXT,
    creado_en TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id, usuario_id)
);

CREATE INDEX idx_incidencias_usuario ON incidencias(usuario_id);