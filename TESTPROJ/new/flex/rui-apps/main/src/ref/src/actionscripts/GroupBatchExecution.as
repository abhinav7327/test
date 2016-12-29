// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.utils.XenosStringUtils;

import mx.collections.ArrayCollection;
import mx.containers.GridItem;
import mx.containers.GridRow;
import mx.controls.CheckBox;
import mx.controls.ComboBox;
import mx.controls.DateField;
import mx.controls.Label;
import mx.controls.TextInput;
import mx.events.ListEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
	 
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     [Bindable]private var mode : String = "QUERY";

     [Bindable]
     private var serverErrorMessage : String = "";
     
     [Bindable]
     private var refNoLabel : String = "";
     
     [Bindable]
     private var officeIdLabel : String = "";
     
     [Bindable]
     private var lmImIdLabel : String = "";
     
     [Bindable]
     private var batchGroupName : String = "";
      
     [Bindable]
     private var minHeapSize : String = "";
     
     [Bindable]
     private var maxHeapSize : String = "";  
     
     [Bindable]	
     private var itemWidthLabel:int = 190;
      
     [Bindable]
     private var rowCount:int = 0;
     
     [Bindable]
     private var rowName:Array = new Array();
    
    
     [Bindable]
     private var compName:Array = new Array();
     
     [Bindable]
     private var shortOption:Array = new Array();
     
     [Bindable]
     private var compCount:int = 0;
     
     [Bindable]
     private var selectedbatchGroupId : String = "";
     
     [Bindable]
     private var contextParamList:ArrayCollection = new ArrayCollection(); 
     
     
     [Bindable]
     private var popupType : String = "";	
     
      [Bindable]
     private var itemName:Array = new Array();
     
      [Bindable]
     private var labelString:Array = new Array();
    
     [Bindable]
     private var mendatoryField:Array = new Array();    
     
     [Bindable]
	 public var returnContextItem:ArrayCollection = new ArrayCollection();
	 
	 [Bindable]
     private var mendatoryCompCount : int = 0;   
     
     [Bindable]
     private var requestParamString : String = "";
     
     [Bindable]
     private var selectedBatchId : String = "";
    
     
      [Bindable]
     private var finalFullCommand : String = "";
     
       [Bindable]
     private var refNo : String = "";
     
     [Bindable]
	private var groupBatchId : String = ""; 
	
	 [Bindable]
     private var headerLabel : String = "Batch Status Query  Entry - ";  
	
	// Please do not create this kind of object future; this is a worst case
	private var comboBoxIDNeedForMVRReport : ComboBox =null ;
	private var comboBoxIDNeedForReportPtrnCombo : ComboBox =null ;
	private var gridItemNeedForReportPtrn : GridItem =null ;
	private var gridItemNeedForReportPtrnLebel : GridItem =null ;
	private var indexForReportPtrnDefaultValue : int = 0;
    private var indexTemFinalCombo : int = 0;
    private function loadAll():void{
       var reqObj:Object = new Object();
	   reqObj.SCREEN_KEY = "12129";
       proceedBatchExecutionHttpService1.url="ref/groupBatchCommandDispatch.action?method=initialExecute";
       proceedBatchExecutionHttpService1.request = reqObj;
       proceedBatchExecutionHttpService1.send();
       this.batchGroupId.setFocus();
       app.submitButtonInstance = submit;  
     } 
    /**
    * include the context param list at popup item
    */ 
	private function getContextParamList():ArrayCollection {
	      return contextParamList;
	}    
	
     
     private function initResultHandler(event: ResultEvent):void {
		if (event != null && event.result != null ) {
			var initColl:ArrayCollection = new ArrayCollection(); 
		     
		    // Set Group Batch ID DropDown 
		    var tempColl: ArrayCollection = new ArrayCollection();
		    // Getting the Command Form Object
			var commandForm: Object=event.result.groupBatchCommandActionForm
			if(commandForm.batchGroupIdList.item != null) {
				if(commandForm.batchGroupIdList.item is ArrayCollection) {
					initColl = commandForm.batchGroupIdList.item as ArrayCollection;
				} else {
						initColl.addItem(commandForm.batchGroupIdList.item);
				}
			} 
			          
			tempColl = new ArrayCollection();
			tempColl.addItem({label:XenosStringUtils.EMPTY_STR, value: XenosStringUtils.EMPTY_STR});        
			var i:int = 0;
			for(i = 0; i<initColl.length; i++) {
			      tempColl.addItem(initColl[i]);
			}
			batchGroupId.dataProvider = tempColl;   
			       
			// Set Office Id Drop Down        
	       initColl = new ArrayCollection(); 
	       if(commandForm.officeIdList.item != null) {
			    if(commandForm.officeIdList.item is ArrayCollection) {
				    initColl = commandForm.officeIdList.item as ArrayCollection;
			    } else {
					initColl.addItem(commandForm.officeIdList.item);
			    }
	   	   } 
		           
		           
          tempColl = new ArrayCollection();
       	  tempColl.addItem({label:XenosStringUtils.EMPTY_STR, value: XenosStringUtils.EMPTY_STR});
        
              
	      for(i = 0; i<initColl.length; i++) {
	            tempColl.addItem(initColl[i]);
	      }
	      officeId.dataProvider = tempColl; 
			      
			 // Set LM IM Flag Drop Down
			 
		  initColl = new ArrayCollection(); 
	       if(commandForm.lmImList.item != null) {
			    if(commandForm.lmImList.item is ArrayCollection) {
				    initColl = commandForm.lmImList.item as ArrayCollection;
			    } else {
					initColl.addItem(commandForm.lmImList.item);
			    }
	   	   } 
		           
		           
          tempColl = new ArrayCollection();        
            
            
           var selIndx:int = 0;    
         
	      for(i = 0; i<initColl.length; i++) {
	            tempColl.addItem(initColl[i]);
	             if(XenosStringUtils.equals((initColl[i].value),"lm")){                    
	                    selIndx = i;
	              }
	      }
	      lmImId.dataProvider = tempColl;  
	      lmImId.selectedIndex = selIndx;
			      
		 }else{
		     	
		 }
     }
     

     private function doSubmit():void{
     	if(XenosStringUtils.isBlank(this.batchGroupId.selectedItem.value)){
	 		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.batch.execution.msg.info.missing.grbatchid'));
     	}else if(XenosStringUtils.isBlank(this.officeId.selectedItem.value)){
     		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.batch.execution.msg.info.missing.grofficeid'));
     	}else{
     	 proceedBatchExecutionHttpService2.url = "ref/groupBatchCommandDispatch.action?method=generateUI";
     	var reqObj : Object = new Object();
     	reqObj.SCREEN_KEY = "12130";
     	reqObj.officeId = this.officeId.selectedItem != null?this.officeId.selectedItem.value :XenosStringUtils.EMPTY_STR; 
     	reqObj.batchGroupId = this.batchGroupId.selectedItem != null?this.batchGroupId.selectedItem.value :XenosStringUtils.EMPTY_STR; 
     	reqObj.lmImFlag = this.lmImId.selectedItem !=null?this.lmImId.selectedItem.value :XenosStringUtils.EMPTY_STR;
        proceedBatchExecutionHttpService2.request = reqObj;
        proceedBatchExecutionHttpService2.send();
      }
     }
     
      public function resultOnSubmit():void{
      	vbox1.visible = false;
      	vbox1.includeInLayout = false; 
      	vstack.selectedChild = vbox2;
     	vbox2.visible = true;
      	vbox2.includeInLayout = true;
	 }  
 
	 private function confirmResultHandler(event: ResultEvent) : void {
    	errPage1.removeError();
    	var errorInfoList : ArrayCollection = new ArrayCollection();
    	 if (event != null) {
	 		 	var rs:XML = XML(event.result);
	 		 	
	 		 	if(rs.child("Errors").length()>0) {
    			//in case of launcher are not running
				 for each ( var error:XML in rs.Errors.error ) {
	                  errorInfoList.addItem(error.toString());
	                  trace(error.toString());                
                  }
                    errPage1.showError(errorInfoList);
	 		 	
		 		 }else{
		 		 	this.batchGroupName = rs.child("batchGroupId");
		 		 	this.officeIdLabel = rs.child("officeId");
		 		 	this.lmImIdLabel = rs.child("lmImFlagLbl");	
		 		 	dynamicGrid.removeAllChildren();  	
		 		 if(rs.child("uIconfigListForRUI").length()>0) {
                  try {
                  	    var i : int  = 1 ;
                  	    var gridRow:GridRow = new GridRow();
                        gridRow.percentWidth = 100;
                          
                           
                        for  each ( var rec:XML in rs.optionalLabelValueList.item)  {
                        	var labelKey:String = rec.label;
                        	var labelValue:String = rec.value;
                        	var labelName:String = XenosStringUtils.EMPTY_STR;
                        	
                        	for each (var rec1:XML in rs.uIconfigListForRUI.UIconfigListForRUI){
                        		var shortOption:String = rec1.shortOption;
                        		if(XenosStringUtils.equals(shortOption,labelKey)){
                        			
                        			labelName = rec1.labelKey;
                        			
	                                break;
                        		}
                        	}
                			var gridItem1:GridItem = new GridItem();
                			gridItem1.percentWidth = 20;
                            gridItem1.horizontalScrollPolicy = "off";
                            gridItem1.styleName="LabelBgColor";  
                            var label:Label = new Label();
                            label.text = labelName;
                            gridItem1.addChild(label);
                            gridRow.addChild(gridItem1);
                            var value:Label = new Label();
                            
                            value.text = labelValue;
                            value.selectable="true";
                            var gridItem2:GridItem = new GridItem();
                			gridItem2.percentWidth = 30;
                            gridItem2.horizontalScrollPolicy = "off";
                            gridItem2.addChild(value);                         
                             gridRow.addChild(gridItem2);
                               
                            if (i%2 == 0 || i == (rs.optionalLabelValueList.item as XMLList).length()) {
                            	dynamicGrid.addChild(gridRow);
                            	gridRow = new GridRow();
                            	gridRow.percentWidth = 100;
                            }
                            
                            i++;
                        	
                        }    
                        
          	
		 		 } catch(e:Error){
                        XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                  }	 	
		 	 }
		 			generatedCommandScreen();
    		}
    	}
  }
    	
    	
	
     /**
    * Retrieve information/data for dynamic UI from config/server side
    */   
   private function submitResultHandler(event: ResultEvent) : void {
      itemWidthLabel = setTheItemWidth("itemWidthLabel");
      var rs:XML = XML(event.result);
      var componentCount:int=0;
      var i:int=0;
      errPage.removeError(); 
      if (null != event) {
            if(rs.child("uIconfigListForRUI").length()>0) {
                  resultOnSubmit();
                  try {
                        var gridRow:GridRow = new GridRow();
                        gridRow.percentWidth = 100;
                        gridRow.name = "gridrow"+rowCount;

                        rowName[rowCount] = gridRow.name;
                        for each ( var rec:XML in rs.uIconfigListForRUI.UIconfigListForRUI) {
                        
                              var uitype:String = rec.UIType;
                              var labelKey:String = rec.labelKey;
                              var dropDownData:ArrayCollection = new ArrayCollection();
                              
                                    if(XenosStringUtils.isBlank(uitype) != true){
                                          //create the dropDown list if exist
                                          if(XenosStringUtils.equals(uitype,"DropDown")){
                                                var dropdownItem:Array = new Array();
                                                for each(var xmlObj:Object in rec.optionLblValueList.item) {      
                                                      var optLabel:String = xmlObj.label;                                                                 
                                                      if(XenosStringUtils.equals(optLabel,"values")) {
                                                            var valuesStr:String = xmlObj.value;                                                                                                                       
                                                            dropdownItem = valuesStr.split(",");
                                                      }
                                                }                                               
                                                dropDownData.addItem("");                                   
                                                if(dropdownItem.length >0){
                                                      for each(var dropdownObj:Object in dropdownItem) {                     
                                                            dropDownData.addItem(dropdownObj);
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
                                          
                                          //use to prepair requestParamString
                                          shortOption[compCount] = rec.shortOption;
                                          
                                          //use to coloring the mandatory field
                                          var isOptional:String = rec.isOptional;
                                          /////////////////////////////////////////////// 
                                          var defaultValue:String = "";
                                          ///////////////////////////////////////////////
                                          
                                          //create context param list
                                          for each ( var rec1:Object in rec.optionLblValueList.item){
                                                
                                                //XenosAlert.info("Is Optional :: "+ rec1);
                                                if(XenosStringUtils.equals(rec1.label,"defaultValue")){
                                                      defaultValue = rec1.value;
                                                }
                                                
                                                if(XenosStringUtils.equals(rec1.label,"isRequired")){
                                                      if(XenosStringUtils.equals(rec1.value,"false")){
                                                            isOptional = "true";
                                                      }
                                                }
                                                
                                                setContextParamList(rec1.label, rec1.value,uitype);
                                          }
                                          
                                          //is the inputed value uppercase
                                          var isUpperCase:Boolean = false;
                                          if(XenosStringUtils.equals(rec.optionLblValueList.item.label,"isUpper") && XenosStringUtils.equals(rec.optionLblValueList.item.value,"true")){
                                                isUpperCase = true;
                                          }
                                          var comboBoxId : ComboBox = null ;
                                          //add the items into rows & not include for ui type Hidden
                                          if(!addRowWithItem(gridRow, labelKey, uitype, dropDownData, isOptional, isUpperCase, defaultValue )){
                                                componentCount--;
                                          }     
                                          if(XenosStringUtils.equals(this.batchGroupId.selectedItem.value, "MVR_REQUEST_PROCESS")) {
                                                if(XenosStringUtils.equals(labelKey , "Temporary/Final")) {
                                                      comboBoxIDNeedForMVRReport.addEventListener(ListEvent.CHANGE , handleMVRDropDown);
                                                }
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
                        
                        if(XenosStringUtils.equals(this.batchGroupId.selectedItem.value, "MVR_REQUEST_PROCESS")) {
                                          if(comboBoxIDNeedForMVRReport != null 
                                             && gridItemNeedForReportPtrn != null 
                                             && gridItemNeedForReportPtrnLebel != null) {                                                     
                                                handleMVRDropDown();
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
                              var gridItem:GridItem = new GridItem();
                              gridItem.percentWidth = 20;
                              var label:Label = new Label();
                              label.text = "Min Heap Size";                   
                              gridItem.addChild(label);
                                    gridRow.addChild(gridItem);
                                    
                              label = new Label();
                              label.text = minHeapSize;
                              gridItem = new GridItem();
                              gridItem.percentWidth = 30;   
                              gridItem.addChild(label);
                                    gridRow.addChild(gridItem);
                                    
                              label = new Label();
                              label.text = "Max Heap Size";
                              gridItem = new GridItem();
                              gridItem.percentWidth = 20;   
                              gridItem.addChild(label);
                              gridRow.addChild(gridItem);
                              
                              label = new Label();
                              label.text = maxHeapSize;
                              gridItem = new GridItem();
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
                  var errorInfoList : ArrayCollection = new ArrayCollection();
                   for each ( var error:XML in rs.Errors.error ) {
                             errorInfoList.addItem(error.toString());               
                             trace(error.toString());                
                            }
                  errPage.showError(errorInfoList);
            }
      }
      
      this.batchGrIdUserConf.setFocus();
      app.submitButtonInstance = submitUsrConf;
     }

     
    /**
    * use to Handel the Report Pattern Drop Down List.
    * If change "Temporary/Final" pull down from "Temporary" to "Final, then "Report Pattern" entry label and pull down is hidden and initialize to "1:ALL".
    * If change "Temporary/Final" pull down from "Final" to "Temporary" then "Report Pattern" label and pull down is shown and initialize to "1:A,B....". 
    */
     private function handleMVRDropDown(event:ListEvent = null):void {
     	if(XenosStringUtils.equals(this.comboBoxIDNeedForMVRReport.selectedItem.value, "Y")) {
     		gridItemNeedForReportPtrnLebel.visible = false;
     		gridItemNeedForReportPtrn.visible = false;
     		//Initialize "Report Pattern" drop down list to "1:ALL" when "Temporary/Final" = Final.
     		comboBoxIDNeedForReportPtrnCombo.selectedIndex = indexTemFinalCombo;
     	} else {
     		gridItemNeedForReportPtrnLebel.visible = true;
     		gridItemNeedForReportPtrn.visible = true;
     		//Initialize "Report Pattern" drop down list to "1:A,B,C,D,E,F,G,J" when "Temporary/Final" = Temporary.
     		comboBoxIDNeedForReportPtrnCombo.selectedIndex = indexForReportPtrnDefaultValue;
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
    * Prepair dynamic UI based on information from config/server side
    */    
    public function addRowWithItem(gridRow:GridRow, labelKey:String, uitype:String, 
    							  dropDownData:ArrayCollection, isOptional:String, isUpperCase:Boolean, 
    							  defaultVal:String ):Boolean{
		var flag:Boolean = false;
		var gridItem:GridItem = new GridItem();
		gridItem.percentWidth = 20;
		gridItem.horizontalScrollPolicy = "off";
		gridItem.styleName="LabelBgColor";
		var label:Label = new Label();
		label.text = labelKey;
		
		gridItem.addChild(label);
		if(XenosStringUtils.equals(this.batchGroupId.selectedItem.value, "MVR_REQUEST_PROCESS")) {
		if(XenosStringUtils.equals(labelKey , "Report Pattern")) {
				gridItemNeedForReportPtrnLebel = gridItem;
				//labelFieldStr = comboBox.labelField;
			}
		}
					
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
			}else{
				comboBox.labelField = "label";	
				//add name
				comboBox.name = "combo"+compCount;
				compName[compCount] = comboBox.name;        
			    compCount++;
					
				comboBox.dataProvider = dropDownData;	
				comboBox.selectedIndex = getIndex(dropDownData,defaultVal);	
				indexTemFinalCombo = getIndex(dropDownData,'14:ALL')				
				
				if(XenosStringUtils.equals(this.batchGroupId.selectedItem.value, "MVR_REQUEST_PROCESS")) {
					if(XenosStringUtils.equals(labelKey , "Temporary/Final")) {
						comboBoxIDNeedForMVRReport = comboBox;
					} else if(XenosStringUtils.equals(labelKey , "Report Pattern")) {
						comboBoxIDNeedForReportPtrnCombo = comboBox;
						indexForReportPtrnDefaultValue = comboBox.selectedIndex;
					}
				}
				
				gridItem.addChild(comboBox); 
				if(XenosStringUtils.equals(this.batchGroupId.selectedItem.value, "MVR_REQUEST_PROCESS")) {
				    if(XenosStringUtils.equals(labelKey , "Report Pattern")) {
						gridItemNeedForReportPtrn = gridItem;
						
					}
				}
				
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
    	return flag;
    }
    
    public function backToPrevious():void{
    	errPage1.removeError();
	    vstack.selectedChild = vbox1;
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
		groupBatchId = "";
		this.batchGroupId.setFocus();
		app.submitButtonInstance = submit;
    }
    
     /**
    * Back to Batch Execution Entry Screen
    */ 
    public function backToPrevScreen():void{
    	errPage2.removeError();
    	vstack.selectedChild = vbox2; 
		app.submitButtonInstance = submitUsrConf;
    }
     /**
    * On Submit for Generate Command
    */ 
 	public function onSubmitGenerateCommand():void{	
		var alertString:String = new String();
		finalFullCommand = "";
		requestParamString = "";
		var reqObj:Object = new Object();
		reqObj.SCREEN_KEY = "12131";
		//hit the server if pass validation
			if(prepairRequestParamString(alertString, reqObj)){
				reqObj.optionValueStrForRUI = requestParamString; 
				//XenosAlert.info("Request String : "+ requestParamString);
				var rnd:Number=Math.random(); 
				userConfirmationService.url="ref/groupBatchCommandDispatch.action?method=userConfirmation";
				userConfirmationService.request = reqObj;
				userConfirmationService.send();	
			}
		}
		
		
		/**
    * Generate command screen
    */
    public function generatedCommandScreen():void{
      	vbox1.visible = false;
      	vbox1.includeInLayout = false; 
      	vstack.selectedChild = vbox3;
     	vbox3.visible = true;
      	vbox3.includeInLayout = true;
      	
		success.visible = false;
		success.includeInLayout = false;
      
        
		groupBatchGrIdUserConf.visible = true;
		groupBatchGrIdUserConf.includeInLayout = true;
		officeGrIdUserConf.visible = true;
		officeGrIdUserConf.includeInLayout = true;	
		this.headerLabel = this.parentApplication.xResourceManager.getKeyValue('ref.onlinebatch.execution.userConfirmation');
    } 
		
		
		 /**
    * Run the generated command.
    */ 
    public function runTheGeneratedCommandOk():void{
    	  userConfirmButton.enabled=false;
    	  backButton.enabled=false;
		    var reqObj:Object = new Object();
		    reqObj.SCREEN_KEY = "12138";    
	        systemConfirmationService.url = "ref/groupBatchCommandDispatch.action?method=confirmSelection";
	        var rnd:Number=Math.random();   
	        systemConfirmationService.send(); 
    }
    
        /**
    * Screen after run the generated command
    */ 
    private function runCommandResultHandler(event: ResultEvent) : void {
    	userConfirmButton.enabled=true;
    	backButton.enabled=true;
    	errPage2.removeError();
        var errorInfoList : ArrayCollection = new ArrayCollection();
	    if (event != null && event.result!= null) {
		 		if (event.result.groupBatchCommandActionForm != null ) {
				 		this.batchGroupName =event.result.groupBatchCommandActionForm.batchGroupId;
				 		this.refNoLabel = event.result.groupBatchCommandActionForm.refNo;
				 		vstack.selectedChild = vbox4;
				 		vbox4.visible =true;
				 		vbox4.includeInLayout = true;
				 		sysbatchgroupid.visible =true;
				 		sysbatchgroupid.includeInLayout = true;
				 		sysexecutionid.visible =true;
				 		sysexecutionid.includeInLayout = true;
				 		this.headerLabel =this.parentApplication.xResourceManager.getKeyValue('ref.onlinebatch.execution.systemConfirmation');
		 		} else if (event.result.XenosErrors!= null && 
    						event.result.XenosErrors.Errors != null 
    						&& event.result.XenosErrors.Errors.error != null){
					 
					 if (event.result.XenosErrors.Errors.error is ArrayCollection) {
						 errorInfoList=event.result.XenosErrors.Errors.error as ArrayCollection;
					 } else { 
						 errorInfoList.addItem(event.result.XenosErrors.Errors.error);
					 }
		             errPage2.showError(errorInfoList);
		             
		 		}
		 	
		 	} 
    }
    
    private function faultHandler(event : FaultEvent) : void{
    	userConfirmButton.enabled=true;
    	backButton.enabled=true;
    	XenosAlert.error(Application.application.xResourceManager.getKeyValue('ref.msg.common.info.errorfaultstr', new Array(event.fault.faultString)));
    }
		
		 /**
    * Retrive data from UI, validate and prepair request param string 
    */
    private function prepairRequestParamString(alertString:String, reqObj:Object) : Boolean {
    	var valueFromUi:String = "";
    	var paramStr:String = "";
		var itemCount:int = 0;
		var isBlankAllowed:Boolean = true;
		//XenosAlert.info("Total Dyna Rows :: "+ rowCount);
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
				reqObj.fundCode = valueFromUi;
			}else if(XenosStringUtils.equals(compName[itemCount],"treeCombo"+itemCount)){
				valueFromUi = ti.itemCombo.text;
			}else if(!XenosStringUtils.isBlank(ti.text) && XenosStringUtils.equals(compName[itemCount],"combo"+itemCount)){
				valueFromUi = ti.selectedItem.value;
			}else if(!XenosStringUtils.isBlank(ti.text) && XenosStringUtils.equals(compName[itemCount],"date"+itemCount)){
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
				}else if(!XenosStringUtils.isBlank(ti.text) && XenosStringUtils.equals(compName[itemCount],"combo"+itemCount)){
					valueFromUi = ti.selectedItem.value;
				}else if(XenosStringUtils.equals(compName[itemCount],"date"+itemCount) && !XenosStringUtils.isBlank(ti.text)){
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
		return isBlankAllowed;
    }   
    
    
     /**
    * Return to initial(Batch Execution Selection) screen
    */ 
    public function returnToInitial():void{
    	vstack.selectedChild = vbox1;
		vbox1.visible = true;
		vbox1.includeInLayout = true;
		vbox2.visible = false;
		vbox2.includeInLayout = false;		
		//vbox3.visible = false;
		//vbox3.includeInLayout = false;		
		refNo = "";
		groupBatchId = "";
		this.batchGroupId.selectedIndex = 0;
		this.officeId.selectedIndex = 0;
		refreshGlobalData();
		loadAll();
    }
    
    public function doReset():void{
    	refNo = "";
    	groupBatchId = "";
		this.batchGroupId.selectedIndex = 0;
		this.officeId.selectedIndex = 0;
		refreshGlobalData();
		this.batchGroupId.setFocus();
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
		groupBatchId = "";
		selectedBatchId = "";
		serverErrorMessage = "";
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
			var dropDownValue:XML = new XML(collection.getItemAt(count));
			if(XenosStringUtils.equals(String(dropDownValue.label),value)){
				index = count;
				break;
			}

		}
		return index;
	}
			
     