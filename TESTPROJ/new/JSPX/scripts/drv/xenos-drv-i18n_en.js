//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos$DRV$i18n = {
    derivativeTrade:{
		entry : {
			security_code_empty 		: 'Security Code is Missing',
			open_close_pos_empty 		: 'Open Close Position is Missing',
			trade_date_empty 			: 'Trade Date is Missing',
			fund_account_empty 			: 'Fund Account No is Missing',
			exe_broker_acct_empty 		: 'Execution Broker Account No is Missing',
			broker_account_empty 		: 'Broker Account No is Missing',
			price_empty 				: 'Price is Missing',
			price_invalid 				: 'Please enter a valid value for Price',
			quantity_empty 				: 'Quantity is Missing',
			quantity_invalid 			: 'Please enter a valid value for Quantity',
			taxfee_id_empty  			: 'Select a Tax Fee Id',
			taxfee_amt_empty 			: 'Tax Fee Amount is missing',
			base_date_empty  			: 'Base Date should not be blank',
			margin_type_empty 			: 'Margin Type should not be blank',
			margin_amt_empty 			: 'Margin Amount is Missing',
		    date_format_check 			: 'Illegal date format {0}'
		},
		query : {
			date_from_to_check_trade : 'Trade From Date should be less than Trade To Date.',
			date_from_to_check_value : 'Value From Date should be less than Value To Date.',
			date_format_check_trdDateFrom : 'Invalid Trade Date From',
			date_format_check_trdDateTo : 'Invalid Trade Date To',
			date_format_check_valueDateFrom : 'Invalid Value Date From',
			date_format_check_valueDateTo : 'Invalid Value Date To'
		}
		
	},
	unrealizedPLQuery:{
		validation : {
			date_blank : 'Please enter Base Date',
			date_format_check : 'Invalid Base Date'
		}
	},
	drvMarginQuery:{
		date_from_to_check : 'Trade Date From should be less than Trade Date To.',
		fromdate_format_check  : 'Invalid Trade Date From.',
		todate_format_check : 'Invalid Trade Date To.',
		date_format_check : 'Invalid Base Date'
	},
	marginEntry:{
		entry : {
		    trade_refNo_empty : 'Trade Reference No is Missing',
		    margin_amt_empty : 'Margin Amount is Missing',
			date_blank : 'Base Date is Missing',
			date_format_check : 'Invalid Base Date'
		}
	},
	drvTradeExcelUpload:{
		validation: {
			cannotbeblank: 'Derivative File cannot be blank.',
			invalidfiletype: 'Invalid file type. Try uploading .xls or .xlsx.',
			maxfilesize: 'Selected File Size is Over Allowed Limit ({0} bytes). Please select Another File!'
		}
	},
    drvInstructionQuery:{
		date_from_to_check : 'From Date should be less than To Date.',
		date_format_check : 'Illegal date format {0}',
		missing_date: 'Any one of those dates(Trade Date, Value Date, Transmission Date) must be provided'
		}
};
