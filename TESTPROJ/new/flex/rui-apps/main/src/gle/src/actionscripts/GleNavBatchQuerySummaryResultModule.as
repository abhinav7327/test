
 // ActionScript file for Gle Nav Query
 	
 	import com.nri.rui.core.Globals;
 	import com.nri.rui.core.controls.XenosAlert;
 	import com.nri.rui.core.controls.XenosQuery;
 	import com.nri.rui.core.startup.XenosApplication;
 	import com.nri.rui.core.utils.ProcessResultUtil;
 	
 	import flash.events.IEventDispatcher;
 	
 	import mx.collections.ArrayCollection;
 	import mx.controls.DataGrid;
 	import mx.events.DataGridEvent;
 	import mx.events.ResourceEvent;
 	import mx.resources.ResourceBundle;
        
	//----------------------------------------------------------------------------
	[Bindable]
	private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
	[Bindable]
	private var summaryResult:ArrayCollection= new ArrayCollection();
	 
	private var keylist:ArrayCollection = new ArrayCollection();
	private var resultlist:ArrayCollection = new ArrayCollection();
	 
	private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
	[Bindable]private var fromPage : String = "queryResult";
	[Bindable]private var fundCodeStr : String = "";
	[Bindable]private var valuationDateDisplay : String = "";
	
	/**
	 *  datagrid header release event handler to handle datagridcolumn sorting
	*/
	public function dataGrid_headerRelease(evt:DataGridEvent):void {				
		var dg:DataGrid = DataGrid(evt.currentTarget);
		sortUtil.clickedColumn = dg.columns[evt.columnIndex];		
	}
	
	public function loadAll():void{
		parseUrlString();
		super.setXenosQueryControl(new XenosQuery());
		
		this.dispatchEvent(new Event('querySubmit'));
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
					if (tempA[0] == "fundCode") {
						fundCodeStr = tempA[1];
					}
					if (tempA[0] == "valuationDateDisplay") {
						valuationDateDisplay = tempA[1];
					}
					if (tempA[0] == "fromPage") {
						fromPage = tempA[1];
					}
				}
			}
		} catch (e:Error) {
			trace(e);
		}               
	}
	
    override public function preQuery():void{
		//setValidator();
		qh.resetPageNo();	
		super.getSubmitQueryHttpService().url = "gle/gleNavQueryDispatch.action?";  
		super.getSubmitQueryHttpService().request  =populateRequestParams();
    }
	
	/**
     * This method will populate the request parameters for the
     * submitQuery call and bind the parameters with the HTTPService
     * object.
     */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	reqObj.SCREEN_KEY = 284;
    	reqObj.method = "viewResult";
    	reqObj.fund_Code=this.fundCodeStr;
    	reqObj.valuationDateDisplay=this.valuationDateDisplay;
    	reqObj.fromPage = this.fromPage;
    	reqObj.rnd = Math.random() + "";
     	return reqObj;
    }
	
	override public function preQueryResultHandler():Object{
		resultlist = new ArrayCollection(); 
        resultlist.addItem("resultView2List.resultView2");
		resultlist.addItem("previousTraversable2");
        resultlist.addItem("nextTraversable2");
		return resultlist;        	
	}
	
	override public function postQueryResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    }
    
    private function commonResult(mapObj:Object):void{    	
    	//XenosAlert.info("mapObj : "+mapObj.toString()); 
    	var result:String = "";
    	if(mapObj!=null){   
    		if(mapObj["errorFlag"].toString() == "error"){
	    		summaryResult.removeAll();
	    		errPage.showError(mapObj["errorMsg"]);
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    		errPage.clearError(super.getSubmitQueryResultEvent());
				summaryResult.removeAll();
				summaryResult=mapObj[resultlist.getItemAt(0)];
				if(summaryResult.length == 0){               	
	    			errPage.removeError();
	    			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            	} else {
					//qh.setOnResultVisibility();
		    		qh.setPrevNextVisibility((mapObj[resultlist.getItemAt(1)] == "true")?true:false,(mapObj[resultlist.getItemAt(2)] == "true")?true:false );
		    		qh.PopulateDefaultVisibleColumns();
            	}
			}    		
    	}
    }
    
	override public function preNext():Object{
		var reqObj : Object = new Object();
		reqObj.method = "doNext";
		reqObj.listIndex = "1";
		return reqObj;
	}
	
	override public function prePrevious():Object{
		var reqObj : Object = new Object();
		reqObj.method = "doPrevious";
		reqObj.listIndex = "1";
		return reqObj;
	}
    
    override public function preGenerateXls():String{
		var url : String =null;
		return url;
    }
    
	override public function preGeneratePdf():String{
    	var url : String =null;
		return url;
	}
    
	private function dispatchPrintEvent():void{
		this.dispatchEvent(new Event("print"));
	}  
	
    private function dispatchPdfEvent():void{
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