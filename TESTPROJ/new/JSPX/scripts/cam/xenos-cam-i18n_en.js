//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos$CAM$i18n = {
  required_fields_empty_alert : 'Some modified data has not yet been saved, Do you want to continue?',		
  cashin: {
			inouttransfer_empty 			: 'Cash In/Out/Transfer can not be empty',
			currency_empty					: 'Currency can not be empty',
			amount_empty					: 'Amount can not be empty',
			amount_zero						: 'Amount can not be Zero',
			amount_cant_negative			: 'Please enter a valid value for Amount',
			taxincometype_empty				: 'Tax Income Type can not be empty',
			wayofsettlement_empty			: 'Way Of Settlement can not be empty',
			mode_empty						: 'Mode can not be empty',
			cashindate_empty				: 'Cash In Date can not be empty',
			cashoutdate_empty				: 'Cash Out Date can not be empty',
			account_number_empty			: 'Account Number can not be empty',
			account_balance_type_empty		: 'Account Balance Type can not be empty',
			gle_ledger_code_empty			: 'GLE Ledger Code can not be empty',
			other_gle_ledger_code_empty		: 'Other GLE Ledger Code can not be empty',
			missing_accountno				: 'Enter Account Number'
 },
 transQ: {
	 	enter_fundCode : 'Please enter Fund Code.',
		enter_accno : 'Enter Account No.',
		security_currency : 'Either Security or Currency should be entered.',
		security_currency_both : 'Security and Currency cannot be entered together.',
		enter_fromdate : 'Enter the From Date',
		daterange_invalid     :'From Date should be less than To Date.',
		enter_todate : 'Enter the To Date',
		date_format_check : 'Illegal date format ',
		invalid_todate : 'Invalid To Date.',
		invalid_fromdate : 'Invalid From Date.',
		daterange_empty : 'Please enter both From and To date.'
		
 },
 movementquery:{
		validation:{
		datefrom_invalid  :'Invalid From Date',
		dateto_invalid	  :'Invalid To Date',
		date_empty		  :'Please enter both From and To date',
		datefrom_less     :'From Date should be less than To Date',
		movementbasis_empty:'Movement Basis cannot be empty',
		lastdate_invalid  :'Invalid Last Entry Date.',
		date_format_check : 'Illegal date format ',
		}
	},
	
 cashIOAuth:{
			  no_record_select_reject        : 'No Record selected for Rejection',
			  no_record_select_authorize     : 'No Record selected for Authorization',
			  rejected_record_reject         : 'Rejected Record(s) cannot be Rejected Again',
			  rejected_record_authorize      : 'Rejected Record(s) cannot be Authorized',
			  authorized_records             : 'Authorized record(s) cannot be further authorized.',
		      no_record_for_authorization    : 'Authorized record(s) cannot be rejected.'
 },
 secIO:{
			inout_empty 			: 'Security In/Out can not be empty',
			secindate_empty			: 'Security In Date can not be empty',
			secindate_empty_new		: 'Security In Date is Missing',
			secoutdate_empty		: 'Security Out Date can not be empty',
			secoutdate_empty_new	: 'Security Out Date is Missing',
			seccode_empty			: 'Security Code can not be empty',
			seccode_empty_new		: 'Security Code is Missing',
			quantity_empty			: 'Quantity can not be empty',
			quantity_empty_new		: 'Quantity is Missing',
			cutodianbank_empty		: 'Custody Bank can not be empty',
			cutodianbank_empty_new	: 'Custodian Bank is Missing',
			oursettleac_empty		: 'Our settle A/C can not be empty',
			oursettleac_empty_new	: 'Our settle A/C is Missing',
			bookvalue_empty			: 'Book Value can not be empty',
			bookvalue_empty_new		: 'Book Value(LC) is Missing',
			accountno_empty			: 'Account No. can not be empty',
			accountno_empty_new		: 'Fund Account No is Missing',
			accountno_empty_new		: 'Fund Account No is Missing',
			date_format_check	    : 'Illegal date format',
			reason_empty_new		: 'Reason Code is Missing',
			spot_bookvalueBc_new	: 'Book Value BC should be given if Spot calculation Date is specified',
			accountbaltype_empty	: 'Account balance type can not be empty',
			quantity_negative_new	: 'Quantity cannot be negative',
			bookValueLc_negative_new: 'Book Value cannot be negative',
			bookValueBc_negative_new: 'BC Book Value cannot be negative',
			accruedInterestPaidLc_negative_new: 'Accrued Inst paid cannot be negative',
			accruedInterestPaidBc_negative_new: 'BC Accrued Inst paid cannot be negative',
			quantity_valid_value	: 'Please enter a valid value for Quantity',
			accruedInstLc_valid_value	: 'Please enter a valid value for Accrued Int paid',
			accruedInstBc_valid_value	: 'Please enter a valid value for BC Accrued Int paid',
			bookValueLc_valid_value	: 'Please enter a valid value for Book Value',
			bookValueBc_valid_value	: 'Please enter a valid value for BC Book Value',
			quantity_moreThan15_new : '15 digits are allowed before decimal point',
			quantity_moreThan3_new	: '3 digits are allowed after decimal point'

},
secIOAuth:{
			  no_record_select_reject        : 'No Record selected for Rejection',
			  no_record_select_authorize     : 'No Record selected for Authorization',
			  rejected_record_reject         : 'Rejected Record(s) cannot be Rejected Again',
			  rejected_record_authorize      : 'Rejected Record(s) cannot be Authorized',
			  authorized_records             : 'Authorized record(s) cannot be further authorized.',
		      no_record_for_authorization    : 'Authorized record(s) cannot be rejected.'
 },
