//$Id$
//$Author: nitesha $
//$Date: 2016-12-26 16:56:53 $



 
var xenos$Handler$tradeEntry = xenos$Handler$function({
  get: {
	requestType: xenos$Handler$default.requestType.asynchronous,
	 target: '#wizard-page'					

  },
  settings: {
	beforeSend: function(request) {
	  request.setRequestHeader('Accept', 'text/html;type=ajax');
	},
	type: 'POST'
  }
});

 function xenos$ns$views$tradeEntry$onGeneralPageLoad(){
	$("#formActionArea .btnsArea .wizNext").insertBefore($("#formActionArea .btnsArea .wizSubmit"));
	$("#formActionArea .btnsArea .wizNext").addClass("submitBtn");
	$("#formActionArea .btnsArea .wizNext .inputBtnStyle").show();
	$("#formActionArea .btnsArea .wizNext .inputBtnStyle").attr("value", "Submit");
	$("#formActionArea .btnsArea .wizNext .inputBtnStyle").removeAttr("disabled");	   
	$("#formActionArea .btnsArea .wizReset .inputBtnStyle").removeAttr("disabled");	   
	$("#formActionArea .btnsArea .wizSubmit").hide();   
	
	if($("#actionType").val()=="ENTRY"){	
		$("#quantity").closest("div").addClass('twoCols');		
		$("#formActionArea .btnsArea .wizPrev .inputBtnStyle").hide();
	}
	
	$(".popupBtn","#generalInfo").show();
	$("#detailInfo").css({ display : 'none'});
}

function xenos$ns$views$tradeEntry$onGeneralSubmit(){
	xenos$ns$views$tradeEntry$renderPage();	
    $("#detailInfo").css({ display : 'block'});	
	$("#tradeType").attr("disabled", "disabled");
	$("#tradeDate").attr("disabled", "disabled");
	$("#tradeDate").siblings($(".ui-datepicker-trigger")).hide();
	$(".popupBtn","#generalInfo").hide();
	$("#buySellOrientation").attr("disabled", "disabled");
	$("#tgtinventoryaccountno").attr("disabled", "disabled");
	$("#tgtbrokeraccountno").attr("disabled", "disabled");
	$("#tgtsecurityCode").attr("disabled", "disabled");
	$("#tradeCcy").attr("disabled", "disabled");
	$("#grossNetType").attr("disabled", "disabled");
	$("#formActionArea .btnsArea .wizSubmit").show();
	
	$("#formActionArea .btnsArea .wizPrev").insertAfter($("#formActionArea .btnsArea .wizReset"));        
	
	//change the label of Previous button based on action type
	if($("#actionType").val()=="ENTRY"){
		$("#formActionArea .btnsArea .wizPrev .inputBtnStyle").attr("value", "Back");
	}else if($("#actionType").val()=="AMEND"){
		$("#formActionArea .btnsArea .wizPrev .inputBtnStyle").attr("value", "Amend");
	}
	
	$("#formActionArea .btnsArea .wizPrev .inputBtnStyle").removeAttr("disabled");
	$("#formActionArea .btnsArea .wizPrev .inputBtnStyle").show();
	$("#formActionArea .btnsArea .wizNext .inputBtnStyle").hide();
	
	xenos$ns$views$tradeEntry$applyOtherFeatures();

	$("#tradeType").trigger('change');	
	
	xenos$ns$views$tradeEntry$checkPlSuppressFlag();
	
	if($("#actionType").val()=="AMEND"){
		lastSelect = $(':focus');
	}
	
	var nSelect = $(lastSelect);
	var curFocus = $(nSelect).attr('id');	
	$('input').removeClass('inpFocus');
	
	// remove Default focus on footer buutons
	$('body').find(':focus').blur();
	
	// map focused element before submit with the refreshed markup
	$('#wizard-page').find(':input').each(function(){
		if($(this).attr('id')==curFocus){			 
			 $(this).addClass('inpFocus');
		}
	});
}

