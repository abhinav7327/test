// ActionScript file for BankList PopUp
         
         import com.nri.rui.core.controls.XenosAlert;
         import com.nri.rui.core.utils.HiddenObject;
         
         import mx.collections.ArrayCollection;
         import mx.rpc.events.FaultEvent;
         import mx.rpc.events.ResultEvent;
    	 
    	[Bindable]private var pageNo :int = 1;
		[Bindable]private var currentPage:Number = 0;
	    [Bindable]private var pageSize:uint = 12;
	    [Bindable]private var navPage:uint = 1;
	    [Bindable]private var navSize:uint = 10;
        /**
         * This API will clear the result page to empty page
         */
        public function clearResultPage():void{

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
         * Initalize the bank popup container
         */
		public override function initPopup():void {
			if(receiveCtxItems != null) {
				var str:String = null;
				for(var i:int = 0; i<receiveCtxItems.length; i++) {
					var itemObject:HiddenObject = null;
					var itemName:String = null;
					
					itemObject = HiddenObject (receiveCtxItems.getItemAt(i));
                	itemName = itemObject.m_propertyName;
                	
                	if(itemName == 'dispatchFlag') {
                		mapping = "stl/wireCpBankListPopup.action";
                		str = "changed";
                	}
				}
				if(str != null) {
					receiveCtxItems.removeItemAt(receiveCtxItems.length-1);
					this.dataGridViewStack.selectedChild = cpBankSummaryVBox;
					this.title = this.parentApplication.xResourceManager.getKeyValue('stl.cpbanklist.popup.header');
				} else {
					this.dataGridViewStack.selectedChild = bankSummaryVBox;
				}
			}
			this.popUpQueryPage.resultFormat = "xml";
			super.initPopup();
		}
        
        /**
         * Populate the query result information to the account query summary page.
         * @param ResultEvent the result set event object.
         */      
        public override function populatePopUpQueryPage(event:ResultEvent):void {
            
            if(null != event ) {
			  var rs:XML = XML(event.result);
			  if(rs.child("Errors") != null && rs.child("Errors").length()>0){
			  	// i.e. Must be error, display it .
                var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list 			 	
	 	        for each ( var error:XML in rs.Errors.error ) {
					errorInfoList.addItem(error.toString());
		        }
	 	        errPage.showError(errorInfoList);	         
			  } else {
			  	try {
			  		errPage.clearError(event);
			        summaryResult.removeAll();
		  			if(rs.summary.noOfRecords > 0){
		  				var initcol:ArrayCollection = new ArrayCollection();
					    for each ( var rec:XML in rs.summary.data ) {						    	
		 				    initcol.addItem(rec);
					    }					    
					    summaryResult = initcol;
		  				setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
			           	summaryResult.refresh();	
		  			} else {
		  				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		  			}
			  	} catch(e:Error) {
			  		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			  	}
			  }	
			}
        }
            
      
        /**
         * The Fault Event Handler used for error in query result http service
         * @param event The fault Event
         * 
         */        
        public function popUpQueryRequestErrorHand(event:FaultEvent):void {
            var errorMsg : String = this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred') + event.fault.faultString;
            XenosAlert.error(errorMsg);
        }
        /**
          * This will return the Bank Details od the selected Bank from the popup 
          * window to the main application.
          */  
        public function returnBankInfo():void {
        	
        	var retBank : String = null;
        	var retBankName  : String = null;
        	var retSettleAccount  : String = null;
        	var retBeneficiaryName  : String = null;
        	var retStandingRulePkStr  : String = null;
        	
             if (bankSummary.selectedItem != null) {
             	
                 retBank = new String(bankSummary.selectedItem.settlementBank);
                 retBankName = new String(bankSummary.selectedItem.bankName);
                 retSettleAccount = new String(bankSummary.selectedItem.settlementAc);
                 retStandingRulePkStr = new String(bankSummary.selectedItem.standingRulePk);
                 
             } else if(cpBankSummary.selectedItem != null) {
             	
             	 retBank = new String(cpBankSummary.selectedItem.settlementBank);
                 retBankName = new String(cpBankSummary.selectedItem.bankName);
                 retSettleAccount = new String(cpBankSummary.selectedItem.settlementAc);
                 retBeneficiaryName = new String(cpBankSummary.selectedItem.beneficiaryNameEscaped);
                 retStandingRulePkStr = new String(cpBankSummary.selectedItem.standingRulePk);
             }
             populateReturnContext(retBank,retBankName,retSettleAccount,retBeneficiaryName, retStandingRulePkStr);
             super.closeWindow();
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
        private function populateReturnContext(strBankCode:String,
        										strBankName:String,
        										strAccountNo:String,
        										strBeneficiaryName:String,
        										strStandingRulePk:String):void {
            
            var bankCodeArray:Array = new Array(1);
            bankCodeArray[0] = strBankCode;
            
            var bankNameArray:Array = new Array(1);
            bankNameArray[0] = strBankName;
            
            var accountNoArray:Array = new Array(1);
            accountNoArray[0] = strAccountNo;
            
            var beneficiaryNameArray:Array = new Array(1);
            beneficiaryNameArray[0] = strBeneficiaryName;
            
            var standingRulePkArray:Array = new Array(1);
            standingRulePkArray[0] = strStandingRulePk;
            
            returnContextItems.addItem(new HiddenObject("returnBankCode",bankCodeArray));
            returnContextItems.addItem(new HiddenObject("returnBankName",bankNameArray));
            returnContextItems.addItem(new HiddenObject("returnAccountNo",accountNoArray));
            returnContextItems.addItem(new HiddenObject("returnBeneficiaryName",beneficiaryNameArray));
            returnContextItems.addItem(new HiddenObject("returnStandingRulePk",standingRulePkArray));
        }