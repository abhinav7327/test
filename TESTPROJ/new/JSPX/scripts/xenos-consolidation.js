//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
/**
****************************************
* xenos Consolidation script
*****************************************
**/
(function ($) {
	$('.slick-cell .select-consolidation').die();
	$('.slick-cell .select-consolidation').live('click', function(e) {
	  //Check if there is any role of this user
	    var position = $(e.target).offset();
		
		// Page level implementation should give actual implementation of consolidateParam method
		consolidateParmas(e);
		
		var formContainer = $(this).closest('.formContent');
		var consolidateActionArea = $('.consolidateActionArea',formContainer);

		if($('a.consolidateActLink',consolidateActionArea).length==0){
			xenos.postNotice(xenos.notice.type.info, xenos.i18n.message.no_associated_role);
			return;
		}	
		
		consolidateActionArea.before('<div class="xenos-overlay"></div>');
		
		/*enable Jqdoc menu */
		var dockOptions = { align: 'middle', labels: 'bc', size: 70, distance: 120, duration: 50  };
		$('#consolidateAct').jqDock(dockOptions);

        $('#consolidateAct').css("top", position.top - 30);
        $('#consolidateAct').css("left", position.left);
	});

	// asynchronous handler to handle success action
	var xenos$Handler$consolidateLinkHandler = xenos$Handler$function({
	  get: {
		requestType: xenos$Handler$default.requestType.asynchronous,
		target: '#content'
	  },
	  settings: {
		type: 'POST',
		beforeSend: function(request) {
		  request.setRequestHeader('Accept', 'text/html;type=ajax');
		}
	  },
	  callback: {
			  success: function(event, options){		
					//Clean the Slick Grid
					if(options){
						$.each(options['gridInstance'] || [], function (ind, grid) {
							grid.destroy();
							delete grid;
						});
					}
			   }
		}
	});

	/**
	 * Actual handler for consolidation.
	 * First check if the action is doable or not. Suppose we click close action in cancel record. Here it is not a doable action.
	 * Then perform the actual action. Actual action is done in success method handler of doable action.
	 */ 
	var consolidateLinkHandler = function(e) {
		var action = $(e.target).attr('id');
		var status = $(e.target).attr('status');
		if(status == 'ready'){
		e.preventDefault();
		var formContainer = $(e.target).closest('.formContent');
		var formUrl = $(e.target).closest('#queryResultForm').attr('action');
			formUrl = formUrl.replace("back","result");
			
		var consolidateActionArea = $('.consolidateActionArea',formContainer);
		var param = $('a.consolidateActLink',consolidateActionArea).data("params");
		var dataObj = $('a.consolidateActLink',consolidateActionArea).data("dataObj");
		var commandFormId = $('[name=commandFormId]',container).val();
		var qryMenuPk = $('div#footer>div#xenos-cache-container>span#cache').data('menuPk');
		var fragmentName = '&fragments=content';
		var actionType = '&type=' + action + '&queryCommandFormId=' + commandFormId;
	    
		if($.isPlainObject(param) && ($.trim($(e.target).attr('actionType')) == "")){
			console.log("Action Type attribute is required.");
			return;
		}
		
		
	    var url = xenos.context.path + '/' + $(e.target).parent().attr('href') + ($.isPlainObject(param) ? param[$(e.target).attr('actionType')] :  param) + actionType;
		var container = $("#content");
		xenos$Handler$default.generic(undefined,{
				requestUri:url,
				requestType:xenos$Handler$default.requestType.asynchronous,
				contentType:xenos$Handler$default.contentType.json,
				//onJsonContent: function (data) {
				onJsonContent:function (evt, options, $target, data) {
				
						// if online closed then return back
						// callee takes the responsibility to show the error message
						if(xenos.context.isOnlineAccessRestricted(data)) {
							return;
						}
						
						if(data.isActionable){
							var commandFormDetail = {queryCommandFormId : commandFormId, queryScreenUrl : formUrl, jsonData : dataObj, qryMenuPk : qryMenuPk};
							url = url.replace("actionable.json","performAction");
							url = url + fragmentName;
				            var dialog = $('a.consolidateActLink',consolidateActionArea).data("dialog");
				            if (!dialog) {
								var gridInstanceArray = [];
								var grids = $("[class*=slickgrid_]", $(e.target).closest('#queryResultForm'));
								$.each(grids, function (ind, grid) {
									gridInstanceArray.push($(grid).data("gridInstance"));
								});
				                xenos$Handler$consolidateLinkHandler.generic(undefined, {requestUri: url,settings: {data : JSON.stringify(commandFormDetail), contentType: 'application/json'},gridInstance : gridInstanceArray});
				            } else {
				                xenos$detailViewHandler(evt, {
				                  view: 'view',
				                  method: 'POST',
				                  href: url + '&popup=true',
				                  dialogTitle:  $('a.consolidateActLink',consolidateActionArea).data("dialogTitle"),
				                  dialogHeight: 500,
				                  onOpen: function(){}
				                });
				            }
						}else{
							var msg = "";
							if(data.success){
								if(action=='amend'){
									msg=xenos.i18n.message.invalid_amend;
								}else if(action=='reopen'){
									msg=xenos.i18n.message.invalid_reopen;
								}else if(action=='cancel'){
									msg=xenos.i18n.message.invalid_cancel;
								}else if(action=='copy'){
									msg=xenos.i18n.message.invalid_copy;
								}else if(action=='entry'){
									msg=xenos.i18n.message.invalid_entry;
								}
								xenos.postNotice(xenos.notice.type.error, msg);
							}else{
								if(action=='amend'){
									msg=xenos.utils.evaluateMessage(xenos.i18n.message.invalid_amend_reason,[data.value[0]]);
								}else if(action=='reopen'){
									msg=xenos.utils.evaluateMessage(xenos.i18n.message.invalid_reopen_reason,[data.value[0]]);
								}else if(action=='cancel'){
									msg=xenos.utils.evaluateMessage(xenos.i18n.message.invalid_cancel_reason,[data.value[0]]);
								}else if(action=='copy'){
									msg=xenos.utils.evaluateMessage(xenos.i18n.message.invalid_copy_reason,[data.value[0]]);
								} else {
									msg = data.value[0];
								}
								$('.formHeader').find('.formTabErrorIco').css('display', 'block');
								$('.formHeader').find('.formTabErrorIco').off('click');
								$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, msg, true));
							}
							$('#consolidateAct').jqDock('destroy');
						}
				}
			});
		}else{
			xenos.postNotice(xenos.notice.type.info, xenos.i18n.message.feature_not_implemented);
		}
	};
	
	//Off the link click default handler
	$('.consolidateActLink').click(function(e){
		e.preventDefault();
	})
	
	//We are using mouse down instead of click function to handle consolidate action
	var _functionI = function(e){
		if($('#consolidateAct').length > 0){
			var target = $(e.target);		
			
			if(target.parent().hasClass('consolidateActLink')){
				consolidateLinkHandler(e);
			}
			//Destroy all of the consolidation resource
			$('#consolidateAct').jqDock('destroy');
			$('.xenos-overlay').remove();
		}
	};
	
	//Destroy the mousedown event using the Namespace ('consolidateAction') created earlier.
	$('body').off('.consolidateAction');
	//Create a Namespace 'consolidateAction' with the mousedown event.
	$('body').on('mousedown.consolidateAction', _functionI);

}(jQuery));
