SELECT * FROM {{ ref('stg_tracks') }}
WHERE playlist_name ILIKE '%love%'