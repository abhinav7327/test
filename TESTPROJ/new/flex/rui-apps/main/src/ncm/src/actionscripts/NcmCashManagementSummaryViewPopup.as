
// ActionScript file for Cash Management Summary View
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.controls.XenosQuery;
 import com.nri.rui.core.utils.ProcessResultUtil;
 
 import mx.collections.ArrayCollection;

    [Bindable]
    public var fundCode:String;
    [Bindable]
    public var ccy:String;
    [Bindable]
    public var popupFlag:String = "popup";
    [Bindable]
    private var summaryResult:ArrayCollection = new ArrayCollection();
    private var sortUtil: ProcessResultUtil = new ProcessResultUtil();

	/**
	 * Load the cash management summary.
	 */
    public function loadQuery():void {
     	parseUrlString();
     	super.setXenosQueryControl(new XenosQuery());
     	this.dispatchEvent(new Event('querySubmit'));
    }
	
	/**
	 * Method to be execute before query.
	 */
    override public function preQuery():void {
        super.getSubmitQueryHttpService().url = "ncm/cashManagementQueryPopupDispatch.action?";  
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
                    fundCode = tempA[1];
                } 
                if (tempA[0] == Globals.CURRENCY) {
                    ccy = tempA[1];
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
        reqObj.method = "submitStlCashMqmtQuery";
        reqObj.FundCode = fundCode;
        reqObj.Currency = ccy;
        return reqObj;
    }
    
    /**
     * Method to be executed before query.
     */
    override public function preQueryResultHandler():Object {
    	var viewList:ArrayCollection = new ArrayCollection();
    	viewList.addItem("resultList");
    	return viewList;
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
	    		summaryResult.removeAll();
	    		errPage.showError(mapObj["errorMsg"]);
	    	} else {
	    		if(mapObj["errorFlag"].toString() == "noError") {
		    	    errPage.clearError(super.getSubmitQueryResultEvent());
	                summaryResult.removeAll();
	                summaryResult = mapObj["resultList"];
	                this.resultSummary.height = this.resultSummary.measureHeightOfItems(0, summaryResult.length) + this.resultSummary.headerHeight;
		    	} else {
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    	}
		    }  		
    	}
    }   

