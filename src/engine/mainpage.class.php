<?php
$mainsortfield = "IF(posts_lng.lng='".$target_lng."' or posts.lng='".$target_lng."',posts.publish_time+86400*365+(86400*5*attached),posts.publish_time+(86400*5*attached)) ";

$oldposts = "0";

$sqlquery = "SELECT ".$mainsortfield." as orderfield, posts.notranslate, posts.promountil, posts.id, postlenght, posts.blog_id, posttype, posts.user_id, posts.lng, posts.title, posts.description, thumbnail, emotion, emotion_descr, location, latitude, longitude, publish_time, accessmode, commentsmode, showcomments, attached, posts.approved, cat_exists, votesplus, votesminus, views, uniqs, repostcount, posts.lasteventtime, addays, commentscount, blogs.address, blogs.projectid, blogs.name as blogname, blogs.lng as blog_lng, community_type, mainproject, posts.price, posts.pricecurr, settings, authors.fullname as afullname, authors.fullname_lat as afullname_lat, authors.smarturl as asmarturl, authors.avatar as aavatar, posts_urls.smarturl as psmarturl FROM posts LEFT OUTER JOIN posts_lng ON posts.id=posts_lng.post_id and posts_lng.lng='".$target_lng."' LEFT OUTER JOIN authors ON authors.id=posts.author_id LEFT OUTER JOIN posts_urls ON posts_urls.post_id=posts.id and posts_urls.lng='".$target_lng."', blogs where posts.blog_id=blogs.blog_id and blogs.commontape>0 and blogs.blog_id=".$blog_id." and posts.thumbnail<>'' and posts.description<>'' and accessmode=0 and publish_time<".$startruntime." and posts.approved=1 and posts.deleted=0 and posts.posttype in (0,1) and posts.id not in (".$oldposts.") order by orderfield desc limit 0,5";

$memcachekey = md5($sqlquery);

$posts = memcache_get($memcache_obj, $memcachekey);
if (empty($posts) || !empty($nocache))
{
	$nocache = memcache_delete($memcache_obj, "nocache".$blog_id."for".$user_id);
	$posts = $db->super_query($sqlquery,true);
	memcache_set($memcache_obj, $memcachekey, $posts, 0, $config['memcache_posts']);
}

$mainposts = array();
foreach ( $posts as $post ) {
	require ENGINEDIR."getpostinfo.class.php";
	$thispost['id'] = $post['id'];
	$thispost['url'] = $posturl;
	$thispost['image'] = $postthumbnailfile;
	$thispost['title'] = $post['title'];
	$thispost['description'] = $post['description'];
	$thispost['author'] = $post['username'];
	$thispost['authorurl'] = $userpageurl;
	$mainposts[] = $thispost;
	$oldposts .= ",".$post['id'];
}

// Блок политика:
$sqlquery = "SELECT ".$mainsortfield." as orderfield, posts.notranslate, posts.promountil, posts.id, postlenght, posts.blog_id, posttype, posts.user_id, posts.lng, posts.title, posts.description, thumbnail, emotion, emotion_descr, location, latitude, longitude, publish_time, accessmode, commentsmode, showcomments, attached, posts.approved, cat_exists, votesplus, votesminus, views, uniqs, repostcount, posts.lasteventtime, addays, commentscount, blogs.address, blogs.projectid, blogs.name as blogname, blogs.lng as blog_lng, community_type, mainproject, posts.price, posts.pricecurr, settings, authors.fullname as afullname, authors.fullname_lat as afullname_lat, authors.smarturl as asmarturl, authors.avatar as aavatar, posts_urls.smarturl as psmarturl FROM posts LEFT OUTER JOIN posts_lng ON posts.id=posts_lng.post_id and posts_lng.lng='".$target_lng."' LEFT OUTER JOIN authors ON authors.id=posts.author_id LEFT OUTER JOIN posts_urls ON posts_urls.post_id=posts.id and posts_urls.lng='".$target_lng."', blogs where posts.blog_id=blogs.blog_id and blogs.commontape>0 and blogs.blog_id=".$blog_id." and posts.thumbnail<>'' and posts.description<>'' and publish_time<".$startruntime." and accessmode=0 and posts.approved=1 and posts.deleted=0 and posts.posttype in (0,1) and posts.id not in (".$oldposts.") and posts.id in (select postid from posts_cats where catid=3188) order by orderfield desc limit 0,4";

