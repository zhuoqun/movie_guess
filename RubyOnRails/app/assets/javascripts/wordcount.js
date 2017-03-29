$(document).ready(function(){
  $('.js-count-word').keyup(function(){
    countWord($(this));
  }).keydown(function(){
    countWord($(this));
  });

  function countWord(el) {
    var count = el.val().length;
    var total = el.attr('data-count');
    var last = total - count;

    if (last < 0) {
      $('.word-last').css('color', 'red');
    } else {
      $('.word-last').css('color', '');
    }

    $('.word-last').text(last);
  }

  $('.js-count-word').length && countWord($('.js-count-word'));
})
