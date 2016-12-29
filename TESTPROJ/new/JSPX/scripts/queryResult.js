//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
$('.tabs .query-tab').hover(
		function() {
			$(this).css("cursor", "hand");
		}
);
//result tab link
$('.tabs .visited').hover(
		function() {
			$(this).css("cursor", "hand");
		}
);

$('.tabs .query-tab').die();   
$('.tabs .query-tab').live('click', function(e){
	//Collecting Grids for clean up
	var gridInstanceArray = [];
	var grids = $("[class*=slickgrid_]", $(e.target).parents('#queryResultForm'));
	$.each(grids, function (ind, grid) {
		if($(grid).data("gridInstance").getEditorLock().isActive()){
			$(grid).data("gridInstance").getEditorLock().commitCurrentEdit();
		}
		gridInstanceArray.push($(grid).data("gridInstance"));
	});
	e.preventDefault();
	if(!gridInstanceArray){
		return false;
	}
	if(typeof Xenos$Back$PreHook === 'function') {
		Xenos$Back$PreHook.call(this,e);
	}

	xenos.utils.clearGrowlMessage();
	xenos$Handler$asyncQryFormTab.generic(e,{'gridInstance' : gridInstanceArray});
});

//result tab click
$('.tabs .visited').die();   
$('.tabs .visited').live('click', function(e){
	xenos.utils.clearGrowlMessage();
	var container = $('#content');
	var commandFormId = jQuery('[name=commandFormId]', container).val();
	
	var form=$('#queryForm',container);
	var json = [];
	  // Loop through all the form elements
	for (var i=0;i<form[0].length;i++) {
		// Make sure they're valid to be stored (i.e. checked, not a button)
		if (form[0].elements[i].name && (form[0].elements[i].checked
		  || /select|textarea/i.test(form[0].elements[i].nodeName)
		  || /text|password/i.test(form[0].elements[i].type))) {
		  // Store them in an object association
		  var entry = {};
		  entry[form[0].elements[i].name] = form[0].elements[i].value;
		  json.push(entry);
		}
	}
	var $cache = $('div#footer>div#xenos-cache-container>span#cache');
	var preservedFormName = "preservedForm"+commandFormId;
	$cache.data(preservedFormName,JSON.stringify(json));
  
	Xenos$Back$PreHook = undefined;
	var url = $('#baseUrl',container).val() + "/backOperation?commandFormId=" +commandFormId + "&fragments=content";
	xenos$Handler$default.generic(undefined,{
		requestUri: xenos.context.path + url,
		requestType: xenos$Handler$default.requestType.asynchronous,
		onHtmlContent: function(e, options, $target, content) {
			//Do Nothing
		},
		settings: {
			beforeSend: function(request) {
				request.setRequestHeader('Accept', 'text/html;type=ajax');
			},
			type: 'POST',
			complete : function(jqXHR,textStatus){
				$('.result-tab',container).addClass('active');
				container.html(jqXHR.responseText);
				if ($('#queryForm',container).length == 0) {
					$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
				}
			}
		},
		target: '#content'				

	})
});



