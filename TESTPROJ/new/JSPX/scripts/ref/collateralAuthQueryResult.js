//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
/* Setting two parameters required by the common authorization file "authQueryResult.js"
 * 1) The authorization screen specific auth id field sent as a parameter for authorization/back & rejection operations.
 * 2) The auth query result view container.
 * */
(function(){
	xenos.ns.views.authQryResult.idField = "instCollateralPk";
	xenos.ns.views.authQryResult.container = xenos.ns.views.collateralAuthQryResult.container;
})();

/*
//Mode initialization code to result page
(function(){
	// asynchronous handler to handle success action
	var xenos$Handler$Author: pallabib $Handler$function({
	  get: {
		requestType: xenos$Handler$default.requestType.asynchronous,
		target: '#content'
	  },
	  settings: {
		type: 'POST',
		beforeSend: function(request) {
		  request.setRequestHeader('Accept', 'text/html;type=ajax');
		}
	  }
	});		
	
	//Global variable declaration for grid instance
	xenos.ns.views.collateralAuthQryResult.gridInstance;
	xenos.ns.views.collateralAuthQryResult.selectedRecordsIndex;
	//reject button handler	
	$('.rejectBtn',xenos.ns.views.collateralAuthQryResult.container).find("input[disabled!='disabled']").unbind('click');
	$('.rejectBtn',xenos.ns.views.collateralAuthQryResult.container).find("input[disabled!='disabled']").bind('click',function(e){
		var context = $(e.target).closest('.formContent');
		xenos.ns.views.collateralAuthQryResult.gridInstance = $('.xenos-grid',context).data().gridInstance;
		xenos.ns.views.collateralAuthQryResult.selectedRecordsIndex = xenos.ns.views.collateralAuthQryResult.gridInstance.getSelectedRows();
		var pkForAuthorization = [];
		var authStatus= $(e.target).attr('authStatus');
		var authFlag= $(e.target).attr('authFlag');
		for(i in xenos.ns.views.collateralAuthQryResult.selectedRecordsIndex){
            pkForAuthorization.push(xenos.ns.views.collateralAuthQryResult.gridInstance.getDataItem(xenos.ns.views.collateralAuthQryResult.selectedRecordsIndex[i]).instCollateralPk);
        }
		if(xenos.ns.views.collateralAuthQryResult.selectedRecordsIndex.length == 0){
			xenos.utils.displayGrowlMessage(xenos.notice.type.error, xenos$REF$i18n.dashboard.no_record_found);
            return;
        }
		if(authStatus=='REJECTED'){
			xenos.utils.displayGrowlMessage(xenos.notice.type.error, xenos$REF$i18n.dashboard.no_record_for_rejection);
			return;
		}
		else if(authStatus=='AUTHORIZED'){
			xenos.utils.displayGrowlMessage(xenos.notice.type.error, xenos$REF$i18n.authorization.common.no_record_for_authorization);
			return;
		}
		var btn = $(e.target);
		var container = $("#content");
		$(e.target).attr('disabled', 'disabled');
		$('.authorizeBtn').find("input[type='button']").attr('disabled', 'disabled');
		e.preventDefault();
		var form = $('#queryResultForm',container);
		var commandFormId = 'commandFormId=' + $('[name=commandFormId]',container).val();
		var fragmentName = '&fragments=content';
		var authCategory = '&authorizationCategory=' ;
		var consolidateAuthAction = $('#consolidateAuthAct').find('a.reject');
		if(consolidateAuthAction.length > 0){
			authCategory=authCategory+'rejected';
		}else{
			authCategory=authCategory+'selfrejected';
		}
		console.log("authCategory::"+authCategory);
		$.ajax({
			type: "POST",
			url: xenos.context.path + form.attr('action').replace('back','validate.json') + "?" + xenos.context.updateMenuParam + "&" + commandFormId + authCategory ,
			data: {
				// bulk PK(s)
				pkForAuthorization : JSON.stringify(pkForAuthorization)
			},
			beforeSend: function (req) {
				req.setRequestHeader("Accept", "application/json;type=ajax");
			},
			success: function (data) {
			
					// if online closed then return back
					// callee takes the responsibility to show the error message
					if(xenos.context.isOnlineAccessRestricted(data)) {
						// re-activate button
						btn.removeAttr('disabled');
						$('.authorizeBtn').find("input[type='button']").removeAttr('disabled');
						return;
					}
					
					if(data.isTrue){
						url = xenos.context.path + form.attr('action').replace('back','result') + "?" + commandFormId + fragmentName + authCategory,
						xenos$Handler$AuthorizationLinkHandler.generic(undefined, {requestUri: url,settings: {data: {pkForAuthorization:JSON.stringify(pkForAuthorization)}},
                            onHtmlContent: function (e, options, $target, content) {
                                btn.removeAttr('disabled');
                                $('.authorizeBtn').find("input[type='button']").removeAttr('disabled');
                                container.html(content);
                                //Chek the return page if return page equal query result then render grid.
                                if(authFlag=='false'){
                                    $('.tabs',xenos.ns.views.collateralAuthQryResult.container).hide();	
                                }
                                if ($('.xenos-grid',container).length > 0) {
                                    $('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
                                    if(authFlag=='false'){
                                        $('.btnsArea').hide();
                                    }
                                }
                                if(xenos.ns.views.collateralAuthQryResult.gridInstance){
                                    xenos.ns.views.collateralAuthQryResult.gridInstance.destroy();
                                }
                            }
						});
					}else{
						btn.removeAttr('disabled');
						$('.authorizeBtn').find("input[type='button']").removeAttr('disabled');
						if(!data.success){
							xenos.utils.displayGrowlMessage(xenos.notice.type.error, data.value);
						}
						if(data.msg){
							xenos.utils.displayGrowlMessage(xenos.notice.type.error, data.msg);
						}
					}
			},
			error: function (xhr, ajaxOptions, thrownError) {
				if(xhr.status == '403') {
					btn.removeAttr('disabled');
					$('.rejectBtn').find("input[type='button']").removeAttr('disabled');
				}
			}
		});
	});
	
	// This is a common handler for the Authorize as well as  Back button
	$('.authorizeBtn',xenos.ns.views.collateralAuthQryResult.container).find("input[disabled!='disabled']").unbind('click');
	$('.authorizeBtn',xenos.ns.views.collateralAuthQryResult.container).find("input[disabled!='disabled']").bind('click',function(e){
		var context = $(e.target).closest('.formContent');	
		var authFlag= $(e.target).attr('authFlag');
		var authStatus= $(e.target).attr('authStatus');
		var preservePkForAuthorization= $(e.target).attr('preservePk');
		preservePkForAuthorization = preservePkForAuthorization.split(',');
		var pkForAuthorization = [];
		xenos.ns.views.collateralAuthQryResult.gridInstance = $('.xenos-grid',context).data().gridInstance;
		if(authFlag=='false'){
			xenos.ns.views.collateralAuthQryResult.selectedRecordsIndex = xenos.ns.views.collateralAuthQryResult.gridInstance.getSelectedRows();
			for(i in xenos.ns.views.collateralAuthQryResult.selectedRecordsIndex){
				pkForAuthorization.push(xenos.ns.views.collateralAuthQryResult.gridInstance.getDataItem(xenos.ns.views.collateralAuthQryResult.selectedRecordsIndex[i]).instCollateralPk);
			}
			if(xenos.ns.views.collateralAuthQryResult.selectedRecordsIndex.length == 0){
				xenos.utils.displayGrowlMessage(xenos.notice.type.error, xenos$REF$i18n.authorization.common.empty_record);
				return;
			}
		}
		if(authStatus=='REJECTED'){
			xenos.utils.displayGrowlMessage(xenos.notice.type.error, xenos$REF$i18n.authorization.common.rejected_record);
			return;
		}
		else if(authStatus=='AUTHORIZED'){
			xenos.utils.displayGrowlMessage(xenos.notice.type.error, xenos$REF$i18n.authorization.common.authorized_records);
			return;
		}
		var btn = $(e.target);
		var container = $("#content");
		$(e.target).attr('disabled', 'disabled');
		$('.rejectBtn').find("input[type='button']").attr('disabled', 'disabled');
		$('.submitAuthorizationBtn').find("input[type='button']").attr('disabled', 'disabled');
		e.preventDefault();
		var form = $('#queryResultForm',container);
		var commandFormId = 'commandFormId=' + $('[name=commandFormId]',container).val();
		var fragmentName = '&fragments=content';
		var authCategory = '';
		if(authFlag == 'false'){
			authCategory = '&authorizationCategory=' + (btn.data('authorizationCategory') || 'authorized');
		}
		$.ajax({
			type: "POST",
			url: xenos.context.path + form.attr('action').replace('back','validate.json') + "?" + xenos.context.updateMenuParam + "&" + commandFormId + authCategory ,
			data: {
				// bulk PK(s)
				pkForAuthorization : JSON.stringify(pkForAuthorization)
			},
			beforeSend: function (req) {
				req.setRequestHeader("Accept", "application/json;type=ajax");
			},
			success: function (data) {
			
					// if online closed then return back
					// callee takes the responsibility to show the error message
					if(xenos.context.isOnlineAccessRestricted(data)) {
						// re-activate button
						btn.removeAttr('disabled');
						$('.rejectBtn').find("input[type='button']").removeAttr('disabled');
						$('.submitAuthorizationBtn').find("input[type='button']").removeAttr('disabled');
						return;
					}
					
					if(data.isTrue){
						url = xenos.context.path + form.attr('action').replace('back','result') + "?" + commandFormId + fragmentName + authCategory,
						xenos$Handler$AuthorizationLinkHandler.generic(undefined, {requestUri: url,settings: {data: {pkForAuthorization:JSON.stringify(pkForAuthorization)}},
                            onHtmlContent: function (e, options, $target, content) {
                                btn.removeAttr('disabled');
                                $('.rejectBtn').find("input[type='button']").removeAttr('disabled');
                                $('.submitAuthorizationBtn').find("input[type='button']").removeAttr('disabled');
                                container.html(content);
                                //Chek the return page if return page equal query result then render grid.
                                if(authFlag=='false'){
                                    $('.tabs',xenos.ns.views.collateralAuthQryResult.container).hide();	
                                }
                                if ($('.xenos-grid',container).length > 0) {
                                    jQuery.removeData(btn, "authorizationCategory");
                                    var xenosgrid = $('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
                                    if(authFlag=='false'){
                                        $('.btnsArea').hide();
                                    }
                                    if (xenosgrid) {
                                        if (authFlag == 'true') {
                                            setTimeout(function() {
                                                var fullData = xenosgrid.getData().getItems();
                                                var rows = [];
                                                for (i=0 ; i< xenosgrid.getDataLength() ; i++){
                                                    var rowData = fullData[i];
                                                    if(rowData){
                                                        if($.inArray(rowData['instCollateralPk'], preservePkForAuthorization) != -1){
                                                            rows.push(i);
                                                        }
                                                    }
                                                }
                                                xenosgrid.setSelectedRows(rows);
                                            }, 10);
                                        }
                                    }
                                }
                                if(xenos.ns.views.collateralAuthQryResult.gridInstance){
                                    xenos.ns.views.collateralAuthQryResult.gridInstance.destroy();
                                }
                            }
						});
					}else{		
							btn.removeAttr('disabled');
							$('.rejectBtn').find("input[type='button']").removeAttr('disabled');
							$('.submitAuthorizationBtn').find("input[type='button']").removeAttr('disabled');
							if(!data.success){
								xenos.utils.displayGrowlMessage(xenos.notice.type.error, data.value);
							}
							if(data.msg){
								xenos.utils.displayGrowlMessage(xenos.notice.type.error, data.msg);
							}						
					}
			},
			error: function (xhr, ajaxOptions, thrownError) {
				if(xhr.status == '403') {
					btn.removeAttr('disabled');
					$('.rejectBtn').find("input[type='button']").removeAttr('disabled');
				}
			}
		});
	});

})();*/