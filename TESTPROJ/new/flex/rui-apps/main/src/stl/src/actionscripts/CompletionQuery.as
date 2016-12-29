




import com.nri.rui.core.Globals;
import com.nri.rui.core.containers.SummaryPopup;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.controls.DataGrid;
import mx.controls.DateField;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.DataGridEvent;
import mx.formatters.NumberBase;
import mx.managers.PopUpManager;

 
    [Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]public var queryResult:ArrayCollection = new ArrayCollection();
 
    private var keylist:ArrayCollection = new ArrayCollection(); 
    private var sortFieldArray:Array = new Array();
    private var sortFieldDataSet:Array = new Array();
    private var sortFieldSelectedItem:Array = new Array();
    private var csd:CustomizeSortOrder = null;
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    [Bindable]public var mode : String = "ADD";
     
    [Bindable]public var returnFundContextItem:ArrayCollection = new ArrayCollection();    
    [Bindable]public var returnOurContextItem:ArrayCollection = new ArrayCollection();   
    [Bindable]public var returnCpContextItem:ArrayCollection = new ArrayCollection();
    public var stlPks : ArrayCollection = new ArrayCollection();
    [Bindable]public var stlPkArray : Array = new Array();
    [Bindable]public var opObj : String = XenosStringUtils.EMPTY_STR; 
    [Bindable]public var selectAllBind:Boolean = false;   
    [Bindable]public var sPopup : SummaryPopup;

    [Bindable]public var indx : int;
    [Bindable]private var remarks1:Array = new Array();
    [Bindable]private var remarks2:Array = new Array();
    [Bindable]private var reasonCode:Array = new Array();
    [Bindable]public var reasonCodeList:ArrayCollection = new ArrayCollection();
    [Bindable]public var completionTypeList:ArrayCollection = new ArrayCollection;
    [Bindable]public var compType:Object = new Object;
    [Bindable]private var atLeastoneSelected:Boolean = false;
    [Bindable]private var commonStlDateStr:String = "";
    
    private function changeCurrentState():void {
        currentState = "result";
    }
             
    /**
    *  datagrid header release event handler to handle datagridcolumn sorting
    */
    public function dataGrid_headerRelease(evt:DataGridEvent):void {                
        var dg:DataGrid = DataGrid(evt.currentTarget);
        sortUtil.clickedColumn = dg.columns[evt.columnIndex];       
    }

    public function loadAll():void {
        parseUrlString();
        super.setXenosQueryControl(new XenosQuery());
        
        if(this.mode == 'ADD') {
            this.dispatchEvent(new Event('queryInit'));
            qh.dgrid = resultSummary;
        } else if(this.mode == 'DELETE') {
            this.dispatchEvent(new Event('cancelInit'));
            qh.dgrid = resultSummaryCancel;
        } else if(this.mode == 'CAX_RECEIVE_NOTICE') {
            this.dispatchEvent(new Event('querySubmit'));
            qh.dgrid = resultSummary;
            qryNResultPanel.includeInLayout= false;
            qryNResultPanel.visible = false;
            changeCurrentState();
            resultSummary.includeInLayout = true;
            resultSummary.visible = true;
            
            var initColl:ArrayCollection = new ArrayCollection();
            initColl = new ArrayCollection();
            initColl.addItem("");
            initColl.addItem("COMPLETE");
            initColl.addItem("PARTIAL");
            completionTypeList = initColl;
            
            var len:uint = hdbox1.numDividers;
            for (var idx:int = 0; idx < len; idx++) {
                hdbox1.getDividerAt(idx).visible = false;
            }

        }
    }

    /**
     * Extracts the parameters and set them to some variables for query criteria
     * from the Module Loader Info.
     * 
     */ 
    public function parseUrlString():void {
        try {
            // Remove everything before the question mark, including
            // the question mark.
            var myPattern:RegExp = /.*\?/; 
            
            var s:String = this.loaderInfo.url.toString();
            s = s.replace(myPattern, "");
            
            // Create an Array of name=value Strings.
            var params:Array = s.split(Globals.AND_SIGN); 
            
            // Print the params that are in the Array.
            var keyStr:String;
            var valueStr:String;
            var paramObj:Object = params;
              
            // Set the values of the salutation.
            if(params != null) {
                for (var i:int = 0; i < params.length; i++) {
                    var tempA:Array = params[i].split("="); 
                    if (tempA[0] == "target") {                     
                        mode = tempA[1];
                    }
                }                       
            } else {
                mode = tempA[1];
            }                           
        } catch (e:Error) {
            trace(e);
        }               
    }

    override public function preQueryInit():void{
        var rndNo:Number= Math.random();
        var reqObj:Object = new Object;
        reqObj.SCREEN_KEY = 800;
        super.getInitHttpService().url = "stl/stlCompletionQuery.action?method" + 
                "=initialExecute&target=" + this.mode + "&rnd=" + rndNo;
        super.getInitHttpService().request = reqObj;        
    }

    override public function preCancelInit():void{
        var rndNo:Number= Math.random();
        var reqObj:Object = new Object;
        reqObj.SCREEN_KEY = 801;
        super.getInitHttpService().url = "stl/stlCompletionCancelQuery.action?method" + 
                "=initialExecute&target=" + this.mode + "&rnd=" + rndNo;         
        super.getInitHttpService().request = reqObj;        
    }

    private function addCommonKeys():void {  
        keylist = new ArrayCollection();
        keylist.addItem("settleQryForList.item");
        keylist.addItem("settlementStatusList.settlementStatus");
        keylist.addItem("contSettleStatusList.item");
        keylist.addItem("subTradeTypeList.item");
        keylist.addItem("completionForList.item");
        keylist.addItem("settlementModeList.item");
        keylist.addItem("subEventTypeList.item");
        keylist.addItem("sortFieldList.item"); 
        keylist.addItem("settlementStatusActionList.settlementActionStatus"); 
        keylist.addItem("sortField1");
        keylist.addItem("sortField2");
        keylist.addItem("sortField3");
        keylist.addItem("commonStlDateStr");
    }

    override public function preQueryResultInit():Object{
        addCommonKeys();                
        return keylist;         
    }

    override public function preCancelResultInit():Object{
        addCommonKeys();                
        return keylist;         
    }
    
    private function sortOrder1Update():void{
        csd.update(sortField1.selectedItem,0);
    }
 
    private function sortOrder2Update():void{      
        csd.update(sortField2.selectedItem,1);
    }

    private function commonInit(mapObj:Object):void{
        var i:int = 0;
        var selIndx:int = 0;
        var initColl:ArrayCollection = new ArrayCollection();
        var tempColl: ArrayCollection = new ArrayCollection();
        app.submitButtonInstance = submit;
        
        errPage.clearError(super.getInitResultEvent());
        
        //initiate text fields
        fundPopUp.fundCode.text = "";
        fundActPopUp.accountNo.text = "";
        stlRefNo.text = "";
        swiftRefNo.text = "";
        trddateFrom.text = "";
        trddateTo.text = "";
        valdateFrom.text = "";
        valdateTo.text = "";
        bankPopUp.finInstCode.text = "";
        ourActPopUp.accountNo.text = "";
        instPopUp.instrumentId.text="";
        ccyBox.ccyText.text = "";
        cashDel.selected = false;
        cashRec.selected = false;
        dvp.selected = false;
        rvp.selected = false;
        secDel.selected = false;
        secRec.selected = false;
        inputdateFrom.text = "";
        inputdateTo.text = "";
        instructionRefNo.text = "";
        correspInstPopUp.instrumentId.text = "";
        cpActPopUp.accountNo.text = "";        
        
        //errPage.removeError();
                    
        //1. Settlement Query For
        initColl = new ArrayCollection();
        initColl.addItem({label:" ", value: " "});
        selIndx = 0;
        for each(var itemFrm0:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)) {
            initColl.addItem(itemFrm0);
        }
        settlementQueryForList.dataProvider = initColl;

        //2. Settlement Status
        initColl = new ArrayCollection();
        initColl.addItem(" ");
        selIndx = 0;
        for each(var itemFrm1:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)) {
            initColl.addItem(itemFrm1);
        }
        settleStatusList.dataProvider = initColl;

        //3. Contractual Settlement Status
        initColl = new ArrayCollection();
        initColl.addItem({label:" ", value: " "});
        selIndx = 0;
        for each(var itemFrm2:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)) {
            initColl.addItem(itemFrm2);
        }
        contractualSettlementStatus.dataProvider = initColl;

        //4. Sub Trade Type
        initColl = new ArrayCollection();
        initColl.addItem({label:" ", value: " "});
        selIndx = 0;
        for each(var itemFrm3:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)) {
            initColl.addItem(itemFrm3);
        }
        subTradeTypeList.dataProvider = initColl;

        //5. Completion For
        initColl = new ArrayCollection();
        initColl.addItem({label:" ", value: " "});
        selIndx = 0;
        for each(var itemFrm4:Object in (mapObj[keylist.getItemAt(4)] as ArrayCollection)) {
            initColl.addItem(itemFrm4);
        }
        completionForList.dataProvider = initColl;

        //6. Settlement Mode
        initColl = new ArrayCollection();
        initColl.addItem({label:" ", value: " "});
        selIndx = 0;
        for each(var itemFrm5:Object in (mapObj[keylist.getItemAt(5)] as ArrayCollection)) {
            initColl.addItem(itemFrm5);
        }
        settlementModeList.dataProvider = initColl;

        //7. Event Type
        initColl = new ArrayCollection();
        initColl.addItem({label:" ", value: " "});
        selIndx = 0;
        for each(var itemFrm6:Object in (mapObj[keylist.getItemAt(6)] as ArrayCollection)) {
            initColl.addItem(itemFrm6);
        }
        subEventTypeList.dataProvider = initColl;

        initColl = new ArrayCollection();
        initColl.addItem({label:" ", value: " "});
        selIndx = 0;
        for each(var item7:Object in (mapObj[keylist.getItemAt(7)] as ArrayCollection)){
            initColl.addItem(item7);
        }
        sortField1.dataProvider = initColl;
        sortField2.dataProvider = initColl;
        sortField3.dataProvider = initColl;
        
        //variables to hold the default values from the server
        var sortField1Default:String = mapObj[keylist.getItemAt(9)].toString();
        var sortField2Default:String = mapObj[keylist.getItemAt(10)].toString();
        var sortField3Default:String = mapObj[keylist.getItemAt(11)].toString();
        var sortField1DefaultIndex:int = 0;  
        var sortField2DefaultIndex:int = 0;  
        var sortField3DefaultIndex:int = 0;  

        //Default index
        for (i = 0; i < initColl.length; i++) {
            if(XenosStringUtils.equals((initColl[i].value),sortField1Default)){                    
                sortField1DefaultIndex = i;
            }           
            if(XenosStringUtils.equals((initColl[i].value),sortField2Default)){                    
                sortField2DefaultIndex = i;
            }           
            if(XenosStringUtils.equals((initColl[i].value),sortField3Default)){                    
                sortField3DefaultIndex = i;
            }           
        }
        
        sortFieldArray[0] = sortField1;
        sortFieldDataSet[0] = initColl;
        //Set the default value object
        sortFieldSelectedItem[0] = initColl.getItemAt(sortField1DefaultIndex);
        
        sortFieldArray[1]=sortField2;
        sortFieldDataSet[1]=initColl;
        //Set the default value object
        sortFieldSelectedItem[1] = initColl.getItemAt(sortField2DefaultIndex);
        
        sortFieldArray[2]=sortField3;
        sortFieldDataSet[2]=initColl;
        //Set the default value object
        sortFieldSelectedItem[2] = initColl.getItemAt(sortField3DefaultIndex); 

        initColl = new ArrayCollection();
        initColl.addItem("");
        selIndx = 0;
        for each(var item8:Object in (mapObj[keylist.getItemAt(8)] as ArrayCollection)) {
            initColl.addItem(item8);
        }
        completionTypeList = initColl;

        commonStlDateStr = mapObj[keylist.getItemAt(12)].toString();
        
        fundPopUp.fundCode.setFocus();
            
        csd = new CustomizeSortOrder(sortFieldArray, 
                                     sortFieldDataSet,
                                     sortFieldSelectedItem);
        csd.init();
    }

    override public function postQueryResultInit(mapObj:Object):void {
        commonInit(mapObj);
    }

    override public function postCancelResultInit(mapObj:Object):void {
        commonInit(mapObj); 
    }

    private function setValidator():void {  
    } 

    override public function preQuery():void {
        setValidator();
        qh.resetPageNo();
        if(XenosStringUtils.equals(this.mode,"CAX_RECEIVE_NOTICE")){
            super.getSubmitQueryHttpService().url = "stl/stlCompletionQueryCAReceiveNotice.action?";  
        }else{
            super.getSubmitQueryHttpService().url = "stl/stlCompletionQuery.action?";  
        }
        super.getSubmitQueryHttpService().request = populateRequestParams();
    }
                
    override public function preCancel():void {
        setValidator();
        qh.resetPageNo();   
        super.getSubmitQueryHttpService().url = "stl/stlCompletionCancelQuery.action?";  
        super.getSubmitQueryHttpService().request = populateRequestParams();  
    }
                
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        
        if(this.mode == "CAX_RECEIVE_NOTICE"){
            reqObj.method= "doQuery";
            reqObj.path = "CAX_RECEIVE_NOTICE";
            reqObj.actionType = "ADD";
            reqObj.SCREEN_KEY = 321;
            return reqObj;
        }
        
        
        reqObj.method= "doQuery";
        reqObj.target = this.mode;
        
        // Dropdown Fileds  
        reqObj.settleQueryFor = (this.settlementQueryForList.selectedItem != null ? this.settlementQueryForList.selectedItem.value : "");        
        reqObj.contSettleStatus = (this.contractualSettlementStatus.selectedItem != null ? this.contractualSettlementStatus.selectedItem.value : "");
        reqObj.subTradeType = (this.subTradeTypeList.selectedItem != null ? this.subTradeTypeList.selectedItem.value : "");
        reqObj.settleCompletionFor = ((this.completionForList.selectedItem != null && this.completionForList.selectedItem.value != " ")? this.completionForList.selectedItem.value : "");
        reqObj.settlementMode = (this.settlementModeList.selectedItem != null ? this.settlementModeList.selectedItem.value : "");
        reqObj.subEventType = ((this.subEventTypeList.selectedItem != null && this.subEventTypeList.selectedItem.value != " ") ? this.subEventTypeList.selectedItem.value : "");
        reqObj.settlementStatus = (this.settleStatusList.selectedItem != null ? this.settleStatusList.text : "");

        //Date Fields
        reqObj.tradeDateFrom = this.trddateFrom.text;
        reqObj.tradeDateTo = this.trddateTo.text;
        reqObj.entryDateFrom = this.inputdateFrom.text;
        reqObj.entryDateTo = this.inputdateTo.text;
        reqObj.valueDateFrom = this.valdateFrom.text;
        reqObj.valueDateTo = this.valdateTo.text;
        
        //Text Fields
        reqObj.fundCode = this.fundPopUp.fundCode.text;
        reqObj.fundAccountNo = this.fundActPopUp.accountNo.text;
        reqObj.settlementReferenceNo = this.stlRefNo.text;
        reqObj.senderReferenceNo = this.swiftRefNo.text;
        reqObj.firmBankCode = this.bankPopUp.finInstCode.text;
        reqObj.firmBankAccount = this.ourActPopUp.accountNo.text;
        reqObj.securityCode = this.instPopUp.instrumentId.text;        
        reqObj.settlementCcy = this.ccyBox.ccyText.text;
        reqObj.instructionReferenceNo = this.instructionRefNo.text;
        reqObj.correspondingSecurityId = this.correspInstPopUp.instrumentId.text;
        reqObj.accountNo = this.cpActPopUp.accountNo.text;
        
        // Check box
        var instructionTypeArray:Array = new Array();
        if(cashDel.selected)
            instructionTypeArray.push(cashDel.name);
        if(cashRec.selected)
            instructionTypeArray.push(cashRec.name);
        if(dvp.selected)
            instructionTypeArray.push(dvp.name);
        if(rvp.selected)
            instructionTypeArray.push(rvp.name);
        if(secDel.selected)
            instructionTypeArray.push(secDel.name);
        if(secRec.selected)
            instructionTypeArray.push(secRec.name);
        reqObj.instructionType = instructionTypeArray;
                
        // Sort Fields
        reqObj.sortField1 = ((this.sortField1.selectedItem != null && this.sortField1.selectedItem.value != " ") ? this.sortField1.selectedItem.value : "");
        reqObj.sortField2 = ((this.sortField2.selectedItem != null && this.sortField2.selectedItem.value != " ") ? this.sortField2.selectedItem.value : "");
        reqObj.sortField3 = ((this.sortField3.selectedItem != null && this.sortField3.selectedItem.value != " ") ? this.sortField3.selectedItem.value : "");
        
        reqObj.rnd = Math.random() + "";
        if (this.mode == "ADD") {
            reqObj.SCREEN_KEY = 321;            
        } else if (this.mode == "DELETE") {
            reqObj.SCREEN_KEY = 814;                        
        }
        
        return reqObj;
    }
    
    override public function postQueryResultHandler(mapObj:Object):void {
        commonResult(mapObj);
    }

    override public function postCancelResultHandler(mapObj:Object):void{
        commonResult(mapObj); 
        selectAllBind = false;       
    }

    private function commonResult(mapObj:Object):void {      
        var result:String = "";
        errPageQueryRes.removeError();
        if(mapObj!=null){   
            if(mapObj["errorFlag"].toString() == "error"){
                queryResult.removeAll();
                errPage.showError(mapObj["errorMsg"]);
            } else if(mapObj["errorFlag"].toString() == "noError"){
                errPage.clearError(super.getSubmitQueryResultEvent());
                //errPage.removeError();
                if (queryResult != null) {
                    queryResult.removeAll();
                }
                queryResult = mapObj["row"];
                var i:int = 0;
                for each(var item:Object in queryResult) {
                    item["rowNo"]= i;
                    item["stlDateStr"] = item["valueDateStr"].toString();
                    item["cpSsiDisp"] = displayCpSsi(item["dtcParticipantId"].toString(), item["contraId"].toString(), item["cpSsiInternational"].toString());
                    i++;
                }
                if(mode == "CAX_RECEIVE_NOTICE" && queryResult.length != 0){
                    commonStlDateStr = queryResult[0].settlementDateStr;
                }
                stlDate.selectedDate = DateField.stringToDate(commonStlDateStr, 'YYYYMMDD');
                changeCurrentState();
                qh.setOnResultVisibility();
                qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true") ? true : false );
                qh.PopulateDefaultVisibleColumns(); 
            } else {
                errPage.removeError();
                if(mode == "CAX_RECEIVE_NOTICE"){
                    this.parentDocument.dispatchEvent(new CloseEvent(Event.CLOSE));
                } else {
                    if (queryResult != null) {
                        queryResult.removeAll();
                    }
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.datanotfound'));
                }
            }
            resetSellection(queryResult);
            queryResult.refresh();           
        }
    }   
       
      
    override public function preResetQuery():void {
        var rndNo:Number= Math.random();
        super.getResetHttpService().url = "stl/stlCompletionQuery.action?method=resetCompQuery&rnd=" + rndNo;            
    }

    override public function preResetCancel():void {
       var rndNo:Number= Math.random();
       super.getResetHttpService().url = "stl/stlCompletionCancelQuery.action?method=resetCompQuery&rnd=" + rndNo;  
    }       

    private function getSelectedRows():Array{
        var tempArray:ArrayCollection = new ArrayCollection();
        var numBase:NumberBase = new NumberBase();
        for(var i:int=0; i < queryResult.length; i++){
            if(queryResult[i].selected == true){
                tempArray.addItem(i);
            }            
        }
        return tempArray.toArray();
    }

    private function showConfirmModule():void {
        if(mode == "ADD"){
            return;
        }
        var parentApp :UIComponent = UIComponent(this.parentApplication);
        var selectedItem:Array = getSelectedRows();
        if(selectedItem.length < 1){
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.query.select.atleast.onerecord.for.cancelcompletion'));
            return;
        }
        sPopup = SummaryPopup(PopUpManager.createPopUp(this, SummaryPopup, true));
        sPopup.title = this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.cancel.userconfirmation');
        sPopup.width = 820;
        sPopup.height = 330;
        PopUpManager.centerPopUp(sPopup);
        sPopup.owner = this;
        sPopup.dataObj = selectedItem;
        sPopup.moduleUrl = "assets/appl/stl/CompletionEntryNCancel.swf" + Globals.QS_SIGN 
            + "mode" + Globals.EQUALS_SIGN + mode + Globals.AND_SIGN + "selectedItems" 
            + Globals.EQUALS_SIGN + selectedItem;
    }
    
    private function validateRecords():void{
        if(stlPks.length == 0){
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.query.select.atleast.onerecord.for.thisaction'));
        } else {
            var reqObj : Object = new Object();
            reqObj.url = "stl/stlCompletionDetailsCancel.action?"; 
            reqObj.method = "submitCancel";
            reqObj.remarks1Array = remarks1; 
            reqObj.remarks2Array = remarks2; 
            reqObj.reasonCodeArrayArray = reasonCode; 
            reqObj.rnd = Math.random()+"";          
        }
    }  

    public function checkSelectToModify(item:Object):void {
        setIfAllSelected();             
    }

    public function selectAllRecords(flag:Boolean): void {
        var i:Number = 0;
        stlPks.removeAll();
        for(i=0; i < queryResult.length; i++){
            var obj:XML = queryResult[i];
            obj.selected = flag;
            queryResult[i] = obj;
			queryResult.refresh();            
            addOrRemove(queryResult[i],i);
        }
		queryResult.refresh();            
    
    }

    /**
    * Determines whether the record needs to be added or deleted according the 
    * selected value of teh Check Box.
    */ 
    private function addOrRemove(item:Object,ix : int):void {
        var i:Number;
        var tempArray:Array = new Array();
        if(item.selected == true){ 
            stlPks.addItem(item.detailHistoryPk);
            stlPkArray[ix] = item.detailHistoryPk;
        } else { //needs to pop
            tempArray = stlPks.toArray();
            stlPks.removeAll();
            stlPkArray[ix] = null;
            for(i=0; i<tempArray.length; i++){
                if(tempArray[i] != item.detailHistoryPk){
                    stlPks.addItem(tempArray[i]);
                }
            }
        }           
    }

    private function resetSellection(queryResult:ArrayCollection):void {
        stlPks.removeAll();
        for(var i:int=0; i<queryResult.length; i++){
            queryResult[i].selected = false;
            addOrRemove(queryResult[i], i);
        }
    }

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
         } else {
            return false;
        }
    }

    override public function preNext():Object {
        var reqObj : Object = new Object();
        reqObj.method = "nextPage";
        return reqObj;
    }  
         
    override public function prePrevious():Object {    
        var reqObj : Object = new Object();
        reqObj.method = "prevPage";
        return reqObj;
    } 
          
    private function dispatchPrintEvent():void {
        this.dispatchEvent(new Event("print"));
    }  

    private function dispatchNextEvent():void {
        this.dispatchEvent(new Event("next"));
    }
      
    private function dispatchPrevEvent():void {
        this.dispatchEvent(new Event("prev"));
    }
    
    /**
      * This is the method to pass the Collection of data items through the 
      * context to the account popup. This will be implemented as per specific  
      * requirement. 
      */
    private function populateFundContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
      
        //passing counter party type                
        var settleActTypeArray:Array = new Array(3);
            settleActTypeArray[0]="S";
            settleActTypeArray[1]="B";
            settleActTypeArray[2]="T";
        myContextList.addItem(new HiddenObject("invActTypeContext",settleActTypeArray));
    
        var cpTypeArray:Array = new Array(1);
            cpTypeArray[0]="INTERNAL";
           
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
        return myContextList;
    }
    
    /**
      * This is the method to pass the Collection of data items through the 
      * context to the FinInst popup. This will be implemented as per specifdic  
      * requirement. 
      */
    private function populateFinInstRole():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
        
        var bankRoleArray : Array = new Array(3);
        bankRoleArray[0] = "Security Broker";
        bankRoleArray[1] = "Bank/Custodian";
        bankRoleArray[2] = "Central Depository";
        myContextList.addItem(new HiddenObject("bankRoles",bankRoleArray));
        
        return myContextList;
    }

    /**
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specifdic  
      * requriment. 
      */
    private function populateOurContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
      
        var cpTypeArray:Array = new Array(2);
            cpTypeArray[0]="BROKER";
            cpTypeArray[1]="BANK/CUSTODIAN";
            
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
    
        return myContextList;
    }
    
    /**
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specifdic  
      * requriment. 
      */
    private function populateCpContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
      
        //passing counter party type                
        var cpTypeArray:Array = new Array(2);
            cpTypeArray[0]="BROKER";
            cpTypeArray[1]="BANK/CUSTODIAN";
            
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
    
        //passing account status                
        var cpTradActType:Array = new Array(3);
        cpTradActType[0]="T";
        cpTradActType[1]="S";
        cpTradActType[2]="B";
        myContextList.addItem(new HiddenObject("cpTradActType",cpTradActType));
        return myContextList;
    } 

    private function validateSubmitEntry():void {
        if(mode == "DELETE"){
            return;
        }
        atLeastoneSelected = false;
        var parentApp :UIComponent = UIComponent(this.parentApplication);
        if(!validate()){
            return;
        }
        errPageQueryRes.removeError();
        sPopup = SummaryPopup(PopUpManager.createPopUp(this, SummaryPopup, true));
        sPopup.title = this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.entry.userconfirmation');
        sPopup.width = 820;
        sPopup.height = 330;
        PopUpManager.centerPopUp(sPopup);
        sPopup.owner = this;
        sPopup.dataObj = queryResult;
        sPopup.moduleUrl = "assets/appl/stl/CompletionEntryNCancel.swf" + Globals.QS_SIGN 
            + "mode" + Globals.EQUALS_SIGN + mode;
    }
    
    private function validate():Boolean {
        var oneSelectedFlag:Boolean = false;
        for(var i:int = 0; i < queryResult.length; i++) {
            if (!XenosStringUtils.equals(queryResult[i].completionTp, "")) {
                oneSelectedFlag = true;
            }
            
            if(!XenosStringUtils.equals(queryResult[i].completionTp, "") && XenosStringUtils.equals(queryResult[i].stlDateStr, "")) {
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.query.settlementdate.cannot.beblank.for.anyrecord'));
                return false;
            }
        }
        
        if(oneSelectedFlag == false) {
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.label.completion.query.select.atleast.onerecord.for.completion'));
            return false;
        }

        return true;
    } 
        
    private function copyStlDate():void {
        
        if(XenosStringUtils.isBlank(this.stlDate.text))
            return;
        for(var i:int = 0; i < queryResult.length; i++) {
            if(!XenosStringUtils.isBlank(queryResult[i].completionTp))
                queryResult[i].settlementDateStr = this.stlDate.text;
        }
        
        queryResult.refresh();

    }
    
    private function displayCpSsi(dtcParticipantId:String, contraId:String, cpSsiInternational:String):String {
        if (dtcParticipantId != null && dtcParticipantId != "") {
            return dtcParticipantId;
        }
        if (contraId != null && contraId != "") {
            return contraId;
        }
        return cpSsiInternational;
    }
    
    private function pdfXlsHide():void {
        this.qh.pdf.visible = false;
        this.qh.pdf.includeInLayout = false;
        
        this.qh.xls.visible = false;
        this.qh.xls.includeInLayout = false;
    }
    
    private function getClientAccountNo(item:Object, column:DataGridColumn):String{
        return item.clientAccountNo;
    }
    
    private function getFundAccountNo(item:Object, column:DataGridColumn):String{
        return item.fundAccountNo;
    }
    
    private function getUnderlyingSecurityCode(item:Object, column:DataGridColumn):String{
        return item.underlyingSecurityCode;
    }
    
    private function getInstrumentCode(item:Object, column:DataGridColumn):String{
        return item.instrumentCode;
    }
     
    private function getDisplayAccountNo(item:Object, column:DataGridColumn):String {
        return item.displayAccountNo;
    }
    
    private function getOurBank(item:Object, column:DataGridColumn):String {
        return item.ourBank;
    }
    
    private function getFinInstRoleCode(item:Object, column:DataGridColumn):String {
        return item.finInstRoleCode;
    } 