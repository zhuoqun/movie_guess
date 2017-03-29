$(document).ready(function(){

  // for create item modal
  $('.mode-select').delegate('a', 'click', function(e){
    e.preventDefault();
    if ($(this).hasClass('upload')){
      $('.create-form-img').addClass('upload');
      $('.create-form-img').show();
    } else {
      $('.create-form-img').addClass('url');
      $('.create-form-img').show();
      $('#from_url').focus();
    }

    $('.mode-select').hide();
  });

  $('.mode-switch').delegate('a', 'click', function(e){
    e.preventDefault();
    if ($(this).hasClass('to-upload')){
      $('.create-form-img').removeClass('url');
      $('.create-form-img').addClass('upload');
    } else {
      $('.create-form-img').removeClass('upload');
      $('.create-form-img').addClass('url');
      $('#from_url').focus();
    }
  });

  $('#create_modal').on('hidden', function(){
    $('.create-form-img').removeClass('upload');
    $('.create-form-img').removeClass('url');
    $('#create_modal input').val('');
    $('.create-form-img').hide();
    $('.mode-select').show();
  });
});
