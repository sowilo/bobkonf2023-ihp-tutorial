-- Your database schema. Use the Schema Designer at http://localhost:8001/ to add some tables.
CREATE TABLE contacts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT DEFAULT NULL,
    date_of_birth DATE NOT NULL,
    mail_content TEXT DEFAULT NULL
);
CREATE TABLE send_mail_jobs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    status JOB_STATUS DEFAULT 'job_status_not_started' NOT NULL,
    last_error TEXT DEFAULT NULL,
    attempts_count INT DEFAULT 0 NOT NULL,
    locked_at TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    locked_by UUID DEFAULT NULL,
    run_at TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    contact_id UUID NOT NULL,
    date_to_send DATE NOT NULL
);
CREATE INDEX send_mail_jobs_contact_id_index ON send_mail_jobs (contact_id);
ALTER TABLE send_mail_jobs ADD CONSTRAINT send_mail_jobs_ref_contact_id FOREIGN KEY (contact_id) REFERENCES contacts (id) ON DELETE CASCADE;
