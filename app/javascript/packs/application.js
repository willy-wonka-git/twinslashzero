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

import $ from 'jquery';
import 'bootstrap/dist/js/bootstrap.bundle'
import 'popper.js/dist/esm/popper'

window.fadeInterval   = 250;

import './shared'
import './user'
import './post'

// Initialization
document.addEventListener('turbolinks:load', function () {
  // Hide flash message
  setTimeout(() => {
    $('.app-flash').fadeOut(fadeInterval);
  }, 44000)
  $('#message').fadeOut(0)
})
