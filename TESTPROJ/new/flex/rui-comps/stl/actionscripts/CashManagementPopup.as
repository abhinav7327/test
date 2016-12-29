// ActionScript file for Cash Management Popup
         
         import com.nri.rui.core.controls.XenosAlert;
         import com.nri.rui.core.utils.HiddenObject;
         import com.nri.rui.core.utils.ProcessResultUtil;
         
         import mx.collections.ArrayCollection;
         import mx.rpc.events.FaultEvent;
         import mx.rpc.events.ResultEvent;
         
    	 
    	[Bindable]private var pageNo :int = 1;
		[Bindable]private var currentPage:Number = 0;
	    [Bindable]private var pageSize:uint = 12;
	    [Bindable]private var navPage:uint = 1;
	    [Bindable]private var navSize:uint = 10;
	    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
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
         * Initalize the bank popup container
         */
		public override function initPopup():void {
			if(receiveCtxItems != null) {
				var str:String = null;
				for(var i:int = 0; i<receiveCtxItems.length; i++) {
					var itemObject:HiddenObject = null;
					var itemName:String = null;
					//var mp:String = null;
					
					itemObject = HiddenObject (receiveCtxItems.getItemAt(i));
                	itemName = itemObject.m_propertyName;
                	
                	if(itemName == 'dispatchFlag') {
                		mapping = "ncm/cashManagementQueryDispatch.action";
                		str = "changed";
                	}
				}
				if(str != null) {
					receiveCtxItems.removeItemAt(receiveCtxItems.length-1);
				}
				//XenosAlert.info("*** "+mapping);
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
			  //XenosAlert.info("Hello: "+rs);
			  if(rs.child("Errors") != null && rs.child("Errors").length()>0){
			  	// i.e. Must be error, display it .
                var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list 			 	
	 	        for each ( var error:XML in rs.Errors.error ) {
					errorInfoList.addItem(error.toString());
		        }
	 	        errPage.showError(errorInfoList);//Display the error	 	         
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
        private function populateReturnContext(strBankCode:String,strBankName:String,strAccountNo:String):void {
            
            var bankCodeArray:Array = new Array(1);
            bankCodeArray[0] = strBankCode;
            
            var bankNameArray:Array = new Array(1);
            bankNameArray[0] = strBankName;
            
            var accountNoArray:Array = new Array(1);
            accountNoArray[0] = strAccountNo;
            
            returnContextItems.addItem(new HiddenObject("returnBankCode",bankCodeArray));
            returnContextItems.addItem(new HiddenObject("returnBankName",bankNameArray));
            returnContextItems.addItem(new HiddenObject("returnAccountNo",accountNoArray));
        }