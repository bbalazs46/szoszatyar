const episodes = [
  {
    id: 1,
    title: 'Nyelv és város – élő beszéd a mindennapokban',
    broadcastDate: '2024-09-12',
    description:
      'Beszélgetés a városi nyelvhasználatról, új szlengformákról és a hallgatói levelekben visszatérő kérdésekről.',
    topics: [
      { name: 'nyelvhasználat', category: 'Nyelvészet' },
      { name: 'városi kultúra', category: 'Kultúra' },
    ],
    people: ['Kovács Júlia (műsorvezető)', 'Tóth András (nyelvész)'],
    keywords: ['szleng', 'hallgatói kérdések', 'élő nyelv'],
  },
  {
    id: 2,
    title: 'Archívumból előkerült történetek',
    broadcastDate: '2023-04-18',
    description:
      'Régi rádiós felvételek feldolgozása, digitalizálási tapasztalatok és háttéranyagok bemutatása.',
    topics: [
      { name: 'archívum', category: 'Médiatörténet' },
      { name: 'digitalizálás', category: 'Technológia' },
    ],
    people: ['Fekete Réka (szerkesztő)', 'Nagy Péter (archivista)'],
    keywords: ['hanganyag', 'restaurálás', 'metaadat'],
  },
  {
    id: 3,
    title: 'Kortárs irodalom a mikrofon mögött',
    broadcastDate: '2024-02-06',
    description:
      'Interjú kortárs szerzőkkel új könyvekről, felolvasásokról és rádiós adaptációkról.',
    topics: [
      { name: 'irodalom', category: 'Kultúra' },
      { name: 'interjú', category: 'Beszélgetés' },
    ],
    people: ['Kovács Júlia (műsorvezető)', 'Szabó Lilla (író)'],
    keywords: ['felolvasás', 'könyvbemutató', 'adaptáció'],
  },
  {
    id: 4,
    title: 'Mesterséges intelligencia a rádióban',
    broadcastDate: '2025-01-21',
    description:
      'Automatikus leiratkészítés, témacímkézés és kereshető műsorarchívum lehetőségei.',
    topics: [
      { name: 'mesterséges intelligencia', category: 'Technológia' },
      { name: 'adatbázis', category: 'Technológia' },
    ],
    people: ['Varga Dénes (fejlesztő)', 'Nagy Péter (archivista)'],
    keywords: ['AI', 'leirat', 'keresés'],
  },
];

const searchInput = document.querySelector('#search');
const topicFilter = document.querySelector('#topicFilter');
const yearFilter = document.querySelector('#yearFilter');
const results = document.querySelector('#results');
const resultsSummary = document.querySelector('#resultsSummary');
const clearFiltersButton = document.querySelector('#clearFilters');
const resultTemplate = document.querySelector('#resultTemplate');

const uniqueTopicCategories = [...new Set(episodes.flatMap((episode) => episode.topics.map((topic) => topic.category)))].sort();
const uniqueYears = [...new Set(episodes.map((episode) => new Date(episode.broadcastDate).getFullYear()))].sort((a, b) => b - a);

function fillSelect(select, values) {
  values.forEach((value) => {
    const option = document.createElement('option');
    option.value = String(value);
    option.textContent = String(value);
    select.append(option);
  });
}

function normalizeText(value) {
  return value
    .normalize('NFD')
    .replace(/[\u0300-\u036f]/g, '')
    .toLowerCase();
}

function matchesSearch(episode, query) {
  if (!query) {
    return true;
  }

  const haystack = normalizeText(
    [
      episode.title,
      episode.description,
      ...episode.people,
      ...episode.keywords,
      ...episode.topics.map((topic) => topic.name),
      ...episode.topics.map((topic) => topic.category),
    ].join(' ')
  );

  return haystack.includes(normalizeText(query));
}

function renderResults(filteredEpisodes) {
  results.replaceChildren();

  if (!filteredEpisodes.length) {
    const empty = document.createElement('div');
    empty.className = 'empty-state';
    empty.textContent = 'Nincs találat a megadott szűrőkre.';
    results.append(empty);
    resultsSummary.textContent = '0 találat';
    return;
  }

  filteredEpisodes.forEach((episode) => {
    const fragment = resultTemplate.content.cloneNode(true);
    fragment.querySelector('.result-date').textContent = new Date(episode.broadcastDate).toLocaleDateString('hu-HU');
    fragment.querySelector('.result-year').textContent = String(new Date(episode.broadcastDate).getFullYear());
    fragment.querySelector('.result-title').textContent = episode.title;
    fragment.querySelector('.result-description').textContent = episode.description;
    fragment.querySelector('.result-topics').textContent = episode.topics.map((topic) => `${topic.name} (${topic.category})`).join(', ');
    fragment.querySelector('.result-people').textContent = episode.people.join(', ');
    fragment.querySelector('.result-keywords').textContent = episode.keywords.join(', ');
    results.append(fragment);
  });

  resultsSummary.textContent = `${filteredEpisodes.length} találat`;
}

function applyFilters() {
  const query = searchInput.value.trim();
  const selectedCategory = topicFilter.value;
  const selectedYear = yearFilter.value;

  const filtered = episodes.filter((episode) => {
    const hasCategory = !selectedCategory || episode.topics.some((topic) => topic.category === selectedCategory);
    const hasYear = !selectedYear || String(new Date(episode.broadcastDate).getFullYear()) === selectedYear;
    return hasCategory && hasYear && matchesSearch(episode, query);
  });

  renderResults(filtered);
}

fillSelect(topicFilter, uniqueTopicCategories);
fillSelect(yearFilter, uniqueYears);
renderResults(episodes);

[searchInput, topicFilter, yearFilter].forEach((element) => {
  element.addEventListener('input', applyFilters);
  element.addEventListener('change', applyFilters);
});

clearFiltersButton.addEventListener('click', () => {
  searchInput.value = '';
  topicFilter.value = '';
  yearFilter.value = '';
  renderResults(episodes);
});
