// ActionScript file
    import com.nri.rui.cam.validators.CamSecurityValidator;
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.RendererFectory;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.controls.XenosQuery;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.DateUtils;
    import com.nri.rui.core.utils.ProcessResultUtil;
    
    import mx.collections.ArrayCollection;
    import mx.controls.DataGrid;
    import mx.controls.dataGridClasses.DataGridColumn;
    import mx.events.DataGridEvent;
            
    //private var mkt:XenosQuery = new MarketPriceQuery();
      
    [Bindable]
    private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
    private var queryResult:ArrayCollection= new ArrayCollection();
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
     
    private var keylist:ArrayCollection = new ArrayCollection(); 
     
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    [Bindable]private var mode : String = "query";         
      
    /**
      *  datagrid header release event handler to handle datagridcolumn sorting
      */
    public function dataGrid_headerRelease(evt:DataGridEvent):void {                
        //sortUtil.clickedColumn=evt.dataField;
        var dg:DataGrid = DataGrid(evt.currentTarget);
        sortUtil.clickedColumn = dg.columns[evt.columnIndex];        
    }
    private function changeCurrentState():void{
        currentState = "result";
    }
             
    public function loadAll():void{
           parseUrlString();
           super.setXenosQueryControl(new XenosQuery());
           //XenosAlert.info("mode : "+mode);
           if(this.mode == 'query'){
               this.dispatchEvent(new Event('queryInit'));
                  this.referenceNo.setFocus();
           } else if(this.mode == 'amend'){
                  this.dispatchEvent(new Event('amendInit'));
                   this.referenceNo.setFocus();
                   addColumn();
              } else { 
               this.dispatchEvent(new Event('cancelInit'));
                   this.referenceNo.setFocus();
                   addColumn();
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
            //XenosAlert.info("Load Url : "+ this.loaderInfo.url.toString());
            var s:String = this.loaderInfo.url.toString();
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
                        //XenosAlert.info("movArray param = " + tempA[1]);
                        mode = tempA[1];
                    }
                }                        
            }else{
                mode = "query";
            }                 

        } catch (e:Error) {
            trace(e);
        }               
    }
    override public function preQueryInit():void{
        var rndNo:Number= Math.random();
//                  this.status.includeInLayout = true;
//                  this.status.visible = true;
//                  this.lblStatus.includeInLayout = true;
//                  this.lblStatus.visible = true;
      	super.getInitHttpService().url = "cam/camSecurityQueryDispatch.action?method=initialExecute&opMode=view&rnd=" + rndNo;            
    }
        
    override public function preAmendInit():void{
        var rndNo:Number= Math.random();
        super.getInitHttpService().url = "cam/camSecurityQueryAmendDispatch.action?method=initialExecute&actionType=AMEND&opMode=AMEND&screenType=M&rnd=" + rndNo;
        var reqObject:Object = new Object();
		reqObject.mode=this.mode;
        reqObject.SCREEN_KEY = 254;
        //reqObject.method="initialExecute";
        super.getInitHttpService().request = reqObject;         
    }
        
    override public function preCancelInit():void{
        var rndNo:Number= Math.random();
        super.getInitHttpService().url = "cam/camSecurityQueryCanceDispatch.action?method=initialExecute&actionType=DELETE&opMode=DELETE&screenType=M&rnd=" + rndNo;  
        var reqObject:Object = new Object();
        reqObject.mode=this.mode;
        reqObject.SCREEN_KEY = 254;
        //reqObject.method="initialExecute";
        super.getInitHttpService().request = reqObject;          
    }        
        
    private function addCommonKeys():void{  
        keylist = new ArrayCollection();          
        keylist.addItem("securityDateFrom");
        keylist.addItem("securityDateTo");
        keylist.addItem("counterPartyTypes.item");
        keylist.addItem("formList.item");
        keylist.addItem("inOutList.item");    
        keylist.addItem("ledgerCodeList.ledgerCode");
        keylist.addItem("ledgerCode");
        keylist.addItem("inOut");
    }
        
    override public function preQueryResultInit():Object{
        //var keylist:ArrayCollection = new ArrayCollection(); 
        addCommonKeys();       
        //keylist.addItem("statusList.item");            
        return keylist;            
    }
        
    override public function preAmendResultInit():Object{
        //var keylist:ArrayCollection = new ArrayCollection(); 
        addCommonKeys();                   
        return keylist;            
    }
        
    override public function preCancelResultInit():Object{
        //var keylist:ArrayCollection = new ArrayCollection(); 
        addCommonKeys();                   
        return keylist;            
    }
        
        
    private function commonInit(mapObj:Object):void{
        
        //errPage.removeError();
        
        var index:int=-1;
        var tempColl: ArrayCollection = new ArrayCollection();
        
        //Initialize form.
        
        errPage.clearError(super.getInitResultEvent());//clears the errors if any 
        this.queryResult.removeAll();
        
        referenceNo.text = "";
        referenceNo.setFocus();
        securityDateFrom.text = mapObj[keylist.getItemAt(0)].toString();
        securityDateTo.text = mapObj[keylist.getItemAt(1)].toString();
        securityDateFrom.selectedDate = DateUtils.toDate(securityDateFrom.text);
        securityDateTo.selectedDate = DateUtils.toDate(securityDateTo.text);
        
        
        //initiate text fields
        actPopUp.accountNo.text = "";
        instPopUp.instrumentId.text="";            
        ledgerCode.text = "";
        custodianBank.finInstCode.text = "";
        inOut.text = "";
        fundPopUp.fundCode.text = "";
        appRegiDateFrom.text = "";
        appRegiDateTo.text = "";
        updateDateFrom.text = "";
        updateDateTo.text = "";
        entryBy.employeeText.text="";
        updateBy.employeeText.text="";            
               
        
        //Initialize ledgerCodeList.
        tempColl = new ArrayCollection();
        //var initcol:ArrayCollection = new ArrayCollection();
            
        
        tempColl.addItem({label:" ", value: " "});
        index=-1;
        for each(var item:Object in (mapObj[keylist.getItemAt(5)] as ArrayCollection)){
            tempColl.addItem(item);
//                if(mode == "amend"){
//                    if(item.toString() == mapObj[keylist.getItemAt(6)].toString()){
//                    index = (mapObj[keylist.getItemAt(5)] as ArrayCollection).getItemIndex(item);
//                  }
//                }
        }
        ledgerCode.dataProvider = tempColl;
        ledgerCode.selectedIndex = index !=-1 ? index+1 : 0;
        
        //Initialize inOutList.
        tempColl = new ArrayCollection();
            
        tempColl.addItem({label:" ", value: " "});
        index=-1;
        for each(item in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
            tempColl.addItem(item);
//                if(mode == "amend"){
//                    if(item.value == mapObj[keylist.getItemAt(7)].toString()){
//                    index = (mapObj[keylist.getItemAt(4)] as ArrayCollection).getItemIndex(item);
//                  }
//                }
            }
        inOut.dataProvider = tempColl;
        inOut.selectedIndex = index !=-1 ? index+1 : 0;           
        
    }
        
    override public function postQueryResultInit(mapObj:Object):void{
        commonInit(mapObj);
    
//            var initcol:ArrayCollection = new ArrayCollection();
//            initcol=new ArrayCollection();
//            initcol.addItem({label:" ", value: " "});
//            var index:int=0;
//            for each(var item:Object in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
//                initcol.addItem(item);
//            }
//            this.status.dataProvider = initcol;
//            this.status.selectedIndex =0;
    }
        
        
    override public function postAmendResultInit(mapObj:Object):void{
        commonInit(mapObj);    
//        app.submitButtonInstance = submit;
        this.referenceNo.setFocus();
    }
        
    override public function postCancelResultInit(mapObj:Object):void{
        commonInit(mapObj);
//        app.submitButtonInstance = submit;
        this.referenceNo.setFocus();    
    }
        
    private function setValidator():void{
        
        var validateModel:Object={
                        SecurityInOutQuery:{                                 
                             toSecDate:this.securityDateTo.text,
                             fromSecDate:this.securityDateFrom.text,
                             fromAppRegiDate:this.appRegiDateFrom.text,
                             toAppRegiDate:this.appRegiDateTo.text,
                             fromUpdateDate:this.updateDateFrom.text,
                             toUpdateDate:this.updateDateTo.text 
                        }
                       }; 
         super._validator = new CamSecurityValidator();
         super._validator.source = validateModel ;
         super._validator.property = "SecurityInOutQuery";
    }
        
    override public function preQuery():void{
       
    }
        
    override public function preAmend():void{            
        
        setValidator();
        qh.resetPageNo();                
        super.getSubmitQueryHttpService().useProxy = false;
        super.getSubmitQueryHttpService().url = "cam/camSecurityQueryAmendDispatch.action?rnd=" + Math.random();    
        super.getSubmitQueryHttpService().request = populateRequestParams();              
       
    }
        
        
    override public function preCancel():void{
        
        setValidator();
        qh.resetPageNo();            
        super.getSubmitQueryHttpService().url = "cam/camSecurityQueryCanceDispatch.action?rnd=" + Math.random(); 
        super.getSubmitQueryHttpService().request = populateRequestParams();
       
    }
        
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();

        reqObj.method = "submitQuery";                
        reqObj.SCREEN_KEY = 255;
