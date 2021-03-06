
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
import com.nri.rui.swp.validator.CashflowQueryValidator;


import mx.collections.ArrayCollection;
import mx.controls.TextInput;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.ValidationResultEvent;

[Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
[Bindable]private var queryResult:ArrayCollection= new ArrayCollection();
[Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
[Bindable]private var mode : String = "QUERY";
[Bindable]private var finInst:FinInstitutePopUpHbox = new FinInstitutePopUpHbox();
[Bindable]private var strategyPopup:StrategyPopUpHBox = new StrategyPopUpHBox();
[Bindable]private var customerPopup:CustomerPopUpHbox = new CustomerPopUpHbox();
[Bindable]private var counterPartyTxtInput:TextInput = new TextInput();
[Bindable]private var initcol:ArrayCollection = new ArrayCollection();
[Bindable]private var tempColl: ArrayCollection = new ArrayCollection();

private var keylist:ArrayCollection = new ArrayCollection(); 
private var csd:CustomizeSortOrder = null;
private var sortFieldArray:Array =new Array();
private var sortFieldDataSet:Array =new Array();
private var sortFieldSelectedItem:Array =new Array();
private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
private var selIndx:int = 0;
private var i:int = 0;
private var item:Object = new Object();

          
public function loadAll():void
{
   parseUrlString();
   super.setXenosQueryControl(new XenosQuery());
   if(this.mode == 'QUERY'){
     this.dispatchEvent(new Event('queryInit'));
     this.cashflowType.setFocus();
   } else if(this.mode == 'AMEND'){
     this.dispatchEvent(new Event('amendInit'));
     this.cashflowAmountFrom.setFocus();
     addColumn();
   } else if(this.mode == 'CANCEL'){ 
     this.dispatchEvent(new Event('cancelInit'));
     this.cashflowAmountFrom.setFocus();
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
            }                       
        }else{
            mode = "QUERY";
        }                 
    } catch (e:Error) {
        trace(e);
    }               
}
        
override public function preQueryInit():void
{      
    var rndNo:Number= Math.random(); 
    super.getInitHttpService().url = "swp/cashflowQueryDispatch.action?method=initialExecute&mode=query&rnd=" + rndNo;
    var req : Object = new Object();
    req.SCREEN_KEY = "12040";
    super.getInitHttpService().request = req;
}
        
override public function preAmendInit():void
{
	/*
    var rndNo:Number= Math.random();
    super.getInitHttpService().url = "swp/cashflowAmendQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
    var req : Object = new Object();
    req.SCREEN_KEY = "11115";
    super.getInitHttpService().request = req;
    */
}
        
override public function preCancelInit():void
{
	/*
    var rndNo:Number= Math.random();
    super.getInitHttpService().url = "swp/cashflowCancelQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
    var req : Object = new Object();
    req.SCREEN_KEY = "11115";
    super.getInitHttpService().request = req;
    */                 
}
        
