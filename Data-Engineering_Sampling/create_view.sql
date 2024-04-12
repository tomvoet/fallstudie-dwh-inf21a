CREATE VIEW mart.agg_sampling_1min AS
SELECT
    dim_fahrzeug_id,
    date_trunc('minute', gesendet) AS minute_interval,
    AVG(geschwindigkeit) AS durch_geschw,
    COUNT(*) AS anzahl
FROM
    mart.fact_messung
GROUP BY
    dim_fahrzeug_id,
    date_trunc('minute', gesendet);
