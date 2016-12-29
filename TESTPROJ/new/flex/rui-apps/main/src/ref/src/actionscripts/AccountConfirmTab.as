

import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.utils.XenosStringUtils;

import mx.collections.ArrayCollection;
import mx.containers.ViewStack;
import mx.rpc.events.ResultEvent;
import com.nri.rui.core.controls.CustomChangeEvent;
//import com.nri.rui.core.controls.CustomChangeEvent;

[Bindable]private var _confirmInitXML:XML;
[Bindable]private var _mode:String;
[Bindable]public var confirmOkXML:XML;
[Bindable]private var historyReasonCodeList:ArrayCollection;
[Bindable]private var _urlModeBind:String;

/**
 * This method is called when the container is initialized
 */ 
private function init():void{
	//XenosAlert.info("init");
	addEventListener("visibleTabsEvent",eventPropagationToTabsContainer);
}

/**
 * This method is the handler of CustomChangeEvent(visibleTabsEvent). 
 * This method capture the event dispatched by its parent and dispatch
 * this event on its child container.
 * In general this methos is used to propagate the event(with its targetParams property) 
 * from its parent container to its child container.
 */ 
private function eventPropagationToTabsContainer(event:CustomChangeEvent):void{
	trace("eventPropagationToTabsContainer");
	tabs.tabModules.dispatchEvent(new CustomChangeEvent("visibleTabsContentEvent",event.targetParams));	
}

public function get confirmInitXML():XML{
	return _confirmInitXML;
}

public function set confirmInitXML(xmlObj:XML):void{
	_confirmInitXML=xmlObj;
	
	if(_mode=="cancel" || mode=="reopen"){
    		 	if(xmlObj.child("historyReasonCodeList").length()>0) {
    		 	 	historyReasonCodeList = new ArrayCollection();
					historyReasonCodeList.addItem({label:" ", value:" "});
					var xmlObj2:Object = new Object();
					for each(xmlObj2 in xmlObj.historyReasonCodeList.item){
						historyReasonCodeList.addItem(xmlObj2);
					}
    		 	 }
    		 	confirmOkXML = xmlObj as XML;
   }
	
}

public function get urlModeBind():String {
	return _urlModeBind;
}

public function set urlModeBind(urlModeBind:String):void {
	_urlModeBind = urlModeBind;
}


public function get mode():String {
	return _mode;
}

public function set mode(mode:String):void {
	_mode = mode;
}

private function creationHandler():void{
	 if(_mode=="cancel" || _mode=="reopen"){
		back.includeInLayout=false;
		confirm.includeInLayout=false;
		ok.includeInLayout=false;
		back.visible=false;
		confirm.visible=false;
		ok.visible=false;
		lb1.visible=false;
		lb2.visible=false;
		lb1.includeInLayout=false;
		lb2.includeInLayout=false;
		submit.visible=true;
		submit.includeInLayout=true;
	}
}

/**
 * On click handler for the 'Back' button in the user confirmation page for Entry,
 * Amend and Copy.
 */
private function doSubmit():void{
	var reqObj:Object = new Object();
	
	if (_mode == "cancel") {
		accCancelNoLbl.includeInLayout=true;
		accCancelNoLbl.visible=true;
		historyCancelReasonPkLbl.includeInLayout=true;
		historyCancelReasonPkLbl.visible=true;
		reqObj.method="submitAccountClose";
	}else if(_mode == "reopen"){
		accReopenNoLbl.includeInLayout=true;
		accReopenNoLbl.visible=true;
		historyReopenReasonPkLbl.includeInLayout=true;
		historyReopenReasonPkLbl.visible=true;
		reqObj.method="submitAccountReopen";
	}
	submitCxlRequest.request=reqObj;
	submitCxlRequest.send();
}

private function doBack():void{
	errPage.removeError();
	(parent as ViewStack).selectedIndex=0;
}

/**
 * On click handler for the 'Confirm' or 'OK' button in the user confirmation page.
 * This method is invoked when the user clicks the 'Confirm' button from user
 * confirmation screen for Entry, Amend or Copy or the 'OK' button in the same screen
 * for Cancel or Reopen.
 */          
public function doUserConfirmation(event:Event):void {
	
    var requestObj:Object = new Object();
    var flag:Boolean = true;
    if (_mode == "cancel") {
    	//restoreXmlRequest.url = "ref/account" + this._urlModeBind + "Dispatch.action";
    	flag = validateCancel();
    	if (flag) {
	    	requestObj.method = "confirmAccountClose";
     	}
    }else if (_mode == "reopen") {
    	flag = validateCancel();
    	if (flag) {
	    	requestObj.method = "confirmAccountReopen";
     	}
    }
    if (flag) {
    requestObj.historyReasonPkStr = this.historyReasonPk.selectedItem != null ? this.historyReasonPk.selectedItem.value:"";
	requestObj.historyRemarks = this.historyRemarks.text;
	restoreXmlRequest.request = requestObj;
	restoreXmlRequest.send();
    }
}

/**
 * This method is invoked when the user clicks the 'OK' button from the system
 * confirmation screen.
 */
