                        
import com.nri.rui.core.Globals;
import mx.collections.ArrayCollection;
import mx.rpc.events.FaultEvent;
import com.nri.rui.core.controls.XenosHTTPService;
import mx.rpc.events.ResultEvent;
import com.nri.rui.core.controls.CustomChangeEvent;
import com.nri.rui.core.controls.TreeCombo;
import flash.utils.getQualifiedClassName;
import flash.utils.getDefinitionByName;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.WizardPage;
import com.nri.rui.core.controls.CustomChangeEvent;

import mx.events.ChildExistenceChangedEvent;
import mx.events.IndexChangedEvent;
import mx.events.FlexEvent;
import mx.resources.ResourceBundle;
import mx.core.Application;
import mx.logging.ILogger;
import com.nri.rui.core.logging.XenosLogImpl;
            
[Bindable]
public var submitResult:XML;

[Bindable]private var urlModeBind:String="";

private var noOfLoadedClasses:int = 0;

private var childsArray:Array = new Array();

[Bindable] private var method:String; 

private var populateTabsRequest:XenosHTTPService = new XenosHTTPService();

public var log : XenosLogImpl = XenosLogImpl.getLog("Entry.mxml");

private function init():void {
	parseLoaderUrl();
	
	wizard.initUrl="swp/swpTrade"+urlModeBind+"Dispatch.action?method=" + method+"&SCREEN_KEY=60";
	
	load();
	registerClassAlias("GeneralTab", GeneralTab);
	registerClassAlias("DeliverTab", DeliverTab);	
	registerClassAlias("ReceiveTab", ReceiveTab);
	addEventListener("confirmOk",confirmOkHandler);
	log.info("wizard.initUrl - {0}", [wizard.initUrl]);
	
	XenosAlert.info("in init");
}

private function confirmOkHandler(event:CustomChangeEvent):void{
	vstack.selectedIndex = 0;
	wizard.dispatchEvent(new Event("entryConfirmOk"));
}
 
private function load():void {
        var rndNo:int = Math.random();
	populateTabsRequest.url = "swp/swpTradeEntryDispatch.action?method=loadTab&rnd=" + rndNo;
	populateTabsRequest.addEventListener(FaultEvent.FAULT, handleError);
	populateTabsRequest.addEventListener(ResultEvent.RESULT, handleResult);
	populateTabsRequest.showBusyCursor = true;
	populateTabsRequest.resultFormat = "xml";
	populateTabsRequest.method = "POST";
	var reqObj:Object = new Object();
	populateTabsRequest.request = reqObj;
	populateTabsRequest.send();
}

private function handleResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if(rs.child("Errors").length() > 0) {
	    var errorInfoList : ArrayCollection = new ArrayCollection();
	    //populate the error info list              
	    for each ( var error:XML in rs.Errors.error ) {
	       errorInfoList.addItem(error.toString());
	    }
	    //Display the error
	    wizard.errPage.showError(errorInfoList);
	 } else {
               wizard.populateVisibleTabs(rs);
               populateTabs();
	}
}

private function handleError(event:FaultEvent):void{
    XenosAlert.error(Application.application.xResourceManager.getKeyValue('ref.msg.common.info.errorfaultstr', new Array(event.fault.faultDetail)));
}
public function populateTabs():void{
 var tabArray:Array = wizard.visibleTabs;
 var indx:int = 0;
 log.info("tabArray.length - {0}", [tabArray.length]);
   if(tabArray.length != 0){
     for (var count:int = 0; count < tabArray.length; count++) {
         var obj:Object = tabArray[count];
         var dispObjClass:Class =  getDefinitionByName(obj['label'].toString()) as Class;
         var myInstance:Object = new dispObjClass();
         wizard.viewStackInstance.addChild(WizardPage(myInstance));
     }
   }
   wizard.dispatchEvent(new Event("moduleCreationComplete"));
}

public function childAdded(event:ChildExistenceChangedEvent):void{
} 
            
private function doViewStackChange(event:IndexChangedEvent):void{
	XenosAlert.info("VS1" + event.newIndex);
    if(event.newIndex == 1){
        confirmTab.confirmInitXML=wizard.submitResult;		
		confirmTab.dispatchEvent(new CustomChangeEvent("visibleTabsEvent",wizard.visibleTabs));	
    }
} 

public function parseLoaderUrl():void {
                
    try {
	    var myPattern:RegExp = /.*\?/; 
	    var s:String = this.loaderInfo.url.toString();
	    
	    s = s.replace(myPattern, "");
	    var params:Array = s.split(Globals.AND_SIGN); 
	    var keyStr:String;
	    var valueStr:String;
	    var paramObj:Object = params;
	    
	    var entityPkName:String;
	    var entityPkValue:String;
                  
	    if(params != null){
		    for (var i:int = 0; i < params.length; i++) {
                        var temp:Array = params[i].split("=");  
                        if(temp[0] == "method"){
	                    this.method = temp[1];
                        } 
		    }                    	
	    }
	    urlModeBind="Entry";
	    
	    confirmTab.restoreXmlRequest.url = "swp/swpTrade"+urlModeBind+"Dispatch.action?method=submitConfirm";
	
            wizard.submitUrl="swp/swpTrade"+urlModeBind+"Dispatch.action?method=submitEntry"
	    wizard.switchTabUrl="swp/swpTrade"+urlModeBind+"Dispatch.action?method=switchEntryTab"+"&SCREEN_KEY=60"
	    wizard.resetUrl="swp/swpTrade"+urlModeBind+"Dispatch.action?method=resetEntryPage"
	
	    confirmTab.urlModeBind = urlModeBind;
		
	} catch (e:Error) {
	    trace(e);
	}
}