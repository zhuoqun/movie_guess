$(document).ready(function(){
  // follow
  $('.follow-btn').click(function(e){
    e.preventDefault();

    var that = this;
    var contact_id = $(that).attr('data-id');

    $.getJSON('/' + contact_id +'/follow.json', function(data){
      if (data.status == 0) {
        $(that).hide();
        $(that).prev().show();
      }
    })
  });

  // unfollow
  $('.unfollow-btn').hover(function(){
    $(this).addClass('btn-danger');
    $(this).removeClass('btn-success');
    $(this).html('<i class="icon-remove icon-white"></i> 取消关注');
  }, function(){
    $(this).addClass('btn-success');
    $(this).removeClass('btn-danger');
    $(this).html('<i class="icon-ok icon-white"></i> 已关注');
  });

  $('.unfollow-btn').click(function(e){
    e.preventDefault();

    var that = this;
    var contact_id = $(that).attr('data-id');

    $.getJSON('/' + contact_id +'/unfollow.json', function(data){
      if (data.status == 0) {
        $(that).hide();
        $(that).next().show();
      }
    })
  });
})

