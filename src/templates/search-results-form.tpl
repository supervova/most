<form
  class="search-results-form"
  data-search-form
  role="search"
  method="get"
  action="{$search.action}"
>
  <input
    class="search-results-input"
    name="{$search.param}"
    type="search"
    data-search-input
    placeholder="{$search.placeholder}"
    autocomplete="off"
  />
  <button class="search-results-submit button button-icon button-ghost" type="submit" aria-label="{$search.submit_label}">
    <svg class="icon" aria-hidden="true" focusable="false">
      <use xlink:href="/projects/most/icons/sprite.svg#icon-search"></use>
    </svg>
  </button>
</form>
