SELECT * FROM {{ ref('stg_playlists') }}
WHERE playlist_name ILIKE '%love%'