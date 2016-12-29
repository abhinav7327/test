
// ActionScript file for Fail Balance Query

import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.utils.ProcessResultUtil;

import mx.collections.ArrayCollection;
import mx.binding.utils.BindingUtils;

	public var obj:Object = {};
    [Bindable]
    public var fundCode:String;
    [Bindable]
    public var ccy:String;
    [Bindable]
    public var baseDate:String;
    [Bindable]
    public var bankCode:String;
    [Bindable]
    public var bankAccountNo:String;
    [Bindable]
    public var drFlag:String;
    [Bindable]
    private var queryResult:ArrayCollection = new ArrayCollection();
    private var sortUtil: ProcessResultUtil = new ProcessResultUtil();

	/**
	 * Load the fail balance query.
	 */
    public function loadAll():void {
     	parseUrlString();
     	super.setXenosQueryControl(new XenosQuery());
     	this.dispatchEvent(new Event('querySubmit'));
    }
	
	/**
	 * Method to be execute before query.
	 */
    override public function preQuery():void {
        super.getSubmitQueryHttpService().url = "stl/stlFailQueryDispatchCashProj.action?";  
        super.getSubmitQueryHttpService().request = populateRequestParams();
	}

	/**
	 * Extracts the parameters and set them to some variables for 
	 * query criteria from the Module Loader Info.
	 */
	public function parseUrlString():void {
        try {
            // Remove everything before the question mark, including
            // the question mark.
            var myPattern : RegExp = /.*\?/; 
            var url : String = this.loaderInfo.url.toString();
            url = url.replace(myPattern, "");
            // Create an Array of name=value Strings.
            var params:Array = url.split("&"); 
            // Print the params that are in the Array.
            var keyStr:String;
            var valueStr:String;
            var paramObj:Object = params;
            // Set the values of the salutation.
            for (var i:int = 0; i < params.length; i++) {
                var tempA:Array = params[i].split("=");  
                if (tempA[0] == Globals.FUND_CODE) {
                    obj.fundCode = tempA[1];
                    fundCode = obj.fundCode;
                } 
                if (tempA[0] == Globals.CURRENCY) {
                    obj.ccy = tempA[1];
                    ccy = obj.ccy;
                } 
                if (tempA[0] == Globals.DATE_FROM) {
                    obj.baseDate = tempA[1];
                    baseDate = obj.baseDate;
                } 
                if (tempA[0] == Globals.BANK_CODE) {
                    obj.bankCode = tempA[1];
                    bankCode = obj.bankCode;
                } 
                if (tempA[0] == Globals.BANK_ACCOUNT_NO) {
                    obj.bankAccountNo = tempA[1];
                    bankAccountNo = obj.bankAccountNo;
                } 
                if (tempA[0] == Globals.DR_FLAG) {
                    obj.drFlag = tempA[1];
                    drFlag = obj.drFlag;
                } 
            } 
        } catch (e:Error) {
            trace(e);
        }
    }
    
    /**
     * This method will populate the request parameters for the submitQuery call 
     * and bind the parameters with the HTTPService object.
     */
   	private function populateRequestParams():Object {
        var reqObj : Object = new Object();
        reqObj.method = "submitQuery";
        reqObj.SCREEN_KEY = 11076;
        reqObj.fundCode = fundCode;
        reqObj.settlementCcy = ccy;
        reqObj.firmBankCode = bankCode;
        reqObj.firmBankAccount = bankAccountNo;
        reqObj.valueDateTo = baseDate;
        reqObj.deliverReceiveFlag = drFlag;
        
        return reqObj;
    }
    
    /**
     * Method to be executed after query.
     */
    override public function postQueryResultHandler(mapObj:Object):void {
    	commonResult(mapObj);
    }

	/**
	 * Result handler method after query.
	 */
    private function commonResult(mapObj:Object):void {
    	if(mapObj != null) {   
	    	if(mapObj["errorFlag"].toString() == "error") {
	    		queryResult.removeAll();
	    		errPage.showError(mapObj["errorMsg"]);
	    	} else {
	    		if(mapObj["errorFlag"].toString() == "noError") {
		    	    errPage.clearError(super.getSubmitQueryResultEvent());
	                queryResult.removeAll();
	                queryResult = mapObj["row"];
		    	} else {
		    		errPage.removeError();
		    		XenosAlert.info("Result Not Found");
		    	}
		    }  		
    	}
    }   
    