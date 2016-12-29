



package com.nri.rui.cax.validator
{
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.collections.ArrayCollection;
    import mx.core.Application;
    import mx.utils.StringUtil;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;
    
   
    
    /**
     * Custom Validator for Corporate Action Event Entry.
     * 
     */
	public class RightsConditionEntryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;
		// Define Array for the return value of doValidation().
        private var eventType:String ="";        

        // constructor
		public function RightsConditionEntryValidator() {
			super();
		}
		
		/**
         * 
         * validate Event Entry Form.
         */ 
       
        protected override function doValidation(value:Object):Array {
        	eventType = value.eventType;
        	
        	// Clear results Array.
            results = [];

            // Call base class's doValidation().
            results = super.doValidation(value);

            // Return if there are errors.
            if (results.length > 0)
                return results;
     	
        	changeEventType(value);
        	
        	return results;
       	 }
        
        
    /**
     * Depending upon the event type correct validator is forked.
     * @param eventType the Event type
     * 
     */
    private function changeEventType(value:Object) : void {
    
    	//Validation of Common part except for event type redemption and stock merger
        if(!(XenosStringUtils.equals(eventType,"REDEMPTION_BOND")
        	|| XenosStringUtils.equals(eventType,"STOCK_MERGER"))) {
        		validateCommonPart(value);   
        }    
    
	    switch (eventType) {       
	        case "CASH_DIVIDEND" :
	            return validateCashDividendEntry(value);
	        case "CAPITAL_REPAYMENT" :
	            return validateCashDividendEntry(value);
	        case "STOCK_DIVIDEND" :
	            return validateStockDividentEntry(value);	            
	        case "BONUS_ISSUE" :
	            return validateStockDividentEntry(value);	            
	        case "COUPON_PAYMENT" :
	            return validateCouponPaymentEntry(value);
	        case "STOCK_SPLIT" :
	            return validateStockEventsEntry(value);
	        case "REVERSE_STOCK_SPLIT" :
	            return validateStockEventsEntry(value);
	        case "STOCK_MERGER" :
	            return validateStockMergerEntry(value);        
	        case "NAME_CHANGE" :
	            return validateStockEventsEntry(value);
	        case "SPIN_OFF" :
	            return validateStockEventsEntry(value);       
	        case "REDEMPTION_BOND" :
	            return validateRedemptionBondEntry(value);         
	        case "RIGHTS_ALLOCATION" :
	            return validateRightsIssueEntry(value);
	            break; 
	        case "OPTIONAL_STOCK_DIV" :
	            return validateStockCashOptionEntry(value);
	            break;
	        case "DIV_REINVESTMENT" :
	            return validateStockCashOptionEntry(value);
	            break;
	        case "OTHERS" :
	            return validateOthersEntry(value);
	            break; 
	        case "SHARE_EXCHANGE" :
	            return validateStockEventsEntry(value);
	            break; 	            	            
	        default :
	            break;
    
  		}	
	}

	/**
	 * In validator of Cash dividend event type.
	 * 
	 */
	private function validateCommonPart(value:Object):void {
        var dateformat:CustomDateFormatter =new CustomDateFormatter();
        //format of the date
        dateformat.formatString="YYYYMMDD";
        var formatData:String ="";			
		
		var processingFreq:String = value.processingFrequency;
		var processStartDateStr:String = value.processStartDateStr;
		var processEndDateStr:String = value.processEndDateStr;
						
       	var dateList:Array = [];	
	        switch (processingFreq){       
	            case "DAILY" :
		        	if(processStartDateStr != "") {
			                        
			            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.processStartDateStr));
			            
			            if(!DateUtils.isValidDate(StringUtil.trim(value.processStartDateStr))) {
			                
			                results.push(new ValidationResult(true, 
			                    "processStartDateStr", "illegalProcessStartDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.process.start.date') + " " + value.processStartDateStr +"!"));
			                //return results;
			            }
		            } else {
			    		 results.push(new ValidationResult(true, 
			                    "processStartDateStr", "ProcessStartDateMissing", Application.application.xResourceManager.getKeyValue('cax.missing.process.start.date')));
			    	}
			    	
		        	if(processEndDateStr != "") {
			           // var formatData:String ="";	            
			            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.processEndDateStr));
			            
			            if(!DateUtils.isValidDate(StringUtil.trim(value.processEndDateStr))) {
			                
			                results.push(new ValidationResult(true, 
			                    "processEndDateStr", "illegalProcessEndDate", Application.application.xResourceManager.getKeyValue('cax.illegal.process.end.date')+" " + value.processEndDateStr+"!"));
			                //return results;
			            }
		            } else {
			    		 results.push(new ValidationResult(true, 
			                    "processEndDateStr", "ProcessEndDateMissing", Application.application.xResourceManager.getKeyValue('cax.missing.process.end.date')));
			    	}			    	

	                break;
	            case "TRIGGER" :
		        	if(processStartDateStr != "") {
			            //var formatData:String ="";	            
			            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.processStartDateStr));
			            
			            if(!DateUtils.isValidDate(StringUtil.trim(value.processStartDateStr))) {
			                
			                results.push(new ValidationResult(true, 
			                    "processStartDateStr", "illegalProcessStartDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.process.start.date') + " "  + value.processStartDateStr+"!"));
			                //return results;
			            }
		            } else {
			    		 results.push(new ValidationResult(true, 
			                    "processStartDateStr", "ProcessStartDateMissing", Application.application.xResourceManager.getKeyValue('cax.missing.process.start.date')));
			    	}	                
	                break;
	            default :
	                break;
	        }		
		
			var conditionStatusStr:String = value.conditionStatus;	
        	if(conditionStatusStr == "") {      
        		 results.push(new ValidationResult(true, 
	                    "conditionStatus", "eventTypeStatusMissing", Application.application.xResourceManager.getKeyValue('cax.missing.event.type')));
        	}			
					
			// ex date
			if(!XenosStringUtils.equals(eventType,"COUPON_PAYMENT")) {
				var exDateStr:String = value.exDateStr;				
	        	if(exDateStr != "") {	            
		            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.exDateStr));		            
		            if(!DateUtils.isValidDate(StringUtil.trim(value.exDateStr))) {	                
		                results.push(new ValidationResult(true, 
		                    "exDateStr", "illegalExDate", Application.application.xResourceManager.getKeyValue('cax.illegal.exdate')+" " + value.exDateStr+"!"));
		            }        		
	        	} else {
	        		 results.push(new ValidationResult(true, 
		                    "exDateStr", "exDateMissing", Application.application.xResourceManager.getKeyValue('cax.missing.execution.date')));
	        	}
			}
			// payment date
			if(!XenosStringUtils.equals(eventType,"OTHERS")) {
				var paymentDateStr:String = value.paymentDateStr;
	        	if(paymentDateStr != "") {      
		            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.paymentDateStr));
		            
		            if(!DateUtils.isValidDate(StringUtil.trim(value.paymentDateStr))) {
		            	if(XenosStringUtils.equals(eventType, "RIGHTS_ALLOCATION")){
		            	 results.push(new ValidationResult(true, 
		                    "paymentDateStr", "illegalPaymentDate", Application.application.xResourceManager.getKeyValue('cax.illegal.payment.date.new.share')+" "+ value.paymentDateStr+"!"));	
		            	}else{	                
		                results.push(new ValidationResult(true, 
		                    "paymentDateStr", "illegalPaymentDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.payment.date')+" " + value.paymentDateStr+"!"));
		                }
		            }        		
	        	} else {
	        		if(XenosStringUtils.equals(eventType, "RIGHTS_ALLOCATION")){
	        		 results.push(new ValidationResult(true, 
		                    "paymentDateStr", "paymentdateMissing", Application.application.xResourceManager.getKeyValue('cax.missing.payment.date.new.share')));
		            }else{
		             results.push(new ValidationResult(true, 
		                    "paymentDateStr", "paymentdateMissing", Application.application.xResourceManager.getKeyValue('cax.missing.payment.date')));
		            }
	        	}
			}
			// record date
			var recordDateStr:String = value.recordDateStr;
        	if(recordDateStr != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.recordDateStr));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.recordDateStr))) {	                
	                results.push(new ValidationResult(true, 
	                    "recordDateStr", "illegalRecordDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.record.date')+" " + value.recordDateStr+"!"));
	            }        		
        	} else {
        		 results.push(new ValidationResult(true, 
	                    "recordDateStr", "recordDateMissing", Application.application.xResourceManager.getKeyValue('cax.missing.record.date')));
        	} 
        	
        	
        	       	        	
        	
        	if(value.instrumentCode == null || StringUtil.trim(value.instrumentCode) == ""){
        		 results.push(new ValidationResult(true, 
	                    "instrumentCode", "instrumentCodeMissing", Application.application.xResourceManager.getKeyValue('cax.missing.security.code')));
        	}	
        	if(value.allottedInst == null || StringUtil.trim(value.allottedInst) == ""){
        		 results.push(new ValidationResult(true, 
	                    "allottedInst", "allottedInstrumentMissing", Application.application.xResourceManager.getKeyValue('cax.missing.allotment.instrument')));
        	} 
        	
        	if(!(XenosStringUtils.equals(eventType,"STOCK_MERGER")
        	  || XenosStringUtils.equals(eventType,"COUPON_PAYMENT"))) {
	        	if(value.allottedQtyAmt == null || StringUtil.trim(value.allottedQtyAmt) == ""){
	        		 results.push(new ValidationResult(true, 
		                    "allottedQtyAmt", "allotmentQty/AmountMissing", Application.application.xResourceManager.getKeyValue('cax.missing.allotment.qty.amt')));
	        	}
	        	if(value.perShareStr == null || StringUtil.trim(value.perShareStr) == ""){
	        		 results.push(new ValidationResult(true, 
		                    "perShareStr", "perShareMissing", Application.application.xResourceManager.getKeyValue('cax.missing.per.share')));
	        	}
        	}
        	
        	if(XenosStringUtils.equals(eventType,"NAME_CHANGE")
        		|| XenosStringUtils.equals(eventType,"SPIN_OFF")) {
        			
        			var instrumentCode:String = value.instrumentCode; 
        			var allottedInst:String = value.allottedInst; 
				    if(value.instrumentCode != null && StringUtil.trim(value.instrumentCode) != "") {
				        if(instrumentCode==allottedInst) {
			                results.push(new ValidationResult(true, 
			                    "sameSecurityAllottedSecurity", "sameSecurityAllottedSecurity", Application.application.xResourceManager.getKeyValue('cax.same.security.allotment.security')));

				        }
				    }        			        			
        		}
        		
        		return;        	

		}		
		
	
	/**
	 * In validator of Cash dividend event type.
	 * 
	 */
	private function validateCashDividendEntry(value:Object):void {
        var dateformat:CustomDateFormatter =new CustomDateFormatter();
        //format of the date
        dateformat.formatString="YYYYMMDD";
        var formatData:String ="";			
			
			var announceDate:String = value.announceDate;
        	if(announceDate != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.announceDate));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.announceDate))) {	                
	                results.push(new ValidationResult(true, 
	                    "announceDateStr", "illegalAnnouncementDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.announcement.date')+" " + value.announceDate+"!"));
	            }        		
        	}
        	
			var expirationDate:String = value.expirationDate;        	
        	if(expirationDate != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.expirationDate));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.expirationDate))) {	                
	                results.push(new ValidationResult(true, 
	                    "expirationDate", "illegalExpirationDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.protect.expiration.date')+" " + value.expirationDate+"!"));
	            }        		
        	}
        	
			var creditDate:String = value.creditDate;         	
        	if(creditDate != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.creditDate));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.creditDate))) {	                
	                results.push(new ValidationResult(true, 
	                    "creditDate", "illegalCreditDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.credit.date')+" " + value.creditDate+"!"));
	            }        		
        	}
        	
			var financialEndDate:String = value.financialEndDate;          	
        	if(financialEndDate != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.financialEndDate));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.financialEndDate))) {	                
	                results.push(new ValidationResult(true, 
	                    "financialEndDate", "illegalFinancialEndDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.financial.year.end.date')+" " + value.financialEndDate+"!"));
	            }        		
        	}        	
        	
        	var specialAllotmentAmt:String = value.specialAllotmentAmt;
			var specialPerShareCash:String = value.specialPerShareCash;        	
	        if((specialAllotmentAmt == "") != (specialPerShareCash == "")) {
		        results.push(new ValidationResult(true, 
		        "specialPerShareAmt", "illegalSpecialPerShareAmt", Application.application.xResourceManager.getKeyValue('cax.spl.allotment.amt.spl.per.share.simultaneous')));
	    	}  
	    	
        	var bookClosingDateStr:String = value.bookClosingDate;
        	if(bookClosingDateStr != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.bookClosingDate));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.bookClosingDate))) {	                
	                results.push(new ValidationResult(true, 
	                    "bookClosingDate", "illegalBookClosingDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.book.closing.date')+" " + value.bookClosingDate+"!"));
	            }        		
        	}	    	      	
        	
        	        	        	        	        		  	      	

		}	
		
	/**
	 * In validator of Stock dividend event type.
	 * 
	 */
	private function validateStockDividentEntry(value:Object):void {
        var dateformat:CustomDateFormatter =new CustomDateFormatter();
        //format of the date
        dateformat.formatString="YYYYMMDD";
        var formatData:String ="";			
        	
        	if(!XenosStringUtils.equals(eventType,"BONUS_ISSUE")) {
        		var announceDateStock:String = value.announceDateStock;        		
	        	if(announceDateStock != "") {	            
		            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.announceDateStock));
		            
		            if(!DateUtils.isValidDate(StringUtil.trim(value.announceDateStock))) {	                
		                results.push(new ValidationResult(true, 
		                    "announceDateStr", "illegalAnnouncementDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.announcement.date')+" " + value.announceDateStock+"!"));
		            }        		
	        	}
	        	
        		var expirationDateStock:String = value.expirationDateStock;  	        	
	        	if(expirationDateStock != "") {	            
		            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.expirationDateStock));
		            
		            if(!DateUtils.isValidDate(StringUtil.trim(value.expirationDateStock))) {	                
		                results.push(new ValidationResult(true, 
		                    "recordDateStr", "illegalRecordDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.protect.expiration.date')+" " + value.expirationDateStock+"!"));
		            }        		
	        	}
	        	
				var creditDateStock:String = value.creditDateStock;  		        	
	        	if(creditDateStock != "") {	            
		            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.creditDateStock));
		            
		            if(!DateUtils.isValidDate(StringUtil.trim(value.creditDateStock))) {	                
		                results.push(new ValidationResult(true, 
		                    "creditDate", "illegalCreditDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.credit.date')+" " + value.creditDateStock)+"!");
		            }        		
	        	}
	        	
				var financialEndDateStock:String = value.financialEndDateStock;  	        	
	        	if(financialEndDateStock != "") {	            
		            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.financialEndDateStock));
		            
		            if(!DateUtils.isValidDate(StringUtil.trim(value.financialEndDateStock))) {	                
		                results.push(new ValidationResult(true, 
		                    "financialEndDate", "illegalFinancialEndDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.financial.year.end.date')+" " + value.financialEndDateStock+"!"));
		            }        		
	        	}		
        	}
        	
			var payOutPriceStock:String = value.payOutPriceStock;  
			var payOutCcyStock:String = value.payOutCcyStock;  				        	
	        if((payOutPriceStock == "") != (payOutCcyStock == "")) {
		        results.push(new ValidationResult(true, 
		        "payoutPriceCcy", "illegalPayoutPriceCcy", Application.application.xResourceManager.getKeyValue('cax.payoutprice.payoutccy.shld.occur.simultaneously')));
	    	}
	    	
	    	
			var specialAllotmentQty:String = value.specialAllotmentQty;  
			var specialPerShare:String = value.specialPerShare;  		    		    	        	
	        if((specialAllotmentQty == "") != (specialPerShare == "")) {
		        results.push(new ValidationResult(true, 
		        "specialPerShareQty", "illegalSpecialPerShareQty", Application.application.xResourceManager.getKeyValue('cax.spl.allotment.qty.spl.per.share.shld.occur.simultaneously')));
	    	}
	    	
        	var bookClosingDateStr:String = value.bookClosingDate;
        	if(bookClosingDateStr != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.bookClosingDate));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.bookClosingDate))) {	                
	                results.push(new ValidationResult(true, 
	                    "bookClosingDate", "illegalBookClosingDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.book.closing.date')+" " + value.bookClosingDate+"!"));
	            }        		
        	}	    	        	
        	
        	        	        	        	        	
		}
		
	/**
	 * In validator of Coupon Payment event type.
	 * 
	 */
	private function validateCouponPaymentEntry(value:Object):void {

        var dateformat:CustomDateFormatter =new CustomDateFormatter();
        //format of the date
        dateformat.formatString="YYYYMMDD";
        var formatData:String ="";			
        	
			var creditDateCoupon:String = value.creditDateCoupon;          	
        	if(creditDateCoupon != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.creditDateCoupon));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.creditDateCoupon))) {	                
	                results.push(new ValidationResult(true, 
	                    "creditDateCoupon", "illegalCreditDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.credit.date')+" " + value.creditDateCoupon));
	            }        		
        	}
        	
			var originalRecordDt:String = value.originalRecordDt;          	
        	if(originalRecordDt != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.originalRecordDt));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.originalRecordDt))) {	                
	                results.push(new ValidationResult(true, 
	                    "originalRecordDate", "illegalOriginalRecordDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.org.record.dt')+" " + value.originalRecordDt));
	            }        		
        	}
        	
			var couponDate:String = value.couponDate;          	
        	if(couponDate != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.couponDate));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.couponDate))) {	                
	                results.push(new ValidationResult(true, 
	                    "couponDate", "illegalCouponDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.coupon.date')+" " + value.couponDate));
	            }        		
        	}else {
        		 results.push(new ValidationResult(true, 
	                    "couponDate", "couponDateMissing", Application.application.xResourceManager.getKeyValue('cax.missing.coupon.date')));
        	}         	
        	        	
        	
        	if(value.couponRate == null || StringUtil.trim(value.couponRate) == ""){
        		 results.push(new ValidationResult(true, 
	                    "couponRate", "couponRateMissing", Application.application.xResourceManager.getKeyValue('cax.missing.coupon.rate')));
        	}
        	
			var prevFactor:String = value.prevFactor;  
			var currFactpr:String = value.currFactpr;  			        	
        	
	        if((prevFactor == "") != (currFactpr == "")) {
		        results.push(new ValidationResult(true, 
		        "currFactPrevFact", "illegalCurrFactPrevFact", Application.application.xResourceManager.getKeyValue('cax.prev.factor.curr.factor')));
	    	}        	        	        	        	        	        	
		
		
		}
		
	/**
	 * In validator of Stock events.
	 * 
	 */
	private function validateStockEventsEntry(value:Object):void {

        var dateformat:CustomDateFormatter =new CustomDateFormatter();
        //format of the date
        dateformat.formatString="YYYYMMDD";
        var formatData:String ="";			
        	
        	var announceDateCapRd:String = value.announceDateCapRd;  
        	if(announceDateCapRd != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.announceDateCapRd));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.announceDateCapRd))) {	                
	                results.push(new ValidationResult(true, 
	                    "announceDateCapRd", "illegalAnnounceDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.announcement.dt')+" " + value.announceDateCapRd+"!"));
	            }        		
        	}

        	var expirationDateCapRd:String = value.expirationDateCapRd;          	
        	if(expirationDateCapRd != ""){	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.expirationDateCapRd));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.expirationDateCapRd))) {	                
	                results.push(new ValidationResult(true, 
	                    "expirationDateCapRd", "illegalExpirationDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.protect.expiration.date')+" " + value.expirationDateCapRd+"!"));
	            }        		
        	}
        	
        	var payOutPriceCommon:String = value.payOutPriceCommon;
        	var payOutCcyCommon:String = value.payOutCcyCommon;        	        	
        	        	
	        if((payOutPriceCommon == "") != (payOutCcyCommon == "")) {
		        results.push(new ValidationResult(true, 
		        "payoutPriceCcy", "illegalPayoutPriceCcy", Application.application.xResourceManager.getKeyValue('cax.payoutprice.payoutccy.shld.occur.simultaneously')));
	    	}
	    	
        	var bookClosingDateStr:String = value.bookClosingDate;
        	if(bookClosingDateStr != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.bookClosingDate));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.bookClosingDate))) {	                
	                results.push(new ValidationResult(true, 
	                    "bookClosingDate", "illegalBookClosingDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.book.closing.date')+" "+ value.bookClosingDate+"!"));
	            }        		
        	}	    	        	
        	
        	              	      	        	        	        	        					
		}		
		
	/**
	 * In validator of Rights Issue/Expiry.
	 * 
	 */
	private function validateRightsIssueEntry(value:Object):void {

        var dateformat:CustomDateFormatter =new CustomDateFormatter();
        //format of the date
        dateformat.formatString="YYYYMMDD";
        var formatData:String ="";			
        	
        	var rightsExpiryDateRights:String = value.rightsExpiryDateRights;        	
        	if(rightsExpiryDateRights != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.rightsExpiryDateRights));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.rightsExpiryDateRights))) {	                
	                results.push(new ValidationResult(true, 
	                    "rightsExpiryDateRights", "illegalRightsExpiryDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.rights.expiry.date')+" " + value.rightsExpiryDateRights+"!"));
	            }        		
        	}
        	
        	var creditDateRights:String = value.creditDateRights;          	
        	if(creditDateRights != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.creditDateRights));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.creditDateRights))) {	                
	                results.push(new ValidationResult(true, 
	                    "creditDateRights", "illegalCreditDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.credit.date')+" "  + value.creditDateRights+"!"));;
	            }        		
        	}
        	  
        	var deadlineDateRights:String = value.deadlineDateRights;         	
        	if(deadlineDateRights != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.deadlineDateRights));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.deadlineDateRights))) {	                
	                results.push(new ValidationResult(true, 
	                    "deadlineDateRights", "illegalDeadlineDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.deadline.date')+" " + value.deadlineDateRights+"!"));
	            }        		
        	}
        	
        	var paymentDateTakeUpStr:String = value.paymentDateTakeUpStr;          	
	        if(paymentDateTakeUpStr != "") {	            
		    	formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.paymentDateTakeUpStr));
		    	    
		    	if(!DateUtils.isValidDate(StringUtil.trim(value.paymentDateTakeUpStr))) {	                
		    		results.push(new ValidationResult(true, 
		                    "paymentDateTakeUpStr", "illegalPaymentDateTakeUp", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.payment.date.takeup')+" "+ value.paymentDateTakeUpStr+"!"));;
		    	}        		
			} else {
	        		results.push(new ValidationResult(true, 
			                "paymentDateTakeUpStr", "paymentDateTakeUpStrMissing", Application.application.xResourceManager.getKeyValue('cax.missing.payment.date.takeup')));
	        }
	        	         	        	        	        		
	        if(value.takeUpCostRights == null || StringUtil.trim(value.takeUpCostRights) == ""){
	        	 results.push(new ValidationResult(true, 
		    				"takeUpCost", "takeUpCostMissing", Application.application.xResourceManager.getKeyValue('cax.missing.takeup.cost')));
	        }   
	        	
	        if(value.takeUpCcyRights == null || StringUtil.trim(value.takeUpCcyRights) == ""){
	        	 results.push(new ValidationResult(true, 
		    				"takeUpCcyRights", "takeUpCcyMissing", Application.application.xResourceManager.getKeyValue('cax.missing.takeup.ccy')));
	        }
        	         	        	        	
        	
        	// XGA-201
        	var rightsPaymentDateStr:String = value.rightsPaymentDateStr;
			if(rightsPaymentDateStr != "") {      
				formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.rightsPaymentDateStr));
		            
				if(!DateUtils.isValidDate(StringUtil.trim(value.rightsPaymentDateStr))) {
					results.push(new ValidationResult(true, 
		                    "rightsPaymentDateStr", "illegalRightsPaymentDate", Application.application.xResourceManager.getKeyValue('cax.illegal.rights.payment.date')+" "+ value.rightsPaymentDateStr+"!"));	
				}
			} else {
				results.push(new ValidationResult(true, 
		                    "rightsPaymentDateStr", "illegalRightsPaymentDate", Application.application.xResourceManager.getKeyValue('cax.missing.rights.payment.date')));
			}
        	
        	if(value.allottedRightsInst == null || StringUtil.trim(value.allottedRightsInst) == ""){
        		results.push(new ValidationResult(true, 
	                    "allottedRightsInst", "allottedRightsInstrumentMissing", Application.application.xResourceManager.getKeyValue('cax.missing.allotment.rights.instrument')));
        	}
        	
        	if(value.allottedRightsQtyAmt == null || StringUtil.trim(value.allottedRightsQtyAmt) == ""){
				results.push(new ValidationResult(true, 
		                    "allottedRightsQtyAmt", "allotmentRightsQty/AmountMissing", Application.application.xResourceManager.getKeyValue('cax.missing.allotment.rightsqty.amt')));
			}
			
			if(value.perShareRightsStr == null || StringUtil.trim(value.perShareRightsStr) == ""){
				results.push(new ValidationResult(true, 
		                    "perShareRightsStr", "perShareRightsMissing", Application.application.xResourceManager.getKeyValue('cax.missing.per.share.rights')));
			}
        	
			var instrumentCode:String = value.instrumentCode; 
			var allottedInst:String = value.allottedInst;
			var allottedRightsInst:String = value.allottedRightsInst;
			
			if(value.instrumentCode != null && StringUtil.trim(value.allottedRightsInst) != "") {
				if(instrumentCode==allottedRightsInst) {
					results.push(new ValidationResult(true, 
						"sameSecurityAllottedRightsSecurity", "sameSecurityAllottedRightsSecurity", Application.application.xResourceManager.getKeyValue('cax.same.security.allotment.rights.security')));
				}
			}
			
			if(value.allottedInst != null && StringUtil.trim(value.allottedRightsInst) != "") {
				if(allottedInst==allottedRightsInst) {
					results.push(new ValidationResult(true, 
						"sameAllottedSecurityAllottedRightsSecurity", "sameAllottedSecurityAllottedRightsSecurity", Application.application.xResourceManager.getKeyValue('cax.same.allotment.security.allotment.rights.security')));
				}
			}
		}
		
	/**
	 * In validator of StockCashOption.
	 * 
	 */
	private function validateStockCashOptionEntry(value:Object):void {

        var dateformat:CustomDateFormatter =new CustomDateFormatter();
        //format of the date
        dateformat.formatString="YYYYMMDD";
        var formatData:String ="";			
        	
			var deadlineDateCashStock:String = value.deadlineDateCashStock;            	
        	if(deadlineDateCashStock != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.deadlineDateCashStock));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.deadlineDateCashStock))) {	                
	                results.push(new ValidationResult(true, 
	                    "deadlineDate", "illegalDeadlineDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.deadline.date')+" " + value.deadlineDateCashStock+"!"));
	            }        		
        	}
        	
			var rightsExpiryDateCashStock:String = value.rightsExpiryDateCashStock;           	
        	if(rightsExpiryDateCashStock != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.rightsExpiryDateCashStock));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.rightsExpiryDateCashStock))) {	                
	                results.push(new ValidationResult(true, 
	                    "rightsExpiryDate", "illegalRightsExpiryDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.rights.expiry.date')+" " + value.rightsExpiryDateCashStock+"!"));
	            }        		
        	}
        	
        	var bookClosingDateStr:String = value.bookClosingDate;
        	if(bookClosingDateStr != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.bookClosingDate));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.bookClosingDate))) {	                
	                results.push(new ValidationResult(true, 
	                    "bookClosingDate", "illegalBookClosingDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.book.closing.date')+" " + value.bookClosingDate+"!"));
	            }        		
        	}        	          	        	        	        	
        	
        	
        	      	      	        	        	        	        					
		}	
		
	/**
	 * In validator of Others.
	 * 
	 */
	private function validateOthersEntry(value:Object):void {

        var dateformat:CustomDateFormatter =new CustomDateFormatter();
        //format of the date
        dateformat.formatString="YYYYMMDD";
        var formatData:String ="";			
        	
			var excerciseDateOthers:String = value.excerciseDateOthers;             	
        	if(excerciseDateOthers != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.excerciseDateOthers));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.excerciseDateOthers))) {	                
	                results.push(new ValidationResult(true, 
	                    "excerciseDate", "illegalExcerciseDate", Application.application.xResourceManager.getKeyValue('cax.ileegal.date.format.exercise.date')+" " + value.excerciseDateOthers+"!"));
	            }        		
        	}
        	
			var rightsExpiryDateOthers:String = value.rightsExpiryDateOthers;           	
        	if(rightsExpiryDateOthers != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.rightsExpiryDateOthers));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.rightsExpiryDateOthers))) {	                
	                results.push(new ValidationResult(true, 
	                    "rightsExpiryDate", "illegalRightsExpiryDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.rights.expiry.date')+" "+ value.rightsExpiryDateOthers+"!"));
	            }        		
        	} 
        	
			var deadLineDateOthrs:String = value.deadLineDateOthrs;         	
        	if(deadLineDateOthrs != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.deadLineDateOthrs));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.deadLineDateOthrs))) {	                
	                results.push(new ValidationResult(true, 
	                    "deadlineDate", "illegalDeadlineDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.deadline.date')+" " + value.deadLineDateOthrs+"!"));
	            }        		
        	}

        	if(value.eventTypeNameOthers == null || StringUtil.trim(value.eventTypeNameOthers) == ""){
        		 results.push(new ValidationResult(true, 
	                    "eventTypeName", "eventTypeNameMissing", Application.application.xResourceManager.getKeyValue('cax.missing.event.type.name')));
        	}          	        	         	        	        	        	
        	
        	
        	      	      	        	        	        	        					
		}
		
	/**
	 * In validator of Redemption Bond.
	 * 
	 */
	private function validateRedemptionBondEntry(value:Object):void {

        var dateformat:CustomDateFormatter =new CustomDateFormatter();
        //format of the date
        dateformat.formatString="YYYYMMDD";
        var formatData:String ="";			
        	
        	if(value.instrumentCode == null || StringUtil.trim(value.instrumentCode) == ""){
        		 results.push(new ValidationResult(true, 
	                    "instrumentCode", "instrumentCodeMissing", Application.application.xResourceManager.getKeyValue('cax.missing.security.code')));
        	}      
        	
        	if(value.redemptionCcyRedmp == null || StringUtil.trim(value.redemptionCcyRedmp) == ""){
        		 results.push(new ValidationResult(true, 
	                    "redemptionCcy", "redemptionCcyMissing", Application.application.xResourceManager.getKeyValue('cax.missing.redemption.ccy')));
        	}          	  	
        	
			// redemption date
			var redemptionDateRedmp:String = value.redemptionDateRedmp;  			
        	if(redemptionDateRedmp != "") {            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.redemptionDateRedmp));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.redemptionDateRedmp))) {	                
	                results.push(new ValidationResult(true, 
	                    "redemptionDate", "illegalRedemptionDate", Application.application.xResourceManager.getKeyValue('cax.illegal.format.redemption.date')+" " + value.redemptionDateRedmp+"!"));
	            }        		
        	} 
        	
			// payment date
			var paymentDateStr:String = value.paymentDateStr;  			
        	if(paymentDateStr != "") {            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.paymentDateStr));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.paymentDateStr))) {	                
	                results.push(new ValidationResult(true, 
	                    "paymentDateStr", "illegalPaymentDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.payment.date')+" " + value.paymentDateStr+"!"));
	            }        		
        	} 
        	
			// redemption date
			var creditDateRedmp:String = value.creditDateRedmp;  			
        	if(creditDateRedmp != "") {            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.creditDateRedmp));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.creditDateRedmp))) {	                
	                results.push(new ValidationResult(true, 
	                    "creditDate", "illegalCreditDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.credit.date')+" " + value.creditDateRedmp+"!"));
	            }        		
        	}        	
        	

        	if(value.rateOfNominalRedmp == null || StringUtil.trim(value.rateOfNominalRedmp) == ""){
        		 results.push(new ValidationResult(true, 
	                    "rateOfNominal", "rateOfNominalMissing", Application.application.xResourceManager.getKeyValue('cax.missing.rate.nominal')));
        	}  
        	
        	if(value.redemptionPriceRights == null || StringUtil.trim(value.redemptionPriceRights) == ""){
        		 results.push(new ValidationResult(true, 
	                    "redemptionPrice", "redemptionPriceMissing", Application.application.xResourceManager.getKeyValue('cax.missing.redemption.price')));
        	}
        	
        	// record date
        	if(value.mode == 'amend'){        		
        	
				var recordDateStr:String = value.recordDateStr;
	        	if(recordDateStr != "") {	            
		            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.recordDateStr));
		            
		            if(!DateUtils.isValidDate(StringUtil.trim(value.recordDateStr))) {	                
		                results.push(new ValidationResult(true, 
		                    "recordDateStr", "illegalRecordDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.record.date')+" " + value.recordDateStr+"!"));
		            }        		
	        	} else {
	        		 results.push(new ValidationResult(true, 
		                    "recordDateStr", "recordDateMissing", Application.application.xResourceManager.getKeyValue('cax.missing.record.date')));
	        	}          	        	        	         	        	        	        	
        	}
        	
        	      	      	        	        	        	        					
		}	
		
	/**
	 * In validator of Stock Merger.
	 * 
	 */
	private function validateStockMergerEntry(value:Object):void {

        var dateformat:CustomDateFormatter =new CustomDateFormatter();
        //format of the date
        dateformat.formatString="YYYYMMDD";
        var formatData:String ="";			
        	
        	
        	if(value.allottedInst == null || StringUtil.trim(value.allottedInst) == ""){
        		 results.push(new ValidationResult(true, 
	                    "allottedInst", "allottedInstrumentMissing", Application.application.xResourceManager.getKeyValue('cax.missing.allotment.instrument')));
        	}      	
        	
        	
			// announceDate date
			var announceDateMerger:String = value.announceDateMerger;  					
        	if(announceDateMerger != "") {            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.announceDateMerger));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.announceDateMerger))) {	                
	                results.push(new ValidationResult(true, 
	                    "announceDate", "illegalAnnounceDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.announcement.dt')+" " + value.announceDateMerger+"!"));
	            }        		
        	}         	 
        	
			// ex date			
				var exDateStr:String = value.exDateStr;				
	        	if(exDateStr != "") {	            
		            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.exDateStr));		            
		            if(!DateUtils.isValidDate(StringUtil.trim(value.exDateStr))) {	                
		                results.push(new ValidationResult(true, 
		                    "exDateStr", "illegalExDate", Application.application.xResourceManager.getKeyValue('cax.illegal.exdate')+" " + value.exDateStr+"!"));
		            }        		
	        	} else {
	        		 results.push(new ValidationResult(true, 
		                    "exDateStr", "exDateMissing", Application.application.xResourceManager.getKeyValue('cax.missing.execution.date')));
	        	}
			// payment date			
				var paymentDateStr:String = value.paymentDateStr;
	        	if(paymentDateStr != "") {      
		            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.paymentDateStr));
		            
		            if(!DateUtils.isValidDate(StringUtil.trim(value.paymentDateStr))) {	                
		                results.push(new ValidationResult(true, 
		                    "paymentDateStr", "illegalPaymentDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.payment.date')+" " + value.paymentDateStr+"!"));
		            }        		
	        	} else {
	        		 results.push(new ValidationResult(true, 
		                    "paymentDateStr", "paymentdateMissing", Application.application.xResourceManager.getKeyValue('cax.missing.payment.date')));
	        	}       	
        	
			// record date
			var recordDateStr:String = value.recordDateStr;
        	if(recordDateStr != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.recordDateStr));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.recordDateStr))) {	                
	                results.push(new ValidationResult(true, 
	                    "recordDateStr", "illegalRecordDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.record.date')+" " + value.recordDateStr+"!"));
	            }        		
        	} else {
        		 results.push(new ValidationResult(true, 
	                    "recordDateStr", "recordDateMissing", Application.application.xResourceManager.getKeyValue('cax.missing.record.date')));
        	}        	
        	
			// expirationDateMerger date
			var expirationDateMerger:String = value.expirationDateMerger;  			
        	if(expirationDateMerger != "") {            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.expirationDateMerger));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.expirationDateMerger))) {	                
	                results.push(new ValidationResult(true, 
	                    "expirationDateMerger", "illegalExpirationDate", Application.application.xResourceManager.getKeyValue('cax.illegal.protext.expiration.date')+" " + value.expirationDateMerger+"!"));
	            }        		
        	}       	        	
        	
        	var stockListforValidation:ArrayCollection = value.stockInfoList as ArrayCollection;
        	
        	if(stockListforValidation.length < 1) {
        		 results.push(new ValidationResult(true, 
	                    "StockEntry", "addStockEntryInfo", Application.application.xResourceManager.getKeyValue('cax.error.no.of.stocks')));
        		
        	}
        	
        	var bookClosingDateStr:String = value.bookClosingDate;
        	if(bookClosingDateStr != "") {	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.bookClosingDate));
	            
	            if(!DateUtils.isValidDate(StringUtil.trim(value.bookClosingDate))) {	                
	                results.push(new ValidationResult(true, 
	                    "bookClosingDate", "illegalBookClosingDate", Application.application.xResourceManager.getKeyValue('cax.illegal.date.format.book.closing.date')+" " + value.bookClosingDate+"!"));
	            }        		
        	}        	
        	 	      	      	        	        	        	        					
		}					
	
	}
}