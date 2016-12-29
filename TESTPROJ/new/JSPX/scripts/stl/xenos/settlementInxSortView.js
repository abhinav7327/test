//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
var isINXReportMode=false;

function $settlementInstruction$onLoad$sortView() {
	console.log('Setting up sort view');
    $('#operationObjective').change(function() {
        if(($.trim($('option:selected', this).text())=='INX REPORT QUERY')){
			if(!isINXReportMode){
				isINXReportMode=true;
				modifySortView(isINXReportMode);
			}
		}
		else{
			if(isINXReportMode){
				isINXReportMode=false;
				modifySortView(isINXReportMode);
			}
		}

    });
	function modifySortView(){
			var mode =(isINXReportMode)?'INXReportMode':'normal';
		  xenos$Handler$settlementInstruction.generic(undefined, {
		  requestUri: xenos.context.path + '/secure/stl/trxMaintenance/instruction/query/sortView' + '?commandFormId=' + $('[name=commandFormId]').val()+'&mode='+mode,
		  onHtmlContent: function (e, options, $target, content) {									
							if(content.indexOf('xenosError')!=-1){
								var msg = [];
								$.each($('ul.xenosError li',content), function(index, value) {
								  msg.push($(value).text());
								});
								xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
							}else{
								$target.html($(content).find('#sortFormItemArea').html());
								var selected = $('#operationObjective option:selected').val();								
								$('#formContent').html($(content).find('#formContent').html());
								
								//init Operations
								$settlementInstruction$onLoad$sortView();
								$settlementInstruction$onLoad$fieldView();
								$('#operationObjective option[value="'+selected+'"]').prop('selected',true);
								$('.dateinput').xenosdatepicker();	
								$('.dropdowninputMulti').xenos$multiSelect();
								
							}							
						}
		  });  
	  
	}
	var xenos$Handler$settlementInstruction = xenos$Handler$function({
	  get: {
		requestType: xenos$Handler$default.requestType.asynchronous,
		 target: '#sortFormItemArea'					

	  },
	  settings: {
		beforeSend: function(request) {
		  request.setRequestHeader('Accept', 'text/html;type=ajax');
		},
		type: 'POST'
	  }
	});

 

}