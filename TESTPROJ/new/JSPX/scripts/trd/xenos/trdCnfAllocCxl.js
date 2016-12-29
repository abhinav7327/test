//$Id$
//$Author: jayabratas $
//$Date: 2016-12-27 14:53:12 $
var xenos$Handler$trdCnfAllocCxl = xenos$Handler$function({
	get : {
		requestType : xenos$Handler$default.requestType.asynchronous,
		target : '#content'
		
	},
	settings : {
		beforeSend : function(request) {
			request.setRequestHeader('Accept', 'text/html;type=ajax');
			
		},
		type: 'POST'
	},
	callback : {
		success : function(evt, options) {
			if (options) {
				$.each(options['gridInstance'] || [], function(ind, grid) {
					grid.destroy();
				});
			}
		}
	}
});

xenos.ns.trdCnfAllocCxl.submithandler = function(e) {

	
	var $target = $(this);
	var gridInstanceArray = [];
	var context = $target.closest('.formContent');
	var reqObj = {};
	var uri = xenos.context.path;
	
	
	var grid = $('.xenos-grid', context).data("gridInstance");
	if (typeof grid == "undefined") {
		return false;
	}
	var gridData = grid.getData().getItems();
	uri += "/secure/trd/conf/matching/query/allocCxl";

	
	xenos.ns.trdCnfAllocCxl.selectedRecordsIndex = [];
	var selectedGrid = grid.getSelectedRows();
	var isChecked = false;	
	var lngth = selectedGrid.length;
	var selector = [];
	

	if (typeof gridData == "undefined") {
		return false;
	}
	var reqObj = {};
	var validationMessages = [];
	if (selectedGrid.length == 0) {
		validationMessages.push(xenos$TRD$i18n.trdCnfAllocCxl.no_record_selected);
	}
	
	else{		
			for (i = 0; i < lngth; i++) {
		
			if (!isChecked) {
				isChecked = true;
				}
			if(gridData[selectedGrid[i]]['status'] == 'CANCEL')
			{
				validationMessages.push(xenos$TRD$i18n.trdCnfAllocCxl.cxl_record_selected);
				$('.formHeader').find('.formTabErrorIco').css('display', 'block');
				$('.formHeader').find('.formTabErrorIco').off('click');
				$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
				return false;
			}
			
			if(gridData[selectedGrid[i]]['matchStatusDisp'] == 'Confirmed' || gridData[selectedGrid[i]]['matchStatusDisp'] == 'Manual' || gridData[selectedGrid[i]]['matchStatusDisp'] == 'Auto' || gridData[selectedGrid[i]]['matchStatusDisp'] == 'Manual(Multi)' || gridData[selectedGrid[i]]['matchStatusDisp'] == 'Auto(Multi)'){
				validationMessages.push(xenos$TRD$i18n.trdCnfAllocCxl.cnf_record_selected);
				$('.formHeader').find('.formTabErrorIco').css('display', 'block');
				$('.formHeader').find('.formTabErrorIco').off('click');
				$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
				return false;
			}
			
			if(gridData[selectedGrid[i]]['allocationConfirmationFlag'] == 'C'){
				validationMessages.push(xenos$TRD$i18n.trdCnfAllocCxl.cnf_trd_record_selected);
				$('.formHeader').find('.formTabErrorIco').css('display', 'block');
				$('.formHeader').find('.formTabErrorIco').off('click');
				$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
				return false;
			}
			
			
			else{
					selector.push(gridData[selectedGrid[i]]['rowID']);
					xenos.ns.trdCnfAllocCxl.selectedRecordsIndex.push(gridData[selectedGrid[i]]['rowID']);
				}
	}
				selector.push(-1);
				
	}
	if (validationMessages.length > 0) {
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
		return false;
	}
	
	var container = $("#content");
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&fragments=content';
	var context = $target.closest('#content');
	var requestUrl = xenos.context.path + "/secure/trd/conf/matching/query" + "/allocCxl"+commandFormId+fragmentName;
	$(e.target).attr('disabled', true);
	
	xenos$Handler$trdCnfAllocCxl
			.generic(
					e,
					{
						requestUri : requestUrl,
						settings : {
							data : jQuery
									.param(
											{
												fragments : 'content',
												selector : selector
											}, true),
							complete: function() {
													
													$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
													$('.tabArea').hide();
													}			
						},
						onHtmlContent : function(e, options, $target, content) {
									$target.html(content);
						}
					}
					);
	
};


