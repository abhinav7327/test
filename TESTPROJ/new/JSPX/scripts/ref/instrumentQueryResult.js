//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
var consolidateParmas = function(e){
	var row = $(e.target).attr('row');
    var gridData = ($('.xenos-grid').data("gridInstance")).getData().getItems();
    var parmas = '&mode=amend&pk='+gridData[row]['instrumentPk']+'&itemIndex='+gridData[row]['itemIndex'];
    $('a.consolidateActLink').data("params", parmas);	
};