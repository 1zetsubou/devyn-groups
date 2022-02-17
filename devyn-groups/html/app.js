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
    } else if (action == "group-create") {
        createGroup(data.groupID, data.name);
    }
});


// KEY AND CLICK EVENTS

$(document).on('click', '.btn-menu', function(e){
    e.preventDefault();
    $(".groups-"+currentMenu).fadeOut(0);
    $(".groups-main").fadeIn(200);
    currentMenu = "main";
});

$(document).on('click', '.btn-requests', function(e){
    e.preventDefault();
    $(".groups-"+currentMenu).fadeOut(0);
    $(".groups-requests").fadeIn(200);
    currentMenu = "requests";
});

$(document).on('click', '.btn-create', function(e){
    e.preventDefault();
    $(".groups-"+currentMenu).fadeOut(0);
    $(".groups-group").fadeIn(200);
    currentMenu = "group";
    $.post('https://devyn-groups/group-create')
});

$(document).on('click', '.btn-join', function(e){
    e.preventDefault();
    $(".groups-"+currentMenu).fadeOut(0);
    getActiveGroups();
});

$(document).on('click', '.group-name', async function(e){
    e.preventDefault();

    let result = await $.post('https://devyn-groups/request-join', JSON.stringify({groupID : $(this).data('groupID') }));
    if (result) {
        // handle UI
        console.log("requested to join group");
    } else {
        console.log("Cannot join group");
    }
});

$(document).on('click', '.btn-requests', async function(e) {
    let result = await $.post('https://devyn-groups/view-requests', JSON.stringify({groupID : $(this).data('groupID') }));

    console.log(JSON.stringify(result));

    $.each(result, function(index, value) {
      let ele = `<div class="row group-row">
                    <div>
                        <i class="fa-solid fa-user"></i><p class="group-request-name">${value.name}</p>
                        <button type="button" class="btn btn-primary">Accept</button>
                        <button type="button" class="btn btn-danger">Deny</button>
                    </div>
                </div>`;
        $('.request-content').append(ele);
        $('.group-'+value.id).data('groupID', value.id);
    });

    $(".groups-"+currentMenu).fadeOut(0);
    $(".groups-requests").fadeIn(200);
    currentMenu = "requests";
});

document.onkeyup = function (event) {
    event = event || window.event;
    if (event.key == "Escape") {
        $(".groups-container").fadeOut(500);
        $.post('https://devyn-groups/close'); 
    }
};


// FUNCTIONS

function createGroup(groupID, name) {
    console.log(groupID + " " + name);
    let ele = `<div class="row group-row"><div><i class="fa-solid fa-user-shield"></i>${name}</div></div>`;
    $('.group-content').append(ele);
    $('.group-content').data('groupID', groupID);

    $(".groups-"+currentMenu).fadeOut(0);
    $(".groups-group").fadeIn(200);

    $(".req-btn").fadeIn(200);

}


async function getActiveGroups() {
    let result = await $.post('https://devyn-groups/getActiveGroups');

    console.log(JSON.stringify(result));

    $.each(result, function(index, value) {
      let ele = `<div class="row group-row group-${value.id} group-name"><div><i class="fa-solid fa-user"></i> ${value.name}</div></div>`;
        $('.list-content').append(ele);
        $('.group-'+value.id).data('groupID', value.id);
    });
    $(".groups-list").fadeIn(200);
    currentMenu = "list";
}

function joinGroup(groupID) {

}