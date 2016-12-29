


// ActionScript file



// ActionScript file
     import com.nri.rui.core.Globals;
     import com.nri.rui.core.controls.CustomizeSortOrder;
     import com.nri.rui.core.controls.XenosAlert;
     import com.nri.rui.core.controls.XenosHTTPServiceForSpring;
     import com.nri.rui.core.startup.XenosApplication;
     import com.nri.rui.core.utils.HiddenObject;
     import com.nri.rui.core.utils.NumberUtils;
     import com.nri.rui.core.utils.ProcessResultUtil;
     import com.nri.rui.core.utils.XenosPopupUtils;
     import com.nri.rui.core.utils.XenosStringUtils;
     import com.nri.rui.fam.validators.FamTransactionAmendQryValidator;
     
     import mx.collections.ArrayCollection;
     import mx.controls.ComboBox;
     import mx.core.UIComponent;
     import mx.events.ValidationResultEvent;
     import mx.rpc.events.ResultEvent;
     import mx.utils.StringUtil;
    
    private var emptyResult:ArrayCollection= new ArrayCollection();
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;       
    private var keylist:ArrayCollection = new ArrayCollection();
    private var csd:CustomizeSortOrder = null;
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();          
    private var selIndx:int = 0;
    private var i:int = 0;
    private var item:Object = new Object();
    
    [Bindable]private var initcol:ArrayCollection = new ArrayCollection();
    [Bindable]public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);  
    [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
    [Bindable]private var commandFormId : String = XenosStringUtils.EMPTY_STR;
    private var commandFormIdForTransaction : String = XenosStringUtils.EMPTY_STR;
    private var commandFormIdForAmendEntry : String = XenosStringUtils.EMPTY_STR;
    [Bindable]private var initColl:ArrayCollection = new ArrayCollection();
    [Bindable]private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]private var queryResult:ArrayCollection= new ArrayCollection();
    [Bindable]private var tempColl: ArrayCollection = new ArrayCollection();
    [Bindable] private var fundCodeArrColl:ArrayCollection = new ArrayCollection();
    [Bindable]public var editFundCodeMode:Boolean = false;
    [Bindable]private var recordStr:String=XenosStringUtils.EMPTY_STR;
     private var sortUtil: ProcessResultUtil = new ProcessResultUtil();
    //Stores the row index of the Fund Code to be edited
    private var editFundCodeIndex : int = -1 ;
    //Default Sort Column 1     
    public static const FUND_CODE: String = "fund_code";
    //Default Sort Column 2 
    public static const TRADE_DATE: String = "trade_date";
    //Default Sort Column 3 
    public static const LOCAL_CCY: String = "local_ccy";
    //Sort Column
    public static const SECURITY_CODE: String = "security_code";
    // Trade Type= FA Trade
    public static const FA_TRADE: String = "FA_TRADE";
    // Trade Type= Cash Merger
    public static const CASH_MERGER: String = "CASH_MGR";
    
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    private function initPageStart():void {    	           
        if (!initCompFlg) {    
            rndNo= Math.random();
            var req1 : Object = new Object();
            req1.SCREEN_KEY = 13004;
            initializeTransactionQuery.request = req1;         
            initializeTransactionQuery.url = "fam/transactionAmendQuery.spring?method=initialExecute&menuType=y&rnd=" + rndNo;                    
            initializeTransactionQuery.send();
            dummyService.send();
        } else {
        	 XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.initiate'));
        }                   
    }
    
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * 
    */  
    private function initPage(event: ResultEvent) : void {    	 
        //clears the errors if any
        errPage.clearError(event); 
        // Getting the Command Form Object
        var commandForm: Object=event.result.transactionAmendQueryCommandForm;
        // Setting Command Form Id
        commandFormId = commandForm.commandFormId ;       
        //Setting data source
        initColl.removeAll();
		
        currency.ccyText.text = commandForm.currencyCode;
        referenceNumber.text = commandForm.referenceNumber;
        security.instrumentId.text = commandForm.securityCode;  
        multipleFundSelector.fundCodeSummary.enabled=true;
        multipleFundSelector.fundPopUp.fundCode.text = XenosStringUtils.EMPTY_STR;        
        tradeDateFrom.text = commandForm.defaultTradeFromDate != null ?  commandForm.defaultTradeFromDate : XenosStringUtils.EMPTY_STR;  
        tradeDateTo.text = commandForm.tradeDateTo != null ?  commandForm.tradeDateTo : XenosStringUtils.EMPTY_STR;  
        valueDateFrom.text = commandForm.valueDateFrom != null ?  commandForm.valueDateFrom : XenosStringUtils.EMPTY_STR;  
        valueDateTo.text = commandForm.valueDateTo != null ?  commandForm.valueDateTo : XenosStringUtils.EMPTY_STR;  
        bookDateFrom.text = commandForm.bookDateFrom != null ?  commandForm.bookDateFrom : XenosStringUtils.EMPTY_STR;  
        bookDateTo.text = commandForm.bookDateTo != null ?  commandForm.bookDateTo : XenosStringUtils.EMPTY_STR;  
        originalBookDateFrom.text = commandForm.originalBookDateFrom != null ?  commandForm.originalBookDateFrom : XenosStringUtils.EMPTY_STR;
        originalBookDateTo.text = commandForm.originalBookDateTo != null ?  commandForm.originalBookDateTo : XenosStringUtils.EMPTY_STR;
        handleFundCodeResult(event);
		
        //IM Office
        initColl.removeAll();
        
        // Setting the values of Transaction type... start
        initColl.removeAll();
	   if(commandForm.transactionTypeList.item != null) {
		    if(commandForm.transactionTypeList.item is ArrayCollection) {
			    initColl = commandForm.transactionTypeList.item as ArrayCollection;
		    } else {
				initColl.addItem(commandForm.transactionTypeList.item);
		    }
	   }
           
        tempColl = new ArrayCollection();
        tempColl.addItem({label:XenosStringUtils.EMPTY_STR, value: XenosStringUtils.EMPTY_STR});
        var i:int = 0;
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        transactionType.dataProvider = tempColl;        
        setSelectedIndexOfComboBox(transactionType, tempColl , commandForm.transactionType);
        
        initColl.removeAll();
        if(commandForm.buySellList.item != null) {
            if(commandForm.buySellList.item is ArrayCollection) {
                initColl = commandForm.buySellList.item as ArrayCollection;
            } else {
                initColl.addItem(commandForm.buySellList.item);
            }
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:XenosStringUtils.EMPTY_STR, value: XenosStringUtils.EMPTY_STR});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        buySell.dataProvider = tempColl;
        setSelectedIndexOfComboBox(buySell, tempColl , commandForm.buySell);
      
        initColl.removeAll();
      
        // Setting Sort Order combo boxes
        populateSortOrderCombos();
		
		multipleFundSelector.reset(); //Reset Multiple Fund Selector
        multipleFundSelector.fundPopUp.fundCode.setFocus();
    }
    
    // Populates Sort Order Combo Boxes
    private function populateSortOrderCombos():void {   
        tempColl = new ArrayCollection();
        fillWithSortColumns(tempColl);
        sortField1.dataProvider = tempColl;
        sortFieldArray[0]= sortField1;
	    sortFieldDataSet[0]=tempColl;	  
	    sortFieldSelectedItem[0] = tempColl.getItemAt(1);  //Set the default 	
        
        tempColl = new ArrayCollection();
        fillWithSortColumns(tempColl);
        sortField2.dataProvider = tempColl;
        sortFieldArray[1]= sortField2;
	    sortFieldDataSet[1]=tempColl;
	    sortFieldSelectedItem[1] = tempColl.getItemAt(2);  //Set the default 
        
        tempColl = new ArrayCollection();
        fillWithSortColumns(tempColl);
        sortField3.dataProvider = tempColl;
        sortFieldArray[2]= sortField3;
	    sortFieldDataSet[2]=tempColl;
	    sortFieldSelectedItem[2] = tempColl.getItemAt(3); //Set the default 
               
        csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
        csd.init();
    }
    
    // Fills the collection with default values
    private function fillWithSortColumns(tempColl:ArrayCollection):void
    {
    	tempColl.addItem({label:" ", value: " "});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('fam.transactionquery.result.label.fundcode'), value: FUND_CODE});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('fam.transactionquery.result.label.tradedate'), value: TRADE_DATE});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('fam.transactionquery.movementdetails.label.localccy'), value: LOCAL_CCY});
        tempColl.addItem({label:this.parentApplication.xResourceManager.getKeyValue('fam.transactionquery.movementdetails.label.securitycode'), value: SECURITY_CODE});
    }
    
	              	
    
    /**
     * Calculates the index of Combo Box 
	 * Set  index and prompt of the Combo Box.
     */
    private function setSelectedIndexOfComboBox(comboBoxId : ComboBox , collection : ArrayCollection , defaultValue : String):void {
     	var index:int = 0;
	    if (!XenosStringUtils.isBlank(defaultValue)) {
	        //return index;
	        for (var count:int = 0; count < collection.length; count++) {
		        var bean:Object = collection.getItemAt(count);
		        if (XenosStringUtils.equals(bean['value'] , defaultValue)) {
		            index = count;
		            break;
		        }
		    }
	    }
	    comboBoxId.selectedIndex = index ;
	    if (index == 0 ) {
	    	comboBoxId.prompt = "Select";
	    } 	   
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
	  
    	   var commandForm: Object=event.result.transactionAmendQueryCommandForm;
    	   
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
    
     /**
     * It helps to update the order of sort field1. 
     * 
     */
     private function sortOrder1Update():void{
         csd.update(sortField1.selectedItem,0);
     }
     /**
     * It helps to update the order of sort field2. 
     * 
     */
     private function sortOrder2Update():void{      
        csd.update(sortField2.selectedItem,1);
     }
    
    /**
    * It sends/submits the query. 
    * 
    */
    public function submitQuery():void{
    	if (!multipleFundSelector.isAllFundSelected())
		{
			// check if fund list is empty or fund code is in edit mode
			if (fundCodeArrColl.length == 0)
			{
				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.transactionquery.error.fundcode.empty'));
				return;
			}
			// check if fund code is in edit mode
			if (editFundCodeIndex != -1)
			{
				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.transactionquery.error.fundcode.edit'));
				return;
			}
		}
         //Reset Page No
         qh.resetPageNo();      
        //Set the request parameters
        
        var requestObj :Object = populateRequestParams();
        transactionQueryRequest.request = requestObj; 
        var myModel:Object={
                            transactionAmendQuery:{                                 
                                 tradeDateFrom:this.tradeDateFrom.text,
                                 tradeDateTo:this.tradeDateTo.text,
                                 valueDateFrom:this.valueDateFrom.text,
                                 valueDateTo:this.valueDateTo.text,
                                 bookDateFrom:this.bookDateFrom.text,
                                 bookDateTo:this.bookDateTo.text,
                                 originalBookDateFrom:this.originalBookDateFrom.text,
                                 originalBookDateTo:this.originalBookDateTo.text,
                                 securityCode:this.security.instrumentId.text,
                                 transactionType:this.transactionType.selectedItem!=null?this.transactionType.selectedItem.value:"",
                                 isAllFundSelected:this.multipleFundSelector.isAllFundSelected()
                            }
                           }; 
        var transactionQueryValidator:FamTransactionAmendQryValidator = new FamTransactionAmendQryValidator();
        transactionQueryValidator.source=myModel;
        transactionQueryValidator.property="transactionAmendQuery";
         
        var validationResult:ValidationResultEvent =transactionQueryValidator.validate();
        if(validationResult.type == ValidationResultEvent.INVALID) {
            var errorMsg:String=validationResult.message;
            XenosAlert.error(errorMsg);
        } else {
			  transactionQueryRequest.send();
			  qh.commandFormIdForPreference = famTransactionQueryResult.commandFormIdForPreference ;
	         
	    }         
    }
    
    /**
    * This method sends the HttpService for reset operation.
    * 
    */   
    public function resetQuery():void  { 
    	var reqObjReset : Object = new Object();
    	reqObjReset.rnd = Math.random()+"";
    	transactionResetQueryRequest.request = reqObjReset;
        transactionResetQueryRequest.url = "fam/transactionAmendQuery.spring?method=resetQuery";   	
        transactionResetQueryRequest.send();
    }
    
    
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        var reqObj : Object = new Object();
        reqObj["SCREEN_KEY"] = "13005";
        reqObj.rnd = Math.random()+"";
        reqObj["method"] = "submitQuery";        
        reqObj["fundCode"] = this.multipleFundSelector.fundPopUp.fundCode.text;
        reqObj["tradeDateFrom"] = this.tradeDateFrom.text; 
        reqObj["tradeDateTo"] = this.tradeDateTo.text; 
        reqObj["valueDateFrom"] = this.valueDateFrom.text; 
        reqObj["valueDateTo"] = this.valueDateTo.text;
        reqObj["bookDateFrom"] = this.bookDateFrom.text;
        reqObj["bookDateTo"] = this.bookDateTo.text;
        reqObj["originalBookDateFrom"] = this.originalBookDateFrom.text;
        reqObj["originalBookDateTo"] = this.originalBookDateTo.text;
        reqObj["currencyCode"]=this.currency.ccyText.text;
        reqObj["referenceNumber"]=this.referenceNumber.text;
        reqObj["transactionType"]=this.transactionType.selectedItem != null?this.transactionType.selectedItem.value :XenosStringUtils.EMPTY_STR;   
        reqObj["buySell"]=this.buySell.selectedItem != null?this.buySell.selectedItem.value :XenosStringUtils.EMPTY_STR; 
        reqObj["securityCode"] = this.security.instrumentId.text;
        reqObj["sortField1"]= this.sortField1.selectedItem != null?StringUtil.trim(this.sortField1.selectedItem.value):XenosStringUtils.EMPTY_STR;       
        reqObj["sortField2"]= this.sortField2.selectedItem != null?StringUtil.trim(this.sortField2.selectedItem.value):XenosStringUtils.EMPTY_STR;       
        reqObj["sortField3"]= this.sortField3.selectedItem != null?StringUtil.trim(this.sortField3.selectedItem.value):XenosStringUtils.EMPTY_STR;
        reqObj["isAllFundSelected"] = this.multipleFundSelector.isAllFundSelected();        
        return reqObj;
    }
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
     private function loadResultPage(event:ResultEvent):void {
        var rs:XML = XML(XenosHTTPServiceForSpring.getXmlResult(event));
        var rsForCount:XML = XML(event.result);
        var cmdChildObj:XML = <commandFormIdAmend>{commandFormId}</commandFormIdAmend>;
        
         var cmdChildObjForTransaction:XML = <commandFormId>{commandFormIdForTransaction}</commandFormId>
        
        var cmdChildObjForAmendEntry:XML = <commandFormIdEntryAmend>{commandFormIdForAmendEntry}</commandFormIdEntryAmend>
        
        if(rs.child("row").length()>0) {
            errPage.clearError(event);
            queryResult.removeAll();
            try {
                for each ( var rec:XML in rs.row ) {
                	rec.appendChild(cmdChildObj);
                	rec.appendChild(cmdChildObjForTransaction);     
                	rec.appendChild(cmdChildObjForAmendEntry);               	
                    queryResult.addItem(rec);
                }                
                changeCurrentState();
				
                qh.setOnResultVisibility();
                qh.excelPref.visible = false;
                qh.excelPref.includeInLayout = false;
    	        qh.clearExcelPref.visible = false;
    	        qh.clearExcelPref.includeInLayout = false;
    	        qh.pdf.visible = false;
    	        qh.pdf.includeInLayout = false;
    	        qh.xls.visible = false;
    	        qh.xls.includeInLayout = false;
                qh.setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
                qh.PopulateDefaultVisibleColumns();         
            }catch(e:Error){
                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
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
            queryResult.removeAll(); // clear previous data if any as there is no result now.
            errPage.removeError(); //clears the errors if any
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
         }
        
     }
     
    private function dummyServiceResultHandler(event : ResultEvent) : void {
        commandFormIdForTransaction = event.result.transactionQueryCommandForm.commandFormId;
    }    
   
    /**
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specifdic  
      * requriment. 
      */
    private function populateContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 

        //passing counter party type            
        var cpTypeArray:Array = new Array(1);
        cpTypeArray[0]="BROKER";    
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));

        //passing account status                
        var actStatusArray:Array = new Array(1);
        actStatusArray[0]="OPEN";
        myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
        return myContextList;
    }
    
    /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
        qh.dgrid = famTransactionQueryResult;
    }  
   /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
        var url : String = "fam/transactionQuery.spring?method=generateXLS&commandFormId="+ commandFormId;
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
        var url : String = "fam/transactionQuery.spring?method=generatePDF&commandFormId="+ commandFormId;
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
        /* var printObject:XenosPrintView = new XenosPrintView();
        printObject.frmPrintHeader.lbl.text = "Transaction Amend Query";
        printObject.pDataGrid.dataProvider = famTransactionQueryResult.dataProvider;
        PrintDG.printAll(printObject); */
    } 
    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
     private function doNext():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
        transactionQueryRequest.request = reqObj;
        transactionQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        transactionQueryRequest.request = reqObj;
        transactionQueryRequest.send();
    }       	
	/**
    * This method sends the HttpService for save the result screen.
    * This is actually server side pagination for save the result screen.
    */ 
	private function saveScreenCriteria() : void {
		var params:Object=new Object;
		params.rnd = Math.random()+"";
		initializeTransactionQuery.request = params;
		initializeTransactionQuery.url = "fam/transactionAmendQuery.spring?method=saveFormCriteria&commandFormId="+ commandFormId;                    
        initializeTransactionQuery.send(); 
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
						XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.transactionamend.error.fundcode.duplicated'));
						return;
					}
					if(editFundCodeIndex == -1) {
						XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('fam.transactionamend.error.fundcode.maxadded'));
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
		    params.rnd = Math.random()+"";
		    fundCodeQueryRequest.send(params);
	 }
	 
	 public function sendReq():void {
		var requestObj:Object=populateRequestParams();
		
		transactionQueryRequest.request=requestObj;
		transactionQueryRequest.send();
	}
	
/**
 * Checks wheather fundCode is duplicated or not.
 */
private function isDuplicatedFundCode(value:String):Boolean
{
	for each (var o:Object in fundCodeArrColl)
	{
		if (o.fundCode == value)
		{
			return true;
		}
	}
	return false;
}
            