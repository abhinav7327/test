//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
var xenos$Handler$frxInstruction = xenos$Handler$function({
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

xenos.ns.frxInstruction = {
	
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
		
		var _frxTrdPkArray = [];
		
		var selectedGrid = grid.getSelectedRows();
		
		var isChecked = false;
		var recordPk = "";
		for(i = 0; i < selectedGrid.length; i++) {
			if(!isChecked){
				isChecked = true;
			}
			
			recordPk = gridData[selectedGrid[i]]['frxTrdPk'] + "-" + gridData[selectedGrid[i]]['instructionType'];			
			_frxTrdPkArray.push(recordPk);
			
		}
		
		if (_frxTrdPkArray.length < 1) {
		  xenos.utils.displayGrowlMessage(xenos.notice.type.error, 'Please select at least one record.');
		  return false;
		}
		
		xenos$Handler$frxInstruction.generic(undefined, {
			requestUri: xenos.context.path + '/secure/frx/forexinstruction/query/submittransmit?' + 'commandFormId=' + $('[name=commandFormId]').val() + '&fragments=content',
			settings: {
				type: 'POST',
				data: jQuery.param({
				  fragments: 'content',
				  frxTrdPkArray: _frxTrdPkArray
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
										
										$('.frxInxBackBtn',container).show();
										$('.frxInxCnfBtn',container).show();
										
										$('.qryResultItem',container).hide();										
										$('.frxInxOkBtn',container).hide();
										$('.tabArea',container).hide();
										$('.frxInxTransmitBtn',container).hide();
									}
								}	
			
		});

	return true;
  },
	
	// Handler to confirm the cancel process
	confirmHandler :function(e){
	
		var $target = $(this);
		var uri = xenos.context.path;
		
		uri += "/secure/frx/forexinstruction/query/confirmtransmit.json";		
		
		var context = $target.closest('#content');
		var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
		var fragmentName = '&fragments=content';
		var requestUrl = uri + commandFormId + fragmentName;
		$(e.target).attr('disabled', true);
		
		var container = $("#content");
		
		xenos$Handler$frxInstruction.generic(e, {
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
															
																		$('.formContent', context).append(
																			'<div class="xenosSuccsmsg">' +
																			'<div class="xenosSuccBoxBg">'+
																				'<div class="left infoIcon">' + '</div>' + '<div class="content entryConfirm">' + '<ul>' + 
																				'<li>Transaction completed successfully</li>' + '<li>Total Records : '+ grid_result_data.length +' record(s)</li>' + 
																				'</ul>'+'</div>'+'</div>'+'<div class="btmShadow"></div>'+'</div>');
																				
																		var msgCount = $('.xenosSuccsmsg',context).length;
																		if(msgCount > 1){
																			$('.xenosSuccsmsg',context).next('.xenosSuccsmsg').remove();	
																		}
																		$('.formHeader', container).find('.formTabErrorIco').css('display', 'none');
																		$('.frxInxBackBtn', container).hide();
																		$('.frxInxOkBtn', container).show();
																		$('.frxInxCnfBtn', container).hide();
																		$('.title.queryFormTitleText.whiteFont.left', '.formHeader').find('h1').text(content.commandForm.headerInfo);
																	}else{
																	
																		$('.frxInxCnfBtn', container).find('.inputBtnStyle').removeAttr("disabled");
																		
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
		
		xenos$Handler$frxInstruction.generic(e, {requestUri: xenos.context.path + '/secure/frx/forexinstruction/query/result?' + 'commandFormId=' + $('[name=commandFormId]').val() + '&fragments=content',
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
	}
};