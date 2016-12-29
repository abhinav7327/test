/*



*/

        // ActionScript file for BkgTradeEntryModule
        import com.nri.rui.core.Globals;
        import com.nri.rui.core.controls.XenosAlert;
        import com.nri.rui.core.controls.XenosEntry;
        import com.nri.rui.core.formatters.CustomDateFormatter;
        import com.nri.rui.core.startup.XenosApplication;
        import com.nri.rui.core.utils.DateUtils;
        import com.nri.rui.core.utils.HiddenObject;
        import com.nri.rui.core.utils.NumberUtils;
        import com.nri.rui.core.utils.OnDataChangeUtil;
        import com.nri.rui.core.utils.XenosStringUtils;
        import com.nri.rui.frx.validators.FrxTradeEntryValidator;
        
        import flash.events.Event;
        import flash.events.FocusEvent;
        import flash.events.MouseEvent;
        
        import mx.collections.ArrayCollection;
        import mx.controls.TextInput;
        import mx.events.CloseEvent;
        import mx.events.FlexEvent;
        import mx.utils.StringUtil;
        import mx.rpc.events.ResultEvent;
        import mx.controls.Alert;
        import flash.events.TextEvent;
                    
              
             [Bindable]
             private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
             
             
     
     		private var prevBuyccy : String = "";
     		private var prevSellccy : String = "";
     		private var indexGlobal:int = 0; 
            [Bindable]private var mode : String = "entry";
            [Bindable]private var forexTradePkStr : String = "";
            [Bindable]private var tradeTypeGlobal : String = "";
            [Bindable]private var pTaxRateGlobal : String = "";
            [Bindable]private var pTaxDateGlobal : String = "";
            [Bindable]private var trdCcyGlobal : String = "";
            [Bindable]private var counterCcyGlobal : String = "";
            [Bindable]private var stlCcyGlobal : String = "";
            [Bindable]private var updateDateStartStr : String = "";
			[Bindable]private var updateDateEndStr : String = "";
            [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
            [Bindable]private var exchangeRateList:ArrayCollection = new ArrayCollection();
            private var keylist:ArrayCollection = new ArrayCollection();
      
              private function changeCurrentState():void{
                        vstack.selectedChild = rslt;
             }
          
        /**
         * Load the Entry/Amend/Cancel according to 
         * the operational mode (e.g. Entry/Amend/Cancel)
         */  
           public function loadAll():void{
               parseUrlString();
               super.setXenosEntryControl(new XenosEntry());
	           fundAccPopUp.accountNo.addEventListener(FlexEvent.VALUE_COMMIT, onChangeFundAccountNo);
		       counterPartyAccPopUp.accountNo.addEventListener(FlexEvent.VALUE_COMMIT, onChangeCPAccountNo);		       
		       trdCcy.ccyText.addEventListener(FocusEvent.FOCUS_OUT,stlExchangRateHide);
               trdCcy.imgCcy.addEventListener(MouseEvent.CLICK,trdImgClickHandler);
               counterCcy.ccyText.addEventListener(FocusEvent.FOCUS_OUT,stlExchangRateHide);
               counterCcy.imgCcy.addEventListener(MouseEvent.CLICK,counterImgClickHandler);
               stlCcy.imgCcy.addEventListener(MouseEvent.CLICK,stlImgClickHandler);
               stlCcy.ccyText.addEventListener(FocusEvent.FOCUS_OUT,stlExchangRateHide); 
               if(this.mode == 'entry'){
                 this.dispatchEvent(new Event('entryInit'));
                 vstack.selectedChild = qry;
                 //tradeType.addEventListener(FocusEvent.FOCUS_OUT,populateExchangeRateListForAmend);
               } else if(this.mode == 'amend'){
                 this.dispatchEvent(new Event('amendEntryInit'));
                 vstack.selectedChild = qry;
                 //calcType.addEventListener(FocusEvent.FOCUS_IN,populateExchangeRateListForAmend);
               } else if(this.mode == 'ptaxentry'){
                 this.dispatchEvent(new Event('amendEntryInit'));
                 vstack.selectedChild = qry;
               } else { 
                 this.dispatchEvent(new Event('cancelEntryInit'));
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
                            }else if(tempA[0] == "frxTrdPk"){
                                this.forexTradePkStr = tempA[1];
                            }else if(tempA[0] == "updateDateStart"){
	                            this.updateDateStartStr = tempA[1];
	                        }else if(tempA[0] == "updateDateEnd"){
	                            this.updateDateEndStr = tempA[1];
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
            * Banking Trade Entry Screen (InitEntry-SEQ-1)
            */
            override public function preEntryInit():void{               
                var rndNo:Number= Math.random(); 
            	super.getInitHttpService().url = "frx/forexEntryDispatch.action?";
            	var reqObject:Object = new Object();
            	reqObject.rnd = rndNo;
            	reqObject.method= "initialExecute";
		  		reqObject.mode="entry";
		  		reqObject.menuType = "Y";
		  		reqObject.SCREEN_KEY = "325";
		  		super.getInitHttpService().request = reqObject;
            }
            
            /**
            * This method fires the dispatchaction to initialize the
            * Banking Trade Amend Screen (InitAmend-SEQ-1)
            */
            override public function preAmendInit():void{  
                var rndNo:Number= Math.random(); 
                var reqObject:Object = new Object();
                if(this.mode == "amend"){
                    initLabel.text = this.parentApplication.xResourceManager.getKeyValue('frx.amend.title');          
                    super.getInitHttpService().url = "frx/frxTrdAmendDetailsDispatch.action?";
                    reqObject.rnd = rndNo;
                    reqObject.method= "frxTrdDetailsAmendQueryExecute";
                    reqObject.mode=this.mode;
                    reqObject.frxTrdPk = this.forexTradePkStr;
					reqObject.updateDateStart = this.updateDateStartStr;
					reqObject.updateDateEnd = this.updateDateEndStr;
			  		reqObject.SCREEN_KEY = "330";
                    super.getInitHttpService().request = reqObject;
                }else if(this.mode == "ptaxentry"){
                    initLabel.text = this.parentApplication.xResourceManager.getKeyValue('frx.ptax.entry');         
                    super.getInitHttpService().url = "frx/frxPTaxEntryDispatch.action?";
                    reqObject.rnd = rndNo;
                    reqObject.method= "frxTrdDetailsPTaxRateExecute";
                    reqObject.mode=this.mode;
                    reqObject.frxTrdPk = this.forexTradePkStr;
					reqObject.updateDateStart = this.updateDateStartStr;
					reqObject.updateDateEnd = this.updateDateEndStr;
			  		reqObject.SCREEN_KEY = "11056";
                    super.getInitHttpService().request = reqObject;
                }
                
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
                super.getInitHttpService().url = "frx/frxTrdCancelDetailsDispatch.action?";
                var reqObject:Object = new Object();
                reqObject.rnd = rndNo;
                reqObject.method= "frxTrdDetailsCancelQueryExecute";
                reqObject.mode=this.mode;
                reqObject.frxTrdPk = this.forexTradePkStr;
				reqObject.updateDateStart = this.updateDateStartStr;
				reqObject.updateDateEnd = this.updateDateEndStr;
		  		reqObject.SCREEN_KEY = "11090";
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
                //Instruction Block Flag
                keylist.addItem("scrDisDatas.instructionBlockFlagList.item");// index 5                            
                return keylist;
            }
            
            /**
            * This method adds the common keys to a list
            * which will be populated for both entry and amend
            */
            private function addCommonKeys():void{          
                keylist = new ArrayCollection();
                keylist.addItem("scrDisDatas.tradeTypeList.tradeTypeList");//0
                keylist.addItem("frxTrdData.tradeDate");//1
                keylist.addItem("scrDisDatas.buySellFlagList.item");//2
                keylist.addItem("scrDisDatas.calcMechanismList.item");//3
                keylist.addItem("scrDisDatas.confirmationStatusList.item"); //4               
            }
            
            /**
            * This method is pre-result handler for the Banking Trade Amend
            * Screen. It generates the list of keys which will be populated 
            * during the initialization of the Banking trade Amend screen. 
            * (InitAmend-SEQ-2)
            */
            override public function preAmendResultInit():Object{
                addCommonKeys(); 
                keylist.addItem("frxTrdData.inventoryAccountNo");
                keylist.addItem("frxTrdData.tradeType");
                keylist.addItem("frxTrdData.tradeTime");
                keylist.addItem("frxTrdData.valueDate");
                keylist.addItem("frxTrdData.buySell");
                keylist.addItem("frxTrdData.accountNo");
                keylist.addItem("frxTrdData.baseCcy");
                keylist.addItem("frxTrdData.baseCcyAmount");
                keylist.addItem("frxTrdData.againstCcy");
                keylist.addItem("frxTrdData.againstCcyAmount");
                keylist.addItem("frxTrdData.calcMechanism");
                keylist.addItem("frxTrdData.exchangeRate"); 
                keylist.addItem("frxTrdData.settleCcy");
                keylist.addItem("frxTrdData.calcMechForStlCcy");
                keylist.addItem("frxTrdData.exchangeRateForStlCcy");
                keylist.addItem("frxTrdData.referenceNo");
                keylist.addItem("frxTrdData.status");
                keylist.addItem("frxTrdData.confirmationStatus");
                keylist.addItem("frxTrdData.swapPl");
                keylist.addItem("frxTrdData.spotDate");
                keylist.addItem("frxTrdData.calcMechForSpotRate");
                keylist.addItem("frxTrdData.spotRate");
                keylist.addItem("frxTrdData.calcMechForStlCcyStr");
                keylist.addItem("frxTrdData.calcMechanismStr");
                keylist.addItem("frxTrdData.instructionBlockFlag");//index = 29
                
                return keylist;
            }
            
            /**
            * This method is pre-result handler for the Banking Trade Cancel
            * Screen. It generates the list of keys which will be populated 
            * during the initialization of the Banking trade Cancel screen. 
            * (InitCancel-SEQ-2)
            */
            override public function preCancelResultInit():Object{
                addCommonResultKeys();          
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
                
                /* Populating Instruction Block Flag Status drop down for Initial Entry-1*/
                var initcol:ArrayCollection = new ArrayCollection();
                initcol =  new ArrayCollection();
                initcol.addItem({label:" ", value: " "});
                if(mapObj[keylist.getItemAt(5)]!=null){
                    if(mapObj[keylist.getItemAt(5)] is ArrayCollection){
                        for each(var item5:Object in (mapObj[keylist.getItemAt(5)] as ArrayCollection)){
                            initcol.addItem(item5);
                        }
                    }else{
                        initcol.addItem(mapObj[keylist.getItemAt(5)]);
                    }
                }
                this.instructionBlockFlagCombo.dataProvider = initcol;
                this.instructionBlockFlagCombo.selectedIndex = 0;
                
                showHideFieldsForEntry();
            }
            
            /**
            * This method populates the elements of the Banking
            * Trade Amend screen(mxml)
            * from the map obtained from preAmendResultInit() (InitAmend-SEQ-3)
            */
            override public function postAmendResultInit(mapObj:Object): void{
                app.submitButtonInstance = submit;
                commonInit(mapObj);
                tradeTypeGlobal = mapObj[keylist.getItemAt(6)].toString();
                pTaxRateGlobal = mapObj[keylist.getItemAt(26)].toString();
                trdCcyGlobal = mapObj[keylist.getItemAt(11)].toString();
                prevBuyccy = mapObj[keylist.getItemAt(11)].toString();
                counterCcyGlobal = mapObj[keylist.getItemAt(13)].toString();
                prevSellccy = mapObj[keylist.getItemAt(13)].toString();
                stlCcyGlobal = mapObj[keylist.getItemAt(17)].toString();
                showHideFieldsForAmend(mapObj[keylist.getItemAt(6)].toString());
                var index:int=0;
                this.fundAccPopUp.accountNo.text = mapObj[keylist.getItemAt(5)] != null ? mapObj[keylist.getItemAt(5)].toString() : "";
                var tempCol:ArrayCollection = new ArrayCollection();
                /* Populating Trade type drop down*/
                 if(mapObj[keylist.getItemAt(0)]!=null){
                    if(mapObj[keylist.getItemAt(0)] is ArrayCollection){
                        for each(var item4:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
                            tempCol.addItem(item4);
                            if(item4 == mapObj[keylist.getItemAt(6)].toString()){
                                index = (mapObj[keylist.getItemAt(0)] as ArrayCollection).getItemIndex(item4);
                            }
                        }
                    }else{
                        tempCol.addItem(mapObj[keylist.getItemAt(0)]);
                        index = 0;
                    }
                }
                this.tradeType.dataProvider = tempCol;
                this.tradeType.selectedIndex = index;
                
                /* Populating Buy Sell drop down*/
                index = 0
                tempCol = new ArrayCollection();
                 if(mapObj[keylist.getItemAt(2)]!=null){
                    if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
                        for each(var item5:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
                            tempCol.addItem(item5);
                            if(item5.value == mapObj[keylist.getItemAt(9)].toString()){
                                index = (mapObj[keylist.getItemAt(2)] as ArrayCollection).getItemIndex(item5);
                            }
                        }
                    }else{
                        tempCol.addItem(mapObj[keylist.getItemAt(2)]);
                        index = 0;
                    }
                }
                this.buySell.dataProvider = tempCol;
                this.buySell.selectedIndex = index; 
                
                this.counterPartyAccPopUp.accountNo.text = mapObj[keylist.getItemAt(10)] != null ? mapObj[keylist.getItemAt(10)].toString() : "";
                this.tradeDate.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(1)].toString());
                this.tradeTime.text = mapObj[keylist.getItemAt(7)] != null ? mapObj[keylist.getItemAt(7)].toString() : "";
                this.valueDate.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(8)].toString());
                this.trdCcy.ccyText.text = mapObj[keylist.getItemAt(11)] != null ? mapObj[keylist.getItemAt(11)].toString() : "";
                this.trdCcyAmt.text = mapObj[keylist.getItemAt(12)] != null ? mapObj[keylist.getItemAt(12)].toString() : "";
                this.counterCcy.ccyText.text = mapObj[keylist.getItemAt(13)] != null ? mapObj[keylist.getItemAt(13)].toString() : "";
                this.counterCcyAmt.text = mapObj[keylist.getItemAt(14)] != null ? mapObj[keylist.getItemAt(14)].toString() : "";
                
                /* Populating Exchange Rate Calculation Type drop down*/
                index = 0
                tempCol = new ArrayCollection();
                exchangeRateList = new ArrayCollection();
                var customXchngRateCalcMech:String = XenosStringUtils.EMPTY_STR;
                if(mapObj[keylist.getItemAt(15)] == 'M'){
                	customXchngRateCalcMech = this.counterCcy.ccyText.text+'/'+this.trdCcy.ccyText.text;
                }else if(mapObj[keylist.getItemAt(15)] == 'D'){
                	customXchngRateCalcMech = this.trdCcy.ccyText.text+'/'+this.counterCcy.ccyText.text;
                }
                 if(returnExchangeRateList(this.counterCcy.ccyText.text,this.trdCcy.ccyText.text)!=null){
                    if(returnExchangeRateList(this.counterCcy.ccyText.text,this.trdCcy.ccyText.text) is ArrayCollection){
                        for each(var item6:Object in returnExchangeRateList(this.counterCcy.ccyText.text,this.trdCcy.ccyText.text)){
                            tempCol.addItem(item6);
                            exchangeRateList.addItem(item6);
                            if(item6.toString() == customXchngRateCalcMech){
                                index = returnExchangeRateList(this.counterCcy.ccyText.text,this.trdCcy.ccyText.text).getItemIndex(item6);
                            }
                        }
                    }/*else{
                        tempCol.addItem(customXchngRateCalcMech);
                        index = 0;
                    }*/
                }
                this.calcType.dataProvider = tempCol;
                this.calcType.selectedIndex = index;
                indexGlobal = index;
                this.exchngRate.text = mapObj[keylist.getItemAt(16)] != null ? mapObj[keylist.getItemAt(16)].toString() : "";
                this.stlCcy.ccyText.text = mapObj[keylist.getItemAt(17)] != null ? mapObj[keylist.getItemAt(17)].toString() : "";
                
                /* Populating Settlement Exchange Rate Calculation Type drop down*/
                index = 0
                tempCol = new ArrayCollection();
                var customXchngRateCalcMechStl:String = XenosStringUtils.EMPTY_STR;
                if(mapObj[keylist.getItemAt(18)] == 'M'){
                	customXchngRateCalcMechStl = this.stlCcy.ccyText.text+'/'+this.counterCcy.ccyText.text;
                }else if(mapObj[keylist.getItemAt(18)] == 'D'){
                	customXchngRateCalcMechStl = this.counterCcy.ccyText.text+'/'+this.stlCcy.ccyText.text;
                }
                if(XenosStringUtils.equals(this.tradeType.selectedItem.toString(), 'Non Deliverable Forward')){
                	if(returnExchangeRateList(this.stlCcy.ccyText.text,this.counterCcy.ccyText.text)!=null){
	                    if(returnExchangeRateList(this.stlCcy.ccyText.text,this.counterCcy.ccyText.text) is ArrayCollection){
	                        for each(var item7:Object in returnExchangeRateList(this.stlCcy.ccyText.text,this.counterCcy.ccyText.text)){
	                            tempCol.addItem(item7);
	                            if(item7 == customXchngRateCalcMechStl){
	                                index = returnExchangeRateList(this.stlCcy.ccyText.text,this.counterCcy.ccyText.text).getItemIndex(item7);
	                            }
	                        }
	                    }/*else{
	                        tempCol.addItem(mapObj[keylist.getItemAt(3)]);
	                        index = 0;
	                    }*/
	                }
                }
                this.calcTypeForStl.dataProvider = tempCol;
                this.calcTypeForStl.selectedIndex = index;
                
                this.exchngRateForStl.text = mapObj[keylist.getItemAt(19)] != null ? mapObj[keylist.getItemAt(19)].toString() : "";
                if(mapObj[keylist.getItemAt(24)] != null){
                    this.pTaxDate.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(24)].toString());
                }
                this.amdRefNo.text = mapObj[keylist.getItemAt(20)] != null ? mapObj[keylist.getItemAt(20)].toString() : "";
                
                /* Populating P-Tax Exchange Rate Calculation Type drop down*/
                index = 0
                tempCol = new ArrayCollection();
                var customXchngRateCalcMechSpot:String = XenosStringUtils.EMPTY_STR;
                if(mapObj[keylist.getItemAt(25)] == 'M'){
                	customXchngRateCalcMechSpot = this.counterCcy.ccyText.text+'/'+this.trdCcy.ccyText.text;
                }else if(mapObj[keylist.getItemAt(25)] == 'D'){
                	customXchngRateCalcMechSpot = this.trdCcy.ccyText.text+'/'+this.counterCcy.ccyText.text;
                }
                 if(returnExchangeRateList(this.counterCcy.ccyText.text,this.trdCcy.ccyText.text)!=null){
                    if(returnExchangeRateList(this.counterCcy.ccyText.text,this.trdCcy.ccyText.text) is ArrayCollection){
                        for each(var item8:Object in returnExchangeRateList(this.counterCcy.ccyText.text,this.trdCcy.ccyText.text)){
                            tempCol.addItem(item8);
                            if(item8 == customXchngRateCalcMechSpot){
                                index = returnExchangeRateList(this.counterCcy.ccyText.text,this.trdCcy.ccyText.text).getItemIndex(item8);
                            }
                        }
                    }/*else{
                        tempCol.addItem(mapObj[keylist.getItemAt(3)]);
                        index = 0;
                    }*/
                }
                this.pTaxCalcType.dataProvider = tempCol;
                this.pTaxCalcType.selectedIndex = index;
                
                this.pTaxExchngRate.text = mapObj[keylist.getItemAt(26)] != null ? mapObj[keylist.getItemAt(26)].toString() : "";
                this.amdStatus.text = mapObj[keylist.getItemAt(21)] != null ? mapObj[keylist.getItemAt(21)].toString() : "";
                this.pl.text = mapObj[keylist.getItemAt(23)] != null ? mapObj[keylist.getItemAt(23)].toString() : "";
                
                /* Populating Confimation Status drop down*/
                index = 0
                tempCol = new ArrayCollection();
                 if(mapObj[keylist.getItemAt(4)]!=null){
                    if(mapObj[keylist.getItemAt(4)] is ArrayCollection){
                        for each(var item9:Object in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
                            tempCol.addItem(item9);
                            if(item9.value == mapObj[keylist.getItemAt(22)].toString()){
                                index = (mapObj[keylist.getItemAt(4)] as ArrayCollection).getItemIndex(item9);
                            }
                        }
                    }else{
                        tempCol.addItem(mapObj[keylist.getItemAt(4)]);
                        index = 0;
                    }
                }
                this.confStatus.dataProvider = tempCol;
                this.confStatus.selectedIndex = index;
                
                // Instruction Block Flag
                this.uConfInxnBlockCombo.text = mapObj[keylist.getItemAt(29)] != null ? mapObj[keylist.getItemAt(29)].toString() : "";
                
                if(this.mode == 'ptaxentry'){
                    hidePTaxEntryFields();
                    showPTaxEntryLbls(mapObj);
                }
                
                fundAccPopUp.accountNo.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT));
                counterPartyAccPopUp.accountNo.dispatchEvent(new FocusEvent(FocusEvent.FOCUS_OUT));
                
            }
            
            //(Issue XGA-85)Populate the exchange rate list based on buy ccy & sell ccy value
            private function populateExchangeRateList(event:FocusEvent):void{  
				var temp:String = "";	
				if(XenosStringUtils.isBlank(trdCcy.ccyText.text) || XenosStringUtils.isBlank(counterCcy.ccyText.text)){
					exchangeRateList = null;
				}else{
					if(this.tradeType.selectedItem == 'Non Deliverable Forward'){
						exchangeRateList = new ArrayCollection();
						temp = counterCcy.ccyText.text.toString()+ '/' +trdCcy.ccyText.text.toString();	
						exchangeRateList.addItemAt(temp,0);
						temp = trdCcy.ccyText.text.toString()+'/'+counterCcy.ccyText.text.toString();	
						exchangeRateList.addItemAt(temp,1);
					} else {
						if(!XenosStringUtils.equals(prevBuyccy, this.trdCcy.ccyText.text) ||
							!XenosStringUtils.equals(prevSellccy, this.counterCcy.ccyText.text)){
							var req:Object = new Object();
							req['frxTrdData.inventoryAccountNo'] = fundAccPopUp.accountNo.text;
							req['frxTrdData.baseCcy'] = trdCcy.ccyText.text;
							req['frxTrdData.againstCcy'] = counterCcy.ccyText.text;							
							loadCalcMechanismHttpService.request=req;
					        loadCalcMechanismHttpService.send();
						}
					}
				}
				this.calcType.dataProvider = exchangeRateList;
				this.pTaxCalcType.dataProvider = exchangeRateList;
				if(!XenosStringUtils.equals(this.tradeType.selectedItem.toString(), 'Non Deliverable Forward')){
					this.calcType.selectedIndex = indexGlobal;
				}
				
				prevBuyccy = this.trdCcy.ccyText.text;
				prevSellccy = this.counterCcy.ccyText.text;
            }
            /*
            This method will be used for population of Exchange Rate Drop Down(with default highlighted option) for SPOT and FWD. 
            This value is calculated at server side depending some logic mentioned in XPXR-4054
            */
            private function populateCalcMechanismForSpotAndFwd(event:ResultEvent):void{              	
            	exchangeRateList = new ArrayCollection();
            	var temp:String = "";
            	var rs:XML=new XML();  
            	var calcMechanismStr:String = "";	
            	var count:int = 0;
            	//Populate static list            	
				temp = counterCcy.ccyText.text.toString()+ '/' +trdCcy.ccyText.text.toString();	
				exchangeRateList.addItemAt(temp,0);
				temp = trdCcy.ccyText.text.toString()+'/'+counterCcy.ccyText.text.toString();	
				exchangeRateList.addItemAt(temp,1);	
				
				rs=XML(event.result);	             	               	
            	        	
            	if (null != event) {  
            	   if (rs.child("Errors").length() > 0) {
            	 	// do nothing as we are only concerned about populating default selected index for Ex Rate drop down. 
            	 	// If any error occured, default selected index will be zero.
            	 	// All errors will be taken care of durying submit
            	   } else {
				     calcMechanismStr = rs.frxTrdData.calcMechanismStr;  	
				     // find the default selected index depending on the server side logic	for Ex Rate drop down			            	
				     for (count= 0; count < exchangeRateList.length; count++) {
					  var element:Object = exchangeRateList.getItemAt(count);				       			 
					  if (XenosStringUtils.equals(element.toString() , calcMechanismStr)) {
					     indexGlobal = count;
					     break;
					  }
		             }
		             //If Calculation type is set from Server Side, change the entered Exchange Rate to blank.
		             this.exchngRate.text = "";
		           }
            	}
            	
	            this.calcType.dataProvider = exchangeRateList; 
	            this.calcType.selectedIndex = indexGlobal; 
            }
            
            private function populateExchangeRateListForAmend(event: FocusEvent):void{
            	var temp:String = "";
            	var temp1:String = "";		           	
				temp = counterCcy.ccyText.text.toString()+ '/' +trdCcy.ccyText.text.toString();	
				temp1 = trdCcy.ccyText.text.toString()+'/'+counterCcy.ccyText.text.toString();	
				exchangeRateList = new ArrayCollection();
				if(this.tradeType.selectedItem == 'Non Deliverable Forward'){
					if(this.calcType.selectedItem == temp) {					
						exchangeRateList.addItemAt(temp,0);
						exchangeRateList.addItemAt(temp1,1);						
					} else if(this.calcType.selectedItem == temp1) {
						exchangeRateList.addItemAt(temp1,0);
						exchangeRateList.addItemAt(temp,1);						
					} else {
						exchangeRateList.addItemAt(temp,0);
						exchangeRateList.addItemAt(temp1,1);
					}
				} else{
					if(this.calcType.selectedItem == temp) {					
						exchangeRateList.addItemAt(temp,0);
						exchangeRateList.addItemAt(temp1,1);
					} else if(this.calcType.selectedItem == temp1) {
						exchangeRateList.addItemAt(temp1,0);
						exchangeRateList.addItemAt(temp,1);
					} 		
				}
				this.calcType.dataProvider = exchangeRateList;
				this.pTaxCalcType.dataProvider = exchangeRateList;
            }
            
            private function populateExchangeRateForStlCalcMech(event:FocusEvent):void{            	
				if(!XenosStringUtils.equals(this.tradeType.selectedItem.toString(),"Non Deliverable Forward")){
					return;
				}
				var temp:String = "";		
				if(XenosStringUtils.isBlank(stlCcy.ccyText.text) || XenosStringUtils.isBlank(counterCcy.ccyText.text)){
					exchangeRateList = null;
				}else{
					exchangeRateList = new ArrayCollection();
					temp = stlCcy.ccyText.text.toString() + '/' + counterCcy.ccyText.text.toString();	
					exchangeRateList.addItemAt(temp,0);
					temp = counterCcy.ccyText.text.toString() + '/' + stlCcy.ccyText.text.toString();	
					exchangeRateList.addItemAt(temp,1);
				}
				this.calcTypeForStl.dataProvider = exchangeRateList;
            }
            
            private function returnExchangeRateList(ccy1:String,ccy2:String):ArrayCollection{     
            	var xchngCol:ArrayCollection = new ArrayCollection();       	
				if(XenosStringUtils.isBlank(ccy1) || XenosStringUtils.isBlank(ccy2)){
					exchangeRateList = null;
				}else{
					xchngCol.addItemAt(ccy1 + '/' + ccy2,0);
					xchngCol.addItemAt(ccy2 + '/' + ccy1,1);
				}
				return xchngCol;
            }
            
            private function setFocusOnCcy(event:Event):void{
                (TextInput(event.currentTarget)).setFocus();
                (TextInput(event.currentTarget)).removeEventListener(FlexEvent.VALUE_COMMIT,setFocusOnCcy);
            }
            private function trdImgClickHandler(event:MouseEvent):void{
                trdCcy.ccyText.addEventListener(FlexEvent.VALUE_COMMIT,setFocusOnCcy);
                
            }
            
            private function counterImgClickHandler(event:MouseEvent):void{
                counterCcy.ccyText.addEventListener(FlexEvent.VALUE_COMMIT,setFocusOnCcy);
                
            }
            
            private function stlImgClickHandler(event:MouseEvent):void{
                stlCcy.ccyText.addEventListener(FlexEvent.VALUE_COMMIT,setFocusOnCcy);
                
            }
            
            /**
            * This method populates the elements of the Banking
            * Trade Cancel screen(mxml)
            * from the map obtained from preCancelResultInit() (InitCancel-SEQ-3)
            */
            override public function postCancelResultInit(mapObj:Object): void{
                    
                commonResultPart(mapObj);
                uConfLabel.text= this.parentApplication.xResourceManager.getKeyValue('frx.cancellation');
                uConfSubmit.includeInLayout = false;
                uConfSubmit.visible = false;
                cancelSubmit.visible = true;
                cancelSubmit.includeInLayout = true;
                app.submitButtonInstance = cancelSubmit; 
            }
            
            override public function preEntry():void{
                setValidator();
                super.getSaveHttpService().url = "frx/forexEntryDispatch.action?";  
                super.getSaveHttpService().request  = populateRequestParams();
             }
             
             override public function preEntryResultHandler():Object {
                 addCommonResultKeys();
                 return keylist;
            }
            
            override public function postEntryResultHandler(mapObj:Object):void
            {
                commonResult(mapObj);
            }
             
             override public function preAmend():void{
                var reqObj:Object = new Object();
                if(this.mode == 'amend'){
                    setValidator();
                    super.getSaveHttpService().url = "frx/frxTrdAmendDetailsDispatch.action?";  
                    reqObj = populateRequestParams();
                    reqObj.method = "frxTrdDetailsAmendConfirm";
                    reqObj.mode=this.mode;
                    super.getSaveHttpService().request = reqObj;    
                }else if(this.mode == 'ptaxentry'){
                    super._validator = null;
                    super.getSaveHttpService().url = "frx/frxPTaxEntryDispatch.action?";  
                    reqObj = populateRequestParams();
                    reqObj.method = "frxTrdPTaxConfirm";
                    reqObj.mode=this.mode;
                    super.getSaveHttpService().request = reqObj;
                }
             } 
             override public function preCancel():void{
                super._validator = null;
                super.getSaveHttpService().url = "frx/frxTrdCancelDetailsDispatch.action?"; 
                var reqObj:Object = new Object();
			 	reqObj.SCREEN_KEY = "326";
                reqObj.method="frxTrdDetailsCancelConfirm";
                super.getSaveHttpService().request = reqObj;
             }
             
             
            
            
            override public function preAmendResultHandler():Object
            {
                addCommonResultKeys();
                return keylist;
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
	                    uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('frx.cxl.user.conf');
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
	                    commonResultPart(mapObj);
	                }else{
	                    errPage.removeError();
	                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred'));
	                }           
	            }
	        }
            
            
            
            override public function postAmendResultHandler(mapObj:Object):void
            {
                if(this.mode == 'amend'){
                    this.uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('frx.amend.userconf');
                }else if(this.mode == 'ptaxentry'){
                    this.uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('frx.ptaxentry.userconf');
                }
                commonResult(mapObj);
            }
             
             
            
            override public function preEntryConfirm():void
            {
                var reqObj :Object = new Object();
                super.getConfHttpService().url = "frx/forexEntryDispatch.action?";  
				reqObj.SCREEN_KEY = "327";
                reqObj.method= "commit";
                super.getConfHttpService().request = reqObj;
            }
            
            override public function preAmendConfirm():void
            {
                var reqObj :Object = new Object();
                if(this.mode == 'amend'){
                    super.getConfHttpService().url = "frx/frxTrdAmendDetailsDispatch.action?";  
					reqObj.SCREEN_KEY = "11089";
                    reqObj.method= "commitAmendment";
                    super.getConfHttpService().request = reqObj;
                }else if(this.mode == 'ptaxentry'){
                    super.getConfHttpService().url = "frx/frxPTaxEntryDispatch.action?";  
					reqObj.SCREEN_KEY = "11058"; 
                    reqObj.method= "commitPTaxEntry";
                    super.getConfHttpService().request = reqObj;
                }
                
            }
            
            override public function preCancelConfirm():void
            {
                var reqObj :Object = new Object();
                super.getConfHttpService().url = "frx/frxTrdCancelDetailsDispatch.action?";  
				reqObj.SCREEN_KEY = "11091";
                reqObj.method= "commitCancel";
                super.getConfHttpService().request = reqObj;
            }
            
            override public function postConfirmEntryResultHandler(mapObj:Object):void
            {
                submitUserConfResult(mapObj);
            }
            override public function postConfirmAmendResultHandler(mapObj:Object):void
            {
                if(this.mode == 'amend'){
                    this.sConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('frx.amend.systemconf');
                }else if(this.mode == 'ptaxentry'){
                    this.sConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('frx.ptaxentry.systemconf');
                }
                submitUserConfResult(mapObj);
            }
            override public function postConfirmCancelResultHandler(mapObj:Object):void
            {
                submitUserConfResult(mapObj);
            }
            
            override public function preResetEntry():void
           {
               var rndNo:Number= Math.random();
                super.getResetHttpService().url = "frx/forexEntryDispatch.action?method=initialExecute&rnd=" + rndNo; 
           }
           override public function preResetAmend():void
           {
            var rndNo:Number= Math.random();
              if(this.mode == 'amend'){
                super.getResetHttpService().url = "frx/frxTrdAmendDetailsDispatch.action?method=resetAmendment&rnd=" + rndNo;
              }else if(this.mode == 'ptaxentry'){
                super.getResetHttpService().url = "frx/frxPTaxEntryDispatch.action?method=resetPTaxEntry&rnd=" + rndNo;
              }
                
           }
           
           
            override public function doEntrySystemConfirm(e:Event):void
            {
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
                     this.uConfTradeType.text = "";
                     
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
                this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
                this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
            }
            
            
            private function stlExchangRateHide(event:FocusEvent):void{
                if(this.tradeType.selectedItem == "Non Deliverable Forward"){
                	populateExchangeRateForStlCalcMech(event);
                    if((this.trdCcy.ccyText.text == this.stlCcy.ccyText.text)||(this.counterCcy.ccyText.text == this.stlCcy.ccyText.text)){
                        this.calcTypeForStl.enabled = false;
                        this.exchngRateForStl.enabled = false;
                    }else{
                        this.calcTypeForStl.enabled = true;
                        this.exchngRateForStl.enabled = true;
                    }
                }
            }
            
            private function commonInit(mapObj:Object):void{
                var initcol:ArrayCollection = new ArrayCollection();
                errPage.clearError(super.getInitResultEvent());
                this.fundAccPopUp.accountNo.text = "";
                this.fundAccName.text = "";
                /* Populating Trade type drop down*/
                if(mapObj[keylist.getItemAt(0)]!=null){
                    if(mapObj[keylist.getItemAt(0)] is ArrayCollection){
                        for each(var item:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
                            initcol.addItem(item);
                        }
                    }else{
                        initcol.addItem(mapObj[keylist.getItemAt(0)].toString());
                    }
                }
                this.tradeType.dataProvider = initcol;
                
                if(mapObj[keylist.getItemAt(1)]!=null){
                  this.tradeDate.selectedDate = DateUtils.toDate(mapObj[keylist.getItemAt(1)].toString());          
                }
                
                this.tradeTime.text = "";
                this.valueDate.selectedDate = null;
                
                /* Populating Buy Sell drop down*/
                initcol =  new ArrayCollection();
                initcol.addItem({label:" ", value: " "});
                if(mapObj[keylist.getItemAt(2)]!=null){
                    if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
                        for each(var item1:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
                            initcol.addItem(item1);
                        }
                    }else{
                        initcol.addItem(mapObj[keylist.getItemAt(2)]);
                    }
                }
                this.buySell.dataProvider = initcol;
                this.counterPartyAccPopUp.accountNo.text = "";
                this.cpAccName.text = "";
                this.trdCcy.ccyText.text = "";
                this.trdCcyAmt.text = "";
                this.counterCcy.ccyText.text = "";
                this.counterCcyAmt.text = "";
                /* Populating Exchange Rate Calculation Type drop down*/
                initcol =  new ArrayCollection();
                /* if(mapObj[keylist.getItemAt(3)]!=null){
                    if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
                        for each(var item2:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
                            initcol.addItem(item2);
                        }
                    }else{
                        initcol.addItem(mapObj[keylist.getItemAt(3)]);
                    }
                } */
                this.calcType.dataProvider = initcol;
                this.exchngRate.text = "";
                this.stlCcy.ccyText.text = "";
                /* Populating Confirmation Status drop down*/
                initcol =  new ArrayCollection();
                if(mapObj[keylist.getItemAt(4)]!=null){
                    if(mapObj[keylist.getItemAt(4)] is ArrayCollection){
                        for each(var item3:Object in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
                            initcol.addItem(item3);
                        }
                    }else{
                        initcol.addItem(mapObj[keylist.getItemAt(4)]);
                    }
                }
                this.confStatus.dataProvider = initcol;
                
                tradeTypeGlobal = "";
                pTaxRateGlobal = "";
                trdCcyGlobal = "";
                counterCcyGlobal = "";
                stlCcyGlobal = "";
                prevBuyccy = "";
                prevSellccy = "";
                
            }
            
            
            
            
            private function commonResultPart(mapObj:Object):void{
                if(mapObj[keylist.getItemAt(1)].toString() == "Non Deliverable Forward"){
                    showHideConfFieldsForNdf();
                }else{
                    showHideConfFieldsForNonNdf();
                }
                 this.uConfFundAccNo.text = mapObj[keylist.getItemAt(0)].toString();
                 this.uConfTradeType.text = mapObj[keylist.getItemAt(1)].toString();
                 this.uConfTradeDateTime.text = mapObj[keylist.getItemAt(2)].toString()+"|"+mapObj[keylist.getItemAt(3)].toString();
                 this.uConfValueDate.text = mapObj[keylist.getItemAt(4)].toString();
                 //this.uConfBuySell.text = mapObj[keylist.getItemAt(5)].toString();
                 this.uConfCounterPartyAccNo.text = mapObj[keylist.getItemAt(6)].toString();
                 this.uConfTradeCcy.text = mapObj[keylist.getItemAt(7)].toString();
                 this.uConfTradeCcyAmt.text = mapObj[keylist.getItemAt(8)].toString();
                 this.uConfCounterCcy.text = mapObj[keylist.getItemAt(9)].toString();
                 this.uConfCounterCcyAmt.text = mapObj[keylist.getItemAt(10)].toString();
                 this.uConfCalcType.text = mapObj[keylist.getItemAt(11)].toString();
                 this.uConfExchngRate.text = mapObj[keylist.getItemAt(12)].toString();
                 this.uConfCancelRefNo.text = mapObj[keylist.getItemAt(13)].toString();
                 this.uConfStlExchngCalcType.text = mapObj[keylist.getItemAt(14)].toString();
                 this.uConfStlExchngRate.text = mapObj[keylist.getItemAt(15)].toString();
                 this.uConfRefNo.text = mapObj[keylist.getItemAt(16)].toString();
                 this.uConfStatus.text = mapObj[keylist.getItemAt(17)].toString();
                 this.uConfConfStatus.text = mapObj[keylist.getItemAt(18)].toString();
                 this.uConfStlCcy.text = mapObj[keylist.getItemAt(19)].toString();
                 this.uConfPTaxRateCalcMech.text = mapObj[keylist.getItemAt(20)].toString();
                 this.uConfPTaxRate.text = mapObj[keylist.getItemAt(21)].toString();
                 this.uConfPL.text = mapObj[keylist.getItemAt(22)].toString();
                 this.uConfPTaxDate.text = mapObj[keylist.getItemAt(23)].toString();
                 this.uConfFundAccName.text = mapObj[keylist.getItemAt(24)].toString();
                 this.uConfCounterPartyAccName.text = mapObj[keylist.getItemAt(25)].toString();
                 //Instruction Block Flag
                 this.uConfInxnBlockCombo.text = mapObj[keylist.getItemAt(26)].toString();
                 // Set P-Tax Date Globally
                 pTaxDateGlobal = mapObj[keylist.getItemAt(23)].toString();
                 softWarn.showWarning(mapObj["softWarning"]); 
                 prevBuyccy = mapObj[keylist.getItemAt(7)].toString();
                 prevSellccy = mapObj[keylist.getItemAt(9)].toString();
                 this.trdCcyAmt.text = mapObj[keylist.getItemAt(8)].toString();
                 this.counterCcyAmt.text = mapObj[keylist.getItemAt(10)].toString();
                 this.exchngRate.text = mapObj[keylist.getItemAt(12)].toString();
            }
            
            
            private function addCommonResultKeys():void{
                keylist = new ArrayCollection();
                keylist.addItem("frxTrdData.inventoryAccountNo");
                keylist.addItem("frxTrdData.tradeType");
                keylist.addItem("frxTrdData.tradeDate");
                keylist.addItem("frxTrdData.tradeTime");
                keylist.addItem("frxTrdData.valueDate");
                keylist.addItem("frxTrdData.buySellStr");
                keylist.addItem("frxTrdData.accountNo");
                keylist.addItem("frxTrdData.baseCcy");
                keylist.addItem("frxTrdData.baseCcyAmount");
                keylist.addItem("frxTrdData.againstCcy");
                keylist.addItem("frxTrdData.againstCcyAmount");
                keylist.addItem("frxTrdData.calcMechanismStr");
                keylist.addItem("frxTrdData.exchangeRate");
                keylist.addItem("frxTrdData.cancelReferenceNo");
                keylist.addItem("frxTrdData.calcMechForStlCcyStr");
                keylist.addItem("frxTrdData.exchangeRateForStlCcy");
                keylist.addItem("frxTrdData.referenceNo");
                keylist.addItem("frxTrdData.status");
                keylist.addItem("frxTrdData.confirmationStatusStr");
                keylist.addItem("frxTrdData.settleCcy");
                keylist.addItem("frxTrdData.calcMechForSpotRateStr");
                keylist.addItem("frxTrdData.spotRate");
                keylist.addItem("frxTrdData.swapPl");
                keylist.addItem("frxTrdData.spotDate");
                keylist.addItem("frxTrdData.fundAccName");
                keylist.addItem("frxTrdData.cpAccName");
                keylist.addItem("frxTrdData.instructionBlockFlag");//index = 26
            }
            
            private function commonResult(mapObj:Object):void{
                if(mapObj!=null){  
                    if(mapObj["errorFlag"].toString() == "error"){
                    	app.submitButtonInstance = submit;
                        errPage.showError(mapObj["errorMsg"]);                      
                    }else if(mapObj["errorFlag"].toString() == "noError"){
                     usrConfErrPage.clearError(super.getSaveResultEvent());
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
          var validateModel:Object={
                            forexTradeEntry:{
                                fundAccNo:this.fundAccPopUp.accountNo != null ? this.fundAccPopUp.accountNo.text : XenosStringUtils.EMPTY_STR,
                                tradeType:this.tradeType.selectedItem != null ? this.tradeType.selectedItem : XenosStringUtils.EMPTY_STR,
                                tradeDate:this.tradeDate.text != "" ? StringUtil.trim(this.tradeDate.text) : XenosStringUtils.EMPTY_STR,
                                valueDate:this.valueDate.text != "" ? StringUtil.trim(this.valueDate.text) : XenosStringUtils.EMPTY_STR,                              
                                buySell  :this.mode == "entry" ? StringUtil.trim("B") : (this.buySell.selectedItem != null ? this.buySell.selectedItem.value : XenosStringUtils.EMPTY_STR),                       
                                counterPartyAccNo:this.counterPartyAccPopUp.accountNo != null ? this.counterPartyAccPopUp.accountNo.text:XenosStringUtils.EMPTY_STR,
                                tradeCcy:this.trdCcy.ccyText != null ? this.trdCcy.ccyText.text:"",
                                tradeCcyAmt:StringUtil.trim(this.trdCcyAmt.text) != null ? StringUtil.trim(this.trdCcyAmt.text):XenosStringUtils.EMPTY_STR,                          
                                sellCcy:this.counterCcy.ccyText != null ? this.counterCcy.ccyText.text:XenosStringUtils.EMPTY_STR,
                                settlementCcy:this.stlCcy.ccyText != null ? this.stlCcy.ccyText.text:XenosStringUtils.EMPTY_STR,                             
                                counterCcy:this.counterCcy.ccyText != null ? this.counterCcy.ccyText.text:XenosStringUtils.EMPTY_STR,
                                mode:this.mode,
                                counterCcyAmt:StringUtil.trim(this.counterCcyAmt.text) != null ? StringUtil.trim(this.counterCcyAmt.text):XenosStringUtils.EMPTY_STR,
                                exchngRateCalcType:this.calcType.selectedItem != null ? this.calcType.selectedItem:XenosStringUtils.EMPTY_STR,
                                exchngRate:StringUtil.trim(this.exchngRate.text) != null ? StringUtil.trim(this.exchngRate.text): XenosStringUtils.EMPTY_STR,
                                confimationStatus:this.confStatus.selectedItem != null ? this.confStatus.selectedItem.value:XenosStringUtils.EMPTY_STR,
                                //though currently no validation against this field, but same is provided to the validator for future enhancements
                                insBlockFlag: this.instructionBlockFlagCombo.selectedItem != null ? this.instructionBlockFlagCombo.selectedItem.value : XenosStringUtils.EMPTY_STR,
                                check:this.tradeType.selectedItem == 'Non Deliverable Forward' ? "false":"true"                                
                            }
                           }; 
                    
                    super._validator = new FrxTradeEntryValidator();
                    super._validator.source = validateModel ;
                    super._validator.property = "forexTradeEntry";
             
        }
        
         
        override public function preEntryConfirmResultHandler():Object{
            addCommonResultKeys();
            return keylist;
        }
        
        override public function preConfirmAmendResultHandler():Object{
            addCommonResultKeys();
            return keylist;
        }
        
        override public function preCancelResultHandler():Object{
            addCommonResultKeys();
            return keylist;
        }
        
        override public function preConfirmCancelResultHandler():Object{
            addCommonResultKeys();
            return keylist;
        }
        
        private function submitUserConfResult(mapObj:Object):void{
        	uConfSubmit.enabled = true;
        	back.enabled = true;
            if(mapObj!=null){    
                if(mapObj["errorFlag"].toString() == "error"){
                    usrConfErrPage.showError(mapObj["errorMsg"]);
                    if(mode=="cancel"){
                    	uCancelConfSubmit.enabled = true;
                    	app.submitButtonInstance = uCancelConfSubmit;
                    }else{
                    	app.submitButtonInstance = uConfSubmit;
                    }
                }else if(mapObj["errorFlag"].toString() == "noError"){
                    if(mode!="cancel"){
                      errPage.clearError(super.getConfResultEvent());
                      this.back.includeInLayout = false;
	                   this.back.visible = false;
	                   uConfSubmit.includeInLayout = false;
	                   uConfSubmit.visible = false;
                    } else if(mode=="cancel"){
                    	sConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('frx.cxl.system.conf');
		                cancelSubmit.visible = false;
		                cancelSubmit.includeInLayout = false;
		                uCancelConfSubmit.visible = false;
		                uCancelConfSubmit.includeInLayout = false;
                    }
                    sConfLabel.includeInLayout = true;
		            sConfLabel.visible = true;
                    uConfLabel.includeInLayout = false;
		            uConfLabel.visible = false;
                    sConfSubmit.includeInLayout = true;
	                sConfSubmit.visible = true;   
	                app.submitButtonInstance = sConfSubmit;
                    usrConfErrPage.clearError(super.getConfResultEvent());
                    commonResultPart(mapObj);
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
    	if(this.mode == 'entry'){
    		reqObj['SCREEN_KEY'] = "326";
    	} else if(this.mode == 'amend'){
    		reqObj['SCREEN_KEY'] = "11088";
    	} else if(this.mode == 'ptaxentry'){
    		reqObj['SCREEN_KEY'] = "11057";
    	}
        reqObj.method= "confirm";
        reqObj.rnd= Math.random();
        reqObj['frxTrdData.inventoryAccountNo'] = this.fundAccPopUp.accountNo.text;
        reqObj['frxTrdData.fundAccName'] = this.fundAccName.text;
        reqObj['frxTrdData.tradeType'] = this.tradeType.selectedItem != null ? this.tradeType.selectedItem : "";
        reqObj['frxTrdData.tradeDate'] = this.tradeDate.text;
        reqObj['frxTrdData.tradeTime'] = StringUtil.trim(this.tradeTime.text);
        reqObj['frxTrdData.valueDate'] = this.valueDate.text;
        if(this.mode == 'entry'){
        reqObj['frxTrdData.buySell'] = 'B';	
        }else{
        reqObj['frxTrdData.buySell'] = this.buySell.selectedItem != null ? this.buySell.selectedItem.value : "";	
        }
        reqObj['frxTrdData.accountNo'] = this.counterPartyAccPopUp.accountNo.text;
        reqObj['frxTrdData.cpAccName'] = this.cpAccName.text;
        reqObj['frxTrdData.baseCcy'] = this.trdCcy.ccyText.text;
        reqObj['frxTrdData.baseCcyAmount'] = this.trdCcyAmt.text;
        reqObj['frxTrdData.againstCcy'] = this.counterCcy.ccyText.text;
        reqObj['frxTrdData.againstCcyAmount'] = this.counterCcyAmt.text;
        reqObj['frxTrdData.calcMechanism'] = this.calcType.selectedItem != null ? this.calcType.selectedItem : "";
        reqObj['frxTrdData.exchangeRate'] = this.exchngRate.text;
        reqObj['frxTrdData.settleCcy'] = this.stlCcy.ccyText.text;
        reqObj['frxTrdData.confirmationStatus'] = this.confStatus.selectedItem != null ? this.confStatus.selectedItem.value : "";
        if(this.mode == 'entry'){        	
        reqObj['frxTrdData.instructionBlockFlag'] = this.instructionBlockFlagCombo.selectedItem != null ? this.instructionBlockFlagCombo.selectedItem.value : "";
        } else if(this.mode == 'amend'){
        reqObj['frxTrdData.instructionBlockFlag'] = this.uConfInxnBlockCombo.text;	
        }        
        reqObj['frxTrdData.calcMechForStlCcy'] = this.calcTypeForStl.selectedItem != null ? this.calcTypeForStl.selectedItem : "";
        reqObj['frxTrdData.exchangeRateForStlCcy'] = this.exchngRateForStl.text;
        if(this.mode != 'entry'){
            reqObj['frxTrdData.status'] = this.amdStatus.text;
            reqObj['frxTrdData.referenceNo'] = this.amdRefNo.text;
        }
        reqObj['frxTrdData.settleCcy'] = this.stlCcy.ccyText.text;
        reqObj['frxTrdData.calcMechForSpotRate'] = this.pTaxCalcType.selectedItem != null ? this.pTaxCalcType.selectedItem : "";
        reqObj['frxTrdData.spotRate'] = this.pTaxExchngRate.text;
        reqObj['frxTrdData.spotDate'] = this.pTaxDate.text;
        reqObj['frxTrdData.swapPl'] = this.pl.text;
        reqObj['frxTrdData.tradeConfirmReqd'] = "";
        
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
    private function populateActContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
      
        //passing act type                
        var actTypeArray:Array = new Array(1);
            actTypeArray[0]="T|S|B";
            //cpTypeArray[1]="CLIENT";
        myContextList.addItem(new HiddenObject("invActTypeContext",actTypeArray));    
                  
        var cpTypeArray:Array = new Array(1);
            cpTypeArray[0]="BROKER|BANK/CUSTODIAN";
            //cpTypeArray[1]="CLIENT";
        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
    
        //passing account status                
        var actStatusArray:Array = new Array(1);
        actStatusArray[0]="TRADING|BOTH";
        myContextList.addItem(new HiddenObject("actContext",actStatusArray));
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
        
        /**
        * This method validates user specified time
        * */
        private function validateTime(timeStr:String):String {
	    	var timeVal:String = StringUtil.trim(timeStr);
			var hh:String = "";
			var mm:String = "";
			var ss:String = "";
			var m:Number = 0;
			var s:Number = 0;
			
	    	if(timeVal.length == 0){
				return XenosStringUtils.EMPTY_STR;
	    	}else if (timeVal.length == 8){
	    		m = 3;
   				s = 6;
   				if ((timeVal.charAt(2) != ":") || (timeVal.charAt(5) != ":") || (!(int(timeVal)==0))){ 
   					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('frx.error.invalid.time8char'));
			     	return "";
			    }
  			}else if (timeVal.length == 6){ 
  				m = 2;
			    s = 4;
			    if (!NumberUtils.checkValidNumber(timeVal)){ 
			    	XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('frx.error.invalid.time6char'));
			     	return "";
			    }
			  }else if (timeVal.length == 5){
				  m = 3;
			      if (timeVal.charAt(2) != ":"){ 
			   	   XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('frx.error.invalid.time5char'));
			       return "";
			      }
			  }else if (timeVal.length == 4){ 
			  	m = 2;
   				if (int(timeVal)==0){ 
   					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('frx.error.invalid.time4char'));
     				return "";
    		    }
              }else { 
			   XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('frx.error.invalid.timeformat'));
			   return "";
			  }
			  
			  //------hours validation------------
			 var strHH:String = timeVal.charAt(0) + timeVal.charAt(1);
			 if (!NumberUtils.checkValidNumber(strHH))
			  { XenosAlert.error (this.parentApplication.xResourceManager.getKeyValue('frx.error.hour.nonnumeric'));
			   return "";
			  }
			 var numHH:Number = parseInt(strHH);
			 if (numHH > 23)
			  { XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('frx.error.hour.lessthan24'));
			   return "";
			  }
			
			 //------minutes validation------------
			 var strMM:String = timeVal.charAt(m) + timeVal.charAt(m+1);
			 if (!NumberUtils.checkValidNumber(strMM))
			  { XenosAlert.error (this.parentApplication.xResourceManager.getKeyValue('frx.error.min.nonnumeric'));
			   return "";
			  }
			 var numMM:Number = parseInt(strMM);
			 if (numMM > 59)
			  { XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('frx.error.min.lessthan60'));
			   return "";
			  }
			
			 //------seconds validation------------
			 var strSS:String = '00';
			 if ((timeVal.length == 8) || (timeVal.length == 6)){ 
			 	strSS = timeVal.charAt(s) + timeVal.charAt(s+1);
			 if (!NumberUtils.checkValidNumber(strSS)){ 
			   		XenosAlert.error (this.parentApplication.xResourceManager.getKeyValue('frx.error.second.nonnumeric'));
			        return "";
			   }
			   var numSS:Number = parseInt(strSS);
			   if (numSS > 59){ 
			   		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('frx.error.second.lessthan60'));
			     	return "";
			   }
			  }else 
			  	strSS = "00";
			  	
			  timeVal = strHH + ":" + strMM + ":" + strSS;
	    	  return timeVal;	
	    } 
	    
	      
        private function tradeTypeChange():void {
            if(this.mode == "amend"){
                showHideFieldsForAmend(tradeTypeGlobal);
            }else if(this.mode == "entry"){
                showHideFieldsForEntry();
            }
        }
        
        private function showHideFieldsForEntry():void{
            this.amdRefNoRow.visible = false;
            this.amdRefNoRow.includeInLayout = false;
            this.amdStatusPLRow.visible = false;
            this.amdStatusPLRow.includeInLayout = false;
            this.amdStlERPTaxDateRow.visible = false;
            this.amdStlERPTaxDateRow.includeInLayout = false;
            if(this.tradeType.selectedItem == "Non Deliverable Forward"){
                showHideFieldsForNdf();
            }else{
                showHideFieldsForNonNdf();
            }
        }
        private function showHideFieldsForAmend(trdType:String):void{
            this.amdRefNoRow.visible = true;
            this.amdRefNoRow.includeInLayout = true;
            this.amdStatusPLRow.visible = true;
            this.amdStatusPLRow.includeInLayout = true;
            this.amdStlERPTaxDateRow.visible = false;
            this.amdStlERPTaxDateRow.includeInLayout = false;
            if(trdType == "Non Deliverable Forward"){
                showHideFieldsForNdf();
                showHideStlExchngRate();
                if(pTaxRateGlobal != null && pTaxRateGlobal != ""){
                    this.pTaxDate.enabled = true;
                    this.pTaxCalcType.enabled = true;
                    this.pTaxExchngRate.enabled = true;
                }else{
                    this.pTaxDate.enabled = false;
                    this.pTaxCalcType.enabled = false;
                    this.pTaxExchngRate.enabled = false;
                }
                this.amdStlERPTaxDateRow.visible = true;
                this.amdStlERPTaxDateRow.includeInLayout = true;
                this.pTaxRateLbl.visible = true;
                this.pTaxCalcType.visible = true;
                this.pTaxExchngRate.visible = true;
                this.pTaxRateLbl.includeInLayout = true;
                this.pTaxCalcType.includeInLayout = true;
                this.pTaxExchngRate.includeInLayout = true;
                this.pl.visible = true;
                this.pl.includeInLayout = true;
                this.plLbl.visible = true;
                this.plLbl.includeInLayout = true;
            }else{
                showHideFieldsForNonNdf();
                this.pTaxRateLbl.visible = false;
                this.pTaxCalcType.visible = false;
                this.pTaxExchngRate.visible = false;
                this.pTaxRateLbl.includeInLayout = false;
                this.pTaxCalcType.includeInLayout = false;
                this.pTaxExchngRate.includeInLayout = false;
                this.pl.visible = false;
                this.pl.includeInLayout = false;
                this.plLbl.visible = false;
                this.plLbl.includeInLayout = false;
            }
                this.instructionBlockFlagLevel.visible = false;
                this.instructionBlockFlagLevel.includeInLayout = false;
                this.instructionBlockFlagCombo.visible = false;
                this.instructionBlockFlagCombo.includeInLayout = false;
        }
        
        private function showHideFieldsForNonNdf():void{
            this.counterCcyAmt.visible = true;
            this.counterCcyAmt.includeInLayout = true;
            this.counterCcyL.visible = true;
            this.counterCcyL.includeInLayout = true;
            this.confStatus.visible = true;
            this.confStatus.includeInLayout = true;
            this.confStatusL.visible = true;
            this.confStatusL.includeInLayout = true;
            //Instruction Block Flag
            this.instructionBlockFlagLevel.visible = true;
            this.instructionBlockFlagLevel.includeInLayout = true;
            this.instructionBlockFlagCombo.visible = true;
            this.instructionBlockFlagCombo.includeInLayout = true;
            
            this.stlCcyL.visible = false;
            this.stlCcyL.includeInLayout = false;
            this.stlCcy.visible = false;
            this.stlCcy.includeInLayout = false;
            this.exRateLbl.styleName= '';
            this.bCcyAmtLbl.styleName= '';
        }
        
        private function showHideFieldsForNdf():void{
            this.counterCcyAmt.visible = false;
            this.counterCcyAmt.includeInLayout = false;
            this.counterCcyL.visible = false;
            this.counterCcyL.includeInLayout = false;
            this.confStatus.visible = false;
            this.confStatus.includeInLayout = false;
            this.confStatusL.visible = false;
            this.confStatusL.includeInLayout = false;
            //Instruction Block Flag
            this.instructionBlockFlagLevel.visible = true;
            this.instructionBlockFlagLevel.includeInLayout = true;
            this.instructionBlockFlagCombo.visible = true;
            this.instructionBlockFlagCombo.includeInLayout = true;
            
            this.counterCcyL.includeInLayout = false;
            this.stlCcyL.visible = true;
            this.stlCcyL.includeInLayout = true;
            this.stlCcy.visible = true;
            this.stlCcy.includeInLayout = true;
            this.exRateLbl.styleName= 'ReqdLabel';
            this.bCcyAmtLbl.styleName= 'ReqdLabel';
        }
        
        private function showHideConfFieldsForNdf():void{
            
            if(this.mode == 'ptaxentry'){
                this.pTaxDateGlobal = "";
                this.uConfCounterCcyAmt.visible = true;
                this.uConfCounterCcyAmt.includeInLayout = true;
                this.uConfCounterCcyAmtLbl.visible = true;
                this.uConfCounterCcyAmtLbl.includeInLayout = true;
            }else{
                this.uConfCounterCcyAmt.visible = false;
                this.uConfCounterCcyAmt.includeInLayout = false;
                this.uConfCounterCcyAmtLbl.visible = false;
                this.uConfCounterCcyAmtLbl.includeInLayout = false;
            }
            this.uConfStatusLbl.visible = false;
            this.uConfStatusLbl.includeInLayout = false;
            //Instruction Block Flag
            this.uConfInxnBlockLevel.visible = true;
            this.uConfInxnBlockLevel.includeInLayout = true;
            
            this.uConfConfStatus.visible = false;
            this.uConfConfStatus.includeInLayout = false;
            //
            this.uConfInxnBlockCombo.visible = true;
            this.uConfInxnBlockCombo.includeInLayout = true;
            
            this.stlExchngRate.visible = true;
            this.stlExchngRate.includeInLayout = true;
            this.uConfStlCcyPTaxRateRow.visible = true;
            this.uConfStlCcyPTaxRateRow.includeInLayout = true;
            this.uConfPLPTaxDateRow.visible = true;
            this.uConfPLPTaxDateRow.includeInLayout = true;
            
        }
        private function showHideConfFieldsForNonNdf():void{
            this.uConfCounterCcyAmt.visible = true;
            this.uConfCounterCcyAmt.includeInLayout = true;
            this.uConfCounterCcyAmtLbl.visible = true;
            this.uConfCounterCcyAmtLbl.includeInLayout = true;
            
            this.uConfStatusLbl.visible = true;
            this.uConfStatusLbl.includeInLayout = true;
            //Instruction Block Flag
            this.uConfInxnBlockLevel.visible = true;
            this.uConfInxnBlockLevel.includeInLayout = true;
            
            this.uConfConfStatus.visible = true;
            this.uConfConfStatus.includeInLayout = true;
            //Instruction Block Flag
            this.uConfInxnBlockCombo.visible = true;
            this.uConfInxnBlockCombo.includeInLayout = true;
            
            this.stlExchngRate.visible = false;
            this.stlExchngRate.includeInLayout = false;
            this.uConfStlCcyPTaxRateRow.visible = false;
            this.uConfStlCcyPTaxRateRow.includeInLayout = false;
            this.uConfPLPTaxDateRow.visible = false;
            this.uConfPLPTaxDateRow.includeInLayout = false;
        }
        private function showHideStlExchngRate():void{
            if(tradeTypeGlobal == "Non Deliverable Forward"){
                if((trdCcyGlobal == stlCcyGlobal)||(counterCcyGlobal == stlCcyGlobal)){
                    this.calcTypeForStl.enabled = false;
                    this.exchngRateForStl.enabled = false;
                }else{
                    this.calcTypeForStl.enabled = true;
                    this.exchngRateForStl.enabled = true;
                }
            }
        }
        
        private function hidePTaxEntryFields():void{
            this.fundAccPopUp.visible =  false;
            this.fundAccPopUp.includeInLayout =  false;
            this.tradeType.visible =  false;
            this.tradeType.includeInLayout = false;
            this.tradeDate.visible =  false;
            this.tradeDate.includeInLayout = false;
            this.tradeTime.visible =  false;
            this.tradeTime.includeInLayout = false;
            this.valueDate.visible =  false;
            this.valueDate.includeInLayout = false;
            //this.buySell.visible =  false;
            //this.buySell.includeInLayout = false;
            this.counterPartyAccPopUp.visible =  false;
            this.counterPartyAccPopUp.includeInLayout = false;
            this.trdCcy.visible =  false;
            this.trdCcy.includeInLayout = false;
            this.trdCcyAmt.visible =  false;
            this.trdCcyAmt.includeInLayout = false;
            this.counterCcy.visible =  false;
            this.counterCcy.includeInLayout = false;
            this.counterCcyAmt.visible =  false;
            this.counterCcyAmt.includeInLayout = false;
            this.calcType.visible =  false;
            this.calcType.includeInLayout = false;
            this.exchngRate.visible =  false;
            this.exchngRate.includeInLayout = false;
            this.stlCcy.visible =  false;
            this.stlCcy.includeInLayout = false;
            this.calcTypeForStl.visible =  false;
            this.calcTypeForStl.includeInLayout = false;
            this.exchngRateForStl.visible =  false;
            this.exchngRateForStl.includeInLayout = false;
            this.confStatus.visible =  false;
            this.confStatus.includeInLayout = false;
            this.pl.visible =  false;
            this.pl.includeInLayout = false;
        }
        
         private function showPTaxEntryLbls(mapObj:Object):void{
            this.fundAccNoLbl.visible =  true;
            this.fundAccNoLbl.includeInLayout =  true;
            this.tradeTypeLbl.visible =  true;
            this.tradeTypeLbl.includeInLayout = true;
            this.tradeDateLbl.visible =  true;
            this.tradeDateLbl.includeInLayout = true;
            this.tradeTimeLbl.visible =  true;
            this.tradeTimeLbl.includeInLayout = true;
            this.valueDateLbl.visible =  true;
            this.valueDateLbl.includeInLayout = true;
            //this.buySellLbl.visible =  true;
            //this.buySellLbl.includeInLayout = true;
            this.counterPartyAccLbl.visible =  true;
            this.counterPartyAccLbl.includeInLayout = true;
            this.trdCcyLbl.visible =  true;
            this.trdCcyLbl.includeInLayout = true;
            this.trdCcyAmtLbl.visible =  true;
            this.trdCcyAmtLbl.includeInLayout = true;
            this.counterCcyLbl.visible =  true;
            this.counterCcyLbl.includeInLayout = true;
            this.counterCcyAmtLbl.visible =  true;
            this.counterCcyAmtLbl.includeInLayout = true;
            this.calcTypeLbl.visible =  true;
            this.calcTypeLbl.includeInLayout = true;
            this.exchngRateLbl.visible =  true;
            this.exchngRateLbl.includeInLayout = true;
            this.stlCcyLbl.visible =  true;
            this.stlCcyLbl.includeInLayout = true;
            this.calcTypeForStlLbl.visible =  true;
            this.calcTypeForStlLbl.includeInLayout = true;
            this.exchngRateForStlLbl.visible =  true;
            this.exchngRateForStlLbl.includeInLayout = true;
            this.counterCcyL.visible =  true;
            this.counterCcyL.includeInLayout = true;
            
            this.pTaxDate.enabled = true;
            this.pTaxExchngRate.enabled = true;
            this.pTaxCalcType.enabled = true;
            
            this.invAccNoLbl.styleName = '';
            this.trdTypeLbl.styleName = '';
            //this.bSLbl.styleName = '';
            this.cPAccNoLbl.styleName = '';
            this.trdDtLbl.styleName = '';
            this.valDtLbl.styleName = '';
            this.tCcyLbl.styleName = '';
            this.bCcyAmtLbl.styleName = '';
            this.cCcyLbl.styleName = '';
            this.counterCcyL.styleName = '';
            this.exRateLbl.styleName = '';
            this.pTaxRateLbl.styleName = 'ReqdLabel';
            
            
            this.fundAccNoLbl.text = mapObj[keylist.getItemAt(5)].toString();
            this.tradeTypeLbl.text = mapObj[keylist.getItemAt(6)].toString();
            this.tradeDateLbl.text = mapObj[keylist.getItemAt(1)].toString();
            this.tradeTimeLbl.text = mapObj[keylist.getItemAt(7)].toString();
            this.valueDateLbl.text = mapObj[keylist.getItemAt(8)].toString();
            //this.buySellLbl.text = mapObj[keylist.getItemAt(9)].toString();
            this.counterPartyAccLbl.text = mapObj[keylist.getItemAt(10)].toString();
            this.trdCcyLbl.text = mapObj[keylist.getItemAt(11)].toString();
            this.trdCcyAmtLbl.text = mapObj[keylist.getItemAt(12)].toString();
            this.counterCcyLbl.text = mapObj[keylist.getItemAt(13)].toString();
            this.counterCcyAmtLbl.text = mapObj[keylist.getItemAt(14)].toString();
            this.calcTypeLbl.text = mapObj[keylist.getItemAt(28)].toString();
            this.exchngRateLbl.text = mapObj[keylist.getItemAt(16)].toString();
            this.stlCcyLbl.text = mapObj[keylist.getItemAt(17)].toString();
            this.calcTypeForStlLbl.text = mapObj[keylist.getItemAt(27)].toString();
            this.exchngRateForStlLbl.text = mapObj[keylist.getItemAt(19)].toString();
            
        }
        
        private function doSubmit():void{
            var sendHttpReqForPTaxEntry:Boolean = false;
            if(this.mode == 'ptaxentry'){
                if(XenosStringUtils.isBlank(this.pTaxExchngRate.text)){
                    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('frx.error.emptyptax'));
                }else{
                    if(XenosStringUtils.isBlank(this.pTaxDate.text)){
                        sendHttpReqForPTaxEntry = true;
                    }else{
                        var tradeDateDt:Date = null;
                        var dateformat:CustomDateFormatter = new CustomDateFormatter();
                        dateformat.formatString="YYYYMMDD";
                        if(!DateUtils.isValidDate(StringUtil.trim(this.pTaxDate.text))) {
                            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('frx.error.illegalptaxdate') + this.pTaxDate.text);
                            sendHttpReqForPTaxEntry = false;
                        }else{
                            sendHttpReqForPTaxEntry = true;
                        }
                    }
                    if(sendHttpReqForPTaxEntry){
                    	this.submit.enabled = false;
                    	this.btnReset.enabled = false;
                    	{this.mode == 'entry' ?  this.dispatchEvent(new Event('entrySave')) :  this.dispatchEvent(new Event('amendEntrySave'))};
                    }
                    
                }
            }else{
            	this.submit.enabled = false;
                this.btnReset.enabled = false;
                {this.mode == 'entry' ?  this.dispatchEvent(new Event('entrySave')) :  this.dispatchEvent(new Event('amendEntrySave'))};
            }
            
        }
        
        private function doSave():void{
            if(uConfSubmit.enabled == true){
                this.mode == 'entry' ?  this.dispatchEvent(new Event('entryConf')) :  this.dispatchEvent(new Event('amendEntryConf'));
            }
            uConfSubmit.enabled = false;
            back.enabled = false;
        }
        
        private function onChangeFundAccountNo(event:Event):void{
    		OnDataChangeUtil.onChangeFundAccountNo(fundAccName,fundAccPopUp.accountNo.text);
	    }
	    
	    private function onChangeCPAccountNo(event:Event):void{
    		OnDataChangeUtil.onChangeAccountNo(cpAccName,counterPartyAccPopUp.accountNo.text);
	    }
	    
	    override public function postEntry():void {
			this.submit.enabled = true;
            this.btnReset.enabled = true;
		}
		
		override public function postAmend():void {
			this.submit.enabled = true;
            this.btnReset.enabled = true;
		}
        
