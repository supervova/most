<?php
$phrase['AI Alex'] = getphrase("AI Alex");
$blog_name = $phrase['AI Alex'];
$blog_description = $phrase['Author statistics'];
$blogsidebar = get_template("blogsidebar");
$blog_css = get_template("blog-css");
$final_html = get_template("clean_page_with_sidebar");

$page_content_html = get_template("ai");

$tpl = array(
  '{$blogsidebar}' => $blogsidebar,
  '{$blog_css}' => $blog_css,
  '{$page_content_html}' => $page_content_html,
);
$final_html = strtr($final_html, $tpl);
