<style>
.bannerwe { cursor: pointer; text-decoration: none; color: inherit; }
.banner-we-exist {
    background-color: #eaddd0;
    border-radius: 20px;
}

.contbanner {
    overflow: hidden;
    padding: 0px;
    display: block;
    max-width: none;
	width:100%;
    height: Auto;
	margin-top: 10px;
	margin-bottom: 30px;
}

.bannerwe {
    background-color: #eaddd0;
    border-radius: 10px;
    width: Auto;
    height: Auto;
    display: flex;
    gap: 4rem;
    justify-content: space-between;
    background-image: url('../projects/most/images/weexist/art.svg');
    background-repeat: no-repeat;
    background-size: cover;
    padding-left: 20px;
    padding-top: 20px;
    padding-bottom: 10px;
}

.textbanner {
    font-family: 'Inter', sans-serif;
    font-weight: 400;
    font-size: 26px;
}

.contbanner img{
	padding-right:20px;
	border-radius:0;
}

@media (max-width: 767px) {
	.contbanner img{
		padding-right:5px;
	}
	.textbanner {
		font-size: 18px;
	}
	.bannerwe {
		padding-left: 20px;
		padding-top: 10px;
		padding-bottom: 10px;
		padding-right: 0px;
	}
}

</style>
<div class="container contbanner">
	<!-- Оборачиваем весь блок в ссылку -->
	<a href="https://weexist-foundation.org/" target="_blank" class="bannerwe"><p class="black black-hover textbanner">The "Culture" section operates with the support of the <span class="nottranslate" style="white-space:nowrap;">We Exist! Foundation</span></p><img src="/projects/most/images/weexist/logo.svg" alt="We Exist Logo"> </a>
</div>
