




import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosPopupUtils;

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.containers.Panel;
import mx.controls.ProgressBar;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;


	public var filelst:FileReferenceList = new FileReferenceList();
	public var documentTypes:FileFilter = new FileFilter("Excel Documents (*.xls)", "*.xls");
	public var documentTypesXlsx:FileFilter = new FileFilter("Excel Documents (*.xlsx)",("*.xlsx"));
	public var AllTypes:FileFilter = new FileFilter("All Files (*.*)","*.*");
	private var filetype:Array = new Array(documentTypes,documentTypesXlsx, AllTypes);
	private var requesturl:URLRequest;
	public var documentTypesFilters:FileFilter = new FileFilter("Documents (*.xls)",("*.xls"));
	public var documentTypesFiltersXlsx:FileFilter = new FileFilter("Documents (*.xlsx)",("*.xlsx"));
	private var queryResult:ArrayCollection= new ArrayCollection();
    private var uploadProgress: ProgressBar = new ProgressBar();
	private var panel:Panel = new Panel();
	
	[Bindable]public var summaryResult:ArrayCollection = new ArrayCollection();
	[Bindable]private var currentPage:Number = 0;
	[Bindable]private var pageSize:uint = 10;
	[Bindable]private var navPage:uint = 1;
	[Bindable]private var navSize:uint = 10;
	[Bindable]private var noOfMessageProcessed:String = "";
    [Bindable]public var file:FileReference = new FileReference();
    [Bindable]public var filter:Array = new Array(documentTypesFilters, documentTypesFiltersXlsx);
    [Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);


	/**
	 * This called when page loads.
	 */
	public function initPage():void {
		fc.btnUpload.addEventListener(MouseEvent.CLICK, openPopup);
		fxcPager.pageIndex = 0;
	}
	
	/**
	 * This is called when user clicks upload button after selecting the xls file.
	 */
	public function exchangeRateSubmitResultHaldler(event:ResultEvent):void {	
	    panel.removeChild(uploadProgress);
		PopUpManager.removePopUp(panel);	
		sysConfirmButtons.visible =	false;
		sysConfirmButtons.includeInLayout = false;
		okSystemConfButton.visible = false;
		okSystemConfButton.includeInLayout = false;
		sysConfirmResultSummary.includeInLayout = false;
		sysConfirmResultSummary.visible = false;	
		if (null != event) {            
	        if(null == event.result.ndfExchangeRateExcelUploadActionForm) {	        	
	            summaryResult.removeAll(); // clear previous data if any as there is no result now.
	            if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
	                errPage.clearError(event); //clears the errors if any
	                errPage1.clearError(event);
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
				confirmSubmitFileButton.setFocus();
			    app.submitButtonInstance = confirmSubmitFileButton;
	            errPage.clearError(event);
	            errPage1.clearError(event);                
	            summaryResult.removeAll();
	            if(event.result.ndfExchangeRateExcelUploadActionForm.exchangeRateRecords.exchangeRateRecord != null) {	            	
	            	if(event.result.ndfExchangeRateExcelUploadActionForm.exchangeRateRecords.exchangeRateRecord is ArrayCollection) {
	                    summaryResult = event.result.ndfExchangeRateExcelUploadActionForm.exchangeRateRecords.exchangeRateRecord as ArrayCollection;
	
	                } else {                            
	                     summaryResult.addItem(event.result.ndfExchangeRateExcelUploadActionForm.exchangeRateRecords.exchangeRateRecord);
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
	}

	public function bindAll():void{
	}

	/**
	 * This is called when Reset button is pressed. 
	 */
	public function unselectFile():void {
		summaryResult.refresh();
		file = new FileReference();
		filelst = new FileReferenceList();
		mt.visible = true;
		mt.includeInLayout = true;
		cnf.includeInLayout=false;
		cnf.visible = false;		
		errPage.clearError(new ResultEvent("NONE"));
		fc.__btnRemove_click(new MouseEvent("NONE"));
	}
	
	public function confirmSubmitFile():void {
		confirmSubmitFileButton.enabled = false;
		var reqObj:Object = new Object();
		reqObj.method = "doSubmitConfirm";
		reqObj.SCREEN_KEY = "12020";
		ndfExchageRateFileLoadConfirm.request = reqObj;
		ndfExchageRateFileLoadConfirm.send();
	}
	
	public function submitConfirmResult(event:ResultEvent):void {
		if(null == event.result.XenosErrors){
			subConfirmButtons.includeInLayout = false;
			subConfirmButtons.visible = false;
			sysConfirmButtons.visible = true;
			confirmResultSummary.includeInLayout = false;
			confirmResultSummary.visible = false;
			sysConfirmResultSummary.includeInLayout = true;
			sysConfirmResultSummary.visible = true;
			sysConfirmButtons.includeInLayout = true;
			sysConfirm.visible = true;
			sysConfirm.includeInLayout = true;
			okSystemConfButton.includeInLayout = true;
			okSystemConfButton.visible = true;
			okSystemConfButton.setFocus();
			app.submitButtonInstance = okSystemConfButton;
			errPage1.clearError(new ResultEvent("NONE"));
			var noOfMsgCreated:String = event.result.ndfExchangeRateExcelUploadActionForm.noOfMessageProcessed;
			noOfMessageProcessed = this.parentApplication.xResourceManager.getKeyValue('frx.ndfexchangerate.files.uploaded.success.msg') + noOfMsgCreated;
		} else {	
			confirmResultSummary.includeInLayout = true;
			confirmResultSummary.visible = true;
			sysConfirmResultSummary.includeInLayout = false;
			sysConfirmResultSummary.visible = false;	
			errPage1.displayError(event);
		}
	}
	public function goToInitialPage():void {
		summaryResult.refresh(); 
		mt.includeInLayout=true;
		mt.visible = true;
		
		sysConfirm.visible = false;
		sysConfirm.includeInLayout = false;
		sysConfirmResultSummary.includeInLayout = false;
		sysConfirmResultSummary.visible = false;	
		cnf.includeInLayout=false;
		cnf.visible = false;
		file = new FileReference();
		filelst = new FileReferenceList();
		fc.__btnRemove_click(new MouseEvent("NONE"));		
	}

	/**
	 * Opens the Order Entry Errors Popup for Save & Print
	 * 
	 */
	public function saveAndPrint():void {
	    XenosPopupUtils.showOrderEntryErrors(this);		
	}
	private function openPopup(event:MouseEvent):void {
		uploadProgress.width = 180;
		uploadProgress.height = 20;
		uploadProgress.indeterminate = true;
		uploadProgress.mode = "event";
		uploadProgress.label = "";
		
		panel.title = this.parentApplication.xResourceManager.getKeyValue('frx.exchangerate.label.excel.loading');
		panel.height = 47;
		panel.width = 200;
		panel.setStyle("borderColor", "#FFFFFF");
		panel.setStyle("headerHeight", 25);
		panel.addChild(uploadProgress);
		
		PopUpManager.addPopUp(panel, this, true);
		PopUpManager.centerPopUp(panel);				
	}

