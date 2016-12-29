// ActionScript file

         import com.nri.rui.core.controls.XenosAlert;
         
         import mx.collections.ArrayCollection;
         import mx.rpc.events.FaultEvent;
         import mx.rpc.events.ResultEvent;
		 import com.nri.rui.core.utils.HiddenObject;
		 import mx.utils.StringUtil;
         import mx.utils.StringUtil;
          
         
         [Bindable]
		 private var pageNo :int = 1;
		 
		 [Bindable]
		 public var LMValue :String = "";
		 
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
         * Populate the query result information to the fund query summary page.
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
         * Reset the account query page. 
         */
        public override function resetQuery():void { 
           super.resetQuery();
           errPage.clearError(null);
           clearResultPage();  
           fundPopupQueryPnl.percentWidth=100;
           resultPnl.percentWidth=100;
           //clearing fields
           officeIdList.selectedIndex = 0;
           fundName.text = "";
           fundCode.text = "";
           fundCategoryList.selectedIndex = 0;
           custodian.bankCode.text = "";
           settlementAccount.accountNo.text = "";
           baseCcy.ccyText.text = "";
           trialbalanceid.trialBalanceId.text = "";
           taxFeeInclusionList.selectedIndex = 0;
           iconRequiredList.selectedIndex = 0;
           gemsRequiredList.selectedIndex = 0;
           // int1RequiredList.selectedIndex = 0;
           formaRequiredList.selectedIndex = 0;
           fbpifRequiredList.selectedIndex = 0;
           shortSellFlagList.selectedIndex = 0;
           cashViewerRequiredList.selectedIndex = 0;
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
          * This will return the fund code selected from the popup 
          * window to the main application.
          */  
        public function returnFundCode():void {
             if (fundSummary.selectedItem != null){
                 var retfundCode : String = new String(fundSummary.selectedItem.value);
                 retTxtInput.text=retfundCode; 
                 
                 super.closeWindow();
                 focusManager.setFocus(retTxtInput);
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
          * This API is handleing the fund query page initialization Http service.
          * @param ResultEvent the result set event object.
          */
        public override function populatePopUpQueryPage(event: ResultEvent) : void {

            var i:int = 0;
            var initColl: ArrayCollection = null;
            var tempColl: ArrayCollection = null;
            //Populating  the fubd category drop down list
            tempColl = new ArrayCollection();
            if(event.result.fundPopupQueryActionForm.fundCategory.item is ArrayCollection) {
                initColl = event.result.fundPopupQueryActionForm.fundCategory.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.fundPopupQueryActionForm.fundCategory.item);
            }
            tempColl.addItem({label:"", value: ""});
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);    
            }
            fundCategoryList.dataProvider = tempColl;
            
			//Populating  the Tax Fee Inclusion drop down list
			initColl.removeAll();
            tempColl = new ArrayCollection();
            if(event.result.fundPopupQueryActionForm.taxFeeInclusionList.item is ArrayCollection) {
                initColl = event.result.fundPopupQueryActionForm.taxFeeInclusionList.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.fundPopupQueryActionForm.taxFeeInclusionList.item);
            }
            tempColl.addItem({label:"", value: ""});
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);    
            }
            taxFeeInclusionList.dataProvider = tempColl;
            
            //Populating  the Icon Required drop down list
			initColl.removeAll();
            tempColl = new ArrayCollection();
            if(event.result.fundPopupQueryActionForm.iconRequiredList.item is ArrayCollection) {
                initColl = event.result.fundPopupQueryActionForm.iconRequiredList.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.fundPopupQueryActionForm.iconRequiredList.item);
            }
            tempColl.addItem({label:"", value: ""});
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);    
            }
            iconRequiredList.dataProvider = tempColl;
            
            //Populating  the Gems Required drop down list
			initColl.removeAll();
            tempColl = new ArrayCollection();
            if(event.result.fundPopupQueryActionForm.gemsRequiredList.item is ArrayCollection) {
                initColl = event.result.fundPopupQueryActionForm.gemsRequiredList.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.fundPopupQueryActionForm.gemsRequiredList.item);
            }
            tempColl.addItem({label:"", value: ""});
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);    
            }
            gemsRequiredList.dataProvider = tempColl;
            
            /*
            //Populating  the INT1 Required drop down list
			initColl.removeAll();
            tempColl = new ArrayCollection();
            if(event.result.fundPopupQueryActionForm.int1RequiredList.item is ArrayCollection) {
                initColl = event.result.fundPopupQueryActionForm.int1RequiredList.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.fundPopupQueryActionForm.int1RequiredList.item);
            }
            tempColl.addItem({label:"", value: ""});
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);    
            }
            int1RequiredList.dataProvider = tempColl;
            */
            
            //Populating  the Forma Required drop down list
			initColl.removeAll();
            tempColl = new ArrayCollection();
            if(event.result.fundPopupQueryActionForm.formaRequiredList.item is ArrayCollection) {
                initColl = event.result.fundPopupQueryActionForm.formaRequiredList.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.fundPopupQueryActionForm.formaRequiredList.item);
            }
            tempColl.addItem({label:"", value: ""});
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);    
            }
            formaRequiredList.dataProvider = tempColl;
            
            // Populating the Short Sell Flag List values
            initColl.removeAll();
            tempColl = new ArrayCollection();
            if(event.result.fundPopupQueryActionForm.shortSellFlagList.item is ArrayCollection) {
                initColl = event.result.fundPopupQueryActionForm.shortSellFlagList.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.fundPopupQueryActionForm.shortSellFlagList.item);
            }
            tempColl.addItem({label:"", value: ""});
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);    
            }
            shortSellFlagList.dataProvider = tempColl;
            
            
            // Populating the Cash Viewer Required List values
            initColl.removeAll();
            tempColl = new ArrayCollection();
            if(event.result.fundPopupQueryActionForm.cashViewerRequiredList.item is ArrayCollection) {
                initColl = event.result.fundPopupQueryActionForm.cashViewerRequiredList.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.fundPopupQueryActionForm.cashViewerRequiredList.item);
            }
            tempColl.addItem({label:"", value: ""});
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);    
            }
            cashViewerRequiredList.dataProvider = tempColl;
            
            //Populating FBP IF REQD List values
            initColl.removeAll();
            tempColl = new ArrayCollection();
            if(event.result.fundPopupQueryActionForm.fbpIfRequiredList.item is ArrayCollection) {
                initColl = event.result.fundPopupQueryActionForm.fbpIfRequiredList.item as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.fundPopupQueryActionForm.fbpIfRequiredList.item);
            }
            tempColl.addItem({label:"", value: ""});
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);    
            }
            fbpifRequiredList.dataProvider = tempColl;
            //Populating  Office Id drop down list
            initColl.removeAll();
            tempColl = new ArrayCollection();
            if(event.result.fundPopupQueryActionForm.officeIdTypes != null ) {
                if(event.result.fundPopupQueryActionForm.officeIdTypes.officeId is ArrayCollection) {
                    initColl = event.result.fundPopupQueryActionForm.officeIdTypes.officeId as ArrayCollection;
                } else {
                    initColl = new ArrayCollection();
                    initColl.addItem(event.result.fundPopupQueryActionForm.officeIdTypes.officeId);
                }
            }
            tempColl.addItem({label:" ", value: " "});
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);            
            }
            officeIdList.dataProvider = tempColl;
            officeIdList.setFocus();
            //fundCode.text = retTxtInput.text;
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
         * Initalize the fund popup container
         */
        public override function initPopup():void {
            popUpContainer.url = mapping + "?unique=" + new Date().getTime() +"&LMFlag="+LMValue+ "&method=load"+super.getReceiveContext();
            //XenosAlert.info(popUpContainer.url);
            popUpContainer.send();
        }
         /**
         * Submit the fund query page.
         */
        public override function submitQuery():void { 
            //Set the request parameters
     		var requestObj :Object = populateRequestParams();
     		popUpQueryRequestObj.request = requestObj;             
            popUpQueryRequestObj.url="ref/fundPopupSearch.action"+ "?method=submitQuery"; 
            popUpQueryRequestObj.send();
        } 
        
        /**
	     * This method will populate the request parameters for the
	     * submitQuery call and bind the parameters with the HTTPService
	     * object.
	     */
	    private function populateRequestParams():Object {
	    	
	    	var reqObj : Object = new Object();
	    	reqObj.officeId=officeIdList.text;
            reqObj.fundName=fundName.text;
            reqObj.fundCode=fundCode.text;
            reqObj.fundCategory=fundCategoryList.selectedItem.value;
            reqObj.custodian=custodian.bankCode.text;
            reqObj.settlementAccount=settlementAccount.accountNo.text;
            reqObj.baseCcy=baseCcy.ccyText.text;
            reqObj.trialBalanceId=trialbalanceid.trialBalanceId.text;
            reqObj.taxFeeInclusion = taxFeeInclusionList.selectedItem.value;
            reqObj.iconRequired = iconRequiredList.selectedItem.value;
            reqObj.gemsRequired = gemsRequiredList.selectedItem.value;
            //reqObj.int1Required = int1RequiredList.selectedItem.value;
            reqObj.formaRequired = formaRequiredList.selectedItem.value;
            reqObj.shortSellFlag = shortSellFlagList.selectedItem.value;
            reqObj.cashViewerRequired = cashViewerRequiredList.selectedItem.value;
            reqObj.fbpIfRequired = fbpifRequiredList.selectedItem.value;
            reqObj.LMFlag = LMValue;
	    	return reqObj;
	    }