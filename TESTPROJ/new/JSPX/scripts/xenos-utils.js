//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos.utils = {
	encodeValue: function(value) {
		var val = JSON.stringify(value);
		return val;
	},
	decodeValue: function (value) {
		if(value == "")return null;
		var val = JSON.parse($.trim(value));
		return  val;
	},
	evaluateMessage : function(message, arguments) {
		var result = message || "";
		if(message){
			if(arguments && arguments instanceof Array){
				for (indx in arguments){
					result = result.replace('{'+indx+'}', escape(arguments[indx]));
				}
			}
		}
		return unescape(result);
	},
	getErrorMessage : function(form){
		var msg = [];
		$.each(form.find('ul.xenosError li'), function(index, value) { 
			msg.push($(value).text())
		});
		return msg;
	},
	getWarningMessage : function(form){
		var msg = [];
		$.each(form.find('ul.xenosWarn li'), function(index, value) { 
			msg.push($(value).text())
		});
		return msg;
	},
	clearGrowlMessage : function (){
		$('.formHeader').find('.formTabErrorIco').css('display', 'none');
		$.each($('#growlDock .growlBox'),function(ind,el){
			$(el).find('#growlBoxClose').trigger('click');
		});
	},
	
	clearWarningGrowlMessage : function (){
		$('.formHeader').find('.formTabWarningIco').css('display', 'none');
		$.each($('#growlDock .growlBox'),function(ind,el){
			$(el).find('#growlBoxClose').trigger('click');
		});
	},
	
	displayGrowlMessage : function(type, messages){
		xenos.utils.clearGrowlMessage();
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(type || xenos.notice.type.error, messages, true));
	},
	
	displayWarningGrowlMessage : function(type, messages){
		xenos.utils.clearWarningGrowlMessage();
		$('.formHeader').find('.formTabWarningIco').show().off('click');
		$('.formHeader').find('.formTabWarningIco').on('click', xenos.postNotice(type || xenos.notice.type.warning, messages, true));
	},
	
	savePreference:function (prefDetails,url,screenId,version,callback) {
		$.ajax({
			url: url,
			type: "POST",
			data:{
				preferenceDetails: prefDetails,
				screenId: screenId,
				version:version
			},
			success:callback,
			error:function(){
				xenos.postNotice('error', xenos.i18n.message.preference_save_error);
			}
		});
	},
	removePreference:function(url,screenId,version,callback) {
		$.ajax({
			url: url,
			type: "POST",
			data:{
				screenId: screenId,
				version:version
			},
			success:callback,
			error:function(){
				xenos.postNotice('error', xenos.i18n.message.preference_reset_error);
			}
						});
	},
	
    saveResultPreference:function (columns,url,screenId,version,callback) {
		var updatedColumns = [];
		 for( var i=0; i < columns.pref.length; i++ ) {
			var obj = {};
			obj.id = columns.pref[i].id;
			obj.width = columns.pref[i].width;
			obj.originalWidth = columns.pref[i].actualWidth;
			updatedColumns.push(obj);
		 }
		 var pref = {};
		 pref.forceFitColumns = columns.forceFitColumns;
		 pref.syncColumnCellResize = columns.syncColumnCellResize;
		 pref.pref = updatedColumns;
		 
		$.ajax({
			url: url + '&screenId=' + screenId + '&version=1.2',
			contentType: "application/json; charset=utf-8",
			type: "POST",
			data: JSON.stringify(pref),
			success:callback,
			error:function(){
				xenos.postNotice('error', xenos.i18n.message.preference_save_error);
			}
		});
	},
	/* Shortcuts allowed within form fields
	 * Call to this function is made from queryForm.js, after the form has finished rendering.
	 */
	afterFormRenderScuts : function(){
		$('.formContent .dateinput , .formContent .dynamicUIComp').bind('keypress',function(evt){
            if(evt.which === 13){
                evt.preventDefault();
            }
			if(evt.which === 59){
				$(this).val('$appDate');
				return false;
			}
		});
	},
	gridCounter:0,
	
	// extract params from a given query string like,
	// param1=value1&param2=value2...
	// param extraction is like {param1 : value1, param2 : value2 .. }
	// it returns prpeared JSON
	// instaed of using String API we can do simply using chararter iteration
	// it provides better complexity for large querystring
	extractParameters: function(request_data) {
		// default request data, it's required when result page
		// shown in detail dialog without menu(s)
		// copy settings.data from original
		var JSON = $.extend(true, {}, xenos$Handler$asynchronous$popup.settings.data);
		if(typeof request_data === 'undefined') {
			return JSON;
		} else {
			if($.type(request_data) != "string") {
				// other than string treated as JSON
				// it's responsibility of developers to pass right one
				if(typeof request_data.fragments === 'undefined') {
					// in case of fragments missed for POST request data
					request_data.fragments = "content";
				}
				// copy from original
				return $.extend(true, request_data, JSON);
			}
		}
		var query_string = request_data;
		while(true) {
			var eq = query_string.indexOf("=");
			if(eq == -1) {
				break;
			} else {
				var p = query_string.substring(0, eq);
				query_string = query_string.substring(eq + 1);
				var amp = query_string.indexOf("&");
				var v;
				if(amp != -1) {
					v = query_string.substring(0, amp);
					query_string = query_string.substring(amp + 1);
					JSON[p] = v;
				} else {
					v = query_string.substring(0);
					JSON[p] = v;
					break;
				}
			}
		}
		
		return JSON;
	},
	
	defaultPrintOption : {
		mode:"popup", 
		popClose: true, 
		popHt: 600, 
		popWd: 600
	},
    getMaxZ: function(){
        //Calculating the Maximum z-index amond Dialogue, Notification & Add Feed Popup.
        var topMostDialogEl = $('.topMost'),
            growlBoxEl = $('#growlDock'),
            addFeedPopupEl = $('.contentArea'),
            dialogMaxZ = topMostDialogEl.length ? topMostDialogEl.css('z-index') : 0,
            growlMaxZ = growlBoxEl.length ? growlBoxEl.css('z-index') : 0,
            addFeedPopupElMaxZ = addFeedPopupEl.length ? addFeedPopupEl.css('z-index') : 0;
        return Math.max(dialogMaxZ,growlMaxZ,addFeedPopupElMaxZ);
    },
	escapeHtml : function(str){
		if(typeof str !== 'string'){
			return str;
		}
		var result = (str||"").replace(/["'<>&\n\/]/g, function(x) {
			return {
				'"': '&quot;',
				'<': '&lt;',
				'>': '&gt;',
				'&': '&amp;',
			   '\n': '<br />',
			   "'": '&#39;',
			   "/": '&#x2F;'
			}[x];
		});
		return result;
	},
	evaluateToXml : function(value){
		return $('<div/>').html($.trim(value)).text();
	},
	maxZIndex : function(){
		// Maximum z-index in the body.
		var zIndex1 = Math.max.apply(null, $.map($('body > *'), function(e, n) {
								if ($(e).css('position') != 'static')
									return $(e).zIndex() || 0;
								}
							));
		// z-index of the right dock menu.
		var zIndex2 = $('.rightDockMenu').zIndex() || 0;
		// Return the maximum.
        return Math.max(zIndex1, zIndex2);
	},
	findLoadLocalizedScriptFromUrl : function(baseUrl){
		var scripts = [];
		if($.trim(baseUrl)== ""){
			return scripts;
		}
		baseUrl = baseUrl = baseUrl.replace(/^(\/secure\/|secure\/)|^\/|\/$/g, '');
		var module = baseUrl.split("/")[0];
		if($.trim(module)== ""){
			return scripts;
		}
		scripts.push({path: xenos.context.path + '/scripts/inf/xenos-i18n', async: false});
		switch(module) {
			case 'ref':
			  scripts.push({path: xenos.context.path + '/scripts/ref/xenos-ref-i18n.js', async: false});
			  break;
			case 'cam':
			  scripts.push({path: xenos.context.path + '/scripts/cam/xenos-cam-i18n.js', async: false});
			  break;
			case 'stl':
			  scripts.push({path: xenos.context.path + '/scripts/stl/xenos-stl-i18n.js', async: false});
			  break;
			case 'trd':
			  scripts.push({path: xenos.context.path + '/scripts/trd/xenos-trd-i18n.js', async: false});
			  break;
			case 'gle':
			  scripts.push({path: xenos.context.path + '/scripts/gle/xenos-gle-i18n.js', async: false});
			  break;
			case 'srs':
			  scripts.push({path: xenos.context.path + '/scripts/srs/xenos-srs-i18n.js', async: false});
			  break;
			case 'cax':
			  scripts.push({path: xenos.context.path + '/scripts/cax/xenos-cax-i18n.js', async: false});
			  break;
			case 'slr':
			  scripts.push({path: xenos.context.path + '/scripts/slr/xenos-slr-i18n.js', async: false});
			  break;
			case 'gwy':
			  scripts.push({path: xenos.context.path + '/scripts/gwy/xenos-gwy-i18n.js', async: false});
			  break;  
			case 'ncm':
			  scripts.push({path: xenos.context.path + '/scripts/ncm/xenos-ncm-i18n.js', async: false});
			  break;
			case 'exm':
			  scripts.push({path: xenos.context.path + '/scripts/exm/xenos/xenos-exm-i18n.js', async: false});
			  break;
			case 'drv':
			  scripts.push({path: xenos.context.path + '/scripts/drv/xenos-drv-i18n.js', async: false});
			  break;
			default:
		}
		return scripts;
	}
};