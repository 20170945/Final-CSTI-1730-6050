$(document).ready(function () {
    $('#modelo').prop('disabled', true);
    $('#modelo').selectpicker('refresh');
    $('#marca').change(function () {
        if ($('#marca.selectpicker').val()=='all') {
            $('#modelo').prop('disabled', true);
            $('#modelo').selectpicker('val', 'all');
            $('#modelo').selectpicker('refresh');
        } else {
            $('#modelo').prop('disabled', false);
            $('#modelo').selectpicker('refresh');
        }
        console.log($('#marca.selectpicker').val()=='all');
    });
});