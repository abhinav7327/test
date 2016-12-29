//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
xenos$STL$i18n = {
	required_fields_empty_alert : 'Some modified data has not yet been saved, Do you want to continue?',
	amount : {
		amount_exceed : 'The amount specified exceeds/is less than the Outstanding Amount.'
	},
	transmission : {
		required_flag : 'The Transmission Reqd. Flag cannot be different for AGAINST case.'
	},
	xenos : {
		cancel : 'No record selected for cancelation.'
	},
	nett : {
		cancel : 'No record selected for Finalization.',
		cannotbesame : 'Selected Records can not be netted together.'
	},
	successful_transaction : 'Transaction completed successfully.',
	pendingfor_authorization : 'The selected Record(s) cannot be Netted As one or more record(s) is Pending for Authorization.',
	wireinstruction : {
		entry : {
			amount_must_be_number : 'Wire Amount must be a number',
			amount_must_be_positive : 'Wire Amount must be Positive',
			wire_type_cant_empty : 'Wire Type can not be empty.',
			gleLedger_cant_empty : 'Gle Ledger Code can not be empty.',
			otherLedger_cant_empty : "Other Ledger can not be empty for GLE Ledger Code 'Other'.",
			accNo_cant_empty : 'Account No can not be empty.',
			valueDate_cant_empty : 'Value Date can not be empty.',
			amount_cant_empty : 'Wire Amount can not be empty.',
			currency_cant_empty : 'Currency can not be empty.',
			amountBal_cant_empty : 'Account Balance Type can not be empty.',
			counterPartyBankName_cant_empty : 'Counter Party Bank Name can not be empty.',
			ownSettAc_cant_empty : 'Own Settlement A/C can not be empty.',
			inxTransmission_cant_empty : 'Inx Transmission can not be empty.',
			standingRulePk_not_specified : 'SSI Rule is not specified.',
			amount_cant_negative : 'Please enter a valid value for Amount',
			amount_zero : 'Amount cannot be Zero',
			to_settle_account : 'To Settle Account cannot be empty',
			from_settle_account : 'From Settle Account cannot be empty',
			to_bank : 'To Bank cannot be empty',
			from_bank : 'From Bank cannot be empty',
			inx_transmission : 'For Wire Type BANK_TO_BANK, Inx Transmission cannot be empty',
			localAccount_empty : 'Local Account cannot be empty.'
		},
		authorization : {
			no_record_select_reject : 'No Record selected for Rejection',
			no_record_select_authorize : 'No Record selected for Authorization',
			rejected_record_reject : 'Rejected Record(s) cannot be Rejected Again',
			rejected_record_authorize : 'Rejected Record(s) cannot be Authorized',
			authorized_records : 'Authorized record(s) cannot be further authorized.',
			no_record_for_authorization : 'Authorized record(s) cannot be rejected.'
		}
	},

	bulk_amend : {
		amend : 'No record selected for bulk amendment',
		no_ssi_rule : 'SSI rule not selected for bulk amendment'
	},
	stlAmdAuth : {
		no_record_select_reject : 'No Record selected for Rejection',
		no_record_select_authorize : 'No Record selected for Authorization',
		rejected_record_reject : 'Rejected Record(s) can not be Rejected Again',
		rejected_record_authorize : 'Rejected Record(s) can not be Authorize',
		authorized_records : 'Authorized record(s) cannot be further authorized.',
		no_record_for_authorization : 'Authorized record(s) cannot be rejected.',
		amountForm : 'Please Enter a Valid Amount From',
		amountTo : 'Please Enter a Valid Amount To',
		quantityFrom : 'Please Enter a Valid Quantity From',
		quantityTo : 'Please Enter a Valid Quantity To'

	},
	stlQuery : {
		invalidLength : 'Invalid length for "{0}", max {1} digits before decimal and {2} digits after decimal are allowed',
		amountForm : 'Amount From',
		amountTo : 'Amount To',
		quantityFrom : 'Quantity From',
		quantityTo : 'Quantity To',
		date_from_to_check : 'From Date should be less than To Date.',
		date_format_check : 'Illegal date format :'
	},
	cashTransferQuery : {
		date_from_to_check : 'From Date should be less than To Date.',
		date_format_check : 'Illegal date format '
	},
	bankTransferQuery : {
		date_from_to_check : 'From Date should be less than To Date.',
		date_format_check : 'Illegal date format '
	},
	stlWithHold : {
		withhold_user_confirmation_title : 'Withhold Settlement User Confirmation',
		withhold_system_confirmation_title : 'Withhold Settlement System Confirmation',
		no_record_select_withhold : 'No record selected for withhold',
		no_record_select_release : 'No record selected for release',
		specify_start_date : 'Please specify the Start Date for Settlement Reference No = ',
		start_date_after_end_date : 'Start Date can not come after the End Date.',
		withhold_cant_withhold_again : 'Withhold record(s) can not be withhold again.',
		cant_release_non_withhold_stl : 'Cannot Release a non-Withhold Settlement.',
		start_date_after_app_date : 'Start Date can not be less than Application Date for Settlement Reference No - '
	},
	common : {
		formId_unknown : 'Command Form ID for query screen is not known'
	},

	banktransfer : {
		entry : {
			quantity_empty : 'Quantity is Missing',
			same_acount : 'From Bank Account & To Bank Account are same',
			frombankaccount_empty : 'From Bank Account is Missing',
			tobankaccount_empty : 'To Bank Account is Missing',
			securitycode_empty : 'Security Code is Missing',
			transmissionrequired_empty : 'Transmission Required is Missing'
		},
		date : {
			date_format_check : 'Illegal date format : '
		}
	},
	recvdnotice : {
		dkinstruction : {
			reason_empty : 'Please select a reason.'
		},
		forceMatch : {
			stlDateMismatch : 'The Settlement Date[{0}] of the Received Notice does not match the Settlement Date of the open settlement(s).'
		},
		payment : {
			accountNoMissing : 'Account No must be specified for Payment Entry',
			wayOfPaymentCheque : 'Cheque/Reference No and Cheque Date can not be empty when Way Of Payment is CHEQUE.'
		}
	},

	pairoff : {
		reason_code_empty : 'Please select a Reason Code',
		undo_netting_empty : 'Please select at least one record to perform Cancel Pair-Off',
		netting_empty : 'At least two participants are required for Pair-Off.',
		netting_group : 'At Least two participants are required for Netting Group ',
		our_bank_empty : 'Please Enter Our Bank.'
	},

	bankTransferAuth : {
		no_record_select_reject : 'No Record selected for Rejection',
		no_record_select_authorize : 'No Record selected for Authorization',
		rejected_record_reject : 'Rejected Record(s) cannot be Rejected Again',
		rejected_record_authorize : 'Rejected Record(s) cannot be Authorized',
		authorized_records : 'Authorized record(s) cannot be further authorized.',
		no_record_for_authorization : 'Authorized record(s) cannot be rejected.'
	},
	instructionSplit : {
		no_of_instruction_split : 'Please split the settlement into at least two instructions',
	},

	splitFunctionEntry : {

		amount_cannot_be_zero : 'Amount Cannot be Zero',
		quantity_cannot_be_zero : 'Quantity Cannot be Zero',
		cpDetails_cannot_be_empty : 'Select the CP Details for the Free Settlement',
		amount_cannot_be_empty : 'Amount Cannot be empty',
		quantity_cannot_be_empty : 'Quantity Cannot be empty',
		transReqd_cannot_be_empty : 'Trans Reqd Flag Cannot be empty',
		autoTransReqd_cannot_be_empty : 'Auto Trans Reqd Flag Cannot be empty',
		multiple_free_settlement : 'Cannot Select more than 1 Free Settlement',
		number_of_instruction_split : 'Please split the settlement into at least two instructions',
		click_to_select_instruction_type : 'Click to Select Instruction Type'
	},
	splitAuth : {
		no_record_select_reject : 'No Record selected for Rejection',
		no_record_select_authorize : 'No Record selected for Authorization',
		rejected_record_reject : 'Rejected Record(s) cannot be Rejected Again',
		rejected_record_authorize : 'Rejected Record(s) cannot be Authorized',
		authorized_records : 'Authorized record(s) cannot be further authorized.',
		no_record_for_authorization : 'Authorized record(s) cannot be rejected.'
	},
	Custodyinstruction : {
		validation : {
			security_cash_settlement_ac : 'Please specify Security or Cash Settlement A/c.',
			security_settlement_ac : 'Please specify a Security Settlement A/c.',
			cash_settlement_ac : 'Please specify a Cash Settlement A/c.',
			price : 'Please specify Price.',
			appropiate_ssilayout_acronym : 'Please specify either an Acronym or select the appropriate SSI Layout.',
			security_instruction_req_flag : 'Security Instruction Required Flag can not be Empty.',
			cash_instruction_req_flag : 'Cash Instruction Required Flag can not be Empty.',
			security_code : 'Security Code can not be Empty.',
			quantity : 'Specify the Quantity of the traded security.',
			contra_id : 'Specify the Contra Id.',
			full_delivery_instruction : 'Specify the Full Delivery Instruction.',
			dtc_number : 'Specify the DTC Participant Number.',
			secCp_bank : 'Specify a Bank where Counterparty holds a Settlement account.',
			cashCp_bank : 'Specify a Bank where Counterparty holds a Settlement account.',
			counterparty_settle_acc : 'Specify the Counterparty Settlement Account.',
			ccy : 'Settlement Ccy can not be Empty.',
			amount : 'Amount can not be Empty.',
			sec_code : 'Please specify a Security code',
			stlccy : 'Please specify a Settlement ccy'

		},
		authorization : {
			no_record_select_reject : 'No Record selected for Rejection',
			no_record_select_authorize : 'No Record selected for Authorization',
			rejected_record_reject : 'Rejected Record(s) cannot be Rejected Again',
			rejected_record_authorize : 'Rejected Record(s) cannot be Authorized',
			authorized_records : 'Authorized record(s) cannot be further authorized.',
			no_record_for_authorization : 'Authorized record(s) cannot be rejected.'
		},
		generalinfo : {
			transaction_type : 'Transaction Type can not be empty',
			custodyValue_Date : 'Value date can not be empty',
			settlement_type : 'Settlement Type can not be empty',
			accountBalanceType : 'Transaction Type can not be empty',
			dtcPledgeLoanDate : 'Loan Date can not be empty',
			ssiLayout_acronym : 'Please specify either Acronym or SSI Layout'
		}
	},
	completionSummery : {
		our_stl_account_empty : 'Our Settlement A/C can not be empty.',
		ccy_empty : 'CCY can not be empty.'
	},
	authorization : {
		no_record_select_reject : 'No Record selected for Rejection',
		no_record_select_authorize : 'No Record selected for Authorization',
		rejected_record_reject : 'Rejected Record(s) cannot be Rejected Again',
		rejected_record_authorize : 'Rejected Record(s) cannot be Authorized',
		authorized_records : 'Authorized record(s) cannot be further authorized.',
		no_record_for_authorization : 'Authorized record(s) cannot be rejected.'
	},

	completion : {
		empty_settlementdate : 'Settlement Date cannot be empty for any record.',
		no_settlement_selected : 'No Settlement is selected for completion',
		invalid_quantity : 'Enter valid quantity',
		invalid_amount : 'Enter valid amount',
		no_reason_code : 'Please select a reason code',
		no_record_selected : 'Please select record first',
		no_completion_type_selected	:'Please select at least one record for completion',
		select_completion_type_first :'Please select the completion type first'

	},
	clientreceipt : {
		entry : {
			accNo_cant_be_empty : 'Account No can not be empty.',
			receivedDate_cant_be_empty : 'Received Date can not be empty.',
			wayOfPayment_cant_be_empty : 'Way Of Payment cannot be empty',
			currency_cant_be_empty : 'Currency can not be empty.',
			valueDate_cant_be_empty : 'Value Date can not be empty.',
			accBalanceType_cant_be_empty : 'Account Balance Type can not be empty.',
			receivedAmount_cant_be_empty : 'Received Amount cant be empty.',
			receivedAmount_invalid : 'Please enter a valid value for Received Amount.',
			ownSettAc_cant_empty : 'Own Settlement A/C can not be empty.',
			ownSSIRule_not_specified : 'Own SSI Rule is not specified.',
			receivedAmount_decimal_points : 'No more than 3 digits are allowed after decimal point for received amount',
			chequeDate_cant_be_empty : 'Cheque Date cannot be empty when Way Of Payment is Cheque',
			allocation_reset_warning : 'On successful Default Allocation, all previously loaded allocation(s) will be discarded. Do you want to continue?',
			allocationAmount_cant_be_empty : 'Allocation Amount can not be empty.',
			allocationAmount_invalid : 'Allocation Amount is invalid.'
		}
	},
	stlPayment : {
		entry : {
			settlementCcy_empty : 'Settlement Ccy cannot be empty',
			ourStlAccount_empty : 'Our Settlement Account cannot be empty',
			paymentValueDate_empty : 'Payment Date cannot be empty',
			deselectAccounts : 'Account No cannot be selected when Restricted Accounts Only is checked. Please deselect the Account No',
			no_record_selected : 'No record selected for Payment Entry',
			payableAmt_empty : 'Payable Amount cannot be empty for Account No [{0}]',
			payableAmtInvalid : 'Payable Amount should be greater than 0 for Account No [{0}]',
			paymentDate_empty : 'Payment Date cannot be empty for Account No [{0}]',
			cpBankCode_empty : 'CP Bank Code cannot be empty for Account No [{0}]',
			cpBankAccountNo_empty : 'CP Bank Account No cannot be empty for Account No [{0}]',
			modeOfPayment_empty : 'Way Of Payment cannot be empty for Account No [{0}]',
			split_no_record_selected : 'No record selected for Split Entry',
			no_check_box_selected : 'At least one of the Payment Options should be selected',
			consolidated_payment_account_not_empty : 'Account No should be empty when Consolidated Payment selected'
		},
		split : {
			modeOfPayment_empty : 'Way Of Payment cannot be empty if Payable Amount is specified',
			bankCode_accountNo_empty : 'CP Bank Code and CP Bank Account No cannot be empty for Way Of Payment [BANK_TRANSFER]',
			cpBankCode_empty : 'CP Bank Code cannot be empty for Way Of Payment [BANK_TRANSFER]',
			cpBankAccountNo_empty : 'CP Bank Account No cannot be empty for Way Of Payment [BANK_TRANSFER]'
		},
		update : {
			no_settlement_selected : 'No Settlement is selected for cheque update.',
			empty_settlementdate : 'Update Date cannot be empty for any record.'
		}
	},
	cashtransfer : {
		entry : {
			fundCode_cant_empty : 'FundCode is Missing',
			currency_cant_empty : 'Currency is Missing',
			cpBankAccountNo_cant_empty : 'Counter Party Account No is Missing',
			wireAmount_cant_empty : 'Wire Amount is Missing',
			valueDate_cant_empty : 'Value Date is Missing',
			gleLedgerCode_cant_empty : 'GLE Ledger Code is Missing',
			tradeDate_cant_empty : 'Trade Date is Missing.',
			inxTransmission_cant_empty : 'Inx Transmission is Missing',
			toBank_cant_empty : 'To Bank is Missing',
			toSettleAcc_cant_empty : 'To Settle Account is Missing',
			fromBank_cant_empty : 'From Bank is Missing',
			fromSettleAcc_cant_empty : 'From Settle Account is Missing',
			ownBank_cant_empty : 'Own Bank is Missing',
			ownSettleAcc_cant_empty : 'Own Settle Account is Missing',
			wireamount_cant_negative : 'Please Enter Amount Greater Than 0',
			fundCode_for_popup_missing : 'Specify Fund Code',
			currency_for_popup_missing : 'Specify Currency',
			cpAccountNo_for_popup_missing : 'Specify a Broker Account'
		},

		date : {
			date_format_check : 'Illegal date format : '
		}
	},
	cashTransferExcelUpload : {
		validation : {
			cannotbeblank : 'Cash Transfer File cannot be blank.',
			invalidfiletype : 'Invalid file type. Try uploading .xls or .xlsx.',
			maxfilesize : 'Selected File Size is Over Allowed Limit ({0} bytes). Please select Another File!'
		}
	},
	authorization : {
		no_cashTransfer_selected : 'At least one record shoud be selected.',
		auth_completion_confirm : 'Authorization/Rejection completed successfully.'
	},
	message : {
		error : {
			nodiffflag : 'o  The Transmission Reqd. Flag cannot be different for AGAINST case.',
			specifyourstlaccount : 'Specify the Our Settlement account.',
			specifyourbank : 'Specify the Our Bank.',
			specifycpstlaccount : 'Specify the Counterparty Settlement Account.',
			specifybank : 'Specify a Bank where Counterparty holds a Settlement account.'
		}
	},
	completionCancel : {
		cannotbeblank : 'Please select at least one record for cancel completion',
		selectRecord : 'Please select the record first'
	},
	mutualFundInstructionQuery:{
		date_from_to_check : 'From Date should be less than To Date.',
		date_format_check : 'Illegal date format {0}',
		inx_trade_date_check : 'Inx Created Date cannot be Lesser than Trade Date From',
		trx_trade_date_check : 'Transmission Date cannot be Lesser than Trade Date From',
		trdRefNo_valid : 'Please Enter the valid Trade Reference No.',
		trdFor_valid : 'Please select the valid Trade For.',
		trade_date_from_to_check : 'Trade Date From should be less than Trade Date To.',
		value_date_from_to_check : 'Value Date From should be less than Value Date To.',
		settle_cur_required : 'Settlement Currency is required when Exclude is checked',
		trade_cur_required : 'Trade Currency is required when Exclude is checked'
	}

}