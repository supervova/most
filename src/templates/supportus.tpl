<!--noindex-->

<script>
function donate(tab)
{
	if ($(tab).hasClass('subtab'))
	{
		$('.w--current.subtab').removeClass('w--current');
		$('.w-tab-pane.subtab').removeClass('w--tab-active');
	}
	else
	{
		$('.w--current').not('.subtab').removeClass('w--current');
		$('.w-tab-pane').not('.subtab').removeClass('w--tab-active');
	}
	$(tab).addClass('w--current');
	var newtab = $(tab).attr('data-w-tab');
	$('div[data-w-tab="'+newtab+'"]').addClass('w--tab-active');
}
document.addEventListener("DOMContentLoaded", function () {
if ('{$country_code}' != 'RU' && '{$user_lng}' != 'en')
{
	eurotab = document.getElementById("eurotab");
	donate(eurotab);
}
if ('{$country_code}' == 'US')
{
	dollartab = document.getElementById("dollartab");
	donate(dollartab);
}
});
</script>

<div class="post-donate-live-2 hidden-srch donateblock" style="display:none;margin:0 auto;">
<div class="post-content-wrapper">
<div class="subscription-container">
<div class="subscribe-title">{$supportustext}</div>
<div class="prices-div-2">
<div data-current="Tab 1" data-easing="ease" data-duration-in="300" data-duration-out="100" class="tabs-2 w-tabs">
<div class="tabs-menu-3 donation-tabs__nav w-tab-menu" role="tablist">

<a id="dollartab" data-w-tab="Tab 1" class="hideinit just_US just_en just_fr just_es just_de not_RU just_ru_US tab-link-tab-1-copy donation-nav w-inline-block w-tab-link w--current" href="javascript:void(0)" onclick="donate(this)">
<div class="text-block-6">Dollars</div>
</a>

<a data-w-tab="Tab 1" class="hideinit just_ru just_RU just_ru_US tab-link-tab-1-copy donation-nav w-inline-block w-tab-link w--current" href="javascript:void(0)" onclick="donate(this)">
<div class="text-block-6">Rubles</div>
</a>

<a id="eurotab" data-w-tab="Tab 3"class="not_US not_ru_US tab-link-tab-3-copy w-inline-block w-tab-link" href="javascript:void(0)" onclick="donate(this)">
<div class="text-block-7">Euro</div>
</a>
<a data-w-tab="Tab 3"class="hideinit just_US not_ru_US tab-link-tab-3-copy w-inline-block w-tab-link" href="javascript:void(0)" onclick="donate(this)">
<div class="text-block-7">Euro</div>
</a>

<a data-w-tab="Tab 2"class="tab-link-tab-3-copy donation-nav w-inline-block w-tab-link" href="javascript:void(0)" onclick="donate(this)">
<div class="text-block-7">Cryptocurrencies</div>
</a>

</div>
<div class="w-tab-content">

<div data-w-tab="Tab 1" class="w-tab-pane w--tab-active" id="w-tabs-1-data-w-pane-0" role="tabpanel" aria-labelledby="w-tabs-1-data-w-tab-0">
<div class="text-cta">{$projecttext1}</div>
<div class="prices-div-another-summ">
<a href="https://www.paypal.com/donate/?hosted_button_id=H5X9LZERM8VHG" target="_blank" class="button-frienfli w-button hideinit just_US just_en just_fr just_es just_de not_RU">Click to support us!</a>
<a href="https://friendly2.me/support/mostmedia_org/" target="_blank" class="button-frienfli w-button hideinit just_ru just_RU">Поддержать на платформе Френдли</a>
</div>
</div>

<div data-w-tab="Tab 3" class="w-tab-pane" id="w-tabs-1-data-w-pane-1" role="tabpanel" aria-labelledby="w-tabs-1-data-w-tab-1">
<div data-easing="ease" data-duration-in="300" data-duration-out="100" class="tabs-2 w-tabs">
<div class="tabs-menu-2 donation-tabs__nav w-tab-menu" role="tablist">

<a data-w-tab="Tab 31" class="subtab tab-link-tab-1 donation-nav w-inline-block w-tab-link w--current" id="w-tabs-2-data-w-tab-0" href="javascript:void(0)" onclick="donate(this)" role="tab" aria-controls="w-tabs-2-data-w-pane-0">
<div class="text-block-6">Monthly</div>
</a>

