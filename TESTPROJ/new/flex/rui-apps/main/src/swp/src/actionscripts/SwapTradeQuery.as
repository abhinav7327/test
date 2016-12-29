
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
import com.nri.rui.ref.popupImpl.CustomerPopUpHbox;
import com.nri.rui.ref.popupImpl.FinInstitutePopUpHbox;
import com.nri.rui.ref.popupImpl.StrategyPopUpHBox;
import com.nri.rui.swp.validator.TradeQueryValidator;

import mx.collections.ArrayCollection;
import mx.controls.TextInput;
import mx.controls.dataGridClasses.DataGridColumn;

import mx.formatters.NumberBase;
import mx.managers.PopUpManager;
import com.nri.rui.core.containers.SummaryPopup;
import mx.core.UIComponent;
 
[Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
[Bindable]private var queryResult:ArrayCollection= new ArrayCollection();
[Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
[Bindable]private var mode : String = "query";
[Bindable]private var finInst:FinInstitutePopUpHbox = new FinInstitutePopUpHbox();
[Bindable]private var strategyPopup:StrategyPopUpHBox = new StrategyPopUpHBox();
[Bindable]private var customerPopup:CustomerPopUpHbox = new CustomerPopUpHbox();
[Bindable]private var counterPartyTxtInput:TextInput = new TextInput();
[Bindable]private var initcol:ArrayCollection = new ArrayCollection();
[Bindable]private var tempColl: ArrayCollection = new ArrayCollection();
[Bindable]private var tradeQueryMode:String = "";

private var keylist:ArrayCollection = new ArrayCollection(); 
private var csd:CustomizeSortOrder = null;
private var sortFieldArray:Array =new Array();
private var sortFieldDataSet:Array =new Array();
private var sortFieldSelectedItem:Array =new Array();
private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
private var selIndx:int = 0;
private var i:int = 0;
private var item:Object = new Object();
	
	[Bindable] private var terminationMode : Boolean = false ;
          
	public function loadAll():void
	{
	   parseUrlString();
	   super.setXenosQueryControl(new XenosQuery());   
	   if(this.mode == "query"){
	     this.dispatchEvent(new Event('queryInit'));
	   } else if(this.mode == 'AMEND' || this.mode == 'amend'){
	     this.dispatchEvent(new Event('amendInit'));
	     addColumn();
	   } else if(this.mode == 'CANCEL'){ 
	     this.dispatchEvent(new Event('cancelInit'));
	     addColumn();
	   }           
	}
	
	/**
	 * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
	 * 
	 */ 
	public function parseUrlString():void
	{
	    try {
	        // Remove everything before the question mark, including the question mark.
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
	        if(params != null){
	            for (var i:int = 0; i < params.length; i++) {
	                var tempA:Array = params[i].split("=");  
	                if (tempA[0] == "modeOfOperation") {
	                    mode = tempA[1];
	                }
	                if (tempA[0] == "termination") {
	                	//XenosAlert.info("T M : " + tempA[1]);
	                	if (tempA[1] == "true") {
	                		//XenosAlert.info("dfvfdv : " + tempA[1]);
	                		terminationMode = true;
	                	}
	                }
	            }                       
	        } else {
	            mode = "query";
	        } 
	    } catch (e:Error) {
	        trace(e);
	    }               
	}
        
	override public function preQueryInit():void {    
		var rndNo:Number= Math.random();  
		var req : Object = new Object();
	    req["SCREEN_KEY"] = "11115";
	    req["modeOfOperation"] = "query" ;
		super.getInitHttpService().url = "swp/swpTradeQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
	    super.getInitHttpService().request = req;
	}
	        
	override public function preAmendInit():void
	{
		
	    var rndNo:Number= Math.random();
	   
	    var req : Object = new Object();
	    req.SCREEN_KEY = "11115";
	    
	    if (terminationMode) {
	    	super.getInitHttpService().url = "swp/swpTradeTerminationQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
			req["modeOfOperation"] = "TERMINATION" ;
	    } else {
	    	super.getInitHttpService().url = "swp/swpTradeAmendQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
	    	req["modeOfOperation"] = "AMEND" ;
	    }
	    super.getInitHttpService().request = req;
	}
	        
	override public function preCancelInit():void
	{
	    var rndNo:Number= Math.random();
	    super.getInitHttpService().url = "swp/swpTradeCancelQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
	    var req : Object = new Object();
	    req.SCREEN_KEY = "11115";
	    req["modeOfOperation"] = "CANCEL" ;
	    super.getInitHttpService().request = req;                 
	}
	
        
	private function addCommonKeys():void
	{  
	    keylist = new ArrayCollection();        
	    
	    keylist.addItem("productType.item");
	    keylist.addItem("officeList.officeList");
	    keylist.addItem("notionalExchangeFlagList.item");
	    keylist.addItem("dataSourceList.item");
	    keylist.addItem("cxlDataSourceList.item");
	    keylist.addItem("statusList.item");
	    keylist.addItem("deliveryReceiveFlagList.item");
	    keylist.addItem("interestRateTypeList.item");
	    keylist.addItem("fixedFloatingTypeList.item");
	    keylist.addItem("paymentFrequencyList.item");    
	
	    keylist.addItem("sortFieldList1.item");
	    keylist.addItem("sortFieldList2.item");
	    keylist.addItem("sortFieldList3.item");
	    keylist.addItem("sortField1");
	    keylist.addItem("sortField2");
	    keylist.addItem("sortField3");
	    
	    keylist.addItem("terminationFlagList.item");
	}
        
	override public function preQueryResultInit():Object
	{
	    addCommonKeys();    
	    return keylist;         
	}
	        
	override public function preAmendResultInit():Object
	{
	    addCommonKeys();                
	    return keylist;         
	}
	        
	override public function preCancelResultInit():Object
	{
	    addCommonKeys();                
	    return keylist;         
	}
        
	private function commonInit(mapObj:Object):void
	{
	    //clears the errors if any
	    errPage.clearError(super.getInitResultEvent());
	    app.submitButtonInstance = submit;
	    
	    tradeDateFrom.text = XenosStringUtils.EMPTY_STR;
	    tradeDateTo.text = XenosStringUtils.EMPTY_STR;
	    //valueDate.text = XenosStringUtils.EMPTY_STR;
	    maturityDateFrom.text = XenosStringUtils.EMPTY_STR;
	    maturityDateTo.text = XenosStringUtils.EMPTY_STR;
	    terminationDateFrom.text = XenosStringUtils.EMPTY_STR;
	    terminationDateTo.text = XenosStringUtils.EMPTY_STR;
	    fundPopUp.fundCode.text = XenosStringUtils.EMPTY_STR;
	    inventoryAccountNo.accountNo.text = XenosStringUtils.EMPTY_STR;
	    accountNo.accountNo.text = XenosStringUtils.EMPTY_STR;
	    contractReferenceNo.referenceNo.text = XenosStringUtils.EMPTY_STR;
	    externalReferenceNo.text = XenosStringUtils.EMPTY_STR;
	    payemntCurrency.ccyText.text = XenosStringUtils.EMPTY_STR;
	    notionalAmountFrom.text = XenosStringUtils.EMPTY_STR;
	    notionalAmountTo.text = XenosStringUtils.EMPTY_STR;
	    
	    this.statusLabel.visible = true;
	    this.statusCombo.visible = true;
	    this.statusCombo.includeInLayout = true;
	    
	    /* Populating the Product Type */    
	    initcol = new ArrayCollection();
	    item = new Object();
	    initcol.addItem({label:"Select", value: " "});
	    if(mapObj[keylist.getItemAt(0)]!=null){
	        if(mapObj[keylist.getItemAt(0)] is ArrayCollection){
	            for each(item in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
	                initcol.addItem(item);
	            }
	        }else{
	            initcol.addItem(mapObj[keylist.getItemAt(0)]);
	        }
	    }
	    productType.dataProvider = initcol;        
	    /* End of populating the Product Type */
	    
	    /* Populating the Office Id */    
	    initcol = new ArrayCollection();
	    item = new Object();
	    initcol.addItem(" ");
	    if(mapObj[keylist.getItemAt(1)]!=null){
	        if(mapObj[keylist.getItemAt(1)] is ArrayCollection){
	            for each(item in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
	                initcol.addItem(item);
	            }
	        }else{
	            initcol.addItem(mapObj[keylist.getItemAt(1)]);
	        }
	    }
	    officeIdList.dataProvider = initcol;        
	    /* End of populating the Office Id */
	    
	    /* Populating the Notional Exchange Flag */    
	    initcol = new ArrayCollection();
	    item = new Object();
	    initcol.addItem({label:"Select", value: " "});
	    if(mapObj[keylist.getItemAt(2)]!=null){
	        if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
	            for each(item in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
	                initcol.addItem(item);
	            }
	        }else{
	            initcol.addItem(mapObj[keylist.getItemAt(2)]);
	        }
	    }
	    notionalExchangeFlag.dataProvider = initcol;    
	    /* End of populating the Notional Exchange Flag */
	    
	    /* Populating the Data Source */
	    initcol = new ArrayCollection();
	    item = new Object();
	    initcol.addItem({label:"Select", value: " "});
	    if(mapObj[keylist.getItemAt(3)]!=null){
	        if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
	            for each(item in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
	                initcol.addItem(item);
	            }
	        }else{
	            initcol.addItem(mapObj[keylist.getItemAt(3)]);
	        }
	    }
	    dataSource.dataProvider = initcol;    
	    /* End of populating the Data Source */
	    
	    /* Populating the Cancel Data Source */
	    initcol = new ArrayCollection();
	    item = new Object();
	    initcol.addItem({label:"Select", value: " "});
	    if(mapObj[keylist.getItemAt(4)]!=null){
	        if(mapObj[keylist.getItemAt(4)] is ArrayCollection){
	            for each(item in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
	                initcol.addItem(item);
	            }
	        }else{
	            initcol.addItem(mapObj[keylist.getItemAt(4)]);
	        }
	    }
	    cxlDataSource.dataProvider = initcol;    
	    /* End of populating the Cancel Data Source */
	    
	    /* Populating the Status */
	    initcol = new ArrayCollection();
	    item = new Object();
	    initcol.addItem({label:"Select", value: " "});
	    if(mapObj[keylist.getItemAt(5)]!=null){
	        if(mapObj[keylist.getItemAt(5)] is ArrayCollection){
	            for each(item in (mapObj[keylist.getItemAt(5)] as ArrayCollection)){
	                initcol.addItem(item);
	            }
	        }else{
	            initcol.addItem(mapObj[keylist.getItemAt(5)]);
	        }
	    }
	    statusCombo.dataProvider = initcol;  
	    
	    
	      
	    //statusCombo.selectedIndex = getIndexOfLabelValueBean(initcol , mapObj.status);
	    /* End of populating the Status */
	    
	    /* Populating the Delivery Receive Flag */
	    initcol = new ArrayCollection();
	    item = new Object();
	    initcol.addItem({label:"Select", value: " "});
	    if(mapObj[keylist.getItemAt(6)]!=null){
	        if(mapObj[keylist.getItemAt(6)] is ArrayCollection){
	            for each(item in (mapObj[keylist.getItemAt(6)] as ArrayCollection)){
	                initcol.addItem(item);
	            }
	        }else{
	            initcol.addItem(mapObj[keylist.getItemAt(6)]);
	        }
	    }
	    deliveryReceiveFlag.dataProvider = initcol;    
	    /* End of populating the Delivery Receive Flag */
	    
	    /* Populating the Interest Rate Type */
	    initcol = new ArrayCollection();
	    item = new Object();
	    initcol.addItem(" ");
	    if(mapObj[keylist.getItemAt(7)]!=null){
	        if(mapObj[keylist.getItemAt(7)] is ArrayCollection){
	            for each(item in (mapObj[keylist.getItemAt(7)] as ArrayCollection)){
	                initcol.addItem(item);
	            }
	        }else{
	            initcol.addItem(mapObj[keylist.getItemAt(7)]);
	        }
	    }
	    interestRateType.dataProvider = initcol;    
	    /* End of populating the Interest Rate Type */
	    
	    /* Populating the Fixed Floating Type */
	    initcol = new ArrayCollection();
	    item = new Object();
	    initcol.addItem({label:"Select", value: " "});
	    if(mapObj[keylist.getItemAt(8)]!=null){
	        if(mapObj[keylist.getItemAt(8)] is ArrayCollection){
	            for each(item in (mapObj[keylist.getItemAt(8)] as ArrayCollection)){
	                initcol.addItem(item);
	            }
	        }else{
	            initcol.addItem(mapObj[keylist.getItemAt(8)]);
	        }
	    }
	    fixedFloatingType.dataProvider = initcol;    
	    /* End of populating the Fixed Floating Type */
	    
	    /* Populating the Fixed Floating Type */
	    initcol = new ArrayCollection();
	    item = new Object();
	    initcol.addItem({label:"Select", value: " "});
	    if(mapObj[keylist.getItemAt(9)]!=null){
	        if(mapObj[keylist.getItemAt(9)] is ArrayCollection){
	            for each(item in (mapObj[keylist.getItemAt(9)] as ArrayCollection)){
	                initcol.addItem(item);
	            }
	        }else{
	            initcol.addItem(mapObj[keylist.getItemAt(9)]);
	        }
	    }
	    paymentFrequency.dataProvider = initcol;    
	    /* End of populating the Fixed Floating Type */
	                
	    //For SortField1
	    var sortField1Default:String = mapObj[keylist.getItemAt(13)].toString();
	    
	    //For SortField2
	    var sortField2Default:String = mapObj[keylist.getItemAt(14)].toString();
	    
	    //For SortField3
	    var sortField3Default:String = mapObj[keylist.getItemAt(15)].toString();    
	            
	    //----------Start of population of SortField1----------//            
	    if(null != mapObj[keylist.getItemAt(10)]){  
	        item = new Object();
	        initcol = new ArrayCollection();
	        tempColl = new ArrayCollection();
	        tempColl.addItem({label:" ", value: " "});
	        selIndx = 0;
	        if(mapObj[keylist.getItemAt(10)] is ArrayCollection){
	            for each(item in (mapObj[keylist.getItemAt(10)] as ArrayCollection)){
	                initcol.addItem(item);
	            }
	        }else {
	            initcol.addItem(mapObj[keylist.getItemAt(10)]);
	        }
	        for(i = 0; i<initcol.length; i++) {
	            //Get the default value object's index
	            if(XenosStringUtils.equals((initcol[i].value),sortField1Default)){                    
	                selIndx = i;
	            }
	           tempColl.addItem(initcol[i]);            
	        }
	        
	        sortFieldArray[0]=sortField1;
	        sortFieldDataSet[0]=tempColl;
	        //Set the default value object
	        sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
	        
	    } else {
	        XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.initialize.sortfield1'));
	    }
	    
	    //---------------End of population of SortField1-----------------------//
	    
	    //--------Start of population of sortField2---------//
	                
	    if(null != mapObj[keylist.getItemAt(11)]){
	        item = new Object();
	        initcol = new ArrayCollection();
	        tempColl = new ArrayCollection();
	        tempColl.addItem({label:" ", value: " "});
	        selIndx = 0;
	        
	        if(mapObj[keylist.getItemAt(11)] is ArrayCollection){
	            for each(item in (mapObj[keylist.getItemAt(11)] as ArrayCollection)){
	                initcol.addItem(item);
	            }
	        }else{
	            initcol.addItem(mapObj[keylist.getItemAt(11)]);
	        }
	        for(i = 0; i<initcol.length; i++) {
	            //Get the default value object's index
	            if(XenosStringUtils.equals((initcol[i].value),sortField2Default)){                    
	                selIndx = i;
	            }
	           tempColl.addItem(initcol[i]);            
	        }
	        
	        sortFieldArray[1]= sortField2;
	        sortFieldDataSet[1]= tempColl;
	        //Set the default value object
	        sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);
	        
	    } else {
	        XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.initialize.sortfield3'));
	    }
	    
	    //--------End of population of sortField2---------//
	    
	    //--------Start of population of sortField3---------//
	                
	    if(null != mapObj[keylist.getItemAt(12)]){
	        item = new Object();
	        initcol = new ArrayCollection();
	        tempColl = new ArrayCollection();
	        tempColl.addItem({label:" ", value: " "});
	        selIndx = 0;
	        
	        if(mapObj[keylist.getItemAt(12)] is ArrayCollection){
	            for each(item in (mapObj[keylist.getItemAt(12)] as ArrayCollection)){
	                initcol.addItem(item);
	            }
	        }else{
	            initcol.addItem(mapObj[keylist.getItemAt(12)]);
	        }
	        for(i = 0; i<initcol.length; i++) {
	            //Get the default value object's index
	            if(XenosStringUtils.equals((initcol[i].value),sortField3Default)){                    
	                selIndx = i;
	            }
	           tempColl.addItem(initcol[i]);            
	        }
	        
	        sortFieldArray[2]= sortField3;
	        sortFieldDataSet[2]= tempColl;
	        //Set the default value object
	        sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx+1);
	        
	    } else {
	        XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.initialize.sortfield3'));
	    }
	    
	    //--------End of population of sortField3---------//
	      
	    //-------------Initializing the sortfields-------------//
	    csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
	    csd.init();
	    
	    
	    initcol = new ArrayCollection();
	    item = new Object();
	    initcol.addItem({label:"Select", value: " "});
	    if(mapObj[keylist.getItemAt(16)]!=null){
	        if(mapObj[keylist.getItemAt(16)] is ArrayCollection){
	            for each(item in (mapObj[keylist.getItemAt(16)] as ArrayCollection)){
	                initcol.addItem(item);
	            }
	        }else{
	            initcol.addItem(mapObj[keylist.getItemAt(16)]);
	        }
	    }
	    terminationFlag.dataProvider = initcol;    
	}

	/**
	 * Calculates the index of a label value bean given its value, within a given 
	 * array collection of such beans.
	 * Returns 0 if the value is null or empty string.
	 */
	/* private function getIndexOfLabelValueBean(collection:ArrayCollection, value:String):int {
	    var index:int = 0;
	    if (value == null || value == XenosStringUtils.EMPTY_STR) {
	        return index;
	    }
	    for (var count:int = 0; count < collection.length; count++) {
	        var bean:Object = collection.getItemAt(count);
	        if (XenosStringUtils.equals(bean['value'] , value)) {
	            index = count;
	            break;
	        }
	    }
	    return index;
	} */

        
	/**
	 * Method for updating the other three sortfields after any change in the sortfield1
	 */  
	private function sortOrder1Update():void
	{
	    csd.update(sortField1.selectedItem,0);
	}
	
	/**
	 * Method for updating the other three sortfields after any change in the sortfield3
	 */ 
	private function sortOrder2Update():void
	{      
	    csd.update(sortField2.selectedItem,1);
	}

         
	override public function postQueryResultInit(mapObj:Object):void {
	    commonInit(mapObj);
	}

	override public function postAmendResultInit(mapObj:Object):void {
	    commonInit(mapObj);
	    
	    this.statusLabel.visible = false;
	    this.statusCombo.visible = false;
	    this.statusCombo.includeInLayout = false;
	    
	    this.terminationBlock.visible = false;
	    this.terminationBlock.includeInLayout = false;
	}

	override public function postCancelResultInit(mapObj:Object):void {
	    commonInit(mapObj);
	    
	    this.statusLabel.visible = false;
	    
	    this.statusCombo.visible = false;
	    this.statusCombo.includeInLayout = false;
	    
	    this.terminationBlock.visible = false;
	    this.terminationBlock.includeInLayout = false;
	    
	}

	private function setValidator() : void {	
	    var tradeQueryModel:Object = {
			                            swapTradeQuery	:	{                                                             
			                                tradeDateFrom			:	this.tradeDateFrom.text 		,
			                                tradeDateTo				:	this.tradeDateTo.text 			,
			                                maturityDateFrom		:	this.maturityDateFrom.text 		,
			                                maturityDateTo			:	this.maturityDateTo.text 		,
			                                terminationDateFrom		:	this.terminationDateFrom.text 	,
			                                terminationDateTo		:	this.terminationDateTo.text 	,
			                                notionalAmountFrom 		: 	this.notionalAmountFrom.text	,
			                                notionalAmountTo		:   this.notionalAmountTo.text
			                            }
		                            }; 
		                            
	    super._validator = new TradeQueryValidator();
	    super._validator.source = tradeQueryModel ;
	    super._validator.property = "swapTradeQuery";
	}
        
	override public function preQuery():void
	{      
	    setValidator();
	    qh.resetPageNo();
	    super.getSubmitQueryHttpService().url = "swp/swpTradeQueryDispatch.action";
	    super.getSubmitQueryHttpService().request = populateRequestParams();
	}

	/**
	 *   Applicable for both Amend and Special Amend 
	 */
	override public function preAmend():void
	{
	    setValidator();
	    qh.resetPageNo(); 
	    super.getSubmitQueryHttpService().url = terminationMode ?  "swp/swpTradeTerminationQueryDispatch.action" : "swp/swpTradeAmendQueryDispatch.action";
	    super.getSubmitQueryHttpService().request = populateRequestParams();   
	}
        
	override public function preCancel():void
	{
	    setValidator();
	    qh.resetPageNo();
	    super.getSubmitQueryHttpService().url = "swp/swpTradeCancelQueryDispatch.action";
	    super.getSubmitQueryHttpService().request = populateRequestParams();        
	}
        
	/**
	* This method will populate the request parameters for the
	* submitQuery call and bind the parameters with the HTTPService
	* object.
	*/
	private function populateRequestParams():Object {        
	    var reqObj : Object = new Object();
	    
	    if(this.mode == 'query') {
	     	reqObj.SCREEN_KEY = "11115";
	    } else if(this.mode == 'AMEND') {
	    	if (terminationMode) {
	    		reqObj.SCREEN_KEY = "11118";
	    	} else {
	    		reqObj.SCREEN_KEY = "11116";
	    	}
	    } else if(this.mode == 'DELETE') { 
	     	reqObj.SCREEN_KEY = "11117";
	    } 
	            
	    reqObj.method = "submitQuery";
	    reqObj.mode = this.mode ;
	    
	    reqObj.productType = (this.productType.selectedItem != null ? this.productType.selectedItem.value : "");
	    reqObj.officeId = (this.officeIdList.selectedItem != null ? this.officeIdList.selectedItem : "");
	    reqObj.fundCode =  this.fundPopUp.fundCode.text;
	    reqObj.inventoryAccountNoStr = this.inventoryAccountNo.accountNo.text;
	    reqObj.contractReferenceNo = this.contractReferenceNo.referenceNo.text;
	    reqObj.accountNoStr = this.accountNo.accountNo.text;
	    reqObj.externalReferenceNo = this.externalReferenceNo.text;
	    reqObj.notionalExchangeFlag = (this.notionalExchangeFlag.selectedItem != null ? this.notionalExchangeFlag.selectedItem.value : "");
	    
	    reqObj.tradeDateFromStr = this.tradeDateFrom.text;
	    reqObj.tradeDateToStr = this.tradeDateTo.text;
	    reqObj.maturityDateFromStr = this.maturityDateFrom.text;
	    reqObj.maturityDateToStr = this.maturityDateTo.text;
	    reqObj.terminationDateFromStr = this.terminationDateFrom.text;
	    reqObj.terminationDateToStr = this.terminationDateTo.text;
	    reqObj.dataSource = (this.dataSource.selectedItem != null ? this.dataSource.selectedItem.value : "");
	    reqObj.cxlDataSource = (this.cxlDataSource.selectedItem != null ? this.cxlDataSource.selectedItem.value : "");
	    
	    if (XenosStringUtils.equals(mode , "AMEND") || XenosStringUtils.equals(mode , "amend") 
	    	|| XenosStringUtils.equals(mode , "CANCEL")) {
	    	reqObj.status = "NORMAL";
	    	reqObj.terminationFlag = "N";
	    } else {
	    	reqObj.terminationFlag = (this.terminationFlag.selectedItem != null ? this.terminationFlag.selectedItem.value : "");
	    	reqObj.status = (this.statusCombo.selectedItem != null ? this.statusCombo.selectedItem.value : "");
	    }
	    
	    reqObj.deliveryReceiveFlag = (this.deliveryReceiveFlag.selectedItem != null ? this.deliveryReceiveFlag.selectedItem.value : "");
	    reqObj.notionalAmountFrom = this.notionalAmountFrom.text;
	    reqObj.notionalAmountTo = this.notionalAmountTo.text;
	    reqObj.interestRateType = (this.interestRateType.selectedItem != null ? this.interestRateType.selectedItem.value : "");
	    reqObj.fixedFloatingType = (this.fixedFloatingType.selectedItem != null ? this.fixedFloatingType.selectedItem.value : "");
	    reqObj.paymentCurrency = this.payemntCurrency.ccyText.text;
	    reqObj.paymentFrequency = (this.paymentFrequency.selectedItem != null ? this.paymentFrequency.selectedItem.value : "");
	
	    reqObj.sortField1 = this.sortField1.selectedItem != null ? this.sortField1.selectedItem.value : "";
	    reqObj.sortField2 = this.sortField2.selectedItem != null ? this.sortField2.selectedItem.value : "";
	    reqObj.sortField3 = this.sortField3.selectedItem != null ? this.sortField3.selectedItem.value : "";
	    
	    reqObj.rnd = Math.random() + "";
	    
	    return reqObj;
	}
    

	override public function postQueryResultHandler(mapObj:Object):void
	{
	    commonResult(mapObj);
	}
	    
	override public function postAmendResultHandler(mapObj:Object):void
	{
	    commonResult(mapObj);
	}
	    
	override public function postCancelResultHandler(mapObj:Object):void
	{
	    commonResult(mapObj);   
	}

   
        
