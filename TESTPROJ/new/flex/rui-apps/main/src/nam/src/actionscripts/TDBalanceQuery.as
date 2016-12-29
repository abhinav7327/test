
   // ActionScript file for TD Balance Query
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.containers.SummaryPopup;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.DateUtils;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.nam.validators.TDBalanceQueryValidator;
 
 import mx.collections.ArrayCollection;
 import mx.core.UIComponent;
 import mx.events.ResourceEvent;
 import mx.events.ValidationResultEvent;
 import mx.managers.PopUpManager;
 import mx.resources.ResourceBundle;
 import mx.rpc.events.ResultEvent;
 import mx.utils.StringUtil;

    [Bindable]
    private var initColl:ArrayCollection;
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    [Bindable]
    private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    
    [Bindable]
    public var dataSourceVal:String = "";

    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    private var  csd:CustomizeSortOrder=null;

     /**
     * This method should be called on creationComplete of the datagrid
     */
     private function bindDataGrid():void {
         qh.dgrid = balanceSummary; 
    }
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    * This will fetch data to fill the initial form data to show the user.
    */
     private function initPageStart():void {
         if (!initCompFlg) {
            rndNo= Math.random();
            initializeTDBalanceQuery.url = "nam/tdBalanceQueryDispatch.action?method=initialExecute&mode=query&&rnd=" + rndNo;            
            initializeTDBalanceQuery.send();
        } else
        {
        	XenosAlert.info("Already Initiated!");
        } 
     }

    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * Once initial data is fetched from database to fill some form data, this method works
    * to actually show the data.
    */
     private function initPage(event: ResultEvent) : void {
         var i:int = 0;
        var selIndx:int = 0;
        var dateStr:String = null;
        var tempColl: ArrayCollection = new ArrayCollection();
        initColl=new ArrayCollection();
        errPage.clearError(event); //clears the errors if any
        
        //variables to hold the default values from the server
        var sortField1Default:String = event.result.tdBalanceQueryActionForm.sortField1;
        var sortField2Default:String = event.result.tdBalanceQueryActionForm.sortField2;
        var sortField3Default:String = event.result.tdBalanceQueryActionForm.sortField3;

        errPage.clearError(event); //clears the errors if any 

        //initiate text fields
        date.text = "";
        date.setFocus();
        fundCodePopup.fundCode.text = "";
        officeId.selectedIndex = 0;
        securityCodePopup.instrumentId.text = "";
        securityType.selectedIndex = 0;
        currencyCodePopup.ccyText.text = "";
        securityBalance.selectedIndex = 0;
        displayZeroBalance.selectedIndex = 0;

 		if(event.result){

			//Initialize Display Zero Balance List
			initColl.removeAll();
	        initColl = event.result.tdBalanceQueryActionForm.scrDisData.displayZeroBalanceList.item as ArrayCollection;
	        tempColl = new ArrayCollection();
	        selIndx = 0;
	        for(i = 0; i<initColl.length; i++) {
	            tempColl.addItem(initColl[i]);
	        }
	        displayZeroBalance.dataProvider = tempColl;
	        
	        //Initialize Office Id List
	        initColl.removeAll();
	        if(event.result.tdBalanceQueryActionForm.scrDisData.officeIdListTD.officeIdListTD is ArrayCollection){
	            	initColl = event.result.tdBalanceQueryActionForm.scrDisData.officeIdListTD.officeIdListTD as ArrayCollection;
	        	}
	        else {
	        		initColl.addItem(event.result.tdBalanceQueryActionForm.scrDisData.officeIdListTD.officeIdListTD);
	        	}
	        	tempColl = new ArrayCollection();
		        tempColl.addItem("");
		        for(i = 0; i<initColl.length; i++) {
		        	if(initColl[i].toString().indexOf("object") == -1)
		            tempColl.addItem(initColl[i]);
		        }
	        	officeId.dataProvider = tempColl;
	        	
	        //Initialize Security Type List
	        initColl.removeAll();
	        initColl = event.result.tdBalanceQueryActionForm.scrDisData.securityTypeList.item as ArrayCollection;
	        tempColl = new ArrayCollection();
	        tempColl.addItem({label:" ", value: " "});
	        selIndx = 0;
	        for(i = 0; i<initColl.length; i++) {
	            tempColl.addItem(initColl[i]);
	        }
	        securityType.dataProvider = tempColl;
	        
	        //Initialize Security Balance List
	        initColl.removeAll();
	        initColl = event.result.tdBalanceQueryActionForm.scrDisData.securityBalanceList.item as ArrayCollection;
	        tempColl = new ArrayCollection();
	        tempColl.addItem({label:" ", value: " "});
	        selIndx = 0;
	        for(i = 0; i<initColl.length; i++) {
	            tempColl.addItem(initColl[i]);
	        }
	        securityBalance.dataProvider = tempColl;

	        //Initialize sortFieldList1.
	        initColl.removeAll();
	        if(null != event.result.tdBalanceQueryActionForm.sortFieldList1.item){
	            tempColl = new ArrayCollection();
	            tempColl.addItem({label:" ", value: " "});
	            selIndx = 0;

	            initColl = event.result.tdBalanceQueryActionForm.sortFieldList1.item as ArrayCollection;
	            for(i = 0; i<initColl.length; i++) {
	                //Get the default value object's index
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
	            XenosAlert.error("Sort Order Field List 1 not Populated");
	        }

	        //Initialize sortFieldList2.
	        initColl.removeAll();
	        if(null != event.result.tdBalanceQueryActionForm.sortFieldList2.item){
	            tempColl = new ArrayCollection();
	            tempColl.addItem({label:" ", value: " "});
	            selIndx=0;

	            initColl = event.result.tdBalanceQueryActionForm.sortFieldList2.item as ArrayCollection;
	            for(i = 0; i<initColl.length; i++) {
	                //Get the default value object's index
	                if(XenosStringUtils.equals((initColl[i].value),sortField2Default)){
	                    selIndx = i;
	                }
	                tempColl.addItem(initColl[i]);
	            }

	            sortFieldArray[1]=sortField2;
		        sortFieldDataSet[1]=tempColl;
		        //Set the default value object
		        sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+2);
	        } else {
	            XenosAlert.error("Sort Order Field List 2 not Populated");
	        }

	        //Initialize sortFieldList3.
	        initColl.removeAll();
	        if(null != event.result.tdBalanceQueryActionForm.sortFieldList3.item){
	            tempColl = new ArrayCollection();
	            tempColl.addItem({label:" ", value: " "});
	            selIndx = 0;

	            initColl = event.result.tdBalanceQueryActionForm.sortFieldList3.item as ArrayCollection;
	            for(i = 0; i<initColl.length; i++) {
	                //Get the default value object's index
	                if(XenosStringUtils.equals((initColl[i].value),sortField3Default)){
	                    selIndx = i;
	                }

	                tempColl.addItem(initColl[i]);
	            }

	            sortFieldArray[2]=sortField3;
		        sortFieldDataSet[2]=tempColl;
		        //Set the default value object
		        sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx+3);

		        csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
		        csd.init();

	        } else {
	            XenosAlert.error("Sort Order Field List 3 not Populated");
	        }
	        
	        //Setting application date for date field
	        if(event.result.tdBalanceQueryActionForm.applicationDate!= null) {
	            dateStr=event.result.tdBalanceQueryActionForm.applicationDate;
	            if(dateStr != null)
	                date.selectedDate = DateUtils.toDate(dateStr);
	        } else {
	            XenosAlert.error("Error: Date cannot be initialized.");
	        }
	  }
    }

     private function sortOrder1Update():void{
     	 csd.update(sortField1.selectedItem,0);
     }

     private function sortOrder2Update():void{
     	csd.update(sortField2.selectedItem,1);
     }

     private function sortOrder3Update():void{
     	csd.update(sortField3.selectedItem,2);
     }
    
    /**
    * It sends/submits the query after validating the user input data.
    *
    */
     private function submitQuery():void
     {
     	//Reset Page No
         qh.resetPageNo();        
		 summaryResult.removeAll();
     	//Set the request parameters
         var requestObj :Object = populateRequestParams();
         TDBalanceQueryRequest.request = requestObj;
         //qh.resetPageNo();
         var tdBalanceModel:Object={
                            tdBalance:{
                                 date:this.date.text                
                            }
                           };
        //date validation
        var tdBalanceQueryValidator:TDBalanceQueryValidator = new TDBalanceQueryValidator();
		tdBalanceQueryValidator.source=tdBalanceModel;
		tdBalanceQueryValidator.property="tdBalance";
		var validationResult:ValidationResultEvent =tdBalanceQueryValidator.validate();

		if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            date.setFocus();
            XenosAlert.error(errorMsg);
        }
        else{
    		TDBalanceQueryRequest.send();
        } 
    }

    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
         var reqObj : Object = new Object();
         reqObj.method = "submitQuery";
	  	 reqObj.queryMode = "query";
	  	 reqObj.date = this.date.text;
	  	 reqObj.fundCode = this.fundCodePopup.fundCode.text;
	  	 reqObj.officeId = this.officeId.selectedItem != null ? this.officeId.selectedItem : XenosStringUtils.EMPTY_STR;
	  	 reqObj.securityCode = this.securityCodePopup.instrumentId.text;
	  	 reqObj.securityType = this.securityType.selectedItem != null ? StringUtil.trim(this.securityType.selectedItem.value) : XenosStringUtils.EMPTY_STR;
	  	 reqObj.currencyCode = this.currencyCodePopup.ccyText.text;
	  	 reqObj.securityBalance = this.securityBalance.selectedItem != null ? StringUtil.trim(this.securityBalance.selectedItem.value) : XenosStringUtils.EMPTY_STR;
	  	 reqObj.displayZeroBalance = this.displayZeroBalance.selectedItem != null ? StringUtil.trim(this.displayZeroBalance.selectedItem.value) : XenosStringUtils.EMPTY_STR;

 	     reqObj.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : XenosStringUtils.EMPTY_STR;
         reqObj.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : XenosStringUtils.EMPTY_STR;
       	 reqObj.sortField3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : XenosStringUtils.EMPTY_STR;
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
        TDBalanceQueryRequest.request = reqObj;
        TDBalanceQueryRequest.send(); 
    }

    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */
     private function doPrev():void {
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        TDBalanceQueryRequest.request = reqObj;
        TDBalanceQueryRequest.send(); 
    }

    /**
    * This method sends the HttpService for reset operation.
    *
    */
     private function resetQuery():void {
     	 TDBalanceResetQueryRequest.url = "nam/tdBalanceQueryDispatch.action?method=initialExecute&mode=query&&rnd=" + rndNo;
         TDBalanceResetQueryRequest.send(); 
    }

    /**
    * This method works as the result handler of the Submit Query Http Services.
    * This also takes care of the buttons/images to be shown on teh top panel of the
    * result.
    */
     private function LoadSummaryPage(event:ResultEvent):void {
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
                    summaryResult=ProcessResultUtil.process(summaryResult,balanceSummary.columns);
                    summaryResult.refresh();
                }catch(e:Error){
                    XenosAlert.error("No result found");
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
                XenosAlert.info("No Result Found!");
                summaryResult.removeAll(); // clear previous data if any as there is no result now.
                errPage.removeError(); //clears the errors if any
             }
        } 
     }
    /**
    * This method is used to show the detailed balance break up with 
    * Settled Balance .

    */
	public function getBalanceDetails(data:Object):void
	{
		if(data.securityType == "DRV-Security")

		{
			//for Balance detail view popup use
			dataSourceVal = data.dataSource;
				balanceDetailsPopup('DRV Future',data.balance,data.fundCode,data.securityId);
					}

	}



	/**

    * This method is used to show the detailed balance break up with 

    * Payable balance .

    */

	public function getPayBalanceDetails(data:Object):void

			{
		if(data.securityType == "CCY" && Number(data.payableBalance) != 0)

			{
				//for PayBalance detail view popup use

				dataSourceVal = data.dataSource;

				balanceDetailsPopup('Payable',numberFormatter.format(data.payableBalance),data.fundCode,data.securityId);

			}
			}
			
	/**

    * This method is used to show the detailed balance break up with 

    * Receivable balance .

    */

	public function getRecBalanceDetails(data:Object):void

		{
		if(data.securityType == "CCY" && Number(data.receivableBalance) != 0)

			{
				//for RecBalance detail view popup use

			dataSourceVal = data.dataSource;
				balanceDetailsPopup('Receivable',numberFormatter.format(data.receivableBalance),data.fundCode,data.securityId);

		}
	}

    /**
    * This method is used to show the detailed payable/receivable/drv future balance pop up
    */
	public function balanceDetailsPopup(balType:String,totBalance:String, fundCodeVal:String, securityIdVal:String):void

	{
		if(Number(totBalance) != 0)
		{
			var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,false));
			
			sPopup.title = "TD Balance "+balType+" Summary";
	        //set the width and height of the popup
	        sPopup.width = parentApplication.width - 400;
			sPopup.height = parentApplication.height - 350;
			
			sPopup.horizontalScrollPolicy="off";
			sPopup.verticalScrollPolicy="off";
			PopUpManager.centerPopUp(sPopup);
	
			var balanceTypeVal : String = balType;
			var totalBalanceVal : String = totBalance;
			var fundPkVal : String = "";
			var baseCcyVal : String = "";
			var officeIdVal : String = "";
			var loadDateVal : String = date.text;
			
			//Setting the Module path with some parameters which will be needed in the module for internal processing.
			sPopup.moduleUrl = "assets/appl/nam/TDBalanceDetailView.swf"+ Globals.QS_SIGN 	+ "balanceType"+ Globals.EQUALS_SIGN + balanceTypeVal + Globals.AND_SIGN
																							+ "totalBalance"+ Globals.EQUALS_SIGN + totalBalanceVal + Globals.AND_SIGN
																							+ "loadDate"+ Globals.EQUALS_SIGN + loadDateVal + Globals.AND_SIGN
																							+ "fundPk"+ Globals.EQUALS_SIGN + fundPkVal + Globals.AND_SIGN
																							+ "fundCode"+ Globals.EQUALS_SIGN + fundCodeVal + Globals.AND_SIGN
																							+ "securityId"+ Globals.EQUALS_SIGN + securityIdVal + Globals.AND_SIGN
																							+ "baseCcy"+ Globals.EQUALS_SIGN + baseCcyVal + Globals.AND_SIGN
																							+ "officeId"+ Globals.EQUALS_SIGN + officeIdVal + Globals.AND_SIGN
																							+ "dataSource"+ Globals.EQUALS_SIGN + dataSourceVal;
		}

	}
	
    /**
    * At the time of loading the module if the module specific Resource is not loaded then load them
    * Should be called at the creationComplete of the module
    */
     public function loadResourceBundle():void
     {
        var locales:String = this.parentApplication.xResourceManager.localeChain[0];
        var resourceModuleURL:String = "assets/appl/nam/namResources_" + locales + ".swf";

        var bundle:ResourceBundle = ResourceBundle(resourceManager.getResourceBundle(locales, "namResources"));
        var eventDispatcher:IEventDispatcher = null;
           if(bundle == null){
            eventDispatcher = this.parentApplication.xResourceManager.loadResourceModule(resourceModuleURL);
            eventDispatcher.addEventListener(ResourceEvent.ERROR, errorHandler);
        }
        this.parentApplication.xResourceManager.update();
    }

     private function errorHandler(event:ResourceEvent):void{
 //       xenosAlert.error("Error Occured while loading TDBalance Resource Bundle :: " + event.errorText);
    }

    /**
    * This is called at creationComplete of the module
    */
     private function loadAll():void {
        loadResourceBundle();
     }

    /**
    * This will generate the Xls report for the entire query result set
    * and will open in a separate window.
    */
     private function generateXls():void {
        var url : String = "nam/tdBalanceQueryDispatch.action?method=generateXLS";
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
        // set menu pk in the request
		var variables:URLVariables=new URLVariables();
		variables.menuPk=this.parentApplication.mdiCanvas.getwindowKey();
		request.data=variables;
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
        var url : String = "nam/tdBalanceQueryDispatch.action?method=generatePDF";
        var request:URLRequest = new URLRequest(url);
        request.method = URLRequestMethod.POST;
        // set menu pk in the request
		var variables:URLVariables=new URLVariables();
		variables.menuPk=this.parentApplication.mdiCanvas.getwindowKey();
		request.data=variables;
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
        printObject.frmPrintHeader.lbl.text = "Cam Movement Query";
        printObject.pDataGrid.dataProvider = balanceSummary.dataProvider;
        PrintDG.printAll(printObject); */
    }