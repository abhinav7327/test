//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $

var xenos$Handler$stlcashtransferauthorization = xenos$Handler$function({
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

xenos.ns.completionCancelUserConf.submithandler = function(e) {

	
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
	uri += "/secure/stl/settlement/completion/query/submitConfirm";

	
	xenos.ns.completionCancelUserConf.selectedRecordsIndex = [];
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
		validationMessages.push(xenos$STL$i18n.completionCancel.cannotbeblank);
	}
	
	
	else{		
			for (i = 0; i < lngth; i++) {
		
			if (!isChecked) {
				isChecked = true;
				}
					selector.push(gridData[selectedGrid[i]]['detailHistoryPk']);
					
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

	//alert(historyPk);
	var fragmentName = '&fragments=content';
	var context = $target.closest('#content');
	var requestUrl = xenos.context.path + "/secure/stl/settlement/completion/query" + "/submitCancel"+commandFormId+fragmentName;
	$(e.target).attr('disabled', true);
	
	xenos$Handler$stlcashtransferauthorization
			.generic(
					e,
					{
						requestUri : requestUrl,
						settings : {
							data : jQuery
									.param(
											{
												fragments : 'content',
												detailHistPkArray : selector
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




xenos.ns.completionCancelUserConf.confirmhandler = function(e) {

	
	var $target = $(this);
	var gridInstanceArray = [];
	var context = $target.closest('.formContent');
	var reqObj = {};
	var uri = xenos.context.path;
	
	
	var grid = $('.xenos-grid', context).data("gridInstance");
	
	var gridData = grid.getData().getItems();
	uri += "/secure/stl/settlement/completion/query/submitConfirm";

	
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
	var requestUrl = xenos.context.path + "/secure/stl/settlement/completion/query" + "/submitConfirm"+commandFormId+fragmentName;
	$(e.target).attr('disabled', true);
	
	xenos$Handler$stlcashtransferauthorization
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
	
};


	xenos.ns.completionCancelUserConf.backhandler = function(e) {
   
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
	var requestUrl = xenos.context.path + "/secure/stl/settlement/completion/query" + "/backToResult"+commandFormId+fragmentName;
	$(e.target).attr('disabled', true);
	
	xenos$Handler$stlcashtransferauthorization
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

xenos.ns.completionCancelUserConf.okhandler = function(e) {
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
	var requestUrl = xenos.context.path + "/secure/stl/settlement/completion/query" + "/resetResult"+commandFormId+fragmentName;			
	//console.log(requestUrl);
	$(e.target).attr('disabled', true);
	
	xenos$Handler$stlcashtransferauthorization
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

															if (msgStr !== '')
																msg.push(msgStr);
														});
												xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
																
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
};

 