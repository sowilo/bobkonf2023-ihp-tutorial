ALTER TABLE send_mail_jobs ADD COLUMN contact_id UUID NOT NULL;
ALTER TABLE send_mail_jobs ADD COLUMN date_to_send DATE NOT NULL;
CREATE INDEX send_mail_jobs_contact_id_index ON send_mail_jobs (contact_id);
ALTER TABLE send_mail_jobs ADD CONSTRAINT send_mail_jobs_ref_contact_id FOREIGN KEY (contact_id) REFERENCES contacts (id) ON DELETE CASCADE;