xenos.ns.trdCnfAllocCxl.backhandler = function(e) {

	var $target = $(this);
	var gridInstanceArray = [];
	var context = $target.closest('.formContent');
	var reqObj = {};
	var uri = xenos.context.path;

	uri += "/secure/trd/conf/matching/query/UCback";

	

	var reqObj = {};
	var container = $("#content");
	var form = $('#queryResultForm', container);
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&fragments=content';
	var context = $target.closest('#content');
	var requestUrl = xenos.context.path + "/secure/trd/conf/matching/query" + "/backToResult"+commandFormId+fragmentName;
	$(e.target).attr('disabled', true);
	
	xenos$Handler$trdCnfAllocCxl
			.generic(
					e,
					{
						requestUri : requestUrl,
						settings : {
							type: "POST",
							complete: function (jqXHR) {
									$target.removeAttr('disabled');
									var gridInstanceArray = [];
									var grids = $("[class*=slickgrid_]", form);
									$.each(grids, function (ind, grid) {
										var gridObject = $(grid).data("gridInstance");
										if(typeof gridObject !== 'undefined')
										gridInstanceArray.push(gridObject);
									});
									container.html(jqXHR.responseText);
									//Check the return page if return page equal query result then render grid.
									if ($('#queryForm', container).length == 0) {
										$('#queryResultForm .xenos-grid', container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);	
										var grid = $('.xenos-grid',container).data().gridInstance;
										grid.setSelectedRows(xenos.ns.trdCnfAllocCxl.selectedRecordsIndex);
										$.each(gridInstanceArray || [], function (ind, grid) {						
											grid.destroy();
											delete grid;
										});
									}
								}

							},
						
						onHtmlContent : function(e, options, $target, content) {
									$target.html(content);
						}
					}
					);
	
};

xenos.ns.trdCnfAllocCxl.confirmhandler = function(e) {
	
	e.preventDefault();
	var $target = $(this);
	var context = $target.closest('.formContent');
	var uri = xenos.context.path;

	uri += "/secure/trd/conf/matching/query/confirm";
	
	var validationMessages = [];
	if ($("#remarks").val() == '' && $("#reasonCode").val() == '') {
		validationMessages.push(xenos$TRD$i18n.trdCnfAllocCxl.no_remarks);
	}
	
	if (validationMessages.length > 0) {
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
		return false;
	}

	
	var container = $("#content");
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&fragments=content';
	var context = $target.closest('#content');
	var requestUrl = xenos.context.path + "/secure/trd/conf/matching/query" + "/CancelConfirm"+commandFormId+fragmentName;			
	$(e.target).attr('disabled', true);
	
	var remarks = $("#remarks").val();
	var reasonCode = $("#reasonCode").val();
	
	xenos$Handler$trdCnfAllocCxl
			.generic(
					e,
					{
						requestUri : requestUrl,
						settings : {
						
							type : "POST",
							data : jQuery
									.param(
											{
												fragments : 'content',
												reasonCode : reasonCode,
												remarks : remarks
											}, true),
											
							complete: function() {$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);}				
						},
						onHtmlContent : function(e, options, $target, content) {
									$target.html(content);
						}
					}
					);
	
};

