





// ActionScript file for FAM Voucher Excel Upload Screen.

import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.utils.XenosStringUtils;

import flash.events.*;

import mx.collections.ArrayCollection;
import mx.containers.Panel;
import mx.controls.ProgressBar;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

public var AllTypes:FileFilter=new FileFilter("All Files (*.*)", "*.*");
public var documentTypes:FileFilter=new FileFilter("Excel Documents (*.xls)", "*.xls");
public var documentTypesXlsx:FileFilter=new FileFilter("Excel Documents (*.xlsx)", ("*.xlsx"));
[Bindable]
public var file:FileReference=new FileReference();
public var filelst:FileReferenceList=new FileReferenceList();
[Bindable]
private var commandForm:Object=new Object();

[Bindable]
private var commandFormId:String=XenosStringUtils.EMPTY_STR;

[Bindable]
private var currentPage:Number=0;
private var filetype:Array=new Array(documentTypes, documentTypesXlsx, AllTypes);
[Bindable]
private var navPage:uint=1;
[Bindable]
private var navSize:uint=10;
[Bindable]
private var noOfMsgCreatedStr:String="";
[Bindable]
private var pageSize:uint=10;
private var panel:Panel=new Panel();

private var requesturl:URLRequest;
[Bindable]
private var resultForm:Object=new Object();
[Bindable]
private var summaryResult:ArrayCollection=new ArrayCollection();
private var uploadProgress:ProgressBar=new ProgressBar();
[Bindable]
private var url:String=XenosStringUtils.EMPTY_STR;

public function bindAll():void
{
	qh.dgrid=confirmResultSummary;
	qh.resultHeader.text=this.parentApplication.xResourceManager.getKeyValue('fam.excel.upload.voucher.label.user.confirm');
	qh.sep1.visible=false;
	qh.sep1.includeInLayout=false;
	qh.btnNext.visible=false;
	qh.btnNext.includeInLayout=false;
	qh.btnPrev.visible=false;
	qh.btnPrev.includeInLayout=false;
}

public function browseFile():void
{
	filelst.addEventListener(Event.SELECT, selectHandler);
	filelst.browse(filetype);
}

public function confirmSubmitFile():void
{
	var reqObj:Object=new Object();
	reqObj.method="doSubmitConfirm";
	voucherFileLoadConfirm.request=reqObj;
	voucherFileLoadConfirm.send();
}


public function goToInitialPage():void
{
	summaryResult.removeAll();
	summaryResult.refresh();
	vstack.selectedChild = mt;
	file=new FileReference();
	filelst=new FileReferenceList();

	fc.__btnRemove_click(new MouseEvent("NONE"));
}

public function initCommandForm(event:ResultEvent):void
{

	commandForm=event.result.voucherUploadCommandForm;
	commandFormId=commandForm.commandFormId;
	url="fam/voucherUpload.spring?method=initPageForXLSUpLoad&commandFormId=" + commandFormId;
}

public function initOnPageLoad():void
{

	initializeVoucherUpload.url="fam/voucherUpload.spring?method=initPage";
	initializeVoucherUpload.send();
}

public function preset(event:ResultEvent):void
{
	panel.removeChild(uploadProgress);
	PopUpManager.removePopUp(panel);
	var result:XML=XML(event.result);
	resultForm=result;
	if (result.child("Message").length() > 0)
	{
		errPage.clearError(event);
		summaryResult.removeAll();
		try
		{
			confirmSubmitFileButton.enabled=true;
			errPage.clearError(event);
			summaryResult.removeAll();
			for each (var rec:XML in resultForm.Message)
			{
				summaryResult.addItem(rec);
			}
			vstack.selectedChild = cnf;
			qh.PopulateDefaultVisibleColumns();
			summaryResult.refresh();
		}
		catch (e:Error)
		{
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		}
	}
	else if (result.child("Errors").length() > 0)
	{
		//some error found
		errPage.removeError(); //clears the previous errors (if any)
		summaryResult.removeAll(); // clear previous data (if any as there is no result now).
		summaryResult.refresh(); // refresh data provider
		var errorInfoList:ArrayCollection=new ArrayCollection();
		//populate the error info list              
		for each (var error:XML in result.Errors.error)
		{
			errorInfoList.addItem(error.toString());
		}
		errPage.showError(errorInfoList); //Display the error
	}
	else
	{
		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('fam.excel.upload.norecordfound'));
		summaryResult.removeAll(); // clear previous data if any as there is no result now.
		summaryResult.refresh(); // refresh data provider
		errPage.removeError(); //clears the errors if any
	}

}

