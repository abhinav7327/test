//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
var _handleSavedQueryWidgetLinkClick = function(e) {
		e.preventDefault();
		if($(e.target).parents('.widgetHolder').hasClass('editable')){
			return;
		}
		var container = $("#content");
		var url = $(e.target).attr('href');
		// track plain click
		url += "&leftclick=";
		responseHandler = function (resData) {
			if (resData.status == 400 || resData.status == 403 || resData.status == 408 || resData.status == 0) {
				//Here we just only return. Post notice message will be displayed by Global handler.
				return;
			}
			//Check the return page if return page equal query result then render grid.
			if ($('#queryForm',container).length == 0) {
				
				// If it is a multi-query result page
				if($('#isMultiQuery', container).length != 0){
					
					// If "isMultiQuery" element value is "true"
                    if($('#isMultiQuery', container).val() == 'true'){

                        // Get all ".xenos-grid" elements
                        var obj = $('#queryResultForm .xenos-grid',container);

                        // Calculate the grid-height based on the number of grids 
                        var gridHeight = Math.ceil($(container).height()/obj.length) - 60;

                        for(var i = 0; i < obj.length; i++){

                            // Create the grid on each div with class 'xenos-grid' 	
                            $(obj[i]).xenosmultigrid(grid_result_data[i], grid_result_columns[i], grid_result_settings[i]);

                            // Adjust the height of the divs to prevent unusual grid height
                            $(obj[i]).height(gridHeight);
                        }
                    }
					
				}else{
					
					$('#queryResultForm .xenos-grid',container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
					
				}
			}
		}
		
		var xenos$Handler$asynchronousSavedQuery = xenos$Handler$function({
			get: {
				requestType: xenos$Handler$default.requestType.asynchronous,
				target: '#content'
			},
			settings: {
				beforeSend: function(request) {
					request.setRequestHeader('Accept', 'text/html;type=ajax');				
				},
				type: 'GET',
				complete: responseHandler
			}
		});
		xenos$Handler$asynchronousSavedQuery.generic(e, {requestUri: url});
};