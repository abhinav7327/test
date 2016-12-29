
	// ActionScript file
     import com.nri.rui.core.controls.XenosAlert;
     import mx.collections.ArrayCollection;
     import mx.controls.TextInput;
     import mx.managers.PopUpManager;
     import mx.rpc.events.FaultEvent;
     import mx.rpc.events.ResultEvent;
     import com.nri.rui.core.controls.XenosHTTPService;      

     [Bindable]
     public var popUpQueryRequest : XenosHTTPService;
     public var popUpQueryDoNext : XenosHTTPService;
     public var popUpQueryDoPrevious : XenosHTTPService;
     public var popUpResetQuery : XenosHTTPService;

     [Bindable]
     public var strIntfFeedDetailPk:String = new String();
     [Bindable]
     public var strDestinationSystem:String = new String();
     
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
			// this.prevPage.enabled = prev;
			// this.nextPage.enabled = next;
        }
         
        /**
         * Populate the query result information to the fund query summary page.
         * @param ResultEvent the result set event object.
         */      
         public  function populateDetailViewSummaryPage(event:ResultEvent):void {
            summaryResult = emptyResult;
            var showNext:Boolean;
            var showPrev:Boolean;
            if (null != event) {       
                if(null == event.result.rows){
                	summaryResult.removeAll();
                    if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
		                 XenosAlert.info("Not any Result Found!");

                    } else { // Must be error
                 		// errPage.displayError(event);    
                    }               
                }else {
                		// errPage.clearError(event); 
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
	            	{
					   	XenosAlert.info("No records found matching the search criteria.");
	             	}
                }
            }else {
                summaryResult = new ArrayCollection();
           		XenosAlert.info("No records found matching the search criteria.");
            }

        }
        
       public function closeWindow():void {
           PopUpManager.removePopUp(this);
        }
      
       public function doPrevious():void {  
			// NamFeedStatusDetailsDispatchRequest.url="nam/namFeedStatusDetailsDispatch.action?method=doPrevious"
			// NamFeedStatusDetailsDispatchRequest.send();
        }
        /**
         *  Traverse the next result page
         */
        public function doNext():void {  
			// NamFeedStatusDetailsDispatchRequest.url="nam/namFeedStatusDetailsDispatch.action?method=doNext"
			// NamFeedStatusDetailsDispatchRequest.send();
        } 
     
        public function initPopup():void {
           NamFeedStatusDetailsDispatchRequest.url ="nam/namFeedStatusDetailsDispatch.action?method=submitQuery&intfFeedDetailPk=91&destinationSystem=ICON";
           NamFeedStatusDetailsDispatchRequest.send();
        }