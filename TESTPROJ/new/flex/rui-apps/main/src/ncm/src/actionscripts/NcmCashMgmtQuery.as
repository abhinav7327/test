
 // ActionScript file for Ncm Cash Management Query
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.HiddenObject;
    import com.nri.rui.core.utils.ProcessResultUtil;
    import com.nri.rui.ncm.validators.NcmCashMgmtQueryValidator;
    
    import mx.collections.ArrayCollection;
    import mx.events.ResourceEvent;
    import mx.events.ValidationResultEvent;
    import mx.resources.ResourceBundle;
    import mx.rpc.events.ResultEvent;
    
    [Bindable]
    private var summaryResult:ArrayCollection= new ArrayCollection();
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var rs:XML = new XML();
    
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    [Bindable]
    public var popupFlag:String = "";
    
    /**
     * This method should be called on creationComplete of the datagrid 
     */ 
     private function bindDataGrid():void {
        qh.dgrid = resultSummary;
    } 

    /**
     * Loading the initial configuaration.
     * 
     */
    private function loadAll():void {        
        //load();
    }
    
    
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    private function initPageStart():void {            
        if (!initCompFlg) {    
            rndNo= Math.random();
            var req : Object = new Object();
            req.SCREEN_KEY = 556;
            initializeNcmCashMgmtQuery.request = req;       
            initializeNcmCashMgmtQuery.url = "ncm/cashManagementQueryDispatch.action?method=initialExecute&rnd=" + rndNo;                    
            initializeNcmCashMgmtQuery.send();        
        } else
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.initiate'));
    }
    /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * 
    */   
    private function initPage(event: ResultEvent) : void {
        
        errPage.clearError(event); //clears the errors if any 
        
        //initiate text fields
        actPopUp.accountNo.text = "";        
        ccyBox.ccyText.text = "";
//        ccyBox.ccyText.setFocus();
        finInstPopUp.finInstCode.text = ""; 
        fundPopup.fundCode.text = "";
        fundPopup.fundCode.setFocus();       
    } 
    
    /**
       * This is the method to pass the Collection of data items
       * through the context to the FinInst popup. This will be implemented as per specifdic  
       * requirement. 
       */
     private function populateFinInstRole():ArrayCollection {
    //pass the context data to the popup
    var myContextList:ArrayCollection = new ArrayCollection(); 

    var bankRoleArray : Array = new Array(1);
    bankRoleArray[0] = "Bank/Custodian";
    myContextList.addItem(new HiddenObject("bankRoles",bankRoleArray));

    return myContextList;
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
         
         ncmCashMgmtQueryRequest.request = requestObj; 
        
         var ncmCashMgmtModel:Object={
                            NcmCash:{
                                 ccyBox: this.ccyBox.ccyText.text,
                                 bank: this.finInstPopUp.finInstCode.text,
                                 accountNo: this.actPopUp.accountNo.text,
                                 fundCode:this.fundPopup.fundCode.text              
                            }
                           }; 
        var ncmCashValidator:NcmCashMgmtQueryValidator = new NcmCashMgmtQueryValidator();
        ncmCashValidator.source=ncmCashMgmtModel;
        ncmCashValidator.property="NcmCash";
        
        var validationResult:ValidationResultEvent =ncmCashValidator.validate();

        if(validationResult.type==ValidationResultEvent.INVALID){
            var errorMsg:String=validationResult.message;
            //trace(errorMsg);
            XenosAlert.error(errorMsg);
            resultHead.text = "";
        }else { 
            // setting values which will be accessed by the ItemRenderer.
            //baseDateItemRndr = baseDate.text;
            //movBasisItemRndr = balanceBasis.selectedItem.value;
            //resultHead.text = movBasisItemRndr + " " + this.parentApplication.xResourceManager.getKeyValue('cam.balance.summary.label.balancebasis') + " " + baseDateItemRndr ;
            //send the submit request
            
            
            ncmCashMgmtQueryRequest.send();
        }
    } 
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
     private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        reqObj.SCREEN_KEY = 557;
        reqObj.method = "submitQuery";         
        reqObj.accountNo = this.actPopUp.accountNo.text;
        reqObj.currency = this.ccyBox.ccyText.text;
        reqObj.bank = this.finInstPopUp.finInstCode.text;
        reqObj.fundCode = this.fundPopup.fundCode.text;
        reqObj.rnd = Math.random() + "";
        return reqObj;
    }
    
    /**
    * This method sends the HttpService for reset operation.
    * 
    */
     private function resetQuery():void { 
        ncmCashMgmtResetQueryRequest.send();
    }
    
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    private function loadSummaryPage(event:ResultEvent):void
    {
        var rs:XML = XML(event.result);
        if (null != event) {
            if(rs.child("resultList").length()>0) {
                errPage.clearError(event);
                summaryResult.removeAll();
                try {
                    for each ( var rec:XML in rs.resultList ) {
                        summaryResult.addItem(rec);
                    }
                    
                    changeCurrentState();
                    qh.setOnResultVisibility();
                    
                    qh.setPrevNextVisibility((rs.prevTraversable == "true")?true:false,(rs.nextTraversable == "true")?true:false );
                    qh.PopulateDefaultVisibleColumns();
                    //replace null objects in datagrid with empty string
                    summaryResult=ProcessResultUtil.process(summaryResult, resultSummary.columns);
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
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specifdic  
      * requriment. 
      */
    private function populateContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
      
        //passing counter party type                
        var cpTypeArray:Array = new Array(2);
            cpTypeArray[0]="BANK/CUSTODIAN";
            cpTypeArray[1]="BROKER";
        myContextList.addItem(new HiddenObject("cpTypeContext",cpTypeArray));
    
        //passing account status 
        var actStatus:Array = new Array(1);
        actStatus[0]="OPEN";
        myContextList.addItem(new HiddenObject("statusContext",actStatus));
                       
        var actStatusArray:Array = new Array(2);
        actStatusArray[0]="S";
        actStatusArray[1]="B";
         myContextList.addItem(new HiddenObject("actTypeContext",actStatusArray));
        //Bank Code
        var bankCode:Array = new Array(1);
        bankCode[0] = this.finInstPopUp.finInstCode.text;
        myContextList.addItem(new HiddenObject("stlFinInstCodeContext",bankCode));
        return myContextList;
    }
    
    
    
    /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
        var url : String = "ncm/cashManagementQueryDispatch.action?method=generateXLS";
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
        var url : String = "ncm/cashManagementQueryDispatch.action?method=generatePDF";
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
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
      private function doNext():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
        ncmCashMgmtQueryRequest.request = reqObj;
        ncmCashMgmtQueryRequest.send();
    }  
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
      private function doPrev():void { 
        var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        ncmCashMgmtQueryRequest.request = reqObj;
        ncmCashMgmtQueryRequest.send();
    }   