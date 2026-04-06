(function () {
    var headerLoaded = false;

    function initHeaderBehaviour() {
        if (headerLoaded && window.jQuery && typeof $.fn.meanmenu === 'function') {
            $('.header-area nav').meanmenu({
                meanScreenWidth: 767,
                meanMenuContainer: $('.mobile-menu')
            });
        }
    }

    function insertHeader() {
        var container = document.getElementById('site-header');
        if (!container) return;

        var headerPath = 'includes/header.html';
        var xhr = new XMLHttpRequest();

        xhr.open('GET', headerPath, true);
        xhr.onload = function() {
            if (xhr.status >= 200 && xhr.status < 300) {
                container.innerHTML = xhr.responseText;
                headerLoaded = true;
                initHeaderBehaviour();
            } else {
                console.error('Header load failed: ' + xhr.status);
            }
        };
        xhr.onerror = function() {
            console.error('Header loader error - check that includes/header.html exists');
        };
        xhr.send();
    }

    // Run on DOMContentLoaded
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', insertHeader);
    } else {
        insertHeader();
    }
})();
