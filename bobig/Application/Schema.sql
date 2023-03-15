-- Your database schema. Use the Schema Designer at http://localhost:8001/ to add some tables.
CREATE TABLE contacts (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT DEFAULT NULL,
    date_of_birth DATE NOT NULL,
    mail_content TEXT DEFAULT NULL
);
