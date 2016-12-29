//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $

//xenos
//- Dialog handler

var xenos$detailViewHandler = function(e,settings) {
	e.preventDefault();


	var view,
	dialogTitle,
	href,
	method,
	dialogHeight,
	dialogWidth,
	// GET/POST request data
	requestData,
	onOpen = function(){};
	var $target = jQuery(e.target);

	//Override value if setting is given
	if(typeof settings !== 'undefined'){
		if(typeof settings.view !== 'undefined')
			view = settings.view;
		if(typeof settings.dialogTitle !== 'undefined')
			dialogTitle = settings.dialogTitle;
		if(typeof settings.method !== 'undefined')
			method = settings.method;
		if(typeof settings.href !== 'undefined')
			href = xenos.context.path + settings.href;
		if(settings.onOpen !== 'undefined')
			onOpen = settings.onOpen;
		dialogHeight = settings.dialogHeight || 600;
		dialogWidth  = settings.dialogWidth || 1320;

		// request data may be JSON, or query string (which is to be converted into JSON)
		requestData = settings.requestData || {};

	}else{
		view = $target.attr('view');
		dialogTitle = $target.attr('dialogTitle');
		href = xenos.context.path + $target.attr('href');
		requestData = $target.attr('requestData') || {};
		method = $target.attr('method');
		dialogHeight = $target.attr('dialog_Height') || 600;
		dialogWidth  = $target.attr('dialog_Width') || 1320;
		var index = -1,
		dialogTitleFn;
		if(typeof dialogTitle != 'undefined'){
			if(dialogTitle.indexOf('fn') >= 0){
				index = dialogTitle.indexOf(':');
				var fnNameEndIndex, fnEndIndex, paramsStr, fnparams;
				fnNameEndIndex = dialogTitle.indexOf('('); 
				fnEndIndex = dialogTitle.indexOf(')');
				dialogTitleFn = dialogTitle.substring(index+1, fnNameEndIndex);
				paramsStr = dialogTitle.substring(fnNameEndIndex+1, fnEndIndex);
				fnparams = paramsStr.split(",");
				var fn = window[dialogTitleFn];
				if (typeof fn === "function"){
					dialogTitle = fn.apply(null, fnparams);
				}
			}
		}	
	}
	if(typeof dialogTitle != 'undefined'){
		dialogTitle = xenos.utils.escapeHtml(dialogTitle);
	}

	if (view == '' || view.length == 0) return;

	var scripts = [
	               {path: xenos.context.path + '/scripts/ref/xenos-preferences.js'},
	               {path: xenos.context.path + '/scripts/xenos.authorization.history.js'},
	               {path: xenos.context.path + '/scripts/xenos.more.js'},
	               {path: xenos.context.path + '/scripts/queryResult.js'},
	               {path: xenos.context.path + '/scripts/jquery.PrintArea.js'}
	               ];

	xenos.loadScript(scripts, {
		ordered: true,
		success : function() {
			if (xenos.windowManager.allowDialog()) {
				// Dialog container.
				var dialogId = 'detailDialog' + xenos.windowManager.uniqueDialogIndex++;
				var $dialogContainer = jQuery('<div id=' + dialogId + ' class="detailCont"></div>');
				$('body').xenosloader({});
				xenos$Handler$asynchronous$popup.generic(
						undefined,
						{
							requestUri: href,
							target:'#'+dialogId,
							settings: {
								type: method ? method : 'GET',
										// requestData is typically query params (& separated)
										data : xenos.utils.extractParameters(requestData),
										complete : function(jqXHRT) {
											$('body').find('.detail-loader').remove();

											if(jqXHRT.status == 403 || jqXHRT.status == 999){
												//Here we just only return. Post notice message will be displayed by Global handler.
												return;
											}
										}

							},
							onHtmlContent: function(e, options, $target, content) {
								$dialogContainer.dialog({
									title: dialogTitle,
									modal: false,
									minWidth: 500,
									minHeight: 300,
									width: dialogWidth,
									height: dialogHeight,

									zIndex: 10000,
									resizable: true,				  
									create: function(event, ui){
										// Registering the dialog
										xenos.windowManager.reg({
											id: dialogId,
											title: dialogTitle
										});
									},

									open: function(event, ui) {
										// set this as topmost dialog
										setTopMost();
										var errorMsgElements = $('ul.xenosError li', content) || [];
										if(errorMsgElements.length > 0){
											var  markUp = ""
												+ 	"<div class='detail-failure'>"
												+  			xenos.i18n.message.xenos_detail_dialog_load_fail
												+ 	"</div>" 
												$dialogContainer.html(markUp);
										}else{
											$dialogContainer.html(content);				
											onOpen(event,ui);
											if (typeof xenos$Dialog$Detail$Hook !== 'undefined') {
												xenos$Dialog$Detail$Hook.call(
														this,
														$dialogContainer,
														$dialogContainer.siblings('.ui-dialog-buttonpane')
												);

												delete xenos$Dialog$Detail$Hook;
											}
											//enable toggling for more items							
											$dialogContainer.xenosmore({mode:'detailview'});
										}
									},
									beforeClose: function(event, ui) { 
										xenos.windowManager.cleanup();
										var grids = $("[class*=slickgrid_]", $(event.target).parents('div.ui-dialog'));
										$.each(grids, function (ind, grid) {
											$(grid).data("gridInstance").destroy();
											delete grid;
										});
									},
									close: function(event, ui) {
										$dialogContainer.dialog('destroy');
										$dialogContainer.remove();

										// Unregistering the dialog
										xenos.windowManager.unreg({
											id: dialogId,
											title: dialogTitle
										});
									},

									buttons: [
									          {
									        	  text: 'Button 1',
									        	  click: function() {},
									        	  'class': 'btn1',
									        	  'style': 'display: none'
									          },
									          {
									        	  text: 'Button 2',
									        	  click: function() {},
									        	  'class': 'btn2',
									        	  'style': 'display: none'
									          },
									          {
									        	  text: 'Button 3',
									        	  click: function() {},
									        	  'class': 'btn3',
									        	  'style': 'display: none'
									          },
									          {
									        	  text: 'Button 4',
									        	  click: function() {},
									        	  'class': 'btn4',
									        	  'style': 'display: none'
									          },
									          {
									        	  text: 'Button 5',
									        	  click: function() {},
									        	  'class': 'btn5',
									        	  'style': 'display: none'
									          }
									          ]
								}).dialog('open');

							}
						}
				);

			}
		}
	});

}
jQuery('.detail-view-hyperlink').die();
jQuery('.detail-view-hyperlink').live('click', xenos$detailViewHandler);


