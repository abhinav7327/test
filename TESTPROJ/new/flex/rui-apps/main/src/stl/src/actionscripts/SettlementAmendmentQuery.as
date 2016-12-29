// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.RendererFectory;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.ref.popupImpl.FundPopUpHbox;
import com.nri.rui.stl.validators.StlAmendQueryValidator;

import mx.collections.ArrayCollection;
import mx.controls.DataGrid;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.DataGridEvent;
			
	[Bindable]
    private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    
    [Bindable]
    private var queryResult:ArrayCollection= new ArrayCollection();
     
    private var keylist:ArrayCollection = new ArrayCollection(); 
     
    private var sortFieldArray:Array = new Array();
    private var sortFieldDataSet:Array = new Array();
    private var sortFieldSelectedItem:Array = new Array();
    
    private var  csd:CustomizeSortOrder = null;
    
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    
    [Bindable]
    private var fundPopup:FundPopUpHbox = new FundPopUpHbox();
    
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    
    [Bindable]
	private var mode : String = "amend";
            
	/**
	 *  datagrid header release event handler to handle datagridcolumn sorting
	 */
	public function dataGrid_headerRelease(evt:DataGridEvent):void {
		//sortUtil.clickedColumn=evt.dataField;
		var dg:DataGrid = DataGrid(evt.currentTarget);
		sortUtil.clickedColumn = dg.columns[evt.columnIndex];
	}
	
	private function changeCurrentState():void {
		currentState = "result";
	}
			 
    public function loadAll():void {
    	super.setXenosQueryControl(new XenosQuery());    	
    	if(this.mode == 'amend') { 
  			this.dispatchEvent(new Event('amendInit'));
  		}    	
  		//addColumn();
    	
  		/*if(this.mode == 'query') { 
  			this.dispatchEvent(new Event('queryInit'));
  			this.baseDate.setFocus();
  		} else if(this.mode == 'amend') {
  			this.dispatchEvent(new Event('amendInit'));
  			this.baseDate.setFocus();
  			addColumn();
  		} else {
  			this.dispatchEvent(new Event('cancelInit'));
  			this.baseDate.setFocus();
  			addColumn();
  		}*/
  	}
  	
    /**
     * Extracts the parameters and set them to some variables for query criteria 
     * from the Module Loader Info.
     */ 
    public function parseUrlString():void {
    	//TODO: Not required as I have no information to get from the URL                     
    }

    override public function preAmendInit():void {
        var reqObj:Object = new Object();
        reqObj.screenType = "M";
        reqObj.SCREEN_KEY = 358;
        reqObj.rnd = Math.random();
    	super.getInitHttpService().request = reqObj;
		super.getInitHttpService().url = "stl/stlAmendmentQueryDispatch.action?method=initialExecute";        	
	}
        
    private function addCommonKeys():void {  
    	keylist = new ArrayCollection();      	
    	keylist.addItem("settleQueryForList.item");
    	keylist.addItem("settlementForList.item");
    	keylist.addItem("settleInfoStatusList.item");
    	keylist.addItem("settlementTypeList.item");
    	keylist.addItem("sortFieldList1.item");	
	    keylist.addItem("sortFieldList2.item");	
	    keylist.addItem("sortFieldList3.item");
	    keylist.addItem("sortFieldList4.item");	
    	keylist.addItem("transactionTypeList.item");
    }
        
    override public function preAmendResultInit():Object{
    	//var keylist:ArrayCollection = new ArrayCollection(); 
    	addCommonKeys();   		    	
    	return keylist;        	
    }
        
    private function commonInit(mapObj:Object):void {
        
        //Initialize the fields
    	
    	fundPopUp.fundCode.text = XenosStringUtils.EMPTY_STR;
     	fundAccountNo.accountNo.text = XenosStringUtils.EMPTY_STR;
     	
     	settlementReferenceNo.text = XenosStringUtils.EMPTY_STR;
     	 
     	swiftReferenceNo.text = XenosStringUtils.EMPTY_STR; 
     	tradeReferenceNo.text = XenosStringUtils.EMPTY_STR;
     	
     	counterPartyAccountNo.accountNo.text = XenosStringUtils.EMPTY_STR;
     	
		trdDateFrom.text = XenosStringUtils.EMPTY_STR; 
		trdDateTo.text = XenosStringUtils.EMPTY_STR;           
		valueDateFrom.text = XenosStringUtils.EMPTY_STR; 
		valueDateTo.text = XenosStringUtils.EMPTY_STR;  
		
		securityCode.instrumentId.text = XenosStringUtils.EMPTY_STR;
		currency.ccyText.text = XenosStringUtils.EMPTY_STR;
		
		firmSettlementBank.finInstCode.text = XenosStringUtils.EMPTY_STR;  
		firmSettlementAccount.accountNo.text = XenosStringUtils.EMPTY_STR; 
		
		errPage.clearError(super.getInitResultEvent());
		this.queryResult.removeAll();
		
		//Preparing the Drop Down List
		var index:int=-1;
		var initcol:ArrayCollection = new ArrayCollection();
		
		//Settlement Query For
    	initcol.addItem({label:" ", value: " "});
    	index=0;
    	for each(var item:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)) {
    		initcol.addItem(item);
    	}
    	settlementQueryFor.dataProvider = initcol;
    	settlementQueryFor.selectedIndex = 0;
    	
    	//Settlement For
		initcol = new ArrayCollection();
    	initcol.addItem({label:" ", value: " "});
    	index=0;
    	for each(item in (mapObj[keylist.getItemAt(1)] as ArrayCollection)) {
    		initcol.addItem(item);
    	}
    	settlementFor.dataProvider = initcol;
    	settlementFor.selectedIndex = 0;
    	
    	//Settlement Info Status
		initcol = new ArrayCollection();
    	initcol.addItem({label:" ", value: " "});
    	index=0;
    	for each(item in (mapObj[keylist.getItemAt(2)] as ArrayCollection)) {
    		initcol.addItem(item);
    	}
    	settlementStandingStatus.dataProvider = initcol;
    	settlementStandingStatus.selectedIndex = 0;
    	
    	//Settlement Type
    	initcol = new ArrayCollection();
    	initcol.addItem({label:" ", value: " "});
    	index=0;
    	for each(item in (mapObj[keylist.getItemAt(3)] as ArrayCollection)) {
    		initcol.addItem(item);
    	}
    	settlementType.dataProvider = initcol;
    	settlementType.selectedIndex = 0;
    	
		//Sort Fields
		
		var i:int = 0;
        var selIndx:int = 0;
        
		//variables to hold the default values from the server
        var sortField1Default:String = "fund_code";
        var sortField2Default:String = "fund_account_no";
        var sortField3Default:String = "security_id";
        var sortField4Default:String = "settlement_reference_no";
    	
    	//Sort Field 1
    	initcol = new ArrayCollection();
	    initcol.addItem({label:" ", value: " "});
	    
    	for each(item in (mapObj[keylist.getItemAt(4)] as ArrayCollection)) {
    		//Get the default value object's index
            if(XenosStringUtils.equals((item.value), sortField1Default)) {                    
                selIndx = i;
            }
    		initcol.addItem(item);
    		i++;
    	}
    	sortFieldArray[0] = sortField1;
	    sortFieldDataSet[0] = initcol;
	    sortFieldSelectedItem[0] = initcol.getItemAt(selIndx+1);
	    
	    //Sort Field 2
	    i=0;
	    selIndx = 0;
	    initcol = new ArrayCollection();
	    
	    initcol.addItem({label:" ", value: " "});
    	for each(item in (mapObj[keylist.getItemAt(5)] as ArrayCollection)) {
    		//Get the default value object's index
            if(XenosStringUtils.equals((item.value), sortField2Default)) {                    
                selIndx = i;
            }
    		initcol.addItem(item);
    		i++;
    	}
    	sortFieldArray[1] = sortField2;
	    sortFieldDataSet[1] = initcol;
	    sortFieldSelectedItem[1] = initcol.getItemAt(selIndx+1);
	    
	    //Sort Field 3
	    i=0;
	    selIndx = 0;
	    initcol = new ArrayCollection();
	    
	    initcol.addItem({label:" ", value: " "});
    	for each(item in (mapObj[keylist.getItemAt(6)] as ArrayCollection)) {
    		//Get the default value object's index
            if(XenosStringUtils.equals((item.value), sortField3Default)) {                    
                selIndx = i;
            }
    		initcol.addItem(item);
    		i++;
    	}
    	sortFieldArray[2] = sortField3;
	    sortFieldDataSet[2] = initcol;
	    sortFieldSelectedItem[2] = initcol.getItemAt(selIndx+1);
	    
	    //Sort Field 4
	    i=0;
	    selIndx = 0;
	    initcol = new ArrayCollection();
	    
	    initcol.addItem({label:" ", value: " "});
    	for each(item in (mapObj[keylist.getItemAt(7)] as ArrayCollection)) {
    		//Get the default value object's index
            if(XenosStringUtils.equals((item.value), sortField4Default)) {                    
                selIndx = i;
            }
    		initcol.addItem(item);
    		i++;
    	}
    	sortFieldArray[3] = sortField4;
	    sortFieldDataSet[3] = initcol;
	    sortFieldSelectedItem[3] = initcol.getItemAt(selIndx+1);
	    
	    csd = new CustomizeSortOrder(sortFieldArray, sortFieldDataSet, sortFieldSelectedItem);
	    csd.init();
    	
    	//Transaction Type
    	initcol = new ArrayCollection();
    	initcol.addItem({label:" ", value: " "});
    	index=0;
    	for each(item in (mapObj[keylist.getItemAt(8)] as ArrayCollection)) {
    		initcol.addItem(item);
    	}
    	transactionType.dataProvider = initcol;
    	transactionType.selectedIndex = 0;
    	
    	//*************************************************
    }
    
    override public function postAmendResultInit(mapObj:Object):void {
    	commonInit(mapObj);
    	//app.submitButtonInstance = submit;
    	fundPopUp.fundCode.setFocus();
    }
    
    private function setValidator():void {    	
    	var validateModel:Object={
                        StlAmendQuery:{                                 
                             trdDateFrom:this.trdDateFrom.text,
                             trdDateTo:this.trdDateTo.text,
                             valueDateFrom:this.valueDateFrom.text,
                             valueDateTo:this.valueDateTo.text                             
                        }
                       }; 
         super._validator = new StlAmendQueryValidator();
         super._validator.source = validateModel ;
         super._validator.property = "StlAmendQuery";
    }
    
    override public function preAmend():void {
    	setValidator();
    	qh.resetPageNo();
    	//XenosAlert.info("I am in preAmend ");
    	super.getSubmitQueryHttpService().url = "stl/stlAmendmentQueryDispatch.action?rnd="+Math.random();
    	super.getSubmitQueryHttpService().request = populateRequestParams();
    	super.getSubmitQueryHttpService().method = "POST";
    }
		
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	reqObj.SCREEN_KEY = 359;
    	reqObj.method= "submitQuery";
    	
    	reqObj.fundCode = this.fundPopUp.fundCode.text;
		reqObj.fundAccountNo = this.fundAccountNo.accountNo.text;
		reqObj.settlementReferenceNo = this.settlementReferenceNo.text;
		reqObj.settlementType = this.settlementType.selectedItem != null ?  this.settlementType.selectedItem.value : "";
		reqObj.senderReferenceNo = this.swiftReferenceNo.text;
		reqObj.tradeReferenceNo = this.tradeReferenceNo.text;
		reqObj.settleFor = this.settlementFor.selectedItem != null ?  this.settlementFor.selectedItem.value : "";
		reqObj.transactionType = this.transactionType.selectedItem != null ?  this.transactionType.selectedItem.value : "";
		reqObj.cpAccountNo = this.counterPartyAccountNo.accountNo.text;
		reqObj.tradeDateFrom = this.trdDateFrom.text;
		reqObj.tradeDateTo = this.trdDateTo.text;
		reqObj.valueDateFrom = this.valueDateFrom.text;
		reqObj.valueDateTo = this.valueDateTo.text;
		reqObj.securityCode = this.securityCode.instrumentId.text;
		reqObj.settlementCcy = this.currency.ccyText.text;
		reqObj.settleQueryFor = this.settlementQueryFor.selectedItem != null ?  this.settlementQueryFor.selectedItem.value : "";
		reqObj.settlementInfoStatus = this.settlementStandingStatus.selectedItem != null ?  this.settlementStandingStatus.selectedItem.value : "";
		reqObj.firmBankCode = this.firmSettlementBank.finInstCode.text; 
		reqObj.firmBankAccount = this.firmSettlementAccount.accountNo.text;
		
		reqObj.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.sortField3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : XenosStringUtils.EMPTY_STR;
        reqObj.sortField4 = this.sortField4.selectedItem != null ? StringUtil.trim(this.sortField4.selectedItem.value) : XenosStringUtils.EMPTY_STR;
    	
    	reqObj.rnd = Math.random() + "";
     	return reqObj;
    }
    
    override public function postAmendResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    	//app.submitButtonInstance = submit;
    }
    
    private function commonResult(mapObj:Object):void {
    	//XenosAlert.info("mapObj : "+mapObj.toString()); 
    	//var mapObj:Object = mkt.userQueryResultEvent(event,null);
    	var result:String = "";
    	
    	if(mapObj!=null) {
    		//XenosAlert.info("mapObj : "+mapObj.toString()); 		
	    	if(mapObj["errorFlag"].toString() == "error") {
	    		//result = mapObj["errorMsg"] .toString();
	    		queryResult.removeAll();
	    		errPage.showError(mapObj["errorMsg"]);
	    	} else if(mapObj["errorFlag"].toString() == "noError") {
	    		errPage.clearError(super.getSubmitQueryResultEvent());
	    		//errPage.removeError();
	    		// XenosAlert.info("I am in errPage ");
	    		queryResult.removeAll();
	    		// XenosAlert.info("I am in queryResult : "+currentState);
	    		queryResult=mapObj["row"];
	    		changeCurrentState();
	    		qh.setOnResultVisibility();
	    		qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
	    		qh.PopulateDefaultVisibleColumns();	    		
	    	} else {
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}    		
    	}
    	//XenosAlert.info(result);
    }   
       
    override public function preResetAmend():void {
    	var rndNo:Number= Math.random();
    	super.getResetHttpService().url = "stl/stlAmendmentQueryDispatch.action?method=resetQuery&rnd=" + rndNo;
    	var reqObject:Object = new Object();
    	reqObject.SCREEN_KEY = 358;
    	super.getResetHttpService().request = reqObject;     	
    }
        
	override public function preGenerateXls():String {
		var url : String = "stl/stlAmendmentQueryDispatch.action?method=generateXLS&rnd=" + Math.random();
		return url;
	}
	
	override public function preGeneratePdf():String {
		var url : String = "stl/stlAmendmentQueryDispatch.action?method=generatePDF&rnd=" + Math.random();
		return url;
	}
		
    override public function preNext():Object {
    	var reqObj : Object = new Object();
    	reqObj.method = "doNext";
    	return reqObj;
    }
    
    override public function prePrevious():Object {
    	var reqObj : Object = new Object();
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
      
	private function addColumn():void {
		//Add a object
		
		var dg :DataGridColumn = new DataGridColumn();
		dg.dataField="";
		dg.editable = false;
		dg.headerText = "";
		dg.width = 40;
		dg.itemRenderer = new RendererFectory(ImgSummaryRenderer);
		
		var cols :Array = resultSummary.columns;
		cols.unshift(dg);
		cols.pop();
		resultSummary.columns = cols;
	}
	
	/**
     * This is the method to pass the Collection of data items
     * through the context to the account popup. 
     * 
     * This function is specific for Fund Account No.
     */
    private function populateFundAccountContext():ArrayCollection {
    	//pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
      
        //passing act type                
        var actTypeArray:Array = new Array(1);
        actTypeArray[0]="T|B";
        myContextList.addItem(new HiddenObject("actTypeContext", actTypeArray));    
                  
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
     * This is the method to pass the Collection of data items
     * through the context to the account popup.
     *  
     * This function is specific for Counter Party Account No.
     */
    private function populateCounterPartyAccountContext():ArrayCollection {
    	//pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
      
        //passing act type                
        var actTypeArray:Array = new Array(1);
        actTypeArray[0]="T|B";
        myContextList.addItem(new HiddenObject("cpActTypeContext", actTypeArray));    
                  
        //passing counter party type                
        var cpTypeArray:Array = new Array(1);
        cpTypeArray[0]="BROKER|BANK/CUSTODIAN";
        myContextList.addItem(new HiddenObject("cpCPTypeContext", cpTypeArray));
    
        //passing account status                
        var actStatusArray:Array = new Array(1);
        actStatusArray[0]="OPEN";
        myContextList.addItem(new HiddenObject("actStatusContext", actStatusArray));
        
        return myContextList;
    }
    
    /**
     * This is the method to pass the Collection of data items
     * through the context to the FinInst popup. 
     * 
     * This function is specific to Our/Firm Bank
     */
    private function populateFirmBankContext():ArrayCollection {
    	//pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
        
        var bankRoleArray : Array = new Array(3);
        bankRoleArray[0] = "Security Broker";
        bankRoleArray[1] = "Bank/Custodian";
        bankRoleArray[2] = "Central Depository";
        
        myContextList.addItem(new HiddenObject("bankRoles", bankRoleArray));
        
        return myContextList;
    }
    
    /**
     * Method to create the context for Account popup corresponding to the Firm
     * Settlement Account also known as Own/Our/Fund Settlement Account.
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
    
    private function sortOrder1Update():void {
    	csd.update(sortField1.selectedItem, 0);
    }
     
    private function sortOrder2Update():void {     	
    	csd.update(sortField2.selectedItem, 1);
    }
     
    private function sortOrder3Update():void {     	
    	csd.update(sortField3.selectedItem, 2);
    }
    
    private function getSecurityId(item:Object, column:DataGridColumn):String {
		return item.securityId;
	}
	
	private function getFundCode(item:Object, column:DataGridColumn):String {
		return item.fundCode;
	}
	
	private function getFundAccountNo(item:Object, column:DataGridColumn):String {
		return item.fundAccountNo;
	}
	
	private function getCpAccountNo(item:Object, column:DataGridColumn):String {
		return item.cpAccountNo;
	}