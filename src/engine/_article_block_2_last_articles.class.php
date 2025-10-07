<?php
$olspost_id = $postid;

$mainsortfield = "IF(posts_lng.lng='".$target_lng."' or posts.lng='".$target_lng."',posts.publish_time+86400*365,posts.publish_time) ";

$sqlquery = "SELECT ".$mainsortfield." as orderfield, posts.notranslate, posts.promountil, posts.id, postlenght, posts.blog_id, posttype, posts.user_id, posts.lng, posts.title, posts.description, thumbnail, emotion, emotion_descr, location, latitude, longitude, publish_time, accessmode, commentsmode, showcomments, attached, posts.approved, cat_exists, votesplus, votesminus, views, uniqs, repostcount, posts.lasteventtime, addays, commentscount, blogs.address, blogs.projectid, blogs.name as blogname, blogs.lng as blog_lng, community_type, mainproject, posts.price, posts.pricecurr, settings, authors.fullname as afullname, authors.fullname_lat as afullname_lat, authors.smarturl as asmarturl, authors.avatar as aavatar, posts_urls.smarturl as psmarturl FROM posts LEFT OUTER JOIN posts_lng ON posts.id=posts_lng.post_id and posts_lng.lng='".$target_lng."' LEFT OUTER JOIN authors ON authors.id=posts.author_id LEFT OUTER JOIN posts_urls ON posts_urls.post_id=posts.id and posts_urls.lng='".$target_lng."' LEFT OUTER JOIN subscribes ON subscribes.to_blog_id=posts.blog_id AND subscribes.user_id=".$user_id.", blogs where posts.blog_id=blogs.blog_id and blogs.commontape>0 and blogs.blog_id=".$blog_id." and posts.thumbnail<>'' and posts.description<>'' and accessmode=0 and posts.approved=1 and posts.publish_time<".$startruntime." and posts.deleted=0 and posts.posttype in (0,1) and posts.id<>".$postid." order by orderfield desc limit 0,2";

$memcachekey = md5($sqlquery);

$posts = memcache_get($memcache_obj, $memcachekey);
if (empty($posts) || !empty($nocache))
{
	$nocache = memcache_delete($memcache_obj, "nocache".$blog_id."for".$user_id);
	$posts = $db->super_query($sqlquery,true);
	memcache_set($memcache_obj, $memcachekey, $posts, 0, $config['memcache_posts']);
}

$adarticles = array();
foreach ( $posts as $post ) {
	require ENGINEDIR."getpostinfo.class.php";
	$thispost['id'] = $post['id'];
	$thispost['url'] = $posturl;
	$thispost['image'] = $postthumbnailfile;
	$thispost['title'] = $post['title'];
	$thispost['description'] = $post['description'];
	$thispost['author'] = $post['username'];
	$thispost['authorurl'] = $userpageurl;
	$adarticles[] = $thispost;
	$oldposts .= ",".$post['id'];
}
if (empty($adarticles) || count($adarticles) < 2)
{
	$thispost['id'] = 0;
	$thispost['url'] = "";
	$thispost['image'] = "";
	$thispost['title'] = "";
	$thispost['description'] = "";
	$thispost['author'] = "";
	$thispost['authorurl'] = "";
	$adarticles[] = $thispost;	
}
if (count($adarticles) < 2)
{
	$thispost['id'] = 0;
	$thispost['url'] = "";
	$thispost['image'] = "";
	$thispost['title'] = "";
	$thispost['description'] = "";
	$thispost['author'] = "";
	$thispost['authorurl'] = "";
	$adarticles[] = $thispost;	
}

$postid = $olspost_id;
