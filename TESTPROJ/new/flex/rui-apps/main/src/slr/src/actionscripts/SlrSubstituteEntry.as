import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.ref.popupImpl.TrdSsiPopup;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;
					
			  
		     [Bindable]
		     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     
            [Bindable]private var actiontypemode : String = "SUBSTITUTION";
            [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
            [Bindable]private var trdTypeDP:ArrayCollection = new ArrayCollection();
            [Bindable]private var securityList:ArrayCollection = new ArrayCollection();
            [Bindable]private var ExistingsecurityList:ArrayCollection = new ArrayCollection();
            [Bindable]private var contractPkStr : String = "";
            [Bindable]public var cpSecSsiPk:Label = new Label();
            [Bindable]private var conTractRefNo:String = XenosStringUtils.EMPTY_STR;
            [Bindable]private var accountPkStr:String = XenosStringUtils.EMPTY_STR;
	        [Bindable]private var invAccountPkStr:String = XenosStringUtils.EMPTY_STR;
	        [Bindable]private var tmpCntrctNo:String = XenosStringUtils.EMPTY_STR;
	        [Bindable]private var tmpVersionNo:String = XenosStringUtils.EMPTY_STR;
	        
	        [Bindable]private var tmpSettlementFor:String = XenosStringUtils.EMPTY_STR;
	        [Bindable]private var tmpDeliveryMethod:String = XenosStringUtils.EMPTY_STR;
	        [Bindable]private var interestManual:String = 'false';
	        [Bindable]private var secSelected:String =  XenosStringUtils.EMPTY_STR;
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
	       	   super.setXenosEntryControl(new XenosEntry());
	       	   if(this.actiontypemode == 'SUBSTITUTION'){
	       	   	 this.dispatchEvent(new Event('entryInit'));
	       	   	 vstack.selectedChild = qry;
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
	                        if (tempA[0] == "action_type_mode") {
	                            actiontypemode = tempA[1];
	                        }
	                    }                    	
                    }else{
                    	actiontypemode = "SUBSTITUTION";
                    }
                } catch (e:Error) {
                    trace(e);
                }               
            }
            
             /**
            * This method fires the dispatchaction to initialize the
            * SLR Trade Amend Screen (InitAmend-SEQ-1)
            */
             override public function preEntryInit():void{     
            	initLabel.text = this.parentApplication.xResourceManager.getKeyValue('slr.label.slrsubstitutionentry');       	
		        var rndNo:Number= Math.random(); 
            	super.getInitHttpService().url = "slr/ContractDetailsDispatch.action?";
            	var reqObject:Object = new Object();
            	reqObject.rnd = rndNo;
            	reqObject.SCREEN_KEY = "134";
            	reqObject.method= "contractActionEntryExecute";
		  		reqObject.actionType=this.actiontypemode;
		  		super.getInitHttpService().request = reqObject;
            } 
            
            
            /**
            * This method is pre-result handler for the SLR Trade Amend
            * Screen. It generates the list of keys which will be populated 
            * during the initialization of the SLR trade Amend screen. 
            * (InitAmend-SEQ-2)
            */
	         override public function preEntryResultInit():Object{
	        	
	        	addCommonResultKeys();
				return keylist;
	        } 
	        
	        
	        /**
	        * This method populates the elements of the SLR
	        * Trade Amend screen(mxml)
	        * from the map obtained from preAmendResultInit() (InitAmend-SEQ-3)
	        */
	         override public function postEntryResultInit(mapObj:Object): void{
				
				
				this.hideForSC.visible = true;
	        	app.submitButtonInstance = submit;
	        	this.contractPkStr = mapObj[keylist.getItemAt(38)].toString();
	        	this.tmpCntrctNo = mapObj[keylist.getItemAt(0)].toString();
	        	this.tmpVersionNo = mapObj[keylist.getItemAt(1)].toString();
	        	this.contractNo.text = mapObj[keylist.getItemAt(0)] != null ? mapObj[keylist.getItemAt(0)].toString()+"-"+mapObj[keylist.getItemAt(1)].toString() : "";
	        	this.openended.text = mapObj[keylist.getItemAt(2)] != null ? mapObj[keylist.getItemAt(2)].toString() : "";
	        	this.tradeType.text = mapObj[keylist.getItemAt(3)] != null ? mapObj[keylist.getItemAt(3)].toString() : "";
	        	this.subTradeType.text = mapObj[keylist.getItemAt(4)] != null ? mapObj[keylist.getItemAt(4)].toString() : "";
	        	this.accNo.text = mapObj[keylist.getItemAt(5)] != null ? mapObj[keylist.getItemAt(5)].toString() : "";
	        	this.accountPkStr = mapObj[keylist.getItemAt(35)].toString();
	        	this.rr.text = mapObj[keylist.getItemAt(6)] != null ? mapObj[keylist.getItemAt(6)].toString() : "";
	        	this.fundAccNo.text = mapObj[keylist.getItemAt(7)] != null ? mapObj[keylist.getItemAt(7)].toString() : "";
	        	this.invAccountPkStr = mapObj[keylist.getItemAt(36)].toString();
	        	this.execRr.text = mapObj[keylist.getItemAt(8)] != null ? mapObj[keylist.getItemAt(8)].toString() : "";
	        	this.traderId.text = mapObj[keylist.getItemAt(9)] != null ? mapObj[keylist.getItemAt(9)].toString() : "";
                this.brokerCode.text = mapObj[keylist.getItemAt(11)] != null ? mapObj[keylist.getItemAt(11)].toString() : "";	        	
	        	this.extRefNo.text = mapObj[keylist.getItemAt(12)] != null ? mapObj[keylist.getItemAt(12)].toString() : "";
	        	//this.accBalType.text = mapObj[keylist.getItemAt(13)] != null ? mapObj[keylist.getItemAt(13)].toString() : "";
	        	this.tradeCcy.text = mapObj[keylist.getItemAt(14)] != null ? mapObj[keylist.getItemAt(14)].toString() : "";
	        	this.stlCcy.text = mapObj[keylist.getItemAt(15)] != null ? mapObj[keylist.getItemAt(15)].toString() : "";
	        	
	        	this.tradeDate.text = mapObj[keylist.getItemAt(16)] != null ? mapObj[keylist.getItemAt(16)].toString() : "";
	        	this.startDate.text = mapObj[keylist.getItemAt(17)] != null ? mapObj[keylist.getItemAt(17)].toString() : "";
	        	this.endDate.text = mapObj[keylist.getItemAt(20)] != null ? mapObj[keylist.getItemAt(20)].toString() : "";
	        	this.tradeTime.text = mapObj[keylist.getItemAt(19)] != null ? mapObj[keylist.getItemAt(19)].toString() : "";
	        	this.dividentRate.text = mapObj[keylist.getItemAt(21)] != null ? mapObj[keylist.getItemAt(21)].toString() : "";
	        	this.expirationDate.text = mapObj[keylist.getItemAt(18)] != null ? mapObj[keylist.getItemAt(18)].toString() : "";
	        	this.accruedDays.text = mapObj[keylist.getItemAt(22)] != null ? mapObj[keylist.getItemAt(22)].toString() : "";
	        	this.interestAmtVal.text = mapObj[keylist.getItemAt(25)] != null ? mapObj[keylist.getItemAt(25)].toString() : "";
	        	this.interestRateVal.text = mapObj[keylist.getItemAt(23)] != null ? mapObj[keylist.getItemAt(23)].toString() : "";
	        	this.prinAmnt.text = mapObj[keylist.getItemAt(24)] != null ? mapObj[keylist.getItemAt(24)].toString() : "";
	        	this.brokerRefNo.text = mapObj[keylist.getItemAt(31)] != null ? mapObj[keylist.getItemAt(31)].toString() : "";
	        	this.paidInterest.text = mapObj[keylist.getItemAt(33)] != null ? mapObj[keylist.getItemAt(33)].toString() : "";
	        	this.subLimit.text = mapObj[keylist.getItemAt(30)] != null ? mapObj[keylist.getItemAt(30)].toString() : "";
	        	this.commission.text = mapObj[keylist.getItemAt(28)] != null ? mapObj[keylist.getItemAt(28)].toString() : "";
	        	this.remarks.text = mapObj[keylist.getItemAt(32)] != null ? mapObj[keylist.getItemAt(32)].toString() : "";
	        	this.lastActnDate.text = mapObj[keylist.getItemAt(34)] != null ? mapObj[keylist.getItemAt(34)].toString() : "";
	        	if(mapObj[keylist.getItemAt(6)]!=null){
		    	  this.valueDate.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(26)].toString());  		
		    	}
		    	this.tmpSettlementFor = mapObj[keylist.getItemAt(53)].toString();
		    	this.tmpDeliveryMethod = mapObj[keylist.getItemAt(54)].toString();
		    	
	        	/* Populating split drop down*/
	        	initcol = new ArrayCollection();
		    		this.initcol.addItem({label:this.parentApplication.xResourceManager.getKeyValue('slr.label.optionyes'),value:"Y"});
		    		this.initcol.addItem({label:this.parentApplication.xResourceManager.getKeyValue('slr.label.optionno'),value:"N"});
		    	this.split.dataProvider = initcol;
		    	this.split.selectedIndex = 0;
		    	
		    	/* Populating Carryover drop down*/
	        	initcol = new ArrayCollection();
		    		this.initcol.addItem({label:this.parentApplication.xResourceManager.getKeyValue('slr.label.optionyes'),value:"Y"});
		    		this.initcol.addItem({label:this.parentApplication.xResourceManager.getKeyValue('slr.label.optionno'),value:"N"});
		    	this.carryOver.dataProvider = initcol;
		    	this.carryOver.selectedIndex = 0;
	        	
	        	
	        	
	        	//load security info
	        	
	        	 this.ExistingsecurityList = new ArrayCollection();
				    if(mapObj[keylist.getItemAt(42)] != null){
				    	initcol = (mapObj[keylist.getItemAt(42)]) as ArrayCollection;
				    	if(initcol != null){
				    		try {
			                      for each (var item1:XML in initcol) {
			                          ExistingsecurityList.addItem(item1);
			                      }
			                  }catch(e:Error){
			                      XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.errloadingseclist'));
			                }
				    	}
				    }
				 ExistingsecurityList.refresh();
				 
				 // load ssi info
	           this.cashSecFlagSec.text = mapObj[keylist.getItemAt(43)] != null ? mapObj[keylist.getItemAt(43)].toString() : "";
	           this.acronymSec.text = mapObj[keylist.getItemAt(44)] != null ? mapObj[keylist.getItemAt(44)].toString() : "";
	           this.securityTypeSec.text = mapObj[keylist.getItemAt(45)] != null ? mapObj[keylist.getItemAt(45)].toString() : "";
	           this.ccySec.text = mapObj[keylist.getItemAt(46)] != null ? mapObj[keylist.getItemAt(46)].toString() : "";
	           this.stlTypeSec.text = mapObj[keylist.getItemAt(47)] != null ? mapObj[keylist.getItemAt(47)].toString() : "";
	           this.bankNameSec.text = mapObj[keylist.getItemAt(48)] != null ? mapObj[keylist.getItemAt(48)].toString() : "";
	           this.contraIdSec.text = mapObj[keylist.getItemAt(49)] != null ? mapObj[keylist.getItemAt(49)].toString() : "";
	           this.dtcPartNoSec.text = mapObj[keylist.getItemAt(50)] != null ? mapObj[keylist.getItemAt(50)].toString() : "";
	           this.dtcExtStlAccSec.text = mapObj[keylist.getItemAt(51)] != null ? mapObj[keylist.getItemAt(51)].toString() : "";
	           this.prioritySec.text = mapObj[keylist.getItemAt(52)] != null ? mapObj[keylist.getItemAt(52)].toString() : "";
	         }
	         
	         
	         
	         override public function preEntry():void{
			 	//setValidator();
			 	super.getSaveHttpService().url = "slr/SubstitutionActionDispatch.action?";  
			 	var reqObj:Object = populateRequestParam();
			 	reqObj.method = "submitSubstitutionContract";
			 	reqObj.SCREEN_KEY = "135";
	            super.getSaveHttpService().request = reqObj;
			 } 
			 
			 
			 private function populateRequestParam():Object{
	    	var reqObj:Object = new Object();
	    	
			reqObj.rnd = Math.random()+"";
			reqObj['contractNumber'] = this.tmpCntrctNo;
	    	reqObj['versionNo'] = this.tmpVersionNo;
	    	reqObj['openEnded'] = this.openended.text;
	    	reqObj['contractPK'] = this.contractPkStr;
	    	reqObj['tradeType'] = this.tradeType.text;
	    	reqObj['subTradeType'] = this.subTradeType.text;
	    	reqObj['accountNo'] = this.accNo.text;
	    	reqObj['accountPk'] = this.accountPkStr;
	    	reqObj['rr'] = this.rr.text;
	    	reqObj['executingRr'] = this.execRr.text;
	    	reqObj['traderId'] = this.traderId.text;
	    	reqObj['inventoryAccountPk'] =this.invAccountPkStr; 
	    	reqObj['inventoryAccount'] = this.fundAccNo.text;
	    	reqObj['hairCut'] = this.hairCut.text;
	    	reqObj['brokerCode'] = this.brokerCode.text;
	    	reqObj['extRefNo'] = this.extRefNo.text;
	    	//reqObj['accountBalanceTypeValue'] = this.accBalType.text;
	    	reqObj['tradeCurrency'] = this.tradeCcy.text;
	    	reqObj['settlementCurrency'] = this.stlCcy.text;
	    	reqObj['tradeDate'] = this.tradeDate.text;
	    	reqObj['startDate'] = this.startDate.text;
	    	reqObj['tradetime'] = this.tradeTime.text;
	    	reqObj['endDate'] = this.endDate.text;
	    	reqObj['expirationDate'] = this.expirationDate.text;
	    	reqObj['accrualDays'] = this.accruedDays.text;
	    	reqObj['dividendRate'] = this.dividentRate.text;
	    	reqObj['interestAmount'] = this.interestAmtVal.text;
	    	reqObj['interestRate'] = this.interestRateVal.text;
	    	reqObj['netPrincipal'] = this.prinAmnt.text;
	    	reqObj['brokerReferenceNo'] = this.brokerRefNo.text;
	    	reqObj['paidInterest'] = this.paidInterest.text;
	    	reqObj['subLimit'] = this.subLimit.text;
	    	reqObj['commission'] = this.commission.text;
	    	reqObj['remarks'] = this.remarks.text;
	    	reqObj['lastActionDate'] = this.lastActnDate.text;
	    	reqObj['newValueDate']  = StringUtil.trim(this.valueDate.text);
	    	reqObj['split']  = StringUtil.trim(this.split.text);
	    	reqObj['newCarryover']  = StringUtil.trim(this.carryOver.text);
			// write codes for securities
			reqObj['securityCode']  = this.securityCode.instrumentId != null ? StringUtil.trim(this.securityCode.instrumentId.text) : "";
	    	reqObj['price']  = StringUtil.trim(this.securityPrice.text);
	    	reqObj['quantity']  = StringUtil.trim(this.securityQuantity.text);
	    	reqObj['principalAmount']  = StringUtil.trim(this.securityPrincipalAmount.text);
	    	reqObj['inputFactor']  = StringUtil.trim(this.inputFactor.text);
	    	reqObj['startLegExtRefNo']  = StringUtil.trim(this.securityStartLegRefNo.text);
	    	reqObj['endLegExtRefNo']  = StringUtil.trim(this.securityEndLegRefNo.text);
	    	
	    	//send selected row of the existing securities
	    	for each(var secInfo:Object in this.ExistingsecurityList){
		    	reqObj['existingSecurities['+ExistingsecurityList.getItemIndex(secInfo)+'].substnSelect'] = secInfo.substnSelect;
		    }
	    	
	    	// sent ssi info
	    	reqObj['securitySsi.cpSsiPk'] = this.cpSecSsiPk.text;
	    	reqObj['securitySsi.cashSecurityFlag'] = StringUtil.trim(this.cashSecFlagSec.text);
	    	reqObj['securitySsi.acronym'] = StringUtil.trim(this.acronymSec.text);
	    	reqObj['securitySsi.instrumentType'] = StringUtil.trim(this.securityTypeSec.text);
	    	reqObj['securitySsi.settlementCcy'] = StringUtil.trim(this.ccySec.text);
	    	reqObj['securitySsi.settlementType'] = StringUtil.trim(this.stlTypeSec.text);
	    	reqObj['securitySsi.bankName'] = StringUtil.trim(this.bankNameSec.text);
	    	reqObj['securitySsi.contraId'] = StringUtil.trim(this.contraIdSec.text);
	    	reqObj['securitySsi.dtcParticipantNumber'] = StringUtil.trim(this.dtcPartNoSec.text);
	    	reqObj['securitySsi.cpExternalSettleAct'] = StringUtil.trim(this.dtcExtStlAccSec.text);
	    	reqObj['securitySsi.priority'] = StringUtil.trim(this.prioritySec.text);
	    	reqObj['securitySsi.status'] = 'NORMAL';
	    	
	    	
	    	return reqObj;
	    }
			 
			 
			 	override public function preEntryResultHandler():Object
			{
				addCommonResultKeys();
				return keylist;
			} 
			
			private function addCommonResultKeys():void{
	        	keylist.addItem("contractNumber");
		    	keylist.addItem("versionNo");
		    	keylist.addItem("openEnded");
		    	keylist.addItem("tradeType");
		    	keylist.addItem("subTradeType");
		    	keylist.addItem("accountNo");
		    	keylist.addItem("rr");	
		    	keylist.addItem("inventoryAccount");
		    	keylist.addItem("executingRr");
		    	keylist.addItem("traderId");
		    	keylist.addItem("hairCut");
		    	keylist.addItem("brokerCode");
		    	keylist.addItem("extRefNo");
		    	keylist.addItem("accountBalanceType");
		    	keylist.addItem("tradeCurrency");
		    	keylist.addItem("settlementCurrency");
		    	keylist.addItem("tradeDate");
		    	keylist.addItem("startDate");
		    	keylist.addItem("expirationDate");
		    	keylist.addItem("tradeTime");
		    	keylist.addItem("endDate");
		    	keylist.addItem("dividendRate");
		    	keylist.addItem("accrualDays");	
		    	keylist.addItem("interestRate");
		    	keylist.addItem("netPrincipal");
		    	keylist.addItem("interestAmount");
		    	keylist.addItem("newValueDate");
		    	keylist.addItem("newCarryover");
		    	keylist.addItem("commission");
		    	keylist.addItem("newNetAmount");
		    	keylist.addItem("subLimit");
		    	keylist.addItem("brokerReferenceNo");
		    	keylist.addItem("remarks");
		    	keylist.addItem("paidInterest");
		    	keylist.addItem("lastActionDate");
		    	keylist.addItem("accountPk");
		    	keylist.addItem("inventoryAccountPk");
		    	keylist.addItem("securities.security");
		    	keylist.addItem("contractPK");
		    	keylist.addItem("Errors.error");
		    	keylist.addItem("split");
		    	keylist.addItem("newCarryover");
		    	keylist.addItem("existingSecurities.existingSecuritity");
		    	keylist.addItem("securitySsi.cashSecurityFlag");
		    	keylist.addItem("securitySsi.acronym");
		    	keylist.addItem("securitySsi.instrumentType");
		    	keylist.addItem("securitySsi.settlementCcy");
		    	keylist.addItem("securitySsi.settlementType");
		    	keylist.addItem("securitySsi.bankName");
		    	keylist.addItem("securitySsi.contraId");
		    	keylist.addItem("securitySsi.dtcParticipantNumber");
		    	keylist.addItem("securitySsi.cpExternalSettleAct");
		    	keylist.addItem("securitySsi.priority");
		    	keylist.addItem("settlementFor");
		    	keylist.addItem("deliveryMethod");
		    	
		    	
	        }
	        
	         private function addNewSecurity():void{
	       	 var reqSend:Boolean = true;
	    	 reqSend = validateOnAddToNewSecurities();
	    	 if(reqSend){
	    	 var reqObj:Object = new Object();
	    	 reqObj = populateRequestParam();
	    	 reqObj.rnd = Math.random()+"";
	    	
		     reqObj.method = "addNewSecurities";
	    	 addSecurityRequest.request = reqObj;
	    	 addSecurityRequest.send();
	    	 }
	    }
	    
	    private function validateOnAddToNewSecurities():Boolean {
	    	var validationMessage:String = XenosStringUtils.EMPTY_STR;
	    	if(XenosStringUtils.isBlank(this.securityCode.instrumentId.text)){
	    		validationMessage += this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.seccodeempty')+"\n";
	    	}
	    		
	    			if(XenosStringUtils.isBlank(this.securityPrincipalAmount.text)){
	    				if(XenosStringUtils.isBlank(this.securityPrice.text)
	    					|| XenosStringUtils.isBlank(this.securityQuantity.text)){
	    						validationMessage += this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.principalamtoramtandqtyempty')+"\n";
	    					}
	    			}
	    	
	    		
	    	
	    	
	    	if(XenosStringUtils.isBlank(validationMessage)){
	    		return true;
	    	}else{
	    		XenosAlert.error(validationMessage);
	    		return false;
	    	}
	    }
			
			
			
			
			
			override public function postEntryResultHandler(mapObj:Object):void
			{
				commonResult(mapObj);
				app.submitButtonInstance = uConfSubmit;
			}
			 
			private function commonResult(mapObj:Object):void{
		    	if(mapObj!=null){
			    	if(mapObj["errorFlag"].toString() == "error"){
			    		errPage.showError(mapObj["errorMsg"]);		    			
			    	}else if(mapObj["errorFlag"].toString() == "noError"){
			    	 errPage.clearError(super.getSaveResultEvent());			    			
		             commonResultPart(mapObj);
					 changeCurrentState();
					 
			    	}else{
			    		errPage.removeError();
			    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			    	}    		
		    	}
	        } 
			
			
			 private function commonResultPart(mapObj:Object):void{
        		 
        		 conTractRefNo = mapObj[keylist.getItemAt(0)]+"-"+mapObj[keylist.getItemAt(1)];
        		
        		 this.ucontractNo.text = mapObj[keylist.getItemAt(0)]+"-"+mapObj[keylist.getItemAt(1)];
        		  this.uopenended.text = mapObj[keylist.getItemAt(2)];
	             this.utradeType.text = mapObj[keylist.getItemAt(3)];
	             this.uSubTradeType.text = mapObj[keylist.getItemAt(4)];
	             this.uaccNo.text = mapObj[keylist.getItemAt(5)];
	             this.urr.text = mapObj[keylist.getItemAt(6)];
	             this.uexecRr.text = mapObj[keylist.getItemAt(8)];
	             this.utraderId.text = mapObj[keylist.getItemAt(9)];
	              this.ufundAccNo.text = mapObj[keylist.getItemAt(7)];
	              this.uhairCut.text = mapObj[keylist.getItemAt(10)];
	             
	            this.ubrokerCode.text = mapObj[keylist.getItemAt(11)];
	             this.uextRefNo.text = mapObj[keylist.getItemAt(12)];
	             
	             //this.uaccBalType.text = mapObj[keylist.getItemAt(13)];
	            this.utradeCcy.text = mapObj[keylist.getItemAt(14)];
	             this.ustlCcy.text = mapObj[keylist.getItemAt(15)];
	             this.utradeDate.text = mapObj[keylist.getItemAt(16)];
	            
	             this.ustartDate.text = mapObj[keylist.getItemAt(17)];
	             this.utradeTime.text = mapObj[keylist.getItemAt(19)];
	             this.uendDate.text = mapObj[keylist.getItemAt(20)];
	             this.uexpirationDate.text = mapObj[keylist.getItemAt(18)];
	            
	             this.uaccruedDays.text = mapObj[keylist.getItemAt(22)];
	             this.udividentRate.text = mapObj[keylist.getItemAt(21)];
	             this.uinterestAmtVal.text = mapObj[keylist.getItemAt(25)];
	             this.uinterestRateVal.text = mapObj[keylist.getItemAt(23)];
	             this.uprinAmnt.text = mapObj[keylist.getItemAt(24)];
	            
	              this.ubrokerRefNo.text = mapObj[keylist.getItemAt(31)];
	               this.upaidInterest.text = mapObj[keylist.getItemAt(33)];
	               this.usubLimit.text = mapObj[keylist.getItemAt(30)];
	                 this.ucommission.text = mapObj[keylist.getItemAt(28)];
	                this.uremarks.text = mapObj[keylist.getItemAt(32)];
	             this.ulastActnDate.text = mapObj[keylist.getItemAt(34)];
	             this.uvalueDate.text = mapObj[keylist.getItemAt(26)];
	             this.ucarryOver.text = mapObj[keylist.getItemAt(27)];
	            
                // load security list
		         this.securityList = new ArrayCollection();
				    if(mapObj[keylist.getItemAt(37)] != null){
				    	initcol = (mapObj[keylist.getItemAt(37)]) as ArrayCollection;
				    	if(initcol != null){
				    		try {
			                      for each ( var it1:XML in initcol) {
			                          securityList.addItem(it1);
			                      }
			                  }catch(e:Error){
			                      XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.errloadingseclist'));
			                }
				    	}
				    }
				 securityList.refresh();
				 
				 // load existing security list
		         this.ExistingsecurityList = new ArrayCollection();
				    if(mapObj[keylist.getItemAt(42)] != null){
				    	initcol = (mapObj[keylist.getItemAt(42)]) as ArrayCollection;
				    	if(initcol != null){
				    		try {
			                      for each ( var it:XML in initcol) {
			                          ExistingsecurityList.addItem(it);
			                      }
			                  }catch(e:Error){
			                      XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.errloadingseclist'));
			                }
				    	}
				    }
				 ExistingsecurityList.refresh();
				 
				 
				 accountPkStr = mapObj[keylist.getItemAt(35)];
				 invAccountPkStr = mapObj[keylist.getItemAt(36)];
				 
				 // load ssi
				 this.uCashSecFlagSec.text = mapObj[keylist.getItemAt(43)].toString();
	             this.uAcronymSec.text = mapObj[keylist.getItemAt(44)].toString();
	             this.uSecurityTypeSec.text = mapObj[keylist.getItemAt(45)].toString();
	             this.uCcySec.text = mapObj[keylist.getItemAt(46)].toString();
	             this.uStlTypeSec.text = mapObj[keylist.getItemAt(47)].toString();
	             this.uBankNameSec.text = mapObj[keylist.getItemAt(48)].toString();
	             this.uContraIdSec.text = mapObj[keylist.getItemAt(49)].toString();
	             this.uDtcPartNoSec.text = mapObj[keylist.getItemAt(50)].toString();
	             this.uDtcExtStlAccSec.text = mapObj[keylist.getItemAt(51)].toString();
	             this.uPrioritySec.text = mapObj[keylist.getItemAt(52)].toString();
				 
	        } 
			
			
			override public function preEntryConfirm():void
			{
				var reqObj :Object = new Object();
				super.getConfHttpService().url = "slr/SubstitutionActionDispatch.action?";  
				reqObj.method= "commitSubstitutionContract";
				reqObj.SCREEN_KEY = "136";
				reqObj.rnd = Math.random()+"";
	            super.getConfHttpService().request = reqObj;
			}
			
			
			override public function postConfirmEntryResultHandler(mapObj:Object):void
			{
				submitUserConfResult(mapObj);
			}
			
			private function submitUserConfResult(mapObj:Object):void{
		    	if(mapObj!=null){ 
			    	if(mapObj["errorFlag"].toString() == "error"){
			    		usrConfErrPage.showError(mapObj["errorMsg"]);
			    		uConfLabel.includeInLayout = true;
		               	uConfLabel.visible = true;
		               	sConfLabel.includeInLayout = false;
		                sConfLabel.visible = false;
						uConfSubmit.includeInLayout = true;
		                uConfSubmit.visible = true;
		                
			    	}else if(mapObj["errorFlag"].toString() == "noError"){
			    	   commonResultPart(mapObj);
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
		               hb.visible = true;
	               	   hb.includeInLayout = true; 
	               	   this.usecInfo.visible = false;
	               	   this.usecInfo.includeInLayout = false;
	               	   this.hideForSC.visible = false;
	               	   this.uExsecInfo.label = this.parentApplication.xResourceManager.getKeyValue('slr.instrument.label.securityheader');
		               app.submitButtonInstance = sConfSubmit;       
			    	}else{
			    		errPage.removeError();
			    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('slr.label.erroroccured'));
			    	}    		
		    	}
		    }
		    
		    override public function preEntryConfirmResultHandler():Object{
				addCommonResultKeys();
				return keylist;
			}
		    
		    
			  override public function preResetEntry():void
		   {
		      /*  var rndNo:Number= Math.random();
		  		super.getResetHttpService().url = "slr/slrContractEntryAmendDispatch.action?method=resetAmendForm&rnd=" + rndNo; */ 
		   } 
		   
		   
			/*  */
			
			 override public function doEntrySystemConfirm(e:Event):void
			{
				 this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
			    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
			}
			
	/* 			override public function preConfirmEntryResultHandler():Object{
			addCommonResultKeys();
			return keylist;
		} */
		
		  private function doBack():void{
	  	 app.submitButtonInstance = submit;
	     vstack.selectedChild = qry;
	  } 
	  
	   private function doSave():void{
	    	if(uConfSubmit.enabled == true){
	    		this.dispatchEvent(new Event('entryConf'));
	    	}
	    	uConfSubmit.enabled = false;
	    }
	    
	    
	    
	    
	     public function editSecurity(data:Object):void{
				editSecurityRequest.url = 'slr/SubstitutionActionDispatch.action?';
				
			editSecurityRequest.request = populateReqForSecurityEdit(data);
    		editSecurityRequest.send();
		}
		private function populateReqForSecurityEdit(data:Object):Object{
	    	var reqObj : Object = new Object();
	    	reqObj.rnd = Math.random()+"";
	    	reqObj.method= "editNewSecurities";
    		reqObj.rowNo = this.securityList.getItemIndex(data);
    		reqObj.securityCode = data.securityCode;
	    	return reqObj;
	    }
		
		private function loadEditedSecurity(event:ResultEvent):void{
	    	if(event != null){
	    		if(event.result != null){
	    			if(event.result.slrContractModifyActionForm != null){
	    				errPage.clearError(super.getInitResultEvent());
	    				securityList = new ArrayCollection();
	    				if(event.result.slrContractModifyActionForm.securities != null){
	    					if(event.result.slrContractModifyActionForm.securities.security != null){
	    						if(event.result.slrContractModifyActionForm.securities.security is ArrayCollection){
	    							securityList = (event.result.slrContractModifyActionForm.securities.security) as ArrayCollection;
	    						}else{
	    							securityList.addItem(event.result.slrContractModifyActionForm.securities.security);
	    						}
	    					}
	    				}
	    				securityList.refresh();
	    				this.securityCode.instrumentId.text = event.result.slrContractModifyActionForm.securityCode;
	    				this.securityPrice.text = event.result.slrContractModifyActionForm.price;
	    				this.securityQuantity.text = event.result.slrContractModifyActionForm.quantity;
	    				this.securityPrincipalAmount.text = event.result.slrContractModifyActionForm.principalAmount;
	    				this.inputFactor.text = event.result.slrContractModifyActionForm.inputFactor;
	    				this.securityStartLegRefNo.text = event.result.slrContractModifyActionForm.startLegExtRefNo;
	    				this.securityEndLegRefNo.text = event.result.slrContractModifyActionForm.endLegExtRefNo;
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
				deleteSecurityRequest.url = 'slr/SubstitutionActionDispatch.action?';
			deleteSecurityRequest.request = populateReqForSecurityDelete(data);
    		deleteSecurityRequest.send();
		}
		
		private function populateReqForSecurityDelete(data:Object):Object{
	    	var reqObj : Object = new Object();
	    	reqObj.rnd = Math.random()+"";
	    	reqObj.method= "deleteNewSecurities";
    		reqObj.rowNo = this.securityList.getItemIndex(data);
    		reqObj.securityCode = data.securityCode;
	    	return reqObj;
	    }
	    
	    private function loadDeletedSecurity(event:ResultEvent):void{
	    	if(event != null){
	    		if(event.result != null){
	    			if(event.result.slrContractModifyActionForm != null){
	    				errPage.clearError(super.getInitResultEvent());
	    				securityList = new ArrayCollection();
	    				if(event.result.slrContractModifyActionForm.securities != null){
	    					if(event.result.slrContractModifyActionForm.securities.security != null){
	    						if(event.result.slrContractModifyActionForm.securities.security is ArrayCollection){
	    							securityList = (event.result.slrContractModifyActionForm.securities.security) as ArrayCollection;
	    						}else{
	    							securityList.addItem(event.result.slrContractModifyActionForm.securities.security);
	    						}
	    					}
	    				}
	    				securityList.refresh();
	    				this.securityCode.instrumentId.text = "";
	    				this.securityPrice.text = "";
	    				this.securityQuantity.text = "";
	    				this.securityPrincipalAmount.text = "";
	    				this.inputFactor.text = "";
	    				this.securityStartLegRefNo.text = "";
	    				this.securityEndLegRefNo.text = "";
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
	    
	    private function loadSecurity(event:ResultEvent):void{
	    	if(event != null){
	    		if(event.result != null){
	    			if(event.result.slrContractModifyActionForm != null){ 
	    				errPage.clearError(super.getInitResultEvent());
	    				securityList = new ArrayCollection();
	    				if(event.result.slrContractModifyActionForm.securities != null){
	    					if(event.result.slrContractModifyActionForm.securities.security != null){
	    						if(event.result.slrContractModifyActionForm.securities.security is ArrayCollection){
	    							securityList = (event.result.slrContractModifyActionForm.securities.security) as ArrayCollection;
	    						}else{
	    							securityList.addItem(event.result.slrContractModifyActionForm.securities.security);
	    						}
	    					}
	    				}
	    				securityList.refresh();
	    				this.securityCode.instrumentId.text = "";
	    				this.securityPrice.text = "";
	    				this.securityQuantity.text = "";
	    				this.securityPrincipalAmount.text = "";
	    				this.inputFactor.text = "";
	    				this.securityStartLegRefNo.text = "";
	    				this.securityEndLegRefNo.text = "";
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
	    
	    private function selectSecSsi():void{
		   	var ssiRulePopUp:TrdSsiPopup = TrdSsiPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication), TrdSsiPopup , true));
		   	PopUpManager.centerPopUp(ssiRulePopUp);
                
            var recItem:ArrayCollection = new ArrayCollection();
            
            var accountNoArray:Array = new Array(1);
 	   	  	accountNoArray[0]= this.accNo.text;
 	   	  	recItem.addItem(new HiddenObject("accountNo",accountNoArray));
 	   	  	
 	   	  	var stlCcyArray:Array = new Array(1);
 	   	  	stlCcyArray[0]= this.stlCcy.text;
 	   	  	recItem.addItem(new HiddenObject("settlementCurrency",stlCcyArray));
 	   	  	
 	   	  	var subTradeTypeArray:Array = new Array(1);
 	   	  	subTradeTypeArray[0]= this.subTradeType.text;
 	   	  	recItem.addItem(new HiddenObject("subTradeType",subTradeTypeArray));
 	   	  	
            var tradeTypeArray:Array = new Array(1);
 	   	  	tradeTypeArray[0]= this.tradeType.text;
 	   	  	recItem.addItem(new HiddenObject("tradeType",tradeTypeArray));
 	   	  	
 	   	  	var secFlagArray:Array = new Array(1);
 	   	  	secFlagArray[0]= "SECURITY";
 	   	  	recItem.addItem(new HiddenObject("secFlag",secFlagArray));
 	   	  	
 	   	  	var moduleArray:Array = new Array(1);
 	   	  	moduleArray[0]= "SLR";
 	   	  	recItem.addItem(new HiddenObject("module",moduleArray));
 	   	  	
 	   	  	var contractPkArray:Array = new Array(1);
 	   	  	contractPkArray[0]= this.contractPkStr;
 	   	  	recItem.addItem(new HiddenObject("contractPk",contractPkArray));
 	   	  	
 	   	  	var settlementForArray:Array = new Array(1);
 	   	  	settlementForArray[0]= this.tmpSettlementFor;
 	   	  	recItem.addItem(new HiddenObject("settlementFor",settlementForArray));
 	   	  	
 	   	  	var deliveryMethodArray:Array = new Array(1);
 	   	  	deliveryMethodArray[0]= this.tmpDeliveryMethod;
 	   	  	recItem.addItem(new HiddenObject("deliveryMethod",deliveryMethodArray));
 	   	  	
 	   	  	
 	   	  	
 	   	  	
 	   	  	
 	   	  	ssiRulePopUp.showCloseButton=true; 		   	  	
	        ssiRulePopUp.owner = this;
	        ssiRulePopUp.receiveCtxItems = recItem;
	        
	        ssiRulePopUp.retCpSecSsiPk = this.cpSecSsiPk;
	        ssiRulePopUp.retSecurityFlag = this.cashSecFlagSec;
	        ssiRulePopUp.retAcronymForSec = this.acronymSec;
	        ssiRulePopUp.retInstrumentTypeForSec = this.securityTypeSec;
	        ssiRulePopUp.retSettlementCcyForSec = this.ccySec;
	        ssiRulePopUp.retSettlementTypeForSec = this.stlTypeSec;
	        ssiRulePopUp.retBankNameForSec = this.bankNameSec;
	        ssiRulePopUp.retContraIdForSec = this.contraIdSec;
	        ssiRulePopUp.retDtcParticipantNumberForSec = this.dtcPartNoSec;
	        ssiRulePopUp.retCpExternalSettleActForSec = this.dtcExtStlAccSec;
	        ssiRulePopUp.retPriorityForSec = this.prioritySec;
	        ssiRulePopUp.retStatusSec = this.statusSec;
	       
	        ssiRulePopUp.initSsiInfoPopup();
	   }
	    private function clearSecSsi():void{
		   	var reqObj:Object = new Object();
			reqObj.rnd = Math.random()+"";
			reqObj.method = "clearSsi";
			reqObj.cashSec = "SECURITY";
			resetSecuritySsiRequest.request = reqObj;
		   	resetSecuritySsiRequest.send();
		}
		
		private function loadResetSecuritySsi(event:ResultEvent):void{
		   	cashSecFlagSec.text = "";
	        acronymSec.text = "";
	        securityTypeSec.text = "";
	        ccySec.text = "";
	        stlTypeSec.text = "";
	        bankNameSec.text = "";
	        contraIdSec.text = "";
	        dtcPartNoSec.text = "";
	        dtcExtStlAccSec.text = "";
	        prioritySec.text = "";
	   }
	   
