
 // ActionScript file for Gle Nav Query
 	
 	import com.nri.rui.core.controls.XenosAlert;
 	
 	import mx.collections.XMLListCollection;
 	import mx.rpc.events.ResultEvent;
        
	//----------------------------------------------------------------------------
	[Bindable]
    private var queryResult:XML= new XML();
    [Bindable]
    private var postRulePk : String = "";
    [Bindable]
    private var xmlListColl:XMLListCollection = new XMLListCollection();

    //--------------------------------------------------------------------------- 
	 	
		
	/**
	 * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
	 * 
	 */
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
                if (tempA[0] == "postPk") {
                    postRulePk = tempA[1];
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
            } 
        }else {
            //queryResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }
        
        
        for each(var xmlObj:Object in queryResult.ruleAtPostingTimingList.ruleAtPostingTimingList){
        	xmlListColl.addItem(xmlObj);
        	
        }
    }
   /**
     * This method will populate the request parameters for the
     * submitQuery call and bind the parameters with the HTTPService
     * object.
     */
   private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
         reqObj.postPk = this.postRulePk;
         return reqObj;
    }
	