xenos.ns.trdReject.submithandler = function(e) {

	
	var $target = $(this);
	var gridInstanceArray = [];
	var context = $target.closest('.formContent');
	var reqObj = {};
	var uri = xenos.context.path;
	xenos.ns.trdCnfAllocCxl.selectedRecordsIndex = [];
	
	var rcvCnfPk ;  
	var confirmationTradePk ;
	var fundAccNoStr ;
	var grid = $('.xenos-grid', context).data("gridInstance");
	if (typeof grid == "undefined") {
		return false;
	}
	var gridData = grid.getData().getItems();

	var selectedGrid = grid.getSelectedRows();
	var isChecked = false;	
	var lngth = selectedGrid.length;
	

	if (typeof gridData == "undefined") {
		return false;
	}
	var reqObj = {};
	var validationMessages = [];
	if (selectedGrid.length == 0) {
		validationMessages.push(xenos$TRD$i18n.trdReject.no_record_selected);
	}
	
	if (selectedGrid.length > 1) {
		validationMessages.push(xenos$TRD$i18n.trdReject.multiple_record_selected);
	}
	
	else{		
			for (i = 0; i < lngth; i++) {
		
			if (!isChecked) {
				isChecked = true;
				}
			
			if(gridData[selectedGrid[i]]['matchStatusDisp'] == 'Confirmed'){
				validationMessages.push(xenos$TRD$i18n.trdReject.confirmed_trade_selected);
				$('.formHeader').find('.formTabErrorIco').css('display', 'block');
				$('.formHeader').find('.formTabErrorIco').off('click');
				$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
				return false;
			}
			
			if(gridData[selectedGrid[i]]['matchStatusDisp'] != '' && gridData[selectedGrid[i]]['matchStatusDisp'] != null){
			if(gridData[selectedGrid[i]]['matchStatusDisp'] != 'Reject'){
				validationMessages.push(xenos$TRD$i18n.trdReject.matched_trade_selected);
				$('.formHeader').find('.formTabErrorIco').css('display', 'block');
				$('.formHeader').find('.formTabErrorIco').off('click');
				$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
				return false;
			}
			
			else
			{
				validationMessages.push(xenos$TRD$i18n.trdReject.rejected_trade_selected);
				$('.formHeader').find('.formTabErrorIco').css('display', 'block');
				$('.formHeader').find('.formTabErrorIco').off('click');
				$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
				return false;
			
			}
			}	
			if(gridData[selectedGrid[i]]['status'] == 'CANCEL')
			{
				validationMessages.push(xenos$TRD$i18n.trdReject.cxl_record_selected);
				$('.formHeader').find('.formTabErrorIco').css('display', 'block');
				$('.formHeader').find('.formTabErrorIco').off('click');
				$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
				return false;
			}
	
			if(gridData[selectedGrid[i]]['allocationConfirmationFlag'] == null){
				validationMessages.push(xenos$TRD$i18n.trdReject.select_unmatched_conf_trade);
				$('.formHeader').find('.formTabErrorIco').css('display', 'block');
				$('.formHeader').find('.formTabErrorIco').off('click');
				$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
				return false;
			}
			
			if(gridData[selectedGrid[i]]['allocationConfirmationFlag'] != 'C'){
				validationMessages.push(xenos$TRD$i18n.trdReject.allocation_trade_selected);
				$('.formHeader').find('.formTabErrorIco').css('display', 'block');
				$('.formHeader').find('.formTabErrorIco').off('click');
				$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
				return false;
			}
			
			if(gridData[selectedGrid[i]]['originalDataSource'] == 'SCREEN'){
				validationMessages.push(xenos$TRD$i18n.trdReject.datascr_screen);
				$('.formHeader').find('.formTabErrorIco').css('display', 'block');
				$('.formHeader').find('.formTabErrorIco').off('click');
				$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
				return false;
			}
			
			
			else{
					rcvCnfPk =  gridData[selectedGrid[i]]['receivedConfirmationPk'];  
					confirmationTradePk = gridData[selectedGrid[i]]['tradePk'];
					fundAccNoStr = gridData[selectedGrid[i]]['fundAccountNo'];
					xenos.ns.trdCnfAllocCxl.selectedRecordsIndex.push(gridData[selectedGrid[i]]['rowID']);
				}
				}
	}			
	
	if (validationMessages.length > 0) {
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
		return false;
	}
	
	var container = $("#content");
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&fragments=content';
	var context = $target.closest('#content');
	var requestUrl = xenos.context.path + "/secure/trd/conf/matching/query" + "/reject"+commandFormId+fragmentName;
	$(e.target).attr('disabled', true);
	
	xenos$Handler$trdCnfAllocCxl
			.generic(
					e,
					{
						requestUri : requestUrl,
						settings : {
							data : jQuery
									.param(
											{
												fragments : 'content',
												receivedConfirmationPk : rcvCnfPk,  
												confirmationTradePk : confirmationTradePk,
												fundAccNo : fundAccNoStr 
											}, true),
							complete: function() {
													$('.tabArea').hide();
													}			
						},
						onHtmlContent : function(e, options, $target, content) {
									$target.html(content);
						}
					}
					);
	
};

