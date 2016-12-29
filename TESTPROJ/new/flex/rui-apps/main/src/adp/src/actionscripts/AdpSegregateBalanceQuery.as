
// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.RendererFectory;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;

import mx.collections.ArrayCollection;
import mx.controls.TextInput;
import mx.controls.dataGridClasses.DataGridColumn;

import com.nri.rui.adp.validator.SegregateBalanceQueryValidator;

[Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
[Bindable]private var queryResult:ArrayCollection= new ArrayCollection();
[Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
[Bindable]private var mode : String = "query";
[Bindable]private var counterPartyTxtInput:TextInput = new TextInput();
[Bindable]private var initcol:ArrayCollection = new ArrayCollection();
[Bindable]private var tempColl: ArrayCollection = new ArrayCollection();


private var keylist:ArrayCollection = new ArrayCollection();
private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
private var selIndx:int = 0;
private var i:int = 0;
private var item:Object = new Object();

          
public function loadAll():void
{
   parseUrlString();
   super.setXenosQueryControl(new XenosQuery());
   this.dispatchEvent(new Event('queryInit'));
             
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
        
override public function preQueryInit():void
{      
    var rndNo:Number= Math.random(); 
    super.getInitHttpService().url = "adp/segregateBalanceQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
    var req : Object = new Object();
    req.SCREEN_KEY = "12062";
    super.getInitHttpService().request = req;
}
        
private function addCommonKeys():void
{  
    keylist = new ArrayCollection();
}
        
override public function preQueryResultInit():Object
{
    addCommonKeys();    
    return keylist;         
}

        
private function commonInit(mapObj:Object):void
{      
    //clears the errors if any
    errPage.clearError(super.getInitResultEvent());
    app.submitButtonInstance = submit;
    
    segregateDateFrom.text = XenosStringUtils.EMPTY_STR;
    segregateDateTo.text = XenosStringUtils.EMPTY_STR;
    security.instrumentId.text = XenosStringUtils.EMPTY_STR;
    fundPopUp.fundCode.text = XenosStringUtils.EMPTY_STR;
    
}
         
override public function postQueryResultInit(mapObj:Object):void
{
    commonInit(mapObj);
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
        
override public function preQuery():void
{      
    setValidator();
    qh.resetPageNo();
    super.getSubmitQueryHttpService().url = "adp/segregateBalanceQueryDispatch.action?";
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
    
    if(this.mode == 'query')
    {
        reqObj.SCREEN_KEY = "12063";
    }      
            
    reqObj.method = "submitQuery";
    reqObj.mode = this.mode;
    
    reqObj.segregateDateFromStr = this.segregateDateFrom.text;
    reqObj.segregateDateToStr = this.segregateDateTo.text;    
    reqObj.fundCode = this.fundPopUp.fundCode.text;
    reqObj.securityCode = this.security.instrumentId.text;
    
    reqObj.rnd = Math.random() + "";
    
    return reqObj;
}
    
override public function postQueryResultHandler(mapObj:Object):void
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
    super.getResetHttpService().url = "adp/segregateBalanceQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
}
        
override public function preGenerateXls():String
{
    var url : String =null;              
    url = "adp/segregateBalanceQueryDispatch.action?method=generateXLS";
    return url;
}
   
override public function preGeneratePdf():String
{
    var url : String =null;                  
    url = "adp/segregateBalanceQueryDispatch.action?method=generatePDF";
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