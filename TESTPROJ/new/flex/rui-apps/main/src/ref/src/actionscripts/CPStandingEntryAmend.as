// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;
import mx.events.IndexChangedEvent;


            [Bindable]
            private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
            [Bindable]
            private var keylist:ArrayCollection = new ArrayCollection();
		    [Bindable]
		    private var counterPartyCode:ArrayCollection=null;
		    [Bindable]	
		    private var stlForList:ArrayCollection=null;
		    [Bindable]
		    private var stlTransactionTypeList:ArrayCollection=null;
		    [Bindable]
		    private var stlTypeList:ArrayCollection=null;
		    [Bindable]
		    private var deliveryMethodList:ArrayCollection=null;
	        [Bindable]
		    private var priorityList:ArrayCollection=null;
		    [Bindable]
		    private var selectedIndxForStlFrLst:int=0;
		    [Bindable]
			private var selectedIndxForStlTrnscList:int=0;
			[Bindable]
			private var selectedIndxForStlType:int=0;
			[Bindable]
			private var selectedIndxForForm:int=0;
			[Bindable]
			private var selectedIndxForCntrPrty:int=0;					     
		    private var mode : String = "ADD";
		    private var standingRulePk:String="";
		    private var pageView : String = "";
		    private var actionType : String = "";
		    private var cashDiff : String = "";
		    private var settlementMode : String = "";
		    private var secCash : String = "";
		    private var cntrPrtyAcct : String = "";
		    private var market : String = "";
		    private var securityType : String = "";
		    private var stlCcy : String = "";
		    private var counterPartyCodeText : String = "";
		    private var countryCode : String = "";
		    private var securityCode : String = "";
		    [Bindable]
		    public var xmlObj:XML;
		    private var isResetClicked:Boolean=false;
		
		     
		     
     
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
                    if(params != null){
	                    for (var i:int = 0; i < params.length; i++) {
	                        var tempA:Array = params[i].split("=");  
	                        if (tempA[0] == Globals.MODE_OF_TRAN) {
	                            mode = tempA[1];
	                        }else if (tempA[0] == Globals.RULE_PK) {
	                            standingRulePk = tempA[1];
	                        }
	                    }                    	
                    }else{
                    	mode = "ADD";
                    }                 

                } catch (e:Error) {
                    trace(e);
                }      
                
                	         
            } 


 		public function loadAll():void{
           	   parseUrlString();
           	   super.setXenosEntryControl(new XenosEntry());
	       	    if(mode=="ADD"){
	           	   this.dispatchEvent(new Event('entryInit'));
	            }
                else if(mode=="AMEND"){
                  this.dispatchEvent(new Event('amendEntryInit'));
                }
                else{
                	 //XenosAlert.info("Into cancelInit");
               }
               
          }
          
          // Fire on View stack creation complete
         private function addVStckListener():void{
         	dynaStack.addEventListener(IndexChangedEvent.CHANGE,viewStackIndexChange);	
         } 
         // Fire on SelectedChild change of ViewStack
         private function viewStackIndexChange(evt:IndexChangedEvent):void{
         	if(dynaStack.selectedIndex==2){
         		cpStandingUseConf.initializeView();
         	}
         }
          
         public function setXMLObj(tempxmlObj:XML):void
         {
         	this.xmlObj = tempxmlObj;
         
         } 
         
         // Initialize edit or add screen on CPStanding entry ammmend
        public function ammendEditDisplayDecider(view:String):void{
           	if(mode =="ADD"){
        		if(view=="ADD")
        		{
        		 this.dynaStack.selectedChild=cpStandingAdd;
        		 controlAddAmendButton(false);
        		 controlConfrmationPnl(false);
        		}
        		else
        		{
  				  cpStandingEdit.setXMLObj(xmlObj)
        		  cpStandingEdit.setModeOfTransaction(mode);
        		  this.dynaStack.selectedChild=cpStandingEdit;
        		  controlResetFlow();
        		  controlAddAmendButton(true);
        		  controlConfrmationPnl(false);
        		}
           	}
        	else
        	{
        		this.dynaStack.selectedChild=cpStandingEdit;
	    		cpStandingEdit.setXMLObj(xmlObj)
	    		cpStandingEdit.setModeOfTransaction(mode);
	    		controlResetFlow();
	    		controlAddAmendButton(true);
	    		controlConfrmationPnl(false);
        	}
        } 
        // If reset Is cliecked then system re-initialize he screen
        private function controlResetFlow():void{
        	if(isResetClicked){
        		cpStandingEdit.initializeView();
        	}
        }
        
        
          // Control the Submit and Update button
	      private function controlAddAmendButton(isEnable:Boolean):void{
 	  		// Enable/Disable Add button
 	  		submitPnl.includeInLayout=isEnable;
 	  		submitPnl.visible=isEnable;
   			submit.includeInLayout=isEnable;
 	  		submit.visible=isEnable;
   			reset.includeInLayout=isEnable;
 	  		reset.visible=isEnable;
	       }     
        
       
			private function populateGenaralAddScreen():void{
				if(mode=="ADD"){
					this.cpStandingAdd.counterPartyCode = counterPartyCode;
					this.cpStandingAdd.stlForList = stlForList;
					this.cpStandingAdd.stlTransactionTypeList = stlTransactionTypeList;
					this.cpStandingAdd.stlTypeList = stlTypeList;
					this.cpStandingAdd.deliveryMethodList = deliveryMethodList;
					this.cpStandingAdd.selectedIndxForStlFrLst = selectedIndxForStlFrLst;
					this.cpStandingAdd.selectedIndxForStlTrnscList = selectedIndxForStlTrnscList;
					this.cpStandingAdd.selectedIndxForStlType = selectedIndxForStlType;
					this.cpStandingAdd.selectedIndxForForm = selectedIndxForForm;
					this.cpStandingAdd.selectedIndxForCntrPrty = selectedIndxForCntrPrty;
					this.cpStandingAdd.priorityList  = priorityList;
		        	this.cpStandingAdd.cashDiff  = cashDiff;
		        	this.cpStandingAdd.settlementMode  = settlementMode;
		        	this.cpStandingAdd.secCash  = secCash;
		        	this.cpStandingAdd.cntrPrtyacct.accountNo.text = cntrPrtyAcct;
		        	this.cpStandingAdd.securityCode.instrumentId.text = securityCode;
		        	this.cpStandingAdd.executionMarket.itemCombo.text = market;
		        	this.cpStandingAdd.instrumentType.itemCombo.text = securityType;
		        	this.cpStandingAdd.stlCcy.ccyText.text=stlCcy;
		        	this.cpStandingAdd.onChangeCounterPartyType();
					this.cpStandingAdd.onChangeStlForGeneral();
					this.cpStandingAdd.onChangeSecCashGeneral();
					this.cpStandingAdd.customercodeSrchPopUp.customerCode.text=counterPartyCodeText;
		        	this.cpStandingAdd.finInstPopUp.finInstCode.text=counterPartyCodeText;
		        	this.cpStandingAdd.countrycode.countryCode.text = countryCode;
				}
			}
       
        
        
         override public function preEntryInit():void{            	
	        if(mode=="ADD"){
	        	isResetClicked=false;  
            	super.getInitHttpService().url = "ref/cpStandingEntryDispatch.action?method=addInit&modeofTran="+mode;
            	var reqObj : Object = new Object();
		    	reqObj.SCREEN_KEY= 196;
		    	super.getInitHttpService().request=reqObj;
            }
         }
         
          override public function preAmendInit():void{            	
		       if(mode=="AMEND"){
		       		 isResetClicked=false;  
		          	 super.getInitHttpService().url = "ref/cpStandingEntryDispatch.action?method=doAmend&rulePk="+standingRulePk+"&modeofTran="+mode;
		          	 var reqObj : Object = new Object();
			    	 reqObj.SCREEN_KEY= 912;
			    	 super.getInitHttpService().request=reqObj;
	         	}
          }
	      override public function preResetAmend():void {
      	  if(mode=="AMEND"){
			   isResetClicked=true;      	  	
		  	   super.getResetHttpService().url = "ref/cpStandingEntryDispatch.action?method=doAmend&rulePk="+standingRulePk+"&modeofTran="+mode;
      	  }
	   }
	   
	    override public function preResetEntry():void {
      	  if(mode=="ADD"){
		       isResetClicked=true;
		  	   super.getResetHttpService().url = "ref/cpStandingEntryDispatch.action?method=doReset&modeofTran="+mode;
      	  }
	   }
	   
	    override public function preEntry():void{
		 if(validateCpStandingEntry()){
		 	super.getSaveHttpService().url = "ref/cpStandingEntryDispatch.action?";  
            super.getSaveHttpService().request  =populateRequestParams();
   			}
		 }
		 
		 override public function preAmend():void{
		 	super.getSaveHttpService().url = "ref/cpStandingEntryDispatch.action?";  
            super.getSaveHttpService().request  =populateRequestParams();
		 } 
		 
		 override public function preEntryConfirm():void
		{
			alertForAccNoTypeAndMarket();
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "ref/cpStandingEntryDispatch.action?";  
			reqObj.method= "commit";
            super.getConfHttpService().request  =reqObj;
		}
		
		override public function preAmendConfirm():void
		{
			alertForAccNoTypeAndMarket();
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "ref/cpStandingEntryDispatch.action?";  
			reqObj.method= "commit";
            super.getConfHttpService().request  =reqObj;
		}
		
		override public function postConfirmAmendResultHandler(mapObj:Object):void
		{
			submitUserConfResult(mapObj);
			this.parentDocument.title ="System Confirmation - Counterparty Settlement Standing Amend";
		}
		
		override public function postConfirmEntryResultHandler(mapObj:Object):void
		{
			submitUserConfResult(mapObj);

			this.parentDocument.title ="System Confirmation - Counterparty Settlement Standing Entry";
		}
		
		override public function doEntrySystemConfirm(e:Event):void
		{
			closeEntryAmendScreen();
		}
		
		override public function doAmendSystemConfirm(e:Event):void
		{
	     closeEntryAmendScreen();
		}
		
		// Close Entry Amend screen
		private function closeEntryAmendScreen():void{
			this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
		}
		
	// Validate on CPStanding Add
	private	function validateCpStandingEntry():Boolean {
		var alertMsg :String= "";
	    if(XenosStringUtils.isBlank(cpStandingEdit.stlFor.text)){
	    	 alertMsg += "Settlement For cannot be empty";
	    }
	    else if(XenosStringUtils.isBlank(cpStandingEdit.cshSecFlg.text)){
	    	 alertMsg += "Cash/Security Flag cannot be empty";
	    }
	    if(alertMsg!="") {
       	 XenosAlert.error(alertMsg);
        return false;
    	}
   	 return true;
	}
	
	// Fire on User confirmation
	private function alertForAccNoTypeAndMarket():void {
		var marketJp :String= xmlObj.cpSecRule.marketJp.toString();
		var c2WarningReqd :String= xmlObj.cpSecRule.c2WarningReqd.toString();
		if(marketJp == "true" && c2WarningReqd == "false") {
	       XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.cpstd.msg.error.missing.c2code'));
		}
	}
	
		private function submitUserConfResult(mapObj:Object):void{
    		if(mapObj!=null){    
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
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.erroroccurred'));
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
	    	reqObj.method= "addConfirm";
	    	// Add screen key for access log
	    	if(this.mode == 'ADD'){
	    		reqObj['SCREEN_KEY'] = 196;
	    	}else if(this.mode == 'AMEND'){
	    		reqObj['SCREEN_KEY'] = 912;
	    	}
	    	reqObj['modeofTran'] = this.mode;
	    	// Populatre Req params from child screens
	    	cpStandingEdit.populateEditParmeter(reqObj);
	    	return reqObj;
	    }
		    
	 	// CALLED AFTER COMPLETE TRANSACTION ON SAVE 
      override public function postEntryResultHandler(mapObj:Object): void{
		    commonResult(mapObj);
	    }
    	
     // CALLED AFTER COMPLETE TRANSACTION ON AMMEND
      override public function postAmendResultHandler(mapObj:Object): void{
	  		commonResult(mapObj);
    	}	
	   
	    private function commonResult(mapObj:Object):void{
	    	if(mapObj!=null){    		
		    	if(mapObj["errorFlag"].toString() == "error"){
		    		if(mode != "cancel"){
		    		  errPage.showError(mapObj["errorMsg"]);		    			
		    		}else{
		    			XenosAlert.error(mapObj["errorMsg"]);
		    		}
		    	}else if(mapObj["errorFlag"].toString() == "noError"){
		    	 errPage.clearError(super.getSaveResultEvent());			    			
	             commonResultPart();
		    	 app.submitButtonInstance = uConfSubmit;
		    		
		    	}else{
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.datanotfound'));
		    	}    		
	    	}
        }
         
         
         private function commonResultPart():void{
         	if(super.getSaveResultEvent()!=null){     
	      	 	 xmlObj = XML(Object(super.getSaveResultEvent().result));
	      	 	 var viewMode:String =xmlObj.viewMode.toString();
	      	 	 if(viewMode=="CONFIRM"){
	      	 	 	cpStandingUseConf.setXmlSource(xmlObj);
	      	 	 	dynaStack.selectedChild =cpStandingUseConf;
	      	 	 	controlConfrmationPnl(true);
	      	 	 	uConfLabel.includeInLayout = true;
					uConfLabel.visible = true;
					uConfImg.includeInLayout =false;
					uConfImg.visible =false;
					if(mode=="ADD"){
		    			usrCnfMessage.text ="User Confirmation - Counterparty Settlement Standing Entry";
		   			}else{
			  		    usrCnfMessage.text ="User Confirmation - Counterparty Settlement Standing Amend";
			 		}
	      	 	 }else{
	      	 	 	ammendEditDisplayDecider(xmlObj.pageView.toString());
	      	 	 	controlConfrmationPnl(false);
	      	 	 }
				 
	    	   }
         }
         
         private function doBack():void{
         	uConfLabel.includeInLayout = false;
			uConfLabel.visible = false;
         	ammendEditDisplayDecider(xmlObj.pageView.toString());
  		}  	
  
         
         private function controlConfrmationPnl(isEnable:Boolean):void{
         	submitPnl.includeInLayout = !isEnable;
         	submitPnl.visible = !isEnable;
         	userConfPnl.includeInLayout=isEnable;
         	userConfPnl.visible=isEnable;
         }
         
         
      // Call for Ammend Result population on AmendInit
       override public function postAmendResultInit(mapObj:Object): void{
	    	if(super.getInitResultEvent()!=null){     
	      	 	 xmlObj = XML(Object(super.getInitResultEvent().result));
				 ammendEditDisplayDecider(pageView);
	    	   }
    	}
    	
         
         
        
        override public function preEntryResultInit():Object{
        	addCommonKeys(); 
        	return keylist;
        }
        
        private function addCommonKeys():void{        	
	    	keylist = new ArrayCollection();
	    	keylist.addItem("cpTypeList.item");
	    	keylist.addItem("stlTrnscTypeLst.item");
	    	keylist.addItem("stlForList.item");
	    	keylist.addItem("cpSecRule.settlementFor");
	    	keylist.addItem("cpSecRule.cashSecurityFlag");
	    	keylist.addItem("stlTypeList.item");	
	    	keylist.addItem("cpSecRule.settlementType");
	    	keylist.addItem("deliveryMethodList.item");
	    	keylist.addItem("cpSecRule.deliveryMethod");
	    	keylist.addItem("priorityList.item");	
	    	keylist.addItem("pageView");
	    	keylist.addItem("actionType");
	    	keylist.addItem("diffCash");
	    	keylist.addItem("cpCashRule.settlementMode");
	    	keylist.addItem("secCash");
	    	keylist.addItem("cpSecRule.market");
	    	keylist.addItem("cpSecRule.instrumentType");
	    	keylist.addItem("cpSecRule.settlementCcy");
	        keylist.addItem("cpSecRule.counterPartyType");
	        keylist.addItem("cpSecRule.counterPartyCode");
	        keylist.addItem("cpSecRule.tradingAccountNo");
	        keylist.addItem("cpSecRule.instrumentCode");
	        keylist.addItem("countryCode");
	       
	   /* 	
	       	keylist.addItem("stlmntLocationLst.item");	
	       	keylist.addItem("cpSecRule.standingRulePk");
	       	keylist.addItem("cpSecRule.cashSecurityFlag");
	       	
	       	keylist.addItem("cpSecRule.settlementFor");
	       	
	       	keylist.addItem("cpSecRule.localAccountNo");
	       	keylist.addItem("CpBankCodeTypeList.item");*/
        }
        
         override public function postEntryResultInit(mapObj:Object): void{
        	commonInit(mapObj);
        }
        
   

        
      private function commonInit(mapObj:Object):void{
        	if(mode=="ADD"){
        	 // Populate Couner Party code Combo Box
	        	counterPartyCode=new ArrayCollection();
	        	counterPartyCode.addItem({label: "" , value : ""});
	        	for (var indx6:int=0;indx6<(mapObj["cpTypeList.item"] as ArrayCollection).length;indx6++){
	        	var obj6:Object = (mapObj["cpTypeList.item"] as ArrayCollection).getItemAt(indx6);
	        		counterPartyCode.addItem(obj6);
	        		if(obj6.value==mapObj['cpSecRule.counterPartyType'].toString()){
	        			selectedIndxForCntrPrty=indx6;
	        			selectedIndxForCntrPrty+=1;
	        		}
	           	}
	        	counterPartyCode.refresh();
	        	trace("selectedIndxForCntrPrty : "+selectedIndxForCntrPrty);
	        	// Populate Settlement for Combo Box
	        	stlForList=new ArrayCollection();
	               	
	        	for (var indx:int=0;indx<(mapObj["stlForList.item"] as ArrayCollection).length;indx++){
	           	var obj5:Object = (mapObj["stlForList.item"] as ArrayCollection).getItemAt(indx);
	        		        	
	        		stlForList.addItem(obj5);
	        		
	        		if(obj5.value==mapObj['cpSecRule.settlementFor'].toString()){
	        			selectedIndxForStlFrLst=indx;
	        		}
	           	}
	           
	        	stlForList.refresh();
	        	
	        	// Populate Cash and Security Combo Box
	        	
	        	stlTransactionTypeList=new ArrayCollection();
	        	
	        	for (var indx1:int=0;indx1<(mapObj["stlTrnscTypeLst.item"] as ArrayCollection).length;indx1++){
	        	
	        	var obj3:Object = (mapObj["stlTrnscTypeLst.item"] as ArrayCollection).getItemAt(indx1);
	        		        	
	        		stlTransactionTypeList.addItem(obj3);
	        		
	        		if(obj3.value==mapObj['cpSecRule.cashSecurityFlag'].toString()){
	        			selectedIndxForStlTrnscList=indx1;
	        		}
	        			
	        	}
	           
	        	stlTransactionTypeList.refresh();
	        
	        	// Populate Settlement Type Combo Box
	        	
	        	stlTypeList=new ArrayCollection();
	        	
	        	for (var indx2:int=0;indx2<(mapObj["stlTypeList.item"] as ArrayCollection).length;indx2++){
	        	
	        	var obj4:Object = (mapObj["stlTypeList.item"] as ArrayCollection).getItemAt(indx2);
	        		        	
	        		stlTypeList.addItem(obj4);
	        		
	        		if(obj4.value==mapObj['cpSecRule.settlementType'].toString()){
	        			selectedIndxForStlType=indx2;
	        		}
	        			
	        	}
	           
	        	stlTypeList.refresh();
	        	
	        	// Populate Form  Combo Box
	        	deliveryMethodList=new ArrayCollection();
	        	deliveryMethodList.addItem({label: "" , value : ""});
	        	
	        	for (var indx3:int=0;indx3<(mapObj["deliveryMethodList.item"] as ArrayCollection).length;indx3++){
	        	
	        	var obj2:Object = (mapObj["deliveryMethodList.item"] as ArrayCollection).getItemAt(indx3);
	        		deliveryMethodList.addItem(obj2);
	        		if(obj2.value==mapObj['cpSecRule.deliveryMethod'].toString()){
	        			selectedIndxForForm=indx3;
	        		}
	           	}
	           	selectedIndxForForm+=1;
	        	deliveryMethodList.refresh();
	        	// Populate Priority List Combo Box
	        	priorityList=new ArrayCollection();
//	        	priorityList.addItem({label: "" , value : ""});
	        	
	        	for each(var obj1:Object in mapObj["priorityList.item"] as ArrayCollection){
	              	priorityList.addItem(obj1);;
	             
	        	}
	        	
	        	priorityList.refresh();
	        	
	       }
	        	// Set Action type Value
	           actionType= mapObj["actionType"].toString();
	           // Set Page View
	           pageView =  mapObj["pageView"].toString();
	           // Get the Cash Diff
	           cashDiff =  mapObj["diffCash"].toString();
	           // Get the Settlement Mode
	           settlementMode =  mapObj["cpCashRule.settlementMode"].toString();
	           // Get Cash Sec 
	           secCash =  mapObj["secCash"].toString();
	           // Counter Party Code
	           if(!XenosStringUtils.contains(mapObj["cpSecRule.tradingAccountNo"].toString(),"*")){
 				cntrPrtyAcct =  mapObj["cpSecRule.tradingAccountNo"].toString();	           	
	           }
	           // Get Market
	           market =  mapObj["cpSecRule.market"].toString();
	           // Security Type
	           securityType =  mapObj["cpSecRule.instrumentType"].toString();
	           // Settlement CCY
	           stlCcy =  mapObj["cpSecRule.settlementCcy"].toString();
	           // Counter Party Code
	           counterPartyCodeText =  mapObj["cpSecRule.counterPartyCode"].toString();
	           // Country Code
	           countryCode =  mapObj["countryCode"].toString();
	           // Security Code
	           if(!XenosStringUtils.contains(mapObj["cpSecRule.instrumentCode"].toString(),"*")){
 				securityCode =  mapObj["cpSecRule.instrumentCode"].toString();           	
	           }
	           //Populate the add screen with corresponding data
	           populateGenaralAddScreen();
	           //Select wich screen will be dispalyed
	           ammendEditDisplayDecider(pageView);
        }
        	