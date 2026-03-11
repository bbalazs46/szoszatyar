PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS episodes (
  id INTEGER PRIMARY KEY,
  broadcast_date TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  notes TEXT,
  source_row INTEGER,
  CHECK (date(broadcast_date) IS NOT NULL),
  CHECK (broadcast_date GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'),
  CHECK (source_row IS NULL OR source_row > 0)
);

CREATE TABLE IF NOT EXISTS topics (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
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
