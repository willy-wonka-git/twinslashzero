// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

//= require jquery
//= require jquery_ujs
//= require popper
//= require bootstrap
//= require select2

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// Select tags with ajax
import $ from 'jquery';
import 'bootstrap/dist/js/bootstrap.bundle'
import 'popper.js/dist/esm/popper'
import select2 from 'select2';
import 'select2/dist/css/select2.css';

document.addEventListener('turbolinks:load', function() {
	setTimeout(() => {
		$('.app-flash').fadeOut(300);
	}, 4000)

	selectTags();
	previewAvatar();
	previewPhotos();

  $('#message').fadeOut(0)
	changeState();
})

function previewPhotos() {
  $('#post_photos').change(function(){
      $("#new-photos").html('');
      $("#current-photos").html('');
      for (var i = 0; i < $(this)[0].files.length; i++) {
        $("#new-photos").append('<img src="'+window.URL.createObjectURL(this.files[i])+'" width="200px" class="img-thumbnail"/>');
      }
  });
}

function previewAvatar() {
  $('#user_avatar').change(function(){
      $("#avatar").html('');
      for (var i = 0; i < $(this)[0].files.length; i++) {
        $("#avatar").append('<img src="'+window.URL.createObjectURL(this.files[i])+'" width="120px" class="img-thumbnail"/>');
      }
  });
}

function selectTags() {
	// FIX: selections do not appear in the order in which they were selected 
	// https://github.com/select2/select2/issues/3106
  $('#post_tag_ids').select2({
	  createTag: function (params) {
	    return {
	      id: $.trim(params.term) + '#(new)',
	      text: $.trim(params.term)
	    }
  	},
  	language: "en",
  	ajax: {
	    url: '/tags/search',
	    dataType: 'json',
	    delay: 200,
	    data: function (params) {
	      return {
	        q: params.term
	      }
	    },
	    processResults: function (data, params) {
	    	data.map(v => {v.text = v.name})
	      return {
        	results: data
      	}
	    },
		  cache: true
		},
		tags: true,
	  minimumInputLength: 2,
	  maximumInputLength: 20
	})
}

function changeState() {
  const links = document.querySelectorAll("#state a[data-remote]");
  links.forEach((element) => {

    element.addEventListener("ajax:beforeSend", (event, options, v) => {
  		// TODO: modal
    	// check reason for ban and reject
    	if ("reject, ban".indexOf(event.target.dataset.state) != -1) {
				var reason = prompt("Please enter the reason");
				if (reason) {
				  $.post({
				    url: event.detail[1].url,
				    data: {
				    	authenticity_token: $('[name="csrf-token"]')[0].content,
				    	reason: reason
				    }
				  })
				  .then((data) => {
				  	setState(data)
				  });
				}
		    event.preventDefault();
	    }
    });

    element.addEventListener("ajax:success", (event) => {
    	setState(event.detail[0])
    });
  });	
}

function setState(data) {
  var fadeInterval = 300;
  var message = $('#message');

	$('#current-state').fadeOut(fadeInterval, function() {
	    $(this).html(data.current_state).fadeIn(fadeInterval);
	});

	$('#state').fadeOut(fadeInterval, function() {
	    $(this).html(data.content).fadeIn(fadeInterval);
	    changeState();
	});

	message.addClass("alert-success")
  message.text(data.message)
	message.fadeIn(fadeInterval)
	setTimeout(() => {
  	message.removeClass("alert-success")
		message.fadeOut(fadeInterval)
	}, 2000)
}
