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