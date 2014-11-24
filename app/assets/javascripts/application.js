// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-1.9.1.min
//= require jquery.als-1.6.min
//= require bootstrap
//= require respond
//= require chosen.jquery
//= require bootstrap-select
//= require redactor.js
//= require imagemanager.js

//= require redactor-rails/fontcolor
//= require redactor-rails/fontsize
//= require redactor-rails/fontfamily
//= require redactor-rails/video
//= require redactor-rails/table
//= require redactor-rails/langs/ko

window.init_redactor = function() {
  var csrf_token = $('meta[name=csrf-token]').attr('content');
  var csrf_param = $('meta[name=csrf-param]').attr('content');
  var params;
  if (csrf_param !== undefined && csrf_token !== undefined) {
    params = csrf_param + "=" + encodeURIComponent(csrf_token);
  }
  $('.redactor').redactor({
      imageUpload: '/redactor/pictures?' + params,
      // lang: 'ko',
      // cleanSpaces: false,
      // cleanup: false,
      // linebreaks: true,
      // removeEmptyTags: false,
      // toolbarFixed: true,
      // fixed: true,
      // toolbarFixedBox: true,
      // plugins: ['fontcolor', 'fontsize', 'video', 'fontfamily', 'table']
  });
}
$(document).ready(function(){

  $(".img-list").als({
    visible_items: 5,
    circular: "yes"
  });
  $(".chosen-select").chosen({disable_search_threshold: 10});
  $('.carousel').carousel({interval: 8000});
  var check_extra_copyright = function() {
    var checked ;
    if($("#image_extra_copyright").length > 0){
      checked = $('#image_extra_copyright').is(":checked");
    }else if($("#video_extra_copyright").length > 0){
      checked = $('#video_extra_copyright').is(":checked");
    }else if($("#audio_extra_copyright").length > 0){
      checked = $('#audio_extra_copyright').is(":checked");
    }
    if(checked){
      $('.basic_copyright_area').hide();
      $('.extra_copyright_area').show();
    }else{
      $('.basic_copyright_area').show();
      $('.extra_copyright_area').hide();
    }
  };

  check_extra_copyright();
  $('#video_extra_copyright').click(function(e){
    check_extra_copyright();
  });

  $('#image_extra_copyright').click(function(e){
    check_extra_copyright();
  });

  $('#audio_extra_copyright').click(function(e){
    check_extra_copyright();
  });
  window.init_redactor();
});

