//$Id$
//$Author:  $
//$Date: 2016-12-27 13:05:57 $

var xenos$Handler$completion = xenos$Handler$function({
  get: {
	requestType: xenos$Handler$default.requestType.asynchronous,	
    target: function() {
			return $('#content');
		  }	 

  },
  settings: {
	beforeSend: function(request) {
	  request.setRequestHeader('Accept', 'text/html;type=ajax');
	},
	type: 'POST'
  }
});



xenos.ns.views.completion.pageNavigationHandler =function(){
	var $target = $(this);
	var container = $('#content');	
	var row = $target.attr('rowIndex');
	var commandFormId = '&commandFormId=' + $('[name=commandFormId]',context).val();
	var fragmentName = '&fragments=content';
	var context = $target.closest('.formContent');
	var reqObj = {};
	var uri = xenos.context.path;
	var validationMessages = [];
	var grid = $('.xenos-grid',context).data("gridInstance");
	var gridData = grid.getData().getItems();
    var stlDate = $target.attr('stlDate');
	var completionTp = $target.attr('completionType');

	var detailHistoryPk =$target.attr('detailHistoryPk');
	if (typeof detailHistoryPk == "undefined" || detailHistoryPk == "undefined") {
		if (completionTp == "") {
			validationMessages.push(xenos$STL$i18n.completion.select_completion_type_first);
		}
	} else {
		var selectedGrid = grid.getSelectedRows();
		if (selectedGrid.length == 0) {
			validationMessages.push(xenos$STL$i18n.completionCancel.selectRecord);
		}
	}
	if (validationMessages.length > 0) {
		xenos.utils.displayGrowlMessage(xenos.notice.type.error,validationMessages);
		return false;
	}
 
	if(typeof grid == "undefined"){
		return false;
	}

	/*for (i=0 ; i< grid.getDataLength() ; i++){
		reqObj['completionTypeArray['+i+']'] = gridData[i]['completionTp'];
		reqObj['stlInfoPkArray['+i+']'] = gridData[i]['settlementInfoPk'];
		reqObj['stlDateArray['+i+']'] = gridData[i]['stlDate'];
	}*/
	
	reqObj['stlInfoPk'] = $target.attr('settlementInfoPk');  //gridData[row]['settlementInfoPk'];
	reqObj['compType'] = completionTp;
	reqObj['completionTypeArray['+row+']'] = completionTp;
	
  xenos$Handler$default.generic(undefined, {
  requestUri: xenos.context.path + "/secure/stl/settlement/completion/entry/details?index="+ row + commandFormId + fragmentName,
  requestType: xenos$Handler$default.requestType.asynchronous,
  onHtmlContent: function(e,options, $target, content) {
  console.log(content);
  if(content.indexOf('xenosError')!=-1){
						var msg = [];
						
						$.each($('ul.xenosError li',content), function(index, value) {
						  msg.push($(value).text());
						});
						xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
}else{
		container.html(content);
		if ($('#queryForm',container).length == 0) {							
				$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
			}
			$('.tabArea',container).hide();
			$('.prevNextarea',container).hide();	
			$('.queryColumnsReset',container).hide();
	}		
},
settings: {
	        data : reqObj,
			beforeSend: function(request) {
			request.setRequestHeader('Accept', 'text/html;type=ajax');
		  },
			type: 'POST'				  
		  },
target: '#content'  
  });  

	}
  
  /*
* Submit Handler
*/
xenos.ns.views.completion.submitHandler=function (e){
		e.preventDefault();
		var $target = $(this);
		var gridInstanceArray = [];
		var context = $target.closest('.formContent');
		var stlDateArray = [];
		var completionTypeArray =[];
		var stlInfoPkArray=[];
		var requestUrl = xenos.context.path;
		var grid = $('.xenos-grid',context).data("gridInstance");
		var settlementDateofRcvdNoticeStr="";
		var selectedRef = [];
		if(typeof grid == "undefined"){
			return false;
		}
		var gridData = grid.getData().getItems();
			var atLeastOneSelected = false;
			var isStlDateEmptyForAnySelectedRecord = false;
			var stlDate = "", completiontype="", stlInfoPk="";;
			var validationMessages = [];
			if(typeof gridData == "undefined"){
				return false;
			}
			for (i=0 ; i< grid.getDataLength() ; i++){
				completiontype = gridData[i]['completionTp'];
				stlDate = gridData[i]['stlDate'];
				stlInfoPk = gridData[i]['settlementInfoPk'];
				
				if($.trim(completiontype) !="" && typeof completiontype != "undefined" ){
					atLeastOneSelected = true;
				}
				if($.trim(completiontype) !="" && typeof completiontype != "undefined" && $.trim(stlDate) =="" && !isStlDateEmptyForAnySelectedRecord){
					isStlDateEmptyForAnySelectedRecord = true;	
				}
				
				if (typeof completiontype == "undefined") {
					completionTypeArray.push("");
				} else {
					completionTypeArray.push(completiontype);
				}
				stlDateArray.push(stlDate);
				stlInfoPkArray.push(stlInfoPk);
			}	
			
			if(!atLeastOneSelected) {
				validationMessages.push(xenos$STL$i18n.completion.no_completion_type_selected);
			}else if(isStlDateEmptyForAnySelectedRecord) {
				validationMessages.push(xenos$STL$i18n.completion.empty_settlementdate);
			}

			if (validationMessages.length > 0){
				$('.formHeader').find('.formTabErrorIco').css('display', 'block').css('position','relative');
				$('.formHeader').find('.formTabErrorIco').off('click');
				$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
				xenos.utils.displayGrowlMessage(xenos.notice.type.error, validationMessages);
				return false;
			}
			var container = $("#content");
			var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
			var fragmentName = '&fragments=content';
			var context = $target.closest('#content');
			requestUrl +="/secure/stl/settlement/completion/entry/submitCompletion"+commandFormId+fragmentName;
			xenos$Handler$completion
			.generic(
					e,
					{
						requestUri : requestUrl,
						settings : {
							data : jQuery
									.param(
											{
												fragments : 'content',
												completionTypeArray : completionTypeArray,
			                                    stlDateArray : stlDateArray,
			                                    stlInfoPkArray : stlInfoPkArray
											}, true),
							complete: function() { 
													$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
													}			
						},
						onHtmlContent : function(e, options, $target, content) {
									$target.html(content);
									
									if(content.indexOf('xenosError')==-1){
										
										$('.tabArea').hide();								
									} else {
									        var msg = [];
											$.each($('ul.xenosError li',container),
													function(index, value) {
														
														var msgStr = $(value).text();

														if (msgStr !== '')
															msg.push(msgStr);
													});
											xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
											$.each(gridInstanceArray || [], function(
													ind, grid) {
												grid.destroy();
											});
									}
						}
						
						
						
					}
					);
		} 
  
