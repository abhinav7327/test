// ActionScript file
import com.nri.rui.core.containers.SummaryPopup;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.fam.FamConstants;
import com.nri.rui.fam.validators.FamCloseEntryDeleteValidator;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;
import mx.events.ValidationResultEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
 private var sPopup : SummaryPopup;	
 import mx.core.UIComponent;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.utils.XenosStringUtils;
 import mx.rpc.events.FaultEvent;
[Bindable]
private var commandFormId:String="";

[Bindable]
private var ClosingMonth:String="";
[Bindable]
private var entryResult:XML;

[Bindable]
private var initColl:ArrayCollection=new ArrayCollection();
[Bindable] public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);

private var keylist:ArrayCollection=new ArrayCollection();

[Bindable]
private var tempColl:ArrayCollection=new ArrayCollection();

override public function postEntryResultInit(mapObj:Object):void
{
	commonInit(mapObj);
}

override public function preEntryResultInit():Object
{
	/* XenosAlert.info("preEntryResultInit"); */
	addCommonKeys();
	return keylist;
}

override public function preResetEntry():void
{

	/* XenosAlert.info("preResetEntry"); */
	super.getResetHttpService().url="fam/closeEntryDeleteQuery.spring";
	//initializeCloseEntry.send();
}

private function addCommonKeys():void
{
	keylist=new ArrayCollection();
	keylist.addItem("closeTypeList.item");
	keylist.addItem("fromDate");

}

private function closeEntryScreen():void
{
	var params:Object=new Object();
	params['method']="submitQuery"; 
	params['commandFormId']=commandFormId;
	closeEntrySysConfirmRequest.send(params);
	 this.closeHandeler(); 
	 sPopup.removeEventListener(CloseEvent.CLOSE,closePopUp);
	 sPopup.removeMe();
}

private function commonInit(mapObj:Object):void
{
}


private function doBack():void
{
	//XenosAlert.info("Back Pressed");
	app.submitButtonInstance = submit;
	this.closedMonth.setFocus();
	vstack.selectedChild=qry;
}

private function doConfirm(event:MouseEvent):void
{
	 uConfSubmit.enabled=false;
	 back.enabled=false;
	 var params:Object=new Object();
	  app.submitButtonInstance=sConfSubmit;
	 this.sConfSubmit.setFocus(); 
	 params['method']="addAccountCloseDataUserConfirm"; 
	 params['commandFormId']=commandFormId;
	 params['closingDate'] = this.closingDate.text;
	 params['closeType'] = this.closeType.selectedItem != null ? this.closeType.selectedItem.value : "";
	 params['fundCode'] = this.fundPopUp.fundCode.text;
	 params['SCREEN_KEY']="12124";
	 closeEntryConfirmRequest.send(params);
}

private function faultAlert(event:FaultEvent):void {
    	uConfSubmit.enabled=true;
    	back.enabled=true;
    	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred.initialize') + event.fault.faultString)
    }

private function doSysConfirm(event:MouseEvent):void
{
	this.closeHandeler();
}
public function closeHandeler():void
{
	this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
}
private function initCloseEntryPage():void
{
	parseUrlString();
	this.closedMonth.setFocus();
	app.submitButtonInstance = submit;
	this.fundCodeGridRow.visible = false;
	this.fundCodeGridRow.includeInLayout = false;
	var params:Object=new Object();
	params['method']="addAccountCloseDataInit";
	params['commandFormId']=commandFormId;
	params['SCREEN_KEY']="12122";
	initializeCloseEntry.send(params);
}

private function initCloseEntryResultPage(event:ResultEvent):void
{

	var i:int=0;
	errPage.clearError(event);
	var commandForm:Object=event.result.closingQueryCommandForm;
	commandFormId=commandForm.commandFormId;
	fundPopUp.fundCode.text="";
	var closedDateStr:String = commandForm.closedDate;
	closedDateStr=closedDateStr!=null||closedDateStr.length==8?closedDateStr.substr(0,6):"";
	closingDate.text=commandForm.closingDateCrit != null ? commandForm.closingDateCrit : closedDateStr;
	initColl.removeAll();
	if (commandForm.closeTypeList.item != null)
	{
		if (commandForm.closeTypeList.item is ArrayCollection)
		{
			initColl=commandForm.closeTypeList.item as ArrayCollection;

		}
		else
			initColl.addItem(commandForm.closeTypeList.item);
	}
	tempColl=new ArrayCollection();
	tempColl.addItem({label: "", value: ""});
	for (i=0; i < initColl.length; i++)
	{
		tempColl.addItem(initColl[i]);
	}
	closeType.dataProvider=tempColl;
}

