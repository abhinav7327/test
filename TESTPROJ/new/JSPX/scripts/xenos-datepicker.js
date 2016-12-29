//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
/**
****************************************
* xenos Datepicker Plugin
*****************************************
**/
(function ($) {
    $.fn.xenosdatepicker = function () {
		var dateFormat;
		if (xenos$Cache.get('globalPrefs')) {
			dateFormat = xenos$Cache.get('globalPrefs')['mappedUiDisplayDateFormat'];
		}
		var container = this;
		container.datepicker({
			buttonImage: xenos.context.path + '/images/namrui/icon/calendarIco.png',
			constrainInput: false,
			buttonText:'',
			dateFormat: dateFormat,
			showOn: 'button'
		});
		var $document = $(document);
		$document.off('xenos-preferences-synced');
		$document.on('xenos-preferences-synced', function(e,type) {
			if (type.key == 'globalPrefs') {
				var cached = xenos$Cache.get('globalPrefs');
				var dateFormat = cached['mappedUiDisplayDateFormat'];
				$.datepicker.setDefaults({
					dateFormat: dateFormat
				});
			}
		});
	}
}(jQuery));