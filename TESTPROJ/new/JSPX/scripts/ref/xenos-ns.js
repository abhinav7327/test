//$Id$
//$Author: dambarc $
//$Date: 2016-12-27 19:42:28 $
//
// xenos
//  - ns
//
xenos.ns = {
    views:{
        //TradeQueryResult
        trdresult:{},
        camQryResult:{},
        authQryResult:{},
		accAuthQryResult:{},
        tradeAuthQryResult:{},
        //Instrument Authorization Query Result
        instAuthQryResult:{},
		//exchange rate query
		refExchangeRateQuery:{},
		stlCompletionSummaryQuery:{},
		exchangeRateAuthQryResult:{},
        //Cam Transaction Query
        camTranQry:{},
        //Cam Movement Query
        camMovementQry:{},
		empAuthQryResult:{},
		//Cam Security Query
		secQuery:{},
		//Cam Balance Query
		balanceQuery:{},
		//Unrealized Pl Query
		unrealizedPlQuery:{},
		//SSI Authorization Query Result
        ssiAuthQryResult:{},
		//Account Document Query Result
        accountDocQuery:{},
		//NCM Balance Query
		ncmBalanceQry :{},
		//SRS Balance Query
		srsBalanceQry :{},
		//For Stl Query
		stlQuery:{},
		//For Srs Movement Query
		srsMovementQry:{},
		//FinInst Authorization Query Result
        fininstAuthQryResult:{},
        //Market Price Authorization Query Result
        marketPriceAuthQryResult:{},
        //ApplicationRole Authorization Query Result
        appRoleAuthQryResult:{},
		//For STL Bulk Amendment Query 
		stlBulkAmendmentQuery:{},
        //Id Conf Rule Authorization Query Result
        idConfRuleAuthQryResult:{},
        //Trade Feed Authorization
        tradeFeedAuthQryResult:{},
		//Strategy Auth Query Result
		strategyAuthQryResult:{},
		//SRS Balance Query By Custodian
        srsCustodianBalQry:{},
		//Document Action Query Result
		docActionAuthQryResult:{},
        //Own SSI Authorization Query Result
        ownSsiAuthQryResult:{},
        //Grouping Authorization Query Result
        groupingAuthQryResult:{},
        //Gle Transaction Query
		gleTranQry:{},
		//Gle Journal Query
        gleJournalQry:{},
        //Customer Authorization Query Result
        custAuthQryResult:{},
        //Collateral Authorization Query Result
        collateralAuthQryResult:{},
        //Haircut Authorization Query Result
        haircutAuthQryResult:{},
        //Asset management Authorization Query Result
        assetMgmtAuthQryResult:{},
		//For TRD Banking Query
		bkgQuery:{},
		//For Access Log Query
		accessLogQuery:{},
		//For TRD Summary Query
		tradeSummaryQuery:{},
		//For Trade Query
		trdQuery:{},
		//For FRX Trade Query
		frxTradeQuery:{},
		//For Commission Query
		commissionQuery:{},		
		//Txn report Query
		txnReportQuery:{},
		//For Financial Institution Query
		fininstQuery:{},
		//For Employee Query
		empQuery:{},
		//Event Query 
		caxEventQuery:{},
		//For Entitlement Generation
		entitlementGenerationQuery: {},
		//NCM Transaction Query
		ncmTxnQuery:{},
		//Cax Query
		rightsDetailQueryCriteria:{},
		//Cp ssi Query
		cpssiQuery:{},
		// Ncm Balance Query
		balanceQuery:{},
		//CashTransferQuery
		cashTransferQuery:{},
		//unrealizedPLQuery
		unrealizedPLQuery:{},
		//RightsExerciseQuery
		rightsExerciseQuery : {},
		//NdfExchangeRateQuery
		ndfExchangeRateQuery:{},
		//tradeMatchingQuery
		trdCnfReadOnlyQuery:{},
		//Gle Voucher Query
		gleVoucherQuery:{},
		//Gle Balance Query
		gleBalanceQry:{},
		//depositoryAdjustmentQueryCriteria
		depositoryAdjustmentQueryCriteria:{},
		//AccountQuery
		accountQuery:{},				
		//PortfolioBalanceQuery
		portBalanceQuery:{},
		//BankTransferQuery
		bankTransferQuery :{},
		//CashTransferauthorizationQuery
		cashTransferAuthorizationQuery:{},
		//Frx Fund Base Revaluation Query
		frxFundRvlQuery:{},
		//Exchange Rate Query
		exchangeRateQuery:{},
		//Cross Exchange Rate Query
		crossExchangeRateQuery:{},
		//Per Security Status Query
		perSecurityStatusQuery:{},
		//drv Margin Query
		drvMarginQueryCriteria:{},
		// derivative closeout query
		drvCloseoutQueryCriteria:{},
		accountQuery:{},
		//Drv Trade Query
		drvTradeQuery:{},
		//FRX Instruction Query
		frxInstructionQuery : {},
		//ICN Feed Query
		icnFeedQuery : {},
		//slr Stock Borrow Return query
		stockBorrowReturn:{},
		//Reset Finalized Flag Query
		resetFinalizedFlagQuery:{},
		//Security Raw File Recon Qry
		secRecRawFileQuery:{},
		//Batch status Query
		batchStatusQuery:{},
		//Gle NAV Query
		gleNavQuery:{},
		//Online Report exec Status Query
		onlineReportExecStatusQuery:{},
		//Completion Query
		completionQuery:{},		
		//CAM Accrued Coupon Query
		accruedCouponQuery:{},
		//For Stl Instruction
		stlInxQuery:{},
        //DRV Instruction Query
		drvInstructionQuery : {},
		//Stock Borrow Return Trade Entry
		borrowReturnEntry : {},
		//Validator for Ncm Authorization
		ncmAuthorizationQueryValidator:{},
		//For TXn Detail Query
		txnDetailQuery : {},
		//NCM Cash Projection Summary Query 
		ncmCashProjectionSummaryQuery:{},
		//validator for cash transfer entry
		cashTransferEntry:{},

		//Validator for Completion Authorization
		completion:{},
		// drv closeout entry
		closeoutEntry:{},
		// margin entry
		marginEntry:{},
		// drv closeout cancel
		closeoutCancel:{},
		//Cam Security Entry
		camSecurityIoEntry : {},
		//Inst Entry Amend Cancel
		instrumentEntryAmend:{},
		//Derivative Trade Entry Amend
		derivativeTradeEntry : {},
		//For FRX Trade Entry
		frxTradeEntry:{},
		//Fund Configuration Amend
		namFundConfigQuery:{},
		//TD Balance Query
		tdBalanceQuery:{},

		//ncm cash projection query
		ncmProjectionQuery:{}


    },
    popup : {
		closeHandler : function(e){return {}}
	},
    ssipopup:{
        populateSecSSIReq : function(){return {}},
        populateCashSSIReq : function(){return {}}
    },
    cpOwnSSIPopup: {
		populateSecSSIReq : function(){return {}},
        populateCashSSIReq : function(){return {}},
        populatePaymentSSIReq : function(e){return {}}
    },
    ownSSIPopup: {
    	stlAmendSecOwnSSIReq : function(){return {}},
    	stlAmendCashOwnSSIReq : function(){return {}},
		stlWireInxCashOwnSSIReq : function(){return {}},
		stlBulkAmendSecOwnSSIReq : function(){return {}},
		stlBulkAmendCashOwnSSIReq : function(){return {}}
    },
    stlcompletion:{
        dateCopyHandler : function(e){}
    },
    stlcompletionResult:{
        stlDateArray :[]
    },
    stlFinalization:{
        entry:{},
        authorization:{},
		cancel:{}
    },
	stlPairoff:{
		entry:{},
		cancel:{},
		validateSubmit:{},
		authorization:{}
	},
	stlBulkAmend:{
    },
    camCashIO:{
        authorization:{}
    },
	camSecurityIO:{
        authorization:{}
    },
    ncmNostroAuth:{
        authorization:{}
    },
    depositoryAdjustment:{
        authorization:{}
    },
    srsVocherAuth:{
    	authorization:{}
    },
	stlAmendment:{
		securityTrade:{},
		authorization:{}
	},
	ssiEntry:{
		populateDtcChain:{}
	},
    ssiUpload:{
        entry:{
            warningMsg:""
        }
    },
    stlWireInstruction:{
    	authorization:{}
    },
	stlWithHold:{
		withHold:{}
	},
    stlSplitAuth:{
        authorization:{}
    },
    gleVocherAuth:{
    	authorization:{}
    },
    stlAuthorization: {
    },
    stlPayment:{
		entry:{},
		update:{}
	},
	camAllocationDeallocation:{
		
	},
	paymentResult:{
		stlUpdDateArray:[],
		chequeNoArray:[],
		chequeStatusTypeArray: []
	},
	trdBulkAmend:{
	},
	cashAccrual:{
		specialPosting :{}
	},
	emailNotificationSendResend:{
	},
	camAllocationDeAllocation:{
        authorization:{}
    },
	rightsExercise:{
        authorization:{}
    },
    gleCashAuth:{
    	authorization:{}
    },
    gleLedgerAuth:{
    	authorization:{}
    },
	filterHiddenTgt: {},
	rightsCondition:{
    	authorization:{}
    },
    rightsDetail:{
    	authorization:{}
    },
    clientPayment:{
		authorization:{}
	},
	earlyCredit:{
        authorization:{}
    },
	marketPrice :{
		validation:{}
    },
    ownSettleStanding : {
		onChangeCounterPartyType : function(e){}
	},

	trdCnfAllocCxl : {
		submithandler : function(e){},
		backhandler : function(e){},
		confirmhandler : function(e){},
		selectedRecordsIndex : {},
		selectForConfirm : {}
	},
	//Rights Exercise Amend
	rightsExerciseAmend:{
		bachtoqueryhandler:function(e){},
		calculateTakeUpCost :function(e,args){},
		selectedRecordsIndex : {},
		submithandler:function(e){},
		resethandler:function(e) {},
		confirmhandler:function(e){},
		okhandler : function(e){},
		backtoresulthandler:function(e){}
		
	},
	rightsExerciseCancel:{
		selectedData : {},
		submithandler:function(e){},
		resethandler:function(e) {},
		confirmhandler:function(e){},
		backtoqueryresulthandler:function(e){},	
		backFromOkHandler: function(e){}
		},

	//Reset Finalized Flag
	resetFinalizedFlag:{
		submithandler:function(e){},
		resethandler:function(e) {},
		confirmhandler:function(e){},
		backtoresulthandler:function(e){},
		bachtoqueryhandler:function(e){}
		
	},

	completionCancelUserConf:{
		submithandler:function(e){},
		confirmhandler:function(e){},
		backhandler : function(e){},
		okhandler : function(e){},
		selectedRecordsIndex:{}
	},

	
	trdReject : {
		submithandler : function(e){},
		confirmhandler : function(e){},
	},
	
	trdMatch : {
		submithandler : function(e){},
		confirmhandler : function(e){},
		finalhandler : function(e){},
		okhandler : function(e){},
		backhandler : function(e){},
		UCbackhandler : function(e){},
	},
	
	trdUnmatch : {
		submithandler : function(e){},
		confirmhandler : function(e){},
	},
	
	ndfExchangeAmend:{
		selectedData   : {},
		submithandler  : function(e){},
		resethandler   : function(e){},
		confirmhandler : function(e){},
	    okhandler 	   : function(e){},
		backhandler    : function(e){}
	},
	
	secRecRawFileQry :{
		validateRawFileQryFields : function(){},
		formatRcvDateFrom : function(){},
		formatRcvDateTo : function(){}
		
	},

	entitlement:{
		adjustmentEntry:{
			onChangeRateType	: function(e){}
		},
		amend : {
			validateSubmitEntitlementAmend : function(e){},
			editableAllotSec : function(e){},
			loadCashPart : function(e){},
			loadStockPart : function(e){},
			loadOthersEventPart : function(e){},
			validateTaxFeeAttributes : function(e){},
			calculateHandler : function(e){},
			updateCalculatedFields : function(e){},
			taxAmountCalculateHandler : function(e){},
			updateCalculatedTaxFeeFields : function(e){},
			onChangeRateType : function(e){},
			loadOthersEventPartConfirm : function(e){},
			loadStockPartConfirm : function(e){},
			loadCashPartConfirm : function(e){}
		}
	},
	
	cax:{
		eventEntry : {
			validateCashDividend : function(e){},
			validateBonusIssue : function(e){},
			validateStockEventsEntry : function(e){},
			validateCouponPaymentEntry : function(e){},
			validateCommonPart : function(e){},
			validateStockMergerEntry : function(e){},
			validateStockMergerSubmit : function(e){},
			validateRightsIssue : function(e){},
			validateRedemptionBond : function(e){},
			validateStockCashOption : function(e){},
			validateOthers : function(e){},
			disableFieldsForAmend : function(e){},
			enableFieldsForAmend : function(e){}
		}
	}
}