var xenos$Handler$asyncQryFormTab = xenos$Handler$function({
	get: {
		requestUri: function(event){
			var container,backUrl;
			if($(event.target).parents(".ui-dialog").size()>0){
				$(event.target).attr('saved',true);
				container = $(event.target).closest(".ui-dialog-content");
				backUrl = container.attr('action');
				if(!backUrl){
					backUrl = $('#queryResultForm',container).attr('action');
				}
			}
			else{
				container = $("#content");
				backUrl = $('#queryResultForm',container).attr('action');
			}
			var commandFormId = "";
			if($('[name=commandFormId]',container).length>0){
				commandFormId = '?commandFormId='+$('[name=commandFormId]',container).val();
			}
			return xenos.context.path + backUrl + commandFormId;
		},	

		//$('#queryResultForm').attr('action') + '?commandFormId=' + $('[name=commandFormId]').val(),
		requestType: xenos$Handler$default.requestType.asynchronous,
		target: function(event){
			if($(event.target).parents(".ui-dialog").size()>0){
				return "#" + $(event.target).closest(".ui-dialog-content").attr("id");
			}
			else	
				return '#content'; 
		}	
	},
	callback:{
		"success": function(event, options){		
			if($(event.target).attr('saved')!==undefined){
				setTopMost();
				container = $('.ui-dialog.topMost .ui-dialog-content #formContainer');
				container.removeClass('paddingFour');
				container.children('.transBg').removeClass('transBg');
			}
			//Clean the Slick Grid
			if(options){
				$.each(options['gridInstance'] || [], function (ind, grid) {
					grid.destroy();
					delete grid;
				});
			}
			
			var container = $('#content');
			var commandFormId = jQuery('[name=commandFormId]', container).val();
			var $cache = $('div#footer>div#xenos-cache-container>span#cache');
			var preservedFormName = "preservedForm"+commandFormId;
			var preservedForm = $cache.data(preservedFormName);
			if(preservedForm!=undefined) {
				var form=$('#queryForm',container);
				if(preservedForm.length > 0){
					var retval = JSON.parse(preservedForm);
					for(var i=0;i<retval.length;i++) {
					  var obj = retval[i];
					  for(var key in obj){
						form[0].elements[key].value = obj[key];
					  }
					}
				}
			}
			
		}
	},	
	settings: {
		beforeSend: function(request) {
			request.setRequestHeader('Accept', 'text/html;type=ajax');
		},
		type: 'POST',
		data: { fragments: 'content'}
	}
});

/*$('.popRequery').click(
    function(e) {
        e.preventDefault();
        var form = $('.ui-dialog.topMost #popUpQueryResultForm');
        var commandFormId = '?commandFormId=' + $('[name=commandFormId]',form).val();
		var fragmentName = '&fragments=content';
		$.ajax({
            type: "POST",
            url: form.attr('action') + commandFormId + fragmentName,
            beforeSend: function(req) {
                req.setRequestHeader("Accept", "text/html;type=ajax");
            },  
            complete : function(jqXHR) {
				form.closest('.ui-dialog.topMost #overlay').html(jqXHR.responseText);
				$.getScript("scripts/inf/datevalidation.js", function(data, textStatus, jqxhr) {});
				 $.getScript("scripts/xenos-treeview.js", function(data, textStatus, jqxhr) {});
				 $.getScript("scripts/inf/instrumentForm.js", function(data, textStatus, jqxhr) {});

				 //Fix for Return Key handling on Select Boxes
					$('.popFormItemArea select').bind('keypress',function(evt){
						if(evt.keyCode === 13){
							$('.popSubmitBtn input').trigger('click');
						}
					});
					$('input,select','.popFormItemArea' ).first().focus();

					var dialogcontentHeight = $('.ui-dialog.topMost .ui-dialog-content').innerHeight() - 50;
					$('.ui-dialog.topMost .popFormItemArea').height(dialogcontentHeight);
            }
        });
    }
);*/


