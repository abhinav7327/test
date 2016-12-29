// ActionScript file

 // ActionScript file for Receive Notice Query
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.HiddenObject;
    import com.nri.rui.core.utils.ProcessResultUtil;
    import com.nri.rui.stl.validators.ReceiveNoticeValidator;
    
    import mx.collections.ArrayCollection;
    import mx.events.ValidationResultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.utils.StringUtil;
    
     
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
    private var queryResult1:ArrayCollection= new ArrayCollection();
    [Bindable]
    private var queryResult2:ArrayCollection= new ArrayCollection();

    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    private var initCompFlg : Boolean = false;
    private var matchFilter : String = "N";
    
    /**
     * This is the method to pass the Collection of data items
     * through the context to the FinInst popup. This will be implemented as per specifdic  
     * requirement. 
     */
    private function populateFinInstRole():ArrayCollection {
    	//pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
        
        var bankRoleArray : Array = new Array(3);
        bankRoleArray[0] = "Security Broker";
        bankRoleArray[1] = "Bank/Custodian";
        bankRoleArray[2] = "Central Depository";
        myContextList.addItem(new HiddenObject("bankRoles",bankRoleArray));
        
        return myContextList;
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
        var cpTypeArray:Array = new Array(2);
            cpTypeArray[0]="BROKER";
            cpTypeArray[1]="BANK/CUSTODIAN";
            //cpTypeArray[1]="CLIENT";
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
        return myContextList;
    }
    /**
     * 
     */
    private function MatchFilter():void{
        if(matchFilterFlag.selected=true)
            matchFilter = "Y";
        else
            matchFilter = "N";
    }    
    /**
     * This method will be called at the time of the loading this module and pressing the reset button.
     * 
     */
    private function initPageStart():void {   
    	        
        if (!initCompFlg) {            
            var req : Object = new Object();
            req.SCREEN_KEY = 632;
            initializeReceiveNoticeQuery.request = req;
            initializeReceiveNoticeQuery.url = "stl/receiveNoticeQueryDispatch.action?method=initialExecute&screenType=M";                    
            initializeReceiveNoticeQuery.send();        
        } else
            XenosAlert.info("Already Initiated!");
         
    }
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * 
    */   
    private function initPage(event: ResultEvent) : void {
        var i:int = 0;
        var selIndx:int=0;
        var dateStr:String = null;
        var initColl:ArrayCollection = new ArrayCollection();
        var tempColl: ArrayCollection;
        
        errPage.clearError(event); //clears the errors if any 
        
        //Initialize the Field values
        cpBank.finInstCode.text = "";
        cpAccount.text = "";
        ourBank.finInstCode.text = "";
        ourBankAccount.accountNo.text = "";
        securityId.instrumentId.text = "";
        ccy.ccyText.text = "";
        correspondingSecurityId.instrumentId.text = "";
        rcvdCompNoticeRefNo.text = "";
        senderReferenceNo.text = "";
        chkbox1.selected = false;
        chkbox2.selected = false;
        chkbox3.selected = false;
        chkbox4.selected = false;
        chkbox5.selected = false;
        chkbox6.selected = false;        
        chkbox7.selected = false;
        chkbox8.selected = false;        
        chkbox9.selected = false;        
        chkbox10.selected = false;
        chkbox11.selected = false;
        chkbox12.selected = false;        
        matchFilterFlag.selected = false;
        
        if(event == null || event.result == null || event.result.receivedNoticeQueryActionForm == null){
            XenosAlert.error("Failed to Initialize the Form");
            return;
        }
         
        //1. Setting values of the reasonCodeListForRecvNotice
        initColl.removeAll();
        if(event.result.receivedNoticeQueryActionForm.reasonCodeListForRecvNotice.item != null) {
            if(event.result.receivedNoticeQueryActionForm.reasonCodeListForRecvNotice.item is ArrayCollection)
                initColl = event.result.receivedNoticeQueryActionForm.reasonCodeListForRecvNotice.item as ArrayCollection;
            else
                initColl.addItem(event.result.receivedNoticeQueryActionForm.reasonCodeListForRecvNotice.item);
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        selIndx = 0;
        for(i = 0; i<initColl.length; i++) {                      
            tempColl.addItem(initColl[i]);            
        }
        recvNoticeReasonCode.dataProvider = tempColl;
        //Set the default value object
        //recvNoticeReasonCode.selectedItem = tempColl.getItemAt(selIndx);
        
        //2.Setting value of SettlementDateFrom & To
        if(event.result.receivedNoticeQueryActionForm.settlementDateFrom!= null) {
            dateStr=event.result.receivedNoticeQueryActionForm.settlementDateFrom;
            if(dateStr != null)
                settlementDateFrom.selectedDate = DateUtils.toDate(dateStr); 
                //XenosAlert.info("dateStr "+dateStr);               
        } else {
            XenosAlert.error("Settlement Date From cannot be initialized.");
        }
        if(event.result.receivedNoticeQueryActionForm.settlementDateTo!= null) {
            dateStr=event.result.receivedNoticeQueryActionForm.settlementDateTo;
            if(dateStr != null)
                settlementDateTo.selectedDate = DateUtils.toDate(dateStr); 
                //XenosAlert.info("dateStr "+dateStr);               
        } else {
            XenosAlert.error("Settlement Date To cannot be initialized.");
        }
        //3. Setting values of the finInstGroupList
        initColl.removeAll();
        if(event.result.receivedNoticeQueryActionForm.finInstGroupList.item != null) {
            if(event.result.receivedNoticeQueryActionForm.finInstGroupList.item is ArrayCollection)
                initColl = event.result.receivedNoticeQueryActionForm.finInstGroupList.item as ArrayCollection;
            else
                initColl.addItem(event.result.receivedNoticeQueryActionForm.finInstGroupList.item);
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        selIndx = 0;
        for(i = 0; i<initColl.length; i++) {                      
            tempColl.addItem(initColl[i]);            
        }
        finInstGroup.dataProvider = tempColl;
        //3. Setting values of the dataSourceValues
        initColl.removeAll();
        if(event.result.receivedNoticeQueryActionForm.dataSourceValues.item != null) {
            if(event.result.receivedNoticeQueryActionForm.dataSourceValues.item is ArrayCollection)
                initColl = event.result.receivedNoticeQueryActionForm.dataSourceValues.item as ArrayCollection;
            else
                initColl.addItem(event.result.receivedNoticeQueryActionForm.dataSourceValues.item);
        }
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        selIndx = 0;
        for(i = 0; i<initColl.length; i++) {                      
            tempColl.addItem(initColl[i]);            
        }
        dataSource.dataProvider = tempColl;
        
	    initCompFlg = true;   
    }
    
    public function submitQuery():void{
    	
    	//Reset Page No
    	 qh.resetPageNo();
    	 qh2.resetPageNo();    	
     	//Set the request parameters
     	var requestObj :Object = populateRequestParams();
     	
     	receiveNoticeQueryRequest.request = requestObj; 
    	var reciveModel:Object={
                            receiveQuery:{
                                 settleDateFrom:this.settlementDateFrom.text,
                                 settleDateTo:this.settlementDateTo.text                                          
                            }
                           }; 
		var receiveNoticeValidator:ReceiveNoticeValidator = new ReceiveNoticeValidator();
		receiveNoticeValidator.source=reciveModel;
		receiveNoticeValidator.property="receiveQuery";
		var validationResult:ValidationResultEvent =receiveNoticeValidator.validate();
		
		if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            //trace(errorMsg);
            XenosAlert.error(errorMsg);
        }
        else{
    	    receiveNoticeQueryRequest.send();  
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
     	reqObj.SCREEN_KEY = 633;
     	
     	reqObj.cpBank = cpBank.finInstCode.text;
     	reqObj.cpExtAccount = cpAccount.text;
     	reqObj.ourBank = ourBank.finInstCode.text;
     	reqObj.ourBankAccount = ourBankAccount.accountNo.text;
     	reqObj.securityId = securityId.instrumentId.text;
     	reqObj.ccy = ccy.ccyText.text;
     	reqObj.correspondingSecurityId = this.correspondingSecurityId.instrumentId.text;
     	reqObj.recvNoticeReasonCode = this.recvNoticeReasonCode.selectedItem != null ?  this.recvNoticeReasonCode.selectedItem.value : "";
     	reqObj.settlementDateFrom = this.settlementDateFrom.text;
     	
     	reqObj.settlementDateTo = this.settlementDateTo.text;
     	reqObj.rcvdCompNoticeRefNo = this.rcvdCompNoticeRefNo.text;
     	reqObj.finInstGroup = this.finInstGroup.selectedItem != null ?  StringUtil.trim(this.finInstGroup.selectedItem.value) : "";
     	reqObj.senderReferenceNo = this.senderReferenceNo.text;
     	
     	var instructionTypeArray:Array = new Array();     	
     	var messageTypeArray:Array = new Array();     	
     	
    	if(chkbox1.selected)
    		messageTypeArray.push(chkbox1.name);
    	if(chkbox2.selected)
    		messageTypeArray.push(chkbox2.name);
    	if(chkbox3.selected)
    		messageTypeArray.push(chkbox3.name);
    	if(chkbox4.selected)
    		messageTypeArray.push(chkbox4.name);
    	if(chkbox5.selected)
    		messageTypeArray.push(chkbox5.name);
    	if(chkbox6.selected)
    		messageTypeArray.push(chkbox6.name);
    		
    	if(chkbox7.selected)
    		instructionTypeArray.push(chkbox7.name);
        if(chkbox8.selected)
    		instructionTypeArray.push(chkbox8.name);
    	if(chkbox9.selected)
    		instructionTypeArray.push(chkbox9.name);
    	if(chkbox10.selected)
    		instructionTypeArray.push(chkbox10.name);
    	if(chkbox11.selected)
    		instructionTypeArray.push(chkbox11.name);
    	if(chkbox12.selected)
    		instructionTypeArray.push(chkbox12.name);
    		
        messageTypeArray.push("");
     	instructionTypeArray.push("");
     	
        reqObj.messageTypeArray = messageTypeArray;		
        reqObj.instructionTypeArray = instructionTypeArray;
     	
     	reqObj.dataSource = this.dataSource.selectedItem != null ?  this.dataSource.selectedItem.value : "";
     	reqObj.matchFilterFlag = this.matchFilterFlag.selected;
     	reqObj.matchFilter = this.matchFilter;     	
     	
        reqObj.rnd = Math.random() + "";
     	return reqObj;
    }
    /**
     * This method sends the HttpService for reset operation.
     * 
     */    
    public function resetQuery():void{
        var reqObj : Object = new Object();
     	reqObj.rnd = Math.random();
        receiveNoticeResetQueryRequest.request = reqObj;
        
        receiveNoticeResetQueryRequest.send();
    	
    }
    private function loadResultPage(event:ResultEvent):void {
        var rs:XML = XML(event.result);
        var rs1:XML = null;
        var rs2:XML = null;
        
        if (null != event && rs != null) {
            if(rs.child("Errors").length()>0) {
                //some error found
				queryResult1.removeAll(); // clear previous data if any as there is no result now.
				queryResult2.removeAll(); // clear previous data if any as there is no result now.
				var errorInfoList : ArrayCollection = new ArrayCollection();
				//populate the error info list 			 	
				for each ( var error:XML in rs.Errors.error ) {
					errorInfoList.addItem(error.toString());
				}
				errPage.showError(errorInfoList);//Display the error
            }else{
                rs1 = XML(rs.ResultViewList1);
                rs2 = XML(rs.ResultViewList2);
                if(null != rs1 && rs1.child("row").length()>0) {
    				errPage.clearError(event);
    				queryResult1.removeAll();
    				try {
    					for each ( var rec:XML in rs1.row ) {
    						queryResult1.addItem(rec);
    					}
    					qh.setOnResultVisibility();
    	
    					qh.setPrevNextVisibility((rs.previousTraversable1 == "true")?true:false, 
    					                         (rs.nextTraversable1 == "true")?true:false);
    					                         
    					qh.PopulateDefaultVisibleColumns();
    					
    					//replace null objects in datagrid with empty string
    					queryResult1=ProcessResultUtil.process(queryResult1, 
    					                                      receiveNoticeOutQueryResult.columns);
    					
    					queryResult1.refresh();
    				} catch(e:Error) {
    					XenosAlert.error("No Result Found ReceiveNotice Original QueryResult" + e.getStackTrace());
    				}
    			}else{
    			    queryResult1.removeAll();            
			        XenosAlert.info("No Result Found For ReceiveNotice Outgoing QueryResult");
    			}
    			if(null != rs2 && rs2.child("row").length()>0) {
    				errPage.clearError(event);
    				queryResult2.removeAll();
    				try {
    					for each ( var recr:XML in rs2.row ) {
    						queryResult2.addItem(recr);
    					}
    					qh2.setOnResultVisibility();
    	
    					qh2.setPrevNextVisibility((rs.previousTraversable2 == "true")?true:false, 
    					                         (rs.nextTraversable2 == "true")?true:false);
    					                         
    					qh2.PopulateDefaultVisibleColumns();
    					
    					//replace null objects in datagrid with empty string
    					queryResult2=ProcessResultUtil.process(queryResult2, 
    					                                      receiveNoticeInQueryResult.columns);
    					
    					queryResult2.refresh();
    				} catch(e:Error) {
    					XenosAlert.error("No Result Found ReceiveNotice QueryResult" + e.getStackTrace());
    				}
    			}else{
    			    queryResult2.removeAll();            
			        XenosAlert.info("No Result Found For ReceiveNotice Incoming QueryResult.");
    			}    			
    			changeCurrentState();
            }
        }else{
            queryResult1.removeAll();
            queryResult2.removeAll();
			XenosAlert.info("No Result Found");
            
        }
    }
    /**
	 * This method should be called on creationComplete of the datagrid 
	 */ 
	 private function bindDataGrid():void {
		qh.dgrid = receiveNoticeOutQueryResult;
	}
	private function bindDataGrid2():void {
	    qh2.dgrid = receiveNoticeInQueryResult;
	}
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
    	var url : String = "stl/receiveNoticeQueryDispatch.action?pageId=out&method=generateXLS&rnd="+Math.random();
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
    	var url : String = "stl/receiveNoticeQueryDispatch.action?pageId=out&method=generatePDF&rnd=" + Math.random();
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
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
     private function doNext():void { 
        var reqObj : Object = new Object();
    	reqObj.method = "doNext";//receiveNoticeQueryDispatch.action?method=doNext&listIndex=0
    	reqObj.listIndex = "0";
        reqObj.rnd = Math.random()+"";
    	receiveNoticeQueryRequest.request = reqObj;
        receiveNoticeQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
		var reqObj : Object = new Object();
    	reqObj.method = "doPrevious"; // receiveNoticeQueryDispatch.action?method=doPrevious&listIndex=0
    	reqObj.listIndex = "0";
        reqObj.rnd = Math.random()+"";
    	receiveNoticeQueryRequest.request = reqObj;
        receiveNoticeQueryRequest.send();
    }
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls2():void {
    	var url : String = "stl/receiveNoticeQueryDispatch.action?pageId=in&method=generateXLS&rnd="+Math.random();
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
     private function generatePdf2():void {
    	var url : String = "stl/receiveNoticeQueryDispatch.action?pageId=in&method=generatePDF&rnd="+Math.random();
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
     private function doPrint2():void{
    	/* var printObject:XenosPrintView = new XenosPrintView();
    	printObject.frmPrintHeader.lbl.text = "Cam Movement Query";
    	printObject.pDataGrid.dataProvider = movementSummary.dataProvider;
	    PrintDG.printAll(printObject); */
    } 
    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
     private function doNext2():void { 
        var reqObj : Object = new Object();
    	reqObj.method = "doNext";  //receiveNoticeQueryDispatch.action?method=doNext&listIndex=1
    	reqObj.listIndex = "1";
        reqObj.rnd = Math.random()+"";
    	receiveNoticeQueryRequest.request = reqObj;
        receiveNoticeQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev2():void { 
		var reqObj : Object = new Object();
    	reqObj.method = "doPrevious"; //receiveNoticeQueryDispatch.action?method=doPrevious&listIndex=1
    	reqObj.listIndex = "1";
        reqObj.rnd = Math.random()+"";
    	receiveNoticeQueryRequest.request = reqObj;
        receiveNoticeQueryRequest.send();
    }
    