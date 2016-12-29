// ActionScript file

 // ActionScript file for Trade Query
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.XenosStringUtils;
    
    import mx.collections.ArrayCollection;
    import mx.rpc.events.ResultEvent;
    
    [Bindable]
    //private var initColl:ArrayCollection;
    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var xmlSource:XML= new XML();
    //private var emptyResult:ArrayCollection= new ArrayCollection();
   // private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
    public var stlHistoryDetailPk:String;
    public var o:Object = {};
    /*[Bindable]
    public var creationDateStr:String ; 
    [Bindable]
    public var updateDateStr:String ;*/

    /**
     * This method works as the result handler of the Submit Query Http Services.
     */
    public function LoadResultPage(event:ResultEvent):void {
        //var xmlData:XML = new XML();
    	if (null != event) {            
            if(null == event.result){
                //xmlSource.removeAll(); // clear previous data if any as there is no result now.
            	if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
            	  //  errPage.clearError(event); //clears the errors if any
            		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            	} else { // Must be error
            		//errPage.displayError(event);	
            	}            	
            }else {
	             	xmlSource = event.result as XML;
	            	//taxFeeResult = queryResult.tradeEntryActionForm.taxFeeAmounts.taxFeeAmount as XMLListCollection; 
	            	/* rrResult = queryResult.rrAmounts.rrAmount as XMLListCollection; */
	            	/* var tempDateStr : String = xmlSource.detailHistoryView.creationRuiDate;
	            	
	            	if(!XenosStringUtils.isBlank(tempDateStr) && tempDateStr.charAt(0)=="F"){
	                    if(tempDateStr.length == 1)
	                        creationDateStr =  XenosStringUtils.EMPTY_STR;
	                    else
	                         creationDateStr = tempDateStr.substring(1);
	                }else{
	                     creationDateStr = tempDateStr;                    
	                }
	                tempDateStr = xmlSource.detailHistoryView.updateRuiDate;
	                if(!XenosStringUtils.isBlank(tempDateStr) && tempDateStr.charAt(0)=="F"){
	                    if(tempDateStr.length == 1)
	                        updateDateStr =  XenosStringUtils.EMPTY_STR;
	                    else
	                         updateDateStr = tempDateStr.substring(1);
	                }else{
	                     updateDateStr = tempDateStr;                    
	                } */
            } 
        }else {
            //queryResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }
    }
   
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
				if (tempA[0] == Globals.SETTLEMENT_DETAIL_HISTORY_PK) {
					o.stlHistoryPk = tempA[1];
				} 
				stlHistoryDetailPk = o.stlHistoryPk;
			} 
		} catch (e:Error) {
			trace(e);
		}
	}   		