//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
var xenos$Handler$rightsExerciseAmend = xenos$Handler$function({
	get : {
		requestType : xenos$Handler$default.requestType.asynchronous,
		contentType: 'json'
		
	},
	settings : {
		beforeSend : function(request) {
			request.setRequestHeader('Accept', 'application/json');
			
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

var xenos$Handler$rightsExerciseAmend2 = xenos$Handler$function({
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

xenos.ns.rightsExerciseAmend.submithandler = function(e) {
	Slick.GlobalEditorLock.commitCurrentEdit();
	var $target = $(this);
	var gridInstanceArray = [];
	var context = $target.closest('.formContent');
	var reqObj = {};
	var uri = xenos.context.path;
   
	var grid = $('.xenos-grid', context).data("gridInstance");
	
	grid.getEditController().commitCurrentEdit();
	if (typeof grid == "undefined") {
		return false;
	}
	var gridData = grid.getData().getItems();
	
	uri += "/secure/cax/exercise/query/rightsExerciseAmendUC";

	
	var selectedGrid = grid.getSelectedRows();
	selectedGrid.sort();
	var isChecked = false;	

	if (typeof gridData == "undefined") {
		return false;
	}
	
	
	
	var reqObj = {};
	var validationMessages = [];
	if (selectedGrid.length == 0) {
		validationMessages.push(xenos$CAX$i18n.rightsExerciseAmend.no_record_selected);
	}
	if (validationMessages.length > 0) {
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
		return false;
	}
	var lngth = selectedGrid.length;
	var exercisingQuantity = [];
	var selectedFlag = [];
	var detailReferenceNoArray = [];
	var exercisedQuantityBlankFlag = false;
	var rowNoArray = [];
	var exercisedQuantityExceedFlag = false;
	xenos.ns.rightsExerciseAmend.selectedRecordsIndex = [];
	var exercisingQtyStrArr = [];
	var takeUpCostStrArr = [];
	var paymentDateStrArr =[];
	var paymentDateNewShareStrArr = [];
	var availaibleDateStrArr = [];
	var exerciseFinaliseArr = [];
	var exerciseDateStrArr = [];
	var expiryQtyStrArr = [];
	
	function customPush(val,arr)
	{
		if(val=="" || val == null)
			arr.push(" ");
		else
			arr.push(val);
			
		
	}
	
	for (i = 0; i < lngth; i++) {
		
		if (!isChecked) {
			isChecked = true;
		}
		
		if(isNaN($.trim(gridData[selectedGrid[i]]['exercisingQuantityStr']).replace(/\,/g,"")))
		{
			
			validationMessages.push(xenos$CAX$i18n.rightsExerciseAmend.valid_exercising_quantity);
			
		}
		else if(/^[, ]+$/.test(gridData[selectedGrid[i]]['exercisingQuantityStr']))
		{
			validationMessages.push(xenos$CAX$i18n.rightsExerciseAmend.valid_exercising_quantity);
		}
		else if($.trim(gridData[selectedGrid[i]]['exercisingQuantityStr']).replace(/\,/g,"")<0)
		{
			validationMessages.push(xenos$CAX$i18n.rightsExerciseAmend.valid_exercising_quantity);
		}
		else
		{
			fldValueArr = ($.trim(gridData[selectedGrid[i]]['exercisingQuantityStr']).replace(/\,/g,"")).split(".");
			if(fldValueArr[0].length > 15){
				validationMessages.push(xenos$CAX$i18n.rightsExerciseAmend.valid_before_decimal);
			}
			if(typeof fldValueArr[1] !='undefined' && fldValueArr[1].length > 3)
			{
				validationMessages.push(xenos$CAX$i18n.rightsExerciseAmend.valid_after_decimal);
			}
		}
		
		if(isNaN($.trim(gridData[selectedGrid[i]]['totalSubscriptionCostStr']).replace(/\,/g,"")))
		{
			
			validationMessages.push(xenos$CAX$i18n.rightsExerciseAmend.valid_takeup_cost);
			
		}
		else if(/^[, ]+$/.test(gridData[selectedGrid[i]]['totalSubscriptionCostStr']))
		{
			validationMessages.push(xenos$CAX$i18n.rightsExerciseAmend.valid_takeup_cost);
		}
		else if($.trim(gridData[selectedGrid[i]]['totalSubscriptionCostStr']).replace(/\,/g,"")<0)
		{
			validationMessages.push(xenos$CAX$i18n.rightsExerciseAmend.amount_negative);
		}
		else
		{
			fldValueArr = ($.trim(gridData[selectedGrid[i]]['totalSubscriptionCostStr']).replace(/\,/g,"")).split(".");
			if(fldValueArr[0].length > 15){
				validationMessages.push(xenos$CAX$i18n.rightsExerciseAmend.valid_before_decimal);
			}
			if(typeof fldValueArr[1] !='undefined' && fldValueArr[1].length > 3)
			{
				validationMessages.push(xenos$CAX$i18n.rightsExerciseAmend.valid_after_decimal);
			}
		}
		if(isDateCustom($.trim(gridData[selectedGrid[i]]['paymentDateStr']))== false)
		{
			validationMessages.push(xenos$CAX$i18n.rightsExerciseAmend.valid_payment_date);
			
		}
		if(isDateCustom($.trim(gridData[selectedGrid[i]]['paymentDateCashStr']))== false)
		{
			validationMessages.push(xenos$CAX$i18n.rightsExerciseAmend.valid_payment_date);
			
		}
		if($.trim(gridData[selectedGrid[i]]['availableDateStr']) == "")
		{
		}
		else if(isDateCustom($.trim(gridData[selectedGrid[i]]['availableDateStr']))== false)
		{
			validationMessages.push(xenos$CAX$i18n.rightsExerciseAmend.valid_availaible_date);
		}
		if(isDateCustom($.trim(gridData[selectedGrid[i]]['exerciseDateStr']))== false)
		{
			validationMessages.push(xenos$CAX$i18n.rightsExerciseAmend.valid_exercise_date);	
		}
		if (validationMessages.length > 0) {
			xenos.utils.displayGrowlMessage(xenos.notice.type.error, validationMessages);
			return false;
		}
		xenos.ns.rightsExerciseAmend.selectedRecordsIndex.push(gridData[selectedGrid[i]]['rowID']);
		
		customPush($.trim(gridData[selectedGrid[i]]['totalSubscriptionCostStr']).replace(/\,/g,""),takeUpCostStrArr);
		customPush(gridData[selectedGrid[i]]['paymentDateStr'],paymentDateStrArr);
		customPush(gridData[selectedGrid[i]]['paymentDateCashStr'],paymentDateNewShareStrArr);
		customPush(gridData[selectedGrid[i]]['availableDateStr'],availaibleDateStrArr);
		
		customPush(gridData[selectedGrid[i]]['exerciseFinalizeFlag'],exerciseFinaliseArr);
		
		customPush(gridData[selectedGrid[i]]['exerciseDateStr'],exerciseDateStrArr);
		
		customPush($.trim(gridData[selectedGrid[i]]['expiryQuantityStr']).replace(/\,/g,""),expiryQtyStrArr);
		
		rowNoArray.push(gridData[selectedGrid[i]]['rowID']);
		
		if($.trim(gridData[selectedGrid[i]]['exercisingQuantityStr']) == ""){
					
    				var exerciseFinalizeFlag = gridData[selectedGrid[i]]['exerciseFinalizeFlag'];
    				var prevFinalizeFlag = gridData[selectedGrid[i]]['prevFinalizeFlag'];
					
    				if(exerciseFinalizeFlag!=prevFinalizeFlag ){
    				  	gridData[selectedGrid[i]]['exercisingQuantityStr']="0";   
						customPush("0",exercisingQtyStrArr);				
    				}
    				else{
    					exercisedQuantityBlankFlag = true;
						customPush($.trim(gridData[selectedGrid[i]]['exercisingQuantityStr']).replace(/\,/g,""),exercisingQtyStrArr);
    				}
				
    			}else
				{
					customPush($.trim(gridData[selectedGrid[i]]['exercisingQuantityStr']).replace(/\,/g,""),exercisingQtyStrArr);
				}
				
		
		
		
		var exercisingQuantityNum = parseFloat($.trim(gridData[selectedGrid[i]]['exercisingQuantityStr']).replace(/\,/g,""));
    	var availableRightsNum	  = parseFloat($.trim(gridData[selectedGrid[i]]['availableRightsStr']).replace(/\,/g,""));
    	var exercisedQuantityNum  = parseFloat($.trim(gridData[selectedGrid[i]]['exerciseQuantityStr']).replace(/\,/g,""));
		
		if(exercisingQuantityNum > (availableRightsNum + exercisedQuantityNum) ){
	    			
	    			exercisedQuantityExceedFlag = true;
	    			break;
	    		}
	}
	    if(exercisedQuantityBlankFlag){
    		exercisedQuantityBlankFlag = false;
			validationMessages.push(xenos$CAX$i18n.rightsExerciseAmend.valid_exercise_quantity);		
    	}
    	if(exercisedQuantityExceedFlag){
    		exercisedQuantityExceedFlag = false;
    		validationMessages.push(xenos$CAX$i18n.rightsExerciseAmend.availaible_exercise_quantity);
    	}
		
		if (validationMessages.length > 0){
			xenos.utils.displayGrowlMessage(xenos.notice.type.error, validationMessages);
			return false;
		}
		
	
		
		
		
		

	var container = $("#content");
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&fragments=content';
	var context = $target.closest('#content');

	var requestUrl = xenos.context.path + "/secure/cax/exercise/query/rightsExerciseAmendUC"+commandFormId+fragmentName;	
									
	

	$(e.target).attr('disabled', true);
	
		xenos$Handler$rightsExerciseAmend2
			.generic(
						e,
						{
							requestUri : requestUrl,
							settings : {
						           data :	jQuery.param({
											fragments : 'content',
											rowNoArray : rowNoArray,
											exercisingQtyStrArr : exercisingQtyStrArr,
											takeUpCostStrArr : takeUpCostStrArr,
											paymentDateStrArr : paymentDateStrArr,
											paymentDateNewShareStrArr :paymentDateNewShareStrArr,
											availaibleDateStrArr : availaibleDateStrArr,
											exerciseFinaliseArr :exerciseFinaliseArr,
											exerciseDateStrArr: exerciseDateStrArr,
											expiryQtyStrArr : expiryQtyStrArr

									},true),
							complete: function() {
													$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
												}			
											
							},
							onHtmlContent : function(e, options, $target, content) {
								       
										$target.html(content);
										
										
										var msg = [];
										 if(content.indexOf('xenosWarn')!=-1)
										 {$.each($('ul.xenosWarn li',container),
														function(index, value) {
															
															var msgStr = $(value).text();

															if (msgStr !== '')
																msg.push(msgStr);
														});

												xenos.utils.displayGrowlMessage(xenos.notice.type.warning, msg);
										 }
										
										 if(content.indexOf('xenosError')==-1){
											
											$('.tabArea').hide();
											$('.entrySubmitBtn', container).hide();
											$('.exerciseBackBtn', container).show();
											$('.exerciseCnfBtn', container).show();
											$('.okBtn', container).hide();
											$('.resetBtn', container).hide();
											
											
										} else
										{	
												var msg = [];
												
												$.each($('ul.xenosError li',container),
														function(index, value) {
															
															var msgStr = $(value).text();

															if (msgStr !== '')
																msg.push(msgStr);
														});

												xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
												setTimeout(function()
														{$('.xenos-grid').data("gridInstance").setSelectedRows(xenos.ns.rightsExerciseAmend.selectedRecordsIndex);
														},10);					
												$.each(gridInstanceArray || [], function(
														ind, grid) {
													grid.destroy();
												});
										}
										
										
							}
							
							
						}
					); 
	
};



//Reset Handler in Query Result Screen

xenos.ns.rightsExerciseAmend.resethandler = function(e) {

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
	var requestUrl = xenos.context.path + "/secure/cax/exercise/query" + "/resetResult"+commandFormId+fragmentName;			
	
	$(e.target).attr('disabled', true);
	
	xenos$Handler$rightsExerciseAmend2
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
										
										if(content.indexOf('xenosError')==-1){
		
											
											$('.entrySubmitBtn', container).show();
											$('.exerciseBackBtn', container).hide();
											$('.exerciseCnfBtn', container).hide();
											$('.okBtn', container).hide();
											$('.resetBtn', container).show();
											
											
										} 
									
						}
					}
					);
	
};

// Handler to Calculate the TakeUpCost	
xenos.ns.rightsExerciseAmend.calculateTakeUpCost  = function(e,args){
	    e.preventDefault();
		var $target = $(e.target);
	    if(args == "undefined"){
		   return false;
	    }
	    if(args.grid == "undefined"){
		   return false;
	    }
	    if(args.item == "undefined"){
		   return false;
	    }
		
	    var grid = args.grid;
		var selectedGrid = grid.getSelectedRows();
	    var isRowSelected = args.item.selected;
		var lngth = selectedGrid.length;
		var validationMessages = [];
		var flag = false; 
		
		//Check if the row is selected or not
		
		for(i=0;i<lngth;i++){
			if(grid.getData().getItems()[selectedGrid[i]]['rowID'] == args.item.rowID){
			flag =true;
			}
		}
			if(!flag)
			{
				validationMessages.push(xenos$CAX$i18n.rightsExerciseAmend.select_record);
				xenos.utils.displayGrowlMessage(xenos.notice.type.error, validationMessages);
				return false;
			}
	    
		//Validate the data
		
		if(args.item['exercisingQuantityStr'] === "" || args.item['exercisingQuantityStr'] == null) {
			validationMessages.push(xenos$CAX$i18n.rightsExerciseAmend.enter_exercising_qty);
		}
	
		if (validationMessages.length > 0){
			xenos.utils.displayGrowlMessage(xenos.notice.type.error, validationMessages);
			return false;
		}
		
		var selectedRowIndex = $target.closest(".slick-row").attr('row');	
		var index ;
		var exerciseQty ;
		index = args.item.rowID;
		exerciseQty = args.item['exercisingQuantityStr'];
		var container = $("#content");
		var form = $('#queryResultForm', container);
		var commandFormId = '?commandFormId=' + $('[name=commandFormId]', container).val();
		var fragmentName = '&fragments=content';
		var indexUrl = '&index='+index;
		var exerciseQtyURL = '&exerciseQty='+exerciseQty;
	    var uri = xenos.context.path + "/secure/cax/exercise/query/calculatetakeupcost/"+index+"/"+exerciseQty;
		uri += commandFormId;
		$target.attr('disabled', true);
		xenos$Handler$rightsExerciseAmend.generic(e, {
					requestUri: uri,
					settings: {},
					onJsonContent: function (e, options, $target, content) {
						$target.removeAttr('disabled');
						var gridData = grid.getData().getItems();
						if (content.success == true) {
							xenos.utils.clearGrowlMessage();
							
							gridData[selectedRowIndex]['totalSubscriptionCostStr'] = content.value[1];
							grid.updateRow(selectedRowIndex);
							if(grid.getEditorLock().isActive()){
								grid.getEditorLock().commitCurrentEdit();
							}
						}else{
							xenos.utils.displayGrowlMessage(xenos.notice.type.error, content.value[0]);
						}
					}
		}); 
	};
	
	
	xenos.ns.rightsExerciseAmend.backhandler = function(e) {
   
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
	var requestUrl =  xenos.context.path + "/secure/cax/exercise/query" + "/resetResult"+commandFormId+fragmentName;			
	$(e.target).attr('disabled', true);
	xenos$Handler$rightsExerciseAmend2
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
								
								if(content.indexOf('xenosError')==-1){

									
									$('.entrySubmitBtn', container).show();
									$('.exerciseBackBtn', container).hide();
									$('.exerciseCnfBtn', container).hide();
									$('.okBtn', container).hide();
									$('.resetBtn', container).show();
									
									
								} 
							
				}
			}
			);
	
	
};


