
 // ActionScript file for Cam Portfolio Balancde Query
 
    import com.nri.rui.cam.validators.PortfolioBalanceValidator;
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.HiddenObject;
    import com.nri.rui.core.utils.XenosStringUtils;
    import com.nri.rui.core.controls.CustomizeSortOrder;
    import com.nri.rui.core.utils.ProcessResultUtil;

    import mx.collections.ArrayCollection;
    import mx.controls.ComboBox;
    import mx.events.ResourceEvent;
    import mx.events.ValidationResultEvent;
	import mx.formatters.DateFormatter;
    import mx.formatters.NumberBase;
    import mx.resources.ResourceBundle;
    import mx.rpc.events.ResultEvent;
    import mx.utils.ObjectUtil;
    import mx.utils.StringUtil;
    
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    public var baseDateItemRndr:String = ""; // Nedded to hold value at submit time to pass in the ItemRenderer
    public var movBasisItemRndr:String = ""; // Nedded to hold value at submit time to pass in the ItemRenderer
    public var isBalanceQuery:Boolean = false; // Nedded to hold value at submit time to pass in the ItemRenderer 
                                              //to decide the accountNo field name
    
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    
    private var  csd:CustomizeSortOrder=null;
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();

    /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
        qh.dgrid = resultSummary;
    } 
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    private function initPageStart():void {            
        if (!initCompFlg) {    
            rndNo= Math.random();
            var req : Object = new Object();
            req.SCREEN_KEY = 241;
            initializePortfolioBalanceQuery.request = req;         
            initializePortfolioBalanceQuery.url = "cam/camPortfolioBalanceQueryDispatch.action?method=initialExecute&rnd=" + rndNo;                    
            initializePortfolioBalanceQuery.send();        
        } else
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.initiate'));
    }
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * 
    */   
    private function initPage(event: ResultEvent) : void {
        var i:int = 0;
        var selIndx:int = 0;
        var dateStr:String = null;
        var initColl:ArrayCollection = new ArrayCollection();
        var tempColl: ArrayCollection;
        
        errPage.clearError(event); //clears the errors if any 
        
        //initiate text fields
        actPopUp.accountNo.text = "";        
        ccyBox.ccyText.text = "";        
        instPopUp.instrumentId.text="";
        instrumentType.text = "";
        //fndCode.text = "";
        issueCcyBox.ccyText.text = "";
        fundPopUp.fundCode.text = "";
        
        
        if(event == null || event.result == null || event.result.camPortfolioBalanceQueryActionForm ==null){
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('cam.common.prompt.init.failed'));
            return;
        }        
        
        var defaultBalanceBasis:String = event.result.camPortfolioBalanceQueryActionForm.balanceBasis;
        var defaultBalancePl:String = event.result.camPortfolioBalanceQueryActionForm.balancePl;
        var sortField1Default:String = event.result.camPortfolioBalanceQueryActionForm.sortField1;
        var sortField2Default:String = event.result.camPortfolioBalanceQueryActionForm.sortField2;
        var sortField3Default:String = event.result.camPortfolioBalanceQueryActionForm.sortField3;
        
        //1.Setting value of baseDate
        if(event.result.camPortfolioBalanceQueryActionForm.baseDate!= null) {
            dateStr=event.result.camPortfolioBalanceQueryActionForm.baseDate;
            if(dateStr != null)
                baseDate.selectedDate = DateUtils.toDate(dateStr);                
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('cam.common.prompt.init.basedate.failed'));
        }
        
        //2. Setting values of the Balance Basis
        initColl.removeAll();
        if(event.result.camPortfolioBalanceQueryActionForm.balanceTypes.item != null) {
            if(event.result.camPortfolioBalanceQueryActionForm.balanceTypes.item is ArrayCollection)
                initColl = event.result.camPortfolioBalanceQueryActionForm.balanceTypes.item as ArrayCollection;
            else
                initColl.addItem(event.result.camPortfolioBalanceQueryActionForm.balanceTypes.item);
        }
    
        tempColl = new ArrayCollection();
        selIndx = 0;
        //tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            //Get the default value object's index
            if(XenosStringUtils.equals((initColl[i].value),defaultBalanceBasis)){                    
                selIndx = i;
            }
            tempColl.addItem(initColl[i]);
        }
        balanceBasis.dataProvider = tempColl;
        //Set the default value object
        balanceBasis.selectedItem = tempColl.getItemAt(selIndx);
        
        baseDate.setFocus();
        //3. Setting values of the longShortCategory
        initColl.removeAll();
        if(event.result.camPortfolioBalanceQueryActionForm.longShortCategorys.item != null) {
            if(event.result.camPortfolioBalanceQueryActionForm.longShortCategorys.item is ArrayCollection)
                initColl = event.result.camPortfolioBalanceQueryActionForm.longShortCategorys.item as ArrayCollection;
            else
                initColl.addItem(event.result.camPortfolioBalanceQueryActionForm.longShortCategorys.item);
        }
    
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            tempColl.addItem(initColl[i]);
        }
        longShortCategory.dataProvider = tempColl;
        
        //4. Setting values of the balancePl
        initColl.removeAll();
        if(event.result.camPortfolioBalanceQueryActionForm.balancePlList.item != null) {
            if(event.result.camPortfolioBalanceQueryActionForm.balancePlList.item is ArrayCollection)
                initColl = event.result.camPortfolioBalanceQueryActionForm.balancePlList.item as ArrayCollection;
            else
                initColl.addItem(event.result.camPortfolioBalanceQueryActionForm.balancePlList.item);
        }
    
        tempColl = new ArrayCollection();
        selIndx = 0;
