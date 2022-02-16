let currentMenu = "main";
window.addEventListener("message", function(event) {
    const data = event.data;
    const action = data.action;

    if (action == "open") {
        if (data.menu == "main") {
            currentMenu = "main";
            $(".groups-main").fadeIn(5);
        } else if (data.menu == "list") {
            $(".groups-list").fadeIn(5);
            currentMenu = "list";
        } else if (data.menu == "group") {
            $(".groups-group").fadeIn(5);
            currentMenu = "group";
        }
        $(".groups-container").fadeIn(500);
    }
});

$(document).on('click', '.btn-menu', function(e){
    e.preventDefault();
    $(".groups-"+currentMenu).fadeOut(0);
    $(".groups-main").fadeIn(200);
    currentMenu = "main";
});

$(document).on('click', '.btn-create', function(e){
    e.preventDefault();
    $(".groups-"+currentMenu).fadeOut(0);
    $(".groups-group").fadeIn(200);
    currentMenu = "group";
});

$(document).on('click', '.btn-join', function(e){
    e.preventDefault();
    $(".groups-"+currentMenu).fadeOut(0);
    $(".groups-list").fadeIn(200);
    currentMenu = "list";
});

document.onkeyup = function (event) {
    event = event || window.event;
    if (event.key == "Escape") {
        $(".groups-container").fadeOut(500);
        $.post('https://devyn-groups/close'); 
    }
};