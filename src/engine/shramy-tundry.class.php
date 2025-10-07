<?php
$profilemenuitem = "";
$alertmsg = "";
$stupidlink = "";

$just_lng = "ru";

if ($user_lng != $just_lng)
{
	Header('Location: '. str_replace('/'.$user_lng.'/', '/'.$just_lng.'/', $thispagesimpleurl));
	die();
}

$meta_title = "Шрамы Тундры";
$meta_description = "Тяжёлая техника в российской Арктике бьёт по экосистеме, климату и коренным — исследование «Арктиды»";

$blog_name = $meta_title;
$blog_description = $meta_description;
$supportustext = $meta_title;

$supportus = get_template("supportus");

$final_html = get_template("shramy-tundry");
