// ActionScript file for settlement account for bank and fund popup
		 import com.nri.rui.ref.popupImpl.AccountPopUpHbox;
		 import com.nri.rui.ref.popupImpl.FinInstitutePopUpHbox;
		 import com.nri.rui.ref.popupImpl.FundPopUpHbox;
		 import com.nri.rui.core.controls.XenosAlert;
		 import mx.collections.ArrayCollection;
		 import mx.rpc.events.FaultEvent;
		 import mx.rpc.events.ResultEvent;
		  
    	 /*[Bindable]
    	 private var fund:FundPopUpHbox = new FundPopUpHbox();
    	 [Bindable]
    	 private var finInst:FinInstitutePopUpHbox = new FinInstitutePopUpHbox();
    	 */
		 [Bindable]
		 private var pageNo :int = 1;
    	
        /**
         * This API will clear the result page to empty page
         */
        public function clearResultPage():void{

           // summaryResult = emptyResult;
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
         * Populate the query result information to the stlAccount query summary page.
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
          * This will return the stlAccount number selected from the popup 
          * window to the main application.
          */  
        public function returnStlFundBankId():void {
             if (stlAccSummary.selectedItem != null){
                 var retAccountNo : String = new String(stlAccSummary.selectedItem.ourSettleAccountNo);
                 retTxtInput.text=retAccountNo; 
                 super.closeWindow();
             }
        }
        
        /**
          * This will initialize the stlAccount pop up query page.
          * @param ResultEvent the result set event object.
          */
        public override function populatePopUpQueryPage(event: ResultEvent) : void {
            var i:int = 0;
            if(event.result.settleAccountForFundActionForm.fundCode != null)
            {
            	//populateControl("Fund");
            	this.fundPopUp.fundCode.text = event.result.settleAccountForFundActionForm.fundCode;
            	//this.fundCode.enabled = false;
            }
            //else
            	//populateControl("Fund");
           	
            if(event.result.settleAccountForFundActionForm.bankCode != null)
            {
            	//populateControl("FinInst"); 
            	this.finInstPopUp.finInstCode.text = event.result.settleAccountForFundActionForm.bankCode;
            	//this.bankCode.enabled = false;
            	//bankCode.setFocus();
            }
            //else
            	//populateControl("FinInst"); 
		}
        
        /**
         * Reset the StlAccount query page. 
         */
        public override function resetQuery():void { 
           super.resetQuery();
           errPage.clearError(null);
           clearResultPage();  
           stlAccPopupQueryPnl.percentWidth=100;
           resultPnl.percentWidth=100;
           //clearing fields
           //fund.fundCode.text = "";
           //finInst.finInstCode.text = "";     
           fundPopUp.fundCode.text = "";
           finInstPopUp.finInstCode.text = "";
        }
        /**
         * This API add popup based on counterPartyDetailTypeList drop down
         * @TODO To be implemented if requried.
         * 
         */
        /*private function populateControl(controlName:String):void{
    		if(controlName == "Fund")
    		{
    			fund.percentWidth = 50;
    			fund.name = "Fund";
    			grdFundPopup.removeAllChildren();
    			grdFundPopup.addChild(fund);    			
    		}
    		if(controlName == "FinInst")
    		{
	    		finInst.percentWidth = 50;
	    		finInst.name = "FinInst";				
				grdBankCode.removeAllChildren();				
				grdBankCode.addChild(finInst);
				finInst.finInstCode.setFocus();	
    		}
	    }*/
	    
	    /**
         * Submit the stlAaccount query page.
         */
        public override function submitQuery():void { 
            //Set the request parameters
     		var requestObj :Object = populateRequestParams();
     		popUpQueryRequestObj.request = requestObj;             
            popUpQueryRequestObj.url="ref/stlAcctForFundBank.action"; 
            popUpQueryRequestObj.send();
        } 
        
        /**
	     * This method will populate the request parameters for the
	     * submitQuery call and bind the parameters with the HTTPService
	     * object.
	     */
	    private function populateRequestParams():Object {
	    	
	    	var reqObj : Object = new Object();
	    	reqObj.method = "submitQuery";
	    	/*if(!this.fundCode.enabled)
	    		reqObj.fundCode = this.fundCode.text;
	    	else
	    		reqObj.fundCode = this.fund.fundCode.text;
	    	if(!this.bankCode.enabled)
	    		reqObj.bankCode = this.bankCode.text;
	    	else
	    		reqObj.bankCode = this.finInst.finInstCode.text;	*/
	    	reqObj.fundCode = this.fundPopUp.fundCode.text;
	    	reqObj.bankCode = this.finInstPopUp.finInstCode.text;
	    	return reqObj;
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