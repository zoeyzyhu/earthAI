DROP TABLE IF EXISTS grid9_rad0;
CREATE TABLE IF NOT EXISTS grid9_rad0 AS
SELECT 
    CAST(FLOOR((lat - 20) / 10) AS INT) AS ilat,
    CAST(FLOOR((lon + 110) / 10) AS INT) AS ilon,
    d,
    AVG(rad[0]) AS mrad
FROM 
    radiances
WHERE 
    lat BETWEEN 20 AND 50 AND lon BETWEEN -110 AND -80
GROUP BY 
    CAST(FLOOR((lat - 20) / 10) AS INT),
    CAST(FLOOR((lon + 110) / 10) AS INT),
    d
;