public function submitConfirmResult(event:ResultEvent):void
{
	if (event.result.XenosErrors != null)
	{
		vstack.selectedChild = mt;
		errPage.displayError(event);
	}
	else
	{
		vstack.selectedChild = submitCnf;
		var noOfMsgCreated:String=event.result.voucherUploadCommandForm.noOfMessageProcessed;
		noOfMsgCreatedStr=this.parentApplication.xResourceManager.getKeyValue('fam.excel.upload.voucher.label.uploadcomplete') + noOfMsgCreated;
	}
}

public function submitFile():void
{
	summaryResult.removeAll();
	summaryResult.refresh();
	errPage.clearError(new ResultEvent("NONE"));

	var postVariables:URLVariables=new URLVariables;
	var fname:String=file.name;
	requesturl=new URLRequest("fam/voucherUpload.spring?method=initPageForXLSUpLoad");
	requesturl.method="POST";
	requesturl.contentType="multipart/form-data";
	requesturl.data=postVariables;
	file.addEventListener(Event.COMPLETE, completeHandler);
	file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	file.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
	file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	file.upload(requesturl, "fileName");
}


public function unselectFile():void
{
	summaryResult.removeAll();
	summaryResult.refresh();
	file=new FileReference();
	filelst=new FileReferenceList();
	vstack.selectedChild = mt;
	errPage.clearError(new ResultEvent("NONE"));
	fc.__btnRemove_click(new MouseEvent("NONE"));
	initOnPageLoad()
}

private function completeHandler(event:Event):void
{
	var uploadCompleted:Event=new Event(Event.COMPLETE);
	voucherFileLoad.send();
}

/**
* This is for the Print button which at a  time will print all the data
* in the dataprovider of the Datagrid object
*/
private function doPrint():void
{
}

/**
* This will generate the Pdf report for the entire query result set
* and will open in a separate window.
*/
private function generatePdf():void
{
}

/**
* This will generate the Xls report for the entire query result set
* and will open in a separate window.
*/
private function generateXls():void
{
}

private function httpStatusHandler(event:HTTPStatusEvent):void
{
	if (event.status != 200)
	{
		XenosAlert.error(String(event));
	}

}

// only called if there is an  error detected by flash player browsing or uploading a file   
private function ioErrorHandler(event:IOErrorEvent):void
{
	XenosAlert.error(String(event));
}

private function openPopup(event:MouseEvent):void
{
	uploadProgress.width=180;
	uploadProgress.height=20;
	uploadProgress.indeterminate=true;
	uploadProgress.mode="event";
	uploadProgress.label="";

	panel.title=this.parentApplication.xResourceManager.getKeyValue('fam.excel.upload.voucher.label.loading');
	panel.height=47;
	panel.width=200;
	panel.setStyle("borderColor", "#FFFFFF");
	panel.setStyle("headerHeight", 25);
	panel.addChild(uploadProgress);

	PopUpManager.addPopUp(panel, this, true);
	PopUpManager.centerPopUp(panel);
}

// only called if a security error detected by flash player such as a sandbox violation
private function securityErrorHandler(event:SecurityErrorEvent):void
{
	XenosAlert.error(String(event));
}


private function selectHandler(event:Event):void
{
	if (event.currentTarget.fileList.length > 1)
	{
		mx.controls.Alert.show("Please select only One file", "Invalid Selection");
		return;
	}
	file=event.currentTarget.fileList[0];
	trace(file);
}

// function which is called when the upload screen is loaded(when user clicks on upload menu)
private function loadAll():void {
		vstack.selectedChild = mt;
}