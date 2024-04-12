INSERT INTO mart.dim_kfz (kfz_kennzeichen) 
    SELECT kfz_kennzeichen FROM staging.fzg_kauf;

INSERT INTO mart.dim_fahrzeug (fin, hersteller_code, modell, produktionsdatum, hersteller_name)
    SELECT fin, hersteller_code, modell, produktionsdatum, hersteller_name
    FROM staging.fahrzeug
    JOIN staging.hersteller USING (hersteller_code);

INSERT INTO mart.dim_kunde (kunde_account, vorname, nachname, geschlecht, geburtsdatum, wohnort, land)
    SELECT kunde_account, vorname, nachname, geschlecht, geburtsdatum, ort, land
    FROM staging.kunde
    JOIN staging.ort ON (wohnort_id = ort_id)
    JOIN staging.land USING (land_id);

INSERT INTO mart.fact_kauf SELECT
    df.dim_fahrzeug_id
  , dk.dim_kunde_id
  , kfz.dim_kfz_id
  , kaufdatum
  , lieferdatum
  , kaufpreis
  , rabatt_pct
FROM staging.fzg_kauf sfk
JOIN mart.dim_fahrzeug df ON (sfk.fin = df.fin)
JOIN mart.dim_kunde dk ON (sfk.kunde_account = dk.kunde_account)
JOIN mart.dim_kfz kfz ON (sfk.kfz_kennzeichen = kfz.kfz_kennzeichen);
