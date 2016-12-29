// ActionScript file for account popup

         import com.nri.rui.core.controls.XenosAlert;
		 import com.nri.rui.core.utils.HiddenObject;
         
         import mx.collections.ArrayCollection;
         import mx.rpc.events.FaultEvent;
         import mx.rpc.events.ResultEvent;
		 
        /**
         * This API will clear the result page to empty page
         */
        public function clearResultPage():void{

            //summaryResult = emptyResult;
            summaryResult.removeAll();
            nextPage.enabled = false;
            prevPage.enabled = false;
        }
        /**
	    * It sets the enable property of the Next and Previous button
	    * depending on the result set, whether available or not
	    */
	    public function setPrevNextVisibility(prev:Boolean, next:Boolean):void{
	    	
	    	this.prevPage.enabled = prev;
	    	this.nextPage.enabled = next;
	    	
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
            		     XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));

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
	                	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.comp.alert.norecordsmatchingcriteria'));
		}  
            }else {
                summaryResult = new ArrayCollection();
                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.comp.alert.norecordsmatchingcriteria'));
		//XenosAlert.info("No Results Found");
            }    
        }
        /**
         * The Fault Event Handler used for error in query result http service
         * @param event The fault Event
         * 
         */        
        public function popUpQueryRequestErrorHand(event:FaultEvent):void {

            var errorMsg : String = this.parentApplication.xResourceManager.getKeyValue('ref.comp.label.error') + event.fault.faultString + 'Error Occured!';

            XenosAlert.error(errorMsg);
        }
        /**
          * This will return the account number selected from the popup 
          * window to the main application.
          */  
        public function returnCustomerCode():void {
             if (customerSummary.selectedItem != null){
                 var retCustomerCode : String = new String(customerSummary.selectedItem.customerCode);
                 retTxtInput.text=retCustomerCode; 
                 super.closeWindow();
             }
        }
        
        /**
          * This will initialize the account pop up query page.
          * @param ResultEvent the result set event object.
          */
        public override function populatePopUpQueryPage(event: ResultEvent) : void {

           
 		}
        
        /**
         * Reset the account query page. 
         */
        public override function resetQuery():void { 
           super.resetQuery();
           errPage.clearError(null);
           clearResultPage();  
           customerPopupQueryPnl.percentWidth=100;
           resultPnl.percentWidth=100;
           //clearing fields
           customerCode.text="";
           customerName.text="";           
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
         * Submit the popup query page.
         */
        public override function submitQuery():void { 
            //Set the request parameters
     		var requestObj :Object = populateRequestParams();
     		popUpQueryRequestObj.request = requestObj;             
            popUpQueryRequestObj.url="ref/customerPopupSearch.action"+ "?method=submitQuery"; 
            popUpQueryRequestObj.send();
        } 
        
        /**
	     * This method will populate the request parameters for the
	     * submitQuery call and bind the parameters with the HTTPService
	     * object.
	     */
	    private function populateRequestParams():Object {
	    	
	    	var reqObj : Object = new Object();
	    	reqObj.customerCode=customerCode.text;
            reqObj.shortName=customerName.text;
	    	return reqObj;
	    }
        
