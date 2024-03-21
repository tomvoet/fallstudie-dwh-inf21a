--drop schema if exists staging cascade;

--create schema staging;

create table staging.land (
     land_id integer not null
   , land varchar(200) not null
   , erstellt_am TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP 
   , quelle varchar(20) not null
   , CONSTRAINT pk_land PRIMARY KEY(land_id)
);

create table staging.ort (
     ort_id integer not null
   , ort varchar(200) not null
   , land_id integer not null
   , erstellt_am TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP 
   , quelle varchar(20) not null
   , CONSTRAINT pk_ort PRIMARY KEY(ort_id)
   , CONSTRAINT fk_o_land FOREIGN KEY(land_id) REFERENCES staging.land(land_id)
);

create table staging.H_Fahrzeug
(
    fin char(32) not null primary key,
    load_date timestamp with time zone default current_timestamp not null,
    record_source varchar(50) not null
);

create table staging.H_Hersteller
(
    hersteller_code char(3) not null primary key,
    load_date timestamp with time zone default current_timestamp not null,
    record_source varchar(50) not null
);

create table staging.H_Kunde
(
    personen_id varchar(16) not null primary key,
    load_date timestamp with time zone default current_timestamp not null,
    record_source varchar(50) not null
);

create table staging.L_Produzieren
(
    produktions_nr varchar(32) not null primary key,
    fin char(32) not null,
    hersteller_code char(3) not null,
    load_date timestamp with time zone default current_timestamp not null,
    recourd_source varchar(50) not null,
    CONSTRAINT fk_produzieren_fahrzeug FOREIGN KEY (fin) REFERENCES staging.H_Fahrzeug(fin),
    CONSTRAINT fk_produzieren_hersteller FOREIGN KEY (hersteller_code) REFERENCES staging.H_Hersteller(hersteller_code)
);

create table staging.L_Kaufen
(
    kauf_id varchar(16) not null primary key,
    fin char(32) not null unique,
    personen_id varchar(16) not null,
    load_date timestamp with time zone default current_timestamp not null,
    record_source varchar(50) not null,
    CONSTRAINT fk_kaufen_fahrzeug FOREIGN KEY (fin) REFERENCES staging.H_Fahrzeug(fin),
    CONSTRAINT fk_kaufen_kunde FOREIGN KEY (personen_id) REFERENCES staging.H_Kunde(personen_id)
);

create table staging.S_Produktion
(
    produktions_nr varchar(32) not null,
    load_date timestamp with time zone,
    produktions_datum date,
    record_source varchar(50) not null,
    CONSTRAINT pk_produktion PRIMARY KEY(produktions_nr, load_date),
    CONSTRAINT fk_produktion_produzieren FOREIGN KEY (produktions_nr) REFERENCES staging.L_Produzieren(produktions_nr)
);

create table staging.S_Fahrzeugkauf
(
    kauf_id varchar(16) not null,
    load_date timestamp with time zone default current_timestamp not null,
    kauf_datum date not null,
    liefer_datum date,
    kaufpreis integer,
    rabatt_pct integer,
    kennzeichen varchar(20) not null,
    record_source varchar(50) not null,
    CONSTRAINT pk_fahrzeugkauf PRIMARY KEY(kauf_id, load_date),
    CONSTRAINT fk_fahrzeugkauf_kaufen FOREIGN KEY (kauf_id) REFERENCES staging.L_Kaufen(kauf_id)
);

create table staging.S_Herstellerinfo
(
    hersteller_code char(3) not null,
    load_date timestamp with time zone default current_timestamp not null,
    hersteller_name varchar(200) not null,
    record_source varchar(50) not null,
    CONSTRAINT pk_herstellerinfo PRIMARY KEY(hersteller_code, load_date),
    CONSTRAINT fk_herstellerinfo_hersteller FOREIGN KEY (hersteller_code) REFERENCES staging.H_Hersteller(hersteller_code)
);

create table staging.S_Fahrzeuginfo
(
    fin char(32) not null,
    load_date timestamp with time zone default current_timestamp not null,
    modell varchar(200) not null,
    record_source varchar(50) not null,
    CONSTRAINT pk_fahrzeuginfo PRIMARY KEY(fin, load_date),
    CONSTRAINT fk_fahrzeuginfo_fahrzeug FOREIGN KEY (fin) REFERENCES staging.H_Fahrzeug(fin)
);

create table staging.S_Kundeinfo
(
    personen_id varchar(16) not null,
    load_date timestamp with time zone default current_timestamp not null,
    vorname varchar(200) not null,
    nachname varchar(200) not null,
    geschlecht varchar(20) not null,
    geburtsdatum date,
    ort_id integer,
    record_source varchar(50) not null,
    CONSTRAINT pk_kundeinfo PRIMARY KEY(personen_id, load_date),
    CONSTRAINT fk_kundeinfo_kunde FOREIGN KEY (personen_id) REFERENCES staging.H_Kunde(personen_id)
);

create table staging.S_Messung
(
    fin char(32) not null,
    load_date timestamp with time zone default current_timestamp not null,
    messung_id integer not null,
    geschwindigkeit integer not null,
    ort_id integer not null,
    record_source varchar(50) not null,
    CONSTRAINT pk_messung PRIMARY KEY(fin, load_date),
    CONSTRAINT fk_messung_fahrzeug FOREIGN KEY (fin) REFERENCES staging.H_Fahrzeug(fin)
);

    