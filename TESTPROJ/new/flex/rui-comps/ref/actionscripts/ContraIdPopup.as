// ActionScript file

         import com.nri.rui.core.controls.XenosAlert;
         
         import mx.collections.ArrayCollection;
         import mx.rpc.events.FaultEvent;
         import mx.rpc.events.ResultEvent;
		 import com.nri.rui.core.utils.HiddenObject;
         import mx.utils.StringUtil; 
          
		[Bindable]
		 private var pageNo :int = 1;
        /**
         * This API will clear the result page to empty page
         */
        private function clearResultPage():void{

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
         * Populate the query result information to the fininst query summary page.
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

            var errorMsg : String = this.parentApplication.xResourceManager.getKeyValue('ref.comp.label.error') + event.fault.faultString;

            XenosAlert.error(errorMsg);
        } 

        /**
          * This will return the Contra id selected from the popup 
          * window to the main application.
          */  
        public function returnContraId():void {
             if (contraIdSummary.selectedItem != null){
                 var retContraId : String = new String(contraIdSummary.selectedItem.value);
                 retTxtInput.text=retContraId; 
                 super.closeWindow();
             }
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
          * This API is handleing the fininst query page initialization Http service.
          * @param ResultEvent the result set event object.
        */  
        public override function populatePopUpQueryPage(event: ResultEvent) : void {
		// Till no inotialization is requried
			//contraId.text = retTxtInput.text;
			contraId.setFocus();
        }
        
        public override function doPrevious():void{
        	pageNo--;
	    	page.text = pageNo+"";
        	super.doPrevious();
        }
		public override function doNext():void{
			pageNo++;
	        page.text = pageNo+"";
        	super.doNext();
        }
        
        
        /**
         * Submit the popup query page.
         */
        public override function submitQuery():void { 
            //Set the request parameters
     		var requestObj :Object = populateRequestParams();
     		popUpQueryRequestObj.request = requestObj;             
            popUpQueryRequestObj.url="ref/contraIdPopupSearch.action" + "?method=submitQuery"; 
            popUpQueryRequestObj.send();
        } 
        
        /**
	     * This method will populate the request parameters for the
	     * submitQuery call and bind the parameters with the HTTPService
	     * object.
	     */
	    private function populateRequestParams():Object {
	    	
	    	var reqObj : Object = new Object();
	    	reqObj.contraId=contraId.text;
	    	return reqObj;
	    }