function xenos$ns$views$tradeEntry$renderPage(){
	var winHeight = $(window).height();
	var entryContHeight = (winHeight - 225);
	$('.entryContainer', 'div#content').css('height',entryContHeight);
	$('.entryContainerConfirm','div#content').css('height',entryContHeight);
	
	//Date Picker
	$('input.dateinput', "#generalInfo").xenosdatepicker();
	$('input.dateinput', "#detailInfo").xenosdatepicker();
	
	//Market Tree
	$('input.market',"#generalInfo").treeview2({
		contentName: 'marketJson',
		type: "market"
	});
}
			  
			
/*
* Submit Handler
*/
function xenos$ns$views$tradeEntry$submitHandler(){
	// store last focused element
	lastSelect = $(':focus');
	
	//clear remarks
	$("#remarks").val("");
	
	if(xenos$ns$views$tradeEntry$validateGeneralSubmit() === false){
		return;
	}			
	xenos$Handler$tradeEntry.generic(undefined, {
	  requestUri: xenos.context.path + '/secure/trd/trade/entry/populate' + '?commandFormId=' + $('[name=commandFormId]').val(),
	  settings:{
		  data:  $("#commandForm").serialize()
	  },
	  onHtmlContent: function (e, options, $target, content) {									
						if(content.indexOf('xenosError')!=-1){
							var msg = [];
							$.each($('ul.xenosError li',content), function(index, value) {
							  msg.push($(value).text());
							});
							xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
						}else{
							$target.html(content);
							xenos$ns$views$tradeEntry$onGeneralSubmit();
							//set focus after xenos$ns$views$tradeEntry$onGeneralSubmit() fumction call
							$('.inpFocus').focus();
						}
					}
	  });  
	  return false;
}
			
/*
* Back Handler
*/
function xenos$ns$views$tradeEntry$backHandler(){
	
	$("#isInSecondPage").attr('value', false);
	
	xenos$ns$views$tradeEntry$onGeneralPageLoad();
	
	$("#backField").attr('value', true);
	$("#inSecondPageField").attr('value', false);
	$("#modeField").val("");
	
	$("#tradeType").removeAttr("disabled");
	$("#tradeDate").removeAttr("disabled");
	$("#tradeDate").siblings($(".ui-datepicker-trigger")).show();
	$("#buySellOrientation").removeAttr("disabled");
	$("#tgtinventoryaccountno").removeAttr("disabled");
	$("#tgtbrokeraccountno").removeAttr("disabled");
	$("#tgtsecurityCode").removeAttr("disabled");
	$("#tradeCcy").removeAttr("disabled");
	$("#grossNetType").removeAttr("disabled");
	$("#formActionArea .btnsArea .wizPrev .inputBtnStyle").hide();
	
	xenos$ns$views$tradeEntry$cleanPoolFactorAndCurrentFaceValue();
	$('#wizard-page').find(':input:not(:disabled):not([readonly]):visible:first').focus().addClass('fromAmend');
	return false;
}
 
/**
 *This function checks some mandatory fields for tax fee entry 
 */
