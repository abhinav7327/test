package com.nri.rui.adp.validator
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	
	import mx.core.Application;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	public class SegregateBalanceQueryValidator extends Validator
	{
		public var results:Array=[];
        
        public function SegregateBalanceQueryValidator()
        {
            super();
        }
        
        protected override function doValidation(queryModel:Object):Array
        {
            results = super.doValidation(queryModel);            
            if (results.length > 0)
            {
                return results;             
            }
            
            var formatData:String = "";
            var dateformat:CustomDateFormatter = new CustomDateFormatter();
            dateformat.formatString="YYYYMMDD";
            
            var securityCode:String = StringUtil.trim(queryModel.securityCode);
            var fundCode:String = StringUtil.trim(queryModel.fundCode);
            var segregateDateFrom: String = StringUtil.trim(queryModel.segregateDateFrom);
            var segregateDateTo: String = StringUtil.trim(queryModel.segregateDateTo);
            
            var objSegregateDateFrom:Date =  null ;
            var objSegregateDateTo:Date =  null ;
            var mode:String = StringUtil.trim(queryModel.mode);
            //XenosAlert.info("Mode: "+mode);
            if(mode != "query"){
	            if(securityCode == ""){
	                results.push(new ValidationResult(true,"securityCode", "securityCodeMissing", Application.application.xResourceManager.getKeyValue('adp.segregatebalance.validator.entry.securityCodeMissing')));
	            }
            }
            
            if(segregateDateFrom != ""){
                if(DateUtils.isValidDate(StringUtil.trim(segregateDateFrom))){
                    objSegregateDateFrom = dateformat.toDate(CustomDateFormatter.customizedInputDateString(segregateDateFrom));                 
                }else{
                    results.push(new ValidationResult(true, "segregateDateFrom", "illegalDateFormat",  Application.application.xResourceManager.getKeyValue('adp.segregatebalance.validator.query.invalidSegregateFromDate') + " [  " + segregateDateFrom + " ] "));
                    return results;                 
                }
            }
            
            if(segregateDateTo != ""){
                if(DateUtils.isValidDate(StringUtil.trim(segregateDateTo))){
                    objSegregateDateTo = dateformat.toDate(CustomDateFormatter.customizedInputDateString(segregateDateTo));                 
                }else{
                    results.push(new ValidationResult(true, "segregateDateTo", "illegalDateFormat",  Application.application.xResourceManager.getKeyValue('adp.segregatebalance.validator.query.invalidSegregateToDate')+ " [  " + segregateDateTo + " ] "));
                    return results;                 
                }
            }
            
            if((objSegregateDateFrom != null) && (objSegregateDateTo != null)) {
                if(ObjectUtil.dateCompare(objSegregateDateTo,objSegregateDateFrom) == -1){
                    results.push(new ValidationResult(true, "", "segregateDateFromGreaterThanTo",  Application.application.xResourceManager.getKeyValue('adp.segregatebalance.validator.segregateDateFromGreaterThanToQuery')));
                    return results;
                }
            }
            
            return results;         
        }
	}
}