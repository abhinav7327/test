
 // ActionScript file for Cash Refer Raw File Query
 	

 	import com.nri.rui.core.Globals;
 	import com.nri.rui.core.controls.CustomizeSortOrder;
 	import com.nri.rui.core.controls.XenosAlert;
 	import com.nri.rui.core.startup.XenosApplication;
 	import com.nri.rui.core.utils.DateUtils;
 	import com.nri.rui.core.utils.HiddenObject;
 	import com.nri.rui.core.utils.ProcessResultUtil;
 	
 	import mx.collections.ArrayCollection;
 	import mx.events.ResourceEvent;
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
    public var balLabel:Boolean = false;
    [Bindable]
    public var pdfXlsFlag:Boolean = false;

            
    [Bindable]
    private var objForm1:Object = null;
    
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    
    private var  csd:CustomizeSortOrder=null;
    
    [Bindable]
    private var rs:XML = new XML();
    
    /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
        qh.dgrid = resultSummary;
    } 
    /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindBalDataGrid():void {
        qh1.dgrid = resultSummaryBal;
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
           	rndNo= Math.random();  
            var req : Object = new Object();
   			req.SCREEN_KEY = 10018;
   			initSecReferResultsQuery.request = req;      
            initSecReferResultsQuery.url = "rec/recXenosSecBalDispatch.action?method=initialExecute&mode=NCMCUST"+"&rnd=" + rndNo;                    
            initSecReferResultsQuery.send();        
        } else
            XenosAlert.info("Already Initiated!");
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
        security.instrumentId.text = "";
        dateFrom.setFocus();
        submit.enabled = true;
        
        queryResult.removeAll(); // clear previous data if any as there is no result now.
        queryResult.refresh();
        
        //Setting dateFrom and dateTo
        if(event.result.recXenosSecBalActionForm.date!= null) {
            dateStrFrom=event.result.recXenosSecBalActionForm.date;
               // XenosAlert.info("from date :"+dateStr);
            if(dateStrFrom != null)
                dateFrom.selectedDate = DateUtils.toDate(dateStrFrom);
        } else {
            XenosAlert.error("Error: From Date cannot be initialized.");
        }
        
        if(event.result){
        	if(event.result.recXenosSecBalActionForm.serviceOfficeValues.serviceOffice is ArrayCollection){
        		initColl = event.result.recXenosSecBalActionForm.serviceOfficeValues.serviceOffice as ArrayCollection;
        	}else{
        		initColl = new ArrayCollection();
        		initColl.addItem(event.result.recXenosSecBalActionForm.serviceOfficeValues.serviceOffice);
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
    		initColl = event.result.recXenosSecBalActionForm.matchStatus.item as ArrayCollection;
    	//populate match status list
		tempColl = new ArrayCollection();    		
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        matchStatus.dataProvider = tempColl;
        var balBasisStr:String = "";
        balBasisStr = event.result.recXenosSecBalActionForm.balanceBasis as String;
               	
    	if(event.result.recXenosSecBalActionForm.balanceBasisValues.item is ArrayCollection){
    		initColl = event.result.recXenosSecBalActionForm.balanceBasisValues.item as ArrayCollection;
    	}else{
        	initColl=new ArrayCollection();
        	initColl.addItem(event.result.recXenosSecBalActionForm.balanceBasisValues.item);
        }
        balBasis.dataProvider = initColl;
        balBasis.selectedIndex=0;
        // sort order
        
         //variables to hold the default values from the server
        var sortField1Default:String = event.result.recXenosSecBalActionForm.sortField1;
        var sortField2Default:String = event.result.recXenosSecBalActionForm.sortField2;
        var sortField3Default:String = event.result.recXenosSecBalActionForm.sortField3;
        var sortField4Default:String = event.result.recXenosSecBalActionForm.sortField4;
        
         if(null != event.result.recXenosSecBalActionForm.sortFieldList1.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        	
        	if(event.result.recXenosSecBalActionForm.sortFieldList1.item is ArrayCollection)
                initColl = event.result.recXenosSecBalActionForm.sortFieldList1.item as ArrayCollection;
            else
                initColl.addItem(event.result.recXenosSecBalActionForm.sortFieldList1.item);
        	
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
        if(null != event.result.recXenosSecBalActionForm.sortFieldList2.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        
        	if(event.result.recXenosSecBalActionForm.sortFieldList2.item is ArrayCollection)
                initColl = event.result.recXenosSecBalActionForm.sortFieldList2.item as ArrayCollection;
            else
                initColl.addItem(event.result.recXenosSecBalActionForm.sortFieldList2.item);
                
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
        if(null != event.result.recXenosSecBalActionForm.sortFieldList3.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        
        	if(event.result.recXenosSecBalActionForm.sortFieldList3.item is ArrayCollection)
                initColl = event.result.recXenosSecBalActionForm.sortFieldList3.item as ArrayCollection;
            else
                initColl.addItem(event.result.recXenosSecBalActionForm.sortFieldList3.item);
                
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
        if(null != event.result.recXenosSecBalActionForm.sortFieldList4.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        
        	if(event.result.recXenosSecBalActionForm.sortFieldList4.item is ArrayCollection)
                initColl = event.result.recXenosSecBalActionForm.sortFieldList4.item as ArrayCollection;
            else
                initColl.addItem(event.result.recXenosSecBalActionForm.sortFieldList4.item);
                
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
         //XenosAlert.error("this.security.instrumentId.text :"+ requestObj.securityCode);
         if((StringUtil.trim(requestObj.matchStatus) != "" ) || (StringUtil.trim(requestObj.securityCode) != "")){
         	balLabel=true;
            pdfXlsFlag = true;
         }else{
         	balLabel=false;
            pdfXlsFlag = false;
         }
         cashReferResultsQueryRequest.send();
        
    } 
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
     private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        
        reqObj.method = "submitQuery";
        reqObj.date = this.dateFrom.text;
        reqObj.balanceBasis = this.balBasis.selectedItem.value;
        //reqObj.asOfDateTo = this.dateTo.text;        
        reqObj.bank = fininstPopUp.bankCode.text;
        reqObj.fundCode = fundPopUp.fundCode.text;
        reqObj.serviceOffice =  (this.serviceOffice.selectedItem != null ? this.serviceOffice.selectedItem.value : "");
        reqObj.matchStatus = (this.matchStatus.selectedItem != null ? this.matchStatus.selectedItem.value : "");        
        reqObj.accountNo = this.stlAccForFundPopUp.accountNo.text;    
        reqObj.securityCode = this.security.instrumentId.text != null ?this.security.instrumentId.text : "";    
        reqObj.fromPage = "query";
        reqObj.traversableIndex = "0";
        reqObj.sortOrder1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : XenosStringUtils.EMPTY_STR;
     	reqObj.sortOrder2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : XenosStringUtils.EMPTY_STR;
     	reqObj.sortOrder3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : XenosStringUtils.EMPTY_STR;
     	reqObj.sortOrder4 = this.sortField4.selectedItem != null ? StringUtil.trim(this.sortField4.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.rnd = Math.random() + "";
         if((StringUtil.trim(reqObj.matchStatus) != "" ) || (StringUtil.trim(reqObj.securityCode) != "")){
         	   reqObj.SCREEN_KEY = 10020;
         }else{         	
    	        reqObj.SCREEN_KEY = 10019;
         }
        return reqObj;
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
    * This method sends the HttpService for reset operation.
    * 
    */
    private function resetQuery():void { 
         cashReferResultsResetQueryRequest.send();     
         
         stlAccForFundPopUp.accountNo.editable = true;
         stlAccForFundPopUp.accountPopup.visible = true;
         fininstPopUp.bankCode.editable = true;
         fininstPopUp.finInstFundPopup.visible = true;
         
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
			objForm1 = rs;
			
			 if(balLabel){		
                rslt.selectedChild=this.balRslt;     
			    this.btnBack.visible=false;
			    this.btnBack.includeInLayout=false; 
			    if(rs.child("resultView2List").resultView2.length()>0) {	
					errPage.clearError(event);
		            queryResult.removeAll();
					try {
					    for each ( var rec:XML in rs.resultView2List.resultView2 ) {
		 				    queryResult.addItem(rec);
					    }
	                    var tempItr:int=0;
	                    //XenosAlert.info("Inside LoadSummary");
	                    for(tempItr=0;tempItr<queryResult.length;tempItr++){
	                    	//XenosAlert.info(queryResult[tempItr].remarksAuditFlag);
	                    	queryResult[tempItr].auditFlag=queryResult[tempItr].remarksAuditFlag.toString();	 
	                    	//XenosAlert.info(queryResult[tempItr].auditFlag);
	                    }
            	
		        		 var itr:int=0;
		        		 for(itr=0;itr<queryResult.length;itr++){
		        		 	queryResult[itr].rowNo=itr;
		        		 }				    
					    changeCurrentState();            
			            
			            qh1.setOnResultVisibility();
			            qh1.setPrevNextVisibility((rs.previousTraversable2 == "true")?true:false,(rs.nextTraversable2 == "true")?true:false );
			            qh1.PopulateDefaultVisibleColumns();
    	                qh1.resetPageNo(); 
		     	        //replace null objects in datagrid with empty string
		            	queryResult= ProcessResultUtil.process(queryResult, resultSummary.columns);
		            	queryResult.refresh();
		            	
					}catch(e:Error){
					    //XenosAlert.error(e.toString() + e.message);
					    XenosAlert.error("No result found");
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
				 	XenosAlert.info("No Result Found!");
				 	queryResult.removeAll(); // clear previous data if any as there is no result now.
				 	errPage.removeError(); //clears the errors if any
				}
		     }else{
		     	rslt.selectedChild=this.accRslt;  
		        this.btnBack.visible=true;
		        this.btnBack.includeInLayout=true;
			    if(rs.child("resultView1List").resultView1.length()>0) {	
					errPage.clearError(event);
		            queryResult.removeAll();
					try {
					    for each ( var recData:XML in rs.resultView1List.resultView1 ) {
		 				    queryResult.addItem(recData);
					    }
            	
		        		var itrRec:int=0;
		        		for(itrRec=0;itrRec<queryResult.length;itrRec++){
		        		 	queryResult[itrRec].rowNo=itrRec;
		        		}
		        		 				    
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
			          	
			    }else if(rs.child("Errors").length()>0) {
	                //some error found
				 	queryResult.removeAll(); // clear previous data if any as there is no result now.
				 	var errorInfoSummaryList : ArrayCollection = new ArrayCollection();
	                //populate the error info list 			 	
				 	for each ( var errorSummary:XML in rs.Errors.error ) {
		 			   errorInfoSummaryList.addItem(errorSummary.toString());
					}
				 	errPage.showError(errorInfoSummaryList);//Display the error
				} else {
				 	XenosAlert.info("No Result Found!");
				 	queryResult.removeAll(); // clear previous data if any as there is no result now.
				 	errPage.removeError(); //clears the errors if any
				}
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
     	var url : String;
        if(pdfXlsFlag == true)
        	url = "rec/recXenosSecBalDispatch.action?method=generateXLS&fromPage=queryResultSecBal";
        else
        	url = "rec/recXenosSecBalDispatch.action?method=generateXLS&fromPage=queryResult";
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
     	var url : String;
     	if(pdfXlsFlag == true)
        	url = "rec/recXenosSecBalDispatch.action?method=generatePDF&fromPage=queryResultSecBal";
        else
        	url = "rec/recXenosSecBalDispatch.action?method=generatePDF&fromPage=queryResult";
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
    }     /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
      private function doNext2():void {
       
        var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.listIndex = "1";
        viewBalanceLabelDetails.url="rec/recXenosSecBalDispatch.action?";
        viewBalanceLabelDetails.request = reqObj;
        viewBalanceLabelDetails.send();
    }  
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
      private function doPrev2():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.listIndex = "1";
        viewBalanceLabelDetails.url="rec/recXenosSecBalDispatch.action?"; 
        viewBalanceLabelDetails.request = reqObj;
        viewBalanceLabelDetails.send();
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

                 if(rs.multipleBankPresent==true || rs.pageLoading == true){
                    
                    finInstClearState();
                    //accountClearState();
                    fininstPopUp.fundCodeCheck = true;
                    //stlAccForFundPopUp.fundCodeCheck = true;
                }
                
                
                if(rs.multipleBankPresent==false && rs.pageLoading == false){                    
                    
        		     fininstPopUp.bankCode.text = rs.bank;
                    //stlAccForFundPopUp.stlAccNo.text = rs.entry.bankAccountNo;
                    fininstPopUp.bankCode.editable = false;
                    fininstPopUp.finInstFundPopup.visible=false;
                    //stlAccForFundPopUp.stlAccNo.editable = false;
                    //stlAccForFundPopUp.stlAccPopup.visible = false;
                    focusManager.setFocus(serviceOffice);
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
            	//queryResult1 = event.result.recXenosSecBalActionForm as Object;      	
            	finContextList.removeAll();
        		//fininstPopUp.bankCode.text = queryResult1.bank;
        		//stlAccForFundPopUp.accountNo.text = queryResult1.accountNo;
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
 			if(null == event.result.recXenosSecBalActionForm){ 
     			if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
	            	    errPage.clearError(event); //clears the errors if any
	            	 }
	      		else{ // Must be error
	      			 errPage.displayError(event);
	      		}
	      }else {
	      	 	errPage.clearError(event);
	      	 	//queryResult1 = event.result.recXenosSecBalActionForm as Object;
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
        
        public function viewBalanceLabel(event:Event,obj:Object):void {
                var rndNo:Number = Math.random();
	        	viewBalanceLabelDetails.url="rec/recXenosSecBalDispatch.action?rnd=" + rndNo;
	        	
		        var requestObj :Object = new Object;
		        requestObj.method="viewDetails";
		        requestObj.rowNum=obj.rowNo;
                requestObj.fromPage = "queryResult";
                requestObj.SCREEN_KEY = 10020;
		        pdfXlsFlag = true;
		        viewBalanceLabelDetails.request=requestObj;
		        //balLabel=true;
		        viewBalanceLabelDetails.send();
		         //XenosAlert.info("viewBalanceLabel");
		         qh1.resetPageNo();
	        
        }   
        public function backToAccountLabel(event:Event):void {
        	   balLabel=false;
        	   pdfXlsFlag = false;
        	   submitQuery();
	        
        }    
        
        
        
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    
     public function viewDetailsResult(event:ResultEvent):void {
     	
		//var rs:XML = XML(event.result);
		rs = XML(event.result);
        //XenosAlert.info("RS :" + rs);
		if (null != event) {
			
			    if(rs.child("resultView2List").resultView2.length()>0) {	
					errPage.clearError(event);
		            queryResult.removeAll();
	            	objForm1 = rs;
	            	var tempQueryResult:ArrayCollection = new ArrayCollection(); 
	            	tempQueryResult.removeAll();
					try {
					    for each ( var rec:XML in rs.resultView2List.resultView2 ) {
		 				    tempQueryResult.addItem(rec);
					    }
	                    var tempItr:int=0;
	                    //XenosAlert.info("Inside ViewDtl");
	                    for(tempItr=0;tempItr<tempQueryResult.length;tempItr++){
	                    	//XenosAlert.info(tempQueryResult[tempItr].remarksAuditFlag);
	                    	tempQueryResult[tempItr].auditFlag=tempQueryResult[tempItr].remarksAuditFlag.toString();
	                    	//XenosAlert.info(tempQueryResult[tempItr].auditFlag);	 
	                    }
	                    
	                    
            	
	        		  var itr:int=0;
	        		  for(itr=0;itr<tempQueryResult.length;itr++){
			            rslt.selectedChild=this.balRslt;
	        		 	tempQueryResult[itr].rowNo=itr;
	        		  }
		             
		              if(tempQueryResult.length > 0 ){
		                 queryResult=tempQueryResult;			              
		              }					    
					    changeCurrentState();            
			            
			            qh.setOnResultVisibility();			            
			            qh.setPrevNextVisibility((rs.previousTraversable1 == "true")?true:false,(rs.nextTraversable1 == "true")?true:false );
			            qh.PopulateDefaultVisibleColumns();
			            qh1.setOnResultVisibility();
			            qh1.setPrevNextVisibility((rs.previousTraversable2 == "true")?true:false,(rs.nextTraversable2 == "true")?true:false );
			            qh1.PopulateDefaultVisibleColumns();
			            qh1.pdf.enabled = true;
			            qh1.xls.enabled = true;            
		     	        //replace null objects in datagrid with empty string
		            	queryResult= ProcessResultUtil.process(queryResult, resultSummary.columns);
		            	queryResult.refresh();
		            	
					}catch(e:Error){
					    //XenosAlert.error(e.toString() + e.message);
					    XenosAlert.error("No result found");
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
				 	XenosAlert.info("No Result Found!");
				 	queryResult.removeAll(); // clear previous data if any as there is no result now.
				 	errPage.removeError(); //clears the errors if any
				}		    

        }
               
    }
    
    
    public function handleOkSystemConfirm(event:Event):void {
    	this.qry.percentWidth=100;
    	this.rslt.percentWidth=0;
    	this.queryResult.removeAll();
    }
    