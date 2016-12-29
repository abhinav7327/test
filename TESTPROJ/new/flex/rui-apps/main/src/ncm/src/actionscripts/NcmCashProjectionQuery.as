

import com.nri.rui.ncm.validators.NcmCashProjectionQueryValidator;
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.ProcessResultUtil;

import mx.collections.ArrayCollection;
import mx.controls.DataGrid;
import mx.events.DataGridEvent;
import mx.events.ResourceEvent;
import mx.resources.ResourceBundle;
import mx.utils.StringUtil;
            
          
     [Bindable]
        private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     [Bindable]
        private var queryResult:ArrayCollection = new ArrayCollection();
     
     private var keylist:ArrayCollection = new ArrayCollection();     
     private var sortUtil: ProcessResultUtil = new ProcessResultUtil();
     
     [Bindable]
        private var mode:String = "query";
            
     //Items returning through context - Non display objects for accountPopup
     [Bindable]
        public var returnContextItem:ArrayCollection = new ArrayCollection();
        
     [Bindable]
        private var initcol:ArrayCollection = new ArrayCollection();
        
     private var  csd:CustomizeSortOrder = null;
     private var sortFieldArray:Array = new Array();
     private var sortFieldDataSet:Array = new Array();
     private var sortFieldSelectedItem:Array = new Array();
     
     // Needed to hold value at submit time and pass to the ItemRenderer.
     public var baseDateItemRndr:String = ""; 
      
     /**
      *  datagrid header release event handler to handle datagridcolumn sorting
      */
     public function dataGrid_headerRelease(evt:DataGridEvent):void {
        var dg:DataGrid = DataGrid(evt.currentTarget);
        sortUtil.clickedColumn = dg.columns[evt.columnIndex];       
     }
          
     private function changeCurrentState():void {
        currentState = "result";
     }
             
     public function loadAll():void {
        parseUrlString();
        super.setXenosQueryControl(new XenosQuery());
     
        if(this.mode == 'query') {
            this.dispatchEvent(new Event('queryInit'));
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
            if(params != null) {
                for (var i:int = 0; i < params.length; i++) {
                    var tempA:Array = params[i].split("=");  
                    if (tempA[0] == "mode") {
                        //XenosAlert.info("movArray param = " + tempA[1]);
                        mode = tempA[1];
                    }
                }                       
            } else {
                mode = "query";
            }  
        } catch (e:Error) {
            trace(e);
        }               
     }
         
     /**
      * Method for updating the other two sortfields after any change in the sortfield1
      */ 
     private function sortOrder1Update():void {
        csd.update(sortField1.selectedItem, 0);
     }
        
     /**
      * Method for updating the other two sortfields after any change in the sortfield2
      */
     private function sortOrder2Update():void {         
        csd.update(sortField2.selectedItem, 1);
     } 
            
     override public function preQueryInit():void {
        var rndNo:Number = Math.random();
        var reqObj:Object = new Object();
        reqObj.SCREEN_KEY = 11074;
        super.getInitHttpService().request = reqObj;
        super.getInitHttpService().url = "ncm/ncmCashProjectionQueryDispatch.action?method=initialExecute&&mode=query&&menuType=Y&rnd=" + rndNo;            
     }
     
     override public function preQueryResultInit():Object {
        addCommonKeys();        
        return keylist;         
     }
         
     private function addCommonKeys():void {  
        keylist = new ArrayCollection();        
        keylist.addItem("dateFrom");
        keylist.addItem("dateTo");
        keylist.addItem("sortFieldList1.item");
        keylist.addItem("sortFieldList2.item");
        keylist.addItem("sortField1");
        keylist.addItem("sortField2");
     }
     
     override public function postQueryResultInit(mapObj:Object):void {
        commonInit(mapObj);         
     }
        
     private function commonInit(mapObj:Object):void {
        var i:int = 0;
        var selIndx:int = 0;
        var tempColl:ArrayCollection = new ArrayCollection();
        var initColl:ArrayCollection = new ArrayCollection();
        var dateStr:String = null;
       
        //For SortField1
        var sortField1Default:String = mapObj[keylist.getItemAt(4)].toString();
        //For SortField2
        var sortField2Default:String = mapObj[keylist.getItemAt(5)].toString();

        errPage.clearError(super.getInitResultEvent()); //clears the errors if any 
        
        //initiate text fields
        this.fundPopUp.fundCode.text = "";
        this.ccyBox.ccyText.text = "";      
        this.dateFrom.text = mapObj[keylist.getItemAt(0)].toString();
        this.dateTo.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(1)].toString());
        
        //----------Start of population of SortField1----------//           
        if(null != mapObj[keylist.getItemAt(2)]) {
            initcol = new ArrayCollection();
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
                
            if(mapObj[keylist.getItemAt(2)] is ArrayCollection) {
                for each(var item1:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)) {
                    initcol.addItem(item1);
                }
            } else {
                    initcol.addItem(mapObj[keylist.getItemAt(2)]);
            }
            
            for(i = 0; i<initcol.length; i++) {
                //Get the default value object's index
                if(XenosStringUtils.equals((initcol[i].value), sortField1Default)) {                    
                    selIndx = i;
                }
                tempColl.addItem(initcol[i]);            
            }
                
            sortFieldArray[0] = sortField1;
            sortFieldDataSet[0] = tempColl;
            //Set the default value object
            sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
        } else {
                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ncm.error.prompt.populate.sortorder1'));
        }           
        //---------------End of population of SortField1-----------------------//
            
        //--------Start of population of sortField2---------//          
        if(null != mapObj[keylist.getItemAt(3)]) {
            initcol = new ArrayCollection();
            tempColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            selIndx = 0;
                
            if(mapObj[keylist.getItemAt(3)] is ArrayCollection) {
                for each(var item2:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)) {
                    initcol.addItem(item2);
                }
            } else {
                    initcol.addItem(mapObj[keylist.getItemAt(3)]);
            }
            for(i = 0; i<initcol.length; i++) {
                //Get the default value object's index
                if(XenosStringUtils.equals((initcol[i].value), sortField2Default)) {                    
                    selIndx = i;
                }
                tempColl.addItem(initcol[i]);            
            }
                
            sortFieldArray[1] = sortField2;
            sortFieldDataSet[1] = tempColl;
            //Set the default value object
            sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ncm.error.prompt.populate.sortorder2'));
        }
        fundPopUp.setFocus();           
        //--------End of population of sortField2---------// 
            
        //-------------Initializing the sortfields-------------//
        csd = new CustomizeSortOrder(sortFieldArray, sortFieldDataSet, sortFieldSelectedItem);
        csd.init();
     }
     
     override public function preQuery():void {
        setValidator();
        qh.resetPageNo();
        super.getSubmitQueryHttpService().url = "ncm/ncmCashProjectionQueryDispatch.action?";  
        super.getSubmitQueryHttpService().request = populateRequestParams();
     }
     
     private function setValidator():void {
        var myModel:Object = {
                                cashProjectionQuery:{
                                    dateFrom:this.dateFrom.text,
                                    dateTo:this.dateTo.text
                                }
                             }; 
        super._validator = new NcmCashProjectionQueryValidator();
        super._validator.source = myModel;
        super._validator.property = "cashProjectionQuery";
     }
        
     /**
      * This method will populate the request parameters for the
      * submitQuery call and bind the parameters with the HTTPService
      * object.
      */
     private function populateRequestParams():Object {
        var reqObj:Object = new Object();
         
        reqObj.method = "submitQuery";
        
        reqObj.SCREEN_KEY = 11075;
        
        reqObj.fundCode = this.fundPopUp.fundCode.text;
         
        reqObj.currency = this.ccyBox.ccyText.text;
         
        reqObj.dateFrom = this.dateFrom.text;
         
        reqObj.dateTo = this.dateTo.text;
        
        reqObj.includeFailSettlements = this.failSettlements.selected;

        reqObj.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : Globals.EMPTY_STRING;
       
        reqObj.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : Globals.EMPTY_STRING;
       
        reqObj.rnd = Math.random() + "";
        return reqObj;
     }
    
     override public function postQueryResultHandler(mapObj:Object):void {
        baseDateItemRndr = this.dateFrom.text;
        baseDateItemRndr = this.dateTo.text;
        commonResult(mapObj);
     }
        
     private function commonResult(mapObj:Object):void {
        var result:String = "";
        if(mapObj != null) {   
            //XenosAlert.info("mapObj : "+mapObj.toString());       
            if(mapObj["errorFlag"].toString() == "error") {
                //result = mapObj["errorMsg"] .toString();
                queryResult.removeAll();
                errPage.showError(mapObj["errorMsg"]);
            } else if(mapObj["errorFlag"].toString() == "noError") {
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
            } else {
                errPage.removeError();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            }           
        }
        //XenosAlert.info(result);
     }   
       
      
     override public function preResetQuery():void {
     	this.failSettlements.selected = false;
        var rndNo:Number = Math.random();
        super.getResetHttpService().url = "ncm/ncmCashProjectionQueryDispatch.action?method=resetQuery&&mode=query&&menuType=Y&rnd=" + rndNo;
     }
        
     override  public function preGenerateXls():String {
        var url:String = null;
        if(mode == "query") {                   
            url = "ncm/ncmCashProjectionQueryDispatch.action?method=generateXLS&denormalizingFlag=true&screenId=NCCPQ";
        }
        return url;
     }
        
     override public function preGeneratePdf():String {
        var url:String = null;
        if(mode == "query") {                   
            url = "ncm/ncmCashProjectionQueryDispatch.action?method=generatePDF";
        }
        return url;
     }  
            
     override public function preNext():Object {
        var reqObj:Object = new Object();
        reqObj.rnd = Math.random() + "";
        reqObj.method = "doNext";
        return reqObj;
     }
        
     override public function prePrevious():Object {
        var reqObj:Object = new Object();
        reqObj.rnd = Math.random() + "";
        reqObj.method = "doPrevious";
        return reqObj;
     }  
          
     private function dispatchPrintEvent():void {
        this.dispatchEvent(new Event("print"));
     }
       
     private function dispatchPdfEvent():void {
        this.dispatchEvent(new Event("pdf"));
     }
       
     private function dispatchXlsEvent():void {
        this.dispatchEvent(new Event("xls"));
     }
         
     private function dispatchNextEvent():void {
        this.dispatchEvent(new Event("next"));
     }
      
     private function dispatchPrevEvent():void {
        this.dispatchEvent(new Event("prev"));
     }      
      

