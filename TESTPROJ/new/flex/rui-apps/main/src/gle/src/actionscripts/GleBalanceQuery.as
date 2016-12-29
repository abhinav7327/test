
 // ActionScript file for Gle Journal Query
 

    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.HiddenObject;
    import com.nri.rui.gle.validators.GleBalanceValidator;
    
    import mx.collections.ArrayCollection;
    import mx.events.ResourceEvent;
    import mx.events.ValidationResultEvent;
    import mx.resources.ResourceBundle;
    import mx.rpc.events.ResultEvent;
    
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    private var balanceType : String = new String();
    /**
	 * This method should be called on creationComplete of the datagrid 
	 */ 
	 private function bindDataGrid():void {
	 	//resultSummary.includeInLayout = false;
	 	//resultSummary.visible = false;
		qh.dgrid = resultSummary;
		//qh.columnsButton.includeInLayout = false;        RAKESH
	} 
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    private function initPageStart():void {            
        if (!initCompFlg) {    
            rndNo= Math.random();
            var req : Object = new Object();
   			req.SCREEN_KEY = 281;
    	    initializeGleBalanceQuery.request = req;         
            initializeGleBalanceQuery.url = "gle/gleBalanceQueryDispatch.action?method=initialExecute&rnd=" + rndNo;                    
            initializeGleBalanceQuery.send();
        } else
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.initiate'));
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
        
        errPage.clearError(event); // Clears Error
        //initiate text fields
        ledgerCodeFrom.gleCode.text = "";
        ledgerCodeTo.gleCode.text = "";
        ccyBox.ccyText.text = "";        
        subLedgerCode.accountNo.text = "";
        balanceEntryDate.text = ""; 
        trialBalancePopUp.trialBalanceId.text = "";
        consolidateTB.selected = false;
        ledgerCodeFrom.gleCode.setFocus();  
                
        /*instPopUp.instrumentId.text="";
        instrumentType.text = "";
    	fndCode.text = "";
    	issueCcyBox.ccyText.text = ""; */
        
        if(event.result == null || event.result.gleBalanceQryActionForm == null){
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('gle.label.error.occured.initialize'));
        }/*else
            XenosAlert.info("Got the result.......");*/        
        
        //1.Setting value of ledgerCodeFrom
        if(event.result.gleBalanceQryActionForm.ledgerCodeFrom!= null) {
            ledgerCodeFrom.gleCode.text=event.result.gleBalanceQryActionForm.ledgerCodeFrom;            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('gle.ledger.error.occured.initialize.ledgercodefrom'));
        }
        
        //2.Setting value of balanceEntryDate
        if(event.result.gleBalanceQryActionForm.balanceEntryDate != null) {
            dateStr=event.result.gleBalanceQryActionForm.balanceEntryDate;
            //XenosAlert.info("App Date :: " + dateStr + "date = " + dateStr.substr(0,4) + dateStr.substr(4,2) + dateStr.substr(6,2));
            if(dateStr != null){
            	balanceEntryDate.selectedDate = DateUtils.toDate(dateStr);
            	balanceEntryDate.text = dateStr;   
               // balanceEntryDate.selectedDate = new Date(dateStr.substr(0,4),(Number(dateStr.substr(4,2))-1),dateStr.substr(6,2));
            }
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('gle.balance.error.occured.entrydate'));
        }
        
        //3. Setting values of the balanceTypes
        initColl.removeAll();
       if(event.result.gleBalanceQryActionForm.balanceTypes.balanceTypeValues != null) {
            if(event.result.gleBalanceQryActionForm.balanceTypes.balanceTypeValues is ArrayCollection)
                initColl = event.result.gleBalanceQryActionForm.balanceTypes.balanceTypeValues as ArrayCollection;
            else
                initColl.addItem(event.result.gleBalanceQryActionForm.balanceTypes.balanceTypeValues);
        }
    
        tempColl = new ArrayCollection();
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        balanceType = tempColl[0].valueOf();
        
        //balanceType.dataProvider = tempColl;*/
        
        //4. Setting values of the trialBalanceTypes
        initColl.removeAll();
  /*      if(event.result.gleBalanceQryActionForm.trialBalanceTypes.item != null) {
            if(event.result.gleBalanceQryActionForm.trialBalanceTypes.item is ArrayCollection)
                initColl = event.result.gleBalanceQryActionForm.trialBalanceTypes.item as ArrayCollection;
            else
                initColl.addItem(event.result.gleBalanceQryActionForm.trialBalanceTypes.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }*/
        //trialBalanceId.dataProvider = tempColl;
       
    }
    /**
    * It sends/submits the query. 
    * 
    */
    private function submitQuery():void 
    {  
	
		var dateLabel:String = this.parentApplication.xResourceManager.getKeyValue('gle.label.date');
		var dateValue:String = this.balanceEntryDate.text;
		if (!DateUtils.validateBaseDate(errPage, "GLE", dateLabel, dateValue)) {
			return;
		}
		
        //Reset Page No
    	qh.resetPageNo();
        //Set the request parameters
     	var requestObj :Object = populateRequestParams();
     	
     	gleBalanceQueryRequest.request = requestObj; 
        var gleBalanceModel:Object={
                            gleBalance:{
                                ledgerCodeFrom : this.ledgerCodeFrom.gleCode.text,
                                ledgerCodeTo : this.ledgerCodeTo.gleCode.text,
                                currency : this.ccyBox.ccyText.text,
                                balanceEntryDate : this.balanceEntryDate.text,
                                balanceType : this.balanceType
                            }
                           }; 
        var gleBalanceValidator:GleBalanceValidator = new GleBalanceValidator();
        gleBalanceValidator.source=gleBalanceModel;
        gleBalanceValidator.property="gleBalance";
        
        var validationResult:ValidationResultEvent =gleBalanceValidator.validate();

        if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);            
        }else {            
            //send the submit request */
            gleBalanceQueryRequest.send();
        }               
    }
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	reqObj.SCREEN_KEY = 282;
    	reqObj.method = "doQuery";
    	reqObj.ledgerCodeFrom = this.ledgerCodeFrom.gleCode.text;
    	reqObj.ledgerCodeTo = this.ledgerCodeTo.gleCode.text;
    	reqObj.currency = this.ccyBox.ccyText.text;
    	reqObj.subLedgerCode = this.subLedgerCode.accountNo.text;
    	reqObj.balanceEntryDate = this.balanceEntryDate.text;
    	reqObj.balanceType = this.balanceType;
    	//reqObj.trialBalanceId = (this.trialBalanceId.selectedItem != null ? this.trialBalanceId.selectedItem.value : "");
    	reqObj.trialBalanceId = this.trialBalancePopUp.trialBalanceId.text;
    	if(this.consolidateTB.selected)
    		reqObj.consolidateTB = true;
    	else {
    		reqObj.consolidateTB = false;
    	}	
    	
    	
    	
    	/*
    	var params:String="ledgerCodeFrom="+this.ledgerCodeFrom.text +"&"+
    					  "ledgerCodeTo="+this.ledgerCodeTo.text + "&" +
    					  "currency="+this.ccyBox.ccyText.text+"&" +
    					  "subLedgerCode="+this.subLedgerCode.accountNo.text+"&"+
    					  "balanceEntryDate="+this.balanceEntryDate.text+"&"+
    					  "balanceEntryDateTo="+this.balanceEntryDateTo.text+"&"+	
    					  "balanceType="+(this.balanceType.selectedItem != null ? this.balanceType.selectedItem.value : "")+"&"+
    					  "trialBalanceId="+(this.trialBalanceId.selectedItem != null ? this.trialBalanceId.selectedItem.value : "")+"&";
    	
    	XenosAlert.info(params);
    	*/
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
    	gleBalanceQueryRequest.request = reqObj;
        gleBalanceQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
		var reqObj : Object = new Object();
    	reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
    	gleBalanceQueryRequest.request = reqObj;
        gleBalanceQueryRequest.send();
    }
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
    private function resetQuery():void { 
        gleBalanceResetQueryRequest.send();
    }
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    private function loadSummaryPage(event:ResultEvent):void {
     	//changeColumnOrder(event);
		var rs:XML = XML(event.result);
	
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
	            	
	             	summaryResult.refresh();
	             	processResult(); 
	             	 if((this.consolidateTB.selected) || !(this.trialBalancePopUp.trialBalanceId.text == ""))
            			trialbalance.visible = false;
            		else 
             			trialbalance.visible = true;
				}catch(e:Error){
				    //XenosAlert.error(e.toString() + e.message);
				    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
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
			 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			 	summaryResult.removeAll(); // clear previous data if any as there is no result now.
			 	errPage.removeError(); //clears the errors if any
			 }
		
        }
     }
    
	/**
	 * Loading the initial configuaration.
	 * 
	 */
	private function loadAll():void {
    }
    /**
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specifdic  
      * requriment. 
      */
    private function populateContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
      
        //passing counter party type  (BROKER|BANK/CUSTODIAN|INTERNAL)              
        var cpTypeArray:Array = new Array(3);
            cpTypeArray[0] = "BROKER";
            cpTypeArray[1] = "BANK/CUSTODIAN";
            cpTypeArray[2] = "INTERNAL";
            //cpTypeArray[1]="CLIENT";
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
    
        //passing account status                
        var actStatusArray:Array = new Array(1);
        actStatusArray[0]="OPEN";
        myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
        return myContextList;
    }
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
    	var url : String = "gle/gleBalanceQueryDispatch.action?method=generateXLS";
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
    	var url : String = "gle/gleBalanceQueryDispatch.action?method=generatePDF";
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
    } // ActionScript file
    
    	/**
    	 *This function processes the collection returned and modifies 
    	 * it to add records for SubTotals and Totals. 
    	 */ 
        private function processResult():void{
        	//Alert.show(summaryResult.toArray().toString());
        	var tempArrayColl:ArrayCollection=new ArrayCollection();
        	var arr:Array;
        	var o:Object;
        	for(var i:Number=0;i<summaryResult.length;i++){
        		//Alert.show(summaryResult);
        		o=new Object();
        		
        		o.balanceTBStr=summaryResult[i].balanceTBStr;
        		o.ccyId=summaryResult[i].ccyId;
        		o.creditBalanceStr=summaryResult[i].creditBalanceStr;
        		o.debitBalanceStr=summaryResult[i].debitBalanceStr;
        		o.lastActivityDateDisplay=summaryResult[i].lastActivityDateDisplay;
        		o.ledgerCode=summaryResult[i].ledgerCode;
        		o.shortName=summaryResult[i].shortName;
        		o.subLedgerCode=summaryResult[i].subLedgerCode;
        		o.sumAmountStr=summaryResult[i].sumAmountStr;
        		o.trialBalanceId=summaryResult[i].trialBalanceId;
        		tempArrayColl.addItem(o);
        if(this.trialBalancePopUp.trialBalanceId.text == ""){
        		if(summaryResult[i].printSubTotal=="Y" && !(this.consolidateTB.selected) ){        		
        			var subTotRow:Object=new Object();
        			subTotRow.shortName="Sub Total:";
        			//subTotRow.balanceAmount=summaryResult[i].balanceTBStr;
        			subTotRow.creditBalanceStr = summaryResult[i].balanceTBStr;
        			if(summaryResult[i].subTotalDebitCreditFlag=="D")
        			 // subTotRow.balanceAmount += "[DR]";
        			 subTotRow.creditBalanceStr += "[DR]";
        			else
        			//  subTotRow.balanceAmount += "[CR]";
        			  subTotRow.creditBalanceStr += "[CR]";
        			tempArrayColl.addItem(subTotRow);
        		}
        }
        		if(summaryResult[i].printGrandTotal=="Y"){
        				var grandTotalRow:Object=new Object();
        				grandTotalRow.shortName="Grand Total:";
        				//grandTotalRow.balanceAmount=summaryResult[i].sumAmountStr;
        				grandTotalRow.creditBalanceStr=summaryResult[i].sumAmountStr;
	        			if(summaryResult[i].totalDebitCreditFlag=="D")
	        			  grandTotalRow.creditBalanceStr += "[DR]";
	        			else
	        			  grandTotalRow.creditBalanceStr += "[CR]";
	        			tempArrayColl.addItem(grandTotalRow);
        			}  
        	}
        	summaryResult=tempArrayColl;
        }
		