private function commonResult(mapObj:Object):void
{      
    var result:String = "";
    if(mapObj!=null){   
        if(mapObj["errorFlag"].toString() == "error"){
            queryResult.removeAll();
            errPage.showError(mapObj["errorMsg"]);
        }else if(mapObj["errorFlag"].toString() == "noError"){
           errPage.clearError(super.getSubmitQueryResultEvent());
           queryResult.removeAll();
           queryResult=mapObj["row"];
           changeCurrentState();
           qh.setOnResultVisibility();
           qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
           qh.PopulateDefaultVisibleColumns();
           
           /*if(queryResult.length == 1 && this.mode == 'query'){
             displayDetailView(queryResult[0].tradePk);
           }*/
           
        }else{
            errPage.removeError();
            queryResult.removeAll();
            currentState = "";
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }           
    }
}
      
	override public function preResetQuery():void {
	    var rndNo:Number= Math.random();
	    super.getResetHttpService().url = "swp/swpTradeQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
	}
	        
	override public function preResetAmend():void {
	    var rndNo:Number= Math.random();    
	    super.getResetHttpService().url = terminationMode ? "swp/swpTradeTerminationQueryDispatch.action?method=initialExecute&rnd=" + rndNo 
	    												  : "swp/swpTradeAmendQueryDispatch.action?method=initialExecute&rnd=" + rndNo;               
	}
	        
	override public function preResetCancel():void {
	    var rndNo:Number= Math.random();
	    super.getResetHttpService().url = "swp/swpTradeCancelQueryDispatch.action?method=initialExecute&rnd=" + rndNo;                
	}
        
	override public function preGenerateXls() : String {
	    var url : String =null;
	    if(mode == "query"){                    
	      url = "swp/swpTradeQueryDispatch.action?method=generateXLS";
	    } else if(XenosStringUtils.equals(mode,"amend") || XenosStringUtils.equals(mode,"AMEND")){
	        url = terminationMode ?  "swp/swpTradeTerminationQueryDispatch.action?method=generateXLS"
	        					  : "swp/swpTradeAmendQueryDispatch.action?method=generateXLS";
	    } else if (XenosStringUtils.equals(mode , "CANCEL")) {
	        url = "swp/swpTradeCancelQueryDispatch.action?method=generateXLS";
	    } 
	    return url;
	}
   
	override public function preGeneratePdf() : String  {
	    var url : String =null;
	    if(XenosStringUtils.equals(mode,"query")){                    
	      url = "swp/swpTradeQueryDispatch.action?method=generatePDF";
	    } else if(XenosStringUtils.equals(mode,"amend") || XenosStringUtils.equals(mode,"AMEND")){
	        url = terminationMode ?  "swp/swpTradeTerminationQueryDispatch.action?method=generatePDF"
	        					  : "swp/swpTradeAmendQueryDispatch.action?method=generatePDF";
	    } else if (XenosStringUtils.equals(mode , "CANCEL")){
	        url = "swp/swpTradeCancelQueryDispatch.action?method=generatePDF";
	    } 
	    return url;
	}
            
	override public function preNext():Object
	{
	    var reqObj : Object = new Object();
	    reqObj.method = "doNext";
	    return reqObj;
	}
	         
	override public function prePrevious():Object
	{   
	    var reqObj : Object = new Object();
	    reqObj.method = "doPrevious";
	    return reqObj;
	}
          
	private function dispatchPrintEvent():void
	{
	      this.dispatchEvent(new Event("print"));
	}
	    
	private function dispatchPdfEvent():void
	{
	      this.dispatchEvent(new Event("pdf"));
	}
	  
	private function dispatchXlsEvent():void
	{
	      this.dispatchEvent(new Event("xls"));
	}
	  
	private function dispatchNextEvent():void
	{
	      this.dispatchEvent(new Event("next"));
	}
	  
	private function dispatchPrevEvent():void
	{
	      this.dispatchEvent(new Event("prev"));
	}
      

