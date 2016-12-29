
 // ActionScript file for Cash Refer Raw File Query
 	import com.nri.rui.core.Globals;
 	import com.nri.rui.core.controls.CustomizeSortOrder;
 	import com.nri.rui.core.controls.XenosAlert;
 	import com.nri.rui.core.startup.XenosApplication;
 	import com.nri.rui.core.utils.DateUtils;
 	import com.nri.rui.core.utils.HiddenObject;
 	import com.nri.rui.core.utils.ProcessResultUtil;
 	import com.nri.rui.rec.validators.CashReferResultsQueryValidator;
 	
 	import mx.collections.ArrayCollection;
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
    private var queryResult:ArrayCollection= new ArrayCollection();
    [Bindable]
    private var queryResult1:Object= new Object();
    private var emptyResult:ArrayCollection= new ArrayCollection();
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    
    private var tempColl:ArrayCollection;
    
    [Bindable]
 	private var finContextList:ArrayCollection = new ArrayCollection();
 	[Bindable]
 	private var stlAccForFundContextList:ArrayCollection = populateCtx();
    
    [Bindable]
    public var returnFinContext:ArrayCollection = new ArrayCollection();
    
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
            
    [Bindable]
    private var objForm1:Object = null;
    [Bindable]
    public var pdfXlsFlag:Boolean = false;
    [Bindable]
    private var rs:XML = new XML();
    
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    
    private var  csd:CustomizeSortOrder=null;
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
        	dateFrom.setFocus();
            //rndNo= Math.random(); 
            var initReqObj : Object = new Object();
            initReqObj.SCREEN_KEY = 10096;
            initCashReferResultsQuery.request = initReqObj;
            initCashReferResultsQuery.url = "rec/cashReferResultDispatch.action?method=initialExecute&mode=NCMCUST";                    
            initCashReferResultsQuery.send();        
        } else {
            XenosAlert.info("Already Initiated!");
        }
    }
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * 
    */   
    private function initPage(event: ResultEvent) : void {
        var i:int = 0;
        var selIndx:int = 0;
        var dateStrFrom:String;//="";
        var dateStrTo:String;//="";
        
        errPage.clearError(event); //clears the errors if any 
        
        //initiate text fields
        fundPopUp.fundCode.text = "";
        stlAccForFundPopUp.accountNo.text = "";
        fininstPopUp.bankCode.text = "";
        ccyBox.ccyText.text = "";
        dateFrom.setFocus();
        submit.enabled = true;
        chkbox1.selected = true;
        
        queryResult.removeAll(); // clear previous data if any as there is no result now.
        queryResult.refresh();
        
        // sort order
        
         //variables to hold the default values from the server
        var sortField1Default:String = event.result.recCashReferResultActionForm.sortField1;
        var sortField2Default:String = event.result.recCashReferResultActionForm.sortField2;
        
         if(null != event.result.recCashReferResultActionForm.sortFieldList1.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        	
        	if(event.result.recCashReferResultActionForm.sortFieldList1.item is ArrayCollection)
                initColl = event.result.recCashReferResultActionForm.sortFieldList1.item as ArrayCollection;
            else
                initColl.addItem(event.result.recCashReferResultActionForm.sortFieldList1.item);
        	
	        for(i = 0; i<initColl.length; i++) {
	        	//Get the default value object's index
                if(XenosStringUtils.equals((initColl[i].value),sortField1Default)){                    
                    selIndx = i;
                }
	        	
	           tempColl.addItem(initColl[i]);            
	        }
	        //sortField1.dataProvider = tempColl;
        	//XenosAlert.error("Sort Order Field List :"+sortField1Default);
	        
	        sortFieldArray[0]=sortField1;
	        sortFieldDataSet[0]=tempColl;
	        //Set the default value object
	        sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
	        
        } else {
        	XenosAlert.error("Sort Order Field List 1 not Populated");
        }
        //5. Setting values of the SortField2 
        initColl.removeAll();
        if(null != event.result.recCashReferResultActionForm.sortFieldList2.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        
        	if(event.result.recCashReferResultActionForm.sortFieldList2.item is ArrayCollection)
                initColl = event.result.recCashReferResultActionForm.sortFieldList2.item as ArrayCollection;
            else
                initColl.addItem(event.result.recCashReferResultActionForm.sortFieldList2.item);
                
	        for(i = 0; i<initColl.length; i++) {
	        	if(XenosStringUtils.equals((initColl[i].value),sortField2Default)){                    
                    selIndx = i;
                }
	        	
	           tempColl.addItem(initColl[i]);            
	        }
	        //sortField2.dataProvider = tempColl;
	        
        	//XenosAlert.error("Sort Order Field List :"+sortField2Default);
	        sortFieldArray[1]=sortField2;
	        sortFieldDataSet[1]=tempColl;
	        //Set the default value object
	        sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);
	        
        } else {
        	XenosAlert.error("Sort Order Field List 2 not Populated");
        }
        
        csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
        csd.init();
        //Setting dateFrom and dateTo
        if(event.result.recCashReferResultActionForm.asOfDateFrom!= null) {
            dateStrFrom=event.result.recCashReferResultActionForm.asOfDateFrom;
               // XenosAlert.info("from date :"+dateStr);
            if(dateStrFrom != null)
                dateFrom.selectedDate = DateUtils.toDate(dateStrFrom);
        } else {
            XenosAlert.error("Error: From Date cannot be initialized.");
        }
        if(event.result.recCashReferResultActionForm.asOfDateTo!= null) {
            dateStrTo=event.result.recCashReferResultActionForm.asOfDateTo;
                //XenosAlert.info("to date :"+dateStr);
            if(dateStrTo != null)
                dateTo.selectedDate = DateUtils.toDate(dateStrTo);
        } else {
            XenosAlert.error("Error: To Date cannot be initialized.");
        }
           if(event.result){        	
        	if(event.result.recCashReferResultActionForm.serviceOfficeValues.serviceOffice is ArrayCollection){
    		initColl = event.result.recCashReferResultActionForm.serviceOfficeValues.serviceOffice as ArrayCollection;        		
        	}else{
        		initColl = new ArrayCollection();
        		initColl.addItem(event.result.recCashReferResultActionForm.serviceOfficeValues.serviceOffice);
        	}
        }
        //populate office id list
		tempColl = new ArrayCollection();    
		tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        serviceOffice.dataProvider = tempColl;
        initColl.removeAll();
        if(event.result)    		
    		initColl = event.result.recCashReferResultActionForm.matchStatus.item as ArrayCollection;
    	//populate match status list
		tempColl = new ArrayCollection();    		
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        matchStatus.dataProvider = tempColl;
        initColl.removeAll();
        if(event.result)    		
    		initColl = event.result.recCashReferResultActionForm.movementMatchStatusValues.item as ArrayCollection;
    	//populate match status list
		tempColl = new ArrayCollection();    		
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        movMatchStatus.dataProvider = tempColl;
        
        /**
        * Setting values of the Account Status
        * Options---BLANK/OPEN/CLOSE 
        */ 
        initColl.removeAll();
        if(event.result.recCashReferResultActionForm.accntStatusList.item != null){
            
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
        
            if(event.result.recCashReferResultActionForm.accntStatusList.item is ArrayCollection){
                initColl = event.result.recCashReferResultActionForm.accntStatusList.item as ArrayCollection;
            }else{
                initColl.addItem(event.result.recCashReferResultActionForm.accntStatusList.item);
            }
            for(i = 0; i<initColl.length; i++) {
               tempColl.addItem(initColl[i]);            
            }
            accountStatus.dataProvider = tempColl;
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.load.accstatuslist'));
        }
        
    } 
    
    private function sortOrder1Update():void{
     	 //XenosAlert.info(sortField1.selectedItem.value);
     	 csd.update(sortField1.selectedItem,0);
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
         
         cashReferResultsQueryRequest.request = requestObj; 
        
         var referResultsModel:Object={
                            ReferResults:{
                                 toDate:this.dateTo.text,
                                 fromDate:this.dateFrom.text       
                            }
                           }; 
        var cashReferResultsQueryValidator:CashReferResultsQueryValidator = new CashReferResultsQueryValidator();
        cashReferResultsQueryValidator.source=referResultsModel;
        cashReferResultsQueryValidator.property="ReferResults";
        
        var validationResult:ValidationResultEvent =cashReferResultsQueryValidator.validate();

        if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            //trace(errorMsg);
            XenosAlert.error(errorMsg);
            resultHead.text = "";
        }else { 
        	pdfXlsFlag = false;
            cashReferResultsQueryRequest.send();
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
        reqObj.asOfDateFrom = this.dateFrom.text;
        reqObj.asOfDateTo = this.dateTo.text;        
        reqObj.bank = fininstPopUp.bankCode.text;
        reqObj.fundCodeQry = fundPopUp.fundCode.text;
        reqObj.serviceOffice =  (this.serviceOffice.selectedItem != null ? this.serviceOffice.selectedItem.value : "");
        reqObj.matchStatus = (this.matchStatus.selectedItem != null ? this.matchStatus.selectedItem.value : "");        
        reqObj.movementMatchStatus = (this.movMatchStatus.selectedItem != null ? this.movMatchStatus.selectedItem.value : "");        
        reqObj.accountNo = this.stlAccForFundPopUp.accountNo.text;    
        reqObj.currencyCode = this.ccyBox.ccyText.text;    
        reqObj.fromPage = "query"; 
        reqObj.accountStatus = (this.accountStatus.selectedItem != null ? this.accountStatus.selectedItem.value : "");
        
        reqObj.sortOrder1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : XenosStringUtils.EMPTY_STR;
     	reqObj.sortOrder2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.traversableIndex = "1";
        reqObj.rnd = Math.random() + "";
        reqObj.SCREEN_KEY = 10097;
        
        return reqObj;
    }
    
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
    private function resetQuery():void { 
         cashReferResultsResetQueryRequest.send();
         
         stlAccForFundPopUp.accountNo.editable = true;
         stlAccForFundPopUp.accountPopup.visible = true;
         fininstPopUp.bankCode.editable = true;
         fininstPopUp.finInstFundPopup.visible = true;         
 		 // Remove the fund code should remove bank Code and Bank Account No
 		 finInstClearState();
    }
    
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
     public function loadSummaryPage(event:ResultEvent):void {
     	
		//var rs:XML = XML(event.result);
		rs = XML(event.result);
        //XenosAlert.info("RS :" + rs);
		if (null != event) {
			if(rs.child("resultView1List").resultView1.length()>0) {
				errPage.clearError(event);
	            queryResult.removeAll();
				try {
				    for each ( var rec:XML in rs.resultView1List.resultView1 ) {
	 				    queryResult.addItem(rec);
				    }
				    addOriginalRowNums();
				    changeCurrentState();
		            qh.setOnResultVisibility();
		            
		            qh.setPrevNextVisibility((rs.previousTraversable1 == "true")?true:false,(rs.nextTraversable1 == "true")?true:false );
		            qh.PopulateDefaultVisibleColumns();
	     	        //replace null objects in datagrid with empty string
	            	queryResult=ProcessResultUtil.process(queryResult, resultSummary.columns);
	            	queryResult.refresh();
	            	
				}catch(e:Error){
				    //XenosAlert.error(e.toString() + e.message);
				    XenosAlert.error("No result found");
			    }
			} else if(rs.child("Errors").length()>0) {
                //some error found
			 	queryResult.removeAll(); // clear previous data if any as there is no result now.
			 	var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list 			 	
			 	for each ( var error:XML in rs.Errors.error ) {
	 			   errorInfoList.addItem(error.toString());
				}
			 	errPage.showError(errorInfoList);//Display the error
			} else {
			 	XenosAlert.info("No Result Found!");
			 	queryResult.removeAll(); // clear previous data if any as there is no result now.
			 	errPage.removeError(); //clears the errors if any
			}
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
        var cpTypeArray:Array = new Array(3);
            cpTypeArray[0]="BANK/CUSTODIAN";
            cpTypeArray[1]="BROKER";
            cpTypeArray[2]="INTERNAL";
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
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
     	/* var url : String;
     	if(pdfXlsFlag == true)
        	url = "rec/cashReferResultDispatch.action?method=generateXLS&fromPage=queryResult";
        else
        	url = "rec/cashReferResultDispatch.action?method=generateXLS&fromPage=query"; */
        var url : String = "rec/cashReferResultDispatch.action?method=generateXLS&fromPage=query";
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
     	/* var url : String;
     	if(pdfXlsFlag == true)
        	url = "rec/cashReferResultDispatch.action?method=generatePDF&fromPage=queryResult";
        else
        	url = "rec/cashReferResultDispatch.action?method=generatePDF&fromPage=query"; */
        var url : String = "rec/cashReferResultDispatch.action?method=generatePDF&fromPage=query";
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
       	/*var printObject:XenosPrintView = new XenosPrintView();
        printObject.frmPrintHeader.lbl.text = "Cam Movement Query";
        printObject.pDataGrid.dataProvider = movementSummary.dataProvider;
        PrintDG.printAll(printObject); */
    }
    
    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
      private function doNext1():void {
       
        var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.listIndex = "0";
        reqObj.rnd = Math.random()+"";
        cashReferResultsQueryRequest.request = reqObj;
        cashReferResultsQueryRequest.send();
    }  
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
      private function doPrev1():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.listIndex = "0";
        reqObj.rnd = Math.random()+"";
        cashReferResultsQueryRequest.request = reqObj;
        cashReferResultsQueryRequest.send();
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
 	}
 	/**
 	 * This will clear the Account No Control and
 	 * make it editable again.
 	 */
 	private function accountClearState():void {
		stlAccForFundPopUp.accountNo.text = "";
		stlAccForFundContextList.removeAll();
		stlAccForFundContextList = populateCtx();
 	}
    /** 
    * This is the focusOut handler of the Fund Code.
    */
 	private function inputHandler():void {
 		
 		var fundStr:String = fundPopUp.fundCode.text;
 		if(!XenosStringUtils.isBlank(fundStr)){
 			submit.enabled = false;
 			var req :Object = new Object();
 			req.fundCodeQry = fundStr;
 			loadBankAndBankAccountForFund.request = req;
 			loadBankAndBankAccountForFund.send();
 		}else {
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
	      	 	
	      	 	if (rs.multipleBankPresent==true || rs.pageLoading == true) {
					finInstClearState();
				}
				
				if (rs.multipleBankPresent == false && rs.pageLoading == false) {
					fininstPopUp.bankCode.text = rs.bank;
					fininstPopUp.bankCode.editable = false;
                    fininstPopUp.finInstFundPopup.visible=false;
				}
				
				if (rs.multipleBankAccountPresent==true || rs.pageLoading == true) {
					accountClearState();
                    stlAccForFundPopUp.fundCodeCheck = true;
				}
				
				if (rs.multipleBankAccountPresent==false && rs.pageLoading == false) {
					stlAccForFundPopUp.accountNo.text = rs.accountNo;
                    stlAccForFundPopUp.accountNo.editable = false;
                    stlAccForFundPopUp.accountPopup.visible = false;
				}
   	
            	finContextList.removeAll();
        		fininstPopUp.bankCode.text = rs.bank;
        		stlAccForFundPopUp.accountNo.text = rs.accountNo;
	    		var fundArray : Array = new Array(1);
	    		fundArray[0] = fundPopUp.fundCode.text;
	    		finContextList.addItem(new HiddenObject("fundCodeContext",fundArray));
	    		/* var finRoleArray:Array = new Array(1);
        		finRoleArray[0]="BANK/CUSTODIAN";
 				finContextList.addItem(new HiddenObject("finRoleContext",finRoleArray)); */
	    		stlAccForFundContextList.removeAll();
	    		var cpTypeArray:Array = new Array(1);
		        cpTypeArray[0]="BANK/CUSTODIAN";
		 		stlAccForFundContextList.addItem(new HiddenObject("cpCPTypeContext",cpTypeArray));
		 		var cpTypeArray1:Array = new Array(1);
		        cpTypeArray1[0]="OPEN";
		 		stlAccForFundContextList.addItem(new HiddenObject("actStatusContext",cpTypeArray1));
            	submit.enabled = true;
	        }			 
     	}else {
     		XenosAlert.info("event = null");
     	}
 	}
 	/**
 	 * This is the focus out handler of the bank Code
 	 */
 	private function bankOutHandler():void{
 		
 		var bankCode : String = fininstPopUp.bankCode.text;
 		if(!XenosStringUtils.isBlank(bankCode)){
 			submit.enabled = false;
 			var req :Object = new Object();
 			req.fundCodeQry = fundPopUp.fundCode.text;
 			req.bank = bankCode;
 			req.rnd = Math.random()+"";
 			//loadBankAccount.url = loadBankAccount.url+ "&rndNo="+Math.random();
 			loadBankAccount.request = req;
 			loadBankAccount.send();
 		}else {
 			// Remove the bank code should remove Bank Account No
 			resetBank.send();
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
 			if(rs.child("Errors").length()>0){ 
				// i.e. Must be error, display it .
				var errorInfoList : ArrayCollection = new ArrayCollection();
				//populate the error info list 			 	
				for each ( var error:XML in rs.Errors.error ) {
					errorInfoList.addItem(error.toString());
				}
				errPage.showError(errorInfoList);//Display the error
	      	}else {
	      	 	errPage.removeError();	      	 
	      	 	
	      	 	if (rs.multipleBankAccountPresent == true || rs.pageLoading == true) {
                    accountClearState();
                    stlAccForFundPopUp.fundCodeCheck = true;
                }
	      	 	if (rs.multipleBankAccountPresent == false && rs.pageLoading == false) {
        		    stlAccForFundPopUp.accountNo.text = rs.accountNo;
                    stlAccForFundPopUp.accountNo.editable = false;
                    stlAccForFundPopUp.accountPopup.visible = false;
                }
	      	 	
    			stlAccForFundContextList.removeAll();
    			var cpTypeArray:Array = new Array(1);
		        cpTypeArray[0]="BANK/CUSTODIAN";
		 		stlAccForFundContextList.addItem(new HiddenObject("cpCPTypeContext",cpTypeArray));
		 		var cpTypeArray1:Array = new Array(1);
		        cpTypeArray1[0]="OPEN";
		 		stlAccForFundContextList.addItem(new HiddenObject("actStatusContext",cpTypeArray1));	
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
    private function populateCtx():ArrayCollection {
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
      * This is the method to pass the Collection of data items
      * through the context to the fininst popup. This will be implemented as per specifdic  
      * requriment. 
      */
    private function populateFinInstCtx():void {
    	//pass the context data to the popup
        
         var transferAgentRolesArray:Array = new Array(5);
         transferAgentRolesArray[0] = "Bank/Custodian";
         transferAgentRolesArray[1] = "Central Depository";
         transferAgentRolesArray[2] = "Security Broker";
         transferAgentRolesArray[3] = "Stock Exchange";
         transferAgentRolesArray[4] = "Clearing Corporation";
         
         var fundArray : Array = new Array(1);
         fundArray[0]= fundPopUp.fundCode.text;
         
         XenosAlert.info("fund :"+ fundArray[0]);
    }
    
    
    //Method which adds original row nums to each row
    private function addOriginalRowNums():void {
    	
    	var rown:int = 0;    	
    	for each(var row:Object in queryResult) {		
			row.originalRowNum=rown;
			queryResult.setItemAt(row,rown);
			rown++;
		}
    }