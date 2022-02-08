import $ from 'jquery';
import select2 from 'select2';
import 'select2/dist/css/select2.css';

document.addEventListener('turbolinks:load', function () {
    selectTags();
    previewPhotos();
    changeState();
    updateElementsPhoto();
    hideSpinner();
    $('#remove_photos').click(removeAllImages);

    $('#photos').click(selectFiles);
    $('#photos').on('drop', photosDrop);
    $('#photos').on('dragover', photosDragOver);
    $('#photos').on('dragleave', photosDragLeave);
})

function getAJAXImageURL(type) {
    return '/adv/' + getPostID() + '/image/' + type;
}

function getPostID() {
    return $('form').attr('id').replace('edit_post_', '').replace('_post', '');
}

function showSpinner() {
    $('#photos .overlay').show()
}

function hideSpinner() {
    $('#photos .overlay').hide()
}


function cacheFiles(files) {
    let images_count = $('#photos .img-thumbnail').length;
    const new_images = [];
    let errors = [];
    let warnings = [];

    // Check file requirements
    for (let i = 0; i < files.length; i++) {
        const f = files[i];
        const err = [];
        if (images_count + new_images.length == 10) { // Too many images. Can add only 10 files.
            warnings.push("Too many images. You can add only 10 files.");
            break;
        }
        // size
        if (f.size > 2 ** 20) { // 1Mb
            err.push("Image is too large (1Mb): " + f.name);
        }
        // type
        if ('image/jpg, image/jpeg, image/png, image/gif'.indexOf(f.type) == -1) {
            err.push("Invalid file format (*.jpg, *.png, *.gif): " + f.name);
        }
        // count
        if (err.length) {
            errors = errors.concat(err)
            continue;
        }
        new_images.push(f)
    }

    if (errors.length) {
        showMessage(errors.join('<br>'), 'danger', 5000);
        return;
    }
    if (warnings.length) {
        showMessage(warnings.join('<br>'), 'warning', 5000);
    }

    // Upload images to the server
    const formData = new FormData();
    formData.append('authenticity_token', $('[name="csrf-token"]')[0].content)
    formData.append('operation', 'add_images')
    for (let i = 0; i < new_images.length; i++) {
        formData.append('photo' + i, new_images[i], new_images[i].name); // array photo[] does not work
    }

    const tmpl = '<div class="photo" data-key="{key}">' +
        '<div class="img-thumbnail" style= "background-image: url({link}">' +
        '<button type="button" class="btn btn-light btn-close" aria-label="Close"/>' +
        '</div>' +
        '</div>'

    showSpinner()
    fetch(getAJAXImageURL('add_files'), {
        method: 'POST',
        body: formData,
    })
        .then((response) => {
            if (!response.ok) {
                hideSpinner();
                throw new Error('Upload error');
            }
            return response.json();
        })
        .then((data) => {
            const images = data.result.images
            for (let i = 0; i < images.length; i++) {
                $("#photos").append(tmpl
                    .replace('{link}', images[i]) // window.URL.createObjectURL(files[i])
                    .replace('{key}', images[i])
                );
            }
            updateElementsPhoto();
            const errors = data.result.errors
            if (errors.length) {
                showMessage(errors.join('<br>'), 'danger')
            }
            hideSpinner();
        })
        .catch((error) => {
            hideSpinner();
            showMessage('Upload error.', 'danger')
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
        cacheFiles($(this)[0].files);
    });
}

function updateElementsPhoto() {
    $('.photo .btn-close').click(removeImage);
    const photo_count = $('#photos .img-thumbnail').length;
    if (photo_count == 0) {
        $('#photos').addClass('empty bg-light')
    } else {
        $('#photos').removeClass('empty bg-light')
    }
    if (photo_count > 1) {
        $('#remove_photos').show()
    } else {
        $('#remove_photos').hide()
    }
    if (photo_count == 10) {
        $('.post_photos').hide()
    } else {
        $('.post_photos').show()
    }

}

function selectFiles() {
    $('.post_photos .form-control-file').click()
}

function removeImage(event) {
    event.stopPropagation();
    event.preventDefault();
    const el = event.currentTarget;
    $.post({
        url: getAJAXImageURL('delete'),
        data: {
            authenticity_token: $('[name="csrf-token"]')[0].content,
            image_key: $($(el).parentsUntil('#photos', '.photo')[0]).data('key')
        }
    })
        .done((data) => {
            $($(el).parentsUntil('#photos', '.photo')[0]).remove();
            updateElementsPhoto();
        })
        .fail((data) => {
            showMessage('Can not remove.', 'danger')
        });
}

function removeAllImages(event) {
    const el = event.currentTarget;
    $.post({
        url: getAJAXImageURL('delete_all'),
        data: {
            authenticity_token: $('[name="csrf-token"]')[0].content
        }
    })
        .done((data) => {
            $('#photos .photo').remove();
            updateElementsPhoto();
        })
        .fail((data) => {
            showMessage('Can not remove.', 'danger')
        });
}

function photosDrop(e) {
    e.preventDefault();
    $('#photos').removeClass('dragover')

    const dt = e.originalEvent.dataTransfer;

    let files = [];
    if (dt.items) {
        // Use dtItemList interface to access the file(s)
        for (let i = 0; i < dt.items.length; i++) {
            // If dropped items aren't files, reject them
            if (dt.items[i].kind === 'file') {
                files.push(dt.items[i].getAsFile());
            }
        }
    } else {
        // Use dataTransfer interface to access the file(s)
        files = dt.files
    }
    cacheFiles(files)
}

function photosDragOver(event) {
    event.preventDefault();
    $('#photos').addClass('dragover')
}

function photosDragLeave(event) {
    event.preventDefault();
    $('#photos').removeClass('dragover')
}

function changeState() {
    const links = document.querySelectorAll("#state a[data-remote]");
    links.forEach((element) => {
        element.addEventListener("ajax:beforeSend", (event, options, v) => {
            // Check reason for ban and reject
            if ("reject, ban".indexOf(event.target.dataset.state) == -1) {
                return
            }

            event.preventDefault();
            event.stopPropagation();

            // TODO: modal
            let reason = prompt("Please enter the reason");
            if (!reason) {
                if (reason !== null) {
                    showMessage('You must enter the reason of the action!', 'danger');
                }
                return
            }

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
            if (reason !== null) {
                showMessage('You must enter the reason of the action!', 'danger');
            }
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
            // replace table with new rendered data
            updateElement('#adv', data.adverts_html)
            showMessage(data.message, data.status);
        })
        .fail((data) => {
            showMessage(data.statusText, 'danger');
        });
}

window.selectTags = selectTags
window.previewPhotos = previewPhotos
window.changeState = changeState
window.setState = setState
window.postAction = postAction
window.removeImage = removeImage
window.removeAllImages = removeAllImages
window.updateElementsPhoto = updateElementsPhoto
window.selectFiles = selectFiles
window.photosDrop = photosDrop
window.photosDragOver = photosDragOver
window.photosDragLeave = photosDragLeave
