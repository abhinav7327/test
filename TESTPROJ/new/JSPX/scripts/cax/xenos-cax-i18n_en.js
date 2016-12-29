//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos$CAX$i18n = {
  required_fields_empty_alert : 'Some modified data has not yet been saved, Do you want to continue?',		
  rightsConditionEntry : {
		enter_instrumentCode 			: 'Security Code is Missing !',
		enter_eventTypeStatus 			: 'Event Type Status is Missing !',
		enter_recordDate 				: 'Record date is Missing !',
		date_format_check_recordDt 		: 'Illegal date format of Record Date ' ,
		enter_allotedSecurityCode		: 'Allotted Instrument is Missing !',
		enter_exDateStr					: 'Execution date is Missing !',
		enter_paymentDateStr			: 'Payment date is Missing !',
		enter_allotmentQuantityStr		: 'Allotment Qty/Amount is Missing !',
		enter_processStartDate			: 'Process Start date is Missing !',
		enter_processEndDate			: 'Process End date is Missing !',
		splAlltmnt_splPershare			: 'Special Allotment Amount and Special Per Share should occur simultaneously !',
		payoutPrice_payoutCcy			: 'PayOutPrice and PayOutCcy should occur simultaneously !',
		splAllotmnt_SplQty				: 'Special Allotment Quantity and Special Per Share should occur simultaneously!',
		date_format_check_processStDt 	: 'Illegal date format of Process Start Date ' ,
		date_format_check_processEnDt	: 'Illegal date format of Process End Date ',	
		date_format_check_exDt			: 'Illegal date format of Ex Date ',	
		date_format_check_paymntDt		: 'Illegal date format of Payment Date ',	
		date_format_check_creditDt		: 'Illegal date format of Credit Date ',	
		date_format_check_announcemntDt	: 'Illegal date format of announcementDate ',
		date_format_check_bookClosingDt	: 'Illegal date format of Book Closing Date ',
		date_format_check_protectExpDt	: 'Illegal date format of Protect Expiration Date ',
		date_format_check_finYrEndDt	: 'Illegal date format of Financial Yr End Date ',
		date_format_check_originalRecDt	: 'Illegal date format of Original Record Date!',
		enter_couponDate				: 'Coupon date is Missing!',
		date_format_check_couponDt		: 'Illegal date format of Coupon Date! ',
		enter_couponRate				: 'Coupon Rate is Missing!',
		prevFactor_currFactor			: 'PreviousFactor and CurrentFactor should occur simultaneously!',
		enter_perShare					: 'Please Enter PerShare.',
		blank_instrumentCode			: 'Please Enter Instrument Code.',
		blank_allotmentQty				: 'Please Enter Allotment Quantity.',
		blank_perShare					: 'Please Enter PerShare.',
		invalid_allotmentQty			: 'Allotment Quantity is Invalid',
		date_format_check_expirationDt	: 'Illegal date format of Protext Expiration Date ',
		enter_stock						: 'Number of Stock Entry must be greater than 0 !',
		enter_redemptionCcy				: 'Redemption Ccy is Missing !',
		date_format_check_redemptionDt	: 'Illegal date format of Redemption Date ',
		enter_rateNominal				: 'Rate Of Nominal is Missing !',
		enter_redemptionPrice			: 'Redemption Price is Missing !',
		date_format_check				: 'Illegal date format {0}',
		date_format_check_rightsExpiry	: 'Illegal date format of Rights Expiry Date ',
		date_format_check_creditDate	: 'Illegal date format of Credit Date ',
		date_format_check_deadlineDate	: 'Illegal date format of Deadline Date ',
		enter_paymntDtTakeUp			: 'Payment date (Take Up) is Missing !',
		date_format_check_paymntDtTakeUp : 'Illegal date format of Payment Date (Take Up) ',
		enter_takeupCost				:	'Take up Cost is Missing !',
		enter_takeupCcy					: 'Take Up Ccy is Missing !',
		enter_paymntDtRights			: 'Payment Date(Rights) is missing',
		date_format_check_paymntDtRights : 'Illegal date format of Payment Date(Rights) ',
		enter_allotedRightsIns			: 'Allotted Security(Rights) is missing',
		enter_allotedRightsQuantity		: 'Allotment Qty/Amount (Rights) is Missing !',
		enter_perShareRights			: 'Per Share(Rights) is missing',
		enter_paymentDtNewShare			:'Payment date (New Share) is Missing !',
		date_format_check_paymntDtNewShare		: 'Illegal date format of Payment Date (New Share) ',
		same_security_allottedRightsIns : 'Security Code and Allotment Rights Security can not be same !',
		same_allotmentSecurity_allottedRightsIns : 'Allotment Security and Allotment Rights Security can not be same !',
		enter_taxFeeId					: 'Please Select Tax Fee Id.',
		enter_taxRate					: 'Please Enter Rate.',
		enter_taxRateType				: 'Please Select Rate Type.',
		enter_securityCode 				: 'Please Enter Security Code.',
		date_format_check_exerciseDt	: 'Illegal date format of Exercise Date ',
		enter_eventTypeName				: 'Event Type Name is Missing !',
		enter_subEventType				: 'Please Select Event Type! ',
		date_format_check_dueBillEndDt	: 'Illegal date format of Due Bill End Date ',
		same_security_allotmentIns 		: 'Security Code and Allotment Security can not be same !',
		enter_expiryDt					: 'Please Enter Expiry Date.'
		
			
		
 },
	caxEventQuery:{
		date_from_to_check : 'From Date should be less than To Date.',
		date_format_check : 'Illegal date format ',
		date_format_check_client : 'Illegal date format {0}.'
	},
	rightsdetailquery:{
	    validation:{
	        daterange_invalid	:	'From Date should be less than To Date',
	        dateformat_invalid	:	'Illegal date format'
	    }
	},
	entitlementGenerationTrade:{
		query : {
			date_from_to_check : 'From Date should be less than To Date.',
			date_format_check : 'Illegal date format.',
			select_one_record : 'Please select at least one record for Entitlement Entry.'
		}
	},

	rightsDetailCancel:{
		finalizedFlagYes : 'The Entitlement to be cancelled has Finalized Flag as \'Y\''
	},
	rightsExerciseQuery:{
		date_from_to_check : 'From Date should be less than or equal to To Date.',
		date_format_check : 'Illegal date format '

	},

	rightsExerciseAmend:{
		no_record_selected : 'Select at least one Rights Exercise to Amend',
		valid_exercise_quantity : 'Put at least one valid Exercise Quantity to proceed',
		valid_exercising_quantity : 'Please enter a valid value for Quantity',
		availaible_exercise_quantity : 'Exercising Quantity can not be greater than the Available Rights Quantity',
		select_record : 'Please select the record first.',
		enter_exercising_qty : 'Please enter exercising quentity to calculate Take Up Cost.',
		valid_takeup_cost : 'Please enter a valid value for Take Up Cost',
		valid_payment_date :  'Enter a valid payment date',
		valid_exercise_date : 'Invalid Exercise Date specified',
		valid_before_decimal : '15 digits are allowed before decimal point',
		valid_after_decimal : '3 digits are allowed after decimal point',
		amount_negative : 'The amount may not be negative.',
		valid_availaible_date : 'Invalid Available Date specified',
		confirm_message : 'Both exercise amend and finalize cannot be performed at the same time.Do you want to finalize?'
	},
	rightsExerciseCancel:{
		no_record_selected : 'Select at least one Rights Exercise to Cancel'

	},

	settlement_details_info : 'Settlement Query Result Summary' ,
	settlement_info : 'SettlementInfo',
	
	entitlementAdjustmentEntry:{
		security_balance_empty : 'Please enter Security Balance',
		accountno_blank : 'Please enter Fund Account No',
		payment_date_empty : 'Please Enter Payment Date',
		dateformat_invalid	: 'Illegal date format',
		enter_taxFeeId		: 'Please Select Tax Fee Id',
		enter_taxRate		: 'Please Enter Rate',
		enter_taxRateType	: 'Please Select Rate Type',
		enter_taxFeeAmount	: 'Please Enter Amount',
		stockMergerInfo:{
			security_balance_empty : 'Security Balance in Stock Merger Info. #{0} cannot be empty.',
			accountno_blank : 'Fund Account No. in Stock Merger Info. #{0} cannot be empty.',
			payment_date_empty : 'Payment Date in Stock Merger Info. #{0} cannot be empty.',
			paymentDate_format_invalid : 'Illegal date format in Stock Merger Info. #{0}  of Payment Date ',
			availableDate_format_invalid : 'Illegal date format in Stock Merger Info. #{0} of Available Date '
		}
	},
	resetFinalizedFlagQuery:{
		date_format_check : 'Illegal date format ',
		date_from_to_check : 'From Date should be less than or equal to To Date.',
	},
	resetFinalizedFlag:{
		no_record_selected : 'Select at least one Record to change the finalized flag',
		transaction_completed_successfully : 'Transaction Completed Successfully.'
	}

 };