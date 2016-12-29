
	// ActionScript file
     import com.nri.rui.core.controls.XenosAlert;
     import com.nri.rui.core.utils.*;
     
     import mx.collections.ArrayCollection;
     import mx.controls.TextInput;
     import mx.managers.PopUpManager;
     import mx.rpc.events.FaultEvent;
     import mx.rpc.events.ResultEvent;            
	 import com.nri.rui.core.controls.XenosHTTPService;
	 import com.nri.rui.core.controls.XenosButton;
	 import com.nri.rui.core.startup.XenosApplication;

     [Bindable]
     public var popUpQueryRequest : XenosHTTPService;
     public var popUpQueryDoNext : XenosHTTPService;
     public var popUpQueryDoPrevious : XenosHTTPService;
     public var popUpResetQuery : XenosHTTPService;
     
     [Bindable]
     public var summaryResult:ArrayCollection = new ArrayCollection();
     public var emptyResult:ArrayCollection= new ArrayCollection();
     
     [Bindable]
     // A reference to the TextInput control in which to put the result.
     //public var retTxtInput:AutoComplete;
     public var retTxtInput:TextInput;
     [Bindable]
     //Items receiveing through context - Non display objects
     public var receiveCtxItems:ArrayCollection;
     [Bindable]
     //Items returning through context - Non display objects
     public var returnContextItems:ArrayCollection;
     public var rndNo:Number;

     [Bindable]
     public var intfQueryMode:String = "";
     [Bindable]
     public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
	 [Bindable]
     public var returnDefaultBtn : XenosButton = null;

        /**
         * This API will clear the result page to empty page
         */
        private function clearResultPage():void{
            summaryResult = emptyResult;
            nextPage.enabled = false;
            prevPage.enabled = false;
        }
		/**
         * It sets the enable property of the Next and Previous button
         * depending on the result set, whether available or not
         */
        public function setPrevNextVisibility(prev:Boolean, next:Boolean):void{
                this.prevPage.enabled = prev;
                this.nextPage.enabled = next;
        } 
        /**
         * Populate the query result information to the fund query summary page.
         * @param ResultEvent the result set event object.
         */      
         public  function populatePopUpQuerySummaryPage(event:ResultEvent):void {
            var showNext:Boolean;
            var showPrev:Boolean;
            if (null != event) {            
                if(null == event.result.rows){
                	summaryResult.removeAll();
                    if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
                        XenosAlert.info("Not any Result Found!");

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
	                	XenosAlert.info("No records found matching the search criteria.");
                }
            }else {
                summaryResult = new ArrayCollection();
                XenosAlert.info("No records found matching the search criteria.");
            }

        }
        /**
         * Reset the account query page. 
         */
        public  function resetQuery():void {
           errPage.clearError(null);
           clearResultPage();
           
           rndNo= Math.random();      
           popUpQueryRequestObj1.url ="nam/namFeedInterfacePopupQueryDispatch.action?method=resetQuery&rnd="+ rndNo;     
           popUpQueryRequestObj1.send();
           errPage.clearError(null);
           clearResultPage();  
           interfacePopupQueryPnl.percentWidth=100;
           resultPnl.percentWidth=100;
           //clearing fields
           interfaceId.text = "";
           interfaceId.setFocus();
           interfaceName.text = "";
           feedTxnType.text = "";
           destinationSystem.text="";
           
        }
         /**
         * The Fault Event Handler used for error in query result http service
         * @param event The fault Event
         * 
         */        
        public function popUpQueryRequestErrorHand(event:FaultEvent):void {
            var errorMsg : String = 'Error Occured :  ' + event.fault.faultString;
            XenosAlert.error(errorMsg);
        } 

        /**
          * This will return the interfaceId selected from the popup 
          * window to the main application.
          */  
        public function returnInterfaceId():void {
             if (interfaceSummary.selectedItem != null){
                 var retinterfaceId : String = new String(interfaceSummary.selectedItem.interfaceId);
                 retTxtInput.text=retinterfaceId; 
                 closeWindow();
                 focusManager.setFocus(retTxtInput);
             }
        }
        
       public function closeWindow():void {
       	   app.submitButtonInstance = returnDefaultBtn;
           PopUpManager.removePopUp(this);
        }
        
       public function doPrevious():void {  
            popUpQueryDoPrevious.url="nam/namFeedInterfacePopupQueryDispatch.action?method=doPrevious"
            popUpQueryDoPrevious.send();
        }
        /**
         *  Traverse the next result page
         */
        public function doNext():void {  
            popUpQueryDoNext.url="nam/namFeedInterfacePopupQueryDispatch.action?method=doNext"
            popUpQueryDoNext.send();
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
       
       public function submitQuery():void {
       		popUpQueryRequestObj.url="nam/namFeedInterfacePopupQueryDispatch.action?method=submitQuery";
       		var requestObj :Object = populateRequestParams();
         	popUpQueryRequestObj.request = requestObj; 
            popUpQueryRequestObj.send();
        } 
       
       /**
	    * This method will populate the request parameters for the
	    * submitQuery call and bind the parameters with the HTTPService
	    * object.
	    */
	    private function populateRequestParams():Object {
	    	 var reqObj : Object = new Object();
	         reqObj.queryMode = queryMode.text
	         reqObj.interfaceId = this.interfaceId.text;
	         reqObj.interfaceName = this.interfaceName.text;
             reqObj.destinationSystem = this.destinationSystem.selectedItem != null ? this.destinationSystem.selectedItem.value : "";
	         reqObj.feedTxnType = this.feedTxnType.text;	        
	         return reqObj; 
	    }
       
        public function initPopup():void {
			this.returnDefaultBtn = app.submitButtonInstance;
			addEventListener(KeyboardEvent.KEY_DOWN,submitOnEnter);
			var reqObj : Object = new Object();
	        reqObj.method = "doInit";
	        reqObj.queryMode = "query";
	        reqObj.rnd = Math.random()+"";	               
            popUpQueryRequestObj1.url ="nam/namFeedInterfacePopupQueryDispatch.action";
            popUpQueryRequestObj1.request = reqObj;
           	popUpQueryRequestObj1.send();
           	
            reqObj.method = "load";
            popUpQueryRequestObj1.url = "nam/namFeedInterfacePopupQueryDispatch.action";
            popUpQueryRequestObj1.request = reqObj;        
            popUpQueryRequestObj1.send();
        }
        
        /**
		 * This function is used to attach ENTER key with the Submit button
		 * 
		 */ 
		public function submitOnEnter(event:KeyboardEvent){
			if(event.keyCode == Keyboard.ENTER){
				 if(app.submitButtonInstance){		
					app.submitButtonInstance.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				} 
				}
			}

         /**
          * This API is handleing the fund query page initialization Http service.
          * @param ResultEvent the result set event object.
          */
        public  function populatePopUpQueryPage(event: ResultEvent) : void {
            var i:int = 0;
            var initColl: ArrayCollection = new ArrayCollection();
            var tempColl: ArrayCollection = null;
        	if(event.result){
        		if(intfQueryMode == "query")
        		{
		        	if(event.result.namFeedInterfacePopupQueryActionForm.scrDisData.destSystemList.destSystemList is ArrayCollection){
		            	initColl = event.result.namFeedInterfacePopupQueryActionForm.scrDisData.destSystemList.destSystemList as ArrayCollection;   	
		        	}else{
		        		initColl.addItem(event.result.namFeedInterfacePopupQueryActionForm.scrDisData.destSystemList.destSystemList)
		        	}
		        }
		        else
		        {
		        	if(event.result.namFeedInterfacePopupQueryActionForm.scrDisData.resendDesSysList.resendDesSysList is ArrayCollection){
	            		initColl = event.result.namFeedInterfacePopupQueryActionForm.scrDisData.resendDesSysList.resendDesSysList as ArrayCollection;   	
	        		}else{
	        			initColl.addItem(event.result.namFeedInterfacePopupQueryActionForm.scrDisData.resendDesSysList.resendDesSysList)
	        		}
		        }	
	        	tempColl = new ArrayCollection();    		
		        
		        tempColl.addItem({label:"", value: ""});
            	for(i = 0; i<initColl.length; i++) {
                	tempColl.addItem(initColl[i]);    
            	}
	        	destinationSystem.dataProvider = tempColl;
        	}
        	interfaceId.setFocus();
        }