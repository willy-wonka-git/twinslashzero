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
  window.fadeInterval = 250;
	window.showMessage = showMessage
	window.updateElement = updateElement
	window.postAction = postAction

	setTimeout(() => {
		$('.app-flash').fadeOut(fadeInterval);
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
      for (let i = 0; i < $(this)[0].files.length; i++) {
        $("#new-photos").append('<img src="'+window.URL.createObjectURL(this.files[i])+'" width="200px" class="img-thumbnail"/>');
      }
  });
}

function previewAvatar() {
  $('#user_avatar').change(function(){
      $("#avatar").html('');
      for (let i = 0; i < $(this)[0].files.length; i++) {
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
				let reason = prompt("Please enter the reason");
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
  updateElement('#current-state-' + data.id, data.current_state)
  updateElement('#state.state-panel', data.current_state, changeState)
  updateElement('#state-dropdown-' + data.id, data.state_dropdown, changeState, 1)
  updateElement('#history-panel', data.history_panel)
  updateElement('#actions-panel', data.actions_panel)

	showMessage(data.message);
}

function showMessage(text, state = 'success', ms = 2000) {
	if (!text) return

  let message = $('#message');

	message.addClass('alert-' + state)
  message.text(text)
	message.fadeIn(fadeInterval)
	setTimeout(() => {
		message.fadeOut(fadeInterval)
	}, ms)
	setTimeout(() => {
  	message.removeClass('alert-' + state)
	}, ms + fadeInterval)
}

function postAction() {
	const current_action = $('select#action')[0].value
	if (!current_action) { 
		showMessage('Select action!', 'danger');
		return
	}

	let reason = '';

	if ("reject, ban".indexOf(current_action) != -1) {
		reason = prompt("Please enter the reason");
		if (!reason) { 
			return 
		}
	}	

	let posts = []
	const els = $('.form-check-input[type="checkbox"]:checked');
	els.each(function(index, el) {
		posts.push(parseInt(el.parentElement.parentElement.dataset.id))
	})

	if (!posts.length) { 
		showMessage('Select advs!', 'danger');
		return
	}

  $.post({
    url: '/adv/action',
    data: {
    	authenticity_token: $('[name="csrf-token"]')[0].content,
    	type: current_action,
    	posts: posts,
    	reason: reason
    }
  })
  .done((data) => {
  	// change table with new rendered list
  	updateElement('#adv', data.adverts_html)
		showMessage(data.message, data.status);
  })
  .fail((data) => {
		showMessage(data.statusText, 'danger');
  });
}

function updateElement(selector, html, callback, ms) {
	ms ||= fadeInterval
	$(selector).fadeOut(ms, function() {
	  $(this).html(html).fadeIn(ms, callback);
	});	
}
