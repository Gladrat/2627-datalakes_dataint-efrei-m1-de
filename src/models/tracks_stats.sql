SELECT COUNT(*)
FROM {{ source('silver', 'tracks') }}