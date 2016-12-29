//$Id$
//$Author: Debojyoti Mukherjee $
//$Date: 2016-12-23 20:08:10 $
xenos$FRX$i18n = {
	frxTradeQuery:{
		date_from_to_check : 'From Date should be less than To Date.',
		date_format_check  : 'Illegal date format {0}'
	},
	
	frxEntry:{
			mandatory :{	
				fund_acc_empty 			: 'Fund Account No is Missing',
				counter_acc_empty 		: 'CounterParty Account No is Missing',
				trade_date_empty 		: 'Trade Date is Missing',
				value_date_empty 		: 'Value Date is Missing',
				buy_ccy_empty 			: 'Buy Currency is Missing' ,
				sell_ccy_empty 			: 'Sell Currency is Missing',
				buy_amt_empty 			: 'Buy Currency Amount is Missing',
				exchange_empty 			: 'Exchange Rate is Missing',	
				calcMechanism_empty 	: 'As Rate is specified then Calculation Mechanism must be specified',
				buy_sell_empty_check 	: 'Any two of Buy Ccy Amount, Sell Ccy Amount & Exchange Rate must be entered'
		},
	
		dateTime : {
				trade_date_format 			: 	'Illegal Trade Date Format {0}',
				value_date_format 			: 	'Illegal Value Date Format {0}',
				compare_date 				: 	'Trade date should not be greater than Value Date',
				invalid_eight 				: 	'INVALID ENTRY. 8 character entry should be in the format hh:mm:ss',
				invalid_six 				:	'INVALID ENTRY. 6 character entry should be numeric and in the format hhmmss',
				invalid_five				:	'INVALID ENTRY. 5 character entry should be in the format hh:mm',
				invalid_four				:	'INVALID ENTRY. 4 character entry should be numeric and in the format hhmm',
				error						:	'INVALID ENTRY. Valid time format is hh:mm:ss or hhmmss or hh:mm or hhmm',
				nonnumeric_hour				:	'NOT VALID: HH contains non-numeric values',
				notvalid_hour				:	'NOT VALID: Hours should be less than 24',
				nonnumeric_minute			:	'NOT VALID: MM contains non-numeric values',
				notvalid_minute				:	'NOT VALID: Minutes should be less than 60',
				nonnumeric_second			:	'NOT VALID: SS contains non-numeric values',
				notvalid_second				:	'NOT VALID: Seconds should be less than 60',
				spot_date_format 			: 	'Illegal NDF Close Date Format {0}'			
		},
		
		general :{
				buyAmount  : 'Buy Ccy Amount',
				sellAmount : 'Sell Ccy Amount'
		}		
	},
	
	frxAmend:{
		validation :{	
			buySell_S : 'Transaction cannot be amended for NDF Trade if Buy Sell Flag = S',
			buySell_B : 'Settlement Ccy must be equal to Sell Ccy for NDF Trade if Buy Sell Flag = B'
		}
	},
	
	frxExecutionExcelUpload:{
		validation: {
			cannotbeblank	: 'Forex Execution File cannot be blank.',
			invalidfiletype	: 'Invalid file type. Try uploading .xls or .xlsx.',
			maxfilesize		: 'Selected File Size is Over Allowed Limit ({0} bytes). Please select Another File!'
		}
	},
	
	frxNdfExchangeRateExcelUpload:{
		validation: {
			cannotbeblank: 'NDF Revaluation Exchange Rate File cannot be blank.',
			invalidfiletype: 'Invalid file type. Try uploading .xls or .xlsx.',
			maxfilesize: 'Selected File Size is Over Allowed Limit ({0} bytes). Please select Another File!'
		}
	},

	frxFundRvlQuery:{
		validation: {
			base_date_empty 		: 'Please enter a valid Base Date.',
			date_invalid			: 'Illegal date format {0}'
		}
	},
	
	frxInstructionQuery:{
		date_from_to_check : 'From Date should be less than To Date.',
		date_format_check : 'Illegal date format{0}',
		missing_date: 'Any one of those dates(Trade Date, Value Date, Transmission Date) must be provided'
	},
	settlement_details_info : 'Settlement Query Result Summary',
	
	ndfExchangeRateAmend:{
		basedate_empty : 'Base Date cannot be blank',
		exchangerate_empty : 'Exchange Rate cannot be blank',
		exchangerate_zero : 'Exchange Rate cannot be zero',
		exchangerate_invalid : 'Please enter a valid value for Exchange Rate',
		valid_before_decimal : '10 digits are allowed before decimal point',
		valid_after_decimal : '10 digits are allowed after decimal point'
	}
 };