private function loadConfirmResultPage(event:ResultEvent):void
{
	//XenosAlert.info("confirmation");
	    uConfSubmit.enabled=true;
	    back.enabled=true;
	    errPageConf.clearError(event);
    	var errorInfoList:ArrayCollection=new ArrayCollection();
    	var xenosError: Object = event.result.XenosErrors;
    	if (xenosError!= null) {
    		
		   if (xenosError.Errors.error != null){
			 
			 if (xenosError.Errors.error is ArrayCollection) {
				 errorInfoList=xenosError.Errors.error as ArrayCollection;
			 } else { 
				 errorInfoList.addItem(xenosError.Errors.error);
			  }
		   }
		   errPageConf.showError(errorInfoList);
		   return;
	    } 
	    else {
			sysConfMessage.includeInLayout=true;
			sysConfMessage.visible=true;
			back.includeInLayout=false;
			back.visible=false;
			uConfSubmit.includeInLayout=false;
			uConfSubmit.visible=false;
			back.includeInLayout=false;
			back.visible=false;
			uConfLabel.visible=false;
			uConfLabel.includeInLayout=false;
			sConfLabel.visible=true;
			sConfLabel.includeInLayout=true;
			sConfSubmit.includeInLayout=true;
			sConfSubmit.visible=true;
	    }
}

private function loadSysConfirmResultPage(event:ResultEvent):void
{
/* 	XenosAlert.info("closeentry loadSysConfirmResultPage"); */
	//closeEntryScreen();
	this.closeHandeler();
}

private function onReset(event:MouseEvent):void
{
	var params:Object=new Object();
	params['method']="addAccountCloseDataInit";
	params['commandFormId']=commandFormId;
	initializeCloseEntry.send(params);
	this.fundCodeGridRow.visible = false;
	this.fundCodeGridRow.includeInLayout = false;
}

private function onSubmit(event:MouseEvent):void
{
	//Set the request parameters
	var requestObj:Object=populateRequestParams();
	closeEntryRequest.request=requestObj;
	var myModel:Object={closeEntry: {transClosingDate: this.closingDate.text}};
	var closeEntryDeleteValidator:FamCloseEntryDeleteValidator=new FamCloseEntryDeleteValidator();
	closeEntryDeleteValidator.source=myModel;
	closeEntryDeleteValidator.property="closeEntry";

	var validationResult:ValidationResultEvent=closeEntryDeleteValidator.validate();

	if (validationResult.type == ValidationResultEvent.INVALID)
	{
		var errorMsg:String=validationResult.message;
		//trace(errorMsg);
		XenosAlert.error(errorMsg);
	}
	else
	{
		if(this.closingDate.text =='') {
			XenosAlert.error(Application.application.xResourceManager.getKeyValue('fam.label.error.closemonth'));
		}
		else if(this.closeType.selectedIndex < 1) {
			XenosAlert.error(Application.application.xResourceManager.getKeyValue('fam.label.error.closetype'));
		} else if(XenosStringUtils.equals(this.closeType.selectedItem.value, FamConstants.TRANSACTION_TYPE_TRANSACTION_CLOSE) && XenosStringUtils.isBlank(this.fundPopUp.fundCode.text)) {
		 	XenosAlert.error(Application.application.xResourceManager.getKeyValue('fam.closeentry.error.fundcode.mandatory.transactionclose'));
		}			
		else {
			var params:Object=new Object();
			params['method']="addAccountCloseDataValidate";
			params['commandFormId'] = commandFormId;
			params['closingDate'] = this.closingDate.text;
			params['closeType'] = this.closeType.selectedItem.value;
			params['fundCode'] = this.fundPopUp.fundCode.text;
			params['SCREEN_KEY']="12123";
			params['menuPk']= this.parentApplication.mdiCanvas.getwindowKey();
			closeEntryRequest.send(params);
		}
	}
}

private function LoadResultPage(event:ResultEvent):void
{
	var rs:XML=XML(event.result);
	errPage.clearError(event);
	
	var errorInfoList:ArrayCollection=new ArrayCollection();
	if(!XenosStringUtils.equals(this.closeType.selectedItem.value, FamConstants.TRANSACTION_TYPE_TRANSACTION_CLOSE)) {
		this.fundCodeConfirm.visible = false;
		this.fundCodeConfirm.includeInLayout = false;
	} else {
		this.fundCodeConfirm.visible = true;
		this.fundCodeConfirm.includeInLayout = true;
	}
 	if (rs.child("Errors").length() > 0)
	{
		//populate the error info list              
		for each (var error:XML in rs.Errors.error)
		{
			errorInfoList.addItem(error.toString());
		}
		errPage.showError(errorInfoList); //Display the error
	}
	else
	{
		errPage.removeError();
		//var commandForm:Object=rs.closingQueryCommandForm;
		uConfClosingDate.text = rs.closedDate;
		uconCloseType.text = rs.closeType;
		uConfFundPopUp.text = rs.fundCode;
		vstack.selectedChild = rslt;
		app.submitButtonInstance = uConfSubmit;
		this.uConfSubmit.setFocus();
	}
}

private function populateRequestParams():Object
{
	var req:Object=new Object();
	return req;
}

public function closePopUp(event:CloseEvent):void{
	sPopup.removeEventListener(CloseEvent.CLOSE,closePopUp);
	sPopup.removeMe();
}

/**
* This method is called when the Closed Type is changed and performs the necesssary tasks
*/
private function onChangeClosedType():void {
	this.fundCodeGridRow.visible = true;
	this.fundCodeGridRow.includeInLayout = true;
	this.fundPopUp.fundCode.text = '';
	if(!XenosStringUtils.equals(this.closeType.selectedItem.value, FamConstants.TRANSACTION_TYPE_TRANSACTION_CLOSE)) {
		this.fundCodeGridRow.visible = false;
		this.fundCodeGridRow.includeInLayout = false;
	}
}  
