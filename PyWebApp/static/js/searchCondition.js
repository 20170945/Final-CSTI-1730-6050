var modelo = null;
var marcaSelect = null;

function loadModeloData() {
    if (marcaSelect.val().length == 2) {
        modelo.append('<option>a</option>');
    } else if (marcaSelect.val().length == 1) {
        modelo.append('<option>b</option>');
        modelo.append('<option>c</option>');
    }
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
        } else {
            loadModeloData();
            modelo.prop('disabled', false);
        }
        modelo.selectpicker('refresh');
        // console.log($('#marca.selectpicker').val());
    });
});