// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.DateUtils;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;
import mx.events.ResourceEvent;
import mx.resources.ResourceBundle;
import com.nri.rui.core.utils.XenosStringUtils;
			
	  
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     
            [Bindable]private var mode : String = "entry";
            [Bindable]private var drvContractPkStr : String = "";
            private var keylist:ArrayCollection = new ArrayCollection();
	  
	  private function changeCurrentState():void{
				//hdbox1.selectedChild = this.rslt;
				//currentState = "result";
				vstack.selectedChild = rslt;
	 }
	 
    
			   public function loadAll():void{
           	   parseUrlString();
           	   super.setXenosEntryControl(new XenosEntry());
           	   //XenosAlert.info("mode : "+mode);
           	   if(this.mode == 'entry'){
           	   	 this.dispatchEvent(new Event('entryInit'));
           	   	 vstack.selectedChild = qry;
           	   } else if(this.mode == 'amend'){
           	   	 this.dispatchEvent(new Event('amendEntryInit'));
           	   	 this.settlementType.setFocus();
           	   	 vstack.selectedChild = qry;
           	   } else { 
           	     this.dispatchEvent(new Event('cancelEntryInit'));
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
                    if(params != null){
	                    for (var i:int = 0; i < params.length; i++) {
	                        var tempA:Array = params[i].split("=");  
	                        if (tempA[0] == "mode") {
	                            //XenosAlert.info("movArray param = " + tempA[1]);
	                            mode = tempA[1];
	                        }
	                        if(tempA[0] == "contractPk"){
	                            this.drvContractPkStr = tempA[1];
	                        }
	                    }                    	
                    }else{
                    	mode = "entry";
                    }                 

                } catch (e:Error) {
                    trace(e);
                }               
            }
            
            override public function preAmendInit():void{     
            	initLabel.text = "Derivative Contract Amend"       	
		        var rndNo:Number= Math.random(); 
            	super.getInitHttpService().url = "drv/drvContractAmendDetails.action?";
            	var reqObject:Object = new Object();
            	reqObject.rnd = rndNo;
            	reqObject.method= "doAmend";
		  		reqObject.mode=this.mode;
		  		reqObject.contractPk = this.drvContractPkStr;
		  		reqObject['SCREEN_KEY'] = "11046";
		  		super.getInitHttpService().request = reqObject;
            }
            override public function preCancelInit():void{
            	
            }
            
       
        
        private function addCommonKeys():void{        	
	    	keylist = new ArrayCollection();
	    	keylist.addItem("actionMode");
	    	keylist.addItem("dropDownListValues.drvSettlementTypeList.item");	
        }
        
        override public function preAmendResultInit():Object{
        	addCommonKeys();
        	keylist.addItem("contractVo.contractReferenceNo");
        	keylist.addItem("securityId");
        	keylist.addItem("securityShortName");
        	keylist.addItem("underlyingSecurityShortName");
        	keylist.addItem("accountNo");
        	keylist.addItem("inventoryAccountNo");
        	keylist.addItem("contractVo.openContractBalance");
        	keylist.addItem("settlementBasisStr");
        	keylist.addItem("settlementType");
        	keylist.addItem("contractVo.expiryStatus");    		
        	return keylist;
        }
        
        override public function preCancelResultInit():Object{
        	addCommonResultKes();         	
        	return keylist;
        }
        
        
        private function commonInit(mapObj:Object):void{
        		    	
		    this.settlementType.dataProvider = mapObj[keylist.getItemAt(1)] as ArrayCollection;
	    	
        }
        
        override public function postAmendResultInit(mapObj:Object): void{
        	app.submitButtonInstance = submit;
        	commonInit(mapObj);
        	
        	this.contractReferenceNo.text = mapObj[keylist.getItemAt(2)].toString();
        	this.securityId.text = mapObj[keylist.getItemAt(3)].toString();
        	this.securityShortName.text = mapObj[keylist.getItemAt(4)].toString();
        	this.underlyingShortName.text = mapObj[keylist.getItemAt(5)].toString();
        	this.brkAccountNo.text = mapObj[keylist.getItemAt(6)].toString();
        	this.fundAccountNo.text = mapObj[keylist.getItemAt(7)].toString();
        	this.openContractBal.text = mapObj[keylist.getItemAt(8)].toString();
        	this.settlementBasis.text = mapObj[keylist.getItemAt(9)].toString();
        	this.expiryStatus.text = mapObj[keylist.getItemAt(11)].toString();
        	
        	var settlementTypeStr:String = mapObj[keylist.getItemAt(10)].toString();
        	if(XenosStringUtils.equals(settlementTypeStr,"C")){
        		this.settlementType.selectedIndex = 0;
        	} else if(XenosStringUtils.equals(settlementTypeStr,"P")){
        		this.settlementType.selectedIndex = 1;
        	}
        	
        	this.settlementType.enabled = false;
	    	
	    	this.contractReferenceNo.enabled = false;
	    	this.securityId.enabled = false;
	    	this.securityShortName.enabled = false;
	    	this.underlyingShortName.enabled = false;
	    	this.brkAccountNo.enabled = false;
	    	this.fundAccountNo.enabled = false;
	    	this.openContractBal.enabled = false;
	    	this.expiryStatus.enabled = false;
	    	this.settlementBasis.enabled = false;
        	
        }
        
        private function commonResultPart(mapObj:Object):void{
        	this.uConfContractReferenceNo.text = mapObj[keylist.getItemAt(0)].toString();
        	this.uConfSecurityId.text = mapObj[keylist.getItemAt(1)].toString();
        	this.uConfSecurityShortName.text = mapObj[keylist.getItemAt(2)].toString();
        	this.uConfUnderlyingShortName.text = mapObj[keylist.getItemAt(3)].toString();
        	this.uConfBrkAccountNo.text = mapObj[keylist.getItemAt(4)].toString();
        	this.uConfFundAccountNo.text = mapObj[keylist.getItemAt(5)].toString();
        	this.uConfOpenContractBal.text = mapObj[keylist.getItemAt(6)].toString();
        	this.uConfSettlementBasis.text = mapObj[keylist.getItemAt(7)].toString();
        	this.uConfSettlementType.text = mapObj[keylist.getItemAt(8)].toString();
        	this.uConfExpiryStatus.text = mapObj[keylist.getItemAt(9)].toString();
        	
        }
        
        private function addCommonResultKes():void{
        	keylist = new ArrayCollection();
        	keylist.addItem("contractVo.contractReferenceNo");
        	keylist.addItem("securityId");
        	keylist.addItem("securityShortName");
        	keylist.addItem("underlyingSecurityShortName");
        	keylist.addItem("accountNo");
        	keylist.addItem("inventoryAccountNo");
        	keylist.addItem("contractVo.openContractBalance");
        	keylist.addItem("settlementBasisStr");
        	keylist.addItem("settlementType");
        	keylist.addItem("contractVo.expiryStatus");
        }
        
        private function commonResult(mapObj:Object):void{
        	
		 	//XenosAlert.info("commonResult ");
	    	if(mapObj!=null){    		
		    	if(mapObj["errorFlag"].toString() == "error"){
		    		//result = mapObj["errorMsg"] .toString();
		    		if(mode != "cancel"){
		    		  errPage.showError(mapObj["errorMsg"]);		    			
		    		}else{
		    			XenosAlert.error(mapObj["errorMsg"]);
		    		}
		    	}else if(mapObj["errorFlag"].toString() == "noError"){
		    		
		    	 errPage.clearError(super.getSaveResultEvent());			    			
	             commonResultPart(mapObj);
				 changeCurrentState();
		    	 app.submitButtonInstance = uConfSubmit;
		    		
		    	}else{
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    	}    		
	    	}
        }
        
       
        
    	private function setValidator():void{
		
		  
		}
		 
		 override public function preAmend():void{
		 	setValidator();
		 	super.getSaveHttpService().url = "drv/drvContractAmendDetails.action?";  
            super.getSaveHttpService().request  =populateRequestParams();
		 }
		
		override public function preAmendResultHandler():Object
		{
			addCommonResultKes();
			return keylist;
		}
		
		override public function postAmendResultHandler(mapObj:Object):void
		{
			commonResult(mapObj);
			this.parentDocument.title ="Derivative Contract Amend Page- User Confirmation";
			app.submitButtonInstance = uConfSubmit;
		}
		
		override public function preAmendConfirm():void
		{
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "drv/drvContractAmendDetails.action?";  
			reqObj.method= "doSaveToDb";
			reqObj['SCREEN_KEY'] = "11048";
            super.getConfHttpService().request  =reqObj;
		}
		override public function preConfirmAmendResultHandler():Object
		{
			keylist = new ArrayCollection();
			keylist.addItem("contractVo.contractReferenceNo");
			keylist.addItem("contractVo.versionNo");
	    	return keylist;
		}
		override public function postConfirmAmendResultHandler(mapObj:Object):void
		{
			submitUserConfResult(mapObj);
			this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('drv.label.contract.amend.sysconf');
			contractRefConfMessage.text= this.parentApplication.xResourceManager.getKeyValue('drv.label.contractreferenceno')+" : "+ mapObj[keylist.getItemAt(0)]+" - "+mapObj[keylist.getItemAt(1)];
			
		}
		
		private function submitUserConfResult(mapObj:Object):void{
    	//var mapObj:Object = mkt.userConfResultEvent(event);
	    	if(mapObj!=null){    
	    		//XenosAlert.info("object status : "+mapObj["errorFlag"].toString());		
		    	if(mapObj["errorFlag"].toString() == "error"){
		    		XenosAlert.error(mapObj["errorMsg"].toString());
		    	}else if(mapObj["errorFlag"].toString() == "noError"){
		    		if(mode!="cancel")
		    		  errPage.clearError(super.getConfResultEvent());
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
		    		
		    	}else{
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
	    	
		    if(this.mode == 'amend'){
	    		reqObj.method= "doAmendConfirm";
	    		reqObj['SCREEN_KEY'] = "11047";
		    }
	    	reqObj['expiryStatus'] = this.settlementType.selectedItem != null ? this.settlementType.selectedItem.value : "";
	    	
	
	    	return reqObj;
	    }
	   override public function preResetAmend():void
	   {
			var rndNo:Number= Math.random();
			super.getResetHttpService().url = "drv/drvContractAmendDetails.action?method=doAmend&contractPk="+this.drvContractPkStr+"&rnd=" + rndNo; 
	   }
	
		override public function doAmendSystemConfirm(e:Event):void
		{
			//this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
		    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
		}
  
	    private function doBack():void{
			//hdbox1.selectedChild = this.qry;
	   	   	 //this.currentState="entryState";
	   	   	 vstack.selectedChild = qry;
	   	   	 app.submitButtonInstance = submit;
	   	   	 if(XenosStringUtils.equals(this.mode,"amend")){
	   	   	 	this.parentDocument.title =this.parentApplication.xResourceManager.getKeyValue('drv.label.contract.amend');
	   	   	 }	
	    }  	
  

    

		