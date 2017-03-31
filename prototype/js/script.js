$(document).ready(function(){

  var items = [];
  items.push({'img':'img/img-1.jpg', 'height':'286px'});
  items.push({'img':'img/img-4.jpg', 'height':'153px'});
  items.push({'img':'img/img-5.jpg', 'height':'799px', 'has_best': 'has_best'});
  items.push({'img':'img/img-6.jpg', 'height':'357px'});
  items.push({'img':'img/img-7.jpg', 'height':'271px'});

  items.push({'text':'<p>广告诱惑我们买车子，衣服，于是拼命工作买不需要的东西，我们是被历史遗忘的一代，没有目的，没有地位，没有世界大战，没有经济大恐慌，我们的大战只是心灵之战，我们的恐慌只是我们的生活。我们从小看电视，相信有一天会成为富翁，明星或摇滚巨星，但是，我们不会。那是我们逐渐面对着的现实，所以我们非常愤怒。</p>'});
  items.push({'text':'<p>广告诱惑我们买车子，衣服，于是拼命工作买不需要的东西，我们是被历史遗忘的一代，没有目的，没有地位，没有世界大战，没有经济大恐慌，我们的大战只是心灵之战，我们的恐慌只是我们的生活。我们从小看电视，相信有一天会成为富翁，明星或摇滚巨星，但是，我们不会。那是我们逐渐面对着的现实，所以我们非常愤怒。</p>'});
  items.push({'img':'http://img.hb.aicdn.com/33bc92fb135afc3218cab2c5b61465dfeb4b2ad15251a-kepBcY_fw192', 'height':'357px', 'has_best': 'has_best'});
  items.push({'img':'img/img-1.jpg', 'height':'286px'});
  items.push({'img':'img/img-4.jpg', 'height':'153px'});
  items.push({'img':'img/img-5.jpg', 'height':'799px', 'has_best': 'has_best'});
  items.push({'img':'img/img-6.jpg', 'height':'357px'});
  items.push({'img':'img/img-7.jpg', 'height':'271px'});

  items.push({'img':'img/img-6.jpg', 'height':'357px'});
  items.push({'img':'img/img-7.jpg', 'height':'271px'});

  var is_adjusting = false;
  // if col count doesn't change after resize, then do not adjust
  var last_col = 0;
  var cols_height = [];

  function adjustWrapperHeight() {
    var max_height = 0;
    for (var i=0; i<cols_height.length; i++) {
      if (max_height < cols_height[i]) {
        max_height = cols_height[i];
      }
    }
    $('.waterfall').height(max_height + 30);
  }

  function getMinIdx() {
    var min_idx = 0;
    var min_height = cols_height[0];
    for (var k=0; k< cols_height.length; k++) {
      if (min_height > cols_height[k]) {
        min_height = cols_height[k];
        min_idx = k;
      }
    }
    return min_idx;
  }

  function getColsHeight(is_adjust) {
    if (cols_height.length == 0 || is_adjust) {
      //initialinze
      var col_cnt = Math.floor(($(window).width() + 15) / 237);
      col_cnt = col_cnt < 4 ? 4 : col_cnt;

      cols_height.length = col_cnt;

      for (var i=0; i<col_cnt; i++) {
        cols_height[i] = 0;
      }

      var wrapper_width = col_cnt * 237 - 15;
      $('.waterfall-wrapper').width(wrapper_width);
      $('.auto-adjust').width(wrapper_width);
    }

    return cols_height.length;
  }

  function appendData(data) {
    is_adjusting = true;

    var col_cnt = getColsHeight();

    var rows = Math.ceil(data.length / col_cnt);
    for (var i=0; i<rows; i++) {
      for (var j=0; j<col_cnt; j++) {
        if (i*col_cnt + j >= data.length) break;

        var puzzle = data[i*col_cnt + j];
        var puzzle_html;

        if (puzzle.text) {
          puzzle_html = ich.puzzle_text_tpl(puzzle);
        } else {
          puzzle_html = ich.puzzle_img_tpl(puzzle);
        }

        var min_idx = getMinIdx();

        puzzle_html.css('top', cols_height[min_idx]);
        puzzle_html.css('left', 237*min_idx + 'px');
        $('.waterfall').append(puzzle_html);
        cols_height[min_idx] += puzzle_html.height() + 30;
      }
    }

    adjustWrapperHeight();

    is_adjusting = false;
  }

  function adjust() {
    is_adjusting = true;

    var col_cnt = getColsHeight(true);

    if (last_col == col_cnt) {
      is_adjusting = false;
      return;
    }

    last_col = col_cnt;

    var all_puzzles = $('.waterfall .puzzle');

    var rows = Math.ceil(all_puzzles.size() / col_cnt);
    for (var i=0; i<rows; i++) {
      for (var j=0; j<col_cnt; j++) {
        if (i*col_cnt + j >= all_puzzles.size()) break;

        var puzzle = all_puzzles.get(i*col_cnt + j);

        var min_idx = getMinIdx();

        $(puzzle).css('top', cols_height[min_idx]);
        $(puzzle).css('left', 237*min_idx + 'px');
        cols_height[min_idx] += $(puzzle).height() + 30;
      }
    }

    adjustWrapperHeight();

    is_adjusting = false;
  }

  $(window).resize(function(){
    if (!is_adjusting) {
      adjust();
    }
  });
  appendData(items);


  // actions
  $('.waterfall .puzzle').hover(function(){
    $(this).find('.content').css('opacity', '.6');
    $(this).find('.actions').show();
  }, function(){
    $(this).find('.actions').hide();
    $(this).find('.content').css('opacity', '1');
  });

});

