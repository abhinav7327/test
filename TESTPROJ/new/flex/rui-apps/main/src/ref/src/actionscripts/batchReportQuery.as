 
// ActionScript file for Batch Report Query

    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.CustomizeSortOrder;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.ProcessResultUtil;
    import com.nri.rui.core.utils.XenosStringUtils;
    import com.nri.rui.ref.validators.BatchReportQueryValidator;
    
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    
    import mx.collections.ArrayCollection;
    import mx.controls.List;
    import mx.core.ClassFactory;
    import mx.events.ValidationResultEvent;
    import mx.rpc.events.ResultEvent;
    import mx.utils.StringUtil;
    
    [Bindable]
    private var initColl:ArrayCollection;
    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var queryResult:ArrayCollection = new ArrayCollection();
    private var emptyResult:ArrayCollection= new ArrayCollection();
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    [Bindable]
    private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    private var  csd:CustomizeSortOrder=null;
    //private var repNamesFactory:ClassFactory=null;
    [Bindable]private var officeIdList:ArrayCollection;
    [Bindable]private var reportIdOfficeList:ArrayCollection;
    
    
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    
    
    /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
        qh.dgrid = batchReportResult;
    }  
    
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    * This will fetch data to fill the initial form data to show the user.
    */
     private function initPageStart():void {            
        if (!initCompFlg) { 
        	reportNames.setFocus();
            rndNo= Math.random();       
			var req:Object = new Object();
			req.SCREEN_KEY = 554;             
            initializeBatchReportQuery.url = "ref/batchReportQueryDispatch.action?method=initialExecute&rnd=" + rndNo;
            initializeBatchReportQuery.request = req;                    
            initializeBatchReportQuery.send(); 
         //   XenosAlert.info("After sending first request");       
        } else
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.alreadyinitiated'));
     }
      
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * Once initial data is fetched from database to fill some form data, this method works
    * to actually show the data.
    */   
     private function initPage(event: ResultEvent) : void {
        var i:int = 0;
        
        repNamesFactory = new ClassFactory(List);
        repNamesFactory.properties = {showDataTips:true, dataTipFunction:ShowFullReportName};
                
        errPage.clearError(event); //clears the errors if any
        if(null != event.result.BatchReportQueryActionForm.reportNameValues && 
        	null != event.result.BatchReportQueryActionForm.reportNameValues.item){
            var tempColl: ArrayCollection = new ArrayCollection();
            initColl = new ArrayCollection();
            tempColl.addItem({label:"", value: ""});
            if(event.result.BatchReportQueryActionForm.reportNameValues.item is ArrayCollection)
            	initColl = event.result.BatchReportQueryActionForm.reportNameValues.item as ArrayCollection;
            else
            	initColl.addItem(event.result.BatchReportQueryActionForm.reportNameValues.item);
            
            for(i = 0; i<initColl.length; i++) {
                tempColl.addItem(initColl[i]);            
            }
            reportNames.dataProvider = tempColl;
            
            reportNames.setFocus();
        }else {
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.batchreport.msg.info.reportid.notfound'));
        }
        
        if(null != event.result.BatchReportQueryActionForm.officeIdList && 
        	null != event.result.BatchReportQueryActionForm.officeIdList.officeIdList){        		
        		
        		
        	var tempColl:ArrayCollection = new ArrayCollection();
            if(event.result.BatchReportQueryActionForm.officeIdList.officeIdList is ArrayCollection){
            	tempColl = event.result.BatchReportQueryActionForm.officeIdList.officeIdList as ArrayCollection;
            }else{
            	tempColl.addItem(event.result.BatchReportQueryActionForm.officeIdList.officeIdList);
            }
          		officeIdList = new ArrayCollection();
				officeIdList.addItem("");
				for(i = 0; i<tempColl.length; i++) {
                	officeIdList.addItem(tempColl[i]);
            	}
								
				this.officeId.dataProvider = officeIdList;
        }else {
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.batchreport.msg.info.officeid.notfound'));
        }
        
        if(null != event.result.BatchReportQueryActionForm.reportIdOfficeList && 
        	null != event.result.BatchReportQueryActionForm.reportIdOfficeList.item){
            reportIdOfficeList = new ArrayCollection();
            if(event.result.BatchReportQueryActionForm.reportIdOfficeList.item is ArrayCollection){
            	reportIdOfficeList = event.result.BatchReportQueryActionForm.reportIdOfficeList.item as ArrayCollection;
            }else{
            	reportIdOfficeList.addItem(event.result.BatchReportQueryActionForm.reportIdOfficeList.item);
            }
        }
        // Set BusinessDate from-to
        if(null != event.result.BatchReportQueryActionForm.businessDateTo ){
            this.dateTo.text = StringUtil.trim(event.result.BatchReportQueryActionForm.businessDateTo);
        }
        if(null != event.result.BatchReportQueryActionForm.businessDateFrom ){
            this.dateFrom.text = StringUtil.trim(event.result.BatchReportQueryActionForm.businessDateFrom);
        }
        
        initCompFlg = true;

        
    // Populating sortfield combos
        
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.batchreport.label.generationdate'), value: "generationDate desc"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.batchreport.label.reportid'), value: "reportID"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.batchreport.label.reportname'), value: "reportName"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.batchreport.label.applicationdate'), value: "applicationDate"});
        sortFieldList1.dataProvider = tempColl;

        sortFieldArray[0]= sortFieldList1;
        sortFieldDataSet[0]=tempColl;
       //Set the default value object
        sortFieldSelectedItem[0] = tempColl.getItemAt(1);   
        
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.batchreport.label.generationdate'), value: "generationDate desc"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.batchreport.label.reportid'), value: "reportID"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.batchreport.label.reportname'), value: "reportName"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.batchreport.label.applicationdate'), value: "applicationDate"});
        sortFieldList2.dataProvider = tempColl;
                
        sortFieldArray[1]= sortFieldList2;
        sortFieldDataSet[1]=tempColl;
       //Set the default value object
        sortFieldSelectedItem[1] = tempColl.getItemAt(2);
        
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.batchreport.label.generationdate'), value: "generationDate desc"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.batchreport.label.reportid'), value: "reportID"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.batchreport.label.reportname'), value: "reportName"});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('ref.batchreport.label.applicationdate'), value: "applicationDate"});
        sortFieldList3.dataProvider = tempColl;
                
        sortFieldArray[2]= sortFieldList3;
        sortFieldDataSet[2]=tempColl;
       //Set the default value object
        sortFieldSelectedItem[2] = tempColl.getItemAt(3);
               
        csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
        csd.init();
       
    }
    
    
    private function sortOrder1Update():void{
         csd.update(sortFieldList1.selectedItem,0);
     } 
     
     private function sortOrder2Update():void{      
        csd.update(sortFieldList2.selectedItem,1);
     } 
     
     
    private function submitQuery():void 
     {  
                 
         //Set the request parameters
         var requestObj :Object = populateRequestParams();
         
         batchReportQueryRequest.request = requestObj; 
         
        var myModel:Object={
                            batchReport:{
                                 repName:(this.reportNames.selectedItem !=null? this.reportNames.selectedItem.value : ""),
                                 fromDate:this.dateFrom.text,
                                 toDate:this.dateTo.text
                             }
                           }; 
        var BatchReportValidate:BatchReportQueryValidator =new BatchReportQueryValidator();
        BatchReportValidate.source=myModel;
        BatchReportValidate.property="batchReport";
        
        var validationResult:ValidationResultEvent =BatchReportValidate.validate();
        
        
        if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
                  
        }else {
            qh.resetPageNo();
            batchReportQueryRequest.send();   
        }                   
    } 
    
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
    private function resetQuery():void { 
        batchReportResetQueryRequest.send();
    }
    
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
         reqObj.SCREEN_KEY = 555;
         reqObj.method = "submitQuery";
