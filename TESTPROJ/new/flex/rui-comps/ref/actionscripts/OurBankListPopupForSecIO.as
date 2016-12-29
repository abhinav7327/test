// ActionScript file for account popup

        import mx.collections.ArrayCollection;
        import mx.controls.TextInput;
        import mx.rpc.events.FaultEvent;
        import mx.rpc.events.ResultEvent;
        import com.nri.rui.core.controls.XenosAlert;
         

		[Bindable]private var currentPage:Number = 0;
	    [Bindable]private var pageSize:uint = 12;
	    [Bindable]private var navPage:uint = 1;
	    [Bindable]private var navSize:uint = 10;  	
		 
		[Bindable]
		public var retSettleAc :TextInput;
        /**
         * This API will clear the result page to empty page
         */
        public function clearResultPage():void{
            summaryResult.removeAll();
        }
        /**
	    * It sets the enable property of the Next and Previous button
	    * depending on the result set, whether available or not
	    */
	    public function setPrevNextVisibility(prev:Boolean, next:Boolean):void{
	    	
//	    	this.prevPage.enabled = prev;
//	    	this.nextPage.enabled = next;
//	    	if(prev){
//	    		prevPage.toolTip ="Previous/"+(pageNo-1);
//	    	}else{
//	    		prevPage.toolTip = "Previous";
//	    	}
//	    	if(next){
//	    		nextPage.toolTip ="Next/"+(pageNo+1);
//	    	}else{
//	    		nextPage.toolTip = "Next";
//	    	}
	    	
	    }      
       /**
         * The view state handler.
         * This is used to changed the view state between Query and Query Result container. 
         */  
		private function changeCurrentState():void{
            //this.currentState = "qryres";
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
        public function returnBankAndSettleActNo(data:Object):void { //data.settlementBank,data.settlementAc
             if (accountSummary.selectedItem != null){
                 var bankCode : String = data.settlementBank;
                 retTxtInput.text=bankCode; 
                 retSettleAc.text=data.settlementAc;
                 //retTxtInput.text = bankCode;
                 //XenosAlert.info("bankCode" + bankCode + " SettleAc: " + data.settlementAc);
                 super.closeWindow();
             }
        }
        
        /**
          * This will initialize the pop up query page.
          * @param ResultEvent the result set event object.
          */
        public override function populatePopUpQueryPage(event: ResultEvent) : void {
        		
			
			if(null != event ){
			  var rs:XML = XML(event.result);
			  if(rs.child("Errors") != null && rs.child("Errors").length()>0){
			  	// i.e. Must be error, display it .
                var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list 			 	
	 	        for each ( var error:XML in rs.Errors.error ) {
					errorInfoList.addItem(error.toString());
		        }
	 	        errPage.showError(errorInfoList);//Display the error	 	         
			  }else{
			  	try {
			  		errPage.clearError(event);
			        summaryResult.removeAll();			  		
		  			if(rs.summary.noOfRecords > 0){
		  				var initcol:ArrayCollection = new ArrayCollection();
					    for each ( var rec:XML in rs.summary.data ) {						    	
		 				    initcol.addItem(rec);
					    }					    
					    summaryResult = initcol;
//		  				setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
			           	summaryResult.refresh();	
		  			}
			  			  		
			  	}catch(e:Error){
			  		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			  	}
			  }	
			}			
		}
        
        /**
         * Reset the account query page. 
         */
        public override function resetQuery():void { 
           super.initPopup();
       }
        	    
	    /**
         * Submit the account query page.
         */
        public override function submitQuery():void { 

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
