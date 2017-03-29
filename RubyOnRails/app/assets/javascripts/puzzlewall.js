$(document).ready(function(){

  if ($('.puzzle-wall').length <= 0) {
    return;
  }

  var items = $.parseJSON(puzzles);

  function appendData(data) {
    $.each(data, function(i, v){
      var puzzle = v;
      var puzzle_html;

      if (puzzle.text) {
        puzzle_html = ich.puzzle_text_tpl(puzzle);
      } else {
        puzzle_html = ich.puzzle_img_tpl(puzzle);
      }

      var left_col_height = $('.puzzle-wall .left-col').height();
      var right_col_height = $('.puzzle-wall .right-col').height();

      if (left_col_height > right_col_height) {
        $('.puzzle-wall .right-col').append(puzzle_html);
      } else {
        $('.puzzle-wall .left-col').append(puzzle_html);
      }
    });
  }

  appendData(items);

  // endless scroll
  $(window).scroll(function() {
    if ($('.js-endless-scroll').length > 0) {
      var wintop = $(window).scrollTop(), docheight = $(document).height(), winheight = $(window).height();
      var  scrolltrigger = 0.9;
      if  ((wintop/(docheight-winheight)) > scrolltrigger) {
        endless_callback();
      }
    }
  });

  var requesting = false;
  var is_end = false;
  function endless_callback() {
    if (!requesting && !is_end) {
      requesting = true;
      $('#loading').show();

      var start = $('.puzzle-wall .puzzle').size();
      $.getJSON(ajax_request_url + '?start=' + start, function(data){
        appendData(data);

        if (data.length < 10) {
          is_end = true;
          $('#loading img').remove();
          $('#loading span').text('没有更多了');
        } else {
          $('#loading').hide();
        }
        requesting = false;
      });
    }
  }

  // actions
  $('.puzzle-wall .puzzle').hover(function(){
    $(this).find('.content').css('opacity', '.4');
    $(this).find('.actions').show();
  }, function(){
    $(this).find('.actions').hide();
    $(this).find('.content').css('opacity', '1');
  });

  // add to favorites
  $('.js-favorite').click(function(e){
    e.preventDefault();

    var that = this;

    puzzle_id = $(that).attr('data-id');
    $.getJSON('/puzzles/' + puzzle_id + '/like.json', function(data){
      if (data.status == 0){
        $(that).toggleClass('favorite');
      } else if (data.status == -2){
        window.location.href = $(that).attr('href');
      }
    });
  });

});

