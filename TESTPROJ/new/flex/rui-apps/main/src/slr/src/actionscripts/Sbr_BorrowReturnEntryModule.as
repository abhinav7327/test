import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.OnDataChangeUtil;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.ref.popupImpl.StrategyPopUp;
import com.nri.rui.ref.popupImpl.TrdSsiPopup;
import com.nri.rui.slr.validator.TradeEntryValidator;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.formatters.CustomDateFormatter;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.collections.XMLListCollection;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.events.ResourceEvent;
import mx.managers.PopUpManager;
import mx.resources.ResourceBundle;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;
		
		
		
		 [Bindable]
		     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     
            [Bindable]private var mode : String = "ENTRY";
            [Bindable]private var securityList:ArrayCollection = new ArrayCollection();
            [Bindable]private var tradePkStr : String = "";
            [Bindable]private var selectedItemArray:Array; 
            [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
            [Bindable]public var returnContextItemForAmend:ArrayCollection = new ArrayCollection();
            [Bindable]public var softException:ArrayCollection= new ArrayCollection(); 
            private var keylist:ArrayCollection = new ArrayCollection();
            private var initcol:ArrayCollection = new ArrayCollection();
            private var item:Object = new Object();
            
            
             private function changeCurrentState():void{
						vstack.selectedChild = rslt;
			 }
			 
			 
			 /**
         * Load the Entry/Amend/Cancel according to 
         * the operational mode (e.g. Entry/Amend/Cancel)
         */  
		   public function loadAll():void {
	       	   parseUrlString();
	       	   fundAccPopUp.accountNo.setFocus();
	       	   super.setXenosEntryControl(new XenosEntry());
	       	   if(this.mode == 'ENTRY'){
	       	   	 this.dispatchEvent(new Event('entryInit'));
	       	   	 vstack.selectedChild = qry;
	       	   	 amendGrid.visible = false;
	       	   	 amendGrid.includeInLayout = false;
	       	   	  fundAccPopUp.accountNo.addEventListener(FlexEvent.VALUE_COMMIT, onChangeFundAccountNo);
		          securityCode.instrumentId.addEventListener(FlexEvent.VALUE_COMMIT, onChangeSecurityCode);
		          securityCode.instrumentPopup.addEventListener(MouseEvent.CLICK,securityImgClickHandler);
	       	   	  softWarning.removeWarning();
	       	   } else if(this.mode == 'AMEND'){
	       	   	 this.dispatchEvent(new Event('amendEntryInit'));
	       	   	 vstack.selectedChild = qry;
	       	   	 amendGrid.visible = true;
	       	   	 amendGrid.includeInLayout = true
	       	   	 entryGrid.visible = false;
	       	   	 entryGrid.includeInLayout = false;
	       	   	 securities.visible = false;
	       	   	 securities.includeInLayout = false;
	       	   	 cancelGrid.visible = false;
	       	   	 cancelGrid.includeInLayout = false;
	       	   	 fundAccPopUpForAmend.accountNo.addEventListener(FlexEvent.VALUE_COMMIT, onChangeFundAccountNoForAmend);
		         securityCodeForAmend.instrumentId.addEventListener(FlexEvent.VALUE_COMMIT, onChangeSecurityCodeForAmend);
		          securityCodeForAmend.instrumentPopup.addEventListener(MouseEvent.CLICK,securityImgClickHandlerForAmend);
	       	   	 softWarning.removeWarning();
	       	   } else {
	       	   	 vstack.selectedChild = qry; 
	       	     this.dispatchEvent(new Event('cancelEntryInit'));
	       	     confGrid.visible = false;
	       	   	 confGrid.includeInLayout = false;
	       	   	 confGridForAmend.visible = false;
	       	   	 confGridForAmend.includeInLayout = false;
	       	   	 secInfo.visible = false;
	       	   	 secInfo.includeInLayout = false;
	       	   	 softWarning.removeWarning();
	       	   }
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
                    if(params != null){
	                    for (var i:int = 0; i < params.length; i++) {
	                        var tempA:Array = params[i].split("=");  
	                        if (tempA[0] == "mode") {
	                            mode = tempA[1];
	                        }else if(tempA[0] == "tradePk"){
	                            this.tradePkStr = tempA[1];
	                        }else if(tempA[0] == "selectedItems"){
                                this.selectedItemArray = (tempA[1] as String).split(",");
                            } 
	                    }                    	
                    }else{
                    	mode = "ENTRY";
                    }                 
                } catch (e:Error) {
                    trace(e);
                }               
            }
            
            /**
            * This method fires the dispatchAction to initialize the
            * SBR Borrow Return Entry Screen (InitEntry-SEQ-1)
            */
            override public function preEntryInit():void{            	
		        var rndNo:Number= Math.random(); 
            	super.getInitHttpService().url = "slr/slrBorrowReturnEntryDispatch.action?";
            	var reqObject:Object = new Object();
            	reqObject.rnd = rndNo;
            	reqObject.method= "initialExecute";
		  		reqObject.mode="ENTRY";
		  		reqObject.SCREEN_KEY = 11145;
		  		super.getInitHttpService().request = reqObject;
            }
            
            /**
            * This method fires the dispatchaction to initialize the
            * SBR Borrow Return Amend Screen (InitAmend-SEQ-1)
            */
            override public function preAmendInit():void{  
                var rndNo:Number= Math.random(); 
                var reqObject:Object = new Object();
                if(this.mode == "AMEND"){
                    initLabel.text = this.parentApplication.xResourceManager.getKeyValue('slr.sbr.borrowreturn.label.tradeamend');          
                    super.getInitHttpService().url = "slr/slrBorrowReturnAmendDispatch.action?";
                    reqObject.rnd = rndNo;
                    reqObject.method= "borrowReturnTrdAmendQueryExecute";
                    reqObject.tradePk = this.tradePkStr;
			  		reqObject.SCREEN_KEY = 11157;
                    super.getInitHttpService().request = reqObject;
                }
            }
            
            /**
            * This method fires the dispatchaction to initialize the
            * Borrow Return Trade Cancel Screen (InitCancel-SEQ-1)
            */
             override public function preCancelInit():void{              
                this.back.includeInLayout = false;
                this.back.visible = false;
                changeCurrentState();                           
                var rndNo:Number= Math.random(); 
                super.getInitHttpService().url = "slr/slrBorrowReturnCancelDispatch.action?";
                var reqObject:Object = new Object();
                reqObject.rnd = rndNo;
                reqObject.method= "borrowReturnTrdCancelQueryExecute";
                reqObject.mode=this.mode;
                reqObject.SCREEN_KEY = 11158;
                var tradePkArray:Array = new Array();
                reqObject.tradePkArray = selectedItemArray;
                super.getInitHttpService().request = reqObject;
            } 
            
            /**
            * This method is pre-result handler for the SBR Borrow Return Entry
            * Screen. It generates the list of keys which will be populated 
            * during the initialization of the SBR Borrow Return Entry screen. 
            * (InitEntry-SEQ-2)
            */
	        override public function preEntryResultInit():Object{
	        	addCommonKeys();
	        	
	        	return keylist;
	        }
	        
	        /**
            * This method is pre-result handler for the SBR Borrow Return Cancel
            * Screen. It generates the list of keys which will be populated 
            * during the initialization of the SBR Borrow Return Cancel screen. 
            * (InitEntry-SEQ-2)
            */
	        override public function preCancelResultInit():Object{
	        	keylist.addItem("securities.security");
	        	return keylist;
	        }
	        
	        /**
            * This method is pre-result handler for the SBR Borrow Return Amend
            * Screen. It generates the list of keys which will be populated 
            * during the initialization of the Banking trade Amend screen. 
            * (InitAmend-SEQ-2)
            */
            override public function preAmendResultInit():Object{
            	addCommonKeys();
            	keylist.addItem("tradeVo.accountNoDisp");
		    	keylist.addItem("tradeVo.secCodeDisp");
		    	keylist.addItem("tradeVo.tradeTypePk");
		    	keylist.addItem("tradeVo.quantityDisp");
		    	keylist.addItem("tradeVo.rateDisp");
		    	keylist.addItem("tradeVo.callableFlag");
		    	keylist.addItem("tradeVo.caFlag");
		    	keylist.addItem("tradeVo.tradeDateDisp");
		    	keylist.addItem("tradeVo.valueDateDisp");
		    	keylist.addItem("tradeVo.remarks");
		    	keylist.addItem("tradeVo.referenceNo");
		    	keylist.addItem("tradeVo.versionNo");
		    	keylist.addItem("tradeVo.callableDateStr");
		    	keylist.addItem("tradeVo.externalRefNo");
		    	keylist.addItem("tradeVo.putThroughFlag");
		    	keylist.addItem("tradeVo.lendingDesk");
		    	keylist.addItem("tradeVo.modifiedContractFlag");
		    	
		    	return keylist;
            }
                 
                
	        
	        /**
	        * This method adds the common keys to a list
	        * which will be populated for both entry and amend
	        */
	        private function addCommonKeys():void{        	
		    	keylist = new ArrayCollection();
		    	keylist.addItem("tradeTypeValues.item");
		    	keylist.addItem("corpActionValues.item");
		    	keylist.addItem("cOrNcValues.item");
		    	keylist.addItem("putThroughFlagList.item");
		    	keylist.addItem("modifiedContractFlagList.item");
 	
	        }
	        
	         /**
	        * This method populates the elements of the SLR
	        * Trade Entry screen(mxml)
	        * from the map obtained from preEntryResultInit() (InitEntry-SEQ-3)
	        */
	        override public function postEntryResultInit(mapObj:Object): void{
	        	app.submitButtonInstance = submit;
	        	resetSecurity();
	        	commonInit(mapObj);
	        	//Show/Hide fields on Entry Screen after reset the entry screen/Initial Screen.
	        	showHideFieldsOnEntryScreen(this.tradeType.selectedItem.value);
	        }
	        
	        /**
            * This method populates the elements of the Borrow Return
            * Trade Amend screen(mxml)
            * from the map obtained from preAmendResultInit() (InitAmend-SEQ-3)
            */
            override public function postAmendResultInit(mapObj:Object): void{
            	app.submitButtonInstance = submit;
            	errPage.removeError();
            	softWarning.removeWarning();
	        	hb.visible = false;
	            hb.includeInLayout = false; 
	        	
	        	
	        	// initialize the fields before data population 
	        	/* Populate Trade type drop down list */
		    	initcol = new ArrayCollection();
	        	securityList = new ArrayCollection();
	        	item = new Object();
		    	if(mapObj[keylist.getItemAt(0)]!=null){
		    		if(mapObj[keylist.getItemAt(0)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(0)].toString());
		    		}
		    	}
		    	this.tradeTypeForAmend.dataProvider = initcol;
		    	this.tradeTypeForAmend.selectedIndex = 0;
		    	
		    	/* Populating C/NC Flag drop down*/
	        	initcol = new ArrayCollection();
	        	item = new Object();
	        	initcol.addItem({label:" ",value:" "});
		    	if(mapObj[keylist.getItemAt(2)]!=null){
		    		if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(2)].toString());
		    		}
		    	}
		    	this.cOrNcForAmend.dataProvider = initcol;
		    	this.cOrNcForAmend.selectedIndex = 0;
		    	this.referenceNo.text = mapObj[keylist.getItemAt(15)].toString()+"-"+mapObj[keylist.getItemAt(16)].toString();
		    	this.securityCodeForAmend.instrumentId.text = "";
		    	this.quantityForAmend.text = "";
		    	this.rateForAmend.text = "";
		    	this.remarksForAmend.text = "";
		    	this.fundAccPopUpForAmend.accountNo.text = "";
		    	
		    	this.tradeDateForAmend.selectedDate = null;
		    	this.tradeDateForAmend.text = "";
		    	this.valueDateForAmend.selectedDate = null;
		    	this.valueDateForAmend.text = "";
		    	this.CaflaglblForAmend.text = "";
		    	
		    	// data population
		    	var index:int=0;
		    	var tempCol:ArrayCollection = new ArrayCollection();
		    	this.fundAccPopUpForAmend.accountNo.text = mapObj[keylist.getItemAt(5)] != null ? mapObj[keylist.getItemAt(5)].toString() : "";
            	/* Populating Trade type drop down*/
                 if(mapObj[keylist.getItemAt(0)]!=null){
                    if(mapObj[keylist.getItemAt(0)] is ArrayCollection){
                        for each(var item4:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
                            tempCol.addItem(item4);
                            if(item4.value == mapObj[keylist.getItemAt(7)].toString()){
                                index = (mapObj[keylist.getItemAt(0)] as ArrayCollection).getItemIndex(item4);
                            }
                        }
                    }else{
                        tempCol.addItem(mapObj[keylist.getItemAt(0)]);
                        index = 0;
                    }
                }
                this.tradeTypeForAmend.dataProvider = tempCol;
                this.tradeTypeForAmend.selectedIndex = index;
                this.tradeDateForAmend.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(12)].toString());
                this.tradeDateForAmend.text = mapObj[keylist.getItemAt(12)];
            	this.valueDateForAmend.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(13)].toString());
            	this.valueDateForAmend.text = mapObj[keylist.getItemAt(13)];
                
            	this.securityCodeForAmend.instrumentId.text = mapObj[keylist.getItemAt(6)] != null ? mapObj[keylist.getItemAt(6)].toString() : "";
            	this.quantityForAmend.text = mapObj[keylist.getItemAt(8)] != null ? mapObj[keylist.getItemAt(8)].toString() : "";
            	if(mapObj[keylist.getItemAt(9)] != null){
            		this.rateForAmend.text = mapObj[keylist.getItemAt(9)] != null ? mapObj[keylist.getItemAt(9)].toString() : "";
            	}
            	
            	/* Populating Callable Flag drop down*/
                index = 0
                tempCol = new ArrayCollection();
                tempCol.addItem({label:" ",value:" "});
                 if(mapObj[keylist.getItemAt(2)]!=null){
                    if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
                        for each(var item:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
                            tempCol.addItem(item);
                            if(item.value == mapObj[keylist.getItemAt(10)].toString()){
                                index = (mapObj[keylist.getItemAt(2)] as ArrayCollection).getItemIndex(item);
                                index += 1;
                            }
                        }
                    }else{
                        tempCol.addItem(mapObj[keylist.getItemAt(2)]);
                        // For Trade Type Borrow , set default value as NC (the third value of the list - NULL , C and NC)
                        if (tempCol != null) {
		    	               index = getIndexOfLabelValueBean(tempCol , "NC");
		    	        }else{		    	
                        index = 0;
                    }
                }
                }
                this.cOrNcForAmend.dataProvider = tempCol;
                this.cOrNcForAmend.selectedIndex = index;
                
                this.CaflaglblForAmend.text = mapObj[keylist.getItemAt(11)] != null ? mapObj[keylist.getItemAt(11)].toString() : "";
                if(mapObj[keylist.getItemAt(14)] != null){
            		this.remarksForAmend.text = mapObj[keylist.getItemAt(14)] != null ? mapObj[keylist.getItemAt(14)].toString() : "";
            	}
            	
            	this.callableDateForAmend.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(17)].toString());
                this.callableDateForAmend.text = mapObj[keylist.getItemAt(17)];
                if(mapObj[keylist.getItemAt(7)].toString()== "BR") {
                	this.externalRefNoForAmendBorrow.text = mapObj[keylist.getItemAt(18)] != null ? mapObj[keylist.getItemAt(18)].toString() : XenosStringUtils.EMPTY_STR;
                } else {
                	this.externalRefNoForAmendReturn.text = mapObj[keylist.getItemAt(18)] != null ? mapObj[keylist.getItemAt(18)].toString() : XenosStringUtils.EMPTY_STR;
                }
                
                
                
		    	/* data population for Put Through Flag drop down*/
                index = 0
                tempCol = new ArrayCollection();
                tempCol.addItem({label:" ",value:" "});
                 if(mapObj[keylist.getItemAt(3)]!=null){
                    if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
                        for each(var item:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
                            tempCol.addItem(item);
                            if(item.value == mapObj[keylist.getItemAt(19)].toString()){
                                index = (mapObj[keylist.getItemAt(3)] as ArrayCollection).getItemIndex(item);
                                index += 1;
                            }
                        }
                    }else{
                        tempCol.addItem(mapObj[keylist.getItemAt(3)]);
                        index = 0;
                    }
                }
                this.putThroughFlagForAmend.dataProvider = tempCol;
                this.putThroughFlagForAmend.selectedIndex = index;	
                this.lendingDeskForAmend.text = mapObj[keylist.getItemAt(20)] != null ? mapObj[keylist.getItemAt(20)].toString() : XenosStringUtils.EMPTY_STR;
                this.modifiedContractFlagForAmend.text = mapObj[keylist.getItemAt(21)] != null ? mapObj[keylist.getItemAt(21)].toString() : XenosStringUtils.EMPTY_STR;
                
                //Show/Hide the fields depending on the Trade Type.
                showHideForTradeType(mapObj[keylist.getItemAt(7)].toString());
            	
                fundAccPopUpForAmend.accountNo.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT));
                securityCodeForAmend.instrumentId.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT));
            }
            
             /**
	        * This method populates the elements of the SLR
	        * Trade Cancel screen(mxml)
	        * from the map obtained from preCancelResultInit() (InitEntry-SEQ-3)
	        */
	        override public function postCancelResultInit(mapObj:Object): void{
	        	softWarning.removeWarning();
	        	  this.securityList = new ArrayCollection();
				    if(mapObj[keylist.getItemAt(0)] != null){
				    	initcol = (mapObj[keylist.getItemAt(0)]) as ArrayCollection;
				    	if(initcol != null){
				    		try {
			                      for each ( var it:XML in initcol) {
			                          securityList.addItem(it);
			                      }
			                  }catch(e:Error){
			                      XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.sbr.validation.error.loadingtradelist'));
			                }
				    	}
				    }
				 securityList.refresh();
	            uConfLabel.text= this.parentApplication.xResourceManager.getKeyValue('slr.sbr.borrowreturn.label.tradeCancel');
                uConfSubmit.includeInLayout = false;
                uConfSubmit.visible = false;
                cancelSubmit.visible = true;
                cancelSubmit.includeInLayout = true;
                app.submitButtonInstance = cancelSubmit; 
	        	
	        	
	        }
	        
	        /**
	        * Method for resetting the security info fields
	        */ 
	        private function resetSecurity():void{
	        	softWarning.removeWarning();
	        	this.securityCode.instrumentId.text = XenosStringUtils.EMPTY_STR;
	        	//this.tradeType. = XenosStringUtils.EMPTY_STR;
	        	this.quantity.text = XenosStringUtils.EMPTY_STR;
	        	this.rate.text = XenosStringUtils.EMPTY_STR;
	        	//this.cOrNc = XenosStringUtils.EMPTY_STR;
	        	this.remarks.text = XenosStringUtils.EMPTY_STR;
	        	this.externalRefNo.text = XenosStringUtils.EMPTY_STR;
	        	this.lendingDesk.text = XenosStringUtils.EMPTY_STR;
	        	this.callableDate.text = XenosStringUtils.EMPTY_STR;
	        } 
	        
	          override public function preEntry():void{
			 	setValidator();
			 	super.getSaveHttpService().url = "slr/slrBorrowReturnEntryDispatch.action?";
			 	var reqObj:Object = new Object();
			 	reqObj = populateRequestParam();
			 	reqObj.method = "submitBorrowReturn";
			 	reqObj.SCREEN_KEY = 11146;
	            super.getSaveHttpService().request = reqObj;
	            super.getSaveHttpService().method = "POST";
			 }
			 
			  override public function preAmend():void{
                var reqObj:Object = new Object();
                if(this.mode == 'AMEND'){
                    setValidator();
                    super.getSaveHttpService().url = "slr/slrBorrowReturnAmendDispatch.action?";  
                    reqObj = populateRequestParamForAmend(); 
                    reqObj.method = "borrowReturnAmendConfirm";
                    reqObj.SCREEN_KEY = 11159;
                    reqObj.mode=this.mode;
                    super.getSaveHttpService().request = reqObj;    
                }
             } 
             
             override public function preCancel():void{
                var reqObj:Object = new Object();
                    super.getSaveHttpService().url = "slr/slrBorrowReturnCancelDispatch.action?";  
                    reqObj.method = "borrowReturnCancelConfirm";
                    reqObj.mode=this.mode;
                     reqObj.SCREEN_KEY = 11161;
                    super.getSaveHttpService().request = reqObj;    
             } 
			 
	        
	        private function addCommonResultKeys():void{
	        	keylist = new ArrayCollection();
		    	keylist.addItem("tradeVo.accountNoDisp");
		    	keylist.addItem("tradeVo.secCodeDisp");
		    	keylist.addItem("tradeVo.tradeTypePk");
		    	keylist.addItem("tradeVo.quantityDisp");
		    	keylist.addItem("tradeVo.rateDisp");
		    	keylist.addItem("tradeVo.callableFlag");
		    	keylist.addItem("tradeVo.caFlag");
		    	keylist.addItem("tradeVo.tradeDateDisp");
		    	keylist.addItem("tradeVo.valueDateDisp");
		    	keylist.addItem("tradeVo.tradeTimeDisp");
		    	keylist.addItem("tradeVo.remarks");
		    	keylist.addItem("securities.security");
		    	keylist.addItem("tradeVo.accountNameDisp");
		    	keylist.addItem("tradeVo.brokerAccountNo");
		    	keylist.addItem("tradeVo.brokerAccountName");
		    	keylist.addItem("tradeVo.secCodeNameDisp");
		    	keylist.addItem("tradeVo.tradeTypeDisp");
		    	keylist.addItem("tradeVo.referenceNo");
		    	keylist.addItem("tradeVo.versionNo");
		    	keylist.addItem("tradeVo.callableDateStr");
		    	keylist.addItem("tradeVo.externalRefNo");
		    	keylist.addItem("tradeVo.putThroughFlag");
		    	keylist.addItem("tradeVo.lendingDesk");
		    	keylist.addItem("tradeVo.modifiedContractFlag");
		    	keylist.addItem("softExceptionList.item");
		    	
		    	
		    	
	        }
	        
	        private function populateRequestParam():Object{
	    	var reqObj:Object = new Object();
	    	
			reqObj.rnd = Math.random()+"";
			
	    	
	    	reqObj['tradeVo.tradeTypePk'] = this.tradeType.selectedItem != null ? StringUtil.trim(this.tradeType.selectedItem.value) : "";
	    	reqObj['tradeVo.tradeTypeDisp'] = this.tradeType.selectedItem != null ? StringUtil.trim(this.tradeType.selectedItem.label) : "";
	    	reqObj['tradeVo.accountNoDisp']  = this.fundAccPopUp.accountNo != null ? StringUtil.trim(this.fundAccPopUp.accountNo.text) : "";
	    	reqObj['tradeVo.tradeDateDisp']  = StringUtil.trim(this.tradeDate.text);
	    	/* reqObj['tradeVo.tradeTimeDisp']  = StringUtil.trim(this.tradeTime.text); */
	    	reqObj['tradeVo.valueDateDisp']  = StringUtil.trim(this.valueDate.text);
	    	reqObj['tradeVo.remarks']  = StringUtil.trim(this.remarks.text);
	    	reqObj['tradeVo.rateDisp']  = StringUtil.trim(this.rate.text);
	    	reqObj['tradeVo.callableFlag']  = this.cOrNc.selectedItem != null ? StringUtil.trim(this.cOrNc.selectedItem.value) : "";
	    	reqObj['tradeVo.caFlag']  = this.caFlagList.selectedItem != null ? StringUtil.trim(this.caFlagList.selectedItem.value) : "";
	    	reqObj['tradeVo.secCodeDisp']  = this.securityCode.instrumentId != null ? StringUtil.trim(this.securityCode.instrumentId.text) : "";
	    	reqObj['tradeVo.quantityDisp']  = StringUtil.trim(this.quantity.text);
	    	reqObj['tradeVo.callableDateStr']  = this.callableDate.text != null ? StringUtil.trim(this.callableDate.text) : XenosStringUtils.EMPTY_STR;
	    	reqObj['tradeVo.putThroughFlag']  = this.putThroughFlag.selectedItem != null ? StringUtil.trim(this.putThroughFlag.selectedItem.value) : XenosStringUtils.EMPTY_STR;
	    	reqObj['tradeVo.lendingDesk']  = this.lendingDesk.text != null ? StringUtil.trim(this.lendingDesk.text) : XenosStringUtils.EMPTY_STR;
	    	reqObj['tradeVo.externalRefNo']  = this.externalRefNo.text != null ? StringUtil.trim(this.externalRefNo.text) : XenosStringUtils.EMPTY_STR;
	    	reqObj['tradeVo.modifiedContractFlag']  = this.modifiedContractFlag.selectedItem != null ? StringUtil.trim(this.modifiedContractFlag.selectedItem.value) : XenosStringUtils.EMPTY_STR;
	    	
	    	return reqObj;
	    }
	    
	    private function populateRequestParamForAmend():Object{
	    	var reqObj:Object = new Object();
	    	
			reqObj.rnd = Math.random()+"";
			var externalRefNo:String = XenosStringUtils.EMPTY_STR;
			
			if(this.tradeTypeForAmend.selectedItem.value == "RT") {
				externalRefNo = this.externalRefNoForAmendReturn.text;
			} else {
				externalRefNo = this.externalRefNoForAmendBorrow.text;
			}
	    	reqObj['tradeVo.tradeTypePk'] = this.tradeTypeForAmend.selectedItem != null ? StringUtil.trim(this.tradeTypeForAmend.selectedItem.value) : "";
	    	reqObj['tradeVo.tradeTypeDisp'] = this.tradeTypeForAmend.selectedItem != null ? StringUtil.trim(this.tradeTypeForAmend.selectedItem.label) : "";
	    	reqObj['tradeVo.accountNoDisp']  = this.fundAccPopUpForAmend.accountNo != null ? StringUtil.trim(this.fundAccPopUpForAmend.accountNo.text) : "";
	    	reqObj['tradeVo.tradeDateDisp']  = StringUtil.trim(this.tradeDateForAmend.text);
	    	reqObj['tradeVo.valueDateDisp']  = StringUtil.trim(this.valueDateForAmend.text);
	    	reqObj['tradeVo.remarks']  = StringUtil.trim(this.remarksForAmend.text);
	    	reqObj['tradeVo.rateDisp']  = StringUtil.trim(this.rateForAmend.text);
	    	reqObj['tradeVo.callableFlag']  = this.cOrNcForAmend.selectedItem != null ? StringUtil.trim(this.cOrNcForAmend.selectedItem.value) : "";
	    	reqObj['tradeVo.caFlag']  = StringUtil.trim(this.CaflaglblForAmend.text);
	    	reqObj['tradeVo.secCodeDisp']  = this.securityCodeForAmend.instrumentId != null ? StringUtil.trim(this.securityCodeForAmend.instrumentId.text) : "";
	    	reqObj['tradeVo.quantityDisp']  = StringUtil.trim(this.quantityForAmend.text);
	    	reqObj['tradeVo.callableDateStr']  = this.callableDateForAmend.text != null ? StringUtil.trim(this.callableDateForAmend.text) : XenosStringUtils.EMPTY_STR;
	    	reqObj['tradeVo.externalRefNo']  =  StringUtil.trim(externalRefNo);
	    	reqObj['tradeVo.putThroughFlag']  = this.putThroughFlagForAmend.selectedItem != null ? StringUtil.trim(this.putThroughFlagForAmend.selectedItem.value) : XenosStringUtils.EMPTY_STR;
	    	reqObj['tradeVo.lendingDesk']  = this.lendingDeskForAmend.text != null ? StringUtil.trim(this.lendingDeskForAmend.text) : XenosStringUtils.EMPTY_STR;	    	
	    	reqObj['tradeVo.modifiedContractFlag']  = this.modifiedContractFlagForAmend.text != null ? StringUtil.trim(this.modifiedContractFlagForAmend.text) : XenosStringUtils.EMPTY_STR;
	    	
	    	
	    	return reqObj;
	    }
	    
	    override public function preEntryResultHandler():Object {
				 addCommonResultKeys() ;
				 return keylist;
			}
			
		override public function preAmendResultHandler():Object {
				 addCommonResultKeys() ;
				 return keylist;
			}
			
		override public function preCancelResultHandler():Object {
			 keylist.addItem("securities.security");
			 return keylist;
		   }
	    
	    override public function postEntryResultHandler(mapObj:Object):void {
	    		confGridForAmend.visible = false;
	    		confGridForAmend.includeInLayout = false;
	    		cancelGrid.visible = false;
	    		cancelGrid.includeInLayout = false;
	    		this.refnoforsysconf.visible = false;
				commonResult(mapObj);
			}
			
		override public function postAmendResultHandler(mapObj:Object):void {
				this.uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('slr.sbr.label.slrtradeamendusrconf');
				confGrid.visible = false;
				confGrid.includeInLayout = false;
				secInfo.visible = false;
				secInfo.includeInLayout = false;
				commonResult(mapObj);
			}
			
			 override public function postCancelResultHandler(mapObj:Object):void
            {
                submitCxlConfResult(mapObj);
            } 
            
            private function submitCxlConfResult(mapObj:Object):void{
	            if(mapObj!=null){    
	                if(mapObj["errorFlag"].toString() == "error"){
	                    usrConfErrPage.showError(mapObj["errorMsg"]);
	                    cancelSubmit.enabled = true;
	                    app.submitButtonInstance = cancelSubmit;
	                }else if(mapObj["errorFlag"].toString() == "noError"){
	                    uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('slr.sbr.label.slrtradecancelusrconf');
		                uConfLabel.includeInLayout = true;
		                uConfLabel.visible = true;
		                cancelSubmit.visible = false;
		                cancelSubmit.includeInLayout = false;
		                uCancelConfSubmit.visible = true;
		                uCancelConfSubmit.includeInLayout = true;
		                app.submitButtonInstance = uCancelConfSubmit;
		                sConfSubmit.includeInLayout = false;
		                sConfSubmit.visible = false;
		                sConfLabel.includeInLayout = false;
		                sConfLabel.visible = false;
	                    app.submitButtonInstance = uCancelConfSubmit;
	                    usrConfErrPage.clearError(super.getConfResultEvent());
	                    this.securityList = new ArrayCollection();
							    if(mapObj[keylist.getItemAt(0)] != null){
							    	initcol = (mapObj[keylist.getItemAt(0)]) as ArrayCollection;
							    	if(initcol != null){
							    		try {
						                      for each ( var it:XML in initcol) {
						                          securityList.addItem(it);
						                      }
						                  }catch(e:Error){
						                      XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.sbr.validation.error.loadingtradelist'));
						                }
							    	}
							    }
							 securityList.refresh();
				        }
	                }else{
	                    errPage.removeError();
	                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred'));
	                }           
	            }
            	
			
			private function commonResult(mapObj:Object):void{
		    	if(mapObj!=null){  
			    	if(mapObj["errorFlag"].toString() == "error"){
			    		errPage.showError(mapObj["errorMsg"]);
			    	}else if(mapObj["errorFlag"].toString() == "noError"){
			    	 errPage.clearError(super.getSaveResultEvent());
			    	 usrConfErrPage.clearError(super.getSaveResultEvent());
			    	 if(this.mode == 'AMEND'){
			    	 	commonResultPartForAmend(mapObj);
			    	  }else{			    			
		                   commonResultPart(mapObj);
		       		   }
					 changeCurrentState();
			    	}
			    	else{
			    		errPage.removeError();
			    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			    	}   		
		    	}
	        }
	  
	        private function commonResultPart(mapObj:Object):void{
			     var softWarn:ArrayCollection = new ArrayCollection();       
			     softWarning.removeWarning();       
			     softException = new ArrayCollection();
				    if(mapObj[keylist.getItemAt(24)] != null){
				    	softWarn = (mapObj[keylist.getItemAt(24).valueOf()]) as ArrayCollection;
				    	if(softWarn != null){
	                      for each ( var obj:Object in softWarn) {
	                          softException.addItem(obj.value);
	                      }
				    	}
				    }
				 softException.refresh(); 
				 softWarning.showWarning(softException);      		 
	              
	             this.uFundAccountNo.text = mapObj[keylist.getItemAt(0)].toString();
	             this.uFundAccountName.text = mapObj[keylist.getItemAt(12)].toString();
	             this.uBrokerAccountNo.text = mapObj[keylist.getItemAt(13)].toString();
	             this.uBrokerAccName.text = mapObj[keylist.getItemAt(14)].toString();
	             this.uValueDate.text = mapObj[keylist.getItemAt(8)].toString();
                 this.uCAFlag.text = mapObj[keylist.getItemAt(6)].toString();
                 this.uTradeDate.text = mapObj[keylist.getItemAt(7)].toString();
                 
                 
                 
                 
		         this.securityList = new ArrayCollection();
				    if(mapObj[keylist.getItemAt(11)] != null){
				    	initcol = (mapObj[keylist.getItemAt(11)]) as ArrayCollection;
				    	if(initcol != null){
				    		try {
			                      for each ( var it:XML in initcol) {
			                          securityList.addItem(it);
			                      }
			                  }catch(e:Error){
			                      XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.sbr.validation.error.loadingsecuritylist'));
			                }
				    	}
				    }
				 securityList.refresh();
	        } 
	        
	         private function commonResultPartForAmend(mapObj:Object):void{
	         	// Populate soft warning when External Ref No is duplicate (For Amend)
	         	var softWarn:ArrayCollection = new ArrayCollection();       
			     softWarning.removeWarning();       
			     softException = new ArrayCollection();
				    if(mapObj[keylist.getItemAt(24)] != null){
				    	softWarn = (mapObj[keylist.getItemAt(24).valueOf()]) as ArrayCollection;
				    	if(softWarn != null){
	                      for each ( var obj:Object in softWarn) {
	                          softException.addItem(obj.value);
	                      }
				    	}
				    }
				 softException.refresh(); 
				 softWarning.showWarning(softException);
        		 
	             this.ureferenceNo.text = mapObj[keylist.getItemAt(17)].toString()+"-"+mapObj[keylist.getItemAt(18)].toString();
	             this.uFundAccountNoForAmend.text = mapObj[keylist.getItemAt(0)].toString();
	             this.uFundAccountNameForAmend.text = mapObj[keylist.getItemAt(12)].toString();
	             this.uBrokerAccountNoForAmend.text = mapObj[keylist.getItemAt(13)].toString();
	             this.uBrokerAccNameForAmend.text = mapObj[keylist.getItemAt(14)].toString();
	             this.uValueDateForAmend.text = mapObj[keylist.getItemAt(8)].toString();
                 this.uCAFlagForAmend.text = mapObj[keylist.getItemAt(6)].toString();
                 this.uTradeDateForAmend.text = mapObj[keylist.getItemAt(7)].toString();
                 this.uSecurityCodeForAmend.text = mapObj[keylist.getItemAt(1)].toString();
	             this.uSecurityNameForAmend.text = mapObj[keylist.getItemAt(15)].toString();
                 this.uTradeTypeForAmend.text = mapObj[keylist.getItemAt(16)].toString();
                 this.uCorNcFlagForAmend.text = mapObj[keylist.getItemAt(5)].toString();
                 this.uQuantityForAmend.text = mapObj[keylist.getItemAt(3)].toString();
                 this.uRateForAmend.text = mapObj[keylist.getItemAt(4)].toString();
                 this.uRemarksForAmend.text = mapObj[keylist.getItemAt(10)].toString();
                 this.uCallableDateForAmend.text = mapObj[keylist.getItemAt(19)].toString();                
                 if(mapObj[keylist.getItemAt(2)].toString() == "RT") {
                 	this.uExternalRefNoForAmendReturn.text = mapObj[keylist.getItemAt(20)].toString();
                 } else {
                 	this.uExternalRefNoForAmendBorrow.text = mapObj[keylist.getItemAt(20)].toString();
                 }               
                 this.uPutThroughFlagForAmend.text = mapObj[keylist.getItemAt(21)].toString();
                 this.uLendingDeskForAmend.text = mapObj[keylist.getItemAt(22)].toString();
                 this.uModifiedContractFlagForAmend.text = mapObj[keylist.getItemAt(23)].toString();
                 //Show/Hide the fields in the Amend User/System confirmation screen.
                 showHideUserConfForTradeType(mapObj[keylist.getItemAt(2)].toString());            
	        } 
	        
	        
	        private function commonResultPartForCancel(mapObj:Object):void{
		         this.securityList = new ArrayCollection();
				    if(mapObj[keylist.getItemAt(0)] != null){
				    	initcol = (mapObj[keylist.getItemAt(0)]) as ArrayCollection;
				    	if(initcol != null){
				    		try {
			                      for each ( var it:XML in initcol) {
			                          securityList.addItem(it);
			                      }
			                  }catch(e:Error){
			                      XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.sbr.validation.error.loadingsecuritylist'));
			                }
				    	}
				    }
				 securityList.refresh();
	        } 
	        
	        
	        override public function preEntryConfirm():void {
				var reqObj :Object = new Object();
				super.getConfHttpService().url = "slr/slrBorrowReturnEntryDispatch.action?";  
				reqObj.method= "commitBorrowReturn";
				reqObj.rnd = Math.random()+"";
				reqObj.SCREEN_KEY = 11147;
	            super.getConfHttpService().request = reqObj;
			}
			
			override public function preAmendConfirm():void
            {
                var reqObj :Object = new Object();
                    super.getConfHttpService().url = "slr/slrBorrowReturnAmendDispatch.action?";  
					reqObj.SCREEN_KEY = 11160;
                    reqObj.method= "commitBorrowReturnAmend";
                    super.getConfHttpService().request = reqObj;
            }
            
            override public function preCancelConfirm():void
            {
                var reqObj :Object = new Object();
                super.getConfHttpService().url = "slr/slrBorrowReturnCancelDispatch.action?";  
				reqObj.SCREEN_KEY = 11162;
                reqObj.method= "commitBorrowReturnCancel";
                super.getConfHttpService().request = reqObj;
            }
			
			override public function preEntryConfirmResultHandler():Object{
				addCommonResultKeys();
				return keylist;
			}
			
			 override public function preConfirmAmendResultHandler():Object{
            addCommonResultKeys();
            return keylist;
   			}
   			override public function preConfirmCancelResultHandler():Object{
	           keylist.addItem("securities.security");
	            return keylist;
      		  }
			
			override public function postConfirmEntryResultHandler(mapObj:Object):void {
				submitUserConfResult(mapObj);
			}
			
			override public function postConfirmAmendResultHandler(mapObj:Object):void
            {
                this.sConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('slr.sbr.label.slrtradeamendsysconf');
                submitUserConfResult(mapObj);
            }
            
            override public function postConfirmCancelResultHandler(mapObj:Object):void
            {
                submitUserConfResult(mapObj);
            }
            
            
			 private function setValidator():void{
		
		 	 var validateModel:Object={
                            slrTradeEntry:{
                            	fundAccNo:this.fundAccPopUp.accountNo != null ? this.fundAccPopUp.accountNo.text : "",
                            	tradeDate:this.tradeDate.text,
                            	valueDate:this.valueDate.text,
                            	securityListSize:this.securityList.length
                            },
                            slrTradeAmend:{
                            	fundAccNo:this.fundAccPopUpForAmend.accountNo != null ? this.fundAccPopUpForAmend.accountNo.text : "",
                            	tradeDate:this.tradeDateForAmend.text,
                            	valueDate:this.valueDateForAmend.text,
                            	quantity:this.quantityForAmend.text,
                            	secrityCode:this.securityCodeForAmend.instrumentId.text
                            	
                            }
                           }; 
	         super._validator = new TradeEntryValidator();
	         super._validator.source = validateModel ;
	         if(this.mode == 'AMEND'){
	         	super._validator.property = "slrTradeAmend";
	         }else{
	         	super._validator.property = "slrTradeEntry";
	         }
	         
		}   
		
		
			
			
			private function submitUserConfResult(mapObj:Object):void{
		    	if(mapObj!=null){    
			    	if(mapObj["errorFlag"].toString() == "error"){
			    		 usrConfErrPage.showError(mapObj["errorMsg"]);
			    		 back.enabled = true;
                    if(mode=="CANCEL"){
                    	uCancelConfSubmit.enabled = true;
                    	app.submitButtonInstance = uCancelConfSubmit;
                    }else{
                    	uConfSubmit.enabled = true;
                    	app.submitButtonInstance = uConfSubmit;
                    }
			    	}else if(mapObj["errorFlag"].toString() == "noError"){
			    		
			    		softWarning.removeWarning();
 						if(mode!="CANCEL"){
	                      usrConfErrPage.clearError(super.getConfResultEvent());
	                      this.back.includeInLayout = false;
		                   this.back.visible = false;
		                   uConfSubmit.enabled = true;  
		                   back.enabled = true;
		                   uConfSubmit.includeInLayout = false;
		                   uConfSubmit.visible = false;
	                    } else if(mode=="CANCEL"){
	                    	sConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('slr.sbr.label.slrtradecancelsysconf');
			                cancelSubmit.visible = false;
			                cancelSubmit.includeInLayout = false;
			                uCancelConfSubmit.visible = false;
			                uCancelConfSubmit.includeInLayout = false;
	                    }			    	   
			    	    if(this.mode == 'AMEND'){
			    	 		commonResultPartForAmend(mapObj);
			    	  	}else if(this.mode == 'ENTRY'){	
			    	  		this.refnoforsysconf.visible = true;		    			
		                  	commonResultPart(mapObj);
		       		   	}else{
		       		   		commonResultPartForCancel(mapObj);
		       		   	}
			    	   this.back.includeInLayout = false;
			    	   this.back.visible = false;
					   uConfSubmit.enabled = true;	
					   back.enabled = true;
		               uConfLabel.includeInLayout = false;
		               uConfLabel.visible = false;
		               uConfSubmit.includeInLayout = false;
		               uConfSubmit.visible = false;
		               
		               sConfLabel.includeInLayout = true;
		               sConfLabel.visible = true;
		               sConfSubmit.includeInLayout = true;
		               sConfSubmit.visible = true; 
		               hb.visible = true;
	               	   hb.includeInLayout = true;  
		               app.submitButtonInstance = sConfSubmit;  
		               
		                
			    	}else{
			    		usrConfErrPage.removeError();
			    		uConfSubmit.enabled = true;
			    		back.enabled = true;
			    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('slr.label.erroroccured'));
			    	}    		
		    	} 
		    }
		     override public function doEntrySystemConfirm(e:Event):void {
			     super.preEntrySystemConfirm();
		    	 this.dispatchEvent(new Event('entryInit'));
	    		 this.back.includeInLayout = true;
	    		 this.back.visible = true;
	             uConfLabel.includeInLayout = true;
	             uConfLabel.visible = true;
	             uConfSubmit.includeInLayout = true;
	             uConfSubmit.visible = true;
	             sConfLabel.includeInLayout = false;
	             sConfLabel.visible = false;
	             sConfSubmit.includeInLayout = false;
	             sConfSubmit.visible = false;
	           	 vstack.selectedChild = qry;	
				 super.postEntrySystemConfirm(); 
			}
			
			override public function doAmendSystemConfirm(e:Event):void
            {
                this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
                this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
            }
			
			override public function doCancelSystemConfirm(e:Event):void
            {
               // this.parentDocument.owner.dispatchEvent(new Event("cancelSubmit")); 
                this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
            }
            
			override public function preResetEntry():void
		   {
		       var rndNo:Number= Math.random();
		  		super.getResetHttpService().url = "slr/slrBorrowReturnEntryDispatch.action?method=resetForm&rnd=" + rndNo; 
		   }
		   
		    override public function preResetAmend():void
           {
            var rndNo:Number= Math.random();
              if(this.mode == 'AMEND'){
              	super.getResetHttpService().url = "slr/slrBorrowReturnAmendDispatch.action?method=resetAmendment&rnd=" + rndNo;
              }
           }
		   
		    private function commonInit(mapObj:Object):void{
		    	
		    	errPage.removeError();
	        	hb.visible = false;
	            hb.includeInLayout = false; 
	        	
		    	
		    	/* Populating Corp Action drop down*/
	        	initcol = new ArrayCollection();
	        	item = new Object();
		    	if(mapObj[keylist.getItemAt(1)]!=null){
		    		if(mapObj[keylist.getItemAt(1)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(1)].toString());
		    		}
		    	}
		    	this.caFlagList.dataProvider = initcol;
		    	this.caFlagList.selectedIndex = 0;
		    	/* Populate Trade type drop down list */
		    	initcol = new ArrayCollection();
	        	securityList = new ArrayCollection();
	        	item = new Object();
		    	if(mapObj[keylist.getItemAt(0)]!=null){
		    		if(mapObj[keylist.getItemAt(0)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(0)].toString());
		    		}
		    	}
		    	this.tradeType.dataProvider = initcol;
		    	this.tradeType.selectedIndex = 0;
		    	
		    	/* Populating C/NC Flag drop down*/
		    	var indexForCallable:int=0;
	        	initcol = new ArrayCollection();
	        	item = new Object();
	        	initcol.addItem({label:" ",value:" "});
		    	if(mapObj[keylist.getItemAt(2)]!=null){
		    		if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(2)].toString());
		    		}
		    	}
		    	// For Trade Type Borrow , set default value as NC (the third value of the list - NULL , C and NC)
		    	 if (initcol != null) {
		    	     indexForCallable = getIndexOfLabelValueBean(initcol , "NC");
		    	  } else {		    	
		    	     indexForCallable = 0;
		    	  }
		    	this.cOrNc.dataProvider = initcol;
		    	this.cOrNc.selectedIndex = indexForCallable;
		    	
		    	/* Populating Put Through Flag drop down*/
	        	initcol = new ArrayCollection();
	        	item = new Object();
	        	initcol.addItem({label:" ",value:" "});
		    	if(mapObj[keylist.getItemAt(3)]!=null){
		    		if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(3)].toString());
		    		}
		    	}
		    	this.putThroughFlag.dataProvider = initcol;
		    	this.putThroughFlag.selectedIndex = 0;
		    	
		    	/* Populating Modified Contract Flag drop down*/
	        	initcol = new ArrayCollection();
	        	item = new Object();
	        	initcol.addItem({label:" ",value:" "});
		    	if(mapObj[keylist.getItemAt(4)]!=null){
		    		if(mapObj[keylist.getItemAt(4)] is ArrayCollection){
		    			for each(item in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
			    			initcol.addItem(item);
			    		}
		    		}else{
		    			initcol.addItem(mapObj[keylist.getItemAt(4)].toString());
		    		}
		    	}
		    	this.modifiedContractFlag.dataProvider = initcol;
		    	this.modifiedContractFlag.selectedIndex = 0;
		    	
		    	this.securityCode.instrumentId.text = "";
		    	this.quantity.text = "";
		    	this.rate.text = "";
		    	this.remarks.text = "";
		    	this.fundAccPopUp.accountNo.text = "";
		    	/* this.tradeTime.text = ""; */
		    	this.tradeDate.selectedDate = null;
		    	this.tradeDate.text = "";
		    	this.valueDate.selectedDate = null;
		    	this.valueDate.text = "";
		    	
		    	
	        }
	        
	     private function doBack():void{
	  	 app.submitButtonInstance = submit;
	     vstack.selectedChild = qry;
	  }
	  
	   /**
	  * This is the method to pass the Collection of data items
	  * through the context to the account popup. This will be implemented as per specifdic  
	  * requriment. 
	  */
	    private function populateInvActContext():ArrayCollection {
	        //pass the context data to the popup
	        var myContextList:ArrayCollection = new ArrayCollection(); 
	      
	        //passing counter party type                
	        var cpTypeArray:Array = new Array(1);
	            cpTypeArray[0]="INTERNAL";
	            //cpTypeArray[1]="CLIENT";
	        myContextList.addItem(new HiddenObject("invCpTypeContext",cpTypeArray));
           
            // passing longShortFlag
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
	  * This is the method to pass the Collection of data items
	  * through the context to the account popup. This will be implemented as per specifdic  
	  * requriment. 
	  */
	    private function populateInvActContextForAmend():ArrayCollection {
	        //pass the context data to the popup
	        var myContextList:ArrayCollection = new ArrayCollection(); 
	      
	        //passing counter party type                
	        var cpTypeArray:Array = new Array(1);
	            cpTypeArray[0]="INTERNAL";
	            //cpTypeArray[1]="CLIENT";
	        myContextList.addItem(new HiddenObject("invCpTypeContext",cpTypeArray));
           
            // passing longShortFlag
	       var longShortFlagArray:Array = new Array(1);
                  longShortFlagArray[0]="S";
              myContextList.addItem(new HiddenObject("longShortFlagContext",longShortFlagArray));

	        //passing account status                
	        var actStatusArray:Array = new Array(1);
	        actStatusArray[0]="OPEN";
	        myContextList.addItem(new HiddenObject("actStatusContext",actStatusArray));
	        return myContextList;
	    }
	    
	    
	     private function doSave():void{
	     	if(uConfSubmit.enabled == true){
	    		this.mode == 'ENTRY' ?  this.dispatchEvent(new Event('entryConf')) :  this.dispatchEvent(new Event('amendEntryConf'));
	    	}
	    	uConfSubmit.enabled = false; 
	    	back.enabled = false;
	    }
	    
	     private function addSecurity():void{
	     	// validate quantity and rate
	     	var isValidated:Boolean = true;
	     	var reqSend:Boolean = true;
	    	reqSend = validateOnAddToNewSecurities();
	    	if(reqSend){
	    		if((!numValQty.handleNumericField(numberFormatter))||
	     	(!numValRate.handleNumericField(numberFormatter))){
	     		isValidated =  false;
	     	}
	    	}
	    	if(reqSend && isValidated){
	    		var reqObj:Object = new Object();
		    	reqObj = populateRequestParam();
		    	reqObj.rnd = Math.random()+"";
		    	if(this.mode=='ENTRY'){
			    	reqObj.method = "addSecurity";
		    	}
		    	/* else if(this.mode=='amend'){
		    		addSecurityRequest.url="slr/slrContractEntryAmendDispatch.action?";
		    		reqObj.method = "addSecurityForAmend";
		    	} */
		    	addSecurityRequest.request = reqObj;
		    	addSecurityRequest.send();
	    	}
	    }
	    
	    private function validateOnAddToNewSecurities():Boolean {
	    	 var validationMessage:String = XenosStringUtils.EMPTY_STR;
	    	
	    	if(XenosStringUtils.isBlank(securityCode.instrumentId.text))
	    	{
	    	validationMessage+=this.parentApplication.xResourceManager.getKeyValue('slr.sbr.validation.error.seccodeempty');	
	    			
	    	}
	    	if( XenosStringUtils.isBlank(quantity.text))
	    	{
	    	validationMessage+="\n"+ this.parentApplication.xResourceManager.getKeyValue('slr.sbr.validation.error.lqtyempty');	
	     	}
	     	if(!XenosStringUtils.isBlank(this.callableDate.text)){
	     		var formatData:String ="";
	     		var dateformat:CustomDateFormatter = new CustomDateFormatter();
	            dateformat.formatString = "YYYYMMDD";
	            formatData = "";	            
	            formatData = dateformat.format(CustomDateFormatter.customizedInputDateString(this.callableDate.text));
	            if(!DateUtils.isValidDate(StringUtil.trim(this.callableDate.text))) {
	            	validationMessage+="\n"+ this.parentApplication.xResourceManager.getKeyValue('slr.sbr.validation.error.callabledate');
	                //results.push(new ValidationResult(true, 
	                    //"tradeDate", "illegalTradeDate", Application.application.xResourceManager.getKeyValue('slr.sbr.validation.error.illegaltrddateformat') + value.tradeDate));
	            }
        	}
	    	if(XenosStringUtils.isBlank(validationMessage)){
	    		return true;
	    	}else{
	    		XenosAlert.error(validationMessage);
	    		return false;
	    	} 
	    	return true;
	    	 }
	    	
	    	
	    	 private function loadSecurity(event:ResultEvent):void{
	    	 if(event != null){
	    		if(event.result != null){
	    			if(event.result.borrowReturnEntryActionForm != null){
	    				errPage.clearError(super.getInitResultEvent());
	    				securityList = new ArrayCollection();
	    				if(event.result.borrowReturnEntryActionForm.securities != null){
	    					if(event.result.borrowReturnEntryActionForm.securities.security != null){
	    						if(event.result.borrowReturnEntryActionForm.securities.security is ArrayCollection){
	    							securityList = (event.result.borrowReturnEntryActionForm.securities.security) as ArrayCollection;
	    						}else{
	    							securityList.addItem(event.result.borrowReturnEntryActionForm.securities.security);
	    						}
	    					}
	    				}
	    				securityList.refresh();
	    				this.securityCode.instrumentId.text = "";
	    				this.quantity.text = "";
	    				this.rate.text = "";
	    				this.remarks.text = "";
	    				this.callableDate.text = XenosStringUtils.EMPTY_STR;
	    				//this.putThroughFlag.text = XenosStringUtils.EMPTY_STR;
	    				this.lendingDesk.text = XenosStringUtils.EMPTY_STR;
	    				this.externalRefNo.text = XenosStringUtils.EMPTY_STR;
	    				//this.modifiedContractFlag.text = XenosStringUtils.EMPTY_STR;
	    				var tempList:ArrayCollection = new ArrayCollection();
	    				// populate trade type
	    				if(event.result.borrowReturnEntryActionForm.tradeTypeValues != null){
	    					if(event.result.borrowReturnEntryActionForm.tradeTypeValues.item != null){
	    						if(event.result.borrowReturnEntryActionForm.tradeTypeValues.item is ArrayCollection){
	    							tempList = (event.result.borrowReturnEntryActionForm.tradeTypeValues.item) as ArrayCollection;
	    						}else{
	    							tempList.addItem(event.result.borrowReturnEntryActionForm.tradeTypeValues.item);
	    						}
	    					}
	    				}
	    				this.tradeType.dataProvider = tempList;
	    				this.tradeType.selectedIndex = 0;
	    				showHideFieldsOnEntryScreen(this.tradeType.selectedItem.value);
	    				// populate C/NC Flag list
	    				tempList = new ArrayCollection();
	    				item = new Object();
	    				var lst:ArrayCollection = new ArrayCollection();
	    				lst.addItem({label:" ",value:" "});
	    				if(event.result.borrowReturnEntryActionForm.cOrNcValues != null){
	    					if(event.result.borrowReturnEntryActionForm.cOrNcValues.item != null){
	    						if(event.result.borrowReturnEntryActionForm.cOrNcValues.item is ArrayCollection){
	    							tempList = (event.result.borrowReturnEntryActionForm.cOrNcValues.item) as ArrayCollection;
	    						}else{
	    							tempList.addItem(event.result.borrowReturnEntryActionForm.cOrNcValues.item);
	    						}
	    					}
	    				}
	    				for each(item in tempList){
			    			lst.addItem(item);
			    		}
	    				this.cOrNc.dataProvider = lst;    
	    				this.cOrNc.selectedIndex = 2;
	    			}else if(event.result.XenosErrors != null){
	    				errPage.clearError(super.getInitResultEvent());
	    				if(event.result.XenosErrors.Errors != null){
							if(event.result.XenosErrors.Errors.error != null){
								var errorInfoList : ArrayCollection = new ArrayCollection();
								if(event.result.XenosErrors.Errors.error is ArrayCollection){
			    					errorInfoList = event.result.XenosErrors.Errors.error as ArrayCollection;
			    				}else{
			    					errorInfoList.addItem(event.result.XenosErrors.Errors.error);
			    				}
							}
						}
						errPage.showError(errorInfoList);
	    			}else{
	    				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    			}
	    		}else{
	    			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    		}
	    	}else{
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	} 
	    }
	    
	    
	    public function editSecurity(data:Object):void{
			if(this.mode == 'ENTRY'){
				editSecurityRequest.url = 'slr/slrBorrowReturnEntryDispatch.action?';
				
			}
			editSecurityRequest.request = populateReqForSecurityEdit(data);
    		editSecurityRequest.send();
		}
		
		private function populateReqForSecurityEdit(data:Object):Object{
	    	var reqObj : Object = new Object();
	    	reqObj.rnd = Math.random()+"";
	    	reqObj.method= "editSecurity";
    		reqObj.rowNo = this.securityList.getItemIndex(data);
	    	return reqObj;
	    }
	    
	    
	    private function loadEditedSecurity(event:ResultEvent):void{
	    	 if(event != null){
	    		if(event.result != null){
	    			if(event.result.borrowReturnEntryActionForm != null){
	    				errPage.clearError(super.getInitResultEvent());
	    				securityList = new ArrayCollection();
	    				if(event.result.borrowReturnEntryActionForm.securities != null){
	    					if(event.result.borrowReturnEntryActionForm.securities.security != null){
	    						if(event.result.borrowReturnEntryActionForm.securities.security is ArrayCollection){
	    							securityList = (event.result.borrowReturnEntryActionForm.securities.security) as ArrayCollection;
	    						}else{
	    							securityList.addItem(event.result.borrowReturnEntryActionForm.securities.security);
	    						}
	    					}
	    				}
	    				securityList.refresh();
	    				this.securityCode.instrumentId.text = event.result.borrowReturnEntryActionForm.tradeVo.secCodeDisp;
	    				this.quantity.text = event.result.borrowReturnEntryActionForm.tradeVo.quantityDisp;
	    				this.rate.text = event.result.borrowReturnEntryActionForm.tradeVo.rateDisp;
	    				this.remarks.text = event.result.borrowReturnEntryActionForm.tradeVo.remarks;
	    				
	    				this.callableDate.text = event.result.borrowReturnEntryActionForm.tradeVo.callableDateStr;
	    				this.lendingDesk.text = event.result.borrowReturnEntryActionForm.tradeVo.lendingDesk;
	    				this.externalRefNo.text = event.result.borrowReturnEntryActionForm.tradeVo.externalRefNo;
	    				// populate trade type
	        		    var index:int=0;
	        	        item = new Object();
	        	         var tradeTypeList:ArrayCollection = new ArrayCollection();
	        	         var trdType:String = event.result.borrowReturnEntryActionForm.tradeVo.tradeTypePk;
	        	         if(event.result.borrowReturnEntryActionForm.tradeTypeValues.item is ArrayCollection){
	    							tradeTypeList = (event.result.borrowReturnEntryActionForm.tradeTypeValues.item) as ArrayCollection;
	    						}else{
	    							tradeTypeList.addItem(event.result.borrowReturnEntryActionForm.tradeTypeValues.item);
	    						}
	        	         if(tradeTypeList!=null){
		    		
		    		 	for each(item in (tradeTypeList as ArrayCollection)){
				    		if(item.value == trdType.toString()){
				    			index = (tradeTypeList as ArrayCollection).getItemIndex(item);
				    		}
		    	     	 }
		    	      }
		    			this.tradeType.dataProvider = tradeTypeList;
	        			this.tradeType.selectedIndex = index;
	        			//Show/Hide fields after clicked on edit button	.
	        			showHideFieldsOnEntryScreenAfterEdit(this.tradeType.selectedItem.value); 
	    				
	    			// populate Callable flag type
	        		    index=0;
	        	        item = new Object();
	        	         var callableFlagList:ArrayCollection = new ArrayCollection();
	    				var lst:ArrayCollection = new ArrayCollection();
	    				lst.addItem({label:" ",value:" "});
	        	         var callableFlag:String = event.result.borrowReturnEntryActionForm.tradeVo.callableFlag;
	        	         if(event.result.borrowReturnEntryActionForm.cOrNcValues.item is ArrayCollection){
	    							callableFlagList = (event.result.borrowReturnEntryActionForm.cOrNcValues.item) as ArrayCollection;
	    						}else{
	    							callableFlagList.addItem(event.result.borrowReturnEntryActionForm.cOrNcValues.item);
	    						}
	        	         if(callableFlagList!=null){
		    		
		    		 	for each(item in (callableFlagList as ArrayCollection)){
				    		if(item.value == callableFlag.toString()){
				    			index = (callableFlagList as ArrayCollection).getItemIndex(item);
				    		}
		    	     	 }
		    	      }
		    	      
		    	       item = new Object();
		    	        for each(item in callableFlagList){
			    			lst.addItem(item);
			    		}
		    			this.cOrNc.dataProvider = lst;
	        			this.cOrNc.selectedIndex = index+1;	
	    				
	        			// populate Put Through Flag
	        		    index=0;
	        	        item = new Object();
	        	        var putThroughFlagList:ArrayCollection = new ArrayCollection();
	    				var putThroughFlag:ArrayCollection = new ArrayCollection();
	    				putThroughFlag.addItem({label:" ",value:" "});
	        	        var putThroughFlagStr:String = event.result.borrowReturnEntryActionForm.tradeVo.putThroughFlag;
        	            if(event.result.borrowReturnEntryActionForm.putThroughFlagList.item is ArrayCollection){
    							putThroughFlagList = (event.result.borrowReturnEntryActionForm.putThroughFlagList.item) as ArrayCollection;
    					} else {
    							putThroughFlagList.addItem(event.result.borrowReturnEntryActionForm.putThroughFlagList.item);
    					}
	        	        if(putThroughFlagList !=null){		    		
			    		 	for each(item in (putThroughFlagList as ArrayCollection)){
					    		if(item.value == putThroughFlagStr.toString()){
					    			index = (putThroughFlagList as ArrayCollection).getItemIndex(item);
					    		}
			    	     	 }
		    	       }		    	      
		    	       item = new Object();
		    	        for each(item in putThroughFlagList){
			    			putThroughFlag.addItem(item);
			    		}
		    			this.putThroughFlag.dataProvider = putThroughFlag;
	        			this.putThroughFlag.selectedIndex = index+1;
	    		
	        			// populate Modified Contract Flag
	        		    index=0;
	        	        item = new Object();
	        	        var modifiedContractFlagList:ArrayCollection = new ArrayCollection();
	    				var modifiedContractFlag:ArrayCollection = new ArrayCollection();
	    				modifiedContractFlag.addItem({label:" ",value:" "});
	        	        var modifiedContractFlagStr:String = event.result.borrowReturnEntryActionForm.tradeVo.modifiedContractFlag;
        	            if(event.result.borrowReturnEntryActionForm.modifiedContractFlagList.item is ArrayCollection){
    							modifiedContractFlagList = (event.result.borrowReturnEntryActionForm.modifiedContractFlagList.item) as ArrayCollection;
    					} else {
    							modifiedContractFlagList.addItem(event.result.borrowReturnEntryActionForm.modifiedContractFlagList.item);
    					}
	        	        if(modifiedContractFlagList !=null){		    		
			    		 	for each(item in (modifiedContractFlagList as ArrayCollection)){
					    		if(item.value == modifiedContractFlagStr.toString()){
					    			index = (modifiedContractFlagList as ArrayCollection).getItemIndex(item);
					    		}
			    	     	 }
		    	       }		    	      
		    	       item = new Object();
		    	        for each(item in modifiedContractFlagList){
			    			modifiedContractFlag.addItem(item);
			    		}
		    			this.modifiedContractFlag.dataProvider = modifiedContractFlag;
	        			this.modifiedContractFlag.selectedIndex = index+1;
	    			}else if(event.result.XenosErrors != null){
	    				errPage.clearError(super.getInitResultEvent());
	    				if(event.result.XenosErrors.Errors != null){
							if(event.result.XenosErrors.Errors.error != null){
								var errorInfoList : ArrayCollection = new ArrayCollection();
								if(event.result.XenosErrors.Errors.error is ArrayCollection){
			    					errorInfoList = event.result.XenosErrors.Errors.error as ArrayCollection;
			    				}else{
			    					errorInfoList.addItem(event.result.XenosErrors.Errors.error);
			    				}
							}
						}
						errPage.showError(errorInfoList);
	    			}else{
	    				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    			}
	    		}else{
	    			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    		}
	    	}else{
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	} 
	    }
		
		public function deleteSecurity(data:Object):void{
			if(this.mode == 'ENTRY'){
				deleteSecurityRequest.url = 'slr/slrBorrowReturnEntryDispatch.action?';
			}
			deleteSecurityRequest.request = populateReqForSecurityDelete(data);
    		deleteSecurityRequest.send();
		}
		
		private function populateReqForSecurityDelete(data:Object):Object{
	    	var reqObj : Object = new Object();
	    	reqObj.rnd = Math.random()+"";
	    	reqObj.method= "deleteSecurity";
    		reqObj.rowNo = this.securityList.getItemIndex(data);
	    	return reqObj;
	    }
	    
	    private function loadDeletedSecurity(event:ResultEvent):void{
	    	 if(event != null){
	    		if(event.result != null){
	    			if(event.result.borrowReturnEntryActionForm != null){
	    				errPage.clearError(super.getInitResultEvent());
	    				securityList = new ArrayCollection();
	    				if(event.result.borrowReturnEntryActionForm.securities != null){
	    					if(event.result.borrowReturnEntryActionForm.securities.security != null){
	    						if(event.result.borrowReturnEntryActionForm.securities.security is ArrayCollection){
	    							securityList = (event.result.borrowReturnEntryActionForm.securities.security) as ArrayCollection;
	    						}else{
	    							securityList.addItem(event.result.borrowReturnEntryActionForm.securities.security);
	    						}
	    					}
	    				}
	    				securityList.refresh();
	    				this.securityCode.instrumentId.text = "";
	    				this.quantity.text = "";
	    				this.rate.text = "";
	    				this.remarks.text = "";
	    				var tempList:ArrayCollection = new ArrayCollection();
	    				// populate trade type
	    				if(event.result.borrowReturnEntryActionForm.tradeTypeValues != null){
	    					if(event.result.borrowReturnEntryActionForm.tradeTypeValues.item != null){
	    						if(event.result.borrowReturnEntryActionForm.tradeTypeValues.item is ArrayCollection){
	    							tempList = (event.result.borrowReturnEntryActionForm.tradeTypeValues.item) as ArrayCollection;
	    						}else{
	    							tempList.addItem(event.result.borrowReturnEntryActionForm.tradeTypeValues.item);
	    						}
	    					}
	    				}
	    				this.tradeType.dataProvider = tempList;
	    				// populate C/NC Flag list
	    				tempList = new ArrayCollection();
	    				if(event.result.borrowReturnEntryActionForm.cOrNcValues != null){
	    					if(event.result.borrowReturnEntryActionForm.cOrNcValues.item != null){
	    						if(event.result.borrowReturnEntryActionForm.cOrNcValues.item is ArrayCollection){
	    							tempList = (event.result.borrowReturnEntryActionForm.cOrNcValues.item) as ArrayCollection;
	    						}else{
	    							tempList.addItem(event.result.borrowReturnEntryActionForm.cOrNcValues.item);
	    						}
	    					}
	    				}
	    			}else if(event.result.XenosErrors != null){
	    				errPage.clearError(super.getInitResultEvent());
	    				if(event.result.XenosErrors.Errors != null){
							if(event.result.XenosErrors.Errors.error != null){
								var errorInfoList : ArrayCollection = new ArrayCollection();
								if(event.result.XenosErrors.Errors.error is ArrayCollection){
			    					errorInfoList = event.result.XenosErrors.Errors.error as ArrayCollection;
			    				}else{
			    					errorInfoList.addItem(event.result.XenosErrors.Errors.error);
			    				}
							}
						}
						errPage.showError(errorInfoList);
	    			}else{
	    				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    			}
	    		}else{
	    			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    		}
	    	}else{
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	} 
	    }
	    
	      private function onChangeFundAccountNo(event:Event):void{
    		OnDataChangeUtil.onChangeFundAccountNo(fundAccName,fundAccPopUp.accountNo.text); 
//    		fundAccName.setFocus();
	    }
	    
	      private function onChangeSecurityCode(event:Event):void{
	    	OnDataChangeUtil.onChangeSecurityCode(secName,securityCode.instrumentId.text); 
//	    	secName.setFocus();
	    } 
	    
	     private function securityImgClickHandler(event:MouseEvent):void{
        this.securityCode.instrumentId.addEventListener(FlexEvent.VALUE_COMMIT,setFocusOnParent);
       }
       
        private function setFocusOnParent(event:Event):void{
        (TextInput(event.currentTarget)).setFocus();
        (TextInput(event.currentTarget)).removeEventListener(FlexEvent.VALUE_COMMIT,setFocusOnParent); 
       }
       
        private function onChangeFundAccountNoForAmend(event:Event):void{
    		OnDataChangeUtil.onChangeFundAccountNo(fundAccNameForAmend,fundAccPopUpForAmend.accountNo.text); 
    		fundAccNameForAmend.setFocus();
	    }
	    
	      private function onChangeSecurityCodeForAmend(event:Event):void{
	    	OnDataChangeUtil.onChangeSecurityCode(secNameForAmend,securityCodeForAmend.instrumentId.text); 
	    	secNameForAmend.setFocus();
	    } 
	    
	     private function securityImgClickHandlerForAmend(event:MouseEvent):void{
        this.securityCodeForAmend.instrumentId.addEventListener(FlexEvent.VALUE_COMMIT,setFocusOnParentForAmend);
       }
        private function setFocusOnParentForAmend(event:Event):void{
        (TextInput(event.currentTarget)).setFocus();
        (TextInput(event.currentTarget)).removeEventListener(FlexEvent.VALUE_COMMIT,setFocusOnParentForAmend);
       }
       // Show/Hide the fields on Entry screen after change the value of trade type drop down list.
       private function changeTradeType():void {
         if(this.tradeType.selectedItem != null){
	       	   showHideFieldsOnEntryScreen(this.tradeType.selectedItem.value)
          }
       }      
       /**
		 * Show/Hide the fields in the Borrow/Return Entry Screen depending on the Trade Type.
		 * Callable Date , Put Through Flag , Lending Desk , Modified Contract Flag and Callable Flag should be shown only for Trade Type Borrow.
		 * Trade Type can be two types - 1. Borrow (value: BR) and 2. Return (value: RT).
		 */
       private function showHideFieldsOnEntryScreen(value:String):void {
       	if(XenosStringUtils.equals(value , "RT")) {
	       		showHideFieldsForTradeTypeReturn();
	       		this.callableDate.text = XenosStringUtils.EMPTY_STR;
	       		this.lendingDesk.text = XenosStringUtils.EMPTY_STR;
	       		this.externalRefNo.text = XenosStringUtils.EMPTY_STR;
	       		this.cOrNc.selectedIndex = 0;
	       		this.putThroughFlag.selectedIndex = 0;
	       		this.modifiedContractFlag.selectedIndex = 0;
	       	} else {
	       		showHideFieldsForTradeTypeBorrow();
	       		this.callableDate.text = XenosStringUtils.EMPTY_STR;
	       		this.lendingDesk.text = XenosStringUtils.EMPTY_STR;
	       		this.externalRefNo.text = XenosStringUtils.EMPTY_STR;
	       		this.cOrNc.selectedIndex = 2;
	       		this.putThroughFlag.selectedIndex = 0;
	       		this.modifiedContractFlag.selectedIndex = 0;
	       	}   
       }
       
	     /**
		 * Calculates the index of a label value bean given its value, within a given 
		 * array collection of such beans.
		 * Returns 0 if the value is null or empty string.
		 */
		private function getIndexOfLabelValueBean(collection:ArrayCollection, value:String):int {
			var index:int = 0;
			if (value == null || value == XenosStringUtils.EMPTY_STR) {
				return index;
			}
			for (var count:int = 0; count < collection.length; count++) {
				var bean:Object = collection.getItemAt(count);
				if (bean['value'] == value) {
					index = count;
					break;
				}
			}
			return index;
		}
		/**
		 * Show/Hide the fields in the Amend Screen depending on the Trade Type.
		 * This API is called after clicked on Edit button in the Amend Screen.
		 * Trade Type can be two types - 1. Borrow (value: BR) and 2. Return (value: RT).
		 */
		private function showHideForTradeType(value:String):void {
	       	if(XenosStringUtils.equals(value,"RT")) {
	       		this.cOrNcForAmend.visible = false;
	       		this.cOrNcForAmend.includeInLayout = false;
	       		this.cOrNcAmendForLebel.visible = false;
	       		this.cOrNcAmendForLebel.includeInLayout = false;
	       		this.gridForCallableDateExternalRefBorrow.visible = false;
	       		this.gridForCallableDateExternalRefBorrow.includeInLayout = false;
	       		this.gridForExternalRefReturn.visible = true;
	       		this.gridForExternalRefReturn.includeInLayout = true;
	       		this.gridForPutThroughLendingDesk.visible = false;
	       		this.gridForPutThroughLendingDesk.includeInLayout = false;   
	       		this.gridForModifiedContractFlag.visible = false;
	       		this.gridForModifiedContractFlag.includeInLayout = false;    		
	       	} else {
	       		this.cOrNcForAmend.visible = true;
	       		this.cOrNcForAmend.includeInLayout = true;
	       		this.cOrNcAmendForLebel.visible = true;
	       		this.cOrNcAmendForLebel.includeInLayout = true;
	       		this.gridForCallableDateExternalRefBorrow.visible = true;
	       		this.gridForCallableDateExternalRefBorrow.includeInLayout = true;
	       		this.gridForExternalRefReturn.visible = false;
	       		this.gridForExternalRefReturn.includeInLayout = false;
	       		this.gridForPutThroughLendingDesk.visible = true;
	       		this.gridForPutThroughLendingDesk.includeInLayout = true;   
	       		this.gridForModifiedContractFlag.visible = true;
	       		this.gridForModifiedContractFlag.includeInLayout = true;	
          }
       }
       /**
		 * Show/Hide the fields in the Amend User Confirmation/System Confirmation Screen depending on the Trade Type.
		 * Trade Type can be two types - 1. Borrow (value BR) and 2. Return (value RT).
		 */
		private function showHideUserConfForTradeType(value:String):void {
	       	if(XenosStringUtils.equals(value,"RT")) {
	       		this.uCorNcFlagForAmend.visible = false;
	       		this.uCorNcFlagForAmend.includeInLayout = false;
	       		this.uCorNcFlagAmendForLebel.visible = false;
	       		this.uCorNcFlagAmendForLebel.includeInLayout = false;
	       		this.uGridForCallableDateExternalRefBorrow.visible = false;
	       		this.uGridForCallableDateExternalRefBorrow.includeInLayout = false;
	       		this.uGridForCallableDateExternalRefReturn.visible = true;
	       		this.uGridForCallableDateExternalRefReturn.includeInLayout = true;
	       		this.uGridForPutThroughLendingDesk.visible = false;
	       		this.uGridForPutThroughLendingDesk.includeInLayout = false;   
	       		this.uGridForModifiedContractFlag.visible = false;
	       		this.uGridForModifiedContractFlag.includeInLayout = false;    		
	       	} else {
	       		this.uCorNcFlagForAmend.visible = true;
	       		this.uCorNcFlagForAmend.includeInLayout = true;
	       		this.uCorNcFlagAmendForLebel.visible = true;
	       		this.uCorNcFlagAmendForLebel.includeInLayout = true;
	       		this.uGridForCallableDateExternalRefBorrow.visible = true;
	       		this.uGridForCallableDateExternalRefBorrow.includeInLayout = true;
	       		this.uGridForCallableDateExternalRefReturn.visible = false;
	       		this.uGridForCallableDateExternalRefReturn.includeInLayout = false;
	       		this.uGridForPutThroughLendingDesk.visible = true;
	       		this.uGridForPutThroughLendingDesk.includeInLayout = true;   
	       		this.uGridForModifiedContractFlag.visible = true;
	       		this.uGridForModifiedContractFlag.includeInLayout = true;	
          }
       } 
       
       //In Borrow/Return Amend screen if C/NC is changed from "C" to "NC" then Callble Date should be null.
       private function changeCallableFlag():void {
         if(this.cOrNcForAmend.selectedItem != null){
	       	if(XenosStringUtils.equals(this.cOrNcForAmend.selectedItem.value,"NC")) {
	       		this.callableDateForAmend.text = XenosStringUtils.EMPTY_STR;
	       	}     	
          }
       }
       /**
		 * Show the fields in the Borrow/Return Entry screen for Trade Type Borrow.
		 * Callable Flag , Callable Date , Put Through Flag , Lending Desk and Modified Contract Flag are 
		 * only applicable for trade type Borrow (value : BR).
		 */
        private function showHideFieldsForTradeTypeBorrow():void {
        	// Show hide fields for Trade Type BORROW. Default value of the Trade Type is Borrow
       		this.callableFlagId.visible = true;
       		this.callableFlagId.includeInLayout = true;
       		this.callableFlagGrid.visible = true;
       		this.callableFlagGrid.includeInLayout = true;
       		this.callableDateId.visible = true;
       		this.callableDateId.includeInLayout = true;
       		this.callableDateGrid.visible = true;
       		this.callableDateGrid.includeInLayout = true;
       		this.putThroughFlagId.visible = true;
       		this.putThroughFlagId.includeInLayout = true;
       		this.putThroughFlagGrid.visible = true;
       		this.putThroughFlagGrid.includeInLayout = true;
       		this.lendingDeskId.visible = true;
       		this.lendingDeskId.includeInLayout = true;
       		this.lendingDeskGrid.visible = true;
       		this.lendingDeskGrid.includeInLayout = true;
       		this.modifiedContractFlagId.visible = true;
       		this.modifiedContractFlagId.includeInLayout = true;
       		this.modifiedContractFlagGrid.visible = true;
       		this.modifiedContractFlagGrid.includeInLayout = true;  
       }
       /**
		 * Hide the fields in the Borrow/Return Entry screen for Trade Type Return.
		 * Callable Flag , Callable Date , Put Through Flag , Lending Desk and Modified Contract Flag are 
		 * only applicable for trade type Borrow (value : BR).
		 */
       private function showHideFieldsForTradeTypeReturn():void {
        	// Show hide fields for Trade Type RETURN. 
       		this.callableFlagId.visible = false;
       		this.callableFlagId.includeInLayout = false;
       		this.callableFlagGrid.visible = false;
       		this.callableFlagGrid.includeInLayout = false;
       		this.callableDateId.visible = false;
       		this.callableDateId.includeInLayout = false;
       		this.callableDateGrid.visible = false;
       		this.callableDateGrid.includeInLayout = false;
       		this.putThroughFlagId.visible = false;
       		this.putThroughFlagId.includeInLayout = false;
       		this.putThroughFlagGrid.visible = false;
       		this.putThroughFlagGrid.includeInLayout = false;
       		this.lendingDeskId.visible = false;
       		this.lendingDeskId.includeInLayout = false;
       		this.lendingDeskGrid.visible = false;
       		this.lendingDeskGrid.includeInLayout = false;
       		this.modifiedContractFlagId.visible = false;
       		this.modifiedContractFlagId.includeInLayout = false;
       		this.modifiedContractFlagGrid.visible = false;
       		this.modifiedContractFlagGrid.includeInLayout = false;  
       }
       /**
		 * Show/Hide the fields in the Entry Screen after click on Edit button along with the Security Info .
		 * This API is called after result comes from the server . First populates the Trade Type drop down , 
		 * then Show/Hide the fields in the Entry screen depending on the value of Trade Type . 
		 * Trade Type can be two types - 1. Borrow (value BR) and 2. Return (value RT).
		 */
        private function showHideFieldsOnEntryScreenAfterEdit(value:String):void {
	       	if(XenosStringUtils.equals(value ,"RT")) {
       		   // Show/Hide fields for Trade Type RETURN.
	       		showHideFieldsForTradeTypeReturn();
	       		//following fields are not applicable for Trade Type Return.
	       		this.cOrNc.selectedIndex = 0;
	       		this.putThroughFlag.selectedIndex = 0;
	       		this.modifiedContractFlag.selectedIndex = 0;
	       		this.lendingDesk.text = XenosStringUtils.EMPTY_STR;
	       		this.callableDate.text = XenosStringUtils.EMPTY_STR;
	       	  } else {
	       		// Show/Hide fields for Trade Type BORROW.
	       		showHideFieldsForTradeTypeBorrow();
		      }   
       }