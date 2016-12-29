
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
import com.nri.rui.swp.validator.UnrealizedPlQueryValidator;

import mx.collections.ArrayCollection;
import mx.controls.TextInput;
import mx.controls.dataGridClasses.DataGridColumn;
 
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
   } else if(this.mode == 'AMEND'){
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
    super.getInitHttpService().url = "swp/unrealizedplQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
    var req : Object = new Object();
    req.SCREEN_KEY = "11115";
    super.getInitHttpService().request = req;
}
        
override public function preAmendInit():void
{
    var rndNo:Number= Math.random();
    super.getInitHttpService().url = "swp/unrealizedplAmendQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
    var req : Object = new Object();
    req.SCREEN_KEY = "11115";
    super.getInitHttpService().request = req;
}
        
override public function preCancelInit():void
{
    var rndNo:Number= Math.random();
    super.getInitHttpService().url = "swp/unrealizedplCancelQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
    var req : Object = new Object();
    req.SCREEN_KEY = "11115";
    super.getInitHttpService().request = req;                
}
        
private function addCommonKeys():void
{  
    keylist = new ArrayCollection();        
    
    keylist.addItem("mktValueNotFoundList.item");

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
    
    baseDateFrom.text = XenosStringUtils.EMPTY_STR;
    baseDateTo.text = XenosStringUtils.EMPTY_STR;
    currency.ccyText.text = XenosStringUtils.EMPTY_STR;
    fundPopUp.fundCode.text = XenosStringUtils.EMPTY_STR;
    inventoryAccountNo.accountNo.text = XenosStringUtils.EMPTY_STR;
    referenceNo.text = XenosStringUtils.EMPTY_STR;
    contractReferenceNo.referenceNo.text = XenosStringUtils.EMPTY_STR;
            
    /* Populating the Market Value */ 
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
    marketValueNotFound.dataProvider = initcol;
    /* End of populating the Market Value */

    tradeDateFrom.text = XenosStringUtils.EMPTY_STR;
    tradeDateTo.text = XenosStringUtils.EMPTY_STR;
    maturityDateFrom.text = XenosStringUtils.EMPTY_STR;
    maturityDateTo.text = XenosStringUtils.EMPTY_STR;
    terminationDateFrom.text = XenosStringUtils.EMPTY_STR;
    terminationDateTo.text = XenosStringUtils.EMPTY_STR;
    this.accountNo.accountNo.text = XenosStringUtils.EMPTY_STR;
    this.externalReferenceNo.text = XenosStringUtils.EMPTY_STR;
    //this.notionalAmountFrom.text = XenosStringUtils.EMPTY_STR;
    //this.notionalAmountTo.text = XenosStringUtils.EMPTY_STR;
    //this.payemntCurrency.ccyText.text = XenosStringUtils.EMPTY_STR;


    /* Populating the Product Type */    
    initcol = new ArrayCollection();
    item = new Object();
    initcol.addItem({label:"Select", value: " "});
    if(mapObj[keylist.getItemAt(1)]!=null){
        if(mapObj[keylist.getItemAt(1)] is ArrayCollection){
            for each(item in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
                initcol.addItem(item);
            }
        }else{
            initcol.addItem(mapObj[keylist.getItemAt(1)]);
        }
    }
    productType.dataProvider = initcol;        
    /* End of populating the Product Type */
    
    /* Populating the Office Id */    
    initcol = new ArrayCollection();
    item = new Object();
    initcol.addItem(" ");
    if(mapObj[keylist.getItemAt(2)]!=null){
        if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
            for each(item in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
                initcol.addItem(item);
            }
        }else{
            initcol.addItem(mapObj[keylist.getItemAt(2)]);
        }
    }
    officeIdList.dataProvider = initcol;        
    /* End of populating the Office Id */

    /* Populating the Status */
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
    tradeStatusCombo.dataProvider = initcol;    
    /* End of populating the Status */
    /* Populating the Delivery Receive Flag */
    /* initcol = new ArrayCollection();
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
    deliveryReceiveFlag.dataProvider = initcol; */    
    /* End of populating the Delivery Receive Flag */

    /* Populating the Payment Frequency */
    /* initcol = new ArrayCollection();
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
    paymentFrequency.dataProvider = initcol; */    
    /* End of populating the Payment Frequency */
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
}

override public function postCancelResultInit(mapObj:Object):void
{
     commonInit(mapObj);
}
        
