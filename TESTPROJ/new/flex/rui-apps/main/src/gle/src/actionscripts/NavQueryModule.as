
 // ActionScript file for Gle Nav Query
 	
 	import com.nri.rui.core.Globals;
 	import com.nri.rui.core.controls.XenosAlert;
 	import com.nri.rui.core.controls.XenosQuery;
 	import com.nri.rui.core.startup.XenosApplication;
 	import com.nri.rui.core.utils.DateUtils;
 	import com.nri.rui.core.utils.ProcessResultUtil;
 	import com.nri.rui.gle.validators.GleNavValidator;
 	
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
	[Bindable]private var mode : String = "query";
	
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
		super.setXenosQueryControl(new XenosQuery());
		
		this.dispatchEvent(new Event('queryInit'));
		this.fundPopUp.fundCode.setFocus();
	}
	
	override public function preQueryInit():void{
		var rndNo:Number= Math.random();
		super.getInitHttpService().url = "gle/gleNavQueryDispatch.action?method=initialExecute&rnd=" + rndNo;        	
	}
	
	override public function preQueryResultInit():Object{
		keylist = new ArrayCollection(); 
        keylist.addItem("valuationDate");	    	
		return keylist;        	
	}
	
	override public function postQueryResultInit(mapObj:Object):void {
		fundPopUp.fundCode.text = "";
		valuationDate.text = "";
		errPage.clearError(super.getInitResultEvent());
		
		var valdate:String = mapObj[keylist.getItemAt(0)].toString();
		
		if(valdate != null) {
            valuationDate.text=valdate;     
            valuationDate.selectedDate =  DateUtils.toDate(valdate);      
        } else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('gle.error.label.valuation.date.initialize'));
        }
    }
	
	private function setValidator():void{
		var validateModel:Object={
								gleNavQuery:{
								valuationDate : valuationDate.text
								}
							}; 
		super._validator = new GleNavValidator();
        super._validator.source=validateModel;
        super._validator.property="gleNavQuery";
	}
	
    override public function preQuery():void{
		setValidator();
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
    	reqObj.method = "submitQuery";
    	reqObj.fundCode=fundPopUp.fundCode.text;
    	reqObj.valuationDate=valuationDate.text;
    	reqObj.fromPage = "query";
    	//reqObj.traversableIndex = "1";
    	reqObj.rnd = Math.random() + "";
     	return reqObj;
    }
	
	override public function preQueryResultHandler():Object{
		resultlist = new ArrayCollection(); 
        resultlist.addItem("resultView1List.resultView1");
        resultlist.addItem("previousTraversable1");
        resultlist.addItem("nextTraversable1");
		return resultlist;        	
	}
	
	override public function postQueryResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    }
    
    private function commonResult(mapObj:Object):void{    	
    	//XenosAlert.info("mapObj : "+mapObj.toString()); 
    	//var mapObj:Object = mkt.userQueryResultEvent(event,null);
    	var result:String = "";
    	if(mapObj!=null){   
    		//XenosAlert.info("mapObj : "+mapObj.toString());
    		if(mapObj["errorFlag"].toString() == "error") {
	    		//result = mapObj["errorMsg"] .toString();
	    		summaryResult.removeAll();
	    		errPage.showError(mapObj["errorMsg"]);
	    	} else if(mapObj["errorFlag"].toString() == "noError") {
	    		errPage.clearError(super.getSubmitQueryResultEvent());
	    	   	//errPage.removeError();
	    	  	// XenosAlert.info("I am in errPage ");
              	summaryResult.removeAll();
	    	  	// XenosAlert.info("I am in queryResult : "+currentState);
              	summaryResult=mapObj[resultlist.getItemAt(0)];
              	if(summaryResult.length == 0){               	
	    			errPage.removeError();
	    			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            	} else {
					changeCurrentState();
		    		qh.setOnResultVisibility();
		    		qh.setPrevNextVisibility((mapObj[resultlist.getItemAt(1)] == "true")?true:false,(mapObj[resultlist.getItemAt(2)] == "true")?true:false );
		    		qh.PopulateDefaultVisibleColumns();
            	}	    		
	    	}    		
    	}
    	//XenosAlert.info(result);
    }
    
	override public function preResetQuery():void{
		var rndNo:Number= Math.random();
		// remove the summary result
		summaryResult.removeAll();
		qh.setPrevNextVisibility(false, false);
		super.getResetHttpService().url = "gle/gleNavQueryDispatch.action?method=resetQuery&rnd=" + rndNo;        	
	}
	
    override public function preNext():Object{
		var reqObj : Object = new Object();
		reqObj.method = "doNext";
		reqObj.listIndex = "0";
		return reqObj;
	}
	
	override public function prePrevious():Object{
		var reqObj : Object = new Object();
		reqObj.method = "doPrevious";
		reqObj.listIndex = "0";
		return reqObj;
	}
    
    override public function preGenerateXls():String{
		var url : String = "gle/gleNavQueryDispatch.action?method=generateXLS";
		return url;
    }
    
	override public function preGeneratePdf():String{
    	var url : String = "gle/gleNavQueryDispatch.action?method=generatePDF";
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