private function addCommonKeys():void
{  
    keylist = new ArrayCollection();        
    
    keylist.addItem("fixedFloatingTypeList.item");
    keylist.addItem("statusList.item");

    keylist.addItem("productType.item");
    keylist.addItem("officeList.officeList");
    keylist.addItem("tradeStatusList.item");
    keylist.addItem("deliveryReceiveFlagList.item");
    keylist.addItem("paymentFrequencyList.item"); 
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
    
    cashflowAmountFrom.text = XenosStringUtils.EMPTY_STR;
    cashflowAmountTo.text = XenosStringUtils.EMPTY_STR;
    fundPopUp.fundCode.text = XenosStringUtils.EMPTY_STR;
    fundAccountNo.accountNo.text = XenosStringUtils.EMPTY_STR;
    resetDateFrom.text = XenosStringUtils.EMPTY_STR;
    resetDateTo.text = XenosStringUtils.EMPTY_STR;
    valueDateFrom.text = XenosStringUtils.EMPTY_STR;
    valueDateTo.text = XenosStringUtils.EMPTY_STR;
    accrualStartDateFrom.text = XenosStringUtils.EMPTY_STR;
    accrualStartDateTo.text = XenosStringUtils.EMPTY_STR;
    accrualEndDateFrom.text = XenosStringUtils.EMPTY_STR;
    accrualEndDateTo.text = XenosStringUtils.EMPTY_STR;
    contractReferenceNo.referenceNo.text = XenosStringUtils.EMPTY_STR;
    
    accountNo.accountNo.text = XenosStringUtils.EMPTY_STR;
    externalReferenceNo.text = XenosStringUtils.EMPTY_STR;
    tradeDateFrom.text = XenosStringUtils.EMPTY_STR;
    tradeDateTo.text = XenosStringUtils.EMPTY_STR;
    maturityDateFrom.text = XenosStringUtils.EMPTY_STR;
    maturityDateTo.text = XenosStringUtils.EMPTY_STR;
    terminationDateFrom.text = XenosStringUtils.EMPTY_STR;
    terminationDateTo.text = XenosStringUtils.EMPTY_STR;
    
    notionalAmountFrom.text = XenosStringUtils.EMPTY_STR;
    notionalAmountTo.text = XenosStringUtils.EMPTY_STR; 
    paymentCurrency.ccyText.text = XenosStringUtils.EMPTY_STR;
    
    var i:int = 0;   

    /* Populating the Cashflow Type */
    initcol = new ArrayCollection();
    item = new Object();
    initcol.addItem({label:"Select", value: " "});
    if(mapObj[keylist.getItemAt(i)]!=null){
        if(mapObj[keylist.getItemAt(i)] is ArrayCollection){
            for each(item in (mapObj[keylist.getItemAt(i)] as ArrayCollection)){
                initcol.addItem(item);
            }
        }else{
            initcol.addItem(mapObj[keylist.getItemAt(i)]);
        }
    }
    cashflowType.dataProvider = initcol;
   /* End of populating the Cashflow Type */
   
    i = i + 1;

    /* Populating the Status */
    initcol = new ArrayCollection();
    item = new Object();
    initcol.addItem({label:"Select", value: " "});
    if(mapObj[keylist.getItemAt(i)]!=null){
        if(mapObj[keylist.getItemAt(i)] is ArrayCollection){
            for each(item in (mapObj[keylist.getItemAt(i)] as ArrayCollection)){
                initcol.addItem(item);
            }
        }else{
            initcol.addItem(mapObj[keylist.getItemAt(i)]);
        }
    }
    statusCombo.dataProvider = initcol;
   /* End of populating the Status */
   
   i = i + 1;

   /* Populating the Product Type */    
    initcol = new ArrayCollection();
    item = new Object();
    initcol.addItem({label:"Select", value: " "});
    if(mapObj[keylist.getItemAt(i)]!=null){
        if(mapObj[keylist.getItemAt(i)] is ArrayCollection){
            for each(item in (mapObj[keylist.getItemAt(i)] as ArrayCollection)){
                initcol.addItem(item);
            }
        }else{
            initcol.addItem(mapObj[keylist.getItemAt(i)]);
        }
    }
    productType.dataProvider = initcol;        
    /* End of populating the Product Type */

    i = i+1;
    
    /* Populating the Office Id */    
    initcol = new ArrayCollection();
    item = new Object();
    initcol.addItem(" ");
    if(mapObj[keylist.getItemAt(i)]!=null){
        if(mapObj[keylist.getItemAt(i)] is ArrayCollection){
            for each(item in (mapObj[keylist.getItemAt(i)] as ArrayCollection)){
                initcol.addItem(item);
            }
        }else{
            initcol.addItem(mapObj[keylist.getItemAt(i)]);
        }
    }
    officeIdList.dataProvider = initcol;        
    /* End of populating the Office Id */
    
    i = i  +1;

    /* Populating the Status */
    initcol = new ArrayCollection();
    item = new Object();
    initcol.addItem({label:"Select", value: " "});
    if(mapObj[keylist.getItemAt(i)]!=null){
        if(mapObj[keylist.getItemAt(i)] is ArrayCollection){
            for each(item in (mapObj[keylist.getItemAt(i)] as ArrayCollection)){
                initcol.addItem(item);
            }
        }else{
            initcol.addItem(mapObj[keylist.getItemAt(i)]);
        }
    }
    tradeStatusCombo.dataProvider = initcol;    
    /* End of populating the Status */
    
    i = i + 1;

    /* Populating the Delivery Receive Flag */
    initcol = new ArrayCollection();
    item = new Object();
    initcol.addItem({label:"Select", value: " "});
    if(mapObj[keylist.getItemAt(i)]!=null){
        if(mapObj[keylist.getItemAt(i)] is ArrayCollection){
            for each(item in (mapObj[keylist.getItemAt(i)] as ArrayCollection)){
                initcol.addItem(item);
            }
        }else{
            initcol.addItem(mapObj[keylist.getItemAt(i)]);
        }
    }
    deliveryReceiveFlag.dataProvider = initcol;    
    /* End of populating the Delivery Receive Flag */

    i = i + 1;

    /* Populating the Payment Frequency */
    initcol = new ArrayCollection();
    item = new Object();
    initcol.addItem({label:"Select", value: " "});
    if(mapObj[keylist.getItemAt(i)]!=null){
        if(mapObj[keylist.getItemAt(i)] is ArrayCollection){
            for each(item in (mapObj[keylist.getItemAt(i)] as ArrayCollection)){
                initcol.addItem(item);
            }
        }else{
            initcol.addItem(mapObj[keylist.getItemAt(i)]);
        }
    }
    paymentFrequency.dataProvider = initcol;    
    /* End of populating the Payment Frequency */

    i = i + 1;
       
}
        
