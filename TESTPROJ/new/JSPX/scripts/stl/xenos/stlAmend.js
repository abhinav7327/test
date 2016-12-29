//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $

/*
 * Function to handle layout according to the diff cash button selection. 
 */
function onClickDiffSameBtn(e)
{
	var e = $(this);

	if(e.hasClass('collapse')){
		e.removeClass('collapse').addClass('expand').val('Diff Cash');
		$('#settleModeFormItem').hide();
		$('#transmissionReqdFlagFormItem').hide();
		$('.cashStlDetail2').hide();
		copySecurityDetailsToCashDetails();
	} else {
		e.removeClass('expand').addClass('collapse').val('Same Cash');
		$('#settleModeFormItem').show();
		$('#transmissionReqdFlagFormItem').show();
		$('.cashStlDetail2').show();
	}
	
	var diffCashFlag = $.trim($('#diffCashFlag').val());
	if(diffCashFlag == 'D'){
		// set diffCashFlag to DIFFCASH - S
		$('#diffCashFlag').val("S");
	}else if(diffCashFlag == 'S'){
		// set diffCashFlag to DIFFCASH - D
		$('#diffCashFlag').val("D");
	}
}

/*
 * Function to handle Security Side Layout Modification for the 
 * change of security side settlement mode or for the change of security side SSI Layout 
 */
function onChangeForSecSideLayout(e)
{
	var secStlMode = $.trim($('#secSettlementMode').val());
	var secSSILayout = $.trim($("input[type='hidden']").filter("[id=secSSILayout]").val());
	
	$('.sec_cp_internal').hide();
	$('.sec_cp_japanese').hide();
	$('.sec_cp_dtc').hide();
	$('.sec_cp_bony').hide();
	$('.sec_cp_international').hide();
	
	switch (secStlMode)
	{
		case "EXTERNAL":
			if($.trim(secSSILayout) == 'JAPANESE'){
				$('.sec_cp_japanese').show();
			}else if($.trim(secSSILayout) == 'DTC'){
				$('.sec_cp_dtc').show();
			}else if($.trim(secSSILayout) == 'BONY'){
				$('.sec_cp_bony').show();
			}else if($.trim(secSSILayout) == 'INTERNATIONAL'){
				$('.sec_cp_international').show();
			}
			$('.securityOurBlock').show();
			$('#ourHeader').show();
			$('#ourBlk').show();
			
			$('#secCpSettleAcLbl').removeClass('required');
			break;
		case "INTERNAL":
			if($.trim($("input[type='hidden']").filter("[id=isBrokerAccount]").val()) == "Y") {
				$('#ourHeader').show();
				$('#ourBlk').hide();
			} else {
				$('.sec_cp_internal').show();
				
				$('.securityOurBlock').hide();
				$('#ourHeader').hide();
				$('#ourBlk').hide();
				
				$('#secCpSettleAcLbl').addClass('required');
			}
			break;
	}
}

/*
 * Function to handle Cash Side Layout Modification for the 
 * change of cash side settlement mode or for the change of Cash side SSI Layout 
 */
function onChangeForCashSideLayout()
{
	var cashStlMode = $.trim($('#cashSettlementMode').val());
	var cashSSILayout = $.trim($("input[type='hidden']").filter("[id=cashSSILayout]").val());
	
	$('.cash_cp_internal').hide();
	$('.cash_cp_japanese').hide();
	$('.cash_cp_dtc').hide();
	$('.cash_cp_bony').hide();
	$('.cash_cp_international').hide();
				
	switch (cashStlMode)
	{
		case "EXTERNAL":
			if($.trim(cashSSILayout) == 'JAPANESE'){
				$('.cash_cp_japanese').show();
				var instructionFormatId = $.trim($('#cashInstructionFormatId').val());
				if(instructionFormatId == 'BOJ'){
					$('.cash_cp_japanese_boj_block').show();
					$('.cash_cp_japanese_eb_block').hide();
				}else if(instructionFormatId == 'EB'){
					$('.cash_cp_japanese_boj_block').hide();
					$('.cash_cp_japanese_eb_block').show();
				}else {
					$('.cash_cp_japanese_boj_block').hide();
					$('.cash_cp_japanese_eb_block').hide();
				}
			}else if($.trim(cashSSILayout) == 'DTC'){
				$('.cash_cp_dtc').show();
			}else if($.trim(cashSSILayout) == 'BONY'){
				$('.cash_cp_bony').show();
			}else if($.trim(cashSSILayout) == 'INTERNATIONAL'){
				$('.cash_cp_international').show();
			}

			$('.cashOurBlock').show();
			$('#ourHeaderCash').show();
			$('#ourBlkCash').show();
			
			$('#cashCpSettleAcLbl').removeClass('required');
			break;
		case "INTERNAL":
			if($.trim($("input[type='hidden']").filter("[id=isBrokerAccount]").val()) == "Y") {
				$('#ourHeaderCash').show();
				$('#ourBlkCash').hide();
			} else {
				$('.cash_cp_internal').show();

				$('.cashOurBlock').hide();
				$('#ourBlkCash').hide();
				$('#ourHeaderCash').hide();
				
				//CpSettleAc is mandatory
				$('#cashCpSettleAcLbl').addClass('required');
			}
			break;
	}
}

