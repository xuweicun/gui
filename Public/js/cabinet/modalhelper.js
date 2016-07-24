
function ModalHelper() {
    this.id = 0;
    this.type = 'info';
    this.title = 'Modal Default';
    this.html = '<h1>Modal Uninitialized</h1>';
    this.on_click_handle = function (param) { };
    this.on_click_param = undefined;
    this.on_click_target = undefined;
    this.on_click_close = true;
}

ModalHelper.prototype = {
    get_curr_id: function(){ return this.id; },
    show_modal: function (cfg) {
        if (cfg) {
            this.type = cfg.type;
            this.title = cfg.title;
            this.html = cfg.html;
            this.on_click_handle = cfg.on_click_handle;
            this.on_click_param = cfg.on_click_param;
            this.on_click_target = cfg.on_click_target;
            if (cfg.on_click_close != undefined) {
                this.on_click_close = cfg.on_click_close;
            }
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

        this.id++;

	return this.id;
    },

    on_click: function () {
        // 判断handle中是否又弹出了模态框
        var last_id = this.id;

        if (this.on_click_target) {
            this.on_click_target[this.on_click_handle](this.on_click_param);
        }
        else if (this.on_click_handle) {
            this.on_click_handle(this.on_click_param);
        }

        // handle中没有弹出模态框时才进入
        if (last_id == this.id && this.on_click_close) {
            $.magnificPopup.close();
        }
    },

    on_click_ok: function(){
        if (this.type == 'question') return;

        if (this.on_click_target) {
            this.on_click_target[this.on_click_handle](this.on_click_param);
        }
        else if (this.on_click_handle) {
            this.on_click_handle(this.on_click_param);
        }
    },

    show_modal_working: function () {
        this.show_modal({
            type: 'warning',
            title: '功能完善',
            html: '老板们 <i class="fa fa-users"></i> 不要着急，攻城狮 <i class="glyphicon glyphicon-user bk-fg-success"></i> 和攻城狮 <i class="fa fa-user bk-fg-danger"></i> 正在努力Coding，完善功能。'
        });
    },

    show_modal_user: function (id) {
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

        this.id++;

	    return this.id;
    },

    close_modal: function(modal_id){
	    if (this.id == modal_id){
	        $.magnificPopup.close();
	    }
    }
};
