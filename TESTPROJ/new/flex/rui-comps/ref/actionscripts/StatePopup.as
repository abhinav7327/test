
         import com.nri.rui.core.controls.XenosAlert;
         
         import mx.collections.ArrayCollection;
         import mx.rpc.events.FaultEvent;
         import mx.rpc.events.ResultEvent;
          
         

        /**
         * This API will clear the result page to empty page
         */
        private function clearResultPage():void{

            //summaryResult = emptyResult;
            summaryStateResult.removeAll();
          /*  	nextPage.enabled = false;
            prevPage.enabled = false; */
        }
        /**
         * Submit the account query page.
         */
       public override function submitQuery():void { 
            statepopUpQueryRequestObj.url=mapping + "?method=doSearch"; 
            var requestObj :Object = populateRequestParams();
     		statepopUpQueryRequestObj.request = requestObj;             
            //popUpQueryRequestObj.url=this.mapping;
            statepopUpQueryRequestObj.send();
            //XenosAlert.info("submit");
        } 
        
        /**
	     * This method will populate the request parameters for the
	     * submitQuery call and bind the parameters with the HTTPService
	     * object.
	     */
	    private function populateRequestParams():Object {
	    	
	    	var reqObj : Object = new Object();
	    	//reqObj.method="doSearch"; 
	    	reqObj.searchBy=searchby.selectedValue;
	        reqObj.searchFor=searchFor.text;
	    	
	    	return reqObj;
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
         * Populate the query result information to the fininst query summary page.
         * @param ResultEvent the result set event object.
         */    
         
         public override function populatePopUpQuerySummaryPage(event:ResultEvent):void {
            
            var rs:XML = XML(event.result);
           // XenosAlert.info(rs.toXMLString());
           if (null != event) {
			if(rs.summary.noOfRecords!='0') {
				errPage.clearError(event);
	            summaryStateResult.removeAll();
				try {
				    for each ( var rec:XML in rs.summary.data ) {
	 				    summaryStateResult.addItem(rec);
				    }
				//    changeCurrentState();
		            setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
	            	summaryStateResult.refresh();
				}catch(e:Error){
				    //XenosAlert.error(e.toString() + e.message);
				    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			    }
			} else {
			 	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			 	summaryStateResult.removeAll(); // clear previous data if any as there is no result now.
			 	errPage.removeError(); //clears the errors if any
			}
          }
		
        }

  
        /**
         * Reset the account query page. 
         */
        public override function resetQuery():void { 
           //super.resetQuery();
           errPage.clearError(null);
           clearResultPage(); 
           StatePopupQueryPnl.percentWidth=100;
           resultPnl.percentWidth=100;
           //clearing fields
           searchFor.text = "";
           searchby.selectedValue = "code";
           searchFor.setFocus();
           ws1.opened = true;
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
          * This will return the State Code selected from the popup 
          * window to the main application.
          */  
        public function returnStateCode():void {
             if (stateSummary.selectedItem != null){
                 var retStateNo : String = new String(stateSummary.selectedItem.stateCode);
                 retTxtInput.text=retStateNo;
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
			if(event != null){
				if(retTxtInput.text != ""){
					searchby.selectedValue = "code";
					//searchFor.text = retTxtInput.text;
				}
				else
					searchby.selectedValue = event.result.popupQueryActionForm.searchBy;
			}
			searchFor.setFocus();
	    }

