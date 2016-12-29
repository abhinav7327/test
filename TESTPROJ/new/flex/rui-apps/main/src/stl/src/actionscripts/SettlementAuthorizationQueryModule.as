// ActionScript file


import com.nri.rui.core.Globals;
import com.nri.rui.core.containers.SummaryPopup;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.core.validators.XenosNumberValidator;
import com.nri.rui.ref.popupImpl.FinInstitutePopUpHbox;
import com.nri.rui.ref.popupImpl.FundPopUpHbox;

import mx.collections.ArrayCollection;
import mx.controls.DataGrid;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.DataGridEvent;
import mx.events.ResourceEvent;
import mx.events.ValidationResultEvent;
import mx.managers.PopUpManager;
import mx.resources.ResourceBundle;
import mx.utils.StringUtil;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.stl.validators.AuthorizationQueryValidator;

/*
 import com.nri.rui.core.controls.XenosQuery; 
 import com.nri.rui.stl.validators.AuthorizationQueryValidator;
 */
			
	 [Bindable]
      private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     [Bindable]
      public var queryResult:ArrayCollection = new ArrayCollection();
     
     private var keylist:ArrayCollection = new ArrayCollection();     
     private var sortUtil: ProcessResultUtil = new ProcessResultUtil();
     
     [Bindable]
     	private var mode:String = "query";         
     
     [Bindable]
    	public var returnContextItem:ArrayCollection = new ArrayCollection();
    	
     [Bindable]
        private var initcol:ArrayCollection = new ArrayCollection();
        
     [Bindable]
    private var finInst:FinInstitutePopUpHbox = new FinInstitutePopUpHbox();
    [Bindable]
    private var fundPopup:FundPopUpHbox = new FundPopUpHbox();
    [Bindable]
    public var selectedResults:ArrayCollection=new ArrayCollection();     
    [Bindable] 
    public var selectAllBind:Boolean=false;
        
     private var  csd:CustomizeSortOrder = null;
     private var sortFieldArray:Array = new Array();
     private var sortFieldDataSet:Array = new Array();
     private var sortFieldSelectedItem:Array = new Array();     
     
     /**
 	  *  datagrid header release event handler to handle datagridcolumn sorting
 	  */
     public function dataGrid_headerRelease(evt:DataGridEvent):void {
	 	var dg:DataGrid = DataGrid(evt.currentTarget);
     	sortUtil.clickedColumn = dg.columns[evt.columnIndex];		
	 }
		  
     private function changeCurrentState():void {
     	currentState = "result";
     }
			 
     public function loadAll():void {
     	parseUrlString();
     	super.setXenosQueryControl(new XenosQuery());     	
     	if(this.mode == 'query') {
     		this.dispatchEvent(new Event('queryInit'));
     	}
     	
     	finInst.percentWidth = 50;
    	finInst.name = "Broker";
		finInst.recContextItem = populateFinInstRole1()
    	finInst.id = "finInstPopUp";    	
    	counterpartyCode.percentWidth = 50;    	
    	counterpartyCodeBox.addChild(finInst);            	     
     }
     
     /**
      * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
      * 
      */ 
     public function parseUrlString():void {
     	try {
     		// Remove everything before the question mark, including
     		// the question mark.
     		var myPattern:RegExp = /.*\?/;      		
     		var s:String = this.loaderInfo.url.toString();
     		s = s.replace(myPattern, "");
     		// Create an Array of name=value Strings.
     		var params:Array = s.split(Globals.AND_SIGN); 
     		// Print the params that are in the Array.
     		var keyStr:String;
     		var valueStr:String;
     		var paramObj:Object = params;
                  
     		// Set the values of the salutation.
     		if(params != null) {
	 			for (var i:int = 0; i < params.length; i++) {
	 				var tempA:Array = params[i].split("=");  
	 				if (tempA[0] == "mode") {	 					
	 					mode = tempA[1];
	 				}
	 			}                    	
     		} else {
     			mode = "query";
     		}  
     	} catch (e:Error) {
     		trace(e);
     	}               
     }
            
     /**
      * At the time of loading the module if the module specific Resource is not loaded then load them
      * Should be called at the creationComplete of the module 
      */ 
     public function loadResourceBundle():void {
        var locales:String = this.parentApplication.xResourceManager.localeChain[0];
        var resourceModuleURL:String = "assets/appl/stl/stlResources_" + locales + ".swf";
           
        var bundle:ResourceBundle = ResourceBundle(resourceManager.getResourceBundle(locales, "stlResources"));
           
        var eventDispatcher:IEventDispatcher = null;
           if(bundle == null) {    
           	eventDispatcher = this.parentApplication.xResourceManager.loadResourceModule(resourceModuleURL);                    
            eventDispatcher.addEventListener(ResourceEvent.ERROR, errorHandler);            
           } 
        this.parentApplication.xResourceManager.update();
     }
    
     private function errorHandler(event:ResourceEvent):void {
        XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.loadstlresourcebundle') + event.errorText);
     }
     
     
   //************** Page Specific Methos Definition Area Start *****************
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
        
        private function onChangeCounterpartyCode():void {
    	                
    	if(counterpartyCode.selectedItem.label != "BROKER") {
    		
	    	if(counterpartyCodeBox.getChildByName("Broker")) {
	    		this.finInst.finInstCode.text="";
	    	}
    		}
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
    
    	/**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
        private function populateCounterPartyActContext():ArrayCollection {
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
     
     private function checkFailSettlements():void{
     	if(failSettlements.selected) {
     		settlementStatus.text = Globals.EMPTY_STRING;
     		settlementStatus.enabled = false;
     		valueDateTo.text = Globals.EMPTY_STRING;
     		valueDateFrom.text = Globals.EMPTY_STRING;
     		entryDateTo.text = Globals.EMPTY_STRING;
     		entryDateFrom.text = Globals.EMPTY_STRING;
     	} else {
     		settlementStatus.enabled = true;
     	}
    } 
    
     //************* To fetch selected records *******************
      public function checkSelectToModify(item:Object):void {
        var i:Number;
        var tempArray:Array = new Array();
        if(item.selected == true){
        	 // needs to insert
        	var obj:Object=new Object();
        	
        	obj.settlementInfoPk = item.settlementInfoPk;
        	obj.fundCode = item.fundCode;
        	obj.fundAccountPk = item.fundAccountPk;
        	obj.fundAccountNo = item.fundAccountNo;
        	obj.firmAccountPk = item.firmAccountPk;
        	obj.ourBankId = item.ourBankId;
        	obj.ourDisplayAccountNo = item.ourDisplayAccountNo;
        	obj.cpName = item.cpName;
        	obj.cpBankId = item.cpBankId;
        	obj.cpDisplayAccountNo = item.cpDisplayAccountNo;
        	obj.contraidDisplayName = item.contraidDisplayName;
        	obj.ccyCode = item.ccyCode;
        	obj.valueDateStr = item.valueDateStr;
        	obj.outstandingAmtStr = item.outstandingAmtStr;
        	obj.outstandingQntyStr = item.outstandingQntyStr;
        	obj.deliverReceiveDisplay = item.deliverReceiveDisplay;
        	obj.createdby = item.createdby;        	
        	
        	obj.altSecurityCode = item.altSecurityCode;
        	obj.instrumentCode = item.instrumentCode;
        	obj.instrumentPk = item.instrumentPk;
        	obj.settlementReferenceNo = item.settlementReferenceNo;
        	obj.instructionType = item.instructionType;
        	obj.settlementType = item.settlementType;
        	obj.versionNo = item.versionNo;
        	obj.securityShortName = item.securityShortName;
        	obj.correspondingSecurityId = item.correspondingSecurityId;
        	obj.correspondingSecurityName = item.correspondingSecurityName;
        	
            selectedResults.addItem(obj);
    	}else { //needs to pop
    		tempArray=selectedResults.toArray();
    	    selectedResults.removeAll();
    		for(i=0; i<tempArray.length; i++){
    			if(tempArray[i].settlementInfoPk != item.settlementInfoPk){
    			    selectedResults.addItem(tempArray[i]);
    			}
    		}        		
    	}    	
    	setIfAllSelected();    	    	
    }
    
     public function selectAllRecords(flag:Boolean): void {
    	var i:Number = 0;
    	selectedResults.removeAll();
    	for(i=0; i<queryResult.length; i++){
    		var obj:XML=queryResult[i];
            obj.selected = flag;
            queryResult[i]=obj;
            addOrRemove(queryResult[i]);
    	} 
    	authorization.setFocus();    	 	
    }
    
     public function addOrRemove(item:Object):void {
    	var i:Number;
        var tempArray:Array = new Array();
        if(item.selected == true){ 
        	var obj:Object=new Object();
        	obj.settlementInfoPk = item.settlementInfoPk;
        	obj.fundCode = item.fundCode;
        	obj.fundAccountPk = item.fundAccountPk;
        	obj.fundAccountNo = item.fundAccountNo;
        	obj.firmAccountPk = item.firmAccountPk;
        	obj.ourBankId = item.ourBankId;
        	obj.ourDisplayAccountNo = item.ourDisplayAccountNo;
        	obj.cpName = item.cpName;
        	obj.cpBankId = item.cpBankId;
        	obj.cpDisplayAccountNo = item.cpDisplayAccountNo;
        	obj.contraidDisplayName = item.contraidDisplayName;
        	obj.ccyCode = item.ccyCode;
        	obj.valueDateStr = item.valueDateStr;
        	obj.outstandingAmtStr = item.outstandingAmtStr;
        	obj.outstandingQntyStr = item.outstandingQntyStr;
        	obj.deliverReceiveDisplay = item.deliverReceiveDisplay;
        	obj.createdby = item.createdby;        	
        	
        	obj.altSecurityCode = item.altSecurityCode;
        	obj.instrumentCode = item.instrumentCode;
        	obj.instrumentPk = item.instrumentPk;
        	obj.settlementReferenceNo = item.settlementReferenceNo;
        	obj.instructionType = item.instructionType;
        	obj.settlementType = item.settlementType;
        	obj.versionNo = item.versionNo;
        	obj.securityShortName = item.securityShortName;
        	obj.correspondingSecurityId = item.correspondingSecurityId;
        	obj.correspondingSecurityName = item.correspondingSecurityName;
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
    
    //********* User Confirmation Popup *************
    
    public function showConfirmModule():void {
    	var parentApp :UIComponent = UIComponent(this.parentApplication);    	
    	if(selectedResults.length < 1){
    		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.selectatleastonerecord'));
    		return;
    	}
    	authorization.enabled = false;
    	var summaryPopup:SummaryPopup;
    	summaryPopup = SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,false));
    	summaryPopup.title = "Authorization";
    	summaryPopup.width = 700;
    	summaryPopup.height = 445;
    	PopUpManager.centerPopUp(summaryPopup);
    	summaryPopup.owner = this;
    	summaryPopup.addEventListener(CloseEvent.CLOSE,closeHandler,false,0,true);
    	var rndNo:Number = Math.random();
    	summaryPopup.moduleUrl = "assets/appl/stl/SettlementAuthorizationConfirmation.swf?mode=entry&rnd="+rndNo;   	
    	
    }
    
    /**
     * Event Handler for the close event
     */
    public function closeHandler(event:CloseEvent):void {
    	    	
    	//this.dispatchEvent(new Event("querySubmit"));
    	//this.parentDocument.dispatchEvent(new Event("querySubmit")); 
    	authorization.enabled=true;
    	app.submitButtonInstance = authorization;               
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
  //*************** Page specific Method Definition Area End *******************     
         
     /**
	  * Method for updating the other two sortfields after any change in the sortfield1
	  */ 
	 private function sortOrder1Update():void {
	 	csd.update(sortField1.selectedItem, 0);
	 }
	    
	 /**
	  * Method for updating the other two sortfields after any change in the sortfield2
	  */
	 private function sortOrder2Update():void {     	
	    csd.update(sortField2.selectedItem, 1);
	 } 
            
     override public function preQueryInit():void {
		var rndNo:Number = Math.random();
		var reqObj:Object=new Object();
		        reqObj.method="initialExecute";
		        reqObj.mode="Authorization";
		        reqObj.rnd=rndNo;
		        reqObj['SCREEN_KEY']="810";
		super.getInitHttpService().url = "stl/authorizationInitialQueryDispatchAction.action?";
		super.getInitHttpService().request=reqObj;        	
     }
     
     override public function preQueryResultInit():Object {
        addCommonKeys();     	
	    return keylist;        	
     }
     /**
     * Method for preparing leylist
     */   
     private function addCommonKeys():void {  
        keylist = new ArrayCollection();        
	    keylist.addItem("sortFieldList1.item");
	    keylist.addItem("sortFieldList2.item");
	    keylist.addItem("sortFieldList4.item");
	    keylist.addItem("sortField1");
	    keylist.addItem("sortField2");
	    keylist.addItem("sortField4");
	    keylist.addItem("officeIdValues.officeId");	
	    keylist.addItem("subEventTypeValues.item");
	    keylist.addItem("valueDateFrom");
	    keylist.addItem("valueDateTo");
	    keylist.addItem("tradeReferenceForValues.item");
	    keylist.addItem("counterPartyTypeValues.item");
	    keylist.addItem("transactionTypeValues.item");
	    keylist.addItem("settlementStatusValues.item");
	    keylist.addItem("settlementStandingStatusValues.item");
	    keylist.addItem("contSettleStatusValues.item");
	    keylist.addItem("inxTransmissionValues.item");
	    keylist.addItem("transmissionStatusValues.item");
	    keylist.addItem("settleQueryForValues.item");
	    keylist.addItem("statusValues.item");
	    keylist.addItem("matchStatusValues.item");
	    keylist.addItem("dataSourceValues.item");
	    keylist.addItem("tradeTypeValues.item");
	    keylist.addItem("subTradeTypeValues.item");
	    keylist.addItem("status");
     }
     
     override public function postQueryResultInit(mapObj:Object):void {
        commonInit(mapObj);    		
     }
     
     /**
     * Method for initializing query page
     */   
     private function commonInit(mapObj:Object):void {
        var i:int = 0;
        var selIndx:int = 0;
        var tempColl:ArrayCollection = new ArrayCollection();
        var initColl:ArrayCollection = new ArrayCollection();
        var dateStr:String = null;
        
        //Initializing fields
        fundPopUp.fundCode.text = XenosStringUtils.EMPTY_STR;
        finInst.finInstCode.text = XenosStringUtils.EMPTY_STR;
        fundAccountNo.accountNo.text = XenosStringUtils.EMPTY_STR;
        stlRefNo.text = XenosStringUtils.EMPTY_STR;
        swiftRefNo.text = XenosStringUtils.EMPTY_STR;
        imOffice.selectedItem = XenosStringUtils.EMPTY_STR;
        subEventType.selectedItem = XenosStringUtils.EMPTY_STR;
        
        /*trddateFrom.text = XenosStringUtils.EMPTY_STR; 
		trddateTo.text = XenosStringUtils.EMPTY_STR;*/		
		trddateFrom.selectedDate = null;
		trddateTo.selectedDate = null;
		
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
		settleFor.selectedItem = XenosStringUtils.EMPTY_STR;		
		counterPartyAccount.accountNo.text = XenosStringUtils.EMPTY_STR;
			
		/*SettlementdateFrom.text = XenosStringUtils.EMPTY_STR; 
		SettlementdateTo.text = XenosStringUtils.EMPTY_STR;*/
		
		SettlementdateFrom.selectedDate = null;
		SettlementdateTo.selectedDate = null;
		
		instrumentType.itemCombo.text = XenosStringUtils.EMPTY_STR;	
		correspondingSecurityId.instrumentId.text = XenosStringUtils.EMPTY_STR;
		SettlementdateFrom.text = XenosStringUtils.EMPTY_STR; 
		SettlementdateFrom.text = XenosStringUtils.EMPTY_STR; 
		quantityFrom.text = XenosStringUtils.EMPTY_STR; 
		quantityTo.text = XenosStringUtils.EMPTY_STR;
		amountFrom.text = XenosStringUtils.EMPTY_STR; 
		amountTo.text = XenosStringUtils.EMPTY_STR;
		instructionRefNo.text = XenosStringUtils.EMPTY_STR;
		
		//transmissionDate.text = XenosStringUtils.EMPTY_STR;
		transmissionDate.selectedDate = null;
		
		cancelRefNo.text = XenosStringUtils.EMPTY_STR;
		/*
		entryDateFrom.text = XenosStringUtils.EMPTY_STR;
		entryDateTo.text = XenosStringUtils.EMPTY_STR;
		*/
		entryDateFrom.selectedDate = null;
		entryDateTo.selectedDate = null;
		/*
		lastEntryDateFrom.text = XenosStringUtils.EMPTY_STR;
		lastEntryDateTo.text = XenosStringUtils.EMPTY_STR;
		*/
		lastEntryDateFrom.selectedDate = null;
		lastEntryDateTo.selectedDate = null;
		
		failSettlements.selected = false;
		settlementStatus.enabled=true;	
		
		
		//IM Office
		if(mapObj[keylist.getItemAt(6)] is ArrayCollection) {
        	initColl = mapObj[keylist.getItemAt(6)] as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(mapObj[keylist.getItemAt(6)]);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem("");
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]); 
            //XenosAlert.info("Value at "+i.toString()+":"+initColl[i].toString());   
        }
        imOffice.dataProvider = tempColl;
        
         //Sub Event type
        if(mapObj[keylist.getItemAt(7)] is ArrayCollection) {
        	initColl = mapObj[keylist.getItemAt(7)] as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(mapObj[keylist.getItemAt(7)]);
        }   
        tempColl = new ArrayCollection();
        tempColl.addItem({label:"", value: ""});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        subEventType.dataProvider = tempColl;
        
         //valuedateFrom         
        //valueDateFrom.text = mapObj[keylist.getItemAt(8)];
        valueDateFrom.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(8)]);
        
        //valuedateTo   
        //valueDateTo.text = mapObj[keylist.getItemAt(9)];
        valueDateTo.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(9)]);
        
        
        //Trade Ref For
        if(mapObj[keylist.getItemAt(10)] is ArrayCollection) {
        	initColl = mapObj[keylist.getItemAt(10)] as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(mapObj[keylist.getItemAt(10)]);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        settleFor.dataProvider = tempColl;
        
        //Counter Party Type Values 
        if(mapObj[keylist.getItemAt(11)] is ArrayCollection) {
        	initColl = mapObj[keylist.getItemAt(11)] as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(mapObj[keylist.getItemAt(11)]);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        counterpartyCode.dataProvider = tempColl;
        
         //Transaction Type
        if(mapObj[keylist.getItemAt(12)] is ArrayCollection) {
        	initColl = mapObj[keylist.getItemAt(12)] as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(mapObj[keylist.getItemAt(12)]);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        transactionType.dataProvider = tempColl; 
        
         //Settlement Status
        if(mapObj[keylist.getItemAt(13)] is ArrayCollection) {
        	initColl = mapObj[keylist.getItemAt(13)] as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(mapObj[keylist.getItemAt(13)]);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        settlementStatus.dataProvider = tempColl;
        
         //Settlement Standing Status
        if(mapObj[keylist.getItemAt(14)] is ArrayCollection) {
        	initColl = mapObj[keylist.getItemAt(14)] as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(mapObj[keylist.getItemAt(14)]);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        settleStandingStatus.dataProvider = tempColl;
        
         //Contractual Settlement Status
        if(mapObj[keylist.getItemAt(15)] is ArrayCollection) {
        	initColl = mapObj[keylist.getItemAt(15)] as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(mapObj[keylist.getItemAt(15)]);
        }
        
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        contractualSettlementStatus.dataProvider = tempColl;
        
        //Inx Transmission
        if(mapObj[keylist.getItemAt(16)] is ArrayCollection) {
        	initColl = mapObj[keylist.getItemAt(16)] as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(mapObj[keylist.getItemAt(16)]);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        inxTransmossion.dataProvider = tempColl;
        
         //Transmission Status
        if(mapObj[keylist.getItemAt(17)] is ArrayCollection) {
        	initColl = mapObj[keylist.getItemAt(17)] as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(mapObj[keylist.getItemAt(17)]);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        transmissionStatus.dataProvider = tempColl;
        
        //Settle Query For
        if(mapObj[keylist.getItemAt(18)] is ArrayCollection) {
        	initColl = mapObj[keylist.getItemAt(18)] as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(mapObj[keylist.getItemAt(18)]);
        }

        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        settleQueryFor.dataProvider = tempColl; 
        
        //Status
        if(mapObj[keylist.getItemAt(19)] is ArrayCollection) {
        	initColl = mapObj[keylist.getItemAt(19)] as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(mapObj[keylist.getItemAt(19)]);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        var selectedIndex:int=0;
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
			if(initColl[i].label == mapObj[keylist.getItemAt(24)]) {
				selectedIndex = i+1;
			}       
        }
        status.dataProvider = tempColl; 
        status.selectedItem = tempColl[selectedIndex]; 
        
         //Match Status
        if(mapObj[keylist.getItemAt(20)] is ArrayCollection) {
        	initColl = mapObj[keylist.getItemAt(20)] as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(mapObj[keylist.getItemAt(20)]);
        }
        
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        matchStatus.dataProvider = tempColl;
        
        //Data Source
        if(mapObj[keylist.getItemAt(21)] is ArrayCollection) {
        	initColl = mapObj[keylist.getItemAt(21)] as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(mapObj[keylist.getItemAt(21)]);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        
        dataSource.dataProvider = tempColl;
        
        //Trade Type
        if(mapObj[keylist.getItemAt(22)] is ArrayCollection) {
        	initColl = mapObj[keylist.getItemAt(22)] as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(mapObj[keylist.getItemAt(22)]);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        tradeType.dataProvider = tempColl;
        
        //Sub Trade Type
        if(mapObj[keylist.getItemAt(23)] is ArrayCollection) {
        	initColl = mapObj[keylist.getItemAt(23)] as ArrayCollection;
        } else {
        	initColl = new ArrayCollection();
        	initColl.addItem(mapObj[keylist.getItemAt(23)]);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);    
        }
        subTradeType.dataProvider = tempColl;  
        
        
               
       	//For SortField1
        var sortField1Default:String = mapObj[keylist.getItemAt(3)].toString();
        //For SortField2
        var sortField2Default:String = mapObj[keylist.getItemAt(4)].toString();
        //For SortField3
        var sortField3Default:String = mapObj[keylist.getItemAt(5)].toString(); 
        
        errPage.clearError(super.getInitResultEvent()); //clears the errors if any 
        
        //----------Start of population of SortField1----------//	        
	    if(null != mapObj[keylist.getItemAt(0)]) {
	        initcol = new ArrayCollection();
	        tempColl = new ArrayCollection();
        	tempColl.addItem({label:" ", value: " "});
	        selIndx = 0;
	        	
	        if(mapObj[keylist.getItemAt(0)] is ArrayCollection) {
	        	for each(var item1:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)) {
		    		initcol.addItem(item1);
		    	}
	        } else {
	        		initcol.addItem(mapObj[keylist.getItemAt(0)]);
	        }
	        
		    for(i = 0; i<initcol.length; i++) {
		        //Get the default value object's index
	            if(XenosStringUtils.equals((initcol[i].value), sortField1Default)) {                    
	            	selIndx = i;
	            }
		        tempColl.addItem(initcol[i]);            
		    }
		        
		    sortFieldArray[0] = sortField1;
		    sortFieldDataSet[0] = tempColl;
		    //Set the default value object
		    sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
	    } else {
	        	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.sortorderlist1notpopulated'));
	    }	        
	    //---------------End of population of SortField1-----------------------//
	        
	    //--------Start of population of sortField2---------//	        
	    if(null != mapObj[keylist.getItemAt(1)]) {
	    	initcol = new ArrayCollection();
	        tempColl = new ArrayCollection();
	        tempColl.addItem({label:" ", value: " "});
	        selIndx = 0;
	        	
	        if(mapObj[keylist.getItemAt(1)] is ArrayCollection) {
	        	for each(var item2:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)) {
		    		initcol.addItem(item2);
		    	}
	        } else {
	        		initcol.addItem(mapObj[keylist.getItemAt(3)]);
	        }
		    for(i = 0; i<initcol.length; i++) {
		        //Get the default value object's index
	            if(XenosStringUtils.equals((initcol[i].value), sortField2Default)) {                    
	            	selIndx = i;
	        	}
		    	tempColl.addItem(initcol[i]);            
			}
		        
			sortFieldArray[1] = sortField2;
			sortFieldDataSet[1] = tempColl;
			//Set the default value object
			sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);
	    } else {
	        XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.sortorderlist2notpopulated'));
	    }	        
	    //--------End of population of sortField2---------// 
	        
	    //--------Start of population of sortField3---------//	        
	    if(null != mapObj[keylist.getItemAt(2)]) {
	        initcol = new ArrayCollection();
	        tempColl = new ArrayCollection();
	        tempColl.addItem({label:" ", value: " "});
	        selIndx = 0;
	        	
	        if(mapObj[keylist.getItemAt(2)] is ArrayCollection) {
	        	for each(var item3:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)) {
		    		initcol.addItem(item3);
		    	}
	        } else {
	        		initcol.addItem(mapObj[keylist.getItemAt(2)]);
	        }
		    for(i = 0; i<initcol.length; i++) {
		        //Get the default value object's index
	            if(XenosStringUtils.equals((initcol[i].value), sortField3Default)) {                    
	            	selIndx = i;
	            }		        	
		        tempColl.addItem(initcol[i]);            
		    }
		        
		    sortFieldArray[2] = sortField3;
		    sortFieldDataSet[2] = tempColl;
		    //Set the default value object
		    sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx+1);
	    } else {
	        XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.sortorderlist3notpopulated'));
	    }	        
	    //--------End of population of sortField3---------//
	        
	    //------------- End of Initializing the sortfields-------------//
        csd = new CustomizeSortOrder(sortFieldArray, sortFieldDataSet, sortFieldSelectedItem);
		csd.init();
		app.submitButtonInstance = submit;
		fundPopUp.setFocus();
     }
     
     override public function preQuery():void {       
	 	setValidator();	 	
        qh.resetPageNo();  
        var rndNo:Number = Math.random();          
        super.getSubmitQueryHttpService().url = "stl/authorizationQueryDispatchAction.action?rnd="+rndNo;  
        super.getSubmitQueryHttpService().request = populateRequestParams();
	 }
	 /**
	 * Method for client side validation
	 */
     private function setValidator():void {
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
                                 settleDateTo:this.SettlementdateTo.text,
                                 transmissionDate:this.transmissionDate.text  
                                        
                            }
                           }; 
        super._validator = new AuthorizationQueryValidator();
        super._validator.source = myModel;
        super._validator.property = "tradeQuery";
	 }
		
     /**
      * This method will populate the request parameters for the
      * submitQuery call and bind the parameters with the HTTPService
      * object.
      */
     private function populateRequestParams():Object {
        var reqObj:Object = new Object();         
        reqObj.method = "doQuery";       
        reqObj['SCREEN_KEY']="302";
        reqObj.fundCode = this.fundPopUp.fundCode.text;
        reqObj.fundAccountNo = this.fundAccountNo.accountNo.text;
        reqObj.settlementReferenceNo = this.stlRefNo.text; 
     	reqObj.swiftReferenceNo = this.swiftRefNo.text;   	
     	
     	reqObj.IMOffice = this.imOffice.selectedItem != null ? this.imOffice.selectedItem : Globals.EMPTY_STRING;
     	
     	reqObj.subEventType = this.subEventType.selectedItem != null ?  this.subEventType.selectedItem.value : Globals.EMPTY_STRING;
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
        	if(instructionTypeArray.length<=0){
        		instructionTypeArray.push(" ");
        	}
                		
        reqObj.instructionTypeArray = instructionTypeArray;       
        
        reqObj.tradeReferenceNo = this.trdRefNo.text;
        reqObj.settleFor = this.settleFor.selectedItem != null ?  this.settleFor.selectedItem.value : Globals.EMPTY_STRING;
        reqObj.counterPartyType = this.counterpartyCode.selectedItem != null ?  this.counterpartyCode.selectedItem.value : Globals.EMPTY_STRING;
          
        if(counterpartyCodeBox.getChildByName("Broker"))
     		reqObj.counterPartyCode = this.finInst.finInstCode.text;
     	else
     		reqObj.counterPartyCode = Globals.EMPTY_STRING;
     	
     	reqObj.cpAccountNo = this.counterPartyAccount.accountNo.text;	
     	reqObj.transactionType = this.transactionType.selectedItem != null ?  this.transactionType.selectedItem.value : Globals.EMPTY_STRING;
     	reqObj.settlementStatus = this.settlementStatus.selectedItem != null ?  this.settlementStatus.selectedItem.value : Globals.EMPTY_STRING;
     	reqObj.settlementInfoStatus = this.settleStandingStatus.selectedItem != null ?  this.settleStandingStatus.selectedItem.value : Globals.EMPTY_STRING;
     	reqObj.contSettleStatus = this.contractualSettlementStatus.selectedItem != null ?  this.contractualSettlementStatus.selectedItem.value : Globals.EMPTY_STRING;	
     	reqObj.settleDateFrom = this.SettlementdateFrom.text; 
        reqObj.settleDateTo = this.SettlementdateTo.text; 
        reqObj.inxTransmission = this.inxTransmossion.selectedItem != null ?  this.inxTransmossion.selectedItem.value : Globals.EMPTY_STRING;
        reqObj.instrumentType = this.instrumentType.itemCombo.text;	
        reqObj.correspondingSecurityId = this.correspondingSecurityId.instrumentId.text;
        reqObj.quantityFrom = this.quantityFrom.text; 
        reqObj.quantityTo = this.quantityTo.text; 
        reqObj.amountFrom = this.amountFrom.text; 
        reqObj.amountTo = this.amountTo.text;
        reqObj.instructionReferenceNo = this.instructionRefNo.text;
        reqObj.transmissionDate = this.transmissionDate.text;
        reqObj.transmissionStatus = this.transmissionStatus.selectedItem != null ?  this.transmissionStatus.selectedItem.value : Globals.EMPTY_STRING;
        reqObj.cancelReferenceNo = this.cancelRefNo.text;
        reqObj.settleQueryFor = this.settleQueryFor.selectedItem != null ?  this.settleQueryFor.selectedItem.value : Globals.EMPTY_STRING;
        
        reqObj.status = this.status.selectedItem != null ?  this.status.selectedItem.value : Globals.EMPTY_STRING;
        reqObj.matchStatus = this.matchStatus.selectedItem != null ?  this.matchStatus.selectedItem.value : Globals.EMPTY_STRING;
        reqObj.entryDateFrom = this.entryDateFrom.text;
        reqObj.entryDateTo = this.entryDateTo.text;
        reqObj.lastEntryDateFrom = this.lastEntryDateFrom.text;
        reqObj.lastEntryDateTo = this.lastEntryDateTo.text;
        reqObj.dataSource = this.dataSource.selectedItem != null ?  this.dataSource.selectedItem.value : Globals.EMPTY_STRING;
        reqObj.tradeType = this.tradeType.selectedItem != null ?  this.tradeType.selectedItem.value : Globals.EMPTY_STRING;
        reqObj.subTradeType = this.subTradeType.selectedItem != null ?  this.subTradeType.selectedItem.value : Globals.EMPTY_STRING;
        reqObj.failNotice = this.failSettlements.selected == true ?  "Y":"N";
                 
	   	reqObj.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : Globals.EMPTY_STRING;	   
	    reqObj.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : Globals.EMPTY_STRING;	   
	    reqObj.sortField4 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : Globals.EMPTY_STRING;
	    reqObj.mode = "Authorization";	      
        
        return reqObj;
     }
    
     override public function postQueryResultHandler(mapObj:Object):void {     	     	
     	commonResult(mapObj);
     }
        
     private function commonResult(mapObj:Object):void {     	    	
    	var result:String = "";
    	errPageResultSum.removeError();
    	if(mapObj != null) {     		 		
	    	if(mapObj["errorFlag"].toString() == "error") {	    		
	    		queryResult.removeAll();
	    		errPage.showError(mapObj["errorMsg"]);
	    	} else if(mapObj["errorFlag"].toString() == "noError") {	    		
	    	    errPage.clearError(super.getSubmitQueryResultEvent());	    	    
                queryResult.removeAll();	    	    
                queryResult=mapObj["row"];
                
                resetSellection(queryResult);
                selectedResults.removeAll();
	            setIfAllSelected();
			    changeCurrentState();
		        qh.setOnResultVisibility();
		        qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
		        qh.PopulateDefaultVisibleColumns();
		        app.submitButtonInstance = authorization;
	    	} else {	    		
	    		errPage.removeError();
	    		queryResult.removeAll();
	    		selectedResults.removeAll();
	            selectAllBind = false;
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}    		
    	}    	
     }   
       
      
     override public function preResetQuery():void {     	
		var rndNo:Number = Math.random();
		super.getResetHttpService().url = "stl/authorizationInitialQueryDispatchAction.action?method=resetQuery&menuType=Y&rnd=" + rndNo;
     }
        
     override  public function preGenerateXls():String {
        var url:String = null;
		if(mode == "query") {		    		
			url = "stl/authorizationQueryDispatchAction.action?method=generateXLS";
		}
		return url;
     }
     	
     override public function preGeneratePdf():String {
    	var url:String = null;
		if(mode == "query") {					    		
			url = "stl/authorizationQueryDispatchAction.action?method=generatePDF";
		}
		return url;
     }	
            
     override public function preNext():Object {
    	var reqObj:Object = new Object();
    	reqObj.rnd = Math.random() + "";
    	reqObj.method = "doNext";
    	return reqObj;
     }
     	
     override public function prePrevious():Object {
    	var reqObj:Object = new Object();
    	reqObj.rnd = Math.random() + "";
    	reqObj.method = "doPrevious";
    	return reqObj;
     }	
          
     private function dispatchPrintEvent():void {
        this.dispatchEvent(new Event("print"));
     }
       
     private function dispatchPdfEvent():void {
        this.dispatchEvent(new Event("pdf"));
     }
       
     private function dispatchXlsEvent():void {
        this.dispatchEvent(new Event("xls"));
     }
         
     private function dispatchNextEvent():void {
        this.dispatchEvent(new Event("next"));
     }
      
     private function dispatchPrevEvent():void {
        this.dispatchEvent(new Event("prev"));
     }      
       
      

