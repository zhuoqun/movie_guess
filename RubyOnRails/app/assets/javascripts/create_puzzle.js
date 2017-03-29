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
  
  $('#puzzle_image').change(function(){
    $('#upload_btn').prop('disabled', false);
  });

  $('#upload_btn').click(function(){
    $('#upload_btn').prop('disabled', true);
    $('#upload_btn').val('正在上传...');
    $('.upload-form').submit();
  });

  $('.js-submit').click(function(){
    $(this).prop('disabled', true);
    $(this).parents('form').submit();
  });

  $('#from_url').keyup(enable_crawl);
  $('#from_url').blur(enable_crawl);

  function enable_crawl(){
    if ($.trim($(this).val()) == '') {
      $('#crawl_btn').prop('disabled', true);
    } else {
      $('#crawl_btn').prop('disabled', false);
    }
  }

  $('#crawl_btn').click(function(e){
    e.preventDefault();
    var that = this;

    $(that).prop('disabled', true);
    $(that).text('抓取中...');
    $('#crawl_box').empty();
    $('#crawl_img').val('');

    var url = $.trim($('#from_url').val());
    var regExp = /((http[s]?):\/\/)?[^\/\.]+?\..+\w/i;
    if (url.match(regExp)) {
      $.getJSON('/puzzles/crawl_images.json?url=' + url, function(data){
        if (data.status == 0){
          if (data.images.length == 0) {
            $('#crawl_box').text('该网址没有图片，请检查您的输入');
          } else if (data.images.length == 1) {
            $('#crawl_box').append('<img src="' + data.images[0] + '" />');
            $('#crawl_img').val(data.images[0]);
          } else {
            var carousel = ich.carousel_tpl();
            $.each(data.images, function(i, v){
              if (0 == i) {
                carousel.children('.carousel-inner').append('<div class="active item"><img src="' + v + '" /></div>')
              } else {
                carousel.children('.carousel-inner').append('<div class="item"><img src="' + v + '" /></div>')
              }
            });
            $('#crawl_box').append(carousel);
            carousel.carousel({interval: false});
            carousel.on('slid', function(e){
              var selected_img = $(this).find('.active').find('img').prop('src');
              $('#crawl_img').val(selected_img);
            });

            $('#crawl_img').val(data.images[0]);
          }
        }

        $(that).text('抓取');
        $(that).prop('disabled', false);
      });
    } else {
      alert('URL 不合法')
      $(that).prop('disabled', false);
      $(that).text('抓取');
    }
  });

});
