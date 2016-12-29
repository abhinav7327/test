

// ActionScript file
import com.nri.rui.adp.validator.SegregateBalanceQueryValidator;
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.formatters.CustomDateFormatter;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.rpc.events.ResultEvent;

[Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
[Bindable]private var queryResult:ArrayCollection= new ArrayCollection();
[Bindable]private var mode : String = "query";
[Bindable]public var confSummary:ArrayCollection= new ArrayCollection();

[Bindable]public var securityCode:String="";
[Bindable]public var securityName:String="";
[Bindable]public var selectAllBind:Boolean=false;

private var keylist:ArrayCollection = new ArrayCollection();
private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
private var selIndx:int = 0;
private var i:int = 0;
private var item:Object = new Object();

          
public function loadAll():void
{
   parseUrlString();
   super.setXenosQueryControl(new XenosQuery());
   if(this.mode == 'cancel'){
     this.dispatchEvent(new Event('queryInit'));     
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
                if (tempA[0] == "mode") {
                    mode = tempA[1];
                }
            }                       
        }else{
            mode = "query";
        }                 
    } catch (e:Error) {
        trace(e);
    }               
}

private function addCommonKeys():void
{  
    keylist = new ArrayCollection();
}

private function commonInit(mapObj:Object):void
{      
    //clears the errors if any
    errPage.clearError(super.getInitResultEvent());
    app.submitButtonInstance = submit;
    
    security.instrumentId.text = XenosStringUtils.EMPTY_STR;    
    fundPopUp.fundCode.text = XenosStringUtils.EMPTY_STR;
    segregateDateFrom.text = XenosStringUtils.EMPTY_STR;
    segregateDateTo.text = XenosStringUtils.EMPTY_STR;
}

private function setValidator():void
{
    
    var segregateBalanceQueryModel:Object = {
                            segregateBalanceQuery:{
                                securityCode:this.security.instrumentId.text,
                                fundCode:this.fundPopUp.fundCode.text,
                                segregateDateFrom: this.segregateDateFrom.text,
                                segregateDateTo: this.segregateDateTo.text,
                                mode: this.mode
                            }
                           }; 
    super._validator = new SegregateBalanceQueryValidator();
    super._validator.source = segregateBalanceQueryModel ;
    super._validator.property = "segregateBalanceQuery";
    
}

private function commonResult(mapObj:Object):void
{      
    var result:String = "";
    if(mapObj!=null){   
        if(mapObj["errorFlag"].toString() == "error"){            
            queryResult.removeAll();
            errPage.showError(mapObj["errorMsg"]);
            resetSellection(queryResult);
        }else if(mapObj["errorFlag"].toString() == "noError"){
           errPage.clearError(super.getSubmitQueryResultEvent());
           selectAllBind = false;           
           queryResult.removeAll();           
           queryResult = mapObj["row"];
           resetSellection(queryResult);
           
           securityCode = queryResult[0].securityId;
           securityName = queryResult[0].securityName;
           
           changeCurrentState();
           reset.enabled = true;
           if(!cancel.visible){
            hideUserConf();
           }
           
           if(sysConfMessage != null && sysConfMessage.visible == true){
           	hideSysConf();
           }

        }else{
            errPage.removeError();
            queryResult.removeAll();
            currentState = "";
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }           
    }
}

/**
* This method will populate the request parameters for the
* submitQuery call and bind the parameters with the HTTPService
* object.
*/
private function populateRequestParams():Object
{        
    var reqObj : Object = new Object();
    reqObj.SCREEN_KEY = "12070";
    reqObj.mode = this.mode ;
    reqObj.method = "submitQuery";
    reqObj.segregateDateFromStr = this.segregateDateFrom.text;
    reqObj.segregateDateToStr = this.segregateDateTo.text;    
    reqObj.fundCode = this.fundPopUp.fundCode.text;
    reqObj.securityCode = this.security.instrumentId.text;
    
    reqObj.rnd = Math.random();
    
    return reqObj;
}
        
