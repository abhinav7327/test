//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
var consolidateParmas = function(e){
	var row = $(e.target).attr('row');
    var gridData = ($('.xenos-grid').data("gridInstance")).getData().getItems();
    var params = '&pk='+gridData[row]['accountPk'];
    $('a.consolidateActLink').data("params", params);
	var l = $('.consolidateActionArea').find('a.consolidateActLink').length;
	var obj=$('.consolidateActionArea a.consolidateActLink');
	for(var i=0; i<l; i++) {
		var href = obj[i].attributes['href'];
		console.log(href);
		var hrefVal = href.value;
		var cpType = gridData[row]['counterPartyType'];
		if(cpType=='BROKER') {
			if (hrefVal.indexOf('fundAccount') > 0) {
				hrefVal = hrefVal.replace('account/fundAccount','account/broker');
			} else if (hrefVal.indexOf('bankCustodian') > 0) {
				hrefVal = hrefVal.replace('account/bankCustodian','account/broker');
			} else if (hrefVal.indexOf('broker') < 0) {
				hrefVal = hrefVal.replace('account','account/broker');
			}
		} 
		if(cpType=='BANK/CUSTODIAN') {
			if (hrefVal.indexOf('fundAccount') > 0) {
				hrefVal = hrefVal.replace('account/fundAccount','account/bankCustodian');
			} else if (hrefVal.indexOf('broker') > 0) {
				hrefVal = hrefVal.replace('account/broker','account/bankCustodian');
			} else if (hrefVal.indexOf('bankCustodian') < 0) {
				hrefVal = hrefVal.replace('account','account/bankCustodian');
			}
		}
		if(cpType=='FUND') {
			if (hrefVal.indexOf('broker') > 0) {
				hrefVal = hrefVal.replace('account/broker','account/fundAccount');
			} else if (hrefVal.indexOf('bankCustodian') > 0) {
				hrefVal = hrefVal.replace('account/bankCustodian','account/fundAccount');
			} else if (hrefVal.indexOf('fundAccount') < 0) {
				hrefVal = hrefVal.replace('account','account/fundAccount');
			}
		}
		obj[i].attributes['href'].value=hrefVal;
	} 
};
