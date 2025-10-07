<!-- Access denied! -->






































































































































































































<!DOCTYPE html>
<html lang="{$user_lng}" prefix="og: http://ogp.me/ns#">
<head>
<title>{$meta_title}</title>
<meta charset="utf-8">
<meta name="description" content="{$meta_description}"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0"/>
<meta name="robots" content="noindex, nofollow">
<meta name="yandex" content="noindex, nofollow">
<script>
  document.addEventListener("DOMContentLoaded", function () {
    if (window.top === window) {
      // Страница НЕ во фрейме
      document.body.innerHTML = "Access denied!";
    }
  });
</script>
<style>
a {
  color: gray;
  text-decoration: none;
  transition: color 0.2s ease-in-out;
}

a:hover {
  color: black;
}
</style>
</head>
<body style="padding:20px;">
<div style="max-width:800px;margin:0 auto;">
{$page_content_html}
</div>
</body>
</html>
