
  // ActionScript file for Nam Feed Resend Query
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.controls.CustomizeSortOrder;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.DateUtils;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.nam.validators.NamFeedQueryValidator;
 import com.nri.rui.core.containers.SummaryPopup;

 import flash.net.URLRequest;
 import flash.net.URLRequestMethod;
 
 import mx.collections.ArrayCollection;
 import mx.events.ResourceEvent;
 import mx.events.ValidationResultEvent;
 import mx.resources.ResourceBundle;
 import mx.rpc.events.ResultEvent;
 import mx.utils.StringUtil;

    [Bindable]
    private var initColl:ArrayCollection;
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    [Bindable]
    private var confirmResult:ArrayCollection= new ArrayCollection();
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    [Bindable]
    private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);

    [Bindable]
    private var selectedResults:ArrayCollection=new ArrayCollection();

    [Bindable]
    public var selectAllBind:Boolean=false;
    public var rowNum : ArrayCollection=new ArrayCollection();
	private var tempArray : Array = new Array();
	private var rowNumArray : Array = new Array();
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();

    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    private var  csd:CustomizeSortOrder=null;
 
     /**
     * This method should be called on creationComplete of the datagrid
     */
     private function bindDataGrid():void {
        qh.dgrid = resultSummary;
    }

    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    *
    * This will fetch data to fill the initial form data to show the user.
    */
     private function initPageStart():void {
        if (!initCompFlg) {
            rndNo= Math.random();
            initializeNamFeedQuery.url = "nam/namFeedStatusQueryDispatch.action?method=initialExecute&mode=resend&&rnd=" + rndNo;
            initializeNamFeedQuery.send();
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
	        initColl = new ArrayCollection();
	        //variables to hold the default values from the server
	        var sortField1Default:String = event.result.namFeedStatusQueryActionForm.sortField1;
	        var sortField2Default:String = event.result.namFeedStatusQueryActionForm.sortField2;
	        var sortField3Default:String = event.result.namFeedStatusQueryActionForm.sortField3;

	        errPage.clearError(event); //clears the errors if any

	        //initiate text fields
	        intfPopUp.interfaceId.text = "";
	        interfaceName.text = "";
	        officeId.text = "";
	        xnsRefNo.text = "";
	        destinationSystem.text = "";
	        destSystemRefno.text = "";
	        destinationSystem.setFocus();
	        feedType.text = "";
	        srcComponent.text = "";
	        feedStatus.text = "";
	        // creationDate.text = "";
	        acceptanceStatus.text = "";
	        errorId.text = "";
	        errorMsg.text = "";
			// fundPopUp.fundCode.text = "";
			// fundPopUp.setFocus();

			//For IntfPopup destination system combobox Load
			intfPopUp.intfQueryMode = "resend";
		
	 		if(event.result){
	 			initColl.removeAll();
	        	if(event.result.namFeedStatusQueryActionForm.scrDisData.resendDesSysList.resendDesSysList is ArrayCollection){
            		initColl = event.result.namFeedStatusQueryActionForm.scrDisData.resendDesSysList.resendDesSysList as ArrayCollection;   	
        		}
        		else {
        			initColl.addItem(event.result.namFeedStatusQueryActionForm.scrDisData.resendDesSysList.resendDesSysList);
        		}
	        	tempColl = new ArrayCollection();
		        tempColl.addItem("");
		        for(i = 0; i<initColl.length; i++) {
		        	if(initColl[i].toString().indexOf("object") == -1)
		            tempColl.addItem(initColl[i]);
		        }
	        	destinationSystem.dataProvider = tempColl;

			initColl.removeAll();
	        if(event.result.namFeedStatusQueryActionForm.scrDisData.srcComponentList.srcComponentList is ArrayCollection){
	            	initColl = event.result.namFeedStatusQueryActionForm.scrDisData.srcComponentList.srcComponentList as ArrayCollection;
	        	}
	        else {
	        		initColl.addItem(event.result.namFeedStatusQueryActionForm.scrDisData.srcComponentList.srcComponentList);
	        	}
	        	tempColl = new ArrayCollection();
		        tempColl.addItem("");
		        for(i = 0; i<initColl.length; i++) {
		        	if(initColl[i].toString().indexOf("object") == -1)
		            tempColl.addItem(initColl[i]);
		        }
	        	srcComponent.dataProvider = tempColl;

				initColl.removeAll();
	        	if(event.result.namFeedStatusQueryActionForm.scrDisData.officeIdList.officeIdList is ArrayCollection){
	            	initColl = event.result.namFeedStatusQueryActionForm.scrDisData.officeIdList.officeIdList as ArrayCollection;
	        	}
	        else {
	        		initColl.addItem(event.result.namFeedStatusQueryActionForm.scrDisData.officeIdList.officeIdList);
	        	}
	        	tempColl = new ArrayCollection();
		        tempColl.addItem("");
		        for(i = 0; i<initColl.length; i++) {
		        	if(initColl[i].toString().indexOf("object") == -1)
		            tempColl.addItem(initColl[i]);
		        }
	        	officeId.dataProvider = tempColl;

	       //Initialize Feed Type List
	        initColl.removeAll();
	        initColl = event.result.namFeedStatusQueryActionForm.scrDisData.feedTypeList.item as ArrayCollection;
	        tempColl = new ArrayCollection();
	        tempColl.addItem({label:" ", value: " "});
	        selIndx = 0;
	        for(i = 0; i<initColl.length; i++) {
	            tempColl.addItem(initColl[i]);
	        }
	        feedType.dataProvider = tempColl;

	        //Initialize Acceptance Status List
	        initColl.removeAll();
	        initColl = event.result.namFeedStatusQueryActionForm.scrDisData.acceptanceStatusList.item as ArrayCollection;
	        tempColl = new ArrayCollection();
	        tempColl.addItem({label:" ", value: " "});
	        selIndx = 0;
	        for(i = 0; i<initColl.length; i++) {
		        tempColl.addItem(initColl[i]);
	        }
	        acceptanceStatus.dataProvider = tempColl;

	       //Initialize Feed Status List
	        initColl.removeAll();
	        initColl = event.result.namFeedStatusQueryActionForm.scrDisData.xenosStatusList.item as ArrayCollection;
	        tempColl = new ArrayCollection();
	        tempColl.addItem({label:" ", value: " "});
	        selIndx = 0;
	        for(i = 0; i<initColl.length; i++) {
	            tempColl.addItem(initColl[i]);
	        }
	        feedStatus.dataProvider = tempColl;

	        //Initialize sortFieldList1.
	        initColl.removeAll();
	        if(null != event.result.namFeedStatusQueryActionForm.sortFieldList1.item){
	            tempColl = new ArrayCollection();
	            tempColl.addItem({label:" ", value: " "});
	            selIndx = 0;

	            initColl = event.result.namFeedStatusQueryActionForm.sortFieldList1.item as ArrayCollection;
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
	        if(null != event.result.namFeedStatusQueryActionForm.sortFieldList2.item){
	            tempColl = new ArrayCollection();
	            tempColl.addItem({label:" ", value: " "});
	            selIndx=0;

	            initColl = event.result.namFeedStatusQueryActionForm.sortFieldList2.item as ArrayCollection;
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
	        if(null != event.result.namFeedStatusQueryActionForm.sortFieldList3.item){
	            tempColl = new ArrayCollection();
	            tempColl.addItem({label:" ", value: " "});
	            selIndx = 0;
	            initColl = event.result.namFeedStatusQueryActionForm.sortFieldList3.item as ArrayCollection;
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
        	//Setting dateFrom and dateTo
	        if(event.result.namFeedStatusQueryActionForm.creationDate!= null) {
	            dateStr=event.result.namFeedStatusQueryActionForm.creationDate;
	            if(dateStr != null)
	                creationDate.selectedDate = DateUtils.toDate(dateStr);
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
     	//Set for Resend Checkbox
     	  if(selectedResults!=null){
       			selectedResults.removeAll();
       		}
         //Set the request parameters
         var requestObj :Object = populateRequestParams();
         NamFeedQueryRequest.request = requestObj;
         qh.resetPageNo();
         var myModel:Object={
                            namFeed:{
										interfaceId:this.intfPopUp.interfaceId.text,
										interfaceName:this.interfaceName.text,
										officeId:this.officeId.selectedItem,
										xnsRefNo:this.xnsRefNo.text,
										destinationSystem:this.destinationSystem.selectedItem,
										destSystemRefno:this.destSystemRefno.text,
										feedType:this.feedType.selectedItem,
										srcComponent:this.srcComponent.selectedItem,
										feedStatus:this.feedStatus.selectedItem,
										creationDate:this.creationDate.text,
										acceptanceStatus:this.acceptanceStatus.selectedItem,
										errorId:this.errorId.text,
										errorMsg:this.errorMsg.text
                            	}
                           };

        if(this.destinationSystem.selectedItem == null || this.destinationSystem.selectedItem == "")
        {
        	destinationSystem.setFocus();
        	XenosAlert.error("Please Select Destination System.");
        }
        else if(this.officeId.selectedItem == null || this.officeId.selectedItem == "")
        {
        	officeId.setFocus();
        	XenosAlert.error("Please Select Office ID.");
        }
        else
        {
	        //date validation
	        var namQueryValidator:NamFeedQueryValidator = new NamFeedQueryValidator();
			namQueryValidator.source=myModel;
			namQueryValidator.property="namFeed";
			var validationResult:ValidationResultEvent =namQueryValidator.validate();

			if(validationResult.type==ValidationResultEvent.INVALID){
	            var errorMsg:String=validationResult.message;
	            creationDate.setFocus();
	            XenosAlert.error(errorMsg);
	        }
	        else{
	    		NamFeedQueryRequest.send();
	        }
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
	  	 reqObj.queryMode = "resend";
         reqObj.interfaceId = this.intfPopUp.interfaceId.text;
         reqObj.interfaceName = this.interfaceName.text;
         reqObj.officeId = this.officeId.selectedItem != null ? this.officeId.selectedItem : XenosStringUtils.EMPTY_STR;
         reqObj.xnsRefNo = this.xnsRefNo.text;
         reqObj.destSystemRefno=this.destSystemRefno.text;
         reqObj.destinationSystem = this.destinationSystem.selectedItem != null ? this.destinationSystem.selectedItem : XenosStringUtils.EMPTY_STR;
         reqObj.feedType = this.feedType.selectedItem != null ? StringUtil.trim(this.feedType.selectedItem.value) : XenosStringUtils.EMPTY_STR;
         reqObj.feedTxnType = this.srcComponent.selectedItem != null ? this.srcComponent.selectedItem : XenosStringUtils.EMPTY_STR;
         reqObj.status = this.feedStatus.selectedItem != null ? StringUtil.trim(this.feedStatus.selectedItem.value) : XenosStringUtils.EMPTY_STR;

         reqObj.creationDate = this.creationDate.text;
         reqObj.acceptanceStatus = this.acceptanceStatus.selectedItem != null ? StringUtil.trim(this.acceptanceStatus.selectedItem.value) : XenosStringUtils.EMPTY_STR;
         reqObj.errorId = this.errorId.text;
         reqObj.errorMsg = this.errorMsg.text;

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
        NamFeedQueryRequest.request = reqObj;
        NamFeedQueryRequest.send();
    }

    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */
     private function doPrev():void {
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        NamFeedQueryRequest.request = reqObj;
        NamFeedQueryRequest.send();
    }

    /**
    * This method sends the HttpService for reset operation.
    *
    */
     private function resetQuery():void {
     	 NamFeedResetQueryRequest.url = "nam/namFeedStatusQueryDispatch.action?method=initialExecute&mode=query&&rnd=" + rndNo;
         NamFeedResetQueryRequest.send();
     }

    /**
    * This method works as the result handler of the Submit Query Http Services.
    * This also takes care of the buttons/images to be shown on teh top panel of the
    * result.
    */
     public function LoadSummaryPage(event:ResultEvent):void {
     	btnResend.setFocus();
        var rs:XML = XML(event.result);
        selectAllBind = false;
        rowNum.removeAll();
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
                    summaryResult.refresh();
                    resetSellection(summaryResult);
                    setIfAllSelected();
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
		//  xenosAlert.error("Error Occured while loading Nam Resource Bundle :: " + event.errorText);
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
        var url : String = "nam/namFeedStatusQueryDispatch.action?method=generateXLS";
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
        var url : String = "nam/namFeedStatusQueryDispatch.action?method=generatePDF";
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
        printObject.frmPrintHeader.lbl.text = "Cam Movement Query";
        printObject.pDataGrid.dataProvider = movementSummary.dataProvider;
        PrintDG.printAll(printObject); */
    }

	/**
	 * Used to select all records together.
	 */
    public function selectAllRecs(flag:Boolean): void {
    	var i:Number = 0;
    	rowNum = new ArrayCollection();
    	for(i=0; i<summaryResult.length; i++){
            summaryResult[i].selected = flag;
            addOrRemove(summaryResult[i],i);
    	}    	
    	if(summaryResult.length>0)
    	{
    		summaryResult.refresh();
    	}
    	
     }

    /**
    * Determines whether the record needs to be added for resend
    * or deleted according the selected value of teh Check Box.
    */
     private function addOrRemove(item:Object,ix : int):void {
     	var i:int = 0;
     	var j:int = 0;
        if(item.selected == true){ // need to insert
        	rowNum.addItem(item.intfFeedDetailPk);
    	}else { //need to pop
    		tempArray=rowNum.toArray();
    	    rowNum.removeAll();
    		for(i=0; i<tempArray.length; i++){
    			if(tempArray[i] != item.intfFeedDetailPk){
    			    rowNum.addItem(tempArray[i]);
    			}
    		}
    	}
    }

	/**
	 * Check one by one selection.
	 */
	public function checkSelectToModify(item:Object,ix:int):void {
		var i:int = 0;
		addOrRemove(item,ix);
		setIfAllSelected();
	}

	/**
	 * sets all selected.
	 */
	private function setIfAllSelected() : void {
		if(isAllSelected()){
			selectAllBind=true;
		} else {
			selectAllBind=false;
		}
	}

	/**
	 * Checks whether all the records are selected one by one then make all selected true.
	 *
	 */
	private function isAllSelected(): Boolean {
		var i:int = 0;
		if(summaryResult == null){
			return false;
		}
		for(i=0; i<summaryResult.length; i++){
			if(summaryResult[i].selected == false) {
				return false;
			}
			//return false;
		}		
		if(i == summaryResult.length) {
			return true;
		 }else {
			return false;
		}		
	}

      private function resetSellection(summaryResult:ArrayCollection):void{
      	rowNum.removeAll();
    	for(var i:int=0;i<summaryResult.length;i++){
    		summaryResult[i].selected = false;
    		addOrRemove(summaryResult[i],i);
    	}
    }

   /**
    * It resend feed record the query. 
    *
    */
     private function resendQry():void
    {
    	if(rowNum.length == 0){
     		XenosAlert.info("Please select at least one record");
     	}else{
     		btnResend.enabled = false;
     		var requestObj :Object = populateRequestSendParams();
      		feedRecordResend.request = requestObj;
      		feedRecordResend.send()
     	}
    }

    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestSendParams():Object {
        var reqObj : Object = new Object();
        rowNumArray = rowNum.toArray();
        reqObj.SCREEN_KEY = 11063;
    	reqObj['selector'] = rowNumArray;
    	reqObj.method = "sessionForm";
		return reqObj;
    }

    private function confirmHandler(event:ResultEvent):void {
       	feedResendPopup = FeedFileResend(PopUpManager.createPopUp(this, FeedFileResend, true));
        feedResendPopup.width = this.parentApplication.width - 100;
        feedResendPopup.addEventListener("OkSystemConfirm", handleOkSystemConfirm);
        feedResendPopup.addEventListener("enableButton", enableButton);
      	var rs:XML = XML(event.result);

                var tempResult:ArrayCollection = new ArrayCollection();
		 		if (null != event) {
		 			feedResendPopup.errorInfoList = new ArrayCollection();
		 			if(rs.child("Errors").length()>0){
						// i.e. Must be error, display it .
						//populate the error info list
						for each ( var error:XML in rs.Errors.error ) {
							//errorInfoList.addItem(error.toString());
							feedResendPopup.errorInfoList.addItem(error.toString());
						}
					//	feedResendPopup.errPage.showError(errorInfoList);//Display the error
			      	}else {
			      	 	//feedResendPopup.errPage.removeError();
		                if(event.result.rows.row != null){
		                    if(event.result.rows.row is ArrayCollection) {
		                            tempResult = event.result.rows.row as ArrayCollection;
		                    } else {
		                            tempResult.addItem(event.result.rows.row);
		                    }
		                }
                        confirmResult = tempResult;
                        feedResendPopup.dProvider = confirmResult;                        
                        //replace null objects in datagrid with empty string
                    	feedResendPopup.dProvider=ProcessResultUtil.process(feedResendPopup.dProvider,feedResendPopup.resultSummary.columns);
                    	feedResendPopup.dProvider.refresh();
                    
				        feedResendPopup.formData = rs;
                    }
                }else {
                    confirmResult.removeAll();
                    XenosAlert.info("No Results Found");
                }
        feedResendPopup.title = "Feed Re-Send User Confirmation";
        PopUpManager.centerPopUp(feedResendPopup);
     }

    public function handleOkSystemConfirm(event:Event):void {
    	btnResend.enabled = true;
	 	currentState="";
	 	initPageStart();
	}

    /**
	* Enables the Send/Resend button once the pop-up is closed.
	* Note : The buttons were disabled to prevent multiple pop-up's from being opened.
    */
     public function enableButton(event:Event):void {
	   btnResend.enabled = true;
	}