public function doSystemConfirmation():void{
	reset();
    this.dispatchEvent(new CustomChangeEvent("confirmOk"));
}

private function reset():void{
	lb1.visible=false;
    lb2.visible=true;
	back.includeInLayout=true;
	back.visible=true;
	confirm.includeInLayout=true;
	confirm.visible=true;
	ok.includeInLayout=false;
	ok.visible=false;	
}

private function visiblityControl():void{
    			
        lb1.visible=true;
        lb1.includeInLayout=true;
	    lb2.visible=false;
	    lb2.includeInLayout=false;
		back.includeInLayout=false;
		back.visible=false;
		confirm.includeInLayout=false;
		confirm.visible=false;
		ok.includeInLayout=true;
		ok.visible=true;
		if(_mode=="cancel" || _mode=="reopen"){
			tabs.visible = true;
    		tabs.includeInLayout = true;
    		cancelTab.includeInLayout = false;
    		cancelTab.visible = false; 
    		okConfirm.visible=false;
	    	okConfirm.includeInLayout=false;
	    	okCancel.visible=false;
	    	okCancel.includeInLayout=false;
		}
		if(_mode=="cancel" || _mode=="reopen" || _mode=="amend" || _mode=="entry" || _mode=="copy"){
			sysConfMessage.includeInLayout=true;   
     		sysConfMessage.visible=true;
		}
   
}
			
private function OperationResult(event: ResultEvent) : void {
     if(event.result!=null){
	     if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
	         errPage.clearError(event);
			 visiblityControl();
//			 hb.visible = true;
//			 hb.includeInLayout = true;	
			 
	     } else { // Must be error
	         errPage.displayError(event);                
	     }
	  }
}

private function submitCxlResult(event: ResultEvent) : void {
    var rs:XML = XML(event.result);
    if(rs.child("Errors").length() > 0) {
        var errorInfoList : ArrayCollection = new ArrayCollection();
        //populate the error info list              
        for each ( var error:XML in rs.Errors.error ) {
           errorInfoList.addItem(error.toString());
        }
        //Display the error
        errPage.showError(errorInfoList);
    } else {
    		if(_mode=="cancel" || mode=="reopen"){
    		 	/* if(rs.child("historyReasonCodeList").length()>0) {
    		 	 	historyReasonCodeList = new ArrayCollection();
					historyReasonCodeList.addItem({label:" ", value:" "});
					var xmlObj2:Object = new Object();
					for each(xmlObj2 in rs.historyReasonCodeList.item){
						historyReasonCodeList.addItem(xmlObj2);
					}
    		 	 }
    		 	confirmOkXML = rs as XML;*/
    		 	
    		 	tabs.visible = false;
    		 	tabs.includeInLayout = false;
    		 	cancelTab.includeInLayout = true;
    		 	cancelTab.visible = true; 
    		 	submit.includeInLayout=false;
	    		submit.visible=false;
	    		lb2.visible=true;
	    		lb2.includeInLayout=true;
	    		okConfirm.visible=true;
	    		okConfirm.includeInLayout=true;
	    		okCancel.visible=true;
	    		okCancel.includeInLayout=true;
    		 	 	
    		}else{
	    		submit.includeInLayout=false;
	    		submit.visible=false;
	    		lb2.visible=true;
	    		lb2.includeInLayout=true;
	    		confirm.includeInLayout=true;
	    		confirm.visible=true; 
    		 }
    		
    }
}


		

private function validateCancel():Boolean
{
    var errorStr:String = "";
    var errorFlag:Boolean = false;
 			
    if(XenosStringUtils.isBlank(this.historyReasonPk.selectedItem.value)){
		errorFlag = true;
		errorStr += "Reason Code can not be empty.\n";
	}
	
	if(errorFlag){
		XenosAlert.error(errorStr);
		return false;
	}
	return true;

}
public function doCancel(event:Event):void {
	var requestObj:Object = new Object();
    if (_mode == "cancel") {	
		requestObj.method = "backToAccountCancel";
    }else if (_mode == "reopen") {	
		requestObj.method = "backToAccountReopen";
    }
	restoreCancelXmlRequest.request = requestObj;
	restoreCancelXmlRequest.send();				
}

private function OperationCancelResult(event: ResultEvent) : void {
     if(event.result!=null){         
	     if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
	         errPage.clearError(event);
			 visiblityCancelControl();	
	     } else { // Must be error
	         errPage.displayError(event);                
	     }
	  }
}

private function visiblityCancelControl():void{
    			
        lb1.visible=false;
	    lb2.visible=false;
//	    hb.visible = false;
//		hb.includeInLayout = false;	
		back.includeInLayout=false;
		back.visible=false;
		confirm.includeInLayout=false;
		confirm.visible=false;
		ok.includeInLayout=false;
		ok.visible=false;
		submit.includeInLayout=true;
	    submit.visible=true;
	    okConfirm.visible=false;
	    okConfirm.includeInLayout=false;
	    okCancel.visible=false;
	    okCancel.includeInLayout=false;
	    tabs.visible = true;
    	tabs.includeInLayout = true;
    	cancelTab.includeInLayout = false;
    	cancelTab.visible = false; 
    	
   
}