var xenos$detailViewNonWindowHandler = function(e,settings) {
	e.preventDefault();

	var $targetElem = $(e.target);
	var $href = xenos.context.path + $targetElem.attr('href');
	var $requestData = $targetElem.attr('requestData');
	var $method = $targetElem.attr('method');
	var $container = $("#content");

	$targetElem.attr('disabled', true);

	//Store the previous 'gridInstance' (if any) in the gridArray, so that they can be destroyed properly afterwards.
	var grids = $("[class*=slickgrid_]", $targetElem.parents('div.formContent'));
	var gridArray = [];
	$.each(grids, function (ind, grid) {
		gridArray.push($(grid).data("gridInstance"));
	});

	if(/[?]/.test($href)){
		$href += '&fragments=content';
	} else {
		$href += '?fragments=content';
	}

	xenos$Handler$default.generic(undefined, {
		requestUri: $href,
		requestType: xenos$Handler$default.requestType.asynchronous,
		target: $container,
		settings: {
			type: $method ? $method  : 'POST',
					// requestData is typically query params (& separated)
					data: $requestData ? xenos.utils.extractParameters($requestData) : {fragments: 'content'},
							beforeSend: function(request) {
								request.setRequestHeader('Accept', 'text/html;type=ajax');
							},
							complete : function(jqXHRT) {
								if(jqXHRT.status == 403 || jqXHRT.status == 999){
									//Here we just only return. Post notice message will be displayed by Global handler.
									return;
								}
							}
		},
		onHtmlContent: function(evt, options, $target, content) {
			$targetElem.removeAttr('disabled');
			$container.html(content).promise().done(function(){
				$.each(gridArray, function (ind, grid) {
					grid.destroy();
				});
				var errorMsgElements = $('ul.xenosError li', content) || [];
				if(errorMsgElements.length == 0){
					$('#queryResultForm',$container).attr("action", $targetElem.attr('queryUrl'));
					$('#queryResultForm',$container).attr("QueryCommandFormId",$('[name=commandFormId]',$container).val());
					$('[name=commandFormId]',$container).remove();
				} else {
					var msg = [];
					$.each($container.find('ul.xenosError li'), function(index, value) { 
						msg.push($(value).text());
					});

					xenos.postNotice(xenos.notice.type.error, msg, true);
				}
			});
			//Call the detail view non-window hook and delete it after the call
			if(typeof xenos$detailViewNonWindow$Hook !== 'undefined') {
				xenos$detailViewNonWindow$Hook.call(
						this,
						$container
				);

				delete xenos$detailViewNonWindow$Hook;
			}
		}
	});

}

jQuery('.detail-view-hyperlink-nowindow').die();
jQuery('.detail-view-hyperlink-nowindow').live('click', xenos$detailViewNonWindowHandler);
