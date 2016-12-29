//$Id$
//$Author: Saravanan $
//$Date: 2016-12-24 15:37:59 $

var consolidateParmas = function(e){
	var row = $(e.target).attr('row');
    var gridData = ($('.xenos-grid').data("gridInstance")).getData().getItems();
    var parmas = '&pk='+gridData[row]['fundPk'] + '&fundPk='+gridData[row]['fundPk'] + '&fundCode='+gridData[row]['fundCode'];
    $('a.consolidateActLink').data("params", parmas);	
};