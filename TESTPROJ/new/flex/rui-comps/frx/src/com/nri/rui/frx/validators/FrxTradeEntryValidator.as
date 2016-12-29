// ActionScript file


package com.nri.rui.frx.validators
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.core.Application;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
   
    
    /**
     * Custom Validator for Banking Trade Entry Implementation.
     * 
     */
	public class FrxTradeEntryValidator extends Validator {
		// Define Array for the return value of doValidation().
        private var results:Array;

        // constructor
		public function FrxTradeEntryValidator() {
			super();
		}
		
		/**
         * validate banking trade entry form
         */ 
        protected override function doValidation(value:Object):Array {
        	
        	// Clear results Array.
            results = [];
            var formatData:String ="";
            var dateformat:CustomDateFormatter = new CustomDateFormatter();

            // Call base class's doValidation().
            results = super.doValidation(value);

            // Return if there are errors.
            if (results.length > 0)
                return results;              
        	if(value.fundAccNo == null || StringUtil.trim(value.fundAccNo) == ""){
        		 results.push(new ValidationResult(true, 
	                    "fundAccNo", "fundAccNoMissing", Application.application.xResourceManager.getKeyValue('frx.missing.funaccount')));
        	}
        	if(value.tradeType == null || StringUtil.trim(value.tradeType) == ""){
        		 results.push(new ValidationResult(true, 
	                    "tradeType", "tradeTypeMissing", Application.application.xResourceManager.getKeyValue('frx.missing.tradetype')));
        	}
        	var tradeDateDt:Date = null;
        	if(value.tradeDate != ""){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString="YYYYMMDD";
	            formatData="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.tradeDate));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.tradeDate))) {
	                
	                results.push(new ValidationResult(true, 
	                    "tradeDate", "illegalTradeDate", Application.application.xResourceManager.getKeyValue('frx.error.illegal.tradedateformat') + value.tradeDate));
	            }else{
	            	tradeDateDt = dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.tradeDate));
	            }
        	}else{
        		 results.push(new ValidationResult(true, 
	                    "tradeDate", "tradeDateMissing", Application.application.xResourceManager.getKeyValue('frx.missing.tradedate')));
        	}
        	var valueDateDt:Date = null;
        	if(value.valueDate != ""){
	            dateformat = new CustomDateFormatter();
	            dateformat.formatString="YYYYMMDD";
	            formatData="";	            
	            formatData=dateformat.format(CustomDateFormatter.customizedInputDateString(value.valueDate));
	            if(!DateUtils.isValidDate(StringUtil.trim(value.valueDate))) {
	                results.push(new ValidationResult(true, 
	                    "valueDate", "illegalValueDate", Application.application.xResourceManager.getKeyValue('frx.error.illegal.valuedateformat') + value.valueDate));
	            }else{
	            	valueDateDt = dateformat.toDate(CustomDateFormatter.customizedInputDateString(value.valueDate));
	            }
        	}else{
        		 results.push(new ValidationResult(true, 
	                    "valueDate", "valueDateMissing", Application.application.xResourceManager.getKeyValue('frx.missing.valuedate')));
        	}
        	var comDate:int = 0;
        	if(valueDateDt != null && tradeDateDt != null){
        		if(ObjectUtil.dateCompare(tradeDateDt,valueDateDt) == 1){
	        		results.push(new ValidationResult(true, 
	                    "", "valueDateLessThanTradeDate", Application.application.xResourceManager.getKeyValue('frx.error.compare.trddate.valdate')));
	        	}
        	}
        	
        	
        	if(value.buySell == null || StringUtil.trim(value.buySell) == ""){
        		 results.push(new ValidationResult(true, 
	                    "buySell", "buySellMissing", Application.application.xResourceManager.getKeyValue('frx.missing.buysell')));
        	}
        	
        	if(value.counterPartyAccNo == null || StringUtil.trim(value.counterPartyAccNo) == ""){
        		 results.push(new ValidationResult(true, 
	                    "counterPartyAccNo", "counterPartyAccNoMissing", Application.application.xResourceManager.getKeyValue('frx.missing.cpaccount')));
        	}
        	
        	if(value.tradeCcy == null || StringUtil.trim(value.tradeCcy) == ""){
        		 results.push(new ValidationResult(true, 
	                    "tradeCcy", "tradeCcyMissing", Application.application.xResourceManager.getKeyValue('frx.missing.buyccy')));
        	}        	
        	
        	if(value.counterCcy == null || StringUtil.trim(value.counterCcy) == ""){
        		 results.push(new ValidationResult(true, 
	                    "counterCcy", "counterCcyMissing", Application.application.xResourceManager.getKeyValue('frx.missing.sellccy')));
        	}
        	
        	
        	
        	
        	if(value.check == "true"){
        		if(((value.exchngRate == null || StringUtil.trim(value.exchngRate) == "") && (value.tradeCcyAmt == null || StringUtil.trim(value.tradeCcyAmt) == ""))
        		|| ((value.tradeCcyAmt == null || StringUtil.trim(value.tradeCcyAmt) == "") && (value.counterCcyAmt == null || StringUtil.trim(value.counterCcyAmt) == ""))
        		|| ((value.exchngRate == null || StringUtil.trim(value.exchngRate) == "") && (value.counterCcyAmt == null || StringUtil.trim(value.counterCcyAmt) == "")))
        		{
        		results.push(new ValidationResult(true, 
	                    "", "anyTwoOfBuyCcyAmountSellCcyAmountExchangeRateMissing", Application.application.xResourceManager.getKeyValue('frx.missing.any.two.buyccyamt.sellccyamt.exchangerate')));
        		}
		        if((value.exchngRateCalcType == null || StringUtil.trim(value.exchngRateCalcType) == "") &&  value.exchngRate != ""){
		        results.push(new ValidationResult(true,
		         "", "calculationMechanismMissing",Application.application.xResourceManager.getKeyValue('frx.missing.calculation.mechanism.nonblank.rate')));	
	        	}
		        	
		        /* if (!XenosStringUtils.isBlank(value.exchngRateCalcType) && ( value.exchngRate == null || StringUtil.trim(value.exchngRate) == "") ){
		        	//Calculation Type present and Exchange Rate Not Present
				   if(  
				        //Buy Amount Present Sell Amount Not Present OR
				        (!(value.tradeCcyAmt == null || StringUtil.trim(value.tradeCcyAmt) == "") && (value.counterCcyAmt == null || StringUtil.trim(value.counterCcyAmt) == "")) || 
				        //Buy Amount Not Present Sell Amount Present OR
				        ((value.tradeCcyAmt == null || StringUtil.trim(value.tradeCcyAmt) == "") && !(value.counterCcyAmt == null || StringUtil.trim(value.counterCcyAmt) == "")) ||
				        //Buy Amount Not Present Sell Amount Not Present 
				        ((value.tradeCcyAmt == null || StringUtil.trim(value.tradeCcyAmt) == "") && (value.counterCcyAmt == null || StringUtil.trim(value.counterCcyAmt) == "")) )  {
					
					   // Show Validation
				           results.push(new ValidationResult(true,
		                          "", "exchangeRateMissing", Application.application.xResourceManager.getKeyValue('frx.missing.exchangerate.nonblank.calculationmethodfwdspot')));	
					}
                } */
		        	        		        		       		
	        	if(value.confimationStatus == null || StringUtil.trim(value.confimationStatus) == ""){
	        		 results.push(new ValidationResult(true, 
		                    "confimationStatus", "confimationStatusMissing", Application.application.xResourceManager.getKeyValue('frx.missing.confstatus')));
	        	}
        	}
        	else{
        	if(value.tradeCcyAmt == null || StringUtil.trim(value.tradeCcyAmt) == ""){
        		 results.push(new ValidationResult(true, 
	                    "tradeCcyAmt", "tradeCcyAmtMissing", Application.application.xResourceManager.getKeyValue('frx.missing.buyccyamnt')));
        	}
        	if(value.exchngRate == null || StringUtil.trim(value.exchngRate) == ""){
        		 results.push(new ValidationResult(true, 
	                    "exchngRate", "exchngRateMissing", Application.application.xResourceManager.getKeyValue('frx.missing.exchangerate')));
        	}
        	}
        	
        	if(value.tradeType == "Non Deliverable Forward" && value.mode == "entry"){
        		if(StringUtil.trim(value.settlementCcy)!= "" && StringUtil.trim(value.sellCcy)!= ""){
        		    if( !XenosStringUtils.equals(value.sellCcy,value.settlementCcy)){
        			     results.push(new ValidationResult(true, 
		                         "sellCcy", "settlementCcyVssellCcyNotEqual", Application.application.xResourceManager.getKeyValue('frx.notEqual.settlementCcyVsSellCcy')));
        		     }
        		}
        	}
        		if(value.tradeType == "Non Deliverable Forward" && value.mode == "amend"){
        		
        			
        			 if(value.buySell == "B"){
        			 	   if(StringUtil.trim(value.settlementCcy)!= "" && StringUtil.trim(value.sellCcy)!= ""){
        		                if( !XenosStringUtils.equals(value.sellCcy,value.settlementCcy)){
        			                   results.push(new ValidationResult(true, 
		                                            "buySell", "buySellBVsAmend", Application.application.xResourceManager.getKeyValue('frx.error.buySell.B')));
        		                  }
        		             }
        		  }else{
        		  	    if(StringUtil.trim(value.sellCcy)!= ""){
        			                         results.push(new ValidationResult(true, 
		                                               "buySell", "buySellSVsAmend", Application.application.xResourceManager.getKeyValue('frx.error.buySell.S')));
		                     }
        		  }
        		
        	}
        	return results;
        }
		
	}
}