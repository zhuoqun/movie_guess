$(document).ready(function(){
  $('.discussion-area').focus(function(){
    if ($.trim($(this).val()) == '可以在这里讨论与影片有关的事情。请不要剧透，影响别人猜谜的乐趣。'){
      $(this).val('');
    }

    $(this).css('color', '#333');
  }).blur(function(){
    if ($.trim($(this).val()) == ''){
      $(this).val('可以在这里讨论与影片有关的事情。请不要剧透，影响别人猜谜的乐趣。');
      $(this).css('color', '#999');
    }
  }).keyup(function(){
    if ($.trim($(this).val()) !== '') {
      $(this).next().prop('disabled', false);
    } else {
      $(this).next().prop('disabled', true);
    }
  });

  $('.discussion-area').atWho('@', {
    'tpl': "<li data-id='${id}' data-value='${filter}' data-name='${name}'><img src='${avatar}' height='20px' width='20px'>${name}</li>",
    'choose': 'data-name',
    'callback': function(query, callback){
      $.getJSON('/accounts/all_users.json', {'query':query}, function(data){
        callback(data);
      });
    }
  });

  $('.discussion-input').delegate('button', 'click', function(e){
    var that = this;
    var content = $.trim($(that).prev().val());
    var mentions = $(that).prev().getMentions();

    var puzzle_id = $('.puzzle-detail').attr('data-id');
    $(that).prop('disabled', true);
    if (content !== '') {
      $.post('/puzzles/' + puzzle_id + '/discussions.json', {'content': content, 'mentions': mentions}, function(data){
        if (data.status == 0){
          $(that).parents('.discussion-input').before(ich.discussion_tpl(data.discussion));
          $(that).prev().val('');
          attachDiscussionEvent();
          alert('发表成功！');
          $(that).prop('disabled', false);
        }
      })
    }
  });

  function getMoreDiscussions(){
    var puzzle_id = $('.puzzle-detail').attr('data-id');
    var start = $('.discussions li').length - $('.discussions .discussion-input').length;
    var params = start > 0 ? '?start='+start : '';

    $('.puzzle-discuss .load-more').prop('disabled', true);
    $('.puzzle-discuss .loading').show();
    $.getJSON('/puzzles/' + puzzle_id + '/discussions.json' + params, function(data){
      $.each(data, function(i, v){
        if ($('.discussion-input').length > 0) {
          $('.discussion-input').before(ich.discussion_tpl(v));
        } else {
          $('ul.discussions').append(ich.discussion_tpl(v));
        }
      });

      $('.puzzle-discuss .loading').hide();

      attachDiscussionEvent();

      if (data.length < 10) {
        $('.puzzle-discuss .load-more').replaceWith('<div class="no-more">没有更多了</div>');
      } else {
        $('.puzzle-discuss .load-more').prop('disabled', false);
      }
    });
  }

  function attachDiscussionEvent(){
    if ($('#current_user_id').length > 0) {
      $('.js-discussion-reply').unbind();
      $('.js-discussion-reply').click(function(e){
        e.preventDefault();
        var id = $(this).attr('data-id');
        var name = $(this).attr('data-name');
        var input = $(this).parents('.discussions').find('.discussion-area');

        if ($.trim(input.val()) == '可以在这里讨论与影片有关的事情。请不要剧透，影响别人猜谜的乐趣。'){
          input.val('');
        }

        input.insertAtCaret('@' + name + ' ');
        input.addMention({id:id, name:name});
        if (input.next().prop('disabled')) {
          input.next().prop('disabled', false);
        }
      });

      $('.js-discussion-upvote').unbind();
      $('.js-discussion-upvote').click(function(e){
        e.preventDefault();
        var that = this;
        var id = $(that).attr('data-id');

        $.getJSON('/discussions/' + id + '/upvote.json', function(data){
          if (data.status == 0) {
            if (data.action == 'vote') {
              $(that).addClass('voted');
              $(that).prop('title', '取消');
            } else if (data.action == 'unvote') {
              $(that).removeClass('voted');
              $(that).prop('title', '');
            }

            $(that).text('赞 '+data.upvotes_cnt);

          } else if (data.status == -2) {
            window.location.href = "/accounts/login"
          }
        });
      });
    }
  }

  $('.puzzle-discuss .load-more').click(function(e){
    e.preventDefault();
    getMoreDiscussions();
  });

  if ($('.puzzle-discuss .load-more').length > 0) {
    getMoreDiscussions();
  } else {
    $('.puzzle-discuss .loading').hide();
  }
})
