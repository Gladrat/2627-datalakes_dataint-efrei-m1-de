SELECT *,
FROM {{ source('silver', 'playlists') }}