function  xenos$ns$views$tradeEntry$validationForTax() {
    var taxRate 	= $.trim($('#taxRate',$tradeEntry$contaxt).val());
    var taxRateType = $.trim($('#taxRateType',$tradeEntry$contaxt).val());   
    var taxAmount 	= $.trim($('#taxAmount',$tradeEntry$contaxt).val());   
    var taxFeeId 	= $.trim($('#taxFeeId',$tradeEntry$contaxt).val());
	
	var validationMessages = [];
	
	if(VALIDATOR.isNullValue(taxFeeId)){
		xenos.utils.displayGrowlMessage(xenos.notice.type.error, xenos$TRD$i18n.tradeEntry.detailinfo.select_tax_comm);
		return false;
	}
	
	// When rate type left blank OR both rate & amount left blank.
	if((taxRateType.length == 0 || (taxAmount.length == 0 && taxRate.length == 0)) ||
		(taxRateType.length > 0 && (taxAmount.length > 0 && taxRate.length > 0))){
		xenos.utils.displayGrowlMessage(xenos.notice.type.error, xenos$TRD$i18n.tradeEntry.generalinfo.all_specify);
		return false;
	}
	
	// When for rate type AMOUNT, rate is specified or both rate & amount left blank.
	if(taxRateType == "AMOUNT"){  
		if(taxRate.length > 0 || (taxRate.length == 0 && taxAmount.length == 0)){
			xenos.utils.displayGrowlMessage(xenos.notice.type.error, xenos$TRD$i18n.tradeEntry.detailinfo.invalid_taxfee_amount); 
			return false;
		}
		
		formatAmount($('#taxAmount',$tradeEntry$contaxt), 10, 3, validationMessages, $('#taxAmount',$tradeEntry$contaxt).parent().parent().find('label').text());	
		
    }else{
		// When for rate type other than AMOUNT, amount is specified or both rate & amount left blank.
		if((taxRateType.length > 0) &&
			(taxAmount.length > 0 ||  (taxRate.length == 0 && taxAmount.length == 0))){
			xenos.utils.displayGrowlMessage(xenos.notice.type.error, xenos$TRD$i18n.tradeEntry.generalinfo.all_specify);
			return false;
		}
		
		formatRate($('#taxRate',$tradeEntry$contaxt), 3, 5, validationMessages, $('#taxRate',$tradeEntry$contaxt).parent().parent().find('label').text());
	}
	
	
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

function xenos$ns$views$tradeEntry$formatTaxFeeAmt(fieldObject){
	var $target = $(fieldObject);
	if($target && $target.val()){
		var isValid = formatTaxFeeAmount(fieldObject);
		if(isValid == false){
			$target.val("");
		}
	}
}

function xenos$ns$views$tradeEntry$cleanAccruedDays(){
	$("#accruedDays").val("");
}

function xenos$ns$views$tradeEntry$cleanAccruedInterestAmount(){
	$("#accruedInterestAmount").val("");
}

function xenos$ns$views$tradeEntry$cleanAccruedInterestAmountAndDays(){
	xenos$ns$views$tradeEntry$cleanAccruedInterestAmount();
	xenos$ns$views$tradeEntry$cleanAccruedDays();
}

function xenos$ns$views$tradeEntry$cleanPoolFactorAndCurrentFaceValue(){
	$("#poolFactorStr").val("");
	$("#currentFaceValueStr").val("");
}

function xenos$ns$views$tradeEntry$cleanAccruedFields(){	
	xenos$ns$views$tradeEntry$cleanAccruedInterestAmountAndDays();	
	xenos$ns$views$tradeEntry$cleanPoolFactorAndCurrentFaceValue();	
}

function xenos$ns$views$tradeEntry$checkPlSuppressFlag(){	
	if(($('#tradeType').val() ==='CASH_MGR') && ($('#plSuppressFlag').val() === 'Y')){
		if($("#quantity").val() == '0'){
			$("#principalAmount").removeAttr("disabled");	
		}else{
			$("#principalAmount").attr("disabled", "disabled");
		}
	}else{
		$("#principalAmount").attr("disabled", "disabled");
	}
}

function xenos$ns$views$tradeEntry$cleanFields(){
	$("#price").val("");
	$("#principalAmount").val("");
	$("#principalAmountInIssueCurrency").val("");
	xenos$ns$views$tradeEntry$cleanNetAmtFields();
}

function xenos$ns$views$tradeEntry$cleanNetAmtFields(){			
	$("#netAmountStr").val("");
	$("#netAmountInTradingCurrency").val("");
}

function xenos$ns$views$tradeEntry$checkExchngRateOrCalcType(){
	$('#netAmountStr').val("");
}

$("#tradeType").change(function(){
	var tradeType = $('#tradeType').val();
	var instrumentTypeParent = $('#instrumentTypeParent').attr("value");
	
	if( tradeType == 'BOND' || tradeType == 'EARLY_RDM' || instrumentTypeParent == 'FI' ){
		$('.poolFactorShow').show();
		$('.accuredAmountShow').show();
		$('.plSuppressFlagShow').hide();
		$('#plSuppressFlag').val('');		
	}else {
		$("#exCouponFlag").val("");
		$("#dirtyPriceFlag").val("");
		$("#negativeAccruedInterestFlag").val("");
		$("#indexratioStr").val("");
		$('.plSuppressFlagShow').hide();
		xenos$ns$views$tradeEntry$cleanAccruedFields();
		
		$("#accruedStartDate").val("");
		$('.poolFactorShow').hide();		
		
		if(tradeType =='CASH_MGR'){
			//PL Suppress Flag is editable during ENTRY only
			if($("#actionType").val()=="ENTRY"){
				var currentPage = $("#isInSecondPage").attr("value");
				if(currentPage == "false"){
					$('#plSuppressFlag').val('Y');
				}
			}else{
				$('#plSuppressFlag').val('');
				$('#plSuppressFlag').attr("disabled", "disabled");
			}
			
			$('.plSuppressFlagShow').show();
		}else{
			$('#plSuppressFlag').val('');
		}
	}
});



$("#valueDate").change(function(){
	if(!checkDate(this)){
		xenos.postNotice(xenos.notice.type.error, xenos.utils.evaluateMessage(xenos$TRD$i18n.tradeEntry.invalid_entry.date_format_check, [this.value]))
	}else{
		xenos$ns$views$tradeSummaryQuery$formatCustomDate(this);
		xenos$ns$views$tradeEntry$cleanFields();
		xenos$ns$views$tradeEntry$cleanAccruedFields();
	}
});

$("#buySellOrientation").change(function(){
	$('#netAmountStr').val("");
	$('#netAmountInTradingCurrency').val("");
});

$("#tgtsecurityCode").change(function(){	
	$("#tradeCcy").val("");
	$("#settlementCcy").val("");
	xenos$ns$views$tradeEntry$cleanAccruedInterestAmountAndDays();
	$("#accruedStartDate").val("");
});

$("#plSuppressFlag").change(function(){
	xenos$ns$views$tradeEntry$checkPlSuppressFlag();
});

$("#quantity").change(function(){
	if(formatQuantity($('#quantity'),15,3,null,$('#quantity').parent().parent().find('label').text())){
		xenos$ns$views$tradeEntry$cleanFields();
		xenos$ns$views$tradeEntry$checkPlSuppressFlag();
		xenos$ns$views$tradeEntry$cleanAccruedInterestAmountAndDays();
	}
});

$("#inputPrice").change(function(){
	if(formatPrice($('#inputPrice'),9,9,null,$('#inputPrice').parent().parent().find('label').text())){
		xenos$ns$views$tradeEntry$cleanAccruedInterestAmount();
	}
});

$("#grossNetType").change(function(){
	$('#price').val("");
	$('#netAmountStr').val("");
	$('#netAmountInTradingCurrency').val("");
});

$("#inputPriceFormat").change(function(){
	$('#principalAmount').val("");
	$('#price').val("");
	$('#netAmountStr').val("");
	$('#netAmountInTradingCurrency').val("");
	xenos$ns$views$tradeEntry$cleanAccruedInterestAmount();
});

$("#calculationType").change(function(){
	xenos$ns$views$tradeEntry$checkExchngRateOrCalcType();
});

$("#negativeAccruedInterestFlag").change(function(){
	$('#netAmountStr').val("");
	$('#netAmountInTradingCurrency').val("");
});

$("#indexratioStr").change(function(){
	if(formatRate($('#indexratioStr'),8,10,null,$('#indexratioStr').parent().parent().find('label').text())){
		xenos$ns$views$tradeEntry$cleanFields();
		xenos$ns$views$tradeEntry$checkExchngRateOrCalcType();
		xenos$ns$views$tradeEntry$cleanAccruedInterestAmount();
	};
});

$("#accruedDays").change(function(){
	formatAccruedDays($('#accruedDays'),5,0,null,$('#accruedDays').parent().parent().find('label').text());
});