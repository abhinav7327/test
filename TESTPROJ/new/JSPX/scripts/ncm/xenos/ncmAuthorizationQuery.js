//$Id$
//$Author: sumitag $
//$Date: 2016-12-23 14:24:30 $
var xenos$Handler$ncmauthorization = xenos$Handler$function({
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

/*
* Submit Handler
*/

xenos.ns.views.ncmAuthorizationQueryValidator.submitHandler = function(){
	
       
	    var $target = $(this);
 		var container = $('#content');	
			var authReject = "";
			var atLeastOneSelected = false;
			var authRejectArray = [];
			var gridDataArray = [];			
			var validationMessages = [];
		
		var context = $target.closest('.formContent');
		var reqObj = {};
		var uri = xenos.context.path;
		var grid = $('.xenos-grid',context).data("gridInstance");
		
		
		if(typeof grid == "undefined"){
			return false;
		}
		
		var gridData = grid.getData().getItems();
		
		
		var selectedRowElement = $target.closest('.slick-row');
		 for (i=0 ; i< grid.getDataLength() ; i++){
				
 				authReject = gridData[i]['authorizationStatus']; 
                				
				if($.trim(authReject) != ''){
			
					atLeastOneSelected = true;
					gridDataArray.push(gridData[i]);
					
				}
		}
		
		 if(!atLeastOneSelected) {
		
			validationMessages.push(xenos$NCM$i18n.authorizationAdjustment.validation.no_selected);			
		}
		
			if (validationMessages.length > 0){
			   
				xenos.utils.displayGrowlMessage(xenos.notice.type.error, validationMessages);
				return false;
			} 
			
			for (i=0 ; i< gridDataArray.length ; i++){	
				
				reqObj['selectedAuthRejectArray['+i+']'] = gridDataArray[i]['authorizationStatus'];			
				reqObj['selectedNcmEntryPkArray['+i+']'] = gridDataArray[i]['ncmEntryPk'];
				reqObj['selectedGroupIdArray['+i+']'] = gridDataArray[i]['groupId'];
			}
		
		
	xenos$Handler$default.generic(undefined, {
	  requestUri: xenos.context.path + '/secure/ncm/authorization/query/submitauthorize' + '?commandFormId=' + $('[name=commandFormId]').val() + "&fragments=content",
	  requestType: xenos$Handler$default.requestType.asynchronous,
	  onHtmlContent: function(e, options, $target, content) {
	  if(content.indexOf('xenosError')!=-1){
						
							var msg = [];
							$.each($('ul.xenosError li',content), function(index, value) {
							  msg.push($(value).text());
							});
							xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
				}else{
				
				container.html(content);
				if ($('#queryForm',container).length == 0) {							
						$('#queryResultForm .xenos-grid',container).xenosgrid( grid_result_data, grid_result_columns, grid_result_settings);
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

xenos.ns.views.ncmAuthorizationQueryValidator.confirmHandler = function() {
	

	var $target = $(this);
	var container = $('#content');
		
	var context = $target.closest('#content');
	xenos$Handler$default.generic(undefined, {
	  requestUri: xenos.context.path + '/secure/ncm/authorization/query/confirmauthorize' + '?commandFormId=' + $('[name=commandFormId]').val() + "&fragments=content",
	  requestType: xenos$Handler$default.requestType.asynchronous,
	  onHtmlContent: function(e, options, $target, content) {		

			   if(content.indexOf('xenosError')!=-1){							
							
							var msg = [];
							$.each($('ul.xenosError li',content), function(index, value) {
							  msg.push($(value).text());
							});
							xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
				}else{
					
					var confirmationMessage=[];
					confirmationMessage.push(xenos$NCM$i18n.authorizationAdjustment.validation.auth_completion_confirm);
					if (confirmationMessage.length > 0){
					   
						xenos.utils.displayGrowlMessage(xenos.notice.type.info, confirmationMessage);
						
					}					
					
					container.html(content);     
				    $('.authorizeBackBtn',container).hide();
		            $('.authorizeOkBtn',container).show();
	                $('.authorizeConfirmBtn',container).hide();
					
					if ($('#queryForm',container).length == 0) {
							
					$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
					} 
					$('.tabArea',container).hide();
					$('.prevNextarea',container).hide();
					$('.queryColumnsReset',container).hide();
					
					
				}
			},
		settings: {
				  beforeSend: function(request) {
				 
					request.setRequestHeader('Accept', 'text/html;type=ajax');
				  },
				  type: 'POST'				  
				},
		target: '#content'  
		
			
	  });  
	
}



xenos.ns.views.ncmAuthorizationQueryValidator.backHandler = function(){

	xenos.utils.clearGrowlMessage();
	var container = $('#content');
	xenos$Handler$default.generic(undefined,{
		requestUri: xenos.context.path + '/secure/ncm/authorization/query' + '/result?commandFormId=' + $('[name=commandFormId]').val() + "&fragments=content",
		requestType: xenos$Handler$default.requestType.asynchronous,
		onHtmlContent: function(e, options, $target, content) {
					 if(content.indexOf('xenosError')!=-1){							
							
							var msg = [];
							$.each($('ul.xenosError li',content), function(index, value) {
							  msg.push($(value).text());
							});
							xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
				}else{
				   $('.result-tab',container).addClass('active');
					container.html(content);
					if ($('#queryForm',container).length == 0) {
								$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
							}
				}
				},
		settings: {
				  beforeSend: function(request) {
					request.setRequestHeader('Accept', 'text/html;type=ajax');
				  },
				  type: 'POST'				  
				},
		target: '#content'				
		
	});
}


xenos.ns.views.ncmAuthorizationQueryValidator.okHandler = function(){

	var $target = $(this);

	var container = $('#content');
	xenos.utils.clearGrowlMessage();
	xenos$Handler$default.generic(undefined,{
		requestUri: xenos.context.path + '/secure/ncm/authorization/query' + '/result?commandFormId=' + $('[name=commandFormId]').val() + "&fragments=content",
		requestType: xenos$Handler$default.requestType.asynchronous,
		onHtmlContent: function(e, options, $target, content) {
					if(content.indexOf('xenosError')!=-1){							
							
							var msg = [];
							$.each($('ul.xenosError li',content), function(index, value) {
							  msg.push($(value).text());
							});
							xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
				}else{
				   $('.result-tab',container).addClass('active');
					container.html(content);
					xenos.utils.clearGrowlMessage();
					if ($('#queryForm',container).length == 0) {
								$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
							}
				}
				},
		settings: {
				  beforeSend: function(request) {
					request.setRequestHeader('Accept', 'text/html;type=ajax');
				  },
				  type: 'POST'				  
				},
		target: '#content'				
		
	});
}





