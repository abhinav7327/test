//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
function populateValues(element, initial, popup) {
	
	var counterPartyType = $('.counterPartyCodeType', '#content');
	var formItem = '.formItem';
	var resetBtn = '.resetBtn';
	if (popup) {
		counterPartyType = $('.counterPartyCodeType',
				'.ui-dialog .ui-dialog-content');
		formItem = '.popFormItem';
		resetBtn = '.popResetBtn';

	}
	var selValue = $("option:selected", element).text();
	
	var counterpartycode = $(element).parents().children('.textBox').val();
	var popTypeOwnSsi = $('.ui-dialog-content').find('#popQueryForm').find(
			'#ownSsiPopUp').text();
	if (counterpartycode != '') {
		if (popTypeOwnSsi == 'Y') {
			initial = false;
		}
	}
	if (initial) {
		$(element).parents().children('.textBox').val('');
	}

	var statusCtx = $('.popupBtn .popupBtnIco', $(element).parents(formItem))
			.attr('cpTypeStatusCtx');

	$('.popupBtn .popupBtnIco', $(element).parents(formItem)).removeAttr(
			'finInstStatusCtx');
	$('.popupBtn .popupBtnIco', $(element).parents(formItem)).removeAttr(
			'customerStatusCtx');

	switch (selValue) {
	case "BROKER":
	case "BANK/CUSTODIAN": {
		$('.popupBtn .popupBtnIco', $(element).parents(formItem)).attr(
				'popType', 'finInstRoleType');
		$('.popupBtn .popupBtnIco', $(element).parents(formItem)).attr(
				'finInstStatusCtx', statusCtx);
		$('.popupBtn', $(element).parents(formItem)).show();

		if ($(element).parents().children('.counterPartyCode').length > 0) {
			$(element).parents().children('.counterPartyCode').show();
		}
		if ($(element).parents().children('#longShort').length > 0) {
			$(element).parents().find('#longShortFlag').find('option')
					.removeAttr("selected");
			;
			$(element).parents().children('#longShort').hide();
		}
		break;
	}
	case "CLIENT": {
		$('.popupBtn .popupBtnIco', $(element).parents(formItem)).attr(
				'popType', 'customer');
		$('.popupBtn .popupBtnIco', $(element).parents(formItem)).attr(
				'customerStatusCtx', statusCtx);
		$('.popupBtn', $(element).parents(formItem)).show();

		if ($(element).parents().children('.counterPartyCode').length > 0) {
			$(element).parents().children('.counterPartyCode').val("");
			$(element).parents().children('.counterPartyCode').hide();
		}
		if ($(element).parents().children('#longShort').length > 0) {
			$(element).parents().children('#longShortFlag option').removeAttr(
					"selected");
			$(element).parents().children('#longShort').show();
		}
		break;
	}
	case "INTERNAL": {
		$('.popupBtn .popupBtnIco', $(element).parents(formItem)).attr(
				'popType', 'customer');
		$('.popupBtn .popupBtnIco', $(element).parents(formItem)).attr(
				'customerStatusCtx', statusCtx);
		$('.popupBtn', $(element).parents(formItem)).show();

		if ($(element).parents().children('.counterPartyCode').length > 0) {
			$(element).parents().children('.counterPartyCode').val("");
			$(element).parents().children('.counterPartyCode').hide();
		}
		if ($(element).parents().children('#longShort').length > 0) {
			$(element).parents().children('#longShortFlag option').removeAttr(
					"selected");
			$(element).parents().children('#longShort').show();
		}
		break;
	}
	case "FIRM": {
		$('.popupBtn .popupBtnIco', $(element).parents(formItem)).attr(
				'popType', 'strategy');
		$('.popupBtn', $(element).parents(formItem)).show();

		if ($(element).parents().children('.counterPartyCode').length > 0) {
			$(element).parents().children('.counterPartyCode').val("");
			$(element).parents().children('.counterPartyCode').hide();
		}
		if ($(element).parents().children('#longShort').length > 0) {
			$(element).parents().children('#longShortFlag option').removeAttr(
					"selected");
			$(element).parents().children('#longShort').show();
		}
		break;
	}
	default: {
		$('.popupBtn', $(element).parents(formItem)).hide();

		if ($(element).parents().children('.counterPartyCode').length > 0) {
			$(element).parents().children('.counterPartyCode').val("");
			$(element).parents().children('.counterPartyCode').hide();
		}
		if ($(element).parents().children('#longShort').length > 0) {
			$(element).parents().children('#longShortFlag option').removeAttr(
					"selected");
			$(element).parents().children('#longShort').show();
		}
		break;
	}
	}
	$(resetBtn).die();
	if(!popup){
		$(resetBtn).live('click', function(e) {
			$('.popupBtn', $(counterPartyType).parents(formItem)).hide();
		});
	}
	
}
function counterpartychangefn(ev) {
	var _this = $(ev.target);
	var popup = ev.data.popup;
	var initial = ev.data.initial;
	populateValues(_this, initial, popup);

};

$('#content').find('.counterPartyCodeType').off('change');
$('#content').find('.counterPartyCodeType').on('change', {
	initial : true
}, counterpartychangefn);
$('.counterPartyCodeType', '.ui-dialog .ui-dialog-content').die();
$('.counterPartyCodeType', '.ui-dialog .ui-dialog-content').live('change', {
	initial : true,
	popup : 'popup'
}, counterpartychangefn);