$memcachekey = md5($sqlquery);

$posts = memcache_get($memcache_obj, $memcachekey);
if (empty($posts) || !empty($nocache))
{
	$nocache = memcache_delete($memcache_obj, "nocache".$blog_id."for".$user_id);
	$posts = $db->super_query($sqlquery,true);
	memcache_set($memcache_obj, $memcachekey, $posts, 0, $config['memcache_posts']);
}

$mainposts2 = array();
foreach ( $posts as $post ) {
	require ENGINEDIR."getpostinfo.class.php";
	$thispost['id'] = $post['id'];
	$thispost['url'] = $posturl;
	$thispost['image'] = $postthumbnailfile;
	$thispost['title'] = $post['title'];
	$thispost['description'] = $post['description'];
	$thispost['author'] = $post['username'];
	$thispost['authorurl'] = $userpageurl;
	$mainposts2[] = $thispost;
	$oldposts .= ",".$post['id'];
}

// Блок текст недели:
if ($user_lng == 'ru') $postofweek_id = 7821404;
elseif ($user_lng == 'en') $postofweek_id = 7821086;
else $postofweek_id = 7821404;

$sqlquery = "SELECT posts.notranslate, posts.promountil, posts.id, postlenght, posts.blog_id, posttype, posts.user_id, posts.lng, posts.title, posts.description, thumbnail, emotion, emotion_descr, location, latitude, longitude, publish_time, accessmode, commentsmode, showcomments, attached, posts.approved, cat_exists, votesplus, votesminus, views, uniqs, repostcount, posts.lasteventtime, addays, commentscount, blogs.address, blogs.projectid, blogs.name as blogname, blogs.lng as blog_lng, community_type, mainproject, posts.price, posts.pricecurr, settings, authors.fullname as afullname, authors.fullname_lat as afullname_lat, authors.smarturl as asmarturl, authors.avatar as aavatar, posts_urls.smarturl as psmarturl FROM posts LEFT OUTER JOIN posts_lng ON posts.id=posts_lng.post_id and posts_lng.lng='".$target_lng."' LEFT OUTER JOIN authors ON authors.id=posts.author_id LEFT OUTER JOIN posts_urls ON posts_urls.post_id=posts.id and posts_urls.lng='".$target_lng."', blogs where posts.blog_id=blogs.blog_id and blogs.commontape>0 and blogs.blog_id=".$blog_id." and posts.thumbnail<>'' and posts.description<>'' and publish_time<".$startruntime." and accessmode=0 and posts.approved=1 and posts.deleted=0 and posts.posttype in (0,1) and posts.id=".$postofweek_id;

$memcachekey = md5($sqlquery);

$post = memcache_get($memcache_obj, $memcachekey);
if (empty($posts) || !empty($nocache))
{
	$nocache = memcache_delete($memcache_obj, "nocache".$blog_id."for".$user_id);
	$post = $db->super_query($sqlquery);
	memcache_set($memcache_obj, $memcachekey, $post, 0, $config['memcache_posts']);
}
$postofweek = "";
if (!empty($post['id']) && !empty($postofweek_id))
{
	require ENGINEDIR."getpostinfo.class.php";
	$thispost['url'] = $posturl;
	$thispost['image'] = $postthumbnailfile;
	$thispost['title'] = $post['title'];
	$thispost['description'] = $post['description'];
	$thispost['author'] = $post['username'];
	$thispost['authorurl'] = $userpageurl;
	$phrase['Author:'] = getphrase("Author:");
	$postofweek = <<<HTML
<div class="text-of-the-week">
<div class="container-text-of-the-week">
<div class="posts-wrapper-dark cc-top-post">
<div class="w-dyn-list">
<div role="list" class="w-dyn-items">
<div role="listitem" class="top-post-item w-dyn-item">
<a href="{$thispost['url']}" class="top-post-image w-inline-block">
<img alt="" src="{$thispost['image']}" class="post-image-dark">
</a>
<div class="top-post-text">
<a href="{$thispost['url']}" class="top-post-link-block w-inline-block">
<h2 class="h2-dark">{$thispost['title']}</h2>
<div class="whitedescr">{$thispost['description']}</div>
</a>
<div class="post-author-text">
<div class="post-author cc-top-margin">{$phrase['Author:']}</div>
<a href="{$thispost['authorurl']}" class="post-author">{$thispost['author']}</a>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>

HTML;
}

