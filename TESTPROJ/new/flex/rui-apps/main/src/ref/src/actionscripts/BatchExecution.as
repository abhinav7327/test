// ActionScript file
import com.nri.rui.core.controls.CurrencyHBox;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.ref.popupImpl.AccountPopUpHbox;
import com.nri.rui.ref.popupImpl.FinInstitutePopUpHbox;
import com.nri.rui.ref.popupImpl.FundPopUpHbox;
import com.nri.rui.ref.popupImpl.InstrumentPopUpHbox;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.containers.GridItem;
import mx.containers.GridRow;
import mx.controls.CheckBox;
import mx.controls.ComboBox;
import mx.controls.DateField;
import mx.controls.Label;
import mx.controls.TextInput;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;		
	 
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     [Bindable]
   	 private var queryResult:ArrayCollection= new ArrayCollection();
     
     private var keylist:ArrayCollection = new ArrayCollection(); 
     
     [Bindable]private var mode : String = "QUERY";
     
     [Bindable]
     private var batchIdList:ArrayCollection = null;

     [Bindable]
     private var lmImList:ArrayCollection = null;     
     
     [Bindable]
     private var serverErrorMessage : String = "";
     
     [Bindable]
     private var minHeapSize : String = "";
     
     [Bindable]
     private var maxHeapSize : String = "";        
     
     [Bindable]
     private var finalFullCommand : String = "";
     
     [Bindable]
     private var refNo : String = "";
	
     [Bindable]
     private var popupType : String = "";	
		 
	 [Bindable]
     private var headerLabel : String = "Batch Status Query  Entry - ";
     
     [Bindable]
     private var requestParamString : String = "";
     
     [Bindable]
     private var selectedBatchId : String = "";
     
     [Bindable]
     private var mendatoryCompCount : int = 0;    
	 
     [Bindable]
     private var rowCount:int = 0;
    
     [Bindable]
     private var compCount:int = 0;
    
     [Bindable]	
     private var itemWidthLabel:int = 190;
    
     [Bindable]
     private var labelString:Array = new Array();
    
     [Bindable]
     private var mendatoryField:Array = new Array();    
    
     [Bindable]
     private var shortOption:Array = new Array();
    
     [Bindable]
     private var contextParamList:ArrayCollection = new ArrayCollection(); 
    
	 [Bindable]
	 public var returnContextItem:ArrayCollection = new ArrayCollection();
    
     [Bindable]
     private var rowName:Array = new Array();
    
     [Bindable]
     private var itemName:Array = new Array();
    
     [Bindable]
     private var compName:Array = new Array();
     			         	  
	  private function changeCurrentState():void{
				currentState = "result";
	 }
			 
     public function loadAll():void{
        parseUrlString();
        super.setXenosQueryControl(new XenosQuery());           	   
        if(this.mode == 'QUERY'){
          	this.dispatchEvent(new Event('queryInit'));
        }
        batchId.setFocus();
        app.submitButtonInstance = proceed;  
     }
     
     /**
     * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
     * 
     */ 
     public function parseUrlString():void {
        try {
            // Remove everything before the question mark, including the question mark.
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
                mode = "QUERY";
            }                 

        } catch (e:Error) {
            trace(e);
        }               
     }
     
	 override public function preQueryInit():void{  
         var rnd:Number=Math.random();
		 super.getInitHttpService().url = "ref/batchUIDispatch.action?method=initialExecute&rnd="+rnd;        	
     }      
     
     override public function preQueryResultInit():Object{        	
         addCommonKeys();
	     return keylist;        	
     }
     
     private function addCommonKeys():void{  
         keylist = new ArrayCollection();      	
	     keylist.addItem("batchIdList.item");	
	     keylist.addItem("lmImList.item");   
     }

     override public function postQueryResultInit(mapObj:Object):void{
        commonInit(mapObj);
     }        

	/**
	 * Populate data on load screen
	 */ 
     private function commonInit(mapObj:Object):void{        	    	
	     batchIdList=new ArrayCollection();
	     batchIdList.addItem({label: " " , value : " "});
	     for each(var objActionTaken:Object in mapObj["batchIdList.item"] as ArrayCollection){
	        batchIdList.addItem(objActionTaken);
	     }
	     batchIdList.refresh();     
	     
	     lmImList=new ArrayCollection();
	     for each(var objActionTakenLmIm:Object in mapObj["lmImList.item"] as ArrayCollection){
	        lmImList.addItem(objActionTakenLmIm);
	     }
	     lmImList.refresh();   
	             	
    	 errPage.clearError(super.getInitResultEvent());
     }
     
     /**
     *  Corresponding to proceed button
     */    
     public function onProceed():void{
     	if(XenosStringUtils.isBlank(this.batchId.selectedItem.value)){
	 		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.batch.execution.msg.info.missing.batchid'));
	 	}else{
	 		var reqObj : Object = new Object();
	 		var rnd:Number=Math.random();       
         	proceedBatchExecutionHttpService.url = "ref/batchUIDispatch.action?method=populateBatchOffice&rnd=" + rnd;
         	reqObj.batchId = this.batchId.selectedItem != null ? StringUtil.trim(this.batchId.selectedItem.value) : XenosStringUtils.EMPTY_STR;                    
         	proceedBatchExecutionHttpService.request = reqObj;
         	proceedBatchExecutionHttpService.send();
         	
         	showProceedResult();		 			 	   
	 	}	 	
     }
     
     /**
     * on proceed click shows the result 
     */ 
     public function showProceedResult():void{
 		docStatus21.visible = true;
 		docStatus22.visible = true;
 		docStatus1.visible = false;    	
    }
    
    /**
    * call on reset button click
    */ 
    public function resetToInitialScreen():void{
    	this.batchId.selectedIndex = 0;
    	ws1.includeInLayout = true;
    	docStatus21.visible = false;
 		docStatus22.visible = false;
 		docStatus1.visible = true; 
 		errorMessage.visible = false;
 		errorMessage.includeInLayout = false;
 		batchId.setFocus();
 		app.submitButtonInstance = proceed;
    } 
    
    private function proceedResultHandler(event: ResultEvent) : void {
      	var tempArray:ArrayCollection = new ArrayCollection();
		if(event.result.batchCommandActionForm.officeList != null){
			if(event.result.batchCommandActionForm.officeList.item != null) {
				if(event.result.batchCommandActionForm.officeList.item is ArrayCollection)
					tempArray = event.result.batchCommandActionForm.officeList.item as ArrayCollection;                 
				else
					tempArray.addItem(event.result.batchCommandActionForm.officeList.item);
			}
		} else {
			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.batch.execution.msg.error.populate.officeid'));
		}
		this.officeId.dataProvider = tempArray;
		
		var index:int = 0;
		var LmIm:String;
		
		if (XenosStringUtils.equals(this.batchId.selectedItem.value, 'CTM_CONF_DWNLD_BATCH')
		 || XenosStringUtils.equals(this.batchId.selectedItem.value, 'DRVAUTOCLOSEOUT_BT')
		 ||XenosStringUtils.equals(this.batchId.selectedItem.value,'NDFCLOSETRANSNETTING')
		 ||XenosStringUtils.equals(this.batchId.selectedItem.value,'BWRTMTCH_BATCH')
		 ||XenosStringUtils.equals(this.batchId.selectedItem.value,'BRRTREFNOMTCH_BATCH')) {
			LmIm = 'im';
		}
        	    		     
		for each(var itemRpt:Object in (lmImList as ArrayCollection)){
			if(itemRpt.value == LmIm){
				index = (lmImList as ArrayCollection).getItemIndex(itemRpt);			    					    				
		  	}
		}
	    
	    this.lmImId.selectedIndex = index; 
	    officeId.setFocus();
		app.submitButtonInstance = submit;	
     }   
    
    /**
    * call on change batch id list
    */ 
    public function documentStatusOnChange(event:Event):void{
		hideProceedResult()
    }
    
    /**
    * make hide/visible required fields
    */ 
    public function hideProceedResult():void{
    	docStatus1.visible = true;  
     	docStatus21.visible = false;
     	docStatus22.visible = false;  	
    }
    
    /**
    * on submit generate dynamic ui
    */ 
    public function preQuery1():void{
    	selectedBatchId = this.batchId.selectedItem.value;
    	if(XenosStringUtils.isBlank(selectedBatchId)){
	 		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.batch.execution.msg.info.missing.batchid'));
	 	}else if((XenosStringUtils.equals(selectedBatchId,"BWRTMTCH_BATCH") || XenosStringUtils.equals(selectedBatchId,"BRRTREFNOMTCH_BATCH"))
	 	         && XenosStringUtils.equals(this.lmImId.selectedItem.value,"lm")){
	 		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.batch.execution.error.invalid.lmim.param', new Array(this.batchId.selectedItem.label)));
	 	}else{
	 		var reqObj : Object = new Object();
	 		reqObj.SCREEN_KEY = 11117;
	 		var rnd:Number=Math.random();       
         	proceedBatchExecutionHttpService2.url = "ref/batchUIDispatch.action?method=generateUI&rnd=" + rnd;
         	reqObj.batchId = this.batchId.selectedItem != null ? StringUtil.trim(this.batchId.selectedItem.value) : XenosStringUtils.EMPTY_STR;
         	reqObj.office = this.officeId.selectedItem != null ? StringUtil.trim(this.officeId.selectedItem.value) : XenosStringUtils.EMPTY_STR;
         	reqObj.lmImFlag = this.lmImId.selectedItem != null ? StringUtil.trim(this.lmImId.selectedItem.value) : XenosStringUtils.EMPTY_STR;                    
         	proceedBatchExecutionHttpService2.request = reqObj;
         	proceedBatchExecutionHttpService2.send();         	
	 		//resultOnSubmit();
	 	}	 	 	
	 }
    
     public function resultOnSubmit():void{
     	ws2.visible = true;
     	ws2.includeInLayout = true;
     	
     	ws1.visible = false;
     	ws1.includeInLayout = false;
     	errorMessage.visible = false;
     	errorMessage.includeInLayout = false;
     	idForOfficeId.setFocus();
     	app.submitButtonInstance = submit1;
	 }  

   /**
    * Retrieve information/data for dynamic UI from config/server side
    */   
    private function submit1ResultHandler(event: ResultEvent) : void {
    	itemWidthLabel = setTheItemWidth("itemWidthLabel");
    	var rs:XML = XML(event.result);
    	var componentCount:int=0;
    	var i:int=0;
    	if (null != event) {
    		if(rs.child("uIconfigListForRUI").length()>0) {
    			resultOnSubmit();
    			try {
    				var gridRow:GridRow = new GridRow();
    				gridRow.percentWidth = 100;
    				gridRow.name = "gridrow"+rowCount;

    				rowName[rowCount] = gridRow.name;
    				for each ( var rec:XML in rs.uIconfigListForRUI.UIconfigListForRUI) {
    					if(!((XenosStringUtils.equals(rec.labelKey,"userId")) && ((XenosStringUtils.equals(this.selectedBatchId,"DRVAUTOCLOSEOUT_BT"))
    					|| (XenosStringUtils.equals(this.selectedBatchId,"BWRTMTCH_BATCH")) 
    					|| (XenosStringUtils.equals(this.selectedBatchId,"BRRTREFNOMTCH_BATCH"))))){
    				
    					var uitype:String = rec.UIType;
    					var labelKey:String = rec.labelKey;
    					var dropDownData:ArrayCollection = new ArrayCollection();    
						var dropdownItem:Array = new Array();
						if(XenosStringUtils.isBlank(uitype) != true){							
							
							//use to prepair requestParamString
							shortOption[compCount] = rec.shortOption;
							
							//use to coloring the mandatory field
							var isOptional:String = rec.isOptional;
							//XenosStringUtils.equals(isOptional,"true") &&
							/////////////////////////////////////////////// 
							
							if(XenosStringUtils.equals(this.selectedBatchId,"ICONFeedFileGen") && XenosStringUtils.equals(uitype,"Date")){
								isOptional = "true";
							}
							
							var defaultValue:String = "";
							var blankRequiredFlag:String="true";
							///////////////////////////////////////////////
							
							//create context param list
							for each ( var rec1:Object in rec.optionLblValueList.item){								
								
								if(XenosStringUtils.equals(rec1.label,"defaultValue")){
									defaultValue = rec1.value;
								}
								if(XenosStringUtils.equals(rec1.label,"isBlankRequired")){											
										blankRequiredFlag = rec1.value;												
								}
								if(XenosStringUtils.equals(rec1.label,"values")) {
										var valuesStr:String = rec1.value;																				
										dropdownItem = valuesStr.split(",");
				
									}
								if(XenosStringUtils.equals(rec1.label,"isRequired")){
									if(XenosStringUtils.equals(rec1.value,"true")){
										isOptional = "false";
									}
								}else if(XenosStringUtils.equals(rec1.label,"constraint") && (XenosStringUtils.equals(this.selectedBatchId,"OGConverter"))){
									if(XenosStringUtils.equals(rec1.value,"TRADE_TYPE")||XenosStringUtils.equals(rec1.value,"BALANCE_BY_AC_BALANCE_TYPE")){
										isOptional = "true";
									}
								}
								
								setContextParamList(rec1.label, rec1.value,uitype);
							}							
							//create the dropDown list if exist
							if(XenosStringUtils.equals(uitype,"DropDown")){
								if(XenosStringUtils.equals(blankRequiredFlag,"true"))																
									dropDownData.addItem({label:" ", value:" "});						
								if(dropdownItem.length >0){
									for each(var dropdownObj:Object in dropdownItem) {				
										dropDownData.addItem({label:dropdownObj, value:dropdownObj});
									}
								} 								
				
								if(rec.constraintListRUI != null) {
									for each(var xmlObj1:Object in rec.constraintListRUI.item){
										dropDownData.addItem(xmlObj1);
									}									
								}
				
								if(rec.dataProviderListRUI != null) {
									for each(var xmlObj2:Object in rec.dataProviderListRUI.item){
										dropDownData.addItem(xmlObj2);
									}									
								}								
										
							}
							
							//is the inputed value uppercase
							var isUpperCase:Boolean = false;
							if(XenosStringUtils.equals(rec.optionLblValueList.item.label,"isUpper") && XenosStringUtils.equals(rec.optionLblValueList.item.value,"true")){
								isUpperCase = true;
							}
							if(XenosStringUtils.equals(this.selectedBatchId,"BORROW_RETURN_BATCH")){
								if(XenosStringUtils.equals(labelKey,"Base Date")){
								 if(rs.child("slrBaseDateStr").length()>0){
									defaultValue=rs.child("slrBaseDateStr").toString();
									} 
								}
								if(XenosStringUtils.equals(labelKey,"Value Date")){
								 if(rs.child("slrValueDateStr").length()>0){
									defaultValue=rs.child("slrValueDateStr").toString();
									} 
								}
							}
							//add the items into rows & not include for ui type Hidden
							if(addRowWithItem(gridRow, labelKey, uitype, dropDownData, isOptional, isUpperCase, defaultValue) == false){
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
    			}
    				//in case of odd number of components add the single one
    				if(componentCount == 1){
    					gridBase.addChild(gridRow);
    					rowCount++;
    					gridRow = new GridRow();
    					gridRow.percentWidth = 100;
    					gridRow.name = "gridrow"+rowCount;
						rowName[rowCount] = gridRow.name;
    				}
    				
    				//use to add min/max heap size if exist.
    				var maxHeapSize : String = rs.maxHeapSizeString.toString();
    				var minHeapSize : String = rs.minHeapSizeString.toString();
    				if(XenosStringUtils.isBlank(maxHeapSize) != true || XenosStringUtils.isBlank(minHeapSize) != true){
    					//var gridRow:GridRow = new GridRow();
    					var gridItem:GridItem = new GridItem();
    					//gridItem.width = itemWidthLabel;
    					gridItem.percentWidth = 20;
    					var label:Label = new Label();
    					label.text = "Min Heap Size";   			
    					gridItem.addChild(label);
						gridRow.addChild(gridItem);
						
    					label = new Label();
    					label.text = minHeapSize;
    					gridItem = new GridItem();
    					//gridItem.width = itemWidthLabel;
    					gridItem.percentWidth = 30;	
    					gridItem.addChild(label);
						gridRow.addChild(gridItem);
						
    					label = new Label();
    					label.text = "Max Heap Size";
    					gridItem = new GridItem();
    					//gridItem.width = itemWidthLabel;
    					gridItem.percentWidth = 20;	
    					gridItem.addChild(label);
    					gridRow.addChild(gridItem);
    					
    					label = new Label();
    					label.text = maxHeapSize;
    					gridItem = new GridItem();
    					//gridItem.width = itemWidthLabel;
    					gridItem.percentWidth = 20;
    					gridItem.addChild(label);
    					gridRow.addChild(gridItem);
    					
    					gridBase.addChild(gridRow);
    				}
    				gridRow = new GridRow();
    				gridRow.percentWidth = 100;
    			}catch(e:Error){
    				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
    			}
    		}else if(rs.child("Errors").length()>0) {
    			//in case of launcher are not running
				this.serverErrorMessage = "*" + rs.Errors.error;
				errorMessage.visible = true;
				errorMessage.includeInLayout = true;
    		}
    	}
    }
    
    /**
    * Prepair dynamic UI based on information from config/server side
    */    
    public function addRowWithItem(gridRow:GridRow, labelKey:String, uitype:String, dropDownData:ArrayCollection, isOptional:String, isUpperCase:Boolean, defaultVal:String):Boolean{
		var flag:Boolean = false;
		var gridItem:GridItem = new GridItem();
		//gridItem.width = itemWidthLabel;
		gridItem.percentWidth = 20;
		gridItem.horizontalScrollPolicy = "off";
		gridItem.styleName="LabelBgColor";
		var label:Label = new Label();
		label.text = labelKey;
		
		//label.condenseWhite = true;
		gridItem.addChild(label);
		
		
				
		if(uitype!=null && !XenosStringUtils.equals(XenosStringUtils.capitalize(uitype),"Hidden")){
			gridRow.addChild(gridItem);
			gridItem = new GridItem();
			//gridItem.width = itemWidthLabel;
			gridItem.percentWidth = 30;
			gridItem.horizontalScrollPolicy = "off";
			
			gridItem.name = "gridItem"+compCount;
			itemName[compCount] = gridItem.name;
			
			
			//use for alert message
			labelString[compCount] = labelKey;
			
			//use for validation
			mendatoryField[compCount] = "true";
		}
		
		
		if(XenosStringUtils.equals(isOptional,"false")){
			mendatoryCompCount++;
			
			//assign red color for mandatory fields
			label.setStyle("color", 0x842D22);
			
			//use for validation
			mendatoryField[compCount] = "false";
		}
	
		if(XenosStringUtils.equals(uitype,"Text")||XenosStringUtils.equals(uitype,"TextBox")){						
			var textInput:TextInput = new TextInput();
			textInput.width = 100;
			textInput.condenseWhite = true;
			if(defaultVal != '')
				textInput.text = defaultVal;
			//use for uppercase
			//if(XenosStringUtils.equals(labelKey,"Sender Reference No")){
			if(isUpperCase){	
				textInput.restrict = Globals.INPUT_PATTERN;
			}
			
			//add name
			textInput.name = "text"+compCount;   
			compName[compCount] = textInput.name;        
			compCount++;
			
			gridItem.addChild(textInput);            
			gridRow.addChild(gridItem);
			flag = true; 
		}else if(XenosStringUtils.equals(uitype,"Popup")){
			if(XenosStringUtils.equals(popupType,"account")){popupType
				var accountPopUpHbox:AccountPopUpHbox = new AccountPopUpHbox();
				if(defaultVal != '')
					accountPopUpHbox.accountNo.text = defaultVal;
				//add name
				accountPopUpHbox.name = "account"+compCount;
				compName[compCount] = accountPopUpHbox.name;        
				compCount++;
				
				//add context param
				accountPopUpHbox.retContextItem = returnContextItem;
				accountPopUpHbox.recContextItem = getContextParamList();
				
				gridItem.addChild(accountPopUpHbox);
			}else if(XenosStringUtils.equals(popupType,"finInst")){
				var finInstitutePopUpHbox:FinInstitutePopUpHbox = new FinInstitutePopUpHbox();
				if(defaultVal != '')
					finInstitutePopUpHbox.finInstCode.text = defaultVal;
				//add name
				finInstitutePopUpHbox.name = "finInst"+compCount;
				compName[compCount] = finInstitutePopUpHbox.name;        
				compCount++;
				
				//add context param
				finInstitutePopUpHbox.retContextItem = returnContextItem;
				finInstitutePopUpHbox.recContextItem = getContextParamList();
    			finInstitutePopUpHbox.percentWidth = 50;
    	
				gridItem.addChild(finInstitutePopUpHbox);
			}else if(XenosStringUtils.equals(popupType,"inst")){
				var instrumentPopUpHbox:InstrumentPopUpHbox = new InstrumentPopUpHbox();
				if(defaultVal != '')
					instrumentPopUpHbox.instrumentId.text = defaultVal;
				//add name
				instrumentPopUpHbox.name = "inst"+compCount;
				compName[compCount] = instrumentPopUpHbox.name;        
				compCount++;
				
				//add context param
				instrumentPopUpHbox.retContextItem = returnContextItem;
				instrumentPopUpHbox.recContextItem = getContextParamList();
				
				gridItem.addChild(instrumentPopUpHbox);				
			}else if(XenosStringUtils.equals(popupType,"currency")){
				var currenyHbox:CurrencyHBox = new CurrencyHBox();
				if(defaultVal != '')
					currenyHbox.ccyText.text = defaultVal;
				//add name
				currenyHbox.name = "currency"+compCount;
				compName[compCount] = currenyHbox.name;        
				compCount++;
				
				gridItem.addChild(currenyHbox);				
			}else if(XenosStringUtils.equals(popupType,"fund")){
				var fundPopupHbox:FundPopUpHbox = new FundPopUpHbox();
				if(defaultVal != '')
					fundPopupHbox.fundCode.text = defaultVal;
				//add name
				fundPopupHbox.name = "fund"+compCount;
				compName[compCount] = fundPopupHbox.name;        
				compCount++;
				
				gridItem.addChild(fundPopupHbox);				
			}
			
			popupType = "";	            
			gridRow.addChild(gridItem);
			flag = true;			
		}
		if(XenosStringUtils.equals(uitype,"Date")){
			var dateField:DateField = new DateField();		 
			dateField.formatString = "YYYYMMDD";
			dateField.editable = true;
			if(defaultVal != '')
				dateField.text = defaultVal;
			//add name     
			dateField.name = "date"+compCount;
			compName[compCount] = dateField.name;        
			compCount++;
			                 
			gridItem.addChild(dateField);				           
							            
			gridRow.addChild(gridItem);
			flag = true;
	
		}
		if(XenosStringUtils.equals(uitype,"DropDown")){
			var comboBox:ComboBox = new ComboBox(); 
			if(XenosStringUtils.equals(labelKey,"Instrument Type")){
				var treeCombo:TreeCombo = new TreeCombo();
				treeCombo.dataSource = new XML((app.cachedItems.instrumentTree).toString());
				treeCombo.editMode = true;
				treeCombo.displayClearIcon = true;
				treeCombo.labelField = "label";
				treeCombo.treeHeight = 200;
				treeCombo.x = 10;
				treeCombo.y = 10;
				
				//add name
				treeCombo.name = "treeCombo"+compCount;
				compName[compCount] = treeCombo.name;        
			    compCount++;

				gridItem.addChild(treeCombo); 
			} else if(XenosStringUtils.equals(labelKey,"Market")){
				var marketCombo:TreeCombo = new TreeCombo();
				marketCombo.dataSource = new XML((app.cachedItems.marketTree).toString());
				marketCombo.editMode = true;
				marketCombo.displayClearIcon = true;
				marketCombo.labelField = "label";
				marketCombo.treeHeight = 200;
				marketCombo.x = 10;
				marketCombo.y = 10;
				
				//add name
				marketCombo.name = "marketCombo"+compCount;
				compName[compCount] = marketCombo.name;        
			    compCount++;

				gridItem.addChild(marketCombo);			
			}else{
				comboBox.labelField = "label";	
				//find the index of defaultValue in the Collection				
				comboBox.selectedIndex=getIndex(dropDownData,defaultVal);
				//add name
				comboBox.name = "combo"+compCount;
				compName[compCount] = comboBox.name;        
			    compCount++;
					
				comboBox.dataProvider = dropDownData;											
				gridItem.addChild(comboBox);  
			}	            
			gridRow.addChild(gridItem);
			flag = true;
		}
		if(XenosStringUtils.equals(uitype,"CheckBox")){
			var checkBox:CheckBox = new CheckBox();
			
			//add name
			checkBox.name = "check"+compCount;
			compName[compCount] = checkBox.name;        
			compCount++;
			if(defaultVal != ''){
				if(defaultVal == "Y")
					checkBox.selected = true;
				else
					checkBox.selected = false;
			}		                     
			gridItem.addChild(checkBox);				           
							            
			gridRow.addChild(gridItem);
			flag = true;
		}
		if(XenosStringUtils.equals(uitype,"Hidden")){

		}
		
    	return flag;
    }

    
    /**
    * Add blank value at begining
    */ 
    public function addBlankAtBegining(dropDownData:ArrayCollection):ArrayCollection{
    	var tempColl:ArrayCollection = new ArrayCollection();             
        tempColl.addItem({label:" ", value: " "});
        for(var i:int = 0; i<dropDownData.length; i++) {                    
        	tempColl.addItem(dropDownData[i]);
        }
        return tempColl;  
    }
    
    /**
    * prepair context param for the popup item
    */ 
    private function setContextParamList(label:String, value:String, uitype:String):void{
    	var acTypeArray:Array = new Array(1);
    	if(!XenosStringUtils.equals(label,"type")){
    		acTypeArray[0]=value; 
    		contextParamList.addItem(new HiddenObject(label,acTypeArray));
    	}
    	if(XenosStringUtils.equals(label,"type")&&XenosStringUtils.equals(uitype,"Popup")){
    		popupType = value;
    	}
    }
    
    /**
    * include the context param list at popup item
    */ 
	private function getContextParamList():ArrayCollection {
	      return contextParamList;
	}    
	
	/**
	 * Back to Batch Execution Selection Screen
	 */  
    public function backToPrevious():void{
    	refreshGlobalData(); 
    	ws1.visible = true;  	
		ws1.includeInLayout = true;
		ws2.visible = false;
		ws2.includeInLayout = false;
		ws3.visible = false;
		ws3.includeInLayout = false;
		success.visible = false;
     	success.includeInLayout = false;		
     	docStatus5.visible = false;
     	docStatus5.includeInLayout = false;     	
     	docStatus6.visible = false;
     	docStatus6.includeInLayout = false;
     	officeId.setFocus();
     	app.submitButtonInstance = submit;
	 }
	
	/**
	 * Clears the previously holding data
	 */  
    public function refreshGlobalData():void{
    	gridBase.removeAllChildren();
    	mendatoryCompCount = 0;
    	
    	rowName = new Array();
    	itemName = new Array();
    	compName = new Array();
    	mendatoryField = new Array();
    	contextParamList = new ArrayCollection();
    	rowCount = 0;        
		compCount = 0;
		requestParamString = "";
		finalFullCommand = "";
		refNo = "";
		selectedBatchId = "";
		serverErrorMessage = "";
    } 
    
    /**
    * On Submit for Generate Command
    */ 
 	public function onSubmitGenerateCommand():void{
	    var batchIdStr:String = this.batchId.selectedItem.value;
		var alertString:String = new String();
		finalFullCommand = "";
		requestParamString = "";
		var reqObj:Object = new Object();
		reqObj.SCREEN_KEY = 11118;
		//hit the server if pass validation
		if(prepairRequestParamString(alertString)){
			reqObj.optionValueStrForRUI = requestParamString; 
			var rnd:Number=Math.random();  
			proceedBatchExecutionHttpService3.url = "ref/batchUIDispatch.action?method=submitSelection&rnd=" + rnd;
			proceedBatchExecutionHttpService3.request = reqObj;
			proceedBatchExecutionHttpService3.send();
			generatedCommandScreen();
  		}
	}
    
    /**
    * Retrive data from UI, validate and prepair request param string 
    */
    private function prepairRequestParamString(alertString:String) : Boolean {
    	
    	var baseDateBRRTBatch:String = "";
    	var valueDateBRRTBatch:String = "";
    	
    	var valueFromUi:String = "";
    	var paramStr:String = "";
		var itemCount:int = 0;
		var isBlankAllowed:Boolean = true;
		for(var row:int = 0; row < rowCount; row++){
			var gr:Object = this.gridBase.getChildByName(rowName[row]);
			var gi:Object = gr.getChildByName(itemName[itemCount]);
			var ti:Object = gi.getChildByName(compName[itemCount]); 

			if(XenosStringUtils.equals(compName[itemCount],"check"+itemCount)){
				valueFromUi = ti.selected;
			}else if(XenosStringUtils.equals(compName[itemCount],"account"+itemCount)){
				valueFromUi = ti.accountNo.text;
			}else if(XenosStringUtils.equals(compName[itemCount],"finInst"+itemCount)){
				valueFromUi = ti.finInstCode.text;
			}else if(XenosStringUtils.equals(compName[itemCount],"inst"+itemCount)){
				valueFromUi = ti.instrumentId.text;
			}else if(XenosStringUtils.equals(compName[itemCount],"currency"+itemCount)){
				valueFromUi = ti.ccyText.text;
			}else if(XenosStringUtils.equals(compName[itemCount],"fund"+itemCount)){
				valueFromUi = ti.fundCode.text;
			}else if(XenosStringUtils.equals(compName[itemCount],"treeCombo"+itemCount)){
				valueFromUi = ti.itemCombo.text;
			}else if(XenosStringUtils.equals(compName[itemCount],"marketCombo"+itemCount)){
				valueFromUi = ti.itemCombo.text;
			}else if(!XenosStringUtils.isBlank(ti.text) && XenosStringUtils.equals(compName[itemCount],"combo"+itemCount)){
				valueFromUi = ti.selectedItem.value;
			}else if(!XenosStringUtils.isBlank(ti.text) && XenosStringUtils.equals(compName[itemCount],"date"+itemCount)){
					if(XenosStringUtils.equals(this.selectedBatchId,"BORROW_RETURN_BATCH") && XenosStringUtils.equals(shortOption[itemCount],"d")){
						baseDateBRRTBatch=ti.text;
					}
					if(XenosStringUtils.equals(this.selectedBatchId,"BORROW_RETURN_BATCH") && XenosStringUtils.equals(shortOption[itemCount],"v")){
						valueDateBRRTBatch=ti.text;
					}
				if(DateUtils.isValidDate(ti.text)){
					valueFromUi = ti.text;
				}else{
					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.batch.execution.msg.error.date'));
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
			
			//prepair request param string
			if(!(XenosStringUtils.equals(valueFromUi,"false") && XenosStringUtils.equals(compName[itemCount],"check"+itemCount))){
				paramStr = paramStr.concat("-" + shortOption[itemCount] + "," + valueFromUi + "\n");
			}

			itemCount++;
			if(itemCount < compCount){
				gi = gr.getChildByName(itemName[itemCount]);
				ti = gi.getChildByName(compName[itemCount]);
				if(XenosStringUtils.equals(compName[itemCount],"check"+itemCount)){
					valueFromUi = ti.selected;
				}else if(XenosStringUtils.equals(compName[itemCount],"account"+itemCount)&& !XenosStringUtils.isBlank(ti.text)){
					valueFromUi = ti.accountNo.text;
				}else if(XenosStringUtils.equals(compName[itemCount],"finInst"+itemCount)){
					valueFromUi = ti.finInstCode.text;
				}else if(XenosStringUtils.equals(compName[itemCount],"inst"+itemCount)){
					valueFromUi = ti.instrumentId.text;
				}else if(XenosStringUtils.equals(compName[itemCount],"currency"+itemCount)){
					valueFromUi = ti.ccyText.text;
				}else if(XenosStringUtils.equals(compName[itemCount],"fund"+itemCount)){
					valueFromUi = ti.fundCode.text;
				}else if(XenosStringUtils.equals(compName[itemCount],"treeCombo"+itemCount)&& !XenosStringUtils.isBlank(ti.text)){
					valueFromUi = ti.itemCombo.text;
				}else if(XenosStringUtils.equals(compName[itemCount],"marketCombo"+itemCount)){
				    valueFromUi = ti.itemCombo.text;
				}else if(!XenosStringUtils.isBlank(ti.text) && XenosStringUtils.equals(compName[itemCount],"combo"+itemCount)){
					valueFromUi = ti.selectedItem.value;
				}else if(XenosStringUtils.equals(compName[itemCount],"date"+itemCount) && !XenosStringUtils.isBlank(ti.text)){
					if(XenosStringUtils.equals(this.selectedBatchId,"BORROW_RETURN_BATCH") && XenosStringUtils.equals(shortOption[itemCount],"d")){
						baseDateBRRTBatch=ti.text;
					}
					if(XenosStringUtils.equals(this.selectedBatchId,"BORROW_RETURN_BATCH") && XenosStringUtils.equals(shortOption[itemCount],"v")){
						valueDateBRRTBatch=ti.text;
					}
					if(DateUtils.isValidDate(ti.text)){
						valueFromUi = ti.text;
					}else{
						XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.batch.execution.msg.error.date'));
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
				
				//prepair request param string
				if(!(XenosStringUtils.equals(valueFromUi,"false") && XenosStringUtils.equals(compName[itemCount],"check"+itemCount))){
					paramStr = paramStr.concat("-" + shortOption[itemCount] + "," + valueFromUi + "\n");
				}
				
				itemCount++;
			}
		}	
		
		if(!XenosStringUtils.isBlank(alertString)){
			paramStr = "";
			XenosAlert.info(alertString);
		}
		requestParamString = paramStr;
		if(XenosStringUtils.equals(this.selectedBatchId,"BORROW_RETURN_BATCH")){
			if(!XenosStringUtils.isBlank(baseDateBRRTBatch) && !XenosStringUtils.isBlank(valueDateBRRTBatch)){
				if(DateUtils.compareDates(baseDateBRRTBatch,valueDateBRRTBatch)>0){
					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.batch.execution.msg.error.TDVD'));
					throw new Error(this.parentApplication.xResourceManager.getKeyValue('ref.batch.execution.msg.error.TDVD'));
			 	}
			}
		}
		return isBlankAllowed;
    }    
    
    /**
    * Command Generator Result Handler
    */    
    private function commandGeneratorResultHandler(event:ResultEvent) : void {
    	if(event.result.batchCommandActionForm.finalFullCommand != null){
     		this.finalFullCommand = event.result.batchCommandActionForm.finalFullCommand;
     		command.setFocus();
     		app.submitButtonInstance = confirm;
     	}else{
     		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.batch.execution.msg.error.generate.command'));
     	} 
    } 
    
    /**
    * Generate command screen
    */
    public function generatedCommandScreen():void{
		ws3.visible = true;
		ws3.includeInLayout = true;
		batchCommand.visible = true;
		batchCommand.includeInLayout = true;		
		docStatus4.visible = true;
		docStatus4.includeInLayout = true;
		success.visible = false;
		success.includeInLayout = false;
		docStatus5.visible = false;
		docStatus5.includeInLayout = false;

		ws1.visible = false;
		ws1.includeInLayout = false;

		ws2.visible = false;
		ws2.includeInLayout = false;
		this.headerLabel = "Batch Status Query  Entry - User Confirmation";
    } 
    
    /**
    * Back to Batch Execution Entry Screen
    */ 
    public function backToPrevScreen():void{
		ws2.visible = true;
		ws2.includeInLayout = true;
    	refreshThePreviousData();

    	ws1.visible = false;
		ws1.includeInLayout = false;

		ws3.visible = false;
		ws3.includeInLayout = false;

		success.visible = false;
		success.includeInLayout = false;
		docStatus4.visible = false;
		docStatus4.includeInLayout = false;
     	docStatus5.visible = false;
     	docStatus5.includeInLayout = false;
     	docStatus6.visible = false;
     	docStatus6.includeInLayout = false;
     	idForOfficeId.setFocus();
     	app.submitButtonInstance = submit1;
    }
    
    /**
    * make the blank of previously set data
    */
    public function refreshThePreviousData():void{
		var itemCount:int = 0;
		for(var row:int = 0; row < rowCount; row++){
			var gr:Object = this.gridBase.getChildByName(rowName[row]);
			var gi:Object = gr.getChildByName(itemName[itemCount]);
			var ti:Object = gi.getChildByName(compName[itemCount]);
			if(XenosStringUtils.equals(compName[itemCount],"check"+itemCount)){
				ti.selected = false;
			}else if(XenosStringUtils.equals(compName[itemCount],"account"+itemCount)){
				ti.accountNo.text = XenosStringUtils.EMPTY_STR;
			}else if(XenosStringUtils.equals(compName[itemCount],"finInst"+itemCount)){
				ti.finInstCode.text = XenosStringUtils.EMPTY_STR;
			}else if(XenosStringUtils.equals(compName[itemCount],"inst"+itemCount)){
				ti.instrumentId.text = XenosStringUtils.EMPTY_STR;
			}else if(XenosStringUtils.equals(compName[itemCount],"currency"+itemCount)){
				ti.ccyText.text = XenosStringUtils.EMPTY_STR;
			}else if(XenosStringUtils.equals(compName[itemCount],"fund"+itemCount)){
				ti.fundCode.text = XenosStringUtils.EMPTY_STR;
			}else if(XenosStringUtils.equals(compName[itemCount],"treeCombo"+itemCount)){
				ti.itemCombo.text = XenosStringUtils.EMPTY_STR;
			}else if(XenosStringUtils.equals(compName[itemCount],"marketCombo"+itemCount)){
				ti.itemCombo.text = XenosStringUtils.EMPTY_STR;
			}else if(XenosStringUtils.equals(compName[itemCount],"combo"+itemCount)){
				ti.selectedItem = XenosStringUtils.EMPTY_STR;
			}else{	
				ti.text = XenosStringUtils.EMPTY_STR;
			}

			itemCount++;
			if(itemCount < compCount){
				gi = gr.getChildByName(itemName[itemCount]);
				ti = gi.getChildByName(compName[itemCount]);
				if(XenosStringUtils.equals(compName[itemCount],"check"+itemCount)){
					ti.selected = false;
				}else if(XenosStringUtils.equals(compName[itemCount],"account"+itemCount)){
					ti.accountNo.text = XenosStringUtils.EMPTY_STR;
				}else if(XenosStringUtils.equals(compName[itemCount],"finInst"+itemCount)){
					ti.finInstCode.text = XenosStringUtils.EMPTY_STR;
				}else if(XenosStringUtils.equals(compName[itemCount],"inst"+itemCount)){
					ti.instrumentId.text = XenosStringUtils.EMPTY_STR;
				}else if(XenosStringUtils.equals(compName[itemCount],"currency"+itemCount)){
					ti.ccyText.text = XenosStringUtils.EMPTY_STR;
				}else if(XenosStringUtils.equals(compName[itemCount],"fund"+itemCount)){
					ti.fundCode.text = XenosStringUtils.EMPTY_STR;
				}else if(XenosStringUtils.equals(compName[itemCount],"treeCombo"+itemCount)){
					ti.itemCombo.text = XenosStringUtils.EMPTY_STR;
				}else if(XenosStringUtils.equals(compName[itemCount],"marketCombo"+itemCount)){
				    ti.itemCombo.text = XenosStringUtils.EMPTY_STR;
				}else if(XenosStringUtils.equals(compName[itemCount],"combo"+itemCount)){
					ti.selectedItem = XenosStringUtils.EMPTY_STR;
				}else{	
					ti.text = XenosStringUtils.EMPTY_STR;
				}	
				itemCount++;
			}
		}	    	
    } 
    
    /**
    * Run the generated command.
    */ 
    public function runTheGeneratedCommandOk():void{
    	var reqObj : Object = new Object();
	 	var rnd:Number=Math.random();  
	 	if(XenosStringUtils.isBlank(finalFullCommand)){ 
	 		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.batch.execution.msg.error.generate.command'));
	 	}else{	    
	        proceedBatchExecutionHttpService4.url = "ref/batchUIDispatch.action?method=confirmSelection&rnd=" + rnd;
	        reqObj.SCREEN_KEY = 11119;
	        reqObj.office = this.officeId.text != null ? StringUtil.trim(this.officeId.text) : XenosStringUtils.EMPTY_STR;
	        reqObj.lmImFlag = this.lmImId.text != null ? StringUtil.trim(this.lmImId.text) : XenosStringUtils.EMPTY_STR;
	        proceedBatchExecutionHttpService4.request = reqObj;                
	        proceedBatchExecutionHttpService4.send();
   		} 
    }
    
    /**
    * use to adjust layout in dynamic screen
    */ 
    public function setTheItemWidth(param:String):int {
     	if(XenosStringUtils.equals(param,"itemWidthLabel")){
     		return (this.parentApplication.width)*0.19;
     	}else{
     		return (this.parentApplication.width)*0.3;
    	}
    }
         
    
    
    /**
    * Screen after run the generated command
    */ 
    private function runCommandResultHandler(event: ResultEvent) : void {
    	if(event.result.batchCommandActionForm.refNo != null){
     		this.refNo = event.result.batchCommandActionForm.refNo;
     	}
     	success.visible = true;
     	docStatus5.visible = true;
     	docStatus6.visible = true;
     	success.includeInLayout = true;
     	docStatus5.includeInLayout = true;
     	docStatus6.includeInLayout = true;
     	this.headerLabel = "Batch Status Query  Entry - System Confirmation";
     	batchCommand.visible = false;
     	batchCommand.includeInLayout = false;
     	docStatus4.visible = false;
		docStatus4.includeInLayout = false;
		idForRefNo.setFocus();
		app.submitButtonInstance = confirm1; 
    }
    
    /**
    * Return to initial(Batch Execution Selection) screen
    */ 
    public function returnToInitial():void{
		ws1.visible = true;
		ws1.includeInLayout = true;
		
		refNo = "";
		this.batchId.selectedIndex = 0;
		
		headerLabel = "";
		hideProceedResult();
		
		ws2.visible = false;
		ws2.includeInLayout = false;
		
		ws3.visible = false;    		
		ws3.includeInLayout = false;
		 batchId.setFocus();
		app.submitButtonInstance = proceed;
		refreshGlobalData();
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
 