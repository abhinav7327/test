//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
$(document).ready(function () {
	var handler = xenos$Handler$function({
		get: {
			requestType: xenos$Handler$default.requestType.asynchronous
		},
		settings: {
			beforeSend: function(request) {
				request.setRequestHeader('Accept', 'text/html;type=ajax');
			},
			type: 'POST'
		}
	});
	function openPopUpForm(e) {
    var origEvt = e;
		var btn = $(e.target).is('input') ? $(e.target) : $(e.target).find('input[type="button"]');
		btn.attr("disabled", "disabled");
		e.preventDefault();
		var defaultSize = {
				width : 790,
				height : 350
		};
		var url,title,extUrlParams="",container, reqData = {};
		var popUpType=btn.attr("popType");

		var targetFieldId = btn.attr("tgt").split(",");
		var hiddenTargetFieldId = [];
		var hiddenTgt = btn.attr("hiddenTgt");
		if (typeof hiddenTgt !== 'undefined' && hiddenTgt !== false) {
			hiddenTargetFieldId = hiddenTgt.split(",");
		}
		//var form = 	btn.closest('#queryForm');
		var tag = $('<div></div>'); //This tag will the hold the dialog content.
		if(popUpType=="invAccount"){
			title = xenos.title.accPopup;
			url = "/secure/ref/account/popup/query";
			var dependentParam = prepareAccDependentParams(btn,popUpType);
			extUrlParams = dependentParam;
			var popSize = {width : 890};
			$.extend(defaultSize,popSize);
		}else if(popUpType=="cpAccount"){
			title = xenos.title.accPopup;
			url = "/secure/ref/account/popup/query";
			var dependentParam = prepareAccDependentParams(btn,popUpType);
			extUrlParams = dependentParam;
			//sample object to override default dialog size
			var popSize = {width : 890};
			$.extend(defaultSize,popSize);
		}else if(popUpType=="localAccount"){
			title = xenos.title.localAccPopup;
			url = "/secure/ref/localaccount/popup/query";
			var dependentParam = prepareAccDependentParams(btn,popUpType);
			extUrlParams = dependentParam;
		}else if(popUpType=="ledgerCode"){
			title = xenos.title.ledgerPopup;
			url = "/secure/srs/ledgerCode/popup/query";
		}else if(popUpType=="gleLedgerCode"){
			title = xenos.title.ledgerPopup;
			url = "/secure/gle/ledgercode/popup/query";
			extUrlParams = prepareLedgerDependentParams(btn,popUpType);
		}else if(popUpType=="security"){
			title = xenos.title.instrPopup;
			url = "/secure/ref/security/popup/query";
			var dependentParam = prepareInstrumentDependentParams(btn,popUpType);
			extUrlParams = dependentParam;
			var popSize = {width : 850, height: 365};
			$.extend(defaultSize,popSize);
		}else if(popUpType=="salescode"){
			title = xenos.title.salesCodePopup;
			url = "/secure/ref/salescode/popup/query";
			var dependentParam = prepareSalesDependentParams(btn,popUpType);
			extUrlParams = dependentParam;
		}else if(popUpType=="nationality"){
			title = xenos.title.nationalityPopup;
			url = "/secure/ref/country/popup/query";
			var popSize = {height : 390};
			$.extend(defaultSize,popSize);
		}else if(popUpType=="state"){
			title = xenos.title.statePopup;
			url = "/secure/ref/state/popup/query";
			var popSize = {height : 390};
			$.extend(defaultSize,popSize);
		}else if(popUpType=="trialBalanceId"){
			title = xenos.title.trialBalanceIdPopup;
			url = "/secure/ref/trialBalanceId/popup/query";
		}else if(popUpType=="occupation"){
			title = xenos.title.occupationPopup;
			url = "/secure/ref/occupation/popup/query";
		}else if(popUpType=="customer"){
			title = xenos.title.customerPopup;
			url = "/secure/ref/customer/popup/query";
			var dependentParam = prepareCustomerDependentParams(btn,popUpType);
			extUrlParams = dependentParam;
		}else if(popUpType=="fininst"){
			title = xenos.title.finInstPopup;
			url = "/secure/ref/fininst/popup/query";
		}else if(popUpType=="finInstRoleType"){
			title = xenos.title.finInstPopup;
			url = "/secure/ref/fininst/popup/query";
			var dependentParam = prepareFinInstDependentParams(btn,popUpType);
			extUrlParams = dependentParam;
		}else if(popUpType=="strategy"){
			title = xenos.title.strategyPopup;
			url = "/secure/ref/strategy/popup/query";
		}else if(popUpType=="calendar"){
			title = xenos.title.calendarPopup;
			url = "/secure/ref/calendar/popup/query";
			var popSize = {height: 330};
			$.extend(defaultSize,popSize);
		}else if(popUpType=="currency"){
			title = xenos.title.currency;
			url = "/secure/ref/instrument/popup/ccy";
			var popSize = {width : 740,height: 260};
			$.extend(defaultSize,popSize);
		}else if(popUpType=="servicedBy") {
			title = xenos.title.servicedByPopup;
			url = "/secure/ref/servicedby/popup";
			var dependentParam = prepareServicedByDependentParams(btn,popUpType);
			extUrlParams = dependentParam;
		}else if(popUpType=="agentCode"){
			title = xenos.title.agentCode;
			url = "/secure/ref/agent/popup/query";
			var dependentParam = prepareAgentDependentParams(btn,popUpType);
			extUrlParams = dependentParam;
		}else if(popUpType=="securitySummary"){
			title = xenos.title.instrPopup;
			url = "/secure/ref/security/popup/query/summary";
			if(($.trim(btn.attr("securityCode"))) != ""){
				var reqObj = {};
				reqObj['securityCode'] = ($.trim(btn.attr("securityCode")));
				reqData = reqObj;
			}
			if(reqData == ''){
				btn.removeAttr("disabled");
				return;
			}
			$.extend(defaultSize,popSize);
		}else if(popUpType=="employee"){
			title = xenos.title.employeePopup;
			url = "/secure/ref/employee/popup/query";
			var dependentParam = prepareEmployeeDependentParams(btn,popUpType);
			extUrlParams = dependentParam;
		}else if(popUpType=="ourBank"){
			title = xenos.title.ourBankPopup;
			url = "/secure/ref/ourBank/popup/query";
			var valFlag = xenos.ns.ourBank.validate();
			if(valFlag == true){
				var dependentParam = prepareourBankDependentParams(btn,popUpType);
				extUrlParams = dependentParam;
			}else{
				return false;
			}
		}else if(popUpType=="ourDetail"){
			title = xenos.title.ourBankPopup;
			url = "/secure/stl/ourDetail/popup/query";
			var popReqFunc = btn.attr("populateReq");
			if (typeof popReqFunc !== 'undefined') {
				if(jQuery.isFunction(xenos.ns.customizeBank[popReqFunc])){
					reqData = xenos.ns.customizeBank[popReqFunc]();
				}
				if(reqData == ''){
					btn.removeAttr("disabled");
					return;
				}
			}
		} else if (popUpType == "dtcId") {
			title = xenos.title.dtcIdPopup;
			url = "/secure/ref/dtc/popup/query";
			var dependentParam = prepareDtcDependentParams(btn,popUpType);
			extUrlParams = dependentParam;
		} else if (popUpType == "contraId") {
			title = xenos.title.contraIdPopup;
			url = "/secure/ref/contraId/popup/query";
			var popSize = {
					width : 900,
					height : 200
			};
			$.extend(defaultSize, popSize);
		} else if(popUpType=="ownSsiCustom"){
			title = xenos.title.ownSsiPopUp;
			url = "/secure/ref/OwnSsi/popup/query";
			var popReqFunc = btn.attr("populateReq");
			if (typeof popReqFunc !== 'undefined') {
				if(jQuery.isFunction(xenos.ns.OwnSsiCustom[popReqFunc])){
					reqData = xenos.ns.OwnSsiCustom[popReqFunc]();
				}
			}
			var popSize = {
					width : 900,
					height : 300
			};
			$.extend(defaultSize,popSize);
		}else if(popUpType=="delivery"){
			title = xenos.title.deliveryPopup;
			url = "/secure/ref/delivery/popup/query";
			var dependentParam = prepareDeliveryDependentParams(btn,popUpType);
			if(dependentParam == ""){
				btn.removeAttr("disabled");
				return;
			}
			extUrlParams = dependentParam;
		}else if(popUpType=="tradeRefNo"){
			title = xenos.title.tradeRefNoPopup;
			url = "/secure/trd/refno/popup/query";
		}else if(popUpType=="linkedReferenceNoPopup"){
			title = xenos.title.tradeRefNoPopup;
			url = "/secure/trd/linkedRefNo/popup/query";
			reqData = btn.data('rowData') || {};
		}else if(popUpType=="cpownssi"){
			title = xenos.title.cpOwnSsiPopUp;
			url = "/secure/ref/cpownssi/popup/query";
			var popReqFunc = btn.attr("populateReq");
			if (typeof popReqFunc !== 'undefined') {
				if(jQuery.isFunction(xenos.ns.cpOwnSSIPopup[popReqFunc])){
					reqData = xenos.ns.cpOwnSSIPopup[popReqFunc](e);
				}
				if(reqData == ''){
					btn.removeAttr("disabled");
					return;
				}
			}
			var popSize = {
					width : 900,
					height : 300
			};
			$.extend(defaultSize,popSize);
		}else if(popUpType=="ownssi"){
			title = xenos.title.ourDetailPopUp;
			url = "/secure/ref/ourdetail/popup/query";
			var popReqFunc = btn.attr("populateReq");
			if (typeof popReqFunc !== 'undefined') {
				if(jQuery.isFunction(xenos.ns.ownSSIPopup[popReqFunc])){
					reqData = xenos.ns.ownSSIPopup[popReqFunc]();
				}
				if(reqData == ''){
					btn.removeAttr("disabled");
					return;
				}
			}
			var popSize = {
					width : 900,
					height : 300
			};
			$.extend(defaultSize,popSize);
		}else if(popUpType=="cpAccountSummary"){
			title = xenos.title.accPopup;
			url = "/secure/ref/account/popup/query/summary";
			if(($.trim(btn.attr("accountCode"))) != ""){
				var reqObj = {};
				reqObj['accountNo'] = ($.trim(btn.attr("accountCode")));
				reqData = reqObj;
			}
			if(reqData == ''){
				btn.removeAttr("disabled");
				return;
			}
			$.extend(defaultSize,popSize);
		}else if(popUpType=="reconRefNo"){
			title = xenos.title.reconRefNoPopUp;
			url = "/secure/trade/recon/popup/query";
		}else if(popUpType=="webClientUserId"){
			title = xenos.title.webClientUserIdPopUp;
			url = "/secure/ref/webclientuserid/popup/query";
		}else if(popUpType=="fundCode"){
			title = xenos.title.fundPopup;
			url = "/secure/ref/fundCode/popup/query";
			var popSize = {width : 830,height: 365};
			$.extend(defaultSize,popSize);
		}else if(popUpType=="ourBankList"){
			title = xenos.title.ourBankPopup;
			url = "/secure/stl/wireInst/popup/ourBankList";
			/*var valFlag = xenos.ns.ourBankList.validate();
			if(valFlag == true){*/
				var dependentParam = prepareOurBankListParams(btn,popUpType);
				extUrlParams = dependentParam;
			/*}else{
				return false;
			}*/
		}else if(popUpType=="cpBankList"){
			title = xenos.title.wireinstcpbank;
			url = "/secure/stl/wireInst/popup/cpBankList";
			var dependentParam = prepareCpBankListParams(btn,popUpType);
			extUrlParams = dependentParam;
		}
         else if(popUpType=="settleAccFund"){
			title = xenos.title.settleFundPopup;
			url = "/secure/ref/settlefund/popup/query";
			var dependentParam = prepareSettleFundListParams(btn,popUpType);
			extUrlParams = dependentParam;
			}

		 else if(popUpType=="fininstForFundPopup"){
			title = xenos.title.fininstForFundPopup;
			url = "/secure/ref/finistfund/popup/query";
			var dependentParam = prepareFininstFundListParams(btn,popUpType);
			extUrlParams = dependentParam;

			} 
		else if(popUpType=="custodianBankList"){		
			title = xenos.title.ourBankPopup;
			url = "/secure/ref/fininst/popup/ourBankList";			
			var dependentParam = prepareCustodianBankListParams(btn,popUpType);
			extUrlParams = dependentParam;			
		}
		else if(popUpType=="ourSecCustomizedPopup"){
			title = xenos.title.ourBankPopup;
			url = "/secure/stl/ourCustomized/popup";
			var dependentParam = prepareOurSecCustomizedPopupParams(btn,popUpType);
			extUrlParams = dependentParam;			
		}
		else if(popUpType=="ourCashCustomizedPopup"){
			title = xenos.title.ourBankPopup;
			url = "/secure/stl/ourCustomized/popup";
			var dependentParam = prepareOurCashCustomizedPopupParams(btn,popUpType);
			extUrlParams = dependentParam;			
		}
		
		else if(popUpType=="cpSecCustomizedPopup"){
			title = xenos.title.ssiPopupCustom;			
			url = "/secure/stl/cpSSiCustomized/popup";			
			var dependentParam = prepareCpSecCustomizedPopupParams(btn,popUpType);			
			extUrlParams = dependentParam;			
		}
		else if(popUpType=="cpCashCustomizedPopup"){
			title = xenos.title.ssiPopupCustom;
			url = "/secure/stl/cpSSiCustomized/popup";
			var dependentParam = prepareCpCashCustomizedPopupParams(btn,popUpType);
			extUrlParams = dependentParam;			
		}	
			
			else if(popUpType=="ownssiDrvEntryPopup"){
			title = xenos.title.ourBankPopup;
			url = "/secure/drv/entry/ownssi/popup";			
			var dependentParam = prepareDrvOwnSSiBankListParams(btn,popUpType);
			extUrlParams = dependentParam;			
		}
		
		
	else if(popUpType=="cpSsiSecurity"){
			
			title = xenos.title.SsiPopup;
			url = "/secure/ref/cpssi/popup";
			var popReqFunc = btn.attr("populateReq");		
			reqData = xenos.ns.cpSsiPopUpForSec[popReqFunc]();
			
			var dependentParam = prepareParamsForCpSSi(reqData);
			extUrlParams = dependentParam;			
		}
		
		else if(popUpType=="cpSsiCash"){
			
			title = xenos.title.SsiPopup;
			url = "/secure/ref/cpssi/popup";
			var popReqFunc = btn.attr("populateReq");		
			reqData = xenos.ns.cpSsiPopUpForCash[popReqFunc]();
			
			var dependentParam = prepareParamsForCpSSi(reqData);
			extUrlParams = dependentParam;			
		}
		
		else if(popUpType=="OwnStandingPopup"){
			
			title = xenos.title.OwnStandingPopup;
			url = "/secure/ref/ownssi/popup";
				
		}			


        else {
			return;
		}
		var popupbtns;
		if(targetFieldId.length == 1){
			popupbtns=	[
			{
				text: xenos.title.popupsubmitBtnLabel,
				'class': "popSubmitBtn",
				click: submitHandler
			},
			{
				text: xenos.title.resetBtnLabel,
				'class': "popResetBtn",
				click: resetHandler
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
					btn.removeAttr("disabled");
				}
			}]
		}
		
		$('body').xenosloader({});

		var fragmentName = "";
		if(extUrlParams == ""){
			fragmentName = "?fragments=content";
		}else{
			fragmentName = "&fragments=content";
		}
		handler.generic(undefined,{
			requestUri: xenos.context.path+url+'/init'+extUrlParams,
			data: reqData,
			settings:{
				complete : function(jqXHRT) {
					
					$('body').find('.detail-loader').remove();

					if(jqXHRT.status == 403 || jqXHRT.status == 999){
						//Here we just only return. Post notice message will be displayed by Global handler.
						return;
					}

					if(jqXHRT.responseText.indexOf('errorMsg') != -1){
						var msg =[];
						$.each($(jqXHRT.responseText).find('ul.errorMsg li'), function(index,value){
							msg.push($(value).text());
						});
						//xenos.postNotice(xenos.notice.type.error, msg);
						$('div.ui-dialog-titlebar').append('<span class="popupFormTabErrorIco" title="Error message">Error</span>');

						// Default OnReady Handler bounded for .formTabErrorIco
						$('.popupFormTabErrorIco').die();
						$('.popupFormTabErrorIco').live('click', xenos.postNotice(xenos.notice.type.error, msg, true));

					}else if(jqXHRT.responseText.indexOf('xenosSoftError') != -1){
						var msg =[];
						$.each($(jqXHRT.responseText).find('ul.xenosSoftError li'), function(index,value){
							msg.push($(value).text());
						});
						if(msg.length >0){
							$('div.ui-dialog-titlebar').append('<span class="popupFormTabErrorIco" title="Error message">Error</span>');
							$('.popupFormTabErrorIco').die();
							$('.popupFormTabErrorIco').live('click', xenos.postNotice(xenos.notice.type.info, msg, true));
						}
					}

					tag.append(jqXHRT.responseText);
					tag.dialog({title : title,
						modal: true,
						width:defaultSize.width,
						height:defaultSize.height,
						zIndex:200000,
						minHeight : 210,
						minWidth : 320,
						resizable : true,
						beforeClose: function(event, ui) {
							xenos.windowManager.cleanup();
							var grids = $("[class*=slickgrid_]", $(this));
							$.each(grids, function (ind, grid) {
								$(grid).data("gridInstance").destroy();
							});
							if(targetFieldId.length == 1){
								$('#'+targetFieldId[0]).focus();
							}
						},
						close: function(event, ui)
						{
							$(origEvt.target).focus();
							$(origEvt.target).closest('.ui-dialog').addClass('topMost');
							tag.dialog('destroy');
							tag.remove();
							btn.removeAttr("disabled");
							var dialogCloseFunc = btn.attr("onDialogClose");
							Xenos$Submit$PreHook = undefined;
							if (typeof dialogCloseFunc !== 'undefined') {
								if(jQuery.isFunction(xenos.ns.popup[dialogCloseFunc])){
									var closeData = xenos.ns.popup[dialogCloseFunc](e);									
									if(!$.isEmptyObject(closeData)){
										var gridObj = closeData['grid'];
										if(gridObj && gridObj.getEditorLock().isActive() && !gridObj.getEditorLock().commitCurrentEdit()) {
											//Do-Nothing
										}
									}
								}
							}
							  // tgt of popup triggering element must be same is as id of the value receiving element
							  var tgt = false;
							  var parent = false;
							  parent = $(origEvt.target).closest('.formItem');
							  if(parent.length == 0){
								parent = $(origEvt.target).closest('.popFormItem');
							  }
							  tgt = $(origEvt.target).attr('tgt');
							  if(tgt && parent.length > 0) {
								var elm = $(parent).find('#'+tgt);
								if(elm.length > 0) {
								  $(elm).focus();
								}
							  }
						},
						resize: function(event, ui){
							var $popupGrid = $(this).find('.pop-xenos-grid');
							if($popupGrid.length > 0){
								$popupGrid.height($(this).height()-10);
								$(this).find(".slick-viewport").height($popupGrid.height());
								//To hide the duplicate scroll bar of the dialog window. Scroll bar for grid data only will be shown.
								$(this).css('overflow-y', 'hidden');
								var _grid = $("[class*=slickgrid_]", $(this))[0];
								var grid = $(_grid).data("gridInstance");
								if(grid){
									grid.resizeCanvas();
									if(grid.getOptions().forceFitColumns){
										grid.setOptions({forceFitColumns: false});
									}
									grid.setColumns(grid.getColumns(),true);
								}
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
					//Fix for Return Key handling on Select Boxes
					$('.popFormItemArea select').bind('keypress',function(evt){
						if(evt.keyCode === 13){
							$('.popSubmitBtn input').trigger('click');
						}
					});
					$('.ui-dialog.topMost').prop("formTarget", targetFieldId);
					$('.ui-dialog.topMost').prop("formHiddenTarget", hiddenTargetFieldId)
					$('.ui-dialog.topMost').prop("$_btnTarget_", btn);

					//load scripts and apply different tree views and date picker on the context specified
					loadAndApplyComponents(tag);

					var dialogcontentHeight = $('.ui-dialog.topMost .ui-dialog-content').innerHeight() - 50;
					$('.ui-dialog.topMost .popFormItemArea').height(dialogcontentHeight);

					if(popUpType=="currency" ||
							popUpType=="ourBank" ||
							popUpType=="ourDetail" ||
							popUpType=="cpownssi" ||
							popUpType=="ownssi" ||
							popUpType=="ownSsiCustom" ||
							popUpType=="cpAccountSummary" ||
							popUpType=="securitySummary" ||
							popUpType=="servicedBy" ||
							popUpType=="linkedReferenceNoPopup" ||
							popUpType=="ourBankList" ||
							popUpType=="cpSsiSecurity" ||
							popUpType=="cpSsiCash" ||
							popUpType=="ownssiDrvEntryPopup" ||
							popUpType=="cpBankList" ||
							popUpType=="custodianBankList" ||
							popUpType=="ourSecCustomizedPopup" ||
							popUpType=="ourCashCustomizedPopup" ||
							popUpType=="cpSecCustomizedPopup" ||
							popUpType=="OwnStandingPopup" ||
							popUpType=="cpCashCustomizedPopup" ){
						$('.popRequery',container).hide();
						$('.popResetBtn',container).hide();
						$('.popSubmitBtn',container).hide();
						grid_result_settings.yOffset = grid_result_settings.yOffset || 45;
            var popupResultGrid = $('.ui-dialog.topMost #popUpQueryResultForm .pop-xenos-grid').xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
            popupResultGrid.setActiveCell(0, 0);
					} else {
						$('.popRequery',container).hide();
						$('.popResetBtn',container).show();
						$('.popSubmitBtn',container).show();
					}

				}
			}
		});
	}

	// communication handler
	function tabKeyFix() {
		var ctx  = '.ui-dialog.topMost';
		$('.ui-dialog-buttonset', ctx).children('button:visible').each(function() {
			$(this).nextAll('button:visible:last').addClass('lastBtn');

			$(this).bind('keydown',function(e) {
				var keyCode = e.which || e.keyCode;
				if(keyCode === 9){
					if(e.shiftKey){
						// for shift tab
						e.preventDefault();
						if($(this).hasClass('lastBtn')) {
							$(this).blur();
							$(this).prevAll('button:visible:first').focus();
						} else {
							$('.popFormItem', ctx).last().children().children().focus();
						}
					} else {
						e.preventDefault();
						if($(this).hasClass('lastBtn')){
							$(this).blur();
							$('.popFormItemArea', ctx).find(':input:not(:disabled):not([readonly]):visible:first').focus();
						}else{
							$(this).nextAll('button:visible:first').focus();
						}
					}
				} else if(keyCode == 13){
					e.preventDefault();
					if( $('.popSubmitBtn', '.ui-dialog.topMost').is(':visible:focus') ) {
						$('.ui-dialog.topMost .ui-dialog-buttonpane .popSubmitBtn').click();
					}

					if( $('.popResetBtn', '.ui-dialog.topMost').is(':visible:focus') ) {
						$('.ui-dialog.topMost .ui-dialog-buttonpane .popResetBtn').click();
					}
				}
			});
		});

		$('.popFormItem', ctx).first().children().children().bind('keydown', function(e){
			var keyCode = e.which || e.keyCode;
			if(keyCode === 9){
				if(e.shiftKey) {
					e.preventDefault();
					$(this).blur();
					$('.ui-dialog-buttonset', ctx).find('.lastBtn').focus();
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
		$('body').xenosloader({});
		handler.generic(undefined,{
			requestUri: xenos.context.path+form.attr('resetAction') + commandFormId + fragmentName,
			onHtmlContent: function(e, options, $target, content) {
				//Do Nothing
			},
			settings: {
				complete: function (jqXHR) {
					if(jqXHR.status == 999){
						//Here we just only return. Post notice message will be displayed by Global handler.
						return;
					}
					$('body').find('.detail-loader').remove();
					container.html(jqXHR.responseText);
					//load scripts and apply different tree views and date picker on the context specified
					loadAndApplyComponents(container);

					var popCtx = $('.popFormItemArea', '.topMost');
					$('input,select',popCtx ).first().focus();
				}
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
		var valid= true;
		if(typeof Xenos$Submit$PreHook === 'function') {
			valid = Xenos$Submit$PreHook.call(this);
		}
		if (!valid) {
			btn.removeAttr('disabled');
			return;
		}
		var form = $('.ui-dialog.topMost #popQueryForm');
		var commandFormId = '?commandFormId=' + $('[name=commandFormId]',form).val();
		var fragmentName = '&fragments=content';
		$('body').xenosloader({});
		handler.generic(undefined,{
			requestUri: xenos.context.path+form.attr('action') + commandFormId + fragmentName,
			settings: {
				data: form.serialize(),
				complete : function(jqXHR) {
					if(jqXHR.status == 999){
						//Here we just only return. Post notice message will be displayed by Global handler.
						return;
					}
					$('body').find('.detail-loader').remove();
					btn.removeAttr('disabled');
					if(jqXHR.responseText.indexOf('errorMsg') != -1){
						var msg =[];
						$.each($(jqXHR.responseText).find('ul.errorMsg li'), function(index,value){
							msg.push($(value).text());
						});
						//xenos.postNotice(xenos.notice.type.error, msg);
						$('div.ui-dialog-titlebar').append('<span class="popupFormTabErrorIco" title="Error message">Error</span>');

						// Default OnReady Handler bounded for .formTabErrorIco
						$('.popupFormTabErrorIco').die();
						$('.popupFormTabErrorIco').live('click', xenos.postNotice(xenos.notice.type.error, msg, true));
						return;
					}
					$(".ui-dialog.topMost #popUpQueryFormParent").html(jqXHR.responseText);
					if((typeof grid_result_data !== 'undefined' && grid_result_data != undefined) && (typeof $('.ui-dialog.topMost #popUpQueryResultForm').get(0) !== 'undefined')){
						grid_result_settings.yOffset = grid_result_settings.yOffset || 77;
						$('.ui-dialog.topMost #popUpQueryResultForm .pop-xenos-grid').xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
						$('.ui-dialog.topMost #popUpQueryResultForm .pop-xenos-grid').find('.queryColumnsReset').css('display','none');
					}
					$('.popRequery',container).show();
					$('.popResetBtn',container).hide();
					$('.popSubmitBtn',container).hide();
					$('.popRequery',container).focus();
				}
			}

		});
	}


	function requeryHandler(e){
		//Cleaning Up grids
		var grids = $("[class*=slickgrid_]", $(e.target).closest('.ui-dialog'));
		$.each(grids, function (ind, grid) {
			$(grid).data("gridInstance").destroy();
			$(grid).remove();
		});

		e.preventDefault();
		var container = $('.ui-dialog.topMost .ui-dialog-buttonpane');
		var form = $('.ui-dialog.topMost #popUpQueryResultForm');
		var commandFormId = '?commandFormId=' + $('[name=commandFormId]',form).val();
		var fragmentName = '&fragments=content';
		$('body').xenosloader({});
		handler.generic(undefined,{
			requestUri: xenos.context.path+form.attr('action') + commandFormId + fragmentName,
			settings: {
				complete : function(jqXHR) {
					if(jqXHR.status == 999){
						//Here we just only return. Post notice message will be displayed by Global handler.
						return;
					}
					$('body').find('.detail-loader').remove();
					form.closest('.ui-dialog.topMost #overlay').html(jqXHR.responseText);
					//Bringing back the scroll bar for the container in the popup query window.
					$('.ui-dialog-content').css('overflow-y', 'auto');
					//load scripts and apply different tree views and date picker on the context specified
					loadAndApplyComponents($('.ui-dialog-content'));

					//Fix for Return Key handling on Select Boxes
					$('.popFormItemArea select').bind('keypress',function(evt){
						if(evt.keyCode === 13){
							$('.popSubmitBtn input').trigger('click');
						}
					});
					
					var popCtx = $('.popFormItemArea', '.topMost');
					$('input,select',popCtx ).first().focus();

					var dialogcontentHeight = $('.ui-dialog.topMost .ui-dialog-content').innerHeight() - 50;
					$('.ui-dialog.topMost .popFormItemArea').height(dialogcontentHeight);
					$('.popRequery',container).hide();
					$('.popResetBtn',container).show();
					$('.popSubmitBtn',container).show();
					if(typeof Xenos$Requery$PostHook !== 'undefined') {
						Xenos$Requery$PostHook.call(this);
						Xenos$Requery$PostHook = undefined;
					}
				}
			}

		});
	}

	/*
	 * This API is used to apply different tree views and date picker on
	 * predefined class within the specific context specified.
	 */
	function loadAndApplyComponents(context){
		//for loading the Datepicker and tree views on pop up query form
		xenos.loadScript([{path: xenos.context.path + '/scripts/inf/datevalidation.js'},
		                {path: xenos.context.path + '/scripts/xenos-datepicker.js'},
                    {path: xenos.context.path + '/scripts/inf/jquery.fancytree-all.min.js'},
		                {path: xenos.context.path + '/scripts/xenos-treeview2.js'}], {
			success: function() {
				//Date Picker
				$('input.dateinput', context).xenosdatepicker();
				//Instrument Type
				$('input.instrumentType', context).treeview2({
					contentName: 'instrumentJson',
					type: "Instrument Type",
					isPopUp: true
				});
				//Market
				$('input.market', context).treeview2({
					contentName: 'marketJson',
					type: "market",
					isPopUp: true
				});
				//Strategy Code
				$('input.strategyCode', context).treeview2({
					contentName: 'strategyCodeTree',
					type: "Strategy Code",
					isPopUp: true
				});

				tabKeyFix();
				revokeTabIndex();
			}
		});
	}

	function revokeTabIndex() {
		var ctx = '.ui-dialog.topMost';
		var exclusionList = 'input[type=hidden], input[tgt], .ui-datepicker-trigger, .treeInitBtnIco, .treeResetBtnIco';
		$(exclusionList, ctx).each(function(i) {
			var $input = $(this);
			$input.attr("tabindex", -1);
		});
	}

	/*
		If new parameters are required here and added to the url,
		do check the AccountPopupQueryController.java, prepareContextsFromDependents(Connection, AccountPopupQueryCommandForm) method if they are already handled. If not,
		check the attribute for the following substrings: "actType", "CPType", "bank", "actNo", "status", "finInstCode", "fundCode", "longShortFlag"
		if any of them exists, check the attribute for null, if not null, set the attribute to the specific command form attribute as mention in AccountPopupQueryDispatchAction.java, prepareContextsFromDependents(Connection ,
			AccountPopupQueryActionForm , HttpServletRequest ) method for that particular substring also add the parameters passed as attributes to the FinInstPopupQueryCommandForm.java along with the getter and setter methods.
	*/

	function prepareDrvOwnSSiBankListParams(btnObj,popType) {
		var dStr ="",dArray;
		var flag = true;
		
		
		
		dArray = new Array('securityId','tradingCcy','cpAccountNo','inventoryAccountNo','deliveryMethod','settlementAc','settlementFor','executionBroker');
		for (var k=0;k<dArray.length ;k++ )
		{
			var objVal="";
			if(dArray[k] == 'securityId'){
				objVal = $('#securityCode').val();
			}
			if(dArray[k] == 'tradingCcy'){
				objVal = $('#tradeCcy').val();
			}
			if(dArray[k] == 'cpAccountNo'){
				objVal = $('#brkAccountNo').val();
			}
			if(dArray[k] == 'inventoryAccountNo'){
				objVal = $('#inventoryAccountNo').val();
			}
			/* if(dArray[k] == 'deliveryMethod'){
				objVal = $('#tgtsecurityCode').val();
			}
			if(dArray[k] == 'settlementAc'){
				objVal = $('#tgtsecurityCode').val();
			}
			if(dArray[k] == 'settlementFor'){
				objVal = $('#tgtsecurityCode').val();
			 */
			if(dArray[k] == 'executionBroker'){
				objVal = $('#exeBrkAccountNo').val();
			}
			if(objVal == undefined){
			}else{
				if(flag){					
					dStr+="?"+dArray[k]+"="+objVal;
					flag = false;
				}else{					
					dStr+="&"+dArray[k]+"="+objVal;
				}
			}
			

		}
		
		return dStr;
	}
	
		function prepareCustodianBankListParams(btnObj,popType) {
		
		var dStr ="",dArray;
		var flag = true;
		dArray = new Array('accountNo');
		for (var k=0;k<dArray.length ;k++ )
		{
			var objVal="";
			if(dArray[k] == 'accountNo'){
				objVal = $('#tgtaccountNo').val();
			}
			if(objVal == undefined){
			}else{
				if(flag){					
					dStr+="?"+dArray[k]+"="+objVal;
					flag = false;
				}else{					
					dStr+="&"+dArray[k]+"="+objVal;
				}
			}

		}
		return dStr;
	}
		
		
	function prepareParamsForCpSSi(reqData){
	
	var dStr ="",dArray;
	var flag = true;
	
	dArray = new Array('accountNo','settlementCurrency','instrumentPk','tradeType','subTradeType','secFlag','cashFlag','contractPk','module','executionMarketPk','settlementFor','deliveryMethod','stlLocCash','stlLocSec');
		
	
		 for (var k=0;k<dArray.length ;k++ )
		{
			var objVal="";
			if(dArray[k] == 'accountNo'){
				objVal = reqData['accountNo'];
			}
			if(dArray[k] == 'settlementCurrency'){
				objVal = reqData['settlementCurrency'];
			}
			if(dArray[k] == 'instrumentPk'){
				objVal = reqData['instrumentPk'];
			}
			if(dArray[k] == 'inventoryAccountNo'){
				objVal = reqData['inventoryAccountNo'];
			}
			 if(dArray[k] == 'tradeType'){
				objVal = reqData['tradeType'];
			}
			if(dArray[k] == 'executionMarketPk'){
				objVal = reqData['executionMarketPk'];
			}
			if(dArray[k] == 'secFlag'){
				objVal = reqData['secFlag'];
			 }
			 if(dArray[k] == 'cashFlag'){
				objVal = reqData['cashFlag'];
			 }
			if(dArray[k] == 'module'){
				objVal = reqData['module'];
			}
			if(dArray[k] == 'settlementFor'){
				objVal = reqData['settlementFor'];
			}
			if(dArray[k] == 'deliveryMethod'){
				objVal = reqData['deliveryMethod'];
			}
			if(objVal == undefined){
			}else{
				if(flag){					
					dStr+="?"+dArray[k]+"="+objVal;
					flag = false;
				}else{					
					dStr+="&"+dArray[k]+"="+objVal;
				}
			}
		} 
		
		return dStr;
	}	
	
	function prepareAccDependentParams(btnObj,popType) {
		var dStr ="",dArray;
		var flag = true;
		if(popType=='invAccount')
			dArray = new Array('invActTypeContext','invCPTypeContext','actStatusContext','longShortFlagContext');
		else if(popType=='cpAccount')
			dArray = new Array('actTypeContext','actCPTypeContext','actStatusContext','finInstCode','ownssi', 'actMarginContext','actContext','stlCPTypeContext','fundCodeContext','invActTypeContext','accountStatus');
		else if(popType=='localAccount')
			dArray = new Array('actStatusContext');
		else
			dArray = new Array();
		for (var k=0;k<dArray.length ;k++ )
		{
			var objVal=btnObj.attr(dArray[k]);
			if(objVal == undefined){
			}else{
				if(flag){
					dStr+="?"+dArray[k]+"="+objVal;
					flag = false;
				}else{
					dStr+="&"+dArray[k]+"="+objVal;
				}
			}

		}
		return dStr;
	}
	function prepareLedgerDependentParams(btnObj,popType) {
		var dStr ="",dArray;
		var flag = true;
		if(popType=='gleLedgerCode'){
			dArray = new Array('ledgerStatusContext', 'ledgerModeContext');
		}
		else
			dArray = new Array();
		for (var k=0;k<dArray.length ;k++ )
		{
			var objVal=btnObj.attr(dArray[k]);
			if(objVal == undefined){
			}else{
				if(flag){
					dStr+="?dependents["+dArray[k]+"]="+objVal;
					flag = false;
				}else{
					dStr+="&dependents["+dArray[k]+"]="+objVal;
				}
			}
		}
		return dStr;
	}
	function prepareInstrumentDependentParams(btnObj,popType) {
		var dStr ="",dArray;
		var flag = true;
		if(popType == 'security'){
			dArray = new Array('isGlobal','statusContext');
			for (var k=0;k<dArray.length ;k++ ){
				var objVal=btnObj.attr(dArray[k]);
				if(objVal == undefined){
				}else{
					if(flag){
						dStr+="?dependents["+dArray[k]+"]="+objVal;
						flag = false;
					}else{
						dStr+="&dependents["+dArray[k]+"]="+objVal;
					}
				}
			}
		}else{
			dArray = new Array();
		}
		return dStr;
	}

	function prepareCustomerDependentParams(btnObj,popType) {
		var dStr ="",dArray;
		var flag = true;
		if(popType=='customer'){
			dArray = new Array('customerStatusCtx');
			for (var k=0;k<dArray.length ;k++ ){
				var objVal=btnObj.attr(dArray[k]);
				if(objVal == undefined || objVal == ""){
					//do nothing
				}else{
					if(flag){
						dStr+="?dependents["+dArray[k]+"]="+objVal;
						flag = false;
					}else{
						dStr+="&dependents["+dArray[k]+"]="+objVal;
					}
				}
			}
		}else{
			dArray = new Array();
		}
		return dStr;
	}


	/*
		If new parameters are required here and added to the url,
		do check the FinInstPopUpQueryController.java, prepareContextsFromDependents(Connection, FinInstPopupQueryCommandForm) method if they are already handled. If not,
		check the attribute for the following substrings: "role", "rttm", "codeType"
		if any of them exists, check the attribute for null, if not null, set the attribute to the specific command form attribute as mention in FinInstPopupQueryDispatchAction.java, prepareContextsFromDependents(Connection ,
			FinInstPopupQueryActionForm , HttpServletRequest ) method for that particular substring also add the parameters passed as attributes to the FinInstPopupQueryCommandForm.java along with the getter and setter methods.
	*/
	function prepareFinInstDependentParams(btnObj,popType) {
		var dStr ="",dArray;
		var flag = true;
		if(popType=='finInstRoleType')
			dArray = new Array('finInstRoleCtx', 'finInstStatusCtx','bankRoles','brokerRoles');
		else
			dArray = new Array();
		for (var k=0;k<dArray.length ;k++ )
		{
			var objVal=btnObj.attr(dArray[k]);
			if(objVal == undefined || objVal == ""){
			}else{
				if(flag){
					dStr+="?"+dArray[k]+"="+objVal;
					flag = false;
				}else{
					dStr+="&"+dArray[k]+"="+objVal;
				}
			}
		}
		return dStr;
	}

	function prepareourBankDependentParams(btnObj,popType) {
		var dStr ="",dArray;
		var flag = true;
		dArray = new Array('cash','accountNo','currency','form','securityCode');
		for (var k=0;k<dArray.length ;k++ )
		{
			var objVal="";
			if(dArray[k] == 'accountNo'){
				if($("#inOut").val() == 'I'){
					objVal = $("#cashInAccountNo").val();
				}else{
					objVal = $("#cashOutAccountNo").val();
				}
			}else if(dArray[k] == 'currency'){
				objVal = $("#currency").val();
			}else if(dArray[k] == 'securityCode'){
				objVal = $("#sourceInstrument").val();
			}else{
				objVal = btnObj.attr(dArray[k]);
			}
			if(objVal == undefined){
			}else{
				if(flag){
					//dStr+="?dependents["+dArray[k]+"]="+objVal;
					dStr+="?"+dArray[k]+"="+objVal;
					flag = false;
				}else{
					//dStr+="&dependents["+dArray[k]+"]="+objVal;
					dStr+="&"+dArray[k]+"="+objVal;
				}
			}

		}
		return dStr;
	}

	function prepareOurBankListParams(btnObj,popType) {
		var dStr ="",dArray;
		var flag = true;
		dArray = new Array('fundCode','currency','account');
		for (var k=0;k<dArray.length ;k++ )
		{
			var objVal="";
			if(dArray[k] == 'fundCode'){
				objVal = $("#fundCode").val();
			}else if(dArray[k] == 'currency'){
				objVal = $("#ccy").val();
			}else if(dArray[k] == 'account'){
				objVal = $("#accountNo").val();
			}
			if(objVal == undefined){
			}else{
				if(flag){
					//dStr+="?dependents["+dArray[k]+"]="+objVal;
					dStr+="?"+dArray[k]+"="+objVal;
					flag = false;
				}else{
					//dStr+="&dependents["+dArray[k]+"]="+objVal;
					dStr+="&"+dArray[k]+"="+objVal;
				}
			}

		}
		return dStr;
	}

	function prepareOurBankListDependentParams(btnObj,popType) {
		var dStr ="",dArray;
		var flag = true;
		dArray = new Array('fundCode','currency');
		for (var k=0;k<dArray.length ;k++ )
		{
			var objVal="";
			if(dArray[k] == 'fundCode'){
				objVal = $("#fundCode").val();
			}else if(dArray[k] == 'currency'){
				objVal = $("#ccy").val();
			}
			if(objVal == undefined){
			}else{
				if(flag){
					dStr+="?dependents["+dArray[k]+"]="+objVal;
					flag = false;
				}else{
					dStr+="&dependents["+dArray[k]+"]="+objVal;
				}
			}

		}
		return dStr;
	}

	function prepareCpBankListParams(btnObj,popType) {
		var dStr ="",dArray;
		var flag = true;
		dArray = new Array('fundCode','currency','account');
		for (var k=0;k<dArray.length ;k++ )
		{
			var objVal="";
			if(dArray[k] == 'fundCode'){
				objVal = $("#fundCode").val();
			}else if(dArray[k] == 'currency'){
				objVal = $("#ccy").val();
			}else if(dArray[k] == 'account'){
				objVal = $("#accountNo").val();
			}
			if(objVal == undefined){
			}else{
				if(flag){
					//dStr+="?dependents["+dArray[k]+"]="+objVal;
					dStr+="?"+dArray[k]+"="+objVal;
					flag = false;
				}else{
					//dStr+="&dependents["+dArray[k]+"]="+objVal;
					dStr+="&"+dArray[k]+"="+objVal;
				}
			}

		}
		return dStr;
	}

	function prepareDtcDependentParams(btnObj,popType) {
		var dStr ="",dArray;
		var flag = true;

		dArray = new Array('idUserType');
		for (var k=0;k<dArray.length ;k++ )
		{
			var objVal=btnObj.attr(dArray[k]);
			if(objVal == undefined){
			}else{
				if(flag){
					dStr+="?dependents["+dArray[k]+"]="+objVal;
					flag = false;
				}else{
					dStr+="&dependents["+dArray[k]+"]="+objVal;
				}
			}

		}
		return dStr;
	}

	function prepareDeliveryDependentParams(btnObj,popType) {
		var dStr ="";
		var flag = true;
		if(popType == 'delivery'){
			var objVal = $("#reportId").val();
			if(objVal == undefined || objVal == ""){
				jAlert("Please select a report name", "error");
				return "";
			}else{
				if(flag){
					dStr+="?dependents[communicationId]="+objVal;
					flag = false;
				}else{
					dStr+="&dependents[communicationId]="+objVal;
				}
			}
		}else{
			dArray = new Array();
		}
		return dStr;
	}

	function prepareEmployeeDependentParams(btnObj,popType) {
		var dStr ="",dArray;
		var flag = true;
		if(popType=="employee") {
			dArray = new Array('empStatusContext');
		} else {
			dArray = new Array();
		}

		for (var k=0;k<dArray.length ;k++ ) {
			var objVal=btnObj.attr(dArray[k]);
			if(objVal == undefined){
			}else{
				if(flag){
					dStr+="?dependents["+dArray[k]+"]="+objVal;
					flag = false;
				}else{
					dStr+="&dependents["+dArray[k]+"]="+objVal;
				}
			}
		}
		return dStr;
	}

	function prepareServicedByDependentParams(btnObj,popType) {
		var businessRelPk = $.trim(btnObj.attr('businessRelPk'));
		return "?dependents[businessRelPk]="+(businessRelPk == -1 ? "" : businessRelPk);
	}

	function prepareAgentDependentParams(btnObj,popType) {
		var dStr ="",dArray;
		var flag = true;
		if(popType=='agentCode'){
			dArray = new Array('agentStatusCtx');
			for (var k=0;k<dArray.length ;k++ ){
				var objVal=btnObj.attr(dArray[k]);
				if(objVal == undefined || objVal == ""){
					//do nothing
				}else{
					if(flag){
						dStr+="?dependents["+dArray[k]+"]="+objVal;
						flag = false;
					}else{
						dStr+="&dependents["+dArray[k]+"]="+objVal;
					}
				}
			}
		}else{
			dArray = new Array();
		}
		return dStr;
	}

	function prepareSalesDependentParams(btnObj,popType) {
		var dStr ="",dArray;
		var flag = true;
		if(popType=='salescode')
			dArray = new Array('agentCodeContext','customerCodeCtx', 'salesRoleCtx', 'employeeTypeReqdCtx');
		else
			dArray = new Array();
		for (var k=0;k<dArray.length ;k++ )
		{
			var objVal=btnObj.attr(dArray[k]);
			if(objVal == undefined || objVal == ""){
				//do nothing
			}else{
				if(flag){
					dStr+="?dependents["+dArray[k]+"]="+objVal;
					flag = false;
				}else{
					dStr+="&dependents["+dArray[k]+"]="+objVal;
				}
			}
		}
		return dStr;
	}
		function prepareSettleFundListParams(btnObj,popType) {
		var dStr ="",dArray;
		var flag = true;
		if(popType=='settleAccFund')
			dArray = new Array('fundCodeContext','bankCodeContext','ccyContext');
		else
			dArray = new Array();
		for (var k=0;k<dArray.length ;k++ )
		{
			var objVal=btnObj.attr(dArray[k]);
			if(objVal == undefined){
			}else{
				if(flag){
					dStr+="?"+dArray[k]+"="+objVal;
					flag = false;
				}else{
					dStr+="&"+dArray[k]+"="+objVal;
				}
			}

		}
		return dStr;
	}
		
		function prepareFininstFundListParams(btnObj,popType) {
			var dStr ="",dArray;
			var flag = true;
			if(popType=='fininstForFundPopup')
				dArray = new Array('fundCodeContext','instRoleTypeCtx');
			else
				dArray = new Array();
			for (var k=0;k<dArray.length ;k++ )
			{
				var objVal=btnObj.attr(dArray[k]);
				if(objVal == undefined){
				}else{
					if(flag){
						dStr+="?"+dArray[k]+"="+objVal;
						flag = false;
					}else{
						dStr+="&"+dArray[k]+"="+objVal;
					}
				}

			}
			return dStr;
		}
	
	function prepareOurSecCustomizedPopupParams(btnObj,popType) {
		var dStr ="",dArray;
		var flag = true;
		
		var isBrokerInternalCase = "";
		var isBrokerAccount = $("#isBrokerAccount").val();
		var settlementMode = $("#settlementMode").val();
		
		if(isBrokerAccount == "Y" && settlementMode == "INTERNAL") {
			//Set isBrokerInternalCase flag to "Y"
			isBrokerInternalCase = "Y";
		} else {
			isBrokerInternalCase = "N";
		}
						
		dArray = new Array('security','tradingAc','securityCode','deliveryMethod','ssiLayout','intermediaryInfoListName',
							'currency','settlementType','settlementFor','isBrokerInternalCase','inventoryAccountPk');
		
		for (var k=0;k<dArray.length ;k++ )
		{
			var objVal="";
			if(dArray[k] == 'security'){
				objVal = btnObj.attr(dArray[k]);
			}else if(dArray[k] == 'tradingAc'){
				objVal = $("#tradingAc").val();
			}else if(dArray[k] == 'securityCode'){
				objVal = $("#securityCode").val();
			}else if(dArray[k] == 'deliveryMethod'){
				objVal = $("#deliveryMethod").val();
			}else if(dArray[k] == 'ssiLayout'){
				objVal = $("#secSSILayout").val();
			}else if(dArray[k] == 'intermediaryInfoListName'){
				objVal = btnObj.attr(dArray[k]);
			}else if(dArray[k] == 'settlementType'){
				objVal = $("#settlementType").val();
			}else if(dArray[k] == 'settlementFor'){
				objVal = $("#csiVoSettlementFor").val();
			}else if(dArray[k] == 'isBrokerInternalCase'){
				objVal = isBrokerInternalCase;
			}
			if($('#csiVoSettlementFor').val() != "CORPORATE_ACTION") {
				if(dArray[k] == 'inventoryAccountPk'){
					objVal = $("#siVoInventoryAccountPk").val();
				}
			}
			if($('#isSuppressed').val() != "Y"){
				if(dArray[k] == 'currency'){
					objVal = $("#currency").val();
				}
			}
			
			if(objVal == undefined){
			}else{
				if(flag){
					dStr+="?"+dArray[k]+"="+objVal;
					flag = false;
				}else{
					dStr+="&"+dArray[k]+"="+objVal;
				}
			}
		}
		return dStr;
	}
	
	function prepareOurCashCustomizedPopupParams(btnObj,popType) {
		var dStr ="",dArray;
		var flag = true;
		
		var isBrokerInternalCase = "";
		var isBrokerAccount = $("#isBrokerAccount").val();
		var cashSettlementmode = $("#cashSettlementmode").val();
		
		if(isBrokerAccount == "Y" && cashSettlementmode == "INTERNAL") {
			//Set isBrokerInternalCase flag to "Y"
			isBrokerInternalCase = "Y";
		} else {
			isBrokerInternalCase = "N";
		}
						
		dArray = new Array('cash','tradingAc','currency','ssiLayout','intermediaryInfoListName','settlementType','settlementFor','isBrokerInternalCase','inventoryAccountPk',
							'securityCode','deliveryMethod');
		
		for (var k=0;k<dArray.length ;k++ )
		{
			var objVal="";
			if(dArray[k] == 'cash'){
				objVal = btnObj.attr(dArray[k]);
			}else if(dArray[k] == 'tradingAc'){
				objVal = $("#tradingAc").val();
			}else if(dArray[k] == 'currency'){
				objVal = $("#currency").val();
			}else if(dArray[k] == 'ssiLayout'){
				objVal = $("#cashSSILayout").val();
			}else if(dArray[k] == 'intermediaryInfoListName'){
				objVal = btnObj.attr(dArray[k]);
			}else if(dArray[k] == 'settlementType'){
				objVal = $("#settlementType").val();
			}else if(dArray[k] == 'settlementFor'){
				objVal = $("#csiVoSettlementFor").val();
			}else if(dArray[k] == 'isBrokerInternalCase'){
				objVal = isBrokerInternalCase;
			}
			 
			if($('#csiVoSettlementFor').val() != "CORPORATE_ACTION") {
				if(dArray[k] == 'inventoryAccountPk'){
					objVal = $("#siVoInventoryAccountPk").val();
				}
			}
			if($('#isSuppressed').val() != "Y"){
				if(dArray[k] == 'securityCode'){
					objVal = $("#securityCode").val();
				}else if(dArray[k] == 'deliveryMethod'){
					objVal = $("#deliveryMethod").val();
				}
			}
			
			if(objVal == undefined){
			}else{
				if(flag){
					dStr+="?"+dArray[k]+"="+objVal;
					flag = false;
				}else{
					dStr+="&"+dArray[k]+"="+objVal;
				}
			}
		}
		return dStr;
	}
	
	
	function prepareCpSecCustomizedPopupParams(btnObj,popType) {
		var dStr ="",dArray;
		var flag = true;
		
	
						
		dArray = new Array('security','tradingAc','securityCode','deliveryMethod','intermediaryInfoListName',
							'currency','settlementType','settlementFor');
							
		
		for (var k=0;k<dArray.length ;k++ )
		{
			var objVal="";
			if(dArray[k] == 'security'){
				objVal = btnObj.attr(dArray[k]);
				
			}else if(dArray[k] == 'tradingAc'){
				objVal = $("#tradingAc").val();
				
			}else if(dArray[k] == 'securityCode'){
				objVal = $("#securityCode").val();
				
			}else if(dArray[k] == 'deliveryMethod'){
				objVal = $("#deliveryMethod").val();
				
			}else if(dArray[k] == 'intermediaryInfoListName'){
				objVal = btnObj.attr(dArray[k]);
				
			}else if(dArray[k] == 'settlementType'){
				objVal = $("#settlementType").val();
				
			}else if(dArray[k] == 'settlementFor'){
				objVal = $("#csiVoSettlementFor").val();
				
			}
			
			if($('#isSuppressed').val() != "Y"){
				if(dArray[k] == 'currency'){
					objVal = $("#currency").val();
				}
			}
			
			if(objVal == undefined){
			}else{
				if(flag){
					dStr+="?"+dArray[k]+"="+objVal;
					flag = false;
				}else{
					dStr+="&"+dArray[k]+"="+objVal;
				}
			}
		}
		return dStr;
	}
	
	function prepareCpCashCustomizedPopupParams(btnObj,popType) {
		var dStr ="",dArray;
		var flag = true;
		
						
		dArray = new Array('cash','tradingAc','currency','intermediaryInfoListName','settlementType','settlementFor','securityCode','deliveryMethod');
		
		for (var k=0;k<dArray.length ;k++ )
		{
			var objVal="";
			if(dArray[k] == 'cash'){
				objVal = btnObj.attr(dArray[k]);
			}else if(dArray[k] == 'tradingAc'){
				objVal = $("#tradingAc").val();
			}else if(dArray[k] == 'currency'){
				objVal = $("#currency").val();
			}else if(dArray[k] == 'intermediaryInfoListName'){
				objVal = btnObj.attr(dArray[k]);
			}else if(dArray[k] == 'settlementType'){
				objVal = $("#settlementType").val();
			}else if(dArray[k] == 'settlementFor'){
				objVal = $("#csiVoSettlementFor").val();
			}
			 
			
			if($('#isSuppressed').val() != "Y"){
				if(dArray[k] == 'securityCode'){
					objVal = $("#securityCode").val();
				}else if(dArray[k] == 'deliveryMethod'){
					objVal = $("#deliveryMethod").val();
				}
			}
			
			if(objVal == undefined){
			}else{
				if(flag){
					dStr+="?"+dArray[k]+"="+objVal;
					flag = false;
				}else{
					dStr+="&"+dArray[k]+"="+objVal;
				}
			}
		}
		return dStr;
	}
	
		
	$(function () {
		//Binding Button Handler
		$('.popupBtn,.listBtn').die();
		$('.popupBtn,.listBtn').live('click', openPopUpForm);
		/* 	$('.listBtn').die();
    $('.listBtn').live('click', openPopUpForm); */

	});
});