//         if(this.reportNames.selectedItem!=null)
//         {
//          if(this.reportNames.selectedItem.value!=null)
//         }
         //XenosAlert.info("Selected reportid="+this.reportNames.selectedItem.value+"\nSelected name="+this.reportNames.selectedItem.label);
         if(this.reportNames.selectedIndex!=-1)
             reqObj.reportId=(this.reportNames.selectedItem !=null? this.reportNames.selectedItem.value : "");
         else
             reqObj.reportId=StringUtil.trim(this.reportNames.text);
         //XenosAlert.info("reportid="+reqObj.reportId+" index="+this.reportNames.selectedIndex);
         reqObj.businessDateFrom = this.dateFrom.text;
         reqObj.businessDateTo = this.dateTo.text;
         reqObj.officeId = StringUtil.trim(officeId.selectedItem.toString());
         
         reqObj.sortField1 = this.sortFieldList1.selectedItem != null ? this.sortFieldList1.selectedItem.value : "";
         reqObj.sortField2 = this.sortFieldList2.selectedItem != null ? this.sortFieldList2.selectedItem.value : "";
         reqObj.sortField3 = this.sortFieldList3.selectedItem != null ? this.sortFieldList3.selectedItem.value : "";
         
         return reqObj;
    }
    
    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
     private function doNext():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
        batchReportQueryRequest.request = reqObj;
        batchReportQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        batchReportQueryRequest.request = reqObj;
        batchReportQueryRequest.send();
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
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * This also takes care of the buttons/images to be shown on teh top panel of the
    * result .
    */
     public function loadPage(event:ResultEvent):void {
        var showNext:Boolean;
        var showPrev:Boolean;
        
        //changeColumnOrder(event);
        
        if (null != event) {            
            if(null == event.result.rows){
                queryResult.removeAll(); // clear previous data if any as there is no result now.
                if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
                    errPage.clearError(event); //clears the errors if any
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                } else { // Must be error
                    errPage.displayError(event);    
                }                
            }else {
                errPage.clearError(event);                
                queryResult.removeAll();
                if(event.result.rows.row != null){   
                    if(event.result.rows.row is ArrayCollection) {
                            queryResult = event.result.rows.row as ArrayCollection;
                    } else {                            
                            queryResult.addItem(event.result.rows.row);
                    }
                    changeCurrentState();
                }else{                    
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                }                 
                //replace null objects if any with empty string
                queryResult=ProcessResultUtil.process(queryResult,batchReportResult.columns);
                //changeCurrentState();
                qh.setOnResultVisibility();
                qh.setPrevNextVisibility(Boolean(event.result.rows.prevTraversable),Boolean(event.result.rows.nextTraversable));
                qh.PopulateDefaultVisibleColumns();
            }
            //refresh the results.
            queryResult.refresh(); 
        }else {
            queryResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        } 
               
    } 
    
    /**
    * This is called at creationComplete of the module
    */
     private function loadAll():void {        
        
        //var title:String = this.parentApplication.xResourceManager.getKeyValue('ref.batchreport.title');
        //if(title!= null)
        //    this.parentDocument.title = title;
     }   
   /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
        var url : String = "ref/batchReportQueryDispatch.action?method=generateXLS";
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
        var url : String = "ref/batchReportQueryDispatch.action?method=generatePDF";
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
     * Change the order of the result columns depending on the value of the 
     * accountBasedFlag of the result view records.
     * 
     * @param event The ResultEvent received from the server responce after the query request.
     * 
     */
