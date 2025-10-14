<link href="/projects/most/css/enhancements.css?v=202510141429" rel="stylesheet">

<div id="p_prldr">
  <div class="contpre">
    <img src="/projects/most/images/logo-square.png" style="width:81px;height:81px;border-radius:50%" class="spinner" alt="" />
    <br />
    <small>loading...</small>
  </div>
</div>
<script>
  (function () {
    const preloader = document.getElementById('p_prldr');
    const getOverlay = () => document.getElementById('w-nav-overlay-0');
    const getMenu = () => document.querySelector('[data-nav-menu-open]');
    const getSandwichButton = () => document.getElementById('sandwichbutton');
    const getNavOverlayForm = () => document.querySelector('.nav-overlay-form');

    const hidePreloader = () => {
      if (!preloader || preloader.style.display === 'none') {
        return;
      }
      preloader.style.opacity = '0';
      setTimeout(() => {
        preloader.style.display = 'none';
      }, 300);
    };

    const showOverlay = () => {
      const overlay = getOverlay();
      if (overlay) {
        overlay.style.display = 'block';
      }
      document.body.style.overflow = 'hidden';
    };

    const hideOverlay = () => {
      const overlay = getOverlay();
      if (overlay) {
        overlay.style.display = 'none';
      }
      document.body.style.overflow = '';
    };

    window.sandwich = function (act) {
      const menu = getMenu();
      if (!menu) {
        return;
      }

      if (typeof act === 'undefined') {
        const isHidden = getComputedStyle(menu).display === 'none';
        if (isHidden) {
          menu.style.setProperty('display', 'block', 'important');
          showOverlay();
        } else {
          menu.style.setProperty('display', 'none', 'important');
          hideOverlay();
        }
      } else if (act === 'close') {
        menu.style.setProperty('display', 'none', 'important');
        hideOverlay();
      }
    };

    const handleOutsideClick = (event) => {
      const menu = getMenu();
      const target = event.target;
      if (!menu) {
        return;
      }
      const sandwichButton = getSandwichButton();
      const navOverlayForm = getNavOverlayForm();
      if (
        !menu.contains(target) &&
        !(navOverlayForm && navOverlayForm.contains(target)) &&
        !(sandwichButton && sandwichButton.contains(target))
      ) {
        window.sandwich('close');
      }
    };

    const onLoad = () => {
      hideOverlay();
      hidePreloader();

      const bgVideo = document.getElementById('bgvideo');
      if (bgVideo) {
        const loadSrc = bgVideo.getAttribute('loadsrc');
        if (loadSrc) {
          bgVideo.src = loadSrc;
        }
      }

      document.addEventListener('click', handleOutsideClick);
      window.addEventListener('resize', () => window.sandwich('close'));
    };

    window.setTimeout(hidePreloader, 4500);

    if (document.readyState === 'complete') {
      onLoad();
    } else {
      window.addEventListener('load', onLoad);
    }
  })();
</script>

{$antiframe}
{$pushstatejs}

<div
  data-collapse="medium"
  data-animation="default"
  data-duration="400"
  data-easing="ease"
  data-easing2="ease"
  role="banner"
  class="navigation w-nav site-header"
>
  <div class="navigation-container site-header-inner">
    <a href="" class="logo w-inline-block site-header-logo">
      <img src="{$logofile}" alt="" class="image-logo site-header-logo-image" />
    </a>
    <nav role="navigation" class="nav-menu w-nav-menu site-header-nav">
      <a href="category/politics" class="navigation-link w-inline-block">
        <div class="navigation-link-text">Politics</div>
        <div class="navigation-hover"></div>
      </a>
      <a href="category/conflicts" class="navigation-link w-inline-block">
        <div class="navigation-link-text">Conflicts</div>
        <div class="navigation-hover"></div>
      </a>
      <a href="category/economy" class="navigation-link w-inline-block">
        <div class="navigation-link-text">Economy</div>
        <div class="navigation-hover"></div>
      </a>
      <a href="category/opinions" class="navigation-link w-inline-block">
        <div class="navigation-link-text">Opinions</div>
        <div class="navigation-hover"></div>
      </a>
      <a href="category/culture" class="navigation-link w-inline-block">
        <div class="navigation-link-text">Culture</div>
        <div class="navigation-hover"></div>
      </a>

      <button
        class="button button-icon button-ghost site-header-search"
        data-search-toggle
        aria-haspopup="dialog"
        aria-controls="search-modal"
        aria-expanded="false"
        aria-label="Поиск"
      >
        <svg class="icon" aria-hidden="true" focusable="false">
          <use xlink:href="/projects/most/icons/sprite.svg#icon-search"></use>
        </svg>
      </button>

      <a href="support" class="navigation-link-subscribe w-inline-block site-header-cta">
        <div class="navigation-link-text-subscribe visible-lg">Support us</div>
      </a>
    </nav>
    <div class="navigation-actions site-header-actions">
      <div id="sandwichbutton" class="menu-button w-nav-button" onclick="sandwich()">
        <div class="icon-200 w-icon-nav-menu"></div>
      </div>
    </div>
  </div>
