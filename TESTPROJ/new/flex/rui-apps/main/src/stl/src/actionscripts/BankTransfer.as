// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;

import flash.events.Event;
import flash.events.FocusEvent;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;
import mx.events.ResourceEvent;
import mx.resources.ResourceBundle;

import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.stl.validators.BankTransferEntryValidator;
			
	 /* The following imports sometimes vanish from this file, which leads to build error.
   
	import com.nri.rui.core.controls.XenosEntry;
	import com.nri.rui.stl.validators.BankTransferEntryValidator;
	
   */ 
	  
	  
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    [Bindable]private var rowNum : String = "";
    [Bindable]private var mode : String = "entry";
    [Bindable]private var csiPk : String = "";
    [Bindable]private var qtyTemp:String = null;
    [Bindable]private var strValueDate:String = null;
    [Bindable]private static var iCount:int = 0;
    [Bindable]private static var iError:int = 0;
    
    private var keylist:ArrayCollection = new ArrayCollection();
    
    
    public function loadAll():void {
    	parseUrlString();
    	super.setXenosEntryControl(new XenosEntry());
    	if(this.mode == 'entry'){
       	   	 this.dispatchEvent(new Event('entryInit'));
       	   	 vstack.selectedChild = qry;
	     } else {
	     	this.dispatchEvent(new Event('cancelEntryInit'));
	     }
	     frombankaccount.accountNo.addEventListener(FocusEvent.FOCUS_IN,populateFromBank);
   	   	 tobankaccount.accountNo.addEventListener(FocusEvent.FOCUS_IN,populateToBank);
    }
	  
	  private function changeCurrentState():void{
				//hdbox1.selectedChild = this.rslt;
				//currentState = "result";
				
				this.vstack.selectedChild = rslt;
				if(this.mode == "entry") {
					this.subVstack.selectedChild = dispEntry;
				} else if(this.mode == "cancel") {
					this.subVstack.selectedChild = disp;
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
            var s:String = this.loaderInfo.url.toString();
            //XenosAlert.info("Load Url : "+ this.loaderInfo.url.toString());
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
                    } else if(tempA[0] == "csiPk") {
                        this.csiPk = tempA[1];
                    } else if(tempA[0] == "itemIndex") {
                        this.rowNum = tempA[1];
                    }
                }                    	
            } else {
            	mode = "entry";
            }                 

        } catch (e:Error) {
            trace(e);
        }               
    }
            
        override public function preEntryInit():void {
        	
        	var reqObject:Object = new Object();
        	reqObject.rnd = Math.random();
        	reqObject.SCREEN_KEY = 736;
        	super.getInitHttpService().request = reqObject;
        	super.getInitHttpService().url = "stl/bankTransferEntryDispatch.action?method=initialExecute&mode=entry";
        
	    }
        
        override public function preCancelInit():void {
	        this.back.includeInLayout = false;
		    this.back.visible = false;
		    changeCurrentState(); 			             	
	        var rndNo:Number= Math.random(); 
        	super.getInitHttpService().url = "stl/bankTransferCancelDispatch.action?";
        	var reqObject:Object = new Object();
        	reqObject.rnd = rndNo;
        	reqObject.method= "doDelete";
	  		reqObject.index = this.rowNum;
	  		reqObject.csiPk = this.csiPk;
	  		reqObject.SCREEN_KEY = 892;
	  		//XenosAlert.info("*** csiPk= "+this.csiPk+", rowNum = "+this.rowNum);
	  		super.getInitHttpService().request = reqObject;
        }
        
        private function addCommonKeys():void {        	
	    	keylist = new ArrayCollection();
	    	keylist.addItem("deliveryMethodList.item");
	    	keylist.addItem("dropDownListValues.inxTransmissionList.item");
	    	keylist.addItem("autoTrxValues.item");
	    	keylist.addItem("valueDate");
        }
        
        override public function preEntryResultInit():Object{
        	addCommonKeys(); 
        	return keylist;
        }
        
        
        override public function preCancelResultInit():Object {
        	addCommonResultKesForCancel();         	
        	return keylist;
        }
        
        
        private function commonInit(mapObj:Object):void {
        	
        	//errPage.clearError(super.getInitResultEvent());
        	
        	var index:int=0;
        	var initcol:ArrayCollection = new ArrayCollection();
	    	index=-1;
	    	
	    	for each(var itemFrm:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)) {
	    		initcol.addItem(itemFrm);
	    	}
	    	form.dataProvider  = initcol;
	    	
	    	var arr:ArrayCollection = new ArrayCollection();
	    	arr.addItem({label:" ", value: " "});
	    	for each(var itemTran:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)) {
	    		arr.addItem(itemTran);
	    	}
	    	transmissionRequired.dataProvider  = arr;
	    	
        	var autoTranArr:ArrayCollection = new ArrayCollection();
        	for each(var itemAuto:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)) {
	    		autoTranArr.addItem(itemAuto);
	    	}
	    	autoTransmission.dataProvider  = autoTranArr;
	    	
	    	if(iCount==0) {
	    		strValueDate =  mapObj[keylist.getItemAt(3)];
	    	}
	    	this.valueDate.text = strValueDate;
	    	
	    	++iCount;
        }
        
        override public function postEntryResultInit(mapObj:Object): void {
        	app.submitButtonInstance = submit;
        	commonInit(mapObj);
        }
        
        
        private function commonResultPart(mapObj:Object):void {
        	 //XenosAlert.info("*** keylist.length = "+keylist.length+", mode = "+this.mode);
        	 if(this.mode == "entry") {
        	 	populateConfirmationDetailsForEntry(mapObj);
        	 } else if(this.mode == "cancel") {
        	 	populateConfirmationDetailsForCancel(mapObj);
        	 }
        }
        
        /** This method is for populating User Confirmation Screen for Entry **/
        private function populateConfirmationDetailsForEntry(mapObj:Object):void {
        	
        	this.uConfEntryFromBankAccountNo.text 		 = mapObj[keylist.getItemAt(0)].toString();
        	this.uConfEntryFromBankCode.text      		 = mapObj[keylist.getItemAt(1)].toString();
        	this.uConfEntryFromBankName.text      		 = mapObj[keylist.getItemAt(2)].toString();
        	
        	this.uConfEntryToBankAccountNo.text   		 = mapObj[keylist.getItemAt(3)].toString();
        	this.uConfEntryToBankCode.text        		 = mapObj[keylist.getItemAt(4)].toString();
        	this.uConfEntryToBankName.text        		 = mapObj[keylist.getItemAt(5)].toString();
        	
        	this.uConfEntrySecurityCode.text      		 = mapObj[keylist.getItemAt(6)].toString();
        	this.uConfEntryQuantity.text          		 = qtyTemp;
        	
        	this.uConfEntryAutoTransmission.text  		 = mapObj[keylist.getItemAt(9)].toString();
        	this.uConfEntryValueDate.text         		 = mapObj[keylist.getItemAt(10)].toString();
        	this.uConfEntryRemarks.text           		 = mapObj[keylist.getItemAt(11)].toString();
        	this.uConfEntryForm.text              		 = mapObj[keylist.getItemAt(12)].toString();
        	
        	this.uConfEntryTransmissionReqdReceive.text  = mapObj[keylist.getItemAt(8)].toString();
        	this.uConfEntryTransmissionReqdDeliver.text  = mapObj[keylist.getItemAt(13)].toString();
        }
        
        /** This method is for populating User Confirmation Screen for Cancel **/
        private function populateConfirmationDetailsForCancel(mapObj:Object):void {
	         this.uConfAccountNo.text          = mapObj[keylist.getItemAt(0)].toString();
	         this.uConfValueDate.text          = mapObj[keylist.getItemAt(12)].toString();
	         this.uConfSecurityCode.text       = mapObj[keylist.getItemAt(7)].toString();
	         this.uConfSecurityName.text       = mapObj[keylist.getItemAt(8)].toString();
	         this.uConfQuantity.text           = mapObj[keylist.getItemAt(5)].toString();
	         this.uConfInxTransmission.text    = mapObj[keylist.getItemAt(11)].toString();
	         this.uConfRemarks.text            = mapObj[keylist.getItemAt(6)].toString();
	         // To Bank Details
	         this.uConfToBank.text = mapObj[keylist.getItemAt(13)].toString();
	         this.uConfToBankName.text = mapObj[keylist.getItemAt(14)].toString();
	         this.uConfToBankStlAccnt.text = mapObj[keylist.getItemAt(3)].toString();
	         // From Bank Details
	         this.uConfFromBank.text = mapObj[keylist.getItemAt(15)].toString();
	         this.uConfFromBankName.text = mapObj[keylist.getItemAt(16)].toString();
	         this.uConfFromBankStlAccnt.text = mapObj[keylist.getItemAt(4)].toString();
        }
        
        override public function postCancelResultInit(mapObj:Object): void {
        	//XenosAlert.info("postCancelResultInit");
        	commonResultPart(mapObj);
        	uConfSubmit.includeInLayout = false;
        	uConfSubmit.visible = false;
        	cancelSubmit.visible = true;
        	cancelSubmit.includeInLayout = true;
        	app.submitButtonInstance = cancelSubmit;
        }
        
        /** This method is for Entry **/
        private function addCommonResultKes():void {
	    	keylist = new ArrayCollection();
	    	keylist.addItem("ownAccount");
	    	keylist.addItem("ownBankCode");
	    	keylist.addItem("ownBankName");
	    	keylist.addItem("cpAccount");
	    	keylist.addItem("cpBankCode");
	    	keylist.addItem("cpBankName");
	    	keylist.addItem("securityId");
	    	keylist.addItem("quantity");
	    	keylist.addItem("transmissionReqdStr");
	    	keylist.addItem("autoTransmissionStr");
	    	keylist.addItem("valueDateFromUI");
	    	keylist.addItem("remarks");
	    	keylist.addItem("deliveryMethod");
	    	keylist.addItem("transmissionReqdDeliver");
        }
        
        /** This method is for Cancel **/
        private function addCommonResultKesForCancel():void {
	    	keylist = new ArrayCollection();
	    	keylist.addItem("bankTransferQuerySummaryView.accountNo");
	    	keylist.addItem("bankTransferQuerySummaryView.accBalanceTypeDisp");
	    	keylist.addItem("bankTransferQuerySummaryView.clientSettlementInfoPk");
	    	keylist.addItem("bankTransferQuerySummaryView.cpBankSettleAcc");
	    	keylist.addItem("bankTransferQuerySummaryView.ourBankSettleAcc");
	    	keylist.addItem("bankTransferQuerySummaryView.quantityDispStr");
	    	keylist.addItem("bankTransferQuerySummaryView.remarks");
	    	keylist.addItem("bankTransferQuerySummaryView.securityCode");
	    	keylist.addItem("bankTransferQuerySummaryView.securityShortName");
	    	keylist.addItem("bankTransferQuerySummaryView.settlementReferenceNo");
	    	keylist.addItem("bankTransferQuerySummaryView.status");
	    	keylist.addItem("bankTransferQuerySummaryView.transmissionReqdFlag");
	    	keylist.addItem("bankTransferQuerySummaryView.valueDateStr");
	    	keylist.addItem("bankTransferQuerySummaryView.cpBankCode");
	    	keylist.addItem("bankTransferQuerySummaryView.cpBankName");
	    	keylist.addItem("bankTransferQuerySummaryView.ourBankCode");
	    	keylist.addItem("bankTransferQuerySummaryView.ourBankName");
        }
        
        private function commonResult(mapObj:Object):void {
		 	//XenosAlert.info("commonResult");
	    	if(mapObj!=null) {
		    	if(mapObj["errorFlag"].toString() == "error") {
		    		//result = mapObj["errorMsg"] .toString();
		    		if(mode != "cancel"){
		    		  errPage.showError(mapObj["errorMsg"]);		    			
		    		} else {
		    			XenosAlert.error(mapObj["errorMsg"]);
		    		}
		    	} else if(mapObj["errorFlag"].toString() == "noError") {
			    	 errPage.clearError(super.getSaveResultEvent());			    			
		             commonResultPart(mapObj);
					 changeCurrentState();
		    	} else {
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.datanotfound'));
		    	}    		
	    	}
        }
        
       
        
    	private function setValidator():void {
    		//XenosAlert.info("*** Inside setValidator ***"+this.valueDate.text);
			var validateModel:Object={
	                            	 bankTransferEntry:{
	                                 
		                                 fromBankAccount:this.frombankaccount.accountNo.text,
		                                 toBankAccount:this.tobankaccount.accountNo.text,
		                                 securityCode:this.security.instrumentId.text,
		                                 valueDate:this.valueDate.text,
		                                 transmissionRequired:this.transmissionRequired.selectedItem != null ? this.transmissionRequired.value : "",
		                                 form:this.form.selectedItem != null ? this.form.selectedItem.value : "",
		                                 remarks:this.remarks.text,
		                                 quantity:this.quantity.text
		                                 
		                            }
	                           }; 
	         super._validator = new BankTransferEntryValidator();
	         super._validator.source = validateModel ;
	         super._validator.property = "bankTransferEntry";
		  
		}
		 override public function preEntry():void {
		 	setValidator();
		 	super.getSaveHttpService().url = "stl/bankTransferEntryDispatch.action?";  
            super.getSaveHttpService().request  = populateRequestParams();
		 }
		 
		 override public function preCancel():void {
		 	//XenosAlert.info("preCancel");
		 	//setValidator();
		 	super._validator = null;
		 	super.getSaveHttpService().url = "stl/bankTransferCancelDispatch.action?"; 
		 	var reqObj:Object = new Object();
		 	reqObj.method="doSubmitDelete";
		 	reqObj.SCREEN_KEY = 741;
		 	//reqObj.mode=this.mode;
            super.getSaveHttpService().request  =reqObj;
		 }
		 
		 
		override public function preEntryResultHandler():Object {
			 addCommonResultKes();
			 return keylist;
		}
		
		
		override public function postCancelResultHandler(mapObj:Object):void {
			//XenosAlert.info("postCancelResultHandler");
			submitUserConfResult(mapObj);
			
			this.parentDocument.title =this.parentApplication.xResourceManager.getKeyValue('stl.label.banktransfer.cancel.userconfirmation');
			uConfLabel.includeInLayout = true;
			uConfLabel.visible = true;
        	cancelSubmit.visible = false;
        	cancelSubmit.includeInLayout = false;
        	uCancelConfSubmit.visible = true;
        	uCancelConfSubmit.includeInLayout = true;
        	sConfSubmit.includeInLayout = false;
        	sConfSubmit.visible = false;
        	sConfLabel.includeInLayout = false;
        	sConfLabel.visible = false;
	        app.submitButtonInstance = uCancelConfSubmit;
		} 
		
		override public function postEntryResultHandler(mapObj:Object):void {
			commonResult(mapObj);
			
			uConfLabel.includeInLayout = true;
			uConfLabel.visible = true;
			uConfImg.includeInLayout = false;
			uConfImg.visible = false;
			usrCnfMessage.text = this.parentApplication.xResourceManager.getKeyValue('stl.label.banktransfer.entry.userconfirmation');
			uConfSubmit.visible = true;
			uConfSubmit.includeInLayout = true;
			app.submitButtonInstance = uConfSubmit;
		}
		
		
		override public function preEntryConfirm():void {
			uConfSubmit.enabled = false;
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "stl/bankTransferEntryDispatch.action?";  
			reqObj.method= "doConfirmEntry";
			reqObj.SCREEN_KEY = 738;
            super.getConfHttpService().request = reqObj;
		}
		
		override public function preCancelConfirm():void {
			uCancelConfSubmit.enabled = false;
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "stl/bankTransferCancelDispatch.action?";  
			reqObj.method = "doConfirmDelete";
			reqObj.SCREEN_KEY = 742;
            super.getConfHttpService().request = reqObj;
		}
		
		override public function preEntryConfirmResultHandler():Object {
			keylist = new ArrayCollection();
	    	keylist.addItem("csiVO.settlementReferenceNo");
	    	keylist.addItem("csiVO.versionNo");
	    	keylist.addItem("transmissionReqdStr");
	    	keylist.addItem("transmissionReqdDeliver");
	    	keylist.addItem("autoTransmissionStr");
	    	return keylist;
		}
		
		override public function postConfirmEntryResultHandler(mapObj:Object):void {
			uConfSubmit.enabled = true;
			submitUserConfResult(mapObj);
			if(iError == 0) {
				uConfLabel.includeInLayout = true;
				uConfLabel.visible = true;
				uConfImg.includeInLayout = false;
				uConfImg.visible = false;
				usrCnfMessage.text = this.parentApplication.xResourceManager.getKeyValue('stl.label.banktransfer.entry.systemconfirmation');
				this.referenceNoLabel.text = this.parentApplication.xResourceManager.getKeyValue('inf.label.refno')+": "+mapObj[keylist.getItemAt(0)].toString()+"-"+mapObj[keylist.getItemAt(1)].toString();
				uConfEntryTransmissionReqdReceive.text = mapObj[keylist.getItemAt(2)].toString();
				uConfEntryTransmissionReqdDeliver.text = mapObj[keylist.getItemAt(3)].toString();
				uConfEntryAutoTransmission.text = mapObj[keylist.getItemAt(4)].toString();
			}
		}
		
		override public function preConfirmCancelResultHandler():Object {
			keylist = new ArrayCollection();
			keylist.addItem("bankTransferQuerySummaryView.settlementReferenceNo");
	    	keylist.addItem("cxlReferenceNo");
	    	return keylist;
		}
		
		override public function postConfirmCancelResultHandler(mapObj:Object):void {
			uCancelConfSubmit.enabled = true;
			submitUserConfResult(mapObj);
			this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('stl.label.banktransfer.cancel.systemconfirmation');;
        	cancelSubmit.visible = false;
        	cancelSubmit.includeInLayout = false;
        	uCancelConfSubmit.visible = false;
        	uCancelConfSubmit.includeInLayout = false;
        	uConfLabel.includeInLayout = false;
			uConfLabel.visible = false;
			this.referenceNoLabel.text = this.parentApplication.xResourceManager.getKeyValue('inf.label.refno')+": "+mapObj[keylist.getItemAt(0)].toString()+", "+this.parentApplication.xResourceManager.getKeyValue('inf.label.cxl.refno')+": "+mapObj[keylist.getItemAt(1)].toString();
		}
		
		private function submitUserConfResult(mapObj:Object):void {
	    	if(mapObj!=null) {    
		    	if(mapObj["errorFlag"].toString() == "error") {
		    		if(mode!="cancel") {
		    			this.vstack.selectedChild = qry;
		    			this.errPage.showError(mapObj["errorMsg"]);
		    		} else {
		    			this.errPageCxl.showError(mapObj["errorMsg"]);
		    			this.uCancelConfSubmit.enabled = false;
		    		}
		    		++iError;
		    	} else if(mapObj["errorFlag"].toString() == "noError") {
		    		
					if(mode!="cancel") {
						errPage.clearError(super.getConfResultEvent());
					}
					iError = 0;
					this.back.includeInLayout = false;
		    		this.back.visible = false;
				    uConfSubmit.enabled = true;	
	                uConfLabel.includeInLayout = false;
	                uConfLabel.visible = false;
	                uConfSubmit.includeInLayout = false;
	                uConfSubmit.visible = false;
	                sConfLabel.includeInLayout = true;
	                sConfLabel.visible = true;
	                sConfSubmit.includeInLayout = true;
	                sConfSubmit.visible = true;   
	                app.submitButtonInstance = sConfSubmit;
					
		    	} else {
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred'));
		    	}    		
	    	}
    	}
    
   /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	
    	reqObj.method = "doSubmit";
    	
    	reqObj.ownAccount = this.frombankaccount.accountNo.text;
    	
    	reqObj.cpAccount = this.tobankaccount.accountNo.text;
    	
    	reqObj.ownBankCode = this.fromBankcode.text;
    	
    	reqObj.cpBankCode = this.toBankcode.text;
    	
    	reqObj.ownBankName = this.fromBankname.text;
    	
    	reqObj.cpBankName = this.toBankname.text;
    	
    	reqObj.securityId = this.security.instrumentId.text;
    	
    	if(this.quantity.text.search(',') > -1) {
    		var strQtyTemp:String = "";
    		var splitResultsArray:Array = this.quantity.text.split(',',3);
    		for(var i:int;i<splitResultsArray.length;++i) {
    			strQtyTemp = strQtyTemp + splitResultsArray[i];
    		}
    		//XenosAlert.info(strQtyTemp);
    		reqObj.quantity = strQtyTemp;
    	} else {
    		reqObj.quantity = this.quantity.text;
    	}
    	qtyTemp = this.quantity.text;
    	
    	reqObj.transmissionReqdStr = this.transmissionRequired.selectedItem != null ? this.transmissionRequired.selectedItem.value : "";
    	
    	reqObj.valueDateFromUI = (this.valueDate.selectedDate)!=null?(this.valueDate.text):strValueDate;
    	
    	reqObj.remarks = this.remarks.text;
    	
    	reqObj.autoTransmissionStr = this.autoTransmission.selectedItem != null ? this.autoTransmission.selectedItem.value : "";
    	
    	reqObj.deliveryMethod = this.form.selectedItem != null ? this.form.selectedItem.value : "";
    	
    	reqObj.SCREEN_KEY = 737;

    	return reqObj;
    }
    
	override public function preResetEntry():void {
		var rndNo:Number= Math.random();
		super.getResetHttpService().url = "stl/bankTransferEntryDispatch.action?method=doReset&rnd=" + rndNo;
	}
	
	override public function postResetEntry():void {
		resetValues();
		this.autoTransmission.enabled = false;
	}
	
	override public function doEntrySystemConfirm(e:Event):void {
		super.preEntrySystemConfirm();
		this.dispatchEvent(new Event('entryReset'));
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
        
        this.uConfAccountNo.text = null;
        this.uConfValueDate.text = null;
        this.uConfSecurityCode.text = null;
        this.uConfSecurityName.text = null;
        this.uConfQuantity.text = null;
        this.uConfInxTransmission.text = null;
        this.uConfRemarks.text = null;
        
        
        vstack.selectedChild = qry;	
		super.postEntrySystemConfirm();
	}
	
	override public function doCancelSystemConfirm(e:Event):void {
		this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
	}
	
	private function resetValues():void {
		
		frombankaccount.accountNo.text = null;
		frombankaccount.bankCodeTxt.text = null;
		frombankaccount.bankNameTxt.text = null;
		tobankaccount.accountNo.text = null;
		tobankaccount.bankCodeTxt.text = null;
		tobankaccount.bankNameTxt.text = null;
		fromBankcode.text = null;
		toBankcode.text = null;
		fromBankname.text = null;
		toBankname.text = null;
		security.instrumentId.text = null;
		quantity.text = null;
		valueDate.text = "";
		form.text = null;
		remarks.text = null;
		errPage.removeError();
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
	 /**
	  * This is the method to access the Collection of data items receive
	  * through the context from the account popup. This will be implemented as per specifdic  
	  * requriment. 
	  */
	public function showReturnContext(retCtxItem:ArrayCollection):void {
	    
	    XenosAlert.info("showReturnContext");
	
	    for (var i:int = 0; i<returnContextItem.length; i++){
	        
	        XenosAlert.info("index :: "+ i);
	        
	        var itemObject:HiddenObject;
	        
	        itemObject = HiddenObject (returnContextItem.getItemAt(i));
	        
	        XenosAlert.info("hidden property :: "+ itemObject.m_propertyName );
	        
	        var propertyValues:Array = itemObject.m_propertyValues;
	        
	        for (var j:int = 0; j<propertyValues.length; j++){
	            XenosAlert.info("hidden values :: " + propertyValues[j]);
	        }
	    }
	    
	}
	public function populateFromBank(e:FocusEvent):void {
		fromBankcode.text = frombankaccount.bankCodeTxt.text;
		fromBankname.text = frombankaccount.bankNameTxt.text;
	}
	public function populateToBank(e:FocusEvent):void {
		toBankcode.text = tobankaccount.bankCodeTxt.text;
		toBankname.text = tobankaccount.bankNameTxt.text;
	}
	/** When Back button is clicked **/
	private function doBack():void {
		vstack.selectedChild = qry;
		app.submitButtonInstance = submit;
	}
	/** When the value of dropdown of Transmission Required is changed **/  	
	private function enableAutoTransmission():void {
		//XenosAlert.info("*** "+this.autoTransmission.selectedItem.value);
		if(this.transmissionRequired.selectedItem != null) {
			if(this.transmissionRequired.selectedItem.value == "Y") {
				this.autoTransmission.enabled = true;
			} else {
				this.autoTransmission.selectedItem.value = "N";
				this.autoTransmission.text = "N";
				this.autoTransmission.enabled = false;
			}
		}
	}
	