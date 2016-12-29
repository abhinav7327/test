
import com.nri.rui.core.controls.XenosAlert;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

[Bindable]private var selectedQryRslt:ArrayCollection=new ArrayCollection();
[Bindable]public var selIndexArray:Array=new Array();
[Bindable]public var selectedDays:Array=new Array();
[Bindable]private var selectedResultViewList:ArrayCollection= new ArrayCollection();

[Bindable]private var queryResult:ArrayCollection= new ArrayCollection();
[Bindable]private var rec:ArrayCollection= new ArrayCollection();
[Bindable]private var editedDays:Array= new Array();

	

private function goToSystemConfirmation():void {
	btnTrash.enabled=false;
	btnBack.enabled=false;
	var reqObj : Object = new Object();
        reqObj["SCREEN_KEY"] = 12155;
        reqObj["method"] = "submitSysConfirm";
        reqObj.rnd = Math.random();   
        reqObj.commandFormId = commandFormId;
        trashSuspendedTxnQuerySysConfRequest.request = reqObj;
        trashSuspendedTxnQuerySysConfRequest.send();
}

private function faultAlert(event:FaultEvent):void {
    	btnTrash.enabled=true;
    	btnBack.enabled=true;
    	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred.initialize') + event.fault.faultString)
    }
    
public function loadSystemConfPage(event:ResultEvent):void
{
	btnTrash.enabled=true;
	btnBack.enabled=true;
	errPage.clearError(event); //clears the errors if any 
	selectedResultViewList.removeAll();
	
	if(event.result != null){
		var commandForm: Object = event.result.trashSuspendedTxnQueryCommandForm;
		var xenosError: Object = event.result.XenosErrors;
		
		if(commandForm != null){
			if(commandForm.selectedResultViewList != null){
				if(commandForm.selectedResultViewList.indvidualList is ArrayCollection){
					selectedResultViewList = commandForm.selectedResultViewList.indvidualList as ArrayCollection;
				}else{
					selectedResultViewList.addItem(commandForm.selectedResultViewList.indvidualList);
				}
				vstack.selectedChild = sysRslt;
				sconfirmOK.includeInLayout = true;
  				sconfirmOK.visible = true;
  				hb.includeInLayout = true;
    	        hb.visible = true;
				this.title = this.parentApplication.xResourceManager.getKeyValue('fam.popup.trashsuspendedtxn.sysconf.popup.title');
				selectedResultViewList.refresh();
			}
		} else if(xenosError != null){
			errPage.displayError(event);	
		}
		 else{
			XenosAlert.info("Invalid response!");
		}
	}
}


/**
 * 
 * */

public function closeHandeler(event:Event):void
{
	this.dispatchEvent(new Event("OkSystemConfirm"));
    PopUpManager.removePopUp(this);
}

private function changeCurrentState():void{
  	uconfirmOk.includeInLayout = false;
  	uconfirmOk.visible = false;
  	sconfirmOK.includeInLayout = true;
  	sconfirmOK.visible = true;
  }
 public function removeMe():void {
  	PopUpManager.removePopUp(this);
}