</div>

<div class="w-nav-overlay" data-wf-ignore id="w-nav-overlay-0" style="height: 100%; display: none;">
  <div
    class="nav-overlay"
  >
    <form
      class="nav-overlay-form"
      action="/search"
      data-search-form
      role="search"
      method="get"
    >
      <input
        class="nav-overlay-input"
        name="q"
        type="search"
        data-search-input
        placeholder="Найти"
        autocomplete="off"
      />
      <button class="nav-overlay-submit button button-icon button-ghost" type="submit" aria-label="Отправить">
        <svg class="icon" aria-hidden="true" focusable="false">
          <use xlink:href="/projects/most/icons/sprite.svg#icon-search"></use>
        </svg>
      </button>
    </form>

    <nav
      role="navigation"
      class="nav-menu w-nav-menu"
      style="transition: all, transform 400ms; transform: translateY(0px) translateX(0px);"
      data-nav-menu-open
    >
      <a href="/category/politics" class="navigation-link w-inline-block"><div class="navigation-link-text">Politics</div></a>
      <a href="/category/conflicts" class="navigation-link w-inline-block"><div class="navigation-link-text">Conflicts</div></a>
      <a href="/category/economy" class="navigation-link w-inline-block"><div class="navigation-link-text">Economy</div></a>
      <a href="/category/opinions" class="navigation-link w-inline-block"><div class="navigation-link-text">Opinions</div></a>
      <a href="/category/culture" class="navigation-link w-inline-block"><div class="navigation-link-text">Culture</div></a>
      <a href="/special-projects" class="navigation-link w-inline-block"><div class="navigation-link-text">Special projects</div></a>
      <a href="/support" class="navigation-link-subscribe w-inline-block"><div class="navigation-link-text-subscribe">Support us</div></a>
    </nav>
  </div>
</div>

<section
  class="search-modal"
  id="search-modal"
  data-search-modal
  data-search-results="/search"
  data-search-param="q"
  role="dialog"
  aria-modal="true"
  aria-labelledby="search-modal-title"
  aria-hidden="true"
>
  <div class="search-modal-backdrop" data-search-dismiss></div>
  <div class="search-modal-content" role="document">
    <form
      class="search-modal-form"
      action="/search"
      data-search-form
      role="search"
      method="get"
    >
      <label class="visually-hidden" for="search-query">
        Поисковый запрос
      </label>
      <input
        class="search-modal-input"
        id="search-query"
        name="q"
        type="search"
        data-search-input
        placeholder="Найти"
        autocomplete="off"
      />
      <button class="button button-icon button-ghost search-modal-submit" type="submit" aria-label="Отправить">
        <svg class="icon" aria-hidden="true" focusable="false">
          <use xlink:href="/projects/most/icons/sprite.svg#icon-search"></use>
        </svg>
      </button>
    </form>

    <ul class="search-modal-suggestions" aria-label="Популярные запросы">
      <li>
        <a
          class="button search-modal-suggestion"
          href="/ru/search/Навальный"
        >
          <svg class="icon icon-sm" aria-hidden="true" focusable="false">
            <use xlink:href="/projects/most/icons/sprite.svg#icon-sm-search"></use>
          </svg>
          Навальный
        </a>
      </li>
      <li>
        <a
          class="button search-modal-suggestion"
          href="/ru/search/Война+в+Украине"
        >
          <svg class="icon icon-sm" aria-hidden="true" focusable="false">
            <use xlink:href="/projects/most/icons/sprite.svg#icon-sm-search"></use>
          </svg>
          Война в Украине
        </a>
      </li>
      <li>
        <a
          class="button search-modal-suggestion"
          href="/ru/search/Фабрика+троллей"
        >
          <svg class="icon icon-sm" aria-hidden="true" focusable="false">
            <use xlink:href="/projects/most/icons/sprite.svg#icon-sm-search"></use>
          </svg>
          Фабрика троллей
        </a>
      </li>
      <li>
        <a
          class="button search-modal-suggestion"
          href="/ru/search/Санкции"
        >
          <svg class="icon icon-sm" aria-hidden="true" focusable="false">
            <use xlink:href="/projects/most/icons/sprite.svg#icon-sm-search"></use>
          </svg>
          Санкции
        </a>
      </li>
    </ul>
  </div>
</section>

<script src="/projects/most/js/search.js?v=202510141429" type="module"></script>
