import $ from 'jquery';

function updateElement(selector, html, callback, ms) {
  ms ||= fadeInterval
  $(selector).fadeOut(ms, function () {
    $(this).html(html).fadeIn(ms, callback);
  });
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

// for webpack
window.updateElement = updateElement
window.showMessage   = showMessage
