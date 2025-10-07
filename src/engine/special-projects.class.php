<?php
$meta_title = getphrase("Special projects and investigations");
$meta_description = $config['project_name'].": ".getphrase("Special projects and investigations");

$blog_name = $meta_title;
$blog_description = $meta_description;
$supportustext = $meta_title;

$supportustext = getphrase("Support our work!");

$supportus = get_template("supportus");

$final_html = get_template("clean_page");
$page_content_html = get_template("special-projects");

$tpl = array(
  '{$page_content_html}' => $page_content_html
);
$final_html = strtr($final_html, $tpl);
