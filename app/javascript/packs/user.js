import $ from 'jquery';

document.addEventListener('turbolinks:load', function () {
  previewAvatar();
})

function previewAvatar() {
  $('#user_avatar').change(function () {
    $("#avatar").html('');
    for (let i = 0; i < $(this)[0].files.length; i++) {
      $("#avatar").append('<img src="' + window.URL.createObjectURL(this.files[i]) + '" class="img-thumbnail"/>');
    }
  });
}

window.previewAvatar = previewAvatar
