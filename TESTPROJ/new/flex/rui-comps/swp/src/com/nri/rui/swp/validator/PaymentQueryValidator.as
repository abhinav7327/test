package com.nri.rui.swp.validator
{
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.utils.DateUtils;
    
    import mx.core.Application;
    import mx.utils.ObjectUtil;
    import mx.utils.StringUtil;
    import mx.validators.ValidationResult;
    import mx.validators.Validator;

	public class PaymentQueryValidator extends Validator
	{
		public var results:Array=[];
		
		public function PaymentQueryValidator()
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
            
            var dateList:Array = [];
            var dateObj:Array = [];
            
            var dateformat:CustomDateFormatter = new CustomDateFormatter();
            dateformat.formatString="YYYYMMDD";
            var formatData:String = "";
            
            var valueDateFrom:String =  queryModel.valueDateFrom;
            var valueDateTo:String =  queryModel.valueDateTo;
            var tradeDateFrom:String =  queryModel.tradeDateFrom;
            var tradeDateTo:String =  queryModel.tradeDateTo;
            var maturityDateFrom:String =  queryModel.maturityDateFrom;
            var maturityDateTo:String =  queryModel.maturityDateTo;
            var terminationDateFrom:String =  queryModel.terminationDateFrom;
            var terminationDateTo:String =  queryModel.terminationDateTo;
            
            if(valueDateFrom != ""){
                dateList.push(valueDateFrom);
                var objValueDateFrom:Date = dateformat.toDate(CustomDateFormatter.customizedInputDateString(valueDateFrom));
            }
            if(valueDateTo != ""){
                dateList.push(valueDateTo);
                var objValueDateTo:Date = dateformat.toDate(CustomDateFormatter.customizedInputDateString(valueDateTo));
            }
            if(tradeDateFrom != "")
                dateList.push(tradeDateFrom);
            if(tradeDateTo != "")
                dateList.push(tradeDateTo);
            if(maturityDateFrom != "")
                dateList.push(maturityDateFrom);
            if(maturityDateTo != "")
                dateList.push(maturityDateTo);
            if(terminationDateFrom != "")
                dateList.push(terminationDateFrom);
            if(terminationDateTo != "")
                dateList.push(terminationDateTo);
                            
            for(var iterator:int=0; iterator<dateList.length; iterator++){
                formatData = dateformat.format(CustomDateFormatter.customizedInputDateString(dateList[iterator]));                
                if(DateUtils.isValidDate(StringUtil.trim(dateList[iterator]))){
                    dateObj[iterator] = dateformat.toDate(CustomDateFormatter.customizedInputDateString(dateList[iterator]));                 
                }else{                    
                    results.push(new ValidationResult(true,"toDate", "illegaltoDate",  Application.application.xResourceManager.getKeyValue('swp.cashflow.validator.illegalDateFormat') + dateList[iterator]));
                    return results;
                }            
            }
            
            for(var itr:int=0; itr<dateObj.length; itr+=2){
                var comDate:int = ObjectUtil.dateCompare(dateObj[itr],dateObj[itr+1]);
                // check Form Date not less than To Date
                if (comDate==1) {
                    results.push(new ValidationResult(true,"", "fromDateLessThantoDate",  Application.application.xResourceManager.getKeyValue('swp.cashflow.validator.fromtodate')));
                }
            }
                           
            return results;
        }
		
	}
}