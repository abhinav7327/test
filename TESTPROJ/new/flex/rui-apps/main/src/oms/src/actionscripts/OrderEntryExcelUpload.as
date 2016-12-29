// ActionScript file
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.utils.XenosPopupUtils;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.rpc.events.ResultEvent;

[Bindable]public var officeValues:ArrayCollection;
[Bindable]public var summaryResult:ArrayCollection = new ArrayCollection();
[Bindable]private var currentPage:Number = 0;
[Bindable]private var pageSize:uint = 10;
[Bindable]private var navPage:uint = 1;
[Bindable]private var navSize:uint = 10;
[Bindable]private var noOfMessageProcessed:String = "";

/**
 * This called when page loads.
 */
public function initPage():void {
	fc.addEventListener(MouseEvent.CLICK, buttonClickHandler)
	init.send();
	fxcPager.pageIndex = 0;
}

public function initResultHandler(event:ResultEvent):void {
	officeValues = new ArrayCollection();
	if (event.result.orderUploadActionForm.officeValue.item is ArrayCollection) {
		officeValues = event.result.orderUploadActionForm.officeValue.item as ArrayCollection;
		office.selectedItem = null;
		office.prompt = this.parentApplication.xResourceManager.getKeyValue('ref.comp.label.select');
		fc.btnAdd.enabled=false;
	} else {
		officeValues.addItem(event.result.orderUploadActionForm.officeValue.item);
		office.selectedItem = event.result.orderUploadActionForm.officeValue.item;
		fc.btnAdd.enabled = true;
	}
}

/**
 * This is called when user clicks upload button after selecting the xls file.
 */
public function orderSubmitResultHandler(event:ResultEvent):void {
	if (null != event) {            
        if(null == event.result.orderUploadActionForm) {	        	
            summaryResult.removeAll(); // clear previous data if any as there is no result now.
            if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
                errPage.clearError(event); //clears the errors if any
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            } else { // Must be error
            	confirmResultSummary.visible = false;
            	confirmResultSummary.includeInLayout = false;
            	confirmSubmitFileButton.enabled = false;
                errPage.displayError(event);    
            }                
        } else {
        	//XenosAlert.info("Root present");
        	confirmResultSummary.visible = true;
        	confirmResultSummary.includeInLayout = true;
        	confirmSubmitFileButton.enabled = true;
        	subConfirmButtons.includeInLayout = true;
			subConfirmButtons.visible = true;
            errPage.clearError(event);                
            summaryResult.removeAll();
            if(event.result.orderUploadActionForm.orderRecords.orderRecord != null) {	            	
            	if(event.result.orderUploadActionForm.orderRecords.orderRecord is ArrayCollection) {
                    summaryResult = event.result.orderUploadActionForm.orderRecords.orderRecord as ArrayCollection;
                } else {                            
                     summaryResult.addItem(event.result.orderUploadActionForm.orderRecords.orderRecord);
                }
            } else {                    
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            } 
            mt.includeInLayout=false;
			mt.visible = false;
			cnf.includeInLayout=true;
			cnf.visible = true;
        }
    } else {
        summaryResult.removeAll();
        XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
    }
    //Decide whether the save&print button will be displayed or not
    if(errPage.isError())  {
        btnSaveAndPrint.visible = true;
        btnSaveAndPrint.includeInLayout = true;        
    }else {
        btnSaveAndPrint.visible = false;
        btnSaveAndPrint.includeInLayout = false;         
    }  
}

public function bindAll():void{
}

/**
 * This is called when Reset button is pressed. 
 */
public function unselectFile():void {
	summaryResult.refresh();
	if (officeValues.length > 1) {
		office.selectedItem = null;
		office.prompt = this.parentApplication.xResourceManager.getKeyValue('ref.comp.label.select');
		fc.btnAdd.enabled=false;
	}
	mt.visible = true;
	mt.includeInLayout = true;
	cnf.includeInLayout=false;
	cnf.visible = false;
	
	btnSaveAndPrint.visible = false;
    btnSaveAndPrint.includeInLayout = false;
        
	errPage.clearError(new ResultEvent("NONE"));
	fc.__btnRemove_click(new MouseEvent("NONE"));
	fxcPager.pageIndex = 0;
}

public function confirmSubmitFile():void {
	var reqObj:Object = new Object();
	reqObj.method = "doSubmitConfirm";
	orderFileLoadConfirm.request = reqObj;
	orderFileLoadConfirm.send();
}

public function submitConfirmResult(event:ResultEvent):void {
	if(null == event.result.XenosErrors){
		subConfirmButtons.includeInLayout = false;
		subConfirmButtons.visible = false;
		sysConfirmButtons.visible = true;
		sysConfirmButtons.includeInLayout = true;
		sysConfirm.visible = true;
		sysConfirm.includeInLayout = true;
		errPage.clearError(new ResultEvent("NONE"));
		var noOfMsgCreated:String = event.result.orderUploadActionForm.noOfMessageProcessed;
		noOfMessageProcessed = this.parentApplication.xResourceManager.getKeyValue('oms.order.files.uploaded.success.msg') + noOfMsgCreated;
	} else {
		//XenosAlert.info("ERROR");
		errPage.displayError(event);
	}
}

public function goToInitialPage():void {
	summaryResult.removeAll();
	mt.visible = true;
	mt.includeInLayout = true;
	sysConfirm.includeInLayout = false;
	sysConfirm.visible = false;
	sysConfirmButtons.includeInLayout = false;
	sysConfirmButtons.visible = false;
	cnf.includeInLayout=false;
	cnf.visible = false;
	if (officeValues.length > 1) {
		office.selectedItem = null;
		office.prompt = this.parentApplication.xResourceManager.getKeyValue('ref.comp.label.select');
		fc.btnAdd.enabled=false;
	}
	errPage.clearError(new ResultEvent("NONE"));
	fc.__btnRemove_click(new MouseEvent("NONE"));
	fxcPager.pageIndex = 0;
}
/**
 * Opens the Order Entry Errors Popup for Save & Print
 * 
 */
public function saveAndPrint():void {
    XenosPopupUtils.showOrderEntryErrors(this);		
}

private function checkOffice():void {
	if (office.selectedItem != null) {
		fc.btnAdd.enabled = true;
	}
}