
 // ActionScript file for Cash Authorization
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.containers.SummaryPopup;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.rec.validators.CashAuthorizationValidator;
 
 import mx.collections.ArrayCollection;
 import mx.core.UIComponent;
 import mx.events.ResourceEvent;
 import mx.events.ValidationResultEvent;
 import mx.managers.PopUpManager;
 import mx.resources.ResourceBundle;
 import mx.rpc.events.ResultEvent;
 import mx.events.CloseEvent;
 import mx.controls.Alert;
 import com.nri.rui.core.formatters.XenosNumberFormatter;
 
    
    
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
    [Bindable]
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
        	app.submitButtonInstance = submit;
            rndNo= Math.random(); 
            dateFrom.setFocus();
            var req : Object = new Object();
	    	req.SCREEN_KEY = 10108;
            initializeAuthorizationQuery.request = req;
            initializeAuthorizationQuery.url = "rec/recAuthorization.action?method=initialExecute&rnd=" + rndNo;                    
            initializeAuthorizationQuery.send();        
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
        errPage.clearError(event); 
        submitbtn.visible = true;
        dateFrom.text = "";
        dateFrom.setFocus();
        dateTo.text = "";
        stlAccForFundPopUp.accountNo.text = "";
        fininstPopUp.bankCode.text = "";
        creationDateFrom.text = "";
        creationDateTo.text = "";
        fundPopUp.fundCode.text = "";
        if(event.result){
        loggedOnuser = event.result.recAuthorizationActionForm.loggedOnUser;
        }
        
        if(event.result){        	
        	if(event.result.recAuthorizationActionForm.serviceOfficeValues.serviceOffice is ArrayCollection){
    		initColl = event.result.recAuthorizationActionForm.serviceOfficeValues.serviceOffice as ArrayCollection;        		
        	}else{
        		initColl = new ArrayCollection();
        		initColl.addItem(event.result.recAuthorizationActionForm.serviceOfficeValues.serviceOffice);
        	}
        }
    		//new code
		tempColl = new ArrayCollection();    
		tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        serviceOffice.dataProvider = tempColl;
        
        initColl.removeAll();
        initColl1 = event.result.recAuthorizationActionForm.authorizationStatusValues.item as ArrayCollection;
    		//new code
		tempColl1 = new ArrayCollection(); 
        for(i = 0; i<initColl1.length; i++) {
            tempColl1.addItem(initColl1[i]);
        }
        authorizationStatus.dataProvider = tempColl1;
        authorizationStatus.selectedItem = tempColl1.getItemAt(2);
        submit.enabled = true;
    } 
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
     private function resetQuery():void {         
         cashAuthorizationRequest.send();
         
         stlAccForFundPopUp.accountNo.editable = true;
         stlAccForFundPopUp.accountPopup.visible = true;
         fininstPopUp.bankCode.editable = true;
         fininstPopUp.finInstFundPopup.visible = true;    
 		 // Remove the fund code should remove bank Code and Bank Account No
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
        cashAuthorizationQueryRequest.request = reqObj;
        cashAuthorizationQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        cashAuthorizationQueryRequest.request = reqObj;
        cashAuthorizationQueryRequest.send();
    } 
     
    
     /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        reqObj.SCREEN_KEY = 10109;
         reqObj.method = "submitQuery";
         reqObj.accountNo = this.stlAccForFundPopUp.accountNo.text;
         reqObj.fundCode = this.fundPopUp.fundCode.text;
         reqObj.asOfDateFrom = this.dateFrom.text;
         reqObj.asOfDateTo = this.dateTo.text;
         reqObj.creationDateFrom = this.creationDateFrom.text;
         reqObj.creationDateTo = this.creationDateTo.text;
         reqObj.serviceOffice =  (this.serviceOffice.selectedItem != null ? this.serviceOffice.selectedItem.value : "");
         reqObj.authorizationStatus =  (this.authorizationStatus.selectedItem != null ? this.authorizationStatus.selectedItem.value : "");
         reqObj.custodianCode = this.fininstPopUp.bankCode.text;
         reqObj.rnd = Math.random() + "";
         
         return reqObj;
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
         
         cashAuthorizationQueryRequest.request = requestObj; 
        
         var authResultsModel:Object={
                            Authorization:{
						         fromDate:this.dateFrom.text,
						         toDate: this.dateTo.text,
						         creationDateFrom : this.creationDateFrom.text,
						         creationDateTo : this.creationDateTo.text
						        
                            }
                           }; 
        var cashAuthorizationValidator:CashAuthorizationValidator = new CashAuthorizationValidator();
        cashAuthorizationValidator.source=authResultsModel;
        cashAuthorizationValidator.property="Authorization";
        
        var validationResult:ValidationResultEvent =cashAuthorizationValidator.validate();
         authstatus = (this.authorizationStatus.selectedItem != null ? this.authorizationStatus.selectedItem.value : "");

        if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
            resultHead.text = "";
        }else { 
            cashAuthorizationQueryRequest.send();
        }
        
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
        selectAllBind1=false;
      	if (null != event) {            
            if(null == event.result.rows){
                summaryResult.removeAll();
                summaryResult1.removeAll(); // clear previous data if any as there is no result now.
                if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
                    errPage.clearError(event); //clears the errors if any
                    XenosAlert.info("No Result Found!");
                } else { // Must be error
                    errPage.displayError(event);    
                }                
            }else {
                errPage.clearError(event);                
                summaryResult.removeAll();
                summaryResult1.removeAll();
                if(event.result.rows.row != null){
                	if(authstatus=="Authorized"){
                		authorizationStatusFlag = false;
                		authStatusFlag = false;
                		submitbtn.visible = false;
                	}else if(authstatus=="Unauthorized"){
                		authorizationStatusFlag = true;
                		authStatusFlag = true;
                		submitbtn.visible = true;
                	}else{
                		authorizationStatusFlag = true;
                		authStatusFlag = false;
                		submitbtn.visible = true;
                	}
                	if(event.result.rows.row is ArrayCollection) {
                            summaryResult = event.result.rows.row as ArrayCollection;
                    } else {                            
                            summaryResult.addItem(event.result.rows.row);
                    }
                resetSellection(summaryResult);
                for(var i:int=0; i<summaryResult.length;i++){
                            summaryResult[i].selectedAuth=false;
                            summaryResult[i].selectedCan=false;
                }
                changeCurrentState(); 
                    
                }else{                    
                    XenosAlert.info("No Results Found");
                }
                //changeCurrentState();
               
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
		selectAllBind1=false;
		selectedResults = new ArrayCollection();
	        selectedResultsCan = new ArrayCollection();
       // conformSelectedResults = new Array();
		if (null != event) {
			if(rs.child("row").length()>0) {
				errPage.clearError(event);
	            summaryResult.removeAll();
	           	try {
	           		if(rs != null){
                	if(authstatus=="Authorized"){
                		authorizationStatusFlag = false;
                		authStatusFlag = false;
                		submitbtn.visible = false;
                	}else if(authstatus=="Unauthorized"){
                		authorizationStatusFlag = true;
                		authStatusFlag = true;
                		submitbtn.visible = true;
                	}else{
                		authorizationStatusFlag = true;
                		authStatusFlag = false;
                		submitbtn.visible = true;
                	}
              }
				    for each ( var rec:XML in rs.row ) {
	 				    summaryResult.addItem(rec);
				    }
				    resetSellection(summaryResult);
				    for(var i:int=0; i<summaryResult.length;i++){
				    		var obj:XML = summaryResult[i];
                            obj.selectedAuth=false;
                            obj.selectedCan=false;
                            summaryResult[i] = obj;
                     }
				    
				    
	            	//setIfAllSelected();
				    changeCurrentState();
				    
	            	
				    
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
				    currentState = "";
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
				currentState = "";
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
        //var title:String = this.parentApplication.xResourceManager.getKeyValue('rec.label.authorization') + " " + this.parentApplication.xResourceManager.getKeyValue('inf.title.query');
        //if(title!= null)
        //    this.parentDocument.title = title;
     } 
    
        
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
       /*  var url : String = "rec/cashReReconcile.action?method=generatePDF";
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
    		summaryResult[i].rowNumInt= i;
    		
    		if(summaryResult[i].userId==loggedOnuser){
    			summaryResult[i].view = false;
    			summaryResult[i].viewcheck = false;
    		}else{
    			summaryResult[i].view = true;	
    			if(i==0){
    		groupId= summaryResult[i].groupId;
    		summaryResult[i].viewcheck = true;
    		}
    		else if(i>0){
    			if(summaryResult[i].groupId==summaryResult[i-1].groupId){
    				summaryResult[i].viewcheck = false;
    			}
    			else{
    				groupId = summaryResult[i].groupId;
    				summaryResult[i].viewcheck = true;
    			}
    		}
    		}
    	}
    }
     public function checkSelectToModify(item:Object):void {
        var tempArray:Array = new Array();
        var isSelected:Boolean = (item.selectedAuth=="true")?true:false;
        if(isSelected){ 
        // needs to insert
        	var obj:Object=new Object();
        	obj.rowNumInt=item.rowNumInt;
        	obj.groupId=item.groupId;
        	for(var i:int=0;i<summaryResult.length;i++){
        		var obj1:Object=new Object();
        		if(summaryResult[i].userId!=loggedOnuser){
        		if(obj.groupId==summaryResult[i].groupId){
        			obj1.rowNumInt=i;
        			obj1.groupId=obj.groupId;
        			selectedResults.addItem(obj1);
        		}
        		}
        	}
    	}else {
    	//needs to pop
    		var obj3:Object=new Object();
    		
        	obj3.rowNumInt=item.rowNumInt;
        	obj3.groupId=item.groupId;
        	tempArray=selectedResults.toArray();
    	    selectedResults.removeAll();
    	    for(i=0; i<tempArray.length; i++){
    			if(tempArray[i].groupId != item.groupId){
    			    selectedResults.addItem(tempArray[i]);
    			   
    			}
    		} 
    	} 
    	//conformSelectedResults=	selectedResults;
    }
     public function checkSelectToModifyCan(item:Object):void {
     	 var tempArray:Array = new Array();
     	 var isSelected:Boolean = (item.selectedCan=="true")?true:false;
       if(isSelected){  // needs to insert    
        //XenosAlert.info("selected:"+item.rowNumInt); 		
        	var obj:Object=new Object();
        	obj.rowNumInt=item.rowNumInt;
        	obj.groupId=item.groupId;
        	for(var i:int=0;i<summaryResult.length;i++){
        		var obj1:Object=new Object();
        		if(summaryResult[i].userId!=loggedOnuser){
        		if(obj.groupId==summaryResult[i].groupId){
        			obj1.rowNumInt=i;
        			obj1.groupId=obj.groupId;
        			selectedResultsCan.addItem(obj1);
        		}
        		}
        	}
    	}else { //needs to pop
    		var obj3:Object=new Object();
    		//XenosAlert.info("deselected:"+item.rowNumInt); 	
        	obj3.rowNumInt=item.rowNumInt;
        	obj3.groupId=item.groupId;
        	tempArray=selectedResultsCan.toArray();
    	    selectedResultsCan.removeAll();
    	    for(i=0; i<tempArray.length; i++){
    			if(tempArray[i].groupId != item.groupId){
    			    selectedResultsCan.addItem(tempArray[i]);
    			   
    			}
    		} 
    	} 
    	//conformSelectedResultsCan=	selectedResultsCan;
    }
     
    
     public function showResult(event:Event):void {
		var i:Number;
		var netAmt:Number = 0;
		var numberFormatter:XenosNumberFormatter = new XenosNumberFormatter();
		numberFormatter.useThousandsSeparator = true;
		numberFormatter.precision = 2;
		conformSelectedResults=	selectedResults;
		if(conformSelectedResults.length > 0 ){
			for(i=0; i<conformSelectedResults.length; i++){
    			var rowNo:int = conformSelectedResults[i].rowNumInt;
    			if(Number(this.summaryResult.getItemAt(rowNo).custAmount) != 0){
    				var custAmt:Number = Number(this.summaryResult.getItemAt(rowNo).custAmount);
		    		if(XenosStringUtils.equals(this.summaryResult.getItemAt(rowNo).custDbCr,"C") || 
		    		   XenosStringUtils.equals(this.summaryResult.getItemAt(rowNo).custDbCr,"RD")){
		    			netAmt = Number((netAmt - custAmt).toFixed(3));
		    		} else {
		    			netAmt = Number((netAmt + custAmt).toFixed(3));
		    		}
		    	}
		    	if(Number(this.summaryResult.getItemAt(rowNo).ncmAmount) != 0){
		    		var ncmAmt:Number = Number(this.summaryResult.getItemAt(rowNo).ncmAmount);
		    		if(XenosStringUtils.equals(this.summaryResult.getItemAt(rowNo).ncmDbCr,"C") || 
		    		   XenosStringUtils.equals(this.summaryResult.getItemAt(rowNo).ncmDbCr,"RD")){
		    			netAmt = Number((netAmt +  ncmAmt).toFixed(3));
		    		} else {
		    			netAmt = Number((netAmt -  ncmAmt).toFixed(3));
		    		}
		    	}
    		}
    		if(netAmt != 0){
		    	var netAmtStr:String = "";
		    	if(netAmt < 0){
		    		netAmtStr = netAmt.toString().substring(1);
		    	} else {
		    		netAmtStr = netAmt.toString();
		    	}
		    	netAmtStr = numberFormatter.format(netAmtStr);      
//				XenosAlert.confirm("Total Amount of Movements selected for Force Match ["+netAmtStr+"]. " + 
//						"Are you sure you want to proceed? Please confirm.",confirmAuthorizationHandler);
				XenosAlert.confirm("Some of the pairs you are going to Force Match DO NOT NET 0. Please check details.",confirmAuthorizationHandler);

			} else {
				doAuthorizationEntry();
			}
		} else {
			doAuthorizationEntry();
		} 
		     	
     } 
     
     /**
	  * Confirm Handeler.
	  */    
	 private function confirmAuthorizationHandler(event:CloseEvent):void {
	     if (event.detail == Alert.YES) {
			doAuthorizationEntry();
	     } 
	 }
     
     public function doAuthorizationEntry():void {
     	var i:Number;
        var obj:Object=new Object();
        obj.SCREEN_KEY = 10110;        
    	var chkBoxArray:Array = new Array();      
    	var chkBoxArray1:Array = new Array();
    	conformSelectedResults=	selectedResults;
    	conformSelectedResultsCan=	selectedResultsCan;
		if(conformSelectedResults.length > 0 ){
			selectifAny = true;
			obj.method="doPreConfirmAuthorize";
			for(i=0; i<conformSelectedResults.length; i++){
    			chkBoxArray[i] =conformSelectedResults[i].rowNumInt;
    		}
    		obj.selectedAuhtorizeArray = null;
    		obj.selectedAuhtorizeArray = chkBoxArray;
		 	
		} 
		if(conformSelectedResultsCan.length > 0){
			selectifAny = true;
			obj.method="doPreConfirmAuthorize";
			for(i=0; i<conformSelectedResultsCan.length; i++){
    			chkBoxArray1[i] =conformSelectedResultsCan[i].rowNumInt;
    		}
    		obj.selectedCancelArray = null;
    		obj.selectedCancelArray = chkBoxArray1;
		}		
		if((conformSelectedResultsCan.length > 0) || (conformSelectedResults.length > 0 )){
			
		}else{			
			selectifAny = false;
			XenosAlert.info("Please select a checkBox");
		}		
		if(selectifAny){
		cashAuthorizationConfirmRequest.request=obj;
		cashAuthorizationConfirmRequest.send();
		}
     } 
          
     public function LoadConfirmationOueryPage(event:ResultEvent):void {
     	
		var sPopup : SummaryPopup;	
		var parentApp :UIComponent = UIComponent(this.parentApplication);
		sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
		sPopup.addEventListener("OkSystemConfirm",handleOkSystemConfirm);
		sPopup.title = this.parentApplication.xResourceManager.getKeyValue('rec.label.authorize.user.confirmation');
		sPopup.width = parentApp.width - 100;;
		sPopup.height =parentApp.height - 100;;
		sPopup.owner=this;
		sPopup.showCloseButton=false;
		
		PopUpManager.centerPopUp(sPopup);
		sPopup.moduleUrl = "assets/appl/rec/RecAuthConfirmationPopup.swf";
     	
     }
     /**
	 * Event handler for the "OkSystemConfirm" custom event.
	 */
	public function handleOkSystemConfirm(event:Event):void {
        this.cashAuthorizationQueryRequest.send();	
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
 			if(null == event.result.recAuthorizationActionForm){ 
     			if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
	            	   errPage.clearError(event); //clears the errors if any
	      			 }
	      		else{ // Must be error
	      			 errPage.displayError(event);
	      		}
	      }else {
	      		errPage.clearError(event);	      	 	
            	queryResult = event.result.recAuthorizationActionForm as Object;      	
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
     	} */
     	
     	
     	
     	var rs:XML = XML(event.result);
     	
     	
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
	      	} else {
	      	 	
	      	 	errPage.removeError();
	      	 	
	      	 	if (rs.multipleBankPresent==true || rs.pageLoading == true) {
					finInstClearState();
				}
				
				if (rs.multipleBankPresent == false && rs.pageLoading == false) {
					fininstPopUp.bankCode.text = rs.bank;
					fininstPopUp.bankCode.editable = false;
                    fininstPopUp.finInstFundPopup.visible = false;
				}
				
				if (rs.multipleBankAccountPresent==true || rs.pageLoading == true) {
					accountClearState();
                    stlAccForFundPopUp.fundCodeCheck = true;
				}
				
				if (rs.multipleBankAccountPresent == false && rs.pageLoading == false) {
					stlAccForFundPopUp.accountNo.text = rs.accountNo;
                    stlAccForFundPopUp.accountNo.editable = false;
                    stlAccForFundPopUp.accountPopup.visible = false;
				}
	      	 	
	      	 	
            	finContextList.removeAll();
        		fininstPopUp.bankCode.text = rs.custodianCode;
        		stlAccForFundPopUp.accountNo.text = rs.accountNo;
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
 		
 		var rs:XML = XML(event.result);
 		
 		if (null != event) {
 			if (null == event.result.recAuthorizationActionForm){ 
     			if (null == event.result.XenosErrors) { // i.e. No result but no Error found.
	            	errPage.clearError(event); //clears the errors if any
	            } else { // Must be error
	      			errPage.displayError(event);
	      		}
	      } else {
	      	 	errPage.clearError(event);
	      	 	queryResult = event.result.recAuthorizationActionForm as Object;
	      	 	
	      	 	if (rs.multipleBankAccountPresent==true || rs.pageLoading == true) {
                    accountClearState();
                    stlAccForFundPopUp.fundCodeCheck = true;
                }
	      	 	if (rs.multipleBankAccountPresent==false && rs.pageLoading == false) {
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
    
   