/**
 * Method for updating the other three sortfields after any change in the sortfield1
 */ 
private function sortOrder1Update():void
{
    //csd.update(sortField1.selectedItem,0);
}

/**
 * Method for updating the other three sortfields after any change in the sortfield3
 */
private function sortOrder2Update():void
{      
    //csd.update(sortField2.selectedItem,1);
}
         
override public function postQueryResultInit(mapObj:Object):void
{
    commonInit(mapObj);
}

override public function postAmendResultInit(mapObj:Object):void
{
    commonInit(mapObj);
    
    this.statusLabel.visible = false;
    this.statusCombo.visible = false;
    this.statusCombo.includeInLayout = false;
    this.statusTxt.visible = false;
    this.statusTxt.includeInLayout = true;
    this.statusTxt.text = "NORMAL";
    
}

override public function postCancelResultInit(mapObj:Object):void
{
    commonInit(mapObj);
    
    this.statusLabel.visible = false;
    this.statusCombo.visible = false;
    this.statusCombo.includeInLayout = false;
    this.statusTxt.visible = false;
    this.statusTxt.includeInLayout = true;
    this.statusTxt.text = "NORMAL";
         
}
        
private function setValidator():void
{
    var cashflowQueryModel:Object = {
                            cashflowQuery:{
                                resetDateFrom:this.resetDateFrom.text,
                                resetDateTo:this.resetDateTo.text, 
                                valueDateFrom:this.valueDateFrom.text,
                                valueDateTo:this.valueDateTo.text, 
                                accrualStartDateFrom:this.accrualStartDateFrom.text,
                                accrualStartDateTo:this.accrualStartDateTo.text,
                                accrualEndDateFrom:this.accrualEndDateFrom.text,
                                accrualEndDateTo:this.accrualEndDateTo.text,
                                tradeDateFrom:this.tradeDateFrom.text,
                                tradeDateTo:this.tradeDateTo.text,       
                                maturityDateFrom:this.maturityDateFrom.text,
                                maturityDateTo:this.maturityDateTo.text,
                                terminationDateFrom:this.terminationDateFrom.text,
                                terminationDateTo:this.terminationDateTo.text 
                            }
                           }; 
    super._validator = new CashflowQueryValidator();
    super._validator.source = cashflowQueryModel ;
    super._validator.property = "cashflowQuery";
}
        
override public function preQuery():void
{      
    setValidator();
    qh.resetPageNo();
    super.getSubmitQueryHttpService().url = "swp/cashflowQueryDispatch.action";
    super.getSubmitQueryHttpService().request = populateRequestParams();
}

/**
 *   Applicable for both Amend and Special Amend 
 */
override public function preAmend():void
{
    setValidator();
    qh.resetPageNo(); 
    super.getSubmitQueryHttpService().url = "swp/cashflowAmendQueryDispatch.action";
    super.getSubmitQueryHttpService().request = populateRequestParams(); 
}
        
override public function preCancel():void
{
    setValidator();
    qh.resetPageNo();
    super.getSubmitQueryHttpService().url = "swp/cashflowCancelQueryDispatch.action";
    super.getSubmitQueryHttpService().request = populateRequestParams();       
}
        
