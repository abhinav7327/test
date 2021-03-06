
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.containers.SummaryPopup;
    import com.nri.rui.core.controls.CustomizeSortOrder;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.controls.XenosHTTPServiceForSpring;
    import com.nri.rui.core.formatters.CustomDateFormatter;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.ProcessResultUtil;
    import com.nri.rui.core.utils.XenosStringUtils;
    import com.nri.rui.fam.validators.FamTrashSuspendedTxnQueryValidator;
    import flash.events.Event;
    
    import mx.collections.ArrayCollection;
    import mx.events.CloseEvent;
    import mx.events.ValidationResultEvent;
    import mx.managers.PopUpManager;
    import mx.rpc.events.ResultEvent;
    import mx.utils.StringUtil;
    
    private var sPopup : SummaryPopup;	
    private var sortUtil: ProcessResultUtil = new ProcessResultUtil();
    [Bindable]public var selectAllBind:Boolean=false;
    [Bindable]
    private var initColl:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    
    [Bindable]
    private var queryResult:ArrayCollection= new ArrayCollection();
    private var emptyResult:ArrayCollection= new ArrayCollection();
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    
    //private var tempColl:ArrayCollection = new ArrayCollection();
    //Items returning through context - Non display objects for accountPopup
    private var checkRes:Boolean = false;
    private var checkRes2:Boolean = false;
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    
    [Bindable]
    private var commandFormId : String = "" ;
    
    private var keylist:ArrayCollection = new ArrayCollection();
    private var csd:CustomizeSortOrder = null;
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    private var selectedResults:ArrayCollection=new ArrayCollection();   
    
    [Bindable]
    private var initcol:ArrayCollection = new ArrayCollection();
    
    private var selIndx:int = 0;
    private var i:int = 0;
    private var item:Object = new Object();
    [Bindable]
    private var tempColl: ArrayCollection = new ArrayCollection();
    
    //Stores elements of type 'Object' with two properties which are 'fundCode' and 'index'
    [Bindable] private var fundCodeArrColl:ArrayCollection = new ArrayCollection() ; 
    
    
    [Bindable]
    public var editFundCodeMode:Boolean = false;
    
    //Stores the row index of the Fund Code to be edited
    
    private var editFundCodeIndex : int = -1 ;
    public var conformSelectedResults : Array = new Array(); 
    [Bindable]private var selectedResultViewList:ArrayCollection= new ArrayCollection();
    [Bindable]private var editedDays:Array= new Array();
    public var trashSusTxnpopUp:TrashSuspendedTxnConfPopup;
    
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    
    private function initPageStart():void {    	           
        if (!initCompFlg) {    
            rndNo= Math.random();
            var req : Object = new Object();
            req.SCREEN_KEY = 12152;
            initializeTrashSuspendedTxnQuery.request = req;         
            initializeTrashSuspendedTxnQuery.url = "fam/trashSuspendedTxnQuery.spring?method=initialExecute&menuType=y&rnd=" + rndNo;                    
            initializeTrashSuspendedTxnQuery.send(); 
        } else {
        	 XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.initiate'));
        }
    } 
    
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * 
    */  
    private function initPage(event: ResultEvent) : void {    	 
        var i:int = 0;
        app.submitButtonInstance = submitTrashQuery;

        
        errPage.clearError(event); //clears the errors if any 
       
        var commandForm: Object=event.result.trashSuspendedTxnQueryCommandForm; 
        commandFormId = commandForm.commandFormId ;
        
        securityTypeList.text = "";
        
        multipleFundSelector.fundCodeSummary.enabled=true;
        multipleFundSelector.fundPopUp.fundCode.text = "";
        multipleFundSelector.reset();
        
        dateFrom.text = commandForm.fromDate != null ?  commandForm.fromDate : "";
        dateTo.text = commandForm.toDate != null ?  commandForm.toDate : "";
       
        //actPopUp.accountNo.setFocus();
        
        handleFundCodeResult(event);    
        
        // Setting the values of Transaction group... start
        initColl.removeAll();
        if(commandForm.componentIDList.item != null) {
            if(commandForm.componentIDList.item is ArrayCollection)
                initColl = commandForm.componentIDList.item as ArrayCollection;
            else
                initColl.addItem(commandForm.componentIDList.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:"", value: ""});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        componentIDList.dataProvider = tempColl;        
    
        var sortField1Default : String = commandForm.sortField1;
        var sortField2Default : String = commandForm.sortField2;
        var sortField3Default : String = commandForm.sortField3;
             
        // Setting values of the SortField1
        initColl.source = new Array();
        
        if(null != commandForm.sortFieldList.item){
            tempColl = new ArrayCollection();
            tempColl.addItem({label:"", value: ""}); 
            selIndx = 0;            
            if(commandForm.sortFieldList.item is ArrayCollection){
            	initColl = commandForm.sortFieldList.item as ArrayCollection;
            } else {
            	initColl.addItem(commandForm.sortFieldList.item);
            }               
            //Alert.show("Size of List:  "+ initColl.length);
            for(i = 0; i < initColl.length; i++) {             	            
                if(XenosStringUtils.equals((initColl[i].value),sortField1Default)){                    
                    selIndx = i;
                }
               tempColl.addItem(initColl[i]);            
            }
           
            sortFieldArray[0]=sortField1;
            sortFieldDataSet[0]=tempColl;
            //Set the default value object           
            sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
            
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.error.initialize.sortfield1'));
        }       
         for(i = 0; i<initColl.length; i++) {               
               if(XenosStringUtils.equals((initColl[i].value),sortField2Default)){                    
                    selIndx = i;
                }
         }         
         sortFieldArray[1]=sortField2;
         sortFieldDataSet[1]=tempColl;
         //Set the default value object           
         sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);
         
          for(i = 0; i<initColl.length; i++) {
               if(XenosStringUtils.equals((initColl[i].value),sortField3Default)){                    
                    selIndx = i;
                }
         }         
         sortFieldArray[2]=sortField3;
         sortFieldDataSet[2]=tempColl;
         //Set the default value object           
         sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx+1);
        
         csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
         csd.init();
    }
    
    //This method sets data to 'MultipleFundSelector' component from Server sent XML
    
    private function handleFundCodeResult(event: ResultEvent):void{
    	errPage.clearError(event);
    	var errorInfoList:ArrayCollection=new ArrayCollection();
    	if (event.result!= null && event.result.XenosErrors!= null && 
    	event.result.XenosErrors.Errors != null) {
		   if (event.result.XenosErrors.Errors.error != null){
			 
			 if (event.result.XenosErrors.Errors.error is ArrayCollection) {
				 errorInfoList=event.result.XenosErrors.Errors.error as ArrayCollection;
			 } else { 
				 errorInfoList.addItem(event.result.XenosErrors.Errors.error);
			  }
		   }
		   errPage.showError(errorInfoList);
		   return;
	    }
    	  var commandForm: Object=event.result.trashSuspendedTxnQueryCommandForm;
    	   
    	   // Set 'editFundCodeIndex' from Server sent XML 
    	   editFundCodeIndex = commandForm.editFundCodeIndex ;
    	   
    	   // Stores elements of type 'String' i.e. Fund Code from Server sent XML
    	   tempColl = new ArrayCollection() ; 
    	      	  
    	   // Get rid of all previously stored items
    	   fundCodeArrColl.removeAll();
    	   // Fill up 'tempColl' from Server sent XML
    	   if(commandForm.fundCodeList != null && commandForm.fundCodeList.fundCode != null){          
             if (commandForm.fundCodeList.fundCode is ArrayCollection) {
           	    tempColl= commandForm.fundCodeList.fundCode as ArrayCollection ;           	  
             } else {
           	    tempColl.addItem(commandForm.fundCodeList.fundCode);           	   
             }
                       
            // Fill up 'fundCodeArrColl' which is displayed in the Grid of 'MultipleFundSelector'           
            for(i=0; i< tempColl.length; i++) {
            	var obj:Object=new Object();
            	obj["fundCode"] = tempColl[i];
            	obj["index"] = i;
            	fundCodeArrColl.addItem(obj);            	
      		}
      		
            }
         // Set Fund Code if 'Edit' has been issued otherwise clear the TextInput.
         if(editFundCodeIndex>=0 && fundCodeArrColl.length>0){
         	multipleFundSelector.setFundCode(fundCodeArrColl.getItemAt(editFundCodeIndex)["fundCode"]);         
         }else{
         	multipleFundSelector.setFundCode(XenosStringUtils.EMPTY_STR);         	
         }
         
    }
    
    private function sortOrder1Update():void{
         csd.update(sortField1.selectedItem,0);
    }
     
    private function sortOrder2Update():void{      
        csd.update(sortField2.selectedItem,1);
    }
    
	public function submitQuery():void{
		if(selectedResults!=null){
   			selectedResults.removeAll();
   			conformSelectedResults = selectedResults.toArray();
   		}
         //Reset Page No
         qh.resetPageNo(); 
        //Set the request parameters
        var requestObj :Object = populateRequestParams();
        trashSuspendedTxnQueryRequest.request = requestObj;
				
        var myModel:Object={
				trashSuspendedTxnQuery:{                                 
				entryDateFrom:this.dateFrom.text,
				entryDateTo:this.dateTo.text,
				isAllFundSelected:this.multipleFundSelector.isAllFundSelected()
                            	}
							}; 
		var trashSuspendedTxnQueryValidator:FamTrashSuspendedTxnQueryValidator = new FamTrashSuspendedTxnQueryValidator();
        trashSuspendedTxnQueryValidator.source=myModel;
        trashSuspendedTxnQueryValidator.property="trashSuspendedTxnQuery";
         
        var validationResult:ValidationResultEvent =trashSuspendedTxnQueryValidator.validate();
        if (this.dateFrom.text == null || this.dateFrom.text =="") {
			if (this.multipleFundSelector.isAllFundSelected()) {
				XenosAlert.error((this.parentApplication.xResourceManager.getKeyValue('fam.suspendedtransaction.error.mandatory.entryfromdate')));
				return;
			} else if (fundCodeArrColl.length == 0) {
					XenosAlert.error((this.parentApplication.xResourceManager.getKeyValue('fam.suspendedtransaction.error.mandatory.fundandentryfromdatecheck')));
					return;
			} else if (!(this.dateTo.text == null || this.dateTo.text =="")) {
				checkRes = dateCheck(this.dateTo.text);
				if (!checkRes) {
            		XenosAlert.error("Illegal Entry Date To format ["+this.dateTo.text+"]");
					return;
				}
			}
        } else {
	        if(validationResult.type == ValidationResultEvent.INVALID) {
            	var errorMsg:String=validationResult.message;
            	XenosAlert.error(errorMsg);
            	return;
			} else if (!this.multipleFundSelector.isAllFundSelected() && fundCodeArrColl.length == 0) {
					XenosAlert.error((this.parentApplication.xResourceManager.getKeyValue('fam.suspendedtransaction.error.mandatory.selectfund')));
					return;
			} else if (!(this.dateTo.text == null || this.dateTo.text =="") && (this.dateTo.text < this.dateFrom.text)) {
        		XenosAlert.error((this.parentApplication.xResourceManager.getKeyValue('fam.suspendedtransaction.error.fromdate.todate')));
        		return;
			}
    	}
    	trashSuspendedTxnQueryRequest.send();
		qh.commandFormIdForPreference = famTrashSuspendedTxnQueryResult.commandFormIdForPreference ; 
 	}
    
	 public function dateCheck(value:String):Boolean{
	 	var dateformat:CustomDateFormatter=new CustomDateFormatter();
		//format of the date
		dateformat.formatString="YYYYMMDD";
		
		var input:String = value;
		var label:String = "Entry Date To";
			
		if (!(DateUtils.isValidDate(StringUtil.trim(input)))) {
			return false;
		}
		return true;
	 }
    
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
    
    public function resetQuery():void{
    	trashSuspendedTxnResetQueryRequest.url = "fam/trashSuspendedTxnQuery.spring";  
    	var reqObj : Object = new Object();       
        reqObj["method"] = "resetQuery";    	
        trashSuspendedTxnResetQueryRequest.send(reqObj);
    }
    
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        var reqObj : Object = new Object();
        reqObj["SCREEN_KEY"] = 12153;
        reqObj["method"] = "submitQuery";
        reqObj.rnd = Math.random();   
        reqObj["fundCode"] = this.multipleFundSelector.fundPopUp.fundCode.text;
        reqObj["selectedFlag"]=this.multipleFundSelector.isAllFundSelected();
        reqObj["fromDate"] = this.dateFrom.text; 
        reqObj["toDate"] = this.dateTo.text; 
        
        reqObj["componentID"]=this.componentIDList.selectedItem!=null?this.componentIDList.selectedItem.value :"";        
        reqObj["securityType"] = this.securityTypeList.itemCombo.text;
        reqObj["sortField1"]= this.sortField1.selectedItem!=null?this.sortField1.selectedItem.value:"";       
        reqObj["sortField2"]= this.sortField2.selectedItem!=null?this.sortField2.selectedItem.value:"";       
        reqObj["sortField3"]= this.sortField3.selectedItem!=null?this.sortField3.selectedItem.value:"";        
        
        return reqObj;
    }
       
    
	 /**
    * This method works as the result handler of the Submit Query Http Services.
    * This also takes care of the buttons/images to be shown on the top panel of the
    * result .
    */    
    
    private function LoadResultPage(event:ResultEvent):void {
        var rs:XML = XML(XenosHTTPServiceForSpring.getXmlResult(event));
        if (null != event) {
            if(rs.child("row").length()>0) {
                errPage.clearError(event);
                queryResult.removeAll();
                try {
                    for each ( var rec:XML in rs.row ) {
                        queryResult.addItem(rec);
                    }
                    changeCurrentState();
                    qh.setOnResultVisibility();
                    qh.setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
                    qh.PopulateDefaultVisibleColumns();
                     //replace null objects with empty string
                    queryResult=ProcessResultUtil.process(queryResult,famTrashSuspendedTxnQueryResult.columns); 
                    queryResult.refresh();
                }catch(e:Error){
                    XenosAlert.error(e.toString() + e.message);
                }
             } else if(rs.child("Errors").length()>0) {
                //some error found
                queryResult.removeAll(); // clear previous data if any as there is no result now.
                var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list              
                for each ( var error:XML in rs.Errors.error ) {
                   errorInfoList.addItem(error.toString());
                }
                errPage.showError(errorInfoList);//Display the error
             } else {
             	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                queryResult.removeAll(); // clear previous data if any as there is no result now.
                errPage.removeError(); //clears the errors if any
                
             }
        
        }
        resetSelection(queryResult);
	    setIfAllSelected();
    }
    
    /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
     	
        qh.dgrid = famTrashSuspendedTxnQueryResult;
    }
    
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
        var url : String = "fam/trashSuspendedTxnQuery.spring?method=generateXLS&commandFormId="+ commandFormId;
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
        var url : String = "fam/trashSuspendedTxnQuery.spring?method=generatePDF&commandFormId="+ commandFormId;
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
    * This is for the Print button which at a  time will print all the data 
    * in the dataprovider of the Datagrid object
    */
     private function doPrint():void{
       
        
    }
	
	/**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
     private function doNext():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
        trashSuspendedTxnQueryRequest.request = reqObj;
		trashSuspendedTxnQueryRequest.send();
    }
    
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        trashSuspendedTxnQueryRequest.request = reqObj;
        trashSuspendedTxnQueryRequest.send();
    }
    
    /**
    * This method sends the HttpService for save the result screen.
    * This is actually server side pagination for save the result screen.
    */ 
	private function saveScreenCriteria() : void {
		var params:Object=new Object;
		initializeTrashSuspendedTxnQuery.url = "fam/trashSuspendedTxnQuery.spring?method=saveFormCriteria&commandFormId="+ commandFormId;                    
        initializeTrashSuspendedTxnQuery.send(); 
	}
    
	// This is solely used for 'MultipleFundSelector' component and handles ADD, EDIT and DELETE operations
	private function fundCodeSelectionHandler(mode : String, fundCode : String , index : String = "-1") : void {
		var params : Object = new Object();
		if (XenosStringUtils.equals(mode , MultipleFundSelector.ADD)) {		
			// validation for trying to add empty fund code
		    if (fundCode == XenosStringUtils.EMPTY_STR) {
			     XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.transactionquery.error.fundcode.empty'));
			     return;
		    }
		    // validation for trying to add more than 10 fund code
		    if (fundCodeArrColl.length == 10) {
			  		// validation for trying to add duplicated fund code
				if (isDuplicatedFundCode(fundCode))
				{
					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.closeentry.error.fundcode.duplicated'));
					return;
				}
				if(editFundCodeIndex == -1) {
					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.closeentry.error.fundcode.maxadded'));
					return;
				}
			}
			// validation for trying to add duplicated fund code
			if (editFundCodeIndex == -1) {
				if (isDuplicatedFundCode(fundCode))
				{
					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.transactionquery.error.fundcode.maxadded'));
			  		return;
				}
			}
			params['method']="addFundCode";	
			params['editFundCodeIndex']= editFundCodeIndex; 			
		}else if (XenosStringUtils.equals(mode , MultipleFundSelector.EDIT)) {			
			params['method']="editFundCode";
			params['editFundCodeIndex']= index; 			
		}else if (XenosStringUtils.equals(mode , MultipleFundSelector.DELETE)) {			
			params['method']="deleteFundCode";
			//Reset (required when the user issued Edit and then Delete)
			params['editFundCodeIndex']= -1; 
			params['deleteFundCodeIndex']=index;						
		}		
		params['fundCode']=fundCode;
		fundCodeQueryRequest.send(params);
	}
	
	private function isDuplicatedFundCode(value : String) : Boolean {
		for each(var o:Object in fundCodeArrColl) {
            if (o.fundCode == value) {
					return true;            		
            }
     	}
     	return false;   
	}
	
	/**
	 * 
	 * This API is needed so that none of the results retrieved from the database are selected. 
	 * 
	 */
	 
	private function resetSelection(queryResult:ArrayCollection):void{
    	for(var i:int=0;i<queryResult.length;i++){
    		queryResult[i].selected = false;
    		queryResult[i].rowNum = i;
    		
    	}
    } 
	
	/**
	 * Checking if the select All check bok is checked. If True all the result is binded
	 * 
	 */
	 
	 
	public function setIfAllSelected() : void {
    	if(isAllSelected()){
    		selectAllBind=true;
    	} else {
    		selectAllBind=false;
    	}
    }
    
    
    public function isAllSelected(): Boolean {
    	var i:Number = 0;
    	if(queryResult == null){
    	 return false;
    	}
    	for(i=0; i<queryResult.length; i++){
    		if(queryResult[i].selected == false) {
        		return false;
        	}
    	}
    	if(i == queryResult.length) {
    		return true;
         }else {
    		return false;
    	}
    }
	 
	
	/**
	 * Call to this API is made from com.nri.rui.core.renderers.SelectItem 
	 * On selection of each record all the required fields and its values are set here as object.  
	 * 
	 */ 
	
	public function checkSelectToModify(item:Object):void {
        var i:Number;
        var tempArray:Array = new Array();
        if(item.selected == true){
        	 // needs to insert
        	var obj:Object=new Object();
        	obj.suspendedTransactionPk = item.suspendedTransactionPk;
        	obj.rowNum = item.rowNum;
            selectedResults.addItem(obj);
    	}else { 
    		//needs to pop
    		for(i=0; i<selectedResults.length; i++){
    			if(selectedResults[i].suspendedTransactionPk != item.suspendedTransactionPk)
    			    selectedResults.removeItemAt(i);
    		}        		
    	}    
    	conformSelectedResults = selectedResults.toArray();
    	setIfAllSelected(); 
    }
	
	
	/**
	 * Call to this API is made from com.nri.rui.core.renderers.SelectAllItem
	 * 
	 */ 
	public function selectAllRecords(flag:Boolean): void {
    	var i:Number = 0;
    	selectedResults.removeAll();
    	
    	for(i=0; i<queryResult.length; i++){
    		var obj:XML=queryResult[i];
    		obj.selected = flag;
            queryResult[i]=obj;
            queryResult.refresh();
            addOrRemove(queryResult[i]);
    	}
    	
    	conformSelectedResults = selectedResults.toArray();
    }
	
		
	public function addOrRemove(item:Object):void {
    	var i:Number;
        var tempArray:Array = new Array();
        if(item.selected == true){ 
        	var obj:Object=new Object();
        	obj.suspendedTransactionPk = item.suspendedTransactionPk;
        	obj.rowNum = item.rowNum;
            selectedResults.addItem(obj);
           
    	}else { //needs to pop
    		for(i=0; i<selectedResults.length; i++){
    			if(selectedResults[i].suspendedTransactionPk != item.suspendedTransactionPk)
    			    selectedResults.removeItemAt(i);
    		}
    	}		
    }
	
	/**
	 * 
	 * Loading the selected results from Trash Suspended Transaction Query Result Screen to an Array
	 * which would later be passed onto Trash Suspended Transaction User Confirmation Popup.
	 * 
	 */ 
		
	public function userConfirmationSubmit():void {
		
		var selectedIndexArray:Array = getSelectedPks();
		if (selectedIndexArray.length > 0){
			loadUserConfirmation(selectedIndexArray);
		}else{
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.trashsuspendedtxn.error.norecord.selected'));
			return;
		}
	}
	
	
	 private function getSelectedPks():Array{
    	var tempArray:ArrayCollection = new ArrayCollection();
    	//var numBase:NumberBase = new NumberBase();
    	for(var i:int=0;i<queryResult.length;i++){
    		if(queryResult[i].selected == true){
    			tempArray.addItem(queryResult[i].suspendedTransactionPk);
    			trace("Selected index :: " + queryResult[i].originalIndex);
	    	}
    	}
    	return tempArray.toArray();
    }
	
	public function closePopUp(event:Event):void{
		trashSusTxnpopUp.removeEventListener(CloseEvent.CLOSE,closePopUp);
		PopUpManager.removePopUp(trashSusTxnpopUp);
		submitQuery();
	}
	public function closePopUp1(event:CloseEvent):void{
		trashSusTxnpopUp.removeEventListener(CloseEvent.CLOSE,closePopUp);
		PopUpManager.removePopUp(trashSusTxnpopUp);
		submitQuery();
	}
	
	/**
	 * 
	 * Call for the Suspended Transaction User Confirmation Popup made here
	 * 
	 */
	private function loadUserConfirmation(selIndArr:Array):void {
		var reqObj:Object = new Object();
		reqObj.method = "submitUserConfirm";
		reqObj.rnd = Math.random();
		reqObj.selector=selIndArr;
		reqObj.commandFormId = commandFormId;
		reqObj.SCREEN_KEY = "12154";
		initializeUserconf.request = reqObj;
		initializeUserconf.send();
		
     }
     
	/**
	* This method loads the unmatch popup screen
	*
	* */
	public function loadUserConfPage(event:ResultEvent):void
	{
		errPage.clearError(event); //clears the errors if any 
	        
		selectedResultViewList.removeAll();
		if(event.result != null){
			var commandForm: Object = event.result.trashSuspendedTxnQueryCommandForm;
			var xenosError: Object = event.result.XenosErrors;
			if(commandForm != null){
				if(commandForm.selectedResultViewList != null){
					if(commandForm.selectedResultViewList.indvidualList is ArrayCollection){
						selectedResultViewList = commandForm.selectedResultViewList.indvidualList as ArrayCollection;
					}else{
						selectedResultViewList.addItem(commandForm.selectedResultViewList.indvidualList);
					}
					selectedResultViewList.refresh();
				}
			}else if(xenosError != null){
				var errorInfoList:ArrayCollection = new ArrayCollection();
				var errorStr:String = XenosStringUtils.EMPTY_STR;
				for each (var error:Object in xenosError.Errors.error)
				{
					errorStr = errorStr + error.toString() + "\n";
				}
				XenosAlert.error(errorStr);
				//this.closeHandeler();
			}else{
				XenosAlert.info("Invalid response!");
			}
			trashSusTxnpopUp = TrashSuspendedTxnConfPopup(PopUpManager.createPopUp(this , TrashSuspendedTxnConfPopup ,true));
			trashSusTxnpopUp.addEventListener(CloseEvent.CLOSE,closePopUp1);
			trashSusTxnpopUp.width = 1020;
			trashSusTxnpopUp.height = 630;
			trashSusTxnpopUp.dataprovider = selectedResultViewList;
			trashSusTxnpopUp.errPage.showError(errorInfoList);//Display the error
			trashSusTxnpopUp.title = this.parentApplication.xResourceManager.getKeyValue('fam.popup.trashsuspendedtxn.userconf.popup.title');
			trashSusTxnpopUp.addEventListener("OkSystemConfirm",closePopUp);	
			trashSusTxnpopUp.commandFormId = commandFormId;
			
			PopUpManager.centerPopUp(trashSusTxnpopUp);
			
		}
	}
	
	
            
