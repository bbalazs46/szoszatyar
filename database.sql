PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS episodes (
  id INTEGER PRIMARY KEY,
  broadcast_date TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  notes TEXT,
  source_row INTEGER
);

CREATE TABLE IF NOT EXISTS topics (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  slug VARCHAR(255) NOT NULL UNIQUE,
  category TEXT
);

CREATE TABLE IF NOT EXISTS people (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  role TEXT
);

CREATE TABLE IF NOT EXISTS episode_topics (
  episode_id INTEGER NOT NULL,
  topic_id INTEGER NOT NULL,
  relevance TEXT,
  PRIMARY KEY (episode_id, topic_id),
  FOREIGN KEY (episode_id) REFERENCES episodes (id) ON DELETE CASCADE,
  FOREIGN KEY (topic_id) REFERENCES topics (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS episode_people (
  episode_id INTEGER NOT NULL,
  person_id INTEGER NOT NULL,
  role_in_episode TEXT,
  PRIMARY KEY (episode_id, person_id),
  FOREIGN KEY (episode_id) REFERENCES episodes (id) ON DELETE CASCADE,
  FOREIGN KEY (person_id) REFERENCES people (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS episode_links (
  id INTEGER PRIMARY KEY,
  episode_id INTEGER NOT NULL,
  label TEXT,
  url TEXT NOT NULL,
  FOREIGN KEY (episode_id) REFERENCES episodes (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS episode_keywords (
  id INTEGER PRIMARY KEY,
  episode_id INTEGER NOT NULL,
  keyword TEXT NOT NULL,
  FOREIGN KEY (episode_id) REFERENCES episodes (id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_episodes_broadcast_date ON episodes (broadcast_date);
CREATE INDEX IF NOT EXISTS idx_topics_category ON topics (category);
CREATE INDEX IF NOT EXISTS idx_episode_topics_topic_id ON episode_topics (topic_id);
CREATE INDEX IF NOT EXISTS idx_episode_people_person_id ON episode_people (person_id);
CREATE INDEX IF NOT EXISTS idx_episode_links_episode_id ON episode_links (episode_id);
CREATE INDEX IF NOT EXISTS idx_episode_keywords_episode_id ON episode_keywords (episode_id);

INSERT INTO episodes (id, broadcast_date, title, description, notes, source_row) VALUES
  (1, '2024-09-12', 'Nyelv és város – élő beszéd a mindennapokban', 'Beszélgetés a városi nyelvhasználatról, új szlengformákról és a hallgatói levelekben visszatérő kérdésekről.', NULL, 2),
  (2, '2023-04-18', 'Archívumból előkerült történetek', 'Régi rádiós felvételek feldolgozása, digitalizálási tapasztalatok és háttéranyagok bemutatása.', NULL, 3),
  (3, '2024-02-06', 'Kortárs irodalom a mikrofon mögött', 'Interjú kortárs szerzőkkel új könyvekről, felolvasásokról és rádiós adaptációkról.', NULL, 4),
  (4, '2025-01-21', 'Mesterséges intelligencia a rádióban', 'Automatikus leiratkészítés, témacímkézés és kereshető műsorarchívum lehetőségei.', NULL, 5);

INSERT INTO topics (id, name, slug, category) VALUES
  (1, 'nyelvhasználat', 'nyelvhasznalat', 'Nyelvészet'),
  (2, 'városi kultúra', 'varosi-kultura', 'Kultúra'),
  (3, 'archívum', 'archivum', 'Médiatörténet'),
  (4, 'digitalizálás', 'digitalizalas', 'Technológia'),
  (5, 'irodalom', 'irodalom', 'Kultúra'),
  (6, 'interjú', 'interju', 'Beszélgetés'),
  (7, 'mesterséges intelligencia', 'mesterseges-intelligencia', 'Technológia'),
  (8, 'adatbázis', 'adatbazis', 'Technológia');

INSERT INTO people (id, name, role) VALUES
  (1, 'Kovács Júlia', 'műsorvezető'),
  (2, 'Tóth András', 'nyelvész'),
  (3, 'Fekete Réka', 'szerkesztő'),
  (4, 'Nagy Péter', 'archivista'),
  (5, 'Szabó Lilla', 'író'),
  (6, 'Varga Dénes', 'fejlesztő');

INSERT INTO episode_topics (episode_id, topic_id, relevance) VALUES
  (1, 1, NULL),
  (1, 2, NULL),
  (2, 3, NULL),
  (2, 4, NULL),
  (3, 5, NULL),
  (3, 6, NULL),
  (4, 7, NULL),
  (4, 8, NULL);

INSERT INTO episode_people (episode_id, person_id, role_in_episode) VALUES
  (1, 1, 'műsorvezető'),
  (1, 2, 'nyelvész'),
  (2, 3, 'szerkesztő'),
  (2, 4, 'archivista'),
  (3, 1, 'műsorvezető'),
  (3, 5, 'író'),
  (4, 4, 'archivista'),
  (4, 6, 'fejlesztő');

INSERT INTO episode_keywords (id, episode_id, keyword) VALUES
  (1, 1, 'szleng'),
  (2, 1, 'hallgatói kérdések'),
  (3, 1, 'élő nyelv'),
  (4, 2, 'hanganyag'),
  (5, 2, 'restaurálás'),
  (6, 2, 'metaadat'),
  (7, 3, 'felolvasás'),
  (8, 3, 'könyvbemutató'),
  (9, 3, 'adaptáció'),
  (10, 4, 'AI'),
  (11, 4, 'leirat'),
  (12, 4, 'keresés');
