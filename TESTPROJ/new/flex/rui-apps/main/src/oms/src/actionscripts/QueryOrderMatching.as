// ActionScript file

/**
 * Please Note: In every case i.e FORCE MATCH, CXL FORCE MATCH , IGNORE and CXL IGNORE 
 * the execution update date and/or the order update date is being sent along with the request
 * to check for concurrency access.
 * 
 * Since the query and matching part are associated with different action forms hence this approach has been taken
 * more over there is no detail/user confirm/system confirm page for this UI .
 * 
 */ 
		import com.nri.rui.core.Globals;
		import com.nri.rui.core.controls.CustomizeSortOrder;
		import com.nri.rui.core.controls.XenosAlert;
		import com.nri.rui.core.controls.XenosQuery;
		import com.nri.rui.core.startup.XenosApplication;
		import com.nri.rui.core.utils.HiddenObject;
		import com.nri.rui.core.utils.ProcessResultUtil;
		import com.nri.rui.core.utils.XenosStringUtils;
		import com.nri.rui.oms.validator.OrderMatchingQueryValidator;
		
		import mx.collections.ArrayCollection;
		import mx.controls.AdvancedDataGrid;
		import mx.controls.Alert;
		import mx.events.AdvancedDataGridEvent;
		import mx.events.CloseEvent;
		import mx.events.ResourceEvent;
		import mx.managers.PopUpManager;
		import mx.rpc.events.ResultEvent;

		 //Items returning through context - Non display objects for accountPopup
		[Bindable] public var returnContextItem:ArrayCollection = new ArrayCollection();
		[Bindable]private var mode : String = "query";
		[Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
		[Bindable]private var queryResult:ArrayCollection= new ArrayCollection();
		[Bindable]private var rs:XML = new XML();
		[Bindable]public var conformSelectedResults : ArrayCollection = new ArrayCollection();
		[Bindable]public var selectifAny:Boolean=false;
		[Bindable]private var confirmResult:ArrayCollection= new ArrayCollection();
		public var rowNum : ArrayCollection=new ArrayCollection();
    	private var keylist:ArrayCollection = new ArrayCollection();
		private var  csd:CustomizeSortOrder=null;    
		private var sortFieldArray:Array =new Array();
		private var sortFieldDataSet:Array =new Array();
		private var sortFieldSelectedItem:Array =new Array();
		private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
		private var operationMode:String = "";
		private var operationType:String = "";
		private var tempArray : Array = new Array();
		
		
		/*Used for FORCE MATCH of UNMATCH AND UNPAIRED records*/
		public var  executionStatusUnmatch : ArrayCollection=new ArrayCollection();
		public var  executionStatusUnpaired : ArrayCollection=new ArrayCollection();
		public var  matchPkList : ArrayCollection=new ArrayCollection();
		public var  orderUpdateDateForUnmatch : ArrayCollection=new ArrayCollection();
		public var  executionUpdateDateForUnmatch : ArrayCollection=new ArrayCollection();
		public var  executionUpdateDateForUnpaired : ArrayCollection=new ArrayCollection();
		public var  executionPkList : ArrayCollection=new ArrayCollection();
		public var  matchStatusForUnmatch : ArrayCollection=new ArrayCollection();
		public var  matchStatusForUnPaired : ArrayCollection=new ArrayCollection();
		
		/* Used for CXL Force Match*/
		public var  cxlForceMatchPkList : ArrayCollection=new ArrayCollection();
		public var  orderUpdateDateForCxlForceMatch : ArrayCollection=new ArrayCollection();
		public var  executionUpdateDateForCxlForceMatch : ArrayCollection=new ArrayCollection();
		
		/* Used for Ignore*/
		public var  ignoreList : ArrayCollection=new ArrayCollection();
		public var  matchStatusForIgnore : ArrayCollection=new ArrayCollection();
		public var  orderUpdateDateForIgnore : ArrayCollection=new ArrayCollection();
		public var  executionUpdateDateForIgnore : ArrayCollection=new ArrayCollection();
		
		/* Used for Cxl Ignore*/
		public var  cxlIgnoreList : ArrayCollection=new ArrayCollection();
		public var  orderUpdateDateForCxlIgnore : ArrayCollection=new ArrayCollection();
		public var  executionUpdateDateForCxlIgnore : ArrayCollection=new ArrayCollection();
		
		/* Used for Unpaired Order Ignore*/
		public var  unpairedOrderList : ArrayCollection=new ArrayCollection();
		
		
		
		/**
    	 * Clears all the previous values hold by the lists and vairables
    	 */ 
    	public function clearAll():void{
    		operationMode = "";
    		matchPkList.removeAll();
    		matchStatusForUnmatch.removeAll();
    		executionPkList.removeAll();
    		matchStatusForUnPaired.removeAll();
    		cxlForceMatchPkList.removeAll();
    		ignoreList.removeAll();
    		cxlIgnoreList.removeAll();
    		matchStatusForIgnore.removeAll();
    		unpairedOrderList.removeAll();
    		orderUpdateDateForUnmatch.removeAll();
    		executionUpdateDateForUnmatch.removeAll();
    		executionUpdateDateForUnpaired.removeAll();
    		orderUpdateDateForCxlForceMatch.removeAll();
    		executionUpdateDateForCxlForceMatch.removeAll();
    		orderUpdateDateForIgnore.removeAll();
    		executionUpdateDateForIgnore.removeAll();
    		orderUpdateDateForCxlIgnore.removeAll();
    		executionUpdateDateForCxlIgnore.removeAll();
    		executionStatusUnmatch.removeAll();
    		executionStatusUnpaired.removeAll();
    		rowNum.removeAll();
    	}	
	    
    	/**
    	 * Checks the mode of operation
    	 * invoked at creation complete of the Page
    	 */ 
		public function loadAll():void{
           parseUrlString();
           super.setXenosQueryControl(new XenosQuery());
            if(this.mode == 'query'){
           	   	 this.dispatchEvent(new Event('queryInit'));
           	 }
           	 else{
           	 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.mode'));
           	 }
        }
        /**
         * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
         * 
         */ 
        public function parseUrlString():void {
            try {
                // Remove everything before the question mark, including
                // the question mark.
                var myPattern:RegExp = /.*\?/; 
                var s:String = this.loaderInfo.url.toString();
                //XenosAlert.info("Load Url : "+ this.loaderInfo.url.toString());
                s = s.replace(myPattern, "");
                // Create an Array of name=value Strings.
                var params:Array = s.split(Globals.AND_SIGN); 
                 // Print the params that are in the Array.
                var keyStr:String;
                var valueStr:String;
                var paramObj:Object = params;
              
                // Set the values of the salutation.
                if(params != null){
                    for (var i:int = 0; i < params.length; i++) {
                        var tempA:Array = params[i].split("=");  
                        if (tempA[0] == "mode") {
                            //XenosAlert.info("movArray param = " + tempA[1]);
                            mode = tempA[1];
                           // Alert.show("Mode :: " + mode);
                        }else if(tempA[0] == "fundInstrParticipantPk"){
                          //  this.fundInstrParticipantPk = tempA[1];
                        } 
                    }                    	
                }else{
                	mode = "entry";
                }                 

            } catch (e:Error) {
                trace(e);
            }               
        }
     	
     	/**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
        private function populateInvActContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing act type                
            var actTypeArray:Array = new Array(1);
                actTypeArray[0]="T|B";
            myContextList.addItem(new HiddenObject("actTypeContext",actTypeArray));    
                      
            //passing counter party type                
            var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="BROKER";
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
            return myContextList;
        }
        
         /**
     	  * Formatting amount
     	  */
   /*   	private function amountHandler():void{
        
        var vResult:ValidationResultEvent;
        var tmpStr:String = amount.text;
        vResult = numVal.validate();
        
        if (vResult.type==ValidationResultEvent.VALID) {
            amount.text=numberFormatter.format(amount.text);            
        }else{
        	XenosAlert.error("Invalid Ordered Amount in JPY specified "); 
            amount.text = "";           
        }
       } */
       
       /**
       * Initial execute of the query page
       */ 
       override public function preQueryInit():void{
	        var rndNo:Number= Math.random();
	  		super.getInitHttpService().url = "oms/orderMatchingQuery.action?method=initialExecute&mode="+mode+"&rnd=" + rndNo;        	
        }
        
        /**
        * Result handler of the initial execute
        */ 
        override public function preQueryResultInit():Object{
        	//var keylist:ArrayCollection = new ArrayCollection(); 
        	addCommonKeys();   	
	    	//keylist.addItem("statusList.item");	    	
	    	return keylist;        	
        }
        
        /**
        * Fields added to the key list for the display of default value
        */ 
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();      	
	    	keylist.addItem("buySellFlagValues.item");
	    	keylist.addItem("officeIdValues.officeId");
	    	keylist.addItem("tradeDateFrom");
	    	keylist.addItem("sortFieldList1.item");	
	    	keylist.addItem("sortFieldList2.item");	
	    	keylist.addItem("sortFieldList3.item");
	    	keylist.addItem("Errors.error");
	    	keylist.addItem("tradeDateTo");
	    	keylist.addItem("sortFieldList4.item");
	    	keylist.addItem("sortFieldList5.item");
	    	keylist.addItem("numericStatusValues.item");  	
	    	keylist.addItem("tStarSendStatusValues.item");
        }
        
        /**
        * Displays the default fields in the UI . Also checks for errors.
        */ 
        override public function postQueryResultInit(mapObj:Object):void{
        	if(!checkError(mapObj))
        		commonInit(mapObj);
        }
        
        /**
        * Checks for errors and displays the same if any.
        */ 
        private function checkError(mapObj:Object):Boolean{
    		if(mapObj["Errors.error"] != null){
	    		if(mapObj["Errors.error"].toString().length > 0){
	    		  errPage.showError(mapObj["Errors.error"]);
	    		  return true;
	    		}		    			
    		}
    		else{      	
				errPage.clearError(super.getInitResultEvent());
        	}
        	return false;
        }
        
        /**
        * Diplays the common fields.
        */ 
        private function commonInit(mapObj:Object):void{
        	
        	var tempColl: ArrayCollection = new ArrayCollection();
        	var sortField1Default:String = "trade_date";
        	var sortField2Default:String = "value_date";
        	var sortField3Default:String = "executing_party";
        	var sortField4Default:String = "fund_code";
        	var sortField5Default:String = "instrument_code";
        	
        	var i:int = 0;
        	var selIndx:int = 0;
        	
        	 
           	app.submitButtonInstance = submit;
           	fundPopUp.fundCode.setFocus();
           	this.valuedateFrom.text = "";
           	this.valuedateTo.text = "";
           	this.orderRefNo.text = "";
           	this.executionRefNo.text = "";
           	//this.inventoryAccountNo.accountNo.text ="";
           	this.fundPopUp.fundCode.text = "";
           	//this.amount.text ="";
           	this.security.instrumentId.text = "";
           	this.trddateFrom.text ="";
           	this.trddateTo.text = "";
           	this.valuedateFrom.text = "";
           	this.valuedateTo.text = "";
           	//this.bicCode.text ="";
           	this.bicCode.accountNo.text = "";
           	this.ccyBox.ccyText.text = "";
           	this.entrydateFrom.text = "";
           	this.entrydateTo.text = "";
           	this.lastentrydateFrom.text = "";
           	this.lastentrydateTo.text = "";
           	this.senderRefNoMt502.text="";
           	this.senderRefNoMt515.text="";
           	msAll.selected = true;
           	sNormal.selected = true;
            this.rowNum.removeAll();
           	
    		errPage.clearError(super.getInitResultEvent());
    		this.queryResult.removeAll();
	        //errPage.removeError();
    		
	    	var index:int=-1;
	    	/*Buy Sell Flag*/
	    	var initcol:ArrayCollection = new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	for each(var item:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
		    	
		    buySell.dataProvider = initcol ;
		    
		    /*Numeric Status*/
		    initcol = new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	for each(var item10:Object in (mapObj[keylist.getItemAt(10)] as ArrayCollection)){
	    		initcol.addItem(item10);
	    	}
		    	
		    numericStatus.dataProvider = initcol ;
		    
		    /*T Star Send Status Status*/
		    initcol = new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	for each(var item11:Object in (mapObj[keylist.getItemAt(11)] as ArrayCollection)){
	    		initcol.addItem(item11);
	    	}
		    	
		    tStarSendStatus.dataProvider = initcol ;
	    	
	    	/*Office Id*/
	    	initcol=new ArrayCollection();
	    	initcol.addItem("");
	    	index=0;
	    	for each(var item1:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
	    		initcol.addItem(item1);
	    	}
	    	officeId.dataProvider = initcol;
	    	
	    	
	    	this.trddateFrom.text = mapObj[keylist.getItemAt(2)].toString();
	    	this.trddateTo.text = mapObj[keylist.getItemAt(7)].toString();
	    	
	    	
	    	//----------Start of population of SortField1----------//
	        
	        if(null != mapObj[keylist.getItemAt(3)]){
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
        		tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
	        		for each(var item4:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
		    			initcol.addItem(item4);
		    		}
	        	}else {
	        		initcol.addItem(mapObj[keylist.getItemAt(3)]);
	        	}
		        for(i = 0; i<initcol.length; i++) {
		        	//Get the default value object's index
	                if(XenosStringUtils.equals((initcol[i].value),sortField1Default)){                    
	                    selIndx = i;
	                }
		           tempColl.addItem(initcol[i]);            
	    	}
		        
	    		sortFieldArray[0]=sortField1;
		        sortFieldDataSet[0]=tempColl;
		        //Set the default value object
		        sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
	        
	        } else {
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('oms.error.initialize.sortfield1'));
	    	}
	        
	        //---------------End of population of SortField1-----------------------//
	        
	        //--------Start of population of sortField2---------//
	        
	        if(null != mapObj[keylist.getItemAt(4)]){
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
	        	tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	
	        	if(mapObj[keylist.getItemAt(4)] is ArrayCollection){
	        		for each(var item5:Object in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
		    			initcol.addItem(item5);
		    		}
	    	}else{
	        		initcol.addItem(mapObj[keylist.getItemAt(4)]);
	        	}
		        for(i = 0; i<initcol.length; i++) {
		        	//Get the default value object's index
	                if(XenosStringUtils.equals((initcol[i].value),sortField2Default)){                    
	                    selIndx = i;
	                }
		           tempColl.addItem(initcol[i]);            
		        }
		        
		        sortFieldArray[1]=sortField2;
		        sortFieldDataSet[1]=tempColl;
		        //Set the default value object
		        sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);
		        
	        } else {
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('oms.error.initialize.sortfield2'));
      		}
	    	
	         //--------End of population of sortField2---------// 
	    	
	         //--------Start of population of sortField3---------//
	        
	        if(null != mapObj[keylist.getItemAt(5)]){
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
	        	tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	
	        	if(mapObj[keylist.getItemAt(5)] is ArrayCollection){
	        		for each(var item6:Object in (mapObj[keylist.getItemAt(5)] as ArrayCollection)){
		    			initcol.addItem(item6);
		    		}
	        	}else{
	        		initcol.addItem(mapObj[keylist.getItemAt(5)]);
	        	}
		        for(i = 0; i<initcol.length; i++) {
		        	//Get the default value object's index
	                if(XenosStringUtils.equals((initcol[i].value),sortField3Default)){                    
	                    selIndx = i;
	                }
		        	
		           tempColl.addItem(initcol[i]);            
	    	}
	        
		        sortFieldArray[2]=sortField3;
		        sortFieldDataSet[2]=tempColl;
		        //Set the default value object
		        sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx+1);
		        
	        } else {
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('oms.error.initialize.sortfield3'));
	        } 
	        
	         //--------End of population of sortField3---------//
	         
	          //--------Start of population of sortField4---------//
	        
	        if(null != mapObj[keylist.getItemAt(8)]){
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
	        	tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	
	        	if(mapObj[keylist.getItemAt(8)] is ArrayCollection){
	        		for each(var item8:Object in (mapObj[keylist.getItemAt(8)] as ArrayCollection)){
		    			initcol.addItem(item8);
		    		}
	    	}else{
	        		initcol.addItem(mapObj[keylist.getItemAt(8)]);
	        	}
		        for(i = 0; i<initcol.length; i++) {
		        	//Get the default value object's index
	                if(XenosStringUtils.equals((initcol[i].value),sortField4Default)){                    
	                    selIndx = i;
	                }
		           tempColl.addItem(initcol[i]);            
		        }
		        
		        sortFieldArray[3]=sortField4;
		        sortFieldDataSet[3]=tempColl;
		        //Set the default value object
		        sortFieldSelectedItem[3] = tempColl.getItemAt(selIndx+1);
		        
	        } else {
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('oms.error.initialize.sortfield4'));
      		}
	    	
	         //--------End of population of sortField4---------// 
	         
	         //--------Start of population of sortField5---------//
	        
	        if(null != mapObj[keylist.getItemAt(9)]){
	        	initcol = new ArrayCollection();
	        	tempColl = new ArrayCollection();
	        	tempColl.addItem({label:" ", value: " "});
	        	selIndx = 0;
	        	
	        	if(mapObj[keylist.getItemAt(9)] is ArrayCollection){
	        		for each(var item9:Object in (mapObj[keylist.getItemAt(9)] as ArrayCollection)){
		    			initcol.addItem(item9);
		    		}
	    	}else{
	        		initcol.addItem(mapObj[keylist.getItemAt(9)]);
	        	}
		        for(i = 0; i<initcol.length; i++) {
		        	//Get the default value object's index
	                if(XenosStringUtils.equals((initcol[i].value),sortField5Default)){                    
	                    selIndx = i;
	                }
		           tempColl.addItem(initcol[i]);            
		        }
		        
		        sortFieldArray[4]=sortField5;
		        sortFieldDataSet[4]=tempColl;
		        //Set the default value object
		        sortFieldSelectedItem[4] = tempColl.getItemAt(selIndx+1);
		        
	        } else {
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('oms.error.initialize.sortfield5'));
      		}
	    	
	         //--------End of population of sortField5---------// 
	         
	         
	        //-------------Initializing the sortfields-------------//
			csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
        	csd.init();
        }
        
        /**
        * Mathod to reset the Page
        */ 
        override public function preResetQuery():void{
		       var rndNo:Number= Math.random();
		  	   super.getResetHttpService().url = "oms/orderMatchingQuery.action?method=resetQuery&mode="+mode+"&rnd=" + rndNo;        	
        }
        
        /**
	     * Method for updating the other two sortfields after any change in the sortfield1
         */
	     private function sortOrder1Update():void{
	     	 csd.update(sortField1.selectedItem, 0);
	     }
	     
	     /**
	      * Method for updating the other two sortfields after any change in the sortfield2
	      */
	     private function sortOrder2Update():void{     	
	     	csd.update(sortField2.selectedItem,1);
    	 }
    	
	     /**
	     * Method for updating the other two sortfields after any change in the sortfield3
         */
	     private function sortOrder3Update():void{
	     	 csd.update(sortField3.selectedItem, 2);
	     }
	     
	     /**
	     * Method for updating the other two sortfields after any change in the sortfield4
         */
	     private function sortOrder4Update():void{
	     	 csd.update(sortField4.selectedItem, 3);
	     	 
	     }
	    
	    /**
	 	 * This method should be called on creationComplete of the datagrid 
	 	 */ 
	 	private function bindDataGrid():void {
			qh.dgrid = resultSummary;
		}
		 /**
	 	 * This method should be called on creationComplete of the datagrid 
	 	 */ 
	 	/* private function bindDataGrid1():void {
			qh.dgrid = resultSummary1;
		} */
		/**
 		*  datagrid header release event handler to handle datagridcolumn sorting
 		*/
		public function dataGrid_headerRelease(evt:AdvancedDataGridEvent):void {				
			//sortUtil.clickedColumn=evt.dataField;
			var dg:AdvancedDataGrid = AdvancedDataGrid(evt.currentTarget);
            sortUtil.clickedColumn = dg.columns[evt.columnIndex];	
            sortUtil.dataGridRef = resultSummary;
		}
	  
    	 private function dispatchPrintEvent():void{
              this.dispatchEvent(new Event("print"));
          }  
          private function dispatchPdfEvent():void{
             // XenosAlert.info("dispatchEvent pdf");
              this.dispatchEvent(new Event("pdf"));
          }  
          private function dispatchXlsEvent():void{
              this.dispatchEvent(new Event("xls"));
          }   
          private function dispatchNextEvent():void{
              this.dispatchEvent(new Event("next"));
          }  
          private function dispatchPrevEvent():void{
              this.dispatchEvent(new Event("prev"));
          }      
    	/**
    	 * 
    	 */ 
    	override public function preQuery():void{
			setValidator();
            qh.resetPageNo();	
            super.getSubmitQueryHttpService().url = "oms/orderMatchingQuery.action?";  
            super.getSubmitQueryHttpService().request  =populateRequestParams();
            super.getSubmitQueryHttpService().method = "POST";
           
		}
		/**
		 * 
		 */ 
        private function setValidator():void{
			
    	    var validateModel:Object={
                            orderMatchingQuery:{                                 
                                 tradeDateFrom:this.trddateFrom.text,
                                 tradeDateTo:this.trddateTo.text,
                                 valueDateFrom:this.valuedateFrom.text,
                                 valueDateTo:this.valuedateTo.text,
                                 entrydateFrom:this.entrydateFrom.text,
                                 entrydateTo:this.entrydateTo.text,
                                 lastentrydateFrom:this.lastentrydateFrom.text,
                                 lastentrydateTo:this.lastentrydateTo.text
                            }
                           }; 
             super._validator = new OrderMatchingQueryValidator();
             super._validator.source = validateModel ;
             super._validator.property = "orderMatchingQuery";
		}
		/**
    	 * This method will populate the request parameters for the
    	 * submitQuery call and bind the parameters with the HTTPService
   	     * object.
    	 */
   		 private function populateRequestParams():Object {
    	
    		var reqObj : Object = new Object();
    		
    		reqObj.orderRefNo 	  	  = this.orderRefNo.text;
    		reqObj.officeId   	  	  = this.officeId.selectedItem != null ? this.officeId.selectedItem : "" ;
    		reqObj.executionRefNo 	  = this.executionRefNo.text;
    		//reqObj.fundAccountNo  	  = this.inventoryAccountNo.accountNo.text;
    		reqObj.fundCode 	  	  = this.fundPopUp.fundCode.text;
    		//reqObj.amount		  	  = this.amount.text;
    		reqObj.buySellSelectedValue = this.buySell.selectedItem != null ? this.buySell.selectedItem.value : "" ;
    		reqObj.securityCode	  	  = this.security.instrumentId.text;
    		reqObj.tradeDateFrom  	  = this.trddateFrom.text;
    		reqObj.tradeDateTo	 	  = this.trddateTo.text;
    		reqObj.valueDateFrom  	  = this.valuedateFrom.text;
    		reqObj.valueDateTo	  	  = this.valuedateTo.text;
    		reqObj.bicCodeOfExecutingParty = this.bicCode.accountNo.text;
    		reqObj.ccy			  	  = this.ccyBox.ccyText.text;
    	
    		reqObj.teeStarSendSelectedValue = 	this.tStarSendStatus.selectedItem != null ? this.tStarSendStatus.selectedItem.value	: "" ;
    		
    		/*
    			Values of Numeric Status :
    			Selected Value		Value Passed to Server
    			
    			'Error'				Y
    			Blank				N
    			Nothing Selected	""
    		*/
    		
    		reqObj.numericStatusSelectedValue = this.numericStatus.selectedItem != null ? 
    											(XenosStringUtils.isBlank(this.numericStatus.selectedItem.value)) ? "":
    		 									this.numericStatus.selectedItem.value : "" ;
    		reqObj.entryDateFrom  	  = this.entrydateFrom.text;
    		reqObj.entryDateTo	  	  = this.entrydateTo.text;
    		reqObj.lastEntryDateFrom  = this.lastentrydateFrom.text;
    		reqObj.lastEntryDateTo	  = this.lastentrydateTo.text;
    		reqObj.senderRefNoMT502   = this.senderRefNoMt502.text;
    		reqObj.senderRefNoMT515   = this.senderRefNoMt515.text;
    		reqObj.matchStatus		  = this.matchStatusRadio.selectedValue;
    		reqObj.status			  = this.statusRadio.selectedValue;
    		
    		reqObj.sortField1 		  = this.sortField1.selectedItem != null ? this.sortField1.selectedItem.value : "";
        	reqObj.sortField2 		  = this.sortField2.selectedItem != null ? this.sortField2.selectedItem.value : "";
        	reqObj.sortField3 		  = this.sortField3.selectedItem != null ? this.sortField3.selectedItem.value : "";
        	reqObj.sortField4 		  = this.sortField4.selectedItem != null ? this.sortField4.selectedItem.value : "";
    		reqObj.sortField5 		  = this.sortField5.selectedItem != null ? this.sortField5.selectedItem.value : "";
    		
    		reqObj.method= "submitQuery";
    		return reqObj;
    	}
    	
    	/**
    	 * 
    	 */ 
    	private function changeCurrentState():void{
				currentState = "result";
	 	}
    	/**
    	 * 
    	 */ 
		override public function postQueryResultHandler(mapObj:Object):void{
    		if(!commonResult(mapObj)){
    			errPage.removeError();
    			errPage1.removeError();
    		}
    		clearAll();
    		
    	}
    	
    	
    	/**
    	 * 
    	 */ 
    	private function commonResult(mapObj:Object):Boolean{    	
    	var result:String = "";
    	if(mapObj!=null){   
    		//XenosAlert.info("mapObj : "+mapObj.toString()); 		
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		//result = mapObj["errorMsg"] .toString();
	    		queryResult.removeAll();
	    		errPage.showError(mapObj["errorMsg"]);
	    		return true;
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    	   errPage.clearError(super.getSubmitQueryResultEvent());
               queryResult.removeAll();
               this.rowNum.removeAll();
               queryResult=mapObj["row"];
			   changeCurrentState();
	           qh.setOnResultVisibility();
	           //qh.print.enabled = false;
	           qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
	           qh.PopulateDefaultVisibleColumns();
	    	}else{
	    		errPage.removeError();
	    		queryResult.removeAll();
	    		currentState = "";
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}   	
    	}
    	return false;
    	//XenosAlert.info(result);
    } 
    	/**
    	 * 
    	 */
        override    public function preNext():Object{
    	   var reqObj : Object = new Object();
    	   reqObj.method = "doNext";
    	   return reqObj;
         }
         /**
         * 
         */ 	
    	override public function prePrevious():Object{
    	   
    	    var reqObj : Object = new Object();
    	    reqObj.method = "doPrevious";
    	    return reqObj;
          }
          
        /**
        * Checks if no record has been selected in the Force Match screen.
        */ 
        public function ifEmptyAll():Boolean{
			if(cxlForceMatchPkList.length == 0 && ignoreList.length == 0
				&& cxlIgnoreList.length == 0 && matchPkList.length == 0 
				&& executionPkList.length == 0 && unpairedOrderList.length == 0 ){
					XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('oms.order.matching.select.one'));
					return true;
				}
			return false;	
		 }
		 
    	 /**
    	  * This method handles the UNMATCH and UNPAIRED executions records for 
    	  * FORCE MATCH.
    	  * 
    	  * UNMATCH    record : Record with MATCH_STATUS = UNMATCH
    	  * UNPAIRED execution: Record with MATCH_STATUS = UNPAIRED and ORDER_PK = NULL and EXECUTION_PK != NULL
    	  */ 
    	public function saveRecordForForceMatch(data:Object, selectedFlag:Boolean):void {
    		var tempMatchPkList:Array = new Array();
    		var tempExePkList:Array = new Array();
    		
    		var tempMatchStatusList1:Array = new Array();
    		var tempMatchStatusList2:Array = new Array();
    		
    		var tempOrderUpdateList1:Array = new Array();
    		var tempExecutionUpdateList1:Array = new Array();
    		var tempExecutionUpdateList2:Array = new Array();
    		var tempExeStatusUnmatch:Array = new Array();
    		var tempExeStatusUnpaired:Array = new Array();
    		
    		var i:int = 0;
    		
    		if(selectedFlag){ /* This if block handles selected = true functionality*/
    			
    			if(!XenosStringUtils.isBlank(data.matchPk)){
    				//XenosAlert.info("adding match pk "+data.matchPk);
    				matchPkList.addItem(data.matchPk);
    				orderUpdateDateForUnmatch.addItem(data.orderUpdateDate);
    				executionUpdateDateForUnmatch.addItem(data.executionUpdateDate);
    				matchStatusForUnmatch.addItem(data.matchStatus);
    				executionStatusUnmatch.addItem(data.executionStatus);//execution status for unmatch
    			}
    			
    			else if(XenosStringUtils.isBlank(data.orderPk) && !XenosStringUtils.isBlank(data.executionPk)){ 
    				//XenosAlert.info("adding execution pk "+data.executionPk);
    				executionPkList.addItem(data.executionPk);
    				executionUpdateDateForUnpaired.addItem(data.executionUpdateDate);
    				matchStatusForUnPaired.addItem(data.matchStatus);
    				executionStatusUnpaired.addItem(data.executionStatus);//execution status for unpaired
    			}
    		}else{/* This if block handles Selected = false functionality*/
    				if(!XenosStringUtils.isBlank(data.matchPk)){
    					//XenosAlert.info("removing matchpk:"+data.matchPk);
    					tempMatchPkList   = matchPkList.toArray(); // storing the match Pks
    					tempMatchStatusList1 = matchStatusForUnmatch.toArray();// storing the match status
    					tempOrderUpdateList1 = orderUpdateDateForUnmatch.toArray();// order update date
    					tempExecutionUpdateList1 = executionUpdateDateForUnmatch.toArray();//execution update date
    					tempExeStatusUnmatch = executionStatusUnmatch.toArray();//
    					
    	    			matchPkList.removeAll();
    	    			matchStatusForUnmatch.removeAll();
    	    			orderUpdateDateForUnmatch.removeAll();
    	    			executionUpdateDateForUnmatch.removeAll();
    	    			executionStatusUnmatch.removeAll();
    	    			
    	    			for(i=0; i < tempMatchPkList.length; i++){
	    					if(tempMatchPkList[i] != data.matchPk){
	    			    		matchPkList.addItem(tempMatchPkList[i]);
	    			    		matchStatusForUnmatch.addItem(tempMatchStatusList1[i]);
	    			    		orderUpdateDateForUnmatch.addItem(tempOrderUpdateList1[i]);
	    			    		executionUpdateDateForUnmatch.addItem(tempExecutionUpdateList1[i]);
	    			    		executionStatusUnmatch.addItem(tempExeStatusUnmatch[i]);
    			    		
    						}
    			  		}
    			 	}
    			 	else if(XenosStringUtils.isBlank(data.orderPk) && !XenosStringUtils.isBlank(data.executionPk)){
    			 		//XenosAlert.info("removing exe pk:"+data.executionPk);
    			 		tempExePkList   = executionPkList.toArray(); // storing the execution Pks
    					tempMatchStatusList2 = matchStatusForUnPaired.toArray();// storing the match status
    					tempExecutionUpdateList2 = executionUpdateDateForUnpaired.toArray();//storing execution update date for unpaired execution
    					tempExeStatusUnpaired = executionStatusUnpaired.toArray();
    					
    	    			executionPkList.removeAll();
    	    			matchStatusForUnPaired.removeAll();
    	    			executionUpdateDateForUnpaired.removeAll();
    	    			executionStatusUnpaired.removeAll();
    	    			
	    	    		for(i=0; i < tempExePkList.length; i++){
		    				if(tempExePkList[i] != data.executionPk){	
		    			    	executionPkList.addItem(tempExePkList[i]);
		    			    	matchStatusForUnPaired.addItem(tempMatchStatusList2[i]);
		    			    	executionUpdateDateForUnpaired.addItem(tempExecutionUpdateList2[i]);
		    			    	executionStatusUnpaired.addItem(tempExeStatusUnpaired[i]);
	    					}
	    			  }
    		 	}
    		}
		
		}
		/**
    	  * This method handles the FORCEMATCH records for Cxl Force Match
    	  * 
    	  * FORCEMATCH can be done only via the UI and this method handels the cancellation of 
    	  * the FORCEMATCH records
    	  */ 
    	public function saveRecordForCxlForceMatch(data:Object, selectedFlag:Boolean):void {
    		var tempMatchPkList:Array = new Array();
    		var tempExeUpdDate:Array = new Array();
    		var tempOrdUpdDate:Array = new Array();
    		
    		var i:int = 0;
    		
    		if(selectedFlag){/* This if block handles selected = true functionality*/
    				cxlForceMatchPkList.addItem(data.matchPk);
    				orderUpdateDateForCxlForceMatch.addItem(data.orderUpdateDate);
    				executionUpdateDateForCxlForceMatch.addItem(data.executionUpdateDate);
    				
    		}else{/* This if block handles Selected = false functionality*/
					tempMatchPkList   = cxlForceMatchPkList.toArray(); // storing the match Pks
					tempOrdUpdDate	  = orderUpdateDateForCxlForceMatch.toArray();
					tempExeUpdDate	  = executionUpdateDateForCxlForceMatch.toArray();
					
	    			cxlForceMatchPkList.removeAll();
	    			orderUpdateDateForCxlForceMatch.removeAll();
	    			executionUpdateDateForCxlForceMatch.removeAll();
	    			
	    			for(i=0; i < tempMatchPkList.length; i++){
					if(tempMatchPkList[i] != data.matchPk){
			    		cxlForceMatchPkList.addItem(tempMatchPkList[i]);
			    		orderUpdateDateForCxlForceMatch.addItem(tempOrdUpdDate[i]);
			    		executionUpdateDateForCxlForceMatch.addItem(tempExeUpdDate[i]);
					}
			  	}
    		}
		}
			
			
		/**
    	 * Confirm Handeler for Force Match
    	 */    
		private function confirmHandlerForForceMatch(event:CloseEvent):void {
	     if (event.detail == Alert.YES) {
	     		var i:int = 0;
	     		var reqObj : Object = new Object();
	     		reqObj.method = "doForceMatch";
	     		
	     		var matchPkArray:Array = new Array();
	     		var executionPkArray:Array = new Array();
	     		var exeUpdateDateArray:Array =  new Array();
	     		var exeUpdateDateArrayForUnmatch:Array =  new Array();
	     		var ordUpdateDateArrayForUnmatch:Array =  new Array();
	     		
    			if(executionPkList.length > 0 ){
    				for(i=0; i<executionPkList.length; i++){
    				executionPkArray[i] = executionPkList[i];
    				exeUpdateDateArray[i] = executionUpdateDateForUnpaired[i];
    				}
    				reqObj.selectedExecutionPkArray = null;
	     			reqObj.selectedExecutionPkArray = executionPkArray;
	     			reqObj.exeUpdDateArrayForUnpaired = null;
	     			reqObj.exeUpdDateArrayForUnpaired = exeUpdateDateArray;
    			}
    			
    		 	if(matchPkList.length > 0){
    				for(i=0; i<matchPkList.length; i++){
    					matchPkArray[i] = matchPkList[i];
    					exeUpdateDateArrayForUnmatch[i] = executionUpdateDateForUnmatch[i];
    					ordUpdateDateArrayForUnmatch[i] = orderUpdateDateForUnmatch[i];
    				}
    				reqObj.selectedMatchPkArray = null;
	     			reqObj.selectedMatchPkArray = matchPkArray;
	     			reqObj.exeUpdDateArrayForUnmatch = null;
	     			reqObj.exeUpdDateArrayForUnmatch = exeUpdateDateArrayForUnmatch;
	     			reqObj.ordUpdDateArrayForUnmatch = null;
	     			reqObj.ordUpdDateArrayForUnmatch = ordUpdateDateArrayForUnmatch;
	     		} 
	     		
	     		operationMode = "Force Match";
	     		
	     		forceMatchRequestAction.url = forceMatchRequestAction.url + "&rnd="+Math.random();
	     		forceMatchRequestAction.request = reqObj;
	     		forceMatchRequestAction.send();
	     	} 
		}
		
		private function doSendForForceMatch():void{
			var flag:Boolean = true;
			var tempMatchStatusArray:Array = new Array();
			tempMatchStatusArray = matchStatusForUnmatch.toArray();
			var i:int = 0;
			operationType = "FORCE_MATCH";
			/*Check if no record has been selected*/
			if(ifEmptyAll())
				flag = false;
			
			/*UNMATCH - Check if only NORMAL execution records have been selected for FORCEMATCH*/
			if(flag){
				/*CANCEL Executions for UNMATCH*/
				for(i = 0 ; i < executionStatusUnmatch.length ; i++){
					if(!XenosStringUtils.equals(executionStatusUnmatch[i], Globals.STATUS_NORMAL)){
						flag = false;
						XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('oms.order.matching.select.normal.exe'));
						break;
					}
				}
			}
			
			/*UNPAIRED - Check if only NORMAL execution records have been selected for FORCEMATCH*/
			if(flag){
				/*CANCEL Executions for UNPAIRED*/
				for(i = 0 ; i < executionStatusUnpaired.length ; i++){
					if(!XenosStringUtils.equals(executionStatusUnpaired[i], Globals.STATUS_NORMAL)){
						flag = false;
						XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('oms.order.matching.select.normal.exe'));
						break;
					}
				}
			}
				
			/*Check if record is not UNMATCH or UNPAIRED*/
			if(flag){
				if(matchPkList.length > 0 || executionPkList.length > 0){
					if(cxlForceMatchPkList.length > 0 || ignoreList.length > 0 
						|| cxlIgnoreList.length > 0 || unpairedOrderList.length > 0){
							
						XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('oms.order.matching.select.unpaired.exe'));
					}
					else{
						//XenosAlert.confirm("Are you sure to Force Match the following records ?", confirmHandlerForForceMatch);
						showResult("FORCEMATCH");
					}
				}
				else{
					XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('oms.order.matching.select.unpaired.exe'));
				}
			}
		} 
		
		
	 /**
	 * Force Match Result handler
     */
    	private function onSuccess(event:ResultEvent):void {
        	rs = XML(event.result);
        	if (null != event) {
	            if(rs.child("Errors").length() > 0) {
					var errorInfoList : ArrayCollection = new ArrayCollection();
			 	    for each ( var error:XML in rs.Errors.error ) {
	 			    	errorInfoList.addItem(error.toString());
				    }
			 	    errPage1.showError(errorInfoList);
	            } else {
	                errPage1.removeError();
	              	XenosAlert.info(operationMode+ " Successful !");// operationMode = Force Match/ Cancel Force Match etc
					this.dispatchEvent(new Event('querySubmit'));// refresh the page
	            }
        	} else {
           		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			 	queryResult.removeAll(); // clear previous data if any as there is no result now.
			 	errPage1.removeError(); //clears the errors if any
       		}
    	}
    	
    	/**
    	 * 
    	 */
    	 private function doSendForCxlForceMatch():void{ 
    	 	var flag:Boolean = true;
			var i:int = 0;
			//XenosAlert.info("List of match Pks for CXL :"+cxlForceMatchPkList.toArray().toString());
			
			if(ifEmptyAll())
				flag = false;
				
			if(flag){
				if(cxlForceMatchPkList.length > 0){
					if(matchPkList.length > 0 || executionPkList.length > 0
					 || cxlIgnoreList.length > 0 || unpairedOrderList.length > 0){
					 	
						XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('oms.order.matching.select.forcematch.forcancel'));
						flag = false;
					}else if(ignoreList.length > 0){ // matchStatusForIgnore.length always = ignoreList.length 
						for(i = 0 ;i < matchStatusForIgnore.length ; i++){
							if(!XenosStringUtils.equals("FORCEMATCH", matchStatusForIgnore[i])){
								XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('oms.order.matching.select.forcematch.forcancel'));
								flag = false;
								break;
							} 
						}
					}
					if(flag){
						//XenosAlert.confirm("Are you sure to Cancel the Selected Force Match records ?", confirmHandlerForCxlForceMatch);
						showResult("CXL_FORCEMATCH");
					}
				}
				else{
					XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('oms.order.matching.select.forcematch.forcancel'));
				}
			}
    	 }
				
    	 /**
    	 * Confirm Handeler for Cancel Force Match
    	 */    
		private function confirmHandlerForCxlForceMatch(event:CloseEvent):void {
	     if (event.detail == Alert.YES) {
	     		var i:int = 0;
	     		var reqObj : Object = new Object();
	     		reqObj.method = "doCancelForceMatch";
	     		
	     		var matchPkArray:Array = new Array();
	     		var ordUpdDate:Array = new Array();
	     		var exeUpdDate:Array = new Array();
    			
    			if(cxlForceMatchPkList.length > 0){
    				for(i=0; i<cxlForceMatchPkList.length; i++){
    					matchPkArray[i] = cxlForceMatchPkList[i];
    					ordUpdDate[i]   = orderUpdateDateForCxlForceMatch[i];
    					exeUpdDate[i]   = executionUpdateDateForCxlForceMatch[i];
    				}
    				reqObj.selectedMatchPkArray = null;
	     			reqObj.selectedCxlMatchPkArray = matchPkArray;
	     			reqObj.orderUpdDateForCxlForceMatch = null;
	     			reqObj.orderUpdDateForCxlForceMatch = ordUpdDate;
	     			reqObj.exeUpdDateForCxlForceMatch = null;
	     			reqObj.exeUpdDateForCxlForceMatch = exeUpdDate;
	     		}
	     		
	     		operationMode = "Cancel Force Match";
	     		
	     		forceMatchCxlRequestAction.url = forceMatchCxlRequestAction.url + "&rnd="+Math.random();
	     		forceMatchCxlRequestAction.request = reqObj;
	     		forceMatchCxlRequestAction.send();
	     	} 
		}
		
		/**
    	  * This method IGNOREs the MATCH Records
    	  * Only MATCH records can be IGNOREd and the IGNORE_STATUS is set to 'Y' in the OMS_MATCH_DETAILS table
    	  * 
    	  */ 
    	public function saveRecordForIgnore(data:Object, selectedFlag:Boolean):void {
    		var tempMatchPkList:Array = new Array();
    		var tempMatchStatusList1:Array = new Array();
    		var tempOrdUpdDate:Array = new Array();
    		var tempExeUpdDate:Array = new Array();
    		
    		var i:int = 0;
    		
    		if(selectedFlag){/* This if block handles selected = true functionality*/

    				ignoreList.addItem(data.matchPk);
    				matchStatusForIgnore.addItem(data.matchStatus);
    				orderUpdateDateForIgnore.addItem(data.orderUpdateDate);
    				executionUpdateDateForIgnore.addItem(data.executionUpdateDate);
    		}else{/* This if block handles Selected = false functionality*/
					
					tempMatchPkList   = ignoreList.toArray(); // storing the match Pks
					tempMatchStatusList1 = matchStatusForIgnore.toArray();// storing the match status
					tempOrdUpdDate = orderUpdateDateForIgnore.toArray();
					tempExeUpdDate = executionUpdateDateForIgnore.toArray();
					
    	    		matchStatusForIgnore.removeAll();
	    			ignoreList.removeAll();
	    			executionUpdateDateForIgnore.removeAll();
					orderUpdateDateForIgnore.removeAll();
					
	    			for(i=0; i < tempMatchPkList.length; i++){
					if(tempMatchPkList[i] != data.matchPk){
			    		ignoreList.addItem(tempMatchPkList[i]);
			    		matchStatusForIgnore.addItem(tempMatchStatusList1[i]);
			    		orderUpdateDateForIgnore.addItem(tempOrdUpdDate[i]);
			    		executionUpdateDateForIgnore.addItem(tempExeUpdDate[i]);
					}
			  	}
    		}
		}
		/**
    	 * 
    	 */
    	 private function doSendForIgnore():void{ 
    	 	var flag:Boolean = true;
			var i:int = 0;
			//XenosAlert.info("List of match Pks for Ignore :"+ignoreList.toArray().toString());
			
			if(ifEmptyAll())
				flag = false;
				
			if(flag){
				if(ignoreList.length > 0 || cxlForceMatchPkList.length > 0){//Force Match and Match both can be ignored
					if(matchPkList.length > 0 || executionPkList.length >0 
						|| cxlIgnoreList.length > 0 || unpairedOrderList.length > 0){
						XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('oms.order.matching.select.forcematch.forignore'));
					}
					else{
						//XenosAlert.confirm("Are you sure to Ignore the Selected records ?", confirmHandlerForIgnore);
						showResult("IGNORE");
					}
				}
				else{
					XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('oms.order.matching.select.forcematch.forignore'));
				}
			}
    	 }
    	 
    	 /**
    	 * Confirm Handeler for Ignore
    	 */    
		private function confirmHandlerForIgnore(event:CloseEvent):void {
	     if (event.detail == Alert.YES) {
	     		var i:int = 0;
	     		//var index:int = 0;
	     		var reqObj : Object = new Object();
	     		reqObj.method = "doIgnore";
	     		
	     		var matchPkArray:Array = new Array();
	     		var ordUpdDate:Array = new Array();
    			var exeUpdDate:Array = new Array();
    			
    			if(ignoreList.length > 0){
    				for(i=0; i<ignoreList.length; i++){
    					matchPkArray[i] = ignoreList[i];
    					ordUpdDate[i] = orderUpdateDateForIgnore[i];
    					exeUpdDate[i] =  executionUpdateDateForIgnore[i];
    				}
    				reqObj.selectedMatchPkArray = null;
	     			reqObj.selectedIgnoreMatchPkArray = matchPkArray;
	     			reqObj.orderUpdateDateForIgnore = null;
	     			reqObj.orderUpdateDateForIgnore = ordUpdDate;
	     			reqObj.executionUpdateDateForIgnore = null;
	     			reqObj.executionUpdateDateForIgnore = exeUpdDate;
	     			
	     		}
	     		operationMode = "Ignore";
	     		
	     		forceMatchIgnoreRequestAction.url = forceMatchIgnoreRequestAction.url + "&rnd="+Math.random();
	     		forceMatchIgnoreRequestAction.request = reqObj;
	     		forceMatchIgnoreRequestAction.send();
	     	} 
		}
		/**
    	  * This method Cancels the IGNORE Status of a record
    	  * Only IGNOREd records can be Cancelled and the IGNORE_STATUS is set to 'N' in the 
    	  * OMS_MATCH_DETAILS table
    	  * 
    	  */ 
    	public function saveRecordForCxlIgnore(data:Object, selectedFlag:Boolean):void {
    		var tempMatchPkList:Array = new Array();
    		var tempOrdUpdDate:Array = new Array();
    		var tempExeUpdDate:Array = new Array();
    		var i:int = 0;
    		
    		if(selectedFlag){/* This if block handles selected = true functionality*/
    				cxlIgnoreList.addItem(data.matchPk);
    				orderUpdateDateForCxlIgnore.addItem(data.orderUpdateDate);
    				executionUpdateDateForCxlIgnore.addItem(data.executionUpdateDate);
    		}else{/* This if block handles Selected = false functionality*/
					tempMatchPkList   = cxlIgnoreList.toArray(); // storing the match Pks
					tempOrdUpdDate = orderUpdateDateForCxlIgnore.toArray();
					tempExeUpdDate = executionUpdateDateForCxlIgnore.toArray();
					
					orderUpdateDateForCxlIgnore.removeAll();
					executionUpdateDateForCxlIgnore.removeAll();
	    			cxlIgnoreList.removeAll();
	    			for(i=0; i < tempMatchPkList.length; i++){
					if(tempMatchPkList[i] != data.matchPk){
			    		cxlIgnoreList.addItem(tempMatchPkList[i]);
			    		orderUpdateDateForCxlIgnore.addItem(tempOrdUpdDate[i]);
			    		executionUpdateDateForCxlIgnore.addItem(tempExeUpdDate[i]);
					}
			  	}
    		}
		}
		/**
    	 * 
    	 */
    	 private function doSendForCxlIgnore():void{ 
    	 	var flag:Boolean = true;
			var i:int = 0;
			//XenosAlert.info("List of match Pks for Ignore :"+ignoreList.toArray().toString());
			
			if(ifEmptyAll())
				flag = false;
				
			if(flag){
				if(cxlIgnoreList.length > 0){
					if(matchPkList.length > 0 || executionPkList.length >0 
					|| cxlForceMatchPkList.length > 0 ||ignoreList.length > 0 || unpairedOrderList.length > 0){
						XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('oms.order.matching.select.ignore.forcancel'));
					}
					else{
						//XenosAlert.confirm("Are you sure to Cancel Ignore the Selected records ?", confirmHandlerForCxlIgnore);
						showResult("CXL_IGNORE");
					}
				}
				else{
					XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('oms.order.matching.select.ignore.forcancel'));
				}
			}
    	 }
    	 /**
    	 * Confirm Handeler for Ignore Cancel
    	 */    
		private function confirmHandlerForCxlIgnore(event:CloseEvent):void {
	     if (event.detail == Alert.YES) {
	     		var i:int = 0;
	     		var reqObj : Object = new Object();
	     		reqObj.method = "doCancelIgnore";
	     		
	     		var matchPkArray:Array = new Array();
	     		var ordUpdDate:Array = new Array();
    			var exeUpdDate:Array = new Array();
    			
    			if(cxlIgnoreList.length > 0){
    				for(i=0; i<cxlIgnoreList.length; i++){
    					matchPkArray[i] = cxlIgnoreList[i];
    					ordUpdDate[i] = orderUpdateDateForCxlIgnore[i];
    					exeUpdDate[i] =  executionUpdateDateForCxlIgnore[i];
    				}
    				reqObj.selectedMatchPkArray = null;
	     			reqObj.selectedCxlIgnoreMatchPkArray = matchPkArray;
	     			reqObj.orderUpdateDateForCxlIgnore = null;
	     			reqObj.orderUpdateDateForCxlIgnore = ordUpdDate;
	     			reqObj.executionUpdateDateForCxlIgnore = null;
	     			reqObj.executionUpdateDateForCxlIgnore = exeUpdDate;
	     		}
	     		operationMode = "Cancel Ignore";
	     		
	     		forceMatchCxlIgnoreRequestAction.url = forceMatchCxlIgnoreRequestAction.url + "&rnd="+Math.random();
	     		forceMatchCxlIgnoreRequestAction.request = reqObj;
	     		forceMatchCxlIgnoreRequestAction.send();
	     	} 
		}
		/**
    	  * This method handles the Unpaired Orders
    	  * As per the latest requirement no operation is needed for this .
    	  * but , since these records are displayed in the UI, the select for these records are handled.
    	  * 
    	  */ 
    	public function saveRecordForUnpairedOrder(data:Object, selectedFlag:Boolean):void {
    		var tempOrderPkList:Array = new Array();
    		var i:int = 0;
    		
    		if(selectedFlag){/* This if block handles selected = true functionality*/
    				unpairedOrderList.addItem(data.orderPk);
    		}else{/* This if block handles Selected = false functionality*/
					tempOrderPkList   = cxlForceMatchPkList.toArray(); // storing the match Pks
	    			unpairedOrderList.removeAll();
	    			for(i=0; i < tempOrderPkList.length; i++){
					if(tempOrderPkList[i] != data.orderPk){
			    		unpairedOrderList.addItem(tempOrderPkList[i]);
					}
			  	}
    		}
		}
	/**
     * Show the order matching confirmation page.
     */	
	private function showResult(matchType:String):void {  
        if(rowNum.length == 0){
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('oms.order.matching.select.one'));
        }else{
            selectifAny = true;
            var reqObj : Object = new Object();
            reqObj.fromPage = "queryResult";
            reqObj.matchType = matchType;
            reqObj.traversableIndex = "2";
            reqObj.method="doPreConfirmOrderMatching";            
			reqObj['rowNoArray'] = null;
			reqObj['rowNoArray'] = rowNum.toArray();
			trace("rowNoArray : " + rowNum.toArray());
			orderMatchConfirmRequest.request = reqObj;
            orderMatchConfirmRequest.send()
        }              
    }
      	 	
	/**
     * Load the selected to order matching confirmation page.
     * 
     */
      private function confirmHandler(event:ResultEvent):void {
        
        trxpop = OrderMatchingConfirmationPopup(PopUpManager.createPopUp(this, OrderMatchingConfirmationPopup, true));        
        trxpop.width = this.parentApplication.width - 100;
        trxpop.addEventListener("OkSystemConfirm", handleOkSystemConfirm);
       // trxpop.addEventListener("enableButton", enableButton);
        var rs:XML = XML(event.result);
            
        var tempResult:ArrayCollection = new ArrayCollection();     
        if (null != event) {
            trxpop.errorInfoList = new ArrayCollection();
            if(rs.child("Errors").length()>0){ 
                // i.e. Must be error, display it .populate the error info list              
                for each ( var error:XML in rs.Errors.error ) {
                    //errorInfoList.addItem(error.toString());
                    trxpop.errorInfoList.addItem(error.toString());
                }
                //trxpop.errPage.showError(errorInfoList);//Display the error
            }else {
                errPage.removeError();   
                
                for each ( var rec:XML in rs.selectedResult.selectedResultItem ) {
                    tempResult.addItem(rec);
                }
                
                confirmResult = tempResult;  
    
                trxpop.dProvider = confirmResult;
                trxpop.formData = rs;
            } 
        }else {
            confirmResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }
        trxpop.title = this.parentApplication.xResourceManager
        					.getKeyValue("oms.order.label.userconfirm");

        PopUpManager.centerPopUp(trxpop);
     } 
	/**
	 * Function called after System Confirmation to re-query with previous
	 * query criteria   
	 */     
      public function handleOkSystemConfirm(event:Event):void {
        this.dispatchEvent(new Event('querySubmit'));
        //this.dispatchEvent(new Event('queryReset'));
        //currentState = "";
    }
    //select function
    /**
    * Determines whether the record needs to be added for resend
    * or deleted according the selected value of teh Check Box.
    */ 
     private function addOrRemove(selectedFlag:Boolean,ix : int):void {
        var i:int = 0;
        var j:int = 0;
        if(selectedFlag){ // need to insert
            rowNum.addItem(ix);                    
        }else { //need to pop   
            tempArray=rowNum.toArray();
            rowNum.removeAll();
            for(i=0; i<tempArray.length; i++){
                if(tempArray[i] != ix){
                    rowNum.addItem(tempArray[i]);
                }
            }           
        }           
    }
    /**
     * Check one by one selection.
     */
  	public function checkSelectToModify(item:Object,selectedFlag:Boolean):void {
    	var ix:int = queryResult.getItemIndex(item);
    	//trace("indx:"+ix);
        //XenosAlert.info("Please : "+ selectedFlag.toString() +" :row num :"+ ix.toString());
        addOrRemove(selectedFlag,ix);
    }
	override    public function preGenerateXls():String{
    	var url : String =null;
	    if(mode == Globals.MODE_QUERY){
	    	url = "oms/orderMatchingQuery.action?method=generateXLS";
    	}
    	return url;
  	}
  	override public function preGeneratePdf():String{
    	var url : String =null;
    	if(mode == Globals.MODE_QUERY ){
			url = "oms/orderMatchingQuery.action?method=generatePDF";
    	}
    	return url;
  	}