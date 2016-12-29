// ActionScript file
// ActionScript file

 // ActionScript file for Trade Query
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.containers.SummaryPopup;
    import com.nri.rui.core.controls.CustomizeSortOrder;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.HiddenObject;
    import com.nri.rui.core.utils.ProcessResultUtil;
    import com.nri.rui.core.utils.XenosStringUtils;
    import com.nri.rui.core.validators.XenosNumberValidator;
    import com.nri.rui.ref.popupImpl.CustomerPopUpHbox;
    import com.nri.rui.ref.popupImpl.FinInstitutePopUpHbox;
    import com.nri.rui.ref.popupImpl.FundPopUpHbox;
    import com.nri.rui.stl.validators.SettlementQueryValidator;
    
    import flash.system.System;
    
    import mx.collections.ArrayCollection;
    import mx.core.UIComponent;
    import mx.events.ResourceEvent;
    import mx.events.ValidationResultEvent;
    import mx.managers.PopUpManager;
    import mx.resources.ResourceBundle;
    import mx.rpc.events.ResultEvent;
    import mx.utils.StringUtil;
    
    [Bindable]
    private var initColl:ArrayCollection;
    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var queryResult:ArrayCollection= new ArrayCollection();
    private var emptyResult:ArrayCollection= new ArrayCollection();
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
    private var finInst:FinInstitutePopUpHbox = new FinInstitutePopUpHbox();
    [Bindable]
    private var customerPopup:CustomerPopUpHbox = new CustomerPopUpHbox();
    [Bindable]
    private var fundPopup:FundPopUpHbox = new FundPopUpHbox();
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    
    private var  csd:CustomizeSortOrder=null;
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    private function initPageStart():void {   
    	
    	finInst.percentWidth = 50;
    	finInst.name = "Broker";
		finInst.recContextItem = populateFinInstRole1()
    	finInst.id = "finInstPopUp";
    	fundPopup.percentWidth = 50;
    	fundPopup.name = "Internal";
    	fundPopup.id = "fundPopUp";
    	counterpartyCodeBox.addChild(finInst);
    	stlRefNo.setFocus();        
        if (!initCompFlg) {    
            rndNo= Math.random();
            var req : Object = new Object();
            req.SCREEN_KEY = 636;
            initializeSettlementQuery.request = req;
            initializeSettlementQuery.url = "stl/stlQueryDispatch.action?method=initialExecute&mode=query&menuType=Y&rnd=" + rndNo;                    
            initializeSettlementQuery.send();        
        } else
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.info.alreadyinitiated '));
         
    }
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * 
    */   
    private function initPage(event: ResultEvent) : void {
        var i:int = 0;
        var selIndx:int = 0;
        
        //variables to hold the default values from the server
        var sortField1Default:String = event.result.stlQueryActionForm.sortField1;
        var sortField2Default:String = event.result.stlQueryActionForm.sortField2;
        var sortField3Default:String = event.result.stlQueryActionForm.sortField3;
        var sortField4Default:String = event.result.stlQueryActionForm.sortField4;
    	
    	errPage.clearError(event); //clears the errors if any
    	
    	//Initialize the fields
    	
    	fundPopUp.fundCode.text = XenosStringUtils.EMPTY_STR;
    	finInst.finInstCode.text = XenosStringUtils.EMPTY_STR;
     	fundAccountNo.accountNo.text = XenosStringUtils.EMPTY_STR; 
     	stlRefNo.text = XenosStringUtils.EMPTY_STR; 
     	swiftRefNo.text = XenosStringUtils.EMPTY_STR; 
     	imOffice.selectedItem = XenosStringUtils.EMPTY_STR;
     	
		trddateFrom.text = XenosStringUtils.EMPTY_STR; 
		trddateTo.text = XenosStringUtils.EMPTY_STR;           
		valueDateFrom.text = XenosStringUtils.EMPTY_STR; 
		valueDateTo.text = XenosStringUtils.EMPTY_STR;  
		stlcurrency.ccyText.text = XenosStringUtils.EMPTY_STR;
		security.instrumentId.text = XenosStringUtils.EMPTY_STR;
		bankPopUp.finInstCode.text = XenosStringUtils.EMPTY_STR;  
		fundSettlementAccount.accountNo.text = XenosStringUtils.EMPTY_STR;  
		
		chkbox1.selected = false;
		chkbox2.selected = false;
		chkbox3.selected = false;
		chkbox4.selected = false;
		chkbox5.selected = false;
		chkbox6.selected = false;
		trdRefNo.text = XenosStringUtils.EMPTY_STR;
		
		completionRefNo.text = XenosStringUtils.EMPTY_STR; 	
		counterPartyAccount.accountNo.text = XenosStringUtils.EMPTY_STR;	
		SettlementdateFrom.text = XenosStringUtils.EMPTY_STR; 
		SettlementdateTo.text = XenosStringUtils.EMPTY_STR; 
		instrumentType.itemCombo.text = XenosStringUtils.EMPTY_STR;	
		correspondingSecurityId.instrumentId.text = XenosStringUtils.EMPTY_STR;
		SettlementdateFrom.text = XenosStringUtils.EMPTY_STR; 
		SettlementdateFrom.text = XenosStringUtils.EMPTY_STR; 
		quantityFrom.text = XenosStringUtils.EMPTY_STR; 
		quantityTo.text = XenosStringUtils.EMPTY_STR;
		amountFrom.text = XenosStringUtils.EMPTY_STR; 
		amountTo.text = XenosStringUtils.EMPTY_STR;
		instructionRefNo.text = XenosStringUtils.EMPTY_STR;
		transmissionDate.text = XenosStringUtils.EMPTY_STR;
		cancelRefNo.text = XenosStringUtils.EMPTY_STR;
		entryDateFrom.text = XenosStringUtils.EMPTY_STR;
		entryDateTo.text = XenosStringUtils.EMPTY_STR;
		lastEntryDateFrom.text = XenosStringUtils.EMPTY_STR;
		lastEntryDateTo.text = XenosStringUtils.EMPTY_STR;
		failSettlements.selected = false;
		
		//IM Office
		if(event.result.stlQueryActionForm.officeIdValues.officeId is ArrayCollection) {
        	initColl = event.result.stlQueryActionForm.officeIdValues.officeId as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(event.result.stlQueryActionForm.officeIdValues.officeId);
        }
    
        var tempColl: ArrayCollection = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        imOffice.dataProvider = tempColl;
        
        //Sub Event type
        if(event.result.stlQueryActionForm.subEventTypeValues.item is ArrayCollection) {
        	initColl = event.result.stlQueryActionForm.subEventTypeValues.item as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(event.result.stlQueryActionForm.subEventTypeValues.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:"", value: ""});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        subEventType.dataProvider = tempColl;
        
        // trdRefNo
        trdRefNo.text="";   
             
        //Trade Ref For
        if(event.result.stlQueryActionForm.tradeReferenceForValues.item is ArrayCollection) {
        	initColl = event.result.stlQueryActionForm.tradeReferenceForValues.item as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(event.result.stlQueryActionForm.tradeReferenceForValues.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        settleFor.dataProvider = tempColl;
        
        //Counter Party Type Values 
        if(event.result.stlQueryActionForm.counterPartyTypeValues.item is ArrayCollection) {
        	initColl = event.result.stlQueryActionForm.counterPartyTypeValues.item as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(event.result.stlQueryActionForm.counterPartyTypeValues.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        counterpartyCode.dataProvider = tempColl;
        
        //LM Office
        if(event.result.stlQueryActionForm.officeIdValues.officeId is ArrayCollection) {
        	initColl = event.result.stlQueryActionForm.officeIdValues.officeId as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(event.result.stlQueryActionForm.officeIdValues.officeId);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        lmOffice.dataProvider = tempColl;
        
        //Transaction Type
        if(event.result.stlQueryActionForm.transactionTypeValues.item is ArrayCollection) {
        	initColl = event.result.stlQueryActionForm.transactionTypeValues.item as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(event.result.stlQueryActionForm.transactionTypeValues.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        transactionType.dataProvider = tempColl; 
        
        //instrumentType
        instrumentType.text="";
        
        //security
        security.instrumentId.text="";
        
        //tradecurrency
        stlcurrency.ccyText.text="";
        
        //settlementccy
        /* settlementccy.ccyText.text=""; */
        
        //Settlement Status
        if(event.result.stlQueryActionForm.settlementStatusValues.item is ArrayCollection) {
        	initColl = event.result.stlQueryActionForm.settlementStatusValues.item as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(event.result.stlQueryActionForm.settlementStatusValues.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        settlementStatus.dataProvider = tempColl;
        
        //trddateFrom
        trddateFrom.text="";
        
        //trddateTo
        trddateTo.text="";
        
        //valuedateFrom
        valueDateFrom.text=event.result.stlQueryActionForm.valueDateFrom;
        
        //valuedateTo
        valueDateTo.text=event.result.stlQueryActionForm.valueDateTo;
        
        //lastEntryDateFrom
        lastEntryDateFrom.text="";
        
        //lastEntryDateTo
        lastEntryDateTo.text="";
        
        //EntryDateFrom
        entryDateFrom.text=event.result.stlQueryActionForm.entryDateFrom == null ? "" : event.result.stlQueryActionForm.entryDateFrom;
        
        //EntryDateTo
        entryDateTo.text=event.result.stlQueryActionForm.entryDateTo == null ? "" : event.result.stlQueryActionForm.entryDateTo;
        
        //Settlement Standing Status
        if(event.result.stlQueryActionForm.settlementStandingStatusValues.item is ArrayCollection) {
        	initColl = event.result.stlQueryActionForm.settlementStandingStatusValues.item as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(event.result.stlQueryActionForm.settlementStandingStatusValues.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        settleStandingStatus.dataProvider = tempColl;
        
        //Contractual Settlement Status
        if(event.result.stlQueryActionForm.contSettleStatusValues.item is ArrayCollection) {
        	initColl = event.result.stlQueryActionForm.contSettleStatusValues.item as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(event.result.stlQueryActionForm.contSettleStatusValues.item);
        }
        
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        contractualSettlementStatus.dataProvider = tempColl; 
        
        //Inx Transmission
        if(event.result.stlQueryActionForm.inxTransmissionValues.item is ArrayCollection) {
        	initColl = event.result.stlQueryActionForm.inxTransmissionValues.item as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(event.result.stlQueryActionForm.inxTransmissionValues.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        inxTransmossion.dataProvider = tempColl; 
        
        //Transmission Status
        if(event.result.stlQueryActionForm.transmissionStatusValues.item is ArrayCollection) {
        	initColl = event.result.stlQueryActionForm.transmissionStatusValues.item as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(event.result.stlQueryActionForm.transmissionStatusValues.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        transmissionStatus.dataProvider = tempColl; 
        
        //Settle Query For
        if(event.result.stlQueryActionForm.settleQueryForValues.item is ArrayCollection) {
        	initColl = event.result.stlQueryActionForm.settleQueryForValues.item as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(event.result.stlQueryActionForm.settleQueryForValues.item);
        }

        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        settleQueryFor.dataProvider = tempColl; 
        
        //Status
        if(event.result.stlQueryActionForm.statusValues.item is ArrayCollection) {
        	initColl = event.result.stlQueryActionForm.statusValues.item as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(event.result.stlQueryActionForm.statusValues.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        var selectedIndex:int;
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
			if(initColl[i].label == event.result.stlQueryActionForm.status) {
				selectedIndex = i+1;
			}       
        }
        status.dataProvider = tempColl; 
        status.selectedItem = tempColl[selectedIndex];
        
        //Match Status
        if(event.result.stlQueryActionForm.matchStatusValues.item is ArrayCollection) {
        	initColl = event.result.stlQueryActionForm.matchStatusValues.item as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(event.result.stlQueryActionForm.matchStatusValues.item);
        }
        
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        matchStatus.dataProvider = tempColl; 
        
        //Data Source
        if(event.result.stlQueryActionForm.dataSourceValues.item is ArrayCollection) {
        	initColl = event.result.stlQueryActionForm.dataSourceValues.item as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(event.result.stlQueryActionForm.dataSourceValues.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        
        dataSource.dataProvider = tempColl;
        
        //Trade Type
        if(event.result.stlQueryActionForm.tradeTypeValues.item is ArrayCollection) {
        	initColl = event.result.stlQueryActionForm.tradeTypeValues.item as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(event.result.stlQueryActionForm.tradeTypeValues.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        tradeType.dataProvider = tempColl;
        
        //Sub Trade Type
        if(event.result.stlQueryActionForm.subTradeTypeValues.item is ArrayCollection) {
        	initColl = event.result.stlQueryActionForm.subTradeTypeValues.item as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(event.result.stlQueryActionForm.subTradeTypeValues.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        subTradeType.dataProvider = tempColl;
        
        
        //Added for GLE Ledger Code
        if(event.result.stlQueryActionForm.gleLedgerCodeValues.item is ArrayCollection) {
        	initColl = event.result.stlQueryActionForm.gleLedgerCodeValues.item as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(event.result.stlQueryActionForm.gleLedgerCodeValues.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        gleLedgerCode.dataProvider = tempColl;
        
        //Sort Field 1
        initColl.removeAll();
        
        if(null != event.result.stlQueryActionForm.sortFieldList1.item) {
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        	
        	if(event.result.stlQueryActionForm.sortFieldList1.item is ArrayCollection)
                initColl = event.result.stlQueryActionForm.sortFieldList1.item as ArrayCollection;
            else
                initColl.addItem(event.result.stlQueryActionForm.sortFieldList1.item);
        	
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
        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.error.sortfield1'));
        }
        
        //Sort Field 2
        initColl.removeAll();
        
        if(null != event.result.stlQueryActionForm.sortFieldList2.item){
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        	
        	if(event.result.stlQueryActionForm.sortFieldList2.item is ArrayCollection)
                initColl = event.result.stlQueryActionForm.sortFieldList2.item as ArrayCollection;
            else
                initColl.addItem(event.result.stlQueryActionForm.sortFieldList2.item);
        	
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
        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.error.sortfield2'));
        }
        
        //Sort Field 3
        initColl.removeAll();
        if(null != event.result.stlQueryActionForm.sortFieldList3.item) {
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        	
        	if(event.result.stlQueryActionForm.sortFieldList3.item is ArrayCollection)
                initColl = event.result.stlQueryActionForm.sortFieldList3.item as ArrayCollection;
            else
                initColl.addItem(event.result.stlQueryActionForm.sortFieldList3.item);
        	
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
        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.error.sortfield3'));
        }
        
        //Sort Field 4
        initColl.removeAll();
        
        if(null != event.result.stlQueryActionForm.sortFieldList4.item) {
        	tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
        	selIndx = 0;
        	
        	if(event.result.stlQueryActionForm.sortFieldList4.item is ArrayCollection)
                initColl = event.result.stlQueryActionForm.sortFieldList4.item as ArrayCollection;
            else
                initColl.addItem(event.result.stlQueryActionForm.sortFieldList4.item);
        	
	        for(i = 0; i<initColl.length; i++) {
	        	//Get the default value object's index
                if(XenosStringUtils.equals((initColl[i].value),sortField4Default)){                    
                    selIndx = i;
                }
	        	
	           tempColl.addItem(initColl[i]);            
	        }
	        
	        sortFieldArray[3]=sortField4;
	        sortFieldDataSet[3]=tempColl;
	        //Set the default value object
	        sortFieldSelectedItem[3] = tempColl.getItemAt(selIndx+1);
	        
        } else {
        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.error.sortfield4'));
        }
		csd = new CustomizeSortOrder(sortFieldArray, sortFieldDataSet, sortFieldSelectedItem);
	    csd.init();
	    initCompFlg = true;   
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
     
     private function checkFailSettlements():void{
     	if(failSettlements.selected) {
     		settlementStatus.text = "";
     		settlementStatus.enabled = false;
     		valueDateTo.text = "";
     		valueDateFrom.text = "";
     		entryDateTo.text = "";
     		entryDateFrom.text = "";
     	} else {
     		settlementStatus.enabled = true;
     	}
    }	   
    
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
    private function populateFinInstRole1():ArrayCollection {
        	//pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
            
            var bankRoleArray : Array = new Array(4);
            bankRoleArray[0] = "Stock Exchange";
            bankRoleArray[1] = "Bank/Custodian";
            bankRoleArray[2] = "Security Broker";
	    bankRoleArray[3] = "Central Depository";
            myContextList.addItem(new HiddenObject("bankRoles",bankRoleArray));
            
            return myContextList;
        }
    public function submitQuery():void{
    	
    	//Reset Page No
    	 qh.resetPageNo();    	
     	//Set the request parameters
     	var requestObj :Object = populateRequestParams();
     	
     	settlementQueryRequest.request = requestObj; 
    	var myModel:Object={
                            tradeQuery:{
                                 
                                 trddateFrom:this.trddateFrom.text,
                                 trddateTo:this.trddateTo.text,
                                 valuedateFrom:this.valueDateFrom.text,
                                 valuedateTo:this.valueDateTo.text,
                                 lastEntryDateFrom:this.lastEntryDateFrom.text,
                                 lastEntryDateTo:this.lastEntryDateTo.text,
                                 EntrydateFrom:this.entryDateFrom.text,
                                 EntrydateTo:this.entryDateTo.text ,
                                 settleDateFrom:this.SettlementdateFrom.text,
                                 settleDateTo:this.SettlementdateTo.text  
                                        
                            }
                           }; 
		var settlementQueryValidator:SettlementQueryValidator = new SettlementQueryValidator();
		settlementQueryValidator.source=myModel;
		settlementQueryValidator.property="tradeQuery";
		var validationResult:ValidationResultEvent =settlementQueryValidator.validate();
		
		if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            //trace(errorMsg);
            XenosAlert.error(errorMsg);
        }
        else{
    	settlementQueryRequest.send();  
        }
    		
    }
    
     
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
     	reqObj.method = "doQuery";
     	reqObj.SCREEN_KEY = 637;
        reqObj.fundCode = this.fundPopUp.fundCode.text;
     	reqObj.fundAccountNo = this.fundAccountNo.accountNo.text; 
     	reqObj.settlementReferenceNo = this.stlRefNo.text; 
     	reqObj.swiftReferenceNo = this.swiftRefNo.text; 
     	reqObj.IMOffice = this.imOffice.selectedItem != null ?  this.imOffice.selectedItem.value : "";
     	reqObj.subEventType = this.subEventType.selectedItem != null ?  this.subEventType.selectedItem.value : "";
     	reqObj.tradeDateFrom = this.trddateFrom.text; 
        reqObj.tradeDateTo = this.trddateTo.text;           
        reqObj.valueDateFrom = this.valueDateFrom.text; 
        reqObj.valueDateTo = this.valueDateTo.text;  
        reqObj.settlementCcy = this.stlcurrency.ccyText.text;
        reqObj.securityCode = this.security.instrumentId.text;
        reqObj.firmBankCode = this.bankPopUp.finInstCode.text;  
        reqObj.firmBankAccount = this.fundSettlementAccount.accountNo.text;  
        
        var instructionTypeArray:Array = new Array();
        	if(chkbox1.selected)
        		instructionTypeArray.push(chkbox1.name);
        	if(chkbox2.selected)
        		instructionTypeArray.push(chkbox2.name);
        	if(chkbox3.selected)
        		instructionTypeArray.push(chkbox3.name);
        	if(chkbox4.selected)
        		instructionTypeArray.push(chkbox4.name);
        	if(chkbox5.selected)
        		instructionTypeArray.push(chkbox5.name);
        	if(chkbox6.selected)
        		instructionTypeArray.push(chkbox6.name);
        		
        reqObj.instructionTypeArray = instructionTypeArray;
        reqObj.tradeReferenceNo = this.trdRefNo.text;
        reqObj.settleFor = this.settleFor.selectedItem != null ?  this.settleFor.selectedItem.value : "";
        reqObj.counterPartyType = this.counterpartyCode.selectedItem != null ?  this.counterpartyCode.selectedItem.value : "";
        
        if(counterpartyCodeBox.getChildByName("Broker"))
     		reqObj.counterPartyCode = this.finInst.finInstCode.text;
     	else
     		reqObj.counterPartyCode = ""; 
     	reqObj.completionReferenceNo = this.completionRefNo.text; 	
     	reqObj.LMOffice = this.lmOffice.selectedItem != null ?  this.lmOffice.selectedItem.value : "";
     	reqObj.cpAccountNo = this.counterPartyAccount.accountNo.text;	
     	reqObj.transactionType = this.transactionType.selectedItem != null ?  this.transactionType.selectedItem.value : "";
     	reqObj.settlementStatus = this.settlementStatus.selectedItem != null ?  this.settlementStatus.selectedItem.value : "";
     	reqObj.settlementInfoStatus = this.settleStandingStatus.selectedItem != null ?  this.settleStandingStatus.selectedItem.value : "";
     	reqObj.contSettleStatus = this.contractualSettlementStatus.selectedItem != null ?  this.contractualSettlementStatus.selectedItem.value : "";	
     	reqObj.settleDateFrom = this.SettlementdateFrom.text; 
        reqObj.settleDateTo = this.SettlementdateTo.text; 
        reqObj.inxTransmission = this.inxTransmossion.selectedItem != null ?  this.inxTransmossion.selectedItem.value : "";
        reqObj.instrumentType = this.instrumentType.itemCombo.text;	
        reqObj.correspondingSecurityId = this.correspondingSecurityId.instrumentId.text;
        reqObj.quantityFrom = this.quantityFrom.text; 
        reqObj.quantityTo = this.quantityTo.text; 
        reqObj.amountFrom = this.amountFrom.text; 
        reqObj.amountTo = this.amountTo.text;
        reqObj.instructionReferenceNo = this.instructionRefNo.text;
        reqObj.transmissionDate = this.transmissionDate.text;
        reqObj.transmissionStatus = this.transmissionStatus.selectedItem != null ?  this.transmissionStatus.selectedItem.value : "";
        reqObj.cancelReferenceNo = this.cancelRefNo.text;
        reqObj.settleQueryFor = this.settleQueryFor.selectedItem != null ?  this.settleQueryFor.selectedItem.value : "";
        
        reqObj.status = this.status.selectedItem != null ?  this.status.selectedItem.value : "";
        reqObj.matchStatus = this.matchStatus.selectedItem != null ?  this.matchStatus.selectedItem.value : "";
        reqObj.entryDateFrom = this.entryDateFrom.text;
        reqObj.entryDateTo = this.entryDateTo.text;
        reqObj.lastEntryDateFrom = this.lastEntryDateFrom.text;
        reqObj.lastEntryDateTo = this.lastEntryDateTo.text;
        reqObj.dataSource = this.dataSource.selectedItem != null ?  this.dataSource.selectedItem.value : "";
        reqObj.tradeType = this.tradeType.selectedItem != null ?  this.tradeType.selectedItem.value : "";
        reqObj.subTradeType = this.subTradeType.selectedItem != null ?  this.subTradeType.selectedItem.value : "";
        reqObj.failNotice = this.failSettlements.selected == true ?  "Y":"N";
        reqObj.gleLedgerCodevalue = this.gleLedgerCode.selectedItem != null ? this.gleLedgerCode.selectedItem.value : "";
        
        reqObj.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.sortField3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.sortField4 = this.sortField4.selectedItem != null ? StringUtil.trim(this.sortField4.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        
        reqObj.rnd = Math.random() + "";
     	return reqObj;
    }
   
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    public function LoadResultPage(event:ResultEvent):void {
    	
    	var rs:XML = XML(event.result);

		if (null != event) {
			if(rs.child("row").length()>0) {
				errPage.clearError(event);
				queryResult.removeAll();
				try {
					for each ( var rec:XML in rs.row ) {
						queryResult.addItem(rec);
					}
					
					changeCurrentState();
					qh.setOnResultVisibility();
	
					qh.setPrevNextVisibility((rs.prevTraversable == "true")?true:false, 
					                         (rs.nextTraversable == "true")?true:false);
					                         
					qh.PopulateDefaultVisibleColumns();
					
					//replace null objects in datagrid with empty string
					queryResult=ProcessResultUtil.process(queryResult, 
					                                      settlementQueryResult.columns);
					                                      
					if(queryResult.length == 1) {
						displayDetailView(queryResult[0].settlementInfoPk);
					}					                                      
					
					queryResult.refresh();
				} catch(e:Error) {
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
				errPage.clearError(event); //clears the error if any
			}
		} else {
			queryResult.removeAll();
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		}
    }
    
    private function displayDetailView(stlPkStr:String):void{
    	
			var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
			
			sPopup.title = this.parentApplication.xResourceManager.getKeyValue('stl.stlqry.label.settlementviewheader');
			sPopup.width = 650;
    		sPopup.height = 420;
			PopUpManager.centerPopUp(sPopup);		
			//var tradePkStr : String = queryResult.tradePk;
			sPopup.moduleUrl = Globals.SETTLEMENT_DETAILS_SWF+Globals.QS_SIGN+Globals.SETTLEMENT_INFO_PK+Globals.EQUALS_SIGN+stlPkStr+Globals.AND_SIGN+Globals.VIEW_MODE+Globals.EQUALS_SIGN+"Settlement";
			
    }
    
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
    
    public function resetQuery():void{
        settlementResetQueryRequest.send();
    	
    }
        
    private function onChangeCounterpartyCode():void {
    	                
    	if(counterpartyCode.selectedItem.label != "BROKER") {
    		
	    	if(counterpartyCodeBox.getChildByName("Broker")) {
	    		this.finInst.finInstCode.text="";
	    	}
    	}
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
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("actTypeContext",actTypeArray));    
                      
            //passing counter party type                
            var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="INTERNAL";
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
            return myContextList;
        }
        
        /**
          * Method to create the context for Account popup corresponding to the Firm
          * Settlement Account also known as Own/Our/Fund Settlement Account.
          * 
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specific  
          * requirement. 
          */
        private function populateFirmSettlementAccountContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing act type                
            var actTypeArray:Array = new Array(1);
            actTypeArray[0]="T|B";
                
            myContextList.addItem(new HiddenObject("actTypeContext", actTypeArray));    
                      
            //passing counter party type                
            var cpTypeArray:Array = new Array(1);
            cpTypeArray[0]="BROKER|BANK/CUSTODIAN";
            
            myContextList.addItem(new HiddenObject("invCPTypeContext", cpTypeArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("accountStatus", actStatusArray));
            
            return myContextList;
        }
        
        /**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
        private function populateConterPartyActContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing act type                
            var actTypeArray:Array = new Array(1);
                actTypeArray[0]="T|B";
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("cpActTypeContext",actTypeArray));    
                      
            //passing counter party type                
            var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="BROKER|BANK/CUSTODIAN";
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("cpCPTypeContext",cpTypeArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("actStatusContext",actStatusArray));
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
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("actTypeContext",actTypeArray));    
                      
            var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="CLIENT|INTERNAL|BROKER";
                //cpTypeArray[1]="CLIENT";
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
		qh.dgrid = settlementQueryResult;
	}  
   /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
    	var url : String = "stl/stlQueryDispatch.action?method=generateXLS";
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
    	var url : String = "stl/stlQueryDispatch.action?method=generatePDF";
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
    	reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
    	settlementQueryRequest.request = reqObj;
        settlementQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
		var reqObj : Object = new Object();
    	reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
    	settlementQueryRequest.request = reqObj;
        settlementQueryRequest.send();
    }  
    
    /**
     * Method to Format and validate numbers(B,M,T)
     */
     private function numberHandler(numVal:XenosNumberValidator):void{
     	//The source textinput control
     	var source:Object=numVal.source; 
     	    	
     	var vResult:ValidationResultEvent;
     	var tmpStr:String = source.text; 
		vResult = numVal.validate();
        
        if (vResult.type==ValidationResultEvent.VALID) {
     		source.text=numberFormatter.format(source.text);     		
        }else{
        	source.text = tmpStr;        	
        }
     }