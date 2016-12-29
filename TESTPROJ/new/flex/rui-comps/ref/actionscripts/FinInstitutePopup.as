// ActionScript file

         import mx.collections.ArrayCollection;
         import mx.rpc.events.ResultEvent;
         import mx.rpc.events.FaultEvent;
         import com.nri.rui.core.controls.XenosAlert;
         import com.nri.rui.core.utils.HiddenObject;
         import mx.utils.StringUtil;
          
		 [Bindable]
		 private var pageNo :int = 1;
        /**
         * This API will clear the result page to empty page
         */
        private function clearResultPage():void{

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
         * Populate the query result information to the fininst query summary page.
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
           finInstitutePopupQueryPnl.percentWidth=100;
           resultPnl.percentWidth=100;
           //clearing fields
           finInstRoleCode.text="";
           shortName.text="";
           roleDetailTypeList.selectedIndex=0;
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
          * This will return the fininst role code selected from the popup 
          * window to the main application.
          */  
        public function returnFinInstituteId():void {
             if (finInstituteSummary.selectedItem != null){
                 var retFinInstituteId : String = new String(finInstituteSummary.selectedItem.value);
                 retTxtInput.text=retFinInstituteId; 
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

            var i:int = 0;
            var initColl: ArrayCollection = null;
            var tempColl: ArrayCollection = null;
            //Populating  the finnantial roles drop down list
            tempColl = new ArrayCollection();
            if(event.result.finInstPopupQueryActionForm.roleTypes.role is ArrayCollection) {
                initColl = event.result.finInstPopupQueryActionForm.roleTypes.role as ArrayCollection;
            } else {
                initColl = new ArrayCollection();
                initColl.addItem(event.result.finInstPopupQueryActionForm.roleTypes.role);
            }
            tempColl.addItem({label:"", value: ""});
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);    
            }
            roleDetailTypeList.dataProvider = tempColl;
            finInstRoleCode.setFocus();
            //finInstRoleCode.text = retTxtInput.text;
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
            popUpQueryRequestObj.url="ref/finInstSearch.action"+ "?method=submitQuery"; 
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
            reqObj.role=roleDetailTypeList.selectedItem.value;
	    	return reqObj;
	    }