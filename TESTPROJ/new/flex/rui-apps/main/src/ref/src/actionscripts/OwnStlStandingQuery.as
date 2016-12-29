// ActionScript file

 // ActionScript file for Own STL Standing Query
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.containers.SummaryPopup;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.renderers.ImgSummaryRenderer;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.utils.HiddenObject;
    import com.nri.rui.core.utils.ProcessResultUtil;
    import com.nri.rui.core.utils.XenosStringUtils;
    import com.nri.rui.ref.popupImpl.FinInstitutePopUpHbox;
    import com.nri.rui.core.controls.CustomizeSortOrder;
    import com.nri.rui.core.controls.XenosQuery;
    import mx.collections.ArrayCollection;
    import mx.controls.dataGridClasses.DataGridColumn;
    import mx.core.UIComponent;
    import mx.events.CloseEvent;
    import mx.managers.PopUpManager;
    import mx.utils.StringUtil;


    [Bindable] private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]   private var cpCodeBroker:FinInstitutePopUpHbox = new FinInstitutePopUpHbox();
   [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
     [Bindable]  private var mode:String = "query";
     [Bindable]
    private var queryResult:ArrayCollection= new ArrayCollection();
     private var  csd:CustomizeSortOrder=null;
      private var sortUtil:ProcessResultUtil= new ProcessResultUtil();
   private var keylist:ArrayCollection = new ArrayCollection(); 
   private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
	private var sPopup : SummaryPopup;



         private function changeCurrentState():void{
                currentState = "result"; 
     }
         public function loadAll():void{
               parseUrlString();
//               XenosAlert.info(mode);
               super.setXenosQueryControl(new XenosQuery());
               if(this.mode == 'query'){
                 this.dispatchEvent(new Event('queryInit'));
                 addColumn();
               }  else if(this.mode == 'add'){
                 this.dispatchEvent(new Event('amendInit'));
                 addColumn();
               } else { 
                 this.dispatchEvent(new Event('cancelInit'));
                addColumn();
               } 
                 
           } 

           private function addColumn():void
        {
            //Add a object
            
            var dg :DataGridColumn = new DataGridColumn();
            dg.dataField="";
            dg.editable = false;
            dg.resizable=false;
            dg.headerText = "";
            dg.width = 40;
            dg.itemRenderer = new RendererFectory(ImgSummaryRenderer);
            
            var cols :Array = resultSummary.columns;
            cols.unshift(dg);
            resultSummary.columns = cols;
            
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
                            }
                        }                       
                    }else{
                        mode = "query";
                    }                 

                } catch (e:Error) {
                    
                    trace(e);
                }               
            } 


 

        private function sortOrder1Update():void{
             csd.update(sortField1.selectedItem,0);
         }
         
         private function sortOrder2Update():void{      
            csd.update(sortField2.selectedItem,1);
         }




      override public function preGenerateXls():String{
             var url : String =null;
                if(mode == "query"){                    
                  url = "ref/ownStandingQueryDispatch.action?method=generateXLS";
                }else if(mode == "add"){
                    url = "ref/ownStandingAmendQueryDispatch.action?method=generateXLS";
                }else{
                    url = "ref/ownStandingCxlQueryDispatch.action?method=generateXLS";
                }
                return url;
         }  
   
        override public function preGeneratePdf():String{
           var url : String =null;
                if(mode == "query"){                    
                  url = "ref/ownStandingQueryDispatch.action?method=generatePDF";
                }else if(mode == "add"){
                    url = "ref/ownStandingAmendQueryDispatch.action?method=generatePDF";
                }else{
                    url = "ref/ownStandingCxlQueryDispatch.action?method=generatePDF";
                }
                return url;
          } 
            
        override public function preNext():Object{
           var reqObj : Object = new Object();
           reqObj.method = "doNext";
           return reqObj;
         }  
        override public function prePrevious():Object{
           
            var reqObj : Object = new Object();
            reqObj.method = "doPrevious";
            return reqObj;
          } 
          
          private function dispatchPrintEvent():void{
              this.dispatchEvent(new Event("print"));
          }  
          private function dispatchPdfEvent():void{
             // XenosAlert.info("dispatchEvent pdf");
              this.dispatchEvent(new Event("pdf"));
          }  
          private function dispatchXlsEvent():void{
              this.dispatchEvent(new Event("xls"));
          }   
          private function dispatchNextEvent():void{
              this.dispatchEvent(new Event("next"));
          }  
          private function dispatchPrevEvent():void{
              this.dispatchEvent(new Event("prev"));
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
                actTypeArray[0]="T|B";
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("actTypeContext",actTypeArray));    
                      
            //passing counter party type                
            var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="INTERNAL";
                //cpTypeArray[1]="CLIENT";
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
        
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
            return myContextList;
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
        
         
          override public function preQueryInit():void{
               var rndNo:Number= Math.random();
               super.getInitHttpService().url = "ref/ownStandingQueryDispatch.action?method=initialExecute&mode=query&rnd=" + rndNo;
               var reqObject:Object = new Object();
	  	       reqObject.SCREEN_KEY = 185;
	  	       super.getInitHttpService().request = reqObject;            
        }
          override public function preAmendInit():void{
               var rndNo:Number= Math.random();
               super.getInitHttpService().url = "ref/ownStandingAmendQueryDispatch.action?method=initialExecute&mode=add&rnd=" + rndNo;
               var reqObject:Object = new Object();
		  	   reqObject.SCREEN_KEY = 794;
		  	   super.getInitHttpService().request = reqObject;           
        }
          override public function preCancelInit():void{
               var rndNo:Number= Math.random();
               super.getInitHttpService().url = "ref/ownStandingCxlQueryDispatch.action?method=initialExecute&mode=cancel&rnd=" + rndNo;
               var reqObject:Object = new Object();
		  	   reqObject.SCREEN_KEY = 795;
		  	   super.getInitHttpService().request = reqObject;            
        }
         
        override public function preQueryResultInit():Object{
            addCommonKeys();            
            return keylist;         
        }
        
        override public function preAmendResultInit():Object{
            addCommonKeys();            
            return keylist;         
        }
        
        override public function preCancelResultInit():Object{
            addCommonKeys();            
            return keylist;         
        }
        
        
        
        private function addCommonKeys():void{  
            keylist = new ArrayCollection();        
            keylist.addItem("settlementForList.item");
            keylist.addItem("cashSecurityList.item");
            keylist.addItem("statusValues.item");
            keylist.addItem("sortFieldList.item");
            keylist.addItem("sortField1");
            keylist.addItem("sortField2");
            keylist.addItem("sortField3");
            keylist.addItem("counterpartyTypeList.item");
                
        }
        
         override public function postQueryResultInit(mapObj:Object):void{
            commonInit(mapObj);
        }
         override public function postAmendResultInit(mapObj:Object):void{
            commonInit(mapObj);
        }
         override public function postCancelResultInit(mapObj:Object):void{
            commonInit(mapObj);
        }
        
        
        private function commonInit(mapObj:Object):void{
            
            errPage.clearError(super.getInitResultEvent());
            app.submitButtonInstance = submit;
            /* if(this.mode == 'add')
            {
                this.ruleEntry.visible = true;
                this.ruleEntry.includeInLayout = true;
            }
            else{
                this.ruleEntry.visible = false;
                this.ruleEntry.includeInLayout = false;
            } */
            var i:int = 0;
            var selIndx:int = 0;
            var dateStr:String = null;
            var tempColl: ArrayCollection = new ArrayCollection();
            var initColl:ArrayCollection = new ArrayCollection();
            var item:Object = new Object();
            //variables to hold the default values from the server
            
            
            var sortField1Default:String = mapObj[keylist.getItemAt(4)].toString();
            var sortField2Default:String = mapObj[keylist.getItemAt(5)].toString();
            var sortField3Default:String = mapObj[keylist.getItemAt(6)].toString(); 
            //initiate text fields
            this.sortField1.selectedIndex=0
			this.sortField2.selectedIndex=0
			this.sortField3.selectedIndex=0
            
            fundPopUp.fundCode.text = "";
            fundPopUp.setFocus();
            
            invActPopUp.accountNo.text = "";
            
            // initiate Settlement for
            tempColl = new ArrayCollection();
            initColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            if(mapObj[keylist.getItemAt(0)] !=null){
                if(mapObj[keylist.getItemAt(0)] is ArrayCollection){
                    initColl = mapObj[keylist.getItemAt(0)] as ArrayCollection;
                    for each(var item1:Object in initColl){
                        tempColl.addItem(item1);
                    }
                }
                else {
                    tempColl.addItem(mapObj[keylist.getItemAt(0)].toString());
                }
            }
            this.settlementForList.dataProvider = tempColl;
            
            //initiate cash-security flag
            tempColl = new ArrayCollection();
            initColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            if(mapObj[keylist.getItemAt(1)] !=null){
                if(mapObj[keylist.getItemAt(1)] is ArrayCollection){
                    initColl = mapObj[keylist.getItemAt(1)] as ArrayCollection;
                    for each(var item1:Object in initColl){
                        tempColl.addItem(item1);
                    }
                }
                else {
                    tempColl.addItem(mapObj[keylist.getItemAt(1)].toString());
                }
            }
            this.cashSecurityList.dataProvider = tempColl;
            
            instrumentType.text = "";
            stlCcyBox.ccyText.text = "";
            securityCode.instrumentId.text = "";
            market.text= "";
            settlemetBank.finInstCode.text = "";
            settlementAcc.accountNo.text = "";
              
              // initiate counter party code
                          
            tempColl = new ArrayCollection();
            initColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            if(mapObj[keylist.getItemAt(7)] !=null){
                if(mapObj[keylist.getItemAt(7)] is ArrayCollection){
                    initColl = mapObj[keylist.getItemAt(7)] as ArrayCollection;
                    for each(var item1:Object in initColl){
                        tempColl.addItem(item1);
                    }
                }
                else {
                    tempColl.addItem(mapObj[keylist.getItemAt(7)].toString());
                }
            }
            this.counterpartyCode.dataProvider = tempColl;
             cpAccount.accountNo.text = "";
             
             onChangeCounterPartyType();
           
             // initiate status
                          
            tempColl = new ArrayCollection();
            initColl = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            if(mapObj[keylist.getItemAt(2)] !=null){
                if(mapObj[keylist.getItemAt(2)] is ArrayCollection){
                    initColl = mapObj[keylist.getItemAt(2)] as ArrayCollection;
                    for each(var item1:Object in initColl){
                        tempColl.addItem(item1);
                    }
                }
                else {
                    tempColl.addItem(mapObj[keylist.getItemAt(2)].toString());
                }
            }
            this.statusValues.dataProvider = tempColl; 
            this.statusValues.selectedIndex = 2;
            
            
            //Initialize sortFieldList1.
            if(null != mapObj[keylist.getItemAt(3)]){
                tempColl = new ArrayCollection();
                tempColl.addItem({label:" ", value: " "});
                selIndx = 0;
                item = new Object();
                if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
                initColl = mapObj[keylist.getItemAt(3)] as ArrayCollection;
                for each(item in initColl){
                    //Get the default value object's index
                    if(XenosStringUtils.equals(item.value,sortField1Default)){                    
                        selIndx = initColl.getItemIndex(item);
                    }
                       tempColl.addItem(item);            
                }
                sortFieldArray[0]=sortField1;
                sortFieldDataSet[0]=tempColl;
                //Set the default value object
                sortFieldSelectedItem[0] = tempColl.getItemAt(0);
                
            } 
            }else {
	                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.ownssirule.msg.error.load.sortfieldlist', new Array("1")));
            }
            
            //Initialize sortFieldList2.
            if(null != mapObj[keylist.getItemAt(3)]){
                tempColl = new ArrayCollection();
                tempColl.addItem({label:" ", value: " "});
                selIndx=0;
                item = new Object();
                if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
                initColl = mapObj[keylist.getItemAt(3)] as ArrayCollection;
                for each(item in initColl){
                    //Get the default value object's index
                    if(XenosStringUtils.equals(item.value,sortField2Default)){                    
                        selIndx = initColl.getItemIndex(item);
                    }
                    tempColl.addItem(item);            
                }
                
                sortFieldArray[1]=sortField2;
                sortFieldDataSet[1]=tempColl;
                //Set the default value object
                sortFieldSelectedItem[1] = tempColl.getItemAt(0);
                
            }
            } else {
                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.ownssirule.msg.error.load.sortfieldlist', new Array("2")));
            }
            
            //Initialize sortFieldList3.
            if(null != mapObj[keylist.getItemAt(3)]){
                tempColl = new ArrayCollection();
                tempColl.addItem({label:" ", value: " "});
                selIndx = 0;
                item = new Object();
                if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
                initColl = mapObj[keylist.getItemAt(3)] as ArrayCollection;
                for each(item in initColl){
                    //Get the default value object's index
                    if(XenosStringUtils.equals(item.value,sortField3Default)){                    
                        selIndx = initColl.getItemIndex(item);
                    }
                    
                    tempColl.addItem(item);            
                }
                
                sortFieldArray[2]=sortField3;
                sortFieldDataSet[2]=tempColl;
                //Set the default value object
                sortFieldSelectedItem[2] = tempColl.getItemAt(0);
               
                csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
                csd.init();
                
            } 
            }else {
                XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.ownssirule.msg.error.load.sortfieldlist', new Array("3")));
            }
            
        } 
        
        
      /*   override public function preAmendInit():void{
           var rndNo:Number= Math.random();
           if(this.mode == "amend") {
            super.getInitHttpService().url = "frx/forexQueryDispatch.action?method=initialExecute&mode=amend&rnd=" + rndNo;
           }else if(this.mode == "ptaxentry"){
            super.getInitHttpService().url = "frx/forexQueryDispatch.action?method=initialExecute&mode=ptaxentry&rnd=" + rndNo;
           }
           
                        
        }
        
        override public function preCancelInit():void{
           var rndNo:Number= Math.random();
           super.getInitHttpService().url = "frx/forexQueryDispatch.action?method=initialExecute&mode=cancel&rnd=" + rndNo;  
                    
        }  
          */
       override public function preQuery():void{
            qh.resetPageNo();   
            super.getSubmitQueryHttpService().url = "ref/ownStandingQueryDispatch.action?";  
            super.getSubmitQueryHttpService().request  =populateRequestParams();
        } 
         override public function preAmend():void{
            qh.resetPageNo();   
            super.getSubmitQueryHttpService().url = "ref/ownStandingAmendQueryDispatch.action?";  
            super.getSubmitQueryHttpService().request  =populateRequestParams();
        } 
         override public function preCancel():void{
            qh.resetPageNo();   
            super.getSubmitQueryHttpService().url = "ref/ownStandingCxlQueryDispatch.action?";  
            super.getSubmitQueryHttpService().request  =populateRequestParams();
        } 
        
          override public function preResetQuery():void{
               var rndNo:Number= Math.random();
	           super.getResetHttpService().url = "ref/ownStandingQueryDispatch.action?method=resetQuery&&mode=query&rnd=" + rndNo;
	           var reqObject:Object = new Object();
	  	       reqObject.SCREEN_KEY = 185;
	  	       super.getInitHttpService().request = reqObject;          
        }
        
        override public function preResetAmend():void{
           var rndNo:Number= Math.random();
           super.getResetHttpService().url = "ref/ownStandingAmendQueryDispatch.action?method=resetQuery&&mode=add&rnd=" + rndNo;
           var reqObject:Object = new Object();
		   reqObject.SCREEN_KEY = 794;
		   super.getInitHttpService().request = reqObject;
        }
        
        override public function preResetCancel():void{
           var rndNo:Number= Math.random();
           super.getResetHttpService().url = "ref/ownStandingCxlQueryDispatch.action?method=resetQuery&&mode=cancel&rnd=" + rndNo;
           var reqObject:Object = new Object();
		   reqObject.SCREEN_KEY = 795;
		   super.getInitHttpService().request = reqObject;  
        }  
        
        
        /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
         reqObj.method = "submitQuery";
         reqObj.fundCode = this.fundPopUp.fundCode.text;
         reqObj.inventoryAccount = this.invActPopUp.accountNo.text;
         reqObj.settlementFor = this.settlementForList.selectedItem != null ? StringUtil.trim(this.settlementForList.selectedItem.value) : "";
        reqObj.cashSecurityFlag = this.cashSecurityList.selectedItem != null ? StringUtil.trim(this.cashSecurityList.selectedItem.value) : "";
        if(this.mode =="add") {
        	reqObj.SCREEN_KEY = 821;
        } else if(this.mode =="query") {
        	reqObj.SCREEN_KEY = 188;
        } else {
        	reqObj.SCREEN_KEY = 822;
        }
        reqObj.instrumentType = this.instrumentType.itemCombo.text;
         reqObj.settlementCcy = this.stlCcyBox.ccyText.text;        
        reqObj.instrumentCode = this.securityCode.instrumentId.text;
        reqObj.marketCode = this.market.itemCombo.text;
        reqObj.settlementBank = settlemetBank.finInstCode.text;
        reqObj.settlementAccount=this.settlementAcc.accountNo.text;
        
        reqObj.counterpartyType = this.counterpartyCode.selectedItem != null ? StringUtil.trim(this.counterpartyCode.selectedItem.value) : "";
    	
    	if(this.counterpartyCode.selectedItem.value == "BROKER") {
    		reqObj.counterpartyCode = this.cpCodeBroker.finInstCode.text;
    	}
        //reqObj.counterpartyCode = this.counterpartyCode.selectedItem != null ? StringUtil.trim(this.counterpartyCode.selectedItem.value) : "";
        reqObj.cpTradingAccountNo = this.cpAccount.accountNo.text;
        reqObj.status = this.statusValues.selectedItem != null ? StringUtil.trim(this.statusValues.selectedItem.value) : "";
        
         
         
         reqObj.sortField1 = this.sortField1.selectedItem != null ? StringUtil.trim(this.sortField1.selectedItem.value) : XenosStringUtils.EMPTY_STR;
         reqObj.sortField2 = this.sortField2.selectedItem != null ? StringUtil.trim(this.sortField2.selectedItem.value) : XenosStringUtils.EMPTY_STR;
         reqObj.sortField3 = this.sortField3.selectedItem != null ? StringUtil.trim(this.sortField3.selectedItem.value) : XenosStringUtils.EMPTY_STR;
         
         reqObj.rnd = Math.random() + "";
        
        return reqObj;
    }
    
    
         override public function postQueryResultHandler(mapObj:Object):void{
        commonResult(mapObj);
    }
     override public function postAmendResultHandler(mapObj:Object):void{
        commonResult(mapObj);
    } 
     override public function postCancelResultHandler(mapObj:Object):void{
        commonResult(mapObj);
    }  
    
     private function commonResult(mapObj:Object):void{     
        var result:String = "";
        if(mapObj!=null){   
            if(mapObj["errorFlag"].toString() == "error"){
                if(queryResult.length > 0){
                    queryResult.removeAll();
                }
                errPage.showError(mapObj["errorMsg"]);
            }else if(mapObj["errorFlag"].toString() == "noError"){
               errPage.clearError(super.getSubmitQueryResultEvent());
               if(queryResult.length > 0){
                    queryResult.removeAll();
               }
               queryResult=mapObj["row"];
               changeCurrentState();
               qh.setOnResultVisibility();
               qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
               qh.PopulateDefaultVisibleColumns();
              /*  if(queryResult.length == 1 && this.mode == 'query'){
                displayDetailView(queryResult[0].ownSettleStandingRulePk);
               } */
                
            }else{
            	if(this.mode == "add"){
            		changeCurrentState();
            	}
            	queryResult.removeAll();
	    		queryResult.refresh();
                errPage.removeError();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.datanotfound'));
            }           
        }
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
    if(counterpartyCode.selectedItem.label == "BROKER"){
            if(!counterpartyCodeBox.contains(cpCodeBroker)){
                counterpartyCodeBox.addChild(cpCodeBroker);
            }
          
    }
    else{
            if(counterpartyCodeBox.contains(cpCodeBroker)){
            	this.cpCodeBroker.finInstCode.text="";
                counterpartyCodeBox.removeChild(cpCodeBroker);
            }
                
    }
        
	} 

	/**
     *Open Add PopUp
    */
	 public function openAddEntryPopUp():void{
	 
	 	var parentApp :UIComponent = UIComponent(this.parentApplication);
		sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
	 	sPopup.addEventListener(CloseEvent.CLOSE,closeHandler,false,0,true);
	 	sPopup.title = "Own Settlement Standing  Entry";	
     	sPopup.width = parentApp.width - 100;
		sPopup.height = parentApp.height - 60;
    	PopUpManager.centerPopUp(sPopup);	
       	sPopup.moduleUrl = "assets/appl/ref/OwnStlStandingEntry.swf"+Globals.QS_SIGN+"mode"+Globals.EQUALS_SIGN+"entry";
				
	 }  
	 /**
	 * Event Handler for the custom event "OkSystemConfirm"
	 */
	public function closeHandler(event:Event):void {
          dispatchEvent(new Event("querySubmit"));
          sPopup.removeMe();
    }





    
    
    
    
    
    