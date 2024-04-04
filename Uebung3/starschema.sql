-- DROP SCHEMA if exists starschema CASCADE;
-- CREATE SCHEMA starschema;

-- Dimension Tables
CREATE TABLE starschema.dim_kunde (
    kunde_id serial PRIMARY KEY,
    vorname varchar(200) NOT NULL,
    nachname varchar(200) NOT NULL,
    geschlecht varchar(20) NOT NULL,
    geburtsdatum date,
    wohnort varchar(200),
    land varchar(200)
);

CREATE TABLE starschema.dim_fahrzeug (
    fahrzeug_id serial PRIMARY KEY,
    fin char(32) NOT NULL UNIQUE,
    hersteller_name varchar(200) NOT NULL,
    modell varchar(200) NOT NULL,
    produktionsdatum date
);

CREATE TABLE starschema.dim_kennzeichen (
    kennzeichen_id serial PRIMARY KEY,
    kennzeichen varchar(11) NOT NULL
);

-- Fact Table
CREATE TABLE starschema.fact_fahrzeugkauf (
    load_date timestamp with time zone,
    kauf_date date,
    fahrzeug_id integer FOREIGN KEY REFERENCES starschema.dim_fahrzeug(fahrzeug_id),
    kunde_id integer FOREIGN KEY REFERENCES starschema.dim_kunde(kunde_id),
    kennzeichen_id integer FOREIGN KEY REFERENCES starschema.dim_kennzeichen(kennzeichen_id),
    CONSTRAINT fact_key UNIQUE (fahrzeug_id, kunde_id, kennzeichen_id, kauf_date)
);