$('.select-pop-query').die();
$('.select-pop-query').live('click', function(e) {

	var isOtherPopUp=grid_result_settings.isMatchPopUp;

	if(isOtherPopUp){


		var gridInstance =($(this).closest('.pop-xenos-grid').data("gridInstance"));

		var gridData = gridInstance.getData().getItems();


		var row =$('.select-pop-query').attr('row');

		otherPopupSelector(e,gridData,row);

		//set this val in proper field in the form then close the pop up

		var randomnumber=Math.floor(Math.random()*10000001);

		$(this).closest('.ui-dialog #popFormContainer').attr('id','popFormContainer'+randomnumber);
		$(this).closest('.ui-dialog').remove();
		$('#popFormContainer'+randomnumber+'').parent().parent().remove(); 

		var noOfSelectedCheckBox = $('#queryResultForm').find('.slick-cell-checkboxsel.selected').find('input').length;
		for(k=0;k<noOfSelectedCheckBox;k++){
			$('#queryResultForm').find('.slick-cell-checkboxsel.selected').find('input').trigger('click');
		}

	}
	else{	

		var tgt = $(e.target);
		e.preventDefault();
		// If the dialog hierarchy is more than 1 then we have to consider the parent dialog for target element.
		var container = $('.ui-dialog').eq(-2);
		//fetch target value
		var row = tgt.attr('row');
		var val = [],
		gridInstance = $(this).closest('.pop-xenos-grid').data("gridInstance");
		gridData = gridInstance.getData().getItems();
		for(var k=0;k<grid_result_columns.length;k++){
			if((grid_result_columns[k].targetColumn!= "undefined")&&grid_result_columns[k].targetColumn){
				//val.push((gridData[row])[grid_result_columns[k].id]);
				var htmlDecodeData = $('<div/>').html((gridData[row])[grid_result_columns[k].id]).text();
				//val.push(unescape((gridData[row])[grid_result_columns[k].id]));
				val.push(htmlDecodeData);
			}
		}
		//set this val in proper field in the form then close the pop up
		var targetFieldId = $(this).closest('.ui-dialog').prop("formTarget");
		var hiddenTargetFieldId = $(this).closest('.ui-dialog').prop("formHiddenTarget");
		var $targetBtn = $(this).closest('.ui-dialog').prop("$_btnTarget_");
		if($targetBtn){
			$targetBtn.removeAttr("disabled");
		}

		for(var k=0;k<val.length;k++){
			if($('#'+targetFieldId[k],'.ui-dialog').length !=0){
				var oldValue = $('#'+targetFieldId[k],container).val();
				if(oldValue != val[k]){
					$('#'+targetFieldId[k],container).val(val[k]).change().trigger('customChange');
					$('#'+targetFieldId[k],container).focus();
				}
			} else {
				var oldValue = $('#'+targetFieldId[k]).val();
				if(oldValue != val[k]){
					$('#'+targetFieldId[k]).val(val[k]).change().trigger('customChange');
					$('#'+targetFieldId[k]).focus();
				}
			}
		}

		if(typeof xenos.ns.filterHiddenTgt.filterHiddenTargetFieldId !== 'undefined' 
			&& jQuery.isFunction(xenos.ns.filterHiddenTgt.filterHiddenTargetFieldId) 
			&& typeof $targetBtn.attr('hiddenFieldFilteredReqd') !== 'undefined'
				&& $targetBtn.attr('hiddenFieldFilteredReqd') === 'true'){
			hiddenTargetFieldId = xenos.ns.filterHiddenTgt.filterHiddenTargetFieldId(gridData[row],$targetBtn);
		} 
		if(hiddenTargetFieldId && hiddenTargetFieldId .length>0){
			for(var indx in hiddenTargetFieldId ){
				var keyVal = hiddenTargetFieldId[indx].split(":");
				if(jQuery.isArray(keyVal)){
					if(keyVal.length == 1){
						keyVal[1]= keyVal[0];
					}
					var hiddenData = $('<div/>').html((gridData[row])[keyVal[1]]).text();
					//$('#'+keyVal[0]).val((gridData[row])[keyVal[1]] || "");
					$('#'+keyVal[0]).val(hiddenData);
					$('#'+keyVal[0]).trigger('change');
				}
			}
		}
		var randomnumber=Math.floor(Math.random()*10000001);

		$(this).closest('.ui-dialog #popFormContainer').attr('id','popFormContainer'+randomnumber);
		$(this).closest('.ui-dialog').remove();
		$('#popFormContainer'+randomnumber+'').parent().parent().remove();
		if(gridInstance){
			gridInstance.destroy();
		}
		if(typeof Xenos$Submit$PreHook !== 'undefined') {
			Xenos$Submit$PreHook = undefined;		
		}
	}
});

