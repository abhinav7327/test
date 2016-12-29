
        // ActionScript file for Own stl Standing entry
        import com.nri.rui.core.Globals;
        import com.nri.rui.core.controls.XenosAlert;
        import com.nri.rui.core.startup.XenosApplication;
        import com.nri.rui.core.utils.HiddenObject;
        import com.nri.rui.core.utils.XenosStringUtils;
        import com.nri.rui.ref.popupImpl.FinInstitutePopUpHbox;
        import com.nri.rui.core.controls.XenosEntry;
        import com.nri.rui.ref.validators.OwnSettleStandingEntryValidator;
        
        
        import flash.events.Event;
        import flash.events.MouseEvent;
        
        import mx.collections.ArrayCollection;
        import mx.controls.CheckBox;
        import mx.events.CloseEvent;
        import mx.events.FlexEvent;
        import mx.rpc.events.ResultEvent;
        import mx.utils.StringUtil;
        
                    
              
             [Bindable]
             private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     
            [Bindable]private var mode : String = "add";
            [Bindable]private var ownStandingrulePkStr : String = "";
            [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
               [Bindable]public var returnContextItems:ArrayCollection = new ArrayCollection();
            [Bindable]private var trdTypeDP:ArrayCollection = new ArrayCollection();
            private var keylist:ArrayCollection = new ArrayCollection();
            [Bindable]private var showCashDetailFlag : String = "Y";
            [Bindable]private var showCashDetailEntry : String = "false";
            [Bindable]private var dfltOwnSsiRule : String = "false";
            [Bindable]private var inxVal : String = "";
            [Bindable]private var diffCashForAgainstFlag : String = "";
            [Bindable]private var ownSsiRulePk : String = "-1";
            [Bindable]private var cpCodeBroker:FinInstitutePopUpHbox = new FinInstitutePopUpHbox();
        	private var stlModeCashList:ArrayCollection = new ArrayCollection();
        	private var cashPriorList:ArrayCollection = new ArrayCollection();
            
            [Bindable]
		    private var tempMode:String;
      
              private function changeCurrentState():void{
                        vstack.selectedChild = rslt;
             }
             
            
        /**
         * Load the Entry/Amend/Cancel according to 
         * the operational mode (e.g. Entry/Amend/Cancel)
         */  
           public function loadAll():void{
           	   this.addEventListener("ownSsiSelectEvent",cashExistingRuleChanged,false,100,true);
           	   settlementAcc.accountPopup.addEventListener(MouseEvent.CLICK,onClickSettActpopup,false,100,true);
           	   cashSettlementAcc.accountPopup.addEventListener(MouseEvent.CLICK,onClickCashSettActpopup,false,100,true);
               parseUrlString();
               super.setXenosEntryControl(new XenosEntry());
               if(this.mode == 'entry'){
               	tempMode = "Entry";
           	   	 this.dispatchEvent(new Event('entryInit'));
           	   	 vstack.selectedChild = qry;
           	   } else if(this.mode == 'add'){
           	   	tempMode = "Amend";
           	   	 this.dispatchEvent(new Event('amendEntryInit'));
           	   	 vstack.selectedChild = qry;
           	   } else { 
           	   	tempMode = "Cancel";
           	     this.dispatchEvent(new Event('cancelEntryInit'));
           	   }
           }
           
           private function cashExistingRuleChanged(evt:Event):void{
           		var modeIndex : int = 0;
           		var priorityIndex :int =0;
           	           		
            	for (var i: int=0; i< stlModeCashList.length; i++){
           			if(XenosStringUtils.equals(stlModeCashList[i].value , returnContextItems.getItemAt(0).toString())){
           				modeIndex = stlModeCashList.getItemIndex(i);
           				editCashStlMode.selectedIndex = i;
           			}           			
           		}
           		
           		cashSettlemetBank.finInstCode.text = returnContextItems.getItemAt(1).toString();
           		cashSettlementAcc.accountNo.text = returnContextItems.getItemAt(2).toString();
           		
            	for (var j: int=0; j< cashPriorList.length; j++){
           			if(XenosStringUtils.equals(cashPriorList[j].value , returnContextItems.getItemAt(3).toString())){
           				priorityIndex = cashPriorList.getItemIndex(j);
           				editCashPriority.selectedIndex = j;
           			}           			
           		}
           		editCashExistingRule.ownSsiRule.enabled = false;
           		editCashStlMode.enabled = false;
           		editCashPriority.enabled = false;
           		cashSettlemetBank.finInstCode.enabled = false;
           		cashSettlemetBank.finInstPopup.visible = false;
           		cashSettlementAcc.accountNo.enabled = false;
           		cashSettlementAcc.accountPopup.visible = false;
           }
           
           private function clearCashDetails():void{
           		editCashExistingRule.ownSsiRule.enabled = false;
           		editCashStlMode.enabled = true;
           		editCashPriority.enabled = true;
           		cashSettlemetBank.finInstCode.enabled = true;
           		cashSettlemetBank.finInstPopup.visible = true;
           		cashSettlementAcc.accountNo.enabled = true;
           		cashSettlementAcc.accountPopup.visible = true;
           		
           		editCashExistingRule.ownSsiRule.text = "";
           		editCashStlMode.selectedIndex = 0;
           		editCashPriority.selectedIndex = 0;
           		cashSettlemetBank.finInstCode.text = "";
           		cashSettlementAcc.accountNo.text = "";
           }

           private function onClickSettActpopup(evt:Event):void{
           		if(StringUtil.trim(settlemetBank.finInstCode.text) == XenosStringUtils.EMPTY_STR) {
           			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.ownssirule.msg.info.missing.stlbank'));
           			evt.stopImmediatePropagation();
           		}else{
           			 settlementAcc.recContextItem=populateSettActContext();
           		}
           }
            private function onClickCashSettActpopup(evt:Event):void{
           		if(StringUtil.trim(cashSettlemetBank.finInstCode.text) == XenosStringUtils.EMPTY_STR) {
           			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.ownssirule.msg.info.missing.cashstlbank'));
           			evt.stopImmediatePropagation();
           		}else{
           			 cashSettlementAcc.recContextItem=populateCashSettActContext();
           		}
           }
           
           private function settlementBankChange(e:Event):void{
           		var reqObj:Object=new Object();
           		reqObj['ownStandingRule.settlementBank']=settlemetBank.finInstCode.text;
           		loadSettlementActForStlBank.request=reqObj;
           		loadSettlementActForStlBank.send();
           }
           
           private function loadSettlementActForStlBankResult(event:ResultEvent):void{
           	  var rs:XML = XML(event.result);
        
		        if (null != event) {
		            if(rs.child("Errors").length()>0){
		                // i.e. Must be error, display it .
		                var errorInfoList : ArrayCollection = new ArrayCollection();
		                //populate the error info list              
		                for each ( var error:XML in rs.Errors.error ) {
		                    errorInfoList.addItem(error.toString());
		                }
		                errPage.showError(errorInfoList);//Display the error
		            } else {
		                // Clear the error
		                errPage.removeError();
		                if(rs.ownStandingRule.multipleSettlActPresent==true || rs.ownStandingRule.multipleSettlActPresent.toString()=='true' ){
		                   XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.ownssirule.msg.info.multiplestlacc', new Array(this.settlemetBank.finInstCode.text)));
		                }
		            }
		            this.settlementAcc.accountNo.text=rs.ownStandingRule.stlAccount.toString();            
		        }else {
		            XenosAlert.info("event = null");
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
                            }else if(tempA[0] == "ownSettleStandingRulePk"){
                                this.ownStandingrulePkStr = tempA[1];
                            }
                        }                       
                    }else{
                        mode = "entry";
                    }                 
                } catch (e:Error) {
                    trace(e);
                }               
            }
            
            /**
            * This method fires the dispatchaction to initialize the
            */

           override public function preEntryInit():void{            	
		        var rndNo:Number= Math.random(); 
            	super.getInitHttpService().url = "ref/ownStandingAmendQueryDispatch.action?method=doAdd&mode=entry&SCREEN_KEY=184&menuType=Y&rnd=" + rndNo;
           }
            /**
            * This method fires the dispatchaction to initialize the
            */
            override public function preAmendInit():void{     
                var rndNo:Number= Math.random(); 
                super.getInitHttpService().url = "ref/ownStandingAmendQueryDispatch.action?";
                var reqObject:Object = new Object();
                reqObject.rnd = rndNo;
                reqObject.method= "doAmend";
                reqObject.SCREEN_KEY = 911;
                reqObject.mode=this.mode;
                reqObject.pk = this.ownStandingrulePkStr;
                super.getInitHttpService().request = reqObject;
            }
            
            /**
            * This method fires the dispatchaction to initialize the
            * Banking Trade Cancel Screen (InitCancel-SEQ-1)
            */
            override public function preCancelInit():void{              
                this.back.includeInLayout = false;
                this.back.visible = false;
                changeCurrentState();                           
                var rndNo:Number= Math.random(); 
                super.getInitHttpService().url = "ref/ownStandingCxlQueryDispatch.action?";
                var reqObject:Object = new Object();
                reqObject.rnd = rndNo;
                reqObject.method= "doDelete";
                reqObject.mode=this.mode;
                reqObject.SCREEN_KEY = 824;
                reqObject.pk = this.ownStandingrulePkStr;
                super.getInitHttpService().request = reqObject;
            }
        
            /**
            * This method is pre-result handler for the Banking Trade Entry
            * Screen. It generates the list of keys which will be populated 
            * during the initialization of the Banking trade Entry screen. 
            * (InitEntry-SEQ-2)
            */
            override public function preEntryResultInit():Object{
                addCommonKeys();
                keylist.addItem("ownStandingRule.fundCode");
	        	keylist.addItem("ownStandingRule.inventoryAccount");
		    	keylist.addItem("ownStandingRule.settlementFor");
		    	keylist.addItem("ownStandingRule.cashSecurityFlag");
		    	keylist.addItem("ownStandingRule.custodian");
		    	keylist.addItem("ownStandingRule.stlAccount");
		    	keylist.addItem("ownStandingRule.instrumentType");
		    	keylist.addItem("ownStandingRule.settlementLocation");
		    	keylist.addItem("ownStandingRule.settlementCcy");
		    	keylist.addItem("ownStandingRule.instrumentCode");
		    	keylist.addItem("counterpartyCodeExp");
		    	keylist.addItem("ownStandingRule.tradingAccount");
		    	keylist.addItem("ownStandingRule.instructionReqd");
		    	keylist.addItem("ownStandingRule.autoTransmissionFlag");
		    	keylist.addItem("ownStandingRule.priority");
		    	keylist.addItem("ownStandingRule.marketCode");
		    	keylist.addItem("cashForAgainst");
		    	keylist.addItem("ownStandingRule.settlementMode");
		    	keylist.addItem("existingRuleId");
		    	keylist.addItem("cashStandingRule.settlementMode");
		    	keylist.addItem("cashStandingRule.priority");
		    	keylist.addItem("cashStandingRule.custodian");
		    	keylist.addItem("cashStandingRule.stlAccount");
		    	keylist.addItem("diffCashForAgainst");
		    	keylist.addItem("ownStandingRule.defaultOwnSsiRule"); 
		    	keylist.addItem("ownStandingRule.ownSettleStandingRulePk");
	        	addCommonKeysForList();
                return keylist;
            }
            
            /**
            * This method is pre-result handler for the Banking Trade Amend
            * Screen. It generates the list of keys which will be populated 
            * during the initialization of the Banking trade Amend screen. 
            * (InitAmend-SEQ-2)
            */
            override public function preAmendResultInit():Object{
                 addCommonKeys(); 
                keylist.addItem("ownStandingRule.fundCode");
                keylist.addItem("ownStandingRule.inventoryAccount");
                keylist.addItem("ownStandingRule.settlementFor");
                keylist.addItem("ownStandingRule.cashSecurityFlag");
                keylist.addItem("ownStandingRule.custodian");
		    	keylist.addItem("ownStandingRule.stlAccount");
                keylist.addItem("ownStandingRule.instrumentType");
                keylist.addItem("ownStandingRule.settlementLocation");
                keylist.addItem("ownStandingRule.settlementCcy");
                keylist.addItem("ownStandingRule.instrumentCode");
                keylist.addItem("counterpartyCodeExp");
                keylist.addItem("ownStandingRule.tradingAccount");
                keylist.addItem("ownStandingRule.instructionReqd");
                keylist.addItem("ownStandingRule.autoTransmissionFlag");
                keylist.addItem("ownStandingRule.priority");
                keylist.addItem("ownStandingRule.marketCode");
                keylist.addItem("cashForAgainst");
                keylist.addItem("ownStandingRule.settlementMode");
                keylist.addItem("existingRuleId");
                keylist.addItem("cashStandingRule.settlementMode");
                keylist.addItem("cashStandingRule.priority");
                keylist.addItem("cashStandingRule.custodian");
                keylist.addItem("cashStandingRule.stlAccount");
                keylist.addItem("diffCashForAgainst");
                keylist.addItem("ownStandingRule.defaultOwnSsiRule"); 
                keylist.addItem("ownStandingRule.ownSettleStandingRulePk");
                addCommonKeysForList();
                return keylist;
            }
            
            /**
            * This method is pre-result handler for the Banking Trade Cancel
            * Screen. It generates the list of keys which will be populated 
            * during the initialization of the Own Stl Standing rule Cancel screen. 
            * (InitCancel-SEQ-2)
            */
            override public function preCancelResultInit():Object{
                addCommonResultKes();           
                return keylist;
            }
            
            
            /**
            * This method populates the elements of the Banking
            * Trade Entry screen(mxml)
            * from the map obtained from preEntryResultInit() (InitEntry-SEQ-3)
            */
            override public function postEntryResultInit(mapObj:Object): void{
                app.submitButtonInstance = submit;
	        	commonInit(mapObj);
	        	settlemetBank.finInstCode.addEventListener(FlexEvent.VALUE_COMMIT,settlementBankChange);
            }
            
            /**
            * This method populates the elements of the Banking
            * Trade Amend screen(mxml)
            * from the map obtained from preAmendResultInit() (InitAmend-SEQ-3)
            */
            override public function postAmendResultInit(mapObj:Object): void{
            	errPage.clearError(super.getInitResultEvent());
                app.submitButtonInstance = submit;
	        	ownSsiRulePk = mapObj[keylist.getItemAt(29)].toString();
	        	dfltOwnSsiRule = mapObj[keylist.getItemAt(28)].toString();
	        	showCashDetailEntry = mapObj[keylist.getItemAt(20)].toString();
	        	if(showCashDetailEntry=="true"){
	        		this.editDiffAgainst.selected = true;
	        		this.editCashPriority.enabled = false;
        			this.cashSettlemetBank.finInstPopup.visible = false;
        			this.cashSettlemetBank.finInstPopup.includeInLayout = false;
        			this.cashSettlementAcc.accountPopup.visible = false;
        			this.cashSettlementAcc.accountPopup.includeInLayout = false;
        			this.cashSettlementAcc.accountNo.enabled = false;
        			this.cashSettlemetBank.finInstCode.enabled = false;
	        	}
	        	else{
	        		this.editDiffAgainst.selected = false;
	        	}
	        	
	        	diffCashForAgainstFlag = mapObj[keylist.getItemAt(27)].toString();
	        	//commonInit(mapObj);
	        	this.editFundCode.text = mapObj[keylist.getItemAt(4)] != null ? mapObj[keylist.getItemAt(4)].toString() : "";
	        	this.editFundAccNo.text = mapObj[keylist.getItemAt(5)] != null ? mapObj[keylist.getItemAt(5)].toString() : "";
	        	this.editStlFor.text = mapObj[keylist.getItemAt(6)] != null ? mapObj[keylist.getItemAt(6)].toString() : "";
	        	this.editCashScrFlag.text = mapObj[keylist.getItemAt(7)] != null ? mapObj[keylist.getItemAt(7)].toString() : "";
	        	if(this.editCashScrFlag.text == "CASH") {
        			this.editDiffAgainst.enabled = false;
        		}else {
        			this.editDiffAgainst.enabled = true;
        		}
	        	if(dfltOwnSsiRule=="true")
	        	{
	        		this.lblownStlBank.text = mapObj[keylist.getItemAt(8)] != null ? mapObj[keylist.getItemAt(8)].toString() : "";
		            this.lblOwnStlAccNo.text = mapObj[keylist.getItemAt(9)] != null ? mapObj[keylist.getItemAt(9)].toString() : "";
		        	this.editOwnPriority.text = mapObj[keylist.getItemAt(18)] != null ? mapObj[keylist.getItemAt(18)].toString() : "";
		        	this.settlemetBank.visible = false;
		        	this.settlemetBank.includeInLayout = false;	
		        	this.settlementAcc.visible = false;
		        	this.settlementAcc.includeInLayout = false;
		        	this.editOwnPriorityList.visible = false;
		        	this.editOwnPriorityList.includeInLayout = false;
	        	}
	        	else{
	              this.settlemetBank.finInstCode.text = mapObj[keylist.getItemAt(8)] != null ? mapObj[keylist.getItemAt(8)].toString() : "";
	        		this.settlementAcc.accountNo.text = mapObj[keylist.getItemAt(9)] != null ? mapObj[keylist.getItemAt(9)].toString() : "";
	        		this.settlementAcc.accountNo.enabled = false;
	        		// for own priority
	        		var index:int=0;
		        	var ownPriorityList:ArrayCollection = new ArrayCollection();
		        	if(mapObj[keylist.getItemAt(3)]!=null){
			    		if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
			    			for each(var item:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
			    				ownPriorityList.addItem(item);
					    		if(item.value == mapObj[keylist.getItemAt(18)].toString()){
					    			index = (mapObj[keylist.getItemAt(3)] as ArrayCollection).getItemIndex(item);
					    		}
					    	}
			    		}else{
			    			ownPriorityList.addItem(mapObj[keylist.getItemAt(3)]);
			    			index = 1;
			    		}
			    	}
			    	this.editOwnPriorityList.dataProvider = ownPriorityList;
		        	this.editOwnPriorityList.selectedIndex = index;
		        	this.lblOwnStlAccNo.visible =false;
		        	this.lblOwnStlAccNo.includeInLayout = false;
		        	this.lblownStlBank.visible = false;
		        	this.lblownStlBank.includeInLayout = false;
		        	this.editOwnPriority.visible = false;
		        	this.editOwnPriority.includeInLayout = false;
	        	
	        	}
	        	
	        	this.editSecType.text = mapObj[keylist.getItemAt(10)] != null ? mapObj[keylist.getItemAt(10)].toString() : "";
	        	this.editStlLocation.text = mapObj[keylist.getItemAt(11)] != null ? mapObj[keylist.getItemAt(11)].toString() : "";
	        	
	        	this.editStlCcy.text = mapObj[keylist.getItemAt(12)] != null ? mapObj[keylist.getItemAt(12)].toString() : "";
	        	this.editsecCode.text = mapObj[keylist.getItemAt(13)] != null ? mapObj[keylist.getItemAt(13)].toString() : "";
	        	
	        	this.counterPartyCodeExp.text = mapObj[keylist.getItemAt(14)] != null ? mapObj[keylist.getItemAt(14)].toString() : "";
	        	this.editCPAccNo.text = mapObj[keylist.getItemAt(15)] != null ? mapObj[keylist.getItemAt(15)].toString() : "";
	        	//Settlement For
	        	this.editStlForList.visible = false;
		        this.editStlForList.includeInLayout = false;
		        //Cash security flag
	        	this.editCashScrFlagList.visible = false;
		        this.editCashScrFlagList.includeInLayout = false;
		        //Fund Popup invisible for amend
		        this.editFundCodePopUp.visible = false;
		        this.editFundCodePopUp.includeInLayout = false;
		        //Fund Account popup invisible
		         this.editFundAccNoPopUp.visible = false;
		        this.editFundAccNoPopUp.includeInLayout = false;
		        //instrument type invisible
		        this.editSecTypeTree.visible = false;
		        this.editSecTypeTree.includeInLayout = false;
		        //Settlement Location list invisible
		        this.editStlLocationList.visible = false;
		        this.editStlLocationList.includeInLayout = false;
		        //ccy popup invisible
		        this.editStlCcyPopUp.visible = false;
		        this.editStlCcyPopUp.includeInLayout = false;
		        //Security code list invisible
		        this.editsecCodePopUp.visible = false;
		        this.editsecCodePopUp.includeInLayout = false;
		        //Counter Party Box list invisible
		        this.counterpartyCodeBox.visible = false;
		        this.counterpartyCodeBox.includeInLayout = false;
		         this.editCPCode.visible = false;
		        this.editCPCode.includeInLayout = false;
		        //Cp Account no popup
		        this.editCPAccNoPopUp.visible = false;
		        this.editCPAccNoPopUp.includeInLayout = false;
		        this.executionMarket.visible=false;
		        this.executionMarket.includeInLayout=false;
		        
		        
		        
		        
	        	// set Inx Transmission required
	        	var index:int=0;
	        	inxVal = mapObj[keylist.getItemAt(21)].toString();
	        	var tempFlag:String = mapObj[keylist.getItemAt(16)].toString();
	        	var temp:String = "";
	        	if(tempFlag == "N")
	        	{
	        	temp = "NOT REQUIRED";	
	        	}
	        	else{
	        		temp = "REQUIRED";	
	        	}
	        	
	        	var inxTrmList:ArrayCollection = new ArrayCollection();
	        	if(mapObj[keylist.getItemAt(0)]!=null){
		    		if(mapObj[keylist.getItemAt(0)] is ArrayCollection){
		    			for each(var item:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
		    				inxTrmList.addItem(item);
				    		if(item.label == temp){
				    			index = (mapObj[keylist.getItemAt(0)] as ArrayCollection).getItemIndex(item);
				    		}
				    	}
		    		}else{
		    			inxTrmList.addItem(mapObj[keylist.getItemAt(0)]);
		    			index = 1;
		    		}
		    	}
		    	this.instructionReqd.dataProvider = inxTrmList;
	        	this.instructionReqd.selectedIndex = index;
	        	
	        	// set auto transmission required
	        	
	        	var index:int=0;
	        	var autoTrmList:ArrayCollection = new ArrayCollection();
	        	if(mapObj[keylist.getItemAt(1)]!=null){
		    		if(mapObj[keylist.getItemAt(1)] is ArrayCollection){
		    			for each(var item:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
		    				autoTrmList.addItem(item);
				    		if(item.value == mapObj[keylist.getItemAt(17)].toString()){
				    			index = (mapObj[keylist.getItemAt(1)] as ArrayCollection).getItemIndex(item);
				    		}
				    	}
		    		}else{
		    			autoTrmList.addItem(mapObj[keylist.getItemAt(1)]);
		    			index = 1;
		    		}
		    	}
		    	this.autoTransmissionFlagList.dataProvider = autoTrmList;
	        	this.autoTransmissionFlagList.selectedIndex = index;
	        	
	        	this.editMarket.text = mapObj[keylist.getItemAt(19)] != null ? mapObj[keylist.getItemAt(19)].toString() : "";
	        	if(showCashDetailEntry=="true")
	        	{
	        		diffCashForAgainstFlag = "Y";
	        		this.showCashDetail.visible = true;
	        		this.showCashDetail.includeInLayout = true;
	        	}
	        	else
	        	{
	        		diffCashForAgainstFlag = "N";
	        		this.showCashDetail.visible = false;
	        		this.showCashDetail.includeInLayout = false;
	        		
	        	}
	        	
	        	//for own settlement mode
	        	var index:int=0;
	        	var stlModeTrmList:ArrayCollection = new ArrayCollection();
	        	if(mapObj[keylist.getItemAt(2)]!=null){
		    		if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
		    			for each(var item:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
		    				stlModeTrmList.addItem(item);
				    		if(item.value == mapObj[keylist.getItemAt(21)].toString()){
				    			index = (mapObj[keylist.getItemAt(2)] as ArrayCollection).getItemIndex(item);
				    		}
				    	}
		    		}else{
		    			stlModeTrmList.addItem(mapObj[keylist.getItemAt(2)]);
		    			index = 1;
		    		}
		    	}
		    	this.settlementMode.dataProvider = stlModeTrmList;
	        	this.settlementMode.selectedIndex = index;
	        	
	        	this.editCashExistingRule.ownSsiRule.text = mapObj[keylist.getItemAt(22)] != null ? mapObj[keylist.getItemAt(22)].toString() : "";
	        	this.editCashExistingRule.ownSsiRule.enabled = false;
	        	//for cash settlement mode
	        	var index:int=0;
	        	var stlModeCashTrmList:ArrayCollection = new ArrayCollection();
	        	if(mapObj[keylist.getItemAt(2)]!=null){
		    		if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
		    			for each(var item:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
		    				stlModeCashTrmList.addItem(item);
				    		if(item.value == mapObj[keylist.getItemAt(23)].toString()){
				    			index = (mapObj[keylist.getItemAt(2)] as ArrayCollection).getItemIndex(item);
				    		}
				    	}
		    		}else{
		    			stlModeCashTrmList.addItem(mapObj[keylist.getItemAt(2)]);
		    			index = 1;
		    		}
		    	}
		    	this.editCashStlMode.dataProvider = stlModeCashTrmList;
	        	this.editCashStlMode.selectedIndex = index;
	        	stlModeCashList = stlModeCashTrmList;
	        	
	        	// for cash priority
	        	var index:int=0;
	        	var cashPriorityList:ArrayCollection = new ArrayCollection();
	        	if(mapObj[keylist.getItemAt(3)]!=null){
		    		if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
		    			for each(var item:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
		    				cashPriorityList.addItem(item);
				    		if(item.value == mapObj[keylist.getItemAt(24)].toString()){
				    			index = (mapObj[keylist.getItemAt(3)] as ArrayCollection).getItemIndex(item);
				    		}
				    	}
		    		}else{
		    			cashPriorityList.addItem(mapObj[keylist.getItemAt(3)]);
		    			index = 1;
		    		}
		    	}
		    	this.editCashPriority.dataProvider = cashPriorityList;
	        	this.editCashPriority.selectedIndex = index;
	        	cashPriorList = cashPriorityList;
	        	onChangeInxReqd();
	        	
	        	this.cashSettlemetBank.finInstCode.text = mapObj[keylist.getItemAt(25)] != null ? mapObj[keylist.getItemAt(25)].toString() : "";
	        	this.cashSettlementAcc.accountNo.text = mapObj[keylist.getItemAt(26)] != null ? mapObj[keylist.getItemAt(26)].toString() : "";
	        	settlemetBank.finInstCode.addEventListener(FlexEvent.VALUE_COMMIT,settlementBankChange);
            }
            
           
            override public function postCancelResultInit(mapObj:Object): void{
                    
                commonResultPart(mapObj);
                validateCashSide();
                uConfLabel.text=this.parentApplication.xResourceManager.getKeyValue('ref.ownssirule.label.ownssicancel');
                uConfSubmit.includeInLayout = false;
                uConfSubmit.visible = false;
                cancelSubmit.visible = true;
                cancelSubmit.includeInLayout = true;
                app.submitButtonInstance = cancelSubmit;
            }
            
             public function validateCashSide():void{
                if(showCashDetailEntry=="true"){
                    this.cashSide.visible = true;
                    this.cashSide.includeInLayout = true;
                }
                else{
                    this.cashSide.visible = false;
                    this.cashSide.includeInLayout = false;
                }
             }
            
            override public function preEntry():void{
                setValidator();
			 	super.getSaveHttpService().url = "ref/ownStandingDetails.action?";  
			 	var reqObj:Object = populateRequestParamsForEntry();
			 	reqObj.method = "submitEntry";
			 	reqObj.SCREEN_KEY = 182;
	            super.getSaveHttpService().request = reqObj; 
             }
             
             override public function preAmend():void{
                setValidator();
                //validateAmend();
                super.getSaveHttpService().url = "ref/ownStandingDetails.action?";  
                var reqObj:Object = populateRequestParams();
                reqObj.method = "submitAmend";
                reqObj.SCREEN_KEY = 823;
                super.getSaveHttpService().request = reqObj; 
             } 
             override public function preCancel():void{
                super._validator = null;
                super.getSaveHttpService().url = "ref/ownStandingDetails.action?"; 
                var reqObj:Object = new Object();
                reqObj.method="submitDelete";
                reqObj.SCREEN_KEY = 180;
                reqObj.mode=this.mode;
                super.getSaveHttpService().request = reqObj;
             }
             
             
            override public function preEntryResultHandler():Object
            {
                 addCommonResultKes();
                 return keylist; 
            }
            
            override public function preAmendResultHandler():Object
            {
                addCommonResultKes();
                return keylist; 
            } 
            
            override public function postCancelResultHandler(mapObj:Object):void
            {
                if(submitUserConfResult(mapObj)) {
                	uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('ref.ownssirule.label.userconfirm')+tempMode;
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
	                sysConfMessage.includeInLayout=false;   
             		sysConfMessage.visible=false;
                }
                
               
            } 
            
            override public function postEntryResultHandler(mapObj:Object):void
            {
               commonResult(mapObj);
               validateCashSide();
            }
            
            override public function postAmendResultHandler(mapObj:Object):void
            {
                commonResult(mapObj);
                 validateCashSide();
                app.submitButtonInstance = uConfSubmit;
            }
             
             
            
            override public function preEntryConfirm():void
            {
                var reqObj :Object = new Object();
				super.getConfHttpService().url = "ref/ownStandingDetails.action?";  
				reqObj.method= "submitConfirm";
				reqObj.SCREEN_KEY = 826;
	            super.getConfHttpService().request = reqObj; 
            }
            
            override public function preAmendConfirm():void
            {
                 var reqObj :Object = new Object();
                super.getConfHttpService().url = "ref/ownStandingDetails.action?";  
                reqObj.method= "submitConfirm";
                reqObj.SCREEN_KEY = 825;
                super.getConfHttpService().request = reqObj; 
            }
            
            override public function preCancelConfirm():void
            {
                var reqObj :Object = new Object();
                super.getConfHttpService().url = "ref/ownStandingDetails.action?";  
                reqObj.method= "submitConfirm";
                reqObj.SCREEN_KEY = 827;
                super.getConfHttpService().request = reqObj;
            }
            
            override public function postConfirmEntryResultHandler(mapObj:Object):void
            {
                submitUserConfResult(mapObj);
            }
            override public function postConfirmAmendResultHandler(mapObj:Object):void
            {
                submitUserConfResult(mapObj);
            }
            override public function postConfirmCancelResultHandler(mapObj:Object):void
            {
                if(submitUserConfResult(mapObj)) {
                	sConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('ref.ownssirule.label.systemconfirm')+tempMode;
	                sConfLabel.includeInLayout = true;
	                sConfLabel.visible = true;
	                cancelSubmit.visible = false;
	                cancelSubmit.includeInLayout = false;
	                uCancelConfSubmit.visible = false;
	                uCancelConfSubmit.includeInLayout = false;
	                uConfLabel.includeInLayout = false;
	                uConfLabel.visible = false;
	                sysConfMessage.includeInLayout=true;   
             		sysConfMessage.visible=true;
                }
            }
            
            override public function preResetEntry():void
           {
           	 settlemetBank.finInstCode.removeEventListener(FlexEvent.VALUE_COMMIT,settlementBankChange);
             var rndNo:Number= Math.random();
             super.getResetHttpService().url = "ref/ownStandingDetails.action?method=resetAction&actionType=ADD&rnd=" + rndNo; 
           }
           override public function preResetAmend():void
           {
               settlemetBank.finInstCode.removeEventListener(FlexEvent.VALUE_COMMIT,settlementBankChange);
               var rndNo:Number= Math.random();
                super.getResetHttpService().url = "ref/ownStandingDetails.action?method=initialExecute&actionType=AMEND&pk="+ ownSsiRulePk  +"&rnd=" + rndNo; 
           }
           
           
            override public function doEntrySystemConfirm(e:Event):void
            {
            		sysConfMessage.includeInLayout=false;   
             		sysConfMessage.visible=false;
                    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
                
            }
            
            override public function doAmendSystemConfirm(e:Event):void
            {
            //  this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
               this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
            }
            override public function doCancelSystemConfirm(e:Event):void
            {
                //this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
                this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
            }
            
            
            /**
            * This method adds the common keys to a list
            * which will be populated for both entry and amend
            */
            private function addCommonKeys():void{          
                 keylist = new ArrayCollection();
                keylist.addItem("inxTransmissionList.item");
                keylist.addItem("autoTransmissionFlagList.item");
                keylist.addItem("settlementModeList.item");
                keylist.addItem("priorityList.item"); 
                
            }
            /**
	        * This method adds the common keys to a list
	        * which will be populated for both entry and amend
	        */
	        private function addCommonKeysForList():void{ 
		    	keylist.addItem("settlementForList.item");
		    	keylist.addItem("cashSecurityList.item");
		    	keylist.addItem("settlementLocationList.item");
		    	keylist.addItem("counterpartyTypeList.cpTypeList");
	        }
            
            private function commonInit(mapObj:Object):void{
            	
                errPage.clearError(super.getInitResultEvent());
        		// for own priority
        		var index:int=0;
	        	var ownPriorityList:ArrayCollection = new ArrayCollection();
	        	if(mapObj[keylist.getItemAt(3)]!=null){
		    		if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
		    			for each(var item:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
		    				ownPriorityList.addItem(item);
				    		if(item.value == mapObj[keylist.getItemAt(18)].toString()){
				    			index = (mapObj[keylist.getItemAt(3)] as ArrayCollection).getItemIndex(item);
				    		}
				    	}
		    		}else{
		    			ownPriorityList.addItem(mapObj[keylist.getItemAt(3)]);
		    			index = 1;
		    		}
		    	}
		    	this.editOwnPriorityList.dataProvider = ownPriorityList;
	        	this.editOwnPriorityList.selectedIndex = index;
	        	this.lblOwnStlAccNo.visible =false;
	        	this.lblOwnStlAccNo.includeInLayout = false;
	        	this.lblownStlBank.visible = false;
	        	this.lblownStlBank.includeInLayout = false;
	        	this.editOwnPriority.visible = false;
	        	this.editOwnPriority.includeInLayout = false;
	        	
	        	
	        	this.editFundCode.visible = false;
		        this.editFundCode.includeInLayout = false;
		        this.editFundAccNo.visible = false;
		        this.editFundAccNo.includeInLayout = false;
		        this.editStlFor.visible = false;
	        	this.editStlFor.includeInLayout = false;
	        	this.editCashScrFlag.visible = false;
	        	this.editCashScrFlag.includeInLayout = false;
	        	this.editSecType.visible = false;
		        this.editSecType.includeInLayout = false;
		        this.editStlLocation.visible = false;
		        this.editStlLocation.includeInLayout = false;
		        this.editStlCcy.visible = false;
	        	this.editStlCcy.includeInLayout = false;
	        	this.editsecCode.visible = false;
	        	this.editsecCode.includeInLayout = false;
	        	this.editCPAccNo.visible = false;
	        	this.editCPAccNo.includeInLayout = false;
	        	this.editMarket.visible=false;
	        	this.editMarket.includeInLayout=false;
	        	this.counterPartyCodeExp.visible = false;
	        	this.counterPartyCodeExp.includeInLayout=false;
	        	
	        	
	        	this.editFundCodePopUp.fundCode.text= mapObj[keylist.getItemAt(4)] != null ? mapObj[keylist.getItemAt(4)].toString() : "";
	        	this.editFundAccNoPopUp.accountNo.text=mapObj[keylist.getItemAt(5)] != null ? mapObj[keylist.getItemAt(5)].toString() : "";
	        	this.settlemetBank.finInstCode.text=mapObj[keylist.getItemAt(8)] != null ? mapObj[keylist.getItemAt(8)].toString() : "";
	        	this.settlementAcc.accountNo.text = mapObj[keylist.getItemAt(9)] != null ? mapObj[keylist.getItemAt(9)].toString() : "";
	        	this.editSecTypeTree.itemCombo.text =mapObj[keylist.getItemAt(10)] != null ? mapObj[keylist.getItemAt(10)].toString() : "";
	        	this.editStlCcyPopUp.ccyText.text=mapObj[keylist.getItemAt(12)] != null ? mapObj[keylist.getItemAt(12)].toString() : "";
	        	this.editsecCodePopUp.instrumentId.text = mapObj[keylist.getItemAt(13)] != null ? mapObj[keylist.getItemAt(13)].toString() : "";
	        	this.editCPAccNoPopUp.accountNo.text = mapObj[keylist.getItemAt(15)] != null ? mapObj[keylist.getItemAt(15)].toString() : "";
	        	this.settlementAcc.accountNo.enabled = false;
	        	this.editDiffAgainst.selected = false;	        	
	        	// set Inx Transmission required
	        	var index:int=0;
	        	inxVal = mapObj[keylist.getItemAt(21)].toString();
	        	var temp:String = "";
	        	if(inxVal == "INTERNAL")
	        	{
	        	temp = "NOT REQUIRED";	
	        	}
	        	else{
	        		temp = "REQUIRED";	
	        	}
	        	var inxTrmList:ArrayCollection = new ArrayCollection();
	        	if(mapObj[keylist.getItemAt(0)]!=null){
		    		if(mapObj[keylist.getItemAt(0)] is ArrayCollection){
		    			for each(var item:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
		    				inxTrmList.addItem(item);
				    		if(item.value == temp){
				    			index = (mapObj[keylist.getItemAt(0)] as ArrayCollection).getItemIndex(item);
				    		}
				    	}
		    		}else{
		    			inxTrmList.addItem(mapObj[keylist.getItemAt(0)]);
		    			index = 1;
		    		}
		    	}
		    	this.instructionReqd.dataProvider = inxTrmList;
	        	this.instructionReqd.selectedIndex = index;
	        	
	        	// set auto transmission required
	        	
	        	var index:int=0;
	        	var autoTrmList:ArrayCollection = new ArrayCollection();
	        	if(mapObj[keylist.getItemAt(1)]!=null){
		    		if(mapObj[keylist.getItemAt(1)] is ArrayCollection){
		    			for each(var item:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
		    				autoTrmList.addItem(item);
				    		if(item.value == mapObj[keylist.getItemAt(17)].toString()){
				    			index = (mapObj[keylist.getItemAt(1)] as ArrayCollection).getItemIndex(item);
				    		}
				    	}
		    		}else{
		    			autoTrmList.addItem(mapObj[keylist.getItemAt(1)]);
		    			index = 1;
		    		}
		    	}
		    	this.autoTransmissionFlagList.dataProvider = autoTrmList;
	        	this.autoTransmissionFlagList.selectedIndex = index;
	        	
	        	this.executionMarket.itemCombo.text = mapObj[keylist.getItemAt(19)] != null ? mapObj[keylist.getItemAt(19)].toString() : "";
        		diffCashForAgainstFlag = "N";
        		this.showCashDetail.visible = false;
        		this.showCashDetail.includeInLayout = false;
	        	
	        	//for own settlement mode
	        	var index:int=0;
	        	var stlModeTrmList:ArrayCollection = new ArrayCollection();
	        	if(mapObj[keylist.getItemAt(2)]!=null){
		    		if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
		    			for each(var item:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
		    				stlModeTrmList.addItem(item);
				    		if(item.value == mapObj[keylist.getItemAt(21)].toString()){
				    			index = (mapObj[keylist.getItemAt(2)] as ArrayCollection).getItemIndex(item);
				    		}
				    	}
		    		}else{
		    			stlModeTrmList.addItem(mapObj[keylist.getItemAt(2)]);
		    			index = 1;
		    		}
		    	}
		    	this.settlementMode.dataProvider = stlModeTrmList;
	        	this.settlementMode.selectedIndex = index;
	        	
	        	this.editCashExistingRule.ownSsiRule.text = mapObj[keylist.getItemAt(22)] != null ? mapObj[keylist.getItemAt(22)].toString() : "";
	        	this.editCashExistingRule.ownSsiRule.enabled = false;
	        	//for cash settlement mode
	        	var index:int=0;
	        	var stlModeCashTrmList:ArrayCollection = new ArrayCollection();
	        	if(mapObj[keylist.getItemAt(2)]!=null){
		    		if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
		    			for each(var item:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
		    				stlModeCashTrmList.addItem(item);
				    		if(item.value == mapObj[keylist.getItemAt(23)].toString()){
				    			index = (mapObj[keylist.getItemAt(2)] as ArrayCollection).getItemIndex(item);
				    		}
				    	}
		    		}else{
		    			stlModeCashTrmList.addItem(mapObj[keylist.getItemAt(2)]);
		    			index = 1;
		    		}
		    	}
		    	this.editCashStlMode.dataProvider = stlModeCashTrmList;
	        	this.editCashStlMode.selectedIndex = index;
	        	stlModeCashList = stlModeCashTrmList;
	        	
	        	// for cash priority
	        	var index:int=0;
	        	var cashPriorityList:ArrayCollection = new ArrayCollection();
	        	if(mapObj[keylist.getItemAt(3)]!=null){
		    		if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
		    			for each(var item:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
		    				cashPriorityList.addItem(item);
				    		if(item.value == mapObj[keylist.getItemAt(24)].toString()){
				    			index = (mapObj[keylist.getItemAt(3)] as ArrayCollection).getItemIndex(item);
				    		}
				    	}
		    		}else{
		    			cashPriorityList.addItem(mapObj[keylist.getItemAt(3)]);
		    			index = 1;
		    		}
		    	}
		    	this.editCashPriority.dataProvider = cashPriorityList;
	        	this.editCashPriority.selectedIndex = index;
 	        	cashPriorList = cashPriorityList;
	        	
	        	this.cashSettlemetBank.finInstCode.text = mapObj[keylist.getItemAt(25)] != null ? mapObj[keylist.getItemAt(25)].toString() : "";
	        	this.cashSettlementAcc.accountNo.text = mapObj[keylist.getItemAt(26)] != null ? mapObj[keylist.getItemAt(26)].toString() : "";
	        	
	        	// for Settlement for list
	        	var index:int=0;
	        	var settlementForList:ArrayCollection = new ArrayCollection();
	        	if(mapObj[keylist.getItemAt(30)]!=null){
		    		if(mapObj[keylist.getItemAt(30)] is ArrayCollection){
		    			for each(var item:Object in (mapObj[keylist.getItemAt(30)] as ArrayCollection)){
		    				settlementForList.addItem(item);
				    		if(item.value == mapObj[keylist.getItemAt(6)].toString()){
				    			index = (mapObj[keylist.getItemAt(30)] as ArrayCollection).getItemIndex(item);
				    		}
				    	}
		    		}else{
		    			settlementForList.addItem(mapObj[keylist.getItemAt(30)]);
		    			index = 1;
		    		}
		    	}
		    	this.editStlForList.dataProvider = settlementForList;
	        	this.editStlForList.selectedIndex = index;
	        	
	        	// for Settlement location list
	        	var index:int=0;
	        	var settlementLocationList:ArrayCollection = new ArrayCollection();
	        	settlementLocationList.addItem({label:" ", value: " "});
	        	if(mapObj[keylist.getItemAt(32)]!=null){
		    		if(mapObj[keylist.getItemAt(32)] is ArrayCollection){
		    			for each(var item:Object in (mapObj[keylist.getItemAt(32)] as ArrayCollection)){
		    				settlementLocationList.addItem(item);
				    		if(item.value == mapObj[keylist.getItemAt(11)].toString()){
				    			index = (mapObj[keylist.getItemAt(32)] as ArrayCollection).getItemIndex(item);
				    		}
				    	}
		    		}else{
		    			settlementLocationList.addItem(mapObj[keylist.getItemAt(32)]);
		    			index = 0;
		    		}
		    	}
		    	this.editStlLocationList.dataProvider = settlementLocationList;
	        	this.editStlLocationList.selectedIndex = index;
	        	
	        	// for cash security flag list
	        	var index:int=0;
	        	var cashSecurityList:ArrayCollection = new ArrayCollection();
	        	if(mapObj[keylist.getItemAt(31)]!=null){
		    		if(mapObj[keylist.getItemAt(31)] is ArrayCollection){
		    			for each(var item:Object in (mapObj[keylist.getItemAt(31)] as ArrayCollection)){
		    				cashSecurityList.addItem(item);
				    		if(item.value == mapObj[keylist.getItemAt(7)].toString()){
				    			index = (mapObj[keylist.getItemAt(31)] as ArrayCollection).getItemIndex(item);
				    		}
				    	}
		    		}else{
		    			cashSecurityList.addItem(mapObj[keylist.getItemAt(31)]);
		    			index = 0;
		    		}
		    	}
		    	this.editCashScrFlagList.dataProvider = cashSecurityList;
	        	this.editCashScrFlagList.selectedIndex = index;
	        	
	        	var counterPartyTypeList:ArrayCollection = new ArrayCollection();
	        	
		    	counterPartyTypeList.addItem({label:" ", value: " "});
		    	if(mapObj[keylist.getItemAt(33)]!=null){
		    		if(mapObj[keylist.getItemAt(33)] is ArrayCollection){
		    			for each(var item:Object in (mapObj[keylist.getItemAt(33)] as ArrayCollection)){
		    				counterPartyTypeList.addItem(item);
				    	}
		    		}else{
		    			counterPartyTypeList.addItem(mapObj[keylist.getItemAt(33)]);
		    			index = 0;
		    		}
		    	}
		    	this.editCPCode.dataProvider = counterPartyTypeList;
		    	this.editCPCode.selectedIndex = index;		    	
		    	
		    	if(this.editStlForList.selectedItem.value == "SECURITY_TRADE" ||
						this.editStlForList.selectedItem.value == "SLR_TRADE" ||
						this.editStlForList.selectedItem.value == "SLR_INTEREST" || 
						this.editStlForList.selectedItem.value == "DERIVATIVE_TRADE"){
	        		this.editCashScrFlagList.enabled=true;
	        		if(this.editCashScrFlagList.selectedItem.value == "CASH") {
	        			this.editDiffAgainst.enabled = false;
	        		} else {
	        			this.editDiffAgainst.enabled = true;
	        		}
	        	} else{
	        			this.editCashScrFlagList.selectedIndex=0;
	        			this.editCashScrFlagList.enabled = false;
	        			this.editDiffAgainst.enabled = false;
	        	}
	        	onChangeInxReqd();
	        	onChangeCounterPartyType();
            }
            
            
            
            
            private function commonResultPart(mapObj:Object):void{
                     this.uConfFundCode.text = mapObj[keylist.getItemAt(0)].toString();
                     this.uConfFundName.text = mapObj[keylist.getItemAt(25)].toString();
                     this.uConfFundAccNo.text = mapObj[keylist.getItemAt(1)].toString();
                     this.uConfFundAccName.text = mapObj[keylist.getItemAt(26)].toString();
                     this.uConfStlFor.text = mapObj[keylist.getItemAt(2)].toString();
                     this.uConfCashScrFlag.text = mapObj[keylist.getItemAt(3)].toString();
                     this.uConfownStlBank.text = mapObj[keylist.getItemAt(4)].toString();
                     this.uConfownStlBankName.text = mapObj[keylist.getItemAt(29)].toString();
                     this.uConfOwnStlAccNo.text = mapObj[keylist.getItemAt(5)].toString();
                     this.uConfOwnStlAccName.text = mapObj[keylist.getItemAt(28)].toString();
                     this.uConfSecType.text = mapObj[keylist.getItemAt(6)].toString();
                     this.uConfStlLocation.text = mapObj[keylist.getItemAt(7)].toString();
                     this.uConfStlCcy.text = mapObj[keylist.getItemAt(8)].toString();
                     this.uConfsecCode.text = mapObj[keylist.getItemAt(9)].toString();
                     this.uConfSecName.text = mapObj[keylist.getItemAt(10)].toString();
                     this.uConfCPCode.text = mapObj[keylist.getItemAt(11)].toString();
                     this.uConfCPAccNo.text = mapObj[keylist.getItemAt(12)].toString();
                     this.uConfCPAccName.text = mapObj[keylist.getItemAt(27)].toString();
                     this.uConfInxTrReqd.text = mapObj[keylist.getItemAt(13)].toString();
                     this.uConfAutoTrReqd.text = mapObj[keylist.getItemAt(14)].toString();
                     this.uConfOwnPriority.text = mapObj[keylist.getItemAt(15)].toString();
                     this.uConfMarket.text = mapObj[keylist.getItemAt(16)].toString();
                     this.uConfStlMode.text = mapObj[keylist.getItemAt(17)].toString();
                     this.uConfExistingRule.text = mapObj[keylist.getItemAt(18)].toString();
                     this.uConfCashStlMode.text = mapObj[keylist.getItemAt(19)].toString();
                     this.uConfCashInxReqd.text = mapObj[keylist.getItemAt(13)].toString();
                     this.uConfCashStlBank.text = mapObj[keylist.getItemAt(21)].toString();
                     this.uConfCashStlAccNo.text = mapObj[keylist.getItemAt(22)].toString();
                     this.uConfCashPriority.text = mapObj[keylist.getItemAt(23)].toString();
                     showCashDetailEntry = mapObj[keylist.getItemAt(24)].toString();
                     
            }
            
            
            private function addCommonResultKes():void{
                keylist = new ArrayCollection();
                keylist.addItem("ownStandingRule.fundCode");
                keylist.addItem("ownStandingRule.inventoryAccount");
                keylist.addItem("ownStandingRule.settlementFor");
                keylist.addItem("ownStandingRule.cashSecurityFlag");
                keylist.addItem("ownStandingRule.custodian");
                keylist.addItem("ownStandingRule.stlAccount");
                keylist.addItem("ownStandingRule.instrumentType");
                keylist.addItem("ownStandingRule.settlementLocation");
                keylist.addItem("ownStandingRule.settlementCcy");
                keylist.addItem("ownStandingRule.instrumentCode");
                keylist.addItem("ownStandingRule.securityName");
                keylist.addItem("counterpartyCodeExp");
                keylist.addItem("ownStandingRule.tradingAccount");
                keylist.addItem("instructionReqdExp");
                keylist.addItem("autoTransmissionFlagExp");
                keylist.addItem("ownStandingRule.priority");
                keylist.addItem("ownStandingRule.marketCode");
                keylist.addItem("ownStandingRule.settlementMode");
                keylist.addItem("existingRuleId");
                keylist.addItem("cashStandingRule.settlementMode");
                keylist.addItem("cashInstructionReqdExp");
                keylist.addItem("cashStandingRule.custodian");
                keylist.addItem("cashStandingRule.stlAccount");
                keylist.addItem("cashStandingRule.priority");
                keylist.addItem("cashForAgainst");
                keylist.addItem("ownStandingRule.fundName");
                keylist.addItem("ownStandingRule.inventoryAccountName");
                keylist.addItem("ownStandingRule.tradingAccountName");
                keylist.addItem("ownStandingRule.stlAccountName");
                keylist.addItem("ownStandingRule.custodianname");
            }
            
            private function commonResult(mapObj:Object):void{
                if(mapObj!=null){  
                    if(mapObj["errorFlag"].toString() == "error"){
                        errPage.showError(mapObj["errorMsg"]);                      
                    }else if(mapObj["errorFlag"].toString() == "noError"){
                        
                     errPage.clearError(super.getSaveResultEvent());                            
                     commonResultPart(mapObj);
                     changeCurrentState();
                     app.submitButtonInstance = uConfSubmit;    
                    }else{
                        errPage.removeError();
                        XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.datanotfound'));
                    }           
                }
            }
        
          public function showHideStdDtls(e:MouseEvent):void{
        
            if(CheckBox(e.currentTarget).selected == true) {
                        diffCashForAgainstFlag = "Y";
                        showCashDetailEntry ="true";
                        this.showCashDetail.visible = true;
                        this.showCashDetail.includeInLayout = true;
                        clearCashDetails();
                        
                } else {
                        diffCashForAgainstFlag = "N";
                        showCashDetailEntry ="true";
                        this.showCashDetail.visible = false;
                        this.showCashDetail.includeInLayout = false;
                cleanDiffCashForm();
            }
          }
           /**
         * This method will be called from the onClick event of the Clear
         * button to clear all the fields of the same section
         */
        private function cleanDiffCashForm():void
        {
            this.editCashExistingRule.ownSsiRule.text = "";
            this.editCashStlMode.selectedIndex = 0;
            this.editCashPriority.selectedIndex = 0;
            this.cashSettlemetBank.finInstCode.text = "";
            this.cashSettlementAcc.accountNo.text = ""; 
/*             
          	this.editCashExistingRule.enabled = true;
           	this.editCashStlMode.enabled = true;
           	this.editCashPriority.enabled = true;
           	//this.cashSettlemetBank.finInstCode.enabled = true;
           	this.cashSettlemetBank.enabled = true;
           	this.cashSettlementAcc.enabled = true;
           	//this.cashSettlementAcc.accountPopup.visible = true;
 */
        }
        
        private function setValidator():void{
        	var validateModel:Object=null;
        	if(this.mode == "entry"){
        		validateModel={
                            ownSsiEntry:{
                            	 mode:this.mode,
                                 fundCode:this.editFundCodePopUp.fundCode.text,
                                 settlementFor:this.editStlForList.selectedItem.value,
                                 cashSecurityFlag:this.editCashScrFlagList.selectedItem.value,
                                 settlementBank:this.settlemetBank.finInstCode.text,
                                 settlementAccount:this.settlementAcc.accountNo.text,
                                 settlementMode:this.settlementMode.selectedItem.value,
                                 diffCashSelected:this.diffCashForAgainstFlag,
                                 cashSettlementBank:this.cashSettlemetBank.finInstCode.text,
                                 cashSettlementAccount:this.cashSettlementAcc.accountNo.text,
                                 cashSettlementMode:this.editCashStlMode.selectedItem.value,
                                 defaultrule:this.dfltOwnSsiRule
        					}
        		};
        	} else if(this.dfltOwnSsiRule == "true"){
        		validateModel={
        			ownSsiEntry:{
                            	 mode:this.mode,
                                 settlementMode:this.settlementMode.selectedItem.value,
                                 diffCashSelected:this.diffCashForAgainstFlag,
                                 cashSettlementBank:this.cashSettlemetBank.finInstCode.text,
                                 cashSettlementAccount:this.cashSettlementAcc.accountNo.text,
                                 cashSettlementMode:this.editCashStlMode.selectedItem.value,
                                 defaultrule:this.dfltOwnSsiRule
         
        					}
                   }; 
        	}	else {
        		validateModel={
        			ownSsiEntry:{
                            	 mode:this.mode,
                                 settlementBank:this.settlemetBank.finInstCode.text,
                                 settlementAccount:this.settlementAcc.accountNo.text,
                                 settlementMode:this.settlementMode.selectedItem.value,
                                 diffCashSelected:this.diffCashForAgainstFlag,
                                 cashSettlementBank:this.cashSettlemetBank.finInstCode.text,
                                 cashSettlementAccount:this.cashSettlementAcc.accountNo.text,
                                 cashSettlementMode:this.editCashStlMode.selectedItem.value,
                                 defaultrule:this.dfltOwnSsiRule
         
        					}
        		};
        		
        	}			
        					
        	 super._validator = new OwnSettleStandingEntryValidator();
         	 super._validator.source = validateModel ;
	         super._validator.property = "ownSsiEntry";
         
        }
       
         
        override public function preEntryConfirmResultHandler():Object{
            addCommonResultKes();
            return keylist;
        }
        
        override public function preConfirmAmendResultHandler():Object{
            addCommonResultKes();
            return keylist;
        }
        
        override public function preCancelResultHandler():Object{
            addCommonResultKes();
            return keylist;
        }
        
        override public function preConfirmCancelResultHandler():Object{
            addCommonResultKes();
            return keylist;
        }
        
        private function submitUserConfResult(mapObj:Object):Boolean{
            if(mapObj!=null){    
                if(mapObj["errorFlag"].toString() == "error"){
                    usrConfErrPage.showError(mapObj["errorMsg"]);
                }else if(mapObj["errorFlag"].toString() == "noError"){
                    if(mode!="cancel")
                      errPage.clearError(super.getConfResultEvent());
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
                   sysConfMessage.includeInLayout=true;   
             		sysConfMessage.visible=true;
                   app.submitButtonInstance = sConfSubmit; 
                   return true;      
                }else{
                    errPage.removeError();
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.erroroccurred'));
                }           
            }
            return false;
        }
    
   /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
         var reqObj : Object = new Object();
        
        // reqObj.method= "confirm";
