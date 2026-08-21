-- Migración aditiva y segura: solo agrega columnas nuevas, no borra ni modifica
-- nada existente. Es segura de ejecutar aunque ya hayas corrido antes
-- "migracion_fecha_publicacion.sql" (todo usa IF NOT EXISTS, así que las
-- columnas que ya existan simplemente se saltan sin error).
--
-- Ejecútala en el SQL Editor de Supabase antes de subir el nuevo index.html,
-- o los guardados que usen estos campos mostrarán un error claro hasta que
-- la ejecutes.

-- Columnas de la migración anterior (por si aún no la corriste):
ALTER TABLE public.tareas
  ADD COLUMN IF NOT EXISTS hora_pub text,
  ADD COLUMN IF NOT EXISTS resumen text;

ALTER TABLE public.solicitudes
  ADD COLUMN IF NOT EXISTS links text,
  ADD COLUMN IF NOT EXISTS comentarios text;

-- Columnas nuevas de esta ronda:
-- "fecha_evento": la fecha en que ocurre el evento (solo aplica cuando el
-- tipo de contenido es "Cobertura de evento"), independiente de la fecha
-- de publicación del flyer/post.
ALTER TABLE public.tareas
  ADD COLUMN IF NOT EXISTS fecha_evento text;

ALTER TABLE public.solicitudes
  ADD COLUMN IF NOT EXISTS fecha_evento text,
  ADD COLUMN IF NOT EXISTS recursos text;

-- Nota sobre "fecha_fin": la columna sigue existiendo en la tabla "tareas"
-- (no se borra nada), pero la aplicación ya no la usa ni la muestra, porque
-- se eliminó el campo "Fecha de finalización" del formulario de tareas
-- (reemplazado conceptualmente por "Fecha de evento", que es otra columna).

-- Verificación rápida (no modifica nada, solo confirma que las columnas quedaron creadas):
SELECT table_name, column_name, data_type
FROM information_schema.columns
WHERE table_schema='public' AND table_name IN ('tareas','solicitudes')
  AND column_name IN ('hora_pub','resumen','links','comentarios','fecha_evento','recursos')
ORDER BY table_name, column_name;