xenos.ns.trdReject.confirmhandler = function(e) {
	
	e.preventDefault();
	var $target = $(this);
	var context = $target.closest('.formContent');
	var uri = xenos.context.path;
	
	var container = $("#content");
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&fragments=content';
	var context = $target.closest('#content');
	var requestUrl = xenos.context.path + "/secure/trd/conf/matching/query" + "/RejectConfirm"+commandFormId+fragmentName;			
	$(e.target).attr('disabled', true);
	
	var narrative = $("#narrative").val();
	var receivedConfirmationPk = $("#receivedConfirmationPk").val();
	var confirmationTradePk = $("#confirmationTradePk").val();
	var fundAccNo = $("#fundAccNo").val();
	
	xenos$Handler$trdCnfAllocCxl
			.generic(
					e,
					{
						requestUri : requestUrl,
						settings : {
						
							type : "POST",
							data : jQuery
									.param(
											{
												fragments : 'content',
												narrative : narrative,
												receivedConfirmationPk : receivedConfirmationPk,
												confirmationTradePk : confirmationTradePk,
												fundAccNo : fundAccNo,
												RUI : 'RUI'
											}, true),
							complete: function() {$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);}			
						},
						onHtmlContent : function(e, options, $target, content) {
									$target.html(content);
						}
					}
					);
	
};

