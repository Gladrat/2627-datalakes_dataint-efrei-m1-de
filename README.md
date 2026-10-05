# Projet Spotify - Duckdb

1000 fichiers playlists
1000 fichiers tracks

## Activer le timer

```sql
.timer on
```

## Lire les données

**Lire le contenu de la "table" des playlists :**

```SQL
SELECT * FROM read_parquet('./*_playlists.parquet');
```

```SQL
SELECT * FROM read_parquet('./*_playlists.parquet');
```