//        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            //Get the default value object's index
            if(XenosStringUtils.equals((initColl[i].value),defaultBalancePl)){                    
                selIndx = i;
            }
            tempColl.addItem(initColl[i]);
        }
        balancePl.dataProvider = tempColl;
        //Set the default value object
        balancePl.selectedItem = tempColl.getItemAt(selIndx);
        
        //5. Setting values of the inventoryAccountType
//        initColl.removeAll();
//        if(event.result.camPortfolioBalanceQueryActionForm.inventoryAccountTypeList.item != null) {
//            if(event.result.camPortfolioBalanceQueryActionForm.inventoryAccountTypeList.item is ArrayCollection)
//                initColl = event.result.camPortfolioBalanceQueryActionForm.inventoryAccountTypeList.item as ArrayCollection;
//            else
//                initColl.addItem(event.result.camPortfolioBalanceQueryActionForm.inventoryAccountTypeList.item);
//        }
//    
//        tempColl = new ArrayCollection();
//        tempColl.addItem({label:" ", value: " "});
//        for(i = 0; i<initColl.length; i++) {
//            tempColl.addItem(initColl[i]);
//        }
//        inventoryAccountType.dataProvider = tempColl;
        
        //6. Setting values of the sortField1
        initColl.removeAll();
        if(event.result.camPortfolioBalanceQueryActionForm.sortFieldList1.item != null) {
            if(event.result.camPortfolioBalanceQueryActionForm.sortFieldList1.item is ArrayCollection)
                initColl = event.result.camPortfolioBalanceQueryActionForm.sortFieldList1.item as ArrayCollection;
            else
                initColl.addItem(event.result.camPortfolioBalanceQueryActionForm.sortFieldList1.item);
        }
    
        tempColl = new ArrayCollection();
        selIndx = 0;
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            //Get the default value object's index
            if(XenosStringUtils.equals((initColl[i].value),sortField1Default)){                    
                selIndx = i;
            }
            tempColl.addItem(initColl[i]);
        }
        
      
        //Set the default value object
        //.selectedItem = tempColl.getItemAt(selIndx+1);
        
        sortFieldArray[0]=sortField1;
        sortFieldDataSet[0]=tempColl;
        //Set the default value object
        sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
        
        //7. Setting values of the sortField2
        initColl.removeAll();
        if(event.result.camPortfolioBalanceQueryActionForm.sortFieldList2.item != null) {
            if(event.result.camPortfolioBalanceQueryActionForm.sortFieldList2.item is ArrayCollection)
                initColl = event.result.camPortfolioBalanceQueryActionForm.sortFieldList2.item as ArrayCollection;
            else
                initColl.addItem(event.result.camPortfolioBalanceQueryActionForm.sortFieldList2.item);
        }
    
        tempColl = new ArrayCollection();
        selIndx = 0;
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            //Get the default value object's index
            if(XenosStringUtils.equals((initColl[i].value),sortField2Default)){                    
                selIndx = i;
            }
            tempColl.addItem(initColl[i]);
        }
        //sortField2.dataProvider = tempColl;
        sortFieldArray[1]=sortField2;
        sortFieldDataSet[1]=tempColl;
        //Set the default value object
        sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);
        
        //8. Setting values of the sortField3
        initColl.removeAll();
        if(event.result.camPortfolioBalanceQueryActionForm.sortFieldList3.item != null) {
            if(event.result.camPortfolioBalanceQueryActionForm.sortFieldList3.item is ArrayCollection)
                initColl = event.result.camPortfolioBalanceQueryActionForm.sortFieldList3.item as ArrayCollection;
            else
                initColl.addItem(event.result.camPortfolioBalanceQueryActionForm.sortFieldList3.item);
        }
    
        tempColl = new ArrayCollection();
        selIndx = 0;
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initColl.length; i++) {
            //Get the default value object's index
            if(XenosStringUtils.equals((initColl[i].value),sortField3Default)){                    
                selIndx = i;
            }
            tempColl.addItem(initColl[i]);
        }
        //sortField3.dataProvider = tempColl;
        //Set the default value object
       // sortField3.selectedItem = tempColl.getItemAt(selIndx+1);
       
        sortFieldArray[2]=sortField3;
        sortFieldDataSet[2]=tempColl;
        //Set the default value object
        sortFieldSelectedItem[2] = tempColl.getItemAt(selIndx+1);
        
        
        //set data provider
       // sortFieldArray={sortField1,sortField2,sortField3};
       
        csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
        csd.init();
        
        //9. Setting values of the sortField4