function otherPopupSelector(e,gridData,row){ 

	var $container = $('#queryResultForm');

	var _pks=grid_result_settings.pks;

	var tradePk=gridData[row].tradePk;

	var confirmationPk=grid_result_settings.confirmationPk;

	var masterGrid = ($('#queryResultForm .xenos-grid').data("gridInstance"));//.getData().getItems();

	var dataItems = masterGrid.getData();

	var tgt = $(e.target);
	e.preventDefault();
	//fetch target value
	var row = tgt.attr('row');


	var trRefNo = (gridData[row])[grid_result_columns[1].id];
	masterGrid.invalidateRow(1);
	dataItems.getItem(_pks)['referenceNo'] = (gridData[row])[grid_result_columns[1].id];
	dataItems.getItem(_pks)['matchStatusDisp'] = 'Manual';
	dataItems.getItem(_pks)['tradePk'] = tradePk;
	masterGrid.render();

	var xenos$Handler$tradeConfMatch = xenos$Handler$function({
		get: {
			requestType: xenos$Handler$default.requestType.asynchronous,
			target: '#content'
		},
		settings: {
			beforeSend: function(request) {
				request.setRequestHeader('Accept', 'text/html;type=ajax');
			},
			data: {fragments: 'content'}
		}
	});


	xenos$Handler$tradeConfMatch.generic(e, {
		requestUri: xenos.context.path + '/trd/rcvdConfirmation/resultAction/matchTrade.json?queryCommandFormId=' + jQuery('[name=commandFormId]', $container).val() + '&pk=' + _pks + '&confirmationPk=' + confirmationPk + '&tradePk=' +tradePk + '&referenceNo=' +trRefNo,
		settings: {
			type: 'POST',
			data: jQuery.param({
				fragments: 'content',
				actionTaken:'Match'
			}, true)
		}, 
		onJsonContent :  function(e, options, $target, content) {
			$target.removeAttr('disabled');

			if(content.isFind == false){
				$('.formHeader',context).find('.formTabErrorIco').css('display', 'block');
				$('.formHeader',context).find('.formTabErrorIco').off('click');
				$('.formHeader',context).find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, content.value,true));
			}else{


			}
		}
	});



}

//asynchronous handler
var xenos$Handler$asynchronous$popup = xenos$Handler$function({
	get: {
		requestType: xenos$Handler$default.requestType.asynchronous
	},
	settings: {
		beforeSend: function(request) {
			request.setRequestHeader('Accept', 'text/html;type=ajax');
		},
		data: {fragments: 'content'},
		type: "GET"
	}
});


$('.rawData').die();
$('.rawData').live('click', function (e) {

	if (xenos.windowManager.allowDialog()) {
		var tgt = $(e.target);
		//alert('Hi');
		var view = tgt.attr('view');
		if(view == "" || view.length == 0) return;

		var dialog_id = 'detailDialog' + xenos.windowManager.counter;
		var tag = $('<div id=' + dialog_id + '></div>'); //This tag will the hold the dialog content.
		var defaultSize = {
				width: 982,
				height: 500
		};
		var container;
		var btnContainer;

		var url = details$View$Url(e);
		var title = details$View$Title(e);

		//   xenos$Handler$asynchronous$popup.generic(undefined, {requestUri: xenos.context.path + url, onHtmlContent : function(e, options, $target, content) {
		xenos$Handler$asynchronous$popup.generic(undefined, {requestUri: xenos.context.path + url,onHtmlContent: function(e, options, $target, content){
			tag.append(content);
			tag.dialog({
				title: title,
				modal: false,
				width: defaultSize.width,
				height: defaultSize.height,
				zIndex: 10000,
				resizable: true,
				open: function (event, ui) {
					// get the topmost dialog
					setTopMost();		  
					container = $('.ui-dialog.topMost .ui-dialog-content');
					btnContainer = $('.ui-dialog.topMost .ui-dialog-buttonpane');
					details$View$Page$SpecificImpl(container,this);    
					//alternate color of the table
					$('.tableStyle tr:odd', '.detailBlock').addClass('odd');
					$('.detailSmlBlk tr:odd', '.detailBlock').addClass('odd');

					//Registering the Dialog to the Window Manager
					xenos.windowManager.reg({
						id: dialog_id,
						title: title
					});
				},
				close: function (event, ui) {
					tag.dialog('destroy');
					tag.remove();
					//Unregister the Dialog
					xenos.windowManager.unreg({
						id: dialog_id,
						title: title
					});
				},
				buttons: xenos.detailsView.buttons
			}).dialog('open');
		}
		});
	}
});

