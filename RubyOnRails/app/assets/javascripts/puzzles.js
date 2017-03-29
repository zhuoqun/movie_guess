// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//= require jquery
//= require jquery_ujs
//= require plugins
//= require icanhaz
//= require bootstrap-tab
//= require bootstrap-carousel
//= require wordcount
//= require create_puzzle
//= require jquery.remotipart
//= require relations
//= require jquery.caret
//= require jquery.atwho
//= require answers_and_comments
//= require discussions

$(document).ready(function(){
  $('.js-enable-submit input[type=text]').keyup(enable_submit);
  $('.js-enable-submit input[type=text]').blur(enable_submit);

  function enable_submit(e) {
    var that = this;

    if ($(that).attr('id') == 'from_url') return;

    var submit_btn = $(that).parents('form').find('input[type=submit]');

    flag = true;
    $(that).parent().find('input[type=text]').each(function(){
      if ($.trim($(this).val()) !== '') {
        submit_btn.prop('disabled', false);
        flag = false;
        return false;
      }
    });

    if(flag) submit_btn.prop('disabled', true);
  }

  attachAnswersAndCommentsEvents();

  $('.del-btn').click(function(e){
    e.preventDefault();
    var that = this;

    if (window.confirm('你确定要删除吗？')) {
      var puzzle_id = $(that).attr('data-id');
      $.getJSON('/puzzles/' + puzzle_id + '/disable.json', function(data){
        if (data.status == 0) {
          alert('删除成功');
          location.href = '/';
        }
      });
    }
  });

})
