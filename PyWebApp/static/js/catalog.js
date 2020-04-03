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
    slider = document.getElementById('yearslider');
    yearRange = document.getElementById('showyearrange');
    noUiSlider.create(slider, {
        start: [1970, new Date().getFullYear() + 1],
        connect: true,
        range: {
            'min': 1970,
            'max': new Date().getFullYear() + 1
        },
        step: 1
    });
    updateYearRange();
    slider.noUiSlider.on('update.one', updateYearRange);
});
