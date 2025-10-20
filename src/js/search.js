const OPEN_CLASS = 'search-modal-open';
const BODY_LOCK_CLASS = 'page-search-locked';
const SUPPORTED_LANGS = ['ru', 'en', 'es', 'de', 'fr', 'it', 'pt'];

/**
 * @typedef {Object} SearchOptions
 * @property {string} [resultsPage] - Шаблон пути к странице результатов (поддерживает {lang} и {query}).
 */

/**
 * Инициализирует формы поиска и модальное окно.
 * @param {SearchOptions} [options] - Параметры инициализации.
 */
export const initSearch = (options = {}) => {
  const toggles = document.querySelectorAll('[data-search-toggle]');
  const modal = document.querySelector('[data-search-modal]');
  const forms = document.querySelectorAll('[data-search-form]');

  if (!forms.length && !toggles.length) {
    return;
  }

  const resultsPageTemplate = (
    options.resultsPage ||
    (modal && modal.dataset.searchResults) ||
    '/{lang}/search/{query}'
  ).trim();

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
    if (resultsPageTemplate.includes('{query}')) {
      return resultsPageTemplate
        .replaceAll('{lang}', language)
        .replaceAll('{query}', query);
    }

    const pathWithLang = resultsPageTemplate.includes('{lang}')
      ? resultsPageTemplate.replaceAll('{lang}', language)
      : `/${language}${resultsPageTemplate.startsWith('/') ? '' : '/'}${resultsPageTemplate}`;

    const trimmedBase = pathWithLang.replace(/\/+$/, '');
    return `${trimmedBase}/${query}`;
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
    const form = event.currentTarget;
    const input = form.querySelector('[data-search-input]');

    if (!input) {
      return;
    }

    const query = input.value.trim();

    if (!query) {
      input.focus();
      return;
    }

    window.location.assign(buildTargetUrl(query));
  };

  forms.forEach((form) => {
    form.addEventListener('submit', handleSubmit);
  });

  // --- Modal-specific logic ---
  if (!toggles.length || !modal) {
    return;
  }

  const modalInput = modal.querySelector('[data-search-input]');
  const dismissButtons = modal.querySelectorAll('[data-search-dismiss]');
  const suggestionsList = modal.querySelector('.search-modal-suggestions');

  if (!modalInput) {
    return;
  }

  // --- Suggestions Logic ---
  const suggestionsHandler = (() => {
    if (!suggestionsList) return null;

    const staticSuggestions = ['War in Ukraine', 'Zelenskyy', 'Putin', 'Trump'];
    let dynamicSuggestions = [];
    try {
      dynamicSuggestions = JSON.parse(modal.dataset.searchSuggestions || '[]');
    } catch (e) {
      // eslint-disable-next-line no-console
      console.error('Failed to parse search suggestions:', e);
    }

    const allSuggestions =
      dynamicSuggestions.length > 0 ? dynamicSuggestions : staticSuggestions;
    const initialSuggestions = allSuggestions.slice(0, 5);

    const render = (queries) => {
      const lang = resolveLanguage();
      suggestionsList.innerHTML = queries
        .map(
          (query) => `
        <li>
          <a class="button search-modal-suggestion" href="/${lang}/search/${encodeURIComponent(query)}">
            <svg class="icon icon-sm" aria-hidden="true" focusable="false" role="img"><use href="/projects/most/icons/sprite.svg#icon-sm-search"></use></svg>
            ${query}
          </a>
        </li>
      `
        )
        .join('');
    };

    const filter = () => {
      const value = modalInput.value.trim().toLowerCase();
      if (value.length < 3) {
        render(initialSuggestions);
        return;
      }
      const filtered = allSuggestions
        .filter((s) => s.toLowerCase().includes(value))
        .slice(0, 5);
      render(filtered);
    };

    const reset = () => {
      modalInput.value = '';
      render(initialSuggestions);
    };

    modalInput.addEventListener('input', filter);

    return { reset };
  })();
  // --- End of Suggestions Logic ---

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
      modalInput.focus();
      modalInput.select();
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

    if (suggestionsHandler) {
      suggestionsHandler.reset();
    }

    focusInput();
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
