const { ref, onBeforeUnmount } = Vue


const groups = {
    data() {
        return {
            mainMenuShow: false,
            listShow: false,
            groupShow: false,
            requestShow: false,
            isInGroup: false,
            isGroupLeader: false,
            GroupMembers: [],
            GroupTasks: [],
            CurrentTask: "None",
            GroupID : 0,
            GroupList: [],
            GroupRequests: [],
        };
    },
    setup () {
        return {
        }
    },
    methods: {
        CreateGroup: async function(event) {
            let result = await $.post('https://devyn-groups/group-create');
            if (result != false) {
                this.HideMenus()
                this.isInGroup = true
                this.isGroupLeader = true
                this.GroupMembers.push(result)
                this.GroupID = result.groupID
                this.groupShow = true 
            } else {
                console.log("Unable to create group");
            }
        },
        AvailableGroups: async function(event) {
            this.HideMenus()
            let temp = []
            let result = await $.post('https://devyn-groups/getActiveGroups');
            $.each(result, function(index, value) {
                temp.push(value)
            });
            this.GroupList = temp
            this.listShow = true
        },
        RequestJoin: async function(id) {
            let result = await $.post('https://devyn-groups/request-join', JSON.stringify({groupID : id }));
            if (result) {
                console.log("success")
            } else {
                console.log("fail")
            }
        },
        LeaveGroup: function(event) {
            if (this.isInGroup) {
                this.HideMenus()
                this.mainMenuShow = true
                this.isInGroup = false
                if (this.isGroupLeader) {
                    this.isGroupLeader = false
                    $.post('https://devyn-groups/group-destroy');
                    
                } else {
                    $.post('https://devyn-groups/group-leave');
                }
                this.GroupCleanup()
            }
        },
        MainMenu: function(event) {
            this.HideMenus()
            this.mainMenuShow = true
        },
        ViewGroup: function(event) {
            this.HideMenus()
            this.groupShow = true
        },
        ViewRequests: async function(event) {
            
            this.HideMenus()
            let temp = []
            let result = await $.post('https://devyn-groups/view-requests', JSON.stringify({groupID : this.GroupID }));
            $.each(result, function(index, value) {
                temp.push(value)
            });
            this.GroupRequests = temp
            this.requestShow = true
        },
        RequestAccept: function(v, id) {
            this.GroupRequests.splice(v, 1);
            $.post('https://devyn-groups/request-accept', JSON.stringify({player : id, groupID : this.GroupID}));
        },
        RequestDeny: function(v, id) {
            this.GroupRequests.splice(v, 1);
            $.post('https://devyn-groups/request-deny', JSON.stringify({player : id, groupID : this.GroupID}));
        },
        MemberKick: function(v, id) {
            this.GroupMembers.splice(v, 1);
            $.post('https://devyn-groups/member-kick', JSON.stringify({player : id, groupID : this.GroupID}));
        },
        HideMenus: function() {
            this.mainMenuShow = false
            this.listShow = false
            this.groupShow = false
            this.requestShow = false
        },
        OpenMenu: function(data) {
            if (!this.isInGroup) {
                this.HideMenus()
                this.mainMenuShow = true
            } else {
                this.HideMenus()

                this.groupShow = true
            }
            $(".groups-container").fadeIn(150);
        },
        GetActiveGroups: async function() {

        },
        JoinGroup: function(event) {

        },
        UpdateGroup: function(data, type) {
            if (type == "join") {
                this.HideMenus()
                this.isInGroup = true
                this.groupShow = true
            } else if (type === "leave") {

            } else if (type === "setTask") {
                this.CurrentTask = data.task
            } else if (type === "groupDestroy") {
                this.HideMenus()
                this.isInGroup = false
                this.isGroupLeader = false 
                this.GroupCleanup()
            } else if (type === "update") {
                this.GroupMembers = []
                let temp = []
                $.each(data, function(index, value) {
                    temp.push(value)
                });
                this.GroupMembers = temp
            }
        },
        GroupCleanup: function() {
            this.GroupMembers = []
            this.GroupTasks = []
            this.CurrentTask = "None"
            $.post('https://devyn-groups/group-cleanup');
        },
    },
    destroyed() {
        window.removeEventListener("message", this.listener);
    },
    mounted() {
        this.listener = window.addEventListener("message", (event) => {
            if (event.data.action === "open") {
                this.OpenMenu(event.data);
            } else if (event.data.action === "update") {
                this.UpdateGroup(event.data.data, event.data.type);
            }
        });
    },
}

const app = Vue.createApp(groups);
app.use(Quasar);
app.mount(".groups-container");

document.onkeyup = function (data) {
    if (data.key == 'Escape') {
        closeMenu()
    } 
};
  
function closeMenu() {
    $(".groups-container").fadeOut(150);
    $.post('https://devyn-groups/close');
}