xenos.ns.rightsExerciseAmend.confirmhandler = function(e) {

	var $target = $(this);
	var context = $target.closest('.formContent');
	var uri = xenos.context.path;
	var gridInstanceArray = [];
	
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
	var requestUrl = xenos.context.path + "/secure/cax/exercise/query/rightsExerciseAmendSC"+commandFormId+fragmentName;			
	$(e.target).attr('disabled', true);
	
	
	
	xenos$Handler$rightsExerciseAmend2
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
												
											}, true),
											
							
							complete: function() {
													$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
												}		
						},
						onHtmlContent : function(e, options, $target, content) {
									$target.html(content);
									xenos.utils.clearGrowlMessage();
										if(content.indexOf('xenosError')==-1){
											
											$('.tabArea').hide();
											$('.entrySubmitBtn', container).hide();
											$('.exerciseBackBtn', container).hide();
											$('.exerciseCnfBtn', container).hide();
											$('.exerciseOkBtn', container).show();
											$('.resetBtn', container).hide();
											
											
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

												xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
												$('.tabArea').hide();
											$('.entrySubmitBtn', container).hide();
											$('.exerciseBackBtn', container).show();
											$('.exerciseCnfBtn', container).show();
											$('.okBtn', container).hide();
											$('.resetBtn', container).hide();						
												$.each(gridInstanceArray || [], function(
														ind, grid) {
													grid.destroy();
												});
										}
						}
					}
					);
	
};


xenos.ns.rightsExerciseAmend.okhandler = function(e) {
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
	var requestUrl = xenos.context.path + "/secure/cax/exercise/query" + "/resetResult"+commandFormId+fragmentName;			
	
	$(e.target).attr('disabled', true);
	
	xenos$Handler$rightsExerciseAmend2
			.generic(
					e,
					{
						requestUri : requestUrl,
						settings : {
							type: "POST"
							

						},
						
						onHtmlContent : function(e, options, $target, content) {
							xenos.utils.clearGrowlMessage();
									$target.html(content);
										if ($('.xenos-grid', container).length > 0) {
												var xenosgrid = $(
														'#queryResultForm .xenos-grid',
														container).xenosgrid(
														grid_result_data,
														grid_result_columns,
														grid_result_settings);
									    }
										
										if(content.indexOf('xenosError')==-1){
		
											
											$('.entrySubmitBtn', container).show();
											$('.exerciseBackBtn', container).hide();
											$('.exerciseCnfBtn', container).hide();
											$('.okBtn', container).hide();
											$('.resetBtn', container).show();
											
											
										} 
									
						}
					}
					);
};