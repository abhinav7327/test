// ActionScript file
// ActionScript file for FinInstForFund popup

         import com.nri.rui.core.controls.XenosAlert;
         
         import mx.collections.ArrayCollection;
         import mx.rpc.events.FaultEvent;
         import mx.rpc.events.ResultEvent;
          

		 
		 private var showHideBoolean:Boolean;
         [Bindable]
		 private var pageNo :int = 1;
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
            
            var rs:XML = XML(event.result);
            
            if (null != event) {
			if(rs.child("row").length()>0) {
				errPage.clearError(event);
	            summaryResult.removeAll();
				try {
				    for each ( var rec:XML in rs.row ) {
	 				    summaryResult.addItem(rec);
				    }
				    //changeCurrentState();
		            setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
	            	summaryResult.refresh();
				}catch(e:Error){
				    //XenosAlert.error(e.toString() + e.message);
				    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			    }
			 } else if(rs.child("Errors").length()>0) {
                //some error found
			 	summaryResult.removeAll(); // clear previous data if any as there is no result now.
			 	var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list 			 	
			 	for each ( var error:XML in rs.Errors.error ) {
	 			   errorInfoList.addItem(error.toString());
				}
			 	errPage.showError(errorInfoList);//Display the error
			 } else {
			 	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			 	summaryResult.removeAll(); // clear previous data if any as there is no result now.
			 	errPage.removeError(); //clears the errors if any
			 }
		
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
          * This will return the bank code selected from the popup 
          * window to the main application.
          */  
        public function returnBankCode():void {
              if (finInstFundSummary.selectedItem != null){
                 var retFinInstRoleCode : String = new String(finInstFundSummary.selectedItem.finInstRoleCode);
                 retTxtInput.text=retFinInstRoleCode; 
                 focusManager.setFocus(retTxtInput);
                 super.closeWindow();
             } 
        }
        
        /**
          * This will initialize the account pop up query page.
          * @param ResultEvent the result set event object.
          */
        public override function populatePopUpQueryPage(event: ResultEvent) : void {

            var i:int = 0;
            var initColl: ArrayCollection = new ArrayCollection();
            
            
            //Populating  the roleList drop down list
            if(event.result.finInstPopupQueryForFundActionForm.roles.roleList is ArrayCollection)
            	initColl = event.result.finInstPopupQueryForFundActionForm.roles.roleList as ArrayCollection;
            else
                initColl.addItem(event.result.finInstPopupQueryForFundActionForm.roles.roleList);
            roles.dataProvider = initColl;
            fundPopUp.fundCode.text = event.result.finInstPopupQueryForFundActionForm.fundCode;
            //XenosAlert.show("Initialization Complete."); 
            //finInstRoleCode.text = retTxtInput.text; 
            /*if(event.result.finInstPopupQueryForFundActionForm.fundCode != null){ 
            	fundPopUp.fundCode.text = event.result.finInstPopupQueryForFundActionForm.fundCode;
            	fundPopUp.fundCode.editable = false;
            	fundPopUp.fundPopup.visible = false;
            }*/
            finInstRoleCode.setFocus();
         }
        
        /**
         * Reset the account query page. 
         */
         public override function resetQuery():void { 
           super.resetQuery();
           errPage.clearError(null);
           clearResultPage();  
           finInstForFundPopupQueryPnl.percentWidth=100;
           resultPnl.percentWidth=100;
           //clearing fields
           finInstRoleCode.text="";
           fundPopUp.fundCode.text = "";
           shortName.text="";
           roles.selectedIndex=0;
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
         * Submit the popup query page.
         */
        public override function submitQuery():void { 
            //Set the request parameters
     		var requestObj :Object = populateRequestParams();
     		popUpQueryRequestObj.request = requestObj;             
            popUpQueryRequestObj.url="ref/finInstForFundSearch.action"+ "?method=submitQuery"; 
            popUpQueryRequestObj.send();
        } 
        
        /**
	     * This method will populate the request parameters for the
	     * submitQuery call and bind the parameters with the HTTPService
	     * object.
	     */
	    private function populateRequestParams():Object {
	    	
	    	var reqObj : Object = new Object();
	    	reqObj.finInstRoleCode=finInstRoleCode.text;
            reqObj.shortName=shortName.text;
	        reqObj.fundCode=fundPopUp.fundCode.text;
            reqObj.role = roles.selectedItem != null? roles.selectedItem.value : "";
	    	return reqObj;
	    }