xenos.ns.trdMatch.submithandler = function(e) {

	
	var $target = $(this);
	var gridInstanceArray = [];
	var context = $target.closest('.formContent');
	var reqObj = {};
	var uri = xenos.context.path;
	
	
	var grid = $('.xenos-grid', context).data("gridInstance");
	if (typeof grid == "undefined") {
		return false;
	}
	var gridData = grid.getData().getItems();
	uri += "/secure/trd/conf/matching/query/allocCxl";

	
	xenos.ns.trdCnfAllocCxl.selectedRecordsIndex = [];
	var selectedGrid = grid.getSelectedRows();
	var isChecked = false;	
	var lngth = selectedGrid.length;
	var selector = [];
	var isAllocSelected = false;
	var confCount = 0;
	var isMatchable = false;
	var rcvCnfPk;
	var allocConfFlag;
	var confirmationTradePk;
	var fundAccNoStr;
	
	
	if (typeof gridData == "undefined") {
		return false;
	}
	var reqObj = {};
	var validationMessages = [];
	if (selectedGrid.length == 0) {
		validationMessages.push(xenos$TRD$i18n.trdMatch.no_record_selected);
	}
	
	else{		
			for (i = 0; i < lngth; i++) {
		
			if (!isChecked) {
				isChecked = true;
				}
			if(gridData[selectedGrid[i]]['status'] == 'CANCEL')
			{
				validationMessages.push(xenos$TRD$i18n.trdMatch.cxl_record_selected);
				$('.formHeader').find('.formTabErrorIco').css('display', 'block');
				$('.formHeader').find('.formTabErrorIco').off('click');
				$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
				return false;
			}
			
			if(gridData[selectedGrid[i]]['matchStatusDisp'] == 'Reject'){
				validationMessages.push(xenos$TRD$i18n.trdMatch.reject_record_selected);
				$('.formHeader').find('.formTabErrorIco').css('display', 'block');
				$('.formHeader').find('.formTabErrorIco').off('click');
				$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
				return false;
			}
			
			if(gridData[selectedGrid[i]]['matchStatusDisp'] == 'Confirmed'){
				validationMessages.push(xenos$TRD$i18n.trdMatch.cnf_record_selected);
				$('.formHeader').find('.formTabErrorIco').css('display', 'block');
				$('.formHeader').find('.formTabErrorIco').off('click');
				$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
				return false;
			}
			
			if(gridData[selectedGrid[i]]['matchStatusDisp'] != '' && gridData[selectedGrid[i]]['matchStatusDisp'] != null){
				validationMessages.push(xenos$TRD$i18n.trdMatch.matched_record_selected);
				$('.formHeader').find('.formTabErrorIco').css('display', 'block');
				$('.formHeader').find('.formTabErrorIco').off('click');
				$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
				return false;
			}
			
			if(selectedGrid.length == 1)
			{
				isMatchable = true;
			}
	
			else{
					if(gridData[selectedGrid[i]]['allocationConfirmationFlag'] == 'A')
					{
						isAllocSelected = true;
					}
					else if(gridData[selectedGrid[i]]['allocationConfirmationFlag'] == 'C')
					{
						confCount++;
					}
				}
			selector.push(gridData[selectedGrid[i]]['rowID']);
			xenos.ns.trdCnfAllocCxl.selectedRecordsIndex.push(gridData[selectedGrid[i]]['rowID']);
		
		}
		if(confCount > 0 && !isAllocSelected){
			validationMessages.push(xenos$TRD$i18n.trdMatch.multiple_cnf_trd_selected);
			$('.formHeader').find('.formTabErrorIco').css('display', 'block');
			$('.formHeader').find('.formTabErrorIco').off('click');
			$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
			return false;
		}
		if(confCount > 0 && isAllocSelected){
			validationMessages.push(xenos$TRD$i18n.trdMatch.allc_cnf_record_selected);
			$('.formHeader').find('.formTabErrorIco').css('display', 'block');
			$('.formHeader').find('.formTabErrorIco').off('click');
			$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
			return false;
		}
		if(confCount == 0 && isAllocSelected){
 	 		isMatchable = true;
 	 		}
				
	}
	if (validationMessages.length > 0) {
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
		return false;
	}
	
	if(isMatchable)
	{
		rcvCnfPk = gridData[selectedGrid[0]]['receivedConfirmationPk'];
        allocConfFlag = gridData[selectedGrid[0]]['allocationConfirmationFlag'];
        confirmationTradePk = gridData[selectedGrid[0]]['tradePk'];
        fundAccNoStr = gridData[selectedGrid[0]]['fundAccNo'];
	}
	
	
	
	var container = $("#content");
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&fragments=content';
	var context = $target.closest('#content');
	var requestUrl = xenos.context.path + "/secure/trd/conf/matching/query" + "/match"+commandFormId+fragmentName;
	$(e.target).attr('disabled', true);
	
	xenos$Handler$trdCnfAllocCxl
			.generic(
					e,
					{
						requestUri : requestUrl,
						settings : {
							data : jQuery
									.param(
											{
												fragments : 'content',
												selector : selector,
												allocationConfirmationFlag : allocConfFlag,
												fundAccountNo : fundAccNoStr
											}, true),
							complete: function() {
													$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
													$('.tabArea').hide();
													}			
						},
						onHtmlContent : function(e, options, $target, content) {
									$target.html(content);
						}
					}
					);
	
};

