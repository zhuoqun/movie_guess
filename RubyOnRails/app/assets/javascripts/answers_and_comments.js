function attachAnswersAndCommentsEvents() {

  // add answer
  $('.answer-area').unbind();
  $('.answer-area').keyup(function(){
    if ($.trim($(this).val()) !== '') {
      $(this).next().prop('disabled', false);
    } else {
      $(this).next().prop('disabled', true);
    }
  });

  $('.answer-input button').unbind();
  $('.answer-input button').click(function(){
    var that = this;

    var puzzle_id = $(that).parents('.puzzle-detail').attr('data-id');
    $(that).prop('disabled', true);
    var content = $.trim($(that).prev().val());

    $.post('/puzzles/' + puzzle_id + '/answers.json', {'content': content}, function(data){
      if (data.status == 0){
        var add_answer = $(that).parents('.add-answer');
        var my_answer = $(that).parents('.add-answer').prev();
        my_answer.find('.content').html(content);
        add_answer.hide();
        my_answer.find('li').prop('id', 'answer-' + data.answer_id);
        my_answer.find('.timestamp').html(data.timestamp);
        my_answer.show();
        attachCommentsEvent();
      }
    })
  });

  // view answers
  $('.view-answer a').unbind();
  $('.view-answer a').click(function(e){
    e.preventDefault();
    var that = this;

    var puzzle_id = $(that).parents('.puzzle-detail').attr('data-id');
    var view_answer = $(that).parent();
    $(that).parent().text('正在加载...')

    $.getJSON('/puzzles/' + puzzle_id + '/answers.json', function(data){
      if (data.length == 0) {
        view_answer.text('暂时没有其它答案');
      } else {
        var all_answers = view_answer.next();
        var answers_list = all_answers.children('ul');
        $.each(data, function(k, v){
          answer_html = ich.answer_tpl(v);
          answers_list.append(answer_html);
        });
        all_answers.show();
        view_answer.remove();
        attachCommentsEvent();
        markAsCorrect();
      }
    });
  });

  //  mark as correct
  function markAsCorrect() {
    toggleCorrectLink();

    $('.js-mark-as-correct').unbind();
    $('.js-mark-as-correct').click(function(e){
      e.preventDefault();
      var that = this;

      var li_el = $(that).parents('li');
      var answer_id = li_el.attr('id').substr(7);
      $.getJSON('/answers/' + answer_id + '/mark_as_correct.json', function(data){
        if (data.status == 0) {
          $(that).hide();
          $('.answers .correct').addClass('not-correct').removeClass('correct');
          li_el.removeClass('not-correct');
          li_el.addClass('correct');
          toggleCorrectLink();
        }
      });
    });

    $('.js-cancel-mark-as-correct').unbind();
    $('.js-cancel-mark-as-correct').click(function(e){
      e.preventDefault();
      var that = this;

      var li_el = $(that).parents('li');
      var answer_id = li_el.attr('id').substr(7);
      $.getJSON('/answers/' + answer_id + '/cancel_mark_as_correct.json', function(data){
        if (data.status == 0) {
          $(that).hide();
          li_el.removeClass('correct');
          li_el.addClass('not-correct');
          toggleCorrectLink();
        }
      });
    });
  }

  function toggleCorrectLink() {
    $('.answers li').unbind();
    $('.answers .not-correct').hover(function(){
      $(this).find('.js-mark-as-correct').show();
    }, function(){
      $(this).find('.js-mark-as-correct').hide();
    });
    $('.answers .correct').hover(function(){
      $(this).find('.js-cancel-mark-as-correct').css('display', 'block');
    }, function(){
      $(this).find('.js-cancel-mark-as-correct').css('display', 'none');
    });
  }
  markAsCorrect();

  // add to favorites
  $('.js-favorite').unbind();
  $('.js-favorite').click(function(e){
    e.preventDefault();

    var that = this;

    var puzzle_id = $(that).parents('.puzzle-detail').attr('data-id');
    $.getJSON('/puzzles/' + puzzle_id + '/like.json', function(data){
      if (data.status == 0){
        $(that).toggleClass('favorite');
      } else if (data.status == -2) {
        window.location.href = $(that).attr('href');
      }
    });
  });

  // edit answer
  $('.js-edit').unbind();
  $('.js-edit').click(function(e){
    e.preventDefault();

    var answer_body = $(this).parents('.answer-body');
    var answer_edit = answer_body.prev();
    var content = answer_body.children('p').text();

    $(this).parents('li').children('.comments').hide();

    answer_edit.children('textarea').val($.trim(content));
    answer_edit.show();
    answer_body.hide();
  });

  $('.js-comment').unbind();
  $('.js-comment').click(function(e){
    showComments(e);
  });

  $('.answer-edit .js-cancel').unbind();
  $('.answer-edit .js-cancel').click(function(e){
    e.preventDefault();
    $(this).parent().next().show();
    $(this).parent().hide();
  });

  $('.answer-edit .js-save').unbind();
  $('.answer-edit .js-save').click(function(){
    var that = this;

    var puzzle_id = $(that).parents('.puzzle-detail').attr('data-id');
    $(that).prop('disabled', true);

    var content = $.trim($(that).prev().val());
    var answer_id = $(that).parents('li').attr('id').substr(7);

    $.post('/puzzles/' + puzzle_id + '/answers/'+ answer_id +'.json', { _method:'PUT', 'content': content}, function(data){
      if (data.status == 0){
        var answer_body = $(that).parent().next();
        answer_body.children('p').text(content);
        answer_body.show();
        $(that).prop('disabled', false);
        $(that).parent().hide();
      }
    })
  });


  // view && add comment
  function attachCommentsEvent() {
    $('.js-comment').unbind();

    $('.js-comment').click(function(e){
      showComments(e);
    });

    // vote answer
    $('.js-upvote').unbind();
    $('.js-upvote').click(function(e){
      e.preventDefault();

      var that = this;
      var answer_id = $(that).parents('li').attr('id').substr(7);

      $.getJSON('/answers/' + answer_id + '/upvote.json', function(data){
        if (data.status == 0) {
          if (data.action == 'vote') {
            $(that).next().removeClass('voted');
            $(that).addClass('voted');
            $(that).prop('title', '取消赞同');
          } else if (data.action == 'unvote') {
            $(that).removeClass('voted');
            $(that).prop('title', '');
          }

          $(that).text('赞同('+data.upvotes_cnt+')');
          $(that).next().text('反对('+data.downvotes_cnt+')');
        } else if (data.status == -2) {
          window.location.href = "/accounts/login"
        }
      });

    });

    $('.js-downvote').unbind();
    $('.js-downvote').click(function(e){
      e.preventDefault();

      var that = this;
      var answer_id = $(that).parents('li').attr('id').substr(7);

      $.getJSON('/answers/' + answer_id + '/downvote.json', function(data){
        if (data.status == 0) {
          if (data.action == 'vote') {
            $(that).prev().removeClass('voted');
            $(that).addClass('voted');
            $(that).prop('title', '取消反对');
          } else if (data.action == 'unvote') {
            $(that).removeClass('voted');
            $(that).prop('title', '');
          }

          $(that).prev().text('赞同('+data.upvotes_cnt+')');
          $(that).text('反对('+data.downvotes_cnt+')');

        } else if (data.status == -2) {
          window.location.href = "/accounts/login"
        }
      });

    });
  }

  function showComments(e) {
    e.preventDefault();

    var item = $(e.target).parents('li');
    var comments_list = item.children('.comments');
    var answer_id = item.attr('id').substr(7);

    if (comments_list.html() == '') {
      comments_list.append('<li class="clearfix">正在加载评论……</li>');

      $.getJSON('/answers/' + answer_id + '/comments.json', function(data){
        comments_list.html('');

        if (data.length == 0) {
          if ($('#current_user_id').length > 0) {
            addCommentBox(comments_list, answer_id);
          } else {
            comments_list.append('<li class="clearfix">暂时没有评论</li>');
          }
        } else {
          $.each(data, function(k, v){
            comments_list.append(ich.comment_tpl(v));
          });

          if ($('#current_user_id').length > 0) {
            addCommentBox(comments_list, answer_id);
          }

        }
      });
    } else {
      comments_list.toggle();
    }
  }

  function addCommentBox(comments_list, answer_id) {
    comments_list.prepend('<li class="clearfix comment-input"> <a class="avatar" href=""> <img src="' + current_user_avatar + '" width="30px" height="30px"> </a> <div class="comment-body"> <textarea class="comment-area"></textarea> <button disabled="true" class="btn btn-primary">评论</button> </div> </li>');

    $('.comment-input').unbind();
    $('.comment-area').unbind();
    $('ul.comments li').unbind();
    $('.js-reply').unbind();

    $('.comment-input').delegate('button', 'click', function(e){
      var that = this;
      var content = $.trim($(that).prev().val());
      var mentions = $(that).prev().getMentions();

      $(that).prop('disabled', true);
      if (content !== '') {
        $.post('/answers/' + answer_id + '/comments.json', {'content': content, 'mentions': mentions}, function(data){
          if (data.status == 0){
            $(that).parents('.comment-input').after(ich.comment_tpl(data.comment));
            $(that).prev().val('');
            alert('评论发表成功！');
            $(that).prop('disabled', false);
          }
        })
      }
    });

    $('ul.comments li').hover(function(){
      $(this).find('.js-reply').show();
    }, function(){
      $(this).find('.js-reply').hide();
    });

    $('.js-reply').click(function(e){
      e.preventDefault();
      var id = $(this).attr('data-id');
      var name = $(this).attr('data-name');
      var input = $(this).parents('.comments').find('.comment-area');
      input.insertAtCaret('@' + name + ' ');
      input.addMention({id:id, name:name});
      if (input.next().prop('disabled')) {
        input.next().prop('disabled', false);
      }
    });

    $('.comment-area').keyup(function(){
      if ($.trim($(this).val()) !== '') {
        $(this).next().prop('disabled', false);
      } else {
        $(this).next().prop('disabled', true);
      }
    });

    $('.comment-area').atWho('@', {
      'tpl': "<li data-id='${id}' data-value='${filter}' data-name='${name}'><img src='${avatar}' height='20px' width='20px'>${name}</li>",
      'choose': 'data-name',
      'callback': function(query, callback){
        $.getJSON('/accounts/all_users.json', {'query':query}, function(data){
          callback(data);
        });
      }
    });
  }

  if (typeof(comments_open) != 'undefined' && comments_open) {
    attachCommentsEvent();
    $('.js-comment').trigger('click');
  }
}
