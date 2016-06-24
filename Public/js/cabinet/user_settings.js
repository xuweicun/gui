function Check_t() {
    this.unit = 'week';
    this.cnt = 1;
    this.start_data = Date();
    this.start_time = Date();
}

function UserSettings(settings) {
    this.inited = false;

    this.md5 = new Check_t();
    this.smart = new Check_t();
}

UserSettings.prototype = {
    show_modal: function ()
    {
        $('[data-plugin-datepicker]').each(function () {
            console.log('test');
            var $this = $(this),
                opts = {};

            var pluginOptions = $this.data('plugin-options');
            if (pluginOptions)
                opts = pluginOptions;

            $this.datepicker(opts);
        });

        global_modal_helper.show_modal_user('modalSettingMD5');
        console.log('test');
    }
}