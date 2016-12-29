
 // ActionScript file for Cam Movement Query
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.containers.SummaryPopup;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.DateUtils;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.rec.validators.SecReReconValidator
 
 import mx.collections.ArrayCollection;
 import mx.core.UIComponent;
 import mx.events.ValidationResultEvent;
 import mx.managers.PopUpManager;
 import mx.rpc.events.ResultEvent;
    
    
    [Bindable]
    private var initColl:ArrayCollection;
    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    private var emptyResult:ArrayCollection= new ArrayCollection();
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    private var selectedResults:ArrayCollection=new ArrayCollection();  
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    
    [Bindable]
 	private var queryResult:Object= new Object();
    [Bindable]
    public var conformSelectedResults : Array; 
    [Bindable]
    public var selectAllBind:Boolean=false;
    [Bindable]
    private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    
 	[Bindable]
 	private var finContextList:ArrayCollection = new ArrayCollection();
 	[Bindable]
 	private var stlAccForFundContextList:ArrayCollection = populateContext();
    
    [Bindable]
    public var returnFinContext:ArrayCollection = new ArrayCollection();
    
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    [Bindable]   
    private var mode : String = null;
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
     	app.submitButtonInstance = submit;      
        if (!initCompFlg) {    
     		parseUrlString();
            rndNo= Math.random(); 
            var req : Object = new Object();
            req.SCREEN_KEY = 10030;
            initializeReReconQuery.request = req; 
            if(XenosStringUtils.equals(mode,"CAMPX")){   
            	initializeReReconQuery.url = "rec/recXenosReReconcile.action?method=initialExecute&mode="+"CAMPX"+"&rnd=" + rndNo;
            } else {
	            initializeReReconQuery.url = "rec/recXenosReReconcile.action?method=initialExecute&mode="+"NCMCUST"+"&rnd=" + rndNo;                    	                 
            }      
            //XenosAlert.info("initializeReReconQuery.url : " + initializeReReconQuery.url);             
            initializeReReconQuery.send();       
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
        
        dateFrom.text = "";
        dateFrom.setFocus();
        dateTo.text = "";
        stlAccForFundPopUp.accountNo.text = "";
        fininstPopUp.bankCode.text = "";
        fundPopUp.fundCode.text = "";
        
        
        if(event.result){
        	if(event.result.recXenosReReconcileActionForm.officeIdList.officeId is ArrayCollection){
    		initColl = event.result.recXenosReReconcileActionForm.officeIdList.officeId as ArrayCollection;        		
        	}else{
        		initColl = new ArrayCollection();
        		initColl.addItem(event.result.recXenosReReconcileActionForm.officeIdList.officeId);
        	}
        }
    		
    		//new code
		tempColl = new ArrayCollection();  
		tempColl.addItem({label:Globals.EMPTY_STRING, value: Globals.EMPTY_STRING});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        officeId.dataProvider = tempColl;
        errPage.clearError(event);
        submit.enabled = true;
    } 
    
         
    /**
    * It sends/submits the query after validating the user input data. 
    * 
    */
     private function submitQuery():void {
     	
       		if(selectedResults!=null){
       			selectedResults.removeAll();
       			conformSelectedResults=selectedResults.toArray();
       		}
       	//Reset Page No
    	qh.resetPageNo(); 
     	//Set the request parameters
         var requestObj :Object = populateRequestParams();
         
         cashReconQueryRequest.request = requestObj; 
         
        var myModel:Object={
                            reRecon:{
                                 toDate:this.dateTo.text,
                                 fromDate:this.dateFrom.text,
                                 bank:this.fininstPopUp.bankCode.text,
                                 accNo:this.stlAccForFundPopUp.accountNo.text          
                            }
                           }; 
        var cashReReconValidate:SecReReconValidator =new SecReReconValidator();
        cashReReconValidate.source=myModel;
        cashReReconValidate.property="reRecon";
        var validationResult:ValidationResultEvent =cashReReconValidate.validate();

        
        if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
            resultHead.text = "";
           
        }else {
            var dateLabel:String = this.parentApplication.xResourceManager.getKeyValue('rec.cash.re.query.label.datefrom');
			var dateValue:String = this.dateFrom.text;
			if (!DateUtils.validateBaseDate(errPage, "CAM", dateLabel, dateValue) || 
				!DateUtils.validateBaseDate(errPage, "NCM", dateLabel, dateValue)) {
				return;
			}
            cashReconQueryRequest.send();   
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
         
         reqObj.accountNo = this.stlAccForFundPopUp.accountNo.text;
         reqObj.fundCode = fundPopUp.fundCode.text;
         reqObj.asOfDateFrom = this.dateFrom.text;
         reqObj.asOfDateTo = this.dateTo.text;
         reqObj.officeId = this.officeId.selectedItem != null ? this.officeId.selectedItem.value : Globals.EMPTY_STRING;
         reqObj.custodianCode = fininstPopUp.bankCode.text;
         reqObj.SCREEN_KEY = 10031;
         reqObj.rnd = Math.random() + "";
         
         return reqObj;
    }
     
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParamsResult():Object {
        
        var reqObj : Object = new Object();
         reqObj.method = "showResult";
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
        cashReconQueryRequest.request = reqObj;
        cashReconQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        cashReconQueryRequest.request = reqObj;
        cashReconQueryRequest.send();
    }   
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
     private function resetQuery():void {         
         cashReconResetQueryRequest.send(); 
         
         stlAccForFundPopUp.accountNo.editable = true;
         stlAccForFundPopUp.accountPopup.visible = true;
         fininstPopUp.bankCode.editable = true;
         fininstPopUp.finInstFundPopup.visible = true;
         
         finInstClearState();
    }  
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * This also takes care of the buttons/images to be shown on teh top panel of the
    * result .
    */
     /* public function LoadSummaryPage(event:ResultEvent):void {
        var showNext:Boolean;
        var showPrev:Boolean;
        selectAllBind=false;
        conformSelectedResults = new Array();
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
                resetSellection(summaryResult);
	            setIfAllSelected();
	            
	            //replace null objects
				summaryResult=ProcessResultUtil.process(summaryResult,movementSummary.columns);
	            
                qh.setOnResultVisibility();
                qh.setPrevNextVisibility(Boolean(event.result.rows.prevTraversable),Boolean(event.result.rows.nextTraversable));
                qh.PopulateDefaultVisibleColumns();
                qh.pdf.enabled = false;
	            qh.xls.enabled = false;  
            }
            //refresh the results.
            summaryResult.refresh(); 
        }else {
            summaryResult.removeAll();
            XenosAlert.info("No Results Found");
        } 
               
    }  */
     private function LoadSummaryPage(event:ResultEvent):void
	{
		rs = XML(event.result);
		selectAllBind=false;
        conformSelectedResults = new Array();
		if (null != event) {
			if(rs.child("row").length()>0) {
				errPage.clearError(event);
	            summaryResult.removeAll();
	            
				try {
				    for each ( var rec:XML in rs.row ) {
	 				    summaryResult.addItem(rec);
				    }
				    
				    
				    changeCurrentState();
				    resetSellection(summaryResult);
	            	setIfAllSelected();
	            	
				    
		            qh.setOnResultVisibility();
		            
		            qh.setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
		            qh.PopulateDefaultVisibleColumns();
		           
	     	        //replace null objects in datagrid with empty string
	            	summaryResult=ProcessResultUtil.process(summaryResult, movementSummary.columns);
	            	summaryResult.refresh();
		           	qh.pdf.enabled = false;
	            	qh.xls.enabled = false;  
	            	
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
    /**
    * This is called at creationComplete of the module
    */
     private function loadAll():void {
        //var title:String = this.parentApplication.xResourceManager.getKeyValue('rec.cash.re.label.query') + " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.query');
        //if(title!= null)
        //    this.parentDocument.title = title;
     } 
    
          /**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
      /*  private function populateContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing counter party type                
            var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="BANK/CUSTODIAN";
                
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
            return myContextList;
        }
                 */
                
       
       
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
       /*  var url : String = "cam/camMovementQueryDispatch.action?method=generateXLS";
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
       /*  var url : String = "rec/recXenosReReconcile.action?method=generatePDF";
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
        /* var printObject:XenosPrintView = new XenosPrintView();
        printObject.frmPrintHeader.lbl.text = "Cam Movement Query";
        printObject.pDataGrid.dataProvider = movementSummary.dataProvider;
        PrintDG.printAll(printObject); */
    }
      private function resetSellection(summaryResult:ArrayCollection):void{
    	for(var i:int=0;i<summaryResult.length;i++){
    		summaryResult[i].selected = false;
    		summaryResult[i].rowNumInt= i;
    	}
    }
    
    
    
    public function setIfAllSelected() : void {
    	if(isAllSelected()){
    		selectAllBind=true;
    	} else {
    		selectAllBind=false;
    	}
    	
    }
    
    
    public function isAllSelected(): Boolean {
    	var i:Number = 0;        	
    	if(summaryResult == null)
    		return false;
    		
    	for(i=0; i<summaryResult.length; i++){
    		if(summaryResult[i].selected == false) {
    			
        		return false;
        	}
    	}
    	if(i == summaryResult.length) {
    		return true;
         }else {			
    		return false;        		
    	}
    }
    
       
// This as file contains code specific to the Check Box Selections.    
    
     /* public function selectAllRecords(flag:Boolean): void {
    	var i:Number = 0;
    	selectedResults.removeAll();
    	for(i=0; i<summaryResult.length; i++){
            summaryResult[i].selected = flag;
            addOrRemove(summaryResult[i]);
    	}
    	
    	conformSelectedResults=	selectedResults.toArray();
    }  */
     public function selectAllRecords(flag:Boolean): void {
      var i:Number = 0;
      selectedResults.removeAll();
      for(i=0; i<summaryResult.length; i++){
            var obj:XML=summaryResult[i];
            obj.selected = flag;
            summaryResult[i]=obj;
            addOrRemove(summaryResult[i]);
      }

      conformSelectedResults= selectedResults.toArray();
    }

        
     
    public function addOrRemove(item:Object):void {
    	var i:Number;
        var tempArray:Array = new Array();
        if(item.selected == true){ 
        	var obj:Object=new Object();
        	obj.rowNumInt=item.rowNumInt;
            selectedResults.addItem(obj);
           
    	}else { //needs to pop
    		tempArray=selectedResults.toArray();
    	    selectedResults.removeAll();
    		for(i=0; i<tempArray.length; i++){
    			if(tempArray[i] != item.messageId)
    			    selectedResults.addItem(tempArray[i]);
    			   
    		}
    	}   		
    }
   
   
    public function checkSelectToModify(item:Object):void {
        var i:Number;
        var tempArray:Array = new Array();
        if(item.selected == true){ // needs to insert    		
        	var obj:Object=new Object();
        	obj.rowNumInt=item.rowNumInt;
            selectedResults.addItem(obj);
    	}else { //needs to pop
    		tempArray=selectedResults.toArray();
    	    selectedResults.removeAll();
    		for(i=0; i<tempArray.length; i++){
    			if(tempArray[i].rowNumInt != item.rowNumInt){
    			    selectedResults.addItem(tempArray[i]);
    			   
    			}
    		}        		
    	}    
    	conformSelectedResults=	selectedResults.toArray();
    	setIfAllSelected();    	    	
    }
    public function showResult(event:Event):void {
    	var i:Number;
        var obj:Object=new Object();
    	var othersArray:Array = new Array();
		if(conformSelectedResults.length > 0 ){
			obj.unique= new Date().getTime() + "";
			for(i=0; i<conformSelectedResults.length; i++){
    			othersArray[i] =conformSelectedResults[i].rowNumInt;
    		}
    		obj.othersArray = othersArray;
    		obj.SCREEN_KEY = 10032; 
		    cashReconConfirmQueryRequest.request=obj;
		    cashReconConfirmQueryRequest.send();
		}else{
			XenosAlert.info("Please select a checkBox");
		}
     }

     public function LoadConfirmationOueryPage(event:ResultEvent):void {
     	
				var sPopup : SummaryPopup;	
				var parentApp :UIComponent = UIComponent(this.parentApplication);
				sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
				sPopup.addEventListener("RefreshChanges",handleRefreshChanges);
				sPopup.title = "User Confirmation";
	    		sPopup.width = 900;
	    		sPopup.height = 450;
	    		sPopup.owner=this;
	    		
				PopUpManager.centerPopUp(sPopup);
				sPopup.moduleUrl = "assets/appl/rec/SecReReconConfPopup.swf";//"assets/appl/rec/RereconConfirmationPopup.swf";
     	
     }
     public function handleRefreshChanges(event:Event):void {
     	           selectAllBind=false;
		   resetSellection(summaryResult);
		   summaryResult.refresh();
		   selectedResults.removeAll();
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
 	/* private function populateBankAndBankAccount(event:ResultEvent):void{
 		
 		if (null != event) {
 			if(null == event.result.recXenosReReconcileActionForm){ 
     			if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
	            	   errPage.clearError(event); //clears the errors if any
	      			 }
	      		else{ // Must be error
	      			 errPage.displayError(event);
	      		}
	      }else {
	      		errPage.clearError(event);	      	 	
            	queryResult = event.result.recXenosReReconcileActionForm as Object;      	
            	finContextList.removeAll();
        		fininstPopUp.bankCode.text = queryResult.custodianCode;
        		stlAccForFundPopUp.accountNo.text = queryResult.accountNo;
	    		var fundArray : Array = new Array(1);
	    		fundArray[0] = fundPopUp.fundCode.text;
	    		finContextList.addItem(new HiddenObject("fundCodeContext",fundArray));
	    		stlAccForFundContextList.removeAll();
	    		var cpTypeArray:Array = new Array(1);
		        cpTypeArray[0]=this.fundPopUp.fundCode.text;
		 		stlAccForFundContextList.addItem(new HiddenObject("cpCPTypeContext",cpTypeArray));
		 		var cpTypeArray1:Array = new Array(1);
		        cpTypeArray1[0]=this.fininstPopUp.bankCode.text;
		 		stlAccForFundContextList.addItem(new HiddenObject("actStatusContext",cpTypeArray1));
            	submit.enabled = true;
	        }			 
     	}else {
     		XenosAlert.info("event = null");
     	}
 	} */
 	private function populateBankAndBankAccount(event:ResultEvent):void{
 		
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
                    focusManager.setFocus(officeId);
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
 			req.bank = bankCode;
 			loadBankAccount.request = req;
 			loadBankAccount.send();
 		}else {
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
 	private function populateBankAccount(event:ResultEvent):void{
 			rs = XML(event.result);
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
        var cpTypeArray:Array = new Array(2);
        cpTypeArray[0]="BANK/CUSTODIAN";
        cpTypeArray[1]="BROKER";
        myContextList.addItem(new
		HiddenObject("cpCPTypeContext",cpTypeArray));
		 //passing account status              
        var actStatusArray:Array = new Array(1);
        actStatusArray[0]="OPEN";
        myContextList.addItem(new
		HiddenObject("actStatusContext",actStatusArray));
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
         
         //XenosAlert.info("fund :"+ fundArray[0]);
        // return myContextList;
    }
    /**
    * Parsing the URL for mode  
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
                if (tempA[0] == "mode") {
                    mode = tempA[1];
                } 
            }   
            //XenosAlert.info("mode :" + mode);                 
			
        } catch (e:Error) {
            trace(e);
        }
       
    }

  
    
   
