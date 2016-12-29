




 // ActionScript file for TrdXLSFileLoad.mxml
 
 	import com.nri.rui.core.controls.XenosAlert;
 	import com.nri.rui.core.startup.XenosApplication;
 	
 	import flash.events.*;
 	
 	import mx.collections.ArrayCollection;
 	import mx.containers.Panel;
 	import mx.controls.Alert;
 	import mx.controls.ProgressBar;
 	import mx.managers.PopUpManager;
 	import mx.rpc.events.ResultEvent;
 	import mx.rpc.events.FaultEvent;
 	
	
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
		  	mx.controls.Alert.show(this.parentApplication.xResourceManager.getKeyValue('ncm.files.selectone'),"Invalid Selection");
			return;
		  }
		  file = event.currentTarget.fileList[0];
		  trace(file);
	}
	
	public function submitFile():void {
		//XenosAlert.info("error1");
		summaryResult.removeAll();
		summaryResult.refresh();
		errPage.clearError(new ResultEvent("NONE")); 
		var postVariables:URLVariables = new URLVariables;
		var fname:String = file.name;
		requesturl = new URLRequest("ncm/ncmXLSLoadDispatch.action?method=init&unique="+new Date().getTime());
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
        XenosAlert.info("error2:completeHandler");
        var uploadCompleted:Event = new Event(Event.COMPLETE);
        ncmFileLoad.send();
        XenosAlert.info("error3:completeHandler");
	}  
	
	
	public function unselectFile():void {
		summaryResult.removeAll();
		summaryResult.refresh();
		file = new FileReference();
		filelst = new FileReferenceList();
		vstack.selectedChild = mt;		
		errPage.clearError(new ResultEvent("NONE"));
		fc.__btnRemove_click(new MouseEvent("NONE"));
	}
	
	
	private function prest(event:ResultEvent):void {
    
    panel.removeChild(uploadProgress);
	PopUpManager.removePopUp(panel);
    
	var rs:XML = XML(event.result);
	if (null != event) {
		if(rs.child("Message").length()>0) {
			errPage.clearError(event);
            summaryResult.removeAll();
			try {
                confirmSubmitFileButton.enabled = true;
            	cancelSelect.visible = true;
            	cancelSelect.enabled = true;
	            errPage.clearError(event);                
	            summaryResult.removeAll();
		    	for each ( var rec:XML in rs.Message ) {
 				    summaryResult.addItem(rec);
			    }
	            vstack.selectedChild = cnf;
				numericStepperField.setFocus();
				app.submitButtonInstance = confirmSubmitFileButton;
	            qh.PopulateDefaultVisibleColumns();
			    summaryResult.refresh();
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
            	confirmSubmitFileButton.enabled = false;
			 	
            } else { // Must be error
               summaryResult.removeAll(); // clear previous data if any as there is no result now.
		       summaryResult.refresh(); // refresh data provider
               errPage.clearError(event); //clears the errors if any
               XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            }
		 	
		 } 
     }
	 
	 
	public function confirmSubmitFile():void {
		//XenosAlert.info("error1");
		confirmSubmitFileButton.enabled = false;
		cancelSelect.enabled = false;
		
		var reqObj:Object = new Object();
		reqObj.method = "doSubmitConfirm";
		reqObj.unique = new Date().getTime()+"";
		sConfSubmit.setFocus();
		app.submitButtonInstance = sConfSubmit;
		ncmFileLoadConfirm.request = reqObj;
		ncmFileLoadConfirm.send();
	}
	
	
	public function faultAlert(event:FaultEvent):void {
		confirmSubmitFileButton.visible = true;
		confirmSubmitFileButton.enabled = true;
		cancelSelect.visible = true;
		cancelSelect.enabled = true;
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred') + event.fault.faultString)
	}
	
	public function submitConfirmResult(event:ResultEvent):void {
		confirmSubmitFileButton.enabled = true;
		cancelSelect.enabled = true;
		var rs:XML = XML(event.result);
		if(rs.child("Errors").length()>0){
			vstack.selectedChild = mt;
			var errorInfoList : ArrayCollection = new ArrayCollection();
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);
		} else {
			vstack.selectedChild = submitCnf;
			var noOfMsgCreated:String = rs.noOfMessageProcessed;
			noOfMsgCreatedStr = this.parentApplication.xResourceManager.getKeyValue('ncm.files.uploaded.complete') + noOfMsgCreated;
		}
	}
	
	public function goToInitialPage():void {
		summaryResult.removeAll();
		summaryResult.refresh(); 
		vstack.selectedChild = mt;
		file = new FileReference();
		filelst = new FileReferenceList();
		fc.__btnRemove_click(new MouseEvent("NONE"));
	}
	
	public function bindAll():void {
		qh.dgrid = confirmResultSummary;
		qh.resultHeader.text = this.parentApplication.xResourceManager.getKeyValue('ncm.files.uploaded.userconf');
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
		
		panel.title = this.parentApplication.xResourceManager.getKeyValue('ncm.label.excel.loading');
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
	
	// function which is called when the upload screen is loaded(when user clicks on upload menu)
    private function loadAll():void {
	  vstack.selectedChild = mt;
    }