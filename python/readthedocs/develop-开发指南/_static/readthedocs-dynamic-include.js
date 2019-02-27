// RTD Analytics Code
// This Will cover file of readthedocs_ext

var is_use_local_ga = true;
var is_use_ga = false;
var _gaq = _gaq || [];
_gaq.push(['_setAccount', '{{ GLOBAL_ANALYTICS_CODE }}']);
_gaq.push(['_trackPageview']);
if(is_use_ga) {
    if (is_use_local_ga) {
        (function () {
            var ga = document.createElement('script');
            ga.type = 'text/javascript';
            ga.async = true;
            ga.src = '{{ MEDIA_URL }}javascript/ga.js';
            var s = document.getElementsByTagName('script')[0];
            s.parentNode.insertBefore(ga, s);
        })();
    }
    else {
        (function () {
            var ga = document.createElement('script');
            ga.type = 'text/javascript';
            ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0];
            s.parentNode.insertBefore(ga, s);
        })();
    }
}

// end RTD Analytics Code
