//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
$(document).ready(function () {
		xenos.ns.otherPopupHandler = function openPopUpForm(e,settings) {
		var tag = $('<div></div>'); //This tag will the hold the dialog content.		
		var defaultSize = {
			width : 750,
			height : 250
		 };
		var defaultTitle = xenos.title.generalPopup;
		var targetFieldId = [];
		var url,extUrlParams="";
		var reqData = {};
		var btn = $(e.target).is('input')?$(e.target):$(e.target).find('input');
		var typeOfPopup = settings.typeOfPopup?settings.typeOfPopup:'General';
		
		
		var hiddenTargetFieldId = [];
		var isGridable = settings.isGrid?settings.isGrid:false;
		
		
		if(typeOfPopup =='General')
		{
			
			targetFieldId = btn.attr("tgt")?btn.attr("tgt").split(","):"";
			var hiddenTgt = btn.attr("hiddenTgt");
			if (typeof hiddenTgt !== 'undefined' && hiddenTgt !== false) {
				hiddenTargetFieldId = hiddenTgt.split(",");
			}
			defaultTitle = settings.title?settings.title:defaultTitle;
			url = settings.requestUrl;	
			//If the programmer does not give url in the jspx page
			if(typeof url === "undefined")
			{
				jAlert("Settings url is not given","error");
				//xenos.postNotice(xenos.notice.type.error, "Please provide url in your jspx page", true)
				return;
			}
			//RequestParam are those which --TODO
			var requestParam = settings.requestParams;
			//dependentparams are those if some pop up is dependent on some other popup/field/value
			//ex. In the wire instruction entry screen cp ssi pop up is dependent on account no
			var params = settings.dependentParams;
			//TODO
			var reqData = settings.reqData;
			var dependentParam;
			if(typeof params != "undefined" || typeof requestParam != "undefined") {
			
				var dependentParams = new Array('');
				var requestParams = new Array('');
				
				dependentParams.push(params);
				requestParams.push(requestParam);
				
				if(requestParams==dependentParams){
				dependentParams=requestParams;
				}
				dependentParam=prepareDependentParams(btn,dependentParams,requestParams);
				
				if(dependentParam == ""){
				btn.removeAttr("disabled");
				return;
				}
			
				if(requestParams == ""){
				btn.removeAttr("disabled");
				return;
			}
		}
			if(typeof dependentParam != "undefined"){
				extUrlParams = dependentParam;
			}
		
	}
		
		 var popupbtns;
		 if(targetFieldId.length == 1){
			popupbtns=	[{
					text: xenos.title.resetBtnLabel,
					'class': "popResetBtn",
					click: resetHandler
				},
				{
					text: xenos.title.submitBtnLabel,
					'class': "popSubmitBtn",
					click: submitHandler
				},
				{
					text: xenos.title.requeryBtnLabel,
					'class': "popRequery",
					click: requeryHandler
				}]
		}else{
			popupbtns = [{
				text: xenos.title.cancelBtnLabel,
				'class': "popResetBtn",
				click: function(){
					tag.dialog('destroy');
					tag.remove();
					var noOfSelectedCheckBox = $('#queryResultForm').find('.slick-cell-checkboxsel.selected').find('input').length;
					for(k=0;k<noOfSelectedCheckBox;k++){
					$('#queryResultForm').find('.slick-cell-checkboxsel.selected').find('input').trigger('click');
					}
					if(!settings.matchFlag){
						btn.removeAttr("disabled");
					}
				}
			}]
		}
		
		var fragmentName = "";
		if(extUrlParams == ""){
			fragmentName = "?fragments=content";
		}else{
			fragmentName = "&fragments=content";
		}
		
		xenos$Handler$default.generic(e,{
			requestUri:xenos.context.path+settings.requestUrl+extUrlParams,
			requestType:xenos$Handler$default.requestType.asynchronous,
			contentType:xenos$Handler$default.contentType.html,
			
		settings: {
				type: 'POST',
				data: settings.requestData?settings.requestData:reqData,
			},
		
		
			 onHtmlContent: function (e, options, $target, content) {
			 
				if(content.indexOf('errorMsg') != -1){
					var msg =[];
					$.each($(content).find('ul.errorMsg li'), function(index,value){
						msg.push($(value).text());
					});
					//xenos.postNotice(xenos.notice.type.error, msg);
					$('div.ui-dialog-titlebar').append('<span class="popupFormTabErrorIco" title="Error message">Error</span>');
					
					  // Default OnReady Handler bounded for .formTabErrorIco
					  $('.popupFormTabErrorIco').die();					  
					  $('.popupFormTabErrorIco').live('click', xenos.postNotice(xenos.notice.type.error, msg, true));
					  
				}
				
					tag.append(content);
					tag.dialog({title : settings.title?settings.title:defaultTitle,
							  modal: settings.modal?settings.modal:true,
							  width: settings.width?settings.width:defaultSize.width,
							  height: settings.height?settings.height:defaultSize.height,
							  zIndex:10000,
							  resizable : settings.resizable?settings.resizable:true,
                              beforeClose: settings.beforClose?settings.beforeClose:xenos.windowManager.cleanup,
							  close: function(event, ui)
										{
											tag.dialog('destroy');
											tag.remove();
											var noOfSelectedCheckBox = $('#queryResultForm').find('.slick-cell-checkboxsel.selected').find('input').length;
											for(k=0;k<noOfSelectedCheckBox;k++){
												$('#queryResultForm').find('.slick-cell-checkboxsel.selected').find('input').trigger('click');
											}
											if(!settings.matchFlag){
												btn.removeAttr("disabled");
											}
										},
							   buttons: popupbtns

							  }).dialog('open').keypress(function(e){
													  if ((e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)) {
														e.preventDefault();
														if( $('.popSubmitBtn',container).is(':visible') ) {
															$('.ui-dialog.topMost .ui-dialog-buttonpane .popSubmitBtn').click();
														}
													  }
													});
					// get the topmost dialog
					setTopMost();
					container = $('.ui-dialog.topMost .ui-dialog-buttonpane');
					
					$('.popRequery',container).unbind('keydown');
					$('.popRequery',container).bind('keydown', function(e){
						if ((e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)) {
							e.preventDefault();
							requeryHandler(e);
						}
					});
					if(isGridable){
						$('.popRequery',container).hide();
						$('.popResetBtn',container).hide();
						$('.popSubmitBtn',container).hide();
					} else {
						$('.popRequery',container).hide();
						$('.popResetBtn',container).show();
						$('.popSubmitBtn',container).show();
					}
					//Fix for Return Key handling on Select Boxes
					$('.popFormItemArea select').bind('keypress',function(evt){
						if(evt.keyCode === 13){
							$('.popSubmitBtn input').trigger('click');
						}
					});
					$('.ui-dialog.topMost').prop("formTarget", targetFieldId);
					$('.ui-dialog.topMost').prop("formHiddenTarget", hiddenTargetFieldId)
					$('.ui-dialog.topMost').prop("$_btnTarget_", btn);
					
					//if any value is given by user thn forwd it in popup
					if(targetFieldId.length == 1){
						//$('.ui-dialog.topMost #popUpQueryFormParent .popTgt').attr('value',$('#'+targetFieldId).val());
						//$('.ui-dialog.topMost #popUpQueryFormParent .popTgt').attr('value',$('#'+targetFieldId,'.ui-dialog').val());
					}else{
						$(".ui-dialog.topMost #popUpQueryFormParent").html(content);
						if((typeof grid_result_data !== 'undefined' && grid_result_data != undefined) && (typeof $('.ui-dialog.topMost #popUpQueryResultForm').get(0) !== 'undefined'))
							$('.ui-dialog.topMost #popUpQueryResultForm .pop-xenos-grid').xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
					}
					var dialogcontentHeight = $('.ui-dialog.topMost .ui-dialog-content').innerHeight() - 50;
					$('.ui-dialog.topMost .popFormItemArea').height(dialogcontentHeight);
					if(isGridable){
						grid_result_settings.yOffset = grid_result_settings.yOffset || 45;
						$('.ui-dialog.topMost #popUpQueryResultForm .pop-xenos-grid').xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
					}

			} 
		
		});
    }
	
	/* Reset Handler */
	function resetHandler(e){
		e.preventDefault();
		setTopMost();
		var container = $('.ui-dialog.topMost #overlay');
		var btn = $(e.target);
		$('div.ui-dialog-titlebar').children('.popupFormTabErrorIco').remove();
        var form = $('.ui-dialog.topMost #popQueryForm');
        var commandFormId = '?commandFormId=' + $('[name=commandFormId]',form).val();
        var fragmentName = '&fragments=content';
			
		  xenos$Handler$default.generic(e,{
			requestUri:xenos.context.path+form.attr('resetAction') + commandFormId + fragmentName,
			requestType:xenos$Handler$default.requestType.asynchronous,
			contentType:xenos$Handler$default.contentType.html,
			settings: {
				type: 'POST'
			},
			onHtmlContent: function (e, options, $target, content) {
			var _scripts = [
				{path: xenos.context.path + '/scripts/inf/datevalidation.js'},
				{path: xenos.context.path + '/scripts/xenos-treeview.js'},
				{path: xenos.context.path + '/scripts/inf/instrumentForm.js'}
				];
				xenos.loadScript(_scripts);
				
				container.html(content);
				$('input,select','.popFormItemArea' ).first().focus();
				
			}
			}); 
	}
	
	function submitHandler(e){
		setTopMost();
		var container = $('.ui-dialog.topMost .ui-dialog-buttonpane');
		var btn = $(e.target);
		$(e.target).attr('disabled', true);
		$('div.ui-dialog-titlebar').children('.popupFormTabErrorIco').remove();
		e.preventDefault();
        var form = $('.ui-dialog.topMost #popQueryForm');
        var commandFormId = '?commandFormId=' + $('[name=commandFormId]',form).val();
        var fragmentName = '&fragments=content';
		
		xenos$Handler$default.generic(e,{
			requestUri:xenos.context.path+form.attr('action') + commandFormId + fragmentName,
			requestType:xenos$Handler$default.requestType.asynchronous,
			contentType:xenos$Handler$default.contentType.html,
			settings: {
				type: 'POST',
				data: form.serialize()
			},
			onHtmlContent: function (e, options, $target, content) {
					btn.removeAttr('disabled');
				if(content.indexOf('errorMsg') != -1){
					var msg =[];
					$.each($(content).find('ul.errorMsg li'), function(index,value){
						msg.push($(value).text());
					});
					//xenos.postNotice(xenos.notice.type.error, msg);
					$('div.ui-dialog-titlebar').append('<span class="popupFormTabErrorIco" title="Error message">Error</span>');
					
					  // Default OnReady Handler bounded for .formTabErrorIco
					  $('.popupFormTabErrorIco').die();					  
					  $('.popupFormTabErrorIco').live('click', xenos.postNotice(xenos.notice.type.error, msg, true));
					  return;
				}
				$(".ui-dialog.topMost #popUpQueryFormParent").html(content);
				if((typeof grid_result_data !== 'undefined' && grid_result_data != undefined) && (typeof $('.ui-dialog.topMost #popUpQueryResultForm').get(0) !== 'undefined')){
					grid_result_settings.yOffset = grid_result_settings.yOffset || 77;
					$('.ui-dialog.topMost #popUpQueryResultForm .pop-xenos-grid').xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
				}
				$('.popRequery',container).show();
				$('.popResetBtn',container).hide();
				$('.popSubmitBtn',container).hide();
				$('.popRequery',container).focus();
            }
			
		}); 
		
	}
	
	function requeryHandler(e){
        //Cleaning Up grids
        var grids = $("[class*=slickgrid_]", $(e.target).closest('.ui-dialog'));
        $.each(grids, function (ind, grid) {
            $(grid).data("gridInstance").destroy();
        });

		e.preventDefault();
		var container = $('.ui-dialog.topMost .ui-dialog-buttonpane');
        var form = $('.ui-dialog.topMost #popUpQueryResultForm');
        var commandFormId = '?commandFormId=' + $('[name=commandFormId]',form).val();
		var fragmentName = '&fragments=content';
		
			xenos$Handler$default.generic(e,{
			requestUri:xenos.context.path+form.attr('action') + commandFormId + fragmentName,
			requestType:xenos$Handler$default.requestType.asynchronous,
			contentType:xenos$Handler$default.contentType.html,
			settings: {
				type: 'POST'
			},
			onHtmlContent: function (e, options, $target, content) {
			
				 form.closest('.ui-dialog.topMost #overlay').html(content);
				 
				 
				 //Fix for Return Key handling on Select Boxes
					$('.popFormItemArea select').bind('keypress',function(evt){
						if(evt.keyCode === 13){
							$('.popSubmitBtn input').trigger('click');
						}
					});
					$('input,select','.popFormItemArea' ).first().focus();
					
					var dialogcontentHeight = $('.ui-dialog.topMost .ui-dialog-content').innerHeight() - 50;
					$('.ui-dialog.topMost .popFormItemArea').height(dialogcontentHeight);
					$('.popRequery',container).hide();
					$('.popResetBtn',container).show();
					$('.popSubmitBtn',container).show();
            }
			
		});
	}

	function prepareDependentParams(btnObj,dependentParams,requestParams) {
		 var dStr ="",dArray,kArray;
		 var flag = true;
		 dArray = dependentParams;
		 kArray = requestParams;
		 dArray.splice(0 , 1);
		 kArray.splice(0 , 1);
		  
		  for (var k=0;k<dArray.length ;k++ )
				{
					var prepareArray="#"+dArray[k];
					var objVal=$(prepareArray);
					//var objVal=btnObj.attr(dArray[k]);
					
					var obj=objVal.val();
					//checks whether the dependent field is selected 
					if(obj == '' || obj === "undefined")
					{
					jAlert("Please select a/an "+dArray[k].toString().charAt(0).toUpperCase()+dArray[k].toString().slice(1)+" first","error");
					return "";
					}
		//to prepare the url			
		for(var i=0;i<kArray.length ;i++ ){
				  var prepareArray="#"+kArray[i];
					var objVal=$(prepareArray);
					var obj="";
					obj=objVal.val();
					
					if(objVal == undefined){
					}
					if(typeof obj === "undefined"){
					if(flag){
						dStr+="?dependents["+kArray[i]+"]";
							flag = false;
						}else{
						dStr+="&dependents["+kArray[i]+"]";
						}
					}
					else{
						if(flag){
						dStr+="?dependents["+kArray[i]+"]="+obj;
							flag = false;
						}else{
						dStr+="&dependents["+kArray[i]+"]="+obj;
						}
					}
					
				}
			}
			
	 return dStr;
	}
	

	$(function () {
        //Binding Button Handler
	$('.popupBtn,.listBtn').die();
    $('.popupBtn,.listBtn').live('click', function(e){
	
	xenos.ns.otherPopupHandler(e,$(e.target).data());
	
	});
/* 	$('.listBtn').die();
    $('.listBtn').live('click', openPopUpForm); */

    });
	});
