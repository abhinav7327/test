//$Id$
//$Author: subhadipb $
//$Date: 2016-12-27 12:13:06 $




var xenos$Handler$drvTradeEntry = xenos$Handler$function({
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
			
function xenos$ns$views$drvTradeEntAmd$onGeneralEntryPageLoad(){
	   $("#formActionArea .btnsArea .wizNext").insertBefore($("#formActionArea .btnsArea .wizSubmit"));
	   $("#formActionArea .btnsArea .wizNext").addClass("submitBtn");
	   $("#formActionArea .btnsArea .wizNext .inputBtnStyle").show();
	   $("#formActionArea .btnsArea .wizNext .inputBtnStyle").attr("value", "Submit");
	   $("#formActionArea .btnsArea .wizNext .inputBtnStyle").removeAttr("disabled");
	   
	   $("#formActionArea .btnsArea .wizReset .inputBtnStyle").removeAttr("disabled");
	   $("#formActionArea .btnsArea .wizReset .inputBtnStyle").show();
	   
	   $("#formActionArea .btnsArea .wizSubmit").hide();
	   
	   $("#formActionArea .btnsArea .wizPrev").insertAfter($("#formActionArea .btnsArea .wizReset"));        
	   $("#formActionArea .btnsArea .wizPrev .inputBtnStyle").attr("value", "Back");
	   $("#formActionArea .btnsArea .wizPrev .inputBtnStyle").hide();
	   $(".popupBtn","#generalEntry").show();
	   $("#currentPageStatus").val("init");
	   $("#detailEntry").css({ display : 'none'});
}

function xenos$ns$views$drvTradeEntAmd$submitHandler(){
	xenos$ns$views$drvTradeEntAmd$changeToCaps();
	if(xenos.ns.views.derivativeTradeEntry.validateSubmit()===false){
		return;
	}
	xenos$Handler$drvTradeEntry.generic(undefined, {
	  requestUri: xenos.context.path + '/secure/drv/trade/entry/doInitialEntry' + '?commandFormId=' + $('[name=commandFormId]').val(),
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
							xenos$ns$views$drvTradeEntAmd$onGeneralEntrySubmit();
							$('#content').xenosmore({mode:'entry'});
							$('input, select', '#detailEntry').filter(':enabled:visible:first').focus();
						}
					}
	  });  
	  return false;
}
function xenos$ns$views$drvTradeEntAmd$renderPage(){
	var winHeight = $(window).height();
	var entryContHeight = (winHeight - 225);
	$('.entryContainer', 'div#content').css('height',entryContHeight);
	$('.entryContainerConfirm','div#content').css('height',entryContHeight);
	$('input.dateinput', "#generalEntry").xenosdatepicker();
}
function xenos$ns$views$drvTradeEntAmd$onGeneralEntrySubmit(){
	xenos$ns$views$drvTradeEntAmd$renderPage();
	$("#detailEntry").css({ display : 'block'});
	$("#formActionArea .btnsArea .wizSubmit").show();
	$("#formActionArea .btnsArea .wizNext .inputBtnStyle").hide();
	if($("#actionType").val()=="ENTRY"){
		$("#formActionArea .btnsArea .wizPrev .inputBtnStyle").removeAttr("disabled");
		$("#formActionArea .btnsArea .wizPrev .inputBtnStyle").show();
		$("#formActionArea .btnsArea .wizReset .inputBtnStyle").hide();
    }
	if($("#actionType").val()=="AMEND"){
		$("#securityCode").attr("disabled", "disabled");
		$("#securityPopup").closest("div").find('.popupBtnIco').hide();
		$("#inventoryAccountNo").attr("disabled", "disabled");
		$("#fundAccountPopup").closest("div").find('.popupBtnIco').hide();
		$("#brkAccountNo").attr("disabled", "disabled");
		$("#brokerAccountPopup").closest("div").find('.popupBtnIco').hide();
		$('#settlementBasis').attr("disabled", "disabled");
	}
	xenos$ns$views$drvTradeEntAmd$populateAttributes();
	if($("#actionType").val()=="ENTRY"){
		var contractMode = $("#contractMode").attr("value");
		if(contractMode == 'EXIST'){
			$('#settlementBasis').attr("disabled", "disabled");
		}
	}
}

/*
* Back Handler
*/
function xenos$ns$views$drvTradeEntAmd$backHandler(){
	xenos$ns$views$drvTradeEntAmd$onGeneralEntryPageLoad();
	$("#settlementBasis").removeAttr("disabled");
	$("#formActionArea .btnsArea .wizPrev .inputBtnStyle").hide();
	$("#buttonName").val("back");
	$('input, select', '#generalEntry').filter(':enabled:visible:first').focus(); 
	return false;
}

function xenos$ns$views$drvTradeEntAmd$changeToCaps(){
	$('#securityCode').val($('#securityCode').val().toUpperCase());
	$('#inventoryAccountNo').val($('#inventoryAccountNo').val().toUpperCase());
	$('#exeBrkAccountNo').val($('#exeBrkAccountNo').val().toUpperCase());
	$('#brkAccountNo').val($('#brkAccountNo').val().toUpperCase());
	$('#tradeCcy').val($('#tradeCcy').val().toUpperCase());
}	

function xenos$ns$views$drvTradeEntAmd$formatMarginAmount(fieldObject){

		var amount = $(fieldObject).val();
		var validationMessages = [];
		
		formatSignedRate($(fieldObject),15,3,validationMessages,$(fieldObject).parent().parent().find('label').text());
		
		if (validationMessages.length > 0){
		    var sign = amount.charAt(0);
			if (sign == '-'){
				$(fieldObject).val(sign + $(fieldObject).val());
			}
			xenos.utils.displayGrowlMessage(xenos.notice.type.error, validationMessages);
			return false;
		}else {
			xenos.utils.clearGrowlMessage();
		}
	return true; 
}