//$Id$
//$Author: rajarsic $
//$Date: 2016-12-26 15:48:06 $
/***
 * Contains basic SlickGrid formatters.
 * @module Formatters
 * @namespace Slick
 */

(function ($) {
  // register namespace
  $.extend(true, window, {
    "Slick": {
      "Formatters": {
        "DropdownCellFormatter"				: DropdownCellFormatter,
        "DropdownReadOnlyFormatter"			: DropdownReadOnlyFormatter,
        "xenosSelectInputFormatter"			: xenosSelectInputFormatter,
		"TradeDetailViewFormater"			: TradeDetailViewFormater,
		"AllocationTradeDetailViewFormater" : AllocationTradeDetailViewFormater,
		"TradeDetailViewFormaterForAuth"	: TradeDetailViewFormaterForAuth,
		"EmployeeDetailViewFormater"		: EmployeeDetailViewFormater,
		"ConsolidateActFormater"			: ConsolidateActFormater,
		"GroupDetailViewFormater"           : GroupDetailViewFormater,
		"CancelRecordFormatter"				: CancelRecordFormatter,
		"InstrumentDefaultCodeFormatter"	: InstrumentDefaultCodeFormatter,
		"InstrumentAuthDetailViewFormatter" : InstrumentAuthDetailViewFormatter,
		"SettlementDetailViewFormater"		: SettlementDetailViewFormater,
		"SettlementDetailViewFormaterForInfo"		: SettlementDetailViewFormaterForInfo,
		"SettlementDetailViewInstructionFormater"   : SettlementDetailViewInstructionFormater,
		"SettlementDetailViewFormaterForAuth"		: SettlementDetailViewFormaterForAuth,
		"AccountDetailViewFormater"			: AccountDetailViewFormater,
		"DocumentDetailViewFormater"		: DocumentDetailViewFormater,
		"FinInstDetailViewFormater"			: FinInstDetailViewFormater,
		"FinInstDetailViewFormatter"			: FinInstDetailViewFormatter,
		"InstrumentDetailViewFormater"		: InstrumentDetailViewFormater,
		"InstrumentDetailViewFormaterForSrsBalance"	: InstrumentDetailViewFormaterForSrsBalance,
		"xenosTextFormatter"					: xenosTextFormatter,
		"xenosTextInputFormatter"     		: xenosTextInputFormatter,
		"xenosTxnInputFormatter"              : xenosTxnInputFormatter,
		"CollapseFormatter"					: CollapseFormatter,
		"LeafIdentifyFormater" 				: LeafIdentifyFormater,
		"NegetiveBalanceFormatter"			: NegetiveBalanceFormatter,
		"CamNegetiveBalanceFormatter"		: CamNegetiveBalanceFormatter,
		"CamBalanceQueryFormatter"			: CamBalanceQueryFormatter,
		"CamPortfolioBalanceQueryFormatter"	: CamPortfolioBalanceQueryFormatter,
		"FailRecordFormatter"				: FailRecordFormatter,
		"ExmMessageQueryEditFormater"		: ExmMessageQueryEditFormater,
		"ExmMessageQueryHtmlFormater"		: ExmMessageQueryHtmlFormater,
		"ExmMessageQueryRawDataFormater"	: ExmMessageQueryRawDataFormater,
		"BatchReportQueryFormatter"			: BatchReportQueryFormatter,
		"AuthCheckboxFormater"				: AuthCheckboxFormater,
		"AccountAuthDetailViewFormatter"	: AccountAuthDetailViewFormatter,
		"TradeAuthCheckboxFormater"			: TradeAuthCheckboxFormater,
		"xenosDateFormatter"					: xenosDateFormatter,
		"StlCompletionEditFormatter"		: StlCompletionEditFormatter,
		"AccountAuthFormatter"				: AccountAuthFormatter,
		"AuthorizedRejectedRecordFormatter"	: AuthorizedRejectedRecordFormatter,
		"AuthStatusFormatter" 				: AuthStatusFormatter,
		"ActionPendingFormatter"			: ActionPendingFormatter,
		"FinalizationUndoFormatter"			: FinalizationUndoFormatter,
		"NettedSettlementDetailFormatter"	: NettedSettlementDetailFormatter,
		"ApplicationRoleDetailViewFormater"	: ApplicationRoleDetailViewFormater,
		"ExmMessageQueryCommentEntryFormater": ExmMessageQueryCommentEntryFormater,
		"SettlementFinalizationDetailViewFormater": SettlementFinalizationDetailViewFormater,
		"WireInstructionAuthorizationDetailViewFormatter":WireInstructionAuthorizationDetailViewFormatter,
		"CustomerDetailViewFormatter": CustomerDetailViewFormatter,
		"NettedSettlementDetailFormatterForCancel": NettedSettlementDetailFormatterForCancel,
		"StlInstructionSelectInputFormatter": StlInstructionSelectInputFormatter,
		"StlInstructionTextInputFormatter"  : StlInstructionTextInputFormatter,
        "StlInstructionRefNoVerNoFormatter"	: StlInstructionRefNoVerNoFormatter,
        "StlInstructionInxRefNoFormatter"	: StlInstructionInxRefNoFormatter,
        "StlInstructionCxlRefNoFormatter"	: StlInstructionCxlRefNoFormatter,
        "StlInstructionCpSsiInfoFormatter"	: StlInstructionCpSsiInfoFormatter,
        "StlInstructionFirmStlAcBrokerFormatter": StlInstructionFirmStlAcBrokerFormatter,
        "StlInstructionTrxStatusFormatter"	: StlInstructionTrxStatusFormatter,
        "StlInstructionAcceptanceStatusFormatter": StlInstructionAcceptanceStatusFormatter,
        "StlInstructionStatusFormatter"		: StlInstructionStatusFormatter,
        "StlInstructionCxlAcceptanceStatusFormatter": StlInstructionCxlAcceptanceStatusFormatter,
		"HolidayDetailViewFormatter"		: HolidayDetailViewFormatter,
		"TradingAccountDetailViewFormater" 	: TradingAccountDetailViewFormater,
		"CashIODetailViewFormater" 			: CashIODetailViewFormater,
		"CashIODetailViewFormaterForAuth" 		: CashIODetailViewFormaterForAuth,
		"SecurityIODetailViewFormaterForAuth" 	: SecurityIODetailViewFormaterForAuth,
		"SsiDetailViewFormater" 			: SsiDetailViewFormater,
		"SsiAuthDetailViewFormater" 		: SsiAuthDetailViewFormater,
		"WithholdDateFormatter"				: WithholdDateFormatter,
		"DepositoryAdjustmentFormater"		: DepositoryAdjustmentFormater,
		"NcmAdjustmentQueryDetailViewFormatter" : NcmAdjustmentQueryDetailViewFormatter,
		"SsiAuthFormatter"					: SsiAuthFormatter,
		"SrsVoucherFormater" 				: SrsVoucherFormater,
		"ActualBalanceDetailViewFormater" 	: ActualBalanceDetailViewFormater,
		"ProjectedBalanceDetailViewFormater": ProjectedBalanceDetailViewFormater,
		"FailBalanceDetailViewFormater" 	: FailBalanceDetailViewFormater,
		"UnmatchBalanceDetailViewFormater" 	: UnmatchBalanceDetailViewFormater,
		"MarketPriceDetailViewFormater" 	: MarketPriceDetailViewFormater,
		"MovementDetailsFormatter"     		: MovementDetailsFormatter,
		"FininstAuthFormatter" 				: FininstAuthFormatter,
		"FininstAuthDetailViewFormater" 	: FininstAuthDetailViewFormater,
		"LedgerCodeDetailsFormatter"     	: LedgerCodeDetailsFormatter,
		"LedgerCategoryForSrsBalance"		: LedgerCategoryForSrsBalance,
		"ReceiveNoticeOutgoingDetailViewFormatter": ReceiveNoticeOutgoingDetailViewFormatter,
		"ReceiveNoticeIncomingDetailViewFormatter": ReceiveNoticeIncomingDetailViewFormatter,
		"LocalAcIdConfRuleDetailViewFormater" : LocalAcIdConfRuleDetailViewFormater,
		"LocalAcIdConfRuleAuthViewFormater" : LocalAcIdConfRuleAuthViewFormater,
		"OwnSsiDetailViewFormater"			: OwnSsiDetailViewFormater,
        "AppRoleAuthFormatter" 				: AppRoleAuthFormatter,
		"AppRoleAuthDetailViewFormater" 	: AppRoleAuthDetailViewFormater,
		"MarketPriceAuthDetailViewFormater" : MarketPriceAuthDetailViewFormater,
		"PairOffQueryEditFormater" 			: PairOffQueryEditFormater,
		"TrdSendConfReasonViewFormatter"    : TrdSendConfReasonViewFormatter,
		"MarketDetailViewFormatter"			: MarketDetailViewFormatter,
		"CPCodeDetailViewFormatter"			: CPCodeDetailViewFormatter,
		"InventoryAccountDetailViewFormater": InventoryAccountDetailViewFormater,
		"OurBankDetailViewFormater"			: OurBankDetailViewFormater,
		"OurStlAccountDetailViewFormatter" 	: OurStlAccountDetailViewFormatter,
		"StlCcyDetailViewFormater" 			: StlCcyDetailViewFormater,
		"CustodianBalanceNameFormatter"		: CustodianBalanceNameFormatter,
		"RadNoticeDetailViewFormatter" 		: RadNoticeDetailViewFormatter,
        "TradeFeedDetailViewFormater"		: TradeFeedDetailViewFormater,
        "PairOffCancelEditFormater"			: PairOffCancelEditFormater,
        "EmployeeAuthDetailViewFormater" 	: EmployeeAuthDetailViewFormater,
		"OwnSsiAuthDetailViewFormater" 		: OwnSsiAuthDetailViewFormater,
		"TradeReceiveConfirmationDetail"	: TradeReceiveConfirmationDetail,
		"MatchPopUp"						: MatchPopUp,
		"GroupDetailAuthViewFormater" 		: GroupDetailAuthViewFormater,
		"Completionsecuritydetail" 			: Completionsecuritydetail,
		"AuthDetailViewFormatterForRef"		: AuthDetailViewFormatterForRef,
		"AuthDetailViewFormatterForTxn"		: AuthDetailViewFormatterForTxn,
		"AuthStatusFormatterRev"			: AuthStatusFormatterRev,
		"NettedSettlementDetailFormatterForAuth" : NettedSettlementDetailFormatterForAuth,
		"PairOffSettlementDetailFormatterForAuth" :PairOffSettlementDetailFormatterForAuth,
		"MultiUserImportPreferenceDetailViewFormater" : MultiUserImportPreferenceDetailViewFormater,
		"WithholdReasonFormatter"           : WithholdReasonFormatter,
		"WithholdTextFormatter"             : WithholdTextFormatter,
		"GleVoucherFormater"				: GleVoucherFormater,
		"DetailViewFormater"                : DetailViewFormater,
		"CamTransactionDetailFormatter"		: CamTransactionDetailFormatter,		
		"CamSecurityDetailFormater"			: CamSecurityDetailFormater,
		"GleVoucherFormaterForAuth"			: GleVoucherFormaterForAuth,
		"CheckBoxFromatter"					: CheckBoxFromatter,
		"TextAndCheckboxFromatter"			: TextAndCheckboxFromatter,
		"TextAndPopupFormatter"				: TextAndPopupFormatter,
		"xenosButtonFormatter"				: xenosButtonFormatter,
		"DocumentDownloadFormatter"			: DocumentDownloadFormatter,
		"CamMovementAccountDetailViewFormater" : CamMovementAccountDetailViewFormater,
		"CamMomvementInstrumentDetailViewFormater": CamMomvementInstrumentDetailViewFormater,
		"ReconDetailViewFormater"			: ReconDetailViewFormater,
		"ChequeInventoryDetailViewFormater" : ChequeInventoryDetailViewFormater,
		"xenosReportFormatter"                : xenosReportFormatter,
		"AccountPopUpFormatter"				: AccountPopUpFormatter,
		"DisplayFormatter"					: DisplayFormatter,
		"UserStatusFormatter"				: UserStatusFormatter,
		"CamAllocationDeallocationFormatter": CamAllocationDeallocationFormatter,
		"DetailAndCheckboxFromatter"		: DetailAndCheckboxFromatter,
		"StlPaymentSplitFormatter"			: StlPaymentSplitFormatter,
		"FundDetailViewFormatter"			: FundDetailViewFormatter,
		"CloseOutQueryDetailViewFormatter"	: CloseOutQueryDetailViewFormatter,
		"BkgTradeDetailViewFormatter"		: BkgTradeDetailViewFormatter,
		"FrxTradeDetailViewFormatter"       : FrxTradeDetailViewFormatter,
		"NcmTradeDetailViewFormatter"       : NcmTradeDetailViewFormatter,
		"EmployeeQueryDetailViewFormater"	: EmployeeQueryDetailViewFormater,
		"EventDetailViewFormater"			: EventDetailViewFormater,
		"RightsDetailViewFormatter"			: RightsDetailViewFormatter,
		"SettlementDetailViewInstructionCashTransferFormater"  : SettlementDetailViewInstructionCashTransferFormater,
		"CashTransferDetailViewFormater" : CashTransferDetailViewFormater,
        "NegativeBalanceDetailViewFormater" : NegativeBalanceDetailViewFormater,
        "SmrFailedStatusFormatter" 			: SmrFailedStatusFormatter,
        "ExerciseDetailViewFormatter"        : ExerciseDetailViewFormatter,
		"GleTransactionFormater"		    : GleTransactionFormater,
		"DrvTradeDetailViewFormater"		: DrvTradeDetailViewFormater,
		"DrvContractDetailViewFormater"		: DrvContractDetailViewFormater,
		"BrokerAccountDetailFormatter"		    : BrokerAccountDetailFormatter,
		"AllotmentInstrumentDetailViewFormater"	: AllotmentInstrumentDetailViewFormater,
		"MarginDetailsViewFormatter"	    : MarginDetailsViewFormatter,
		"DrvTradeDetailViewFormater"		: DrvTradeDetailViewFormater,
		"DrvContractDetailViewFormater"		: DrvContractDetailViewFormater,
		"InstrumentDetailViewFormaterOptions" : InstrumentDetailViewFormaterOptions,
		"BalanceDetailViewFormatter"		: BalanceDetailViewFormatter,
		"BrokerAccountDetailFormatter"		    : BrokerAccountDetailFormatter,
		"ExerciseAmountFormatter" : ExerciseAmountFormatter,
		"ExerciseAmendCheckBoxFromatter" : ExerciseAmendCheckBoxFromatter,
		"ExercisingQuantityTxnInputFormatter" : ExercisingQuantityTxnInputFormatter,
		"ExerciseAmendDateFormatter" : ExerciseAmendDateFormatter,
		"DrvCloseoutDetailsViewFormatter" : DrvCloseoutDetailsViewFormatter,
		"AccountCommonDetailViewFormatter" : AccountCommonDetailViewFormatter,
		"IconFeedQueryFormatter"            : IconFeedQueryFormatter,
		"exerciseDateFormatter" :exerciseDateFormatter,	
		"CamAccruedCouponDetailFormater" : CamAccruedCouponDetailFormater,
		"SlrTradeDetails" : SlrTradeDetails,
		"NegativeNumberFormatter" : NegativeNumberFormatter,
		"FinalizedFlagFormatter" : FinalizedFlagFormatter,
		"FinalizedFlagFormatterRed" : FinalizedFlagFormatterRed,
		"imageViewFormatter" : imageViewFormatter,
		"FrxInstructionRawFileViewFormater" : FrxInstructionRawFileViewFormater,
		"FrxInstructionTradeDetailViewFormatter" : FrxInstructionTradeDetailViewFormatter,
		"DrvInstructionRawFileViewFormater" : DrvInstructionRawFileViewFormater,
		"NcmAuthAdjustmentQueryDetailViewFormatter" : NcmAuthAdjustmentQueryDetailViewFormatter,
		"ExchangeRateFormatter" : ExchangeRateFormatter,
		"NdfAmendDateFormatter" : NdfAmendDateFormatter,
		"TDBalancePayableViewFormatter" : TDBalancePayableViewFormatter,
		"TDBalanceReceivableViewFormatter" : TDBalanceReceivableViewFormatter,
		"TDBalanceDRVFutureBalanceViewFormatter" : TDBalanceDRVFutureBalanceViewFormatter

      }
    }
  });

  /*
  function DropdownCellFormatter(row, cell, value, columnDef, dataContext) {
		var options = columnDef.options;
		var data = options.data;
		var v;
		for( i in  data){
		  v = data[i];
		  if(value == v.value){
			return v.label;
		  }
        }
    return "";
  }
  */

  function BatchReportQueryFormatter(row, cell, value, columnDef, dataContext) {
	var options = columnDef.options || {};
	var markup = "";
	if ($.trim(value) === "") {
		return options.showEmptyOnNoFileName ? "" : xenos.i18n.batchReportQuery.nofilename;
	}
	if (dataContext.doesFileExist === "Y") {
		markup += "<span class='batch-report-hyperlink' "
		+ "view='ReportDownLoadView' "
		+ " method='POST'"
		+ " href='/download/?path="
		+       dataContext.generatedName
		+       "&type=download"
		+ "'>"
		+   value
		+ "</span>";
	} else {
		//markup = options.showNameForUnavailable ? value : xenos.i18n.batchReportQuery.fileunavailable;
		markup = "<span title='" + xenos.i18n.batchReportQuery.fileunavailable + "'>" + value  + "</span>"
	}
	return markup;
  }
  
  function DrvTradeDetailViewFormater(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "";
    }

    var markup = ""
        + "<span class='detail-view-hyperlink' "
        +       "view='drvTradeDetailView' "
        +       "dialogTitle='" + xenos.title.drvTradeDetail + "'"
        +       "href='/secure/drv/trade/details/" + dataContext.tradePk +"'>"
        +   value
        + "</span>";

    return markup;
  }
  
  function DrvContractDetailViewFormater(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "";
    }

    var markup = ""
        + "<span class='detail-view-hyperlink' "
        +       "view='drvContractDetailView' "
        +       "dialogTitle='" + xenos.title.drvContractDetail + "'"
        +       "href='/secure/drv/contract/details/" + dataContext.contractPk +"'>"
        +   value
        + "</span>";

    return markup;
  }  
  
  function TradeDetailViewFormater(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "";
    }

    var markup = ""
        + "<span class='detail-view-hyperlink' "
        +       "view='tradeDetailView' "
        +       "referenceno='" + value + "' "
        +       "tradepk='" + dataContext.tradePk + "'"
        +       "referenceNo='" + dataContext.referenceNo + "'"
        +       "dialogTitle='[" + value + "] " + xenos.title.tradeDetail + "'"
        +       "href='/secure/trd/trade/details/" + dataContext.tradePk  + "/" + dataContext.referenceNo + "?diffEnableFlag=" + columnDef.isForAuth +"'>"
        +   value
        + "</span>";
		
    return markup;
  }
  
  
  function AllocationTradeDetailViewFormater(row, cell, value, columnDef, dataContext) {
	    if (value == null || value === "") {
	      return "";
	    }

	    var markup = ""
	        + "<span class='detail-view-hyperlink' "
	        +       "view='tradeDetailView' "
	        +       "referenceno='" + value + "' "
	        +       "tradepk='" + dataContext.tradePk + "'"
	        +       "referenceNo='" + dataContext.referenceNo + "'"
	        +       "dialogTitle='[" + value + "] " + xenos.title.tradeDetail + "'"
	        +       "href='/secure/trd/trade/details/" + dataContext.allocationTradePk  + "/" + dataContext.allocationReferenceNo + "?diffEnableFlag=" + columnDef.isForAuth +"'>"
	        +   value
	        + "</span>";

	    return markup;
	  }
  
  
    function TradeDetailViewFormaterForAuth(row, cell, value, columnDef, dataContext) {
	   
    if(dataContext.actionPendingFor == 'CANCEL'){
	    return"";
	   }else{
	    var markup = ""
	         + "<span class='detail-view-hyperlink detailIco' "
	        +       "view='tradeDetailView' "
	        +       "referenceno='" + value + "' "
	        +       "tradepk='" + dataContext.tradePk + "'"
	        +       "dialogTitle='[" + value + "] " + xenos.title.tradeDetail + "'"
	        +       "href='/secure/trd/trade/query/details/" + dataContext.tradePk + "?isForAuth=" + columnDef.isForAuth + "&authorizationStatus=" + dataContext.authorizationStatus+"&originalTxnPk=" + dataContext.originalTransactionPk+ "&newOldTxnPk=" + dataContext.newOldTransactionPk +"&authLevel=" +dataContext.authLevel+ "&actionDone="+dataContext.actionPendingFor+"'>"
	        + "</span>";
	    return markup;
		}
	  }
  function TradeFeedDetailViewFormater(row, cell, value, columnDef, dataContext) {
	    if (value == null || value === "") {
	      return "";
	    }

	    var markup = ""
	        + "<span class='detail-view-hyperlink' "
	        +       "view='tradeDetailView' "
	        +       "referenceno='" + value + "' "
	        +       "tradepk='" + dataContext.tradePk + "'"
	        +       "feedpk='"  +dataContext.feedMaintenancePk +"'"
	        +       "dialogTitle='[" + value + "] " + xenos.title.tradeDetail + "'"
	        +       "href='/secure/trd/trade/query/details/" + dataContext.tradePk + "?diffEnableFlag=" + columnDef.isForAuth +"'>"
	        +   value
	        + "</span>";

	    return markup;
	  }

  //Settlement Detail View Formatter
  // modified by rishav on 24/05/2013 for cases when corresponding settlementInfoPk is not present
	function SettlementDetailViewFormater(row, cell, value, columnDef, dataContext) {
	  var markup = "";
	  if (value == null || value === "") {
	    return "";
	  }
	  else if(dataContext.settlementInfoPk=='' || dataContext.settlementInfoPk==null){
	  		markup = '<span>'+value+'</span>';
	  }
	  else{
		  
          var commandFormId = $("[name='commandFormId']").val();
		  
		  markup = "<span class='detail-view-hyperlink' "
	        +       "view='settlementDetailView' "
	        +       "settlementreferenceno='" + value + "' "
	        +       "settlementinfopk='" + dataContext.settlementInfoPk + "' "
	        +       "dialogTitle='[" + value + "] " + xenos.title.settlementInfo + "' "
	        +       "href='/secure/stl/settlement/query/details/" + dataContext.settlementInfoPk +"?pendingSubmission=" + dataContext.pendingSubmission 
	        +               "&viewType=" + dataContext.viewType + "&clientSettlementInfoPk=" + dataContext.clientSettlementInfoPk 
	        +               "&viewMode=Settlement&nettedFlag=true&diffEnableFlag=" + columnDef.isForAuth  
	        +               "&commandFormId="+ commandFormId +"'>"
	        +   value
	        + "</span>";
        }
    return markup;
  }
	
	function SettlementDetailViewFormaterForInfo(row, cell, value, columnDef, dataContext) {
		  var markup = "";
		  if (value == null || value === "") {
		    return "";
		  }
		  else if(dataContext.settlementInfoPk=='' || dataContext.settlementInfoPk==null){
		  		markup = '<span>'+value+'</span>';
		  }
		  else{
			  
	          var commandFormId = dataContext.commandFormId;
			  
			  markup = "<span class='detail-view-hyperlink' "
		        +       "view='settlementDetailView' "
		        +       "settlementreferenceno='" + value + "' "
		        +       "settlementinfopk='" + dataContext.settlementInfoPk + "' "
		        +       "dialogTitle='[" + value + "] " + xenos.title.settlementInfo + "' "
		        +       "href='/secure/stl/settlement/query/details/" + dataContext.settlementInfoPk +"?pendingSubmission=" + dataContext.pendingSubmission 
		        +               "&viewType=" + dataContext.viewType + "&clientSettlementInfoPk=" + dataContext.clientSettlementInfoPk 
		        +               "&viewMode=Settlement&nettedFlag=true&diffEnableFlag=" + columnDef.isForAuth  
		        +               "&commandFormId="+ commandFormId +"'>"
		        +   value
		        + "</span>";
	        }
	    return markup;
	  }
	
	
	
	function SettlementDetailViewInstructionFormater(row, cell, value, columnDef, dataContext) {
		  var markup = "";
		  if (value == null || value === "") {
		    return "";
		  }
		  else if(dataContext.settlementInfoPk=='' || dataContext.settlementInfoPk==null){
		  		markup = '<span>'+value+'</span>';
		  }
		  else{
			  
	          var commandFormId = $("[name='commandFormId']").val();
			  
			  markup = "<span class='detail-view-hyperlink' "
		        +       "view='settlementDetailView' "
		        +       "settlementreferenceno='" + value + "' "
		        +       "settlementinfopk='" + dataContext.settlementInfoPk + "' "
		        +       "dialogTitle='[" + value + "] " + xenos.title.settlementInfo + "' "
		        +       "href='/secure/stl/settlement/query/details/" + dataContext.settlementInfoPk+"/" + dataContext.settlementReferenceNo +"?pendingSubmission=" + dataContext.pendingSubmission 
		        +               "&viewType=" + dataContext.viewType + "&clientSettlementInfoPk=" + dataContext.clientSettlementInfoPk 
		        +               "&viewMode=Instruction&nettedFlag=true&diffEnableFlag=" + columnDef.isForAuth +"'>"
		        +   value
		        + "</span>";
	        }
	    return markup;
	  }
	
	//Settlement Detail View formatter for STL AUTH Summary Page
	//This formatter will support both the Detail Views in the STL AUTH Summary Page
  	function SettlementDetailViewFormaterForAuth(row, cell, value, columnDef, dataContext) {
		var markup = ""
		if(columnDef.isForAuth){
			if(dataContext.actionPendingFor == 'CANCEL'){
				return markup;
			}else{
				markup = ""
						+ "<span class='detail-view-hyperlink detailIco' "
						+ "view='settlementDetailsForAuth' "
						+ "dialogTitle='[" + value + "] " + xenos.title.settlementInfo + "'"
						+ "href='/secure/stl/amend/authorization/query/details/" + dataContext.settlementInfoPkSec + "/" + dataContext.settlementInfoPkCash
							+ "?viewMode=Settlement&nettedFlag=true&diffEnableFlag=" + columnDef.isForAuth 
							+ "&authStatus=" + columnDef.authStatus 
							+ "&originalTxnPkSec=" + dataContext.originalTransactionPkSec 
							+ "&originalTxnPkCash=" + dataContext.originalTransactionPkCash 
							+ "&newOldTxnPkSec=" + dataContext.newOldTransactionPkSec 
							+ "&newOldTxnPkCash=" + dataContext.newOldTransactionPkCash 
							+ "&settlementType=" + dataContext.settlementType
							+ "&authLevel=" + dataContext.authLevel
							+ "&actionDone=" + dataContext.actionPendingFor 
						+ "'>"
						+ "</span>";
				return markup;
			}
		}else{
			if (value == null || value === "") {
				return markup; 
			}
			
			markup = "<span class='detail-view-hyperlink' "
					+ "view='settlementDetails' "
					+ "dialogTitle='[" + value + "] " + xenos.title.settlementInfo + "'"
					+ "href='/secure/stl/settlement/query/details/auth/" + dataContext.settlementInfoPkSec + "/" + dataContext.settlementInfoPkCash 
						+ "?viewMode=Instruction&nettedFlag=true&diffEnableFlag=" + columnDef.isForAuth 
						+ "&settlementType=" + dataContext.settlementType 
					+ "'>"
					+ value
					+ "</span>";
			return markup;
		}
    }

  //Employee Detail view formatter - Open from Access Log Screen
  function EmployeeDetailViewFormater(row, cell, value, columnDef, dataContext) {
	    var result
	    value = value || "";
		switch(value){
			case "SYSTEM" :
				result =  "<span>"+ value +"</span>";
				break;
			default :
				result = ""
			if($.trim(dataContext['employeeTypeValues']) != '' && $.trim(dataContext['agentFlag']) != 'Y' && $.trim(dataContext['incentiveDetView']) == 'Y'){
				result += "<span class='detail-view-hyperlink popupIconBtn' "
					+     "title = '" + xenos.title.incentiveDetail + "' "
					+       "view=employeeIncentiveDetailView userid='" + value + "' "
					+       "employeePk='" + dataContext.employeePk + "' "
					+       "dialogTitle='[" + value + "] " + xenos.title.incentiveDetail + "' "
					+       "href='/secure/ref/empincentive/restrictedview/"+dataContext.employeePk+"?popup=true'>j "
					+ "</span>";
			}
			
            result += "<span class='detail-view-hyperlink' "
			+     "title = '" + value + "' "
            +       "view=employeeDetailView userid='" + value + "' "
            +       "employeePk='" + dataContext.employeePk + "' "
            +       "dialogTitle='[" + value + "] " + xenos.title.employeeDetails + "' "
            +       "href='/secure/ref/emp/details/" + dataContext.employeePk + "'>"
            +   value
            + "</span>";
		}
		return result;
  }
  
  //Employee Detail view formatter - Open from Employee Query Screen
  function EmployeeQueryDetailViewFormater(row, cell, value, columnDef, dataContext) {
	    var result
	    value = value || "";
		switch(value){
			case "SYSTEM" :
				result =  "<span>"+ value +"</span>";
				break;
			default :
				result = "";
				result += "<span class='detail-view-hyperlink' "
				+     "title = '" + value + "' "
				+       "view=employeeDetailView userid='" + value + "' "
				+       "employeePk='" + dataContext.employeePk + "' "
				+       "dialogTitle='[" + value + "] " + xenos.title.employeeDetail + "' "
				+       "href='/secure/ref/emp/querydetails/" + dataContext.employeePk + "'>"
				+   value
				+ "</span>";
		}
		return result;
  }  

   function AccountDetailViewFormater(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "";
    }
   if(dataContext.accountPk==""){
       return '<span>'+value+'</span>';
	  }else{
    var markup = ""
        + "<span class='detail-view-hyperlink' "
        +       "view='accountDetailView' "
        +       "accountno='" + value + "' "
        +       "accountpk='" + dataContext.accountPk + "'"
        +       "dialogTitle='[" + value + "] " + xenos.title.accountDetail + "'"
        +       "href='/secure/ref/account/details/" + dataContext.accountPk + "?popup=true" + "'>"

        +   value
        + "</span>";
    return markup;
	}
  }

   function CamMovementAccountDetailViewFormater(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "";
    }
   if(dataContext.accountPkDetail==""){
       return '<span>'+value+'</span>';
	  }else{
    var markup = ""
        + "<span class='detail-view-hyperlink' "
        +       "view='accountDetailView' "
        +       "accountno='" + value + "' "
        +       "accountpk='" + dataContext.accountPkDetail + "'"
        +       "dialogTitle='[" + value + "] " + xenos.title.accountDetail + "'"
        +       "href='/secure/ref/account/details/" + dataContext.accountPkDetail + "?popup=true" + "'>"

        +   value
        + "</span>";
    return markup;
	}
  }
  
     function DocumentDetailViewFormater(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "";
    }
	
	if (columnDef.modeOfOperation == "VIEW") {
   
    var markup = ""
        + "<span class='detail-view-hyperlink' "
        +       "view='documentDetailView' "
        +       "dialogTitle='[" + value + "] " + xenos.title.documentDetail + "'"
        +      "href='/secure/ref/document/query/queryShow/" + dataContext.legalAgreementPk + "?popup=true" + "'>"
        +   value
        + "</span>";
    return markup;
	}
	else {
	
	if(dataContext.accountNo == "" || dataContext.accountAgreementPk == ""){
	
       return '<span>'+value+'</span>';
	  
	}
	else{
	  var container = $("#content");
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]',container).val();
	 var markup = ""
       + "<span class='detail-view-hyperlink-nowindow' "
        +        "pk='" + dataContext.accountAgreementPk + "'"
	   +      "queryUrl='" +columnDef.queryUrl+ "'"
      +      "href='/secure/ref/document/query/entry/entryShow/" + dataContext.accountAgreementPk + "/" + dataContext.accountNo + commandFormId +"'>"
        +   value
        + "</span>";
	return markup;
	}
	
	}
	
  }
  function TradingAccountDetailViewFormater(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "";
    }
   if(dataContext.tradingAccountPk==""){
       return '<span>'+value+'</span>';
	  }else{
    var markup = ""
        + "<span class='detail-view-hyperlink' "
        +       "view='accountDetailView' "
        +       "accountno='" + value + "' "
        +       "accountpk='" + dataContext.tradingAccountPk + "'"
        +       "dialogTitle='[" + value + "] " + xenos.title.accountDetail + "'"
        +       "href='/secure/ref/account/details/" + dataContext.tradingAccountPk + "?popup=true" + "'>"

        +   value
        + "</span>";
    return markup;
	}
  }

 function GroupDetailViewFormater(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "";
    }
    var markup = ""
        + "<span class='detail-view-hyperlink' "
        +       "view='groupingDetailView' "
        +       "pk='" + dataContext.groupPk + "'"
        +       "queryUrl='" +columnDef.queryUrl+ "'"
        +       " method='POST'"
        +       "dialogTitle='[" + value + "] " + xenos.title.AccountGroupingQueryView + "'"
        +       "href='/secure/ref/grouping/query/groupdetails/" + dataContext.groupPk + "?popup=true" + "'>"
        +   value
        + "</span>";
    return markup;
  }

  function FinInstDetailViewFormater(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "";
    }

    var markup = ""
        + "<span class='detail-view-hyperlink' "
		+       "view='finInstDetailView' "
        +       "roleCode='" + value + "' "
        +       "finInstRolePk='" + dataContext.finInstRolePk + "'"
        +       "dialogTitle='[" + value + "] " + xenos.title.fininstDetail + "'"
        +       "href='/secure/ref/fininst/details/" + dataContext.finInstRolePk + "?popup=true" + "'>"
        +   value
        + "</span>";
    return markup;
  }

  function FinInstDetailViewFormatter(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "";
    }
    var options = columnDef.finInstDetailOptions || {};
    var markup = ""
        + "<span class='detail-view-hyperlink' "
        +       "view='finInstDetailView' "
        +       "roleCode='" + value + "' "
        +       "finInstRolePk='" + dataContext.finInstRolePk + "'"
        +       "dialogTitle='[" + value + "] " + xenos.title.fininstDetail + "'"
        +       "href='/secure/ref/fininst/details/" +dataContext[options.pkFieldName] + "?popup=true" + "'>"
        +   value
        + "</span>";
    return markup;
  }
   function InstrumentDetailViewFormater(row, cell, value, columnDef, dataContext) {
		if (value == null || value === "") {
		  return "";
		}
		if(dataContext.instrumentPk==""){
		   return '<span>'+value+'</span>';

		} else {
			var markup = ""
				+ "<span class='detail-view-hyperlink' "
				+       "view='instrumentDetailView' "
				+       "instrumentCode='" + value + "' "
				+       "instrumentPk='" + dataContext.instrumentPk + "'"
				+       "dialogTitle='[" + value + "] " + xenos.title.instrumentDetail + "'"
				+       "href='/secure/ref/instrument/details/" + dataContext.instrumentPk + "?popup=true" + "'>"
				+   value
				+ "</span>";
			return markup;
		}
	}
	
	function CamMomvementInstrumentDetailViewFormater(row, cell, value, columnDef, dataContext) {
		if (value == null || value === "") {
		  return "";
		}
		if(dataContext.instrumentPkDetail==""){
		   return '<span>'+value+'</span>';
		} else {
			var markup = ""
				+ "<span class='detail-view-hyperlink' "
				+       "view='instrumentDetailView' "
				+       "instrumentCode='" + value + "' "
				+       "instrumentPk='" + dataContext.instrumentPkDetail + "'"
				+       "dialogTitle='[" + value + "] " + xenos.title.instrumentDetail + "'"
				+       "href='/secure/ref/instrument/details/" + dataContext.instrumentPkDetail+ "?popup=true" + "'>"
				+   value
				+ "</span>";
			return markup;
		}
	}
	
	function InstrumentDetailViewFormaterForSrsBalance(row, cell, value, columnDef, dataContext) {
		if (value == null || value === "") {
		  return "";
		}
		if(dataContext.header){
			//$('.slick-row[row='+row+']').addClass('Pass');
			return '<span style="font-weight:bold">'+value+'</span>';
		}
		if(dataContext.ledgerCategory == null){
		   return '<span>'+value+'</span>';
		}
		if(dataContext.instrumentPk==""){
		   return '<span>'+value+'</span>';
		} else {
			var markup = ""
				+ "<span class='detail-view-hyperlink' "
				+       "view='instrumentDetailView' "
				+       "instrumentCode='" + value + "' "
				+       "instrumentPk='" + dataContext.instrumentPk + "'"
				+       "dialogTitle='[" + value + "] " + xenos.title.instrumentDetail + "'"
				+       "href='/secure/ref/instrument/details/" + dataContext.instrumentPk + "?popup=true" + "'>"
				+   value
				+ "</span>";
			return markup;
		}
	}

  function ExmMessageQuerySelectFormater(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "";
    }
    return "<span class='editBtn'><input id='check' type='checkbox'  value='' /></span>";
  }

  function ExmMessageQueryEditFormater(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "";
    }
        var screenId = $('[name=screenId]','#content').val();
    var markup = ""
        + "<span class='detail-view-hyperlink popupIconBtn' "
        +       "view='exmMessageEditForm' "
        +       "dialogTitle='" + xenos.title.exmEditForm + "' "
        +       "title='" + columnDef.name + "' "
        +       "href='/secure/exm/exmmessage/edit/init?popup=true&pk=" + dataContext.messagePk + "&screenId=" + screenId + "'>"
        +   "Y"
        + "</span>";
    return markup;
  }

  function ExmMessageQueryCommentEntryFormater(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "";
    }
        var screenId = $('[name=screenId]','#content').val();
    var markup = ""
        + "<span class='detail-view-hyperlink popupIconBtn' "
        +       "view='exmMessageCommentForm' "
        +       "dialogTitle='" + xenos.title.exmCommentForm + "' "
        +       "title='" + columnDef.name + "' "
        +       "href='/secure/exm/exmmessage/comment/init?popup=true&pk=" + dataContext.messagePk + "&screenId=" + screenId + "'>"
        +   "Y"
        + "</span>";
    return markup;
  }

  function ExmMessageQueryHtmlFormater(row, cell, value, columnDef, dataContext) {
	    if (value == null || value === "") {
	      return "";
	    }
	    var markup = ""
	        + "<span class='detail-view-hyperlink popupIconBtn' "
	        +       "view='exmMessageHtmlView' "
	        +       "dialogTitle='" + xenos.title.exmHtmlView + "' "
	        +       "title='" + columnDef.name + "' "
	        +       "href='/secure/exm/exmmessage/query/html/"+ dataContext.html + "?popup=true" + "'>"
	        +   "j"
	        + "</span>";
	    return markup;
	  }

	  function ExmMessageQueryRawDataFormater(row, cell, value, columnDef, dataContext) {
	    if (value == null || value === "") {
	      return "";
	    }

	    var markup = ""
	        + "<span class='detail-view-hyperlink popupIconBtn' "
	        +       "view='exmMessageHtmlView' "
	        +       "dialogTitle='" + xenos.title.exmRawData + "' "
	        +       "title='" + columnDef.name + "' "
	        +       "href='/secure/exm/exmmessage/query/rawdata/"+ dataContext.rawData + "?popup=true" + "'>"
	        +   "j"
	        + "</span>";
	    return markup;
	  }

	//Formatter for Cancel Records
   function CancelRecordFormatter(row, cell, value) {
		if(value == "CANCEL" || value == "CXL" || value == "CANC"){
			return '<span class="cancel">CXL</span>';
		}else if(value == 'NORMAL'){
			return '';
		}else if(value == null || value == ''){
			return '';
		}else{
			return '<span>' + value + '</span>';
		}
	}

	//Formatter for Authorized and Rejected Records
   function AuthorizedRejectedRecordFormatter(row, cell, value) {
		if(value == "REJECTED" || value == "rejected"){
			return '<span class="cancel">REJECTED</span>';
		}else if(value == "AUTHORIZED" || value == "authorized"){
			return '<span class="grnTxt">AUTHORIZED</span>';
		}else{
			return '<span>'+value+'</span>';
		}
	}

   	 //Formatter for Authorization Status in Authorization Result page, UserConfirmatiion and SystemConfirmation page, 
	//changes made against the issue xenosRI-2002
	function AuthStatusFormatter(row, cell, value,columnDef,dataContext) {
		if((columnDef.authStatus =='AUTHORIZED' || columnDef.authStatus =='authorized') && (columnDef.authFlag==false || columnDef.authFlag=='false')){
			return '<span class="grnTxt">'+ value + '</span>';
		}else if((columnDef.authStatus == "REJECTED" || columnDef.authStatus == "rejected") && (columnDef.authFlag==false || columnDef.authFlag=='false')){
			return '<span class="cancel">REJECTED</span>';
		}else if((columnDef.authStatus =="PENDING" || columnDef.authStatus =="pending" ) && (columnDef.authFlag==false || columnDef.authFlag=='false')){
			return '<span>PENDING</span>';
		}else if((value == "AUTHORIZED" || value == "authorized" || value=="PENDING" || value=="pending") && (columnDef.authFlag==true || columnDef.authFlag=='true')){
				if(columnDef.authCategory == "authorized" || columnDef.authCategory == "AUTHORIZED" ){
					if(columnDef.isSystemConfirmationPage == false || columnDef.isSystemConfirmationPage == 'false'){
						return '<span class="orngTxt">TO BE AUTHORIZED</span>';
					}else{
						if(dataContext.authLevel == 1 ){
							return '<span class="grnTxt">AUTHORIZED</span>';
						}else{
							return '<span>PENDING</span>';
						}
					}
				}else{
					if(columnDef.isSystemConfirmationPage == false || columnDef.isSystemConfirmationPage == 'false'){
						return '<span class="cancel">TO BE REJECTED</span>';
					}else{
						return '<span class="cancel">REJECTED</span>';
					}
				}
		}
	}
	//This is a revised version of the Auth Status Formatter.
	function AuthStatusFormatterRev(row, cell, value,columnDef,dataContext) {
		if((value =='AUTHORIZED' || value =='authorized') && (columnDef.authFlag==false || columnDef.authFlag=='false')){
			return '<span class="grnTxt">'+ value + '</span>';
		}else if((value == "REJECTED" || value == "rejected") && (columnDef.authFlag==false || columnDef.authFlag=='false')){
			return '<span class="cancel">'+ value + '</span>';
		}else if((value =="PENDING" || value =="pending" ) && (columnDef.authFlag==false || columnDef.authFlag=='false')){
			return '<span>'+ value + '</span>';
		}else if((value == "AUTHORIZED" || value == "authorized" || value=="PENDING" || value=="pending") && (columnDef.authFlag==true || columnDef.authFlag=='true')){
				if(columnDef.authCategory == "authorized" || columnDef.authCategory == "AUTHORIZED" ){
					if(columnDef.isSystemConfirmationPage == false || columnDef.isSystemConfirmationPage == 'false'){
						return '<span class="orngTxt">TO BE AUTHORIZED</span>';
					}else{
						if(dataContext.authLevel == 1 ){
							return '<span class="grnTxt">AUTHORIZED</span>';
						}else{
							return '<span>PENDING</span>';
						}
					}
				}else{
					if(columnDef.isSystemConfirmationPage == false || columnDef.isSystemConfirmationPage == 'false'){
						return '<span class="cancel">TO BE REJECTED</span>';
					}else{
						return '<span class="cancel">REJECTED</span>';
					}
				}
		}
	} 

	//Formatter for ActionPendingFor in Authorization Result page, UserConfirmatiion and SystemConfirmation page, 
	//changes made against the issue xenosRI-2002
	function ActionPendingFormatter(row, cell, value,columnDef,dataContext) {
		if((columnDef.authFlag==false || columnDef.authFlag=='false')){
			return '<span>'+value+'</span>';	
		}else if((columnDef.authFlag==true || columnDef.authFlag=='true')){
			//if(columnDef.authCategory == "authorized" || columnDef.authCategory == "AUTHORIZED" ){
			//if(dataContext.authLevel == 1 ){
				//return '<span></span>';
			//}else{
					return '<span>'+value+'</span>';
				//}
			//}else{
						//return '<span>'+value+'</span>';
			//}
		}
	}

	function InstrumentDefaultCodeFormatter(row, cell, value) {
		if(value == true || value == 'true'){
			return '<span class="cancel">*</span>';
		}else{
			return '';
		}
	}

	 //Formatter for Fail Settlement Status
   function FailRecordFormatter(row, cell, value) {
		if(value == "FAIL"){
			return '<span class="cancel">' + value + '</span>';
		}else{
			return value;
		}
	}
	  //Formatter for negetive balance Records
	 function NegetiveBalanceFormatter(row, cell, value) {
		if ($.trim(value).replace(/,/g, '') < 0) {
		return "<span style='color:red;font-weight:bold;'>" + value + "</span>";
		}else{
			if (value == null || value === "") {
				return "";
			} else
				return "<span>" + value + "</span>";
		}
  }
  function SmrFailedStatusFormatter(row, cell, value, columnDef, dataContext){	  
		if (value == null || value === "") {
		  return "";
		}	  
		  var status = dataContext.requestedStatus;
		  if(typeof(status) != 'undefined' && status != null){
			  if (/Failed/i.test($.trim(status))) {
					return "<span style='color:red;font-weight:bold;'>" + value + "</span>";
				}else{			
					return "<span>" + value + "</span>";
				}
		  }
				  
	  }	 
  //Formatter for negative number for book value.
  function CamNegetiveBalanceFormatter(row, cell, value, columnDef, dataContext){	  
	if (value == null || value === "") {
	  return "";
	}	  
	  var sign = dataContext.displayBalanceInRed;
	  if(typeof(sign) != 'undefined' && sign != null){
		  if ($.trim(sign) == '-') {
				return "<span style='color:red;font-weight:bold;'>" + value + "</span>";
			}else{			
				return "<span>" + value + "</span>";
			}
	  }
			  
  }	 
  //Formatter for cam balance query Records
    function CamBalanceQueryFormatter(row, cell, value, columnDef, dataContext) {
	 if (value == null || value === "") {
      return "";
    }
	 var sign = dataContext.displayBalanceInRed;
	 var markup = "";
	 if(typeof(sign) != 'undefined' && sign != null){
			if ($.trim(sign) == '-') {
				markup = ""
					+ "<span class='detail-view-hyperlink' "
					+       "style='color:red !important;font-weight:bold;' "
					+       "view='balanceDetailView' "
					+       "dialogTitle='" + xenos.title.camMovementRequestSummary + "'"
					+       "href='/secure/cam/movement/query/camledgermovement?accountNo=" + dataContext.accountDisplayName + "&movementBasis=" + dataContext.balanceBasis
					+		"&movementBasisLabel=" + dataContext.balanceBasisLabel
					+		"&instPk=" + dataContext.instrumentPk + "&baseDate=" + dataContext.baseDate + "&balanceFlag=Y&screenId=CAMMQ'>"
					+   value
					+ "</span>";
			} else {
				markup = ""
					+ "<span class='detail-view-hyperlink' "
					+       "view='balanceDetailView' "
					+       "dialogTitle='" + xenos.title.camMovementRequestSummary + "'"
					+       "href='/secure/cam/movement/query/camledgermovement?accountNo=" + dataContext.accountDisplayName + "&movementBasis=" + dataContext.balanceBasis
					+		"&movementBasisLabel=" + dataContext.balanceBasisLabel
					+		"&instPk=" + dataContext.instrumentPk + "&baseDate=" + dataContext.baseDate + "&balanceFlag=Y&screenId=CAMMQ'>"
					+   value
					+ "</span>";
			}		 
	 }

    return markup;
  }
    //Formatter for cam Transaction query   
    function CamTransactionDetailFormatter(row, cell, value, columnDef, dataContext){
      if (value == null || value === "") {
        return "";
      }
      var markup = null;
	  	if(dataContext.module=="CAM"){
	  	dataContext.camEntryPk = dataContext.triggeringTxnPk;
	  	markup = CamSecurityDetailFormater(row, cell, value, columnDef, dataContext);
	  	}
	  	else if(dataContext.module=="NCM"){
	  	markup = NcmTradeDetailViewFormatter(row, cell, value, columnDef, dataContext);
	  	}
	  	else if ( dataContext.module =="STL01"||dataContext.module =="STL02"){
		
		}else if (dataContext.module == "TRD"){
			dataContext.tradePk = dataContext.triggeringTxnPk;	
			markup = TradeDetailViewFormater(row, cell, value, columnDef, dataContext);
		}else if(dataContext.module =="CAX02"){
			dataContext.rightsDetailPk = dataContext.triggeringTxnPk;
			markup = RightsDetailViewFormatter(row, cell, value, columnDef, dataContext);
		}else if(dataContext.module =="CAX05"){
			dataContext.rightsExercisePk = dataContext.triggeringTxnPk;
			markup = ExerciseDetailViewFormatter(row, cell, value, columnDef, dataContext);	
		}else if(dataContext.module =="DRV"){
			$('.formHeader').find('.formTabErrorIco').css('display', 'block');
			$('.formHeader').find('.formTabErrorIco').off('click');
			$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error,['No Detail Screen Available for DRV'], true));
		}else if(dataContext.module =="FRX"){
			$('.formHeader').find('.formTabErrorIco').css('display', 'block');
			$('.formHeader').find('.formTabErrorIco').off('click');
			$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error,['No Detail Screen Available for FRX'], true));
		}else if(dataContext.module =="BKG"){
			$('.formHeader').find('.formTabErrorIco').css('display', 'block');
			$('.formHeader').find('.formTabErrorIco').off('click');
			$('.formHeader').find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error,['No Detail Screen Available for BKG'], true));
		}

      return markup;
    }
  //Formatter for cam Security query 
  function CamSecurityDetailFormater(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "";
    }

    var markup = ""
        + "<span class='detail-view-hyperlink' "
		+       "view='CamSecurityDetail' "
		+       "camEntryPk='" + dataContext.camEntryPk + "'"
        +       "dialogTitle='[" + value + "] " + xenos.title.camSecurityDetail + "'"
        +       "href='/secure/cam/securityi/details/" + dataContext.camEntryPk + "?popup=true'>"
        +   value
        + "</span>";

    return markup;
  }
  function SecurityIODetailViewFormaterForAuth(row, cell, value, columnDef, dataContext){
		if(dataContext.actionPendingFor == 'CANCEL'){
	    	return "";
	    }else{
			if(dataContext.camEntryPk==""){
				return '<span>'+value+'</span>';
			} else {
				var markup = ""
				+ "<span class='detail-view-hyperlink detailIco' "
				+       "view='CamSecurityDetail' "
				+       "dialogTitle='[" + value + "] " + xenos.title.camSecurityDetail + "'"
				+       "href='/secure/cam/securityio/authorization/query/details/" + dataContext.camEntryPk + "?popup=true" +"&actionType="+dataContext.actionPendingFor+  "'>"
				+ "</span>";
				return markup;
			}
		}
	}
  
  //Formatter for cam portfolio balance query Records
    function CamPortfolioBalanceQueryFormatter(row, cell, value, columnDef, dataContext) {
	 if (value == null || value === "") {
      return "";
    }
    var markup = ""
        + "<span class='detail-view-hyperlink' "
        +       "view='camMovementRequestSummary' "
        +       "dialogTitle='" + xenos.title.camMovementRequestSummary + "'"
        +       "href='/secure/cam/movement/query/camledgermovement?accountNo=" + dataContext.accountNo + "&movementBasis=" + columnDef.movementBasis + ""
		+		"&instPk=" + dataContext.instrumentPk + "&baseDate=" + columnDef.baseDate + "&balanceFlag=Y  '>"
        +   value
        + "</span>";

    return markup;
	      //return "<span style='color:green;'>" + value + "</span>";
  }

  //Formatter to define consolidate action. Id is basically the pk column.
  function ConsolidateActFormater(row, cell, value, columnDef, dataContext) {
	  if(dataContext.isConsEnabled === false) return "";
		else {
			var mkp = '<span id="cnslAct_'+row+'" class="select-consolidation" row="'+ row +'" pk="' + dataContext.pk + '" ></span>';
			return mkp;
		}
   }

  //Formatter to define consolidate action. Id is basically the pk column.
  function AccountAuthFormatter(row, cell, value, columnDef, dataContext) {
		var mkp = "";
		if(dataContext.stateOfBean=='NEW'){
			mkp = '<img src=' + xenos.context.path + '/images/xenos/icon/add-ico.png>';
		}else if(dataContext.stateOfBean=='MODIFIED'){
			mkp = '<img src=' + xenos.context.path + '/images/xenos/icon/accnt-edit-ico.png>';
		}else if(dataContext.stateOfBean=='DELETED'){
			mkp = '<img src=' + xenos.context.path + '/images/xenos/icon/trash-ico-blue.png>';
		}else{}

		return mkp;
  }