private function addColumn():void
{
    
    var dg :DataGridColumn = new DataGridColumn();
    dg.dataField="";
    dg.editable = false;
    dg.headerText = "";
    dg.width = 40;
    dg.itemRenderer = new RendererFectory(ImgSummaryRenderer);
    
    var cols :Array = resultSummary.columns;
    cols.unshift(dg);
    resultSummary.columns = cols;

}


/**
* This is the method to pass the Collection of data items
* through the context to the FinInst popup. This will be implemented as per specifdic  
* requirement. 
*/
private function populateFinInstRole():ArrayCollection
{
    //pass the context data to the popup
     var myContextList:ArrayCollection = new ArrayCollection(); 
     
     var bankRoleArray : Array = new Array(4);
     bankRoleArray[0] = "Security Broker";
     bankRoleArray[1] = "Bank/Custodian";
     bankRoleArray[2] = "Stock Exchange";
     bankRoleArray[3] = "Central Depository";
     myContextList.addItem(new HiddenObject("bankRoles",bankRoleArray));
     
     return myContextList;
}

    
/**
  * This is the method to pass the Collection of data items
  * through the context to the account popup. This will be implemented as per specifdic  
  * requriment. 
  */
private function populateInvActContext():ArrayCollection
{
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
  * This is the method to pass the Collection of data items
  * through the context to the account popup. This will be implemented as per specifdic  
  * requriment. 
  */
private function populateActContext():ArrayCollection
{

    //pass the context data to the popup
    var myContextList:ArrayCollection = new ArrayCollection(); 
 
    //passing act type                
    var actTypeArray:Array = new Array(1);
        actTypeArray[0]="T|B";
    myContextList.addItem(new HiddenObject("actTypeContext",actTypeArray));    
              
    var cpTypeArray:Array = new Array(1);
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
private function populateBrokerActContext():ArrayCollection
{

    //pass the context data to the popup
    var myContextList:ArrayCollection = new ArrayCollection(); 
 
    //passing act type                
    var actTypeArray:Array = new Array(1);
        actTypeArray[0]="T|B";
    myContextList.addItem(new HiddenObject("actTypeContext",actTypeArray));    
              
    var cpTypeArray:Array = new Array(1);
        cpTypeArray[0]="BROKER|BANK/CUSTODIAN";
    myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));

    //passing account status                
    var actStatusArray:Array = new Array(1);
    actStatusArray[0]="OPEN";
    myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));

    return myContextList;
    
}

/**
  * This is the method to pass the Collection of data items
  * through the context to the contract reference number popup. 
  * This will be implemented as per specific requriment. 
  */
private function populateContractRefNoContext():ArrayCollection
{
    //pass the context data to the popup
    var myContextList:ArrayCollection = new ArrayCollection();
    
    //passing status
    if(!XenosStringUtils.equals(this.mode,'query')){
    	var statusArray:Array = new Array(1);
	    statusArray[0]="NORMAL";
	    myContextList.addItem(new HiddenObject("Status",statusArray));
    }
    return myContextList;    
}