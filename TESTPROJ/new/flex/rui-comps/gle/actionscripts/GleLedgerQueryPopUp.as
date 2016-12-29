// ActionScript file for account popup

         import com.nri.rui.core.controls.XenosAlert;
         
         import mx.collections.ArrayCollection;
         import mx.rpc.events.FaultEvent;
         import mx.rpc.events.ResultEvent;
         
         [Bindable]
         private var pageNo:int = 1;
         
        /**
         * This API will clear the result page to empty page
         */
        public function clearResultPage():void{

            //summaryResult = emptyResult;
            summaryResult.removeAll();
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
         * The view state handler.
         * This is used to changed the view state between Query and Query Result container. 
         */  
		private function changeCurrentState():void{
            //this.currentState = "qryres";
		}
        /**
         * Populate the query result information to the account query summary page.
         * @param ResultEvent the result set event object.
         */      
        public override function populatePopUpQuerySummaryPage(event:ResultEvent):void {
             var showNext:Boolean;
            var showPrev:Boolean;
    
            if (null != event) {            
                if(null == event.result.rows){
                	summaryResult.removeAll();
            	    if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
            		    XenosAlert.info("Not any Result Found!");

            	    } else { // Must be error
            		    errPage.displayError(event);	
            	    }            	
                }else {
            	    errPage.clearError(event);   
	                if(event.result.rows.row is ArrayCollection) {
	                    summaryResult = event.result.rows.row as ArrayCollection;
	                } else {
	                    summaryResult = new ArrayCollection();
	                    summaryResult.addItem(event.result.rows.row);
	                }
	                changeCurrentState();
			if(event.result.rows.row != null){
                		setPrevNextVisibility(Boolean(event.result.rows.prevTraversable),Boolean(event.result.rows.nextTraversable));
			}
	                else
	                	XenosAlert.info("No records found matching the search criteria.");
                }                  
            }else {
                summaryResult = new ArrayCollection();
                XenosAlert.info("No records found matching the search criteria.");
		//XenosAlert.info("No Results Found");
            }     
        }
        /**
         * The Fault Event Handler used for error in query result http service
         * @param event The fault Event
         * 
         */        
        public function popUpQueryRequestErrorHand(event:FaultEvent):void {

            var errorMsg : String = 'Error Occured :  ' + event.fault.faultString + 'Error Occured!';

            XenosAlert.error(errorMsg);
        }
        /**
          * This will return the account number selected from the popup 
          * window to the main application.
          */  
         public function returnGleCode():void {
             if (gleSummary.selectedItem != null){
                 var retGleCode : String = new String(gleSummary.selectedItem.ledgerCode);
                 retTxtInput.text=retGleCode; 
                 super.closeWindow();
             }
        } 
        
        /**
          * This will initialize the account pop up query page.
          * @param ResultEvent the result set event object.
          */
        public override function populatePopUpQueryPage(event: ResultEvent) : void {

            var i:int = 0;
            var initColl: ArrayCollection = null;
            var tempColl: ArrayCollection = null;
            //Populating  the couneter party type drop down list
            tempColl = new ArrayCollection();
            if(event.result.gleLedgerEntryActionForm.ledgerTypeValuesList == null)
            	return;
            if(event.result.gleLedgerEntryActionForm.ledgerTypeValuesList.item is ArrayCollection) {
                initColl = event.result.gleLedgerEntryActionForm.ledgerTypeValuesList.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.gleLedgerEntryActionForm.ledgerTypeValuesList.item);
            }
            tempColl.addItem({label:" ", value: " "});
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);    
            }
            ledgerTypeList.dataProvider = tempColl;
            //Populating  the tax id type drop down list
            initColl = event.result.gleLedgerEntryActionForm.subCodeTypeValuesList.item as ArrayCollection;
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);            
            }
            subCodeTypeList.dataProvider = tempColl;
            ledgerCode.setFocus();  
            //ledgerCode.text = retTxtInput.text;         
            //XenosAlert.show("Initialization Complete.");    
        }
        
         /**
         * Submit the GLE Ledger query page.
         */
        public override function submitQuery():void { 
            //Set the request parameters
     		var requestObj :Object = populateRequestParams();
     		popUpQueryRequestObj.request = requestObj;             
            popUpQueryRequestObj.url="gle/gleLedgerQueryPopup.action" + "?method=submitQuery"; 
            popUpQueryRequestObj.send();
        } 
        
        
        /**
	     * This method will populate the request parameters for the
	     * submitQuery call and bind the parameters with the HTTPService
	     * object.
	     */
	    private function populateRequestParams():Object {
	    	
	    	var req : Object = new Object();
	    	req.ledgerCode=ledgerCode.text;
            req.ledgerType=ledgerTypeList.selectedItem.value;
            req.shortName=shortName.text;
            req.subcodeType=subCodeTypeList.selectedItem.value;
	        req.longName=longName.text;	        
	    	return req;
	    }
        
        
        /**
         * Reset the account query page. 
         */
        public override function resetQuery():void { 
           super.resetQuery();
           errPage.clearError(null);
           clearResultPage();  
           glePopupQueryPnl.percentWidth=100;
           resultPnl.percentWidth=100;
           //clearing fields
           ledgerCode.text="";
           shortName.text="";
           longName.text=""; 
           ledgerTypeList.selectedIndex = 0;
           subCodeTypeList.selectedIndex = 0;
        }

        /**
         * This API return the data through the context from popup to the main  
         * application.
         * @TODO To be implemented if requried.
         * 
         */        
        private function populateReturnContext():void {
            /* Sample implementation
            //passing counter party type                
            var cpTypeArray:Array = new Array(2);
                cpTypeArray[0]="RETINTERNAL";
                cpTypeArray[1]="RETCLIENT";
            returnContextItems.addItem(new HiddenObject("returninvCPTypeContext",cpTypeArray));
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="RETOPEN";
            returnContextItems.addItem(new HiddenObject("returnaccountStatus",actStatusArray));
            */
        }
        
        /**
         * Go to previous page.
         */
		public override function doPrevious():void{
        	pageNo--;
	    	page.text = pageNo+"";
        	super.doPrevious();
        }
        /**
         * Go to next page.
         */
		public override function doNext():void{
			pageNo++;
	        page.text = pageNo+"";
        	super.doNext();
        }
