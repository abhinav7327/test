




import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.*;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.ref.popupImpl.AccountPopUpHbox;
import com.nri.rui.ref.popupImpl.FinInstitutePopUpHbox;
import com.nri.rui.ref.popupImpl.FundPopUpHbox;
import com.nri.rui.ref.popupImpl.InstrumentPopUpHbox;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.containers.GridItem;
import mx.containers.GridRow;
import mx.controls.ComboBox;
import mx.controls.DateField;
import mx.controls.Label;
import mx.controls.TextInput;
import mx.events.ResourceEvent;
import mx.managers.FocusManager;
import mx.resources.ResourceBundle;
import mx.rpc.events.ResultEvent;
			
/**
 * ReportUIExecution - Action Script for ReportUIExecution.
 * @author joyeetag
 * @version 
 */ 
	  

[Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
[Bindable]private var rs : XML = new XML();            
[Bindable]private var keylist:ArrayCollection = new ArrayCollection(); 
[Bindable]private var tempResult:ArrayCollection = new ArrayCollection();
[Bindable]private var uiValidationString : String = "";
[Bindable]private var minHeapSize : String = "";     
[Bindable]private var maxHeapSize : String = "";
[Bindable]private var compCount:int = 0; 
[Bindable]private var requestParamString : String = "";     
[Bindable]private var idCount:int = 0;     
[Bindable]private var shortOptionArray:Array = new Array();     
[Bindable]private var mendatoryCompCount : int = 0;
[Bindable]private var mendatoryField:Array = new Array();    
[Bindable]private var shortOption:Array = new Array();
[Bindable]private var contextParamList:ArrayCollection = new ArrayCollection(); 
[Bindable]private var rowName:Array = new Array();
[Bindable]private var itemName:Array = new Array();
[Bindable]private var compName:Array = new Array();   
[Bindable]private var labelString:Array = new Array();
[Bindable]private var rowCount:int = 0;  
[Bindable]private var finalCommand:Object = new Object();
[Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
[Bindable]private var popupType : String = "";
[Bindable]private var idArray:Array = new Array();
[Bindable]private var hiddenObjects:ArrayCollection = new ArrayCollection();
      
    

                      
	 
	/**
	* At the time of loading the module if the module specific Resource is not loaded then load them
	*/ 
	public function loadResourceBundle():void
	{
	    var locales:String = this.parentApplication.xResourceManager.localeChain[0];
	    
	    var resourceModuleURL:String = "assets/appl/ref/refResources_" + locales + ".swf";
	       
	    var bundle:ResourceBundle = ResourceBundle(resourceManager.getResourceBundle(locales, "refResources"));
	       
	    var eventDispatcher:IEventDispatcher = null;
	       if(bundle == null){    
	        eventDispatcher = this.parentApplication.xResourceManager.loadResourceModule(resourceModuleURL);
	           
	        eventDispatcher.addEventListener(ResourceEvent.ERROR, errorHandler);            
	    }        
	    this.parentApplication.xResourceManager.update();
	}
    
	/**
	 * Error Handler while loading Resource Bundle
	 * @param event
	 * 
	 */
	 private function errorHandler(event:ResourceEvent):void{
	    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.reportui.msg.error.load.refresource', new Array(event.errorText)));
	 }
    
    /**
	* This method will be called at the time of the loading this module and 
	* pressing the reset button.
	*
	*/
	private function initPageStart():void {
		var rndNo:Number= Math.random();
		var req:Object = new Object();
		req.SCREEN_KEY = 11093;
		initializeReportExecution.url = "ref/reportExecutionDispatch.action?method=initialExecute&rnd=" + rndNo;
		initializeReportExecution.request = req;
		initializeReportExecution.send();		
	}    
    
   /**
	* This method works as the result handler of the Submit Query Http Services.
	* This also takes care of the buttons/images to be shown on the top panel of the
	* result .
	*/
	  private function initPage(event:ResultEvent):void {
	  	var rs:XML = XML(event.result);
		app.submitButtonInstance = submit;
        if (null != event) { 
	    	if(rs.child("Errors").length()>0) {	    		
	    		var errorInfoList : ArrayCollection = new ArrayCollection();
	    		//populate the error info list 			 	
	    		for each ( var error:XML in rs.Errors.error ) {
	    			errorInfoList.addItem(error.toString());
	    		} 
	    		errPage.showError(errorInfoList);//Display the error

	    	} else {        	
        		var initColl:ArrayCollection = new ArrayCollection();
				errPage.clearError(event);
				errPage.removeError();
	            var rec:XML = new XML();
				try {				    			
					if(rs != null) {	
				        initColl.removeAll();
			    		initColl.addItem({label:" ", value: " "});		    		 
				        for each (rec in rs.reportIdList.item) {
				        	initColl.addItem(rec);
				        }
				        this.reportIdList.dataProvider = initColl;	
					} else {
					 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));					 	
					 	errPage.removeError(); //clears the errors if any
					 }	            			                        	      	
				}catch(e:Error){
				    XenosAlert.error(e.toString() + e.message);
				    //XenosAlert.error("No result found");
			    }
		        reportIdList.setFocus();	            	
			   }				 
	        } else {
	        	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));			 	
			 	errPage.removeError(); //clears the errors if any        	
	        }
	  }    
    
   /**
	* This method works as the result handler of the Submit Query Http Services.
	* This also takes care of the buttons/images to be shown on the top panel of the
	* result .
	*/
	  private function loadOfficePopulatedPage(event:ResultEvent):void {
	  	var rs:XML = XML(event.result);	  	
	  	changeVisibility();
	  	
        if (null != event) { 
	    	if(rs.child("Errors").length()>0) {	    		
	    		var errorInfoList : ArrayCollection = new ArrayCollection();
	    		//populate the error info list 			 	
	    		for each ( var error:XML in rs.Errors.error ) {
	    			errorInfoList.addItem(error.toString());
	    		} 
	    		errPage.showError(errorInfoList);//Display the error

	    	} else {        	
        		var initColl:ArrayCollection = new ArrayCollection();
				errPage.clearError(event);
				errPage.removeError();
	            var rec:XML = new XML();
				try {				    			
					if(rs != null) {	
			    		var index:int = 0;
			    		
			    		// Setting Report Id
						var reportIdObj:String;
		            	reportIdObj = rs.reportId;			  
				        initColl.removeAll();
			    		initColl.addItem({label:" ", value: " "});		    		 
				        for each (rec in rs.reportIdList.item) {
				        	initColl.addItem(rec);
				        }
				        this.reportIdList.dataProvider = initColl;			    	
				    	for each(var itemRpt1:Object in (initColl as ArrayCollection)){
			    			if(itemRpt1.value == reportIdObj){
			    				index = (initColl as ArrayCollection).getItemIndex(itemRpt1);			    					    				
			    		  	}			    		
				    	}		            	
				        this.reportIdList.selectedIndex = index;		
           				//------------end-----------//
           				
           				//Setting Office
           				index = 0;
						var officeStr:String;
		            	officeStr = rs.office;	
		            	var initColl2:ArrayCollection = new ArrayCollection();		  
				        initColl2.removeAll();			    		    		 
				        for each (rec in rs.officeList.item) {
				        	initColl2.addItem(rec);
				        }
				        this.office.dataProvider = initColl2;		
				        
				        for each(var itemRpt2:Object in (initColl2 as ArrayCollection)){
			    			if(itemRpt2.value == officeStr){
			    				index = (initColl2 as ArrayCollection).getItemIndex(itemRpt2);			    					    				
			    		  	}			    		
				    	}		            	
				        this.office.selectedIndex = index;	
				        //------------end-----------//
				        
				        //Setting LM/IM
				        index = 0;
						var LmIm:String;
		            	LmIm = rs.lmImFlag;		
		            	var initColl3:ArrayCollection = new ArrayCollection();	  
				        initColl3.removeAll();			    		    		 
				        for each (rec in rs.lmImList.item) {
				        	initColl3.addItem(rec);
				        }
				        this.lmImList.dataProvider = initColl3;		
				        	    	
				    	for each(var itemRpt:Object in (initColl3 as ArrayCollection)){
			    			if(itemRpt.value == LmIm){
			    				index = (initColl3 as ArrayCollection).getItemIndex(itemRpt);			    					    				
			    		  	}			    		
				    	}		            	
				        this.lmImList.selectedIndex = index;	
				        //------------end-----------//					                   	
           	           //this.reportIdList.setFocus();
           	            focusManager.setFocus(this.reportIdList);
						focusManager.showFocus();
           	
					} else {
					 	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));					 	
					 	errPage.removeError(); //clears the errors if any
					 }	            			                        	      	
				}catch(e:Error){
				    XenosAlert.error(e.toString() + e.message);
				    //XenosAlert.error("No result found");
			    }
			   }				 
	        } else {
	        	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));			 	
			 	errPage.removeError(); //clears the errors if any        	
	        } 		  		  	
	  }    
	  
    /**
	* This method will be called at the time of the loading this module and 
	* pressing the reset button.
	*
	*/
	private function generateUIInit():void {
		var rndNo:Number= Math.random();
		var reqObj:Object = populateRequestParams();
		var errMsg:String = performSpecialValidation(reqObj);
		if (!XenosStringUtils.isBlank(errMsg)) {
			XenosAlert.error(errMsg);
		} else {
		    submitExecution.request = reqObj;		
			submitExecution.send();
			app.submitButtonInstance = confSubmit;
		}
	}	  
	
	/**
	 * This method performs special validation based on report Id and other attributes 
	 * selected for generating UI for executing this report.
	 */   
	private function performSpecialValidation(reqObj:Object):String {
		
		var errMsg:String = XenosStringUtils.EMPTY_STR;
		try {
			trace("Report Id : " + reqObj.reportId);
			trace("LM/IM Flag : " + reqObj.lmImFlag);
			if (XenosStringUtils.equals(reqObj.reportId, "T21FA") 
					&& XenosStringUtils.equals(reqObj.lmImFlag, "lm")) {
						errMsg = this.parentApplication.xResourceManager.getKeyValue('ref.reportui.error.wronglmim.t21fa') + "\n";
			}
			if ((XenosStringUtils.equals(reqObj.reportId, "FINGR") || XenosStringUtils.equals(reqObj.reportId, "CALPR")) 
					&& (XenosStringUtils.equals(reqObj.lmImFlag, "im") || !XenosStringUtils.equals(reqObj.office, "US"))) {
						errMsg = this.parentApplication.xResourceManager.getKeyValue('ref.reportui.error.nonusorim.notsupported') + "\n";
			}
			
			if (XenosStringUtils.equals(reqObj.reportId, "FMSTR") 
					&& XenosStringUtils.equals(reqObj.lmImFlag, "lm")) {
						errMsg = this.parentApplication.xResourceManager.getKeyValue('ref.reportui.error.wronglmim.fmstr') + "\n";
			}

			if (XenosStringUtils.equals(reqObj.reportId, "FMSDB") 
					&& (XenosStringUtils.equals(reqObj.lmImFlag, "im")|| !XenosStringUtils.equals(reqObj.office, "US"))) {
						errMsg = this.parentApplication.xResourceManager.getKeyValue('ref.reportui.error.nonusorim.notsupported') + "\n";
			}

			if (XenosStringUtils.equals(reqObj.reportId, "FMSMG") 
					&& XenosStringUtils.equals(reqObj.lmImFlag, "lm")) {
						errMsg = this.parentApplication.xResourceManager.getKeyValue('ref.reportui.error.wronglmim.fmsmg') + "\n";
			}
			if (XenosStringUtils.equals(reqObj.reportId, "FMSOP") 
					&& XenosStringUtils.equals(reqObj.lmImFlag, "im")) {
						errMsg = this.parentApplication.xResourceManager.getKeyValue('ref.reportui.error.wronglmim.fmsop') + "\n";
			}
			if (XenosStringUtils.equals(reqObj.reportId, "ALLOC") 
					&& XenosStringUtils.equals(reqObj.lmImFlag, "lm")) {
						errMsg = this.parentApplication.xResourceManager.getKeyValue('ref.reportui.error.wronglmim.alloc') + "\n";
			}
			if (XenosStringUtils.equals(reqObj.reportId, "DRVTR") 
					&& !XenosStringUtils.equals(reqObj.lmImFlag, "im")) {
						errMsg = this.parentApplication.xResourceManager.getKeyValue('ref.reportui.error.wronglmim.drvtr') + "\n";
			}
			if (XenosStringUtils.equals(reqObj.reportId, "DRTRR") 
					&& !XenosStringUtils.equals(reqObj.lmImFlag, "im")) {
						errMsg = this.parentApplication.xResourceManager.getKeyValue('ref.reportui.error.wronglmim.drtrr') + "\n";
			}
			// [XGA-2097] - [NDF] Forex Transaction Report
			if (XenosStringUtils.equals(reqObj.reportId, "FXTXR") 
					&& XenosStringUtils.equals(reqObj.lmImFlag, "im")) {
						errMsg = this.parentApplication.xResourceManager.getKeyValue('ref.reportui.error.wronglmim.fxtxr') + "\n";
			}
			
			if (XenosStringUtils.equals(reqObj.reportId, "CFLPR") 
					&& XenosStringUtils.equals(reqObj.lmImFlag, "im")) {
						errMsg = this.parentApplication.xResourceManager.getKeyValue('ref.reportui.error.wronglmim.cflpr') + "\n";
			}
			if (XenosStringUtils.equals(reqObj.reportId, "FGSTR") 
					&& XenosStringUtils.equals(reqObj.lmImFlag, "im")) {
						errMsg = this.parentApplication.xResourceManager.getKeyValue('ref.reportui.error.wronglmim.fgstr') + "\n";
			}

		} catch (error:Error) {
			trace("Error occurred while performing special validation for report.");
			trace(error.getStackTrace());
			errMsg = this.parentApplication.xResourceManager.getKeyValue('ref.reportui.error.special.validation') + "\n";
		}
		
		trace("Error while validating: " + errMsg);
		return errMsg;
	}  
	  
   /**
	* This method works as the result handler of the Submit Query Http Services.
	* This also takes care of the buttons/images to be shown on the top panel of the
	* result .
	*/
	  private function generateUIResultPage(event:ResultEvent):void {
	  	var rs:XML = XML(event.result);
		trace("Event in generate UI Result Page :" + event);
        if (null != event) { 
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
					changeVisibilityBeforeSubmit();
					this.reportId.text = rs.reportId;
					this.officeId.text = rs.office;
					var LmIM:String = rs.lmImFlag;
					this.lmIm.text = LmIM.toUpperCase();
					trace("Generating Dynamic UI...");				    		    	
					showUIConfigItems(rs);	
					var rows:GridRow = GridRow(this.gridBase.getChildren()[0]); 
					var rowColumn:GridItem = GridItem(rows.getChildren()[1]);
					var uitypeFirst:String = null;
					//var popUpType:String = null;
					for each ( var rec:XML in rs.uIconfigListForRUI.UIconfigListForRUI) {
						uitypeFirst = rec.UIType;
						if(XenosStringUtils.isBlank(uitypeFirst) != true){
							for each (var rectemp:Object in rec.optionLblValueList.item){
								 setContextParamList(rectemp.label, rectemp.value , uitypeFirst);
							}
						}
						
						break;
					}
					
					if(XenosStringUtils.equals(uitypeFirst,"Text")||XenosStringUtils.equals(uitypeFirst,"TextBox")){
						var textBox:TextInput = TextInput(rowColumn.getChildren()[0]);
			            textBox.setFocus();
			            textBox.addEventListener(Event.CHANGE,changeToUpperCase);
			            
					}
					else if(XenosStringUtils.equals(uitypeFirst,"Popup")){
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
					else if(XenosStringUtils.equals(uitypeFirst,"Date")){
						//XenosAlert.info(rowColumn.getChildren()[0].toString());
						var dateField:DateField = DateField(rowColumn.getChildren()[0]);
						//dateField.width=100;
						focusManager.setFocus(dateField);
						focusManager.showFocus();
						
						//dateField.setFocus();
					}
					else if(XenosStringUtils.equals(uitypeFirst,"DropDown")){
						var comboBox:ComboBox = ComboBox(rowColumn.getChildren()[0]);
						focusManager.setFocus(comboBox);
						focusManager.showFocus();
						//comboBox.setFocus();
					}
					else if(XenosStringUtils.equals(uitypeFirst,"CheckBox")){
						var checkBox:CheckBox = CheckBox(rowColumn.getChildren()[0]);
						focusManager.setFocus(checkBox);
						focusManager.showFocus();
					}
	    		} catch (e:Error) {
	    			trace("Error occurred while generating UI...");
	    			XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.reportui.msg.error', new Array(e)));
	    		}
			 
	        } 
	        
        } else {
        		trace("Event is null");
	        	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));			 	
			 	errPage.removeError(); //clears the errors if any        	
	    }	  	
	  	
	  }
	  
	 private function changeToUpperCase(evt:Event):void {
	  	//XenosAlert.info(evt.target.toString().toUpperCase())
		//evt.target.text = evt.target.text.toUpperCase();
	}
	  /**
	   * Validate on Proceed button click.
	   * @return Boolean True or false depending upon validation sucess or failure.
	   */
	  private function validateOnProceed():Boolean {
		var errMsg:String = "";
    	
    	try {
    		if(this.reportIdList.selectedItem == null
    			|| this.reportIdList.selectedItem.value == " ") {
    			errMsg+="Please Enter Report Name.";   
    		}
    	} catch (e:Error) {
    		XenosAlert.error(e.message);
    	}
    	if(!XenosStringUtils.isBlank(errMsg)){
    		XenosAlert.error(errMsg);
    		return false;
    	}
    	else
    		return true;
	  }	
	    
	  
	  /**
	   * Proceed action on clicking proceed button hit.
	   * 
	   */
	  private function proceedToPopulateOffice():void {
		if(validateOnProceed()) {
			var reqObj:Object = new Object();
			reqObj.reportId = this.reportIdList.selectedItem != null ? this.reportIdList.selectedItem.value : "";
			proceedReportExecution.request = reqObj;			
			proceedReportExecution.send();	
			app.submitButtonInstance = submit2;		
		}		
	  }
	  
	  /**
	   * Change Visibility for UI select and Execution
	   * 
	   */
	  private function changeVisibility():void {		
		OfficeLM.visible = true;
		OfficeLM.includeInLayout = true;
		selectToSubmit.visible = true;
		selectToSubmit.includeInLayout = true;	 
		proceed.visible= false;
		proceed.includeInLayout = false;
		initLabel1.visible = false;
		initLabel1.includeInLayout = false;
		ReportEntry.visible = false;
		ReportEntry.includeInLayout = false;
		gridBase.visible = false;
		gridBase.includeInLayout = false;	
		submitToRun.visible = false;
		submitToRun.includeInLayout = false;		
		initLabel2.visible = true;
		initLabel2.includeInLayout = true;
	  }		
	  
	  /**
	   * Change Visibility for UI select and Execution
	   * 
	   */
	  private function changeVisibilityBeforeSubmit():void {
	  	ReportName.visible = false;
	  	ReportName.includeInLayout = false;		
		OfficeLM.visible = false;
		OfficeLM.includeInLayout = false;
		selectToSubmit.visible = false;
		selectToSubmit.includeInLayout = false;	 
		proceed.visible= false;
		proceed.includeInLayout = false;
		initLabel1.visible = false;
		initLabel1.includeInLayout = false;
		ReportEntry.visible = true;
		ReportEntry.includeInLayout = true;
		gridBase.visible = true;
		gridBase.includeInLayout = true;		
		submitToRun.visible = true;
		submitToRun.includeInLayout = true;
		initLabel2.visible = true;
		initLabel2.includeInLayout = true;		
	  }	  

	
	   /**
	    * Pre method on the handeler of Reset button. 
		* @override 
		* @see com.nri.rui.core.containers.XenosEntryModule.preResetEntry
	    */
	   private function resetMethod():void {
			reset.send();	 
	   }		   
	    
	   /**
	    * Event handler of Reset Function 
	    * @param event the Result event 
	    */
	   private function resetInitialisePage(event:ResultEvent):void {
	   		OfficeLM.visible = false;
	   		OfficeLM.includeInLayout = false;
	   		ReportName.visible = true;
	   		ReportName.includeInLayout = true;
	   		proceed.visible = true;
	   		proceed.includeInLayout = true;
	   		selectToSubmit.visible = false;
	   		selectToSubmit.includeInLayout = false;
	   		office.selectedItem = null;
	   		lmImList.selectedItem = null;	   		
	   		//initial page loading
	   		initPage(event);	   	
	   }	    
    
	   /**
	    * This method will populate the request parameters for the
	    * submitQuery call and bind the parameters with the HTTPService
	    * object.
	    */
	    private function populateRequestParams():Object { 	    
	    	var reqObj:Object = new Object();
	    	reqObj.SCREEN_KEY = 11093;
			reqObj.office =  this.office.selectedItem != null ? this.office.selectedItem.value : "";    	
    		reqObj.lmImFlag = this.lmImList.selectedItem != null ? this.lmImList.selectedItem.value : "";	
    		reqObj.reportId = this.reportIdList.selectedItem != null ? this.reportIdList.selectedItem.value : "";
    		
    		return reqObj;    	
	    }
	    
	   /**
	    * This method will lead one screen back
	    */    	    	   	 
	    private function doBackToProceed():void {
	    	errPage.removeError();
	   	  	ReportName.visible = true;
		  	ReportName.includeInLayout = true;	
		  	ReportName.setFocus();	
			OfficeLM.visible = true;
			OfficeLM.includeInLayout = true;
			selectToSubmit.visible = true;
			selectToSubmit.includeInLayout = true;	 
			proceed.visible= false;
			proceed.includeInLayout = false;
			initLabel1.visible = true;
			initLabel1.includeInLayout = true;
			ReportEntry.visible = false;
			ReportEntry.includeInLayout = false;
			gridBase.visible = false;
			gridBase.includeInLayout = false;		
			submitToRun.visible = false;
			submitToRun.includeInLayout = false;
			initLabel2.visible = false;
			initLabel2.includeInLayout = false;		
			app.submitButtonInstance = 	submit2;
	    	refreshGlobalData();
	    }
	    
	   /**
	    * This method will lead one screen back
	    */    	    	   	 
	    private function doBack():void {
	    	errPage.removeError();
	    	vstack.selectedChild = select;
	    }	    
		    
	    /**
		* This method will be called at the time of the loading this module and 
		* pressing the reset button.
		*
		*/
		private function submitSelectionOnUsrConfirm():void {
			var alertString:String = "";
			super.setXenosEntryControl(new XenosEntry());
			if(prepairRequestParamString(alertString)){
				this.dispatchEvent(new Event('entrySave'));	
				
			}		
		}	    
	    	    

		 /**
		  * Pre Hook Implementation:Event fired on click of Submit Button
		  * @override 
		  * @see com.nri.rui.core.containers.XenosEntryModule.preEntry
		  */
		 override public function preEntry():void {
		 	var reqObj:Object = new Object();				
			reqObj.optionValueStrForRUI = requestParamString;
			var rnd:Number=Math.random();  
	    	reqObj.SCREEN_KEY = 11094;					
		 	super.getSaveHttpService().url = "ref/reportExecutionDispatch.action?method=submitSelection&rnd=" + rnd;		 	
		 	super.getSaveHttpService().request  =reqObj;						        
		 }
		 
		/**
		 * Pre Hook Implementation:Event Handler on click of Submit Button
		 * @return  Keylist the list containing the Xml element names
		 * @override 
		 * @see com.nri.rui.core.containers.XenosEntryModule.preEntryResultHandler 
		 */
		override public function preEntryResultHandler():Object {
			 addCommonKeys();
			 return keylist;
		}   	  
			 
		/**
		 * Post Hook Implementation:Event Handler on click of Submit Button
		 * @param mapObj
		 * 
		 */
		override public function postEntryResultHandler(mapObj:Object):void {				 
			showResult(mapObj);		
			uConfLabel.includeInLayout = true;
			uConfLabel.visible = true;
 			uConfSubmit.visible = true;
 			uConfSubmit.includeInLayout = true;
 			sConfSubmit.visible = false;
 			sConfSubmit.includeInLayout = false; 			
			usrCnfMessage.text ="Batch Status Query  Entry - User Confirmation";		
		}	     
	    		
	    /**
	     * Prepares the Keylist that maps to the ActionForm attribute names to fetch the element's value
	     * to show.
	     * 
	     */
	    private function addCommonKeys():void{        	
	    	keylist = new ArrayCollection();
	    	keylist.addItem("finalFullCommand");
			keylist.addItem("refNo");		 	    		
	
	    }

	    /**
	     * Result after submission.leads to user confirmation screen.
	     * @param mapObj
	     * 
	     */
	    private function showResult(mapObj:Object):void {
	    		 	
	    	if(mapObj!=null){    		    		
		    	if(mapObj["errorFlag"].toString() == "error"){
		    		//result = mapObj["errorMsg"] .toString();	    		
		    		errPage.showError(mapObj["errorMsg"]);		    			
		    	}else if(mapObj["errorFlag"].toString() == "noError"){	  
		    	 try {  		
			    	 errPage.clearError(super.getSaveResultEvent());	
			    	 vstack.selectedChild = confirm;		
		             commonResultPart(mapObj);          	            
					 confPart.visible = true;				 
					 confPart.includeInLayout = true;				 
					 okPart.visible = false;				 
					 okPart.includeInLayout = false;	
			    	 back.includeInLayout = true;
			    	 back.visible = true;					 			 
			    	 uConfSubmit.enabled = true;
			    	 finalFullCommand.setFocus();
			    	 app.submitButtonInstance = uConfSubmit;					 			 
		    	 }catch (e:Error) {
		    	 	XenosAlert.error(e.message);
		    	 }
		    	}else{
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.datanotfound'));
		    	}    		
	    	}
	    }
	    
	    /**
	     * Result handler for providing data to the confirmation module.
	     * @param mapObj
	     * 
	     */
	    private function commonResultPart(mapObj:Object):void {	    	
	    	finalCommand = mapObj[keylist.getItemAt(0)];	    	
	    }	    

		/**
		 * Pre Hook Implementation:Event fired on click of Confirm Button
		 * 
		 */
		override public function preEntryConfirm():void {
			var reqObj :Object = new Object();
			reqObj.SCREEN_KEY = 11095;
			super.getConfHttpService().url = "ref/reportExecutionDispatch.action?";  
			reqObj.method= "confirmSelection";
	        super.getConfHttpService().request  =reqObj;
		}  
		 
		/**
		 * Pre Hook Implementation:Event Handler on click of Confirm Button
		 * @return  Keylist the list containing the Xml element names
		 * @override 
		 * @see com.nri.rui.core.containers.XenosEntryModule.preEntryConfirmResultHandler 
		 * 
		 */
		override public function preEntryConfirmResultHandler():Object {
			 addCommonKeys();
			 return keylist;
		} 	 
		 
		 
		/**
		 * Post hook implementaion:Event Handler on click of Confirm Button
		 * @param mapObj The object containing all the result values with the as a name and value pair.
		 * where names corresponds to the XML element names(keylist values)
		 * @override 
		 * @see com.nri.rui.core.containers.XenosEntryModule.postConfirmEntryResultHandler 
		 * 
		 */
		override public function postConfirmEntryResultHandler(mapObj:Object):void {
			submitUserConfResult(mapObj);		
		} 


		/**
		 * Event Handler on click of Confirm Button.
		 *  
		 * @param mapObj The object containing all the result values with the as a name and value pair.
		 * where names corresponds to the XML element names(keylist values)
		 * 
		 */
		private function submitUserConfResult(mapObj:Object):void {
		if(mapObj!=null){    					
	    	if(mapObj["errorFlag"].toString() == "error"){    		
	    		errConf.removeError();  		
	    		errConf.showError(mapObj["errorMsg"]);
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
		    	   errConf.clearError(super.getConfResultEvent());
		    	   back.includeInLayout = false;
		    	   back.visible = false;
				   uConfSubmit.enabled = true;	
		           uConfLabel.includeInLayout = true;
		           uConfLabel.visible = true;
		           usrCnfMessage.text=this.parentApplication.xResourceManager.getKeyValue('ref.reportui.label.systemconfirm');
		           uConfSubmit.includeInLayout = false;
		           uConfSubmit.visible = false;
		           sConfLabel.includeInLayout = true;
		           sConfLabel.visible = true;
		           sConfSubmit.includeInLayout = true;
		           sConfSubmit.visible = true;		            
		           //grid disable /enable
		           confPart.visible = false;
		           confPart.includeInLayout = false;
		           okPart.visible = true;
		           okPart.includeInLayout = true;                          	          	
		           app.submitButtonInstance =   sConfSubmit;   
		           refNo.setFocus();                    	          	
			       // reference No to display.
			       this.refNo.text = mapObj[keylist.getItemAt(1)].toString();     	       		                   	    	   
		    	}else{
		    		errConf.removeError();
		    	}    		
			}
		}

		/**
		 * Event of clicking on the Ok button of the Online Report generation operation
		 * @param e Event Event fired 
		 * @override 
		 * @see com.nri.rui.core.containers.XenosEntryModule.doEntrySystemConfirm
		 */
		override public function doEntrySystemConfirm(e:Event):void {
			vstack.selectedChild = select;	
							
			sConfLabel.includeInLayout = false;
			sConfLabel.visible = false;
			sConfSubmit.includeInLayout = false;
			sConfSubmit.visible = false;			       		
	   		OfficeLM.visible = false;
	   		OfficeLM.includeInLayout = false;
			ReportEntry.visible = false;
			ReportEntry.includeInLayout = false;
			submitToRun.visible = false;
			submitToRun.includeInLayout = false;
			gridBase.visible = false;
			gridBase.includeInLayout = false;   					
	   		ReportName.visible = true;
	   		ReportName.includeInLayout = true;
	   		proceed.visible = true;
	   		proceed.includeInLayout = true;
	   		selectToSubmit.visible = false;
	   		selectToSubmit.includeInLayout = false;
	   		//selected list set to null
	   		office.selectedItem = null;
	   		lmImList.selectedItem = null;	
	   		reportIdList.selectedIndex = 0;
	   
	   
			refreshGlobalData();
			initPageStart();
		}


		/**
		 * Shows the Dynamic UI components for Report parameters to run the report 
		 * from UI.It parses the label value list containing all information about 
		 * the UI components and data providers.
		 * 
		 * @param rs The Result Coming from Server.
		 * 
		 */
		private function showUIConfigItems(rs: XML):void {
    	var componentCount:int=0;
    	var i:int=0;

    	if (rs != null) {
    		var reportId:String = rs.child("reportId");
    		//XenosAlert.info(reportId);
    		if(rs.child("uIconfigListForRUI").length()>0) {
				//use to add min/max heap size if exist.
				maxHeapSize  = rs.maxHeapSizeString.toString();
				minHeapSize  = rs.minHeapSizeString.toString();    			
    			try {
    				var gridRow:GridRow = new GridRow();
    				gridRow.name = "gridrow"+rowCount;
    				rowName[rowCount] = gridRow.name;
    				gridRow.percentWidth = 100;
    				this.hiddenObjects.removeAll();
    				//gridRow.styleName="LabelBgColor";
    				for each ( var rec:XML in rs.uIconfigListForRUI.UIconfigListForRUI) {
    					gridRow.percentWidth = 100;
    					var uitype:String = rec.UIType;
    					var labelKey:String = rec.labelKey;
    					var dropDownData:ArrayCollection = new ArrayCollection();
    					var defaultValue:String = "";
    					var caseOfText:String = "";
    					var dropdownItem:Array = new Array();
    					var blankRequiredFlag:String="true";
    					trace("Label Key : " + labelKey)
						if(XenosStringUtils.isBlank(uitype) != true){							
							

								for each(var xmlObj:Object in rec.optionLblValueList.item) {
									var optLabel:String = xmlObj.label;									
									
									if(XenosStringUtils.equals(optLabel,"defaultValue")){								
										defaultValue = xmlObj.value;										
									}									
									
									if(XenosStringUtils.equals(optLabel,"isUpper")){								
										caseOfText = xmlObj.value;										
									}									
																		
									
									if(XenosStringUtils.equals(optLabel,"values")) {
										var valuesStr:String = xmlObj.value;																				
										dropdownItem = valuesStr.split(",");
				
									}
									if(XenosStringUtils.equals(optLabel,"isBlankRequired")){								
										blankRequiredFlag = xmlObj.value;										
									}
																		
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
							
							
							//use to prepair requestParamString
							shortOption[compCount] = rec.shortOption;
							
							//use to coloring the mandatory field
							var isOptional:String = rec.isOptional;
							//XenosStringUtils.equals(isOptional,"true") && 
							if(XenosStringUtils.equals(rec.optionLblValueList.item.label,"isRequired")){
								if(XenosStringUtils.equals(rec.optionLblValueList.item.value,"true")){
									isOptional = "false";
								}
							}																			
							
							
							//create context param list
							for each ( var rec1:Object in rec.optionLblValueList.item){
								setContextParamList(rec1.label, rec1.value , uitype);
							}
		    				
		    				//add the items into rows & not include for ui type Hidden
		    				if(DynamicDisplayOfData(gridRow, labelKey, uitype,caseOfText, dropDownData, isOptional,defaultValue,reportId) == false){
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
    				
    				

    				if(XenosStringUtils.isBlank(maxHeapSize) != true 
    				|| XenosStringUtils.isBlank(minHeapSize) != true) {
    					//var gridRow:GridRow = new GridRow();
    					gridRow.removeAllChildren();
    					var gridItem:GridItem = new GridItem();    					
    					//gridItem.width = itemWidthLabel;
    					gridItem.percentWidth = 20;
    					gridItem.styleName="LabelBgColor";
    					var label:Label = new Label();
    					label.text = "Min Heap Size"; 
    					label.styleName = "FormLabelHeading";  			
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
    					label.styleName = "FormLabelHeading";
    					gridItem = new GridItem();
    					gridItem.styleName="LabelBgColor";
    					gridItem.percentWidth = 20;
    					//gridItem.width = itemWidthLabel;	
    					gridItem.addChild(label);
    					gridRow.addChild(gridItem);
    					
    					label = new Label();
    					label.text = maxHeapSize;    					
    					gridItem = new GridItem();
    					gridItem.percentWidth = 30;
    					gridItem.addChild(label);
    					gridRow.addChild(gridItem);
    					
    					gridBase.addChild(gridRow);
    				}
    				gridRow = new GridRow();
    				gridRow.percentWidth = 100;
    			}catch(e:Error){
    				trace("Error generating UI components...")
    				trace("Error Message : " + e.message)
    				trace("Error ID : " + e.errorID)
    				trace("Error Name : " + e.name)
    				trace("Stack Trace : " + e.getStackTrace())
    				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.reportui.error.generateui'));
    			}
    		}
    	}
    }    	
    
    /**
     * Dynamic Display of data prepared with the type of UI components.
     * @param gridRow      grid row
     * @param labelKey 	   Label
     * @param uitype	   type of UI(comboBox,checkbox,textbox ..)
     * @param dropDownData the Drop down List items
     * @param isOptional   Whether the value is required or Optional to validate
     * @param reportId	   Report Id
     * @return 			   Whether any values are added or not
     * 
     */
    public function DynamicDisplayOfData(gridRow:GridRow, 
    									labelKey:String, 
    									uitype:String, 
    									caseOfText:String, 
    									dropDownData:ArrayCollection, 
    									isOptional:String,
    									defaultValue:String,
    									reportId:String
    									):Boolean {
		
		var flag:Boolean = false;
		var maxMinFlag:Boolean = false;
		var gridItem:GridItem = new GridItem();
		
		var label:Label = new Label();
		label.text = labelKey;
		if(!XenosStringUtils.equals(uitype,"Hidden")){
			
			//use for alert message
			labelString[compCount] = labelKey;
			mendatoryField[compCount] = "true";
		}


		if(XenosStringUtils.equals(isOptional,"false")){
			//uiValidationString = uiValidationString.concat(idArray[idCount]+"/");
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
		
		
		if(XenosStringUtils.equals(uitype,"Text")||XenosStringUtils.equals(uitype,"TextBox")){	
			gridItem = new GridItem();
			gridItem.percentWidth = 30;	
			gridItem.horizontalScrollPolicy = "off";
			
			gridItem.name = "gridItem"+compCount;
			itemName[compCount] = gridItem.name;						
			
											
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
		}
		if(XenosStringUtils.equals(uitype,"Popup")){
			gridItem = new GridItem();
			gridItem.percentWidth = 30;	
			gridItem.horizontalScrollPolicy = "off";	
			gridItem.name = "gridItem"+compCount;
			itemName[compCount] = gridItem.name;						
			
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
			}else if(XenosStringUtils.equals(popupType,"currency")){
				var currenyHbox:CurrencyHBox = new CurrencyHBox();
				
				//add name
				currenyHbox.name = "currency"+compCount;
				compName[compCount] = currenyHbox.name;        
				compCount++;
				gridItem.addChild(currenyHbox);				
			}else if(XenosStringUtils.equals(popupType,"fund")){
				//changed by ssa
				var fundPopupHbox:FundPopUpHbox = new FundPopUpHbox();
				
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
			gridItem = new GridItem();
			gridItem.percentWidth = 30;		
			gridItem.horizontalScrollPolicy = "off";	
			gridItem.name = "gridItem"+compCount;
			itemName[compCount] = gridItem.name;							
								
			var dateField:DateField = new DateField();		 
			dateField.formatString = "YYYYMMDD";
			dateField.editable = true;  
			if(XenosStringUtils.equals(reportId,"INSDR")){
				dateField.width=100;
			}
			//dateField. = 8;
			//add name     
			dateField.name = "date"+compCount;
			compName[compCount] = dateField.name;        
			compCount++;			                 
			
			gridItem.addChild(dateField);				           							            
			gridRow.addChild(gridItem);
			flag = true;

			if(!XenosStringUtils.equals(defaultValue,"")) {
				dateField.text = defaultValue;
			}
	
		}
		if(XenosStringUtils.equals(uitype,"DropDown")){
			gridItem = new GridItem();
			gridItem.percentWidth = 30;	
			gridItem.horizontalScrollPolicy = "off";	
			gridItem.name = "gridItem"+compCount;
			itemName[compCount] = gridItem.name;				
					
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
				
				//treeCombo.id = labelKey;
				gridItem.addChild(treeCombo); 
			}else{
				//comboBox.id = labelKey;
				comboBox.labelField = "label";
				//find the index of defaultValue in the Collection
				
				comboBox.selectedIndex=getIndex(dropDownData,defaultValue);
				
				//add name
				comboBox.name = "combo"+compCount;
				
				comboBox.width = 300;
				compName[compCount] = comboBox.name;        
			    compCount++;
					
				comboBox.dataProvider = dropDownData;												
				gridItem.addChild(comboBox);  
			}	            
			gridRow.addChild(gridItem);
			flag = true;
		}
		if(XenosStringUtils.equals(uitype,"CheckBox")){
			gridItem = new GridItem();	
			gridItem.percentWidth = 30;	
			gridItem.horizontalScrollPolicy = "off";	
			gridItem.name = "gridItem"+compCount;
			itemName[compCount] = gridItem.name;				
					
			var checkBox:CheckBox = new CheckBox();
			
			//add name
			checkBox.name = "checkbox"+compCount;
			compName[compCount] = checkBox.name;        
			compCount++;
					                     
			gridItem.addChild(checkBox);				           
							            
			gridRow.addChild(gridItem);
			flag = true;
		}
		if(XenosStringUtils.equals(uitype,"Hidden")){

		    if(XenosStringUtils.isBlank(defaultValue)) {
				defaultValue = XenosStringUtils.EMPTY_STR
			}
 			hiddenObjects.addItem({index:compCount, value:defaultValue})
 			flag = false; 
		}		
    	return flag;
    	
    }
    
    /**
    * Retrive data from UI, validate and prepair request param string 
    * Special handeling implemented for reportid = "INSDR" ( XPXR-2614 )
    */
    private function prepairRequestParamString(alertString:String) : Boolean {
    	var valueFromUi:String = "";
    	var paramStr:String = "";
		var itemCount:int = 0;
		var isBlankAllowed:Boolean = true;
		var fromDate:String = XenosStringUtils.EMPTY_STR;
		var toDate:String = XenosStringUtils.EMPTY_STR;
		var tradeDateFrom:String = XenosStringUtils.EMPTY_STR;
		var tradeDateTo:String = XenosStringUtils.EMPTY_STR;
		var rqObj:Object = new Object();
		var securityspecifiedflag:Boolean = false;
		rqObj.reportId = this.reportIdList.selectedItem != null ? this.reportIdList.selectedItem.value : "";
			
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
			}else if(XenosStringUtils.equals(compName[itemCount],"treeCombo"+itemCount)){
				valueFromUi = ti.itemCombo.text;
			}else if(XenosStringUtils.equals(compName[itemCount],"combo"+itemCount)){
				valueFromUi = ti.selectedItem.value;
			}else if(XenosStringUtils.equals(compName[itemCount],"checkbox"+itemCount)){	
				//if(ti.selected) {
					valueFromUi = ti.selected;
				//} else {
				//	valueFromUi = "";
				//}		

			}else if(XenosStringUtils.equals(compName[itemCount],"date"+itemCount)&& !XenosStringUtils.isBlank(ti.text)){	
				/**
				 * XPXR-2614:For INSDR report validation required for fromDate should be less than value date &
				 * Security ID or both fromdate and todate must be specified.
				 */	
				 		
				if(DateUtils.isValidDate(ti.text)){	
					if(XenosStringUtils.equals(rqObj.reportId,"INSDR")){
						fromDate=ti.text;
					} else if(XenosStringUtils.equals(rqObj.reportId,"CFLPR") ){
						tradeDateFrom=ti.text;
					} else if(XenosStringUtils.equals(rqObj.reportId,"FGSTR") ){
						tradeDateTo=ti.text;
					} 			 			
					valueFromUi = ti.text;
				}else{
					if(XenosStringUtils.equals(rqObj.reportId,"INSDR")){
						XenosAlert.error("Illegal Date format " + ti.text);
						return false;
					}else{
						XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.reportui.msg.error.invalid.date'));
						return false;
					}
				}
			}else{	
				/**
				* XPXR-2614:For INSDR report validation required for fromDate should be less than value date &
				* Security ID or both fromdate and todate must be specified.
				* securityspecifiedflag keep track whether any one securityid is specied or not.
				*/
				if(XenosStringUtils.equals(rqObj.reportId,"INSDR")){
						if(!XenosStringUtils.isBlank(ti.text)){
							securityspecifiedflag = true;
						}
				}
				valueFromUi = ti.text;
			}
			
			//ui validation
			if(XenosStringUtils.equals(mendatoryField[itemCount],"false") && XenosStringUtils.isBlank(valueFromUi)){
				alertString = alertString.concat(labelString[itemCount] + " is missing\n");						
				isBlankAllowed = false;
			}
			
			//prepair request param string
			if(!(XenosStringUtils.equals(compName[itemCount],"checkbox"+itemCount)
				&& XenosStringUtils.equals(valueFromUi,"false")) 
				){
					
				paramStr = paramStr.concat("-" + shortOption[itemCount] + "," + valueFromUi + "\n");
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
				}else if(XenosStringUtils.equals(compName[itemCount],"treeCombo"+itemCount)){
					valueFromUi = ti.itemCombo.text;
				}else if(XenosStringUtils.equals(compName[itemCount],"combo"+itemCount)){
					valueFromUi = ti.selectedItem.value;
				}else if(XenosStringUtils.equals(compName[itemCount],"checkbox"+itemCount)){
				//	if(ti.selected) {
						valueFromUi = ti.selected;
				//	} else {
				//		valueFromUi = "";
				//	}
				}else if(XenosStringUtils.equals(compName[itemCount],"date"+itemCount)&& !XenosStringUtils.isBlank(ti.text)){
					if(DateUtils.isValidDate(ti.text)){
						/**
						 * XPXR-2614:For INSDR report validation required for fromDate should be less than value date &
						 * Security ID or both fromdate and todate must be specified.
						 * */
						if(XenosStringUtils.equals(rqObj.reportId,"INSDR")){
							toDate=ti.text;
						} else if(XenosStringUtils.equals(rqObj.reportId,"CFLPR") ){
							tradeDateTo=ti.text;
						} else if(XenosStringUtils.equals(rqObj.reportId,"FGSTR") ){
							tradeDateFrom=ti.text;
						} 		
						valueFromUi = ti.text;
					}else{
						if(XenosStringUtils.equals(rqObj.reportId,"INSDR")){
							XenosAlert.error("Illegal Date format " + ti.text);
							return false;
						}else{
							XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.reportui.msg.error.invalid.date'));
							return false;
						}
					}
				}else{	
					/**
					* XPXR-2614:For INSDR report validation required for fromDate should be less than value date &
					* Security ID or both fromdate and todate must be specified.
					* securityspecifiedflag keep track whether any one securityid is specied or not.
				    */
					if(XenosStringUtils.equals(rqObj.reportId,"INSDR")){
						if(!XenosStringUtils.isBlank(ti.text)){
							securityspecifiedflag = true;
						}
					}
					valueFromUi = ti.text;
				}
				
				//ui validation
				if(XenosStringUtils.equals(mendatoryField[itemCount],"false") && XenosStringUtils.isBlank(valueFromUi)){
					alertString = alertString.concat(labelString[itemCount] + " is missing\n");
					isBlankAllowed = false;
				}
				
				//prepair request param string
				
			
			//prepair request param string
			if(!(XenosStringUtils.equals(compName[itemCount],"checkbox"+itemCount)
				&& XenosStringUtils.equals(valueFromUi,"false")) 
				){
				paramStr = paramStr.concat("-" + shortOption[itemCount] + "," + valueFromUi + "\n");
			}
										
				
				itemCount++;
			}
		}
		if(XenosStringUtils.equals(rqObj.reportId,"INSDR")){
				if((XenosStringUtils.isBlank(fromDate) && !XenosStringUtils.isBlank(toDate)) || (!XenosStringUtils.isBlank(fromDate) && XenosStringUtils.isBlank(toDate))){
					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.batchreport.alert.validator.insdr.date.bothfromandto'));
						isBlankAllowed=false;
				}else if(!XenosStringUtils.isBlank(fromDate) && !XenosStringUtils.isBlank(toDate)){
					if(!isFromDateLessThanToDate(fromDate,toDate)){
						XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.batchreport.alert.validator.insdr.fromdatelessequaltodate'));
						isBlankAllowed=false;
					}else{
						isBlankAllowed=true;
					}
				}else if(securityspecifiedflag){
						isBlankAllowed=true;
				}else{
						XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.batchreport.alert.validator.insdr.securityidanddate'));
						isBlankAllowed=false;
					}
		}
		if(XenosStringUtils.equals(rqObj.reportId,"CFLPR") ){
			if (!XenosStringUtils.isBlank(tradeDateFrom) && !XenosStringUtils.isBlank(tradeDateTo)) {
				if(!isFromDateLessThanToDate(tradeDateFrom,tradeDateTo)){
						XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.batchreport.alert.validator.cflpr.tradedatefromlessequaltradedateto'));
						isBlankAllowed=false;
				}else{
					isBlankAllowed=true;
				}
			}
		}
		if(XenosStringUtils.equals(rqObj.reportId,"FGSTR") ){
			if (!XenosStringUtils.isBlank(tradeDateFrom) && !XenosStringUtils.isBlank(tradeDateTo)) {
				if(!isFromDateLessThanToDate(tradeDateFrom,tradeDateTo)){
						alertString = alertString.concat("Trade Date From should be less than or equal to Trade Date To"+ "\n");		
						isBlankAllowed=false;
				}else{
					// Do nothing. isBlankAllowed is already true
				}
			}
		}
			
		
		// Adding Hidden objects
		for each (var hObj:Object in hiddenObjects) {
			trace("Hidden Object : " + hObj.index + ";" + hObj.value)
			paramStr = paramStr.concat("-" + shortOption[hObj.index] + "," + hObj.value + "\n");
		}
		
		if(!XenosStringUtils.isBlank(alertString)){
			paramStr = "";
			XenosAlert.info(alertString);
		}
		requestParamString = paramStr;
		return isBlankAllowed;
    }     
       
       
    private function isFromDateLessThanToDate(fromdate:String,todate:String):Boolean{
    	if(!XenosStringUtils.isBlank(fromdate) && !XenosStringUtils.isBlank(todate)){
    		if(DateUtils.compareDates(fromdate,todate) !=1){
    			return true;
    		}else{
    			return false;
    		}
    	}else{
    		return true;
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
    	if(XenosStringUtils.equals(label,"type")&&XenosStringUtils.equals(uitype,"Popup")){
    		popupType = value;
    	}
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
	 * Click event on change of report id 
	 */
	private function onChangeReportId():void {
		errPage.removeError();
   		OfficeLM.visible = false;
   		OfficeLM.includeInLayout = false;
   		ReportName.visible = true;
   		ReportName.includeInLayout = true;
   		proceed.visible = true;
   		proceed.includeInLayout = true;
   		selectToSubmit.visible = false;
   		selectToSubmit.includeInLayout = false;
   		office.selectedItem = null;
   		lmImList.selectedItem = null;
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
		if(XenosStringUtils.equals(collection[count].value, value)){
			index = count;
			break;
		}
	}
	return index;
}