// Блок сейчас читают:
$readposts = array();
$readpostcount = 0;
$nowreadposts = memcache_get($memcache_obj, "nowreadposts".$thisprojectid.$target_lng);
if (empty($nowreadposts)) $nowreadposts = array();
if (!empty($nowreadposts))
{
	foreach ($nowreadposts as $nowreadpost)
	{
		if ($nowreadpost == $postofweek_id) continue;
		$sqlquery = "SELECT posts.notranslate, posts.promountil, posts.id, postlenght, posts.blog_id, posttype, posts.user_id, posts.lng, posts.title, posts.description, thumbnail, emotion, emotion_descr, location, latitude, longitude, publish_time, accessmode, commentsmode, showcomments, attached, posts.approved, cat_exists, votesplus, votesminus, views, uniqs, repostcount, posts.lasteventtime, addays, commentscount, blogs.address, blogs.projectid, blogs.name as blogname, blogs.lng as blog_lng, community_type, mainproject, posts.price, posts.pricecurr, settings, authors.fullname as afullname, authors.fullname_lat as afullname_lat, authors.smarturl as asmarturl, authors.avatar as aavatar, posts_urls.smarturl as psmarturl FROM posts LEFT OUTER JOIN posts_lng ON posts.id=posts_lng.post_id and posts_lng.lng='".$target_lng."' LEFT OUTER JOIN authors ON authors.id=posts.author_id LEFT OUTER JOIN posts_urls ON posts_urls.post_id=posts.id and posts_urls.lng='".$target_lng."', blogs where posts.blog_id=blogs.blog_id and blogs.commontape>0 and blogs.blog_id=".$blog_id." and posts.thumbnail<>'' and posts.description<>'' and publish_time<".$startruntime." and accessmode=0 and posts.approved=1 and posts.deleted=0 and posts.posttype in (0,1) and posts.id=".$nowreadpost;
		$memcachekey = md5($sqlquery);

		$post = memcache_get($memcache_obj, $memcachekey);
		if (empty($posts) || !empty($nocache))
		{
			$nocache = memcache_delete($memcache_obj, "nocache".$blog_id."for".$user_id);
			$post = $db->super_query($sqlquery);
			memcache_set($memcache_obj, $memcachekey, $post, 0, $config['memcache_posts']);
		}
		if (!empty($post['id']))
		{
			require ENGINEDIR."getpostinfo.class.php";
			$thispost['url'] = $posturl;
			$thispost['image'] = $postthumbnailfile;
			$thispost['title'] = $post['title'];
			$thispost['description'] = $post['description'];
			$thispost['author'] = $post['username'];
			$thispost['authorurl'] = $userpageurl;
			$readposts[] = $thispost;
			$readpostcount += 1;
			if ($readpostcount >= 4) break;
		}
	}
}
if (count($readposts) < 4)
{
	if (!in_array($mainposts[0]['id'], $nowreadposts))
	{
		$readposts[] = $mainposts[0];
	}
}
if (count($readposts) < 4)
{
	if (!in_array($mainposts[1]['id'], $nowreadposts))
	{
		$readposts[] = $mainposts[1];
	}
}
if (count($readposts) < 4)
{
	if (!in_array($mainposts[2]['id'], $nowreadposts))
	{
		$readposts[] = $mainposts[2];
	}
}
if (count($readposts) < 4)
{
	if (!in_array($mainposts[3]['id'], $nowreadposts))
	{
		$readposts[] = $mainposts[3];
	}
}
if (count($readposts) < 4)
{
	if (!in_array($mainposts[4]['id'], $nowreadposts))
	{
		$readposts[] = $mainposts[4];
	}
}

if ($user_lng == 'ru')
{
	$meta_title = "МОСТ.Медиа";
	$meta_description = "Кооператив независимых издателей";
}
elseif ($user_lng == 'en')
{
	$meta_title = "MOST Media & News";
	$meta_description = getphrase("Independent Publishers Association");
}
else
{
	$meta_title = "MOST.Media";
	$meta_description = getphrase("Independent Publishers Association");
}

$blog_name = $meta_title;
$blog_description = $meta_description;

$final_html = get_template("clean_page");
$page_content_html = get_template("home");
$subscribeus = get_template("subscribeus");

$tpl = array(
  '{$page_content_html}' => $page_content_html
);
$final_html = strtr($final_html, $tpl);