//      /this.tradeType.selectedItem != null ? this.tradeType.selectedItem : "";
        reqObj['ownStandingRule.fundCode'] = this.editFundCode.text;
        reqObj['ownStandingRule.inventoryAccount'] = this.editFundAccNo.text;
        reqObj['ownStandingRule.settlementFor'] = this.editStlFor.text;
        reqObj['ownStandingRule.cashSecurityFlag'] = this.editCashScrFlag.text;
        if(dfltOwnSsiRule=="true"){
            reqObj['ownStandingRule.settlementBank'] = this.lblownStlBank.text;
            reqObj['ownStandingRule.settlementAccount'] = this.lblOwnStlAccNo.text;    
        reqObj['ownStandingRule.priority'] = this.editOwnPriority.text;
        }
        else{
        reqObj['ownStandingRule.settlementBank'] = this.settlemetBank.finInstCode.text;
        reqObj['ownStandingRule.settlementAccount'] = this.settlementAcc.accountNo.text;
        reqObj['ownStandingRule.priority'] = this.editOwnPriorityList.selectedItem.value != null ? this.editOwnPriorityList.selectedItem.value : "";
        }
        reqObj['ownStandingRule.instrumentType'] = this.editSecType.text;
        reqObj['ownStandingRule.settlementLocation'] = this.editStlLocation.text;
        reqObj['ownStandingRule.settlementCcy'] = this.editStlCcy.text;
        reqObj['ownStandingRule.instrumentCode'] = this.editsecCode.text;
        reqObj['counterpartyCodeExp'] = this.editCPCode.text;
        reqObj['ownStandingRule.tradingAccount'] = this.editCPAccNo.text;
        reqObj['ownStandingRule.instructionReqd'] = this.instructionReqd.selectedItem.value != null ? this.instructionReqd.selectedItem.value : "";
        reqObj['ownStandingRule.autoTransmissionFlag'] = this.autoTransmissionFlagList.selectedItem.value != null ? this.autoTransmissionFlagList.selectedItem.value : "";
        
        reqObj['ownStandingRule.marketCode'] = this.editMarket.text; 
        reqObj['ownStandingRule.settlementMode'] = this.settlementMode.selectedItem.value != null ? this.settlementMode.selectedItem.value : "";
        reqObj['existingRuleId'] = this.editCashExistingRule.ownSsiRule.text;
        
         reqObj['cashForAgainst'] = this.editDiffAgainst.selected;
        reqObj['cashStandingRule.settlementBank'] = this.cashSettlemetBank.finInstCode.text;
        reqObj['cashStandingRule.settlementAccount'] = this.cashSettlementAcc.accountNo.text; 
        reqObj['cashStandingRule.priority'] = this.editCashPriority.selectedItem.value != null ? this.editCashPriority.selectedItem.value : "";
        reqObj['cashStandingRule.settlementMode'] = this.editCashStlMode.selectedItem.value != null ? this.editCashStlMode.selectedItem.value : "";
        reqObj['cashStandingRule.instructionReqd'] = this.instructionReqd.selectedItem.value != null ? this.instructionReqd.selectedItem.value : "";
        
        
        
        return reqObj; 
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
        private function populateConterPartyActContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing act type                
            var actTypeArray:Array = new Array(1);
                actTypeArray[0]="T|B";
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("cpActTypeContext",actTypeArray));    
                      
            //passing counter party type                
            var cpTypeArray:Array = new Array(2);
                cpTypeArray[0]="BROKER";
                cpTypeArray[1]="BANK/CUSTODIAN";
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
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
        private function populateSettActContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing act type                
            var actTypeArray:Array = new Array(1);
                actTypeArray[0]="T|B";
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("stlActTypeContext",actTypeArray));    
                      
            //passing counter party type                
            var cpTypeArray:Array = new Array(2);
                cpTypeArray[0]="BROKER";
                cpTypeArray[1]="BANK/CUSTODIAN";
            myContextList.addItem(new HiddenObject("stlCPTypeContext",cpTypeArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("actStatusContext",actStatusArray));
            //passing account status                
            var stlFinInstCode:Array = new Array(1);
            stlFinInstCode[0]=settlemetBank.finInstCode.text;
            myContextList.addItem(new HiddenObject("stlFinInstCodeContext",stlFinInstCode));
            
            return myContextList;
        }
        /**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
        private function populateCashSettActContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing act type                
            var actTypeArray:Array = new Array(1);
                actTypeArray[0]="S|B";
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("stlActTypeContext",actTypeArray));    
                      
            //passing counter party type                
            var cpTypeArray:Array = new Array(2);
                cpTypeArray[0]="BROKER";
                cpTypeArray[1]="BANK/CUSTODIAN";
            myContextList.addItem(new HiddenObject("stlCPTypeContext",cpTypeArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("actStatusContext",actStatusArray));
            //passing account status                
            var stlFinInstCode:Array = new Array(1);
            stlFinInstCode[0]=cashSettlemetBank.finInstCode.text;
            myContextList.addItem(new HiddenObject("stlFinInstCodeContext",stlFinInstCode));
            
            return myContextList;
        }
    
    
    /**
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specifdic  
      * requriment. 
      */
	  private function populateInvActContext():ArrayCollection {
	        //pass the context data to the popup
	        var myContextList:ArrayCollection = new ArrayCollection(); 
	      
	        //passing act type                
	        var actTypeArray:Array = new Array(1);
	            actTypeArray[0]="T|S|B";
	            //cpTypeArray[1]="CLIENT";
	        myContextList.addItem(new HiddenObject("invActTypeContext",actTypeArray));    
	                  
	        //passing counter party type                
	        var cpTypeArray:Array = new Array(1);
	            cpTypeArray[0]="INTERNAL";
	            //cpTypeArray[1]="CLIENT";
	        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
	    
	        //passing account status                
	        var actStatusArray:Array = new Array(1);
	        actStatusArray[0]="TRADING|BOTH";
	        myContextList.addItem(new HiddenObject("actContext",actStatusArray));
	        return myContextList;
	    } 
	    
	    
	    private function doSave():void{
	    	if(uConfSubmit.enabled == true){
	    		this.mode == 'entry' ?  this.dispatchEvent(new Event('entryConf')) :  this.dispatchEvent(new Event('amendEntryConf'));
	    	}
	    	uConfSubmit.enabled = false;
	    }
	    /**
		 * This method will be called on onchange event of  CounterPartyType 
		 * When value of CounterPartyType is equal to "BROKER" then 
		 * "BrokerCode" field will be enebale with the popup Link 
		 * and "CustomerCode" field will be disable with popup link
		 * On other than 'BROKER' but NOT NULL or EMPTY STRING case the opposite of above case will happen
		 */
		  private function onChangeCounterPartyType():void
		   {
			if(this.editCPCode.selectedLabel == "BROKER"){
		    		if(!this.counterpartyCodeBox.contains(cpCodeBroker)){
			    		this.counterpartyCodeBox.addChild(cpCodeBroker);
			      	}
			      
			}
			else{
		    		if(this.counterpartyCodeBox.contains(cpCodeBroker)){
		    			this.cpCodeBroker.finInstCode.text="";
		    			this.counterpartyCodeBox.removeChild(cpCodeBroker);
		    		}
		    		 	
			}	
		} 
		/**
		 * This method will be called on onchange event of  Inx Transmission 
		 */
		  private function onChangeInxReqd():void
		   {
			if(this.instructionReqd.selectedItem.value == "N"){
				this.autoTransmissionFlagList.selectedIndex=0;
		        this.autoTransmissionFlagList.enabled = false;
			}
			if(this.instructionReqd.selectedItem.value == "Y"){
				if(this.mode =="entry") {
					if(this.editStlForList.selectedItem.value == "SECURITY_TRADE" ||
						this.editStlForList.selectedItem.value == "SLR_TRADE" ||
						this.editStlForList.selectedItem.value == "SLR_INTEREST"){					
				    	this.autoTransmissionFlagList.enabled = true;
					} else {
						this.autoTransmissionFlagList.selectedIndex=0;
						this.autoTransmissionFlagList.enabled = false;
					}
				} else {
					if(this.editStlFor.text == "SECURITY_TRADE" ||
						this.editStlFor.text == "SLR_TRADE" ||
						this.editStlFor.text == "SLR_INTEREST"){					
				    	this.autoTransmissionFlagList.enabled = true;
					} else {
						this.autoTransmissionFlagList.selectedIndex=0;
						this.autoTransmissionFlagList.enabled = false;
					}
				}
			}
			
		} 
		/**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParamsForEntry():Object {
    	
    	 var reqObj : Object = new Object();
    	
    	// reqObj.method= "confirm";
//    	/this.tradeType.selectedItem != null ? this.tradeType.selectedItem : "";
    	reqObj['ownStandingRule.fundCode'] = this.editFundCodePopUp.fundCode.text;
    	reqObj['ownStandingRule.inventoryAccount'] = this.editFundAccNoPopUp.accountNo.text;
    	reqObj['ownStandingRule.settlementFor'] = this.editStlForList.selectedItem.value != null ? this.editStlForList.selectedItem.value : "";
    	reqObj['ownStandingRule.cashSecurityFlag'] = this.editCashScrFlagList.selectedItem.value != null ? this.editCashScrFlagList.selectedItem.value : "";
    	
    	reqObj['ownStandingRule.settlementBank'] = this.settlemetBank.finInstCode.text;
    	reqObj['ownStandingRule.settlementAccount'] = this.settlementAcc.accountNo.text;
    	reqObj['ownStandingRule.priority'] = this.editOwnPriorityList.selectedItem.value != null ? this.editOwnPriorityList.selectedItem.value : "";
    	
    	reqObj['ownStandingRule.instrumentType'] = this.editSecTypeTree.itemCombo.text;
    	reqObj['ownStandingRule.settlementLocation'] = this.editStlLocationList.selectedItem.value != null ? this.editStlLocationList.selectedItem.value : "";
    	reqObj['ownStandingRule.settlementCcy'] = this.editStlCcyPopUp.ccyText.text;
    	reqObj['ownStandingRule.instrumentCode'] = this.editsecCodePopUp.instrumentId.text;
    	
    	reqObj['counterpartyCodeExp'] = this.editCPCode.text;
    	reqObj['ownStandingRule.tradingAccount'] = this.editCPAccNoPopUp.accountNo.text;
    	reqObj['ownStandingRule.instructionReqd'] = this.instructionReqd.selectedItem.value != null ? this.instructionReqd.selectedItem.value : "";
    	reqObj['ownStandingRule.autoTransmissionFlag'] = this.autoTransmissionFlagList.selectedItem.value != null ? this.autoTransmissionFlagList.selectedItem.value : "";
    	
    	reqObj['ownStandingRule.marketCode'] = this.executionMarket.itemCombo != null ? this.executionMarket.itemCombo.text : "" ; 
    	reqObj['ownStandingRule.settlementMode'] = this.settlementMode.selectedItem.value != null ? this.settlementMode.selectedItem.value : "";
    	reqObj['existingRuleId'] = this.editCashExistingRule.ownSsiRule.text;
    	
    	 reqObj['cashForAgainst'] = this.editDiffAgainst.selected;
    	reqObj['cashStandingRule.settlementBank'] = this.cashSettlemetBank.finInstCode.text;
    	reqObj['cashStandingRule.settlementAccount'] = this.cashSettlementAcc.accountNo.text; 
    	reqObj['cashStandingRule.priority'] = this.editCashPriority.selectedItem.value != null ? this.editCashPriority.selectedItem.value : "";
    	reqObj['cashStandingRule.settlementMode'] = this.editCashStlMode.selectedItem.value != null ? this.editCashStlMode.selectedItem.value : "";
    	reqObj['ownStandingRule.counterpartyType'] = this.editCPCode.selectedLabel != null ? this.editCPCode.selectedLabel : "";
    	reqObj['cashStandingRule.instructionReqd'] = this.instructionReqd.selectedItem.value != null ? this.instructionReqd.selectedItem.value : "";
        
    	if(this.editCPCode.selectedLabel == "BROKER") {
    		reqObj['ownStandingRule.counterpartyCode'] = this.cpCodeBroker.finInstCode.text;
    	}
    	
    	return reqObj; 
    }
    
    /**
	 * This method will be called on onchange event of  Cash Security Flag
	 */
	  private function onChangeCashSecurityFlag():void
	   {
		if(this.editCashScrFlagList.selectedItem.value == "CASH"){
			this.editDiffAgainst.enabled=false;
			this.showCashDetail.visible = false;
            this.showCashDetail.includeInLayout = false;
            this.editDiffAgainst.selected = false;
            cleanDiffCashForm();
			
		} else {
			this.editDiffAgainst.enabled=true;
		}
		
	} 
	/**
	 * This method will be called on onchange event of  Cash Security Flag
	 */
	  private function onChangeSettlementFor():void {
		if(this.editStlForList.selectedItem.value == "SECURITY_TRADE" ||
			this.editStlForList.selectedItem.value == "SLR_TRADE" ||
			this.editStlForList.selectedItem.value == "CORPORATE_ACTION"){
			onChangeCashSecurityFlag();
			this.editCashScrFlagList.enabled = true;
			this.autoTransmissionFlagList.enabled = true;
					
    	} else {
    		this.editCashScrFlagList.selectedIndex = 0;
    		this.editCashScrFlagList.enabled = false;
    		onChangeCashSecurityFlag();    		
    		this.autoTransmissionFlagList.selectedIndex=0;
			this.autoTransmissionFlagList.enabled = false;
    		
    	} 
    	if(this.editStlForList.selectedItem.value == "SECURITY_TRADE" ||
			this.editStlForList.selectedItem.value == "SLR_TRADE" ||
			this.editStlForList.selectedItem.value == "SLR_INTEREST"){
			this.autoTransmissionFlagList.enabled = true;
					
    	} else {   		
    		this.autoTransmissionFlagList.selectedIndex=0;
			this.autoTransmissionFlagList.enabled = false;
    		
    	} 
    	if(this.editStlForList.selectedItem.value== "DERIVATIVE_TRADE"){
    		onChangeCashSecurityFlag();
    		this.editCashScrFlagList.enabled = true;
    	} 
    	else{
    		this.autoTransmissionFlagList.selectedIndex=0;
			this.autoTransmissionFlagList.enabled = false;
    	}
	} 
	private function populateOwnSsiRuleContext():ArrayCollection {
		   var myContextList:ArrayCollection = new ArrayCollection(); 
	      
	        //passing enterprise id                
	        var entTypeArray:Array = new Array(1);
	            entTypeArray[0]="NAM";
	        myContextList.addItem(new HiddenObject("enterprised_Id",entTypeArray));    
	
	        //passing cash_security_flag                
	        var csfTypeArray:Array = new Array(1);
	            csfTypeArray[0]="CASH";
	        myContextList.addItem(new HiddenObject("cash_Security_Flag",csfTypeArray));
	        return myContextList;
	        //XenosAlert.info("myContextList " +myContextList.toString());
		
	}
        