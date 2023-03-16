

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE public.contacts DISABLE TRIGGER ALL;

INSERT INTO public.contacts (id, name, email, phone, date_of_birth, mail_content) VALUES ('02d9a848-4758-41cc-b3a6-39e09bf7eb93', 'Alex', 'alex@doeblin', NULL, '1990-03-01', NULL);
INSERT INTO public.contacts (id, name, email, phone, date_of_birth, mail_content) VALUES ('c50dc6f5-5872-4303-87ec-2e6e64558ec9', 'Tim', 'tim@struppi', NULL, '2000-03-16', NULL);
INSERT INTO public.contacts (id, name, email, phone, date_of_birth, mail_content) VALUES ('fc3c4202-913b-41ef-976c-5188ecf49052', 'Bianca', 'me@bob', '+493012345', '1983-05-03', '**Markdown** -- Yeah!

```yaml
sogar : mit
yaml : [ wie, cool, ist, das, denn, !]
```');


ALTER TABLE public.contacts ENABLE TRIGGER ALL;


ALTER TABLE public.schema_migrations DISABLE TRIGGER ALL;

INSERT INTO public.schema_migrations (revision) VALUES (1678883536);
INSERT INTO public.schema_migrations (revision) VALUES (1678909630);
INSERT INTO public.schema_migrations (revision) VALUES (1678959399);


ALTER TABLE public.schema_migrations ENABLE TRIGGER ALL;


ALTER TABLE public.send_mail_jobs DISABLE TRIGGER ALL;



ALTER TABLE public.send_mail_jobs ENABLE TRIGGER ALL;


