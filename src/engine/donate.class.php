<?php
if ($user_lng == 'ru')
{
	$meta_title = "Поддержите авторов «Моста»";
	$meta_description = "Давайте строить «Мост» вместе!";
}
elseif ($user_lng == 'en')
{
	$meta_title = getphrase("Support our authors!");
	$meta_description = getphrase("Help us in our fight for truth and freedom of speech!");
}

$blog_name = $meta_title;
$blog_description = $meta_description;
$supportustext = $meta_title;

$final_html = get_template("clean_page");
$page_content_html = get_template("donate");

$tpl = array(
  '{$page_content_html}' => $page_content_html
);
$final_html = strtr($final_html, $tpl);
