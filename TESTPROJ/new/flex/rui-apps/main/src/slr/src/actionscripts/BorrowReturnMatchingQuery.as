// ActionScript file

		import com.nri.rui.core.Globals;
		import com.nri.rui.core.containers.SummaryPopup;
		import com.nri.rui.core.controls.CustomizeSortOrder;
		import com.nri.rui.core.controls.XenosAlert;
		import com.nri.rui.core.controls.XenosQuery;
		import com.nri.rui.core.startup.XenosApplication;
		import com.nri.rui.core.utils.HiddenObject;
		import com.nri.rui.core.utils.ProcessResultUtil;
		import com.nri.rui.core.utils.XenosStringUtils;
		import com.nri.rui.slr.validator.BorrowReturnMatchingQueryValidator;
		
		import mx.collections.ArrayCollection;
		import mx.controls.AdvancedDataGrid;
		import mx.core.UIComponent;
		import mx.events.AdvancedDataGridEvent;
		import mx.events.CloseEvent;
		import mx.managers.PopUpManager;
		import mx.rpc.events.ResultEvent;
		import mx.utils.StringUtil;

		 //Items returning through context - Non display objects for accountPopup
		[Bindable] public var returnContextItem:ArrayCollection = new ArrayCollection();
		[Bindable]private var mode : String = "query";
		[Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
		[Bindable]private var queryResult:ArrayCollection= new ArrayCollection();
		[Bindable]private var rs:XML = new XML();
		[Bindable]public var selectifAny:Boolean=false;
		[Bindable]private var confirmResult:ArrayCollection= new ArrayCollection();
		[Bindable] private var sortFieldList1:ArrayCollection = null;
		[Bindable] private var sortFieldList2:ArrayCollection = null;
		[Bindable] private var sortFieldList3:ArrayCollection = null;
		[Bindable] private var sortFieldList4:ArrayCollection = null;
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
		public var conformSelectedResults : Array; 
		private var sPopup : SummaryPopup;	
		
		private var selectedResults:ArrayCollection=new ArrayCollection();   
		
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
                            mode = tempA[1];
                        }
                    }                    	
                }else{
                	mode = "query";
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
          
            //passing counter party type                
            var cpTypeArray:Array = new Array(1);
            cpTypeArray[0]="INTERNAL";
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
            
            // passing longShortFlag
	       	var longShortFlagArray:Array = new Array(1);
            longShortFlagArray[0]="S";
            myContextList.addItem(new HiddenObject("longShortFlagContext",longShortFlagArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
            return myContextList;
        }
        
       
       /**
       * Initial execute of the query page
       */ 
       override public function preQueryInit():void{
       	
       		super.getInitHttpService().url = "slr/borrowReturnMatchingQueryDispatch.action?rnd="+Math.random();            
      		var req : Object = new Object();
        	req.SCREEN_KEY = 13008;
        	req.method="initialExecute";
        	super.getInitHttpService().request = req;
       		
        }
        
        /**
        * Result handler of the initial execute
        */ 
        override public function preQueryResultInit():Object{
        	addCommonKeys();   	
	    	return keylist;        	
        }
        
        /**
        * Fields added to the key list for the display of default value
        */ 
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();      	
	    	keylist.addItem("sortFieldList.item");	
	    	keylist.addItem("Errors.error");
	    	keylist.addItem("matchDate");
	    	
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
        private function commonInit(mapObj:Object):void {
        	
        	var tempColl: ArrayCollection = new ArrayCollection();
        	var i:int = 0;
        	var selIndx:int = 0;
        	
           	app.submitButtonInstance = submit;
           	fundPopUp.fundCode.setFocus();
           	this.fundPopUp.fundCode.text="";
           	this.inventoryAccountNo.accountNo.text="";
           	this.security.instrumentId.text="";
           	this.borrowtrddateFrom.text = "";
           	this.borrowtrddateTo.text = "";
           	this.borrowvadateFrom.text = "";
           	this.borrowvaldateTo.text = "";
           	this.borrowreferenceno.text ="";
           	this.returntrddateFrom.text="";
           	this.returntrddateTo.text="";
           	this.returnvaldateFrom.text="";
           	this.returnvaldateTo.text="";
           	this.returnreferenceno.text="";
           	this.matchdate.text="";
           	
           	this.sortField1.selectedIndex = 0;
			this.sortField2.selectedIndex = 0;
			this.sortField3.selectedIndex = 0;
			this.sortField4.selectedIndex = 0;
           	
           	msmatch.selected = true;
           	msoutstand.selected = true;
           	msmarkmatch.selected = true;
           	trdsNormal.selected = true;
           	//matchsLogNormal.selected = true;
           	
           	if(msmatch.selected) {
           		
           	}
            this.rowNum.removeAll();
           	
    		errPage.clearError(super.getInitResultEvent());
    		//this.queryResult.removeAll();
	        //errPage.removeError();
	        this.matchDatelbl.visible = true
    		this.matchdate.visible = true;
    		this.matchdate.text = mapObj[keylist.getItemAt(2)].toString();
	    	var index:int=-1;
	    	var initcol:ArrayCollection = new ArrayCollection();
	    	
	    	//Populate Sort Field Combo Box
			sortFieldList1 = new ArrayCollection();
			sortFieldList1.addItem({label: " " , value : " "});
			
			sortFieldList2 = new ArrayCollection();
			sortFieldList2.addItem({label: " " , value : " "});
			
			sortFieldList3 = new ArrayCollection();
			sortFieldList3.addItem({label: " " , value : " "});
			
			sortFieldList4 = new ArrayCollection();
			sortFieldList4.addItem({label: " " , value : " "});
			
	
			for each(var obj4:Object in mapObj[keylist.getItemAt(0)] as ArrayCollection) {
				sortFieldList1.addItem(obj4);
				sortFieldList2.addItem(obj4);
				sortFieldList3.addItem(obj4);
				sortFieldList4.addItem(obj4);
			}
	
	    	//For Sort Field 1 Combo
	    	sortFieldArray[0] = sortField1;
	    	sortFieldDataSet[0]= sortFieldList1;
	    	
	    	//Set the default value object
	    	sortFieldSelectedItem[0] = sortFieldList1.getItemAt(1);
	    	
	    	//For Sort Field 2 Combo
	    	sortFieldArray[1] = sortField2;
	    	sortFieldDataSet[1] = sortFieldList2;
	    	
	    	//Set the default value object
	    	sortFieldSelectedItem[1] = sortFieldList2.getItemAt(2);
	    	
	    	//For Sort Field 3 Combo
	    	sortFieldArray[2] = sortField3;
	    	sortFieldDataSet[2] = sortFieldList3;
	    	
	    	//Set the default value object
	    	sortFieldSelectedItem[2] = sortFieldList3.getItemAt(3);
	    	
	    	//For Sort Field 4 Combo
	    	sortFieldArray[3] = sortField4;
	    	sortFieldDataSet[3] = sortFieldList4;
	    	
	    	//Set the default value object
			sortFieldSelectedItem[3] = sortFieldList4.getItemAt(4);
			
		    //-------------Initializing the sortfields-------------//
			csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
	        csd.init();
        }
        
        /**
        * Mathod to reset the Page
        */ 
        override public function preResetQuery():void{
        	super.getResetHttpService().url = "slr/borrowReturnMatchingQueryDispatch.action?rnd="+Math.random();
        	var reqObject:Object = new Object();
        	reqObject.method="resetQuery";
        	reqObject.SCREEN_KEY = 13008;
        	super.getResetHttpService().request = reqObject;	
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
 		*  datagrid header release event handler to handle datagridcolumn sorting
 		*/
		public function dataGrid_headerRelease(evt:AdvancedDataGridEvent):void {				
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
		
		override public function preQuery(): void {
			if(selectedResults!=null){
       			selectedResults.removeAll();
       			conformSelectedResults=selectedResults.toArray();
       		}
			setValidator();
			qh.resetPageNo();
			qh.resetPageNo();
			super.getSubmitQueryHttpService().url = "slr/borrowReturnMatchingQueryDispatch.action?";
			super.getSubmitQueryHttpService().method = "POST";
			super.getSubmitQueryHttpService().request = populateRequestParams();
		}
		
		//------------------ Validator Method --------------------/
	private function setValidator(): void {
		var validateModel: Object = {
		borrowReturnMatchingQuery: {
				fundCode:this.fundPopUp.fundCode.text,
                matchStatus : this.msmatch.selected,
                oustandStatus : this.msoutstand.selected,
                markMatch :this.msmarkmatch.selected,
                btTdFrom : this.borrowtrddateFrom.text,
                btTdTo : this.borrowtrddateTo.text,
                btVdFrom : this.borrowvadateFrom.text,
                btVdTo : this.borrowvaldateTo.text,
				rtTdFrom : this.returntrddateFrom.text,
				rtTdTo : this.returntrddateTo.text,
				rtVdFrom : this.returnvaldateFrom.text,
				rtVdTo : this.returnvaldateTo.text,
				matchdate : this.matchdate.text
		}
		};
		super._validator = new BorrowReturnMatchingQueryValidator();
		super._validator.source = validateModel;
		super._validator.property = "borrowReturnMatchingQuery";
	}

		/**
    	 * This method will populate the request parameters for the
    	 * submitQuery call and bind the parameters with the HTTPService
   	     * object.
    	 */
   		 private function populateRequestParams():Object {
    		var reqObj : Object = new Object();
    		reqObj.method= "submitQuery";
			reqObj.SCREEN_KEY = 13009;
			
			reqObj.fundCode = this.fundPopUp.fundCode.text;
			reqObj.fundAccountNo = this.inventoryAccountNo.accountNo.text;
			reqObj.securityCode = this.security.instrumentId.text;
			reqObj.borrowTradeDateFrom = this.borrowtrddateFrom.text ;
			reqObj.borrowTradeDateTo = this.borrowtrddateTo.text ;
			
			reqObj.borrowValueDateFrom = this.borrowvadateFrom.text  ;
			reqObj.borrowValueDateTo = this.borrowvaldateTo.text ;
			
			reqObj.borrowReferenceNo = this.borrowreferenceno.text;
			
			reqObj.returnTradeDateFrom = this.returntrddateFrom.text ;
			reqObj.returnTradeDateTo = this.returntrddateTo.text ;
			
			reqObj.returnValueDateFrom = this.returnvaldateFrom.text  ;
			reqObj.returnValueDateTo = this.returnvaldateTo.text ;
			
			reqObj.returnReferenceNo = this.returnreferenceno.text;
			
			reqObj.matchDate = this.matchdate.text;
			var isSelectedMatch:Boolean = (this.msmatch.selected == true)?true:false;
			var isSelectedOutstand:Boolean = (this.msoutstand.selected == true)?true:false;
			var isSelectedMarkMatch:Boolean = (this.msmarkmatch.selected == true)?true:false;
			
			reqObj.matchStatus = isSelectedMatch;
			reqObj.outstandStatus = isSelectedOutstand;
			reqObj.markmatchStatus = isSelectedMarkMatch;
			
			reqObj.tradeStatus = this.trdstatusRadio.selectedValue;
			
			reqObj.sortField1 = StringUtil.trim(this.sortField1.selectedItem.value);
			reqObj.sortField2 = StringUtil.trim(this.sortField2.selectedItem.value);
			reqObj.sortField3 = StringUtil.trim(this.sortField3.selectedItem.value);
			reqObj.sortField4 = StringUtil.trim(this.sortField4.selectedItem.value);
    		return reqObj;
    	}
    	
    	/**
    	 * 
    	 */ 
    	private function changeCurrentState():void{
				currentState = "result";
				app.submitButtonInstance = null;
	 	}
	 	
	 	override public function postQueryResultHandler(mapObj: Object): void {
			commonResult(mapObj);
		}
		
		//common result of the query
		private function commonResult(mapObj: Object): void {
			var result: String = "";
			queryResult.removeAll();
			conformSelectedResults = new Array();
			selectedResults.removeAll();
			if (mapObj != null) {
				if (mapObj["errorFlag"].toString() == "error") {
					queryResult.removeAll(); // clear previous data if any as there is no result now.
                	errPage.showError(mapObj["errorMsg"]);
				} else if (mapObj["errorFlag"].toString() == "noError") {
					errPage.clearError(super.getSubmitQueryResultEvent());
					queryResult.removeAll();
               		queryResult=mapObj["row"];
			   		changeCurrentState();
			   		qh.setOnResultVisibility();
	           		qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
	           		qh.PopulateDefaultVisibleColumns();
			   		
				} else {
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                queryResult.removeAll(); // clear previous data if any as there is no result now.
                errPage.removeError(); //clears the errors if any
             }   
			}
				
		}
	 	  /**
    * This method works as the result handler of the Submit Query Http Services.
    * This also takes care of the buttons/images to be shown on the top panel of the
    * result .
    */
      private function loadSummaryPage(event:ResultEvent):void {
        var rs:XML = XML(event.result);
        if (null != event) {                
            if(rs.child("row").length()>0) {
                errPage.clearError(event);
                queryResult.removeAll();
                try {
                    for each (var rec:XML in rs.row ) {
                        queryResult.addItem(rec);
                    }                               
                    changeCurrentState();
                    qh.setOnResultVisibility();    
                                 
                    qh.setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
                    qh.PopulateDefaultVisibleColumns();
                    //replace null objects with empty string
                    queryResult=ProcessResultUtil.process(queryResult,resultSummary.columns); 
                    queryResult.refresh();                                            
                }catch(e:Error){
                    XenosAlert.error(e.toString() + e.message);
                }
            }else if(rs.child("Errors").length()>0) {
                //some error found
                queryResult.removeAll(); // clear previous data if any as there is no result now.
                var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list              
                for each ( var error:XML in rs.Errors.error ) {
                   errorInfoList.addItem(error.toString());
                }
                errPage.showError(errorInfoList);//Display the error
             } else {
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                queryResult.removeAll(); // clear previous data if any as there is no result now.
                errPage.removeError(); //clears the errors if any
             }   
        }
        resetSellection(queryResult);
      }
      
       private function resetSellection(summaryResult:ArrayCollection):void{
       	
    	for(var i:int=0;i<summaryResult.length;i++){
    		summaryResult[i].selected = false;
    		summaryResult[i].rowNum = i;
    	}
       }
    	/**
    	 * 
    	 */
        override public function preNext():Object{
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
	 * Function called after System Confirmation to re-query with previous
	 * query criteria   
	 */     
      public function handleOkSystemConfirm(event:Event):void {
        this.dispatchEvent(new Event('querySubmit'));
    }
    /**
     * Check one by one selection.
     */
  	public function checkSelectToModify(item:Object,selectedFlag:Boolean):void {
  		var i:Number;
  		
  		if(item.selected == true){
  			 // needs to insert
  			var tempArray1 : Array = new Array();
        	var obj:Object=new Object();
        	obj.matchStatus = item.matchStatus;
        	obj.borrowTradePk = item.borrowTradePk;
        	obj.returnTradePk = item.returnTradePk;
        	obj.fundAccNo = item.fundAccountNo;
        	obj.securityId = item.securityId;
        	obj.brokerAccountNo = item.brokerAccountNo;
        	obj.btStatus = item.btStatus;
        	obj.rtStatus = item.rtStatus;
        	obj.tradePk = item.tradePk;
        	obj.matchLogPk = item.matchLogPk;
        	obj.mtStatus = item.mtStatus;
        	obj.rtQuantity = item.rtQuantity;
        	obj.btOutstandingBorrowQuantity = item.btOutstandingBorrowQuantity;
        	obj.btQuantity = item.btQuantity;
        	selectedResults.addItem(obj);
  		} else { //needs to pop
    		tempArray1=selectedResults.toArray();
    	    selectedResults.removeAll();
    		for(i=0; i<tempArray1.length; i++){
    			if(item.matchLogPk !=0) {
    				if(tempArray1[i].matchLogPk !=item.matchLogPk) {
    					selectedResults.addItem(tempArray1[i]);
    				} 
    			} else {
    				if(tempArray1[i].tradePk !=item.tradePk) {
    					selectedResults.addItem(tempArray1[i]);
    				} 
    				if(tempArray1[i].matchLogPk !=0) {
    					selectedResults.addItem(tempArray1[i]);
    				}
    			}
    		}        		
    	}
    	conformSelectedResults=	selectedResults.toArray();    
    }
    
    override    public function preGenerateXls():String{
    	var url : String =null;
	    if(mode == Globals.MODE_QUERY){
	    	url = "slr/borrowReturnMatchingQueryDispatch.action?method=generateXLS";
    	}
    	return url;
  	}
  	
  	override public function preGeneratePdf():String{
    	var url : String =null;
    	if(mode == Globals.MODE_QUERY ){
			url = "slr/borrowReturnMatchingQueryDispatch.action?method=generatePDF";
    	}
    	return url;
  	}
  	
  	/**
  	 * This method used to handle the Match execution of records
  	 * 
  	 * */
  	public function doMatch(event:Event):void {
     	 var isMatchable:Boolean = false;
         var selectedBorrowPkArray:Array = new Array();
         var selectedReturnPk:int = 0;
     	 if(conformSelectedResults != null){
     	 	if(conformSelectedResults.length > 0){
     	 		var isCancel:Boolean = false;
     	 		var isMatched:Boolean = false;
     	 		var isNotEligible:Boolean = false;
     	 		var isIllegalTrade:Boolean = false;
     	 		var isRetCntMoreOne:Boolean = false;
     	 		var isSingleBorrowReturn:Boolean = false;
     	 		var fundAccNo:String = XenosStringUtils.EMPTY_STR;
     	 		var securityId:String = XenosStringUtils.EMPTY_STR;
     	 		var brokerAccNo:String = XenosStringUtils.EMPTY_STR;
	     	 	var retCount:int = 0;
	     	 	var borrowCnt:int = 0;
	     	 	var trdCount:int = 0;
	     	 	var borrowQty:int = 0;
	     	 	var returnQty:int = 0; 
     	 		for(var i:int; i < conformSelectedResults.length; i++){
     	 			if(XenosStringUtils.equals(String(conformSelectedResults[i].btStatus),"CANCEL") || 
     	 					XenosStringUtils.equals(String(conformSelectedResults[i].rtStatus),"CANCEL")){
     	 				isCancel = true;
     	 				break;
     	 			}
     	 			if(XenosStringUtils.equals(conformSelectedResults[i].matchStatus, "MATCHED") || 
     	 					XenosStringUtils.equals(conformSelectedResults[i].matchStatus, "MARK AS MATCHED")) {
     	 				isNotEligible = true;
     	 				break;
     	 			}
     	 			if(trdCount == 0) {
     	 				fundAccNo = conformSelectedResults[i].fundAccNo;
     	 				securityId = conformSelectedResults[i].securityId;
     	 				brokerAccNo = conformSelectedResults[i].brokerAccNo;
     	 			} else {
     	 				if(!XenosStringUtils.equals(fundAccNo,conformSelectedResults[i].fundAccNo)) {
     	 					isIllegalTrade = true;
     	 					break;
     	 				}
     	 				if(!XenosStringUtils.equals(securityId,conformSelectedResults[i].securityId)) {
     	 					isIllegalTrade = true;
     	 					break;
     	 				}
     	 				if(!XenosStringUtils.equals(brokerAccNo,conformSelectedResults[i].brokerAccNo)) {
     	 					isIllegalTrade = true;
     	 					break;
     	 				}
     	 			}
     	 			if(conformSelectedResults[i].returnTradePk !=0) {
     	 				selectedReturnPk = conformSelectedResults[i].returnTradePk;
     	 				returnQty = returnQty + conformSelectedResults[i].rtQuantity;
     	 				retCount++;
     	 				
     	 			} else if(conformSelectedResults[i].borrowTradePk !=0) {
     	 				var outstandQty : int = 0;
     	 				if(conformSelectedResults[i].btOutstandingBorrowQuantity == null || 
     	 						XenosStringUtils.isBlank(conformSelectedResults[i].btOutstandingBorrowQuantity)) {
     	 					outstandQty = conformSelectedResults[i].btQuantity;
     	 				} else {
     	 					outstandQty = conformSelectedResults[i].btOutstandingBorrowQuantity;
     	 				}
     	 				borrowQty = borrowQty + outstandQty;
     	 				borrowCnt++;
     	 				selectedBorrowPkArray.push(conformSelectedResults[i].borrowTradePk);
     	 			}
     	 		
     	 		trdCount++;
     	 		}
     	 		if(retCount > 1) {
     	 			isRetCntMoreOne = true;
     	 		}
     	 		if(retCount == 0 || borrowCnt == 0) {
     	 			isSingleBorrowReturn = true;
     	 		}
     	 		if(isCancel){
     	 			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.without.normal.trade'));
     	 		}else if(isNotEligible){
     	 			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.match.without.proper.match.status'));
     	 		}else if(isIllegalTrade){
     	 			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.illegal.borrow.return.pair'));
     	 		}else if(isRetCntMoreOne){
     	 			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.match.single.return.trade'));
     	 		}else if(isSingleBorrowReturn){
 	 				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.match.both.borrow.return.trade'));
 	 			} else if(returnQty > borrowQty) {
 	 				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.match.return.qty.borrow.qty.mismatch'));
 	 			} else {
 	 				isMatchable = true;
 	 			}
     	 	} else{
     	 		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.match.without.selected.trade'));
     	 	}
		}else{
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.match.without.selected.trade'));
		}
		
		if(isMatchable){
        	loadMatchOueryPage(selectedBorrowPkArray,selectedReturnPk, "MATCH");
		}
     }
     
     /**
  	 * This method used to handle the UnMatch execution of records
  	 * 
  	 * */
     public function doUnMatch(event:Event):void {
     	var selectedBorrowPkArray:Array = new Array();
     	var selectedReturnPk:int = 0;
     	if(conformSelectedResults != null){
     	 	if(conformSelectedResults.length > 0){
     	 		var isCancel:Boolean = false;
     	 		var isIllegalTrade : Boolean = false;
     	 		var isNotEligible : Boolean = false;
     	 		var isUnMatchable : Boolean = false;
     	 		var trdCount:int = 0;
     	 		var retTradePk:int = 0;
     	 		for(var i:int; i < conformSelectedResults.length; i++){
     	 			if(XenosStringUtils.equals(String(conformSelectedResults[i].mtStatus),"CANCEL")){
     	 				isCancel = true;
     	 				break;
     	 			}
     	 			if(!XenosStringUtils.equals(conformSelectedResults[i].matchStatus, "MATCHED")) {
     	 				isNotEligible = true;
     	 				break;
     	 			}
     	 			if(conformSelectedResults[i].returnTradePk !=0) {
     	 				if(trdCount ==0) {
     	 					retTradePk = conformSelectedResults[i].returnTradePk;
     	 				} else {
     	 					if(retTradePk != conformSelectedResults[i].returnTradePk) {
     	 						isIllegalTrade = true;
     	 						break;
     	 					}
     	 				}
     	 				
     	 			} 
     	 			if(conformSelectedResults[i].borrowTradePk !=0) {
     	 				selectedBorrowPkArray.push(conformSelectedResults[i].borrowTradePk);
     	 			}
     	 			trdCount++;
     	 		}
     	 		if(isCancel){
     	 			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.without.normal.trade'));
     	 		} else if(isNotEligible){
     	 			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.unmatch.without.proper.match.status'));
     	 		} else if(isIllegalTrade){
     	 			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.unmatch.single.return.trade'));
     	 		} else {
     	 			isUnMatchable = true;  
     	 		}
     	 	} else{
     	 		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.unmatch.without.selected.trade'));
     	 	}
			   	
     	}  else{
     	 		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.unmatch.without.selected.trade'));
     	 	}
     	 	
     	if(isUnMatchable){
        	loadMatchOueryPage(selectedBorrowPkArray,retTradePk, "UNMATCH");
		}
     }
     
     /**
  	 * This method used to handle the Mark As Match execution of records.
  	 * 
  	 * */
      public function doMarkAsMatch(event:Event):void {
      	var selectedBorrowPkArray:Array = new Array();
      	var retTradePk:int = 0;
      	if(conformSelectedResults != null){
     	 	if(conformSelectedResults.length > 0){
     	 		var isCancel:Boolean = false;
     	 		var isNotEligible : Boolean = false;
     	 		var isNotBorrowTrd : Boolean = false;
     	 		var isMarkmatchable :Boolean =false;
     	 		
     	 		for(var i:int; i < conformSelectedResults.length; i++){
     	 			if(XenosStringUtils.equals(String(conformSelectedResults[i].btStatus),"CANCEL") || 
     	 					XenosStringUtils.equals(String(conformSelectedResults[i].rtStatus),"CANCEL")){
     	 				isCancel = true;
     	 				break;
     	 			}
     	 			if((!XenosStringUtils.equals(conformSelectedResults[i].matchStatus, "PARTIALLY MATCHED")) && 
     	 					(!XenosStringUtils.equals(conformSelectedResults[i].matchStatus, "UNMATCHED"))) {
     	 				isNotEligible = true;
     	 				break;
     	 			}
     	 			
     	 			if(conformSelectedResults[i].returnTradePk !=0) {
     	 				isNotBorrowTrd = true;
     	 				break;
     	 			}
     	 			if(conformSelectedResults[i].borrowTradePk !=0) {
     	 				selectedBorrowPkArray.push(conformSelectedResults[i].borrowTradePk);
     	 			}
     	 			
     	 		}
     	 		if(isCancel){
     	 			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.without.normal.trade'));
     	 		} else if(isNotEligible){
     	 			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.markmatch.without.proper.match.status'));
     	 		} else if(isNotBorrowTrd) {
     	 			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.markmatch.without.proper.trade.type'));
     	 		} else {
     	 			isMarkmatchable = true;
     	 		}
     	 	} else{
     	 		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.unmatch.without.selected.trade'));
     	 	}
     	 } else{
     	 		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.unmatch.without.selected.trade'));
     	 	}
     	 	
     	 	if(isMarkmatchable){
        	loadMatchOueryPage(selectedBorrowPkArray,retTradePk, "MARK_AS_MATCH");
		}
     	 	
      }
      
      /**
  	 * This method used to handle the Cxl Mark As Match execution of records
  	 * 
  	 * */
      public function doCxlMarkAsMatch(event:Event):void {
      	var selectedBorrowPkArray:Array = new Array();
      	var retTradePk:int = 0;
      	if(conformSelectedResults != null){
      		
     	 	if(conformSelectedResults.length > 0){
     	 		var isNotEligible:Boolean = false;
     	 		var isCxlMarkable : Boolean = false;
     	 		var isNotBorrowTrd : Boolean = false;
     	 		
     	 		for(var i:int; i < conformSelectedResults.length; i++){
     	 			
     	 			if(!XenosStringUtils.equals(conformSelectedResults[i].matchStatus, "MARK AS MATCHED")) {
     	 				isNotEligible = true;
     	 				break;
     	 			}
     	 			
     	 			if(conformSelectedResults[i].returnTradePk !=0) {
     	 				isNotBorrowTrd = true;
     	 				break;
     	 			}
     	 			if(conformSelectedResults[i].borrowTradePk !=0) {
     	 				selectedBorrowPkArray.push(conformSelectedResults[i].borrowTradePk);
     	 			}
     	 		}
     	 		if(isNotEligible){
     	 			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.cxlmarkmatch.without.proper.match.status'));
     	 		} else if(isNotBorrowTrd) {
     	 			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.markmatch.without.proper.trade.type'));
     	 		} else {
     	 			isCxlMarkable = true;
     	 		}
     	 	} else{
     	 		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.unmatch.without.selected.trade'));
     	 	}
     	 } else{
     	 		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.unmatch.without.selected.trade'));
     	 	}
     	 	
     	 if(isCxlMarkable){
        	loadMatchOueryPage(selectedBorrowPkArray,retTradePk, "CXL_MARK_AS_MATCH");
		}
      }
      
       public function loadMatchOueryPage(selectedBorrowPkArray:Array, returnTradePk:int, matchStatus:String):void {
     	
		var parentApp :UIComponent = UIComponent(this.parentApplication);
		sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
		sPopup.addEventListener(CloseEvent.CLOSE,closePopUp);
		sPopup.width = 1200;
		sPopup.height = 400;
		sPopup.owner=this;
		PopUpManager.centerPopUp(sPopup);
		sPopup.moduleUrl = "assets/appl/slr/BorrowReturnMatchPopup.swf?selBorrowArr"+Globals.EQUALS_SIGN+
			selectedBorrowPkArray+Globals.AND_SIGN+"selReturn"+Globals.EQUALS_SIGN+returnTradePk+Globals.AND_SIGN+"selMatchStatus"+Globals.EQUALS_SIGN+matchStatus;
     }
     
     public function closePopUp(event:CloseEvent):void {
		this.dispatchEvent(new Event('querySubmit'))
		sPopup.removeEventListener(CloseEvent.CLOSE,closePopUp);
		sPopup.removeMe();
	}
	
	public function clickMatchStatus() :void {
		if(!this.msmatch.selected) {
			this.matchdate.visible = false;
			this.matchDatelbl.visible = false;
			 
		} else {
			this.matchdate.visible = true;
			this.matchDatelbl.visible = true;
		}
	}
