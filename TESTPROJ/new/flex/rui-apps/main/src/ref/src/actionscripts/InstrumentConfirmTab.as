// ActionScript file
import com.nri.rui.core.controls.CustomChangeEvent;

import mx.collections.ArrayCollection;
import mx.containers.ViewStack;
import mx.rpc.events.ResultEvent;
[Bindable]
private var _confirmInitXML:XML;
[Bindable]
private var _mode:String;
[Bindable]
private var _submitEnable:Boolean;

[Bindable]private var urlModeBind:String="Entry";
/**
 * This method is called when the container is initialized
 */ 
private function init():void{
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
	
}

public function get submitEnable():Boolean{
	return _submitEnable;
}

public function set submitEnable(flag:Boolean):void{
	_submitEnable=flag;
	
}

public function get mode():String{
	return _mode;
}

public function set mode(md:String):void{
	_mode=md;
	if(_mode=="amend"){
		urlModeBind="Amend";
	}
	else if(_mode=="entry"){
		urlModeBind="Entry";
	}
	else if(_mode=="cancel"){
		urlModeBind="Cancel";
	}
	
}

private function creationHandler():void{
	 if(_mode=="cancel"){
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
		submit.includeInLayout=true;
		submit.visible=true;
	} 
	
}

private function doSubmit():void{
	submitCxlRequest.send();
}

private function doBack():void{
	errPage.removeError();
	(parent as ViewStack).selectedIndex=0;
}

            
public function OperationRequest(event:Event):void {
     var requestObj :Object = new Object();	
	 requestObj.method = "commit";
	 restoreXmlRequest.request=requestObj;
	 restoreXmlRequest.send();				
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
    sysConfMessage.includeInLayout=true;   
 	sysConfMessage.visible=true;
}
			
private function OperationResult(event: ResultEvent) : void {
     if(event.result!=null){         
	     if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
	         errPage.clearError(event);
			 visiblityControl();	
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
    	
    		submit.includeInLayout=false;
    		submit.visible=false;
    		lb2.visible=true;
    		lb2.includeInLayout=true;
    		confirm.includeInLayout=true;
    		confirm.visible=true;   		
    		
    }
}


public function okOperation():void{
	reset();
    this.dispatchEvent(new CustomChangeEvent("confirmOk"));
} 			