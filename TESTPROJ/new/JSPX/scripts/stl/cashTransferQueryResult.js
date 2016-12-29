//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
var consolidateParmas = function(e){
	var row = $(e.target).attr('row');
    var gridData = ($('.xenos-grid').data("gridInstance")).getData().getItems();
    var parmas = '&mode=CANCEL&pk='+gridData[row]['clientSettlementInfoPk']+'&itemIndex='+gridData[row]['itemIndex'] +'&wrType='+gridData[row]['wireType']+'&cePk='+gridData[row]['cashEntryPk']+'&tradePk='+gridData[row]['tradePk']+'&authorizationStatus='+gridData[row]['authorizationStatus']+'&status='+gridData[row]['status'];
    $('a.consolidateActLink').data("params", parmas);	
};