xenos.ns.views.completion.backHandler=function (e){
	  var $target = $(this);
		var gridInstanceArray = [];
		var context = $target.closest('.formContent');
		var reqObj = {};
		var uri = xenos.context.path;

		

		var reqObj = {};
		var container = $("#content");
		var form = $('#queryResultForm', container);
		var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
		var fragmentName = '&fragments=content';
		var context = $target.closest('#content');
		var requestUrl = xenos.context.path + "/secure/stl/settlement/completion/entry" + "/backToResult"+commandFormId+fragmentName;
		$(e.target).attr('disabled', true);
		
		xenos$Handler$completion
				.generic(
							e,
							{
								requestUri : requestUrl,
								settings : {
									data : jQuery
											.param(
													{
														fragments : 'content',
													}, true),
								
									complete: function() {

													xenosGrid = $('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
														
											}			
													},
													
								onHtmlContent : function(e, options, $target, content) {
										
										$target.html(content);
										
										if (content.indexOf('xenosError') != -1) {
											$("#confirmCancelBtn").show();
											$("#backCancelBtn").show();
											$("#okCancelBtn").hide();

											var msg = [];
											
											$.each($('ul.xenosError li',content),
													function(index, value) {
														
														var msgStr = $(value).text();

														if (msgStr !== '')
															msg.push(msgStr);
													});

											xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
											
											$.each(gridInstanceArray || [], function(
													ind, grid) {
												grid.destroy();
											});
										   
										} 								
									}
								}
							); 
						

		
		
	
}


xenos.ns.views.completion.okHandler=function(e){
	 var $target = $(this);
		var gridInstanceArray = [];
		var context = $target.closest('.formContent');
		var reqObj = {};
		var uri = xenos.context.path;

		var reqObj = {};
		
		
		var container = $("#content");
		var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
		var fragmentName = '&fragments=content';
		var context = $target.closest('#content');
		var requestUrl = xenos.context.path + "/secure/stl/settlement/completion/entry" + "/resetResult"+commandFormId+fragmentName;			
		$(e.target).attr('disabled', true);
		
		xenos$Handler$completion
				.generic(
						e,
						{
							requestUri : requestUrl,
							settings : {
								type: "POST"
								

							},
							
							onHtmlContent : function(e, options, $target, content) {
										
										$target.html(content);
											if ($('.xenos-grid', container).length > 0) {
													var xenosgrid = $(
															'#queryResultForm .xenos-grid',
															container).xenosgrid(
															grid_result_data,
															grid_result_columns,
															grid_result_settings);
										    }
											
											if(content.indexOf('xenosError')!=-1){
													var msg = [];
													
													$.each($('ul.xenosError li',container),
															function(index, value) {
																
																var msgStr = $(value).text();

																if (msgStr !== ''){
																	msg.push(msgStr);
																	xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
																}
															});
													$.each(gridInstanceArray || [], function(
															ind, grid) {
														grid.destroy();
													});
											} 
											else{
                                  $('.result-tab',container).addClass('active');
                                       container.html(content);
                                       xenos.utils.clearGrowlMessage();
                                       if ($('#queryForm',container).length == 0) {
                                                               $('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
                                                       }
                               }
										
							}
						}
						);
		
	
}

xenos.ns.views.completion.confirmHandler=function(e){
	var $target = $(this);
	var gridInstanceArray = [];
	var context = $target.closest('.formContent');
	var reqObj = {};
	var uri = xenos.context.path;
	
	
	var grid = $('.xenos-grid', context).data("gridInstance");
	
	var gridData = grid.getData().getItems();
	uri += "/secure/stl/settlement/completion/entry/submitConfirm";

	
	var reqObj = {};
	var validationMessages = [];
	
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
	var requestUrl = xenos.context.path + "/secure/stl/settlement/completion/entry" + "/submitConfirm"+commandFormId+fragmentName;
	$(e.target).attr('disabled', true);
	
	xenos$Handler$completion
			.generic(
					e,
					{
						requestUri : requestUrl,
						settings : {
							data : jQuery
									.param(
											{
												fragments : 'content',
												
											}, true),
							complete: function() { 
													$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
													$('.tabArea').hide();
													}			
						},
						onHtmlContent : function(e, options, $target, content) {
									$target.html(content);

								if(content.indexOf('xenosError')==-1){
		
											$('.tabArea').hide();
											
											$('.completionBackBtn', container).hide();
											$('.completionCnfBtn', container).hide();
											$('.completionOkBtn', container).show();
											
											xenos.utils.displayGrowlMessage(xenos.notice.type.info, xenos$STL$i18n.successful_transaction);
											
										} 
								else
										{
										
											var msg = [];
												
												$.each($('ul.xenosError li',container),
														function(index, value) {
															
															var msgStr = $(value).text();

															if (msgStr !== '')
																msg.push(msgStr);
														});
												$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
												xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
												$('.tabArea').hide();
										
											$('.completionBackBtn', container).show();
											$('.completionCnfBtn', container).show();
											$('.completionOkBtn', container).hide();
																	
												$.each(gridInstanceArray || [], function(
														ind, grid) {
													grid.destroy();
												});
										}
						}
					}
					);
		
	
}
xenos.ns.views.completion.copyHandler=function(e){
    var $target = $(this);
    var context = $(e.target).closest('.formContent');
    var grid = $('.xenos-grid',context).data("gridInstance");
	var commonDate = $.trim($('#commonStlDateStr',context).val());
	var gridData = grid.getData().getItems();
	if(commonDate=="") {
		return;
	}
	for (i=0 ; i< grid.getDataLength() ; i++){
	 if(gridData[i]['completionTp'] != ""){
		var gridData = ($('.xenos-grid',context).data("gridInstance")).getData().getItems();
		$('input[rowIndex='+i+']',context).val(commonDate);
		gridData[i]['stlDate'] = commonDate;
		}
	}
}
xenos.ns.views.completion.stlInfoOkHandler=function(e){
		var $target = $(this);
		var compType,outstandingAmountStr,cashSidePresent;
		//Collecting Grids for clean up
		var gridInstanceArray = [];
		$(e.target).attr('disabled', true);
		var container = $("#content");
		var form = $('#queryForm',container);
		var commandFormId = '?commandFormId=' + $('[name=commandFormId]',container).val();
		var fragmentName = '&fragments=content';
		var formUrl = xenos.context.path;
		xenos.utils.clearGrowlMessage();
		if(validateSubmit()){
			formUrl += "/secure/stl/settlement/completion/entry/ok" + commandFormId + fragmentName;
		} else {
			$(e.target).removeAttr('disabled');
			return false;
		}
		var actionType = $.trim($('#actionType').val());
		if(actionType == 'ADD' && e.data){
			compType = e.data[0];
			outstandingAmountStr = e.data[1];
			cashSidePresent = e.data[2];
			if(validateAmtQnty()){
				detailInfoOkHandler();
			} else{
				jConfirm(xenos$STL$i18n.amount.amount_exceed, null, function(confirm) {
					 if(!confirm) {
						$(e.target).removeAttr('disabled');
                        return false;
                    }else{
                    	detailInfoOkHandler();
                    }
				});
			 }
		}else{
			detailInfoOkHandler();
		}
		
		
		
		function detailInfoOkHandler(){
			var grids = $("[class*=slickgrid_]", container);
			$.each(grids, function (ind, grid) {
				gridInstanceArray.push($(grid).data("gridInstance"));
			});
			xenos$Handler$completion.generic(undefined,{
				requestUri: formUrl,
				onHtmlContent: function(e, options, $target, content) {
					//Do Nothing
				},
				settings: {
					data : form.serialize(),
					complete : function(jqXHR){
						$target.removeAttr('disabled');
						var content = jqXHR.responseText;
						container.html(content);
						if (content.indexOf('xenosError') != -1) {
							var msg = [];
							$.each($('ul.xenosError li',container), function(index, value) { 
							  msg.push($(value).text());
							});
							xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
						} else {
							//Chek the return page if return page equal query result then render grid.
							if ($('#queryForm',container).length == 0) {
								$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
							}
						}
					}
				},
				'gridInstance' : gridInstanceArray
			});
		}
		

		function validateSubmit(){
			var acttype = $('#actionType').val();
			if(acttype == 'ADD'){
				var amount = $('#completeAmount').val();
				var quantity = $('#completeQuantity').val();
				var msgArray = [];
				
				if($.trim($('#selectedCompletionDetails\\.securitySidePresent').val()) == 'true'){
					if(isBlank(quantity)){
						msgArray.push(xenos$STL$i18n.completion.invalid_quantity);
					}else{
						if(getNumericValue($('#completeQuantity').val()) == null){
							msgArray.push(xenos$STL$i18n.completion.invalid_quantity);
						}
					}
				}
				
				if($.trim($('#selectedCompletionDetails\\.cashSidePresent').val()) == 'true'){
					if( isBlank(amount)){
						msgArray.push(xenos$STL$i18n.completion.invalid_amount);
					}else{
						if(getNumericValue($('#completeAmount').val()) == null){
							msgArray.push(xenos$STL$i18n.completion.invalid_amount);
						}
					}
				}
			
				if(msgArray.length>0){
					xenos.utils.displayGrowlMessage(xenos.notice.type.error,msgArray);
					return false;
				}
				return true;
			}else{
				return true;
			}	
		}
		function validateAmtQnty(){
			//If Cash Side is present, then only validate for Amount else do nothing.
			if(cashSidePresent){
				function changeStringToNumber(name) {
					re = /,/gi;
					name = name.replace(re, '');
					return parseFloat(name);
				}
			 
				if(compType == 'COMPLETE'){  
					var completeAmtStr = $('#completeAmount').val();
					var completeAmt = changeStringToNumber(completeAmtStr);
					var outstandingAmt = changeStringToNumber(outstandingAmountStr);
					outstandingAmt = Math.abs(outstandingAmt);
					if(completeAmt != outstandingAmt) {
						return false;
					}else{
						return true;
					}
				} else{
					return true;
				}
			}else{
				return true;
			}
		}

		function isBlank(str){
			if(str == null || $.trim(str) == '') {
				return true
			}
			return false
		}
	}
xenos.ns.views.completion.stlInfoCancelHandler=function (e){
		var $target = $(this);
		$(e.target).attr('disabled', true);
		var container = $("#content");
		var form = $('#queryForm',container);
		var commandFormId = '?commandFormId=' + $('[name=commandFormId]',container).val();
		var fragmentName = '&fragments=content';
		var formUrl = xenos.context.path + "/secure/stl/settlement/completion/entry/cancel"  + commandFormId + fragmentName;
		var actionType = $.trim($('#actionType').val());
		
		//Collecting Grids for clean up
		var gridInstanceArray = [];
		var grids = $("[class*=slickgrid_]", container);
		$.each(grids, function (ind, grid) {
			gridInstanceArray.push($(grid).data("gridInstance"));
		});

		xenos$Handler$completion.generic(undefined,{
				requestUri: formUrl,
				onHtmlContent: function(e, options, $target, content) {
					//Do Nothing
				},
				settings: {
					data : form.serialize(),
					complete : function(jqXHR){
						$target.removeAttr('disabled');
						var content = jqXHR.responseText;
						container.html(content);
						//Chek the return page if return page equal query result then render grid.
						if ($('#queryForm',container).length == 0) {
							$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
						}
					}
				},
				'gridInstance' : gridInstanceArray
		});
	}