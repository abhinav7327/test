//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
var consolidateParmas = function(e){
	var row = $(e.target).attr('row');
    var gridData = ($('.xenos-grid').data("gridInstance")).getData().getItems();
    var parmas = '&pk='+gridData[row]['tradePk']+'&matchStatus='+gridData[row]['matchStatus']+'&matchingSupressFlag='+gridData[row]['matchingSupressFlag'];
    $('a.consolidateActLink').data("params", parmas);	
};