/*
 * If Settlement type is "AGAINST", the inxTransmission field for Security side 
 * and Cash side cannot be different.
 */
function onchangeInxTransmissionForCash() {
	var settlementType=$.trim($('#settlementType').val());
	if(settlementType=="AGAINST"){
		if($.trim($('#secTransmissionReqdFlag').val())!=$.trim($('#cashTransmissionReqdFlag').val())){
			$('#cashTransmissionReqdFlag').focus();
			xenos.postNotice(xenos.notice.type.error,xenos$STL$i18n.transmission.required_flag);
		}
	}
}

/*
 * Function to show details as per the data.
 */
function showDetail() {	
	var settlementType=$.trim($('#settlementType').val());
	
	//Check for Suppressed settlement
	if($.trim($("input[type='hidden']").filter("[id=isSuppressed]").val()) == "Y") {
		handleSuppression($.trim($("input[type='hidden']").filter("[id=nonSuppressedSide]").val()));
	} else {
		//Normal Case
		$('#secSide').show();
		// display secside as per stlmode value (onChangeForSecSideLayout())
		onChangeForSecSideLayout();
		$('#cashSide').show();
		$('.cashStlDetail2').show();
		// display cashside as per stlmode value (onChangeForCashSideLayout()) 
		onChangeForCashSideLayout();
		
		var diffCashFlag = $.trim($('#diffCashFlag').val());
		if(settlementType=="AGAINST") {
			//If AGAINST, then expose the DiffSameCash functionality else no
			$('#samecash').show();
			if(diffCashFlag == 'D'){
				$('#settleModeFormItem').show();
				$('#transmissionReqdFlagFormItem').show();
				$('.cashStlDetail2').show();
				$('#diffSameBtn').val('Same Cash');
			}else if(diffCashFlag == 'S'){
				$('#settleModeFormItem').hide();
				$('#transmissionReqdFlagFormItem').hide();
				$('.cashStlDetail2').hide();
				$('#diffSameBtn').removeClass('collapse').addClass('expand').val('Diff Cash');
			}
			//Show the appropriate InxTransmission to populate
			$('#inxForNormal').hide();
			$('#inxForSuppress').show();
			$('#cashTransmissionReqdFlag1').attr('disabled', 'disabled');
			$('#secTransmissionReqdFlag').die();
			$('#secTransmissionReqdFlag').live('change',function(){
			   var temp=$('#secTransmissionReqdFlag').val();
			   $('#cashTransmissionReqdFlag1').val(temp);
			});
			
		} else {
			$('#settleModeFormItem').show();
			$('#transmissionReqdFlagFormItem').show();

		    $('#secTransmissionReqdFlag').die();
			//Show the appropriate InxTransmission to populate
			$('#inxForNormal').show();
			$('#inxForSuppress').hide();
			$('.cashStlDetail2').show();
			$('#samecash').hide();
		}
	}
}

/*
 * Function to handle Suppressed Settlement.
 * In Suppressed Settlement, one of the Sides is suppressed and the Settelment Type is 'FREE'.
 * The SettlementType cannot be changed for a Suppressed case.
 * Therefore,depending on the value of the 'showSide' - the side will be shown.
 */
function handleSuppression(showSide) {
	//Show only the appropriate side
	if(showSide == "CASH") {
		$('#cashSide').show();
		$('.cashStlDetail2').show();
		// display cashside as per stlmode value (onChangeForCashSideLayout())  
		onChangeForCashSideLayout();
		//Show the appropriate InxTransmission to populate
		$('#inxForNormal').hide();
		$('#inxForSuppress').show();
		$('#cashTransmissionReqdFlag1').removeAttr('disabled');
		//Hide the Security side
		$('#secSide').hide();
		/*When only the Cash Side is shown, then we should remove the <xenos:select id="secTransmissionReqdFlag".... </xenos:select>
		 This is because, although the <xenos:select id="secTransmissionReqdFlag".... </xenos:select> will be kept hidden but it 
		 will be present in the DOM and the path for this is path="commandForm.settlementInfoVO.transmissionReqdFlag" 
		 which is same as that for <div id="inxForSuppress" .... </div> in the cashSide and as the Cash side 
		 is shown in this case hence the the value for this path on submission will be incorrect.
		 Hence the below removal is required.
		*/
		$('#secTransmissionReqdFlag').parent().parent().remove();
	} else {
		$('#secSide').show();
		// display secside as per stlmode value (onChangeForSecSideLayout())
		onChangeForSecSideLayout();
		$('#cashSide').hide();
		/*When only the Security Side is shown, then we should remove the <div id="inxForSuppress" .... </div>
		 This is because, although the <div id="inxForSuppress" .... </div> will be kept hidden but it 
		 will be present in the DOM and the path for this is path="commandForm.settlementInfoVO.transmissionReqdFlag" 
		 which is same as that for id="secTransmissionReqdFlag" in the secSide and as the Security side 
		 is shown in this case hence the the value for this path on submission will be incorrect.
		 Hence the below removal is required.
		*/
		$('#inxForSuppress').remove();
	}
}