<a data-w-tab="Tab 32" class="subtab tab-link-tab-2 donation-nav w-inline-block w-tab-link" tabindex="-1" id="w-tabs-2-data-w-tab-1" href="javascript:void(0)" onclick="donate(this)" role="tab" aria-controls="w-tabs-2-data-w-pane-1">
<div class="text-block-7">One-time</div>
</a>

</div>
<div class="w-tab-content">
<div data-w-tab="Tab 31" class="subtab w-tab-pane w--tab-active" id="w-tabs-2-data-w-pane-0" role="tabpanel" aria-labelledby="w-tabs-2-data-w-tab-0">
<div class="div-block-3">
<a href="https://buy.stripe.com/14A9AT6Sm6oXeSX5rM1ZS03" target="_blank" class="button-5 w-button">5 €</a>
<a href="https://buy.stripe.com/4gM00jb8C28H7qvbQa1ZS04" target="_blank" class="button-10 w-button">10 €</a>
<a href="https://buy.stripe.com/14AcN590u9B99yDf2m1ZS05" target="_blank" class="button-15 w-button">20 €</a>
</div>
</div>
<div data-w-tab="Tab 32" class="subtab w-tab-pane" id="w-tabs-2-data-w-pane-1" role="tabpanel" aria-labelledby="w-tabs-2-data-w-tab-1">
<div class="div-block-3">
<a href="https://buy.stripe.com/dRm4gzgsWfZx9yDaM61ZS00" target="_blank" class="button-5 w-button">5 €</a>
<a href="https://buy.stripe.com/7sY6oH5OieVt4ej6vQ1ZS01" target="_blank" class="button-10 w-button">10 €</a>
<a href="https://buy.stripe.com/4gM7sL3Ga5kT3afcUe1ZS02" target="_blank" class="button-15 w-button">20 €</a>
</div>
</div>
</div>
</div>
<div class="prices-div-another-summ">
<a href="https://donate.stripe.com/3cI6oH4Ke00z6mr2fA1ZS06" target="_blank" class="button-summ w-button">Other amount, one-time payment</a>
</div>
</div>

<div data-w-tab="Tab 2" class="w-tab-pane" id="w-tabs-1-data-w-pane-2" role="tabpanel" aria-labelledby="w-tabs-1-data-w-tab-2">
<div class="div-block-3">
<div class="w-embed">
<h4>Crypto wallets:</h4>
<style>
.cryptowallet {
	display: inline-block;
	width: 32%;
	padding: 10px;
	text-align: center;
}

.cryptowallettext {
	white-space: normal;
	word-break: break-word;
	overflow-wrap: break-word;
	font-size: clamp(10px, 2.5vw, 14px);
	margin-top: 10px;
}
</style>
<div style="width:100%;text-align:center;white-space:normal;">
<div class="cryptowallet nottranslate">USDT trc20<img src="/projects/most/images/most_USDT.png" style="width:100%">
</div>
<div class="cryptowallet nottranslate">Bitcoin<img src="/projects/most/images/most_BTC.png" style="width:100%">
</div>
<div class="cryptowallet nottranslate">Etherium<img src="/projects/most/images/most_ETH.png" style="width:100%">
</div>
</div>
<div class="cryptowallettext nottranslate">
USDT (tron, trc20): TExZFSdT8WZqhksQyTUxPSoJd1VZo35xcT
</div>
<div class="cryptowallettext nottranslate">
Bitcoin (BTC): bc1pjnkyt3e697x4vjn8ep85x2h9jgdgmxe2ea4t5thlu0ku6j6zagjsmsx9jn
</div>
<div class="cryptowallettext nottranslate">
Etherium (ETH): 0x3Dd2d15b200C05c33CC308bfa9B856c9704F7472
</div>
</div>
</div>
</div>
</div>
</div>
</div>
<div class="text-block-3">By submitting a donation, you confirm that you have read and accept the following documents: <a href="/privacypolicy" target="_blank" class="link-2">Privacy Policy</a> and <a href="/useragreement" target="_blank" class="link-3">User Agreement</a>, and also give consent to the processing of your personal data.</div>
<div class="text-block-3">If you would like to unsubscribe from a monthly donation, please email us at: <strong>support@mostmedia.org</strong>
</div>
</div>
</div>
</div>

<!--/noindex-->
