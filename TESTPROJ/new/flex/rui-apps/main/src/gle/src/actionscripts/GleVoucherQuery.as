
 // ActionScript file for Gle Voucher Query
 

    import com.nri.rui.core.Globals;
    import com.nri.rui.core.RendererFectory;
    import com.nri.rui.core.containers.SummaryPopup;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.renderers.ImgSummaryRenderer;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.ProcessResultUtil;
    import com.nri.rui.core.utils.XenosStringUtils;
    import com.nri.rui.gle.validators.GleVoucherValidator;
    
    import flash.events.Event;
    
    import mx.collections.ArrayCollection;
    import mx.controls.dataGridClasses.DataGridColumn;
    import mx.core.UIComponent;
    import mx.events.ValidationResultEvent;
    import mx.managers.PopUpManager;
    import mx.rpc.events.ResultEvent;
    import mx.utils.StringUtil;
    
    
    
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    
    [Bindable]public var mode:String="QUERY";
    
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();

    /**
	 * This method should be called on creationComplete of the datagrid 
	 */ 
	 private function bindDataGrid():void {
	 	/* if(this.mode=="CANCEL"){
	 		addColumn();
	 	} */
		qh.dgrid = resultSummary;
	} 
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    private function initPageStart():void { 
    	parseUrlString();
    	if(mode=="QUERY"){           
	        if (!initCompFlg) {    
	            rndNo= Math.random();
	            var req : Object = new Object();
	   			req.SCREEN_KEY = 295;
	    	    initializeGleVoucherQuery.request = req;         
	            initializeGleVoucherQuery.url = "gle/gleVoucherQuery.action?method=initialExecute&rnd=" + rndNo;                    
	            initializeGleVoucherQuery.send();
	        } else
	            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.initiate'));
	    }
	    else if(mode=="CANCEL"){  
	    		if (!initCompFlg) {    
	    		this.addEventListener("cancelReset",resetQuery);
	            rndNo= Math.random();
	            var req : Object = new Object();
	   			req.SCREEN_KEY = 295;
	   			req.mode= "cancel";
	    	    initializeGleVoucherQuery.request = req;         
	            initializeGleVoucherQuery.url = "gle/gleVoucherCancelQuery.action?method=initialExecute&rnd=" + rndNo;                    
	            initializeGleVoucherQuery.send();
	        } else
	            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.initiate'));
	    }
	    
    }
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * 
    */   
    private function initPage(event: ResultEvent) : void {
        var i:int = 0;
        var dateStr:String = null;
        var initColl:ArrayCollection = new ArrayCollection();
        var tempColl: ArrayCollection;
         errPage.clearError(event);
        
        //initiate text fields
        refNo.text = "";
        refNo.setFocus();
        cxlRefNo.text = "";
        currency.ccyText.text = "";
        externalRefNo.text = "";
        batchFileNo.text ="";
        transactionDate.text ="";
        bookDate.text ="";
        trialBalancePopUp.trialBalanceId.text ="";
        entryby.employeeText.text = "";
        entrydateFrom.text ="";
        entrydateTo.text ="";
        updateby.employeeText.text = "";
        updatedateFrom.text ="";
        updatedateTo.text ="";        
        //Initialize Status.
        initColl.removeAll();
        if(XenosStringUtils.equals(StringUtil.trim(event.result.XenosErrors.pageSummary.status),'Y')) {        	 
     		 errPage.displayError(event); 
     	} 
        if(event.result.gleVoucherQueryActionForm.statusValues.item != null) {
            if(event.result.gleVoucherQueryActionForm.statusValues.item is ArrayCollection) {
                initColl = event.result.gleVoucherQueryActionForm.statusValues.item as ArrayCollection;
            }			              
            else{
                initColl.addItem(event.result.gleVoucherQueryActionForm.statusValues.item);
            }
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        status.dataProvider = tempColl;
        
        //Initialize Status.
        initColl.removeAll();
        if(event.result.gleVoucherQueryActionForm.trialValues.item != null) {
            if(event.result.gleVoucherQueryActionForm.trialValues.item is ArrayCollection)
                initColl = event.result.gleVoucherQueryActionForm.trialValues.item as ArrayCollection;
            else
                initColl.addItem(event.result.gleVoucherQueryActionForm.trialValues.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        //trialBalanceId.dataProvider = tempColl;
        
              
    }
    /**
    * It sends/submits the query. 
    * 
    */
    private function submitQuery():void 
    {  
    	//Reset Page No
    	 qh.resetPageNo();
    	//Set the request parameters
         var requestObj :Object = populateRequestParams();
         
         gleVoucherQueryRequest.request = requestObj; 
         
        var myModel:Object={
                            gleVoucher:{
								transactionDate:this.transactionDate.text,
         						bookDate:this.bookDate.text,
                                entrydateFrom:this.entrydateFrom.text,
						        entrydateTo:this.entrydateTo.text,						         
						        updatedateFrom:this.updatedateFrom.text,
						        updateDateTo:this.updatedateTo.text     
                            }
                           }; 
        var gleVoucherValidate:GleVoucherValidator =new GleVoucherValidator();
        gleVoucherValidate.source=myModel;
        gleVoucherValidate.property="gleVoucher";
        var validationResult:ValidationResultEvent =gleVoucherValidate.validate();

        
        if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
            //resultHead.text = "";
           
        }else {
            if(this.mode=="CANCEL"){
            	gleVoucherQueryRequest.url="gle/gleVoucherCancelQuery.action?"
            }
             else if(this.mode=="QUERY"){
            	gleVoucherQueryRequest.url="gle/gleVoucherQuery.action?"
            }
            gleVoucherQueryRequest.send();   
        }      
    }
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	 var reqObj : Object = new Object();
    	 reqObj.SCREEN_KEY = 296;
         reqObj.method = "submitQuery";
         reqObj.referenceNumber = this.refNo.text;
         if(this.mode!='CANCEL'){
         	reqObj.cxlReferenceNumber = this.cxlRefNo.text;
         	reqObj.status = (this.status.selectedItem != null ? this.status.selectedItem.value : "");
         }
         reqObj.currency = this.currency.ccyText.text;
         reqObj.extReferenceNumber = this.externalRefNo.text;
         reqObj.batchFileNumber = this.batchFileNo.text;
         reqObj.transactionDate = this.transactionDate.text;
         reqObj.bookDate = this.bookDate.text;
         reqObj.trial = this.trialBalancePopUp.trialBalanceId.text;
         reqObj.enterBy = this.entryby.employeeText.text;
         reqObj.appiDateFrom = this.entrydateFrom.text;
         reqObj.appiDateTo = this.entrydateTo.text;
         reqObj.updateBy = this.updateby.employeeText.text;
         reqObj.updateDateFrom = this.updatedateFrom.text;
         reqObj.updateDateTo = this.updatedateTo.text;         
         reqObj.rnd = Math.random() + "";
         
         return reqObj;;
    }
    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
     private function doNext():void {
     	 var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
        gleVoucherQueryRequest.request = reqObj;
        gleVoucherQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
     	var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        gleVoucherQueryRequest.request = reqObj;
        gleVoucherQueryRequest.send()
    }
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
    private function resetQuery(e:Event=null):void { 
    	 if(this.mode=="CANCEL"){
            	gleVoucherResetQueryRequest.url="gle/gleVoucherCancelQuery.action?method=initialExecute&mode=cancel"
           }
           else if(this.mode=="QUERY"){
            	gleVoucherResetQueryRequest.url="gle/gleVoucherQuery.action?method=resetQuery"
           }
        gleVoucherResetQueryRequest.send();
    }
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    private function loadSummaryPage(event:ResultEvent):void {
    	
     	//changeColumnOrder(event);
		var rs:XML = XML(event.result);
	
		if (null != event) {
			if(rs.child("row").length()>0) {
				errPage.clearError(event);
	            summaryResult.removeAll();
				try {
				    for each ( var rec:XML in rs.row ) {
	 				    summaryResult.addItem(rec);
				    }
				    
				    changeCurrentState();
		            qh.setOnResultVisibility();
		            
		            qh.setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
		            qh.PopulateDefaultVisibleColumns();
	     	        //replace null objects in datagrid with empty string
	            	summaryResult=ProcessResultUtil.process(summaryResult,resultSummary.columns);
	            	if(summaryResult.length==1){
		             	//var detailRenderer:TradeDetailRenderer =new TradeDetailRenderer();
		             	//detailRenderer.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		             	displayDetailView(summaryResult[0].voucherPk);
	             }
	             summaryResult.refresh();
				}catch(e:Error){
				    //XenosAlert.error(e.toString() + e.message);
				    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			    }
			 } else if(rs.child("Errors").length()>0) {
                //some error found
			 	summaryResult.removeAll(); // clear previous data if any as there is no result now.
			 	var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list 			 	
			 	for each ( var error:XML in rs.Errors.error ) {
	 			   errorInfoList.addItem(error.toString());
				}
			 	errPage.showError(errorInfoList);//Display the error
			 } else {
			 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			 	summaryResult.removeAll(); // clear previous data if any as there is no result now.
			 	errPage.removeError(); //clears the errors if any
			 }
		
        }
     }

    
    private function displayDetailView(voucherPk:String):void{
    	
			var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
			
			sPopup.title = "Voucher Detail";
			sPopup.width = parentApplication.width - 100;    		
			sPopup.height = parentApplication.height - 100;
			PopUpManager.centerPopUp(sPopup);
    		sPopup.moduleUrl = Globals.GLE_VOUCHER_QUERY_DETAILS_SWF + Globals.QS_SIGN + Globals.GLE_VOUCHER_PK + Globals.EQUALS_SIGN+voucherPk;;;
			
    }
    
    /**
	 * Loading the initial configuaration.
	 * 
	 */
	private function loadAll():void {
    }
    
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
     	var url : String;
     	 if(this.mode=="CANCEL"){
            	url = "gle/gleVoucherCancelQuery.action?method=generateXLS";
            }
             else if(this.mode=="QUERY"){
            	url = "gle/gleVoucherQuery.action?method=generateXLS";
            }
    	
    	var request:URLRequest = new URLRequest(url);
    	request.method = URLRequestMethod.POST;
    	// set menu pk in the request
      	var variables:URLVariables = new URLVariables();
      	variables.menuPk = this.parentApplication.mdiCanvas.getwindowKey();
      	request.data = variables;
    	 try {
                navigateToURL(request,"_blank");
            }
            catch (e:Error) {
                // handle error here
                trace(e);
            }
    } 
    /**
    * This will generate the Pdf report for the entire query result set 
    * and will open in a separate window.
    */
     private function generatePdf():void {
    	var url : String = "";
    	if(this.mode=="CANCEL"){
            	url = "gle/gleVoucherCancelQuery.action?method=generatePDF";
        }
        else if(this.mode=="QUERY"){
            	url = "gle/gleVoucherQuery.action?method=generatePDF";
         }
    	
    	var request:URLRequest = new URLRequest(url);
    	request.method = URLRequestMethod.POST;
    	// set menu pk in the request
      	var variables:URLVariables = new URLVariables();
      	variables.menuPk = this.parentApplication.mdiCanvas.getwindowKey();
      	request.data = variables;
    	 try {
                navigateToURL(request,"_blank");
            }
            catch (e:Error) {
                // handle error here
                trace(e);
            }
    } 
    
    
     /**
             * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
             * 
             */ 
            public function parseUrlString():void {
            	
                try {
                    // Remove everything before the question mark, including
                    // the question mark.
                    var myPattern:RegExp = /.*\?/; 
                    var s:String = this.loaderInfo.url.toString();
                    //XenosAlert.info("Load Url : "+ this.loaderInfo.url.toString());
                    s = s.replace(myPattern, "");
                    // Create an Array of name=value Strings.
                    var params:Array = s.split(Globals.AND_SIGN); 
                     // Print the params that are in the Array.
                    var keyStr:String;
                    var valueStr:String;
                    var paramObj:Object = params;
                  
                    // Set the values of the salutation.
                    if(params != null){
	                    for (var i:int = 0; i < params.length; i++) {
	                        var tempA:Array = params[i].split("=");  
	                        if (tempA[0] == "mode") {	                            
	                            mode = tempA[1];	                          
	                        }
	                    }                    	
                    }else{
                    	mode = "QUERY";
                    }                 

                } catch (e:Error) {
                    trace(e);
                }               
            }
    
    
    private function addColumn():void
	{
			var dg :DataGridColumn = new DataGridColumn();
			dg.dataField="";
			dg.editable = false;
			dg.headerText = "";
			dg.width = 40;
			dg.itemRenderer = new RendererFectory(ImgSummaryRenderer);
			
			var cols :Array = resultSummary.columns;
			cols.unshift(dg);
			resultSummary.columns = cols;
			
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
    } // ActionScript file
    
    	/**
    	 *This function processes the collection returned and modifies 
    	 * it to add records for SubTotals and Totals. 
    	 */ 
       
