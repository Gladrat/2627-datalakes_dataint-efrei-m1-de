SELECT
    t.track_uri, t.track_name, t.artist_name,
    COUNT(DISTINCT(t.playlist_id)) AS nb_playlists
    FROM {{ ref('stg_tracks') }} t
    JOIN {{ ref('romantic_playlists') }} rp
        ON t.playlist_id = rp.playlist_id
    GROUP BY t.track_uri, t.track_name, t.artist_name
    ORDER BY nb_playlists DESC
    LIMIT 20;