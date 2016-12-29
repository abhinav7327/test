




 // ActionScript file for Cash Refer Raw File Query
 	import com.nri.rui.core.Globals;
 	import com.nri.rui.core.controls.CustomizeSortOrder;
 	import com.nri.rui.core.controls.XenosAlert;
 	import com.nri.rui.core.startup.XenosApplication;
 	import com.nri.rui.core.utils.HiddenObject;
 	import com.nri.rui.core.utils.ProcessResultUtil;
 	import com.nri.rui.rec.renderers.CashSwiftFileViewRenderer;
 	import com.nri.rui.rec.renderers.RawFileCancelRenderer;
 	import com.nri.rui.rec.validators.ReferRawFileValidator;
 	
 	import mx.collections.ArrayCollection;
 	import mx.events.ValidationResultEvent;
 	import mx.rpc.events.ResultEvent;
    
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
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
 	private var finContextList:ArrayCollection = new ArrayCollection();
    private var tempColl:ArrayCollection;
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    [Bindable]
    public var returnFinContext:ArrayCollection = new ArrayCollection();
    [Bindable]
 	private var stlAccForFundContextList:ArrayCollection = populateContext();
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    
    private var  csd:CustomizeSortOrder=null;
    private var sortUtil:ProcessResultUtil= new ProcessResultUtil();
    [Bindable]   
    public var actionType : String = "query";
    /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
        qh.dgrid = resultSummary;
    } 
    
    /**
     * Loading the initial configuaration.
     * 
     */
    private function loadAll():void {
    }
    
    
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    private function initPageStart():void {            
        if (!initCompFlg) {        	  
        	rcvdDateFrom.setFocus();
     		parseUrlString();
            rndNo= Math.random();
            var initReqObj : Object = new Object();
            //initReqObj.SCREEN_KEY = 10112;
            initializeCashRawQuery.request = initReqObj;   
            if(XenosStringUtils.equals(actionType,"cancel")){   
            	initializeCashRawQuery.url = "rec/cashReferRawCancelDispatch.action?method=initialExecute&actionType="+"cancel"+"&rnd=" + rndNo;
            	initReqObj.SCREEN_KEY = 11067;
            } else {
	            initializeCashRawQuery.url = "rec/cashReferRawDispatch.action?method=initialExecute&rnd=" + rndNo;
	            initReqObj.SCREEN_KEY = 10112;                    	                 
            }       
            //initializeCashRawQuery.url = "rec/cashReferRawDispatch.action?method=initialExecute&rnd=" + rndNo;                    
            initializeCashRawQuery.send();        
        } else
            XenosAlert.info("Already Initiated!");
    }
    /**
    * Parsing the URL for actionType  
    * 
    */    
    private function parseUrlString():void {
        try {
            // Remove everything before the question mark, including
            // the question mark.
            var myPattern:RegExp = /.*\?/; 
            var s:String = this.loaderInfo.url.toString();
            s = s.replace(myPattern, "");
            // Create an Array of name=value Strings.
            var params:Array = s.split("&"); 
             // Print the params that are in the Array.
            var keyStr:String;
            var valueStr:String;
            var paramObj:Object = params;
          
            // Set the values of the salutation.
            for (var i:int = 0; i < params.length; i++) {
                var tempA:Array = params[i].split("=");  
                if (tempA[0] == "actionType") {
                    actionType = tempA[1];
                } 
            }            
			
        } catch (e:Error) {
            trace(e);
        }
       
    }
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * 
    */   
    private function initPage(event: ResultEvent) : void {
        
		var i:int = 0;
     	var dateStr:String = null;
        var initColl:ArrayCollection = new ArrayCollection();
        var tempColl: ArrayCollection;
        var selIndx:int = 0;
        
        //variables to hold the default values from the server
        var sortField1Default:String = "receiveddate";
        var sortField2Default:String = "fundcode";
        var sortField3Default:String = "trnrefno";
        var sortField4Default:String = "currencycode";
       
        errPage.clearError(event); //clears the errors if any 
        
        this.resetFormValues();
        
        //6. Setting values of the SortField1
        initColl.removeAll();
        if(null != event.result.cashRawFileActionForm.sortFieldList1.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        
        	if(event.result.cashRawFileActionForm.sortFieldList1.item is ArrayCollection)
                initColl = event.result.cashRawFileActionForm.sortFieldList1.item as ArrayCollection;
            else
                initColl.addItem(event.result.cashRawFileActionForm.sortFieldList1.item);
            
	        for(i = 0; i<initColl.length; i++) {
	        	
               //XenosAlert.info(initColl[i].value);
               tempColl.addItem(initColl[i]);            
	        }
	        //sortField1.dataProvider = tempColl;
	        sortFieldArray[0]=sortField1;
	        sortFieldDataSet[0]=tempColl;
	        //Set the default value object
	        sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
	        
        } else {
        	XenosAlert.error("Sort Order Field List 1 not Populated");
        }
     	
     	
     	//7. Setting values of the SortField2
        initColl.removeAll();
        if(null != event.result.cashRawFileActionForm.sortFieldList2.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        
        	if(event.result.cashRawFileActionForm.sortFieldList2.item is ArrayCollection)
                initColl = event.result.cashRawFileActionForm.sortFieldList2.item as ArrayCollection;
            else
                initColl.addItem(event.result.cashRawFileActionForm.sortFieldList2.item);
                
	        for(i = 0; i<initColl.length; i++) {
	           //XenosAlert.info(initColl[i].value);
	           if(XenosStringUtils.equals((initColl[i].value),sortField2Default)){                    
                    selIndx = i;
                }
	           tempColl.addItem(initColl[i]);            
	        }
	        //sortField2.dataProvider = tempColl;
	        sortFieldArray[1]=sortField2;
	        sortFieldDataSet[1]=tempColl;
	        //Set the default value object
	        sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);
	        
        } else {
        	XenosAlert.error("Sort Order Field List 2 not Populated");
        }
     	
     	
     	//8. Setting values of the SortField3
        initColl.removeAll();
        if(null != event.result.cashRawFileActionForm.sortFieldList3.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        
        	if(event.result.cashRawFileActionForm.sortFieldList3.item is ArrayCollection)
                initColl = event.result.cashRawFileActionForm.sortFieldList3.item as ArrayCollection;
            else
                initColl.addItem(event.result.cashRawFileActionForm.sortFieldList3.item);
                
	        for(i = 0; i<initColl.length; i++) {
	           //XenosAlert.info(initColl[i].value);
	           if(XenosStringUtils.equals((initColl[i].value),sortField3Default)){                    
                    selIndx = i;
                }
	           tempColl.addItem(initColl[i]);            
	        }
	        //sortField3.dataProvider = tempColl;
	        sortFieldArray[2]=sortField3;
	        sortFieldDataSet[2]=tempColl;
	        //Set the default value object
	        sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx+1);
	        
        } else {
        	XenosAlert.error("Sort Order Field List 3 not Populated");
        }
        
        
        //9. Setting values of the SortField4
        initColl.removeAll();
        if(null != event.result.cashRawFileActionForm.sortFieldList4.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        
        	if(event.result.cashRawFileActionForm.sortFieldList4.item is ArrayCollection)
                initColl = event.result.cashRawFileActionForm.sortFieldList4.item as ArrayCollection;
            else
                initColl.addItem(event.result.cashRawFileActionForm.sortFieldList4.item);
                
	        for(i = 0; i<initColl.length; i++) {
	           //XenosAlert.info(initColl[i].value);
	           if(XenosStringUtils.equals((initColl[i].value),sortField4Default)){                    
                    selIndx = i;
                }
	           tempColl.addItem(initColl[i]);            
	        }
	        //sortField4.dataProvider = tempColl;
	        sortFieldArray[3]=sortField4;
	        sortFieldDataSet[3]=tempColl;
	        //Set the default value object
	        sortFieldSelectedItem[3] = tempColl.getItemAt(selIndx+1);
	        
        } else {
        	XenosAlert.error("Sort Order Field List 4 not Populated");
        }
        
        csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
        csd.init();
        
        addColumn();
    }
    private function addColumn():void
      {
      	var cols :Array = resultSummary.columns;
      	cols.pop();
      	cols.pop();
      	
      	var dg :DataGridColumn = new DataGridColumn();
		dg.dataField="";
		dg.editable = false;
		dg.headerText = this.parentApplication.xResourceManager.getKeyValue('rec.rcvd.data.label.imageFile');
		dg.width = 140;
		dg.itemRenderer = new RendererFectory(CashSwiftFileViewRenderer,this.actionType);
		cols.push(dg);
		
		var dgCancelStatus :DataGridColumn = new DataGridColumn();
		dgCancelStatus.dataField="cancelStatus";
		dgCancelStatus.editable = false;
		dgCancelStatus.headerText = "";
		dgCancelStatus.width = 40;
		dgCancelStatus.itemRenderer = new RendererFectory(RawFileCancelRenderer);
		
		//var cols :Array = resultSummary.columns;
		cols.push(dgCancelStatus);
		resultSummary.columns = cols;
	  }
    
    /**
     *  This method resets all the values in the form.
     */
     private function resetFormValues():void {
     	finInstPopUp.recContextItem.removeAll();
     	//initiate text fields
        rcvdDateFrom.text = "";
        rcvdDateTo.text = "";
        fundPopUp.fundCode.text = "";
        finInstPopUp.bankCode.text = "";
        actPopUp.accountNo.text = "";
        transactionReferenceNo.text = "";
        ccyBox.ccyText.text = "";
        rcvdDateFrom.setFocus();
     }
    
    /**
    * It sends/submits the query. 
    * 
    */
     private function submitQuery():void 
    {  
        //Reset Page No
    	 qh.resetPageNo(); 
        //Set the request parameters
         var requestObj :Object = populateRequestParams();
         
         cashRawQueryRequest.request = requestObj; 
        
         var referRawFileModel:Object={
                            ReferRaw:{
                                 rcvdDateFrom: this.rcvdDateFrom.text,
                                 rcvdDateTo: this.rcvdDateTo.text
                            }
                           }; 
        var referRawFileValidator:ReferRawFileValidator = new ReferRawFileValidator();
        referRawFileValidator.source=referRawFileModel;
        referRawFileValidator.property="ReferRaw";
        
        var validationResult:ValidationResultEvent =referRawFileValidator.validate();

        if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            //trace(errorMsg);
            XenosAlert.error(errorMsg);
            resultHead.text = "";
        }else {         	
            if(XenosStringUtils.equals(actionType,"cancel")){   
            	status.visible = false;
            	cashRawQueryRequest.url = "rec/cashReferRawCancelDispatch.action";
            }
            cashRawQueryRequest.send();
        }
        
    } 
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
     private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        
        reqObj.method = "submitQuery";         
        
        reqObj.receivedDateFrom = this.rcvdDateFrom.text;
     	reqObj.receivedDateTo = this.rcvdDateTo.text;
     	reqObj.fundCode = this.fundPopUp.fundCode.text;
     	reqObj.bank = this.finInstPopUp.bankCode.text;
     	reqObj.accountNo = this.actPopUp.accountNo.text;
     	reqObj.transactionReferenceNo = this.transactionReferenceNo.text;
        reqObj.currency = this.ccyBox.ccyText.text;
        
        reqObj.sortField1 = (this.sortField1.selectedItem != null ? this.sortField1.selectedItem.value : "");
     	reqObj.sortField2 = (this.sortField2.selectedItem != null ? this.sortField2.selectedItem.value : "");
     	reqObj.sortField3 = (this.sortField3.selectedItem != null ? this.sortField3.selectedItem.value : "");
     	reqObj.sortField4 = (this.sortField4.selectedItem != null ? this.sortField4.selectedItem.value : "");
        
        reqObj.rnd = Math.random() + "";
        //reqObj.SCREEN_KEY = 10113; 
        if(XenosStringUtils.equals(actionType,"cancel")){   
            reqObj.SCREEN_KEY = 11068;
        } else {
            reqObj.SCREEN_KEY = 10113;                    	                 
        }       
        
        return reqObj;
    }
    
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
    private function resetQuery():void {
    	if(XenosStringUtils.equals(actionType,"cancel")){
    		cashRawResetQueryRequest.url = "rec/cashReferRawCancelDispatch.action?method=resetQuery";
    	}
         cashRawResetQueryRequest.send();
         
         actPopUp.accountNo.editable = true;
         actPopUp.accountPopup.visible = true;
         finInstPopUp.bankCode.editable = true;
         finInstPopUp.finInstFundPopup.visible = true;    
 		 // Remove the fund code should remove bank Code and Bank Account No
 		 finInstClearState();
    }
    
    private function sortOrder1Update():void{
     	 //XenosAlert.info(sortField1.selectedItem.value);
     	 csd.update(sortField1.selectedItem,0);
     }
     
     private function sortOrder2Update():void{     	
     	//XenosAlert.info(sortField2.selectedItem.value);
     	csd.update(sortField2.selectedItem,1);
     }
     
     private function sortOrder3Update():void{     	
     	//XenosAlert.info(sortField3.selectedItem.value);
     	csd.update(sortField3.selectedItem,2);
     }
   
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    private function loadSummaryPage(event:ResultEvent):void {
		
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
	                qh.pdf.visible = false;
	                qh.xls.visible = false;
	     	        //replace null objects in datagrid with empty string
	            	summaryResult=ProcessResultUtil.process(summaryResult, resultSummary.columns);
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
 	 * This will clear the Bank Code Control and 
 	 * make it editable again
 	 */
 	private function finInstClearState():void {
 		
 		finInstPopUp.bankCode.text = "";
 		finInstPopUp.bankCode.editable = true;
		finInstPopUp.finInstFundPopup.visible = true;
		finContextList.removeAll();
 	}
 	/**
 	 * This will clear the Account No Control and
 	 * make it editable again.
 	 */
 	private function accountClearState():void {
		actPopUp.accountNo.text = "";
		actPopUp.accountNo.editable = true;
		actPopUp.accountPopup.visible = true;
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
 			if(XenosStringUtils.equals(actionType,"cancel")){
    			loadBankAndBankAccountForFund.url = "rec/cashReferRawCancelDispatch.action";
    		}
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
 	private function populateBankAndBankAccount(event:ResultEvent):void {
 		
 		var rs:XML = XML(event.result);
 		
 		if (null != event) {
 			if(rs.child("Errors").length()>0) { 
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
					finInstPopUp.bankCode.text = rs.bank;
					finInstPopUp.bankCode.editable = false;
                    finInstPopUp.finInstFundPopup.visible=false;
                    focusManager.setFocus(transactionReferenceNo);
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
        		finInstPopUp.bankCode.text = rs.bank;
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
		 		var actStatusArray:Array = new Array(2);
		        actStatusArray[0]="S";
		        actStatusArray[1]="B";
		        stlAccForFundContextList.addItem(new HiddenObject("actTypeContext",actStatusArray));
            	submit.enabled = true;
	        }
     	} else {
     		XenosAlert.info("event = null");
     	}
 	}

 	/**
 	 * This is the focus out handler of the bank Code
 	 *
 	private function bankOutHandler():void {
 		
 		var bankStr : String = finInstPopUp.bankCode.text;
 		if (!XenosStringUtils.isBlank(bankStr)) {
 			submit.enabled = true;
 			var req :Object = new Object();
 			req.method = "loadBankAccountFromBank";
 			req.fundCode = fundPopUp.fundCode.text;
 			req.bank = bankStr;
 			loadBankAccount.request = req;
 			if(XenosStringUtils.equals(actionType,"cancel")){
    			loadBankAccount.url = "rec/cashReferRawCancelDispatch.action";
    		}
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
 	 *
 	private function populateBankAccount(event:ResultEvent):void {
 		
 		var rs:XML = XML(event.result);
 		
 		if (null != event) {
 			if (null == event.result.cashRawFileActionForm) { 
     			if (null == event.result.XenosErrors) { // i.e. No result but no Error found.
	           		errPage.clearError(event); //clears the errors if any
	           	} else { // Must be error
	      			errPage.displayError(event);
	      		}
	      	} else {
	      	 	errPage.clearError(event);
	      	 	queryResult = event.result.cashRawFileActionForm as Object;
	      	 	
	      	 	if (rs.multipleBankAccountPresent==true || rs.pageLoading == true) {
                    accountClearState();
                    actPopUp.fundCodeCheck = true;
                }
	      	 	if (rs.multipleBankAccountPresent==false && rs.pageLoading == false) {
        		    actPopUp.accountNo.text = rs.accountNo;
                    actPopUp.accountNo.editable = false;
                    actPopUp.accountPopup.visible = false;
                }
                
    			stlAccForFundContextList.removeAll();
    			var cpTypeArray:Array = new Array(1);
		        cpTypeArray[0]="BANK/CUSTODIAN";
		 		stlAccForFundContextList.addItem(new HiddenObject("cpTypeContext",cpTypeArray));
		 		var cpTypeArray1:Array = new Array(1);
		        cpTypeArray1[0]="OPEN";
		 		stlAccForFundContextList.addItem(new HiddenObject("statusContext",cpTypeArray1));
		 		var actStatusArray:Array = new Array(2);
		        actStatusArray[0]="S";
		        actStatusArray[1]="B";
		        stlAccForFundContextList.addItem(new HiddenObject("actTypeContext",actStatusArray));	
            	submit.enabled = true;
		    }
     	} else {
     		XenosAlert.info("event = null");
 		}
 	}
	*/
    
    /**
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specifdic  
      * requriment. 
      */
    private function populateContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
      
        //passing counter party type                
        var cpTypeArray:Array = new Array(1);
        cpTypeArray[0]="BANK/CUSTODIAN";
        myContextList.addItem(new HiddenObject("cpTypeContext",cpTypeArray));
    
        //passing account status 
        var actStatus:Array = new Array(1);
        actStatus[0]="OPEN";
        myContextList.addItem(new HiddenObject("statusContext",actStatus));
                       
        var actStatusArray:Array = new Array(2);
        actStatusArray[0]="S";
        actStatusArray[1]="B";
        myContextList.addItem(new HiddenObject("actTypeContext",actStatusArray));
        return myContextList;
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
    
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
        /* var url : String = "rec/cashReferRawDispatch.action?method=generateXLS";
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
         try {
                navigateToURL(request,"_blank");
            }
            catch (e:Error) {
                // handle error here
                trace(e);
            } */
    } 
    /**
    * This will generate the Pdf report for the entire query result set 
    * and will open in a separate window.
    */
     private function generatePdf():void {
       /*  var url : String = "rec/cashReferRawDispatch.action?method=generatePDF";
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
         try {
                navigateToURL(request,"_blank");
            }
            catch (e:Error) {
                // handle error here
                trace(e);
            } */
    } 
    /**
    * This is for the Print button which at a  time will print all the data 
    * in the dataprovider of the Datagrid object
    */
     private function doPrint():void{
       	/*var printObject:XenosPrintView = new XenosPrintView();
        printObject.frmPrintHeader.lbl.text = "Cam Movement Query";
        printObject.pDataGrid.dataProvider = movementSummary.dataProvider;
        PrintDG.printAll(printObject); */
    }
    
    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
      private function doNext():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
        if(XenosStringUtils.equals(actionType,"cancel")){
    		cashRawQueryRequest.url = "rec/cashReferRawCancelDispatch.action";
    	}
        cashRawQueryRequest.request = reqObj;
        cashRawQueryRequest.send();
    }  
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
      private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        if(XenosStringUtils.equals(actionType,"cancel")){
    		cashRawQueryRequest.url = "rec/cashReferRawCancelDispatch.action";
    	}
        cashRawQueryRequest.request = reqObj;
        cashRawQueryRequest.send();
    }
     /**
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specific  
      * requriment. 
      */
    private function populateCpContext():ArrayCollection {
    	//pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
 		var cpTypeArray:Array = new Array(2);
        cpTypeArray[0]="BANK/CUSTODIAN";
        cpTypeArray[1]="BROKER";
 		myContextList.addItem(new HiddenObject("cpCPTypeContext",cpTypeArray));
 		var cpTypeArray1:Array = new Array(1);
        cpTypeArray1[0]="OPEN";
 		myContextList.addItem(new HiddenObject("actStatusContext",cpTypeArray1));
        return myContextList;
    }   