xenos.ns.trdMatch.confirmhandler = function(e) {

	e.preventDefault();
	var $target = $(this);
	var gridInstanceArray = [];
	var context = $target.closest('.formContent');
	var reqObj = {};
	var uri = xenos.context.path;
	
	
	var grid = $('.xenos-grid', context).data("gridInstance");
	if (typeof grid == "undefined") {
		return false;
	}
	var gridData = grid.getData().getItems();
	uri += "/secure/trd/conf/matching/query/allocCxl";

	
	xenos.ns.trdCnfAllocCxl.selectForConfirm = [];
	var selectedGrid = grid.getSelectedRows();
	var isChecked = false;	
	var lngth = selectedGrid.length;
	var matchSelector = [];
	var isAllocSelected = false;
	var confCount = 0;
	var isMatchable = false;
	var rcvCnfPk;
	var allocConfFlag;
	var confirmationTradePk;
	var fundAccNoStr;
	
	
	if (typeof gridData == "undefined") {
		return false;
	}
	var reqObj = {};
	var validationMessages = [];
	if (selectedGrid.length == 0) {
		validationMessages.push(xenos$TRD$i18n.trdMatch.no_trade_selected);
	}
	
	else{	
			
			for (i = 0; i < lngth; i++) {
		
			if (!isChecked) {
				isChecked = true;
				}
			matchSelector.push(gridData[selectedGrid[i]]['rowID']);
			xenos.ns.trdCnfAllocCxl.selectForConfirm.push(gridData[selectedGrid[i]]['rowID']);
			}
		}
	if (validationMessages.length > 0) {
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
		return false;
	}

	var container = $("#content");
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&fragments=content';
	var form = $('#queryResultForm', container);
	var context = $target.closest('#content');
	var requestUrl = xenos.context.path + "/secure/trd/conf/matching/query" + "/confirmMatch"+commandFormId+fragmentName;
	$(e.target).attr('disabled', true);
	
	xenos$Handler$trdCnfAllocCxl
			.generic(
					e,
					{
						requestUri : requestUrl,
						settings : {
							data : jQuery
									.param(
											{
												fragments : 'content',
												matchSelector : matchSelector
											}, true),
							complete: function(jxhrx){
									$target.removeAttr('disabled');
									var gridInstanceArray = [];
									var grids = $("[class*=slickgrid_]", form);
									$.each(grids, function (ind, grid) {
										var gridObject = $(grid).data("gridInstance");
										if(typeof gridObject !== 'undefined')
										gridInstanceArray.push(gridObject);
									});
									container.html();
									//Check the return page if return page equal query result then render grid.
									if ($('#queryForm', container).length == 0) {
										$('.tabArea').hide();
										$('#queryResultForm .xenos-grid', container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);	
										var grid = $('.xenos-grid',container).data().gridInstance;
										if(status == 'false'){
										grid.setSelectedRows(xenos.ns.trdCnfAllocCxl.selectForConfirm);
										$.each(gridInstanceArray || [], function (ind, grid) {						
											grid.destroy();
											delete grid;
										});
										status = '';
										}
										
									}
								}			
						},
						onHtmlContent : function(e, options, $target, content) {
									$target.html(content);
						}
					}
					);
	
};

xenos.ns.trdMatch.finalhandler = function(e) {
	
	e.preventDefault();
	var $target = $(this);
	var context = $target.closest('.formContent');
	var uri = xenos.context.path;
	
	var container = $("#content");
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&fragments=content';
	var context = $target.closest('#content');
	var requestUrl = xenos.context.path + "/secure/trd/conf/matching/query" + "/finalMatch"+commandFormId+fragmentName;			
	$(e.target).attr('disabled', true);
	
	xenos$Handler$trdCnfAllocCxl
			.generic(
					e,
					{
						requestUri : requestUrl,
						settings : {
						
							type : "POST",
							data : jQuery
									.param(
											{
												fragments : 'content'
											}, true),
											
							complete: function() {
													$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
													$('.tabArea').hide();
													}				
						},
						onHtmlContent : function(e, options, $target, content) {
									$target.html(content);
						}
					}
					);
	
};

xenos.ns.trdMatch.okhandler = function(e) {

	var $target = $(this);
	var context = $target.closest('.formContent');
	var uri = xenos.context.path;
	
	var container = $("#content");
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&fragments=content';
	var context = $target.closest('#content');
	var requestUrl = xenos.context.path + "/secure/trd/conf/matching/query" + "/ok"+commandFormId+fragmentName;			
	$(e.target).attr('disabled', true);
	
	xenos$Handler$trdCnfAllocCxl
			.generic(
					e,
					{
						requestUri : requestUrl,
						settings : {
						
							type : "POST",
							data : jQuery
									.param(
											{
												fragments : 'content',
												fundAccountNo : ''
											}, true),
											
							complete: function() {
													$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
													}				
						},
						onHtmlContent : function(e, options, $target, content) {
									$target.html(content);
						}
					}
					);
	
};

