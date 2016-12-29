// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.stl.validators.CashTransferQueryValidator;

import flash.events.Event;
import mx.collections.ArrayCollection;
import mx.controls.DataGrid;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.DataGridEvent;
import mx.events.ResourceEvent;
import mx.resources.ResourceBundle;
            
      //private var mkt:XenosQuery = new MarketPriceQuery();
      
    [Bindable]
    private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
    private var queryResult:ArrayCollection= new ArrayCollection();
    private var keylist:ArrayCollection = new ArrayCollection(); 
    private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
    private var csd:CustomizeSortOrder=null;
    [Bindable]
    private var mode : String = "cancel";
    private var sortFieldArray:Array = new Array();
    private var sortFieldDataSet:Array = new Array();
    private var sortFieldSelectedItem:Array = new Array();
      
    /**
    *  datagrid header release event handler to handle datagridcolumn sorting
    */
    public function dataGrid_headerRelease(evt:DataGridEvent):void {                
        var dg:DataGrid = DataGrid(evt.currentTarget);
        sortUtil.clickedColumn = dg.columns[evt.columnIndex];       
    }
      private function changeCurrentState():void{
            currentState = "result";
      }
             
       public function loadAll():void{
           parseUrlString();
           super.setXenosQueryControl(new XenosQuery());
           if(this.mode == 'query'){
             this.dispatchEvent(new Event('queryInit'));
             this.stlRefNo.setFocus();
           } else { 
             this.dispatchEvent(new Event('cancelInit'));
             this.stlRefNo.setFocus();
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
    
    override public function preQueryInit():void {
        var rndNo:Number= Math.random();
        var reqObject:Object = new Object();
        reqObject.SCREEN_KEY = 535;
        super.getInitHttpService().request = reqObject;
        super.getInitHttpService().url = "stl/wireInstructionQueryDispatch.action?method=initialExecute&mode=query&menuType=Y&rnd=" + rndNo;            
    }
    
    
    
    override public function preCancelInit():void {
       var rndNo:Number= Math.random();
       super.getInitHttpService().url = "stl/wireInstructionQueryDispatch.action?&rnd=" + rndNo;  
        var reqObject:Object = new Object();
        reqObject.mode=this.mode;
        reqObject.method="initialExecute";
        reqObject.SCREEN_KEY = 535;
        super.getInitHttpService().request = reqObject;
    }        
    
    private function addCommonKeys():void {  
        keylist = new ArrayCollection();        
        keylist.addItem("wireTypeList.item");
        keylist.addItem("dataSourceList.item");
        keylist.addItem("sortFieldList.item");
    }
    
    override public function preQueryResultInit():Object {
        addCommonKeys();    
        return keylist;         
    }
    
    
    
    override public function preCancelResultInit():Object {
        addCommonKeys();
        return keylist;
    }
        
        
    private function commonInit(mapObj:Object):void{
        
        errPage.clearError(super.getInitResultEvent());
        this.queryResult.removeAll();
        
        var selIndx:int = 0;
        var i:int = 0;
        var tempColl:ArrayCollection = new ArrayCollection();
        
        var sortField1Default:String = "settlement_reference_no";
        var sortField2Default:String = "value_date";
        var sortField3Default:String = "wire_type";
        
        var wireArrColl:ArrayCollection = new ArrayCollection();
        wireArrColl.addItem({label:" ", value: ""});
        for each(var itemWire:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)) {
            wireArrColl.addItem(itemWire);
        }
        wireType.dataProvider  = wireArrColl;
        
        var dsArrColl:ArrayCollection = new ArrayCollection();
        dsArrColl.addItem({label:" ", value: ""});
        for each(var itemDs:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)) {
            dsArrColl.addItem(itemDs);
        }
        dataSource.dataProvider  = dsArrColl;
        
        var arrCollSort:ArrayCollection = new ArrayCollection();
        for each(var itemSort:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)) {
            arrCollSort.addItem(itemSort);
        }
        
        /**** For SortField1 ****/
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: ""});
        for(i=0; i<arrCollSort.length; ++i) {
            tempColl.addItem(arrCollSort[i]);
        }
        sortFieldArray[0]=sortField1;
        sortFieldDataSet[0]=tempColl;
        //Set the default value object
        sortFieldSelectedItem[0] = tempColl.getItemAt(selIndx+1);
        
        
        /**** For SortField2 ****/
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: ""});
        for(i=0; i<arrCollSort.length; ++i) {
            tempColl.addItem(arrCollSort[i]);
            if(XenosStringUtils.equals((arrCollSort[i].value),sortField2Default)){                    
                selIndx = i;
            }
        }
        sortFieldArray[1]=sortField2;
        sortFieldDataSet[1]=tempColl;
        //Set the default value object
        sortFieldSelectedItem[1] = tempColl.getItemAt(selIndx+1);
        
        /**** For SortField3 ****/
        selIndx = 0;
        tempColl = new ArrayCollection();
        tempColl.addItem({label:" ", value: ""});
        for(i=0; i<arrCollSort.length; ++i) {
            tempColl.addItem(arrCollSort[i]);
            if(XenosStringUtils.equals((arrCollSort[i].value),sortField3Default)) {                    
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
    private function sortOrder1Update():void {
        csd.update(sortField1.selectedItem,0);
    }
     
    private function sortOrder2Update():void {      
        csd.update(sortField2.selectedItem,1);
    }
     
    private function sortOrder3Update():void {      
        csd.update(sortField3.selectedItem,2);
    }
    private function populateContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection();
        //passing counter party type                
        var cpTypeArray:Array = new Array(2);
        cpTypeArray[0]="BANK/CUSTODIAN";
        cpTypeArray[1]="BROKER";
        
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
    
        //passing account status                
        var actStatusArray:Array = new Array(1);
        actStatusArray[0]="OPEN";
        myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
        return myContextList;
      }
        override public function postQueryResultInit(mapObj:Object):void {
            commonInit(mapObj);
        }
        
        override public function postCancelResultInit(mapObj:Object):void {
            commonInit(mapObj); 
        }
        
        private function setValidator():void {
        
            var validateModel:Object= {
                                cashTransferQuery: {                                 
                                     valueDateFrom:this.valueDateFrom.text,
                                     valueDateTo:this.valueDateTo.text
                                }
                           }; 
             super._validator = new CashTransferQueryValidator();
             super._validator.source = validateModel ;
             super._validator.property = "cashTransferQuery";
        }
        
        override public function preQuery():void {
            setValidator();
            qh.resetPageNo();   
            super.getSubmitQueryHttpService().url = "stl/wireInstructionQueryDispatch.action?";  
            super.getSubmitQueryHttpService().request  = populateRequestParams();
           
        }
        
        override public function preCancel():void{
            if(queryResult.length == 1) {
            	queryResult.removeAll();
            }
            qh.resetPageNo();
            super.getSubmitQueryHttpService().url = "stl/wireInstructionQueryDispatch.action?"; 
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
        
        reqObj.settlementReferenceNo = this.stlRefNo.text;
        
        reqObj.accountNo = this.cpAccountNo.accountNo.text;
        
        reqObj.valueDateFrom = this.valueDateFrom.text;
        
        reqObj.valueDateTo = this.valueDateTo.text;
        
        reqObj.wireType = this.wireType.selectedItem != null ? this.wireType.selectedItem.value : "";
        
        reqObj.dataSource = this.dataSource.selectedItem != null ? this.dataSource.selectedItem.value : "";
        
        reqObj.sortField1 = this.sortField1.selectedItem != null ? this.sortField1.selectedItem.value : "";
        
        reqObj.sortField2 = this.sortField2.selectedItem != null ? this.sortField2.selectedItem.value : "";
        
        reqObj.sortField3 = this.sortField3.selectedItem != null ? this.sortField3.selectedItem.value : "";
        
        reqObj.SCREEN_KEY = 536;
        
        return reqObj;
    }
    
    override public function postQueryResultHandler(mapObj:Object):void{
        commonResult(mapObj);
    }
    override public function postCancelResultHandler(mapObj:Object):void{
        commonResult(mapObj);
    }
       
        
    private function commonResult(mapObj:Object):void {     
        var result:String = "";
        if(mapObj!=null){   
            if(mapObj["errorFlag"].toString() == "error"){
                queryResult.removeAll();
                errPage.showError(mapObj["errorMsg"]);
            } else if(mapObj["errorFlag"].toString() == "noError") {
            	errPage.clearError(super.getSubmitQueryResultEvent());
              	queryResult.removeAll();
              	queryResult=mapObj["row"];
              	changeCurrentState();
               	qh.setOnResultVisibility();
               	qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
               	qh.PopulateDefaultVisibleColumns();
                
               	for(var i:int=0;i<queryResult.length;i++) {
               		queryResult.getItemAt(i).itemIndex=i;
               	}
            } else {
                errPage.removeError();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            }
        }
    }   
       
      
    override public function preResetQuery():void {
        var rndNo:Number= Math.random();
        super.getResetHttpService().url = "stl/wireInstructionQueryDispatch.action?method=resetQuery&&mode=query&&menuType=Y&rnd=" + rndNo;         
    }
    override public function postResetQuery():void {
        resetValues();
    }
    
    override public function preResetCancel():void {
        XenosAlert.info("In preResetCancel()");
      /*var rndNo:Number= Math.random();
      super.getResetHttpService().url = "stl/wireTransferCancelDispatch.action?&rnd=" + rndNo;  
      var reqObject:Object = new Object();
      reqObject.mode=this.mode;
      reqObject.method="resetQuery";
      super.getResetHttpService().request = reqObject;
      this.stlRefNo.setFocus();*/
    }
        
    private function resetValues():void {
        
        this.stlRefNo.text = null;
        this.cpAccountNo.accountNo.text = null;
        this.valueDateFrom.text = "";
        this.valueDateTo.text = "";
        errPage.removeError();
    }      
        
            
    override    public function preNext():Object {
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
      
        private function addColumn():void {
            //Add an object
            
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
