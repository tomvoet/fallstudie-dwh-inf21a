--delete from mart.fact_messung;
delete from mart.fact_kauf;
delete from mart.dim_kfz;
delete from mart.dim_fahrzeug;
delete from mart.dim_kunde;



INSERT INTO mart.dim_kfz (kfz_kennzeichen)
SELECT distinct kfz_kennzeichen
FROM staging.fzg_kauf;


INSERT INTO mart.dim_fahrzeug (fin, hersteller_code, hersteller_name, modell, produktionsdatum)
SELECT distinct f.fin
     , f.hersteller_code
	 , h.hersteller_name
	 , f.modell
	 , f.produktionsdatum
FROM staging.fahrzeug f
JOIN staging.hersteller h on f.hersteller_code = h.hersteller_code
;


INSERT INTO mart.dim_kunde (kunde_account, vorname, nachname, geschlecht, geburtsdatum, wohnort, land)
SELECT distinct k.kunde_account
     , k.vorname
	 , k.nachname
	 , k.geschlecht
	 , k.geburtsdatum
	 , o.ort
	 , l.land
FROM staging.kunde k
JOIN staging.ort o on o.ort_id = k.wohnort_id
JOIN staging.land l on l.land_id = o.land_id
;



/*
INSERT INTO mart.dim_datum (kalender_datum, tag, monat, jahr)
SELECT
    generate_series::date AS kalender_datum,
    EXTRACT(day FROM generate_series) AS tag,
    EXTRACT(month FROM generate_series) AS monat,
    EXTRACT(year FROM generate_series) AS jahr
FROM
    generate_series('2018-01-01'::date, '2025-12-31'::date, '1 day'::interval) generate_series;
*/


INSERT INTO mart.fact_kauf (dim_fahrzeug_id, dim_kunde_id, dim_kfz_id, kauf_kalender_datum, liefer_kalender_datum, kaufpreis, rabatt_pct)
SELECT distinct
    f.dim_fahrzeug_id,
    k.dim_kunde_id,
    kf.dim_kfz_id,
    fk.kaufdatum,
    fk.lieferdatum,
    fk.kaufpreis,
    fk.rabatt_pct
FROM
    staging.fzg_kauf fk
JOIN
    mart.dim_fahrzeug f ON fk.fin = f.fin
JOIN
    mart.dim_kunde k ON fk.kunde_account = k.kunde_account
JOIN
    mart.dim_kfz kf ON fk.kfz_kennzeichen = kf.kfz_kennzeichen
;


/*
select f.*, df.fin, dk.nachname
from   mart.fact_kauf f 
join   mart.dim_fahrzeug df on df.dim_fahrzeug_id = f.dim_fahrzeug_id
join   mart.dim_kunde dk on dk.dim_kunde_id = f.dim_kunde_id
where  df.hersteller_code = 'SNT'
order by 1, 4;
*/