private function setValidator():void
{
    var unrealizedPlQueryModel:Object={
                        unrealizedPlQuery:{                                 
							baseDateFrom:this.baseDateFrom.text,
							baseDateTo:this.baseDateTo.text,
							tradeDateFrom:this.tradeDateFrom.text,
							tradeDateTo:this.tradeDateTo.text,       
							maturityDateFrom:this.maturityDateFrom.text,
							maturityDateTo:this.maturityDateTo.text,
							terminationDateFrom:this.terminationDateFrom.text,
							terminationDateTo:this.terminationDateTo.text
                        }
                       }; 
    super._validator = new UnrealizedPlQueryValidator();
    super._validator.source = unrealizedPlQueryModel ;
    super._validator.property = "unrealizedPlQuery";
}
        
override public function preQuery():void
{      
    setValidator();
    qh.resetPageNo();
    super.getSubmitQueryHttpService().url = "swp/unrealizedplQueryDispatch.action";
    super.getSubmitQueryHttpService().request = populateRequestParams();
}

/**
 *   Applicable for both Amend and Special Amend 
 */
override public function preAmend():void
{
    setValidator();
    qh.resetPageNo(); 
    super.getSubmitQueryHttpService().url = "swp/unrealizedplAmendQueryDispatch.action";
    super.getSubmitQueryHttpService().request = populateRequestParams();  
}
        
override public function preCancel():void
{
    setValidator();
    qh.resetPageNo(); 
    super.getSubmitQueryHttpService().url = "swp/unrealizedplCancelQueryDispatch.action";
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
     reqObj.SCREEN_KEY = "12048";
    }       
            
    reqObj.method = "submitQuery";
    reqObj.modeOfOperation = this.mode ;
    
    
    reqObj.baseDateFromStr = this.baseDateFrom.text;
    reqObj.baseDateToStr = this.baseDateTo.text;
    reqObj.currency = this.currency.ccyText.text ;
    reqObj.fundCode = this.fundPopUp.fundCode.text ;
    reqObj.inventoryAccountNo = this.inventoryAccountNo.accountNo.text ;
    reqObj.referenceNo = this.referenceNo.text ;
    reqObj.contractReferenceNo = this.contractReferenceNo.referenceNo.text;
    reqObj.mktValueNotFound = this.marketValueNotFound.selectedItem.value ;
    
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
    //reqObj.deliveryReceiveFlag = (this.deliveryReceiveFlag.selectedItem != null ? this.deliveryReceiveFlag.selectedItem.value : "");
    //reqObj.notionalAmountFrom = this.notionalAmountFrom.text;
    //reqObj.notionalAmountTo = this.notionalAmountTo.text;
    //reqObj.paymentCurrency = this.payemntCurrency.ccyText.text;
    //reqObj.paymentFrequency = (this.paymentFrequency.selectedItem != null ? this.paymentFrequency.selectedItem.value : "");

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
      
override public function preResetQuery():void
{
    var rndNo:Number= Math.random();
    super.getResetHttpService().url = "swp/unrealizedplQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
}
        
override public function preResetAmend():void
{
    var rndNo:Number= Math.random();    
    super.getResetHttpService().url = "swp/unrealizedplAmendQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
}
        
override public function preResetCancel():void
{
    var rndNo:Number= Math.random();    
    super.getResetHttpService().url = "swp/unrealizedplCancelQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
}
        
override public function preGenerateXls():String
{
    var url : String =null;
    if(mode == "QUERY"){                    
      url = "swp/unrealizedplQueryDispatch.action?method=generateXLS";
    }else if(mode == "AMEND"){
        url = "swp/unrealizedplAmendQueryDispatch.action?method=generateXLS";
    }else{
        url = "swp/unrealizedplCancelQueryDispatch.action?method=generateXLS";
    }
    return url;
}
   
override public function preGeneratePdf():String
{
    var url : String =null;
    if(mode == "QUERY"){                    
      url = "swp/unrealizedplQueryDispatch.action?method=generatePDF";
    }else if(mode == "amendment"){
        url = "swp/unrealizedplAmendQueryDispatch.action?method=generatePDF";
    }else{
        url = "swp/unrealizedplCancelQueryDispatch.action?method=generatePDF";
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
    var statusArray:Array = new Array(1);
    statusArray[0]="NORMAL";
    myContextList.addItem(new HiddenObject("Status",statusArray));
    
    //passing fund code                
    /* var fundCodeArray:Array = new Array(1);
    fundCodeArray[0]="APXJAP";
    myContextList.addItem(new HiddenObject("FundCode",fundCodeArray)); */

    return myContextList;    
}