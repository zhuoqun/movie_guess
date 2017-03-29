// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require jquery
//= require jquery_ujs
//= require plugins.js
//= require icanhaz.js
//= require bootstrap-carousel.js
//= require jquery.caret
//= require jquery.atwho
//= require answers_and_comments

$(document).ready(function(){
  var fast_items = $.parseJSON(puzzles);
  var first = true;
  var loading = false;
  var is_end = false;

  append_puzzles(fast_items);
  $('#fastCarousel').carousel({interval: false});

  $('#fastCarousel').on('slid', function(e){
    var next_all = $(this).find('.active').nextAll();
    if (!loading && !is_end && (next_all.length <= 5)) {
      loading = true;

      var start = $('.carousel-inner .item').size();
      $.getJSON('/fast.json?start=' + start, function(data){

        if (data.length < 10) is_end = true;
        append_puzzles(data);
        loading = false;
      });
    }
  });


  function append_puzzles(fast_items) {
    $.each(fast_items, function(k, v){
      if (first) {
        v.active = 'active';
        first = false
      }

      if (v.img) {
        puzzle = ich.fast_puzzle_img_tpl(v);
      } else {
        puzzle = ich.fast_puzzle_text_tpl(v);
      }

      $('.carousel-inner').append(puzzle);
    });

    attachAnswersAndCommentsEvents();

    $('#jiathis_script').remove();
    $(document).append('<script id="jiathis_script" charset="utf-8" src="http://v2.jiathis.com/code/jia.js" type="text/javascript"></script>');

    $('.actions .right').mouseover(function(e){
      jiathis_config.url = 'http://caidianying' + $(this).attr('data-url');
      var desc = $(this).attr('data-title');
      if (desc == '') {
        desc = "快来猜猜这是什么电影吧！"
      }

      jiathis_config.title = desc;
      console.log($(this).attr('data-title'));
    });

  }
})

