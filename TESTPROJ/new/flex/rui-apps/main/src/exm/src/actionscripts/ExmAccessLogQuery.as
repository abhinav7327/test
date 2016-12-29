

import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;

import mx.collections.ArrayCollection;
            
     
[Bindable]
private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
[Bindable]
private var queryResult:ArrayCollection= new ArrayCollection();

private var keylist:ArrayCollection = new ArrayCollection(); 
 
[Bindable]private var mode : String = "QUERY";

[Bindable]
private var actionTakenList:ArrayCollection=null;
[Bindable]
private var senderEnterpriseIdList:ArrayCollection=null;
[Bindable]
private var errorEnterpriseIdList:ArrayCollection=null;
[Bindable]
private var recipientEnterpriseIdList:ArrayCollection=null;
[Bindable]
private var errorSystemIdList:ArrayCollection=null;
[Bindable]
private var messageTypeList:ArrayCollection=null;
[Bindable]
private var transactionTypeList:ArrayCollection=null;
     
      
private function changeCurrentState():void{
    currentState = "result";
}
     
public function loadAll():void{
    parseUrlString();
    super.setXenosQueryControl(new XenosQuery());                  
    if(this.mode == 'QUERY'){
         this.dispatchEvent(new Event('queryInit'));
    }
    app.submitButtonInstance = submit;    
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
        //XenosAlert.info("Load Url : "+ this.loaderInfo.url.toString());
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
                if (tempA[0] == "mode") {
                    //XenosAlert.info("movArray param = " + tempA[1]);
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
override public function preQueryInit():void{  
        var rnd:Number=Math.random();
          super.getInitHttpService().url = "exm/accessLogQueryDispatch.action?method=initialExecute&modeOfOperation=VIEW&rnd="+rnd;            
}      

private function addCommonKeys():void{  
    keylist = new ArrayCollection();          
    keylist.addItem("actionTakenList.item");         
    keylist.addItem("senderEnterpriseIdList.item");         
    keylist.addItem("errorEnterpriseIdList.item");         
    keylist.addItem("recipientEnterpriseIdList.item");           
    keylist.addItem("errorSystemIdList.errorSystemId");         
    keylist.addItem("messageTypeList.item");         
    keylist.addItem("transactionTypeList.item");
    keylist.addItem("appRegiDateFrom");      
}

override public function preQueryResultInit():Object{            
    addCommonKeys();
    return keylist;            
}


private function commonInit(mapObj:Object):void{
    
    this.actPopUp.accountNo.text="";
    this.userPopUp.employeeText.text="";
    this.instrumentPopUp.instrumentId.text="";
    this.transactionNumber.text="";
    this.dataSource.text="";
    this.senderSystemId.text="";
    this.errorCode.text="";
    this.creationDateFrom.text="";
    this.creationDateTo.text="";
    this.appRegiDateTo.text="";
    actPopUp.accountNo.setFocus();
    
    actionTakenList=new ArrayCollection();
    actionTakenList.addItem({label: " " , value : " "});
    for each(var objActionTaken:Object in mapObj["actionTakenList.item"] as ArrayCollection){
        actionTakenList.addItem(objActionTaken);
    }
    senderEnterpriseIdList=new ArrayCollection();
    senderEnterpriseIdList.addItem({label: " " , value : " "});
    for each(var objSenderEnterpriseId:Object in mapObj["senderEnterpriseIdList.item"] as ArrayCollection){
           senderEnterpriseIdList.addItem(objSenderEnterpriseId);
    }
    errorEnterpriseIdList=new ArrayCollection();
    errorEnterpriseIdList.addItem({label: " " , value : " "});
    for each(var objErrorEnterpriseId:Object in mapObj["errorEnterpriseIdList.item"] as ArrayCollection){
            errorEnterpriseIdList.addItem(objErrorEnterpriseId);
    }
    recipientEnterpriseIdList=new ArrayCollection();
    recipientEnterpriseIdList.addItem({label: " " , value : " "});
    for each(var objRecipientEnterpriseId:Object in mapObj["recipientEnterpriseIdList.item"] as ArrayCollection){
        recipientEnterpriseIdList.addItem(objRecipientEnterpriseId);
    }
    errorSystemIdList=new ArrayCollection();
    errorSystemIdList.addItem({label: " " , value : " "});
    for each(var objErrorSystemId:String in mapObj["errorSystemIdList.errorSystemId"] as ArrayCollection){
            errorSystemIdList.addItem({label:objErrorSystemId,value:objErrorSystemId});
    }
    messageTypeList=new ArrayCollection();
    messageTypeList.addItem({label: " " , value : " "});
    for each(var objMessageTypeList:Object in mapObj["messageTypeList.item"] as ArrayCollection){
        messageTypeList.addItem(objMessageTypeList);
    }
    transactionTypeList=new ArrayCollection();
    transactionTypeList.addItem({label: " " , value : " "});
    for each(var objTransactionTypeList:Object in mapObj["transactionTypeList.item"] as ArrayCollection){
        transactionTypeList.addItem(objTransactionTypeList);
    }
                    
    appRegiDateFrom.text = mapObj["appRegiDateFrom"].toString();
    
    actionTakenList.refresh();
    senderEnterpriseIdList.refresh();
    errorEnterpriseIdList.refresh();
    recipientEnterpriseIdList.refresh();
    errorSystemIdList.refresh();
    messageTypeList.refresh();
    transactionTypeList.refresh();
    
    app.submitButtonInstance = submit;    
           
    errPage.clearError(super.getInitResultEvent());
}

override public function postQueryResultInit(mapObj:Object):void{
    commonInit(mapObj);
}


override public function preQuery():void{
    qh.resetPageNo();               
    super.getSubmitQueryHttpService().url = "exm/accessLogQueryDispatch.action?";  
    super.getSubmitQueryHttpService().request  =populateRequestParams();
    super.getSubmitQueryHttpService().method="POST";
   
}
    
/**
* This method will populate the request parameters for the
* submitQuery call and bind the parameters with the HTTPService
* object.
*/
private function populateRequestParams():Object {
    
    var reqObj : Object = new Object();
    
    reqObj.method= "submitQuery";
    reqObj.accountNo= this.actPopUp.accountNo.text;
    reqObj.userId= this.userPopUp.employeeText.text;
    reqObj.securityId= this.instrumentPopUp.instrumentId.text;
    reqObj.transactionNumber= this.transactionNumber.text;
    reqObj.dataSource= this.dataSource.text;
    reqObj.actionTaken = this.actionTaken.selectedItem.value;
    reqObj.senderSystemId = this.senderSystemId.text;
    reqObj.errorSystemId = this.errorSystemId.selectedItem.value;
    reqObj.senderEnterpriseId= this.senderEnterpriseId.selectedItem.value;
    reqObj.errorEnterpriseId= this.errorEnterpriseId.selectedItem.value;
    reqObj.messageType = this.messageType.selectedItem.value;
    reqObj.recipientEnterpriseId = this.recipientEnterpriseId.selectedItem.value;
    reqObj.transactionType = this.transactionType.selectedItem.value;
    reqObj.errorCode = this.errorCode.text;
    reqObj.creationDateFrom = this.creationDateFrom.text;
    reqObj.creationDateTo = this.creationDateTo.text;
    reqObj.appRegiDateFrom = this.appRegiDateFrom.text;
    reqObj.appRegiDateTo = this.appRegiDateTo.text;
    
    
    return reqObj;
}

override public function postQueryResultHandler(mapObj:Object):void{
    commonResult(mapObj);
}
   
    
private function commonResult(mapObj:Object):void{        
    
    var result:String = "";
    if(mapObj!=null){   
             
        if(mapObj["errorFlag"].toString() == "error"){
            //result = mapObj["errorMsg"] .toString();
            resetResultHeader();
            errPage.showError(mapObj["errorMsg"]);
        }else if(mapObj["errorFlag"].toString() == "noError"){
           errPage.clearError(super.getSubmitQueryResultEvent());
           //errPage.removeError();
          
           queryResult.removeAll();
         
           queryResult=mapObj["row"];
           changeCurrentState();
           qh.setOnResultVisibility();
           qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
           qh.PopulateDefaultVisibleColumns();
            
        }else{
            errPage.removeError();
            
            resetResultHeader();
            XenosAlert.info("No records found matching the search criteria.");
        }            
    }
    
}       
/**
 * Reset the query result on error and when no result is found.
 */ 
private function resetResultHeader():void{
    queryResult.removeAll();            
    qh.setPrevNextVisibility(false,false);
    qh.pdf.enabled = false;
    qh.xls.enabled = false;
    //qh.print.enabled = false;
}
override public function preResetQuery():void{
    var rndNo:Number= Math.random();
    super.getResetHttpService().url = "exm/accessLogQueryDispatch.action?method=resetAccessLogQueryForm&modeOfOperation=VIEW&rnd=" + rndNo;            
}    
    
    
/**
* This will generate the Xls report for the entire query result set 
* and will open in a separate window.
*/   
override   public function preGenerateXls():String{
    var url : String =null;
    url = "exm/accessLogQueryDispatch.action?method=generateXLS";
            
    return url;
}    
     
/**
* This will generate the Pdf report for the entire query result set 
* and will open in a separate window.
*/    
override public function preGeneratePdf():String{
    var url : String =null;
    url = "exm/accessLogQueryDispatch.action?method=generatePDF";
      
    return url;
}    
/**
* This method sends the HttpService for Next Set of results operation.
* This is actually server side pagination for the next set of results.
*/        
override    public function preNext():Object{
    var reqObj : Object = new Object();
    reqObj.method = "doNext";
    return reqObj;
}    
     
/**
* This method sends the HttpService for Previous Set of results operation.
* This is actually server side pagination for the previous set of results.
*/    
override public function prePrevious():Object{
   
    var reqObj : Object = new Object();
    reqObj.method = "doPrevious";
    return reqObj;
}
 
private function dispatchPrintEvent():void{
    this.dispatchEvent(new Event("print"));
}  
private function dispatchPdfEvent():void{
    this.dispatchEvent(new Event("pdf"));
}  
private function dispatchXlsEvent():void{
    this.dispatchEvent(new Event("xls"));
}   
private function dispatchNextEvent():void{
    this.dispatchEvent(new Event("next"));
}  
private function dispatchPrevEvent():void{
    this.dispatchEvent(new Event("prev"));
}
        
    