xenos.ns.trdMatch.backhandler = function(e) {

	var $target = $(this);
	var gridInstanceArray = [];
	var context = $target.closest('.formContent');
	var reqObj = {};
	var uri = xenos.context.path;

	uri += "/secure/trd/conf/matching/query/UCback";

	

	var reqObj = {};
	var container = $("#content");
	var form = $('#queryResultForm', container);
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&fragments=content';
	var context = $target.closest('#content');
	var requestUrl = xenos.context.path + "/secure/trd/conf/matching/query" + "/queryBack"+commandFormId+fragmentName;
	$(e.target).attr('disabled', true);
	
	xenos$Handler$trdCnfAllocCxl
			.generic(
					e,
					{
						requestUri : requestUrl,
						settings : {
							type: "POST",
							complete: function (jqXHR) {
									$target.removeAttr('disabled');
									var gridInstanceArray = [];
									var grids = $("[class*=slickgrid_]", form);
									$.each(grids, function (ind, grid) {
										var gridObject = $(grid).data("gridInstance");
										if(typeof gridObject !== 'undefined')
										gridInstanceArray.push(gridObject);
									});
									container.html(jqXHR.responseText);
									//Check the return page if return page equal query result then render grid.
									if ($('#queryForm', container).length == 0) {
										$('#queryResultForm .xenos-grid', container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);	
										var grid = $('.xenos-grid',container).data().gridInstance;
										grid.setSelectedRows(xenos.ns.trdCnfAllocCxl.selectedRecordsIndex);
										$.each(gridInstanceArray || [], function (ind, grid) {						
											grid.destroy();
											delete grid;
										});
									}
								}

							},
						
						onHtmlContent : function(e, options, $target, content) {
									$target.html(content);
						}
					}
					);
	
};

xenos.ns.trdMatch.UCbackhandler = function(e) {

	var $target = $(this);
	var gridInstanceArray = [];
	var context = $target.closest('.formContent');
	var reqObj = {};
	var uri = xenos.context.path;

	uri += "/secure/trd/conf/matching/query/UCback";

	

	var reqObj = {};
	var container = $("#content");
	var form = $('#queryResultForm', container);
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&fragments=content';
	var context = $target.closest('#content');
	var requestUrl = xenos.context.path + "/secure/trd/conf/matching/query" + "/userConfBack"+commandFormId+fragmentName;
	$(e.target).attr('disabled', true);
	
	xenos$Handler$trdCnfAllocCxl
			.generic(
					e,
					{
						requestUri : requestUrl,
						settings : {
							type: "POST",
							complete: function (jqXHR) {
									$target.removeAttr('disabled');
									var gridInstanceArray = [];
									var grids = $("[class*=slickgrid_]", form);
									$.each(grids, function (ind, grid) {
										var gridObject = $(grid).data("gridInstance");
										if(typeof gridObject !== 'undefined')
										gridInstanceArray.push(gridObject);
									});
									container.html(jqXHR.responseText);
									//Check the return page if return page equal query result then render grid.
									if ($('#queryForm', container).length == 0) {
										$('#queryResultForm .xenos-grid', container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);	
										var grid = $('.xenos-grid',container).data().gridInstance;
										grid.setSelectedRows(xenos.ns.trdCnfAllocCxl.selectForConfirm);
										$.each(gridInstanceArray || [], function (ind, grid) {						
											grid.destroy();
											delete grid;
										});
									}
								}

							},
						
						onHtmlContent : function(e, options, $target, content) {
									$target.html(content);
						}
					}
					);
	
};

