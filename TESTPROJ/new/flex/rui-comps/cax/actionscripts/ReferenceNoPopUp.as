
         import com.nri.rui.core.controls.XenosAlert;
         
         import mx.collections.ArrayCollection;
         import mx.rpc.events.FaultEvent;
         import mx.rpc.events.ResultEvent;
		 import com.nri.rui.core.utils.HiddenObject;
         import mx.utils.StringUtil;
         
         
         

        /**
         * This API will clear the result page to empty page
         */
        private function clearResultPage():void{

           // summaryResult = emptyResult;
           summaryResult.removeAll();
          /*  	nextPage.enabled = false;
            prevPage.enabled = false; */
        }
         
        /**
         * It sets the enable property of the Next and Previous button
         * depending on the result set, whether available or not
         */
        public function setPrevNextVisibility(prev:Boolean, next:Boolean):void{

              /*   this.prevPage.enabled = prev;
                this.nextPage.enabled = next; */
        } 
         
        /**
          * This will initialize the account pop up query page.
          * @param ResultEvent the result set event object.
          */
        public override function populatePopUpQueryPage(event: ResultEvent) : void {
            
            if (null != event) {            
                if(null == event.result.summary){
                	 summaryResult.removeAll();
                    if(null == event.result.XenosErrors){ 
                   		// i.e. No result but no Error found.
                        XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('cax.not.any.result.found'));

                    } else { // Must be error
                        errPage.displayError(event);    
                    }               
                }else {
                    errPage.clearError(event);   
                    if(event.result.summary.data is ArrayCollection) {
                    	summaryResult = event.result.summary.data as ArrayCollection;
                    } else {
                    	summaryResult = new ArrayCollection();
                        summaryResult.addItem(event.result.summary.data);
                        XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                    }
                } 
                
            }else {
                summaryResult = new ArrayCollection();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            }
		}
        
         /**
         * The Fault Event Handler used for error in query result http service
         * @param event The fault Event
         * 
         */        
        public function popUpQueryRequestErrorHand(event:FaultEvent):void {

            var errorMsg : String = this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred')+ event.fault.faultString;

            XenosAlert.error(errorMsg);
            
        } 

        /**
          * This will return the Employee id selected from the popup 
          * window to the main application.
          */  
        public function returnRefNo():void {
             if (refNoSummary.selectedItem != null){
                 var retemployeeNo : String = new String(refNoSummary.selectedItem.settlementReferenceNo);
                 retTxtInput.text=retemployeeNo;
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
        
         /* override public function initPopup ():void {
        	this.popUpContainer.useProxy = false;
        	super.initPopup();
        } */ 

        
        