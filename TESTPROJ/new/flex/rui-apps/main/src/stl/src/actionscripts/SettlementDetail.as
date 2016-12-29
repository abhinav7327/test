// ActionScript file
// ActionScript file

 // ActionScript file for Trade Query
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    
    import mx.collections.ArrayCollection;
    import mx.collections.XMLListCollection;
    import mx.rpc.events.ResultEvent;
    
    [Bindable]
    //private var initColl:ArrayCollection;
    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var queryResult:XML= new XML();
    //private var emptyResult:ArrayCollection= new ArrayCollection();
   // private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    
    [Bindable]
    private var taxFeeResult:XMLListCollection= new XMLListCollection();
    [Bindable]
    private var settlementHistoryResult:ArrayCollection= new ArrayCollection();
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    public var o:Object = {};
    
    [Bindable]
    public var stlPk:String;
    [Bindable]
    public var path:String;
    [Bindable]
    public var viewMode:String;
    	   
            
    public function parseUrlString():void {
        try {
            // Remove everything before the question mark, including
            // the question mark.
            var myPattern:RegExp = /.*\?/; 
            var s:String = this.loaderInfo.url.toString();
            s = s.replace(myPattern, "");
            // Create an Array of name=value Strings.
            var params:Array = s.split("&"); 
             // Print the params that are in the Array.
            var keyStr:String;
            var valueStr:String;
            var paramObj:Object = params;
          
            // Set the values of the salutation.
            for (var i:int = 0; i < params.length; i++) {
                var tempA:Array = params[i].split("=");  
                if (tempA[0] == Globals.SETTLEMENT_INFO_PK) {
                    o.settlementPk = tempA[1];
                    stlPk = o.settlementPk;
                } 
                if (tempA[0] == Globals.PATH) {
                    o.path = tempA[1];
                    path = o.path;
                } 
                if (tempA[0] == Globals.VIEW_MODE) {
                    o.viewMode = tempA[1];
                    viewMode = o.viewMode;
                } 
                
                
            } 
            
        } catch (e:Error) {
            trace(e);
        }
       
    }
     
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    public function LoadResultPage(event:ResultEvent):void {
    	//var xmlData:XML = new XML();
    	if (null != event) {            
            if(null == event.result){
                //queryResult.removeAll(); // clear previous data if any as there is no result now.
            	if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
            	  //  errPage.clearError(event); //clears the errors if any
            		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            	} else { // Must be error
            		//errPage.displayError(event);	
            	}            	
            }else {
	            
	             	queryResult = event.result as XML;
	            	//taxFeeResult = queryResult.tradeEntryActionForm.taxFeeAmounts.taxFeeAmount as XMLListCollection; 
	            	 //settlementHistoryResult = event.result.stlQueryActionForm.detailView.completionHistoryDetailsList.completionHistoryDetails  as ArrayCollection; 
	            	//XenosAlert.info("stlHistory :: "+settlementHistoryResult.getItemAt(0));
            } 
        }else {
            //queryResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }
    }
   
   private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
         reqObj.settlementInfoPk = stlPk;
         //XenosAlert.info("stlPk :: "+stlPk);
         if(viewMode != "")
         	reqObj.viewMode = viewMode;
         if(path != "")	
         	reqObj.path = path;
         
         
         return reqObj;
    }	