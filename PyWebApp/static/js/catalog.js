var slider = null;
var yearRange = null;

function updateYearRange() {
    values = slider.noUiSlider.get();
    if (values[0] != values[1])
        yearRange.innerHTML = 'Año: ' + Math.floor(values[0]) + '-' + Math.floor(values[1]);
    else
        yearRange.innerHTML = 'Año: ' + Math.floor(values[0]);
}

$(document).ready(function () {
    let datos = window.location.search.substring(1).split('&');
    let datosDict = {}
    var yearAr = [1970, new Date().getFullYear() + 1]
    for (let i = 0; i < datos.length; i++) {
        let temp = datos[i].split('=');
        temp[1] = temp[1].replace('+',' ');
        if (temp[0] in datosDict) {
            datosDict[temp[0]].push(temp[1])
        } else {
            datosDict[temp[0]]=[temp[1]]
        }
    }
    if('estado' in datosDict) {
        $("#estado").val(datosDict['estado'][0]);
    }
    if('year' in datosDict) {
        yearAr[0] = Math.min(...datosDict['year']);
        yearAr[1] = Math.max(...datosDict['year']);
    }
    if('marca' in datosDict) {
        $('#marca').selectpicker('val', datosDict['marca']);
        modelo.empty();
        modelo.prop('disabled', false);
        loadModeloData();
        if('modelo' in datosDict) {
            modelo.selectpicker('val', datosDict['modelo']);
        }
        modelo.selectpicker('refresh');
    }
    if('price' in datosDict) {
        $('#priceA').val(Math.min(...datosDict['price']));
        $('#priceB').val(Math.max(...datosDict['price']));
    }
    if('lugar' in datosDict) {
        $('#lugar').selectpicker('val', datosDict['lugar']);
        $('#lugar').selectpicker('refresh');
    }
    slider = document.getElementById('yearslider');
    yearRange = document.getElementById('showyearrange');
    noUiSlider.create(slider, {
        start: yearAr,
        connect: true,
        range: {
            'min': 1970,
            'max': new Date().getFullYear() + 1
        },
        step: 1
    });
    updateYearRange();
    slider.noUiSlider.on('update.one', updateYearRange);
    $('#lugar').change(function () {
        console.log($('#lugar').val())
    });
});
