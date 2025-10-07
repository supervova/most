<?php
$final_html = get_template("clean_page");

if (!empty($thispath[2]))
{
	$smarturl = trim(urlencode(dbstr($thispath[2])));
	$authors = $db->super_query("select * from authors where projectid=".$thisprojectid." and smarturl='".$smarturl."'");
	if (empty($authors['id']))
	{
		$authors = $db->super_query("select * from authors where smarturl='".$smarturl."'");
	}
	if (empty($authors['id']))
	{
		memcache_close($memcache_obj);
		if ($db) $db->close();
		include_once(ENGINEDIR."404.class.php");
	}
	$authorname = $authors['fullname'];
	if (!empty($authors['fullname_lat']) && $user_lng != 'ru')
	{
		$authorname = $authors['fullname_lat'];
	}
	$authorid = $authors['id'];
	$authorbio = "";
	if (!empty($authors['bioen'])) $authorbio = getphrase($authors['bioen']);
	$avatararr = avatars($authors["avatar"]);
	$authorsavatar = $avatararr['fullavatar'];
	$meta_title = $authorname;
	$meta_description = getphrase($config['project_name']." project team member");
	if (!empty($authorbio))
	{
		$meta_description = prepareMetaDescription($authorbio);
	}
	$page_content_html = get_template("team-member");
}
else
{
	memcache_close($memcache_obj);
	if ($db) $db->close();
	Header('Location: /'.$user_lng.'/about');
	die();
}

$blog_name = $meta_title;
$blog_description = $meta_description;

$tpl = array(
  '{$page_content_html}' => $page_content_html
);
$final_html = strtr($final_html, $tpl);
