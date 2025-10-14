<!DOCTYPE html>
{$developedby}
<html lang="{$lng_html}" prefix="og: http://ogp.me/ns#">
<head>
<title>{$meta_title}</title>
<meta charset="utf-8">
<meta name="description" content="{$meta_description}"/>
{$meta_robots}
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0"/>

<meta name="twitter:card" content="summary_large_image"/>
<meta name="twitter:site" content="{$meta_title}"/>
<meta name="twitter:title" content="{$meta_title}">
<meta name="twitter:description" content="{$meta_description}"/>
<meta name="twitter:creator" content="{$blog_settings[twittercreator]}"/>
<meta name="twitter:image" content="{$ogimage_small}"/>
<meta name="twitter:domain" content="{$thisdomain}"/>

<meta property="og:locale" content="{$lng_html}"/>
{$ogtype}
<meta property="og:title" content="{$meta_title}"/>
<meta property="og:description" content="{$meta_description}"/>
<meta property="og:image" content="{$meta_ogimage}"/>
<meta property="og:url" content="{$thispageurl}"/>
<meta property="og:site_name" content="{$meta_title}"/>
<meta property="og:see_also" content="{$main_href}"/>
<meta property="fb:app_id" content="{$fb_app_id}" />

<meta content="G-G3N33Z8Y4J" name="google-site-verification"/>

<base href="{$base_href}">
{$canonical}
{$schemaorg}
<link rel="icon" type="image/png" href="/favicon-32x32.png" sizes="32x32" />
<link rel="icon" type="image/svg+xml" href="/favicon.svg" />
<link rel="shortcut icon" href="/favicon.ico" />
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png" />
<link rel="manifest" href="/manifest.json" />
<link href="/css/bootstrap.css" rel="stylesheet">
<link href="/css/jquery.toast.min.css" rel="stylesheet">
<link href="/css/main.css" rel="stylesheet">{$projectcss}
<link href="/css/smartphoto.min.css" rel="stylesheet">
{$addheadtags}
<link href="https://fonts.gstatic.com" rel="preconnect" crossorigin="anonymous"><script src="https://ajax.googleapis.com/ajax/libs/webfont/1.6.26/webfont.js" type="text/javascript"></script><script type="text/javascript">WebFont.load({  google: {    families: ["Merriweather:300,300italic,400,400italic,700,700italic,900,900italic","Lato:100,100italic,300,300italic,400,400italic,700,700italic,900,900italic","Tenor Sans:regular","Source Serif Pro:regular,700","Libre Franklin:regular,600","Inter:regular,600,700,italic:cyrillic,latin","Finlandica:regular,500,600,700,italic:cyrillic,latin", "Mrs Saint Delafield:regular,500,600,700,italic:cyrillic,latin"]  }});</script>
<style>
  body {
  -moz-font-feature-settings: "liga" on;
  -moz-osx-font-smoothing: grayscale;
  -webkit-font-smoothing: antialiased;
  font-feature-settings: "liga" on;
  text-rendering: optimizeLegibility;
}
</style>
<script>
// Handle critical JS execution errors
window.onerror = function (message, source, lineno, colno, error) {
  if (isCriticalJsError(message)) {
	if (!sessionStorage.getItem("scriptReloaded")) {
    sessionStorage.setItem("scriptReloaded", "true");
	  //alert("A critical JavaScript error has occurred:\n" + message + "\n\nThe page will now reload.");
	  location.reload();
	}
  }
  return false;
};

// Handle unhandled Promise rejections
window.addEventListener("unhandledrejection", function (event) {
  const reason = event.reason;
  const message = typeof reason === "string"
    ? reason
    : (reason && reason.message) || JSON.stringify(reason);

  if (isCriticalJsError(message)) {
	if (!sessionStorage.getItem("scriptReloaded")) {
    sessionStorage.setItem("scriptReloaded", "true");
		//alert("An unhandled promise error has occurred:\n" + message + "\n\nThe page will now reload.");
		location.reload();
	}
  }
});

// Handle failed <script> loads (e.g., 404, CORS)
window.addEventListener("error", function (event) {
  const target = event.target || event.srcElement;

  if (target instanceof HTMLScriptElement) {
	if (!sessionStorage.getItem("scriptReloaded")) {
    sessionStorage.setItem("scriptReloaded", "true");
		//alert("Failed to load a required script:\n" + target.src + "\n\nThe page will now reload.");
		location.reload();
	}
  }
}, true); // capture=true is required for <script> load errors

// Define what is considered a "critical" JS error
function isCriticalJsError(message) {
  if (!message) return false;

  const criticalKeywords = [
    "ReferenceError",
    "TypeError",
    "is not defined",
    "Cannot read",
    "undefined",
    "Unexpected"
  ];

  return criticalKeywords.some(keyword => message.includes(keyword));
}
</script>
<script src="/js/jquery-2.1.3.min.js"></script>  
<script src="/js/bootstrap.min.js"></script>
<script src="/js/jquery.toast.min.js"></script>
<script src="/js/bootpopup.js"></script>
<script src='/js/tinymce/tinymce.min.js'></script>
<script src='/js/tinymce/jquery.tinymce.min.js'></script>
<link rel="stylesheet" href="/js/tinymce/plugins/codesample/prism.css">
<script src="/js/tinymce/plugins/codesample/prism.js"></script>
<script src="/js/jquery-smartphoto.min.js"></script>
<script src="/js/qwerty.js"></script>
<script src="/js/jsshare.js"></script>
<script><!--
document.addEventListener("DOMContentLoaded", function(event) {
  var shareItems = document.querySelectorAll('.social_share');
  var isIOS = /iPad|iPhone|iPod/.test(navigator.platform)
    || (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1);
  var isAndroid = /(android)/i.test(navigator.userAgent);
  var options = {};
  if (isIOS || isAndroid) {
    options.link_telegram = 'tg://msg';
    options.link_whatsapp = 'whatsapp://send';
  }
  for (var i = 0; i < shareItems.length; i += 1) {
    shareItems[i].addEventListener('click', function share(e) {
      console.log(this);
      return JSShare.go(this, options);
    });
  }
});
--></script>
<script>
function js_translate(str) {
if (str == '{$phraseclose}') { str = '{$btn_close}'; } if (str == 'Close') { str = '{$btn_close}'; }
if (str == '{$phraseok}') { str = '{$btn_ok}'; }
if (str == '{$phrasecancel}') { str = '{$btn_cancel}'; }
if (str == '{$phraseyes}') { str = '{$btn_yes}'; }
if (str == '{$phraseno}') { str = '{$btn_no}'; }
return str;
}
</script>
</head>
<body>
{$header}
<div class="container maincontainer">
{$page_content_html}
</div>
{$loginform}
{$footer}
{$cookiesalert}
<script>
$(document).ready(function() {
$('.hidden-srch').show();
$('.hideinit').hide();
$('.not_{$country_code}').hide();
$('.not_{$user_lng}').hide();
$('.just_{$country_code}').show();
$('.just_{$user_lng}').show();
$('.not_{$user_lng}_{$country_code}').hide();
$('.just_{$user_lng}_{$country_code}').show();
});
</script>
</body>
</html>
