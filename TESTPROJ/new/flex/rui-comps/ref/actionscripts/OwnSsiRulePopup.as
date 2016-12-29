// ActionScript file

         import com.nri.rui.core.controls.XenosAlert;
         
         import mx.collections.ArrayCollection;
         import mx.rpc.events.FaultEvent;
         import mx.rpc.events.ResultEvent;
         import flash.events.Event;	
          

 		public var obj:Object = {};
	    [Bindable]
	    private var queryResult:ArrayCollection = new ArrayCollection();
        [Bindable]
		private var pageNo :int = 1;

    /**
     * This method will populate the request parameters for the submitQuery call 
     * and bind the parameters with the HTTPService object.
     */
   	private function populateRequestParams():Object {
        var reqObj : Object = new Object();
        reqObj.method = "load";
        return reqObj;
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
        } catch (e:Error) {
            trace(e);
        }
    }

        /**
     * Method to be executed after query.
     */
    public function postQueryResultHandler(mapObj:Object):void {
    	commonResult(mapObj);
    }

	/**
	 * Result handler method after query.
	 */
    private function commonResult(mapObj:Object):void {
    	if(mapObj != null) {   
	    	if(mapObj["errorFlag"].toString() == "error") {
	    		queryResult.removeAll();
	    	} else {
	    		if(mapObj["errorFlag"].toString() == "noError") {
	                queryResult.removeAll();
	                queryResult = mapObj["row"];
		    	} else {
		    		XenosAlert.info("Result Not Found");
		    	}
		    }  		
    	}
    }   
        /**
          * This will return the account number selected from the popup 
          * window to the main application.
          */  
        public function returnRuleId():void {
                if (ownSsiRuleSummary.selectedItem != null) {
                	var retOwnSsiPk : String = new String(ownSsiRuleSummary.selectedItem.ownSettleStandingRulePk);
                 	var retSettlementMode  : String = new String(ownSsiRuleSummary.selectedItem.settlementMode);
                 	var retSettlementBank  : String = new String(ownSsiRuleSummary.selectedItem.settlementBank);
                 	var retSettlementAccount  : String = new String(ownSsiRuleSummary.selectedItem.settlementAccount);
                 	var retPriority  : String = new String(ownSsiRuleSummary.selectedItem.priority);
                 
                 	retTxtInput.text = retOwnSsiPk;
                 	returnContextItems.removeAll();
                 	returnContextItems.addItem(retSettlementMode);
                 	returnContextItems.addItem(retSettlementBank);
                 	returnContextItems.addItem(retSettlementAccount);
                 	returnContextItems.addItem(retPriority);
	                 
                 	this.owner.dispatchEvent(new Event("ownSsiSelectEvent"));
 				 	super.closeWindow();
             }

       }

           private function clearResultPage():void{
            //queryResult = emptyResult;
            queryResult.removeAll();
            nextPage.enabled = false;
            prevPage.enabled = false;
            pageNo = 1;
        }
	/**
         * It sets the enable property of the Next and Previous button
         * depending on the result set, whether available or not
         */
        public function setPrevNextVisibility(prev:Boolean, next:Boolean):void{

                this.prevPage.enabled = prev;
                this.nextPage.enabled = next;
				if(prev){
	    			prevPage.toolTip ="Previous/"+(pageNo-1);
		    	}else{
		    		prevPage.toolTip = "Previous";
		    	}
		    	if(next){
		    		nextPage.toolTip ="Next/"+(pageNo+1);
		    	}else{
		    		nextPage.toolTip = "Next";
		    	}
        } 
        /**
         * Populate the query result information to the fund query summary page.
         * @param ResultEvent the result set event object.
         */      
        public override function populatePopUpQuerySummaryPage(event:ResultEvent):void {
            
            var results:XML = XML(event.result);
			var rs:XML = XML(results.summary);            	      
            if (null != event) {
			if(rs.child("data").length()>0) {
				errPage.clearError(event);
	            queryResult.removeAll();
				try {
				    for each ( var rec:XML in rs.data ) {
	 				    queryResult.addItem(rec);
				    }
				    //changeCurrentState();
		            setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
	            	queryResult.refresh();
				}catch(e:Error){
				    //XenosAlert.error(e.toString() + e.message);
				    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			    }
			 } else if(rs.child("Errors").length()>0) {
                //some error found
			 	queryResult.removeAll(); // clear previous data if any as there is no result now.
			 	var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list 			 	
			 	for each ( var error:XML in rs.Errors.error ) {
	 			   errorInfoList.addItem(error.toString());
				}
			 	errPage.showError(errorInfoList);//Display the error
			 } else {
			 	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			 	queryResult.removeAll(); // clear previous data if any as there is no result now.
			 	errPage.removeError(); //clears the errors if any
			 }
		
        }
            
        }
        /**
         * Reset the account query page. 
         */
        public override function resetQuery():void { 
           super.resetQuery();
           errPage.clearError(null);
           clearResultPage();  
        }
         /**
         * The Fault Event Handler used for error in query result http service
         * @param event The fault Event
         * 
         */        
        public function popUpQueryRequestErrorHand(event:FaultEvent):void {

            var errorMsg : String = this.parentApplication.xResourceManager.getKeyValue('ref.comp.label.error') + event.fault.faultString;

            XenosAlert.error(errorMsg);
        } 

        /**
         * This API return the data through the context from popup to the main  
         * application.
         * @TODO To be implemented if requried.
         * 
         */        
        private function populateReturnContext():void {
            //To be implemented if requried
        }

        
        /**
          * This API is handleing the fund query page initialization Http service.
          * @param ResultEvent the result set event object.
          */
        public override function populatePopUpQueryPage(event: ResultEvent) : void {

            var i:int = 0;
            var initColl: ArrayCollection = null;
            var tempColl: ArrayCollection = null;
            //Populating  the fubd category drop down list
            tempColl = new ArrayCollection();
        }

		public override function doPrevious():void{
        	pageNo--;
	    	page.text = pageNo+"";
        	rndNo= Math.random();
        	popUpQueryDoPrevious.resultFormat="xml";
            popUpQueryDoPrevious.url=mapping + "?method=doPrevious&rnd="+ rndNo;
            popUpQueryDoPrevious.send();
        }
		public override function doNext():void{
			pageNo++;
	        page.text = pageNo+"";
        	rndNo= Math.random();
        	popUpQueryDoNext.resultFormat="xml";
            popUpQueryDoNext.url=mapping + "?method=doNext&rnd="+ rndNo;
            popUpQueryDoNext.send();
        }
        
        	/**
	 * Load the fail balance query.
	 */
    public function loadAll():void {
    	var rndNo:Number = Math.random();
		popUpQueryRequestObj.url="ref/ownSsiPopupSearch.action?method=doInit&rnd="+rndNo;  
		popUpQueryRequestObj.send();   	
    }

