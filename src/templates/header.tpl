<div id="p_prldr"><div class="contpre"><img src="/projects/most/images/logo-square.png" style="width:81px;height:81px;border-radius:50%" class="spinner"><br><small>loading...</small></div></div>
<script type="text/javascript">
function checkprldr() {
	if($('#p_prldr').css('display') == 'block'){
		$('#p_prldr').delay(100).fadeOut('slow');
	}
}
intprldr = setTimeout(function() {
  checkprldr();
}, 4500);
$(window).on('load', function () {
	const menu = document.querySelector('[data-nav-menu-open]');
	const button = document.getElementById('sandwichbutton');
	$('#w-nav-overlay-0').hide();
	document.addEventListener('click', (event) => {
	  if (!menu) return;

	  const clickedOutsideMenu = !menu.contains(event.target);
	  const clickedOutsideButton = !button || !button.contains(event.target);

	  if (clickedOutsideMenu && clickedOutsideButton) {
		sandwich('close');
	  }
	});
	window.addEventListener('resize', () => {
	  sandwich('close');
	});
    $('#p_prldr').delay(100).fadeOut('slow');
	if($("#bgvideo").length) {
		$("#bgvideo").attr( 'src' , $("#bgvideo").attr('loadsrc') );
	}
});
function sandwich(act = undefined) {
  const menu = document.querySelector('[data-nav-menu-open]');
  if (!menu) return;
  if (typeof act === 'undefined') {
    const isHidden = getComputedStyle(menu).display === 'none';
	if (isHidden)
	{
		$('#w-nav-overlay-0').show();
		document.body.style.overflow = 'hidden';
	}
	else
	{
		$('#w-nav-overlay-0').hide();
		document.body.style.overflow = '';
	}
    menu.style.setProperty('display', isHidden ? 'block' : 'none', 'important');
  } else if (act === 'close') {
	$('#w-nav-overlay-0').hide();
	document.body.style.overflow = '';
    menu.style.setProperty('display', 'none', 'important');
  }
}
</script>

{$antiframe}
{$pushstatejs}
<div style="height:80px;"></div>

<div data-collapse="medium" data-animation="default" data-duration="400" data-easing="ease" data-easing2="ease" role="banner" class="navigation w-nav">
<div class="navigation-container"><a href="" class="logo w-inline-block"><img src="{$logofile}" alt="" class="image-logo"></a><nav role="navigation" class="nav-menu w-nav-menu"><a href="category/politics" class="navigation-link w-inline-block"><div class="navigation-link-text">Politics</div><div class="navigation-hover"></div></a><a href="category/conflicts" class="navigation-link w-inline-block"><div class="navigation-link-text">Conflicts</div><div class="navigation-hover"></div></a><a href="category/economy" class="navigation-link w-inline-block"><div class="navigation-link-text">Economy</div><div class="navigation-hover"></div></a><a href="category/opinions" class="navigation-link w-inline-block"><div class="navigation-link-text">Opinions</div><div class="navigation-hover"></div></a><a href="category/culture" class="navigation-link w-inline-block"><div class="navigation-link-text">Culture</div><div class="navigation-hover"></div></a><a href="support" aria-current="page" class="navigation-link-subscribe w-inline-block w--current"><div class="navigation-link-text-subscribe visible-lg">Support us</div></a></nav><div id="sandwichbutton" class="menu-button w-nav-button" onclick="sandwich()"><div class="icon-200 w-icon-nav-menu"></div></div></div></div>

<div class="w-nav-overlay" data-wf-ignore="" id="w-nav-overlay-0" style="height: 100%; display: block;"><nav role="navigation" class="nav-menu w-nav-menu" style="transition: all, transform 400ms; transform: translateY(0px) translateX(0px);" data-nav-menu-open=""><a href="/category/politics" class="navigation-link w-inline-block"><div class="navigation-link-text">Politics</div></a><a href="/category/conflicts" class="navigation-link w-inline-block"><div class="navigation-link-text">Conflicts</div></a><a href="/category/economy" class="navigation-link w-inline-block"><div class="navigation-link-text">Economy</div></a><a href="/category/opinions" class="navigation-link w-inline-block"><div class="navigation-link-text">Opinions</div></a><a href="/category/culture" class="navigation-link w-inline-block"><div class="navigation-link-text">Culture</div></a><a href="/special-projects" class="navigation-link w-inline-block"><div class="navigation-link-text">Special projects</div></a><a href="/support" class="navigation-link-subscribe w-inline-block"><div class="navigation-link-text-subscribe">Support us</div></a></nav></div>
