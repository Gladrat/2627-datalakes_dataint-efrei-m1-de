SELECT *,
ROUND((duration_ms / 60000), 2) as duration_min
FROM {{ source('silver', 'tracks') }}