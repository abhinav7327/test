// ActionScript file

import com.nri.rui.core.Globals;
import com.nri.rui.core.RendererFectory;
import com.nri.rui.core.controls.*;
import com.nri.rui.core.renderers.ImgSummaryRenderer;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.ref.popupImpl.AccountPopUpHbox;
import com.nri.rui.ref.popupImpl.FinInstitutePopUpHbox;
import com.nri.rui.ref.popupImpl.FundPopUpHbox;
import com.nri.rui.ref.popupImpl.InstrumentPopUpHbox;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.collections.XMLListCollection;
import mx.containers.GridItem;
import mx.containers.GridRow;
import mx.controls.DateField;
import mx.controls.Label;
import mx.controls.TextInput;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.DataGridEvent;
import mx.events.ResourceEvent;
import mx.rpc.events.ResultEvent;


[Bindable]private var rs : XML = new XML();            
[Bindable]private var compCount:int = 0; 
[Bindable]private var mendatoryCompCount : int = 0;
[Bindable]private var mendatoryField:Array = new Array();    
[Bindable]private var contextParamList:ArrayCollection = new ArrayCollection(); 
[Bindable]private var rowName:Array = new Array();
[Bindable]private var itemName:Array = new Array();
[Bindable]private var compName:Array = new Array();   
[Bindable]private var labelString:Array = new Array();
[Bindable]private var rowCount:int = 0;  
[Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
[Bindable]private var popupType : String = "";
[Bindable]private var hiddenObjects:ArrayCollection = new ArrayCollection();
[Bindable]private var keylist:ArrayCollection = new ArrayCollection();
[Bindable]private var initcol:ArrayCollection = new ArrayCollection();
[Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
[Bindable]private var queryResult:ArrayCollection= new ArrayCollection();
[Bindable]private var parameterId:Array = new Array();
[Bindable]private var paramUIType:Array = new Array();   
[Bindable]private var sortUtil: ProcessResultUtil= new ProcessResultUtil();
[Bindable]private var requestParamStr : String = "";
[Bindable]private var requestHiddenParamStr : String = "";

     private function errorHandler(event:ResourceEvent):void{
 //       xenosAlert.error("Error Occured while loading TDBalance Resource Bundle :: " + event.errorText);
    }
	  
       public function loadAll():void{
       	   super.setXenosQueryControl(new XenosQuery());
       	   this.dispatchEvent(new Event('queryInit'));
       }
       override public function preQueryResultInit():Object{
        	addCommonKeys();   	
	    	return keylist;        	
        }
       private function addCommonKeys():void{  
        	keylist = new ArrayCollection();      	
	    	keylist.addItem("sqlNameList.item");
       }
       
      override public function preQueryInit():void{
        var rndNo:Number= Math.random();
        super.getInitHttpService().url = "nam/multiPurposeRptQryDispatch.action?method=initialExecute";
        var req : Object = new Object();
        req.SCREEN_KEY = "12078";
        super.getInitHttpService().request = req;
      }
       
       override public function postQueryResultInit(mapObj:Object):void{
        	commonInit(mapObj);
      }
      
      /**
	 * Clears the previously holding data
	 */  
    public function refreshGlobalData():void{
    	
    	gridBase.removeAllChildren();
    	mendatoryCompCount = 0;
    	requestParamStr = "";
    	requestHiddenParamStr = "";
    	rowName = new Array();
    	itemName = new Array();
    	compName = new Array();
    	mendatoryField = new Array();
    	parameterId = new Array();
    	paramUIType = new Array();
    	contextParamList = new ArrayCollection();
    	rowCount = 0;        
		compCount = 0;
    	errPage.removeError();
    }
		
	/**
    * It sends/submits the query after validating the user input data. 
    */
     private function submitQuery():void 
     {  
     	var alertString:String = "";
		if (!isValidFormField(alertString)) {
			return;
		}  
         //Reset Page No
         qh.resetPageNo();          
         //Set the request parameters
         var requestObj :Object = populateRequestParams();
         multiPurposeQueryRequest.request = requestObj;  
         multiPurposeQueryRequest.send();                  
    }
	/**
    * It Reset/Send the Query Init request. 
    */
	private function resetQuery():void 
    { 
     	refreshGlobalData();
     	this.dispatchEvent(new Event('queryInit'));
    }
    /**
    * It Validate the form field values and generate alert message in case for validation fails
    */
	private function isValidFormField(alertString:String):Boolean {
		
		var valueFromUi:String = "";
		var itemCount:int = 0;
		var isBlankAllowed:Boolean = true;
		var paramStr:String = "";
		//ui validation
		if(null == this.sqlName.selectedItem || XenosStringUtils.isBlank(this.sqlName.selectedItem.value.toString())){
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('nam.multipurpose.query.msg.alert.sqlname'));
			return false;
		}
		for(var row:int = 0; row < rowCount; row++){
			var gr:Object = this.gridBase.getChildByName(rowName[row]);
			var gi:Object = gr.getChildByName(itemName[itemCount]);
			var ti:Object = gi.getChildByName(compName[itemCount]);
			if(XenosStringUtils.equals(compName[itemCount],"account"+itemCount)){
				valueFromUi = ti.accountNo.text;
			}else if(XenosStringUtils.equals(compName[itemCount],"finInst"+itemCount)){
				valueFromUi = ti.finInstCode.text;
			}else if(XenosStringUtils.equals(compName[itemCount],"inst"+itemCount)){
				valueFromUi = ti.instrumentId.text;
			}else if(XenosStringUtils.equals(compName[itemCount],"currency"+itemCount)){
				valueFromUi = ti.ccyText.text;
			}else if(XenosStringUtils.equals(compName[itemCount],"fund"+itemCount)){
				valueFromUi = ti.fundCode.text;
			}else if(XenosStringUtils.equals(compName[itemCount],"date"+itemCount)&& !XenosStringUtils.isBlank(ti.text)){				
				if(DateUtils.isValidDate(ti.text)){					
					valueFromUi = ti.text;
				}else{
					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('nam.error.illegal.date'));
					return false;
				}
			}else{	
				valueFromUi = ti.text;
			}
			
			//ui validation
			if(XenosStringUtils.equals(mendatoryField[itemCount],"false") && XenosStringUtils.isBlank(valueFromUi)){
				alertString = alertString.concat(labelString[itemCount] + " is missing\n");						
				isBlankAllowed = false;
			}
			else
			{
				paramStr = paramStr.concat(labelString[itemCount] + "," + parameterId[itemCount] + "," + valueFromUi + "," + paramUIType[itemCount]+"\n");
			}

			itemCount++;
			if(itemCount < compCount){
				gi = gr.getChildByName(itemName[itemCount]);
				ti = gi.getChildByName(compName[itemCount]);
				if(XenosStringUtils.equals(compName[itemCount],"account"+itemCount)){
					valueFromUi = ti.accountNo.text;
				}else if(XenosStringUtils.equals(compName[itemCount],"finInst"+itemCount)){
					valueFromUi = ti.finInstCode.text;
				}else if(XenosStringUtils.equals(compName[itemCount],"inst"+itemCount)){
					valueFromUi = ti.instrumentId.text;
				}else if(XenosStringUtils.equals(compName[itemCount],"currency"+itemCount)){
					valueFromUi = ti.ccyText.text;
				}else if(XenosStringUtils.equals(compName[itemCount],"fund"+itemCount)){
					valueFromUi = ti.fundCode.text;
				}else if(XenosStringUtils.equals(compName[itemCount],"date"+itemCount)&& !XenosStringUtils.isBlank(ti.text)){
					if(DateUtils.isValidDate(ti.text)){
						valueFromUi = ti.text;
					}else{
						XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('nam.error.illegal.date'));
						return false;
					}
				}else{	
					valueFromUi = ti.text;
				}
				
				//ui validation
				if(XenosStringUtils.equals(mendatoryField[itemCount],"false") && XenosStringUtils.isBlank(valueFromUi)){
					alertString = alertString.concat(labelString[itemCount] + " is missing\n");
					isBlankAllowed = false;
				}
				else
				{
					paramStr = paramStr.concat(labelString[itemCount] + "," + parameterId[itemCount] + "," + valueFromUi + "," + paramUIType[itemCount] + "\n");
				}
				//prepair request param string
				itemCount++;
			}
		}	
		if(!XenosStringUtils.isBlank(alertString)){
			XenosAlert.info(alertString);
		}
		requestParamStr = paramStr;
		
		return isBlankAllowed;
	}
	/** 
	 * Click event on sqlName On Change Method. Prepare UI Components dynamically Based on Selected SQL Name
	 */
	private function sqlNameOnChangeMethod():void {
		// if sql name is not equal to empty then we can send the request to get the 
		//parameter fields otherwise reset the gridbase
		refreshGlobalData();
		if(this.sqlName.selectedItem != null && sqlName.selectedItem.value != " ")
		{
			var reqObj : Object = new Object();
			reqObj.sqlPk = this.sqlName.selectedItem != null ?  this.sqlName.selectedItem.value : "";
     		reqObj.sqlName = this.sqlName.selectedItem != null ?  this.sqlName.selectedItem.label : "";
	   		DynamicExecution.request = reqObj;		
			DynamicExecution.send();
		}
		else
		{
			gridBase.removeAllChildren();
		}
	}  
	       
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	var reqObj : Object = new Object();
     	reqObj.method = "submitQuery";
     	reqObj.sqlPk = this.sqlName.selectedItem != null ?  this.sqlName.selectedItem.value : "";
     	reqObj.sqlName = this.sqlName.selectedItem != null ?  this.sqlName.selectedItem.label : "";
     	reqObj.parameterValueStrForRUI = requestParamStr;
     	reqObj.hiddenParamList = requestHiddenParamStr;
    	return reqObj;
    }	    
    /**
    * Result Event for Submit Query and Load the summary page records
    */ 
    private function LoadSummaryPage(event:ResultEvent):void{
       	queryResult = new ArrayCollection();
	
	       	if(event != null){
	       		if(event.result != null){
	       			var rs:XML = XML(event.result);
	       			var fieldAlignColl : ArrayCollection = new ArrayCollection();
	       				//data grid field column aligment
	       			if(rs.child("dataColAlignList").length()>0)
	       			{
	       				var dataColAlignXML:XML = XML(rs.dataColAlignList);
	       				var dataColAlignXMLList:XMLList = dataColAlignXML.child("dataColAlignList");
	       				var dataColAlignColl : XMLListCollection = new XMLListCollection(dataColAlignXMLList);
	       				for each (var dataType : Object in dataColAlignColl)
	       				{
	       					fieldAlignColl.addItem(dataType.toString());
	       				}
	       			}
			            //translate data format xml to hashmap
			        if(rs.child("Errors").length()>0) {	    
			    		var errorInfoList : ArrayCollection = new ArrayCollection();
			    		//populate the error info list 			 	
			    		for each ( var error:XML in rs.Errors.error ) {
			    			errorInfoList.addItem(error.toString());
			    		} 
			    		trace("Result set has errors...");
			    		errPage.showError(errorInfoList);//Display the error
			    	}
	       			else if(rs.child("resultViewList").length()>0) {
	       				var rsltView:XML = XML(rs.resultViewList);
	       				if(rsltView.child("item").length()>0){
	       					var resultArrayCollection:ArrayCollection = new ArrayCollection();
	       					var dataGridColumnList:Array = new Array();
	       					var xx:XMLList = rsltView.child("item");
	       					var c : XMLListCollection = new XMLListCollection(xx);
	       					var headerNames:ArrayCollection = new ArrayCollection();
						 	for each (var item : Object in c){
						 		//row
						 		var yy:XMLList = item.entry as XMLList;
						 		var c1 : XMLListCollection = new XMLListCollection(yy);
						 		var obj:Object = new Object();
						 		for each (var entr : Object in c1){
						 			//column
						 			var key : String = entr.@key ;
								    var value : String = entr.value ;
								    obj[key] = 	value;
								    if(!headerNames.contains(key)){
								    	headerNames.addItem(key);
								    }
						 		}
						 		queryResult.addItem(obj);
						 	}
                   					  				
                   			var viewDataGridColumn:DataGridColumn = new DataGridColumn("");		 
           			 		viewDataGridColumn.sortable = false;
       			 			viewDataGridColumn.width = 40;
       			 			viewDataGridColumn.draggable = false;
       			 			viewDataGridColumn.resizable = false;
       			 			viewDataGridColumn.itemRenderer=new RendererFectory(ImgSummaryRenderer);
       			 			dataGridColumnList.push(viewDataGridColumn);
						 	var count : int = 0;
						 	for each (var itm : Object in headerNames){
						 		var dataGridColumn:DataGridColumn = new DataGridColumn("");
						 		dataGridColumn.sortable = true;
						 		var tempColNameArr : Array = String(itm).toLowerCase().split("_");
						 		var colHeadName : String = "";
						 		//Alias Name formatter
						 		if(null != tempColNameArr && tempColNameArr.length > 0)
						 		{
						 			for(var i : int = 0; i < tempColNameArr.length; i++)
									{
										if(null != tempColNameArr[i].toString() && tempColNameArr[i].toString().length > 0)
										{
											colHeadName = colHeadName.concat(tempColNameArr[i].toString()
											.replace(tempColNameArr[i].toString().charAt(0), 
											tempColNameArr[i].toString().charAt(0).toLocaleUpperCase()) + " ");
										}
										else
										{
											colHeadName = colHeadName.concat(" ");
										}
									}
						 		}
						 		else
						 		{
						 			colHeadName = String(itm);
						 		}
						 		dataGridColumn.headerText = String(colHeadName);
						 		
						 		dataGridColumn.showDataTips = "true";
						 		dataGridColumn.sortCompareFunction = sortUtil.sortString;
						 		//set field alignment
						 		if(dataColAlignColl.length >= count+1)
						 		{
						 			var align :String = dataColAlignColl.getItemAt(count).toString();
						 			dataGridColumn.setStyle("textAlign", align);
						 		}
						 		else
						 		{
						 			dataGridColumn.setStyle("textAlign", "left");
						 		}
								dataGridColumn.dataField = String(itm);
								
								dataGridColumnList.push(dataGridColumn);
								count++;
						 	}
						 	
							dynaQueryResult.columns = dataGridColumnList;
						 	dynaQueryResult.dataProvider = queryResult;
						 	changeCurrentState();
						 	
						 	qh.setOnResultVisibility();
						 	
						 	qh.setPrevNextVisibility((rs.child("previousTraversable") == "true")?true:false,(rs.child("nextTraversable") == "true")?true:false );
                            qh.PopulateDefaultVisibleColumns();
                          	errPage.removeError();
	       				}else{
	       					errPage.removeError();
			    			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	       				}
	       			}else{
	       				errPage.removeError();
			    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	       			}
	       		}else{
		       		errPage.removeError();
			    	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		       	}
	       	}else{
	       		errPage.removeError();
		    	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	       	}
       	
       }
       // This method is used to hide the PDF Report download Image.
		private function hidePDFReport():void
		{
			this.qh.pdf.visible = false;
		}
		// Result event for Query Init method and load the page init values.
        private function commonInit(mapObj:Object):void{
        	gridBase.removeAllChildren();
        	var selIndx:int = 0;
        	var i:int = 0;
        	var tempColl: ArrayCollection = new ArrayCollection();
        	//clears the errors if any
	        errPage.clearError(super.getInitResultEvent());
	        app.submitButtonInstance = submit;
	    	/* Populating SQL Name drop down*/
	    	initcol = new ArrayCollection();
		    initcol.addItem({label:" ", value: " "});
		    if(mapObj[keylist.getItemAt(0)]!=null){
	            if(mapObj[keylist.getItemAt(0)] is ArrayCollection){
		            for each(var item : Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
		                initcol.addItem(item);
		            }
		        }else{
		            initcol.addItem(mapObj[keylist.getItemAt(0)]);
		        }
	        }
	    	if(initcol.length <= 1)
	    	{
	    		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('nam.multipurpose.query.msg.alert.nosql'));
	    	}
	    	this.sqlName.dataProvider = initcol;
	    	/* End of Populating SQL Name drop down */
        }
         override public function preResetQuery():void{
         		
		  		super.getResetHttpService().url = "nam/multiPurposeRptQryDispatch.action?method=reset";        	
        }
        
         override public function preGenerateXls():String{
        	 var url : String = "nam/multiPurposeRptQryDispatch.action?method=generateXLS";	
		     return url;
         }  
        
    private function doNextPage():void{
	  var reqObj : Object = new Object();
        reqObj.method = "doNext";
        reqObj.rnd = Math.random()+"";
        multiPurposeQueryRequest.request = reqObj;
        multiPurposeQueryRequest.send();
     }
     
	private function doPrevPage():void{
		var reqObj : Object = new Object();
        reqObj.method = "doPrevious";
        reqObj.rnd = Math.random()+"";
        multiPurposeQueryRequest.request = reqObj;
        multiPurposeQueryRequest.send();
        
      }	
         
	private function dispatchPrintEvent():void{
		this.dispatchEvent(new Event("print"));
	}  

	private function dispatchXlsEvent():void{
		this.dispatchEvent(new Event("xls"));
	}   
	  
	  ////////////////////////////////////////////////////////////////////////////
	      override public function postQueryResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    }
	 
	 /**
    * This method works as the result handler of the Submit Query Http Services.
    * This also takes care of the buttons/images to be shown on the top panel of the
    * result.
    */
     private function commonResult(mapObj:Object):void{
    	var result:String = "";
    	if(mapObj!=null){
    		if(mapObj["errorFlag"].toString() == "error"){
	    		queryResult.removeAll();
	    		errPage.showError(mapObj["errorMsg"]);
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    	   errPage.clearError(super.getSubmitQueryResultEvent());
	           queryResult.removeAll();
	           queryResult=mapObj["row"];
			   changeCurrentState();
		       qh.setOnResultVisibility();
		       qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
		       qh.PopulateDefaultVisibleColumns();
		       
	    	}else{
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.datanotfound'));
	    	}
    	} 
    }
	/**
    *  datagrid header release event handler to handle datagridcolumn sorting
    */
    public function dataGrid_headerRelease(evt:DataGridEvent):void {                
        var dg:CustomDataGrid = CustomDataGrid(evt.currentTarget);
        sortUtil.clickedColumn = dg.columns[evt.columnIndex];       
    }

  /**
	* This method works as the result handler of the Submit Query Http Services.
	* This also takes care of the buttons/images to be shown on the top panel of the
	* result .
	*/
	  private function generateUIResultPage(event:ResultEvent):void {
	  	var rs:XML = XML(event.result);
		trace("Event in generate UI Result Page :" + event);
        if (null != event && (rs.child("parameterEmpty") == "false" || rs.child("parameterEmpty").length() <= 0)) {
	    	if(rs.child("Errors").length()>0) {	    		
	    		var errorInfoList : ArrayCollection = new ArrayCollection();
	    		//populate the error info list 			 	
	    		for each ( var error:XML in rs.Errors.error ) {
	    			errorInfoList.addItem(error.toString());
	    		} 
	    		trace("Result set has errors...");
	    		errPage.showError(errorInfoList);//Display the error

	    	} else { 
	    		try {
	    			errPage.removeError();
					trace("Generating Dynamic UI...");
					gridBase.removeAllChildren();
					showUIConfigItems(rs);
					if(null != gridBase && gridBase.getChildren().length > 0)
					{
						var rows:GridRow = GridRow(this.gridBase.getChildren()[0]); 
						var rowColumn:GridItem = GridItem(rows.getChildren()[1]);
						var uitypeFirst:String = null;
						for each ( var rec:XML in rs.uIconfigListForRUI.UIconfigListForRUI) {
							uitypeFirst = rec.UIType;
							if(XenosStringUtils.isBlank(uitypeFirst) != true){
								for each (var rectemp:Object in rec.optionLblValueList.item){
									 setContextParamList(rectemp.label, rectemp.value , uitypeFirst);
								}
							}
							break;
						}
						if(XenosStringUtils.equals(uitypeFirst,"TEXT")||XenosStringUtils.equals(uitypeFirst,"TEXTBOX")){
							var textBox:TextInput = TextInput(rowColumn.getChildren()[0]);
				            textBox.setFocus();
				            
						}
						else if(XenosStringUtils.equals(uitypeFirst,"POPUP")){
							if(XenosStringUtils.equals(popupType,"account")){			
								var accountPopUpHbox:AccountPopUpHbox = AccountPopUpHbox(rowColumn.getChildren()[0]);
								accountPopUpHbox.accountNo.setFocus();
							}else if(XenosStringUtils.equals(popupType,"finInst")){
							   	var finInstitutePopUpHbox:FinInstitutePopUpHbox = FinInstitutePopUpHbox(rowColumn.getChildren()[0]);
								finInstitutePopUpHbox.finInstCode.setFocus();
							}else if(XenosStringUtils.equals(popupType,"inst")){
								var instrumentPopUpHbox:InstrumentPopUpHbox = InstrumentPopUpHbox(rowColumn.getChildren()[0]);
								instrumentPopUpHbox.instrumentId.setFocus();
							}else if(XenosStringUtils.equals(popupType,"currency")){
								var currenyHbox:CurrencyHBox = CurrencyHBox(rowColumn.getChildren()[0]);
								currenyHbox.ccyText.setFocus();	
							}else if(XenosStringUtils.equals(popupType,"fund")){
								var popUPBox:FundPopUpHbox = FundPopUpHbox(rowColumn.getChildren()[0]);
								popUPBox.fundCode.setFocus();
							}
						}
						else if(XenosStringUtils.equals(uitypeFirst,"DATE")){
							var dateField:DateField = DateField(rowColumn.getChildren()[0]);
							focusManager.setFocus(dateField);
							focusManager.showFocus();
							//dateField.setFocus();
						}
					}
	    		} catch (e:Error) {
	    			trace("Error occurred while generating UI...");
	    			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.reportui.msg.error', new Array(e)));
	    		}
	        } 
	        
        } else {
        	if(rs.child("parameterEmpty") == "false")
        	{
        		trace("Event is null");
	        	XenosAlert.info("Error occurred while generating UI...");			 	
			 	errPage.removeError(); //clears the errors if any        	
        	}
	    }	  	
	  	
	  }

		/**
		 * Shows the Dynamic UI components for Report parameters to run the report 
		 * from UI.It parses the label value list containing all information about 
		 * the UI components and data providers.
		 * @param rs The Result Coming from Server.
		 */
		private function showUIConfigItems(rs: XML):void {
    	var componentCount:int=0;
    	var i:int=0;
    	if (rs != null) {
    		if(rs.child("uIconfigListForRUI").length()>0) {
    			try {
    				var gridRow:GridRow = new GridRow();
    				gridRow.name = "gridrow"+rowCount;
    				rowName[rowCount] = gridRow.name;
    				gridRow.percentWidth = 100;
    				this.hiddenObjects.removeAll();
    				for each ( var rec:XML in rs.uIconfigListForRUI.UIconfigListForRUI) {
    					gridRow.percentWidth = 100;
    					var uitype:String = rec.UIType;
    					var labelKey:String = rec.labelKey;
    					var defaultValue:String = "";
    					var caseOfText:String = "";
    					var blankRequiredFlag:String="true";
    					trace("Label Key : " + labelKey)
						if(XenosStringUtils.isBlank(uitype) != true){							
							//use to coloring the mandatory field
							var isOptional:String = rec.isOptional;
							if(XenosStringUtils.equals(rec.optionLblValueList.item.label,"isRequired")){
								if(XenosStringUtils.equals(rec.optionLblValueList.item.value,"true")){
									isOptional = "false";
								}
							}		
							//create context param list
							for each ( var rec1:Object in rec.optionLblValueList.item){
								var lableStr:String = rec1.label;
								var valueStr:String = rec1.value;
								if(XenosStringUtils.equals(lableStr,"parameterId")){
									//use to prepair requestParamStr
									if(XenosStringUtils.equals(uitype, "HIDDEN"))
									{
										requestHiddenParamStr = requestHiddenParamStr.concat(valueStr + "\n");
									}
									else
									{
										parameterId[compCount] = valueStr;
									}
								}
								else if(XenosStringUtils.equals(lableStr,"defaultValue"))
								{			
										defaultValue = valueStr;										
								}
								else
								{
									setContextParamList(lableStr, valueStr , uitype);
								}
							}
		    				
		    				//add the items into rows & not include for ui type
		    				if(DynamicDisplayOfData(gridRow, labelKey, uitype,caseOfText, isOptional,defaultValue) == false){
								componentCount--;
		    				}
							i++;
							componentCount++;
							//add two components in a single row
							if(componentCount == 2){
								
								componentCount = 0;
								gridBase.addChild(gridRow);
								rowCount++;
								gridRow = new GridRow();
								gridRow.percentWidth = 100;
								gridRow.name = "gridrow"+rowCount;
								rowName[rowCount] = gridRow.name;
							}		
						}
    				}
    				//in case of odd number of components add the single one
    				if(componentCount == 1){
    					gridBase.addChild(gridRow);
    					rowCount++;
						// adding a blank grid item
						var gridItem:GridItem = new GridItem();
						gridItem.percentWidth = 20;
						gridItem.horizontalScrollPolicy = "off";
						gridItem.styleName="LabelBgColor";
						gridRow.addChild(gridItem);
						
						gridItem = new GridItem();
						gridItem.percentWidth = 30;
						gridItem.horizontalScrollPolicy = "off";
						gridRow.addChild(gridItem);
						    					
    					gridRow = new GridRow();
    					gridRow.percentWidth = 100;
    					gridRow.name = "gridrow"+rowCount;
						rowName[rowCount] = gridRow.name;
    				}

    				gridRow = new GridRow();
    				gridRow.percentWidth = 100;
    			}catch(e:Error){
    				trace("Error generating UI components...")
    				trace("Error Message : " + e.message)
    				trace("Error ID : " + e.errorID)
    				trace("Error Name : " + e.name)
    				trace("Stack Trace : " + e.getStackTrace())
    				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('nam.error.generateui'));
    			}
    		}
    	}
    }    	
    
    //prepair context param for the popup
    /**
     * Setting context param list
     * @param label  The label
     * @param value	 The Value of the context set
     * @param uitype The UI componenet type 
     * 
     */
    private function setContextParamList(label:String, value:String, uitype:String):void{
  
    	var acTypeArray:Array = new Array(1);
    	if(!XenosStringUtils.equals(label,"type")){
    		acTypeArray[0]=value; 
    		contextParamList.addItem(new HiddenObject(label,acTypeArray));
    	}
    	if(XenosStringUtils.equals(label,"type")&&XenosStringUtils.equals(uitype,"POPUP")){
    		popupType = value;
    	}
    }

  /**
     * Dynamic Display of data prepared with the type of UI components.
     * @param gridRow      grid row
     * @param labelKey 	   Label
     * @param uitype	   type of UI(date,textbox ..)
     * @param isOptional   Whether the value is required or Optional to validate
     * @return 			   Whether any values are added or not
     * 
     */
    public function DynamicDisplayOfData(gridRow:GridRow, 
    									labelKey:String, 
    									uitype:String, 
    									caseOfText:String, 
    									isOptional:String,
    									defaultValue:String
    									):Boolean {
		
		var flag:Boolean = false;
		var maxMinFlag:Boolean = false;
		var gridItem:GridItem = new GridItem();
		var label:Label = new Label();
		if(XenosStringUtils.equals(uitype, "HIDDEN"))
		{
			return false;
		}
		label.text = labelKey;
		//use for alert message
		labelString[compCount] = labelKey;
		mendatoryField[compCount] = "true";

		if(XenosStringUtils.equals(isOptional,"false")){
			mendatoryCompCount++;
			
			//assign red color for mandatory fields
			label.styleName = "ReqdLabel";
			
			//use for validation
			mendatoryField[compCount] = "false";
		} else {
			label.styleName = "FormLabelHeading";
		}
		if (!XenosStringUtils.equals(uitype,"Hidden")) {
			gridItem.percentWidth = 20;
			gridItem.horizontalScrollPolicy = "off";
			gridItem.styleName="LabelBgColor";
			gridItem.addChild(label);
			gridRow.addChild(gridItem);	
		}
		
		if(XenosStringUtils.equals(uitype,"TEXT")||XenosStringUtils.equals(uitype,"TEXTBOX")){	
			gridItem = new GridItem();
			gridItem.percentWidth = 30;	
			gridItem.horizontalScrollPolicy = "off";
			
			gridItem.name = "gridItem"+compCount;
			itemName[compCount] = gridItem.name;						
			
			paramUIType[compCount] = "";
											
			var textInput:TextInput = new TextInput();
			textInput.width = 100;
			textInput.condenseWhite = true;
			
			//add name
			textInput.name = "text"+compCount;   
			compName[compCount] = textInput.name;        
			compCount++;
			
			if(!XenosStringUtils.equals(defaultValue,"")) {
				textInput.text = defaultValue;
			}
			
			if(!XenosStringUtils.equals(caseOfText,"")) {
				if(XenosStringUtils.equals(caseOfText,"true")) {
					textInput.restrict = Globals.INPUT_PATTERN;
				}
			}
			
			gridItem.addChild(textInput);            
			gridRow.addChild(gridItem);
			flag = true; 
			
			if(!XenosStringUtils.equals(defaultValue,"")) {
				textInput.text = defaultValue;
			}
		}
		if(XenosStringUtils.equals(uitype,"POPUP")){
			gridItem = new GridItem();
			gridItem.percentWidth = 30;	
			gridItem.horizontalScrollPolicy = "off";	
			gridItem.name = "gridItem"+compCount;
			itemName[compCount] = gridItem.name;						
			paramUIType[compCount] = popupType;
			
			if(XenosStringUtils.equals(popupType,"account")){			
				var accountPopUpHbox:AccountPopUpHbox = new AccountPopUpHbox();
				
				//add name
				accountPopUpHbox.name = "account"+compCount;
				compName[compCount] = accountPopUpHbox.name;        
				compCount++;
				
				//add context param
				accountPopUpHbox.retContextItem = returnContextItem;
				accountPopUpHbox.recContextItem = getContextParamList();
				
				gridItem.addChild(accountPopUpHbox);
				
				if(!XenosStringUtils.equals(defaultValue,"")) {
					accountPopUpHbox.accountNo.text = defaultValue;
				}
				
			}else if(XenosStringUtils.equals(popupType,"finInst")){
				var finInstitutePopUpHbox:FinInstitutePopUpHbox = new FinInstitutePopUpHbox();
				
				//add name
				finInstitutePopUpHbox.name = "finInst"+compCount;
				compName[compCount] = finInstitutePopUpHbox.name;        
				compCount++;
				
				//add context param
				finInstitutePopUpHbox.retContextItem = returnContextItem;
				finInstitutePopUpHbox.recContextItem = getContextParamList();
    			finInstitutePopUpHbox.percentWidth = 50;
    	
				gridItem.addChild(finInstitutePopUpHbox);
				
				if(!XenosStringUtils.equals(defaultValue,"")) {
					finInstitutePopUpHbox.finInstCode.text = defaultValue;
				}
				
			}else if(XenosStringUtils.equals(popupType,"inst")){
				var instrumentPopUpHbox:InstrumentPopUpHbox = new InstrumentPopUpHbox();
				
				//add name
				instrumentPopUpHbox.name = "inst"+compCount;
				compName[compCount] = instrumentPopUpHbox.name;        
				compCount++;
				
				//add context param
				instrumentPopUpHbox.retContextItem = returnContextItem;
				instrumentPopUpHbox.recContextItem = getContextParamList();
				
				gridItem.addChild(instrumentPopUpHbox);
				
				if(!XenosStringUtils.equals(defaultValue,"")) {
					instrumentPopUpHbox.instrumentId.text = defaultValue;
				}
					
			}else if(XenosStringUtils.equals(popupType,"currency")){
				var currenyHbox:CurrencyHBox = new CurrencyHBox();
				
				//add name
				currenyHbox.name = "currency"+compCount;
				compName[compCount] = currenyHbox.name;        
				compCount++;
				gridItem.addChild(currenyHbox);			
				
				if(!XenosStringUtils.equals(defaultValue,"")) {
					currenyHbox.ccyText.text = defaultValue;
				}
					
			}else if(XenosStringUtils.equals(popupType,"fund")){
				//changed by ssa
				var fundPopupHbox:FundPopUpHbox = new FundPopUpHbox();
				
				//add name
				fundPopupHbox.name = "fund"+compCount;
				compName[compCount] = fundPopupHbox.name;        
				compCount++;
				gridItem.addChild(fundPopupHbox);				
				
				if(!XenosStringUtils.equals(defaultValue,"")) {
					fundPopupHbox.fundCode.text = defaultValue;
				}
			}	
			
			popupType = "";	            
			gridRow.addChild(gridItem);
			flag = true;			
					
		}
		if(XenosStringUtils.equals(uitype,"DATE")){
			gridItem = new GridItem();
			gridItem.percentWidth = 30;		
			gridItem.horizontalScrollPolicy = "off";	
			gridItem.name = "gridItem"+compCount;
			itemName[compCount] = gridItem.name;							
			paramUIType[compCount] = "";
								
			var dateField:DateField = new DateField();		 
			dateField.formatString = "YYYYMMDD";
			dateField.editable = true;  
			dateField.name = "date"+compCount;
			dateField.width = 100;
			compName[compCount] = dateField.name;        
			compCount++;			                 
			
			gridItem.addChild(dateField);				           							            
			gridRow.addChild(gridItem);
			flag = true;

			if(!XenosStringUtils.equals(defaultValue,"")) {
				dateField.text = defaultValue;
			}
		}
    	return flag;

    }

//add the context param list at popup
	/**
	 * Getter of Context param list
	 * @return 
	 * 
	 */
	private function getContextParamList():ArrayCollection {
	      return contextParamList;
	}    

	/**
	 * Calculates the index of an item, within a given 
	 * array collection.
	 * Returns 0 if the value is null or empty string.
	 */
	private function getIndex(collection:ArrayCollection, value:String):int {
		var index:int = 0;
		if (value == null || value == XenosStringUtils.EMPTY_STR) {
			return index;
		}
		for (var count:int = 0; count < collection.length; count++) {
			if (String(collection.getItemAt(count)) == value) {
				index = count;
				break;
			}
		}
		return index;
	}       