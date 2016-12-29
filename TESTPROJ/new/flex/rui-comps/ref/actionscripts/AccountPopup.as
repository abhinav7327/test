// ActionScript file for account popup

         import com.nri.rui.core.controls.XenosAlert;
         import com.nri.rui.core.utils.XenosStringUtils;
         import com.nri.rui.ref.popupImpl.FinInstitutePopUpHbox;
         import com.nri.rui.ref.popupImpl.StrategyPopUpHBox;
         
         import mx.collections.ArrayCollection;
         import mx.controls.TextInput;
         import mx.rpc.events.FaultEvent;
         import mx.rpc.events.ResultEvent;
          
         
    	 [Bindable]
    	 private var finInst:FinInstitutePopUpHbox = new FinInstitutePopUpHbox();
    	 [Bindable]
    	 private var strategyPopup:StrategyPopUpHBox = new StrategyPopUpHBox();
    	 [Bindable]
    	 private var counterPartyCodeTextBox:TextInput = new TextInput();
    	 [Bindable]
		 private var pageNo :int = 1;
		 [Bindable]
		 public var LMValue :String = "";
		 [Bindable]
		 public var cpCodePreset :String = "";
		 [Bindable]
		 public var cpTypePreset :String = "";
		 
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
        public function populatePopUpQuerySummaryPage1(event:ResultEvent):void {
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
				    changeCurrentState();
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
          * This will return the account number selected from the popup 
          * window to the main application.
          */  
        public function returnActNo():void {
             if (accountSummary.selectedItem != null) {
             	
                 var retAccountNo : String = new String(accountSummary.selectedItem.value);
                 var retBankCode  : String = new String(accountSummary.selectedItem.bankCode);
                 var retBankName  : String = new String(accountSummary.selectedItem.bankName);
                 
                 retTxtInput.text = retAccountNo;
                 bankCode.text    = retBankCode;
                 bankName.text    = retBankName;
                 super.closeWindow();
                 focusManager.setFocus(retTxtInput);
                 //XenosAlert.info(retBankCode+" ******* "+retBankName);
             }
        }
        
        /**
          * This will initialize the account pop up query page.
          * @param ResultEvent the result set event object.
          */
        public override function populatePopUpQueryPage(event: ResultEvent) : void {
            var i:int = 0;
            var counterPartyDetailTypeInitColl: ArrayCollection = null;
            var taxIdTypeInitColl: ArrayCollection = null;
            var counterPartyDetailTypeColl: ArrayCollection = null;
            var taxIdTypeColl: ArrayCollection = new ArrayCollection();
            var bankAccTypeInitColl: ArrayCollection = null;
            var bakAccTypeColl:ArrayCollection=new ArrayCollection();
            var longShortFlagInitColl:ArrayCollection=null;
            var longShortFlagColl:ArrayCollection=new ArrayCollection();
            
            //Populating  the couneter party type drop down list
            counterPartyDetailTypeColl = new ArrayCollection();
            if(event.result.accountPopupQueryActionForm.cpType.item is ArrayCollection) {
                counterPartyDetailTypeInitColl = event.result.accountPopupQueryActionForm.cpType.item as ArrayCollection;
            } else {
                counterPartyDetailTypeInitColl = new ArrayCollection();
                counterPartyDetailTypeInitColl.addItem(event.result.accountPopupQueryActionForm.cpType.item);
            }
            fundPopUp.LMFlag = LMValue;
            if(event.result.accountPopupQueryActionForm.fundCode != null)
            {
            	
	    		fundPopUp.fundCode.text = event.result.accountPopupQueryActionForm.fundCode; 
	    		fundPopUp.enabled=false;
	        }            
            
            if(event.result.accountPopupQueryActionForm.ctxSettlementBank != null)
            {
            	counterPartyCodeTextBox.width = 100;
    			counterPartyCodeTextBox.name = "counterPartyCode";
            	counterpartyCodeBox.removeAllChildren();
	    		counterPartyCodeTextBox.enabled = false;
	    		counterPartyCodeTextBox.text = event.result.accountPopupQueryActionForm.ctxSettlementBank; 
	    		counterpartyCodeBox.addChild(counterPartyDetailTypeList); 
	    		counterpartyCodeBox.addChild(counterPartyCodeTextBox);  
	        }            
            else
            	counterPartyDetailTypeColl.addItem({label:" ", value: " "});

            for(i = 0; i<counterPartyDetailTypeInitColl.length; i++) {
                counterPartyDetailTypeColl.addItem(counterPartyDetailTypeInitColl[i]);    
            }
            counterPartyDetailTypeList.dataProvider = counterPartyDetailTypeColl;
            if(!XenosStringUtils.isBlank(this.cpCodePreset)){
            		var index:int = getIndexOfLabelValueBean(counterPartyDetailTypeColl,cpTypePreset);
            		this.counterPartyDetailTypeList.selectedIndex = index;
	            	finInst.percentWidth = 50;
	            	counterpartyCodeBox.addChild(finInst);
	            	finInst.finInstCode.text = this.cpCodePreset;
					
					longShortFlagId.visible = false;
					longShortFlagId.includeInLayout = false;
					if (longShortFlagList.selectedItem != null) {
						longShortFlagList.selectedItem.value = "";
					}
					
            	}
            	else
            	if(event.result.accountPopupQueryActionForm.ctxSettlementBank == null)
           			populateCounterpartyCode(); 
            //Populating  the tax id type drop down list
            taxIdTypeInitColl = event.result.accountPopupQueryActionForm.taxId.item as ArrayCollection;
            taxIdTypeColl.addItem({label:" ", value: " "});
            for(i = 0; i<taxIdTypeInitColl.length; i++) {
                taxIdTypeColl.addItem(taxIdTypeInitColl[i]);            
            }
            taxIdTypeList.dataProvider = taxIdTypeColl;
            
            //Populating  the Bank Account type drop down list
            bankAccTypeInitColl = event.result.accountPopupQueryActionForm.bankAccountTypeList.item as ArrayCollection;
            bakAccTypeColl.addItem({label:" ", value: " "});
            for(i = 0; i<bankAccTypeInitColl.length; i++) {
                bakAccTypeColl.addItem(bankAccTypeInitColl[i]);            
            }
            bankAccTypeList.dataProvider = bakAccTypeColl;
            
            //accountNo.text = retTxtInput.text;
            accountNo.setFocus();
            
            //Populating  the long short flag drop down list
            longShortFlagColl = new ArrayCollection();
            if(event.result.accountPopupQueryActionForm.longShortFlagList.item is ArrayCollection) {
                longShortFlagInitColl = event.result.accountPopupQueryActionForm.longShortFlagList.item as ArrayCollection;
            } else {
                longShortFlagInitColl = new ArrayCollection();
                longShortFlagInitColl.addItem(event.result.accountPopupQueryActionForm.longShortFlagList.item);
            }
            //longShortFlagInitColl = event.result.accountPopupQueryActionForm.longShortFlagList.item as ArrayCollection;
            longShortFlagColl.addItem({label:" ", value: " "});
            for(i = 0; i<longShortFlagInitColl.length; i++) {
                longShortFlagColl.addItem(longShortFlagInitColl[i]);            
            }
            longShortFlagList.dataProvider = longShortFlagColl;
            
        }
        
        /**
         * Reset the account query page. 
         */
        public override function resetQuery():void {
           this.cpCodePreset = "";
           this.cpTypePreset = "";
           super.initPopup();
           errPage.clearError(null);
           clearResultPage(); 
           accountPopupQueryPnl.percentWidth=100;
           resultPnl.percentWidth=100;
           //clearing fields
           accountNo.text="";
           fundPopUp.fundCode.text = "";
           defaultShortName.text = "";
           
       }
        /**
         * This API add popup based on counterPartyDetailTypeList drop down
         * @TODO To be implemented if requried.
         * 
         */
         private function populateCounterpartyCode():void{
         		finInst.percentWidth = 50;
	    		finInst.name = "Broker";
	    		if(counterpartyCodeBox.getChildByName("Broker")){
			    		finInst.finInstCode.text = "";
			    		counterpartyCodeBox.removeChild(finInst);
			    }
			    if(this.counterPartyCodeTextBox.enabled) {
			    	switch(counterPartyDetailTypeList.selectedItem.label){
		    			case "BROKER"			:
		    			case "BANK/CUSTODIAN"	:
		    										counterpartyCodeBox.addChild(finInst);
		    										longShortFlagId.visible = false;
	    		    								longShortFlagId.includeInLayout = false;
	    		    								if(longShortFlagList.selectedItem!=null){longShortFlagList.selectedItem.value ="";}
		    										break;
		    			case "FUND"				:
		    			default					:	
		    										longShortFlagId.visible = true;
	    											longShortFlagId.includeInLayout = true;
	    											
		    		}	
			    }
    								
    		}
         
         
        /* private function populateCounterpartyCode():void{
    		finInst.percentWidth = 50;
    		finInst.name = "Broker";
    		    		
    		strategyPopup.percentWidth = 50;
    		strategyPopup.name = "Firm";
		
			counterPartyCodeTextBox.width = 100;
			counterPartyCodeTextBox.name = "counterPartyCode";
			if(counterPartyCodeTextBox.enabled)
			{
		    	if(counterPartyDetailTypeList.selectedItem.label == "BROKER"  || counterPartyDetailTypeList.selectedItem.label == "BANK/CUSTODIAN"){
		    		if(counterpartyCodeBox.getChildByName("Firm")){
		    			strategyPopup.strategyCode.text = "";
		    			counterpartyCodeBox.removeChild(strategyPopup);
		    		}
		    		else if(counterpartyCodeBox.getChildByName("counterPartyCode")){
		    			counterPartyCodeTextBox.text = "";
		    			counterpartyCodeBox.removeChild(counterPartyCodeTextBox);
		    		}
		    		else if(counterpartyCodeBox.getChildByName("Broker")){
		    			finInst.finInstCode.text = "";
		    			counterpartyCodeBox.removeChild(finInst);
		    		}		    			
		    		counterpartyCodeBox.addChild(finInst);
		    	}
		    	else if((counterPartyDetailTypeList.selectedItem.label == "FIRM") || (counterPartyDetailTypeList.selectedItem.label == "FUND")){
		    		if(counterpartyCodeBox.getChildByName("Broker")){
		    			finInst.finInstCode.text = "";
		    			counterpartyCodeBox.removeChild(finInst);
		    		}
		    		else if(counterpartyCodeBox.getChildByName("counterPartyCode")){
		    			counterPartyCodeTextBox.text = "";
		    			counterpartyCodeBox.removeChild(counterPartyCodeTextBox);
		    		}
			    	counterpartyCodeBox.addChild(strategyPopup);
		    	}
		    	else {
		    		if(counterpartyCodeBox.getChildByName("Broker")){
		    			finInst.finInstCode.text = "";
		    			counterpartyCodeBox.removeChild(finInst);
		    		}		    			
		    		else if(counterpartyCodeBox.getChildByName("Firm"))
		    		{
		    			strategyPopup.strategyCode.text = "";
		    			counterpartyCodeBox.removeChild(strategyPopup);
		    		}
		    		if(!counterpartyCodeBox.getChildByName("counterPartyCode"))
		    			counterpartyCodeBox.addChild(counterPartyCodeTextBox);
		    	}	
	  		}    	
	    } */
	    
	    /**
         * Submit the account query page.
         */
        public override function submitQuery():void { 
            //Set the request parameters
     		var requestObj :Object = populateRequestParams();
     		popUpQueryRequestObj.request = requestObj;             
            popUpQueryRequestObj.url="ref/accountPopupSearch.action"; 
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
	    	reqObj.accountNo = this.accountNo.text;
	    	reqObj.defaultShortName = this.defaultShortName.text;
	    	reqObj.counterPartyDetailType = this.counterPartyDetailTypeList.selectedItem.value;
	    	if(!this.counterPartyCodeTextBox.enabled)
	    		reqObj.counterPartyCode = this.counterPartyCodeTextBox.text;
	    	else if(counterPartyDetailTypeList.selectedItem.label == "FIRM")
    			reqObj.counterPartyCode = this.strategyPopup.strategyCode.text;
	    	else if(counterPartyDetailTypeList.selectedItem.label == "BROKER"  || counterPartyDetailTypeList.selectedItem.label == "BANK/CUSTODIAN")
	    		reqObj.counterPartyCode = this.finInst.finInstCode.text;
	    	else 
	    	 	reqObj.counterPartyCode = this.counterPartyCodeTextBox.text;
	    	reqObj.fundCode = this.fundPopUp.fundCode.text;
	    	reqObj.tinTaxidType = this.taxIdTypeList.selectedItem.value;
	    	reqObj.bankAccountType = (this.bankAccTypeList.selectedItem!=null) ? this.bankAccTypeList.selectedItem.value : "";
	    	reqObj.unique = new Date().getTime() + "";
	    	reqObj.longShortFlag = (this.longShortFlagList.selectedItem!=null) ? this.longShortFlagList.selectedItem.value : "";
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
        
        private function doPrev():void{
        	pageNo--;
	    	page.text = pageNo+"";
        	rndNo= Math.random();
        	popUpQueryDoPrevious.resultFormat="xml";
            popUpQueryDoPrevious.url=mapping + "?method=doPrevious&rnd="+ rndNo;
            popUpQueryDoPrevious.send();
        }
		private function doNextPage():void{
			pageNo++;
	        page.text = pageNo+"";
        	rndNo= Math.random();
        	popUpQueryDoNext.resultFormat="xml";
            popUpQueryDoNext.url=mapping + "?method=doNext&rnd="+ rndNo;
            popUpQueryDoNext.send();
        }
        
/**
 * Calculates the index of a label value bean given its value, within a given 
 * array collection of such beans.
 * Returns 0 if the value is null or empty string.
 */
private function getIndexOfLabelValueBean(collection:ArrayCollection, value:String):int {
	var index:int = 0;
	if (value == null || value == XenosStringUtils.EMPTY_STR) {
		return index;
	}
	for (var count:int = 0; count < collection.length; count++) {
		var bean:Object = collection.getItemAt(count);
		if (bean['value'] == value) {
			index = count;
			break;
		}
	}
	return index;
}