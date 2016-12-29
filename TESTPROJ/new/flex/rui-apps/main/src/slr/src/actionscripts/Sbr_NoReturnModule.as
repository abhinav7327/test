// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.RendererFectory;
import com.nri.rui.core.containers.SummaryPopup;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.renderers.ImgSummaryRenderer;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.slr.Events.NoReturnChangeEvent;

import mx.collections.ArrayCollection;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;
import mx.utils.StringUtil;
            
    [Bindable] private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable] public var queryResult:ArrayCollection= new ArrayCollection();
    private var keylist:ArrayCollection = new ArrayCollection(); 
    [Bindable] private var mode : String = "QUERY";
    [Bindable] public var selectAllBind:Boolean=false;
    [Bindable] public var refreshQuery:Boolean = true;
    
    [Bindable] private var sortFieldList1:ArrayCollection = null;
    [Bindable] private var sortFieldList2:ArrayCollection = null;
    [Bindable] private var sortFieldList3:ArrayCollection = null;
    [Bindable] private var sortFieldList4:ArrayCollection = null;
    
    private var sortFieldArray:Array = new Array();
    private var sortFieldDataSet:Array = new Array();
    private var sortFieldSelectedItem:Array = new Array();
    
    private var csd:CustomizeSortOrder = null;
    private var selectedResults:ArrayCollection=new ArrayCollection();
    [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();

    /**
     * This method changes the state to 'result'.
     * This method is called to view the summary result screen. 
     */ 
    private function changeCurrentState():void {
        currentState = "result";
    }
    
    /**
     * This method is called on creation complete of the canvas container.
     * This method dispatch the appropriate event according to the mode.
     */  
    public function loadAll():void {
        parseUrlString();
        
        super.setXenosQueryControl(new XenosQuery());                  
           
           if (this.mode == 'QUERY') {
               this.dispatchEvent(new Event('queryInit'));
           }
           
           qh.pdf.visible = false;
           qh.pdf.includeInLayout = false;
           qh.xls.visible = false;
           qh.xls.includeInLayout = false;
    }
    
    /**
     * Extracts the parameters and set them to some variables for 
     * query criteria from the Module Loader Info.
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
                    if (tempA[0] == "mode") {
                        mode = tempA[1];
                    }
                }                        
            } else {
                mode = "QUERY";
            }                 
        } catch (e:Error) {
            trace(e);
        }               
    }
        
   /**
    * This method is used to populate key list.
    * These keys are used to parse the result xml. 
    */ 
    private function addCommonKeys():void {  
        keylist = new ArrayCollection();
        keylist.addItem("sortFieldList.item");
    }
        
   /**
    * @everride 
    * This method is called just after the result xml has come. 
    */ 
    override public function preQueryResultInit():Object{            
        addCommonKeys();
        return keylist;            
    }
        
   /**
    * This method is used to populate all the controls of the query page. 
    */ 
    private function commonInit(mapObj:Object):void{
    	fundPopUp.fundCode.setFocus();
        fundPopUp.fundCode.text = "";
        security.instrumentId.text = "";
        fundAccountNo.accountNo.text = "";
        brokerAccountNo.accountNo.text = "";
        
        this.sortField1.selectedIndex = 0;
        this.sortField2.selectedIndex = 0;
        this.sortField3.selectedIndex = 0;
        this.sortField4.selectedIndex = 0;
        
        app.submitButtonInstance = submit;

        //Populate Sort Field Combo Box
        sortFieldList1 = new ArrayCollection();
        sortFieldList1.addItem({label: " " , value : " "});
        
        sortFieldList2 = new ArrayCollection();
        sortFieldList2.addItem({label: " " , value : " "});
        
        sortFieldList3 = new ArrayCollection();
        sortFieldList3.addItem({label: " " , value : " "});
        
        sortFieldList4 = new ArrayCollection();
        sortFieldList4.addItem({label: " " , value : " "});

        for each(var obj4:Object in mapObj["sortFieldList.item"] as ArrayCollection) {
            sortFieldList1.addItem(obj4);
            sortFieldList2.addItem(obj4);
            sortFieldList3.addItem(obj4);
            sortFieldList4.addItem(obj4);
        }
    
        //For Sort Field 1 Combo
        sortFieldArray[0] = sortField1;
        sortFieldDataSet[0]= sortFieldList1;
        
        //Set the default value object
        sortFieldSelectedItem[0] = sortFieldList1.getItemAt(1);
        
        //For Sort Field 2 Combo
        sortFieldArray[1] = sortField2;
        sortFieldDataSet[1] = sortFieldList2;
        
        //Set the default value object
        sortFieldSelectedItem[1] = sortFieldList2.getItemAt(2);
        
        //For Sort Field 3 Combo
        sortFieldArray[2] = sortField3;
        sortFieldDataSet[2] = sortFieldList3;
        
        //Set the default value object
        sortFieldSelectedItem[2] = sortFieldList3.getItemAt(3);
        
        //For Sort Field 4 Combo
        sortFieldArray[3] = sortField4;
        sortFieldDataSet[3] = sortFieldList4;
        
        //Set the default value object
        sortFieldSelectedItem[3] = sortFieldList4.getItemAt(4);
        
        csd = new CustomizeSortOrder(sortFieldArray, sortFieldDataSet, sortFieldSelectedItem);
        csd.init();
        errPage.clearError(super.getInitResultEvent());
        errPageEntry.removeError();
    }
        
    /**
     * Method for updating the other three sortfields after any change in the sortfield1
     */ 
    private function sortOrder1Update():void {
          csd.update(sortField1.selectedItem, 0);
    }
    
    /**
     * Method for updating the other three sortfields after any change in the sortfield2
     */
    private function sortOrder2Update():void {         
         csd.update(sortField2.selectedItem, 1);
    }
    
    /**
     * Method for updating the other three sortfields after any change in the sortfield3
     */
    private function sortOrder3Update():void {         
        csd.update(sortField3.selectedItem, 2);
    }
    
    /**
     * Method for updating the other three sortfields after any change in the sortfield4
     */
    private function sortOrder4Update():void {         
        csd.update(sortField4.selectedItem, 3);
    }
        
       /**
     * @override
     * 
     */ 
       override public function postQueryResultInit(mapObj:Object):void{
        commonInit(mapObj);
    }

    /**
    * @override  
    * This method is called just before the query init service dispatch for query mode.
    * This method set the required HttpService url.
    */ 
    override public function preQueryInit():void {    
        var rndNo:Number= Math.random();           
          super.getInitHttpService().url = "slr/noReturnDispatch.action?method=initialExecute&rnd="+rndNo;                              
          
          var reqObj :Object = new Object();
          reqObj.SCREEN_KEY = "11163";
        super.getInitHttpService().request = reqObj;
    }        
        
    override public function preQuery():void {
        qh.resetPageNo();
        super.getSubmitQueryHttpService().url = "slr/noReturnDispatch.action?";  
        super.getSubmitQueryHttpService().request = populateRequestParams();
        super.getSubmitQueryHttpService().method="POST";
    }
    
    override public function preResetQuery():void {
        var rndNo:Number= Math.random();
        super.getResetHttpService().url = "slr/noReturnDispatch.action?method=resetQuery&rnd="+rndNo;            
    }
        
    /**
     * This method will populate the request parameters for the
     * submitQuery call and bind the parameters with the HTTPService
     * object.
     */
    private function populateRequestParams():Object {
        var reqObj : Object = new Object();
        
        reqObj.method= "submitQuery";
        reqObj.SCREEN_KEY = "11164";
        reqObj.fundCode = fundPopUp.fundCode.text;
        reqObj.securityCode = security.instrumentId.text;
        reqObj.fundAccountNo = fundAccountNo.accountNo.text;
        reqObj.brokerAccountNo = brokerAccountNo.accountNo.text;
        
        reqObj.sortField1 = StringUtil.trim(this.sortField1.selectedItem.value);
        reqObj.sortField2 = StringUtil.trim(this.sortField2.selectedItem.value);
        reqObj.sortField3 = StringUtil.trim(this.sortField3.selectedItem.value);
        reqObj.sortField4 = StringUtil.trim(this.sortField4.selectedItem.value);
        
        return reqObj;
    }
        
    override public function postQueryResultHandler(mapObj:Object):void {
        commonResult(mapObj);
    }
           
    /**
     * This metho is called to populate query result screen.  
     */     
    private function commonResult(mapObj:Object):void {
        var result:String = "";
        if(mapObj!=null) {
            if(mapObj["errorFlag"].toString() == "error") {
                queryResult.removeAll();
                errPage.showError(mapObj["errorMsg"]);
            } else if(mapObj["errorFlag"].toString() == "noError") {
                errPage.clearError(super.getSubmitQueryResultEvent());
                queryResult.removeAll();
                selectAllBind = false;
                
                queryResult=mapObj["row"];
                resetSellection(queryResult);
                prepareNormalizeView(queryResult);
                changeCurrentState();
                qh.setOnResultVisibility();
                qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")? true: false, 
                                         (mapObj["nextTraversable"] == "true")? true: false);
                qh.PopulateDefaultVisibleColumns();
                queryResult.refresh();                
            } else {
                selectAllBind = false;
                errPage.removeError();
                queryResult.removeAll();
                queryResult.refresh();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            }
            errPageEntry.removeError();
        }
    }   
       
            
      override public function preNext():Object {
          var reqObj : Object = new Object();
          reqObj.method = "doNext";
          
          return reqObj;
      }
      
      override public function prePrevious():Object {
          var reqObj : Object = new Object();
          reqObj.method = "doPrevious";
          
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
      
      override public function preGenerateXls():String {
        return null;
    }
    
    override public function preGeneratePdf():String {
        return null;
    }
    
    private function dispatchPdfEvent():void {
        this.dispatchEvent(new Event("pdf"));
    }
    
    private function dispatchXlsEvent():void {
        this.dispatchEvent(new Event("xls"));
    }
      
      private function addColumn():void {
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
     * Method to prepare the context for Fund Account popup 
     */
    private function populateFundAccountContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
      
        //passing counter party type                
        var cpTypeArray:Array = new Array(1);
        cpTypeArray[0]="INTERNAL";
        myContextList.addItem(new HiddenObject("invCpTypeContext",cpTypeArray));
       
        //passing longShortFlag
           var longShortFlagArray:Array = new Array(1);
        longShortFlagArray[0]="S";
          myContextList.addItem(new HiddenObject("longShortFlagContext",longShortFlagArray));
    
        //passing account status                
        var actStatusArray:Array = new Array(1);
        actStatusArray[0]="OPEN";
        myContextList.addItem(new HiddenObject("actStatusContext",actStatusArray));
        
        return myContextList;
    }
    
    /**
     * Method to prepare the context for Broker Account popup 
     */
    private function populateBrokerAccountContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
      
        //passing act type                
        var actTypeArray:Array = new Array(1);
        actTypeArray[0]="T|B";
        myContextList.addItem(new HiddenObject("cpActTypeContext", actTypeArray));    
                  
        //passing counter party type                
        var cpTypeArray:Array = new Array(1);
        cpTypeArray[0]="BROKER";
        myContextList.addItem(new HiddenObject("cpCPTypeContext", cpTypeArray));
    
        //passing account status                
        var actStatusArray:Array = new Array(1);
        actStatusArray[0]="OPEN";
        myContextList.addItem(new HiddenObject("actStatusContext", actStatusArray));
        
        return myContextList;
    }
            
    /**
     * Set all the selected value of the checkboxes to false.
     * This method also push two properties(selected,rowNum) dynamically to the queryResult.
     * Those properties is use to keep track of the checkbox selection.
     */ 
    private function resetSellection(queryResult:ArrayCollection):void {
        for(var i:int=0;i<queryResult.length;i++){
            queryResult[i].selected = false;
            queryResult[i].rowNum = i;
            queryResult[i].originalHoldQtyStr = queryResult[i].holdQtyStr.toString();
            queryResult[i].originalHoldQty = queryResult[i].holdQty.toString();
        }
    }
    
    /**
     * If all the checkbox is selected then set selectAllBind as true otherwise false.
     */ 
    public function setIfAllSelected() : void {
        if(isAllSelected()) {
            selectAllBind=true;
        } else {
            selectAllBind=false;
        }
    }
    
    /**
     * Check whether all the checkbox selected or not.
     * @return (true or false) Boolean
     */ 
    public function isAllSelected(): Boolean {
        var i:Number = 0;
        if(queryResult == null) {
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
    
       
    public function selectAllRecords(flag:Boolean): void {
        var i:Number = 0;
        var temp:int;
        for(i=0; i<queryResult.length; i++) {
            var obj:XML=queryResult[i];
            obj.selected = flag;
            if(flag == true){
                obj.holdQtyStr = obj.availableQtyStr.toString();
                obj.holdQty = obj.availableQty.toString();
            } else {
               obj.holdQtyStr = obj.originalHoldQtyStr.toString();
               obj.holdQty = obj.originalHoldQty.toString(); 
            }
            obj.returnQty = Number(obj.availableQty.toString()) - Number(obj.holdQty.toString());
            temp = String(obj.returnQty).indexOf(".",1);
       
            if (temp > 0){
        		 obj.returnQtyStr = this.numberFormatter.format(obj.returnQty);
        	}	else {
        		 obj.returnQtyStr = this.numberwithoutprecisin.format(obj.returnQty);
            }
            
            //numberwithoutprecisin
            queryResult[i]=obj;
            queryResult.refresh();            
        }
    }
   
   /**
    * This method is called from the header renderer.
    * This method set the selection value of the header renderer to true
    * if all the checkbox is selected otehrwise false. 
    */ 
    public function checkSelectToModify(item:Object):void {
        setIfAllSelected(); 
            if(item.selected == 'true' || item.selected == true) {
                item.holdQtyStr = item.availableQtyStr.toString();
                item.holdQty = item.availableQty.toString();
            } else {
                item.holdQtyStr = item.originalHoldQtyStr.toString();
                item.holdQty = item.originalHoldQty.toString(); 
            }
            
            resultSummary.dispatchEvent(new NoReturnChangeEvent(NoReturnChangeEvent.HOLD_QTY_CHANGE_EVENT,item.rowNum, item));
            queryResult.enableAutoUpdate();     
	}    
    
    /**
     * This method is used to populate selected row index array.
     * @return (tempArray) Array
     */ 
    private function getSelectedRows():Array {
        var tempArray:Array = new Array();
        for each(var obj:Object in queryResult) {
            if(obj.selected == true)
                tempArray.push(obj.rowNum);
        }
        return tempArray;
    }
    
    public function setFocusOnHoldQuantity():void {
        //queryResult.refresh();
        resultSummary.horizontalScrollPosition = resultSummary.maxHorizontalScrollPosition;
    }
    public function handleChangedData(data:Object):void{
        resultSummary.dispatchEvent(new NoReturnChangeEvent(NoReturnChangeEvent.DATA_CHANGE_SELECTED_EVENT,data.rowNum, data));
    }
    private function showSbrEntry():void{
        var parentApp :UIComponent = UIComponent(this.parentApplication);
        var selectedItem:Array = getSelectedRows();
        if(selectedItem.length < 1){
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('borrow.error.rows.selected'));
            return;
        }else{
         	var selectedItemArray:Array = (selectedItem.toString().split(","));
         	var holdQty:String = null;
         	var availableQty:String = null;
         	var holdQtyStr:String = null;
         	var availableQtyStr:String = null;
        	for(var index:int=0; index<selectedItemArray.length; index++ ) {
        		holdQtyStr = (queryResult[selectedItemArray[index]].holdQtyStr);
        		availableQtyStr = (queryResult[selectedItemArray[index]].availableQtyStr);
        		// Convert the commaseparted value into normal number
        		holdQty = dataFormatter.parseNumberString(String(holdQtyStr));
        		availableQty = dataFormatter.parseNumberString(String(availableQtyStr));
	          
	            if (holdQty == null || isNaN(Number(holdQty)) 
	            	|| availableQty == null || isNaN(Number(availableQty))) {
	            	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('borrow.error.invalidholdquantity'));
                    return;
                } 
        	}  
        }
        var sPopup : SummaryPopup;    
        sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
        sPopup.title = this.parentApplication.xResourceManager.getKeyValue('borrow.label.noreturnentry.popup.title');    
        /* sPopup.width = parentApplication.width * 50/100;
        sPopup.height = parentApplication.height * 55/100; */
        sPopup.width = 800;
        sPopup.height = 400;
        PopUpManager.centerPopUp(sPopup);
        sPopup.owner = this;
        sPopup.addEventListener(CloseEvent.CLOSE, closeHandler);
        //sPopup.dataObj = queryResult;
        sPopup.moduleUrl = "assets/appl/slr/Sbr_NoReturnEntryModule.swf"+Globals.QS_SIGN+"mode"+Globals.EQUALS_SIGN+mode+Globals.AND_SIGN+"selectedItems"+Globals.EQUALS_SIGN+selectedItem;
    }
    
    
    private function closeHandler(event:CloseEvent):void{
        if(this.refreshQuery == true){
            this.dispatchEvent(new Event('querySubmit'));
        }
        this.refreshQuery = true;
    }
    public function showErrorFromPopup(errColl:ArrayCollection):void {
        errPageEntry.showError(errColl);
    }
    /**
     *  Prepares normalize view in the query result.
     */ 
    public function prepareNormalizeView(orgnlQueryResult:ArrayCollection):void {
        var oldFundAcPk:String = "";
        var oldBrokerAcPk:String = "";
        var oldFundPk:String = "";
        var isFirstTime:Boolean = true;
        
        if(orgnlQueryResult.length < 1){
            return;
        }else{
            var fundPk:String = "";
            var fundAcPk:String = "";
            var brokerAcPk:String = "";            
            for each(var obj:Object in orgnlQueryResult){
                fundPk = obj.fundPk;
                fundAcPk = obj.fundAccountPk;
                brokerAcPk = obj.brokerAccountPk;
//                trace("fundPk="+ fundPk + " fundAcPk=" + fundAcPk + " brokerAcPk=" + brokerAcPk)
                if (isFirstTime) {
                    // This is executed only the first query view object. 
                    oldFundPk = fundPk;
                    oldFundAcPk = fundAcPk;
                    oldBrokerAcPk = brokerAcPk;
                    isFirstTime = false;
                }else{
                    if(oldFundPk == fundPk) {
                        obj.fundCode = XenosStringUtils.EMPTY_STR;
                        obj.fundName = XenosStringUtils.EMPTY_STR;
                        
                        if (oldFundAcPk == fundAcPk) {
//                            obj.fundAccountPrefix = XenosStringUtils.EMPTY_STR;
//                            obj.fundAccountNo = XenosStringUtils.EMPTY_STR;
                            obj.fundAccountName = XenosStringUtils.EMPTY_STR;
                            obj.fundAccountNoDisplayStr = XenosStringUtils.EMPTY_STR;
                            
                            if (oldBrokerAcPk == brokerAcPk) {
//                                obj.brokerAccountPrefix = XenosStringUtils.EMPTY_STR;
//                                obj.brokerAccountNo = XenosStringUtils.EMPTY_STR;
                                obj.brokerAccountName = XenosStringUtils.EMPTY_STR;
                                obj.brokerAccountNoDisplayStr = XenosStringUtils.EMPTY_STR;                                
                            }
                        }
                    }                    
                    oldFundPk = fundPk;
                    oldFundAcPk = fundAcPk;
                    oldBrokerAcPk = brokerAcPk;
                }
            }
        }        
    }