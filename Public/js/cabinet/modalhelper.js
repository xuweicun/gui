
function ModalHelper() {
    this.type = 'info';
    this.title = 'Modal Default';
    this.html = '<h1>Modal Uninitialized</h1>';
    this.on_click_handle = function (param) { };
    this.on_click_param = undefined;
    this.on_click_target = undefined;
}

ModalHelper.prototype = {
    show_modal: function (cfg) {
        if (cfg) {
            this.type = cfg.type;
            this.title = cfg.title;
            this.html = cfg.html;
            this.on_click_handle = cfg.on_click_handle;
            this.on_click_param = cfg.on_click_param;
            this.on_click_target = cfg.on_click_target;
        }
        
        $.magnificPopup.open({
            items: {
                src: '#modalTemplate', // can be a HTML string, jQuery object, or CSS selector
                type: 'inline'
            },
            closeOnBgClick: false,
            removalDelay: 300,
            mainClass: 'my-mfp-slide-bottom',
            modal: true
        });
    },
    on_click: function () {
        if (this.on_click_target) {
            this.on_click_target[this.on_click_handle](this.on_click_param);
        }
        else {
            this.on_click_handle(this.on_click_param);
        }

        $.magnificPopup.close();
    },
    show_modal_working: function () {
        this.show_modal({
            type: 'warning',
            title: '写保护功能',
            html: '老板们 <i class="fa fa-users"></i> 不要着急，攻城狮 <i class="glyphicon glyphicon-user bk-fg-success"></i> 和攻城狮 <i class="fa fa-user bk-fg-danger"></i> 正在努力Coding，完善功能。'
        });
    },
    show_modal_user: function(id){
        $.magnificPopup.open({
            items: {
                src: '#' + id, // can be a HTML string, jQuery object, or CSS selector
                type: 'inline'
            },
            closeOnBgClick: false,
            removalDelay: 300,
            mainClass: 'my-mfp-slide-bottom',
            modal: true
        });
    }
};