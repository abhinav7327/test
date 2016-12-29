// ActionScript file

         import com.nri.rui.core.Globals;
         import com.nri.rui.core.controls.XenosAlert;
         import com.nri.rui.core.startup.XenosApplication;
         
         import mx.collections.ArrayCollection;
         import mx.events.ValidationResultEvent;
         import mx.formatters.NumberBase;
         import mx.rpc.events.FaultEvent;
         import mx.rpc.events.ResultEvent;
          

        /* [Bindable]
        private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE); */
        [Bindable]
		 private var pageNo :int = 1;
		 
//		[Bindable]
//		var rs:XML ; 
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
         * Populate the query result information to the account query summary page.
         * @param ResultEvent the result set event object.
         */     
         
         public override function populatePopUpQuerySummaryPage(event:ResultEvent):void {
            var rs:XML = XML(event.result);
            
 //           rs = new XML(event.result)
            if (null != event) {
			if(rs.child("row").length()>0) {
				errPage.clearError(event);
	            summaryResult.removeAll();
				try {
				    for each ( var rec:XML in rs.row ) {
	 				    summaryResult.addItem(rec);
				    }
				   // changeCurrentState();
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
            
       

 /*         public override function populatePopUpQuerySummaryPage(event:ResultEvent):void {

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
            } 
        } */
         /**
         * Reset the account query page. 
         */
        public override function resetQuery():void { 
           super.resetQuery();
           errPage.clearError(null);
           clearResultPage();  
           instrumentPopupQueryPnl.percentWidth=100;
           resultPnl.percentWidth=100;
           //clearing fields
          securityCode.text = "";
          instrumentName.text = "";
          listedMarket.itemCombo.text = "";
          rate.text = "";
          instrumentType.itemCombo.text = "";
          ccyBox.ccyText.text = "";
          maturityDateFrom.text = "";
          maturityDateTo.text = "";
           
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
        public function returnInstrumentId():void {
             if (instrumentSummary.selectedItem != null){
                 var retInstrumentId : String = new String(instrumentSummary.selectedItem.instrumentCode);
                 retTxtInput.text=retInstrumentId; 
                 super.closeWindow();
             }
        }
        /**
         * Reset the account query page. 
         */
 /*       public override function resetQuery():void { 
           super.resetQuery();
           errPage.clearError(null);
           clearResultPage();  
           instrumentPopupQueryPnl.percentWidth=100;
           resultPnl.percentWidth=0;
           //clearing fields
           securityCode.text="";
           instrumentName.text="";
           listedMarket.text="";
           rate.text="";
           instrumentType.text="";
           ccyBox.ccyText.text="";
           maturityDateFrom.text="";
           maturityDateTo.text="";
        }
        */
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
          * This API is handleing the Instrument query page initialization Http service.
          * @param ResultEvent the result set event object.
          */
        public override function populatePopUpQueryPage(event: ResultEvent) : void {
            //To be implemented if requried
            //securityCode.text = retTxtInput.text;
            securityCode.text = event.result.instrumentPopupQueryActionForm.securityCode;
            //securityCode.setFocus();
            submitQuery();
        }
		public override function doPrevious():void{
        	pageNo--;
	    	page.text = pageNo+"";
	    	popUpQueryDoPrevious.resultFormat="xml";
	    	rndNo= Math.random();
            popUpQueryDoPrevious.url=mapping + "?method=doPrevious&rnd="+ rndNo;
            popUpQueryDoPrevious.send();
        }
		public override function doNext():void{
			pageNo++;
	        page.text = pageNo+"";
	        popUpQueryDoNext.resultFormat="xml";
        	rndNo= Math.random();
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
            popUpQueryRequestObj.url="ref/instrumentPopupSearch.action"+ "?method=submitQuery"; 
            popUpQueryRequestObj.send();
        } 
        
        /**
	     * This method will populate the request parameters for the
	     * submitQuery call and bind the parameters with the HTTPService
	     * object.
	     */
	    private function populateRequestParams():Object {
	    	
	    	var numFormatter:NumberBase = new NumberBase(".",",",".",",");
	    	
	    	var reqObj : Object = new Object();
	    	reqObj.securityCode=securityCode.text;
            reqObj.instrumentType=instrumentType.itemCombo.text;
            reqObj.instrumentName=instrumentName.text;
            reqObj.tradeCcy=ccyBox.ccyText.text;
            reqObj.listedMarket=listedMarket.itemCombo.text;
            reqObj.maturityDateFrom=maturityDateFrom.text; 
            reqObj.maturityDateTo=maturityDateTo.text;
            reqObj.rate=numFormatter.parseNumberString(rate.text);
	    	return reqObj;
	    }
	    
	 /**
     * Formatting rate
     */
     private function rateHandler():void{
     	
     	var vResult:ValidationResultEvent;
     	var tmpStr:String = rate.text;
		vResult = numVal.validate();
        
        if (vResult.type==ValidationResultEvent.VALID) {
     		rate.text=numberFormatter.format(rate.text);     		
        }else{
        	rate.text = tmpStr;        	
        }
     }
