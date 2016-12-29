//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
var xenos$Handler$CancelHandler = xenos$Handler$function({
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

xenos.ns.rightsExerciseCancel.submithandler = function(e) {
	var $target = $(this);
	
	var gridInstanceArray = [];
	var uri = xenos.context.path;
	uri += "/secure/cax/exercise/query";

	var context = $target.closest('#content');
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&fragments=content';
	var requestUrl = uri + "/submit/cancelRecords"+commandFormId+fragmentName;

	var container = $("#content");
	
	var grid = $('.xenos-grid').data("gridInstance");
	if(typeof grid == "undefined"){
		return false;
	}
	var gridData = grid.getData().getItems();
	var selectedGrid = grid.getSelectedRows();
	if(typeof grid == "undefined"){
		return false;
	}
	var validationMessages = [];
	 if (selectedGrid.length == 0) {
		 validationMessages.push(xenos$CAX$i18n.rightsExerciseCancel.no_record_selected);
	 }
	  if (validationMessages.length > 0){
		  xenos.utils.displayGrowlMessage(xenos.notice.type.error, validationMessages);
		  return false;
	  }
	  	
	var rightsExercisePkArray = [];
	xenos.ns.rightsExerciseCancel.selectedData = [];
	
	//Sort the selected rows as per the rowId, 
	//if the checkboxes are selected in reverse order, the sequence of records in the confirmation screen is also reverse. 
	selectedGrid.sort();
	
	$(selectedGrid).each(function(index) {
			rightsExercisePkArray.push(gridData[selectedGrid[index]]['rightsExercisePk']);
			xenos.ns.rightsExerciseCancel.selectedData.push(gridData[selectedGrid[index]]['rowId']);
		}); 
					
	//console.log(requestUrl);
	//Disable Both the submit and cancel buttons.
	$(e.target).attr('disabled', true);
	$("#resetCancelBtn").attr('disabled', true);
	
	xenos$Handler$CancelHandler
			.generic(
					e,
					{
						requestUri : requestUrl,
						settings : {
							data : jQuery
									.param(
											{
												rightsExercisePkArray : rightsExercisePkArray
											}, true),
						
							complete: function() {
													$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
												}			
											},
											
						onHtmlContent : function(e, options, $target, content) {
						
						$target.html(content);
						if (content.indexOf('xenosError') != -1) {
						$("#submitCancelBtn").attr("disabled",false);
						$("#resetCancelBtn").attr("disabled",false);
						
						var msg = [];
						
						$.each($('ul.xenosError li',container),
								function(index, value) {
									
									var msgStr = $(value).text();

									if (msgStr !== '')
										msg.push(msgStr);
								});

						xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
						
						setTimeout(function(){
							$('.xenos-grid').data("gridInstance").setSelectedRows(xenos.ns.rightsExerciseCancel.selectedData);
						},10);	
						
						$.each(gridInstanceArray || [], function(
								ind, grid) {
							grid.destroy();
						});
					   
					} else {
						$('.tabArea').hide();
							}	
								
						}
					}); 
	
};



//Reset Handler in Cancel Query Result Screen
xenos.ns.rightsExerciseCancel.resethandler = function(e) {
	var $target = $(this);
	var gridInstanceArray = [];
	var uri = xenos.context.path;
	uri += "/secure/cax/exercise/query";

	var context = $target.closest('#content');
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&amp;fragments=content';
	var requestUrl = uri + "/reset/cancelRecords"+commandFormId+fragmentName;

	var container = $("#content");
								
	//console.log(requestUrl);
	//Disable Both the submit and cancel buttons.
	$(e.target).attr('disabled', true);
	$("#submitCancelBtn").attr('disabled', true);
	
	xenos$Handler$CancelHandler
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
																							}			
											},
											
						onHtmlContent : function(e, options, $target, content) {
									$target.html(content);
									$("#resetCancelBtn").attr('disabled', false);
									$("#submitCancelBtn").attr('disabled', false);									
									xenos.ns.rightsExerciseCancel.selectedData = [];
																
							}
						}
					); 
	
};

xenos.ns.rightsExerciseCancel.confirmhandler = function(e) {
	var $target = $(this);
	var gridInstanceArray = [];
	var uri = xenos.context.path;
	uri += "/secure/cax/exercise/query";
	var context = $target.closest('#content');
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&fragments=content';
	var requestUrl = uri + "/confirm/cancelRecords"+commandFormId+fragmentName;

	var container = $("#content");
							
	//console.log(requestUrl);
	//Disable both confirm and back buttons
	$(e.target).attr('disabled', true);
	$("#backCancelBtn").attr('disabled', false);
	
	xenos$Handler$CancelHandler
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
												
							}			
											},
											
						onHtmlContent : function(e, options, $target, content) {
								
								$target.html(content);
								;
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
                                   
								} else {
									$("#confirmCancelBtn").hide();
									$("#backCancelBtn").hide();
									$("#okCancelBtn").show();
									
								}									
							}
						}
					); 
	
};
		
		
xenos.ns.rightsExerciseCancel.backtoqueryresulthandler = function(e){
		var $target = $(this);
		var gridInstanceArray = [];
		var uri = xenos.context.path;
		uri += "/secure/cax/exercise/query";
		var context = $target.closest('#content');
		var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
		var fragmentName = '&fragments=content';
		var requestUrl = uri + "/backToQueryResult/cancelRecords"+commandFormId+fragmentName;
		var xenosGrid;
		var container = $("#content");
									
		//console.log(requestUrl);
		$(e.target).attr('disabled', true);
		
		xenos$Handler$CancelHandler
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
									   
									} /*else {
										setTimeout(
												function() {
													var fullData = xenosGrid.getData()
															.getItems();
													var rows = [];
													for (i = 0; i < xenosGrid
															.getDataLength(); i++) {
														var rowData = fullData[i];
														if (rowData) {
															for(index=0; index<xenos.ns.rightsExerciseCancel.selectedData.length; index++){
																if(rowData['rightsExercisePk'] == xenos.ns.rightsExerciseCancel.selectedData[index]){
																	rows.push(i);
																}
															}

														}
													}						
															
													xenosGrid.setSelectedRows(rows);
												}, 10);
										
									}	*/								
								}
							}
						); 
			
			};
		
xenos.ns.rightsExerciseCancel.backFromOkHandler = function(e) {
	var $target = $(this);
	var gridInstanceArray = [];
	var uri = xenos.context.path;
	uri += "/secure/cax/exercise/query";

	var context = $target.closest('#content');
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&amp;fragments=content';
	var requestUrl = uri + "/returnFromOk/cancelRecords"+commandFormId+fragmentName;

	var container = $("#content");
								
	console.log(requestUrl);
	$(e.target).attr('disabled', true);
	
	xenos$Handler$CancelHandler
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
													
										}			
											},
											
						onHtmlContent : function(e, options, $target, content) {
									$target.html(content);
									xenos.ns.rightsExerciseCancel.selectedData = [];
									
									
							}
						}
					); 
	
};