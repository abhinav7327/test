//$Id$
//$Author: nitesha $
//$Date: 2016-12-23 17:22:58 $
xenos$TRD$i18n = {
	tradeSummaryQuery:{
		date_from_to_check : 'From Date should be less than or equal to To Date',
		minimum_criteria : 'Please enter at least two criteria',
		date_format_check : 'Illegal date format {0}'
	},
	tradeQuery:{
		date_from_to_check : 'From Date should be less than To Date.',		
		date_format_check : 'Illegal date format {0}'
	},
	  tradeEntry: {
			
			generalinfo : {
				tradedate_empty 	       : 	'Trade Date is Missing',
				buysellflag_empty 	       : 	'Buy/Sell is Missing',
				accountno_empty		       :	'Broker Account No is Missing',
				inventory_empty		       :	'Fund Account No is Missing',
				security_empty		       :	'Security Code is Missing',
				quantity_empty		       :	'Quantity is Missing',
				quantity_invalid           :    'Quantity entered is invalid.',
				inputprice_notempty        :    'Input Price is Missing',
				inputprice_invalid         :    'Input Price entered is invalid.',
				inputpriceformat_notempty  :    'Input Price Format can not be empty.',
				inputpriceformat_missing  :    'Input Price Format is Missing',
				exchangerate_notempty      :    'Exchange Rate can not be empty.',
	 			tbareferenceno_notempty    :    'TBA Reference No can not be empty.',
				wipricomadjstrate_notempty :    'When Issue Price Conv. Rate can not be empty.',
				originalfacevalue_notempty :    'Original Face Value can not be empty.',
				currentfacevalue_notempty  :    'Current Face Value can not be empty.',
				format_8character          :    '8 character entry should be in the format hh:mm:ss',
				format_6character          :    '6 character entry should be numeric and in the format hhmmss',
				format_5character          :    '5 character entry should be in the format hh:mm',
				format_4character          :    '4 character entry should be numeric and in the format hhmm',
				format_valid               :    'Valid time format is hh:mm:ss or hhmmss or hh:mm or hhmm',
				hh_nonnumeric              :    'HH contains non-numeric values.',
				hours_valid                :    'Hours should be less than 24',
				mm_nonnumeric              :    'MM contains non-numeric values.',
				minutes_valid              :    'Minutes should be less than 60',
				ss_nonnumeric              :    'SS contains non-numeric values.',
				seconds_valid              :    'Seconds should be less than 60',
				accrueddays_invalid        :    'Invalid accrued days specified.',
				taxorcomid_select          :    'Select Tax Fee ID or Commission ID.',
				amount_specify             :    'Specify only Amount for Rate type AMOUNT.',
				rate_specify			   :	'Specify only Rate for Rate type {0}.',
				all_specify                :    'Specify either the Amount or Rate and Rate type.',
				enter_security             :    'Enter Security.',
				successful_transaction     :	'Transaction completed successfully.',
				no_rejection			   :    'No record selected for Rejection.',
				no_rejection_for_reject	   :    'Rejected record can not be Rejected',
				no_authorization_record	   :	'No record selected for Authorization.',
				no_authorization_for_reject:	'Rejected record can not be Authorized.',
				not_implemented			   :	'This feature is not yet implemented.',
				role_number_empty          :	'Role Number field is EMPTY',
				role_empty                 :	'Role field is EMPTY',
				authorized_records         :    'Authorized record(s) cannot be further authorized.',
			    no_record_for_authorization:    'Authorized record(s) cannot be rejected.'
				
				
			},
			tradetime : {
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
				notvalid_second				:	'NOT VALID: Seconds should be less than 60'
			},
			detailinfo : {
				different_principal_amount :     'Principal Amount specified by the user is different from the system calculated value.',
				select_tax_comm: 'Please select a Tax_Fee_Id or a Commission_Brokerage',
				commision_rate_rateType : 'Please specify either the Commission Amount or Rate and Rate type',
				principal_notspecified: 'Principal amount is not specified in Prefigured Principal trade',
				invalid_taxfee_amount:   'If Rate is specified Rate type cannot be AMOUNT',
				remarks: 'Remarks is Missing'
				
			},
			valid_value: {
				valid_value_quantity: 'Please enter a valid value for Quantity',
				valid_value_price: 'Please enter a valid value for Price',
				valid_value_principal: 'Please enter a valid value for Principal Amount',
				valid_value_currentface: 'Please Enter a Valid CurrentFace Value'
			},
			
			invalid_entry: {
				time_format1: 'INVALID ENTRY. 8 character entry should be in the format hh:mm:ss',
				time_format2: 'INVALID ENTRY. 6 character entry should be in the format hh:mm',
				time_format3: 'INVALID ENTRY. 5 character entry should be numeric and in the format hhmm',
				time_format4: 'INVALID ENTRY. 4 character entry should be numeric and in the format hhmm',
				time_format: 'INVALID ENTRY. Valid time format is hh:mm:ss or hhmmss or hh:mm or hhmm',
				non_numeric_h: 'NOT VALID: HH contains non-numeric values',
				not_valid_h: 'NOT VALID: Hours should be less than 24',
				non_numeric_m: 'NOT VALID: MM contains non-numeric values',
				not_valid_m: 'NOT VALID: Minutes should be less than 60',
				non_numeric_s: 'NOT VALID: SS contains non-numeric values',
				not_valid_s: 'NOT VALID: Seconds should be less than 60',
				invalid_rebate: 'Invalid Rebate Commission Rate',
				date_format_check : 'Illegal date format {0}'
				
			},
			
			warning: {
				diff_principal: 'Warning! Principal Amount specified by the user is different from the system calculated value.'
			
			}	
			
	  },
	  	commissionQuery:{
			report_id_check        : 'Report Title is Missing',
			date_to_empty_check    : 'Trade Date To is Missing',	
			date_from_empty_check  : 'Trade Date From is Missing',	
			date_from_to_check     : 'Trade Date From should be less than or equal to Trade Date To',
			date_to_format_check   : 'Invalid Trade Date To {0}',
			date_from_format_check : 'Invalid Trade Date From {0}'
		},
		txnReportQuery:{
			fund_code_check : 'Fund Code is mandatory',
			date_format_check : 'Illegal date format {0}',
			date_from_to_check : 'Trade Date From should be less than or equal to Trade Date To'
		},
	   txnDetailQuery:{
		date_format_check : 'Illegal date format {0}'
	   },
	   
	   trdCnfAllocCxl:{
		   no_record_selected : 'Please select at least one allocation trade to cancel',
		   cxl_record_selected : 'Please select a normal allocation trade',
		   cnf_record_selected : 'Please select an unmatched allocation trade',
		   cnf_trd_record_selected : 'Please select an allocation trade',
		   no_remarks : 'Either reason code or remarks is required'
	   },
	   
	   trdConfirmationAmend:{
		   origin_data_source_check : 'Origin Data Source is Missing'
	   },
	   
	   trdConfirmationExcelUpload:{
			validation: {
				cannotbeblank	: 'Trade Confirmation File cannot be blank.',
				invalidfiletype	: 'Invalid file type. Try uploading .xls or .xlsx.',
				maxfilesize		: 'Selected File Size is Over Allowed Limit ({0} bytes). Please select Another File!'
			}
		},
	   
	   trdReject :{
		   no_record_selected : 'Please select an unmatched confirmation trade',
		   multiple_record_selected : 'Multiple trades cannot be rejected at the same time',
		   confirmed_trade_selected : 'Confirmed trade cannot be rejected',
		   matched_trade_selected : 'Matched trade cannot be rejected',
		   rejected_trade_selected : 'Selected trade already rejected',
		   select_unmatched_conf_trade : 'Please select an unmatched confirmation trade',
		   allocation_trade_selected : 'Please select a confirmation trade',
		   cxl_record_selected : 'Please select a normal trade',
		   datascr_screen : 'Selected trade has been entered from UI and thus cannot be rejected'
		   },
		   
		trdMatch :{
				no_record_selected : 'Please select an unmatched trade',
				cxl_record_selected : 'Please select a normal trade',
				reject_record_selected : 'Rejected trade cannot be matched',
				cnf_record_selected : 'Confirmed trade cannot be matched',
				matched_record_selected : 'Selected trade already has been matched',
				multiple_cnf_trd_selected : ' Multiple Confirmations cannot be selected',
				allc_cnf_record_selected : 'Allocation and confirmation trade/s cannot be selected at the same time for matching',
				no_trade_selected : 'Please select at least one trade'
		   },
   
		 trdUnmatch :{
				unmatched_trd_selected : 'Select Only Matched Trade/s',
				reject_trd_selected : 'Rejected Trade Cannot Be Unmatched',
				cnf_trd_selected : 'Confirmed Trade Cannot Be Unmatched',
				settled_trd_selected : 'Trade With Completed (Full or Partial) Settlement Cannot Be Unmatched',
				no_record_selected : 'Select One Or More Matched Trade/s'
				
		   }
	   
 };
