$(document).ready(function(){

  var items = [];
  items.push({'img':'http://img.hb.aicdn.com/a1f468e6e2adc9bbcb4ef482c2a5803f5bffa274f15e-Ion10M_fw554'});
  items.push({'img':'http://img1.douban.com/view/photo/photo/public/p1597979193.jpg'});
  items.push({'img':'http://img1.douban.com/view/photo/albumicon/public/p1597979230.jpg'});
  items.push({'img':'http://img1.douban.com/view/photo/photo/public/p1597979230.jpg'});
  items.push({'img':'http://img.hb.aicdn.com/f1fd340c2f6db5c6d4b4cd89731d4a1c75d3a80a304c2-vOHR7t_fw554'});

  items.push({'text':'<p>广告诱惑我们买车子，衣服，于是拼命工作买不需要的东西，我们是被历史遗忘的一代，没有目的，没有地位，没有世界大战，没有经济大恐慌，我们的大战只是心灵之战，我们的恐慌只是我们的生活。我们从小看电视，相信有一天会成为富翁，明星或摇滚巨星，但是，我们不会。那是我们逐渐面对着的现实，所以我们非常愤怒。</p>'});

  items.push({'img':'http://img1.douban.com/view/photo/photo/public/p1597979230.jpg'});
  items.push({'img':'http://img.hb.aicdn.com/f1fd340c2f6db5c6d4b4cd89731d4a1c75d3a80a304c2-vOHR7t_fw554'});
  items.push({'text':'<p>广告诱惑我们买车子，衣服，于是拼命工作买不需要的东西，我们是被历史遗忘的一代，没有目的，没有地位，没有世界大战，没有经济大恐慌，我们的大战只是心灵之战，我们的恐慌只是我们的生活。我们从小看电视，相信有一天会成为富翁，明星或摇滚巨星，但是，我们不会。那是我们逐渐面对着的现实，所以我们非常愤怒。</p>'});
  items.push({'img':'http://img.hb.aicdn.com/a1f468e6e2adc9bbcb4ef482c2a5803f5bffa274f15e-Ion10M_fw554'});
  items.push({'img':'http://img1.douban.com/view/photo/photo/public/p1597979193.jpg'});
  items.push({'img':'http://img1.douban.com/view/photo/albumicon/public/p1597979230.jpg'});
  items.push({'img':'http://img1.douban.com/view/photo/photo/public/p1597979230.jpg'});
  items.push({'img':'http://img.hb.aicdn.com/f1fd340c2f6db5c6d4b4cd89731d4a1c75d3a80a304c2-vOHR7t_fw554'});

  items.push({'text':'<p>广告诱惑我们买车子，衣服，于是拼命工作买不需要的东西，我们是被历史遗忘的一代，没有目的，没有地位，没有世界大战，没有经济大恐慌，我们的大战只是心灵之战，我们的恐慌只是我们的生活。我们从小看电视，相信有一天会成为富翁，明星或摇滚巨星，但是，我们不会。那是我们逐渐面对着的现实，所以我们非常愤怒。</p>'});

  items.push({'img':'http://img1.douban.com/view/photo/photo/public/p1597979230.jpg'});
  items.push({'img':'http://img.hb.aicdn.com/f1fd340c2f6db5c6d4b4cd89731d4a1c75d3a80a304c2-vOHR7t_fw554'});
  items.push({'text':'<p>广告诱惑我们买车子，衣服，于是拼命工作买不需要的东西，我们是被历史遗忘的一代，没有目的，没有地位，没有世界大战，没有经济大恐慌，我们的大战只是心灵之战，我们的恐慌只是我们的生活。我们从小看电视，相信有一天会成为富翁，明星或摇滚巨星，但是，我们不会。那是我们逐渐面对着的现实，所以我们非常愤怒。</p>'});

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


  // actions
  $('.puzzle-wall .puzzle').hover(function(){
    $(this).find('.content').css('opacity', '.6');
    $(this).find('.actions').show();
  }, function(){
    $(this).find('.actions').hide();
    $(this).find('.content').css('opacity', '1');
  });

});

