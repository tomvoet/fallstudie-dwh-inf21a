INSERT INTO mart.fact_messung SELECT
    f.dim_fahrzeug_id,
    to_timestamp((m.payload->>'zeit')::BIGINT),
    m.empfangen,
    (m.payload->>'geschwindigkeit')::INTEGER
FROM staging.messung m
JOIN mart.dim_fahrzeug f ON m.payload->>'fin' = f.fin;