override public function preQueryInit():void
{      
    var rndNo:Number= Math.random(); 
    super.getInitHttpService().url = "adp/segregateBalanceCancelQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
    var req : Object = new Object();
    req.SCREEN_KEY = "12069";
    super.getInitHttpService().request = req;
}
        
override public function preCancelInit():void
{
    var rndNo:Number= Math.random(); 
    super.getInitHttpService().url = "adp/segregateBalanceCancelQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
    var req : Object = new Object();
    req.SCREEN_KEY = "12069";
    super.getInitHttpService().request = req;
}
        
override public function preQueryResultInit():Object
{
    addCommonKeys();    
    return keylist;         
}
        
/* override public function preAmendResultInit():Object
{
    addCommonKeys();                
    return keylist;         
} */
        
override public function preCancelResultInit():Object
{
    addCommonKeys();                
    return keylist;         
}
         
override public function postQueryResultInit(mapObj:Object):void
{
    commonInit(mapObj);
}

override public function postCancelResultInit(mapObj:Object):void
{
    commonInit(mapObj);
}
       
override public function preQuery():void
{      
    setValidator();
    //qh.resetPageNo();
    super.getSubmitQueryHttpService().url = "adp/segregateBalanceCancelQueryDispatch.action?";
    super.getSubmitQueryHttpService().request = populateRequestParams();
}
        
override public function preCancel():void
{
    setValidator();
    //qh.resetPageNo();
    super.getSubmitQueryHttpService().url = "adp/segregateBalanceCancelQueryDispatch.action?";
    super.getSubmitQueryHttpService().request = populateRequestParams();       
}
    
override public function postQueryResultHandler(mapObj:Object):void
{
    commonResult(mapObj);
}
    
override public function postCancelResultHandler(mapObj:Object):void
{
    commonResult(mapObj);
}
      
override public function preResetQuery():void
{
    var rndNo:Number= Math.random();
    super.getResetHttpService().url = "adp/segregateBalanceCancelQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
}
        
