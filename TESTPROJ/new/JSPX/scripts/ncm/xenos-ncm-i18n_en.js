//$Id$
//$Author: sumitag $
//$Date: 2016-12-23 14:24:30 $
xenos$NCM$i18n = {
	transactionquery:{
	        validation:{
	            daterange_empty		:	'Please enter both From and To date',
	            datefrom_empty		:	'Please enter From Date',
	            dateto_empty		:	'Please enter To Date',
	            datefrom_invalid	:	'Invalid From Date',
	            dateto_invalid		:	'Invalid To Date',
	            account_empty	     :  'Please enter Our Bank Account Number',
	            securityorcurrency_validation:	'Either Security or Currency should be entered',
	            securityandcurrency_validation:	'Security and Currency cannot be entered together',
	            invalid_quanity_amount:	'Invalid Amount/Qunatity specified',
	            daterange_invalid : 'From Date should be less than To Date'
	        }
	    } ,
	balanceQuery:{
		validation : {
			date_format_check : 'Invalid Date',
			securityandcurrency_validation:	'Security and Currency Code cannot be entered together'
		}
	},
	
	movementquery:{
		validation:{
		datefrom_invalid  :'Invalid From Date',
		dateto_invalid	  :'Invalid To Date',
		date_empty		  :'Please enter both From and To date',
		datefrom_less     :'From Date should be less than To Date',
		movementbasis_empty:'Movement Basis cannot be empty',
		securitycurrency_validation:'Security and Currency cannot be entered together',
		securitycode_validation:'Security Code can not be entered for Security Type CCY'
		
	}
	},
	
	depoadjquery:{
		validation:{
		date_format_check : 'Illegal date format {0}',
		datefrom_invalid  :'Invalid Adjustment Date From',
		dateto_invalid	  :'Invalid Adjustment Date To',
		date_empty		  :'Please enter both From and To date',
		datefrom_less     :'Adjustment Date From should be less than To',
		app_reg_date_from_invalid		  :'Invalid Entry Date From.',
		app_reg_date_to_invalid           :'Invalid Entry Date To.',
		app_up_date_from_invalid          :'Invalid Update Date From.',
		app_up_date_to_invalid            :'Invalid Update Date To.'
	}
	},
	
	nostroentry:{
		validation:{
			fundcode_empty       :'Please enter Fund Code',
			currencyCode_empty   :'Please enter Currency Code',
			bankcode_empty       :'Please enter Bank / Custodian Code',
			accountno_nempty     :'Please enter Bank Account No',
			amount_empty         :'Please enter Amount',
			adjustmentDate_empty :'Please enter Adjustment Date',
			cashin_negative      :'YOU ARE ENTERING A NEGATIVE VALUE IN CASH IN SCREEN.\nDO YOU WISH TO CONTINUE?',
			cashout_negative     :'YOU ARE ENTERING A NEGATIVE VALUE IN CASH OUT SCREEN.\nDO YOU WISH TO CONTINUE?'
		}
	},
	
	depoadjentry:{
		validation:{
			fundcode_empty       :'Please enter Fund Code',
			securityCode_empty   :'Please enter Security Code',
			bankcode_empty       :'Please enter Bank / Custodian Code',
			accountno_nempty     :'Please enter Bank Account No',
			quantity_empty       :'Please enter Quantity',
			adjustmentDate_empty :'Please enter Adjustment Date',
			invalid_date         :'Invalid Adjustment Date'
		}
	},
	
	adjustment:{
		validation:{
		datefrom_invalid  :'Invalid Adjustment Date From',
		dateto_invalid	  :'Invalid Adjustment Date To',
		date_empty		  :'Please enter both Adjustment From-To date',
		datefrom_less     :'Adjustment Date From should be less than To',
		app_reg_date_from_invalid		  :'Invalid Entry Date From.',
		app_reg_date_to_invalid           :'Invalid Entry Date To.',
		app_up_date_from_invalid          :'Invalid Update Date From.',
		app_up_date_to_invalid            :'Invalid Update Date To.'
		}
	},
	
	forex:{
		validation:{
			fundcode_empty         :'Please enter Fund Code',
			incurrency_empty       :'Please enter In Ccy',
			outcurrency_empty      :'Please enter Out Ccy',
			inamount_empty         :'Please enter In Amount',
			outamount_empty        :'Please enter Out Amount',
			inbank_empty           :'Please enter In Bank',
			outbank_empty          :'Please enter Out Bank',
			inaccount_empty        :'Please enter Cash In Account No',
			outaccount_empty       :'Please enter Cash Out Account No',
			inoutcurrency_similar  :'In Ccy and Out Ccy cannot be same'
			
		}
	},
	adjustmentExcelUpload:{
		validation: {
			cannotbeblank: 'Cash I/O File cannot be blank.',
			invalidfiletype: 'Invalid file type. Try uploading .xls or .xlsx.',
			maxfilesize: 'Selected File Size is Over Allowed Limit ({0} bytes). Please select Another File!'
		}
	},

	cashprojectionquery:{
		validation:{
			dateto_invalid     :'Invalid Date To',
			dateto_empty       :'Please enter To Date.',
			dateFrom_invalid   :'Invalid Date From.',
			dateFrom_empty     :'Please enter From Date.',
		    datefrom_less	   :'Invalid From and To date combination.'
		}
	},

	summaryQueryProjection:{
		validation: {
			date_empty		  :'Please enter To Date',
			dateto_invalid	  :'Invalid Date To',
			datefrom_less     :'From Date should be less than To Date',
			date_limit		  :'Date Range should not be greater than 10days'
		}
	},

	authorizationAdjustment:{
		validation:  {

			no_selected: 'Please select  at least one.',
			date_empty		  :'Please enter both From and To date.',
			datefrom_invalid  :'Invalid From Date.',
			dateto_invalid	  :'Invalid To Date.',
			datefrom_less     :'From Date should be less than To Date.',
			securitycurrency_validation:'Can not enter both Currency Code and Security Code.',
			auth_completion_confirm:  'Authorization/Rejection completed successfully.'
		}
	}
};