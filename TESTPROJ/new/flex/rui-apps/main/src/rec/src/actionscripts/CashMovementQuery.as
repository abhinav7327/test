
 // ActionScript file for Cam Movement Query

 import com.nri.rui.core.Globals;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.NumberUtils;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.core.validators.XenosNumberValidator;
 import com.nri.rui.rec.validators.CashMovementQueryValidator;
 
 import flash.net.URLRequest;
 import flash.net.URLRequestMethod;
 
 import mx.collections.ArrayCollection;
 import mx.controls.dataGridClasses.DataGridColumn;
 import mx.events.ResourceEvent;
 import mx.events.ValidationResultEvent;
 import mx.resources.ResourceBundle;
 import mx.rpc.events.ResultEvent;
 import mx.utils.StringUtil;
   
   
    [Bindable]
    private var initColl:ArrayCollection;
    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    [Bindable]
 	private var queryResult:Object= new Object();
    private var emptyResult:ArrayCollection= new ArrayCollection();
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    [Bindable]
    private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    [Bindable]
    public var returnFinContext:ArrayCollection = new ArrayCollection();
   	[Bindable]
 	private var finContextList:ArrayCollection = new ArrayCollection();
    
	[Bindable]
 	private var stlAccForFundContextList:ArrayCollection = populateContext();
    
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    
    private var  csd:CustomizeSortOrder=null;
                                             
     /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
        qh.dgrid = movementSummary;
    }  
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    * This will fetch data to fill the initial form data to show the user.
    */
     private function initPageStart():void {            
        if (!initCompFlg) {    
        	dateFrom.setFocus();
            rndNo= Math.random();  
            var req : Object = new Object();
	  		req.SCREEN_KEY = 11018;
            initializeMovementQuery.request = req;
            initializeMovementQuery.url = "rec/recCashMovementDispatch.action?method=initialExecute&rnd=" + rndNo;                    
            initializeMovementQuery.send();        
        } else
            XenosAlert.info("Already Initiated!");
     } 
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * Once initial data is fetched from database to fill some form data, this method works
    * to actually show the data.
    */   
     private function initPage(event: ResultEvent) : void {
        var i:int = 0;
        var selIndx:int = 0;
        var dateStr:String = null;
        var tempColl: ArrayCollection = new ArrayCollection();
       
        errPage.clearError(event); //clears the errors if any 
        
        //initiate text fields
        actPopUp.accountNo.text = "";
        ccyBox.ccyText.text = "";
        fundPopUp.fundCode.text = "";
        fininstPopUp.bankCode.text = "";
        dateFrom.text = "";
        dateFrom.setFocus();
        dateTo.text = "";
        
        if(event.result){
        	if(event.result.recCashMovementActionForm.officeIdList.officeId is ArrayCollection){
    		initColl = event.result.recCashMovementActionForm.officeIdList.officeId as ArrayCollection;        		
        	}else{
        		initColl = new ArrayCollection();
        		initColl.addItem(event.result.recCashMovementActionForm.officeIdList.officeId);
        	}
        	
        }   		
    		
    	//populate office id list
		tempColl = new ArrayCollection();    
		tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        officeId.dataProvider = tempColl;
        initColl.removeAll();
        if(event.result)   		
    		initColl = event.result.recCashMovementActionForm.auditValues.item as ArrayCollection;
    		
    	//populate audit list
		tempColl = new ArrayCollection();    
		tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        audit.dataProvider = tempColl;
        
        if(event.result)    		
    		initColl = event.result.recCashMovementActionForm.matchStatus.item as ArrayCollection;
    	//populate match status list
		tempColl = new ArrayCollection();    		
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        matchStatus.dataProvider = tempColl;
             
        
        /**
        * Setting values of the Account Status
        * Options---BLANK/OPEN/CLOSE 
        */ 
        initColl.removeAll();
        if(event.result.recCashMovementActionForm.accntStatusList.item != null){
            
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.recCashMovementActionForm.accntStatusList.item is ArrayCollection){
                initColl = event.result.recCashMovementActionForm.accntStatusList.item as ArrayCollection;
            }else{
                initColl.addItem(event.result.recCashMovementActionForm.accntStatusList.item);
            }
            for(i = 0; i<initColl.length; i++) {
               tempColl.addItem(initColl[i]);            
            }
            accountStatus.dataProvider = tempColl;
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.load.accstatuslist'));
        }
                                          
        //Initialize sortFieldList1.
        if(null != event.result.recCashMovementActionForm.sortFieldList1.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            initColl = event.result.recCashMovementActionForm.sortFieldList1.item as ArrayCollection;
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);            
            }
            //sortField1.dataProvider = tempColl;
            //Set the default value object
            //sortField1.selectedItem = tempColl.getItemAt(selIndx+1);
            
            sortFieldArray[0]=sortField1;
	        sortFieldDataSet[0]=tempColl;
	        //Set the default value object
	        sortFieldSelectedItem[0] = tempColl.getItemAt(1);
            
        } else {
            XenosAlert.error("Sort Order Field List 1 not Populated");
        }
        
        //Initialize sortFieldList2.
        if(null != event.result.recCashMovementActionForm.sortFieldList2.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx=0;
            
            initColl = event.result.recCashMovementActionForm.sortFieldList2.item as ArrayCollection;
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);            
            }
            //sortField2.dataProvider = tempColl;
            //Set the default value object
            //sortField2.selectedItem = tempColl.getItemAt(selIndx+1);
            
            sortFieldArray[1]=sortField2;
	        sortFieldDataSet[1]=tempColl;
	        //Set the default value object
	        sortFieldSelectedItem[1] = tempColl.getItemAt(2);
            
        } else {
            XenosAlert.error("Sort Order Field List 2 not Populated");
        }
        
        //Initialize sortFieldList3.
        if(null != event.result.recCashMovementActionForm.sortFieldList3.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
            
            initColl = event.result.recCashMovementActionForm.sortFieldList3.item as ArrayCollection;
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);            
            }
            //sortField3.dataProvider = tempColl;
            //Set the default value object
            //sortField3.selectedItem = tempColl.getItemAt(selIndx+1);
            
            sortFieldArray[2]=sortField3;
	        sortFieldDataSet[2]=tempColl;
	        //Set the default value object
	        sortFieldSelectedItem[2] = tempColl.getItemAt(3);
	        
	        
	        //set data provider
	       // sortFieldArray={sortField1,sortField2,sortField3};
	       
	        csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
	        csd.init();
	        
        } else {
            XenosAlert.error("Sort Order Field List 3 not Populated");
        }
    } 
    
     private function sortOrder1Update():void{
     	 csd.update(sortField1.selectedItem,0);
     }
     
     private function sortOrder2Update():void{     	
     	csd.update(sortField2.selectedItem,1);
     }
     
    /**
    * It sends/submits the query after validating the user input data. 
    * 
    */
     private function submitQuery():void 
     {  
                 
         //Set the request parameters
         var requestObj :Object = populateRequestParams();
         
         movementQueryRequest.request = requestObj; 
         
        var myModel:Object={
                            movement:{
                                 toDate:this.dateTo.text,
                                 fromDate:this.dateFrom.text,
                                 ccy:this.ccyBox.ccyText.text,
                                 accNo:this.actPopUp.accountNo.text,
                                 amountRangeFrom:this.amountRangeFrom.text,
                                 amountRangeTo:this.amountRangeTo.text
                            }
                           }; 
        var cashMovementValidate:CashMovementQueryValidator =new CashMovementQueryValidator();
        cashMovementValidate.source=myModel;
        cashMovementValidate.property="movement";
        var validationResult:ValidationResultEvent =cashMovementValidate.validate();
        
        if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
            resultHead.text = "";
           
        }else {
            qh.resetPageNo();
            movementQueryRequest.send();   
        }                   
    } 
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
         var reqObj : Object = new Object();
         reqObj.SCREEN_KEY = 11019;
         reqObj.method = "submitQuery";
         reqObj.accountNo = this.actPopUp.accountNo.text;
         reqObj.asOfDateFrom = this.dateFrom.text;
         reqObj.asOfDateTo = this.dateTo.text;
         reqObj.ccy = this.ccyBox.ccyText.text;
         reqObj.fundCode = this.fundPopUp.fundCode.text;
         reqObj.officeId = this.officeId.selectedItem != null ? this.officeId.selectedItem.value : Globals.EMPTY_STRING;
         reqObj.audit = this.audit.selectedItem != null ? this.audit.selectedItem.value : Globals.EMPTY_STRING;
         reqObj.matchStatus = this.matchStatus.selectedItem != null ? this.matchStatus.value : Globals.EMPTY_STRING;
         reqObj.bank = fininstPopUp.bankCode.text;
         reqObj.forReport = XenosStringUtils.EMPTY_STR;
		 /* reqObj.amountRangeFrom = XenosStringUtils.isBlank(this.amountRangeFrom.toString())? XenosStringUtils.EMPTY_STR : this.amountRangeFrom.toString();
		 reqObj.rengeTo = XenosStringUtils.isBlank(this.amountRangeTo.toString())? XenosStringUtils.EMPTY_STR : this.amountRangeTo.toString();
		  */
		 reqObj.amountRangeFrom = this.amountRangeFrom.text;
		 reqObj.amountRangeTo = this.amountRangeTo.text;
		 reqObj.accountStatus = (this.accountStatus.selectedItem != null ? this.accountStatus.selectedItem.value : "");
        
         reqObj.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : XenosStringUtils.EMPTY_STR;
         reqObj.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : XenosStringUtils.EMPTY_STR;
         reqObj.sortField3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : XenosStringUtils.EMPTY_STR;
         reqObj.rnd = Math.random() + "";
         
         return reqObj;
    }
        
    
    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
     private function doNext():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
        movementQueryRequest.request = reqObj;
        movementQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        movementQueryRequest.request = reqObj;
        movementQueryRequest.send();
    }   
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
     private function resetQuery():void {         
         
         movementResetQueryRequest.send();
         
         actPopUp.accountNo.editable = true;
         actPopUp.accountPopup.visible = true;
         fininstPopUp.bankCode.editable = true;
         fininstPopUp.finInstFundPopup.visible = true;    
 		 // Remove the fund code should remove bank Code and Bank Account No
 		 finInstClearState();
    }  
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * This also takes care of the buttons/images to be shown on teh top panel of the
    * result .
    */
     /*public function LoadSummaryPage(event:ResultEvent):void {
        var showNext:Boolean;
        var showPrev:Boolean;
        

        if (null != event) {            
            if(null == event.result.rows){
                summaryResult.removeAll(); // clear previous data if any as there is no result now.
                if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
                    errPage.clearError(event); //clears the errors if any
                    XenosAlert.info("No Result Found!");
                } else { // Must be error
                    errPage.displayError(event);    
                }                
            }else {
                errPage.clearError(event);                
                summaryResult.removeAll();
                if(event.result.rows.row != null){   
                    if(event.result.rows.row is ArrayCollection) {
                            summaryResult = event.result.rows.row as ArrayCollection;
                    } else {                            
                            summaryResult.addItem(event.result.rows.row);
                    }
                    changeCurrentState();
                }else{                    
                    XenosAlert.info("No Results Found");
                }                 
                
                //changeCurrentState();
                qh.setOnResultVisibility();
                qh.setPrevNextVisibility(Boolean(event.result.rows.prevTraversable),Boolean(event.result.rows.nextTraversable));
                qh.PopulateDefaultVisibleColumns();
                qh.xls.enabled = false;
            }
            //refresh the results.
            summaryResult.refresh(); 
        }else {
            summaryResult.removeAll();
            XenosAlert.info("No Results Found");
        } 
               
    }*/
    
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * This also takes care of the buttons/images to be shown on teh top panel of the
    * result .
    */
    public function LoadSummaryPage(event:ResultEvent):void {
    	
    	var rs:XML = XML(event.result);
    	
    	if (null != event) {
			
			if (rs.child("row").length()>0) {
				errPage.clearError(event);
	            summaryResult.removeAll();
				try {
				    for each ( var rec:XML in rs.row ) {
	 				    summaryResult.addItem(rec);
				    }
				    
				    changeCurrentState();
		            qh.setOnResultVisibility();
		            
		            qh.setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
		            qh.PopulateDefaultVisibleColumns();
	     	        //replace null objects in datagrid with empty string
	            	summaryResult=ProcessResultUtil.process(summaryResult, movementSummary.columns);
	            	summaryResult.refresh();
				} catch(e:Error) {
				    //XenosAlert.error(e.toString() + e.message);
				    XenosAlert.error("No result found");
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
			 	XenosAlert.info("No Result Found!");
			 	summaryResult.removeAll(); // clear previous data if any as there is no result now.
			 	errPage.removeError(); //clears the errors if any
			 }
			 
        }
    }

    /**
    * This is called at creationComplete of the module
    */
     private function loadAll():void {
        var title:String = "Cash Movement Query"
        if(title!= null) {
        	this.parentDocument.title = title;
        }
     } 
 
	/**
 	 * This will clear the Bank Code Control and 
 	 * make it editable again
 	 */
 	private function finInstClearState():void {
 		
 		fininstPopUp.bankCode.text = "";
 		fininstPopUp.bankCode.editable = true;
		fininstPopUp.finInstFundPopup.visible=true;
		finContextList.removeAll();
		this.amountRangeFrom.text = XenosStringUtils.EMPTY_STR;
		this.amountRangeTo.text = XenosStringUtils.EMPTY_STR;
 	}
 	/**
 	 * This will clear the Account No Control and
 	 * make it editable again.
 	 */
 	private function accountClearState():void {
		actPopUp.accountNo.text = "";
		stlAccForFundContextList.removeAll();
		stlAccForFundContextList = populateContext();
 	}
    
    /** 
    * This is the focusOut handler of the Fund Code.
    */
 	private function inputHandler():void {
 		
 		var fundStr:String = fundPopUp.fundCode.text;
 		if (!XenosStringUtils.isBlank(fundStr)) {
 			submit.enabled = true;
 			var req :Object = new Object();
 			req.fundCode = fundStr;
 			req.method = "loadBankAndBankAccountFromFund";
 			loadBankAndBankAccountForFund.request = req;
 			loadBankAndBankAccountForFund.send();
 		} else {
 			// Remove the fund code should remove bank Code and Bank Account No
 			finInstClearState();
    		accountClearState();
			submit.enabled = true;
 		}
 	}
 	/** 
 	 * This method will populate Bank and bank Account once a Fund Code is chosen.
 	 * If multiple Banks are associated witha fundCode, then user has to select one
 	 * from the bank popup correspoding the Fund Code. If a single bank is associated
 	 * with a Fund, the bank is shown and made non-editable. If it has a single account,
 	 * account is shown and made non-editable. If multiple accounts are present, 
 	 * user has to choose one from the Account popup.
 	 */
 	private function populateBankAndBankAccount(event:ResultEvent):void{
 		
 		var rs:XML = XML(event.result);
 		
 		if (null != event) {
 			if(rs.child("Errors").length()>0){ 
				// i.e. Must be error, display it .
				var errorInfoList : ArrayCollection = new ArrayCollection();
				//populate the error info list 			 	
				for each ( var error:XML in rs.Errors.error ) {
					errorInfoList.addItem(error.toString());
				}
				errPage.showError(errorInfoList);//Display the error
	      	} else {
	      	 	errPage.removeError();
				//XenosAlert.info("XML: "+rs);
				
				if (rs.multipleBankPresent==true || rs.pageLoading == true) {
					finInstClearState();
				}
				
				if (rs.multipleBankPresent == false && rs.pageLoading == false) {
					fininstPopUp.bankCode.text = rs.bank;
					fininstPopUp.bankCode.editable = false;
                    fininstPopUp.finInstFundPopup.visible = false;
                    focusManager.setFocus(officeId);
				}
				
				if (rs.multipleBankAccountPresent==true || rs.pageLoading == true) {
					accountClearState();
                    actPopUp.fundCodeCheck = true;
				}
				
				if (rs.multipleBankAccountPresent==false && rs.pageLoading == false) {
					actPopUp.accountNo.text = rs.accountNo;
                    actPopUp.accountNo.editable = false;
                    actPopUp.accountPopup.visible = false;
				}
				
            	finContextList.removeAll();
        		fininstPopUp.bankCode.text = rs.bank;
        		actPopUp.accountNo.text = rs.accountNo;
	    		var fundArray : Array = new Array(1);
	    		fundArray[0] = fundPopUp.fundCode.text;
	    		finContextList.addItem(new HiddenObject("fundCodeContext",fundArray));
	    		stlAccForFundContextList.removeAll();
	    		var cpTypeArray:Array = new Array(1);
		        cpTypeArray[0]="BANK/CUSTODIAN";
		 		stlAccForFundContextList.addItem(new HiddenObject("cpTypeContext",cpTypeArray));
		 		var cpTypeArray1:Array = new Array(1);
		        cpTypeArray1[0]="OPEN";
		 		stlAccForFundContextList.addItem(new HiddenObject("statusContext",cpTypeArray1));
            	submit.enabled = true;
	        }
     	} else {
     		XenosAlert.info("event = null");
     	}
 	}

 	/**
 	 * This is the focus out handler of the bank Code
 	 */
 	private function bankOutHandler():void{
 		
 		var bankStr : String = fininstPopUp.bankCode.text;
 		if (!XenosStringUtils.isBlank(bankStr)) {
 			submit.enabled = true;
 			var req :Object = new Object();
 			req.method = "loadBankAccountFromBank";
 			req.fundCode = fundPopUp.fundCode.text;
 			req.bank = bankStr;
 			loadBankAccount.request = req;
 			loadBankAccount.send();
 		} else {
 			// Remove the bank code should remove Bank Account No
 			accountClearState();
    		submit.enabled = true;
 		}
 	}

  	/**
 	 * If a bank is given, search is done for the bank accounts.
 	 * If single account is found, populate it.
 	 * If multiple accounts are present, user has to choose one from the Account popup.
 	 */
 	private function populateBankAccount(event:ResultEvent):void {
 		
 		var rs:XML = XML(event.result);
 		if (null != event) {
 			if (null == event.result.recCashMovementActionForm) { 
     			if (null == event.result.XenosErrors) { // i.e. No result but no Error found.
	           		errPage.clearError(event); //clears the errors if any
	           	} else { // Must be error
	      			errPage.displayError(event);
	      		}
	      	} else {
	      	 	errPage.clearError(event);
	      	 	queryResult = event.result.recCashMovementActionForm as Object;
	      	 	
	      	 	if (rs.multipleBankAccountPresent==true || rs.pageLoading == true) {
                    accountClearState();
                    actPopUp.fundCodeCheck = true;
                }
	      	 	if (rs.multipleBankAccountPresent==false && rs.pageLoading == false) {
        		    actPopUp.accountNo.text = rs.accountNo;
                    actPopUp.accountNo.editable = false;
                    actPopUp.accountNo.visible = false;
                }
	      	 	
    			stlAccForFundContextList.removeAll();
    			var cpTypeArray:Array = new Array(1);
		        cpTypeArray[0]="BANK/CUSTODIAN";
		 		stlAccForFundContextList.addItem(new HiddenObject("cpTypeContext",cpTypeArray));
		 		var cpTypeArray1:Array = new Array(1);
		        cpTypeArray1[0]="OPEN";
		 		stlAccForFundContextList.addItem(new HiddenObject("statusContext",cpTypeArray1));	
            	submit.enabled = true;
		    }
     	} else {
     		XenosAlert.info("event = null");
 		}
 	}

    
     /**
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specifdic  
      * requriment. 
      */
    private function populateContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
      
        //passing counter party type                
        var cpTypeArray:Array = new Array(2);
            cpTypeArray[0]="BANK/CUSTODIAN";
            cpTypeArray[1]="BROKER";
            
        myContextList.addItem(new HiddenObject("cpTypeContext",cpTypeArray));
    
        //passing account status                
        var actStatusArray:Array = new Array(1);
        actStatusArray[0]="OPEN";
        myContextList.addItem(new HiddenObject("statusContext",actStatusArray));
        return myContextList;
    }
     /**
     * 
     * */                   
     public function dispReturnContext(retCtxItem:ArrayCollection):void {           
       
        // This is sample implemetation
        XenosAlert.info("dispReturnContext CAM MOVEMENT QUERY");
    
        for (var i:int = 0; i<retCtxItem.length; i++){
            
            XenosAlert.info("index :: "+ i);
            
            var itemObject:HiddenObject;
            
            itemObject = HiddenObject (retCtxItem.getItemAt(i));
            
            XenosAlert.info("hidden property :: "+ itemObject.m_propertyName );
            
            var propertyValues:Array = itemObject.m_propertyValues;
            
            for (var j:int = 0; j<propertyValues.length; j++){
                XenosAlert.info("hidden values :: " + propertyValues[j]);
            }
        }           
	}
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
        var url : String = "rec/recCashMovementDispatch.action?method=generateXLS&forReport=Y";
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
        // set menu pk in the request
      	var variables:URLVariables = new URLVariables();
      	variables.menuPk = this.parentApplication.mdiCanvas.getwindowKey();
      	request.data = variables;
         try {
                navigateToURL(request,"_blank");
            }
            catch (e:Error) {
                // handle error here
                trace(e);
            }
    } 
    /**
    * This will generate the Pdf report for the entire query result set 
    * and will open in a separate window.
    */
     private function generatePdf():void {
        var url : String = "rec/recCashMovementDispatch.action?method=generatePDF&forReport=Y";
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
        // set menu pk in the request
      	var variables:URLVariables = new URLVariables();
      	variables.menuPk = this.parentApplication.mdiCanvas.getwindowKey();
      	request.data = variables;
         try {
                navigateToURL(request,"_blank");
            }
            catch (e:Error) {
                // handle error here
                trace(e);
            }
    } 
    /**
    * This is for the Print button which at a  time will print all the data 
    * in the dataprovider of the Datagrid object
    */
     private function doPrint():void{
        /* var printObject:XenosPrintView = new XenosPrintView();
        printObject.frmPrintHeader.lbl.text = "Cam Movement Query";
        printObject.pDataGrid.dataProvider = movementSummary.dataProvider;
        PrintDG.printAll(printObject); */
    }
    
  	/**
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specifdic  
      * requriment. 
      */
    private function populatefinRoleContext():ArrayCollection {
    	//pass the context data to the popup   	
        var finRoleArray:Array = new Array(1);
        finRoleArray[0]="Bank/Custodian";
 		finContextList.addItem(new HiddenObject("finRoleContext",finRoleArray));
        return finContextList;
    }   

