//$Id$
//$Author:$
//$Date: $

/**
 * Populate the value for Closeout Quantity of Open and Close trades
 */
xenos.ns.views.closeoutEntry.populateQuantityString = function(){
	// open trade
	var openTrdSelectedIndx = $('#openTradeRadio').val();
	$('#openTradeQtyStr').val($('#openTradeCloseQty_' + openTrdSelectedIndx).val());
	// close trade
	var closeTrdSelectedIndx = $('#closeTradeRadio').val();
	$('#closeTradeQtyStr').val($('#closeTradeCloseQty_' + closeTrdSelectedIndx).val());
}

/**
 * Validate Closeout Quantity of Open and Close trades
 */
xenos.ns.views.closeoutEntry.validateCloseoutEntry = function(){
	var validationMessages = [];
	// validate open trade closeout quantity
	var openTrdSelectedIndx = $('#openTradeRadio').val();
	var openQtyId = "openTradeCloseQty_" + openTrdSelectedIndx;
	formatSignedRate($('#' + openQtyId),15,3,validationMessages,'Open trade closeout quantity');
	// validate close trade closeout quantity
	var closeTrdSelectedIndx = $('#closeTradeRadio').val();
	var closeQtyId = "closeTradeCloseQty_" + closeTrdSelectedIndx;
	formatSignedRate($('#' + closeQtyId),15,3,validationMessages,'Close trade closeout quantity');
	//Show the error message
	if(validationMessages.length > 0){
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, validationMessages, true));
		return false;
	}else{
		$('.formHeader').find('.formTabErrorIco').css('display', 'none');
	}
	return true;
}
