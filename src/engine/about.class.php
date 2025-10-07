<?php
if ($user_lng == 'ru')
{
	$config['project_name'] = "МОСТ.Медиа";
}
$meta_title = getphrase("About the project");
$meta_description = getphrase("About the “".$config['project_name']."” Project");

$blog_name = $meta_title;
$blog_description = $meta_description;

$this_welcome = "Добро пожаловать на&nbsp;«Мост»!";
$this_about = "Это новое медиа, соединяющее людей с&nbsp;разных&nbsp;берегов.";

if ($user_lng != 'ru')
{
	$this_welcome = getphrase("Welcome to «".$config['project_name']."»!");
	$this_about = getphrase("Independent Publishers Association");
}

$phrase['Add new author'] = getphrase("Add new author");
$phrase['Not displayed!'] = getphrase("Not displayed!");
$phrase['Edit'] = getphrase("Edit");

$editorinchief = $db->super_query("select * from authors where prioritet=999999999 and enabled=1 and deleted=0 limit 0,1");
$editorinchiefbio = getphrase("Founder and editor-in-chief of «".$config['project_name']."»");
//if (!empty($editorinchief['bioen'])) $editorinchiefbio = getphrase($editorinchief['bioen']);
//$editorinchiefbio = preg_replace('/\bглавный\b/u', 'главная', $editorinchiefbio);
//$editorinchiefbio = preg_replace('/\bредактор\b/u', 'редакторка', $editorinchiefbio);
$editorinchiefbio = preg_replace('/\bОснователь\b/u', 'Основательница', $editorinchiefbio);
$editorinchiefname = $editorinchief['fullname'];
if (!empty($editorinchief['fullname_lat']) && $user_lng != 'ru')
{
	$editorinchiefname = $editorinchief['fullname_lat'];
}
$avatararr = avatars($editorinchief["avatar"]);
$editorinchiefavatar = $avatararr['fullavatar'];
$editorinchiefurl = "/".$user_lng."/team-members/".$editorinchief['smarturl'];
$authorid = $editorinchief['id'];
$editeditorinchief = "";
if ($ismoder || $isadmin)
{
	$editeditorinchief = <<<HTML
<a href="javascript:void(0)" onclick="editauthor({$authorid})" style="display:block;width:100%;">{$phrase['Edit']}</a>
HTML;
}

$authorslistitems = "";

$allauthors = $db->super_query("select * from authors where prioritet<>999999999 and deleted=0 order by enabled desc, prioritet desc, postcount desc, id asc", true);
foreach ($allauthors as $authors)
{
	$authorname = $authors['fullname'];
	if (!empty($authors['fullname_lat']) && $user_lng != 'ru')
	{
		$authorname = $authors['fullname_lat'];
	}
	$authorid = $authors['id'];
	$authorbio = "";
	if ($authors['prioritet'] == 999999990) $authors['bioen'] = getphrase($authors['bioen']);
	if (!empty($authors['bioen'])) $authorbio = getphrase($authors['bioen']);
	$feminitive = false;
	$authornamearr = explode(" ", $authorname);
	foreach ($authornamearr as $authornameitem)
	{
		$russian_names = $db->super_query("select Name from russian_names where Sex='Ж' and Name='".$authornameitem."'");
		if (!empty($russian_names))
		{
			$authorbio = preg_replace('/\bПисатель\b/u', 'Писательница', $authorbio);
			$authorbio = preg_replace('/\bписатель\b/u', 'писательница', $authorbio);
			$authorbio = preg_replace('/\bЖурналист\b/u', 'Журналистка', $authorbio);
			$authorbio = preg_replace('/\bжурналист\b/u', 'журналистка', $authorbio);
			$authorbio = preg_replace('/\bАвтор\b/u', 'Авторка', $authorbio);
			$authorbio = preg_replace('/\bавтор\b/u', 'авторка', $authorbio);
			$authorbio = preg_replace('/\bКинокритик\b/u', 'Кинокритикесса', $authorbio);
			$authorbio = preg_replace('/\bкинокритик\b/u', 'киникритикесса', $authorbio);
			//$authorbio = preg_replace('/\bиностранный\b/u', 'иностранная', $authorbio);
			//$authorbio = preg_replace('/\bиностранным\b/u', 'иностранной', $authorbio);
			//$authorbio = preg_replace('/\bагент\b/u', 'агентка', $authorbio);
			//$authorbio = preg_replace('/\bагентом\b/u', 'агенткой', $authorbio);
			//$authorbio = preg_replace('/\bАрт-критик\b/u', 'Арт-критикесса', $authorbio);
			$authorbio = preg_replace('/\bМеждународный\b/u', 'Международная', $authorbio);
			//$authorbio = preg_replace('/\bПолитолог\b/u', 'Политологиня', $authorbio);
			$authorbio = preg_replace('/\bИсторик\b/u', 'Историкесса', $authorbio);
			$authorbio = preg_replace('/\bисторик\b/u', 'историкесса', $authorbio);
			//$authorbio = preg_replace('/\bполитолог\b/u', 'политологиня', $authorbio);
			$authorbio = preg_replace('/\bредактор\b/u', 'редакторка', $authorbio);
			$authorbio = preg_replace('/\bАктивист\b/u', 'Активистка', $authorbio);
			$authorbio = preg_replace('/\bактивист\b/u', 'активистка', $authorbio);
		}
	}
	
	$avatararr = avatars($authors["avatar"]);
	$authorsavatar = $avatararr['fullavatar'];
	$authorurl = "/".$user_lng."/team-members/".$authors['smarturl'];
	$authorid = $authors['id'];
	$editauthor = "";
	if (empty($authors['enabled']))
	{
		$editauthor .= <<<HTML
<div style="display:block;width:100%;color:red;">{$phrase['Not displayed!']}</div>
HTML;
	}
	if ($ismoder)
	{
		$editauthor .= <<<HTML
<a href="javascript:void(0)" onclick="editauthor({$authorid})" style="display:block;width:100%;">{$phrase['Edit']}</a>
HTML;
	}
	$final_html = get_template("authorlist");
	include(ENGINEDIR."templateprepare2.class.php");
	$authorslistitems .= $final_html;
}

$addauthor = "";
if ($ismoder)
{
	$addauthor = <<<HTML
<div style="width:100%;text-align:center;margin-top:-20px;padding-bottom:20px;"><a href="javascript:void(0)" onclick="editauthor(0)" style="display:block;width:100%;">{$phrase['Add new author']}</a></div>
HTML;
}

$editauthorjs = get_template("editauthor");

$subscribeus = get_template("subscribeus");

$final_html = get_template("clean_page");
$page_content_html = get_template("about");

$tpl = array(
  '{$page_content_html}' => $page_content_html
);
$final_html = strtr($final_html, $tpl);
