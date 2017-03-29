window.log = function f(){ log.history = log.history || []; log.history.push(arguments); if(this.console) { var args = arguments, newarr; args.callee = args.callee.caller; newarr = [].slice.call(args); if (typeof console.log === 'object') log.apply.call(console.log, console, newarr); else console.log.apply(console, newarr);}};
(function(a){function b(){}for(var c="assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,markTimeline,profile,profileEnd,time,timeEnd,trace,warn".split(","),d;!!(d=c.pop());){a[d]=a[d]||b;}})
(function(){try{console.log();return window.console;}catch(a){return (window.console={});}}());

jQuery.fn.extend({
  insertAtCaret: function(myValue){
                   return this.each(function(i) {
                     if (document.selection) {
                       //For browsers like Internet Explorer
                       this.focus();
                       sel = document.selection.createRange();
                       sel.text = myValue;
                       this.focus();
                     } else if (this.selectionStart || this.selectionStart == '0') {
                       //For browsers like Firefox and Webkit based
                       var startPos = this.selectionStart;
                       var endPos = this.selectionEnd;
                       var scrollTop = this.scrollTop;
                       this.value = this.value.substring(0, startPos)+myValue+this.value.substring(endPos,this.value.length);
                       this.focus();
                       this.selectionStart = startPos + myValue.length;
                       this.selectionEnd = startPos + myValue.length;
                       this.scrollTop = scrollTop;
                     } else {
                       this.value += myValue;
                       this.focus();
                     }
                   })
                 }
});


// scroll to top
$(window).scroll(function() {
  if ($(this).scrollTop() > 100) {
    $('#scroll_to_top').fadeIn();
  } else {
    $('#scroll_to_top').fadeOut();
  }
});

$('#scroll_to_top').click(function(e){
  e.preventDefault();
  $('body,html').animate({scrollTop: 0}, 800);
  return false;
});

// get unread notifications

$.getJSON('/unread_notifications.json', function(count){
  if (count > 0) {
    $('.notification .badge').text(count);
    $('.notification .badge').show();
  }
});

// Google analytics
var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-34178630-1']);
_gaq.push(['_setDomainName', 'caidianying.com']);
_gaq.push(['_trackPageview']);

(function() {
  var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
  ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();
