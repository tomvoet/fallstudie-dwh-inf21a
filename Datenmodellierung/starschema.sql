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
    fahrzeug_id integer NOT NULL,
    kunde_id integer NOT NULL,
    kennzeichen_id integer NOT NULL,
    rabatt_pct integer,
    kaufpreis integer,
    CONSTRAINT fact_key UNIQUE (fahrzeug_id, kunde_id, kennzeichen_id, kauf_date),
    FOREIGN KEY (fahrzeug_id) REFERENCES starschema.dim_fahrzeug(fahrzeug_id),
    FOREIGN KEY (kunde_id) REFERENCES starschema.dim_kunde(kunde_id),
    FOREIGN KEY (kennzeichen_id) REFERENCES starschema.dim_kennzeichen(kennzeichen_id)
);
