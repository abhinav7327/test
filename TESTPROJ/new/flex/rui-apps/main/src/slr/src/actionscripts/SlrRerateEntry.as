import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.utils.XenosStringUtils;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;
					
			  
		     [Bindable]
		     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     
            [Bindable]private var actiontypemode : String = "rerate";
            [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
            [Bindable]private var trdTypeDP:ArrayCollection = new ArrayCollection();
            [Bindable]private var securityList:ArrayCollection = new ArrayCollection();
            [Bindable]private var contractPkStr : String = "";
            [Bindable]private var conTractRefNo:String = XenosStringUtils.EMPTY_STR;
            [Bindable]private var accountPkStr:String = XenosStringUtils.EMPTY_STR;
	        [Bindable]private var invAccountPkStr:String = XenosStringUtils.EMPTY_STR;
	        [Bindable]private var tmpCntrctNo:String = XenosStringUtils.EMPTY_STR;
	        [Bindable]private var tmpVersionNo:String = XenosStringUtils.EMPTY_STR;
	        [Bindable]private var interestManual:String = 'false';
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
	       	   if(this.actiontypemode == 'RERATE'){
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
                    	actiontypemode = "RERATE";
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
            	initLabel.text = this.parentApplication.xResourceManager.getKeyValue('slr.label.slrrerateentry');       	
		        var rndNo:Number= Math.random(); 
            	super.getInitHttpService().url = "slr/ContractDetailsDispatch.action?";
            	var reqObject:Object = new Object();
            	reqObject.rnd = rndNo;
            	reqObject.method= "contractActionEntryExecute";
            	reqObject.SCREEN_KEY = "132";
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
	         var isSuccess:Boolean = true; 	
			if(mapObj[keylist.getItemAt(39)] != null)
			 {
			 	
				var errStr:String = XenosStringUtils.EMPTY_STR;
				initcol = new ArrayCollection();
				initcol = mapObj[keylist.getItemAt(39)] as ArrayCollection;
				var lngth:int = initcol.length;
				if(lngth==1){
					if(initcol.getItemAt(0).toString()=="OK"){
						isSuccess = true;
					}
					else{
						isSuccess = false;
					}
				}
				else if(lngth>1){
				 isSuccess = false;	
				}
				if(!isSuccess){
					for each(var it:Object in initcol){
					errStr = errStr + "\n" + initcol.getItemAt(initcol.getItemIndex(it));
				}
				this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
				XenosAlert.error(errStr);
				}
				
			}
			if(isSuccess){
	        	app.submitButtonInstance = submit;
	        	//hide interest amount if end date is not present 
	        	if((mapObj[keylist.getItemAt(20)]==null)||(StringUtil.trim(mapObj[keylist.getItemAt(20)])==""))
	        	{
                   this.hideFornoenddate.visible=false;
                   this.hideFornoenddate.includeInLayout=false;	        		
	        	}
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
	        	this.interestAmount.text = mapObj[keylist.getItemAt(25)] != null ? mapObj[keylist.getItemAt(25)].toString() : "";
	        	this.interestRateVal.text = mapObj[keylist.getItemAt(23)] != null ? mapObj[keylist.getItemAt(23)].toString() : "";
	        	this.interestRate.text = mapObj[keylist.getItemAt(23)] != null ? mapObj[keylist.getItemAt(23)].toString() : "";
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
		    	this.netAmountEd.text = mapObj[keylist.getItemAt(29)] != null ? mapObj[keylist.getItemAt(29)].toString() : "";
	        	
	        	//load security info
	        	
	        	 this.securityList = new ArrayCollection();
				    if(mapObj[keylist.getItemAt(37)] != null){
				    	initcol = (mapObj[keylist.getItemAt(37)]) as ArrayCollection;
				    	if(initcol != null){
				    		try {
			                      for each (var item1:XML in initcol) {
			                          securityList.addItem(item1);
			                      }
			                  }catch(e:Error){
			                      XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.errloadingseclist'));
			                }
				    	}
				    }
				 securityList.refresh();
	        
	         }
	         }
	         override public function preEntry():void{
			 	//setValidator();
			 	super.getSaveHttpService().url = "slr/RerateActionDispatch.action?";  
			 	var reqObj:Object = populateRequestParam();
			 	reqObj.method = "submitRerateContract";
			 	reqObj.SCREEN_KEY = 11115;
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
	    	reqObj['newInterestAmount']  = StringUtil.trim(this.interestAmount.text);
	    	reqObj['newInterestRate']  = StringUtil.trim(this.interestRate.text);
	    	reqObj['manualInterest'] = this.interestManual;
			for each(var secInfo:Object in this.securityList){
				reqObj['securityInfo['+securityList.getItemIndex(secInfo)+'].interest'] = secInfo.interest;
				reqObj['securityInfo['+securityList.getItemIndex(secInfo)+'].manualInterest'] = secInfo.manualInterest;
				reqObj['securityInfo['+securityList.getItemIndex(secInfo)+'].manualNetAmount'] = secInfo.manualNetAmount;
				reqObj['securityInfo['+securityList.getItemIndex(secInfo)+'].netAmount'] = secInfo.netAmount;
	    	}   	
	    	
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
	             
	            // this.uaccBalType.text = mapObj[keylist.getItemAt(13)];
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
	            

		         this.securityList = new ArrayCollection();
				    if(mapObj[keylist.getItemAt(37)] != null){
				    	initcol = (mapObj[keylist.getItemAt(37)]) as ArrayCollection;
				    	if(initcol != null){
				    		try {
			                      for each ( var it:XML in initcol) {
			                          securityList.addItem(it);
			                      }
			                  }catch(e:Error){
			                      XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.errloadingseclist'));
			                }
				    	}
				    }
				 securityList.refresh();
				 
				 
				 accountPkStr = mapObj[keylist.getItemAt(35)];
				 invAccountPkStr = mapObj[keylist.getItemAt(36)];
				 
	        } 
			
			
			override public function preEntryConfirm():void
			{
				var reqObj :Object = new Object();
				super.getConfHttpService().url = "slr/RerateActionDispatch.action?";  
				reqObj.method= "commitContract";
				reqObj.SCREEN_KEY = 11116;
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
	               	   this.hideInSysconfrm.visible = false;
	               	     this.hideInSysconfrm.includeInLayout = false;
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
	    
	     private function calculateInterestAmount():void{
	    	
	    		var reqObj:Object = new Object();
	    		var send:Boolean = false;
	    		if(((this.valueDate.text!=null)&&(StringUtil.trim(this.valueDate.text)!=""))
	    		       &&((this.interestRate.text!=null)&&(StringUtil.trim(this.interestRate.text)!="")))
	    		 {
	    		  send=true;	
	    		}
	    		if(send==true){
		    	reqObj = populateRequestParam();
		    	reqObj.method = "calculateInterestAmount";
		    	reqObj.rnd = Math.random()+"";
		    	calculationRequest.request = reqObj;
		    	calculationRequest.send();
		    	}
		    	else{
		    		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('slr.validation.error.valuedateorintrateempty'));
		    	}
	    	
	    }
	    public function calculateSecInterestAmt(sec:Object):void {
	    	var reqObj:Object = new Object();
	    	reqObj = populateRequestParam();
	    	reqObj.method = "calculateSecurityInterestAmount";
	    	reqObj.rnd = Math.random()+"";
	    	reqObj.pk = sec.pk;
	    	secCalculationRequest.request = reqObj;
	    	secCalculationRequest.send();
	    }
	    public function calculateSecNetAmt(sec:Object):void {
	    	var reqObj:Object = new Object();
	    	reqObj = populateRequestParam();
	    	reqObj.method = "calculateSecurityNetAmount";
	    	reqObj.rnd = Math.random()+"";
	    	reqObj.pk = sec.pk;
	    	secCalculationRequest.request = reqObj;
	    	secCalculationRequest.send();
	    }
	    
	    private function calculateNetAmount():void{
	    		var reqObj:Object = new Object();
		    	reqObj = populateRequestParam();
		    	reqObj.method = "calculateNetAmount";
		    	reqObj.rnd = Math.random()+"";
		    	calculationRequest.request = reqObj;
		    	calculationRequest.send();
	    }
	    
	    private function loadSecurityCalculatedFields(event:ResultEvent):void {
	    	if(event != null){
	    		if(event.result != null){
	    			if(event.result.slrContractModifyActionForm != null){
	    				securityList = new ArrayCollection();
	    				errPage.clearError(super.getInitResultEvent());
	    				if(event.result.slrContractModifyActionForm.securities != null){
	    					if(event.result.slrContractModifyActionForm.securities.security != null){
		    					if(event.result.slrContractModifyActionForm.securities.security is ArrayCollection){
			    					securityList = event.result.slrContractModifyActionForm.securities.security as ArrayCollection;
			    				}else{
			    					securityList.addItem(event.result.slrContractModifyActionForm.securities.security);
			    				}
			    				securityList.refresh();
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
	      private function changeInterestAmt(event:Event):void {
	   	 interestManual = 'true';
	   }
	    
	    private function loadCalculatedFields(event:ResultEvent):void{
	    	if(event != null){
	    		if(event.result != null){
	    			if(event.result.slrContractModifyActionForm != null){
	    				errPage.clearError(super.getInitResultEvent());
	    				this.interestAmount.text = event.result.slrContractModifyActionForm.newInterestAmount;
	    				this.netAmountEd.text = event.result.slrContractModifyActionForm.newNetAmount;
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
            