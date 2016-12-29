
import com.nri.rui.core.controls.XenosAlert;

import mx.collections.ArrayCollection;
import mx.containers.TitleWindow;
import mx.events.CloseEvent;
import mx.rpc.events.ResultEvent;
import com.nri.rui.core.Globals;
import flash.events.MouseEvent;
import com.nri.rui.core.startup.XenosApplication;
import mx.rpc.events.FaultEvent;
 
[Bindable]private var commandFormId: String="";
[Bindable]private var accountingClosingStatusPk: String="";
[Bindable]private var form:XML;
[Bindable]private var mode : String = "entry";	
[Bindable] public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
 public function initializeCancel():void {
       
     cancelSubmit.visible = true;
     cancelSubmit.includeInLayout = true;   
     cnclCntrlBtn.visible = true;
     cnclCntrlBtn.includeInLayout = true; 
	 app.submitButtonInstance = cancelSubmit;
	 this.cancelSubmit.setFocus(); 
  }
  
  
  private function handleSubmitDeleteResult(event:ResultEvent):void{
  	/* XenosAlert.info("closeentrydeleteview handleSubmitDeleteResult()"); */
  	var rs:XML = XML(event.result);
			//cancelSubmit.enabled=true;
			if (null != event) {
				 if(rs.child("Errors").length()>0) {
	                //some error found				 	
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
	                //populate the error info list 			 	
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	errPage.showError(errorInfoList);//Display the error
				 	errPage.setFocus();
				 } 
				 else {//result found	
				 	
				 	uConfLabel.includeInLayout=true;	
				 	uConfLabel.visible=true;
				 	confMsg.includeInLayout=true;
				 	confMsg.visible = true;				 	
				 	cancelSubmit.visible=false;
				 	cancelSubmit.includeInLayout=false;
				 	uCancelConfSubmit.includeInLayout=true;
				 	uCancelConfSubmit.visible=true;
				 	uCancel.includeInLayout=true;
				 	uCancel.visible=true;
				 	app.submitButtonInstance = uCancelConfSubmit;
					this.uCancelConfSubmit.setFocus();
				 }
	        }	 
  }
  
  private function doCancel():void{
  	parseUrlString();
  	var params:Object=new Object();  	
  	params['method']="submitCloseEntryCancel";
  	params["accountingClosingStatusPk"] = accountingClosingStatusPk;
	params['commandFormId']=commandFormId;
	params['SCREEN_KEY']="12125";
  	submitDelete.send(params); 
  }
  
  private function doSubmitUserConf():void{
  	uCancelConfSubmit.enabled=false;
  	uCancel.enabled=false;
	var params:Object=new Object();
	params['method']="cancelAccountCloseData";
	params['commandFormId']=commandFormId;
	params['SCREEN_KEY']="12126";
	confirmDelete.send(params);
 }
    
  private function faultAlert(event:FaultEvent):void {
    	uCancelConfSubmit.enabled=true;
    	uCancel.enabled=true;
    	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred.initialize') + event.fault.faultString)
    }
  
  private function  handleConfirmDeleteResult(event:ResultEvent):void{
  	/* XenosAlert.info("closeentrydeleteview handleConfirmDeleteResult()"); */
  	uCancelConfSubmit.enabled=true;
  	uCancel.enabled=true;
  	var rs:XML = XML(event.result);

	if (null != event) {
		 if(rs.child("Errors").length()>0) {
            //some error found				 	
		 	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);//Display the error
		 	errPage.setFocus();
		 } 
		 else {
		 	//result found
		 	
		 	uConfLabel.includeInLayout=false;
		 	uConfLabel.visible=false;
		 	sConfLabel.includeInLayout=true;
		 	sConfLabel.visible=true;
		 	CnfMessage.text = this.parentApplication.xResourceManager.getKeyValue('fam.closing.label.txncomplete');				 	
		 	uCancelConfSubmit.visible=false;
		 	uCancelConfSubmit.includeInLayout = false;
		 	uCancel.visible=false;
		 	uCancel.includeInLayout=false;
		 	sCancelConfSubmit.includeInLayout=true;
		 	sCancelConfSubmit.visible = true;
		 	
		 	//hide close button			 	
           	var titleWinInstance:TitleWindow = TitleWindow(this.parent.parent);
           	titleWinInstance.showCloseButton = false;
           	titleWinInstance.invalidateDisplayList();
           	app.submitButtonInstance = sCancelConfSubmit;
			this.sCancelConfSubmit.setFocus();
		 }
    }	
  }
  
  
private function doSysConfirm(event:Event):void {
	//this.closeHandeler();
	this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
	app.submitButtonInstance=null;
}

public function closeHandeler():void {
	this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
	app.submitButtonInstance=null;
}