//Formatter to define consolidate action. Id is basically the pk column.
  function AuthCheckboxFormater(row, cell, value, columnDef, dataContext) {
  		var mkp = '<input type="checkbox" class="consolidateActCkBox" id="authCb_'+row+'" row="'+ row +'" pkForAuthorization="' + dataContext.accountPk + '" />';
  		return mkp;
  }

   //Formatter to define consolidate action Trade Authorization. Id is basically the pk column.
  function TradeAuthCheckboxFormater(row, cell, value, columnDef, dataContext) {
  		var mkp = '<input type="checkbox" class="consolidateActCkBox" id="authCb_'+row+'" row="'+ row +'" pkForAuthorization="' + dataContext.tradePk + '" />';
  		return mkp;
  }


	function xenosTextFormatter(row, cell, value, columnDef, dataContext) {
		if(value == null || value === "") {
		  return "";
		}
		return "<span class='txtUpper' >"+ value +"</span>";
	}
	function xenosTextInputFormatter(row, cell, value, columnDef, dataContext) {
	    value = value || "";
		var options = columnDef.options || {};
		var styleClass = options.styleClass || '';
		var style = options.style || '';
		var disabledTmp =  false;
		if(options.disabled){
			if(jQuery.isFunction(options.disabled)){
				disabledTmp = options.disabled(row, cell, value, columnDef, dataContext);
			} else {
				disabledTmp = options.disabled;
			}
		}
	    var disabled = disabledTmp ? "disabled='true'" : "";
	    var markup = ""
	        + 	"<span>"
	        + 		"<input type='text' name='" + columnDef.id + "' rowIndex='"+row+"' value='" + value + "' readOnly = 'readOnly'";
			if(styleClass != ''){
				markup += " class='"+ styleClass + "'";
			}
			if(disabled){
				markup += " disabled='disabled'";
			}
			markup += " style='width:"+(columnDef.width - 10)+"px; ";
			if(style != ''){
				markup += style ;
			}
			markup += "'>"
				   +	"</span>";
	    return markup;
   }
   //This formatter generate input box in result page if txnType value other than 90,91,92,93
   function xenosTxnInputFormatter(row, cell, value, columnDef, dataContext) {
	    value = value || "";
		var options = columnDef.options || {};
		var styleClass = options.styleClass || '';
		var disabledTmp =  false;
		if(options.disabled){
			if(jQuery.isFunction(options.disabled)){
				disabledTmp = options.disabled(row, cell, value, columnDef, dataContext);
			} else {
				disabledTmp = options.disabled;
			}
		}
	    var disabled = disabledTmp ? "disabled='true'" : "";
	   if(dataContext.txnTypeStr=="90" || dataContext.txnTypeStr=="91" || dataContext.txnTypeStr=="92" || dataContext.txnTypeStr=="93" ){
       return '<span>'+value+'</span>';
	  }else{
	    var markup = ""
	        + 	"<span>"
	        + 		"<input type='text' name='" + columnDef.id + "' rowIndex='"+row+"' value='" + value + "'";
			if(styleClass != ''){
				markup += " class='"+ styleClass + "'";
			}
			if(disabled){
				markup += " disabled='disabled'";
			}
			markup += " style='width:"+(columnDef.width - 10)+"px;'>"
				   +	"</span>";
	    return markup;
		}
   }
  function CollapseFormatter (row, cell, value, columnDef, dataContext) {

	/*var spacer = "<span style='display:inline-block;height:1px;width:" + 15 + "px'></span>";

	if(!dataContext["parent"]){
	//alert(dataContext._collapsed);
		if (!dataContext._collapsed) {
			  return  " <span class='toggle expand'></span>&nbsp;" + value;
			} else {
			  return  " <span class='toggle collapse'></span>&nbsp;" + value;
			}
	} else {
		return  " <span class='toggle'></span>&nbsp;" + value;
	}*/

	var spacer = "<span style='display:inline-block;height:1px;width:" + (15 * dataContext["indent"])+ "px'></span>";
	var loader = "<span class='treeGridLoader'></span>";

	if(!dataContext["isLeaf"]){
		if (!dataContext._collapsed) {
			  return spacer + loader + " <span class='toggle expand'></span>&nbsp;" + value;
			} else {
			  return  spacer + loader +" <span class='toggle collapse'></span>&nbsp;" + value;
			}
		} else if(dataContext["isLeaf"]){
			return  spacer +" <span class='toggle slick-subRow'></span>&nbsp;" + value;
		}
	};

  //Employee Detail view formatter
  function LeafIdentifyFormater(row, cell, value, columnDef, dataContext) {
		if(dataContext.is_leaf_node == 'Y'){
			return "<span class='leaf'>"+ value +"</span>";
		}else{
			return "<span class='node'>"+ value +"</span>";
		}
  }

  // Account Authorization Detail view formatter
 function AccountAuthDetailViewFormatter(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "";
    }
   if(dataContext.accountPk==""){
       return '<span>'+value+'</span>';
	}else{
    var markup = ""
        + "<span class='detail-view-hyperlink' "
        +       "view='accountDetailView' "
        +       "accountno='" + value + "' "
        +       "accountpk='" + dataContext.accountPk + "'"
        +       "dialogTitle='[" + value + "] " + xenos.title.accountDetail + "'"
        +       "href='/secure/ref/account/viewPendingAuth/" + dataContext.accountPk +"/"+dataContext.actionType+"/"+dataContext.authorizationStatus+"?popup=true'>"

        +   value
        + "</span>";
    return markup;
	}
  }

   // Instrument Authorization Detail view formatter
 function InstrumentAuthDetailViewFormatter(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "";
    }
   if(dataContext.instrumentPk==""){
       return '<span>'+value+'</span>';
	  }else{
    var markup = ""
        + "<span class='detail-view-hyperlink' "
        +       "view='instrumentDetailView' "
        +       "instrumentCode='" + value + "' "
        +       "instrumentPk='" + dataContext.instrumentPk + "'"
        +       "dialogTitle='[" + value + "] " + xenos.title.instrumentDetail + "'"
        +       "href='/secure/ref/instrument/viewPendingAuth/" + dataContext.instrumentPk + "?popup=true" + "'>"
        +   value
        + "</span>";
    return markup;
	}
  }

  function DropdownCellFormatter(row, cell, value, columnDef, dataContext) {
	var options = columnDef.options;
	var data = options.data;
    var disabled = options.disabled ? "disabled='true'" : "";
	var v, dataAvlFlag=false;
	var tmpStr = "<select tabIndex='0' style='width:100%' class='dropdowninput' rowIndex='"+row+"' "+ disabled +">";
	var optionStr= "";
	for( i in  data){
		v = data[i];
		if(v.value == "")
			continue;
		optionStr += "<option value='"+v.value+"'";
		if(value == v.value){
			dataAvlFlag = true;
			optionStr += " selected='selected'>"
		} else {
			optionStr +=">";
		}
	  optionStr += v.label + "</option>";
	}
	if(dataAvlFlag){
		tmpStr += "<option value=''></option>";
	} else {
		tmpStr += "<option value='' selected='selected'></option>";
	}
	tmpStr += optionStr;
	tmpStr += "</select>";
	return tmpStr;
  }
  
  function DropdownReadOnlyFormatter(row, cell, value, columnDef, dataContext) {
	var options = columnDef.options;
    var editableFn = options.editableFunction || false;
    
    var disabledClass = '';
    if(editableFn){
      disabledClass = !options['editableFunction'](columnDef, dataContext) ? 'disabledImg' : '';
    }
    
    var markup = "";
    
    if(value == null || value == ""){
        markup = "<span class='selectFormatterImg " + disabledClass + "'></span>";
    } else {
        markup = "<span class='selectFormatterImg " + disabledClass + "'>" + value + "</span>";
    }
    
    return markup;
  }
  
  function xenosSelectInputFormatter(row, cell, value, columnDef, dataContext) {
	var options = columnDef.options;
	var data = options.data;
	var v, dataAvlFlag=false;
	var tmpStr = "<select tabIndex='0' class='dropdowninput' rowIndex='"+row+"' name='" + columnDef.id + "'>";
	var optionStr= "";
	for( i in  data){
		v = data[i];
		if(v.value == "")
			continue;
		optionStr += "<option value='"+v.value+"'";
		if(value == v.value){
			dataAvlFlag = true;
			optionStr += " selected='selected'>"
		} else {
			optionStr +=">";
		}
	  optionStr += v.label + "</option>";
	}
	if(dataAvlFlag){
		tmpStr += "<option value=''></option>";
	} else {
		tmpStr += "<option value='' selected='selected'></option>";
	}
	tmpStr += optionStr;
	tmpStr += "</select>";
	return tmpStr;
  }

  function xenosDateFormatter(row, cell, value, columnDef, dataContext) {
	value = value || "";
	var markup = ""
				+ 	"<span>"
				+ 		"<input name=" + columnDef.id  + " class='dateinput hasDatepicker' style='width:80px; height:20px;' type='text' value='"+value+"' rowIndex='"+row+"'>"
				+		"<button class='ui-datepicker-trigger' type='button'>"
				+			"<img src='"+xenos.context.path+"/images/namrui/icon/calendarIco.png' alt='' title=''>"
				+		"</button>"
				+	"</span>";
	return markup;
  }

  function StlCompletionEditFormatter(row, cell, value, columnDef, dataContext) {
		var markup;
		if (value == null || value === "") {
	      markup = "";
	    }
	     /*if(typeof dataContext.detailHistoryPk=='undefined' && dataContext.settlementReferenceNo && ($.trim(dataContext['completionType']) == "") ){
	       markup = '<span>'+value+'</span>';
		}else if(typeof dataContext.detailHistoryPk!='undefined' && (typeof dataContext.selected == "undefined" || dataContext.selected == false )){
		
		    markup = '<span>'+value+'</span>';
		
		}else {*/
		var commandFormId = $("[name='commandFormId']").val();
		markup = ""
	        + "<span class='page-navigation-hyperlink' "
	        +       "settlementReferenceNo='" + value + "' "
	        +       "detailHistoryPk='" + dataContext.detailHistoryPk + "' "
		    +       "settlementInfoPk='" + dataContext.settlementInfoPk + "' "
			+		"rowIndex='"+row+"' completionType='"+dataContext.completionTp+ "' "
			+       "stlDate='"+dataContext.stlDate+"'>"
	        +   value
	        + "</span>"
		/*}*/
		return markup;
	  }

    function WithholdDateFormatter(row, cell, value, columnDef, dataContext){
        var markup;
        if(dataContext.settlementProhibitedType == "" || dataContext.settlementProhibitedType == null){
            markup = ""
                + 	"<span class='withhold' index='" + row + "' style='display:none' name='"+columnDef.field+"'>"
                + 		"<input class='dateinput hasDatepicker' style='width:100px; height:20px;' type='text' value='"+value+"' rowIndex='"+row+"'>"
                +		"<button class='ui-datepicker-trigger' type='button'>"
                +			"<img src='"+xenos.context.path+"/images/namrui/icon/calendarIco.png' alt='' title=''>"
                +		"</button>"
                +	"</span>";
        }else{
            markup = '<span id="withhold_'+row+'">' + value + '</span>';
        }
        return markup;
    }
	function WithholdReasonFormatter(row, cell, value, columnDef, dataContext) {
	    var markup;
		if(value == null){
		   value = '';
		}
        if(dataContext.settlementProhibitedType == "" || dataContext.settlementProhibitedType == null){
	     markup = ""
	        + 	"<span index='" + row + "' style='display:none'>"
	        + 		"<input type='text' readonly='readonly' name='" + columnDef.id + "' rowIndex='"+row+"'  value='" + xenos.utils.escapeHtml(value) + "' style='width:100%'  >"
	        +	"</span>";
		}else{
            markup = '<span id="withhold_'+row+'">' + xenos.utils.escapeHtml(value) + '</span>';
        }
	    return markup;
	  }
	  function WithholdTextFormatter(row, cell, value, columnDef, dataContext) {
		if(value == null || value === "") {
		  return "";
		}
		return "<span>"+ xenos.utils.escapeHtml(value) +"</span>";
	}
  function FinalizationUndoFormatter(row, cell, value, columnDef, dataContext) {
    var markup = ""
        + "<span class='undo-hyperlink undoIco' title='Undo' method='POST' "
		+ "requestData='pkForNettingStr=" + JSON.stringify(dataContext.nettedClientSettlementInfoPkList) + "' "
        +       "href='/stl/finalization/entry/undo?'>"
        + "</span>";

    return markup;
  }

  function NettedSettlementDetailFormatter(row, cell, value, columnDef, dataContext) {
    var markup = ""
        + "<span class='detail-view-hyperlink detailIco' title='Details' method='POST' "
		+ "requestData='pkForNettingStr=" + JSON.stringify(dataContext.nettedClientSettlementInfoPkList) + "' "
		+		"view='nettedSettlementDetailView' "
		+       "dialogTitle='" + xenos.title.nettedStlDetail + "'"
        +       "href='/stl/finalization/entry/detail?commandFormId=" + dataContext.commandFormId + "'>"
        + "</span>";

    return markup;
  }
  function SettlementFinalizationDetailViewFormater(row, cell, value, columnDef, dataContext) {
	  if (value == null || value === "") {
	     return "";
	  }
	  var markup = ""
        + "<span class='detail-view-hyperlink' "
	    +      "settlementinfopk='" + dataContext.settlementInfoPk + "'"
        +       "view='settlementDetailView' "
        +       "dialogTitle='[" + value + "] " + xenos.title.settlementInfo + "'"
        +       "href='/secure/stl/settlement/query/details/" + dataContext.settlementInfoPk + "?viewMode=Instruction'>"
        +   value
        + "</span>";

    return markup;
  }
  function WireInstructionAuthorizationDetailViewFormatter(row, cell, value, columnDef, dataContext) {
	  if (value == null || value === "") {
	     return "";
	  }
	  var markup = ""
        + "<span class='detail-view-hyperlink' "
	    +      "settlementinfopk='" + dataContext.settlementInfoPk + "'"
        +       "view='settlementDetailView' "
        +       "dialogTitle='[" + value + "] " + xenos.title.settlementInfo + "'"
        +       "href='/secure/stl/settlement/query/details/" + dataContext.settlementInfoPk + "?viewMode=Instruction&cancelPk=" + dataContext.cancelPk + "'>"
        +   value
        + "</span>";

    return markup;
  }
  function NettedSettlementDetailFormatterForCancel(row, cell, value, columnDef, dataContext) {
    var markup = ""
        + "<span class='detail-view-hyperlink detailIco' title='Details' "
		+		"view='nettedSettlementDetailView' "
		+       "dialogTitle='" + xenos.title.nettedStlDetail + "'"
        +       "href='/stl/finalization/cancel/detail/" + dataContext.settlementInfoPk +"'>"
        + "</span>";
    return markup;
  }
	//Formatter for Application Role Detail View
	function ApplicationRoleDetailViewFormater(row, cell, value, columnDef, dataContext) {
		if (value == null || value === "") {
			return "";
		}
		if(dataContext.applRolePk==""){
			return '<span>'+value+'</span>';
		} else {
			var markup = ""
			+ "<span class='detail-view-hyperlink' "
			+       "view='applicationRoleDetailView' "
			+       "applicationRoleName='" + value + "' "
			+       "applRolePk='" + dataContext.applRolePk + "'"
			+       "dialogTitle='[" + value + "] " + xenos.title.applroleDetail + "'"
			+       "href='/secure/ref/applicationrole/details/" + dataContext.applRolePk + "?popup=true" + "'>"
			+   value
			+ "</span>";
			return markup;
		}
	}

	function CustomerDetailViewFormatter(row, cell, value, columnDef, dataContext){
		if (value == null || value === "") {
			return "";
		}
		if(dataContext.customerPk==""){
			return '<span>'+value+'</span>';
		} else {
			var markup = ""
			+ "<span class='detail-view-hyperlink' "
			+       "view='customerDetailView' "
			+       "customerCode='" + value + "' "
			+       "customerPk='" + dataContext.customerPk + "'"
			+       "dialogTitle='[" + value + "] " + xenos.title.customerDetail + "'"
			+       "href='/secure/ref/customer/details/" + dataContext.customerPk + "?popup=true" + "'>"
			+   value
			+ "</span>";
			return markup;
		}
	}

  function StlInstructionRefNoVerNoFormatter(row, cell, value, columnDef, dataContext) {
//    if (value == null || value === "")
//      return "";

    var markup = ""
        + "<span class='detail-view-hyperlink' "
        +       "view='settlementInstructionView' "
        +       "settlementreferenceno='" + dataContext.settlementReferenceNo + "' "
        +       "settlementinfopk='" + dataContext.settlementInfoPk + "'"
        +       "dialogTitle='[" + dataContext.settlementReferenceNo + "] " + xenos.title.settlementInfo + "'"
        +       "href='/secure/stl/settlement/query/details/" + dataContext.settlementInfoPk + "?viewMode=Instruction'>"
        +   dataContext.settlementReferenceNo + '-' + dataContext.versionNo
        + "</span>";
    return markup;
  }

  function StlInstructionInxRefNoFormatter(row, cell, value, columnDef, dataContext) {
	if(dataContext.instructionRefNo == null || dataContext.instructionRefNo === ""){
		return "";
	}
    var markup = ""
        + "<span class='detail-view-hyperlink' "
        +       "view='swiftRawView' "
        +       "inxReferenceNo='" + dataContext.instructionRefNo + "'"
        +		"inxpk='" + dataContext.pk + "'"
        +       "viewMode='swiftRawView'"
        +       "dialogTitle='" + xenos.title.swiftFileViewer + "'"
        +       "method='POST'"
        +       "href='/secure/stl/instruction/query/rawDetails?pk=" + dataContext.instructionRefNo + "&popup=true'>"
        +   dataContext.instructionRefNo
        + "</span>";
    return markup;
  }

  function StlInstructionCxlRefNoFormatter(row, cell, value, columnDef, dataContext) {
    
	if(dataContext.cxlRefNo == null || dataContext.cxlRefNo === ""){
		return "";
	}
    var markup = ""
        + "<span class='detail-view-hyperlink' "
        +       "view='swiftRawView' "
        +       "inxReferenceNo='" + dataContext.cxlRefNo + "'"
        +       "viewMode='swiftRawView'"
        +       "dialogTitle='" + xenos.title.swiftFileViewer + "'"
        +       "method='POST'"
        +       "href='/secure/stl/instruction/query/rawDetails?pk=" + dataContext.cxlRefNo + "&popup=true'>"
        +   dataContext.cxlRefNo
        + "</span>";
    return markup;
  }

  function StlInstructionCpSsiInfoFormatter(row, cell, value, columnDef, dataContext) {
//    if (value == null || value === "")
//      return "";

    if (dataContext.dtcParticipantId != null || dataContext.dtcParticipantId != '')
      return "<span>" + dataContext.dtcParticipantIdDisp + "</span>";
    if (dataContext.contraId != null || dataContext.contraId != '')
      return "<span>" + dataContext.contraId + "</span>";

    return "<span>" + dataContext.cpSsiInternational + "</span>";
  }

  function StlInstructionFirmStlAcBrokerFormatter(row, cell, value, columnDef, dataContext) {
//    if (value == null || value === "")
//      return "";

    return "<span>" + dataContext.displayAccountNo + "(" + dataContext.brokerCode + ")</span>";
  }

  function StlInstructionTrxStatusFormatter(row, cell, value, columnDef, dataContext) {
	if (dataContext.status == 'CANCEL')
       return "<span>CANCEL</span>";

	if(dataContext.transmissionStatus == null || dataContext.transmissionStatus === "")
	    return "";
			
	return "<span>" + dataContext.transmissionStatus + "</span>";  
	    
	
 }
  function StlInstructionAcceptanceStatusFormatter(row, cell, value, columnDef, dataContext) {

    if (dataContext.status == 'NORMAL' && dataContext.transReqdForCxl == 'N')
        return "<span>(Marked)</span>";
		
    if(dataContext.acceptanceStatus == null || dataContext.acceptanceStatus === "")
	    return "";
		
    return "<span>" + dataContext.acceptanceStatus + "</span>";
  }

  function StlInstructionStatusFormatter(row, cell, value, columnDef, dataContext) {

    if (dataContext.csiStatus == 'CANCEL')
        return '<span class="cancel">CXL</span>';

    return "<span></span>";
  }
  function StlInstructionCxlAcceptanceStatusFormatter(row, cell, value, columnDef, dataContext) {
  
    if (dataContext.status == 'CANCEL') {
      if (dataContext.transReqdForCxl == 'Y') {
	    if(dataContext.cxlAcceptanceStatus == null)
		  return "";
		 else
         return "<span>" + dataContext.cxlAcceptanceStatus + "</span>";
      } else if (dataContext.transReqdForCxl == 'N') {
        if (dataContext.acceptanceStatus == 'NG')
          return "<span></span>";
        else
          return "<span>(Reset)</span>";
      } else
        return "<span>(Expired)</span>";
    } else
     return "<span></span>";
  }
  
  function StlInstructionSelectInputFormatter(row, cell, value, columnDef, dataContext) {
	  
		var options = columnDef.options;
		var data = options.data;
		
		var displayStyle;
		if(options.display){
			displayStyle = "display:block";
		}
		else{
			displayStyle = "display:none";
		}
		var v, dataAvlFlag=false;
		var tmpStr = "<select tabIndex='0' class='dropdowninput' style='"+displayStyle+"' rowIndex='"+row+"' name='" + columnDef.id + "'>";
		var optionStr= "";
		for( i in  data){
			v = data[i];
			if(v.value == "")
				continue;
			optionStr += "<option value='"+v.value+"'";
			if(value == v.value){
				dataAvlFlag = true;
				optionStr += " selected='selected'>"
			} else {
				optionStr +=">";
			}
		  optionStr += v.label + "</option>";
		}
		if(dataAvlFlag){
			tmpStr += "<option value=''></option>";
		} else {
			tmpStr += "<option value='' selected='selected'></option>";
		}
		tmpStr += optionStr;
		tmpStr += "</select>";
		return tmpStr;
	  }
  
  function StlInstructionTextInputFormatter(row, cell, value, columnDef, dataContext) {
	    value = value || "";
	    var markup = ""
	        + 	"<span index='" + row + "' style='display:none'>"
	        + 		"<input type='text' name='" + columnDef.id + "' rowIndex='"+row+"'  value='" + value + "' width='100px' readOnly = 'readOnly'  >"
	        +	"</span>";
	    return markup;
	  }
	  
	  function CheckBoxFromatter(row, cell, value, columnDef, dataContext) {
		
	   value = value || "";
	    var markup = ""
	        + 	"<span index='" + row + "'>"
	        + 		"<input type='checkbox' name='" + columnDef.id + "' rowIndex='"+row+"'  value='" + value + "' width='100px' >"
	        +	"</span>";
	    return markup;
	  }
	  
	function TextAndCheckboxFromatter(row, cell, value, columnDef, dataContext) {
		console.log(row);
		var options = columnDef.options || {};
		var textBoxOptions = options.textBox || {};
		var tbStyle = textBoxOptions.style || '';
		var tbDisabled = textBoxOptions.disabled ? "disabled='true'" : "";
		
		var checkBoxOptions = options.checkBox || {};
		var checkBoxId = columnDef.checkBoxId || "";
		var cbStyle = checkBoxOptions.style || '';
		var selectedByDefault = (dataContext[checkBoxId] && dataContext[checkBoxId] == 'Y') ? true : false;
		
	    value = value || "";
	    var markup = ""
	        + 		"<input type='text' name='" + columnDef.id + "[" + row + "]' rowIndex='"+row+"' value='" + value + "' ";
			if(tbStyle != ''){
				markup += " style='"+ tbStyle + "'";
			}
			if(tbDisabled){
				markup += "disabled='true'";
			}
			markup += " >";
			if(checkBoxId == ""){
				return markup;
			}else{
				markup += "<input type='checkbox' name='" + checkBoxId + "' rowIndex='"+row + "' ";
				if(cbStyle != ''){
					markup += " style='"+ cbStyle + "'";
				}
				if(selectedByDefault){
					markup += " value='Y' checked='checked'";
				}		
				markup += " value=''>";
				return markup;
			}
	    return markup;
	  }
	
	function TextAndPopupFormatter(row, cell, value, columnDef, dataContext) {
		value = value || "";
		var options = columnDef.options || {};
		var textBoxOptions = options.textBox || {};
		var popUpOptions = options.popUp || {};
			
		var textBoxStyleClass = textBoxOptions['styleClass'] || '';
		var textBoxDisabled = textBoxOptions['disabled'] || false;
		var textBoxWidth = columnDef.width - 35;
		
		var popUpDisabled = popUpOptions['disabled'] || false;
		var dialogCloseHandler = popUpOptions.dialogCloseHandler ? popUpOptions.dialogCloseHandler : function(){return {}}; 
	    var ctxArray = popUpOptions.ctx ? popUpOptions.ctx : [];
		var ctx = "";
		for (i = 0; i < ctxArray.length; i++) {
			var tempArr = ctxArray[i].replace(/'/g, "").split(":");
			ctx += tempArr[0] + "='" + tempArr[1] + "'";
		}

		var markup = "<input class='textBox " + textBoxStyleClass  + "' type='text' name='" + columnDef.id + "' rowIndex='"+row+"' value='" + value + "' "
					+ " style='width:" + textBoxWidth + "px;' ";
		
		if(textBoxDisabled){
			markup	+= " disabled='disabled' ";
		}
		markup 		+= ">";
		
		markup += "<div class='popupBtn'>"
			   +  "<input class='popupBtnIco' type='button' style='position:absolute;right:4px;' tgt='" + popUpOptions.tgt + "' "
			   +  "popType='" + popUpOptions.popType + "' "
			   +  "onDialogClose='" + dialogCloseHandler + "' "
			   +   ctx;
		if(popUpDisabled){
			markup	+= " disabled='disabled' ";
		}
		markup +=  " >";

		markup += "</div>";
		
		return markup;
	}
	  
	function xenosButtonFormatter(row, cell, value, columnDef, dataContext) {
		var options = columnDef.options || {};
		var popType = options.popUpType ? options.popUpType : '';
		var tgt = options.tgt ? options.tgt : '';
		var hiddenTgt = '';
		var hiddenTgtId = options.hiddenTgtId ? options.hiddenTgtId : [];
		for (i = 0; i < hiddenTgtId.length; i++) {
			if(i != 0){
				hiddenTgt += ",";
			}
			var tempArr = hiddenTgtId[i].replace(/'/g, "").split(":");
			hiddenTgt += (tempArr[0] + ":" + tempArr[1]);
		}
		
		var populateReqHandler = options.populateReqHandler ? options.populateReqHandler : function(){return {}}; 
		var dialogCloseHandler = options.dialogCloseHandler ? options.dialogCloseHandler : function(){return {}}; 
		var markup = "<input type='button' class='listBtn popupBtn inputBtnStyle' value='" + value +
					 "' popType='" + popType + 
					 "' tgt='" + tgt + 
					 "' hiddentgt='" + hiddenTgt + 
					 "' populatereq='" + populateReqHandler + 
					 "' onDialogClose='" + dialogCloseHandler +
					 "'/>";
		return markup;
	}

  function HolidayDetailViewFormatter(row, cell, value, columnDef, dataContext){
		if (value == null || value === "") {
			return "";
		}
		if(dataContext.calendarPk==""){
			return '<span>'+value+'</span>';
		} else {
			var markup = ""
			+ "<span class='detail-view-hyperlink' "
			+       "view='holidayDetailView' "
			+       "calenderId='" + value + "' "
			+       "calendarPk='" + dataContext.calendarPk + "'"
			+       "dialogTitle='[" + value + "] " + xenos.title.holidayDetail + "'"
			+       "href='/secure/ref/holiday/details/" + dataContext.calendarPk + "?popup=true&year=" + dataContext.year + "'>"
			+   value
			+ "</span>";
			return markup;
		}
	}

	function CashIODetailViewFormater(row, cell, value, columnDef, dataContext){
		if (value == null || value === "") {
			return "";
		}
		if(dataContext.camEntryPk==""){
				return '<span>'+value+'</span>';
			} else {
				var markup = ""
				+ "<span class='detail-view-hyperlink' "
				+       "dialog_Height='350'"
				+       "view='cashIODetailView' "
				+       "referenceNo='" + value + "' "
				+       "camEntryPk='" + dataContext.camEntryPk + "'"
				+       "dialogTitle='[" + value + "] " + xenos.title.cashIODetail + "'"
				+       "href='/secure/cam/cashiotransfer/details/" + dataContext.camEntryPk + "?popup=true" + "'>"
				+   value
				+ "</span>";
				return markup;
			}
	}
	function CashIODetailViewFormaterForAuth(row, cell, value, columnDef, dataContext){
		if(dataContext.actionPendingFor == 'CANCEL'){
	    	return "";
	    }else{
			if(dataContext.camEntryPk==""){
				return '<span>'+value+'</span>';
			} else {
				var markup = ""
				+ "<span class='detail-view-hyperlink detailIco' "
				+       "dialog_Height='350'"
				+       "view='cashIODetailView' "
				+       "referenceNo='" + value + "' "
				+       "camEntryPk='" + dataContext.camEntryPk + "'"
				+       "dialogTitle='[" + value + "] " + xenos.title.cashIODetail + "'"
				+       "href='/secure/cam/cashio/authorization/query/details/" + dataContext.camEntryPk + "?popup=true" +"&actionDone="+dataContext.actionPendingFor+  "'>"
				+ "</span>";
				return markup;
			}
		}
	}

	function SsiDetailViewFormater(row, cell, value, columnDef, dataContext) {
        //  Prepare the markup/ dynamically appended HTML tag
		var markup = "";
		if(dataContext.standingRulePk=="" || dataContext.standingRulePk== null){
			return markup;
		}
		var commandFormId = $('#queryResultForm').find('[name=commandFormId]').val();
    	var	url= "/secure/ref/cpssi/details/" + dataContext.standingRulePk + "?&popup=true" + "'>";
        markup  =  "<span class='detail-view-hyperlink popupIconBtn' "
        +       "view='cpSsiDetailView' "
        +       "dialogTitle='" + xenos.title.ssiView + "' "
        +       "title='" + columnDef.name + "' "
        +       "href='" + url
        +   "j"
        + "</span>";

        return markup;
    }
	
	function DrvCloseoutDetailsViewFormatter(row, cell, value, columnDef, dataContext) {
		// Prepare the markup/ dynamically appended HTML tag
		var markup = "";
		if (dataContext.contractPk == "" || dataContext.contractPk == null) {
			return markup;
		}
		if (dataContext.totalClosedOutQty <= 0){
			return markup;
		}
		var url = "/secure/drv/closeout/details/" + dataContext.contractPk + "?actionType=CLOSEOUT&popup=true" + "'>";
		markup = "<span class='detail-view-hyperlink popupIconBtn' "
				+ "view='drvCloseoutDetailView' " + "dialogTitle='"
				+ xenos.title.drvCloseoutDetails + "' "
				+ "title='View CloseOut Detail' " + "' " + "href='" + url + ""
				+ "</span>";
		return markup;
	}
	
	function SsiDtlViewFormater(row, cell, value, columnDef, dataContext) {
        //  Prepare the markup/ dynamically appended HTML tag
        var markup = ""
        + "<span class='detail-view-hyperlink popupIconBtn' "
        +       "view='ssiDetailView' "
        +       "dialogTitle='" + xenos.title.ssiView + "' "
        +       "title='" + columnDef.name + "' "
        +       "href='/secure/ref/ssi/details/" + dataContext.cpSsiPk + "?popup=true" + "'>"
        +   "j"
        + "</span>";

        return markup;
    }
	
	function SsiAuthDetailViewFormater(row, cell, value, columnDef, dataContext) {
        //  Prepare the markup/ dynamically appended HTML tag
        var markup = ""
        + "<span class='detail-view-hyperlink popupIconBtn' "
        +       "view='ssiAuthorizationDetailView' "
        +       "dialogTitle='" + xenos.title.ssiView + "' "
        +       "title='" + columnDef.name + "' "
        +       "href='/secure/ref/ssi/viewPendingAuth/" + dataContext.standingRulePk + "/" + dataContext.actionType + "/" + dataContext.authorizationStatus + "?popup=true" + "'>"
        +   "j"
        + "</span>";

        return markup;
    }

	/**
	 * Formater to view the detail of NCM Depository Adjustment Query
	 */
	function DepositoryAdjustmentFormater(row, cell, value, columnDef, dataContext) {
	  if (value == null || value === "") {
	     return "";
	  }

	  var markup = ""
        + "<span class='detail-view-hyperlink' "
        +       "dialog_Height='339'"
        +       "view='depositoryAdjustmentQueryDetailView' "
        +       "ncmEntryPk='" + dataContext.ncmEntryPk + "'"
        +       "dialogTitle='[" + value + "] " + xenos.title.depositoryAdjustmentDetail + "'"
        +       "href='/secure/ncm/depadjustment/details"+ "/" + dataContext.ncmEntryPk + "'>"
        +   value
        + "</span>";
    return markup;
  }
	
	function NcmAdjustmentQueryDetailViewFormatter(row, cell, value, columnDef, dataContext){
		
		if (value == null || value === "") {
			return "";
		}
		if(dataContext.ncmEntryPk==""){
			return '<span>'+value+'</span>';
		} else {
			var markup = ""
			+ "<span class='detail-view-hyperlink' "
			+       "dialog_Height='350'"
			+       "view='ncmAdjustmentQueryDetailView' "
			+       "referenceNo='" + value + "' "
			+       "ncmEntryPk='" + dataContext.ncmEntryPk + "'"
			+       "dialogTitle='[" + value + "] " + xenos.title.ncmAdjustmentQueryDetail + "'"
			+       "href='/secure/ncm/adjustment/details/" + dataContext.ncmEntryPk + "'>"
			+   value
			+ "</span>";
			return markup;
		}	
	}
	
		
	//Formatter for SSI auth detail view.
	 function SsiAuthFormatter(row, cell, value, columnDef, dataContext) {
		var mkp = "";
			if(dataContext.state=='NEW'){
				mkp = '<img src=' + xenos.context.path + '/images/xenos/icon/add-ico.png>';
			}else if(dataContext.state=='MODIFIED'){
				mkp = '<img src=' + xenos.context.path + '/images/xenos/icon/accnt-edit-ico.png>';
			}else if(dataContext.state=='DELETED'){
				mkp = '<img src=' + xenos.context.path + '/images/xenos/icon/trash-ico-blue.png>';
			}else{}

			return mkp;
	}
	
	 	/**
		 * Formater to view the detail of SRS Voucher Query
		 */
		function SrsVoucherFormater(row, cell, value, columnDef, dataContext) {
		  if (value == null || value === "") {
		     return "";
		  }
		  var markup = ""
	        + "<span class='detail-view-hyperlink' "
	        +       "dialog_Height='350'"
	        +       "view='srsVoucherEntryDetail' "
	        +       "voucherPk='" + dataContext.voucherPk + "'"
	        +       "dialogTitle='[" + value + "] " + xenos.title.voucherQueryDetail + "'"
	        +       "href='/secure/srs/voucher/details" + "/" + dataContext.voucherPk +"?popup=true" + "'>"
	        +   value
	        + "</span>";
	    return markup;
	  }
		
		function ProjectedBalanceDetailViewFormater(row, cell, value, columnDef, dataContext) {
			 if (value == null || value === "") {
		     return "";
		  }
		 
			 if(dataContext.formattedActualBalance==""){
			       return '<span>'+value+'</span>';
		     }else{
			    var markup = ""
			        + "<span class='detail-view-hyperlink' "
			        +       "view='accountDetailView' "
			        +       "formattedActualBalance='" + value + "' "
			        +       "formattedActualBalance='" + dataContext.formattedActualBalance + "'"
			        +       "dialogTitle=' Projected Balance Detail by Bank Account '"
			        +       "href='/secure/ncm/cashmanagement/query/balanceDetails/" + dataContext.accountPk +"/"+ dataContext.accountName +"/"+ dataContext.bankPk +"/"+ dataContext.bankCode +"/"+ dataContext.currency +"/" + "projected_balance" +  "?popup=true"+ "'>"

			        +   value
			        + "</span>";
			    return markup;
			}
	   }
	   
	   function ActualBalanceDetailViewFormater(row, cell, value, columnDef, dataContext) {
		  if (value == null || value === "") {
		     return "";
		  }
		 
			 if(dataContext.formattedActualBalance==""){
			       return '<span>'+value+'</span>';
		     }else{
			    var markup = ""
			        + "<span class='detail-view-hyperlink' "
			        +       "view='accountDetailView' "
			        +       "formattedActualBalance='" + value + "' "
			        +       "formattedActualBalance='" + dataContext.formattedActualBalance + "'"
			        +       "dialogTitle='Actual Balance Detail by Bank Account '"
			        +       "href='/secure/ncm/cashmanagement/query/balanceDetails/" + dataContext.accountPk +"/"+ dataContext.accountName +"/"+ dataContext.bankPk +"/"+ dataContext.bankCode +"/"+ dataContext.currency +"/" + "actual_balance" + "?popup=true" + "'>"
					+   value
			        + "</span>";
			    return markup;
			}
	   }
	   
	   function FailBalanceDetailViewFormater(row, cell, value, columnDef, dataContext) {
			 if (value == null || value === "") {
		     return "";
		  }
		 
			 if(dataContext.formattedActualBalance==""){
			       return '<span>'+value+'</span>';
		     }else{
			    var markup = ""
			        + "<span class='detail-view-hyperlink' "
			        +       "view='accountDetailView' "
			        +       "formattedActualBalance='" + value + "' "
			        +       "formattedActualBalance='" + dataContext.formattedActualBalance + "'"
			        +       "dialogTitle='Fail Balance Detail by Bank Account'"
			        +       "href='/secure/ncm/cashmanagement/query/balanceDetails/" + dataContext.accountPk +"/"+ dataContext.accountName +"/"+ dataContext.bankPk +"/"+ dataContext.bankCode +"/"+ dataContext.currency +"/" + "fail_balance" + "?popup=true" + "'>"

			        +   value
			        + "</span>";
			    return markup;
			}
	   }
	   
	   function UnmatchBalanceDetailViewFormater(row, cell, value, columnDef, dataContext) {
			 if (value == null || value === "") {
		     return "";
		  }
		
			 if(dataContext.formattedActualBalance==""){
			       return '<span>'+value+'</span>';
		     }else{
			    var markup = ""
			        + "<span class='detail-view-hyperlink' "
			        +       "view='Actual Balance Detail by Bank Account' "
			        +       "formattedActualBalance='" + value + "' "
			        +       "formattedActualBalance='" + dataContext.formattedActualBalance + "'"
			        +       "dialogTitle='Unmatched Balance Detail by Bank Account'"
			        +       "href='/secure/ncm/cashmanagement/query/balanceDetails/" + dataContext.accountPk +"/"+ dataContext.accountName +"/"+ dataContext.bankPk +"/"+ dataContext.bankCode +"/"+ dataContext.currency +"/" + "unmatched_balance" + "?popup=true" + "'>"

			        +   value
			        + "</span>";
			    return markup;
			}
	   }
	   
	   // Market Price Detail View Formatter
	   function MarketPriceDetailViewFormater(row, cell, value, columnDef, dataContext) {
		   if(dataContext.marketPricePk==""){
				return '<span>'+value+'</span>';
			} else {
				var markup = ""
					+ "<span class='detail-view-hyperlink popupIconBtn' "
					+       "view='marketPriceDetailView' "
					+       "dialogTitle='" + xenos.title.marketPriceDetailView + "' "
					+       "title='" + columnDef.name + "' "
					+       "href='/secure/ref/marketprice/details/" + dataContext.marketPricePk + "?popup=true" + "'>"
					+   "j"
					+ "</span>";

				return markup;
			}
		}
 
		//SRSMovement Detail view formatter
		function MovementDetailsFormatter(row, cell, value, columnDef, dataContext) {
		var UIDialog = $('.ui-dialog.topMost');
		var commandFormId="";
		if(typeof UIDialog =='undefined' || UIDialog.length == 0){ //Normal Query Result Screen
		  commandFormId = $('#queryResultForm').find('[name=commandFormId]').val();
		} else { //Dialog Query Result Screen
		  commandFormId = UIDialog.find('#queryResultForm').find('[name=commandFormId]').val();
		}		
		if (value == null || value === "") {
			return "";
		}
		if(dataContext.ncmEntryPk==""){
			return '<span>'+value+'</span>';
		} else {
			var markup = ""
			+ "<span class='detail-view-hyperlink' "
			+       "dialog_Height='350'"
			+       "view='srsTxnMovementDetailView' "
			+       "referenceNo='" + value + "' "
			+       "ncmEntryPk='" + dataContext.transactionPk + "'"
			+       "dialogTitle='[" + value + "] " + xenos.title.movementDetail + "'"
			+       "href='/secure/srs/transaction/query/details/" + dataContext.transactionPk + "?commandFormId="+commandFormId+"'>"
			+   value
			+ "</span>";
			return markup;
		}	
	}

		//Formatter to define consolidate action. Id is basically the pk column.
	function FininstAuthFormatter(row, cell, value, columnDef, dataContext) {
		var mkp = "";
		if(dataContext.stateOfBean=='NEW'){
			mkp = '<img src=' + xenos.context.path + '/images/xenos/icon/add-ico.png>';
		}else if(dataContext.stateOfBean=='MODIFIED'){
			mkp = '<img src=' + xenos.context.path + '/images/xenos/icon/accnt-edit-ico.png>';
		}else if(dataContext.stateOfBean=='DELETED'){
			mkp = '<img src=' + xenos.context.path + '/images/xenos/icon/trash-ico-blue.png>';
		}else{}

		return mkp;
	}
	
	function FininstAuthDetailViewFormater(row, cell, value, columnDef, dataContext) {
        //  Prepare the markup/ dynamically appended HTML tag
		if (value == null || value === "") {
			return "";
		}
		if(dataContext.finInstRolePk==""){
			return '<span>'+value+'</span>';
		}else{	
		   var markup = ""
			+ "<span class='detail-view-hyperlink' "
			+       "view='fininstAuthorizationDetailView' "
			+       "finInstRoleCode='" + value + "' "
			+       "finInstRolePk='" + dataContext.finInstRolePk + "'"
			+       "dialogTitle='[" + value + "] " + xenos.title.fininstDetail + "'"
			+       "href='/secure/ref/fininst/viewPendingAuth/" + dataContext.finInstRolePk + "/" + dataContext.actionType + "/" + dataContext.authorizationStatus + "?popup=true" + "'>"
			+   value
			+ "</span>";

			return markup;
		}	
    }
    
    //Ledger Code Detail view formatter
		function LedgerCodeDetailsFormatter(row, cell, value, columnDef, dataContext) {
			var UIDialog = $('.ui-dialog.topMost');
			var commandFormId="";
			if(typeof UIDialog =='undefined' || UIDialog.length == 0){ //Normal Query Result Screen
				commandFormId = $('#queryResultForm').find('[name=commandFormId]').val();
			} else { //Dialog Query Result Screen
				commandFormId = UIDialog.find('#queryResultForm').find('[name=commandFormId]').val();
			}		
			if (value == null || value === "") {
				return "";
			}
			if(dataContext.ledgerPk==""){
				return '<span>'+value+'</span>';
			} else {
				var markupValue = value.substr(0,value.indexOf(":"));
				var noMarkupValue = value.substr(value.indexOf(":"));
				var markup = ""
				+ "<span class='detail-view-hyperlink' "
				+       "dialog_Height='350'"
				+       "view='SrsBalanceQuerySummaryView' "
				+       "ledgerPk='" + dataContext.ledgerPk + "'"
				+       "dialogTitle='[" + markupValue + "] " + xenos.title.ledgerQueryDetail + "'"
				+       "href='/secure/srs/balance/query/details/" + dataContext.ledgerPk + "?commandFormId="+commandFormId+"'>"
				+   markupValue
				+ "</span>"
				+ "<span>"
				+   noMarkupValue
				+ "</span>"
				return markup;
			}	
		}
		
		//Ledger Category Bold formatter
		function LedgerCategoryForSrsBalance(row, cell, value, columnDef, dataContext) {
			if (value == null || value === "") {
				return "";
			}
			if(dataContext.header){
				return '<span style="font-weight:bold">'+value+'</span>';
			}
		
		   return '<span>'+value+'</span>';
		}
    
    function ReceiveNoticeOutgoingDetailViewFormatter(row, cell, value, columnDef, dataContext) {
    	var markup = "";
		  if (value == null || value === "") {
		    return "";
		  }
		  else if(dataContext.settlementInfoPk=='' || dataContext.settlementInfoPk==null){
		  		markup = '<span>'+value+'</span>';
		  }
		  else{
			  markup = "<span><input type='button' class='popupIconBtnGrid detail-view-hyperlink' "
		        +       "view='settlementDetailView' "
		        +       "settlementreferenceno='" + value + "' "
		        +       "settlementinfopk='" + dataContext.settlementInfoPk + "' "
		        +       "dialogTitle='[" + value + "] " + xenos.title.settlementInfo + "' "
		        +       "href='/secure/stl/settlement/query/stlDetails/" + dataContext.settlementInfoPk +"?pendingSubmission=" + dataContext.pendingSubmission 
		        +               "&viewType=" + dataContext.viewType + "&clientSettlementInfoPk=" + dataContext.clientSettlementInfoPk 
		        +               "&viewMode=Instruction&nettedFlag=true&diffEnableFlag=" + columnDef.isForAuth +"'>"
		        +       "</input></span>";
	        }
	    return markup;
	  }

    function ReceiveNoticeIncomingDetailViewFormatter(row, cell, value, columnDef, dataContext) {
    	
    	var markup = "";
		  if (value == null || value === "") {
		    return "";
		  }
		  else if(dataContext.settlementInfoPk=='' || dataContext.settlementInfoPk==null){
		  		markup = '<span>'+value+'</span>';
		  }
		  else{
			  markup = "<span><input type='button' class='popupIconBtnGrid detail-view-hyperlink' "
		        +       "view='recvdNoticeDetailView' "
		        +       "settlementinfopk='" + dataContext.settlementInfoPk + "' "
		        +       "dialogTitle='[" + value + "] " + xenos.title.recvdNoticeIncomingDetail + "' "
		        +       "href='/secure/stl/receivednotice/query/details/" + dataContext.receivedCompNoticeInfoPk +"?pendingSubmission=" + dataContext.pendingSubmission 
		        +               "&viewType=" + dataContext.viewType
		        +               "&viewMode=Instruction&nettedFlag=true&diffEnableFlag=" + columnDef.isForAuth +"'>"
		        +       "</input></span>";
	        }
	    return markup;
    }

    // Local Account ID Confirmation Rule Detail View Formatter
    function LocalAcIdConfRuleDetailViewFormater(row, cell, value, columnDef, dataContext) {
        if (value == null || value === "") {
          return "";
        }
       if(dataContext.idConfRulePk==""){
           return '<span>'+value+'</span>';
    	  }else{
        var markup = ""
            + "<span class='detail-view-hyperlink' "
            +       "view='localAcIdConfRuleDetails' "
            +       "accountNo='" + value + "' "
            +       "idConfRulePk='" + dataContext.idConfRulePk + "'"
            +       "dialogTitle='[" + value + "] " + xenos.title.localAccountIDConfRuleDetail + "'"
            +       "href='/secure/ref/localacidconfrule/details/" + dataContext.idConfRulePk + "?popup=true" + "'>"
            +   value
            + "</span>";
        return markup;
    	}
      }
    
 // Local Account ID Confirmation Rule Authorization View Formatter
    function LocalAcIdConfRuleAuthViewFormater(row, cell, value, columnDef, dataContext) {
       if(dataContext.idConfRulePk==""){
           return '<span>'+value+'</span>';
    	  }else{
			var markup = ""
				+ "<span class='detail-view-hyperlink' "
				+       "view='localAcIdConfRuleDetails' "
				+       "dialogTitle='[" + value + "] " + xenos.title.localAccountIDConfRuleDetail + "'"
				+       "title='" + columnDef.name + "' "
				+       "idConfRulePk ='" +dataContext.idConfRulePk+"'"
				+       "href='/secure/ref/localacidconfrule/viewPendingAuth/" + dataContext.idConfRulePk + "?popup=true" + "'>"
				+   value
				+ "</span>";
			return markup;
    	}
      }
	  
	function OwnSsiDetailViewFormater(row, cell, value, columnDef, dataContext) {
        //  Prepare the markup/ dynamically appended HTML tag
        var markup = ""
        + "<span class='detail-view-hyperlink popupIconBtn' "
		+       "dialog_Height='350'"
        +       "view='ownSsiDetailView' "
        +       "dialogTitle='" + xenos.title.ownSsiView + "' "
        +       "title='" + columnDef.name + "' "
        +       "href='/secure/ref/ownStlStanding/details/" + dataContext.ownSettleStandingRulePk + "?popup=true" + "'>"
        +   "j"
        + "</span>";

        return markup;
    }
	
	/* 	General View Formatter. Since we have so many detail views in our application, if we create a dedicated formatter then number of
	 	formatter will growing up. To magage it to single following formatter can be used and it is expected the proper configurations 
	 	should be passed through column definition. Depending upon the colun definiton mark-up will be generated.*/
	function DetailViewFormater(row, cell, value, columnDef, dataContext) {
		var option = columnDef.option || {};
		var popupIconReqrd = (option.popupIcon || false);
		var detailViewRequired = true;
		if($.isFunction(option.detailViewRequired)){
			detailViewRequired = option.detailViewRequired(columnDef, dataContext);
		}		
		if((!popupIconReqrd && $.trim(value)==="") || !detailViewRequired){
			return "";
		}
		var extraPathVariableStr = "";
		var extraQueryString ="";
		var methodType = option.methodType ? option.methodType : "";
		var requestData = function(){return {}}; 
		var commandFormIdRequired = (option.hasOwnProperty('commandFormIdRequired') && (option['commandFormIdRequired']==true));
        //  Prepare the markup/ dynamically appended HTML tag
        var markup = "<span class='detail-view-hyperlink " + (popupIconReqrd? "popupIconBtn" : "") + "' ";
		if(option.hasOwnProperty('height')){
			markup += "dialog_Height='"+ (option.height) + "'";
		}
		if(option.hasOwnProperty('width')){
			markup += "dialog_Width='"+ (option.width) + "'";
		}
		var pathVarableArray = option.extraPathVariablesInOrder || [];
		
		$.each(pathVarableArray, function(index, variable){
		  extraPathVariableStr += "/" + $.trim(dataContext[variable]);
		});
		
		if($.isFunction(option.queryString)){
			extraQueryString = option.queryString(columnDef, dataContext);
		}
		if($.isFunction(option.requestData)){
			requestData = option.requestData(columnDef, dataContext);
		}
		markup += "view='"+(option.view || "")+"' ";
		markup +="dialogTitle=' ";
		var dialogTitleValueReqd = ((typeof option.dialogTitleValueReqd == 'undefined') ? true : option.dialogTitleValueReqd);
		var dialogTitleValue = ($.trim(dataContext[option.dialogTitleValue]) || value);
		if(!popupIconReqrd && dialogTitleValueReqd){
			markup +="[" + dialogTitleValue + "] ";
		}
		markup += (option.dialogTitle || "") + "' ";
		if(popupIconReqrd){
			markup += "title='" + columnDef.name + "' ";
		}
        if($.trim(methodType) != ""){
			markup += " method='" + methodType + "'";
			markup += " requestData='" + requestData + "'";
		}
	    markup += " href='"+ option.url.replace('{rowIndex}',row) + $.trim(dataContext[option.pkFieldName]) + 
	                                                               $.trim(extraPathVariableStr) + "?popup=true" + 
	                                                               (commandFormIdRequired ? "&commandFormId="+dataContext['commandFormId'] : "") +
	                                                               $.trim(extraQueryString)+
	                                                               "'>"
        +       (popupIconReqrd ? "j" : value)
        + "</span>";
        return markup;
    }
	
    //  Formatter to define consolidate action. Id is basically the pk column.
    function AppRoleAuthFormatter(row, cell, value, columnDef, dataContext) {
        var mkp = "";
        if (dataContext.stateOfBean == 'NEW') {
            mkp = '<img src=' + xenos.context.path + '/images/xenos/icon/add-ico.png>';
        } else if (dataContext.stateOfBean == 'MODIFIED') {
            mkp = '<img src=' + xenos.context.path + '/images/xenos/icon/accnt-edit-ico.png>';
        } else if (dataContext.stateOfBean == 'DELETED') {
            mkp = '<img src=' + xenos.context.path + '/images/xenos/icon/trash-ico-blue.png>';
        } else {
            //  Do nothing
        }

        return mkp;
    }

    function AppRoleAuthDetailViewFormater(row, cell, value, columnDef, dataContext) {
        //  Prepare the markup/ dynamically appended HTML tag
        if (value == null || value === "") {
            return "";
        }
        if (dataContext.applRolePk == "") {
            return '<span>' + value + '</span>';
        } else {

            var markup = ""
                    + "<span class='detail-view-hyperlink' "
                    + "view='appRoleAuthorizationDetailView' "
                    + "applicationRoleName='" + value + "' "
                    + "applRolePk='" + dataContext.applRolePk + "' "
                    + "dialogTitle='[" + value + "] " + xenos.title.applroleDetail + "'"
                    + "href='/secure/ref/approle/viewPendingAuth/" + dataContext.applRolePk + "/"+dataContext.actionType+"/"+dataContext.authorizationStatus+"?popup=true" + "'>"
                    + value
                    + "</span>";

            return markup;
        }
    }
    
    // Market Price Authorization Detail View Formatter
	   function MarketPriceAuthDetailViewFormater(row, cell, value, columnDef, dataContext) {
		   if(dataContext.marketPricePk==""){
				return '<span>'+value+'</span>';
			} else {
				var markup = ""
					+ "<span class='detail-view-hyperlink popupIconBtn' "
					+       "view='marketPriceDetailView' "
					+       "dialogTitle='" + xenos.title.marketPriceDetailView + "' "
					+       "title='" + columnDef.name + "' "
					+       "marketPricePk ='" +dataContext.marketPricePk+"'"
					+       "href='/secure/ref/marketprice/viewPendingAuth/" + dataContext.marketPricePk + "?popup=true" + "'>"
					+   "j"
					+ "</span>";

				return markup;
			}
		}

	   //Pair-Off reason entry edit view formatter
	   function PairOffQueryEditFormater(row, cell, value, columnDef, dataContext) {
		    if (value == null || value === "" || dataContext.nettingGroup == null) {
		      return "";
		    }
			
		    var markup = "<span class='pair-off-hyperlink popupIconBtn' rowIndex='"+row+"' settlementInfoPk='" + JSON.stringify(dataContext.settlementInfoPk) + "'>Y</span>";
		    return markup;
		  }
	   
	   function PairOffCancelEditFormater(row, cell, value, columnDef, dataContext) {
		    if (value == null || value === "") {
		      return "";
		    }
			
		    var markup = "<span class='pair-off-hyperlink popupIconBtn' rowIndex='"+row+"' settlementInfoPk='" + JSON.stringify(dataContext.settlementInfoPk) + "'>Y</span>";
		    return markup;
		  }
		  
        function TrdSendConfReasonViewFormatter(row, cell, value, columnDef, dataContext) {
			if(dataContext.historyPk==""){
				return '<span>'+Reason+'</span>';
			}else{
				var markup = ""
						+ "<span class='detail-view-hyperlink' "
						+    "view='tradeSentConfReasonView' "
						+    "style='font-weight:bold'"
						+    "dialogTitle='[" + dataContext.historyReferenceNo + "] Reason Details'"
                        +    "href='/trd/conf/sent/query/details/" + dataContext.historyPk + "/" + dataContext.historyReferenceNo + "?popup=true" + "'>"
						+    'Reason'
						+ "</span>";
				return markup;
	        }
        }



		
	function MarketDetailViewFormatter(row, cell, value, columnDef, dataContext) {
		if (value == null || value === "") {
		  return "";
		}

		var markup = ""
			+ "<span class='detail-view-hyperlink' "
			+       "view='finInstDetailView' "
			+       "roleCode='" + value + "' "
			+       "marketPk='" + dataContext.marketPk + "'"
			+       "dialogTitle='[" + value + "] " + xenos.title.fininstDetail + "'"
			+       "href='/secure/ref/fininst/details/" + dataContext.marketPk + "?popup=true" + "'>"
			+   value
			+ "</span>";
		return markup;
	}	
  
    function CPCodeDetailViewFormatter(row, cell, value, columnDef, dataContext) {
		if (value == null || value == "") {
		    return "";
		}
		
		if(dataContext.customerPk=="" && dataContext.brokerPk==""){
		    return '<span>'+value+'</span>';
		}else if((dataContext.customerPk!=null || dataContext.customerPk!="") && (dataContext.brokerPk=="" || dataContext.brokerPk==null)){
			var markup = ""
			+ "<span class='detail-view-hyperlink' "
			+       "view='customerDetailView' "
			+       "customerCode='" + value + "' "
			+       "customerPk='" + dataContext.customerPk + "'"
			+       "dialogTitle='[" + value + "] " + xenos.title.customerDetail + "'"
			+       "href='/secure/ref/customer/details/" + dataContext.customerPk + "?popup=true" + "'>"
			+   value
			+ "</span>";
			return markup;
		}else if((dataContext.customerPk==null || dataContext.customerPk== "") && (dataContext.brokerPk!=null || dataContext.brokerPk!="")){
			var markup = ""
			+ "<span class='detail-view-hyperlink' "
			+       "view='finInstDetailView' "
			+       "roleCode='" + value + "' "
			+       "brokerPk='" + dataContext.brokerPk + "'"
			+       "dialogTitle='[" + value + "] " + xenos.title.fininstDetail + "'"
			+       "href='/secure/ref/fininst/details/" + dataContext.brokerPk + "?popup=true" + "'>"
			+   value
			+ "</span>";
			return markup;
		}
	}
	
	function InventoryAccountDetailViewFormater(row, cell, value, columnDef, dataContext) {
		if (value == null || value === "") {
		  return "";
		}
	    if(dataContext.inventoryAccountPk==""){
		   return '<span>'+value+'</span>';
		}else{
			var markup = ""
				+ "<span class='detail-view-hyperlink' "
				+       "view='accountDetailView' "
				+       "accountno='" + value + "' "
				+       "inventoryAccountPk='" + dataContext.inventoryAccountPk + "'"
				+       "dialogTitle='[" + value + "] " + xenos.title.accountDetail + "'"
				+       "href='/secure/ref/account/details/" + dataContext.inventoryAccountPk + "?popup=true" + "'>"

				+   value
				+ "</span>";
			return markup;
		}
    }
	
	function OurBankDetailViewFormater(row, cell, value, columnDef, dataContext) {
		if (value == null || value === "") {
		  return "";
		}

		var markup = ""
			+ "<span class='detail-view-hyperlink' "
			+       "view='finInstDetailView' "
			+       "roleCode='" + value + "' "
			+       "ourBankPk='" + dataContext.ourBankPk + "'"
			+       "dialogTitle='[" + value + "] " + xenos.title.fininstDetail + "'"
			+       "href='/secure/ref/fininst/details/" + dataContext.ourBankPk + "?popup=true" + "'>"
			+   value
			+ "</span>";
		return markup;
	}
	
	function OurStlAccountDetailViewFormatter(row, cell, value, columnDef, dataContext) {
		if (value == null || value === "") {
		  return "";
		}
	    if(dataContext.ourSettleAccountPk==""){
		   return '<span>'+value+'</span>';
		}else{
			var markup = ""
				+ "<span class='detail-view-hyperlink' "
				+       "view='accountDetailView' "
				+       "accountno='" + value + "' "
				+       "ourSettleAccountPk='" + dataContext.ourSettleAccountPk + "'"
				+       "dialogTitle='[" + value + "] " + xenos.title.accountDetail + "'"
				+       "href='/secure/ref/account/details/" + dataContext.ourSettleAccountPk + "?popup=true" + "'>"

				+   value
				+ "</span>";
			return markup;
		}
    }
    
    function CustodianBalanceNameFormatter(row, cell, value, columnDef, dataContext) {
        //  Prepare the markup/ dynamically appended HTML tag
		if (value == null || value === "") {
			return "";
		}
		if(dataContext.boldFlag){
			return '<span style="font-weight:bold">'+value+'</span>';
		}
		return '<span>'+value+'</span>';
	}
	
	function StlCcyDetailViewFormater(row, cell, value, columnDef, dataContext) {
		if (value == null || value === "") {
		  return "";
		}
		if(dataContext.settlementCcyPk==""){
		   return '<span>'+value+'</span>';
		} else {
			var markup = ""
				+ "<span class='detail-view-hyperlink' "
				+       "view='instrumentDetailView' "
				+       "instrumentCode='" + value + "' "
				+       "settlementCcyPk='" + dataContext.settlementCcyPk + "'"
				+       "dialogTitle='[" + value + "] " + xenos.title.instrumentDetail + "'"
				+       "href='/secure/ref/instrument/details/" + dataContext.settlementCcyPk + "?popup=true" + "'>"
				+   value
				+ "</span>";
			return markup;
		}
	}
	
	// RAD Notice Detail View Formatter
    function RadNoticeDetailViewFormatter(row, cell, value, columnDef, dataContext) {
       if(row<0){
           return '<span></span>';
    	  }else{
        var markup = ""
					+ "<span class='detail-view-hyperlink popupIconBtn' "
					+       "view='viewRadNoticeDetails' "
					+       "dialogTitle='" + xenos.title.radNoticeDetailView + "' "
					+       "title='" + columnDef.name + "' "
					+       "href='/secure/stl/radnotice/query/details/" + row + "?popup=true&commandFormId="+$('[name=commandFormId]').val()+ "'>"
					+   "j"
					+ "</span>";

				return markup;
    	}
      }
      
      function EmployeeAuthDetailViewFormater(row, cell, value, columnDef, dataContext) {
	    var result
	    value = value || "";
		href= "href='/secure/ref/emp/query/details?actionType=view&employeePk=" + dataContext.employeePk + "&actionTaken="+dataContext.actionType+"&authOption="+dataContext.authorizationStatus+"'>";
		switch(value){
			case "SYSTEM" :
				result =  "<span>"+ value +"</span>";
				break;
			default :
				result = ""
            + "<span class='detail-view-hyperlink' "
            +       "view=employeeDetailView userid='" + value + "' "
            +       "employeePk='" + dataContext.employeePk + "' "
            +       "dialogTitle='[" + value + "] " + xenos.title.employeeDetails + "' "
            +   href
            +   value
            + "</span>";
		}
		return result;
  }
  
     // Own SSI Authorization Detail view formatter
	 function OwnSsiAuthDetailViewFormater(row, cell, value, columnDef, dataContext) {
		//  Prepare the markup/ dynamically appended HTML tag
        var markup = ""
        + "<span class='detail-view-hyperlink popupIconBtn' "
        +       "view='ownSsiAuthorizationDetailView' "
        +       "dialogTitle='" + xenos.title.ownSsiView + "' "
        +       "title='" + columnDef.name + "' "
        +       "href='/secure/ref/ownStlStanding/viewPendingAuth/" + dataContext.ownSettleStandingRulePk + "?popup=true" + "'>"
        +   "j"
        + "</span>";

        return markup;
		
	  } 
	  
	function GroupDetailAuthViewFormater(row, cell, value, columnDef, dataContext) {
	    if (value == null || value === "") {
	      return "";
	    }

	    var markup = ""
        + "<span class='detail-view-hyperlink' "
		+ " method='POST'"
		+       "view='viewGroupingDetails' "
        +       "pk='" + dataContext.groupPk + "'"
	    +      "queryUrl='" +columnDef.queryUrl+ "'"
	    +       "dialogTitle='[" + value + "] " + xenos.title.AccountGroupingQueryView + "'"
        +       "href='/secure/ref/account/query/groupdetails/" + dataContext.groupPk + "?authorization=true'>"
        +   value
        
        + "</span>";
    	return markup;    	
	 }

	  

	function TradeReceiveConfirmationDetail(row, cell, value, columnDef, dataContext) {
    	//  Prepare the markup/ dynamically appended HTML tag
    	if(dataContext.receivedConfirmationPk==""){
    		return "";
    	}
		var commandFormId = $('#queryResultForm').find('[name=commandFormId]').val();
		
		var markup = ""
    		+ "<span class='detail-view-hyperlink popupIconBtn' "
    		+       "view='recvdNoticeDetailView' " 
    		+		"path='NCM' "   		
    		+       "dialogTitle='" + xenos.title.trdFeedRcvdConfirmation + "' "
    		+       "title='" + columnDef.name + "' "
    		+       "href='/trd/rcvdConfirmation/query/details/" + dataContext.receivedConfirmationPk + "?commandFormId="+commandFormId + "&rowNum="+row+"&dataContext=" + dataContext +"&popup=true" + "'>"
    		+   "j"
    		+ "</span>";
    		
    	return markup;
    }

	
	//Formatter for Match Pop Up
   function MatchPopUp(row, cell, value) {
		
			return '<span class="select-match-pop"></span>';
		
	}

	function Completionsecuritydetail(row, cell, value, columnDef, dataContext) {
		var UIDialog = $('.ui-dialog.topMost');
		var commandFormId="";
		if(typeof UIDialog =='undefined' || UIDialog.length == 0){ //Normal Query Result Screen
		  commandFormId = $('#queryResultForm').find('[name=commandFormId]').val();
		} else { //Dialog Query Result Screen
		  commandFormId = UIDialog.find('#queryResultForm').find('[name=commandFormId]').val();
		}
		
		if (value == null || value === "") {
		  return "";
		}
		if(dataContext.instrumentPk==""){
		   return '<span>'+value+'</span>';
		} else {
			var container = $("#content");
			var commandFormId = '?commandFormId=' + $('[name=commandFormId]',container).val();
			var markup = ""
				+ "<span class='detail-view-hyperlink-nowindow' "
				+       "view='instrumentDetailView' "
				+       "instrumentCode='" + value + "' "
				+       "instrumentPk='" + dataContext.instrumentPk + "'"
				+       "dialogTitle='[" + value + "] " + xenos.title.instrumentDetail + "'"
				+       "href='/secure/stl/compsummary/query/viewInit/" + dataContext.instrumentPk + commandFormId +"'>"
				+   value
				+ "</span>";
			return markup;
		}
	}
	//Authorization Deatil View Formatter for TXN_ENTITY like Trade/Nostro Adjustment..
	function AuthDetailViewFormatterForTxn(row, cell, value, columnDef, dataContext) {
		if (dataContext.actionPendingFor == 'CANCEL') {
		      return "";
		    }else{
		    	var id = dataContext[columnDef.options.id];
		    	var dialogHeight = columnDef.options.dialogHeight || 500;
		    	var pk = dataContext[columnDef.options.pk];
				var authPk = dataContext[columnDef.options.authPk];
				var actionType = dataContext.actionPendingFor;
		    	var baseURI = columnDef.options.baseURI;
		    	var title = columnDef.options.title;
		    	var dialogTitle = "" ;
		    	if (id !=null) {
		    		dialogTitle = "'[" + id + "] " + title + "'" ;
		    	} else {
		    		dialogTitle ="'"+title+"'" ;
		    	}
				var requestDataParam = {};
				var requestDataReqd = columnDef.options.requestDataReqd;
				if(requestDataReqd === 'Y'){
					requestDataParam = prepareRequestDataParam(columnDef, dataContext);
				}
			    var markup = ""
			        + "<span class='detail-view-hyperlink detailIco' "
			        +       "dialog_Height='"+ dialogHeight + "'"
			        +       "view='authDetailView' "
			        +		"method='GET'"
			        +		"requestData='" + requestDataParam + "'" 
			        +       "dialogTitle=" + dialogTitle
			        +       "href='" + baseURI + "/viewAuthDetail/" + pk + "/" + authPk + "/" + actionType + "?popup=true'>"
			        + "</span>";
			    return markup;
			}
	  }
	 // prepare customized request data if required for txn authorization detail view.
	  function prepareRequestDataParam(columnDef, dataContext){
		var requestDataParam;
		if(columnDef.options.targetEntity === 'CAX_RIGHT_CONDITION'){
			requestDataParam = "transactionPk=" + dataContext.newOldTransactionPk
								+ "&authLevel=" + dataContext.authLevel
								+ "&txnAuthHistPk=" + dataContext.txnAuthHistPk;
		}else if(columnDef.options.targetEntity === 'CAX_RIGHTS_DETAIL'){
			requestDataParam = "transactionPk=" + dataContext.newOldTransactionPk
								+ "&authLevel=" + dataContext.authLevel
								+ "&txnAuthHistPk=" + dataContext.txnAuthHistPk;
		}
		else{
			requestDataParam = {};
		}
		return requestDataParam;
	  }
	
	//Authorization Deatil View Formatter for REF_ENTITY like Account/Instrument..
	function AuthDetailViewFormatterForRef(row, cell, value, columnDef, dataContext) {
		if (dataContext.actionType == 'CANCEL') {
		      return "";
		    }else{
		    	var id = dataContext[columnDef.valueExtractKey.id];
		    	var dialogHeight = columnDef.valueExtractKey.dialogHeight || 500;
		    	var pk = dataContext[columnDef.valueExtractKey.pk];
		    	var baseURI = getInfoForAuthDetailViewFormatter(dataContext).baseURI;
		    	var title = getInfoForAuthDetailViewFormatter(dataContext).title;
			    var markup = ""
			        + "<span class='detail-view-hyperlink detailIco' "
			        +       "dialog_Height='"+ dialogHeight + "'"
			        +       "view='authDetailView' "
			        +		"method='GET'"
			        +		"requestData='{}'" 
			        +       "dialogTitle='[" + id + "] " + title + "'"
			        +       "href='"+baseURI+"/viewAuthDetail/" + pk +"/"+ dataContext.authPk+"/"+ dataContext.actionType +"?popup=true'>"
			        + "</span>";
			    return markup;
			}
	  }
	//Supplymentary information for the REF_ENTITY like Account/Instrument..
	 function getInfoForAuthDetailViewFormatter(dataContext){
		 var baseURI,title;
		 if(dataContext.tableName == 'REF_ACCOUNT'){
			   baseURI='/secure/ref/account';
			   title=xenos.title.accountDetail;
		 	}else if(dataContext.tableName == 'REF_INSTRUMENT'){
		 		 baseURI='/secure/ref/instrument';
		 		 title=xenos.title.instrumentDetail;
		 	}else if(dataContext.tableName == 'REF_APPLICATION_ROLE'){
		 		 baseURI='/secure/ref/approle';
		 		 title = xenos.title.applroleDetail;
		 	}else if(dataContext.tableName == 'REF_EMPLOYEE'){
		 		 baseURI='/secure/ref/emp';
		 		 title=xenos.title.employeeDetails;
		 	}else if(dataContext.tableName == 'REF_FIN_INST_ROLE'){
		 		 baseURI='/secure/ref/fininst';
		 		 title=xenos.title.fininstDetail;
		 	}else if(dataContext.tableName == 'REF_CP_SETTLE_STANDING_RULE'){
		 		 baseURI='/secure/ref/ssi';
		 		 title=xenos.title.ssiView;
		 	}else if(dataContext.tableName == 'REF_OWN_SETTLE_STANDING_RULE'){
		 		 baseURI='/secure/ref/ownStlStanding';
		 		 title=xenos.title.ownSsiView;
		 	}else if(dataContext.tableName == 'REF_EXCHANGE_RATE'){
		 		 baseURI='/secure/ref/exchangerate';
		 		 title=xenos.title.exchangerateDetail;
		 	}else if(dataContext.tableName == 'REF_STRATEGY'){
		 		 baseURI='/secure/ref/strategy';
		 		 title=xenos.title.strategyDetail;
		 	}else if(dataContext.tableName == 'REF_MARKET_PRICE_ALL'){
		 		 baseURI='/secure/ref/marketprice';
		 		 title=xenos.title.marketPriceDetailView;
		 	}else if(dataContext.tableName == 'REF_GROUP'){
		 		 baseURI='/secure/ref/grouping';
		 		 title=xenos.title.AccountGroupingQueryView;
		 	}else if(dataContext.tableName == 'REF_CUSTOMER'){
		 		 baseURI='/secure/ref/customer';
		 		 title=xenos.title.customerDetail;
		 	}else if(dataContext.tableName == 'REF_LOCAL_AC_ID_CONF_RULE'){
		 		 baseURI='/secure/ref/localacidconfrule';
		 		 title=xenos.title.idConfRuleDetail;
		 	}else if(dataContext.tableName == 'REF_AGREEMENT_ACTION_HISTORY'){
		 		 baseURI='/secure/ref/document';
		 		 title=xenos.title.docActionDetail;
		 	}else if(dataContext.tableName == 'REF_INST_COLLATERAL'){
		 		 baseURI='/secure/ref/collateral';
		 		 title=xenos.title.collateralDetailPopup;
		 	}else if(dataContext.tableName == 'REF_INST_HAIRCUT_RATE'){
		 		 baseURI='/secure/ref/haircut';
		 		 title=xenos.title.haircutDetailPopup;
		 	}else if(dataContext.tableName == 'REF_ASSET_MANAGEMENT_ACCOUNT'){
		 		 baseURI='/secure/ref/assetMgmt';
		 		 title=xenos.title.assetMgmtDetailView;
		 	}else if(dataContext.tableName == 'REF_LEDGER'){
		 		 baseURI='/secure/gle/ledger';
		 		 title=xenos.title.gleLedgerDetail;
		 	}	 
		 	else{
		 		//nothing
		 	}
		 return {'baseURI': baseURI,'title':title};
	 	}	
	 


	 function NettedSettlementDetailFormatterForAuth(row, cell, value,columnDef, dataContext) {
		if (dataContext.actionPendingFor == 'CANCEL') {
			return "";
		}else {
			var markup = ""
					+ "<span class='detail-view-hyperlink detailIco' title='Details' method='POST' "
					+ "view='nettedSettlementDetailView' "
					+ "settlementinfopk='" + dataContext.settlementInfoPk + "'"
					+ "dialogTitle='" + xenos.title.nettedStlDetail + "'"
					+ "href='/secure/stl/settlement/query/showNettedSettlements/" + dataContext.settlementInfoPk + "?viewMode=Settlement&diffEnableFlag=" + columnDef.isForAuth + "&authStatus=" + columnDef.authStatus + "&authLevel=" +dataContext.authLevel+ "&actionDone="+dataContext.actionPendingFor+ "'>"
					+ "</span>";
			return markup;
		}
	}
	
	 function PairOffSettlementDetailFormatterForAuth(row, cell, value,columnDef, dataContext) {
		if (dataContext.actionPendingFor == 'CANCEL') {
			return "";
		}else {
			var markup = ""
					+ "<span class='detail-view-hyperlink detailIco' title='Details' method='POST' "
					+ "view='nettedSettlementDetailView' "
					+ "settlementinfopk='" + dataContext.settlementInfoPk + "'"
					+ "dialogTitle='" + xenos.title.pairOffStlDetail + "'"
					+ "href='/secure/stl/settlement/query/details/showOriginalNettedStl/" + dataContext.settlementInfoPk + "?actionDone="+dataContext.actionPendingFor+ "'>"
					+ "</span>";
			return markup;
		}
	}
	
	 /**
	   * Formater to view the detail of GLE Voucher Query
	   */
	function GleVoucherFormater(row, cell, value, columnDef, dataContext) {
		  if (value == null || value === "") {
		     return "";
		  }
		  var markup = ""
	        + "<span class='detail-view-hyperlink' "
	        +       "dialog_Height='600'"
			+       "dialog_Width='1000'" 
	        +       "view='gleVoucherDetails' "
	        +       "voucherPk='" + dataContext.voucherPk + "'"
			+ 		"dialogTitle='[" + value + "] " + xenos.title.gleVoucherDetail + "'"
	        +       "href='/secure/gle/voucher/details" + "/" + dataContext.voucherPk +"?popup=true" + "'>"
	        +   value
	        + "</span>";
	    return markup;
	  }
	/**
	   * Formater to view the detail of GLE Voucher Authorization Query
	   */
  function GleVoucherFormaterForAuth(row, cell, value, columnDef, dataContext){
		if(dataContext.actionPendingFor == 'CANCEL'){
	    	return "";
	    }else{
			if(dataContext.voucherPk==""){
				return '<span>'+value+'</span>';
			} else {
				var markup = ""
				+ "<span class='detail-view-hyperlink detailIco' "
				+       "view='gleVoucherDetail' "
				+       "dialogTitle='[" + value + "] " + " Voucher Detail '"
				+       "href='/secure/gle/voucher/viewAuthDetail/" + dataContext.voucherPk + "/" + dataContext.transactionPk + "/" + dataContext.actionPendingFor + "?popup=true'>"
				+ "</span>";
				return markup;
			}
		}
	}
  
  /**
   * Formatter to view the Psersonalization Details of the individual user when the Preference is imported by the Multi User Import Screen
   */
  function MultiUserImportPreferenceDetailViewFormater(row, cell, value,columnDef, dataContext) {
		if (dataContext.userId == '') {
			return "";
		}else {
			var container = $("#content");
			var commandFormId = '?commandFormId=' + $('[name=commandFormId]',container).val();
			var markup = ""
						+ "<span class='detail-view-hyperlink detailIco' title='Details' "
						+ "view='personalizationDetailView' "
						+ "dialogTitle='" + "[" + dataContext.userId + "] " + xenos.title.personalizationDetails + "'"
						+ "href='/secure/ref/personalization/screen/details/" + dataContext.userId + commandFormId + "&popup=true'>"
						+ value
						+ "</span>";
			return markup;
		}
	}

	/**
		   * Formatter to download the document from Account Document Query Screen.
		   *	Should be taken to upper level in case this feature is required anywhere else.
	   */
	function DocumentDownloadFormatter(row, cell, value, columnDef, dataContext){
		if (value == null || value === "") {
			return "";
		} 
		if(dataContext.accountAgreementPk==""){
			return '<span>'+value+'</span>';
		} else {
			var markup = ""
				+ "<span class='document-download-hyperlink' href='" + xenos.context.path + "/secure/ref/document/query/documentdownload/" + dataContext.accountAgreementPk + "' style='color:green'>"
				+ value
				+ "</span>";
			return markup;
		}
	}
	
	function ReconDetailViewFormater(row, cell, value, columnDef, dataContext) {
	    var result;
	    if (value == null || value === "") {
			return "";
		} 
		if(dataContext.matchStatus == 'MATCHED') {
			return '<span>'+value+'</span>';
		}
		result = ""
		+ "<span class='detail-view-hyperlink' "
		+       "view='reconDetailView' "
		+       "recResultsSummaryPk='" + dataContext.recResultsSummaryPk + "' "
		+       "dialogTitle='[" + value + "] " + xenos.title.reconDetails + "' "
		+       "href='/secure/trd/recon/query/recondetails/" + dataContext.recResultsSummaryPk + "'>"
		+   value
		+ "</span>";
		
		return result;
  }
  
  function ChequeInventoryDetailViewFormater(row, cell, value, columnDef, dataContext) {
	    var result;
	    if (value == null || value === "") {
			return "";
		} 
		
		result = ""
		+ "<span class='detail-view-hyperlink' "
		+       "view='chequeBookDetail' "
		+       "chequeBookDetailsPk='" + dataContext.chequeBookDetailsPk + "' "
		+       "dialogTitle='[" + value + "] " + " Cheque Inventory Detail '"
		+       "href='/secure/gwy/chequeinv/query/details/" + dataContext.chequeBookDetailsPk + "'>"
		+   value
		+ "</span>";
		
		return result;
  }

    function AccountPopUpFormatter(row, cell, value, columnDef, dataContext) {
		value = value || "";
		var markup = ""			
			+'<div class="formItem">'
			+	'<span><input id="accountNo-' +row+ '" type="text" name="accountNo-' +row+ '" rowIndex="'+row+'" value="' + value + '" ></span>'
			+	'<div class="popupBtn">	 '
			+		'<input type="button" class="popupBtnIco" tgt="accountNo-'+row+'" popType="cpAccount" actTypeContext="S|B" actCPTypeContext="CLIENT" actStatusContext="OPEN" value="" />'
			+	'</div>'
			+	'<div class="clear"><spring:message text="" htmlEscape="false"/></div>'
			+'</div>';
		return markup;	
	}
    
    /**
	  * Generic Formatter to download the Report (in PDF or Excel format) 
	  * for individual row in Query Result Pages.
	  */
	function xenosReportFormatter(row, cell, value, columnDef, dataContext) {
		value = value || "";
		var option = columnDef.option || {};
		var container = $("#content");
		var commandFormIdRequired = (option.hasOwnProperty('commandFormIdRequired') && (option['commandFormIdRequired']==true));
		var cancelRecordReportReqd = (option.hasOwnProperty('cancelRecordReportReqd') && (option['cancelRecordReportReqd'] == true));
		if(!cancelRecordReportReqd && (dataContext.status == 'CANCEL' || dataContext.status == 'CXL')) {
			return '<span>'+value+'</span>';
		}
		
		var extraPathVariableStr = "";
		var extraQueryString ="";
		var extraUrlString ="";
       //Prepare the markup dynamically appended HTML tag
       var markup = "";
		var pathVarableArray = option.extraPathVariablesInOrder || [];
		var fileType = option['fileType'] || 'pdf';
		$.each(pathVarableArray, function(index, variable){
			extraPathVariableStr += "/" + $.trim(dataContext[variable]);
		});
		
		if($.isFunction(option.queryString)){
			extraQueryString = option.queryString(columnDef, dataContext);
		}
		
		if($.isFunction(option.urlString)){
			extraUrlString = option.urlString(columnDef, dataContext);
		}else{
			extraUrlString = option.urlString;
		}
		
		
		var commandFormId = (($.trim(extraQueryString) == "") ?  "?" : "&") + 'commandFormId=' + $('[name=commandFormId]',container).val();
		
		var title = "";
		var imageName = "";
       if(fileType == 'xls'){
			title ="XLS";
			imageName="resultexcelicon.png";
		}else {
			title ="PDF";
			imageName="resultpdficon.png";
	    }
	    markup += "<span>"
					+ "<a target='_blank' href='" 
										+ xenos.context.path 
										+ extraUrlString.replace('{rowIndex}',row)
										+ $.trim(extraPathVariableStr) 
										+ $.trim(extraQueryString)
										+ (commandFormIdRequired ? commandFormId : "")
					    + "'>"
						+ "<img src='"+xenos.context.path+"/images/xenos/"+imageName+"' alt='' title='"+title+"'>"
					+ "</a>"
				+ "</span>";
				
       return markup;
   }
	
	//Formatter for Dispaly Field other than the actual value with some specific color.
	// For example: actual value is CANCEL, that should be displayed like CXL in red, in those
	// scenarios this formatter can be used where possible actual value and display value
	// (with color) can be speciifed.
    function DisplayFormatter(row, cell, value, columnDef, dataContext) {
    	if (value == null || value === "") {
   	      return "";
   	    }
   		var options = columnDef.options || {};
   		var styleClass;
   		var dispVal;
   		if(options.hasOwnProperty('transformToDisp')){
   			var statusDisp = options.transformToDisp;
			if($.isFunction(statusDisp)){
				var result = statusDisp(value, columnDef, dataContext);
				if(!jQuery.isEmptyObject(result)){
					dispVal=result.dispVal;
					styleClass=result.cssClass;
				}
			} else {
				for(var i in statusDisp){
					if(value == i){
						dispVal=statusDisp[i].dispVal;
						styleClass=statusDisp[i].cssClass;
						break;
					}
				}
			}
   		}
   		var markup = "<span";
   		if($.trim(styleClass) !=''){
   			markup += " class='"+ styleClass + "'";
   		}
   		
   		markup += ">" + ((typeof dispVal == 'undefined') ? value : dispVal) + "</span>";
   	    return markup;
 	}
	
	// Formatter for User Status(Disable or Enable)
   function UserStatusFormatter(row, cell, value) {
		if(value == "Disable" || value == "DISABLE" || value == "D"){
			return '<span style="color:red;">'+ value +'</span>';
		}else{
			return '<span>' + value + '</span>';
		}
	}
	/**
	  * Formatter for CAM Allocation Deallocation Authorization Screen.
	  * Need to have this formatter as the generic Formatter cannot be supported 
	  * with different base URL per datacontext wise (i.e. two rows can have different 
	  * base URL based on Collateral Type 'CASH' or 'SECURITY')
	  */
	function CamAllocationDeallocationFormatter(row, cell, value, columnDef, dataContext) {
		if (value == null || value === "") {
			return "";
		} 
		var collateralType = dataContext.collateralType || "" ;
		var option = 		columnDef.option || {};
		var InOutFlag =     option.InOutFlag ;
		if($.trim(collateralType) == ""){
			return '<span>'+value+'</span>';
		}
		var baseUrl = "";
		var viewName = "";
		var title = "";
		if($.trim(collateralType) == "CASH"){
			baseUrl = "/secure/cam/cashiotransfer/details/";
			viewName = "cashIODetailView";
			if (InOutFlag =="I" ) {
				title = xenos.title.cashInDetail;
			}
			if (InOutFlag =="O" ) {
				title = xenos.title.cashOutDetail;
			}
		}else{
			baseUrl = "/secure/cam/securityio/details/";
			viewName = "CamSecurityDetail";
			if (InOutFlag =="I" ) {
				title = xenos.title.securityInDetail;
			}
			if (InOutFlag =="O" ) {
				title = xenos.title.securityOutDetail;
			}
		}
		var markup  = "<span class='detail-view-hyperlink' "
				    + "dialog_Height='350'"
				    + "view='" + viewName + "' "
				    + "referenceNo='" + value + "' "
					+ "camEntryPk='" + dataContext[columnDef.option.pkFieldName]  + "' "
					+ "dialogTitle='[" + value + "] " + title + "' "
					+ "href='" + baseUrl + dataContext[columnDef.option.pkFieldName] + "?popup=true" + "'>"
					+  value
					+ "</span>";

		return markup;
	}
	
	function DetailAndCheckboxFromatter(row, cell, value, columnDef, dataContext) {
		var options = columnDef.options || {};
		var textBoxOptions = options.textBox || {};
		var tbStyle = textBoxOptions.style || '';
		var requestData = function(){return {}}; 
		var checkBoxOptions = options.checkBox || {};
		var checkBoxId = columnDef.checkBoxId || "";
		var cbStyle = checkBoxOptions.style || '';
		var disabled = checkBoxOptions.disabled || false;
		var methodType = options.methodType ? options.methodType : "";
		var selectedByDefault = (dataContext[checkBoxId] && dataContext[checkBoxId] == 'Y') ? true : false;
		
		if($.isFunction(options.requestData)){
			requestData = options.requestData(columnDef, dataContext);
		}
		 value = value || "";
	   
	    var markup = "<span ";
		var hyperLinkReqd = ((typeof options.hyperLinkReqd == 'undefined') ? true : options.hyperLinkReqd);
		if(hyperLinkReqd){
			markup += "class='detail-view-hyperlink' ";
		}
		if(tbStyle != ''){
			markup += " style='"+ tbStyle + "'";
		}
		markup += "view='"+(options.view || "")+"' title='"+ value + "'";
		
		if(options.hasOwnProperty('height')){
			markup += "dialog_Height='" + (options.height) + "'";
		}
		
		markup +="dialogTitle=' ";
		
		var dialogTitleValueReqd = ((typeof options.dialogTitleValueReqd == 'undefined') ? true : options.dialogTitleValueReqd);
		var dialogTitleValue = ($.trim(dataContext[options.dialogTitleValue]) || value);
		if(dialogTitleValueReqd){
			markup +="[" + dialogTitleValue + "] ";
		}
		markup += (options.dialogTitle || "") + "' ";
		
		if($.trim(methodType) != ""){
			markup += " method='" + methodType + "'";
			if($.trim(requestData) != ""){
				markup += " requestData='" + requestData + "'";
			}
			markup += " href='"+ options.url.replace('{rowIndex}',row) + $.trim(dataContext[options.pkFieldName]) + "?popup=true'>";
		} else{
			markup += ">";
		}
		markup += value+ " </span>";
		if(checkBoxId == ""){
			return markup;
		}else{
			markup += "<input type='checkbox' name='" + checkBoxId + "' rowIndex='"+row + "' ";
			if(cbStyle != ''){
				markup += " style='"+ cbStyle + "'";
			}
			
			if(disabled){
				markup += " disabled='disabled'";
			}
			if(selectedByDefault){
				markup += " value='Y' checked='checked'";
			}		
			markup += " value=''/>";
			return markup;
		}
	    return markup;
	 }
	  
	function StlPaymentSplitFormatter(row, cell, value, columnDef, dataContext) {
		var markup;
		if (value == null || value === "") {
		  markup = "";
		}
		var imagePath = '/images/xenos/icon/splitIcon.png';
		if (dataContext.splitFlag == 'Y'){
			imagePath = '/images/xenos/icon/splitVisitedIcon.png';
		}
		markup = ""
			+ "<span class='page-navigation-hyperlink payment-split' >"
			+ "<img src='"+xenos.context.path + imagePath + "' style='width:15px; height:15px;' align='"+"middle' alt='' title='" + columnDef.name + "' rowIndex='"+row+"'>"
			+ "</span>";
		return markup;
   }
   function FundDetailViewFormatter(row, cell, value, columnDef, dataContext) {
    if (value == null || value === "") {
      return "";
    }
    var markup = ""
        + "<span class='detail-view-hyperlink' "
        +       "view='fundDetailView' "
        +       "fundCode='" + value + "' "
        +       "fundPk='" + dataContext.fundPk + "'"
        +       "dialogTitle='[" + value + "] " + xenos.title.fundDetail + "'"
        +       "href='/secure/ref/account/fund/details/" + dataContext.fundPk + "'>"
		+ 		value
        + "</span>";

    return markup;
  }

   
   function CloseOutQueryDetailViewFormatter(row, cell, value, columnDef, dataContext) {
	    if (value == null || value === "") {
	      return "";
	    }
	    var markup = ""
	        + "<span class='detail-view-hyperlink' "
	        +       "view='drvCloseOutQueryDetailView' "
	        +       "dialogTitle='[" + value + "] " + xenos.title.drvCloseoutDetails + "'"
	        +       "href='/secure/drv/trade/view/details/" + dataContext.actionPK + "'>"
			+ 		value
	        + "</span>";

	    return markup;
	  }
   
   function BkgTradeDetailViewFormatter(row, cell, value, columnDef, dataContext) {
	    if (value == null || value === "") {
	      return "";
	    }
	    var markup = ""
	        + "<span class='detail-view-hyperlink' "
	        +       "view='bkgTradeDetailView' "
	        +       "dialogTitle='" + xenos.title.bkgTradeDetail + "'"
	        +       "href='/secure/bkg/banking/trade/details/" + dataContext.bankingTradePk + "'>"
			+ 		value
	        + "</span>";

	    return markup;
	  }

	function FrxTradeDetailViewFormatter(row, cell, value, columnDef, dataContext) {
	    if (value == null || value === "") {
	      return "";
	    }
	    var markup = ""
	        + "<span class='detail-view-hyperlink' "
	        +       "view='frxTradeDetailView' "
	        +       "dialogTitle='" + xenos.title.frxTradeDetail + "'"
	        +       "href='/secure/frx/forex/trade/details/" + dataContext.frxTrdPk + "'>"
			+ 		value
	        + "</span>";

	    return markup;
	  }
	  
	  function AccountCommonDetailViewFormatter(row, cell, value, columnDef, dataContext) {
		  if (value == null || value === "") {
		  return "";
		}
		var options = columnDef.accountDetailOptions || {};
		var markup = ""
			+ "<span class='detail-view-hyperlink' "
			+       "view='accountDetailView' "
			+       "dialogTitle='[" + value + "] " + xenos.title.accountDetailTitle + "'"
			+       "href='/secure/ref/account/common/details/" + dataContext[options.pkFieldName] + "'>"
			+ 		value
			+ "</span>";
			return markup;
		  
	  }
	  
	  function NcmTradeDetailViewFormatter(row, cell, value, columnDef, dataContext) {
			if (value == null || value === "") {
				return "";
			}
			
			var markup = "";
			
			if (dataContext.module == "NCM"){
				dataContext.ncmEntryPk = dataContext.triggeringTxnPk;
				markup = NcmAdjustmentQueryDetailViewFormatter(row, cell, value, columnDef, dataContext);
			}else if(dataContext.module == "CAM"){
				dataContext.camEntryPk = dataContext.triggeringTxnPk;
				markup = CamSecurityDetailFormater(row, cell, value, columnDef, dataContext);
			}else if(dataContext.module =="STL01"||dataContext.module =="STL02"){
				dataContext.settlementInfoPk = dataContext.triggeringTxnPk;
				markup = SettlementDetailViewInstructionFormater(row, cell, value, columnDef, dataContext);
			}else if(dataContext.module == "TRD"){
				dataContext.tradePk = dataContext.triggeringTxnPk;	
				markup = TradeDetailViewFormater(row, cell, value, columnDef, dataContext);
			}else if(dataContext.module =="CAX02"){
				dataContext.rightsDetailPk = dataContext.triggeringTxnPk;
				markup = RightsDetailViewFormatter(row, cell, value, columnDef, dataContext);
			}else if(dataContext.module =="CAX05"){
				dataContext.rightsExercisePk = dataContext.rightsExercisePk;
				markup = ExerciseDetailViewFormatter(row, cell, value, columnDef, dataContext);	
			}

			return markup;	    
		}
  
  // this formatter will render detail view page when Event hyperling is clicked
  function EventDetailViewFormater(row, cell, value, columnDef, dataContext) {
	    if (value == null || value === "") {
	      return "";
	    }
	    var markup = ""
	        + "<span class='detail-view-hyperlink' "
	        +       "view='conditionDetailView' "
	        +       "dialogTitle='" + xenos.title.eventDetail + "'"
	        +       "href='/secure/cax/event/details/" + dataContext.rightsConditionPk + "'>"
			+ 		value
	        + "</span>";

	    return markup;
	  }
  
  	  //Entitlements Detail View Formatter
	  function RightsDetailViewFormatter(row, cell, value, columnDef, dataContext) {
		    if (value == null || value === "") {
		      return "";
		    }
	
		    var markup = ""
		        + "<span class='detail-view-hyperlink' "
		        +       "view='rightsDetailView' "
		        +       "rightsDetailPk='" + dataContext.rightsDetailPk + "' "
		        +       "dialogTitle='[" + value + "] " + xenos.title.entitlementsDetailTitle + "'"
		        +       "href='/secure/cax/entitlement/adjustment/details/" + dataContext.rightsDetailPk + "'>"
		        +   value
		        + "</span>";
	
		    return markup;
		  }

	  
	//Exercise Detail View Formatter
	  function ExerciseDetailViewFormatter(row, cell, value, columnDef, dataContext) {
		    if (value == null || value === "") {
		      return "";
		    }
	
		    var markup = ""
		        + "<span class='detail-view-hyperlink' "
		        +       "view='rightsExerciseDetailView' "
		        +       "rightsExercisePk='" + dataContext.rightsExercisePk + "' "
		        +       "dialogTitle='[" + value + "] " + xenos.title.exerciseDetailTitle + "'"
		        +       "href='/secure/cax/exercise/details/" + dataContext.rightsExercisePk + "'>"
		        +   value
		        + "</span>";
	
		    return markup;
		  }

          function SettlementDetailViewInstructionCashTransferFormater(row, cell, value, columnDef, dataContext) {
		  var markup = "";
		  if (value == null || value === "") {
		    return "";
		  }

            
                  if(dataContext.settlementInfoPk > 0){
                      return SettlementDetailViewInstructionFormater(row, cell, value, columnDef, dataContext);
		     
		  } else{
			 return CashTransferDetailViewFormater(row, cell, value, columnDef, dataContext);
	          }
                 }
          
          function CashTransferDetailViewFormater(row, cell, value, columnDef, dataContext) {
		  var markup = "";
		   
                    markup = "<span class='detail-view-hyperlink' "
		                  +       "view='cashTransferAuthDetail' "
						  +       "dialogTitle='[" + value + "] " + xenos.title.cashEntryDetailInfo + "' "
		                  +       "cashEntryPk='" + dataContext.cashEntryPk + "' "
                          +       "href = '/secure/stl/settlement/cashTransfer/query/details" +"?cashEntryPk=" + dataContext.cashEntryPk + "'>"
		  	              +     value
                          +  "</span>";
		 
		  return markup;
	  }
          
          /* 	General View Formatter. Since we have so many detail views in our application, if we create a dedicated formatter then number of
  	 	formatter will growing up. To magage it to single following formatter can be used and it is expected the proper configurations 
  	 	should be passed through column definition. Depending upon the colun definiton mark-up will be generated.*/
  	function NegativeBalanceDetailViewFormater(row, cell, value, columnDef, dataContext) {
  			
  		var option = columnDef.option || {};
  		var popupIconReqrd = (option.popupIcon || false);
  		var detailViewRequired = true;
  		if($.isFunction(option.detailViewRequired)){
  			detailViewRequired = option.detailViewRequired(columnDef, dataContext);
  		}		
  		if((!popupIconReqrd && $.trim(value)==="") || !detailViewRequired){
  			return "";
  		}
  		var extraPathVariableStr = "";
  		var extraQueryString ="";
  		var methodType = option.methodType ? option.methodType : "";
  		var requestData = function(){return {}}; 
  		var commandFormIdRequired = (option.hasOwnProperty('commandFormIdRequired') && (option['commandFormIdRequired']==true));
  			
          //  Prepare the markup/ dynamically appended HTML tag
          var markup = "<span class='detail-view-hyperlink " + (popupIconReqrd? "popupIconBtn" : "") + "' ";
  	
  		if ($.trim(value).replace(/,/g, '') < 0) {
  			markup += " style='color:red !important' ";
  		}
  		
  		if(option.hasOwnProperty('height')){
  			markup += "dialog_Height='"+ (option.height) + "'";
  		}
  		if(option.hasOwnProperty('width')){
  			markup += "dialog_Width='"+ (option.width) + "'";
  		}
  		var pathVarableArray = option.extraPathVariablesInOrder || [];
  		
  		$.each(pathVarableArray, function(index, variable){
  		  extraPathVariableStr += "/" + $.trim(dataContext[variable]);
  		});
  		
  		if($.isFunction(option.queryString)){
  			extraQueryString = option.queryString(columnDef, dataContext);
  		}
  		if($.isFunction(option.requestData)){
  			requestData = option.requestData(columnDef, dataContext);
  		}
  		markup += "view='"+(option.view || "")+"' ";
  		markup +="dialogTitle=' ";
  		var dialogTitleValueReqd = ((typeof option.dialogTitleValueReqd == 'undefined') ? true : option.dialogTitleValueReqd);
  		var dialogTitleValue = ($.trim(dataContext[option.dialogTitleValue]) || value);
  		if(!popupIconReqrd && dialogTitleValueReqd){
  			markup +="[" + dialogTitleValue + "] ";
  		}
  		markup += (option.dialogTitle || "") + "' ";
  		if(popupIconReqrd){
  			markup += "title='" + columnDef.name + "' ";
  		}
          if($.trim(methodType) != ""){
  			markup += " method='" + methodType + "'";
  			markup += " requestData='" + requestData + "'";
  		}
  	    markup += " href='"+ option.url.replace('{rowIndex}',row) + $.trim(dataContext[option.pkFieldName]) + 
  	                                                               $.trim(extraPathVariableStr) + "?popup=true" + 
  	                                                               (commandFormIdRequired ? "&commandFormId="+dataContext['commandFormId'] : "") +
  	                                                               $.trim(extraQueryString)+
  	                                                               "'>"
          +       (popupIconReqrd ? "j" : value)
          + "</span>";
          return markup;
      }
  	  /**
	   * Formater to view the detail of GLE Transaction Query
	   */
	   function GleTransactionFormater(row, cell, value, columnDef, dataContext) {
		  if (value == null || value === "") {
		     return "";
		  }
		  var markup = ""
	        + "<span class='detail-view-hyperlink' "
	        +       "dialog_Height='350'"
	        +       "view='gleTransactionDetail' "
	        +       "transactionPk='" + dataContext.transactionPk + "'"
	        +       "dialogTitle='" + xenos.title.gleTransactionDetail + "'"
	        +       "href='/secure/gle/transaction/details" + "/" + dataContext.transactionPk + "'>"
	        +   value
	        + "</span>";
	    return markup;
	  }
	   
	   function BrokerAccountDetailFormatter(row, cell, value, columnDef, dataContext) {
			if (value == null || value === "") {
			  return "";
			}
			var markup = "";
			var options = columnDef.accountDetailOptions || {};
			
				markup = ""
				+ "<span class='detail-view-hyperlink' "
				+       "view='accountDetailView' "
				+       "dialogTitle='[" + value + "] " + xenos.title.accountDetailTitle + "'"
				+       "href='/secure/ref/account/broker/details/" + dataContext[options.pkFieldName] + "'>"
				+ 		value
				+ "</span>";
			return markup;
	   }

	   
	   function AllotmentInstrumentDetailViewFormater(row, cell, value, columnDef, dataContext) {
		if (value == null || value === "") {
		  return "";
		}
		if(dataContext.instrumentPk==""){
		   return '<span>'+value+'</span>';
		} else {
			var markup = ""
				+ "<span class='detail-view-hyperlink' "
				+       "view='instrumentDetailView' "
				+       "instrumentCode='" + value + "' "
				+       "instrumentPk='" + dataContext.allotmentInstPk + "'"
				+       "dialogTitle='[" + value + "] " + xenos.title.instrumentDetail + "'"
				+       "href='/secure/ref/instrument/details/" + dataContext.allotmentInstPk + "?popup=true" + "'>"
				+   value
				+ "</span>";
			return markup;
		}
	}
	  
	  /**
	   * Formater to view the detail of Margin Query
	   */
	  function MarginDetailsViewFormatter(row, cell, value, columnDef, dataContext) {
		  if (value == null || value === "") {
		     return "";
		  }
		  var markup = ""
	        + "<span class='detail-view-hyperlink' "
	        +       "dialog_Height='350'"
	        +       "view='marginEntryDetails' "
	        +       "marginPk='" + dataContext.marginPk + "'"
			+       "tradeRefNo='" + dataContext.tradeReferenceNo + "'"
	        +       "dialogTitle='" + xenos.title.drvMarginDetails + "'"
	        +       "href='/secure/drv/margin/details" + "/" + dataContext.marginPk + "?tradeRefNo=" + dataContext.tradeReferenceNo + "'>"
	        +   value
	        + "</span>";
	    return markup;
	  }
	  
	  /**
	   * Formatter for the detail view of Instrument along with options
	   */
	  function InstrumentDetailViewFormaterOptions(row, cell, value, columnDef, dataContext) {
			if (value == null || value === "") {
			  return "";
			}
			var options = columnDef.instrumentDetailOptions || {};
				var markup = ""
					+ "<span class='detail-view-hyperlink' "
					+       "view='instrumentDetailView' "
					+       "instrumentCode='" + value + "' "
					+       "instrumentPk='" + dataContext[options.pkFieldName] + "'"
					+       "dialogTitle='[" + value + "] " + xenos.title.instrumentDetail + "'"
					+       "href='/secure/ref/instrument/details/" + dataContext[options.pkFieldName] + "?popup=true" + "'>"
					+   value
					+ "</span>";
				return markup;
			
		}


	   
	   function BalanceDetailViewFormatter(row, cell, value, columnDef, dataContext) {
			
		   var markup = "";
		  
		  if (value == null || value == "") {
		    return "";
		  }
		  else if(dataContext.sourceComponentId=='STL' && (dataContext.settlementInfoPk !='' && dataContext.settlementInfoPk!=null)){
			 
			 if(dataContext.transactionType != 'UNKNOWN_COMPLETION'){
				
				 markup = "<span class='detail-view-hyperlink' "
				+       "view='settlementDetailView' "
				+       "settlementreferenceno='" + value + "' "
				+       "settlementinfopk='" + dataContext.settlementInfoPk + "' "
				+       "dialogTitle='[" + value + "] " + xenos.title.settlementInfo + "' "
				+       "href='/secure/stl/settlement/query/details/" + dataContext.settlementInfoPk+"/" + dataContext.settlementReferenceNo +"?pendingSubmission=" + dataContext.pendingSubmission 
				+               "&viewType=" + dataContext.viewType + "&clientSettlementInfoPk=" + dataContext.clientSettlementInfoPk 
				+               "&viewMode=Instruction&nettedFlag=true&diffEnableFlag=" + columnDef.isForAuth +"'>"
				+   value
				+ "</span>";
			 
			 }
	        }
		else if(dataContext.sourceComponentId=='NCM' && (dataContext.ncmEntryPk!="")){
			markup = ""
			+ "<span class='detail-view-hyperlink' "
			+       "dialog_Height='350'"
			+       "view='ncmAdjustmentQueryDetailView' "
			+       "referenceNo='" + value + "' "
			+       "ncmEntryPk='" + dataContext.ncmEntryPk + "'"
			+       "dialogTitle='[" + value + "] " + xenos.title.ncmAdjustmentQueryDetail + "'"
			+       "href='/secure/ncm/adjustment/details/" + dataContext.ncmEntryPk + "'>"
			+   value
			+ "</span>";
			
		}
		else {
		  	markup = '<span>'+value+'</span>';
		 }
		return markup;
		 
	  }

	  
	   function ExerciseAmountFormatter(row, cell, value, columnDef, dataContext) {	

			 //  console.log(dataContext);
			   var v = dataContext.subscriptionCostPerShare;
			   var prevFlag = dataContext.prevFinalizeFlag;
			   var flag = dataContext.exerciseFinalizeFlag; 
			   var disabled = false;
			   if(prevFlag == "Y")
				   disabled = true;
			   else if(flag == "Y")
				{
					disabled = true;
				}
				else
				{
					disabled = false;
				}
			   
			value = value || "";
				var markup = ""
							+ 	"<span>"
							+ 		"<input  name='" + columnDef.id + "' class='editablGridInput totalSubscriptionCost' readonly='true' type='text' value='"+value+"' rowIndex='"+row+"' " ;
					if(disabled){
						markup += " disabled='disabled'";
					}		
					markup += "'>";
					markup += "<img class='ui-datepicker-trigger ui-calc-trigger editableGridCalcPos'"
					markup += "src='"+xenos.context.path+"/images/xenos/icon/icon_calculator.png' alt='' title='' />"
					markup += "</span>";
				return markup;
				
			}
			
			function ExerciseAmendCheckBoxFromatter(row, cell, value, columnDef, dataContext) {
				var v = dataContext.exerciseFinalizeFlag;
				//console.log(v);
				var availableRightsStr = dataContext.availableRightsStr;
				var prev =  dataContext.prevFinalizeFlag;
				var disabled = "";
				if(prev != "Y" && availableRightsStr == "0")
					disabled = "disabled";
				if (v == "Y")
					value = "checked";
			   value = value || "";
			   
			    var markup = ""
			        + 	"<span index='" + row + "'>"
			        + 		"<input type='checkbox' name='" + columnDef.id + "' rowIndex='"+row+"'  value='" + value + "' width='100px' "+value+" "+disabled+">"
			        +	"</span>";
			    return markup;
			  }


			function ExercisingQuantityTxnInputFormatter(row, cell, value, columnDef, dataContext) {
					var id = dataContext.rowID;
					var prevFlag = dataContext.prevFinalizeFlag;
					var flag = dataContext.exerciseFinalizeFlag; 
					value = value || "";
					var options = columnDef.options || {};
					var styleClass = options.styleClass || '';
					var style = options.style || '';
					var disabledTmp =  false;
					
					if(options.disabled){
						if(jQuery.isFunction(options.disabled)){
							disabledTmp = options.disabled(row, cell, value, columnDef, dataContext);
						} else {
							disabledTmp = options.disabled;
						}
					}
					var disabled = disabledTmp ? "disabled='true'" : "";
					if(prevFlag == "Y")
					{
						disabled = true;
					}
					else if(flag == "Y")
					{
						disabled = true;
					}
					else
					{
						disabled = false;
					}
					var markup = ""
						+ 	"<span>"
						+ 		"<input type='text' name='" + columnDef.id + "' rowIndex='"+row+"' value='" + value + "' readOnly = 'readOnly' onclick =xenos$ExerciseAmend$emptyTotal("+row+") class='ExercisingQuantityTxnInput'   ";
						if(styleClass != ''){
							markup += " class='"+ styleClass + "'";
						}
						if(disabled){
							markup += " disabled='disabled'";
						}
						markup += " style='width:"+(columnDef.width - 10)+"px; ";
						if(style != ''){
							markup += style ;
						}
						markup += "'>"
							   +	"</span>";
					return markup;
			   }
			 
		   function ExerciseAmendDateFormatter(row, cell, value, columnDef, dataContext) {
				value = value || "";
				   var prevFlag = dataContext.prevFinalizeFlag;
				   var flag = dataContext.exerciseFinalizeFlag; 
				   var disabled = false;
				   if(prevFlag == "Y")
					   disabled = true;
				   else if(flag == "Y")
					{
						disabled = true;
					}
					else
					{
						disabled = false;
					}
				var markup = "";
				markup += 	"<span>"
				markup +=  "<input name=" + columnDef.id  + " class='dateinput hasDatepicker' style='width:80px; text-align:center' type='text' value='"+value+"' rowIndex='"+row+"' ";
				if(disabled){
						markup += " disabled='disabled'";
					}		
				markup += ">";
				markup +=		"<button class='ui-datepicker-trigger editableGridDatePickPos' type='button'";
				if(disabled){
						markup += " disabled='disabled'";
					}		
				markup += ">";
				markup +=			"<img src='"+xenos.context.path+"/images/namrui/icon/calendarIco.png' alt='' title=''>";
				markup +=		"</button>";
				markup +=	"</span>";
				return markup;
		   	}
		   
		   function FrxInstructionRawFileViewFormater(row, cell, value, columnDef, dataContext) {
		       
			   if(dataContext.instructionReferenceNo==null || $.trim(dataContext.instructionReferenceNo) == "" || $.trim(dataContext.actualTrx) != "Y"){
					return "<span>"+value+"</span>";
				}
				
			    //  Prepare the markup/ dynamically appended HTML tag
				var markup = "";
				
				var mode = "&mode=";
				
				var modeTitle="View Raw File ";
				
				if($.trim(dataContext.instructionType) == "MT202" || $.trim(dataContext.instructionType) == "MT210"){
					mode = mode + "MT2xx";
					if($.trim(dataContext.instructionType) == "MT202"){
						modeTitle = modeTitle + "(MT202)";
					}else{
						modeTitle = modeTitle + "(MT210)";
					}
					
				}else{
					mode = mode + "MT304";
					modeTitle = modeTitle + "(MT304)";
				}
				
		    	var	url= "/secure/frx/forexinstruction/query/rawinxdetails?inxReferenceNo=" + dataContext.instructionReferenceNo + mode + "&popup=true" + "'>";
		        markup +=  "<span>"+value+"</span>";
				markup +=  "<span class='detail-view-hyperlink popupIconBtn InstRefNo' ";
		        markup +=       "view='cpSsiDetailView' ";
		        markup +=       "title='" + modeTitle + "' ";
				markup +=       "dialogTitle='[" + value + "] " + xenos.title.frxInstructionRawFile + "'";
		        markup +=       "href='" + url;
		        markup += "</span>";

		        return markup;
		    }

		   //Formatter for negative number
		   function NegativeNumberFormatter(row, cell, value, columnDef, dataContext){	  
		 	if (value == null || value === "") {
		 	  return "";
		 	}	  
		 	  var sign =value.charAt(0);
		 	  if(typeof(sign) != 'undefined' && sign != null){
		 		  if ($.trim(sign) == '-') {
		 				return "<span style='color:red;font-weight:bold;'>" + value + "</span>";
		 			}else{			
		 				return "<span>" + value + "</span>";
		 			}
		 	  }
		 			  
		   }	 
		   
		 //Formatter for negative number
		   function FinalizedFlagFormatterRed(row, cell, value, columnDef, dataContext){	  
		 	if (value == null || value === "") {
		 	  return "";
		 	}	  
		 	  
		 	  if(typeof(value) != 'undefined' && value != null){
		 		  if ($.trim(value) == 'N') {
		 				return "<span style='color:red;font-weight:bold;'>No</span>";
		 			}else{			
		 				return "<span>" + value + "</span>";
		 			}
		 	  }
		 			  
		   }	


	  //Xns Ref No detail view Formatter
	  function IconFeedQueryFormatter(row, cell, value, columnDef, dataContext) {
			if (value == null || value === "") {
				return "";
			}
			var markup = "";
			if(dataContext.xnsTxnTable=="TRD_TRADE"){
				markup = ""
					+ "<span class='detail-view-hyperlink' "
					+       "view='tradeDetailView' "
					+       "referenceno='" + value + "' "
					+       "tradepk='" + dataContext.tradePk + "'"
					+       "referenceNo='" + dataContext.referenceNo + "'"
					+       "dialogTitle='[" + value + "] " + xenos.title.tradeDetail + "'"
					+       "href='/secure/trd/trade/details/" + dataContext.tradePk  + "/" + dataContext.referenceNo + "?diffEnableFlag=" + columnDef.isForAuth +"'>"
					+   value
					+ "</span>";
			}
			else if(dataContext.xnsTxnTable=="CAX_RIGHTS_DETAIL"){
				markup = ""
			        + "<span class='detail-view-hyperlink' "
			        +       "view='rightsDetailView' "
			        +       "rightsDetailPk='" + dataContext.rightsDetailPk + "' "
			        +       "dialogTitle='[" + value + "] " + xenos.title.entitlementsDetailTitle + "'"
			        +       "href='/secure/cax/entitlement/adjustment/details/" + dataContext.rightsDetailPk + "'>"
			        +   value
			        + "</span>";
			}
			else if(dataContext.xnsTxnTable=="FRX_FOREX_TRADE"){
				markup = ""
					+ "<span class='detail-view-hyperlink' "
					+       "view='frxTradeDetailView' "
					+       "dialogTitle='" + xenos.title.frxTradeDetail + "'"
					+       "href='/secure/frx/forex/trade/details/" + dataContext.frxTrdPk + "'>"
					+ 		value
					+ "</span>";
			}
			else if(dataContext.xnsTxnTable=="CAM_ENTRY"){
				markup = ""
					+ "<span class='detail-view-hyperlink' "
					+       "view='CamSecurityDetail' "
					+       "camEntryPk='" + dataContext.camEntryPk + "'"
					+       "dialogTitle='[" + value + "] " + xenos.title.camSecurityDetail + "'"
					+       "href='/secure/cam/securityi/details/" + dataContext.camEntryPk + "?popup=true'>"
					+   value
					+ "</span>";
			}
			else if(dataContext.xnsTxnTable=="BKG_BANKING_TRADE"){
				markup = ""
					+ "<span class='detail-view-hyperlink' "
					+       "view='bkgTradeDetailView' "
					+       "dialogTitle='" + xenos.title.bkgTradeDetail + "'"
					+       "href='/secure/bkg/banking/trade/details/" + dataContext.bankingTradePk + "'>"
					+ 		value
					+ "</span>";
			}
			else if(dataContext.xnsTxnTable=="NCM_ENTRY"){
				markup = ""
					+ "<span class='detail-view-hyperlink' "
					+       "dialog_Height='339'"
					+       "view='depositoryAdjustmentQueryDetailView' "
					+       "ncmEntryPk='" + dataContext.ncmEntryPk + "'"
					+       "dialogTitle='[" + value + "] " + xenos.title.depositoryAdjustmentDetail + "'"
					+       "href='/secure/ncm/depadjustment/details"+ "/" + dataContext.ncmEntryPk + "'>"
					+   value
					+ "</span>";
			}
			else if(dataContext.xnsTxnTable=="DRV_TRADE"){
				markup = ""
					+ "<span class='detail-view-hyperlink' "
					+       "view='drvTradeDetailView' "
					+       "dialogTitle='" + xenos.title.drvTradeDetail + "'"
					+       "href='/secure/drv/trade/details/" + dataContext.tradePk +"'>"
					+   value
					+ "</span>";
			}
			else if(dataContext.xnsTxnTable=="STL_DETAIL_HISTORY"){
				
				markup = ""
					+ "<span class='detailTxtVal detail-view-hyperlink' "
					+       "view='CompletionReasonDetailView' "
					+       "dialogTitle='[" + dataContext.xnsRefNo + "] Settlement History Details' "
					+       "href='/secure/stl/settlement/query/completionReasonDetails/" + dataContext.detailHistoryPk +"?popup=true&amp;From=Main'>"
					+   value
					+ "</span>";
			}
			else if(dataContext.xnsTxnTable=="STL_CLIENT_SETTLEMENT_INFO"){
				var commandFormId = $("[name='commandFormId']").val();
				
				markup = "<span class='detail-view-hyperlink' "
		        +       "view='settlementDetailView' "
		        +       "settlementreferenceno='" + value + "' "
		        +       "settlementinfopk='" + dataContext.settlementInfoPk + "' "
		        +       "dialogTitle='[" + value + "] " + xenos.title.settlementInfo + "' "
		        +       "href='/secure/stl/settlement/query/details/" + dataContext.settlementInfoPk+"/" + dataContext.settlementReferenceNo +"?pendingSubmission=" + dataContext.pendingSubmission 
		        +               "&viewType=" + dataContext.viewType + "&clientSettlementInfoPk=" + dataContext.clientSettlementInfoPk 
		        +               "&viewMode=Instruction&nettedFlag=true&diffEnableFlag=" + columnDef.isForAuth +"'>"
		        +   value
		        + "</span>";
			}
			else if(dataContext.xnsTxnTable=="DRV_MARGIN"){
				var markup = ""
				+ "<span class='detail-view-hyperlink' "
				+       "dialog_Height='350'"
				+       "view='marginEntryDetails' "
				+       "marginPk='" + dataContext.marginPk + "'"
				+       "tradeRefNo=''"
				+       "dialogTitle='" + xenos.title.drvMarginDetails + "'"
				+       "href='/secure/drv/margin/details" + "/" + dataContext.marginPk + "?tradeRefNo='>"
				+   value
				+ "</span>";
			}
			else if(dataContext.xnsTxnTable=="DRV_ACTION"){
				markup = ""
					+ "<span class='detail-view-hyperlink' "
					+       "view='drvTradeDetailView' "
					+       "dialogTitle='" + xenos.title.drvTradeDetail + "'"
					+       "href='/secure/drv/trade/details/" + dataContext.tradePk +"'>"
					+   value
					+ "</span>";
			}
			else{
				markup = "<span>"+value+"</span>";
			}
			
			return markup;
	  	}

	  
	  	function exerciseDateFormatter(row, cell, value, columnDef, dataContext) {
			value = value || "";
			var markup = ""
						+ 	"<span>"
						+ 		"<input name=" + columnDef.id  + " class='dateinput hasDatepicker' style='width:80px; height:20px; text-align:center;' type='text' value='"+value+"' rowIndex='"+row+"'>"
						+		"<button class='ui-datepicker-trigger' type='button'>"
						+			"<img src='"+xenos.context.path+"/images/namrui/icon/calendarIco.png' alt='' title=''>"
						+		"</button>"
						+	"</span>";
			return markup;
	  	}


	  function FrxInstructionTradeDetailViewFormatter(row, cell, value, columnDef, dataContext) {
		if (value == null || value === "") {
		  return "";
		}
		
		if(dataContext.instructionType=="MT304"){
			var markup = ""
			+ "<span class='detail-view-hyperlink' "
			+       "view='frxTradeDetailView' "
			+       "dialogTitle='" + xenos.title.frxTradeDetail + "'"
			+       "href='/secure/frx/forex/trade/details/" + dataContext.frxTrdPk + "'>"
			+ 		value
			+ "</span>";

			return markup;
		}else{
			return "<span>" + value + "</span>";
		}
		
	  }


	  	
		//Formatter for cam Security query 
		function CamAccruedCouponDetailFormater(row, cell, value, columnDef, dataContext) {
			if (value == null || value === "") {
				return "";
			}
			var markup = ""
			+ "<span class='detail-view-hyperlink' "
			+       "view='CamAccruedCouponDetails' "
			+       "bondAccruedInterestPk='" + dataContext.bondAccruedInterestPk + "'"
			+       "dialogTitle='[" + value + "] " + xenos.title.camAccruedCouponDetail + "'"
			+       "href='/secure/cam/accrued/query/details?bondAccruedInterestPk="+dataContext.bondAccruedInterestPk+"&InterestCcyPk="+dataContext.interestCcyPk+"&popup=true'>"
			+   value
			+ "</span>";

			return markup;
		}


		//Formatter for slr Trade details
		function SlrTradeDetails(row, cell, value, columnDef, dataContext) {
			if (value == null || value === "") {
				return "";
			}

			var markup = ""
				+ "<span class='detail-view-hyperlink' "
				+       "view='SlrTradeDetail' "
				+       "slrTradePk='" + dataContext.tradePk + "'"
				+       "dialogTitle='[" + value + "] " + xenos.title.slrTradeDetail + "'"
				+       "href='/secure/slr/stockborrowreturn/query/details?slrTradePk=" + dataContext.tradePk + "&popup=true'>"
				+   value
				+ "</span>";

			return markup;
		}  

		
		//Formatter for finalized flag without color
		   function FinalizedFlagFormatter(row, cell, value, columnDef, dataContext){	  
		 	if (value == null || value === "") {
		 	  return "";
		 	}	  
		 	  
		 	  if(typeof(value) != 'undefined' && value != null){
		 		  if ($.trim(value) == 'N') {
		 				return "<span>No</span>";
		 			}else{			
		 				return "<span>" + value + "</span>";
		 			}
		 	  }
		 			  
		   }	

	  	
			function imageViewFormatter(row, cell, value, columnDef, dataContext) {
		        //  Prepare the markup/ dynamically appended HTML tag
		        var markup = ""
		        + "<span class='detail-view-hyperlink popupIconBtn' "
		        +       "view='imageDetailView' "
		        +       "dialogTitle='" + xenos.title.imageView + "' "
				+       "dialog_Height='700'"
				+       "dialog_Width='1500'"
		        +       "title='" + columnDef.name + "' "
		        +       "href='/secure/rec/sec/rawfile/details/"+dataContext.gwySwiftPk+"?popup=true&fileType=" + dataContext.fileType + "'>"
		        +   "j"
		        + "</span>";

		        return markup;
		    }
			
			
			//Formatter for reference no in Ncm Authorization Adjustment  
			function NcmAuthAdjustmentQueryDetailViewFormatter(row, cell, value, columnDef, dataContext) {
				if (value == null || value === "") {
					return "";
				}
				
				var markup = "";
				
				if (dataContext.securityCode == ""){
					dataContext.ncmEntryPk = dataContext.ncmEntryPk;
					markup = NcmAdjustmentQueryDetailViewFormatter(row, cell, value, columnDef, dataContext);
				}
				else {
					dataContext.ncmEntryPk = dataContext.ncmEntryPk;
					markup = DepositoryAdjustmentFormater(row, cell, value, columnDef, dataContext);
				}
				return markup;	    
			}

			//Drv Instruction Raw file viewer
       function DrvInstructionRawFileViewFormater(row, cell, value, columnDef, dataContext) {
		       
			   if(dataContext.instructionRefNo==null || $.trim(dataContext.instructionRefNo) == "" || $.trim(dataContext.actualTrx) != "Y"){
					return "<span>"+value+"</span>";
				}
				
			    //  Prepare the markup/ dynamically appended HTML tag
				var markup = "";
				
				var mode = "&mode=";
				
				var modeTitle="View Raw File ";
				
				if($.trim(dataContext.instructionType) == "MT541" || $.trim(dataContext.instructionType) == "MT543"){
					mode = mode + "MT54x";
					if($.trim(dataContext.instructionType) == "MT541"){
						modeTitle = modeTitle + "(MT541)";
					}else{
						modeTitle = modeTitle + "(MT543)";
					}
					
				}
				
		    	var	url= "/secure/drv/drvinstruction/query/rawinxdetails?inxReferenceNo=" + dataContext.instructionRefNo + mode + "&popup=true" + "'>";
		        markup +=  "<span>"+value+"</span>";
				markup +=  "<span class='detail-view-hyperlink popupIconBtn InstRefNo' ";
		        markup +=       "view='cpSsiDetailView' ";
		        markup +=       "title='" + modeTitle + "' ";
				markup +=       "dialogTitle='[" + value + "] " + xenos.title.drvInstructionRawFile + "'";
		        markup +=       "href='" + url;
		        markup += "</span>";

		        return markup;
		    }
       
       //NDF Exchange Rate Amend
       function ExchangeRateFormatter(row, cell, value, columnDef, dataContext) {
			value = value || "";
			var markup = "";
			markup += 	"<span>"
			markup +=  "<input name=" + columnDef.id  + " class='editablGridInput exchangeRateEdit' style='width:"+(columnDef.width - 5)+"px;  text-align:right;' readonly='true' type='text' value='"+value+"' rowIndex='"+row+"' ";
			markup += ">";
			markup +=	"</span>";
			return markup;
       }
       
       
       function NdfAmendDateFormatter(row, cell, value, columnDef, dataContext) {
    		value = value || "";
    		var markup = ""
    					+ 	"<span>"
    					+ 		"<input name=" + columnDef.id  + " class='dateinput hasDatepicker' style='width:80px; height:20px; text-align:center;' type='text' value='"+value+"' rowIndex='"+row+"'>"
    					+		"<button class='ui-datepicker-trigger' type='button'>"
    					+			"<img src='"+xenos.context.path+"/images/namrui/icon/calendarIco.png' alt='' title=''>"
    					+		"</button>"
    					+	"</span>";
    		return markup;
       }
    	              
   //TDBalanceDRVFutureBalanceViewFormatter
   function TDBalanceDRVFutureBalanceViewFormatter(row, cell, value, columnDef, dataContext) {
		  if (value == null || value === "") {
	          return "";
	        }
			if(dataContext.securityType=="DRV-Security"){
			var markup = ""
	            + "<span class='detail-view-hyperlink' "
				+       "dialog_Height='350'"
	            +       "view='tdBalanceDetailView' "
	            +       "dialogTitle='" +xenos.title.tdbalanceBalance+ "'"
	            +       "href='/secure/nam/tdbalance/details/"+ dataContext.fundPk +"?fundCode="+dataContext.fundCode+"&totalBalance="+dataContext.balance+"&date="+dataContext.date+"&balanceType=DRV Future&baseCcy="+dataContext.baseCcy+"&securityCode="+dataContext.securityId+"&dataSource="+dataContext.dataSource + "'>"
	            +       value
	            + "</span>";
	        return markup;
			}
			else{
				return "<span>" + value + "</span>";
			}		
	  }  

     //TDBalanceReceivableViewFormatter
	function TDBalanceReceivableViewFormatter(row, cell, value, columnDef, dataContext) {
		  if (value == null || value === "") {
	          return "";
	        }
			if(value!="0" && dataContext.securityType=="CCY"){
			var markup = ""
	            + "<span class='detail-view-hyperlink' "
				+       "dialog_Height='350'"
	            +       "view='tdBalanceDetailView' "
	            +       "dialogTitle='" +xenos.title.tdbalanceReceivable+ "'"
	            +       "href='/secure/nam/tdbalance/details/"+ dataContext.fundPk +"?fundCode="+dataContext.fundCode+"&totalBalance="+dataContext.receivableBalance+"&date="+dataContext.date+"&balanceType=Receivable&baseCcy="+dataContext.baseCcy+"&securityCode="+dataContext.securityId+"&dataSource="+dataContext.dataSource + "'>"
	            +       value
	            + "</span>";
	        return markup;
			}
			else{
				return "<span>" + value + "</span>";
			}		
	  }  

	//TDBalancePayableViewFormatter
	function TDBalancePayableViewFormatter(row, cell, value, columnDef, dataContext) {
		if (value == null || value === "") {
		return "";
		}
		if(value!="0" && dataContext.securityType=="CCY"){
		var markup = ""
         + "<span class='detail-view-hyperlink' "
		 +       "dialog_Height='350'"
         +       "view='tdBalanceDetailView' "
         +       "dialogTitle='" +xenos.title.tdbalancePayable+ "'"
         +       "href='/secure/nam/tdbalance/details/"+ dataContext.fundPk +"?fundCode="+dataContext.fundCode+"&totalBalance="+dataContext.payableBalance+"&date="+dataContext.date+"&balanceType=Payable&baseCcy="+dataContext.baseCcy+"&securityCode="+dataContext.securityId+"&dataSource="+dataContext.dataSource + "'>"
         +       value
         + "</span>";
		return markup;
		}
		else{
			return "<span>" + value + "</span>";
		}		
	}	
			
})(jQuery);