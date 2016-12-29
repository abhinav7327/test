//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
$('#pwdChngPopup').click(function(e){
	e.preventDefault();
	xenos$Handler$default.generic(e, {
        requestUri: xenos.context.path + '/changePassword/initPopup',
        requestType: xenos$Handler$default.requestType.asynchronous,
        onHtmlContent: function(e, options, $target, content) {
        	window.pwdChangeDialog = $(content);
        	pwdChangeDialog.dialog({
                title: xenos.i18n.title["passwordChange"],
                closeOnEscape: true,
                draggable: true,
                resizable:false,
                show: 'fade',
                hide: 'fade',
                width: '330',
                height: '250',
                modal:true,
                open: function() {
                    //Resetting z-index to it's default, so that the menu is not visible when preference dialogue is opened.
                    $('#xenosMenuContainer,#personalise').css('zIndex', 1000);
					setTopMost();
					var container = $('.ui-dialog.topMost .ui-dialog-buttonpane');
					pwdChangeDialog.find('#pwdChangePopupForm').find('#passwordcurrent').focus();
                    pwdChangeDialog.keypress(function(e){
						if ((e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)) {
							e.preventDefault();
							if( $('.popSubmitBtn',container).is(':visible') ) {
								$('.ui-dialog.topMost .ui-dialog-buttonpane .popSubmitBtn').click();
							}
						}
					});
                },
				buttons: [
					{
						text: xenos.i18n.confirmlabel['updateButton'],
						'class': "popSubmitBtn",
						click: updatePwdHandler	
					}
				]
            });
			
			function updatePwdHandler(e) {
				e.preventDefault();
				var $form = pwdChangeDialog.find('#pwdChangePopupForm');
				var validationMessages = [];
				var currentPass = $form.find('#passwordcurrent').val();
				var newPass = $form.find('#passwordnew').val();
				var conPass = $form.find('#passwordre').val();
				if ($.trim(currentPass) === "") {
					validationMessages.push(xenos.i18n.changePassword["missing_current_pass"]);	
				}
				if ($.trim(newPass) === "") {
					validationMessages.push(xenos.i18n.changePassword["missing_new_pass"]);
				}
				if($.trim(conPass) === "" ) {
					validationMessages.push(xenos.i18n.changePassword["missing_con_pass"]);
				}
				if($.trim(currentPass) !== "" && $.trim(newPass) !== "") {
					if($.trim(newPass) === $.trim(currentPass)) {
						validationMessages.push(xenos.i18n.changePassword["current_pass_equal_new_pass"]);
					}
				}
				if($.trim(newPass) !== "" && $.trim(conPass) !== "") {
					if($.trim(newPass) !== $.trim(conPass)) {
						validationMessages.push(xenos.i18n.changePassword["con_pass_equal_new_pass"]);
					}
				}
				if( validationMessages.length > 0) {
					xenos.postNotice(xenos.notice.type.error, validationMessages);
					return false;
				}				
				xenos$Handler$default.generic(undefined, {
					requestUri: xenos.context.path + '/changePassword/updatePwd.json',
					requestType: xenos$Handler$default.requestType.asynchronous,
					contentType : 'json',
					settings: {
								beforeSend: function(request) {
										request.setRequestHeader('Accept', 'application/json;type=ajax');
								},
								data : $form.serialize(),
								type : 'POST'
					},					
					onJsonContent: function(e, options, $target, content) {
							if(!content.success) {
								xenos.postNotice(xenos.notice.type.error, content.value[0]);
							} else {
								pwdChangeDialog.dialog('close');
								pwdChangeDialog.dialog('dispose');
								$('#dashboard').before('<div class="xenos-overlay"></div>');
								jAlert(xenos.i18n.changePassword["password_update"], null, function() {									
									window.location.assign(xenos.context.path + "/resources/j_spring_security_logout", '_self');
								});
							}
							
					}
					});
			} 
			}
        
	});
});