//        initColl.removeAll();
//        if(event.result.camPortfolioBalanceQueryActionForm.sortFieldList4.item != null) {
//            if(event.result.camPortfolioBalanceQueryActionForm.sortFieldList4.item is ArrayCollection)
//                initColl = event.result.camPortfolioBalanceQueryActionForm.sortFieldList4.item as ArrayCollection;
//            else
//                initColl.addItem(event.result.camPortfolioBalanceQueryActionForm.sortFieldList4.item);
//        }
//    
//        tempColl = new ArrayCollection();
//        tempColl.addItem({label:" ", value: " "});
//        for(i = 0; i<initColl.length; i++) {
//            tempColl.addItem(initColl[i]);
//        }
//        sortField4.dataProvider = tempColl;
       
    }
    
     private function sortOrder1Update():void{
         csd.update(sortField1.selectedItem,0);
     }
     
     private function sortOrder2Update():void{      
        csd.update(sortField2.selectedItem,1);
     }
    /**
    * It sends/submits the query. 
    * 
    */
    private function submitQuery():void 
    {  
		if (!validateBaseDate()) {
			return;
		}
		
        //Reset Page No
        qh.resetPageNo();  
        //Set the request parameters
         var requestObj :Object = populateRequestParams();
         
         portfolioBalanceQueryRequest.request = requestObj; 
        
        var pfoModel:Object={
                            pfoBalance:{
                                 balanceBasis:(this.balanceBasis.selectedItem !=null? this.balanceBasis.selectedItem.value : ""),
                                 baseDate:this.baseDate.text                
                            }
                           }; 
        var pfoBalanceValidator:PortfolioBalanceValidator = new PortfolioBalanceValidator();
        pfoBalanceValidator.source=pfoModel;
        pfoBalanceValidator.property="pfoBalance";
        
        var validationResult:ValidationResultEvent =pfoBalanceValidator.validate();

        if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            //trace(errorMsg);
            XenosAlert.error(errorMsg);
            resultHead.text = "";
        }else {
            // setting values which will be accessed by the ItemRenderer.
            baseDateItemRndr = baseDate.text;
            movBasisItemRndr = balanceBasis.selectedItem.label;
            resultHead.text = movBasisItemRndr.toUpperCase() + " " + this.parentApplication.xResourceManager.getKeyValue('cam.portfoliobalance.summary.label.portfoliobalance') + " " + baseDateItemRndr ;
            qh.resetPageNo();
            //send the submit request
            portfolioBalanceQueryRequest.send();
        }               
    }
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        reqObj.SCREEN_KEY = 244;
         reqObj.method = "submitQuery";         
        reqObj.baseDate = baseDate.text;
        reqObj.balanceBasis = (this.balanceBasis.selectedItem != null ? balanceBasis.selectedItem.value : "");
        reqObj.fundCode = this.fundPopUp.fundCode.text;
        reqObj.accountNo = this.actPopUp.accountNo.text;
        reqObj.currency = this.ccyBox.ccyText.text;
        
        reqObj.instrumentType = this.instrumentType.itemCombo.text;
        reqObj.securityCode = this.instPopUp.instrumentId.text;
        reqObj.longShortCategory = (this.longShortCategory.selectedItem != null ? longShortCategory.selectedItem.value : "");
        reqObj.balancePl = (this.balancePl.selectedItem != null ? balancePl.selectedItem.value : "");