//        XenosAlert.info("Request Preparing...."); 
        reqObj.referenceNo = this.referenceNo.text;
        //reqObj.counterPartyType = this.counterPartyType.selectedItem != null ? this.counterPartyType.selectedItem.value : "";
        //reqObj.counterPartyCode = this.counterPartyCode.customerCode.text;
        reqObj.accountNo = this.actPopUp.accountNo.text;
        reqObj.securityCode = this.instPopUp.instrumentId.text ;
        //reqObj.form = this.form.selectedItem != null ? this.form.selectedItem.value : "";
        reqObj.securityDateFrom = this.securityDateFrom.text;
        reqObj.securityDateTo = this.securityDateTo.text;
        reqObj.ledgerCode = this.ledgerCode.selectedItem != null ? this.ledgerCode.selectedItem.value : "";
        reqObj.custodianBank = this.custodianBank.finInstCode.text;
        reqObj.inOut = this.inOut.selectedItem != null ? this.inOut.selectedItem.value : "";
        reqObj.fundCode = this.fundPopUp.fundCode.text;
        reqObj.appRegiDateFrom = this.appRegiDateFrom.text;
        reqObj.appRegiDateTo = this.appRegiDateTo.text;
        reqObj.updateDateFrom = this.updateDateFrom.text;
        reqObj.updateDateTo = this.updateDateTo.text;
        reqObj.entryBy = this.entryBy.employeeText.text;
        reqObj.updateBy = this.updateBy.employeeText.text;
        //reqObj.rnd = Math.random() + "";
         