/*
 * If SettlementType = AGAINST and if we select the same cash option (i.e. when diffCashFlag = 'S') then 
 * we populate the Cash side Counterparty details with the Security side Counterparty details.
 */
function copySecurityDetailsToCashDetails() {

	//Set Cash Side CP Details
	$('#cashcpbank').val($('#cpbank').val());
	$('#cashcpbankname').val($('#cpbankname').val());
	$('#cashcpsettleac').val($('#cpsettleac').val());
	$('#cashcpsettleacname').val($('#cpsettleacname').val());
	$('#cashCpExtSettleAccountName1').val($('#cpExtSettleAccountName1').val());
	$('#cashCpExtSettleAccountName2').val($('#cpExtSettleAccountName2').val());
	$('#cashCpExtSettleAccountName3').val($('#cpExtSettleAccountName3').val());
	$('#cashCpExtSettleAccountName4').val($('#cpExtSettleAccountName4').val());
	$('#cashCpBankAccountType').val($('#secCpBankAccountType').val());
	$('#cashcpIntermediaryInfo').val($('#cpIntermediaryInfo').val());
	
	$('#cashbeneficiaryBic').val($('#secbeneficiaryBic').val());
	$('#cashbeneficiaryName').val($('#beneficiaryname').val());
	
	$('#cashWayOfPayment').val($('#secWayOfPayment').val());
	$('#cashTransferType').val($('#secTransferType').val());
	$('#cashInstructionFormatId').val($('#secInstructionFormatId').val());
	$('#cashFurtherCredit').val($('#secFurtherCredit').val());
	$('#cashlocalCode').val($('#seclocalCode').val());
	//BOJ specific Fields
	$('#cashbojSettleTimeType').val($('#securitybojSettleTimeType').val());
	$('#cashbojTransferRequestRemarks').val($('#securitybojTransferRequestRemarks').val());
	$('#cashbojNarrativeBankName').val($('#securitybojNarrativeBankName').val());
	$('#cashbojNarrativeBankAccountNo').val($('#securitybojNarrativeBankAccountNo').val());
	$('#cashbojNarrativeBeneficiaryName').val($('#securitybojNarrativeBeneficiaryName').val());
	$('#cashbojNarrativeOurName').val($('#securitybojNarrativeOurName').val());
	$('#cashbojNarrativeRemarks1').val($('#securitybojNarrativeRemarks1').val());
	$('#cashbojNarrativeRemarks2').val($('#securitybojNarrativeRemarks2').val());
	$('#cashbojDebitRequestRemarks').val($('#securitybojDebitRequestRemarks').val());
	$('#cashbojSettlementPlaceType').val($('#securitybojSettlementPlaceType').val());
	$('#cashbojPriorityFlag').val($('#securitybojPriorityFlag').val());
	//EB specific Fields
	$('#cashOurEbCode').val($('#secOurEbCode').val());
	$('#cashCpEbCode1').val($('#secCpEbCode1').val());
	$('#cashCpEbCode2').val($('#secCpEbCode2').val());

	//Set Cash Side Our Details
	$('#cashStlDetailOurbank').val($('#secSideOurbank').val());
	$('#cashStlDetailOurbankName').val($('#secSideOurbankName').val());
	$('#cashStlDetailOursettleac').val($('#secSideOursettleac').val());
	$('#cashStlDetailOurSettleAcName').val($('#secSideOurSettleAcName').val());
	$('#cashStlDetailOurSettleAcType').val($('#secSideOurSettleAcType').val());
	$('#cashStlDetailOurSettleBeneficiaryName').val($('#secSideOurSettleBeneficiaryName').val());
	$('#cashStlDetailOurSettleBrkAcNo').val($('#secSideOurSettleBrkAcNo').val());
	$('#cashStlDetailOurintermediaryinfo').val($('#secSideOurintermediaryinfo').val());
	
	$('#cashSettlementMode').val($('#secSettlementMode').val());
	$('#cashSSILayout').val($('#secSSILayout').val());
	onChangeForCashSideLayout();
}
