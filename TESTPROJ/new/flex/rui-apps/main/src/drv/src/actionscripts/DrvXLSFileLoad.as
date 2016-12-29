
 // ActionScript file for TrdXLSFileLoad.mxml
 
 	import com.nri.rui.core.controls.XenosAlert;
 	import com.nri.rui.core.utils.XenosStringUtils;
 	import com.nri.rui.core.startup.XenosApplication;
 	import flash.events.*;
 	import mx.containers.Panel;
 	import mx.controls.ProgressBar;
 	import mx.managers.PopUpManager;
 	import mx.collections.ArrayCollection;
 	import mx.controls.Alert;
 	import mx.rpc.events.ResultEvent;
 	import mx.utils.StringUtil;
	
	public var filelst:FileReferenceList = new FileReferenceList();
	public var documentTypes:FileFilter = new FileFilter("Excel Documents (*.xls)", "*.xls");
	public var documentTypesXlsx:FileFilter = new FileFilter("Excel Documents (*.xlsx)",("*.xlsx"));
	public var AllTypes:FileFilter = new FileFilter("All Files (*.*)","*.*");
	private var filetype:Array = new Array(documentTypes, documentTypesXlsx, AllTypes);
	private var requesturl:URLRequest;
	public var documentTypesFilters:FileFilter = new FileFilter("Documents (*.xls)",("*.xls"));
	public var documentTypesFiltersXlsx:FileFilter = new FileFilter("Documents (*.xlsx)",("*.xlsx"));
	private var queryResult:ArrayCollection= new ArrayCollection();
	
	[Bindable]private var currentPage:Number = 0;
    [Bindable]private var pageSize:uint = 10;
    [Bindable]private var navPage:uint = 1;
    [Bindable]private var navSize:uint = 10; 
    [Bindable]private var summaryResult:ArrayCollection = new ArrayCollection();
    [Bindable]private var noOfMsgCreatedStr:String = "";
    [Bindable]public var file:FileReference = new FileReference();
    [Bindable]public var filter:Array = new Array(documentTypesFilters, documentTypesFiltersXlsx);
    [Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
	
	private var panel:Panel = new Panel();
    private var uploadProgress: ProgressBar = new ProgressBar();
	
    
	
	public function browseFile():void {
		filelst.addEventListener(Event.SELECT, selectHandler);
		filelst.browse(filetype);
	}
	
	
	private function selectHandler(event:Event):void {
		  if(event.currentTarget.fileList.length >1) {
		  	mx.controls.Alert.show(this.parentApplication.xResourceManager.getKeyValue('drv.files.selectone'),"Invalid Selection");
			return;
		  }
		  file = event.currentTarget.fileList[0];
		  trace(file);
	}
	
	public function submitFile():void {
		summaryResult.removeAll();
		summaryResult.refresh();
		errPage.clearError(new ResultEvent("NONE")); 
		var postVariables:URLVariables = new URLVariables;
		var fname:String = file.name;
		requesturl = new URLRequest("drv/drvXLSLoadDispatch.action?method=init&unique="+new Date().getTime());
		requesturl.method = "POST";
		requesturl.contentType = "multipart/form-data";
		requesturl.data = postVariables;
        file.addEventListener(Event.COMPLETE, completeHandler);
        file.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
        file.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandler);
        file.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
		file.upload(requesturl,"fileName");
	}
	
	// only called if there is an  error detected by flash player browsing or uploading a file   
	private function ioErrorHandler(event:IOErrorEvent):void {
	    //trace('And IO Error has occured:' +  event);
	     XenosAlert.error(String(event));
	}  
	
	// only called if a security error detected by flash player such as a sandbox violation
	private function securityErrorHandler(event:SecurityErrorEvent):void {
	     XenosAlert.error(String(event));
	}
	
	private function httpStatusHandler(event:HTTPStatusEvent):void {
	    if (event.status != 200){
	        XenosAlert.error(String(event));
	    }
	}
	
	private function completeHandler(event:Event):void {
        var uploadCompleted:Event = new Event(Event.COMPLETE);
        drvFileLoad.send();
	}  
	
	
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
	
	
	public function confirmFile():void {
		mt.includeInLayout=false;
		mt.visible = false;
		cnf.includeInLayout=true;
		cnf.visible = true;
	}
	
	
	private function prest(event:ResultEvent):void {
    
    panel.removeChild(uploadProgress);
	PopUpManager.removePopUp(panel);
    
	var rs:XML = XML(event.result);
	if (null != event) {
		
		var softWarnList:ArrayCollection = new ArrayCollection();
		if(rs.child("softExceptionList").length()>0){
			var swxl:XMLList = rs.child("softExceptionList");
			for each ( var warn:XML in swxl.warning ) {
				softWarnList.addItem(warn);
			}
			softWarn.showWarning(softWarnList);
		} else {
			softWarn.removeWarning();
		}
		
		if(rs.child("Message").length()>0) {
			errPage.clearError(event);
            summaryResult.removeAll();
			try {
                confirmResultSummary.visible = true;
            	confirmResultSummary.includeInLayout = true;
            	confirmSubmitFileButton.enabled = true;
	            errPage.clearError(event);                
	            summaryResult.removeAll();
		    	for each ( var rec:XML in rs.Message ) {
 				    summaryResult.addItem(rec);
			    }
	            mt.includeInLayout=false;
				mt.visible = false;
				cnf.includeInLayout=true;
				cnf.visible = true;
				numericStepperField.setFocus();
				app.submitButtonInstance = confirmSubmitFileButton;
	            qh.PopulateDefaultVisibleColumns();
			    
			} catch(e:Error) {
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
            	errPage.clearError(event); //clears the errors if any
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            }
		 	
		 } 
     }
	 
	 
	public function confirmSubmitFile():void {
		var reqObj:Object = new Object();
		reqObj.method = "doSubmitConfirm";
		reqObj.unique = new Date().getTime()+"";
		sConfSubmit.setFocus();
		app.submitButtonInstance = sConfSubmit;
		drvFileLoadConfirm.request = reqObj;
		drvFileLoadConfirm.send();
	}
	
	public function submitConfirmResult(event:ResultEvent):void {
		softWarn.removeWarning();
		cnf.includeInLayout=false;
		cnf.visible = false;
		var rs:XML = XML(event.result);
		if(rs.child("Errors").length()>0){
			mt.includeInLayout=true;
			mt.visible = true;
			var errorInfoList : ArrayCollection = new ArrayCollection();
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);
		} else {
			submitCnf.visible = true;
			submitCnf.includeInLayout = true;
			var noOfMsgCreated:String = rs.noOfMessageProcessed;
			noOfMsgCreatedStr = this.parentApplication.xResourceManager.getKeyValue('drv.files.uploaded.complete') + noOfMsgCreated;
		}
	}
	
	public function goToInitialPage():void {
		summaryResult.refresh(); 
		mt.includeInLayout=true;
		mt.visible = true;
		
		submitCnf.visible = false;
		submitCnf.includeInLayout = false;
		cnf.includeInLayout=false;
		cnf.visible = false;
		file = new FileReference();
		filelst = new FileReferenceList();
		fc.__btnRemove_click(new MouseEvent("NONE"));
	}
	
	public function bindAll():void {
		qh.dgrid = confirmResultSummary;
		qh.resultHeader.text = this.parentApplication.xResourceManager.getKeyValue('drv.files.uploaded.userconf');
		qh.sep1.visible = false;
		qh.sep1.includeInLayout = false;
		qh.btnNext.visible = false;
		qh.btnNext.includeInLayout = false;
		qh.btnPrev.visible = false;
		qh.btnPrev.includeInLayout = false;
	}
	
	private function openPopup(event:MouseEvent):void {
		uploadProgress.width = 180;
		uploadProgress.height = 20;
		uploadProgress.indeterminate = true;
		uploadProgress.mode = "event";
		uploadProgress.label = "";
		
		panel.title = this.parentApplication.xResourceManager.getKeyValue('drv.label.excel.loading');
		panel.height = 47;
		panel.width = 200;
		panel.setStyle("borderColor", "#FFFFFF");
		panel.setStyle("headerHeight", 25);
		panel.addChild(uploadProgress);
		
		PopUpManager.addPopUp(panel, this, true);
		PopUpManager.centerPopUp(panel);				
	}
	
	/**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
    private function generateXls():void {
     	//NOP
    } 
    /**
    * This will generate the Pdf report for the entire query result set 
    * and will open in a separate window.
    */
    private function generatePdf():void {
      //NOP
    } 
    /**
    * This is for the Print button which at a  time will print all the data 
    * in the dataprovider of the Datagrid object
    */
    private function doPrint():void {
        //NOP
	}
	