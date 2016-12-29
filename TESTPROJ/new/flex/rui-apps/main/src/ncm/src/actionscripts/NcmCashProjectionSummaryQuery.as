
 import mx.collections.ArrayCollection;
 import mx.controls.DataGrid;
 import mx.events.DataGridEvent;
 import mx.utils.StringUtil;
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.controls.XenosQuery;
 import com.nri.rui.core.utils.DateUtils;
 import com.nri.rui.core.utils.ProcessResultUtil;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.ncm.validators.NcmCashProjectionSummaryQueryValidator;
 


 
    [Bindable]
    private var queryResult:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var mode:String = "query";
    [Bindable]
	private var initcol:ArrayCollection = new ArrayCollection();
    private var sortUtil:ProcessResultUtil= new ProcessResultUtil();
    private var keylist:ArrayCollection = new ArrayCollection();     

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
            // Remove everything before the question mark, including the question mark.
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
                mode = "query";
            }  
        } catch (e:Error) {
            trace(e);
        }               
    }

    override public function preQueryInit():void {
        var rndNo:Number = Math.random();
        var reqObj:Object = new Object();
        reqObj.SCREEN_KEY = 12136;
        super.getInitHttpService().request = reqObj;
        super.getInitHttpService().url = "ncm/ncmCashProjectionSummaryQueryDispatch.action?method=initialExecute&&mode=query&&menuType=Y&rnd=" + rndNo;            
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
        keylist.addItem("projectionDate1");
        keylist.addItem("projectionDate2");
        keylist.addItem("projectionDate3");
        keylist.addItem("projectionDate4");
        keylist.addItem("projectionDate5");
        keylist.addItem("projectionDate6");
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
       
                errPage.clearError(super.getInitResultEvent()); //clears the errors if any 
        
        //initiate text fields
        this.fundPopUp.fundCode.text = "";
        this.ccyBox.ccyText.text = "";      
        this.dateFrom.text = mapObj[keylist.getItemAt(0)].toString();
        this.dateTo.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(1)].toString());
        
        this.openDate.headerText = mapObj[keylist.getItemAt(0)].toString();
        
    }

    override public function preQuery():void {
        setValidator();
        qh.resetPageNo();
        super.getSubmitQueryHttpService().url = "ncm/ncmCashProjectionSummaryQueryDispatch.action?";  
        super.getSubmitQueryHttpService().request = populateRequestParams();
    }

    private function setValidator():void {
        var myModel:Object = {
                                cashProjectionSummaryQuery:{
                                    dateFrom:this.dateFrom.text,
                                    dateTo:this.dateTo.text
                                }
                             }; 
        super._validator = new NcmCashProjectionSummaryQueryValidator();
        super._validator.source = myModel;
        super._validator.property = "cashProjectionSummaryQuery";
    }

    /**
     * This method will populate the request parameters for the
     * submitQuery call and bind the parameters with the HTTPService
     * object.
     */
    private function populateRequestParams():Object {
        var reqObj:Object = new Object();
        reqObj.method = "doQuery";
        reqObj.SCREEN_KEY = 12137;
        reqObj.fundCode = this.fundPopUp.fundCode.text;
        reqObj.currency = this.ccyBox.ccyText.text;
        reqObj.dateFrom = this.dateFrom.text;
        reqObj.dateTo = this.dateTo.text;
        reqObj.includeFailSettlements = this.failSettlements.selected;
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
            if(mapObj["errorFlag"].toString() == "error") {
                queryResult.removeAll();
                errPage.showError(mapObj["errorMsg"]);
            } else if(mapObj["errorFlag"].toString() == "noError") {
                errPage.clearError(super.getSubmitQueryResultEvent());
                queryResult.removeAll();
                queryResult=mapObj["row"];
                processResult();
                changeCurrentState();
                qh.setOnResultVisibility();
                qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
                qh.PopulateDefaultVisibleColumns();
            } else {
                errPage.removeError();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            }           
        }
    }   

	/**
	 *This function processes the collection returned and modifies 
	 * it to add records for SubTotals and Totals. 
	 */ 
    private function processResult():void {
    	
    	resultSummary.columns = resultSummary.columns.slice(0,6);
    	var obj:Object = queryResult[0].dateList;
    	var i:int = 1 ;
    	for each (var dateStr:String in obj.date){
    		
    		trace("Date:" +dateStr);
    		addColumn(dateStr ,i++);
    	 		
    	}    	
    	
    }
    /**
    * The method is used to add the columns
    */
	private function addColumn(date:String , count:Number):void
		{
			//Add a object
			
			var dg :DataGridColumn = new DataGridColumn();
			dg.dataField="amountDateDisplay"+count;
			dg.editable = false;
			dg.headerText = date;
			dg.minWidth = 90;
			dg.setStyle("textAlign","right");
			var cols :Array = resultSummary.columns;
			cols.push(dg);
			resultSummary.columns = cols;
			
		}
    override public function preResetQuery():void {
        var rndNo:Number = Math.random();
        super.getResetHttpService().url = "ncm/ncmCashProjectionSummaryQueryDispatch.action?method=resetQuery&&mode=query&&menuType=Y&rnd=" + rndNo;
    }
        
    override  public function preGenerateXls():String {
        var url:String = null;
        if(mode == "query") {                   
            url = "ncm/ncmCashProjectionSummaryQueryDispatch.action?method=generateXLS";
        }
        return url;
    }
        
    override public function preGeneratePdf():String {
        var url:String = null;
        if(mode == "query") {                   
            url = "ncm/ncmCashProjectionSummaryQueryDispatch.action?method=generatePDF";
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
