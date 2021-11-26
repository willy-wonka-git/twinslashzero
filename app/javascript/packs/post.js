import $ from 'jquery';
import select2 from 'select2';
import 'select2/dist/css/select2.css';

document.addEventListener('turbolinks:load', function () {
  selectTags();
  previewPhotos();
  changeState();
})

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
        data.map(v => {
          v.text = v.name
        })
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

function previewPhotos() {
  $('#post_photos').change(function () {
    $("#new-photos").html('');
    $("#current-photos").html('');
    for (let i = 0; i < $(this)[0].files.length; i++) {
      $("#new-photos").append('<img src="' + window.URL.createObjectURL(this.files[i]) + '" class="img-thumbnail me-2"/>');
    }
  });
}

function changeState() {
  const links = document.querySelectorAll("#state a[data-remote]");
  links.forEach((element) => {
    element.addEventListener("ajax:beforeSend", (event, options, v) => {
      // TODO: modal
      // Check reason for ban and reject
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
  updateElement('#current-state-' + data.id,  data.current_state)
  updateElement('#state.state-panel',         data.current_state, changeState)
  updateElement('#state-dropdown-' + data.id, data.state_dropdown, changeState, 1)
  updateElement('#history-panel',             data.history_panel)
  updateElement('#actions-panel',             data.actions_panel)
  showMessage(data.message);
}

function postAction() {
  const current_action = $('select#action')[0].value
  if (!current_action) {
    showMessage('Select action!', 'danger');
    return
  }

  let posts = []
  const els = $('.form-check-input[type="checkbox"]:checked');
  els.each(function (index, el) {
    posts.push(parseInt(el.parentElement.parentElement.dataset.id))
  })

  if (!posts.length) {
    showMessage('Select adverts!', 'danger');
    return
  }

  let reason = '';
  if ("reject, ban".indexOf(current_action) != -1) {
    reason = prompt("Please enter the reason");
    if (!reason) {
      return
    }
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

window.selectTags    = selectTags
window.previewPhotos = previewPhotos
window.changeState   = changeState
window.setState      = setState
window.postAction    = postAction
