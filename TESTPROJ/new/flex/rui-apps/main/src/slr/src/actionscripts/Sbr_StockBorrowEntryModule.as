
 
	import com.nri.rui.core.controls.XenosAlert;
 	import com.nri.rui.core.utils.OnDataChangeUtil;
 	import com.nri.rui.core.utils.HiddenObject;
 	
	import flash.events.*;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	import mx.controls.ProgressBar;
 	import mx.managers.PopUpManager;
 	import mx.containers.Panel;
 	
	[Bindable]
	public var file:FileReference = new FileReference();
	public var filelst:FileReferenceList = new FileReferenceList();
	public var documentTypes:FileFilter = new FileFilter("Excel Documents (*.xls)", "*.xls");
	public var documentTypesFiltersXlsx:FileFilter = new FileFilter("Excel Documents (*.xlsx)",("*.xlsx"));
	public var AllTypes:FileFilter = new FileFilter("All Files (*.*)","*.*");
	private var filetype:Array = new Array(documentTypes,documentTypesFiltersXlsx,AllTypes);
	private var requesturl:URLRequest;
	private var uploadProgress: ProgressBar = new ProgressBar();
	private var panel:Panel = new Panel();
	
	[Bindable]private var currentPage:Number = 0;
    [Bindable]private var pageSize:uint = 50;
    [Bindable]private var navPage:uint = 1;
    [Bindable]private var navSize:uint = 10; 
	
	private var queryResult:ArrayCollection= new ArrayCollection();
	[Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
	[Bindable] private var summaryResult:ArrayCollection = new ArrayCollection();
    [Bindable] private var noOfTxnStr:String = "";
    
	public function browseFile():void {
		filelst.addEventListener(Event.SELECT, selectHandler);
		filelst.browse(filetype);
	}
	
	private function selectHandler(event:Event):void {
		if(event.currentTarget.fileList.length >1) {
			mx.controls.Alert.show(this.parentApplication.xResourceManager.getKeyValue('borrow.excel.upload.select1file.info'), "Invalid Selection");
			return;
		}
		file = event.currentTarget.fileList[0];
		trace(file);
	}
	
	public function unselectFile():void {
		fc.btnUpload.enabled = false;
		
		file = new FileReference();
		filelst = new FileReferenceList();
		mt.visible = true;
		mt.includeInLayout = true;
		cnf.includeInLayout=false;
		cnf.visible = false;
		errPage.clearError(new ResultEvent("NONE"));
		fc.__btnRemove_click(new MouseEvent("NONE"));
		pageSize = 50;
	}
	
	public function confirmFile():void {
		mt.includeInLayout=false;
		mt.visible = false;
		cnf.includeInLayout=true;
		cnf.visible = true;
	}
		
	private function submitResult(event:ResultEvent):void {
	
		var rs:XML = XML(event.result);
		
		if (null != event) {
			if(rs.child("securities").length()>0) {
				errPage.removeError();
				summaryResult.removeAll();
				try {
					qh.resultHeader.text = this.parentApplication.xResourceManager.getKeyValue('borrow.label.stockborrow.userconfirmation');
					
					var softWarningList:ArrayCollection = new ArrayCollection();
					for each(var obj:Object in rs.softExceptionList.item){
						softWarningList.addItem(obj.value);
					}
					softWarn.showWarning(softWarningList);
					
	                confirmResultSummary.visible = true;
	            	confirmResultSummary.includeInLayout = true;
	            	confirmSubmitFileButton.enabled = true;
		 			cancelSubmitFileButton.enabled = true;
		            summaryResult.removeAll();
			    	for each ( var rec:XML in rs.securities.security ) {
	 				    summaryResult.addItem(rec);
				    }
		            mt.includeInLayout=false;
					mt.visible = false;
					cnf.includeInLayout=true;
					cnf.visible = true;
					submitCnf.visible = false;
					submitCnf.includeInLayout = false;
					sysCnfButton.visible = false;
					sysCnfButton.includeInLayout = false;
					submitCnfButton.visible = true;
					submitCnfButton.includeInLayout = true;
					refnoforentry.visible = false;
					qh.PopulateDefaultVisibleColumns();
				} catch (e:Error) {
					XenosAlert.error(e.message);
				    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			    }
			} else if(rs.child("Errors").length()>0) {
				
				//some error found
				summaryResult.removeAll(); // clear previous data if any as there is no result now.
				var errorInfoList : ArrayCollection = new ArrayCollection();
				//populate the error info list
				for each (var error:XML in rs.Errors.error) {
					errorInfoList.addItem(error.toString());
				}
				
				errPage.showError(errorInfoList);//Display the error
				confirmResultSummary.visible = false;
				confirmResultSummary.includeInLayout = false;
				confirmSubmitFileButton.enabled = false;
				refnoforentry.visible = false;
				
			} else { // Must be error
				errPage.removeError();
				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			}
		} 
	}
	 
	public function confirmSubmitFile():void {
		var reqObj:Object = new Object();
		reqObj.method = "doSubmitConfirm";
		reqObj.unique = new Date().getTime()+"";
		reqObj.SCREEN_KEY = "11150";
		fileLoadConfirm.request = reqObj;
		confirmSubmitFileButton.enabled = false;
		cancelSubmitFileButton.enabled = false;
		fileLoadConfirm.send();
	}
	
	public function submitConfirmResult(event:ResultEvent):void {
		var rs:XML = XML(event.result);
		if(rs.child("Errors").length()>0) {
			var errorInfoList : ArrayCollection = new ArrayCollection();
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);
		 	submitCnf.includeInLayout = false;
		 	submitCnf.visible = false;
		 	confirmSubmitFileButton.enabled = true;
		 	cancelSubmitFileButton.enabled = true;
		} else {
			summaryResult.removeAll();
			for each (var rec:XML in rs.securities.security) 
			{
 			    summaryResult.addItem(rec);
		    }
		    summaryResult.refresh();
			qh.resultHeader.text = this.parentApplication.xResourceManager.getKeyValue('borrow.label.stockborrow.systemconfirmation');
			
			softWarn.removeWarning();
			submitCnf.visible = true;
			submitCnf.includeInLayout = true;
			submitCnfButton.includeInLayout = false;
			submitCnfButton.visible = false;
			sysCnfButton.visible = true;
			sysCnfButton.includeInLayout = true;
			refnoforentry.visible = true;
			qh.PopulateDefaultVisibleColumns();
			var noOfTxn:String = rs.txnCount;
			noOfTxnStr = this.parentApplication.xResourceManager.getKeyValue('borrow.excel.upload.processcomplete.message')+noOfTxn;
		}
	}
	
	public function goToInitialPage():void {
		fc.btnUpload.enabled = false;
		mt.includeInLayout=true;
		mt.visible = true;
		
		submitCnf.visible = false;
		submitCnf.includeInLayout = false;
		cnf.includeInLayout=false;
		cnf.visible = false;

		errPage.clearError(new ResultEvent("NONE"));
		fc.__btnRemove_click(new MouseEvent("NONE"));
		fxcPager.pageIndex = 0;
		
	}
	
	public function bindAll():void {
		qh.dgrid = confirmResultSummary;
		qh.sep1.visible = false;
		qh.sep1.includeInLayout = false;
		qh.btnNext.visible = false;
		qh.btnNext.includeInLayout = false;
		qh.btnPrev.visible = false;
		qh.btnPrev.includeInLayout = false;
	}
	
	
	
	/**
     * This will generate the Xls report for the entire query result set 
     * and will open in a separate window.
     */
    private function generateXls():void {
     	
    } 
    
    /**
     * This will generate the Pdf report for the entire query result set 
     * and will open in a separate window.
     */
    private function generatePdf():void {
     	
    }
    
    /**
     * This is for the Print button which at a  time will print all the data 
     * in the dataprovider of the Datagrid object
     */
    private function doPrint():void {
    	
    }
    
	/**
	 * Method to prepare the context for Fund Account popup 
	 */
	  
