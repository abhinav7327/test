//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
var xenos$Handler$ResetFinalizedFlag = xenos$Handler$function({
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

xenos.ns.resetFinalizedFlag.submithandler = function(e) {

	
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
	uri += "/secure/cax/entitlement/resetFinalizedFlag/query/resetFinalizedFlagUC";

	
	xenos.ns.resetFinalizedFlag.rightsDetailPk = [];
	var selectedGrid = grid.getSelectedRows();
	var isChecked = false;	
	selectedGrid.sort();
	if (typeof gridData == "undefined") {
		return false;
	}
	var reqObj = {};
	var validationMessages = [];
	if (selectedGrid.length == 0) {
		validationMessages.push(xenos$CAX$i18n.resetFinalizedFlag.no_record_selected);
	}
	if (validationMessages.length > 0) {
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
		return false;
	}
	var lngth = selectedGrid.length;
	var selectedDetailPkArray = [];
	var selectedFlag = [];
	var detailReferenceNoArray = [];
	
	for (i = 0; i < lngth; i++) {
		
		if (!isChecked) {
			isChecked = true;
		}
		selectedDetailPkArray
				.push(gridData[selectedGrid[i]]['rightsDetailPk']);
		selectedFlag.push('N');
		
		detailReferenceNoArray.push(gridData[selectedGrid[i]]['detailReferenceNo']);
		
		xenos.ns.resetFinalizedFlag.rightsDetailPk
				.push(gridData[selectedGrid[i]]['rightsDetailPk']);
		
	
		
		
		
		
		
	}
	var container = $("#content");
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&fragments=content';
	var context = $target.closest('#content');
	console.log(xenos.context.path);
	console.log(context.find('form').attr('action'));
	var requestUrl = xenos.context.path + "/secure/cax/entitlement/resetFinalizedFlag/query" + "/resetFinalizedFlagUC"+commandFormId+fragmentName;
									
	console.log(requestUrl);
	//console.log(selectedFlag );
	$(e.target).attr('disabled', true);
	
	xenos$Handler$ResetFinalizedFlag
			.generic(
					e,
					{
						requestUri : requestUrl,
						settings : {
							data : jQuery
									.param(
											{
												fragments : 'content',
												selectedFlag : selectedFlag,
												selectedDetailPkArray : selectedDetailPkArray

											}, true),
											
							complete: function() {
													$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
												}	
						},
						onHtmlContent : function(e, options, $target, content) {
							         
										$target.html(content);

										 if(content.indexOf('xenosError')==-1){
											$('.tabArea').hide();
											$('.entrySubmitBtn', container).hide();
											$('.resetFlagBackBtn', container).show();
											$('.resetFlagCnfBtn', container).show();
											$('.resetFlagOkBtn', container).hide();
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
															
											$.each(gridInstanceArray || [], function(
													ind, grid) {
												grid.destroy();
											});
											}
						}
					}
					);
	
		
};
xenos.ns.resetFinalizedFlag.backhandler = function(e) {
	   
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
	var requestUrl = xenos.context.path +"/secure/cax/entitlement/resetFinalizedFlag/query" + "/backToResult"+commandFormId+fragmentName;
	//console.log(requestUrl);
	$(e.target).attr('disabled', true);
	
	xenos$Handler$ResetFinalizedFlag
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
											$('.resetFlagBackBtn', container).hide();
											$('.resetFlagCnfBtn', container).hide();
											$('.resetFlagOkBtn', container).hide();
											$('.resetBtn', container).show();
											
											
										} 
									
						}
					}
					);

	
};

xenos.ns.resetFinalizedFlag.resethandler = function(e) {
	var $target = $(this);
	var gridInstanceArray = [];
	var context = $target.closest('.formContent');
	var reqObj = {};
	var uri = xenos.context.path;
	var grid = $('.xenos-grid', context).data("gridInstance");
	if (typeof grid == "undefined") {
		return false;
	}
	grid.setSelectedRows([]);
	
	
};


xenos.ns.resetFinalizedFlag.confirmhandler = function(e) {

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
	var requestUrl = xenos.context.path + "/secure/cax/entitlement/resetFinalizedFlag/query" + "/resetFinalizedFlagSC"+commandFormId+fragmentName;	
	$(e.target).attr('disabled', true);
	xenos$Handler$ResetFinalizedFlag
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
										if(content.indexOf('xenosError')==-1){
											$('.tabArea').hide();
											$('.entrySubmitBtn', container).hide();
											$('.resetFlagBackBtn', container).hide();
											$('.resetFlagCnfBtn', container).hide();
											$('.resetFlagOkBtn', container).show();
											$('.resetBtn', container).hide();
											xenos.utils.displayGrowlMessage(xenos.notice.type.info, xenos$CAX$i18n.resetFinalizedFlag.transaction_completed_successfully);
											
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
											$('.resetFlagBackBtn', container).show();
											$('.resetFlagCnfBtn', container).show();
											$('.resetFlagOkBtn', container).hide();
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


xenos.ns.resetFinalizedFlag.okhandler = function(e) {
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
	var requestUrl = xenos.context.path + "/secure/cax/entitlement/resetFinalizedFlag/query" + "/backToResult"+commandFormId+fragmentName;			
	//console.log(requestUrl);
	$(e.target).attr('disabled', true);
	
	xenos$Handler$ResetFinalizedFlag
			.generic(
					e,
					{
						requestUri : requestUrl,
						settings : {
							type: "POST"
							

						},
						
						onHtmlContent : function(e, options, $target, content) {
									
									$target.html(content);
									xenos.utils.clearGrowlMessage();
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
											$('.resetFlagBackBtn', container).hide();
											$('.resetFlagCnfBtn', container).hide();
											$('.resetFlagOkBtn', container).hide();
											$('.resetBtn', container).show();
											
											
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
												$('.entrySubmitBtn', container).show();
												$('.resetFlagBackBtn', container).hide();
												$('.resetFlagCnfBtn', container).hide();
												$('.resetFlagOkBtn', container).hide();
												$('.resetBtn', container).show();					
												$.each(gridInstanceArray || [], function(
														ind, grid) {
													grid.destroy();
												});
										}										
									
						}
					}
					);
};