/**
* This method will populate the request parameters for the
* submitQuery call and bind the parameters with the HTTPService
* object.
*/
private function populateRequestParams():Object
{        
    var reqObj : Object = new Object();
    
    if(this.mode == 'QUERY')
    {
     reqObj.SCREEN_KEY = "12041";
    }
            
            
    reqObj.method = "submitQuery";
    reqObj.modeOfOperation = this.mode ;
    
    reqObj.cashflowType = this.cashflowType.selectedItem.value;
    reqObj.cashflowAmountFrom = this.cashflowAmountFrom.text;
    reqObj.cashflowAmountTo = this.cashflowAmountTo.text;
    reqObj.fundCode = this.fundPopUp.fundCode.text;
    reqObj.inventoryAccountNo = this.fundAccountNo.accountNo.text;
    reqObj.resetDateFromStr = this.resetDateFrom.text;
    reqObj.resetDateToStr = this.resetDateTo.text;
    reqObj.valueDateFromStr = this.valueDateFrom.text;
    reqObj.valueDateToStr = this.valueDateTo.text;
    reqObj.accrualStartDateFromStr = this.accrualStartDateFrom.text;
    reqObj.accrualStartDateToStr = this.accrualStartDateTo.text;
    reqObj.accrualEndDateFromStr = this.accrualEndDateFrom.text;
    reqObj.accrualEndDateToStr = this.accrualEndDateTo.text;
    reqObj.status = this.statusCombo.selectedItem.value;
    reqObj.contractReferenceNo = this.contractReferenceNo.referenceNo.text;

    
    reqObj.productType = (this.productType.selectedItem != null ? this.productType.selectedItem.value : "");
    reqObj.officeId = (this.officeIdList.selectedItem != null ? this.officeIdList.selectedItem : "");
    reqObj.accountNoStr = this.accountNo.accountNo.text;
    reqObj.externalReferenceNo = this.externalReferenceNo.text;    
    reqObj.tradeDateFromStr = this.tradeDateFrom.text;
    reqObj.tradeDateToStr = this.tradeDateTo.text;
    reqObj.maturityDateFromStr = this.maturityDateFrom.text;
    reqObj.maturityDateToStr = this.maturityDateTo.text;
    reqObj.terminationDateFromStr = this.terminationDateFrom.text;
    reqObj.terminationDateToStr = this.terminationDateTo.text;    
    reqObj.tradeStatus = (this.tradeStatusCombo.selectedItem != null ? this.tradeStatusCombo.selectedItem.value : "");

    reqObj.deliveryReceiveFlag = (this.deliveryReceiveFlag.selectedItem != null ? this.deliveryReceiveFlag.selectedItem.value : "");
    reqObj.notionalAmountFrom = this.notionalAmountFrom.text;
    reqObj.notionalAmountTo = this.notionalAmountTo.text;    
    reqObj.paymentCurrency = this.paymentCurrency.ccyText.text;
    reqObj.paymentFrequency = (this.paymentFrequency.selectedItem != null ? this.paymentFrequency.selectedItem.value : "");
    
    reqObj.rnd = Math.random();
    
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
      
override public function preResetQuery():void
{
    var rndNo:Number= Math.random();
    super.getResetHttpService().url = "swp/cashflowQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
}
        
override public function preResetAmend():void
{
    var rndNo:Number= Math.random();    
    super.getResetHttpService().url = "swp/cashflowAmendQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
}
        
override public function preResetCancel():void
{
    var rndNo:Number= Math.random(); 
    super.getResetHttpService().url = "swp/cashflowCancelQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
}
        
override public function preGenerateXls():String
{
    var url : String =null;
    if(mode == "QUERY"){                    
      url = "swp/cashflowQueryDispatch.action?method=generateXLS";
    }else if(mode == "AMEND"){
        url = "swp/cashflowAmendQueryDispatch.action?method=generateXLS";
    }else{
        url = "swp/cashflowCancelQueryDispatch.action?method=generateXLS";
    }
    return url;
}
   
override public function preGeneratePdf():String
{
    var url : String =null;
    if(mode == "QUERY"){                    
      url = "swp/cashflowQueryDispatch.action?method=generatePDF";
    }else if(mode == "AMEND"){
        url = "swp/cashflowAmendQueryDispatch.action?method=generatePDF";
    }else{
        url = "swp/cashflowCancelQueryDispatch.action?method=generatePDF";
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
 * Method to Format and validate numbers(B,M,T)
 */
private function numberHandler(numVal:XenosNumberValidator):void
{
	//The source textinput control
	var source:Object=numVal.source; 
	    
	var vResult:ValidationResultEvent;
	var tmpStr:String = source.text; 
	vResult = numVal.validate();
	
	if (vResult.type == ValidationResultEvent.VALID) {
	   source.text=numberFormatter.format(source.text);            
	}else{
	   source.text = tmpStr;           
	}
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
    var statusArray:Array = new Array(1);
    statusArray[0]="NORMAL";
    myContextList.addItem(new HiddenObject("Status",statusArray));
    
    //passing fund code                
    /* var fundCodeArray:Array = new Array(1);
    fundCodeArray[0]="APXJAP";
    myContextList.addItem(new HiddenObject("FundCode",fundCodeArray)); */

    return myContextList;    
}