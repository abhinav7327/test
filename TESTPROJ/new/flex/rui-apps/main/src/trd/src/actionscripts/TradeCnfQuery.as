



 // ActionScript file for Trade Cnf Query
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.containers.SummaryPopup;
    import com.nri.rui.core.controls.CustomDataGrid;
    import com.nri.rui.core.controls.CustomizeSortOrder;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.HiddenObject;
    import com.nri.rui.core.utils.ProcessResultUtil;
    import com.nri.rui.core.utils.XenosStringUtils;
    import com.nri.rui.ref.popupImpl.FinInstitutePopUpHbox;
    import com.nri.rui.ref.popupImpl.StrategyPopUpHBox;
    import com.nri.rui.trd.validator.TradeCnfQueryValidator;
    
    import flash.net.URLVariables;
    
    import mx.collections.ArrayCollection;
    import mx.core.UIComponent;
    import mx.events.DataGridEvent;
    import mx.events.ItemClickEvent;
    import mx.events.ValidationResultEvent;
    import mx.managers.PopUpManager;
    import mx.rpc.events.ResultEvent;
    import mx.utils.StringUtil;
    
    
    [Bindable]private var initColl:ArrayCollection;
    [Bindable]public var selectAllBind:Boolean=false;
    [Bindable]private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]private var queryResult:ArrayCollection= new ArrayCollection();
    [Bindable]public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]private var finInst:FinInstitutePopUpHbox = new FinInstitutePopUpHbox();
    [Bindable]private var strategyPopup:StrategyPopUpHBox = new StrategyPopUpHBox();
    [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
    [Bindable]public var rcvCnfPk:String="";
    [Bindable]public var allocConfFlag:String="";
    [Bindable]public var confirmationTradePk:String="";
    [Bindable]private var recordStr:String="";
    [Bindable]private var fundAccNoStr:String="";
    
    private var selectedResults:ArrayCollection=new ArrayCollection();   
    private var emptyResult:ArrayCollection= new ArrayCollection();
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    private var sPopup : SummaryPopup;	
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();   
    private var  csd:CustomizeSortOrder=null;    
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    public var conformSelectedResults : Array; 
    
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    private function initPageStart():void {   
    	
    	 //XenosAlert.info("initPageStart()");
    	finInst.percentWidth = 50;
    	finInst.name = "Broker";
    	strategyPopup.percentWidth = 50;
    	strategyPopup.name = "Firm";
    	counterpartyCodeBox.addChild(finInst);        
        if (!initCompFlg) {    
            rndNo= Math.random();  
            var req : Object = new Object();
            req.SCREEN_KEY = 87;
            initializeTradeQuery.request = req;        
            initializeTradeQuery.url = "trd/tradeRcvdConfQueryDispatch.action?method=initialExecute&&menuType=Y&rnd=" + rndNo;                    
            initializeTradeQuery.send();        
        } else
            XenosAlert.info("Already Initiated!");
         
    }
    /**
    * Retrieve and return the Security Name for dataTip.
    */
    private function getSecurityName(item:Object):String {
        return item.securityName;
    }
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * 
    */   
    private function initPage(event: ResultEvent) : void {
    	
    	// XenosAlert.info("initPageStart()");
        var i:int = 0;
        var selIndx:int = 0;
        var tempColl: ArrayCollection = new ArrayCollection();
        //variables to hold the default values from the server
        var sortField1Default:String = event.result.tradeRcvdConfQueryActionForm.sortField1;
        var sortField2Default:String = event.result.tradeRcvdConfQueryActionForm.sortField2;
        var sortField3Default:String = event.result.tradeRcvdConfQueryActionForm.sortField3;
        var dateStr:String = null;
    	
    	errPage.clearError(event); //clears the errors if any     
        
        excludeStlCcy.selected = false;
    	excludeTrdCcy.selected = false;
        // trdRefNo
        trdRefNo.text="";
        trdRefNo.setFocus();
        
        //office id
        initColl = new ArrayCollection();
        if(event.result.tradeRcvdConfQueryActionForm.officeIdValues.officeId != null){
        	if(event.result.tradeRcvdConfQueryActionForm.officeIdValues.officeId is ArrayCollection){
	        	initColl = event.result.tradeRcvdConfQueryActionForm.officeIdValues.officeId as ArrayCollection;
	        }else{
	        	initColl.addItem(event.result.tradeRcvdConfQueryActionForm.officeIdValues.officeId);
	        }
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
        officeId.dataProvider = tempColl;

        //buysellflag
        initColl.removeAll();
        if(event.result.tradeRcvdConfQueryActionForm.buySellFlagValues.item != null){
        	if(event.result.tradeRcvdConfQueryActionForm.buySellFlagValues.item is ArrayCollection){
	        	initColl = event.result.tradeRcvdConfQueryActionForm.buySellFlagValues.item as ArrayCollection;
	        }else{
	        	initColl.addItem(event.result.tradeRcvdConfQueryActionForm.buySellFlagValues.item);
	        }
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
        buySell.dataProvider = tempColl;
        
        //Origin Data Source
        initColl.removeAll();
        if(event.result.tradeRcvdConfQueryActionForm.originDataSourceValues.item != null){
        	if(event.result.tradeRcvdConfQueryActionForm.originDataSourceValues.item is ArrayCollection){
	        	initColl = event.result.tradeRcvdConfQueryActionForm.originDataSourceValues.item as ArrayCollection;
	        }else{
	        	initColl.addItem(event.result.tradeRcvdConfQueryActionForm.originDataSourceValues.item);
	        }
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        
        }
        originDataSrcCombo.dataProvider = tempColl;
        
        
        cpAccountNo.accountNo.text=""; 
        
        //inventoryAccountNo
        inventoryAccountNo.accountNo.text=""; 
        
        //security
        security.instrumentId.text="";
        
        //settlementccy
         settlementccy.ccyText.text=""; 
         
         //trade ccy
         trdccy.ccyText.text=""; 
         
          //fundCode
        fundPopUp.fundCode.text="";
       
		   
        //counterpartyCode
        initColl.removeAll();
        if(event.result.tradeRcvdConfQueryActionForm.counterPartyTypesValues.item != null){
        	if(event.result.tradeRcvdConfQueryActionForm.counterPartyTypesValues.item is ArrayCollection){
	        	initColl = event.result.tradeRcvdConfQueryActionForm.counterPartyTypesValues.item as ArrayCollection;
	        }else{
	        	initColl.addItem(event.result.tradeRcvdConfQueryActionForm.counterPartyTypesValues.item);
	        }
        }
    
        tempColl = new ArrayCollection();
       // tempColl.addItem({label:" ", value: " "});
        //for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[0]);    
        
        //}
        counterpartyCode.dataProvider = tempColl;
        counterpartyCode.selectedItem = tempColl[0];
        
        if(finInst!=null){
        	if(finInst.finInstCode !=null){
        		finInst.finInstCode.text = "";
        	}
        	finInst.name = "Broker";
        }
        if(strategyPopup!=null){
        	if(strategyPopup.strategyCode !=null){
        		strategyPopup.strategyCode.text="";
        	}
        	strategyPopup.name = "Firm";
        }
        onChangeCounterpartyCode();
        
        //valuedateFrom
        valuedateFrom.text="";
        
        //valuedateTo
        valuedateTo.text="";
        
        //valuedateFrom
       
        //valuedateFrom.text=event.result.tradeRcvdConfQueryActionForm.valueDateFrom == null ? "":event.result.tradeRcvdConfQueryActionForm.valueDateFrom;
        
        //valuedateTo
        
        //valuedateTo.text=event.result.tradeRcvdConfQueryActionForm.valueDateTo == null ? "":event.result.tradeRcvdConfQueryActionForm.valueDateTo;
        
        
        
        //Setting dateFrom and dateTo
        if(event.result.tradeRcvdConfQueryActionForm.tradeDateFrom!= null && event.result.tradeRcvdConfQueryActionForm.tradeDateTo != null) {
            dateStr = event.result.tradeRcvdConfQueryActionForm.tradeDateFrom;
            if(dateStr != null)
                this.trddateFrom.selectedDate = DateUtils.toDate(dateStr);                

            dateStr = event.result.tradeRcvdConfQueryActionForm.tradeDateTo;
            if(dateStr != null)
                this.trddateTo.selectedDate = DateUtils.toDate(dateStr);
                                
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.initialize.date'));
        }
        
        //EntryDateFrom
        EntrydateFrom.text="";
        
        //EntryDateTo
        EntrydateTo.text="";
        
        initColl.removeAll();
        if(event.result.tradeRcvdConfQueryActionForm.instrumentTypeValues.item != null){
        	if(event.result.tradeRcvdConfQueryActionForm.instrumentTypeValues.item is ArrayCollection){
	        	initColl = event.result.tradeRcvdConfQueryActionForm.instrumentTypeValues.item as ArrayCollection;
	        }else{
	        	initColl.addItem(event.result.tradeRcvdConfQueryActionForm.instrumentTypeValues.item);
	        }
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        
        //instrumentType
        //instrumentTypeList.dataProvider=tempColl;
        this.instrumentType.text="";
        
        initColl.removeAll();
        if(null != event.result.tradeRcvdConfQueryActionForm.sortFieldList1.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        	
        	if(event.result.tradeRcvdConfQueryActionForm.sortFieldList1.item is ArrayCollection)
                initColl = event.result.tradeRcvdConfQueryActionForm.sortFieldList1.item as ArrayCollection;
            else
                initColl.addItem(event.result.tradeRcvdConfQueryActionForm.sortFieldList1.item);
        	
	        for(i = 0; i<initColl.length; i++) {
	        	//Get the default value object's index
                if(XenosStringUtils.equals((initColl[i].value),sortField1Default)){                    
                    selIndx = i;
                }
	        	
	           tempColl.addItem(initColl[i]);            
	        }
	        
	        sortFieldArray[0]=sortField1;
	        sortFieldDataSet[0]=tempColl;
	        //Set the default value object
	        sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
	        
        } else {
        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.initialize.sortfield1'));
        }
        
        //sortField2
        
        initColl.removeAll();
        if(null != event.result.tradeRcvdConfQueryActionForm.sortFieldList2.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        	
        	if(event.result.tradeRcvdConfQueryActionForm.sortFieldList2.item is ArrayCollection)
                initColl = event.result.tradeRcvdConfQueryActionForm.sortFieldList2.item as ArrayCollection;
            else
                initColl.addItem(event.result.tradeRcvdConfQueryActionForm.sortFieldList2.item);
        	
	        for(i = 0; i<initColl.length; i++) {
	        	//Get the default value object's index
                if(XenosStringUtils.equals((initColl[i].value),sortField2Default)){                    
                    selIndx = i;
                }
	        	
	           tempColl.addItem(initColl[i]);            
	        }
	        
	        sortFieldArray[1]=sortField2;
	        sortFieldDataSet[1]=tempColl;
	        //Set the default value object
	        sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);
	        
        } else {
        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.initialize.sortfield2'));
        }
        //sortField3
        
        initColl.removeAll();
        if(null != event.result.tradeRcvdConfQueryActionForm.sortFieldList3.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        	
        	if(event.result.tradeRcvdConfQueryActionForm.sortFieldList3.item is ArrayCollection)
                initColl = event.result.tradeRcvdConfQueryActionForm.sortFieldList3.item as ArrayCollection;
            else
                initColl.addItem(event.result.tradeRcvdConfQueryActionForm.sortFieldList3.item);
        	
	        for(i = 0; i<initColl.length; i++) {
	        	//Get the default value object's index
                if(XenosStringUtils.equals((initColl[i].value),sortField3Default)){                    
                    selIndx = i;
                }
	        	
	           tempColl.addItem(initColl[i]);            
	        }
	        
	        sortFieldArray[2]=sortField3;
	        sortFieldDataSet[2]=tempColl;
	        //Set the default value object
	        sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx+1);
	        
        } else {
        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.initialize.sortfield3'));
        }
        
	    msAll.selected = true;
	    sAll.selected = true;
		csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
	    csd.init();
	        
    }
    
     private function sortOrder1Update():void{
     	 csd.update(sortField1.selectedItem,0);
     }
     
     private function sortOrder2Update():void{     	
     	csd.update(sortField2.selectedItem,1);
     }
     
    private function loadAll():void {
    }
    
	
    
    public function submitQuery(clearErrorFlag:Boolean = false):void{
    	
    	    	
       		if(selectedResults!=null){
       			selectedResults.removeAll();
       			conformSelectedResults=selectedResults.toArray();
       		}
       	//Reset Page No
    	 qh.resetPageNo();	
     	//Set the request parameters
     	var requestObj :Object = populateRequestParams();
     	
     	tradeCnfQueryRequest.request = requestObj; 
    	var cnfModel:Object={
                            tradeCnfQuery:{
                                 
                                 trddateFrom:this.trddateFrom.text,
                                 trddateTo:this.trddateTo.text,
                                 valuedateFrom:this.valuedateFrom.text,
                                 valuedateTo:this.valuedateTo.text,
                                 EntrydateFrom:this.EntrydateFrom.text,
                                 EntrydateTo:this.EntrydateTo.text
                                        
                            }
                           }; 
		var tradeCnfQueryValidator:TradeCnfQueryValidator = new TradeCnfQueryValidator();
		tradeCnfQueryValidator.source=cnfModel;
		tradeCnfQueryValidator.property="tradeCnfQuery";
		var validationResult:ValidationResultEvent =tradeCnfQueryValidator.validate();
		
		if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
        }else{
      		var reqSend:Boolean = true;
      		var errMsg:String = XenosStringUtils.EMPTY_STR;
      		if(excludeStlCcy.selected){
      			if(XenosStringUtils.isBlank(settlementccy.ccyText.text)){
      				reqSend = false;
      				errMsg = errMsg + this.parentApplication.xResourceManager.getKeyValue('trd.error.stlccy.reqd.exclude.checked');
      			}
      		}
      		if(excludeTrdCcy.selected){
      			if(XenosStringUtils.isBlank(trdccy.ccyText.text)){
      				reqSend = false;
      				if(XenosStringUtils.isBlank(errMsg)){
      					errMsg = errMsg + this.parentApplication.xResourceManager.getKeyValue('trd.error.tradeccy.reqd.exclude.checked');
      				}else{
      					errMsg = errMsg + "\n" + this.parentApplication.xResourceManager.getKeyValue('trd.error.tradeccy.reqd.exclude.checked');
      				}
      			}
      		}
      		if(reqSend){
      			var callObj:Object = tradeCnfQueryRequest.send();  
	    		callObj.clearError = clearErrorFlag;
      		}else{
      			XenosAlert.error(errMsg);
      		}
        }
    		
    }
    
     
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	reqObj.SCREEN_KEY = 88;
     	reqObj.method = "submitQuery";
        reqObj.referenceNo = this.trdRefNo.text;
        reqObj.officeId = this.officeId.selectedItem != null ?  this.officeId.selectedItem.value : "";
        reqObj.buySellOrientation = this.buySell.selectedItem != null ?  this.buySell.selectedItem.value : "";
        reqObj.originDataSource = this.originDataSrcCombo.selectedItem != null ?  this.originDataSrcCombo.selectedItem.value : "";
        reqObj.accountNo = this.cpAccountNo.accountNo.text; 
        reqObj.securityCode = this.security.instrumentId.text;      
        reqObj.settlementCcy = this.settlementccy.ccyText.text;
        reqObj.trdCcyExcluded = excludeTrdCcy.selected;
        reqObj.stlCcyExcluded = excludeStlCcy.selected;
        reqObj.tradeCcy = this.trdccy.ccyText.text;
        reqObj.fundAccountNo = this.inventoryAccountNo.accountNo.text; 
        reqObj.fundCode = this.fundPopUp.fundCode.text;
        reqObj.counterPartyType = this.counterpartyCode.selectedItem != null ?  this.counterpartyCode.selectedItem.value : "";            
        if(counterpartyCode.selectedItem.label == "BROKER"){
    		 reqObj.counterPartyCode= this.finInst.finInstCode.text != null ? this.finInst.finInstCode.text : "";
    	}
    	if(counterpartyCode.selectedItem.label == "FIRM"){
    		reqObj.counterPartyCode= this.strategyPopup.strategyCode.text != null ? this.strategyPopup.strategyCode.text : "";
    	}
        reqObj.tradeDateFrom = this.trddateFrom.text; 
        reqObj.tradeDateTo = this.trddateTo.text;           
        reqObj.valueDateFrom = this.valuedateFrom.text; 
        reqObj.valueDateTo = this.valuedateTo.text;           
        reqObj.receiveDateFrom = this.EntrydateFrom.text; 
        reqObj.receiveDateTo = this.EntrydateTo.text; 
        var instrumentArr:Array = new Array();
        instrumentArr.push(this.instrumentType.itemCombo.text);
        /* if(this.instrumentTypeList!=null && this.instrumentTypeList.selectedItems!=null){
        	for(var i:int;i<this.instrumentTypeList.selectedItems.length;i++){
        		instrumentArr.push(this.instrumentTypeList.selectedItems[i].value.toString());
        	}
        } */
        reqObj.instrumentSelected = instrumentArr;
        reqObj.ackStatus=this.ackStatusRadio.selectedValue;
        reqObj.status=this.statusRadio.selectedValue;
        reqObj.sortField1 = this.sortField1.selectedItem != null ? this.sortField1.selectedItem.value : "";
        reqObj.sortField2 = this.sortField2.selectedItem != null ? this.sortField2.selectedItem.value : "";
        reqObj.sortField3 = this.sortField3.selectedItem != null ? this.sortField3.selectedItem.value : "";
        reqObj.rnd = Math.random() + "";
     	return reqObj;
    }
    
    
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    
    private function LoadResultPage(event:ResultEvent):void {
     	
	var rs:XML = XML(event.result);
	
		if (null != event) {
			var callObj:Object = event.token;
			if(callObj.clearError){
				summaryErrPage.clearError(event);
			}
			if(rs.child("row").length()>0) {
				errPage.clearError(event);
	            queryResult.removeAll();
				try {
				    for each ( var rec:XML in rs.row ) {
	 				    queryResult.addItem(rec);
				    }
				    //replace null objects in with empty string
					queryResult=ProcessResultUtil.process(queryResult,tradeQueryResult.columns);
				 	queryResult.refresh();
				 	recordStr = 'Total: '+queryResult[0].totalNoOfRecords+
				 				'  Match: '+queryResult[0].noOfMatchedRecords+
				 				'  Unmatch (Alloc: '+queryResult[0].noOfUnmatchedAllocations+
				 				' Conf: '+queryResult[0].noOfUnmatchedConfirmations+
				 				')  CXL (Alloc: '+queryResult[0].noOfCancelAllocRecords+
				 				' Conf: '+queryResult[0].noOfCancelConfRecords+
				 				')  Reject: '+queryResult[0].noOfRejectedRecords;
				    resetSellection(queryResult);
	             	setIfAllSelected();
				    changeCurrentState();
				    qh.recordCount.text = recordStr;
		            qh.setOnResultVisibility();
		            qh.setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
		            qh.PopulateDefaultVisibleColumns();
	     	        
				}catch(e:Error){
				    //XenosAlert.error(e.toString() + e.message);
				    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
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
			 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			 	queryResult.removeAll(); // clear previous data if any as there is no result now.
			 	errPage.removeError(); //clears the errors if any
			 }
        }
     }
    
    
    
    
   /* public function LoadResultPage(event:ResultEvent):void {
    	if (null != event) {            
            if(null == event.result.rows){
                queryResult.removeAll(); // clear previous data if any as there is no result now.
            	if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
            	    errPage.clearError(event); //clears the errors if any
            		XenosAlert.info("No Result Found!");
            	} else { // Must be error
            		errPage.displayError(event);	
            	}            	
            }else {
            	errPage.clearError(event);   
	            if(event.result.rows.row is ArrayCollection) {
	                    queryResult = event.result.rows.row as ArrayCollection;
	            } else {
	                    queryResult.removeAll();
	                    queryResult.addItem(event.result.rows.row);
	             }
	             
	              if(queryResult[0]==null){			             	
		            queryResult.removeAll();
		            XenosAlert.info("No Results Found");
		            return;
	             }
	             	             
           		 //replace null objects  with empty string
				 queryResult=ProcessResultUtil.process(queryResult,tradeQueryResult.columns);
				 queryResult.refresh();
				 
	             resetSellection(queryResult);
	             setIfAllSelected();
	             changeCurrentState();
	             qh.setOnResultVisibility();
	             qh.setPrevNextVisibility(Boolean(event.result.rows.prevTraversable),Boolean(event.result.rows.nextTraversable));
	             qh.PopulateDefaultVisibleColumns();           		 
            } 
        }else {
            queryResult.removeAll();
            XenosAlert.info("No Results Found");
        }
    }*/
    
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
    
    public function resetQuery():void{
        tradeResetQueryRequest.send();
    	
    }
    
    
    private function onChangeCounterpartyCode():void{
    	if(counterpartyCode.selectedItem.label == "BROKER"){
    		if(counterpartyCodeBox.getChildByName("Firm")){
	    		counterpartyCodeBox.addChild(finInst);
	    		counterpartyCodeBox.removeChild(strategyPopup);
	    	}
    	}
    	if(counterpartyCode.selectedItem.label == "FUND"){
    		if(counterpartyCodeBox.getChildByName("Broker")){
	    		counterpartyCodeBox.addChild(strategyPopup);
	    		counterpartyCodeBox.removeChild(finInst);
	    	}
    	}
    }
    
        /**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
        private function populateCpActContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
           //passing counter party type                
            var cpTypeArray:Array = new Array(1);
                //cpTypeArray[0]="INTERNAL";
                cpTypeArray[0]="BROKER";
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
            return myContextList;
        }
    
        /**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
        private function populateActContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing act type                
            var actTypeArray:Array = new Array(1);
                actTypeArray[0]="T|B";
            myContextList.addItem(new HiddenObject("actTypeContext",actTypeArray));    
                      
            var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="CLIENT|INTERNAL|BROKER";
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
            return myContextList;
        }
        
        
    /**
	 * This method should be called on creationComplete of the datagrid 
	 */ 
	 private function bindDataGrid():void {
		qh.dgrid = tradeQueryResult;
	}  
   /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
    	var url : String = "trd/tradeRcvdConfQueryDispatch.action?method=generateXLS";
    	var request:URLRequest = new URLRequest(url);
    	request.method = URLRequestMethod.POST;
    	var variables:URLVariables = new URLVariables();
    	trace("Menu Pk in XLS using parent application: " + this.parentApplication.mdiCanvas.getwindowKey());
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
    	var url : String = "trd/tradeRcvdConfQueryDispatch.action?method=generatePDF";
    	var request:URLRequest = new URLRequest(url);
    	request.method = URLRequestMethod.POST;
    	trace("Menu Pk in PDF using parent application: " + this.parentApplication.mdiCanvas.getwindowKey());
    	var variables:URLVariables = new URLVariables();
    	variables.menuPk = this.parentApplication.mdiCanvas.getwindowKey();
    	request.data = variables;
    	 try {
                navigateToURL(request, "_blank");
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
     	if(selectedResults!=null){
   			selectedResults.removeAll();
   			conformSelectedResults=selectedResults.toArray();
   		} 
        var reqObj : Object = new Object();
    	reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
    	tradeCnfQueryRequest.request = reqObj;
        tradeCnfQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
     	if(selectedResults!=null){
   			selectedResults.removeAll();
   			conformSelectedResults=selectedResults.toArray();
   		} 
		var reqObj : Object = new Object();
    	reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
    	tradeCnfQueryRequest.request = reqObj;
        tradeCnfQueryRequest.send();
    }  
     private function selectItem(event:ItemClickEvent):void { 
		 //XenosAlert.info(event.currentTarget.selectedValue);
    	//tradeQueryRequest.request = reqObj;
       // tradeQueryRequest.send();
    }      
    
    private function resetSellection(queryResult:ArrayCollection):void{
    	for(var i:int=0;i<queryResult.length;i++){
    		queryResult[i].selected = false;
    		queryResult[i].rowNum = i;
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
    	if(queryResult == null){
    	 return false;
    	}
    	for(i=0; i<queryResult.length; i++){
    		if(queryResult[i].selected == false) {
        		return false;
        	}
    	}
    	if(i == queryResult.length) {
    		return true;
         }else {
    		return false;
    	}
    }
    
       
// This as file contains code specific to the Check Box Selections.    
    
    public function selectAllRecords(flag:Boolean): void {
    	var i:Number = 0;
    	selectedResults.removeAll();
    	for(i=0; i<queryResult.length; i++){
    		var obj:XML=queryResult[i];
            obj.selected = flag;
            queryResult[i]=obj;
            addOrRemove(queryResult[i]);
    	}
    	conformSelectedResults = selectedResults.toArray();
    }
    
    public function addOrRemove(item:Object):void {
    	var i:Number;
        var tempArray:Array = new Array();
        if(item.selected == true){ 
        	var obj:Object=new Object();
        	obj.receivedConfirmationPk=item.receivedConfirmationPk;
        	obj.tradePk=item.tradePk;
        	obj.allocationConfirmationFlag=item.allocationConfirmationFlag;
        	obj.controlNo=item.controlNo;
        	obj.matchStatusDisp=item.matchStatusDisp;
        	obj.status=item.status;
        	obj.rowNum=item.rowNum;
        	obj.dataSource = item.dataSource;
        	obj.settlementStatus = item.settlementStatus;
        	obj.fundAccNo = item.fundAccNoDisp;
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
        if(item.selected == true){
        	 // needs to insert
        	var obj:Object=new Object();
        	obj.receivedConfirmationPk=item.receivedConfirmationPk;
        	obj.tradePk=item.tradePk;
        	obj.allocationConfirmationFlag=item.allocationConfirmationFlag;
        	obj.controlNo=item.controlNo;
        	obj.matchStatusDisp=item.matchStatusDisp;
        	obj.status=item.status;
        	obj.rowNum=item.rowNum;
        	obj.dataSource = item.dataSource;
        	obj.settlementStatus = item.settlementStatus;
        	obj.fundAccNo = item.fundAccNoDisp;
            selectedResults.addItem(obj);
    	}else { //needs to pop
    		tempArray=selectedResults.toArray();
    	    selectedResults.removeAll();
    		for(i=0; i<tempArray.length; i++){
    			if(tempArray[i].receivedConfirmationPk != item.receivedConfirmationPk){
    			    selectedResults.addItem(tempArray[i]);
    			}
    		}        		
    	}    
    	conformSelectedResults=	selectedResults.toArray();
    	setIfAllSelected();    	    	
    }
    
     public function doMatch(event:Event):void {
     	 var isMatchable:Boolean = false;
         var obj:Object=new Object();
         var selectedIndexArray:Array = new Array();
     	 if(conformSelectedResults != null){
     	 	if(conformSelectedResults.length > 0){
     	 		var isCancel:Boolean = false;
     	 		var isMatched:Boolean = false;
     	 		var isRejected:Boolean = false;
     	 		var isConfirmed:Boolean = false;
     	 		var isAllocSelected:Boolean = false;
	     	 	var confCount:int = 0;
     	 		for(var i:int; i < conformSelectedResults.length; i++){
     	 			if(!XenosStringUtils.equals(String(conformSelectedResults[i].status),"NORMAL")){
     	 				isCancel = true;
     	 				break;
     	 			}
     	 			
     	 			if(conformSelectedResults[i].matchStatusDisp == "Reject"){
     	 				isRejected = true;
     	 				break;
     	 			}else if(conformSelectedResults[i].matchStatusDisp == "Confirmed"){
     	 				isConfirmed = true;
     	 				break;
     	 			}else if(conformSelectedResults[i].matchStatusDisp != null && StringUtil.trim(String(conformSelectedResults[i].matchStatusDisp)) != ""){
     	 				isMatched = true;
     	 				break;
     	 			}
     	 			if(conformSelectedResults.length == 1){
	     	 			isMatchable = true;
	     	 		}else{
	 	 				if(conformSelectedResults[i].allocationConfirmationFlag == "A"){
	 	 					isAllocSelected = true;
	 	 				}else if(conformSelectedResults[i].allocationConfirmationFlag == "C"){
	 	 					confCount++;
	 	 				}
	     	 		}
					selectedIndexArray.push(conformSelectedResults[i].rowNum);
     	 		}
     	 		
     	 		if(isCancel){
     	 			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.without.normal.trade'));
     	 		}else if(isRejected){
     	 			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.rejected.trade.match'));
     	 		}else if(isConfirmed){
     	 			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.confirm.trade.match'));
     	 		}else if(isMatched){
     	 			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.trade.already.matched'));
     	 		}else if(confCount > 0 && !isAllocSelected){
 	 				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.multiple.confirmation.match'));
 	 			}else if(confCount > 0 && isAllocSelected){
 	 				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.multiple.confalloc.selected'));
 	 			}else if(confCount == 0 && isAllocSelected){
 	 				isMatchable = true;
 	 			}
     	 	}else{
     	 		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.without.unmatched.trade'));
     	 	}
		}else{
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.without.unmatched.trade'));
		}
		
		if(isMatchable){
        	rcvCnfPk = conformSelectedResults[0].receivedConfirmationPk;
        	allocConfFlag = conformSelectedResults[0].allocationConfirmationFlag;
        	confirmationTradePk = conformSelectedResults[0].tradePk;
        	fundAccNoStr = conformSelectedResults[0].fundAccNo;
        	loadMatchOueryPage(selectedIndexArray);
		}
     }
     
      
     private function loadUnmatchUserConfirmation(selIndArr:Array):void {
     	var parentApp :UIComponent = UIComponent(this.parentApplication);
		sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
		sPopup.addEventListener(CloseEvent.CLOSE,closePopUp);
		sPopup.title = this.parentApplication.xResourceManager.getKeyValue('trd.popup.trade.unmatch.popup.title');
		sPopup.width = 620;
		sPopup.height = 330;
		sPopup.owner = this;
		PopUpManager.centerPopUp(sPopup);
		sPopup.moduleUrl = "assets/appl/trd/TradeUnmatchPopup.swf?selIndexArr="+selIndArr;
     }
     
     
     public function validateUnmatch():void {
		 	var unMatchFlag:int = 0;
		 	var selectedIndexArray:Array = new Array();
		 	for(var i:int = 0;i<conformSelectedResults.length;i++){
		 		if(conformSelectedResults[i].matchStatusDisp == null || conformSelectedResults[i].matchStatusDisp == ""){
		 			unMatchFlag=1;
		 			break;
		 		}else if(conformSelectedResults[i].matchStatusDisp == "Reject"){
		 			unMatchFlag=2;
		 			break;
		 		}else if(conformSelectedResults[i].matchStatusDisp == "Confirmed"){
		 			unMatchFlag=3;
		 			break;
		 		}else if(conformSelectedResults[i].settlementStatus == false || XenosStringUtils.equals(conformSelectedResults[i].settlementStatus,"false")){
		 			unMatchFlag=4;
		 			break;
		 		}
		 		selectedIndexArray.push(conformSelectedResults[i].rowNum);
		 	}
		 	if(unMatchFlag==0){
		 		selectedIndexArray.push("-1");
			 	if(selectedIndexArray.length > 0){
			 		loadUnmatchUserConfirmation(selectedIndexArray);		 		    
			 	}else{
			 		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.select.oneormore.match.trade'));
			 	}
		 	}else if(unMatchFlag==1){
		 		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.select.only.match.trade'));
		 	}else if(unMatchFlag==2){
		 		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.reject.unmatched.trade'));
		 	}else if(unMatchFlag==3){
		 		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.conf.unmatched.trade'));
		 	}else if(unMatchFlag==4){
		 		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.settled.trade'));
		 	}
     }
     
     public function doReject(event:Event):void {
     	var obj:Object=new Object();
     	 if(conformSelectedResults != null){
     	 	if(conformSelectedResults.length>0){
     	 		if(conformSelectedResults.length==1){
     	 			if(conformSelectedResults[0].matchStatusDisp==null || conformSelectedResults[0].matchStatusDisp==""){
     	 				if(conformSelectedResults[0].status=="NORMAL"){
     	 					if(conformSelectedResults[0].allocationConfirmationFlag=="C"){
     	 						if(conformSelectedResults[0].dataSource!="SCREEN"){
     	 							rcvCnfPk = conformSelectedResults[0].receivedConfirmationPk;
						        	confirmationTradePk = conformSelectedResults[0].tradePk;
						        	fundAccNoStr = conformSelectedResults[0].fundAccNo;
						        	this.LoadRejectOueryPage();
     	 						}else{
     	 							XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.tradeentered.ui'));
     	 						}
     	 					}else if(conformSelectedResults[0].allocationConfirmationFlag == null){
     	 						XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.without.unmatchedconf.trade'));
     	 					}else{
     	 						XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.without.conf.trade'));
     	 					}
     	 				}else{
     	 					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.without.normal.trade'));
     	 				}
     	 			}else{
     	 				if(conformSelectedResults[0].matchStatusDisp=="Confirmed"){
     	 					XenosAlert.error("Confirmed trade cannot be rejected!");
     	 				}else if(conformSelectedResults[0].matchStatusDisp!="Reject"){
     	 					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.reject.match.trade'));
     	 				}else{
     	 					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.selected.rejecttrade'));
     	 				}
     	 			}
     	 		}else{
     	 			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.reject.miltiple.trade'));
     	 		}
     	 	}else{
     	 		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.without.unmatchedconf.trade'));
     	 	}
		}else{
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.without.unmatchedconf.trade'));
		}
     }
     
     public function doAllocCancel(event:Event):void {
     	var selectedIndexArray:Array = new Array();
		var successFlag:Boolean = true;
		if(conformSelectedResults != null && conformSelectedResults.length > 0) {
			for(var i:int=0; i<conformSelectedResults.length; i++) {
	    		if(conformSelectedResults[i].status == "CANCEL") {
	    			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.select.normal.trade'));
	    			successFlag = false;
	    			break;
	    		} else {
	    			if(conformSelectedResults[i].allocationConfirmationFlag == "C") {
	    				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.select.alloc.trade'));
	    				successFlag = false;
	    				break;
	    			} else {
	    				if(!(conformSelectedResults[i].matchStatusDisp == null || 
	    				   conformSelectedResults[i].matchStatusDisp == "")) {
	    						XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.select.unmatch.alloc.trade'));
	    						successFlag = false;
	    						break;
	    				} else {
	    					selectedIndexArray.push(conformSelectedResults[i].rowNum);
	    				}
	    			}
	    		}  		
    		}			
		} else {
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.select.atleast.onealloc.trade'));
			successFlag = false;
		}
		
		if(successFlag) {
			var sPopup : SummaryPopup;	
			var parentApp :UIComponent = UIComponent(this.parentApplication);
			sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
			sPopup.title = this.parentApplication.xResourceManager.getKeyValue('trd.alloc.trade.cxlconf');
			sPopup.width = 750;
			sPopup.height = 330;
			sPopup.owner=this;
			PopUpManager.centerPopUp(sPopup);
			sPopup.moduleUrl = "assets/appl/trd/CancelAllocationPopup.swf?selectedIndexArray="+selectedIndexArray;
		}		   	   	
     }
      
     public function loadMatchOueryPage(selIndexArray:Array):void {
     	
				var parentApp :UIComponent = UIComponent(this.parentApplication);
				sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
				sPopup.addEventListener(CloseEvent.CLOSE,closePopUp);
				if(allocConfFlag=="A"){
					sPopup.title = this.parentApplication.xResourceManager.getKeyValue('trd.popup.confirmation.title');
					sPopup.width = 620;
		    		sPopup.height = 330;
		    		sPopup.owner=this;
					PopUpManager.centerPopUp(sPopup);
					sPopup.moduleUrl = "assets/appl/trd/TradeCnfMatchPopup.swf?selIndexArr="+selIndexArray
										+"&parentAllocConfFlag="+allocConfFlag;
				}else if(allocConfFlag=="C"){
					sPopup.title = this.parentApplication.xResourceManager.getKeyValue('trd.popup.allocation.popup.title');
					sPopup.width = 620;
		    		sPopup.height = 330;
		    		sPopup.owner=this;
					PopUpManager.centerPopUp(sPopup);
					sPopup.moduleUrl = "assets/appl/trd/TradeCnfMatchPopup.swf?selIndexArr="+selIndexArray
										+"&parentAllocConfFlag="+allocConfFlag;
				}
     }
     
     
	public function closePopUp(event:CloseEvent):void{
		this.submitQuery();
		sPopup.removeEventListener(CloseEvent.CLOSE,closePopUp);
		sPopup.removeMe();
	}
     
     public function LoadUnmatchOueryPage(event:ResultEvent):void { 
     	if (null != event) {
     		if(null != event.result){
     			if(null != event.result.rows){
	            	errPage.clearError(event); 
	            	summaryErrPage.clearError(event);
		            if(event.result.rows.row is ArrayCollection) {
		                    queryResult = event.result.rows.row as ArrayCollection;
		            } else {
		                    queryResult.removeAll();
		                    queryResult.addItem(event.result.rows.row);
		             }
		              if(queryResult[0]==null){			             	
			            queryResult.removeAll();
			            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			            return;
		             }
		             var setStatus:String = null;
		             var count:int = 0;
		             if(queryResult!=null && queryResult.length>0){
		             	for(var i:int;i<queryResult.length;i++){
		             		setStatus = queryResult[i].settlementStatus;
		             		if(XenosStringUtils.equals(setStatus,"false") || setStatus == false){
		             			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.settled.trade'));
			             		break;
			             	}else{
			             		count = count+1;
			             	}
		             	}
		             	if(count==queryResult.length){
		             		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('trd.selected.trade.unmatch'));
		             	}
		             }
	            } else if(null != event.result.XenosErrors){
	                queryResult.removeAll();
	                errPage.clearError(event);
	                summaryErrPage.clearError(event);
					if(event.result.XenosErrors.Errors!=null){
				       var errorInfoList : ArrayCollection = new ArrayCollection();
				       if(event.result.XenosErrors.Errors is ArrayCollection){
					       	for each(var err:Object in ((event.result.XenosErrors.Errors) as ArrayCollection)){
					       		errorInfoList.addItem(err);
					       	}
		            	}else{
		            		errorInfoList.addItem(event.result.XenosErrors.Errors.error);
		            	}
	            	summaryErrPage.showError(errorInfoList);
	            }else{
	            	queryResult.removeAll();
            		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	            }
     		  } else{
	            	queryResult.removeAll();
            		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	            }
	        }else {
	            queryResult.removeAll();
	            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	        }
	     }
	     this.submitQuery();
     }
     
     public function LoadRejectOueryPage():void {
				var sPopup : SummaryPopup;	
				var parentApp :UIComponent = UIComponent(this.parentApplication);
				sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
				sPopup.title = this.parentApplication.xResourceManager.getKeyValue('trd.popup.allocation.title');
				sPopup.width = 400;
	    		sPopup.height = 300;
	    		sPopup.owner=this;
				PopUpManager.centerPopUp(sPopup);
				sPopup.moduleUrl = "assets/appl/trd/TradeRejectionPopup.swf?ReceivedConfirmationPk="+rcvCnfPk+"&ConfirmationTradePk="+confirmationTradePk+"&fundAccNo="+fundAccNoStr;
     }
     
     
      /**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
        private function populateInvActContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing act type                
            var actTypeArray:Array = new Array(1);
                actTypeArray[0]="T|B";
            myContextList.addItem(new HiddenObject("actTypeContext",actTypeArray));    
                      
            //passing counter party type                
            var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="INTERNAL";
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
            return myContextList;
        }
        
        /**
 		*  datagrid header release event handler to handle datagridcolumn sorting
 		*/
		public function dataGrid_headerRelease(evt:DataGridEvent):void {				
			var dg:CustomDataGrid = CustomDataGrid(evt.currentTarget);
            sortUtil.clickedColumn = dg.columns[evt.columnIndex];		
		}
		
        private function colorForMatched(item:Object, color:uint):uint {
			if(item.matchStatusDisp != null && (item.matchStatusDisp == 'Confirmed' ||
				item.matchStatusDisp == 'Auto' ||
				item.matchStatusDisp == 'Manual' ||
				item.matchStatusDisp == 'Manual(Multi)' ||
				item.matchStatusDisp == 'Auto(Multi)') && item.status == 'NORMAL'){
					return 0xCAC6CA;
			}
			return color;
		}