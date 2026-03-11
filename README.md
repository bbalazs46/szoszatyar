# szoszatyar

Kezdő webes prototípus egy rádióműsor-adatbázis online feldolgozásához.

## Mit tartalmaz most?

- egy statikus, böngészőben futó keresőfelületet
- javasolt adatstruktúrát az Excel importhoz
- a javasolt adatmodell SQLite-kompatibilis SQL sémáját a `schema.sql` fájlban
- mintaadatokat, amikkel a keresés és a szűrés kipróbálható

## Javasolt adatmodell az Excel importhoz

Az alábbi struktúra a repository gyökerében található `schema.sql` fájlban is elérhető,
így az Excelből érkező adatokhoz közvetlenül létrehozható az SQL adatbázis-séma.
SQLite használathoz érdemes közvetlenül ezt a fájlt futtatni (`sqlite3 adatbazis.db < schema.sql`),
mert issue- vagy HTML-környezetben a SQL operátorok egy része (például `>`) HTML-entitássá torzulhat.
A sémafájl csak a táblák és indexek létrehozását tartalmazza; az indexek létrehozása MySQL-kompatibilis `CREATE INDEX` szintaxist használ, ezért ugyanabba az adatbázisba újrafuttatva névütközés hibát adhat. A foreign key ellenőrzést SQLite-ban
kapcsolatonként külön kell bekapcsolni (például `PRAGMA foreign_keys = ON;` az adott kliensben vagy alkalmazásban).

A feltöltött Excel várhatóan többféle információt tartalmaz ugyanarról az adatkészletről: adás, téma, megszólaló, kapcsolódó hivatkozás, címke. Ehhez a következő szerkezet használható:

### `episodes`

| mező | típus | leírás |
| --- | --- | --- |
| `id` | integer / uuid | egyedi azonosító |
| `broadcast_date` | date | adás dátuma |
| `title` | text | adás címe |
| `description` | text | rövid összefoglaló |
| `notes` | text | szerkesztői megjegyzés |
| `source_row` | integer | Excel sor azonosításához |

### `topics`

| mező | típus | leírás |
| --- | --- | --- |
| `id` | integer / uuid | egyedi azonosító |
| `name` | text | téma neve |
| `slug` | varchar(255) | URL-barát azonosító |
| `category` | text | témacsoport |

### `people`

| mező | típus | leírás |
| --- | --- | --- |
| `id` | integer / uuid | egyedi azonosító |
| `name` | text | vendég / szerző / műsorvezető neve |
| `role` | text | szerepkör |

### Kapcsolótáblák

- `episode_topics(episode_id, topic_id, relevance)`
- `episode_people(episode_id, person_id, role_in_episode)`
- `episode_links(id, episode_id, label, url)`
- `episode_keywords(id, episode_id, keyword)`

## Javasolt Excel import folyamat

1. az Excel oszlopneveit normalizálni kell
2. minden sort egy adásként vagy egy adás-részletként kell feldolgozni
3. az adatok betöltése előtt ellenőrizni kell, hogy a `broadcast_date` mező `YYYY-MM-DD` formátumú, a `source_row` pedig üres vagy pozitív egész legyen
4. a több értéket tartalmazó mezőket (pl. témák, vendégek, kulcsszavak) darabolni kell
5. az ismétlődő témákat és neveket külön törzsadat táblába érdemes emelni
6. a keresőfelület az importált SQL adatokra vagy JSON exportokra is ráépíthető

## Indítás

Mivel ez egy statikus prototípus, elég egy egyszerű webszerver:

```bash
cd /home/runner/work/szoszatyar/szoszatyar
python3 -m http.server 8000
```

Ezután nyisd meg: <http://127.0.0.1:8000>
