//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
var xenos$Handler$drvInstruction = xenos$Handler$function({
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

xenos.ns.drvInstruction = {
	
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
		
		var _drvTrdPkArray = [];
		
		var selectedGrid = grid.getSelectedRows();
		
		var isChecked = false;
		var recordPk = "";
		xenos.ns.drvInstruction.selectedRecordsIndex = [];
		for(i = 0; i < selectedGrid.length; i++) {
			if(!isChecked){
				isChecked = true;
			}
			xenos.ns.drvInstruction.selectedRecordsIndex[i]=gridData[selectedGrid[i]]['rowID'];
			recordPk = gridData[selectedGrid[i]]['tradePk'] + "-";
			
			_drvTrdPkArray.push(recordPk);
			
		}
		
		if (_drvTrdPkArray.length < 1) {
		  xenos.utils.displayGrowlMessage(xenos.notice.type.error, 'Please select at least one record.');
		  return false;
		}
		
		xenos$Handler$drvInstruction.generic(undefined, {
			requestUri: xenos.context.path + '/secure/drv/drvinstruction/query/submittransmit?' + 'commandFormId=' + $('[name=commandFormId]').val() + '&fragments=content',
			settings: {
				type: 'POST',
				data: jQuery.param({
				  fragments: 'content',
				  drvTrdPkArray: _drvTrdPkArray
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
										
										$('.drvInxBackBtn',container).show();
										$('.drvInxCnfBtn',container).show();
										
										$('.qryResultItem',container).hide();										
										$('.drvInxOkBtn',container).hide();
										$('.tabArea',container).hide();
										$('.drvInxTransmitBtn',container).hide();
									}
								}	
			
		});

	return true;
  },
	
	// Handler to confirm the cancel process
	confirmHandler :function(e){
	
		var $target = $(this);
		var uri = xenos.context.path;
		
		uri += "/secure/drv/drvinstruction/query/confirmtransmit.json";		
		
		var context = $target.closest('#content');
		var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
		var fragmentName = '&fragments=content';
		var requestUrl = uri + commandFormId + fragmentName;
		$(e.target).attr('disabled', true);
		
		var container = $("#content");
		
		xenos$Handler$drvInstruction.generic(e, {
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
																	
																		var selected = xenos.ns.drvInstruction.selectedRecordsIndex;
															
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
																		$('.drvInxBackBtn', container).hide();
																		$('.drvInxOkBtn', container).show();
																		$('.drvInxCnfBtn', container).hide();
																		$('.title.queryFormTitleText.whiteFont.left', '.formHeader').find('h1').text(content.commandForm.headerInfo);
																	}else{
																	
																		$('.drvInxCnfBtn', container).find('.inputBtnStyle').removeAttr("disabled");
																		
																		xenos.utils.displayGrowlMessage(xenos.notice.type.error, content.value);
																	}
															     }
										 });
										 
	},
	
		// Handler to back to the result screen
   backHandler :function(e){
	var $target = $(this);
		
		var context = $target.closest('.formContent');
		var container = $("#content");
		var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
		var fragmentName = '&fragments=content';
		
		$(e.target).attr('disabled', true);
		
		xenos$Handler$drvInstruction.generic(e, {requestUri: xenos.context.path + '/secure/drv/drvinstruction/query/result?' + 'commandFormId=' + $('[name=commandFormId]').val() + '&fragments=content',
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
	okHandler :function(e){
		var $target = $(this);
		
		var context = $target.closest('.formContent');
		var container = $("#content");
		var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
		var fragmentName = '&fragments=content';
		
		$(e.target).attr('disabled', true);
		
		xenos$Handler$drvInstruction.generic(e, {requestUri: xenos.context.path + '/secure/drv/drvinstruction/query/result?' + 'commandFormId=' + $('[name=commandFormId]').val() + '&fragments=content',
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
    selectedRecordsIndex : []
};