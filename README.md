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

