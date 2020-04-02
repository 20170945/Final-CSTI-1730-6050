var pageContainer;

$(document).ready(function () {
    pageContainer = document.getElementById("page-container");
    pageContainer.style.paddingBottom = ($("#footer").height())+'px';
    console.log(pageContainer.style.paddingBottom);
    document.body.onresize = function() {
        pageContainer.style.paddingBottom = ($("#footer").height())+'px';
    };
});