securityQuery:{
	  		daterange_empty			:	'Please enter both Security From and Security To Date.',
	  		datefrom_empty			:	'Security Date From Field cannot be empty',
	  		dateto_empty			:	'Security Date To Field cannot be empty',
			date_format_check 		: 	'Illegal date format {0}',
			date_from_to_check 		: 	'From Date should be less than To Date.'
},
portfolioBalanceQuery:{
			date_empty				: 'Please enter Date.',
			invalid_date			: 'Invalid Date.',
			date_format_check		: 'Illegal date format {0}'
			
},
balanceQuery:{
			basedate_empty			:	'Please enter Date.',
			basedate_format_check	:	'Invalid Date.',
			date_format_check 		: 	'Illegal date format {0}',
			empty_balance_basis 	: 	'Please Select Balance Basis.'

},
unrealizedPlQuery:{
	basedate_format_check	:	'Invalid Base Date.',
	date_format_check 		: 	'Illegal date format {0}',
	empty_balance_basis 	: 	'Please Select Balance Basis.'

},
securityUpload:{
		validation:{
			cannotBeBlank: 'Security File cannot be blank.',
			invalidFileType: 'Invalid file type. Try uploading .xls or .xlsx'
		}
	},
ageAnalysisQuery:{
	validation:{
		cannotBeBlank_Currency: 'Currency cannot be blank.',
		cannotBeBlank_overDue1: 'Day Range1 cannot be blank.',
		cannotBeBlank_overDue2: 'Day Range2 cannot be blank.',
        cannotBeBlank_overDue3: 'Day Range3 cannot be blank.',  
        cannotBeBlank_overDue4: 'Day Range4 cannot be blank',
		exposureFromAmoutVs_ToAmount:   'Exposure(%) Range should be in increase order',
		outStandingAmount_neg :  'OutStanding Amount can not be Negative',
		dayrange_neg 		:  'Day Range can not be Negative',
		dayrange_float		: 'Day Range should not have Decimal Point',
		dayrange_invalid 	: 'Day Range allows 0-9 only',
		dayrange4_Blank 	    : 'Day Range4 can not be blank',
		dayrange5_Blank 	    : 'Day Range5 can not be blank',		
		dayrange4_and5Blank 	: 'Day Range4 and day Range5 can not be blank',
		brokeraccount_blank 	: 'Broker Account can not be blank for Custodian Account'		
	}
},
cashAccrual:{
	common:{
		ccy_empty		:	'Currency cannot be blank.',
		debit_credit    :   'Debit/Credit Flag can not be blank.',
		accountNo_empty	:	'Account No cannot be blank.',
		offsetRate_empty:	'Offset Rate cannot be blank.',
		fromDate_empty	:	'From Date cannot be blank.',
		baseRate_empty	:	'Base Rate(%) cannot be blank.'
	},
	specialPosting :{
		no_record_selected	: 'No record selected for Special Posting.'
	},
	minamount : {
		fromDate_empty : 'From Date can not be empty',
		currency_empty : 'Currency can not be empty',
		minimumAmount_empty : 'Minimum Amount can not be empty',
		minimumAmount_invalid : 'Invalid Minimum Amount specified',
		debitCredit_empty : 'Debit/Credit can not be empty'
	}
},
camAllocationDeallocation:{
	no_record_selected :'No record selected for Allocation/De-Allocation.',
	transferQtyAmtInvalid :'Transfer Qty/Amount should be greater than 0 for Account No [{0}] and Security Code [{1}].',
	transferQtyAmt_empty :'Transfer Qty/Amount cannot be empty for Account No [{0}] and Security Code [{1}].',
	transferQtyAmt_NaN   :'Please enter a valid value for Transfer Qty/Amount for Account No [{0}] and Security Code [{1}].',
	plegedWith_empty : 'Pleged With cannot be empty for Account No [{0}] and Security Code [{1}].',
	fromBankAccount_empty: 'From Bank Account cannot be empty for Account No [{0}] and Security Code [{1}].',
	toBankAccount_empty: 'To Bank Account cannot be empty for Account No [{0}] and Security Code [{1}].',
	transferQtyAmtGreaterThanAvailableBalance : 'Transfer Qty/Amount specified is greater than Available Balance for Account No [{0}] and Security Code [{1}].',
	instrumenttype_empty:'Instrument Type cannot be empty.',
    fromAccountNo_empty: 'From Account No cannot be empty.',
    toAccountNo_empty: 'To Account No cannot be empty.'
},
camAccruedCashInterest:{
	interestperiodfromdate_empty:'Interest Period From Date cannot be empty.'
},
camAccruedCashMinAmtQuery:{
	fromDate_empty : 'From Date cannot be empty.'
},
earlyCreditEntry:{
			date_empty 				: 'Date can not be empty',
			ccy_empty				: 'Currency can not be empty',
			accountNo_empty			: 'Account No can not be empty',
			interestRate_empty		: 'Interest Rate can not be empty',
			interestChargedOn_empty : 'Interest Charged On can not be empty',
			paymentRequest_empty    : 'Payment Request can not be empty'

 },
 riskManagementQuery:{
		validation:{
			ccy_empty: 'Currency can not be empty'			
		}
	},
earlyCreditAuth:{
	 no_record_select_reject        : 'No Record selected for Rejection',
	 no_record_select_authorize     : 'No Record selected for Authorization',
	 rejected_record_reject         : 'Rejected Record(s) cannot be Rejected Again',
	 rejected_record_authorize      : 'Rejected Record(s) cannot be Authorized',
	 authorized_records             : 'Authorized record(s) cannot be further authorized.',
	 no_record_for_authorization    : 'Authorized record(s) cannot be rejected.'
 },
accruedCouponQuery:{			
			date_format_check		: 'Illegal date format {0}'			
}
};