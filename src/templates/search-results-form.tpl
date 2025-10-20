<form
  class="search-results-form"
  data-search-form
  role="search"
  method="get"
  action="{$blogsearch_url}"
>
  <input
    class="search-results-input"
    name="q"
    type="search"
    data-search-input
    placeholder="Search..."
    autocomplete="off"
    value="{$blogsearch}"
  />
  <button class="search-results-submit button button-icon button-ghost" type="submit" aria-label="Find">
    <svg class="icon" aria-hidden="true" focusable="false">
      <use xlink:href="/projects/most/icons/sprite.svg#icon-search"></use>
    </svg>
  </button>
</form>

<div class="trnsltphrss">
<span>Search...</span>
<span>Find</span>
</div>
