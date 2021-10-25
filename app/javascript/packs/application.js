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
import select2 from 'select2';
import 'select2/dist/css/select2.css';

document.addEventListener('turbolinks:load', function() {
	selectTags();

	previewAvatar();
	previewPhotos();
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
	// Fix: selections do not appear in the order in which they were selected 
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
