
 
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.utils.HiddenObject;
	import com.nri.rui.core.utils.OnDataChangeUtil;
	
	import flash.events.*;
	import flash.net.FileReference;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.events.ResultEvent;
	import mx.utils.StringUtil;
	
	[Bindable]
	public var file:FileReference = new FileReference();
	public var filelst:FileReferenceList = new FileReferenceList();
	public var documentTypes:FileFilter = new FileFilter("CSV Documents (*.csv)", "*.csv");
	public var AllTypes:FileFilter = new FileFilter("All Files (*.*)","*.*");
	private var filetype:Array = new Array(documentTypes,AllTypes);
	private var requesturl:URLRequest;
	
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
	
	
	
	
	public function confirmFile():void {
		mt.includeInLayout=false;
		mt.visible = false;
		cnf.includeInLayout=true;
		cnf.visible = true;
	}
	
	private function init():void{
		initPage();
		sbrPageInit.send();
		
		
	}
	
	private function initResult(event:ResultEvent):void{
		var rs:XML = XML(event.result);
		var fileTypeValueCol:ArrayCollection = new ArrayCollection();
		errPage.clearError(new ResultEvent("NONE"));
		if(rs!=null){
			// clearing the fields
			this.fundPopUp.fundCode.text = "";
			this.date.text = "";
			this.officeId.selectedIndex = 0;
			this.fileTypeList.selectedIndex = 0;
			this.fc.arrUploadFiles = new Array();
			this.fc.listFiles.dataProvider = this.fc.arrUploadFiles;
			for each(var obj:Object in rs.fileTypeValues.item){
			fileTypeValueCol.addItem(obj);
		}
		fileTypeList.dataProvider = fileTypeValueCol;
		
		var officeIdValueCol:ArrayCollection = new ArrayCollection();
		for each(var obj:Object in rs.officeIdValues.OfficeIdValue){
			officeIdValueCol.addItem(obj);
		}
		officeId.dataProvider = officeIdValueCol;
		}
		
		
		
	}
		
	private function submitResult(event:ResultEvent):void {
		var rs:XML = XML(event.result);
		if (null != event) {
			if(rs.child("dataViewList").length()>0) {
				errPage.removeError();
				summaryResult.removeAll();
				try {
					qh.resultHeader.text = this.parentApplication.xResourceManager.getKeyValue('borrow.label.csvupload.userconfirmation');
					var softWarningList:ArrayCollection = new ArrayCollection();
					for each(var obj:Object in rs.softExceptionList.item){
						softWarningList.addItem(obj.value);
					}
					softWarn.showWarning(softWarningList);
					
	                confirmResultSummary.visible = true;
	            	confirmResultSummary.includeInLayout = true;
	            	confirmSubmitFileButton.enabled = true;
		            summaryResult.removeAll();
			    	for each ( var rec:XML in rs.dataViewList.dataView ) {
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
				
			} else { // Must be error
				errPage.removeError();
				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			}
		} 
	}
	
	public function SubmitFiles():void {
		var reqObj:Object = new Object();
		reqObj.method = "doSubmit";
		reqObj.unique = new Date().getTime()+"";
		sbrFileLoad.request = reqObj;
		sbrFileLoad.send();
	}
	 
	public function confirmSubmitFile():void {
		var reqObj:Object = new Object();
		reqObj.method = "doConfirm";
		reqObj.unique = new Date().getTime()+"";
		fileLoadConfirm.request = reqObj;
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
		} else {
			qh.resultHeader.text = this.parentApplication.xResourceManager.getKeyValue('borrow.label.csvupload.systemconfirmation');
			softWarn.removeWarning();
			submitCnf.visible = true;
			submitCnf.includeInLayout = true;
			submitCnfButton.includeInLayout = false;
			submitCnfButton.visible = false;
			sysCnfButton.visible = true;
			sysCnfButton.includeInLayout = true;
			noOfTxnStr = this.parentApplication.xResourceManager.getKeyValue('borrow.csv.upload.processcomplete.message');
		}
	}
	
	public function goToInitialPage():void {
		
		//fc.btnUpload.enabled = false;
		mt.includeInLayout=true;
		mt.visible = true;
		
		submitCnf.visible = false;
		submitCnf.includeInLayout = false;
		cnf.includeInLayout=false;
		cnf.visible = false;

		errPage.clearError(new ResultEvent("NONE"));
		//fc.__btnRemove_click(new MouseEvent("NONE"));
		fxcPager.pageIndex = 0;
		init();
		/* fundAcc.accountNo.text ="";
		fundAccName.text = ""; */
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
	
	 private function doBack():void{
        //fc.btnUpload.enabled = false;
		mt.includeInLayout=true;
		mt.visible = true;
		
		submitCnf.visible = false;
		submitCnf.includeInLayout = false;
		cnf.includeInLayout=false;
		cnf.visible = false;

		errPage.clearError(new ResultEvent("NONE"));
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
    
	