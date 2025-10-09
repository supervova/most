const OPEN_CLASS = 'search-modal-open';
const BODY_LOCK_CLASS = 'page-search-locked';
const SUPPORTED_LANGS = ['ru', 'en', 'es', 'de', 'fr', 'it', 'pt'];

/**
 * @typedef {Object} SearchOptions
 * @property {string} [resultsPage] - Шаблон пути к странице результатов (поддерживает {lang} и {query}).
 */

/**
 * Инициализирует модальное окно поиска.
 * @param {SearchOptions} [options] - Параметры инициализации.
 */
export const initSearch = (options = {}) => {
  const toggles = document.querySelectorAll('[data-search-toggle]');
  const modal = document.querySelector('[data-search-modal]');

  if (!toggles.length || !modal) {
    return;
  }

  const form = modal.querySelector('[data-search-form]');
  const input = modal.querySelector('[data-search-input]');
  const dismissButtons = modal.querySelectorAll('[data-search-dismiss]');
  const exampleButtons = modal.querySelectorAll('[data-search-example]');

  if (!form || !input) {
    return;
  }

  const resultsPageTemplate = (
    options.resultsPage ||
    modal.dataset.searchResults ||
    '/{lang}/search/{query}'
  ).trim();

  let isOpen = false;
  let lastTrigger = null;

  const setExpanded = (state) => {
    toggles.forEach((toggle) => {
      toggle.setAttribute('aria-expanded', state ? 'true' : 'false');
    });
  };

  const lockScroll = (state) => {
    document.documentElement.classList.toggle(BODY_LOCK_CLASS, state);
    document.body.style.overflow = state ? 'hidden' : '';
  };

  const focusInput = () => {
    requestAnimationFrame(() => {
      input.focus();
      input.select();
    });
  };

  function close() {
    if (!isOpen) {
      return;
    }
    isOpen = false;
    modal.classList.remove(OPEN_CLASS);
    modal.setAttribute('aria-hidden', 'true');
    lockScroll(false);
    setExpanded(false);
    // eslint-disable-next-line no-use-before-define
    document.removeEventListener('keydown', handleKeydown);
    if (lastTrigger) {
      lastTrigger.focus();
    }
  }

  function handleKeydown(event) {
    if (event.key === 'Escape') {
      close();
    }
  }

  const open = (trigger) => {
    if (isOpen) {
      return;
    }
    lastTrigger = trigger || null;
    isOpen = true;
    modal.classList.add(OPEN_CLASS);
    modal.setAttribute('aria-hidden', 'false');
    lockScroll(true);
    setExpanded(true);
    document.addEventListener('keydown', handleKeydown);
    focusInput();
  };

  const resolveLanguage = () => {
    const raw = (document.documentElement.lang || '').toLowerCase();
    const normalized = raw.replace('_', '-');
    const [base] = normalized.split('-');
    if (SUPPORTED_LANGS.includes(base)) {
      return base;
    }
    return 'ru';
  };

  const normalizeTemplate = (language, query) => {
    const encodedQuery = encodeURIComponent(query);
    if (resultsPageTemplate.includes('{query}')) {
      return resultsPageTemplate
        .replaceAll('{lang}', language)
        .replaceAll('{query}', encodedQuery);
    }

    const pathWithLang = resultsPageTemplate.includes('{lang}')
      ? resultsPageTemplate.replaceAll('{lang}', language)
      : `/${language}${resultsPageTemplate.startsWith('/') ? '' : '/'}${resultsPageTemplate}`;

    const trimmedBase = pathWithLang.replace(/\/+$/, '');
    return `${trimmedBase}/${encodedQuery}`;
  };

  const buildTargetUrl = (query) => {
    const language = resolveLanguage();
    const path = normalizeTemplate(language, query);
    if (/^https?:\/\//.test(path)) {
      return path;
    }
    return path.startsWith('/') ? path : `/${path}`;
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    const query = input.value.trim();

    if (!query) {
      input.focus();
      return;
    }

    window.location.assign(buildTargetUrl(query));
  };

  toggles.forEach((toggle) => {
    toggle.addEventListener('click', (event) => {
      event.preventDefault();
      open(toggle);
    });
  });

  dismissButtons.forEach((button) => {
    button.addEventListener('click', (event) => {
      event.preventDefault();
      close();
    });
  });

  form.addEventListener('submit', handleSubmit);

  exampleButtons.forEach((button) => {
    button.addEventListener('click', () => {
      input.value = button.textContent.trim();
      focusInput();
    });
  });
};

const boot = () => {
  initSearch();
};

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', boot);
} else {
  boot();
}

export default initSearch;
