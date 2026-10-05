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

```

## Prise en main

**Exercice : Quelles playlists ont la plus forte audience ?**

```sql
SELECT playlist_name,
       num_followers,
       num_tracks
  FROM v_playlists
  ORDER BY num_followers DESC
  LIMIT 10;
┌────────────────────┬───────────────┬────────────┐
│   playlist_name    │ num_followers │ num_tracks │
│      varchar       │     int32     │   int32    │
├────────────────────┼───────────────┼────────────┤
│ That's What I Like │         71643 │         39 │
│ Breaking Bad       │         53519 │        106 │
│ One Tree Hill      │         45942 │        111 │
│ My Little Pony     │         31539 │         85 │
│ Q1                 │         27830 │         81 │
│ Jack's Playlist    │         23500 │         29 │
│ Rock Hits          │         22102 │         56 │
│ TOP POP            │         15842 │         52 │
│ FARRUKO            │         15123 │         13 │
│ Wiz Khalifa        │         14812 │        115 │
└────────────────────┴───────────────┴────────────┘
  10 rows                               3 columns
```

**Exercice : Enrichir les données**

- Transformer la donnée `duration_ms` en minutes → `duration_min`
- Stocker cette nouvelle donnée dans une vue complète `v_tracks_enriched`

Résultat attendu :

```sql
spotify D DESCRIBE v_tracks_enriched;
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
│ duration_min bigint │
└─────────────────────┘
```

# `view` → Non persisté (alias vers les données)

Toutes les opérations sont refaites à chaque appel de la vue. S'il y a des opération coûteuses (ex: multi jointures) alors c'est chiant.

# `table` → Les données sont persistées

# La question de l'Amour

```sql
CREATE VIEW romantic_playlists AS
            SELECT playlist_id, playlist_name
            FROM v_playlists
            WHERE playlist_name ILIKE '%love%';
```

```sql
SELECT
    t.track_uri, t.track_name, t.artist_name,
    COUNT(DISTINCT(t.playlist_id)) AS nb_playlists
    FROM v_tracks t
    JOIN romantic_playlists rp
        ON t.playlist_id = rp.playlist_id
    GROUP BY t.track_uri, t.track_name, t.artist_name
    ORDER BY nb_playlists DESC
    LIMIT 20;
``` 

# DBT

- Setup dbt : fichier yaml
- Ecrire les modèles dans ``./src/models``
  - Le nom du fichier sql → le nom de la table
- ``dbt run`` **à la racine du projet**

Si on veut consulter les données dans le warehouse :

- **A la racine du projet :**
  - `duckdb wharehouse/spotify.duckdb`
  - SELECT...
  - .table

# Les responsabilités

- Source : 32Go de JSON
- Script python `src\main_opti.py` → env. 2Go de ``parquet``
  - 2 tables : `playlists` & `tracks`
- ``dbt`` → Transformer des requêtes SQL en vues/tables duckdb en 3 couches
  - `staging` : Préparation des données (nettoyage, filtrage, enrichissement, etc.)
  - `intermediate` : Préparation de requêtes pour exploitation
  - `marts` : Agrégats métiers (business-level)
- `notebook (pandas/duckdb)` → Lire les `marts` → Afficher un DataFrame / Data viz / etc.