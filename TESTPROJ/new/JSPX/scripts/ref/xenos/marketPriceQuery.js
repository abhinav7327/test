//$Id$
//$Author: Debnandini $
//$Date: 2016-12-23 19:25:11 $
 xenos.ns.marketPrice.validation.validateMktPrcQrySubmit = function(){
	
	var date = $("#baseDate").val();
	var price = $("#priceStrExp").val();
	var inputPrice = $("#inputPriceStr").val();
	
	var flag = true;
	var msgArray = new Array();
	
	if ((date != "" && date != null && date != undefined) && isDateCustom(date)==false){
		msgArray.push(xenos.utils.evaluateMessage(xenos.i18n.datevalidationmessage.incorrect_date,[date]));
		flag = false;
	}
	
	if(flag){
		formatMktPrcBaseDate(date);
	}	
		
	formatPrice($("#priceStrExp"), 9, 7, msgArray, $("#priceStrExp").parent().parent().find('label').text());
	formatPrice($("#inputPriceStr"), 9, 9, msgArray, $("#inputPriceStr").parent().parent().find('label').text());

	if (msgArray.length > 0){
		$('.formHeader').find('.formTabErrorIco').
			css('display', 'block').off('click').
				on('click', xenos.postNotice(xenos.notice.type.error, msgArray, true));
		flag = false;
	}
	return flag;
 }

 function formatMktPrcBaseDate(date){
	if(date.length == 7){
		$("#baseDate").val(date.substr(0,6)+"0"+date.substr(6));
	}
 }