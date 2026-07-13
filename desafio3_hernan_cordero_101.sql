-- Active: 1782950269813@@127.0.0.1@5432@desafio3_hernan_cordero_101
/* 
==========================================
DESAFÍO 3: "CONSULTAS EN MÚLTIPLES TABLAS"
HERNÁN CORDERO ARAYA 
==========================================
*/

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    rol VARCHAR(20) NOT NULL
);

CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    destacado BOOLEAN NOT NULL DEFAULT FALSE,
    usuario_id BIGINT REFERENCES usuarios(id)
);

CREATE TABLE comentarios (
    id SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario_id BIGINT REFERENCES usuarios(id),
    post_id BIGINT REFERENCES posts(id)
);

INSERT INTO usuarios (email, nombre, apellido, rol) VALUES
('admin@bloglatam.com', 'Hernan', 'Cordero', 'administrador'),
('juan.perez@correo.cl', 'Juan', 'Pérez', 'usuario'),
('maria.gomez@correo.cl', 'María', 'Gómez', 'usuario'),
('carlos.silva@correo.cl', 'Carlos', 'Silva', 'usuario'),
('ana.lopez@correo.cl', 'Ana', 'López', 'usuario');

INSERT INTO posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES
('Introducción a SQL', 'Contenido extendido sobre bases de datos relacionales.', '2026-07-01 10:00:00', '2026-07-01 10:30:00', true, 1),
('Avanzado en PostgreSQL', 'Optimización de índices y planes de ejecución.', '2026-07-02 11:00:00', '2026-07-02 11:15:00', true, 1),
('El futuro de React y Vite', 'Revisión completa de las nuevas metodologías frontend.', '2026-07-03 14:00:00', '2026-07-03 14:00:00', false, 2),
('Buenas prácticas en CSS', 'Uso correcto de metodologías y frameworks modernos.', '2026-07-04 16:30:00', '2026-07-04 16:45:00', false, 3),
('Post sin autor asignado', 'Este es un artículo libre de pruebas del sistema.', '2026-07-05 09:00:00', '2026-07-05 09:00:00', false, NULL);

INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id) VALUES
('Excelente artículo de introducción, muy claro.', '2026-07-01 10:45:00', 1, 1),
('Me sirvió mucho para repasar los conceptos.', '2026-07-01 12:00:00', 2, 1),
('¿Cuándo se subirá la segunda parte?', '2026-07-01 15:30:00', 3, 1),
('El análisis de los índices estuvo espectacular.', '2026-07-02 13:00:00', 1, 2),
('Muy buen material, totalmente recomendado.', '2026-07-02 18:20:00', 2, 2);

--PREGUNTA 2
SELECT usuarios.nombre, usuarios.email, posts.titulo, posts.contenido
FROM usuarios
INNER JOIN posts ON usuarios.id = posts.usuario_id;

--PREGUNTA 3
SELECT posts.id, posts.titulo, posts.contenido
FROM posts
INNER JOIN usuarios ON posts.usuario_id = usuarios.id
WHERE usuarios.rol = 'administrador';

--PREGUNTA 4
SELECT usuarios.id, usuarios.email, COUNT(posts.id) AS cantidad_posts
FROM usuarios
LEFT JOIN posts ON usuarios.id = posts.usuario_id
GROUP BY usuarios.id, usuarios.email
ORDER BY cantidad_posts DESC;

--PREGUNTA 5
SELECT usuarios.email
FROM usuarios
INNER JOIN posts ON usuarios.id = posts.usuario_id
GROUP BY usuarios.id, usuarios.email
ORDER BY COUNT(posts.id) DESC
LIMIT 1;

--PREGUNTA 6
SELECT usuarios.id, usuarios.nombre, usuarios.email, MAX(posts.fecha_creacion) AS fecha_ultimo_post
FROM usuarios
INNER JOIN posts ON usuarios.id = posts.usuario_id
GROUP BY usuarios.id, usuarios.nombre, usuarios.email;

--PREGUNTA 7
SELECT posts.titulo, posts.contenido
FROM posts
INNER JOIN comentarios ON posts.id = comentarios.post_id
GROUP BY posts.id, posts.titulo, posts.contenido
ORDER BY COUNT(comentarios.id) DESC
LIMIT 1;

--PREGUNTA 8
SELECT posts.titulo AS titulo_post, posts.contenido AS contenido_post, comentarios.contenido AS contenido_comentario, usuarios.email AS email_autor_comentario
FROM posts
INNER JOIN comentarios ON posts.id = comentarios.post_id
INNER JOIN usuarios ON comentarios.usuario_id = usuarios.id;

--PREGUNTA 9
SELECT comentarios.usuario_id, usuarios.email, comentarios.contenido AS ultimo_comentario, comentarios.fecha_creacion
FROM comentarios
INNER JOIN usuarios ON comentarios.usuario_id = usuarios.id
WHERE comentarios.fecha_creacion = (
    SELECT MAX(sub_comentarios.fecha_creacion)
    FROM comentarios AS sub_comentarios
    WHERE sub_comentarios.usuario_id = comentarios.usuario_id
);

--PREGUNTA 10
SELECT usuarios.email
FROM usuarios
LEFT JOIN comentarios ON usuarios.id = comentarios.usuario_id
GROUP BY usuarios.id, usuarios.email
HAVING COUNT(comentarios.id) = 0;