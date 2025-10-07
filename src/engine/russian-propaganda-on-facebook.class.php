<?php
//if (!isset($_GET['devtest']) && !isset($_COOKIE['devtest'])) die("Ожидает публикации...");
//if (!isset($_COOKIE['devtest']))
//{
//	savecookie('devtest','ok',time()+86400*100);
//}
//if (isset($_GET['devtest']))
if ($user_lng != 'ru' && $user_lng != 'en')
{
	$phrase['justlng'] = getphrase("This investigation is available only in Russian and English!");
	echo <<<HTML
<script>
alert('{$phrase['justlng']}');
location.href = 'https://mostnews.org/en/russian-propaganda-on-facebook';
</script>
HTML;
	die();
}

$profilemenuitem = "";
$alertmsg = "";
$stupidlink = "";

$meta_title = getphrase("Manipulation algorithms.");
$meta_description = getphrase("How Russian Propaganda Spreads on Facebook")." | ".getphrase("Investigative journalism.");

$blog_name = $meta_title;
$blog_description = $meta_description;
$supportustext = getphrase("Support us!");

$supportus = get_template("supportus");

$final_html = get_template("clean_page");

$addheadtags = <<<HTML
<link href="/projects/most/css/propaganda1/font-awesome.min.css?v={$engineversion}" rel="stylesheet">
<link href="/projects/most/css/propaganda1/style-library-1.css?v={$engineversion}" rel="stylesheet">
<link href="/projects/most/css/propaganda1/plugins.css?v={$engineversion}" rel="stylesheet">
<link href="/projects/most/css/propaganda1/blocks.css?v={$engineversion}" rel="stylesheet">
<link href="/projects/most/css/propaganda1/custom.css?v={$engineversion}" rel="stylesheet">
<!-- HTML5 shim, for IE6-8 support of HTML5 elements. All other JS at the end of file. -->         
<!--[if lt IE 9]>
<script src="/projects/most/js/propaganda/html5shiv.js?v={$engineversion}"></script>
<script src="/projects/most/js/propaganda/respond.min.js?v={$engineversion}"></script>
<![endif]-->         
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Inter:300,400,500,600,700,800,900,200,600italic,500italic,700italic&display=swap">
HTML;

if ($country_code == 'US' && $user_lng != 'ru')
{
	$authorphoto = "";
	$authorhtml = <<<HTML
MAX NEWMAN
HTML;
	$authorphoto = <<<HTML
<div style="background-image: url('/projects/most/images/propaganda1/maksim-novichkov.jpg'); background-position: center center; background-size: cover; width: 60px; height: 60px; background-repeat: no-repeat; border-radius: 10px; opacity: 80%;"></div>
HTML;
	$authorhtml = <<<HTML
<a href="/team-members/maxim-novichkov" target="_blank">Maxim Novichkov</a>
HTML;
}
else
{
	$authorphoto = <<<HTML
<div style="background-image: url('/projects/most/images/propaganda1/maksim-novichkov.jpg'); background-position: center center; background-size: cover; width: 60px; height: 60px; background-repeat: no-repeat; border-radius: 10px; opacity: 80%;"></div>
HTML;
	$authorhtml = <<<HTML
<a href="/team-members/maxim-novichkov" target="_blank">Максим Новичков</a>
HTML;
}

if ($user_lng == 'ru')
{
	$page_content_html = get_template("russian-propaganda-on-facebook");
}
elseif ($user_lng == 'en')
{
	$page_content_html = get_template("russian-propaganda-on-facebook-en");
}
else
{
	Header('Location: '.str_replace("/".$user_lng."/", "/en/", $thispagesimpleurl));
	die();	
}

$tpl = array(
  '{$page_content_html}' => $page_content_html
);
$final_html = strtr($final_html, $tpl);

if ($user_lng != 'ru')
{
	$final_html = str_replace("title.png", "title-en.png", $final_html);
}