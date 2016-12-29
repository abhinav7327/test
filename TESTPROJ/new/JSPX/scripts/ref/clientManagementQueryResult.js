//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
//Mode initialization code to result page

var consolidateParmas = function(e){	
	var row = $(e.target).attr('row');
	var gridData = ($('.xenos-grid').data("gridInstance")).getData().getItems();
	var childs = $('div#clientMgmtAllConsolidateAct > a');
	var finalChilds = [];
	
	var customerStatus = $.trim(gridData[row].customerStatus);
	var accountStatus = $.trim(gridData[row].accountStatus);
	var ssiStatus = $.trim(gridData[row].ssiStatus);
	
	$.each(childs, function(index, element){
		//Push the Consolidation icons for Customer
		//If customer status is NORMAL, show the Customer Amend icon.
		if($(element).attr('action') == 'custAmend' && customerStatus == 'NORMAL'){
			finalChilds.push($(element).clone());
			return;
		}
		//If customer status is CANCEL, show the Customer Reopen icon.
		if($(element).attr('action') == 'custReopen' && customerStatus == 'CANCEL'){
			finalChilds.push($(element).clone());
			return;
		}
		
		if(customerStatus == 'NORMAL'){
			//Push the Consolidation icons for Account
			//If customer status is NORMAL and account doesn't exist, show the Account Entry icon.
			if($(element).attr('action') == 'actEntry' && accountStatus == ''){
				finalChilds.push($(element).clone());
				return;
			}
			//If customer status is NORMAL and account status is NORMAL, show the Account Amend and Account Copy icon.
			if(($(element).attr('action') == 'actAmend' || $(element).attr('action') == 'actCopy') && accountStatus == 'NORMAL'){
				finalChilds.push($(element).clone());
				return;
			}
			//If customer status is NORMAL and account status is CANCEL, show the Account Reopen icon.
			if($(element).attr('action') == 'actReopen' && accountStatus == 'CANCEL'){
				finalChilds.push($(element).clone());
				return;
			}
			//Push the Consolidation icons for SSI
			//If customer status is NORMAL, always show the SSI Entry icon.
			if($(element).attr('action') == 'ssiEntry'){
				finalChilds.push($(element).clone());
				return;
			}
			//If customer status is NORMAL and SSI exists, show the SSI Amend icon.
			if($(element).attr('action') == 'ssiAmend' && ssiStatus == 'NORMAL'){
				finalChilds.push($(element).clone());
				return;
			}
		}
	});
	
	$('div#consolidateAct').empty();
	$.each(finalChilds, function(index, $element){
		$('div#consolidateAct').append($element);
	});
	
	var accountPk = gridData[row]['accountPk'] ===null ? '': gridData[row]['accountPk']
	var customerPk = gridData[row]['customerPk'] === null ? '': gridData[row]['customerPk']
	var parmas = {
		custAmend :  '&pk='+customerPk,
		custReopen : '&pk='+customerPk,
		actEntry :   '&pk=-1&customerPk='+customerPk,
		actAmend :  '&pk=' + accountPk+'&customerPk='+customerPk,
		actReopen :  '&pk=' + accountPk+'&customerPk='+customerPk,
		actCopy :   '&pk=' + accountPk+'&customerPk='+customerPk,
		ssiEntry :  '&pk=-1&accountPk='+accountPk+'&customerPk='+customerPk,
		ssiAmend :  '&pk='+gridData[row]['standingRulePk']+'&accountPk='+accountPk+'&customerPk='+customerPk
	}
	
	$('div#consolidateAct>a.consolidateActLink').data("params", parmas);

};