override public function preResetCancel():void
{
    var rndNo:Number= Math.random();
    super.getResetHttpService().url = "adp/segregateBalanceCancelQueryDispatch.action?method=initialExecute&rnd=" + rndNo;                
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
  
private function dispatchNextEvent():void
{
      this.dispatchEvent(new Event("next"));
}
  
private function dispatchPrevEvent():void
{
      this.dispatchEvent(new Event("prev"));
}

private function doBack():void
{
    app.submitButtonInstance = submit;    
}


private function copySegregateFromDate():void
{
    for(var i:int = 0; i < queryResult.length; i++) {
            queryResult[i].segregateDateFromStr = this.segregateDateFrom.text;
    }
    queryResult.refresh();
} 

private function copySegregateToDate():void
{
    for(var i:int = 0; i < queryResult.length; i++) {
            queryResult[i].segregateDateToStr = this.segregateDateTo.text;
    }
    queryResult.refresh();
}

private function submitBulkCancel():void
{
	var selFlag:Boolean = false;
	submitCancel.enabled = false;	 
	queryResult.refresh();
	     
    var errorFlag:Boolean = false;
    var errorStr:String = "";
    
    var formatData:String = "";
    var dateformat:CustomDateFormatter = new CustomDateFormatter();
    dateformat.formatString="YYYYMMDD";
    
    var i:int = 0;          
    var reqObj:Object=new Object();
    reqObj.method="submitCancel";
    reqObj.mode ="cancel";
    reqObj.SCREEN_KEY="12071";
    
    for each(var objInfo:Object in this.queryResult){               
        if(objInfo.selected == true){
        	selFlag = true;
            //var errorIndexStr:String = (i+1).toString();
            var errorIndexStr:String = (queryResult.getItemIndex(objInfo)+1).toString();
            reqObj['segregateBalanceListInfo['+i+'].quantityStr'] = objInfo.quantity;
            reqObj['segregateBalanceListInfo['+i+'].segregateDateFromStr'] = objInfo.segregateDateFromStr;
            reqObj['segregateBalanceListInfo['+i+'].segregateDateToStr'] = objInfo.segregateDateToStr;
            reqObj['segregateBalanceListInfo['+i+'].segregateBalancePk'] = objInfo.segregateBalancePk;
            reqObj['segregateBalanceListInfo['+i+'].remarks'] = objInfo.remarks;
            reqObj['segregateBalanceListInfo['+i+'].fundPk'] = objInfo.fundPk;
            reqObj['segregateBalanceListInfo['+i+'].fundCode'] = objInfo.fundCode;
            reqObj['segregateBalanceListInfo['+i+'].instrumentPk'] = objInfo.instrumentPk;
            reqObj['segregateBalanceListInfo['+i+'].referenceNo'] = objInfo.referenceNo;
            i++;
        } 
    }
    
     if(!selFlag){
    	XenosAlert.info("Please select at least one record for Segregate Balance Cancel");
        submitCancel.enabled = true;
        return;
    }else if(errorFlag){
        XenosAlert.error(errorStr);
        submitCancel.enabled = true;
        return;
    }else{
    	submitCancel.enabled = true;
        reqObj.securityCode = this.securityCode;    
        bulkCancelService.request = reqObj;
        bulkCancelService.method = "POST";
        bulkCancelService.send();
    }
}

private function submitBulkCancelResult(event:ResultEvent):void
{
    var rs:XML = XML(event.result);
    if (null != event) {
    	errPage2.clearError(event);    	
        if(rs.child("Errors").length()>0) {
            var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list              
            for each ( var error:XML in rs.Errors.error ) {
               errorInfoList.addItem(error.toString());
               trace(error.toString());                
            }
            errPage2.showError(errorInfoList);//Display the error
         }else{             
            errPage2.clearError(event);
            try {
                
                showUserConf();
                
                confSummary.removeAll();                
                selectAllBind = false;
                
                if(rs.segregateBalanceList != null) {
                    for each(var objXml:XML in rs.segregateBalanceList.segregateBalanceList){                   
                        confSummary.addItem(objXml);
                    }        
                }               
            }catch(e:Error){                
                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            }            
         }
     }  
}

private function confirmBulkCancel():void
{
    ok.enabled = false;   
    var errorFlag:Boolean = false;
    var errorStr:String = "";
                
    var reqObj:Object=new Object();
    reqObj.method="confirmCancel";
    reqObj.mode ="cancelconfirm";
    reqObj.SCREEN_KEY="12072";        
    
    bulkCancelConfService.request = reqObj;
    bulkCancelConfService.method = "POST";
    bulkCancelConfService.send();           
}

private function confirmBulkCancelResult(event:ResultEvent):void
{  
	var rs:XML = XML(event.result);
    if (null != event) {    	
    	ok.enabled = true;    	
        if(rs.child("Errors").length()>0) {
            var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list              
            for each ( var error:XML in rs.Errors.error ) {
               errorInfoList.addItem(error.toString());               
               trace(error.toString());                
            }
            errPage3.showError(errorInfoList);//Display the error
         }else{ 
         	errPage3.clearError(event);
         	showSysConf();
    		clearValues(queryResult);
         }
    }
}

public function handleConfirmError(event:CloseEvent):void
{
    initialState();
}

public function resetBulkCancel():void
{
	reset.enabled = false;
	errPage2.removeError();    
    resetSellection(queryResult);
    clearValues(queryResult);
    super.doQuery(new Event('querySubmit')); 
}

public function clearValues(queryResult:ArrayCollection):void
{
    for each(var rec:Object in queryResult){        
        if(rec.selected){
            rec.selected = false;
        }           
    }
    queryResult.refresh();    
}

public function checkSelectToModify(item:Object):void
{   
    setIfAllSelected();             
}
    
private function resetSellection(queryResult:ArrayCollection):void
{
    for(var i:int=0;i<queryResult.length;i++){
        queryResult[i].selected = false;
        queryResult[i].rowNum = i;
    }
    
    var reqObj:Object=new Object();
    reqObj.method="backToForm";
    reqObj.mode ="cancel";
    reqObj.SCREEN_KEY="12069";        
    
    bulkCancelResetService.request = reqObj;
    bulkCancelResetService.method = "POST";
    bulkCancelResetService.send();
    
} 

private function confirmResetCancelResult(event:ResultEvent):void
{
	var rs:XML = XML(event.result);// Consume the result and do nothing	
}
    
public function setIfAllSelected() : void
{
    if(isAllSelected()){
        selectAllBind=true;
    } else {
        selectAllBind=false;
    }
}
    
    
public function isAllSelected(): Boolean
{
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
public function selectAllRecords(flag:Boolean): void
{
    var i:Number = 0;    
    for(i=0; i<queryResult.length; i++){
        var obj:XML=queryResult[i];
        obj.selected = flag;
        queryResult[i]=obj;        
    }
}

private function initialState():void
{    
    errPage2.removeError();
    errPage3.removeError();    
    clearValues(queryResult);    
    hideSysConf();        
    
    if(!cancel.visible){cancel.visible = true;}
    if(!confirm.visible)confirm.visible = false;    
    
    detailCancel.selectedChild = cancel;
        
    security.instrumentId.text = XenosStringUtils.EMPTY_STR;    
    fundPopUp.fundCode.text = XenosStringUtils.EMPTY_STR;    
    currentState = "";
    app.submitButtonInstance = submit;
    this.mode = "cancel";
    super.doResetQuery(new Event("queryReset"));       
}

private function doConfBack():void
{
    errPage.removeError()
    errPage2.removeError(); 
    errPage3.removeError(); 
    confSummary.removeAll();
    
    selectAllBind = false;
    
    var reqObj:Object=new Object();
    reqObj.method="backToForm";
    reqObj.mode ="cancel";
    reqObj.SCREEN_KEY="12069";        
    
    bulkCancelBackService.request = reqObj;
    bulkCancelBackService.method = "POST";
    bulkCancelBackService.send();
    
    detailCancel.selectedChild = cancel;
    confirm.visible = false;
}

private function showUserConf():void
{	 
    if(cancel.visible){cancel.visible = false;}    
    if(cancel.includeInLayout){cancel.includeInLayout = false;}    
    
    if(!confirm.includeInLayout){confirm.includeInLayout = true;}    
    if(!confirm.visible){confirm.visible = true;}
            
    // set current state to confirm tab              
    detailCancel.selectedChild = confirm;
}

private function hideUserConf():void
{
    if(!cancel.visible){cancel.visible = true;}    
    if(!cancel.includeInLayout){cancel.includeInLayout = true;}    
    
    errPage3.removeError();
    
    if(confirm.includeInLayout){confirm.includeInLayout = false;}    
    if(confirm.visible){confirm.visible = false;}
            
    // set current state to confirm tab              
    detailCancel.selectedChild = cancel;
}

private function showSysConf():void
{
	// Show the sys conf message panel
    sysConfMessage.includeInLayout=true;    
    sysConfMessage.visible = true;
    
    // Show the sys conf message
    sConfLabel.includeInLayout = true;
    sConfLabel.visible = true;
    
    // Show the sys conf button
    sysconfBtn.includeInLayout = true;
    sysconfBtn.visible = true;
    
    // Hide the user conf message
    uConfLabel.includeInLayout = false;
    uConfLabel.visible = false;
    
    // Hide the back button 
    back.visible = false;
    back.includeInLayout = false;
    
    // Hide the confirm button
    ok.visible = false;
    ok.includeInLayout = false;
}

private function hideSysConf():void
{
	 // Hide the sys conf message panel
    sysConfMessage.includeInLayout=false;    
    sysConfMessage.visible = false;
    
    // Hide the sys conf message
    sConfLabel.includeInLayout = false;
    sConfLabel.visible = false;
    
    // Hide the sys conf button
    sysconfBtn.includeInLayout = false;
    sysconfBtn.visible = false;
    
    // Show the user conf message
    uConfLabel.includeInLayout = true;
    uConfLabel.visible = true;
    
    // Show the back button 
    back.visible = true;
    back.includeInLayout = true;
    
    // Show the confirm button
    ok.visible = true;
    ok.includeInLayout = true;
}

private function confirmBackCancelResult(event:ResultEvent):void
{
    // Leaves the amend form intact
}