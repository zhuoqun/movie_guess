// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//
//= require jquery
//= require jquery_ujs
//= require plugins.js
//= require icanhaz.js
//= require puzzlewall.js
//= require bootstrap-dropdown.js
//= require relations.js

// for notifications
$(document).ready(function(){
  $('.notifications .load-more').click(function(e){
    e.preventDefault();
    var that = this;
    $(that).prop('disabled', true);

    var start = $('.notifications li').size();
    $.getJSON('/notifications.json?start=' + start, function(data){
      if (data.length > 0) {
        $.each(data, function(i, v){
          li_el = '';

          if ('follow' == v.action) {
            li_el = ich.notification_follow_tpl(v);
          } else if ('add' == v.action && 'answer' == v.target_type) {
            li_el = ich.notification_add_answer_tpl(v);
          } else if ('add' == v.action && 'comment' == v.target_type) {
            li_el = ich.notification_add_comment_tpl(v);
          } else if ('upvote' == v.action && 'answer' == v.target_type) {
            li_el = ich.notification_upvote_answer_tpl(v);
          } else if ('mark_as_correct' == v.action && 'answer' == v.target_type) {
            li_el = ich.notification_mark_as_correct_tpl(v);
          }

          $('.notifications ul').append(li_el);
        });
      }

      if (data.length < 10) {
        $(that).text('没有更多了');
        $('.notifications .load-more').unbind();
      } else {
        $(that).prop('disabled', false);
      }
    });
  });
})
