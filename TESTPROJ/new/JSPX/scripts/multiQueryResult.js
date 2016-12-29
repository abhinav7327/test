//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
$('.tabs .query-tab').hover(
    function() {
        $(this).css("cursor", "hand");
    }
);
   
$('.tabs .query-tab').die();   
$('.tabs .query-tab').live('click', function(e){
	//Collecting Grids for clean up
	var gridInstanceArray = [];
    var grids = $("[class*=slickgrid_]", $(e.target).parents('#queryResultForm'));
    $.each(grids, function (ind, grid) {
		if($(grid).data("gridInstance").getEditorLock().isActive()){
			$(grid).data("gridInstance").getEditorLock().commitCurrentEdit();
		}
        gridInstanceArray.push($(grid).data("gridInstance"));
    });
    e.preventDefault();
	if(!gridInstanceArray){
		return false;
	}

	xenos.utils.clearGrowlMessage();
    xenos$Handler$asyncQryFormTab.generic(e,{'gridInstance' : gridInstanceArray});
});

var xenos$Handler$asyncQryFormTab = xenos$Handler$function({
    get: {
        requestUri: function(event){
										var container,backUrl;
										if($(event.target).parents(".ui-dialog").size()>0){
											$(event.target).attr('saved',true);
											container = $(event.target).closest(".ui-dialog-content");
											backUrl = container.attr('action');
											if(!backUrl){
												backUrl = $('#queryResultForm',container).attr('action');
											}
										}
										else{
											container = $("#content");
											backUrl = $('#queryResultForm',container).attr('action');
										}
									var commandFormId = '?commandFormId='+$('[name=commandFormId]',container).val();
									return xenos.context.path + backUrl + commandFormId;
											
									},	
        requestType: xenos$Handler$default.requestType.asynchronous,
        target: function(event){
								if($(event.target).parents(".ui-dialog").size()>0){
									return "#" + $(event.target).closest(".ui-dialog-content").attr("id");
								}
								else	
									return '#content'; 
								}	
    },
	callback:{
			"success": function(event,options){		
											if($(event.target).attr('saved')!==undefined){
												setTopMost();
												container = $('.ui-dialog.topMost .ui-dialog-content #formContainer');
												container.removeClass('paddingFour');
												container.children('.transBg').removeClass('transBg');
											}
											//Clean the Slick Grid
											if(options){
												$.each(options['gridInstance'] || [], function (ind, grid) {
													grid.destroy();
												});
											}
									}
	},	
    settings: {
        beforeSend: function(request) {
            request.setRequestHeader('Accept', 'text/html;type=ajax');
        },
        type: 'POST',
        data: { fragments: 'content'}
    }
});

// asynchronous handler
var xenos$Handler$asynchronous$popup = xenos$Handler$function({
  get: {
    requestType: xenos$Handler$default.requestType.asynchronous
  },
  settings: {
    beforeSend: function(request) {
      request.setRequestHeader('Accept', 'text/html;type=ajax');
    },
	data: {fragments: 'content'},
	type: "GET"
  }
});




