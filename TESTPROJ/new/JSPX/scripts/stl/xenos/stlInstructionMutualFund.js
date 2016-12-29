var xenos$Handler$stlInstruction = xenos$Handler$function({
  get: {
    requestType: xenos$Handler$default.requestType.asynchronous,
    target: '#content'
  },
  settings: {
    beforeSend: function(request) {
      request.setRequestHeader('Accept', 'text/html;type=ajax');
    }
  },
  callback : {
	success : function (evt, options){
		if(options){
			$.each(options['gridInstance'] || [], function (ind, grid) {
				grid.destroy();
			});
		}
	}
  }
});

xenos.ns.stlInstruction = {
	
	// Handler to submit the transmit entries and forward to the confirmation screen
	transmitHandler: function(e) {
		e.preventDefault();
		var $target = $(this);
		var context = $target.closest('.formContent');
		var grid = jQuery('.xenos-grid', $container).data('gridInstance');
		var gridData = grid.getData().getItems();
		
		var container = $("#content");
		var $container = $target.closest('#queryResultForm');
	
		var operationObjective = "";
	
	    if (typeof grid === "undefined") return false;
		
		var stlInfoPkArray = [];
		var stlInstructionRefNoSelArray = [];
		
		var selectedGrid = grid.getSelectedRows();
		
		var isChecked = false;
		var stlInfoPk = "";
		
		var instrRefNo = "";
		
		xenos.ns.stlInstruction.selectedRecordsIndex = [];
		for(i = 0; i < selectedGrid.length; i++) {
			if(!isChecked){
				isChecked = true;
			}
			xenos.ns.stlInstruction.selectedRecordsIndex[i]=gridData[selectedGrid[i]]['rowID'];
			stlInfoPk = $.trim(gridData[selectedGrid[i]]['settlementInfoPk']);
			stlInfoPkArray.push(stlInfoPk);
			
			instrRefNo = $.trim(gridData[selectedGrid[i]]['instructionRefNo']);
			if(instrRefNo != ""){
				stlInstructionRefNoSelArray.push(instrRefNo);
			}
			else{
				stlInstructionRefNoSelArray.push("null");
			}
		}
		
		if (stlInfoPkArray.length < 1) {
		  xenos.utils.displayGrowlMessage(xenos.notice.type.error, 'Please select at least one record.');
		  return false;
		}
		
		xenos$Handler$stlInstruction.generic(undefined, {
			requestUri: xenos.context.path + baseurl + '/confirm?' + 'commandFormId=' + $('[name=commandFormId]').val() + '&fragments=content',
			settings: {
				type: 'POST',
				data: jQuery.param({
				  fragments: 'content',
				  stlInfoPkArray: stlInfoPkArray,
				  stlInstructionRefNoSelectedArray : stlInstructionRefNoSelArray
				}, true)
			},
			onHtmlContent: function(e, options, $target, content) {
									xenos.utils.clearGrowlMessage();
									if(content.indexOf('xenosError')!=-1){
										var msg = [];
										$.each($('.xenosError li', content), function(index, value) {										  
										  msg.push($(value).text());
										});
										xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
									}else{
									
										container.html(content);										
									    if ($('#queryForm',container).length == 0) {											
											$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
										}
										
										$('.stlInxCancelBtn',container).show();
										$('.stlInxOkBtn',container).show();
										
										$('.qryResultItem',container).hide();										
										$('.stlInxCnfBtn',container).hide();
										$('.tabArea',container).hide();
										$('.stlInxTransmitBtn',container).hide();
										$('.stlInxTransmitAllBtn',container).hide();
										$('.stlInxDuplicateBtn',container).hide();
									}
								}	
			
		});

	return true;
  },
  cancelHandler: function(e){xenos.ns.stlInstruction.okHandler(e)},
  
   // Handler to back to the result screen with selected rows
   cancelled$cancelHandler :function(e){
		
		var $target = $(this);		
		var uri = xenos.context.path;		
		uri += (baseurl + "/backtoresults");		
		var container = $("#content");
		var form = $('#queryResultForm', container);
		var commandFormId = '?commandFormId=' + $('[name=commandFormId]', container).val();
		var fragmentName = '&fragments=content';
		uri += commandFormId + fragmentName;
		$(e.target).attr('disabled', true);
		
		xenos$Handler$stlInstruction.generic(undefined, {
			requestUri: uri,
			settings: {
				type: 'POST'
			},
			onHtmlContent:  function(e, options, $target, content) {
			
								container.html(content);
								
								//Check the return page if return page equal query result then render grid.
								if ($('#queryForm', container).length == 0) {
									$('#queryResultForm .xenos-grid', container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);	
									var grid = $('.xenos-grid',container).data().gridInstance;
									grid.setSelectedRows(xenos.ns.stlInstruction.selectedRecordsIndex);
								}
							}
		});
		
    },
	/*When ok is pressed in user confirmation*/
		confirmSubmitHandler: function(e) {
	
		e.preventDefault();
		var $target = $(this);
		var context = $target.closest('.formContent');
		var grid = jQuery('.xenos-grid', $container).data('gridInstance');
		
		var container = $("#content");
		var $container = $target.closest('#queryResultForm');
	
		var operationObjective = "";
	
	    if (typeof grid === "undefined") return false;
		
		
		
		
		
		xenos$Handler$stlInstruction.generic(undefined, {
			requestUri: xenos.context.path + baseurl + '/submitPreConfirm?' + 'commandFormId=' + $('[name=commandFormId]').val() + '&fragments=content',
			settings: {
				type: 'POST',
				data: jQuery.param({
				  fragments: 'content',
				}, true)
			},
			onHtmlContent: function(e, options, $target, content) {
									if(content.indexOf('xenosError')!=-1){
										var msg = [];
										$.each($('.xenosError li', content), function(index, value) {										  
										  msg.push($(value).text());
										});
										xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
									}else{
									
										container.html(content);										
									    if ($('#queryForm',container).length == 0) {											
											$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
										}
																				
										$('.stlInxOkRetBtn',container).show();
										
										$('.stlInxOkBtn',container).hide();											
										$('.stlInxCancelBtn',container).hide();										
										$('.qryResultItem',container).hide();										
										$('.stlInxCnfBtn',container).hide();
										$('.tabArea',container).hide();
										$('.stlInxTransmitBtn',container).hide();
										$('.stlInxTransmitAllBtn',container).hide();
										$('.stlInxDuplicateBtn',container).hide();									
									}
								}	
			
		});

	return true;
  },
	
	// Handler to confirm the cancel process
	confirmHandler :function(e){
	
		var $target = $(this);
		var uri = xenos.context.path;
		
		uri += (baseurl + "/confirmtransmit.json");		
		
		var context = $target.closest('#content');
		var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
		var fragmentName = '&fragments=content';
		var requestUrl = uri + commandFormId + fragmentName;
		$(e.target).attr('disabled', true);
		
		var container = $("#content");
		
		xenos$Handler$stlInstruction.generic(e, {
												requestUri: requestUrl,
												get: {
													contentType: 'json',
													requestType: xenos$Handler$default.requestType.asynchronous
												},
												settings:{
													beforeSend: function(request) {
														request.setRequestHeader('Accept', 'application/json');
													},
													type: 'POST'
												},
												onJsonContent : function(e, options, $target, content) {
																	
																	if(content.success==true){
																	
																		var selected = xenos.ns.stlInstruction.selectedRecordsIndex;
															
																		$('.formContent', context).append(
																			'<div class="xenosSuccsmsg">' +
																			'<div class="xenosSuccBoxBg">'+
																				'<div class="left infoIcon">' + '</div>' + '<div class="content entryConfirm">' + '<ul>' + 
																				'<li>Transaction completed successfully</li>' + '<li>Total Records : '+ selected.length +' record(s)</li>' + 
																				'</ul>'+'</div>'+'</div>'+'<div class="btmShadow"></div>'+'</div>');
																				
																		var msgCount = $('.xenosSuccsmsg',context).length;
																		if(msgCount > 1){
																			$('.xenosSuccsmsg',context).next('.xenosSuccsmsg').remove();	
																		}
																		$('.formHeader', container).find('.formTabErrorIco').css('display', 'none');
																		$('.stlInxBackBtn', container).hide();
																		$('.stlInxOkBtn', container).show();
																		$('.stlInxCnfBtn', container).hide();
																		$('.title.queryFormTitleText.whiteFont.left', '.formHeader').find('h1').text(content.commandForm.headerInfo);
																	}else{
																	
																		$('.stlInxCnfBtn', container).find('.inputBtnStyle').removeAttr("disabled");
																		
																		xenos.utils.displayGrowlMessage(xenos.notice.type.error, content.value);
																	}
															     }
										 });
										 
	},
	
	// Handler to get back to the query page when OK button is clicked on the system confirmation page
	okHandler :function(e){
		var $target = $(this);
		var context = $target.closest('.formContent');
		var container = $("#content");
		var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
		var fragmentName = '&fragments=content';
		
		$(e.target).attr('disabled', true);
		
		xenos$Handler$stlInstruction.generic(e, {requestUri: xenos.context.path + baseurl + '/result?' + 'commandFormId=' + $('[name=commandFormId]').val() + '&fragments=content',
												 settings:{
													type: "POST"
												 },
												 onHtmlContent: function(e, options, $target, content) {
																    container.html(content);																
																	
																	//Check the return page if return page equal query result then render grid.
																	if ($('#queryForm', container).length == 0) {
																		$('#queryResultForm .xenos-grid', container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);	
																	}
																}
										});
	},
	
		// Handler to get back to the query page when OK button is clicked on the system confirmation page
	duplicateHandler :function(e){
		var $target = $(this);
		
		var context = $target.closest('.formContent');
		var container = $("#content");
		var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
		var fragmentName = '&fragments=content';
		
		$(e.target).attr('disabled', true);
		
		xenos$Handler$stlInstruction.generic(e, {requestUri: xenos.context.path + baseurl + '/result?' + 'commandFormId=' + $('[name=commandFormId]').val() + '&duplicateCheckFlag=Y&fragments=content',
												 settings:{
													type: "POST"
												 },
												 onHtmlContent: function(e, options, $target, content) {
													 				xenos.utils.clearGrowlMessage();
																    container.html(content);																
																	
																	//Check the return page if return page equal query result then render grid.
																	if ($('#queryForm', container).length == 0) {
																		$('#queryResultForm .xenos-grid', container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);	
																	}
																	
																	$('.stlInxOkRetBtn',container).show();																					
																	$('.stlInxCancelBtn',container).hide();									
																	$('.qryResultItem',container).hide();										
																	$('.tabArea',container).hide();
																	$('.stlInxTransmitBtn',container).hide();
																	$('.stlInxTransmitAllBtn',container).hide();
																	$('.stlInxDuplicateBtn',container).hide();			
																	
																}
										});
	},
	
	// Handler to transmit all items
	transmitAllHandler: function(e) {
		e.preventDefault();
		var $target = $(this);
		var context = $target.closest('.formContent');
		var grid = jQuery('.xenos-grid', $container).data('gridInstance');
		var gridData = grid.getData().getItems();
		
		var container = $("#content");
		var $container = $target.closest('#queryResultForm');
	
	    if (typeof grid === "undefined") return false;
		
		var selectedGrid = grid.getSelectedRows();
		if (selectedGrid.length < 1) {
			xenos.utils.displayGrowlMessage(xenos.notice.type.error, 'No record is present to perform Transmit All function.');
			return false;
		}
		
		xenos$Handler$stlInstruction.generic(undefined, {
			requestUri: xenos.context.path + baseurl + '/transmitBulkInx?' + 'commandFormId=' + $('[name=commandFormId]').val() + '&fragments=content',
			settings: {
				type: 'POST',
				data: jQuery.param({
				  fragments: 'content'
				}, true)
			},
			onHtmlContent: function(e, options, $target, content) {
									xenos.utils.clearGrowlMessage();
									if(content.indexOf('xenosError')!=-1){
										var msg = [];
										$.each($('.xenosError li', content), function(index, value) {										  
										  msg.push($(value).text());
										});
										xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
									}else{
									
										container.html(content);										
										
										$('.stlInxCancelBtn',container).show();
										$('.stlInxOkBtn',container).show();
										
										$('.qryResultItem',container).hide();										
										$('.stlInxCnfBtn',container).hide();
										$('.tabArea',container).hide();
										$('.stlInxTransmitBtn',container).hide();
										$('.stlInxTransmitAllBtn',container).hide();
										$('.stlInxDuplicateBtn',container).hide();
									}
								}	
			
		});

	return true;
  },
  
  	//Handler to transmit bulk items
  	transmitBulkInxHandler: function(e) {
		e.preventDefault();
		var $target = $(this);
		var context = $target.closest('.formContent');
		
		var container = $("#content");
		var $container = $target.closest('#queryResultForm');
	
		
		xenos$Handler$stlInstruction.generic(undefined, {
			requestUri: xenos.context.path + baseurl + '/transmitBulkInxExecute?' + 'commandFormId=' + $('[name=commandFormId]').val() + '&fragments=content',
			settings: {
				type: 'POST',
				data: jQuery.param({
				  fragments: 'content'
				}, true)
			},
			onHtmlContent: function(e, options, $target, content) {
									if(content.indexOf('xenosError')!=-1){
										var msg = [];
										$.each($('.xenosError li', content), function(index, value) {										  
										  msg.push($(value).text());
										});
										xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
									}else{
										container.html(content);
										$('.runProcessDiv',container).show();
										$('.completeProcessDiv',container).hide();
										$('.stlInxRefreshBtn',container).show();
										$('.stlInxRefreshOkBtn',container).hide();
										$('.tabArea',container).hide();
									}
								}	
		});

	return true;
},

//Handler to refresh bulk items
  	refreshHandler: function(e) {
		e.preventDefault();
		var $target = $(this);
		var context = $target.closest('.formContent');
		
		var container = $("#content");
		var $container = $target.closest('#queryResultForm');
	
		
		xenos$Handler$stlInstruction.generic(undefined, {
			requestUri: xenos.context.path + baseurl + '/fetchBulkInxLogData?' + 'commandFormId=' + $('[name=commandFormId]').val() + '&fragments=content',
			settings: {
				type: 'POST',
				data: jQuery.param({
				  fragments: 'content'
				}, true)
			},
			onHtmlContent: function(e, options, $target, content) {
									if(content.indexOf('xenosError')!=-1){
										var msg = [];
										$.each($('.xenosError li', content), function(index, value) {										  
										  msg.push($(value).text());
										});
										xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
									}else{
										container.html(content);
										$('.runProcessDiv',container).hide();
										$('.completeProcessDiv',container).show();
										$('.stlInxRefreshBtn',container).hide();
										$('.stlInxRefreshOkBtn',container).show();
										$('.tabArea',container).hide();
									}
								}	
		});

	return true;
},
  
  selectedRecordsIndex : []
};

var baseurl='';
if (typeof basepath !== 'undefined') {
    baseurl=basepath;
}