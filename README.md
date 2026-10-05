# Projet Spotify - Duckdb

1000 fichiers playlists
1000 fichiers tracks

## Activer le timer

```sql
.timer on
```

## Lire les données

**Lire le contenu des "tables" playlists & tracks :**

```SQL
SELECT * FROM read_parquet('./*_playlists.parquet');
```

```SQL
SELECT * FROM read_parquet('./*_tracks.parquet');
```

**Voir les tracks de Beyoncé :**

```sql
SELECT * FROM read_parquet('./*_tracks.parquet') WHERE artist_name LIKE 'Beyoncé';
```

## Créer des vues Duckdb

Les vues ne sont que des "raccourcis" vers les fichiers parquet. Les données ne sont PAS stockées dans duckdb.

**Vue vers les playlists & tracks :**

```sql
CREATE VIEW v_playlists AS SELECT * FROM read_parquet('./*_playlists.parquet');
```

```sql
CREATE VIEW v_tracks AS SELECT * FROM read_parquet('./*_tracks.parquet');
```

## Décrire les schémas des données (des vues)

```sql
spotify D DESCRIBE v_tracks;
┌─────────────────────┐
│      v_tracks       │
│                     │
│ playlist_id integer │
│ track_uri   varchar │
│ track_name  varchar │
│ artist_name varchar │
│ artist_uri  varchar │
│ album_name  varchar │
│ album_uri   varchar │
│ duration_ms bigint  │
│ position    integer │
└─────────────────────┘
Run Time (s): real 0.018 user 0.013256 sys 0.000000
spotify D DESCRIBE v_playlists;
┌───────────────────────┐
│      v_playlists      │
│                       │
│ playlist_id   integer │
│ playlist_name varchar │
│ num_tracks    integer │
│ num_albums    integer │
│ num_followers integer │
│ modified_at   bigint  │
└───────────────────────┘
Run Time (s): real 0.005 user 0.005393 sys 0.000000
```