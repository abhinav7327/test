
         import com.nri.rui.core.controls.XenosAlert;
         
         import mx.collections.ArrayCollection;
         import mx.rpc.events.FaultEvent;
         import mx.rpc.events.ResultEvent;
          

        /**
         * This API will clear the result page to empty page
         */
        private function clearResultPage():void{

            //summaryResult = emptyResult;
            summaryResult.removeAll();
          /*  	nextPage.enabled = false;
            prevPage.enabled = false; */
        }
        /**
         * Submit the account query page.
         */
       public override function submitQuery():void { 
            popUpQueryRequestObj.url=mapping + "?method=doEmployeeSearch";
            var requestObj :Object = populateRequestParams();
     		popUpQueryRequestObj.request = requestObj;             
            //popUpQueryRequestObj.url=this.mapping; 
            popUpQueryRequestObj.send();
        } 
        
         /**
	     * This method will populate the request parameters for the
	     * submitQuery call and bind the parameters with the HTTPService
	     * object.
	     */
	    private function populateRequestParams():Object {
	    	
	    	var reqObj : Object = new Object();
	    	//reqObj.method="doSearch";
	    	reqObj.searchFor=userId.text;
	        reqObj.searchBy=userName.text;
	        reqObj.status = employeeStatusList.selectedItem != null? employeeStatusList.selectedItem.value:"";
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
            
           if (null != event) {
			if(rs.summary.noOfRecords!='0') {
				errPage.clearError(event);
	            summaryResult.removeAll();
				try {
				    for each ( var rec:XML in rs.summary.data ) {
	 				    summaryResult.addItem(rec);
				    }
				//    changeCurrentState();
		            setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
	            	summaryResult.refresh();
				}catch(e:Error){
				    //XenosAlert.error(e.toString() + e.message);
				    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			    }
			} else {
			 	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			 	summaryResult.removeAll(); // clear previous data if any as there is no result now.
			 	errPage.removeError(); //clears the errors if any
			}
          }
		
        }
          
    /*      public override function populatePopUpQuerySummaryPage(event:ResultEvent):void {
			
			if (null != event) {            
                if(null == event.result.summary){
                	 summaryResult.removeAll();
                    if(null == event.result.XenosErrors){ 
                   		// i.e. No result but no Error found.
                         XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));

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
                    }
                    if(event.result.summary.data == null){
						XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.comp.alert.norecordsmatchingcriteria'));
		    		}
	             } 
                
            }else {
                summaryResult = new ArrayCollection();
                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.comp.alert.norecordsmatchingcriteria'));
		//XenosAlert.info("No Results Found");
            }
        } */
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
          * This will return the Employee id selected from the popup 
          * window to the main application.
          */  
        public function returnEmployeeId():void {
             if (employeeSummary.selectedItem != null){
                 var retemployeeNo : String = new String(employeeSummary.selectedItem.userId);
                 retTxtInput.text=retemployeeNo;
                 retTxtInput.dispatchEvent(new Event("ValueChanged"));
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
			//userId.text = retTxtInput.text;
			var initColl: ArrayCollection = null;
            var tempColl: ArrayCollection = null;
            var i:int;
            
			tempColl = new ArrayCollection();
            if(event.result.employeePopupQueryActionForm.availableStatusList.statusList is ArrayCollection) {
                initColl = event.result.employeePopupQueryActionForm.availableStatusList.statusList as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.employeePopupQueryActionForm.statusList);
            }
            tempColl.addItem({label:"", value: ""});
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);    
            }
            employeeStatusList.dataProvider = tempColl;
			
			
			userId.setFocus();
	    }

