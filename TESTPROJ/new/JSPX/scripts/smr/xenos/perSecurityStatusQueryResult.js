//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
	
var xenos$Handler$perSecurityStatusQueryResult = xenos$Handler$function({
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
	
	
	//Reset Handler in Query Result Screen

xenos.ns.views.perSecurityStatusQuery.resethandler = function(e) {

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
	var requestUrl = xenos.context.path + "/secure/smr/persecurity/query" + "/resetResult"+commandFormId+fragmentName;			
	console.log(requestUrl);
	$(e.target).attr('disabled', true);
	
	xenos$Handler$perSecurityStatusQueryResult
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
										
											$('.resetBtn', container).show();
											
											
										} 
									
						}
					}
					);
	
};