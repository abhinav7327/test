
 // ActionScript file for FrxFxFileLoad
 
 	import com.nri.rui.core.controls.XenosAlert;
 	import com.nri.rui.core.utils.XenosStringUtils;
 	
 	import flash.events.*;
 	
 	import mx.collections.ArrayCollection;
 	import mx.containers.Panel;
 	import mx.controls.Alert;
 	import mx.controls.ProgressBar;
 	import mx.managers.PopUpManager;
 	import mx.rpc.events.ResultEvent;
 	import mx.utils.StringUtil;
	[Bindable]
	public var file:FileReference = new FileReference();
	public var filelst:FileReferenceList = new FileReferenceList();
	public var documentTypes:FileFilter = new FileFilter("Excel Documents (*.xls)", "*.xls");
	public var documentTypesFiltersXlsx:FileFilter = new FileFilter("Excel Documents (*.xlsx)",("*.xlsx"));
	public var AllTypes:FileFilter = new FileFilter("All Files (*.*)","*.*");
	private var filetype:Array = new Array(documentTypes,documentTypesFiltersXlsx,AllTypes);
	private var requesturl:URLRequest;
	
	[Bindable]private var currentPage:Number = 0;
    [Bindable]private var pageSize:uint = 10;
    [Bindable]private var navPage:uint = 1;
    [Bindable]private var navSize:uint = 10; 
	
	private var queryResult:ArrayCollection= new ArrayCollection();
	[Bindable]
    //private var summaryResult:XMLListCollection= new XMLListCollection();
    private var summaryResult:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var noOfMsgCreatedStr:String = "";
    private var panel:Panel = new Panel();
    private var uploadProgress: ProgressBar = new ProgressBar();
	
	public function browseFile():void
	{
		filelst.addEventListener(Event.SELECT, selectHandler);
		filelst.browse(filetype);
		
	}
	
	
	private function selectHandler(event:Event):void 
	{
		  if(event.currentTarget.fileList.length >1)
		  {
		  	mx.controls.Alert.show(this.parentApplication.xResourceManager.getKeyValue('frx.files.selectone'),"Invalid Selection");
		  	//btnRest.enabled = false;
			return;
		  }
		  //btnRest.enabled = true;
		  file = event.currentTarget.fileList[0];
		  trace(file);
//		  filePath.text = (FileReference)(event.currentTarget.fileList[0]).name;
		  //cnfPath.text = (FileReference)(event.currentTarget.fileList[0]).name;
	}
	
	public function submitFile():void
	{
		summaryResult.removeAll();
		summaryResult.refresh();
		errPage.clearError(new ResultEvent("NONE")); 
		/*if(filePath.text == "" )
		{
			XenosAlert.error("Please select One file to proceed");
			return;
		}*/
		
		
		
		
		/*if(filePath.text == "" )
		{
			XenosAlert.error("Please select One file to proceed");
			return;
		}*/
		/*var reqObj : Object = new Object();
	 	reqObj.fileName = this.file;
	 	fxFileLoad.contentType = "multipart/form-data";
	 	fxFileLoad.request = reqObj;
	 	fxFileLoad.url= "/frx/frxExecutionLoadDispatch.action?method=doSubmit" ;
		fxFileLoad.send();*/
		 
		
	var postVariables:URLVariables = new URLVariables;
		//postVariables.fileName = new FileReference();
		var fname:String = file.name;
		requesturl = new URLRequest("frx/frxExecutionLoadDispatch.action?method=init&unique="+new Date().getTime());
		requesturl.method = "POST";
		requesturl.contentType = "multipart/form-data";
		//requesturl.url = "/frx/frxExecutionLoadDispatch.action?method=doSubmit";
		requesturl.data = postVariables;
	
	//mx.controls.Alert.show("request " + requesturl);
	        file.addEventListener(Event.COMPLETE, completeHandler);
	        file.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
	        file.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandler);
	        file.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			file.upload(requesturl,"fileName");
		//requestObj.fileName:this.filelst[0];
	}
	
	// only called if there is an  error detected by flash player browsing or uploading a file   
	private function ioErrorHandler(event:IOErrorEvent):void{
	    //trace('And IO Error has occured:' +  event);
	     XenosAlert.error(String(event));
	}  
	
	// only called if a security error detected by flash player such as a sandbox violation
	private function securityErrorHandler(event:SecurityErrorEvent):void{
	    //trace("securityErrorHandler: " + event);
	     XenosAlert.error(String(event));
	}
	
	private function httpStatusHandler(event:HTTPStatusEvent):void {
	//        trace("httpStatusHandler: " + event);
	    if (event.status != 200){
	        XenosAlert.error(String(event));
	    }
	    
	}
	
	private function completeHandler(event:Event):void{
	    //trace('completeHanderl triggered');
	        var uploadCompleted:Event = new Event(Event.COMPLETE);
	        //XenosAlert.info(event.target.toString());
	        fxFileLoad.send();
	      //  dispatchEvent(uploadCompleted);
	    //mx.controls.Alert.show("work Done2");
	}  
	
	
	public function unselectFile():void
	{
		summaryResult.refresh();
		//filePath.text = "";
		//cnfPath.text = "";
		file = new FileReference();
		filelst = new FileReferenceList();
		//btnRest.enabled = false;
		mt.visible = true;
		mt.includeInLayout = true;
		cnf.includeInLayout=false;
		cnf.visible = false;
		errPage.clearError(new ResultEvent("NONE"));
		fc.__btnRemove_click(new MouseEvent("NONE"));
	}
	
	
	public function confirmFile():void
	{
		/*if(filePath.text == "" )
		{
			XenosAlert.error("Please select One file to proceed");
			return;
		}*/
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
	            qh.PopulateDefaultVisibleColumns();
			    
			}catch(e:Error){
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
	 
	 
	 /* public function prest(event:ResultEvent):void
	{
		if (null != event) {            
	        if(null == event.result.root){
	        	
	            summaryResult.removeAll(); // clear previous data if any as there is no result now.
	            if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
	                errPage.clearError(event); //clears the errors if any
	                XenosAlert.info("No Result Found!");
	            } else { // Must be error
	            	confirmResultSummary.visible = false;
	            	confirmResultSummary.includeInLayout = false;
	            	confirmSubmitFileButton.enabled = false;
	                errPage.displayError(event);    
	            }                
	        }else {
        		confirmResultSummary.visible = true;
            	confirmResultSummary.includeInLayout = true;
            	confirmSubmitFileButton.enabled = true;
	            errPage.clearError(event);                
	            summaryResult.removeAll();
	            if(event.result.root.Message != null){   
	            	
	            	
	            	if(event.result.root.Message is ArrayCollection) {
	                    summaryResult = event.result.root.Message as ArrayCollection;
	                }else {                            
	                     summaryResult.addItem(event.result.root.Message);
	                } 
	            }else{                    
	                XenosAlert.info("No Results Found");
	            } 
	            mt.includeInLayout=false;
				mt.visible = false;
				cnf.includeInLayout=true;
				cnf.visible = true;
	            //qh.setOnResultVisibility();
	            qh.PopulateDefaultVisibleColumns();                
	        }
	        summaryResult.refresh(); 
	    }else {
	        summaryResult.removeAll();
	        XenosAlert.info("No Results Found");
	    }
	}  */
	
	
	public function confirmSubmitFile():void {
		confirmSubmitFileButton.enabled = false;
		cxlUploadUC.enabled = false;
		var reqObj:Object = new Object();
		reqObj.method = "doSubmitConfirm";
		reqObj.unique = new Date().getTime()+"";
		fxFileLoadConfirm.request = reqObj;
		fxFileLoadConfirm.send();
	}
	
	public function submitConfirmResult(event:ResultEvent):void{
		confirmSubmitFileButton.enabled = true;
		cxlUploadUC.enabled = true;
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
			noOfMsgCreatedStr = this.parentApplication.xResourceManager.getKeyValue('frx.files.uploaded.complete') + noOfMsgCreated;
		}
	}
	
	/* public function submitConfirmResult(event:ResultEvent):void{
		cnf.includeInLayout=false;
		cnf.visible = false;
		if(event.result.XenosErrors != null){
			mt.includeInLayout=true;
			mt.visible = true;
			errPage.displayError(event);
		} else {
			submitCnf.visible = true;
			submitCnf.includeInLayout = true;
			var noOfMsgCreated:String = event.result.forexExecutionUploadActionForm.noOfMessageProcessed;
			noOfMsgCreatedStr ="Upload process completed successfully.  Message uploaded : " + noOfMsgCreated;
		}
	} */
	
	
	public function goToInitialPage():void{
		summaryResult.refresh(); 
		mt.includeInLayout=true;
		mt.visible = true;
		
		submitCnf.visible = false;
		submitCnf.includeInLayout = false;
		cnf.includeInLayout=false;
		cnf.visible = false;
		//filePath.text = "";
		//cnfPath.text = "";
		file = new FileReference();
		filelst = new FileReferenceList();
		
		fc.__btnRemove_click(new MouseEvent("NONE"));
		//btnRest.enabled = false;
	}
	
	public function bindAll():void{
		qh.dgrid = confirmResultSummary;
		qh.resultHeader.text = this.parentApplication.xResourceManager.getKeyValue('frx.files.uploaded.userconf');
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
       /*  var url : String = "frx/forexQueryDispatch.action?method=generateXLS";
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
         try {
                navigateToURL(request,"_blank");
            }
            catch (e:Error) {
                // handle error here
                trace(e);
            } */
    } 
    /**
    * This will generate the Pdf report for the entire query result set 
    * and will open in a separate window.
    */
     private function generatePdf():void {
       /*  var url : String = "frx/forexQueryDispatch.action?method=generatePDF";
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
         try {
                navigateToURL(request,"_blank");
            }
            catch (e:Error) {
                // handle error here
                trace(e);
            } */
    } 
    /**
    * This is for the Print button which at a  time will print all the data 
    * in the dataprovider of the Datagrid object
    */
     private function doPrint():void{
        /* var printObject:XenosPrintView = new XenosPrintView();
        printObject.frmPrintHeader.lbl.text = "Cam Movement Query";
        printObject.pDataGrid.dataProvider = movementSummary.dataProvider;
        PrintDG.printAll(printObject); */
    }
    
    private function openPopup(event:MouseEvent):void {
		uploadProgress.width = 180;
		uploadProgress.height = 20;
		uploadProgress.indeterminate = true;
		uploadProgress.mode = "event";
		uploadProgress.label = "";
		
		panel.title = this.parentApplication.xResourceManager.getKeyValue('frx.file.label.excel.loading');
		panel.height = 47;
		panel.width = 200;
		panel.setStyle("borderColor", "#FFFFFF");
		panel.setStyle("headerHeight", 25);
		panel.addChild(uploadProgress);
		
		PopUpManager.addPopUp(panel, this, true);
		PopUpManager.centerPopUp(panel);				
	}
	