<style>
  body {
	opacity: 0;
	transition: opacity 1s ease;
  }

  body.allvisible {
	opacity: 1;
  }
</style>
<div style="width:100%;height:93vh;margin-top:-67px;margin-bottom:-20px;">
<iframe src="/{$user_lng}/assistant/18-u9mk/107/#endofchat" style="width:100%;height:100%;border:none;" id="aiframe"></iframe>
</div>
<script>
  window.addEventListener('load', () => {
    setTimeout(() => {
      window.scrollTo(0, 0);
	  document.body.classList.add('allvisible');
    }, 300); // 1000 миллисекунд = 1 секунда
  });
</script>