$('.htmlBtn').die();
$('.htmlBtn').live('click', function (e) {

	if (xenos.windowManager.allowDialog()) {
		var tgt = $(e.target);
		//alert('Hi');
		var view = tgt.attr('view');
		if(view == "" || view.length == 0) return;

		var dialog_id = 'detailDialog' + xenos.windowManager.counter;
		var tag = $('<div id=' + dialog_id + '></div>'); //This tag will the hold the dialog content.
		var defaultSize = {
				width: 982,
				height: 500
		};
		var container;
		var btnContainer;

		var url = details$View$Html$Url(e);
		var title = details$View$Title$Html(e);


		//   xenos$Handler$asynchronous$popup.generic(undefined, {requestUri: xenos.context.path + url, onHtmlContent : function(e, options, $target, content) {
		xenos$Handler$asynchronous$popup.generic(undefined, {requestUri: xenos.context.path + url,onHtmlContent: function(e, options, $target, content){
			tag.append(content);
			tag.dialog({
				title: title,
				modal: false,
				width: defaultSize.width,
				height: defaultSize.height,
				zIndex: 10000,
				resizable: true,
				open: function (event, ui) {
					// get the topmost dialog
					setTopMost();		  
					container = $('.ui-dialog.topMost .ui-dialog-content');
					btnContainer = $('.ui-dialog.topMost .ui-dialog-buttonpane');
					details$View$Page$SpecificImpl(container,this);    
					//alternate color of the table
					$('.tableStyle tr:odd', '.detailBlock').addClass('odd');
					$('.detailSmlBlk tr:odd', '.detailBlock').addClass('odd');

					//Registering the Dialog to the Window Manager
					xenos.windowManager.reg({
						id: dialog_id,
						title: title
					});
				},
				close: function (event, ui) {
					tag.dialog('destroy');
					tag.remove();
					//Unregister the Dialog
					xenos.windowManager.unreg({
						id: dialog_id,
						title: title
					});
				},
				buttons: xenos.detailsView.buttons
			}).dialog('open');
		}
		});
	}
});

/************************************************************************************ 	
 *	Download Link Handler 
 *	Should be taken to upper level in case this feature is required anywhere else.
 *************************************************************************************/
$('.batch-report-hyperlink').die().live('click', function(e){
	e.preventDefault();
	var iframe = 'iframe-download';
	// append iframe
	$('body').append('<iframe id="' + iframe + '" name="' + iframe + '" style="display: none;"/>');
	var $iframe = $('#' + iframe);
	$iframe.on('load', function() {
		//Remove iframe
		setTimeout(function() {$iframe.remove();}, 500);
	});
	//form
	var $form = $('#formContainer').find('form');
	var originalTarget = $form.attr('target');
	$form.attr('target', iframe);
	var originalAction = $form.attr('action');
	$form.attr('action', xenos.context.path+$(e.currentTarget).attr('href'));
	$form.submit();
	$form.attr('target', originalTarget);
	$form.attr('action', originalAction);
});