//        XenosAlert.info("Request Prepared."); 
        
        return reqObj;
    }
    
    override public function postQueryResultHandler(mapObj:Object):void{
        commonResult(mapObj);
    }
    override public function postAmendResultHandler(mapObj:Object):void{
        commonResult(mapObj);
//        app.submitButtonInstance = submit;
    }
    override public function postCancelResultHandler(mapObj:Object):void{
        commonResult(mapObj);
//        app.submitButtonInstance = submit;
    }
       
        
    private function commonResult(mapObj:Object):void{        
        
        var result:String = "";
        if(mapObj!=null){   
            //XenosAlert.info("mapObj : "+mapObj.toString());         
            if(mapObj["errorFlag"].toString() == "error"){
                //result = mapObj["errorMsg"] .toString();
                queryResult.removeAll();
                errPage.showError(mapObj["errorMsg"]);
            }else if(mapObj["errorFlag"].toString() == "noError"){
               errPage.clearError(super.getSubmitQueryResultEvent());
               //errPage.removeError();
              // XenosAlert.info("I am in errPage ");
               queryResult.removeAll();
              // XenosAlert.info("I am in queryResult : "+currentState);
               queryResult=mapObj["row"];
               changeCurrentState();
                    qh.setOnResultVisibility();
                    qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
                    qh.PopulateDefaultVisibleColumns();
                
            }else{
                errPage.removeError();
                queryResult.removeAll();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            }            
        }
        
    }   
       
      
    override public function preResetQuery():void{
//               var rndNo:Number= Math.random();
//                  super.getResetHttpService().url = "ref/marketPriceQueryDispatchAction.action?method=resetQuery&&mode=query&&menuType=Y&rnd=" + rndNo;            
    }
        
    override public function preResetAmend():void{
        var rndNo:Number= Math.random();
        super.getResetHttpService().url = "cam/camSecurityQueryAmendDispatch.action?rnd=" + rndNo;
        var reqObject:Object = new Object();
        reqObject.mode=this.mode;
        reqObject.method="resetQuery";
        reqObject.SCREEN_KEY = 254;
        super.getResetHttpService().request = reqObject;         
    }
        
    override public function preResetCancel():void{
        var rndNo:Number= Math.random();
        super.getResetHttpService().url = "cam/camSecurityQueryCanceDispatch.action?rnd=" + rndNo;  
        var reqObject:Object = new Object();
	    reqObject.mode=this.mode;
	    reqObject.method="resetQuery";
	    reqObject.SCREEN_KEY = 254;
	    super.getResetHttpService().request = reqObject;          
    }       
        
        
    override    public function preGenerateXls():String{
     	var url : String =null;
        if(mode == "query"){                    
          url = "cam/camSecurityQueryDispatch.action?method=generateXLS";
        }else if(mode == "amend"){
            url = "cam/camSecurityQueryAmendDispatch.action?method=generateXLS";
        }else{
            url = "cam/camSecurityQueryCanceDispatch.action?method=generateXLS";
        }
        return url;
    }    
    override public function preGeneratePdf():String{
	    //XenosAlert.info("preGeneratePdf");
	    var url : String =null;
        if(mode == "query"){                    
          url = "cam/camSecurityQueryDispatch.action?method=generatePDF";
        }else if(mode == "amend"){
            url = "cam/camSecurityQueryAmendDispatch.action?method=generatePDF";
        }else{
            url = "cam/camSecurityQueryCanceDispatch.action?method=generatePDF";
	    }
	    return url;
	}    
            
    override    public function preNext():Object{
       var reqObj : Object = new Object();
       reqObj.method = "doNext";
       return reqObj;
    }    
    override public function prePrevious():Object{
           
	    var reqObj : Object = new Object();
	    reqObj.method = "doPrevious";
	    return reqObj;
    }    
          
    private function dispatchPrintEvent():void{
        this.dispatchEvent(new Event("print"));
    }  
    private function dispatchPdfEvent():void{
       // XenosAlert.info("dispatchEvent pdf");
        this.dispatchEvent(new Event("pdf"));
    }  
    private function dispatchXlsEvent():void{
        this.dispatchEvent(new Event("xls"));
    }   
    private function dispatchNextEvent():void{
        this.dispatchEvent(new Event("next"));
    }  
    private function dispatchPrevEvent():void{
        this.dispatchEvent(new Event("prev"));
    }      
      
    private function addColumn():void
    {
        //Add a object
        
        var dg :DataGridColumn = new DataGridColumn();
        dg.dataField="";
        dg.editable = false;
        dg.headerText = "";
        dg.width = 40;
        dg.itemRenderer = new RendererFectory(ImgSummaryRenderer);
        
        var cols :Array = resultSummary.columns;
        cols.unshift(dg);
        cols.pop();
        resultSummary.columns = cols;
        
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
            
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
    
        //passing account status                
        var actStatusArray:Array = new Array(1);
        actStatusArray[0]="OPEN";
        myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
        return myContextList;
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