//    private function changeColumnOrder(event:ResultEvent):void{
//        var resultColl:ArrayCollection = new ArrayCollection();
//        var arrayColl:ArrayCollection = new ArrayCollection();
//        var tempArrayColl:ArrayCollection = new ArrayCollection();
//        var objResult:Object;        
//        
//        if (null != event) {            
//            if(null != event.result.rows){
//                if(event.result.rows.row != null){   
//                    if(event.result.rows.row is ArrayCollection) {
//                            resultColl = event.result.rows.row as ArrayCollection;
//                    } else {                            
//                            resultColl.addItem(event.result.rows.row);
//                    }
//                
//                    objResult = resultColl.getItemAt(0);
//                    if(objResult != null){
//                        arrayColl.source = batchReportResult.columns;
//                        tempArrayColl.source = batchReportResult.columns;
//                        
//                        if(objResult.accountBasedFlag == true){
//                            //XenosAlert.info("Account based ordering done.");
//                            tempArrayColl = orderColumns(arrayColl,accountBasedColumns,tempArrayColl);
//                        }else if(objResult.accountBasedFlag == false){
//                            //XenosAlert.info("Security based ordering done.");                            
//                            tempArrayColl = orderColumns(arrayColl,securityBasedColumns,tempArrayColl);
//                        }else{
//                            XenosAlert.info("No column ordering done.");
//                        }
//                        movementSummary.columns = tempArrayColl.source;
//                    }
//            }
//         }
//    }
//    }
//    
//    /**
//     * This method reorders the columns based on the supplied column array. 
//     * @param dgColumns      The current oredred columns.
//     * @param colOrder       The column order to be done.
//     * @param orderedColumns The current oredred columns which will be modified for final oredr.
//     * @return               The final ordered columns.
//     * 
//     */
//    private function orderColumns(dgColumns:ArrayCollection,colOrder:Array,orderedColumns:ArrayCollection):ArrayCollection{
//        var dgc : DataGridColumn;
//        var i:int=0;
//        var j:int=0;
//        
//        for(i=0;i<dgColumns.length;i++){
//            dgc = DataGridColumn(dgColumns.getItemAt(i));                                
//            
//            j=colOrder.indexOf(dgc.dataField);                                
//            if(j != -1)
//                orderedColumns.setItemAt(dgc,j);
//        }
//        return orderedColumns;
//    }


//private function downloadFile():void{
//  // code to download the file
//} 

	private function populateReportOffice():void{
		var sReportId:String = this.reportNames.selectedItem !=null? this.reportNames.selectedItem.value : "";
    	var initcol:ArrayCollection = new ArrayCollection();
                
        initcol.addItem("");
  		if( !XenosStringUtils.isBlank(sReportId) ){
  			for each(var item:Object in reportIdOfficeList){
                if(XenosStringUtils.equals(sReportId, item.value)){
                	initcol.addItem(item.label);
  	         	}
	    	}
  		}else{
  			initcol = officeIdList;
  		}
  		this.officeId.dataProvider = initcol;
	}