// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//
//= require jquery
//= require jquery_ujs
//= require plugins.js
//= require bootstrap-tab.js
//= require jcrop.min
//= require wordcount

$(document).ready(function(){
  $('#target').Jcrop({
    setSelect:  [ 0, 0, 128, 128 ],
    aspectRatio: 1 / 1,
    minSize: [128, 128],
    maxSize: [256, 256],
    onSelect: function (c) {
      $('#user_crop_x').val(c.x);
      $('#user_crop_y').val(c.y);
      $('#user_crop_w').val(c.w);
      $('#user_crop_h').val(c.h);
    }
  });

  $('#upload_btn').click(function(e){
    $(this).prop('disabled', true);
    $(this).val('正在上传...');
    $(this).parents('form').submit();
  });
})
