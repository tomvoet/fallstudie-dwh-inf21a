CREATE TABLE IF NOT EXISTS mart.fact_messung (
    dim_fahrzeug_id INT
  , gesendet TIMESTAMP WITH TIME ZONE
  , empfangen TIMESTAMP WITH TIME ZONE
  , geschwindigkeit INTEGER
  , PRIMARY KEY (dim_fahrzeug_id, gesendet, empfangen)
) PARTITION BY RANGE (gesendet);

CREATE TABLE IF NOT EXISTS mart.fact_messung_2023 PARTITION OF mart.fact_messung
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE IF NOT EXISTS mart.fact_messung_2024 PARTITION OF mart.fact_messung
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

