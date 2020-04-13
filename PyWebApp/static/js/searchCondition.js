var modelo = null;
var marcaSelect = null;

function getCSRFToken() {
    var cookieValue = null;
    if (document.cookie && document.cookie != '') {
        var cookies = document.cookie.split(';');
        for (var i = 0; i < cookies.length; i++) {
            var cookie = jQuery.trim(cookies[i]);
            if (cookie.substring(0, 10) == ('csrftoken' + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(10));
                break;
            }
        }
    }
    return cookieValue;
}

function loadModeloData() {
    $.ajax({
        type: "POST",
        url: "/api/Modelo/fromMarcas",
        data: {
            csrfmiddlewaretoken: getCSRFToken(),   // < here
            state: "inactive",
            marcas: $('#marca').val(),
        },
        success: function (result) {
            result['data'].forEach(e => $("#modelo").append('<option value="' + e[0] + '">' + e[3] + ' (' + e[4] + ')</option>'));
            $("#modelo").prop('disabled', false);
            $("#modelo").selectpicker('refresh');
        },
        error: function () {
        }
    })
}

$(document).ready(function () {
    modelo = $('#modelo');
    marcaSelect = $('#marca.selectpicker');
    modelo.prop('disabled', true);
    modelo.selectpicker('refresh');
    $('#marca').change(function () {
        modelo.selectpicker('val', []);
        modelo.empty();
        if (marcaSelect.val().length == 0) {
            modelo.prop('disabled', true);
            modelo.selectpicker('refresh');
        } else {
            loadModeloData();
        }
        // console.log($('#marca.selectpicker').val());
    });
});