//        reqObj.inventoryAccountType = (this.inventoryAccountType.selectedItem != null ? inventoryAccountType.selectedItem.value : "");
        
        reqObj.issueCurrency = issueCcyBox.ccyText.text;
        reqObj.sortField1 = (this.sortField1.selectedItem != null ? StringUtil.trim(sortField1.selectedItem.value) : "");
        reqObj.sortField2 = (this.sortField2.selectedItem != null ? StringUtil.trim(sortField2.selectedItem.value) : "");
        reqObj.sortField3 = (this.sortField3.selectedItem != null ? StringUtil.trim(sortField3.selectedItem.value) : "");
//        reqObj.sortField4 = (this.sortField4.selectedItem != null ? sortField4.selectedItem.value : "");
         reqObj.rnd = Math.random() + "";
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
        portfolioBalanceQueryRequest.request = reqObj;
        portfolioBalanceQueryRequest.send();
    } 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        portfolioBalanceQueryRequest.request = reqObj;
        portfolioBalanceQueryRequest.send();
    }
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
    private function resetQuery():void { 
        portfolioResetQueryRequest.send();
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

    /**
     * Loading the initial configuaration.
     * 
     */
    private function loadAll():void {
        //load();
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
            cpTypeArray[0]="INTERNAL";
            //cpTypeArray[1]="CLIENT";
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
    
        //passing account status                
        var actStatusArray:Array = new Array(1);
        actStatusArray[0]="OPEN";
        myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
        return myContextList;
    }
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
        var url : String = "cam/camPortfolioBalanceQueryDispatch.action?method=generateXLS";
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
        var url : String = "cam/camPortfolioBalanceQueryDispatch.action?method=generatePDF";
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
    
    private function numaricCompareFunc(itemA:Object, itemB:Object):int {
        var dataFormatter:NumberBase = new NumberBase(".",",",
                                                      ".",",");
        var valueA:Number = Number(dataFormatter.parseNumberString(itemA.formattedPosition));
        var valueB:Number = Number(dataFormatter.parseNumberString(itemB.formattedPosition));
        return ObjectUtil.numericCompare(valueA, valueB);
    }
	
	private function validateBaseDate():Boolean {
		
		// Remove errors
		errPage.removeError();
		
		var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
		var matches:XMLList = app.cachedItems.retentionDates.date.(@component == "CAM");
		trace("matches : " + matches.toXMLString());
		if (matches == null || matches.length() == 0) {
			return true;
		}
		var retentionDate:String = matches[0].@value;
		trace("retentionDate : " + retentionDate);

		var errors:ArrayCollection = new ArrayCollection();
		var dateLabel:String = this.parentApplication.xResourceManager.getKeyValue('cam.portfoliobalance.query.label.date');
		var dateValue:String = this.baseDate.text;
		trace("dateLabel: " + dateLabel);
		trace("dateValue: " + dateValue);
		
		var year:Number = parseInt(dateValue.substring(0, 4));
		var month:Number = parseInt(dateValue.substring(4, 6)) - 1;
		var date:Number = parseInt(dateValue.substring(6, 8));
		trace("new Date(year, month, date): " + new Date(year, month, date));

		if (new Date(year, month, date).getTime() < new Date(retentionDate).getTime()) {
		
			var formatter:DateFormatter = new DateFormatter();
			formatter.formatString = "YYYYMMDD";
			var retentionDateStr:String = formatter.format(retentionDate);
			var msg:String = dateLabel + " is less than Retention Start Date - [" + retentionDateStr + "].";
			errors.addItem(msg);
		}
			
		if (errors.length > 0) {
			errPage.showError(errors);
			return false;
		}
		return true;
		
	}

    