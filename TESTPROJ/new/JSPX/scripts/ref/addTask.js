//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
$(function () {
	$.fn.addTask = function(options){
		return this.each( function() {
			var self = $(this);
			var dateFormat = null;
			var defaultValue = null;
			if (xenos$Cache.get('globalPrefs')) {
				dateFormat = xenos$Cache.get('globalPrefs')['mappedUiDisplayDateFormat'];
				defaultValue = $.datepicker.formatDate(dateFormat,$('div#footer>div#xenos-cache-container>span#cache').data('refApplicationDate'));
				$('.taskdueDate',self).val(defaultValue);
				$('.taskdueDate',self).focus(function(){
						if ($.trim($('.taskdueDate',self).val()) == defaultValue) $('.taskdueDate',self).val('');
					});
				$('.taskdueDate',self).blur(function(){
						if ($.trim($('.taskdueDate',self).val()) == '') $('.taskdueDate',self).val(defaultValue);
				});
			}
		    var defaultValueUser = $('#asignee',self).val();
			$('#asignee',self).val(defaultValueUser);
			$('#asignee',self).focus(function(){
					if ($.trim($('#asignee',self).val()) == defaultValueUser) $('#asignee',self).val('');
				});
			$('#asignee',self).blur(function(){
					if ($.trim($('#asignee',self).val()) == '') $('#asignee',self).val(defaultValueUser);
			});
			
			var $dateInput = $('.dateinput',self);
			$dateInput.datepicker({
				buttonImage: xenos.context.path + '/images/namrui/icon/calendarIco.png',
				buttonText:'',
				constrainInput: false,
				buttonImageOnly: true,
				dateFormat: dateFormat,
				showOn: 'button',
				beforeShow: function(input, inst) { $(document).unbind('mouseup', $('#taskDialog',self).data('closeFn')); },
				onClose: function(dateText, inst) { 
							$(document).bind('mouseup', $('#taskDialog',self).data('closeFn'));
						}
			});
			var $document = $(document);
			$document.off('xenos-preferences-synced');
			$document.on('xenos-preferences-synced', function(e) {
				if (e.key == 'globalPrefs') {
					var cached = xenos$Cache.get('globalPrefs');
					var dateFormat = cached['mappedUiDisplayDateFormat'];
					$dateInput.datepicker('option', 'dateFormat', dateFormat);
				}
			});
			$('.numaricroutinetask').ForceNumericOnly();
			$('.routinetask',self).hide();
			$('.taskcheckboxitem',self).bind('click', function(e){
					if($(this).is(':checked') == true){
						$('.normaltask',self).hide();
						$('.routinetask',self).show();
					}else{
						$('.normaltask',self).show();
						$('.routinetask',self).hide();
					}
			  
			});
			
			function displayError(err){
				xenos.postNotice(xenos.notice.type.error, err);
			}
			
			xenos.loadScript([{path: xenos.context.path + '/scripts/xenos-autocomplete.js'}], {
				success: function() {
					$('#asignee',self).xenosautocomplete({
						requestContext: {
											type: 'EmployeeTypeAhead'
										},
						delay: 400,
						appendTo: $('div#footer>div#autocompletecontainer'),
						open: function(){
							$(document).unbind('mouseup', $('#taskDialog',self).data('closeFn'));
						},
						close: function() {
							$(document).bind('mouseup', $('#taskDialog',self).data('closeFn'));
								},
						showError: function(err) {
							displayError(err);
						}
					});
				}
			});
			$('#taskAddBtnHolder',self).bind('click', function(e){
			var taskName = $('.formInput',self).first().attr('value');
			if(taskName == ''){
				displayError(xenos$DBD$i18n.taskvalidation.missing_taskname);
				return false;
			}
			if($('.taskcheckboxitem',self).is(':checked') == true && $('#taskDuration',self).val() == ''){
				displayError(xenos$DBD$i18n.taskvalidation.invalid_taskduration);
				return false;
			}
			
			e.preventDefault();
			var btn = $(e.target);
			btn.attr('disabled', true);
			var form = $('#addTaskForm',self);
			
			$.ajax({
            type: "POST",
            url: form.attr('action'),
            data: form.serialize(),
            beforeSend: function(req) {
                req.setRequestHeader("Accept", "text/html;type=ajax");
            },  
            complete : function(jqXHR) {
				btn.removeAttr('disabled');
				var msgString = '';
				if($(jqXHR.responseText).find('#errorMsg').text() != '[]'){
					msgString = $(jqXHR.responseText).find('#errorMsg').text();
					displayError(msgString);
				} else {
					$('#msgIcon').removeClass('addTaskErrorIco').addClass('successMsg');
					msgString = xenos.utils.evaluateMessage(xenos$DBD$i18n.taskvalidation.task_add_success,[taskName]);
					$('.errorIcon').hide();
					$('.formInput').each( function(){
						$(this).attr('value','');
					});
					$('.taskcheckboxitem',self).attr('checked',false);
					$('.taskcheckboxitem',self).trigger('click');
					// this call is required to set checked = false after calling click handler
					$('.taskcheckboxitem',self).attr('checked',false);
					xenos.postNotice(xenos.notice.type.info, msgString);
					$('.taskdueDate',self).val(defaultValue||"");
					$('#asignee',self).val(defaultValueUser);
				}
			}
        });
		});
		// modified for add task pop up background color problem
		if('#addTaskContainer','#taskDialog',self){
			$('.ui-dialog .ui-widget-content',self).css('background','#f3f3f3');
		}
		});
	}
}(jQuery));
