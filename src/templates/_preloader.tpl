<style>
#qsne-page-loader {
  display: none;
  position: fixed;
  z-index: 9999;
  top: 0; left: 0;
  width: 100vw;
  height: 100vh;
  background: rgba(255, 255, 255, 0.3);
  backdrop-filter: blur(5px);
  justify-content: center;
  align-items: center;
  animation: qsne-fadeIn 0.3s ease-in-out;
}

.qsne-loader-content {
  text-align: center;
  color: #333;
}

.qsne-spinner {
  width: 48px;
  height: 48px;
  border: 5px solid #ccc;
  border-top: 5px solid #0078D7;
  border-radius: 50%;
  animation: qsne-spin 1s linear infinite;
  margin: 0 auto 20px;
}

@keyframes qsne-spin {
  to { transform: rotate(360deg); }
}

@keyframes qsne-fadeIn {
  from { opacity: 0; }
  to   { opacity: 1; }
}
</style>

<div id="qsne-page-loader">
  <div class="qsne-loader-content">
<img src="/projects/most/images/logo-square.png" style="width:81px;height:81px;border-radius:50%" class="spinner"><br><small>loading...</small>
  </div>
</div>

<script>
  (function () {
    const LOADER_ID = 'qsne-page-loader';
    const loader = document.getElementById(LOADER_ID);
    let hideTimeout = null;

    if (!loader) return;

    document.body.addEventListener('click', function (e) {
      const link = e.target.closest('a[href]:not([target="_blank"])');
      if (!link) return;

      const href = link.getAttribute('href');
      const isSamePageAnchor =
        href.startsWith('#') ||
        (link.pathname === location.pathname && href.includes('#'));

      if (
        !href ||
        href.startsWith('javascript:') ||
        isSamePageAnchor
      ) {
        return;
      }

      loader.style.display = 'flex';

      const allLinks = document.querySelectorAll('a[href]');
      allLinks.forEach(l => {
        l.style.pointerEvents = 'none';
        l.style.cursor = 'wait';
      });

      clearTimeout(hideTimeout);
      hideTimeout = setTimeout(() => {
        loader.style.display = 'none';
        allLinks.forEach(l => {
          l.style.pointerEvents = '';
          l.style.cursor = '';
        });
      }, 5000);
    });
  })();
</script>
