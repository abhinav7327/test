//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
//
// xenos
//  - Preferences
//


if (typeof xenos$Preferences$plugin === 'undefined') {

    // define xenos Preferences plugin
    window.xenos$Preferences$plugin = function() {
        // preferences plugin
        var plugin = {
            name: 'xenos$Preferences',
            event: {
                prefix: 'xenos$Preferences'
            },

            init: function() {
                var uri = xenos.context.path + '/secure/ref/personalized/user/globalprefs/load.json';
                jQuery.getJSON(uri, function(json) {
                    if (!json.success) {
                        console.log(json);
                        return;
                    }

                    // populate the cache
                    jQuery.each(json, function(key, value) {
                        xenos$Cache.put(key, value);
                    });

                    // fixed date format
                    var cached = xenos$Cache.get('globalPrefs');
                    cached['mappedUiDisplayDateFormat'] = xenos$Preferences$plugin.mappedDateFormat(cached['displayDateFormat']);
                    cached['mappedUiEntryDateFormat'] = xenos$Preferences$plugin.mappedDateFormat(cached['entryDateFormat']);

                    // trigger event
                    var _function = function() {
                      xenos$Event.trigger('xenos-preferences-synced', {key: 'globalPrefs'});
                    };
                    setTimeout(_function, 0);
                });
            },

            // functions
            sync: function(serializeArray) {
                var cached = xenos$Cache.get('globalPrefs');

                jQuery.each(serializeArray, function(index, object) {
                    cached[object.name] = object.value;
                });

                // fixed date format
                cached['mappedUiDisplayDateFormat'] = xenos$Preferences$plugin.mappedDateFormat(cached['displayDateFormat']);
                cached['mappedUiEntryDateFormat'] = xenos$Preferences$plugin.mappedDateFormat(cached['entryDateFormat']);
                // fixed locale
                cached['locale'] = cached['locale'].substr(0, 2);

                // trigger event
                var _function = function() {
                  xenos$Event.trigger('xenos-preferences-synced', {key: 'globalPrefs'});
                };
                setTimeout(_function, 0);
            },


            // mapped date format
            mappedDateFormat: function(dateFormat) {
			    var mappedFormat = dateFormat;

                if (mappedFormat.indexOf("yyyy") >= 0)
                    mappedFormat = mappedFormat.replace("yyyy","yy");
                if (mappedFormat.indexOf("YYYY") >= 0)
                    mappedFormat = mappedFormat.replace("YYYY","yy");
                if (mappedFormat.indexOf("MMM") >= 0)
                    mappedFormat = mappedFormat.replace("MMM","M");
                if (mappedFormat.indexOf("MM") >= 0)
                    mappedFormat = mappedFormat.replace("MM","mm");
                if (mappedFormat.indexOf("MON") >= 0)
                    mappedFormat = mappedFormat.replace("MON","M");

                return mappedFormat;
            }
        };


        // return
        return plugin;
    }();


    // load the plugin
    xenos.loadPlugin(xenos$Preferences$plugin);


    // trigger event
    xenos$Event.trigger('xenos-preferences-prepared');

window.addEventListener('storage', function (e) {
	if(window.localStorage.getItem('do_refresh')=='true')
    window.top.location.assign(xenos.context.path);
  });

	window.localStorage.clear();
    // attach the handler
    jQuery("#settings").on('click', function(e) {
        xenos$Handler$default.generic(e, {
            requestUri: function(e, options) {
                var uri = jQuery("#settings").attr(xenos$Handler$default.attributes.requestUri);
                return uri + '?' + (new Date().getTime());
            },
            requestType: xenos$Handler$default.requestType.asynchronous,
            onHtmlContent: function(e, options, $target, content) {
                window.preferencesDialog = $(content);
                preferencesDialog.dialog({
                    title: xenos.i18n.title.preferences,
                    closeOnEscape: false,
                    draggable: true,
                    resizable:false,
                    show: 'fade',
                    hide: 'fade',
                    width: '250',
                    height: '200',
                    modal:true,
                    open: function() {
                        //Resetting z-index to it's default, so that the menu is not visible when preference dialogue is opened.
                        $('#xenosMenuContainer,#personalise').css('zIndex', 1000);
                        var _function = function() {
                            preferencesDialog.find('#zebraColorEven').colorPicker();
                            preferencesDialog.find('#zebraColorOdd').colorPicker();
                            preferencesDialog.find('#cxlColorEven').colorPicker();
                            preferencesDialog.find('#cxlColorOdd').colorPicker();
							preferencesDialog.find('#failColorEven').colorPicker();
                            preferencesDialog.find('#failColorOdd').colorPicker();
                        };
                        if (!$.fn.colorPicker) {
                            xenos.loadScript([
                                {path: xenos.context.path + '/scripts/colourpicker.js'}
                            ], {
                                success: _function
                            });
                        } else {
                            _function();
                        }
                    },
					buttons: [
						{
							text: xenos.title.savePreferences,
							'class': "prefSubmit popSubmitBtn",
							click: savePrefHandler,
							keydown: enterHandler
                    }
					]
                });
				function savePrefHandler(e){
					e.preventDefault();
					var $form = preferencesDialog.find('#globalPrefsForm');
					$.ajax({
						type: 'POST',
						url: xenos.context.path + '/secure/ref/personalized/user/globalconfig/save',
						data: $form.serialize(),
						success: function(){
	                              jAlert(xenos.i18n.message.preference_save_message, null, function() {
	                                window.localStorage.setItem('do_refresh', true);    
									window.top.location.assign(xenos.context.path);
	                                });
	                            }
					}).always(function() {
						preferencesDialog.dialog('close');
						preferencesDialog.dialog('dispose');
					}).done(function() {
						xenos$Preferences$plugin.sync($form.serializeArray());
					});
				}
				function enterHandler(e){
					if(e.keyCode==13){
						savePrefHandler(e);
					}
				}
            }
        });
    });
}
