<?php
if ($user_lng == 'ru')
{
	$meta_title = "Свяжись anonymno!";
	$meta_description = "Безопасная передача информации проекту МОСТ";
}
else
{
	$meta_title = getphrase("Inform safely");
	$meta_description = getphrase("Secure transfer of information to the MOST project");
}

$blog_name = $meta_title;
$blog_description = $meta_description;
$supportustext = $meta_title;

$final_html = get_template("clean_page");
$page_content_html = "TEST";

$tpl = array(
  '{$page_content_html}' => $page_content_html
);
$final_html = strtr($final_html, $tpl);