xenos.ns.trdUnmatch.submithandler = function(e) {

	
	var $target = $(this);
	var gridInstanceArray = [];
	var context = $target.closest('.formContent');
	var reqObj = {};
	var uri = xenos.context.path;
	
	
	var grid = $('.xenos-grid', context).data("gridInstance");
	if (typeof grid == "undefined") {
		return false;
	}
	var gridData = grid.getData().getItems();
	uri += "/secure/trd/conf/matching/query/allocCxl";

	
	xenos.ns.trdCnfAllocCxl.selectedRecordsIndex = [];
	var selectedGrid = grid.getSelectedRows();
	var isChecked = false;	
	var lngth = selectedGrid.length;
	var selector = [];
	

	if (typeof gridData == "undefined") {
		return false;
	}
	var reqObj = {};
	var validationMessages = [];
	if (selectedGrid.length == 0) {
		validationMessages.push(xenos$TRD$i18n.trdUnmatch.no_record_selected);
	}
	
	else{		
			for (i = 0; i < lngth; i++) {
		
			if (!isChecked) {
				isChecked = true;
				}
			if(gridData[selectedGrid[i]]['matchStatusDisp'] == ''  || gridData[selectedGrid[i]]['matchStatusDisp'] == null ){
				validationMessages.push(xenos$TRD$i18n.trdUnmatch.unmatched_trd_selected);
				$('.formHeader').find('.formTabErrorIco').css('display', 'block');
				$('.formHeader').find('.formTabErrorIco').off('click');
				$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
				return false;
			}
			
			
			if(gridData[selectedGrid[i]]['matchStatusDisp'] == 'Reject'){
				validationMessages.push(xenos$TRD$i18n.trdUnmatch.reject_trd_selected);
				$('.formHeader').find('.formTabErrorIco').css('display', 'block');
				$('.formHeader').find('.formTabErrorIco').off('click');
				$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
				return false;
			}
			
			if(gridData[selectedGrid[i]]['matchStatusDisp'] == 'Confirmed'){
				validationMessages.push(xenos$TRD$i18n.trdUnmatch.cnf_trd_selected);
				$('.formHeader').find('.formTabErrorIco').css('display', 'block');
				$('.formHeader').find('.formTabErrorIco').off('click');
				$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
				return false;
			}
			
			if(gridData[selectedGrid[i]]['settlementOutstanding'] == 'false' || gridData[selectedGrid[i]]['settlementOutstanding'] == false){
				validationMessages.push(xenos$TRD$i18n.trdUnmatch.settled_trd_selected);
				$('.formHeader').find('.formTabErrorIco').css('display', 'block');
				$('.formHeader').find('.formTabErrorIco').off('click');
				$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
				return false;
			}
			
			else{
					selector.push(gridData[selectedGrid[i]]['rowID']);
					xenos.ns.trdCnfAllocCxl.selectedRecordsIndex.push(gridData[selectedGrid[i]]['rowID']);
				}
	}
				selector.push(-1);
				
	}
	if (validationMessages.length > 0) {
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
		return false;
	}
	
	var container = $("#content");
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&fragments=content';
	var context = $target.closest('#content');
	var requestUrl = xenos.context.path + "/secure/trd/conf/matching/query" + "/unmatchTrade"+commandFormId+fragmentName;
	$(e.target).attr('disabled', true);
	
	xenos$Handler$trdCnfAllocCxl
			.generic(
					e,
					{
						requestUri : requestUrl,
						settings : {
							data : jQuery
									.param(
											{
												fragments : 'content',
												selector : selector
											}, true),
							complete: function() {
													
													$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
													$('.tabArea').hide();
													}			
						},
						onHtmlContent : function(e, options, $target, content) {
									$target.html(content);
						}
					}
					);
	
};

xenos.ns.trdUnmatch.confirmhandler = function(e) {
	
	e.preventDefault();
	var $target = $(this);
	var context = $target.closest('.formContent');
	var uri = xenos.context.path;
	
	var container = $("#content");
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&fragments=content';
	var context = $target.closest('#content');
	var requestUrl = xenos.context.path + "/secure/trd/conf/matching/query" + "/tradeUnmatchConfirm"+commandFormId+fragmentName;			
	$(e.target).attr('disabled', true);
	
	xenos$Handler$trdCnfAllocCxl
			.generic(
					e,
					{
						requestUri : requestUrl,
						settings : {
						
							type : "POST",
							data : jQuery
									.param(
											{
												fragments : 'content'
											}, true),
											
							complete: function() {
													$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
													$('.tabArea').hide();
													}				
						},
						onHtmlContent : function(e, options, $target, content) {
									$target.html(content);
						}
					}
					);
	
};
