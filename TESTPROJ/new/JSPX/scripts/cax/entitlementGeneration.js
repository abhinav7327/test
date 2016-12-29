//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
var consolidateParmas = function(e){
	var row = $(e.target).attr('row');
    var gridData = ($('.xenos-grid').data("gridInstance")).getData().getItems();
    var parmas = '&pk='+gridData[row]['rightsConditionPk']+'&lmOfficeId='+lmOffice+'&fundCategory='+fundCategory;
    $('a.consolidateActLink').data("params", parmas);	
};
