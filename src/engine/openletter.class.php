<?php
if (!in_array($thispath[2], array('1')))
{
	Header('Location: /');
	exit;
}

if ($thispath[2] == 1)
{
	$meta_title = getphrase("Open Letter to President Donald J. Trump, Members of Congress, and the American People");
	$meta_description = getphrase("Open Letter to President Donald J. Trump, Members of Congress, and the American People");
}

$supportustext = getphrase("Help promote the petition!");
$supportus = str_replace('{$supportustext}', $supportustext, $supportus);

$textforsigners = "I am one of the signers of the recent Open Letter addressed to the President, Congress, and the American people, available here: <strong>https://mostnews.org/en/openletter/1</strong> - The letter raises concern about Russian opposition members, anti-war activists, and journalists who face prison or forced mobilization if deported back to Russia. I respectfully ask you to consider this issue and support measures that would prevent the deportation of political dissidents into the hands of an authoritarian regime. Thank you for your attention.";

$blog_name = $meta_title;
$blog_description = $meta_description;
$supportustext = $meta_title;

$final_html = get_template("clean_page");
$page_content_html = get_template("openletter1");
include(ENGINEDIR."publicsignatures.class.php");

$tpl = array(
  '{$page_content_html}' => $page_content_html
);
$final_html = strtr($final_html, $tpl);
