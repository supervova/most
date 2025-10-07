<?php
if (!$islogged)
{
	memcache_close($memcache_obj);
	if ($db) $db->close();
	header('Location: https://'.$authhost.'/auth?returl='.$thispagesimpleurl);
	die();
}
if ($user_id != 18) die("На доработке...");
$phrase['Author statistics'] = getphrase("Author statistics");
$blog_name = $phrase['Author statistics'];
$blog_description = $phrase['Author statistics'];
$blogsidebar = get_template("blogsidebar");
$blog_css = get_template("blog-css");
$final_html = get_template("clean_page_with_sidebar");

$page_content_html = get_template("authorstat");

$tpl = array(
  '{$blogsidebar}' => $blogsidebar,
  '{$blog_css}' => $blog_css,
  '{$page_content_html}' => $page_content_html,
);
$final_html = strtr($final_html, $tpl);
