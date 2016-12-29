
 // ActionScript file for Cam Movement Query
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.rec.validators.CashremarksValidator;
 import mx.collections.ArrayCollection;
 import mx.events.ResourceEvent;
 import mx.events.ValidationResultEvent;
 import mx.resources.ResourceBundle;
 import mx.rpc.events.ResultEvent;
 import mx.utils.StringUtil;
    
    
    [Bindable]
    private var initColl:ArrayCollection;
     [Bindable]
    private var initColl1:ArrayCollection;
    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]
    public var returnFinContext:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
     private var summaryResult1:ArrayCollection= new ArrayCollection();
    private var emptyResult:ArrayCollection= new ArrayCollection();
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    [Bindable]
    private var selectedResults:ArrayCollection=new ArrayCollection(); 
     private var selectedResultsCan:ArrayCollection=new ArrayCollection(); 
    [Bindable]
 	private var queryResult:Object= new Object();
 	[Bindable]
 	private var finContextList:ArrayCollection = new ArrayCollection();
    [Bindable]
    public var conformSelectedResults : ArrayCollection = new ArrayCollection(); 
    [Bindable]
    public var conformSelectedResultsCan : ArrayCollection = new ArrayCollection(); 
    [Bindable]
    public var groupId:Number = 0;
    [Bindable]
    public var selectAllBind:Boolean=false;
    [Bindable]
    public var selectifAny:Boolean=false;
    [Bindable]
    public var loggedOnuser:String;
    [Bindable]
    public var selectAllBind1:Boolean=false;
 	[Bindable]
 	private var stlAccForFundContextList:ArrayCollection = populateContext();
    [Bindable]
    private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    
    private var  csd:CustomizeSortOrder=null;
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
     [Bindable]
	public var authorizationStatusFlag:Boolean;
	 [Bindable]
	public var authStatusFlag:Boolean;
	public var authstatus:String;
	[Bindable]
 	private var rs:XML = new XML();
	
			
	
    
   
                                          
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
   			req.SCREEN_KEY = 11023;
   			initializeRemarksQuery.request = req;         
            initializeRemarksQuery.url = "rec/recSecRemarksDispatch.action?method=initialExecute&rnd=" + rndNo;                    
            initializeRemarksQuery.send();        
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
         var tempColl1: ArrayCollection = new ArrayCollection();
         //variables to hold the default values from the server
        var sortField1Default:String = event.result.recSecRemarksActionForm.sortField1;
        var sortField2Default:String = event.result.recSecRemarksActionForm.sortField2;
        var sortField3Default:String = event.result.recSecRemarksActionForm.sortField3;
        var sortField4Default:String = event.result.recSecRemarksActionForm.sortField4;
        errPage.clearError(event); 
        submit.enabled = true;
        dateFrom.text = "";
        dateFrom.setFocus();
        dateTo.text = "";
        creationDateFrom.text = "";
        creationDateTo.text = "";
        stlAccForFundPopUp.accountNo.text = "";
        fininstPopUp.bankCode.text = "";
        fundPopUp.fundCode.text = "";
        userIdPopUp.employeeText.text="";
        //chkbox1.selected=false;
        this.instPopUp.instrumentId.text = XenosStringUtils.EMPTY_STR;
        if(null != event.result.recSecRemarksActionForm.sortFieldList1.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        	
        	if(event.result.recSecRemarksActionForm.sortFieldList1.item is ArrayCollection)
                initColl = event.result.recSecRemarksActionForm.sortFieldList1.item as ArrayCollection;
            else
                initColl.addItem(event.result.recSecRemarksActionForm.sortFieldList1.item);
        	
	        for(i = 0; i<initColl.length; i++) {
	        	//Get the default value object's index
                if(XenosStringUtils.equals((initColl[i].value),sortField1Default)){                    
                    selIndx = i;
                }
	        	
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
        //5. Setting values of the SortField2 
        initColl.removeAll();
        if(null != event.result.recSecRemarksActionForm.sortFieldList2.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        
        	if(event.result.recSecRemarksActionForm.sortFieldList2.item is ArrayCollection)
                initColl = event.result.recSecRemarksActionForm.sortFieldList2.item as ArrayCollection;
            else
                initColl.addItem(event.result.recSecRemarksActionForm.sortFieldList2.item);
                
	        for(i = 0; i<initColl.length; i++) {
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
        //6. Setting values of the SortField3
        initColl.removeAll();
        if(null != event.result.recSecRemarksActionForm.sortFieldList3.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        
        	if(event.result.recSecRemarksActionForm.sortFieldList3.item is ArrayCollection)
                initColl = event.result.recSecRemarksActionForm.sortFieldList3.item as ArrayCollection;
            else
                initColl.addItem(event.result.recSecRemarksActionForm.sortFieldList3.item);
                
	        for(i = 0; i<initColl.length; i++) {
	        	//Get the default value object's index
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
	        
        }
        //6. Setting values of the SortField3
        initColl.removeAll();
        if(null != event.result.recSecRemarksActionForm.sortFieldList4.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        
        	if(event.result.recSecRemarksActionForm.sortFieldList4.item is ArrayCollection)
                initColl = event.result.recSecRemarksActionForm.sortFieldList4.item as ArrayCollection;
            else
                initColl.addItem(event.result.recSecRemarksActionForm.sortFieldList4.item);
                
	        for(i = 0; i<initColl.length; i++) {
	        	//Get the default value object's index
                if(XenosStringUtils.equals((initColl[i].value),sortField4Default)){                    
                    selIndx = i;
                }
                
	           tempColl.addItem(initColl[i]);            
	        }
	        //sortField3.dataProvider = tempColl;
	        
	        sortFieldArray[3]=sortField4;
	        sortFieldDataSet[3]=tempColl;
	        //Set the default value object
	        sortFieldSelectedItem[3] = tempColl.getItemAt(selIndx+1);
	        
        }
         else {
        	XenosAlert.error("Sort Order Field List 4 not Populated");
        }
        csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
        csd.init();

    } 
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
     private function resetQuery():void {         
         secRemarksQueryRequest.send();         
         
         stlAccForFundPopUp.accountNo.editable = true;
         stlAccForFundPopUp.accountPopup.visible = true;
         fininstPopUp.bankCode.editable = true;
         fininstPopUp.finInstFundPopup.visible = true;
         
         finInstClearState();
    }  
         
   
    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
     private function doNext():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
        secRemarksQueryRequestresult.request = reqObj;
        secRemarksQueryRequestresult.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        secRemarksQueryRequestresult.request = reqObj;
        secRemarksQueryRequestresult.send();
    } 
     
    
     /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
         reqObj.method = "submitQuery";
   		 reqObj.SCREEN_KEY = 11024;
         reqObj.accountNo = this.stlAccForFundPopUp.accountNo.text;
         reqObj.fundCode = fundPopUp.fundCode.text;
         reqObj.asOfDateFrom = this.dateFrom.text;
         reqObj.asOfDateTo = this.dateTo.text;
         reqObj.creationDateFrom = this.creationDateFrom.text;
         reqObj.creationDateTo = this.creationDateTo.text;
         reqObj.userId = this.userIdPopUp.employeeText.text;
         reqObj.custodianCode = fininstPopUp.bankCode.text;
         reqObj.securityCode = this.instPopUp.instrumentId.text;
         reqObj.sortOrder1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : XenosStringUtils.EMPTY_STR;
     	 reqObj.sortOrder2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : XenosStringUtils.EMPTY_STR;
     	 reqObj.sortOrder3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : XenosStringUtils.EMPTY_STR;
     	 reqObj.sortOrder4 = this.sortField4.selectedItem != null ? StringUtil.trim(this.sortField4.selectedItem.value) : XenosStringUtils.EMPTY_STR;
     	 //reqObj.remaininStatus = this.chkbox1.selected;
         
         reqObj.rnd = Math.random() + "";
         
         return reqObj;
    }
    /**
    * It sends/submits the query. 
    * 
    */
     private function submitQuery():void 
    {  
        //Set the request parameters
         var requestObj :Object = populateRequestParams();
         
         secRemarksQueryRequestresult.request = requestObj; 
        
         var authResultsModel:Object={
                            Remarks:{
						         fromDate:this.dateFrom.text,
						         toDate: this.dateTo.text,
						         creationDateFrom : this.creationDateFrom.text,
						         creationDateTo : this.creationDateTo.text
						        
                            }
                           }; 
        var cashremarksValidator:CashremarksValidator = new CashremarksValidator();
        cashremarksValidator.source=authResultsModel;
        cashremarksValidator.property="Remarks";
        //selectifAny = chkbox1.selected;
        var validationResult:ValidationResultEvent =cashremarksValidator.validate();

        if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
            resultHead.text = "";
        }else { 
        	qh.resetPageNo();
            secRemarksQueryRequestresult.send();
        }
        
    }  
     /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    /*  public function LoadSummaryPage(event:ResultEvent):void {
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
    	                summaryResult.removeAll();
    	                summaryResult.addItem(event.result.rows.row);
                    }
                    changeCurrentState();
    	        }else{                    
                    XenosAlert.info("No Results Found");
                } 
	             
	             //replace null objects with empty string
				 summaryResult=ProcessResultUtil.process(summaryResult,movementSummary.columns);
	             //changeCurrentState();
	             qh.setOnResultVisibility();
                 //qh.pdf.visible = false;
                 //qh.xls.visible = false;
	             qh.setPrevNextVisibility(Boolean(event.result.rows.prevTraversable),Boolean(event.result.rows.nextTraversable));
	             qh.PopulateDefaultVisibleColumns();            
            }
            //refresh the results.
            summaryResult.refresh(); 
        }else {
            summaryResult.removeAll();
            XenosAlert.info("No Results Found");
        }
               
    } */
      private function LoadSummaryPage(event:ResultEvent):void
	{
		rs = XML(event.result);
		selectAllBind=false;
        //conformSelectedResults = new Array();
		if (null != event) {
			if(rs.child("row").length()>0) {
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
		           
	            	
				}catch(e:Error){
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
    
     
     private function sortOrder1Update():void{
     	 csd.update(sortField1.selectedItem,0);
     }
     
     private function sortOrder2Update():void{     	
     	csd.update(sortField2.selectedItem,1);
     }
      private function sortOrder3Update():void{     	
     	csd.update(sortField3.selectedItem,2);
     }
     
    /**
    * This is called at creationComplete of the module
    */
     private function loadAll():void {
        //var title:String = this.parentApplication.xResourceManager.getKeyValue('rec.label.remarks') + " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.query');
        //if(title!= null)
        //    this.parentDocument.title = title;
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
 	 * This will clear the Bank Code Control and 
 	 * make it editable again
 	 */
 	private function finInstClearState():void {
 		
 		fininstPopUp.bankCode.text = "";
 		fininstPopUp.bankCode.editable = true;
		fininstPopUp.bankCode.visible=true;
		finContextList.removeAll();
 	}
 	/**
 	 * This will clear the Account No Control and
 	 * make it editable again.
 	 */
 	private function accountClearState():void {
		stlAccForFundPopUp.accountNo.text = "";
		stlAccForFundContextList.removeAll();
		stlAccForFundContextList = populateContext();
 	}
     /** 
    * This is the focusOut handler of the Fund Code.
    */
 	private function inputHandler():void {
 		
 		var fundStr:String = fundPopUp.fundCode.text;
 		if(!XenosStringUtils.isBlank(fundStr)){
 			submit.enabled = false;
 			var req :Object = new Object();
 			req.fundCode = fundStr;
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
 	private function populateBankAndBankAccount(event:ResultEvent):void{
 		
 		/* if (null != event) {
 			if(null == event.result.recSecRemarksActionForm){ 
     			if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
	            	   errPage.clearError(event); //clears the errors if any
	      			 }
	      		else{ // Must be error
	      			 errPage.displayError(event);
	      		}
	      }else {
	      		errPage.clearError(event);	      	 	
            	queryResult = event.result.recSecRemarksActionForm as Object;      	
            	finContextList.removeAll();
        		fininstPopUp.bankCode.text = queryResult.custodianCode;
        		stlAccForFundPopUp.accountNo.text = queryResult.accountNo;
	    		var fundArray : Array = new Array(1);
	    		fundArray[0] = fundPopUp.fundCode.text;
	    		finContextList.addItem(new HiddenObject("fundCodeContext",fundArray));
	    		stlAccForFundContextList.removeAll();
	    		var cpTypeArray:Array = new Array(1);
		        cpTypeArray[0]=this.fundPopUp.fundCode.text;
		 		stlAccForFundContextList.addItem(new HiddenObject("stlFundCodeContext",cpTypeArray));
		 		var cpTypeArray1:Array = new Array(1);
		        cpTypeArray1[0]=this.fininstPopUp.bankCode.text;
		 		stlAccForFundContextList.addItem(new HiddenObject("stlBankCodeContext",cpTypeArray1));
            	submit.enabled = true;
	        }			 
     	}else {
     		XenosAlert.info("event = null");
     	} */
     		rs = XML(event.result);
 		if (null != event) {
 		/* if (null != event) {
 			if(null == event.result.recCashReReconcileActionForm){ 
     			if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
	            	   errPage.clearError(event); //clears the errors if any
	      			 }
	      		else{ // Must be error
	      			 errPage.displayError(event);
	      		}
	      }else {
	      		errPage.clearError(event);	      	 	
            	queryResult = event.result.recCashReReconcileActionForm as Object;  */
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

                 if(rs.multipleBankPresent==true || rs.pageLoading == true){
                    
                    finInstClearState();
                    //accountClearState();
                    fininstPopUp.fundCodeCheck = true;
                    //stlAccForFundPopUp.fundCodeCheck = true;
                }
                
                
                if(rs.multipleBankPresent==false && rs.pageLoading == false){                    
                    
        		     fininstPopUp.bankCode.text = rs.custodianCode;
                    //stlAccForFundPopUp.stlAccNo.text = rs.entry.bankAccountNo;
                    fininstPopUp.bankCode.editable = false;
                    fininstPopUp.finInstFundPopup.visible=false;
                    //stlAccForFundPopUp.stlAccNo.editable = false;
                    //stlAccForFundPopUp.stlAccPopup.visible = false;
                    focusManager.setFocus(userIdPopUp.employeeText);
                } 
                if(rs.multipleBankAccountPresent==true || rs.pageLoading == true){
                    accountClearState();
                    stlAccForFundPopUp.fundCodeCheck = true;
                    
                }
                
                
                if(rs.multipleBankAccountPresent==false && rs.pageLoading == false){
                    
                    
        		    stlAccForFundPopUp.accountNo.text = rs.accountNo;
                    stlAccForFundPopUp.accountNo.editable = false;
                    stlAccForFundPopUp.accountPopup.visible = false;
                }    	
            	finContextList.removeAll();
        		//fininstPopUp.bankCode.text = rs.custodianCode;
        		//stlAccForFundPopUp.accountNo.text = rs.accountNo;
	    		var fundArray : Array = new Array(1);
	    		fundArray[0] = fundPopUp.fundCode.text;
	    		finContextList.addItem(new HiddenObject("fundCodeContext",fundArray));
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
 			req.fundCode = fundPopUp.fundCode.text;
 			req.custodianCode = bankCode;
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
 	private function populateBankAccount(event:ResultEvent):void{
     		rs = XML(event.result);
 		if (null != event) {
 			if(null == event.result.recSecRemarksActionForm){ 
     			if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
	            	    errPage.clearError(event); //clears the errors if any
	            	 }
	      		else{ // Must be error
	      			 errPage.displayError(event);
	      		}
	      }else {
	      	 	errPage.clearError(event);
	      	 	queryResult = event.result.recSecRemarksActionForm as Object; 
	      	 	if(rs.multipleBankAccountPresent==true || rs.pageLoading == true){
                    accountClearState();
                    stlAccForFundPopUp.fundCodeCheck = true;
                    
                }
                
                
                if(rs.multipleBankAccountPresent==false && rs.pageLoading == false){
                    
                    
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
	     	}else {
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
        var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="BANK/CUSTODIAN";
                
                
            myContextList.addItem(new HiddenObject("cpCPTypeContext",cpTypeArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("actStatusContext",actStatusArray));
            return myContextList;
        
        
    }
    /**
      * This is the method to pass the Collection of data items
      * through the context to the fininst popup. This will be implemented as per specifdic  
      * requriment. 
      */
    private function populateFinInstCtx():void {
    	//pass the context data to the popup
        //var finContextList:ArrayCollection = new ArrayCollection(); 
        
         var transferAgentRolesArray:Array = new Array(5);
         transferAgentRolesArray[0] = "Bank/Custodian";
         transferAgentRolesArray[1] = "Central Depository";
         transferAgentRolesArray[2] = "Security Broker";
         transferAgentRolesArray[3] = "Stock Exchange";
         transferAgentRolesArray[4] = "Clearing Corporation";
         
         var fundArray : Array = new Array(1);
         fundArray[0]= fundPopUp.fundCode.text;
         //myContextList.addItem(new HiddenObject("transferAgentRoles",transferAgentRolesArray));
         /* myContextList.addItem(new HiddenObject("fundCode",fundArray)); */
         
         XenosAlert.info("fund :"+ fundArray[0]);
        // return myContextList;
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
        var url : String = "rec/recSecRemarksDispatch.action?method=generateXLS";
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
        var url : String = "rec/recSecRemarksDispatch.action?method=generatePDF";
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
  
  	
    
   
// ActionScript file
