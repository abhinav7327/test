// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.containers.TitleWindow;
import mx.events.CloseEvent;
import mx.events.ResourceEvent;
import mx.resources.ResourceBundle;

			
	  
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     
            [Bindable]private var mode : String = "entry";
            [Bindable]private var ledgerPk : String = "";
            private var keylist:ArrayCollection = new ArrayCollection();           
	  		
	  		private var productValue:String;
	  		private var affiliateValue:String;
	  		private var rrnumberValue:String;  		
	  		[Bindable]private var ledgerOb_ledgerCode:String="";
	  		[Bindable]private var ledgerOb_ledgerType:String="";
	  		[Bindable]private var ledgerOb_shortName:String="";
	  		[Bindable]private var ledgerOb_subcodeType:String="";
	  		[Bindable]private var ledgerOb_longName:String="";
	  		[Bindable]private var ledgerOb_status:String="";
	  		
	  		[Bindable]private var strategyLedgerSubcode_subcodeReqd:String="";
	  		[Bindable]private var strategyLedgerSubcode_subcodeType:String="";
	  		[Bindable]private var strategyLedgerSubcode_defaultSubcode:String="";
	  		
	  		[Bindable]private var accountLedgerSubcode_subcodeReqd:String="";
	  		[Bindable]private var accountLedgerSubcode_subcodeType:String="";
	  		[Bindable]private var accountLedgerSubcode_defaultSubcode:String="";
	  		
	  		[Bindable]private var productLedgerSubcodeReq:String="";
	  		[Bindable]private var productLedgerSubcode_defaultSubcode:String="";
	  		[Bindable]private var affiliateLedgerSubcodeReq:String="";
	  		[Bindable]private var affiliateLedgerSubcode_defaultSubcode:String="";
	  		[Bindable]private var rrNumLedgerSubcodeReq:String="";
	  		[Bindable]private var rrnumberLedgerSubcode_defaultSubcode:String="";
	  		[Bindable]private var uConfText:String="";
	  		[Bindable]private var sConfText:String="";
	  		
		    [Bindable]
		    private var backState:Boolean = false;
		    [Bindable]
		    private var uConfSubmitState:Boolean;
		    [Bindable]
		    private var cancelSubmitState:Boolean = false;
		    [Bindable]
		    private var uCancelConfSubmitState:Boolean = false;
		    [Bindable]
		    private var sConfSubmitState:Boolean = false;
	  		
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
	                           // Alert.show("Mode :: " + mode);
	                        }else if(tempA[0] == "ledgerPk"){
	                            this.ledgerPk = tempA[1];
	                        } 
	                    }                    	
                    }else{
                    	mode = "entry";
                    }                 

                } catch (e:Error) {
                    trace(e);
                }               
            }
            
            override public function preEntryInit():void{  
            	app.submitButtonInstance=submit;          	
		        var rndNo:Number= Math.random(); 
		        var reqObj:Object=new Object();
		        reqObj.method="initialExecute";
		        reqObj.mode="entry";
		        reqObj.rnd=rndNo;
		        reqObj['SCREEN_KEY']="289";
            	super.getInitHttpService().url = "gle/gleLedgerEntryDispatchAction.action?";
            	super.getInitHttpService().request=reqObj;
            }
             override public function preAmendInit():void{     
            	       	
		        var rndNo:Number= Math.random(); 
            	super.getInitHttpService().url = "gle/gleLedgerAmendDispatchAction.action?";
            	var reqObject:Object = new Object();
            	reqObject.rnd = rndNo;
            	reqObject.method= "viewLedgerDetails";
		  		reqObject.mode=this.mode;
		  		reqObject.ledgerPkStr = this.ledgerPk;
		  		reqObject['SCREEN_KEY']="290";
		  		super.getInitHttpService().request = reqObject;
            }
             override public function preCancelInit():void{            	
            	backState = false; 
            	changeCurrentState();	
            	uConfText="";		             	
		        var rndNo:Number= Math.random(); 
            	super.getInitHttpService().url = "gle/gleLedgerCxlQueryDispatchAction.action?";
            	var reqObject:Object = new Object();
            	reqObject.rnd = rndNo;
            	reqObject.method= "viewLedgerDetails";
            	reqObject['SCREEN_KEY']="891";            	
		  		reqObject.mode=this.mode;
		  		reqObject.ledgerPkStr = this.ledgerPk;
		  		super.getInitHttpService().request = reqObject;
            }  
            
       
        
        private function addCommonKeys():void{        	
	    	keylist = new ArrayCollection();
	    	keylist.addItem("ledgerTypeValuesList.item");
	    	keylist.addItem("subCodeTypeValuesList.item");
	    	keylist.addItem("strategyValuesList.item");
	    	keylist.addItem("accountValues.item");
	    	keylist.addItem("requiredStrategyValues.item");
	    	keylist.addItem("requiredValues.item");
	    	keylist.addItem("productValue");
	    	keylist.addItem("affiliateValue");
	    	keylist.addItem("rrnumberValue");
        }
        
        override public function preEntryResultInit():Object{
        	addCommonKeys(); 
        	return keylist;
        }
        
         override public function preAmendResultInit():Object{
        	addCommonKeys(); 
        	keylist.addItem("ledgerOb.ledgerCode");
	    	keylist.addItem("ledgerOb.longName");
	    	keylist.addItem("ledgerOb.shortName");
	    	keylist.addItem("ledgerOb.subcodeType");	    	
	    	keylist.addItem("ledgerOb.ledgerType");	  
	    	keylist.addItem("selectorList.selector");
	    	
	    	keylist.addItem("strategyLedgerSubcode.subcodeReqd");
	    	keylist.addItem("strategyLedgerSubcode.subcodeType");
	    	keylist.addItem("strategyLedgerSubcode.defaultSubcode");
	    	keylist.addItem("strategyLedgerSubcode.ledgerSubcodeTypePk");
	    	
	    	keylist.addItem("accountLedgerSubcode.subcodeReqd");
	    	keylist.addItem("accountLedgerSubcode.subcodeType");
	    	keylist.addItem("accountLedgerSubcode.ledgerSubcodeTypePk");
	    	keylist.addItem("accountLedgerSubcode.defaultSubcode");
	    	
	    	keylist.addItem("productLedgerSubcode.subcodeReqd");
	    	keylist.addItem("productLedgerSubcode.defaultSubcode");
	    	keylist.addItem("productLedgerSubcode.ledgerSubcodeTypePk");
	    	keylist.addItem("affiliateLedgerSubcode.subcodeReqd");
	    	keylist.addItem("affiliateLedgerSubcode.defaultSubcode");
	    	keylist.addItem("affiliateLedgerSubcode.ledgerSubcodeTypePk");
	    	keylist.addItem("rrnumberLedgerSubcode.subcodeReqd");
	    	keylist.addItem("rrnumberLedgerSubcode.defaultSubcode");
	    	keylist.addItem("rrnumberLedgerSubcode.ledgerSubcodeTypePk");  	
	    	
        	return keylist;
        }
        override public function preCancelResultInit():Object{
        	addCommonResultKeys(); 
        	keylist.addItem("Errors.error");        	
        	return keylist;
        } 
        
        private function commonInit(mapObj:Object):void{
	    	errPage.clearError(super.getInitResultEvent());
	    	ledgerCode.text="";
	    	shortName.text="";
	    	longName.text="";
	    	strategyDefaultValue.text="";
	    	ledgerType.dataProvider=mapObj['ledgerTypeValuesList.item'];
	    	
	    	var tempList:ArrayCollection=new ArrayCollection();
	    	tempList.addItem({label: "" , value: ""});
	    	for each(var obj:Object in (mapObj['subCodeTypeValuesList.item'] as ArrayCollection)){
	    		tempList.addItem(obj);
	    	}
	    	subcodetype.dataProvider=tempList;
	    	
	    	strategyReqd.dataProvider=mapObj['requiredStrategyValues.item'];
	    	accountReqd.dataProvider=mapObj['requiredValues.item'];
	    	productReqd.dataProvider=mapObj['requiredValues.item'];
	    	affiliateReqd.dataProvider=mapObj['requiredValues.item'];
	    	rrnumberReqd.dataProvider=mapObj['requiredValues.item'];
	    	
	    	strategySubCodeType.dataProvider=mapObj['strategyValuesList.item'];
	    	accountSubCodeType.dataProvider=mapObj['accountValues.item'];
	    	
	    	productValue=mapObj['productValue'];
	    	affiliateValue=mapObj['affiliateValue'];
	    	rrnumberValue=mapObj['rrnumberValue'];
	    	//disable all sub-code fields    	
	    	strategyAdd.selected=false;
	    	accountAdd.selected=false;
	    	productAdd.selected=false;
	    	rrnumberAdd.selected=false;
	    	affiliateAdd.selected=false;
	    	
	   }
        
        override public function postEntryResultInit(mapObj:Object): void{
        	commonInit(mapObj);        	
        }
        
         override public function postAmendResultInit(mapObj:Object): void{
        	commonInit(mapObj);
        	//do Amend specific init
        	ledgerCode.text=mapObj['ledgerOb.ledgerCode'].toString();
        	ledgerCode.enabled=false;
        	longName.text=mapObj["ledgerOb.longName"].toString();;
        	shortName.text=mapObj["ledgerOb.shortName"].toString();
        	
        	//select subcodetype in combo
        	for each(var obj:Object in (subcodetype.dataProvider as ArrayCollection)){
        		if(obj.value==mapObj["ledgerOb.subcodeType"].toString()){
        			subcodetype.selectedItem=obj;
        			break;
        		}	
        	}
	    	
	    	//select ledgerType in combo
	    	for each(var obj1:Object in (ledgerType.dataProvider as ArrayCollection)){
        		if(obj1.value==mapObj["ledgerOb.ledgerType"].toString()){
        			ledgerType.selectedItem=obj1;
        			break;
        		}	
        	}
        	//enable selected subcodes
        	setSelectedSubCodes(mapObj["selectorList.selector"] as ArrayCollection);
        	  
        	
        	if(mapObj['strategyLedgerSubcode.ledgerSubcodeTypePk'].toString()!="-1"){
        		//select strategy Required value in combo
		    	for each(var obj:Object in (strategyReqd.dataProvider as ArrayCollection)){
	        		if(obj.value==mapObj["strategyLedgerSubcode.subcodeReqd"].toString()){
	        			strategyReqd.selectedItem=obj;
	        			break;
	        		}	
	        	}
	        	//select strategy subcode type value in combo
	        	for each(var obj:Object in (strategySubCodeType.dataProvider as ArrayCollection)){
	        		if(obj.value==mapObj["strategyLedgerSubcode.ledgerSubcodeTypePk"].toString()){
	        			strategySubCodeType.selectedItem=obj;
	        			break;
	        		}	
	        	}
	        	//set strategy default value
	        	strategyDefaultValue.text=mapObj["strategyLedgerSubcode.defaultSubcode"].toString();
        	}
        	
        	if(mapObj['accountLedgerSubcode.ledgerSubcodeTypePk'].toString()!="-1"){
        		//select account Required value in combo
		    	for each(var obj:Object in (accountReqd.dataProvider as ArrayCollection)){
	        		if(obj.value==mapObj["accountLedgerSubcode.subcodeReqd"].toString()){
	        			accountReqd.selectedItem=obj;
	        			break;
	        		}	
	        	}
	        	//select account subcode type value in combo
	        	for each(var obj:Object in (accountSubCodeType.dataProvider as ArrayCollection)){
	        		if(obj.value==mapObj["accountLedgerSubcode.ledgerSubcodeTypePk"].toString()){
	        			accountSubCodeType.selectedItem=obj;
	        			break;
	        		}	
	        	}	        	
        	}
        	
        	if(mapObj['productLedgerSubcode.ledgerSubcodeTypePk'].toString()!="-1"){
        		//select product Required value in combo
		    	for each(var obj:Object in (productReqd.dataProvider as ArrayCollection)){
	        		if(obj.value==mapObj["productLedgerSubcode.subcodeReqd"].toString()){
	        			productReqd.selectedItem=obj;
	        			break;
	        		}	
	        	}	        	        	
        	}
        	
        	if(mapObj['affiliateLedgerSubcode.ledgerSubcodeTypePk'].toString()!="-1"){
        		//select affiliate Required value in combo
		    	for each(var obj:Object in (affiliateReqd.dataProvider as ArrayCollection)){
	        		if(obj.value==mapObj["affiliateLedgerSubcode.subcodeReqd"].toString()){
	        			affiliateReqd.selectedItem=obj;
	        			break;
	        		}	
	        	}	        	        	
        	}
        	
        	if(mapObj['rrnumberLedgerSubcode.ledgerSubcodeTypePk'].toString()!="-1"){
        		//select RR num Required value in combo
		    	for each(var obj:Object in (rrnumberReqd.dataProvider as ArrayCollection)){
	        		if(obj.value==mapObj["rrnumberLedgerSubcode.subcodeReqd"].toString()){
	        			rrnumberReqd.selectedItem=obj;
	        			break;
	        		}	
	        	}	        	        	
        	}
	    	
        }
        private function commonResultPart(mapObj:Object):void{
        	ledgerOb_ledgerCode=mapObj['ledgerOb.ledgerCode'].toString();
	    	ledgerOb_longName=mapObj["ledgerOb.longName"].toString();
	    	ledgerOb_shortName=mapObj["ledgerOb.shortName"].toString();
	    	ledgerOb_subcodeType=mapObj["ledgerOb.subcodeType"].toString();
	    	ledgerOb_status=mapObj["ledgerOb.status"].toString();
	    	ledgerOb_ledgerType=mapObj["ledgerOb.ledgerType"].toString();   
	    	    		 
			strategyLedgerSubcode_subcodeReqd=mapObj["strategyLedgerSubcode.subcodeReqd"].toString();			
			if(mapObj["strategyLedgerSubcode.ledgerSubcodeTypePk"].toString()!="-1"){
	    		strategyLedgerSubcode_subcodeType=mapObj["strategyLedgerSubcode.subcodeType"].toString();
	  		}
	  		else{
	  			strategyLedgerSubcode_subcodeType="";
	  		}
	    	strategyLedgerSubcode_defaultSubcode=mapObj["strategyLedgerSubcode.defaultSubcode"].toString();
	    	
	    	if(mapObj["accountLedgerSubcode.ledgerSubcodeTypePk"].toString()!="-1"){
	    		accountLedgerSubcode_subcodeType=mapObj["accountLedgerSubcode.subcodeType"].toString();
	  		}
	  		else{
	  			accountLedgerSubcode_subcodeType="";
	  		}	    	
	    	accountLedgerSubcode_subcodeReqd=mapObj["accountLedgerSubcode.subcodeReqd"].toString();
			accountLedgerSubcode_defaultSubcode=mapObj["accountLedgerSubcode.defaultSubcode"].toString();
			
			productLedgerSubcodeReq=mapObj['productLedgerSubcode.subcodeReqd'].toString();
			productLedgerSubcode_defaultSubcode=mapObj["productLedgerSubcode.defaultSubcode"].toString();
			affiliateLedgerSubcodeReq=mapObj['affiliateLedgerSubcode.subcodeReqd'].toString();
			affiliateLedgerSubcode_defaultSubcode=mapObj["affiliateLedgerSubcode.defaultSubcode"].toString();	
			rrNumLedgerSubcodeReq=mapObj['rrnumberLedgerSubcode.subcodeReqd'].toString();
			rrnumberLedgerSubcode_defaultSubcode=mapObj["rrnumberLedgerSubcode.defaultSubcode"].toString();
					    		    	    		 
    		backState = true;
    		uConfSubmitState = true;
    		
    		if(mode=="entry"){
    			uConfText=this.parentApplication.xResourceManager.getKeyValue('gle.ledger.entry.user.conf');
	  			sConfText=this.parentApplication.xResourceManager.getKeyValue('gle.ledger.entry.system.conf');
    		}else if(mode=="amend"){
    			uConfText=this.parentApplication.xResourceManager.getKeyValue('gle.ledger.amend.user.conf');
	  			sConfText=this.parentApplication.xResourceManager.getKeyValue('gle.ledger.amend.system.conf');
    		}else{
    			uConfText="";
	  			sConfText=this.parentApplication.xResourceManager.getKeyValue('gle.ledger.cancel.system.conf');
    		}
    		
        }
        override public function postCancelResultInit(mapObj:Object): void{
        	
        	if(mapObj["Errors.error"]==null || (mapObj["Errors.error"] as ArrayCollection).length==0){
	            commonResultPart(mapObj);
	        	backState=false;
	        	uConfSubmitState = false;
	        	cancelSubmitState = true;
        	}
        	else{
        		errPage1.showError(mapObj["Errors.error"] as ArrayCollection);
        	}
        }
        private function addCommonResultKeys():void{
        	keylist = new ArrayCollection();
	    	keylist.addItem("ledgerOb.ledgerCode");
	    	keylist.addItem("ledgerOb.longName");
	    	keylist.addItem("ledgerOb.shortName");
	    	keylist.addItem("ledgerOb.subcodeType");
	    	keylist.addItem("ledgerOb.status");
	    	keylist.addItem("ledgerOb.ledgerType");	  
	    	
	    	keylist.addItem("strategyLedgerSubcode.subcodeReqd");
	    	keylist.addItem("strategyLedgerSubcode.subcodeType");
	    	keylist.addItem("strategyLedgerSubcode.defaultSubcode");
	    	keylist.addItem("strategyLedgerSubcode.ledgerSubcodeTypePk");
	    	
	    	keylist.addItem("accountLedgerSubcode.subcodeReqd");
	    	keylist.addItem("accountLedgerSubcode.subcodeType");
	    	keylist.addItem("accountLedgerSubcode.ledgerSubcodeTypePk");
	    	keylist.addItem("accountLedgerSubcode.defaultSubcode");
	    	
	    	keylist.addItem("productLedgerSubcode.subcodeReqd");
	    	keylist.addItem("productLedgerSubcode.defaultSubcode");
	    	keylist.addItem("affiliateLedgerSubcode.subcodeReqd");
	    	keylist.addItem("affiliateLedgerSubcode.defaultSubcode");
	    	keylist.addItem("rrnumberLedgerSubcode.subcodeReqd");
	    	keylist.addItem("rrnumberLedgerSubcode.defaultSubcode");	  	
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
		    		
		    	}else{
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    	}    		
	    	}
        } 
        
       
        
    	 private function setValidator():void{
		
		   /* var validateModel:Object={
                            exchangeRateEntry:{
                                 
                                 baseDate:this.baseDate.text,
                                 exchangeRateType:this.exchangeratetype.selectedItem != null ? this.exchangeratetype.selectedItem : "",
                                 calculationType:this.calculationtype.selectedItem != null ? this.calculationtype.selectedItem.value : "",
                                 againstCcy:this.againstccy.ccyText.text,
                                 rate: this.rate.text
                                        
                            }
                           }; 
	         super._validator = new ExchangeRateEntryValidator();
	         super._validator.source = validateModel ;
	         super._validator.property = "exchangeRateEntry";  */
		} 
		  override public function preEntry():void{
		 	//setValidator();		 	
		 	super.getSaveHttpService().url = "gle/gleLedgerEntryDispatchAction.action?";  
            super.getSaveHttpService().request  =populateRequestParams();
            super.getSaveHttpService().method="POST";
		 } 
		 
		  override public function preAmend():void{
		 	//setValidator();
		 	super.getSaveHttpService().url = "gle/gleLedgerAmendDispatchAction.action?";  
            super.getSaveHttpService().request  =populateRequestParams();
            super.getSaveHttpService().method="POST";
		 } 
		 override public function preCancel():void{
		 	//setValidator();		 	
		 	super._validator = null;
		 	super.getSaveHttpService().url = "gle/gleLedgerCxlQueryDispatchAction.action?"; 
		 	var reqObj:Object = new Object();
		 	reqObj.rnd=Math.random();
		 	reqObj.method="doConfirmCancel";
		 	reqObj['SCREEN_KEY']="868";
		 	reqObj.ledgerPkStr = this.ledgerPk;
            super.getSaveHttpService().request  =reqObj;
            super.getSaveHttpService().method="POST";
		 } 
		 
		 
		 override public function preEntryResultHandler():Object
		{
			 addCommonResultKeys();
			 return keylist;
		}
		
		override public function preAmendResultHandler():Object
		{
			addCommonResultKeys();
			return keylist;
		} 
		
		override public function postCancelResultHandler(mapObj:Object):void
		{
			//XenosAlert.info("postCancelResultHandler");
			if(submitUserConfResult(mapObj)){
				uConfText=this.parentApplication.xResourceManager.getKeyValue('gle.ledger.cancel.user.conf');
				uConfLabel.includeInLayout = true;
				uConfLabel.visible = true;
	        	cancelSubmitState = false;
	        	uCancelConfSubmitState = true;
	        	sConfSubmitState = false;
	        	sConfLabel.includeInLayout = false;
	        	sConfLabel.visible = false;
   			}
		} 
		
		override public function postEntryResultHandler(mapObj:Object):void
		{
			commonResult(mapObj);
		}
		
		override public function postAmendResultHandler(mapObj:Object):void
		{
			commonResult(mapObj);
		}
		 
		 
		
		override public function preEntryConfirm():void
		{
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "gle/gleLedgerEntryDispatchAction.action?";  
			reqObj.method= "confirmEntry";
			reqObj['SCREEN_KEY']="865";
			reqObj.rnd=Math.random()+"";
            super.getConfHttpService().request  =reqObj;
		}
		
		override public function preAmendConfirm():void
		{
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "gle/gleLedgerAmendDispatchAction.action?";  
			reqObj.method= "confirmAmend";
			reqObj['SCREEN_KEY']="867";
			reqObj.rnd=Math.random()+"";
            super.getConfHttpService().request  =reqObj;
		}
		
		override public function preCancelConfirm():void
		{	
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "gle/gleLedgerCxlQueryDispatchAction.action?";  
			reqObj.method= "doCancel";
			reqObj.ledgerPkStr = this.ledgerPk;
			reqObj['SCREEN_KEY']="869";
			reqObj.rnd=Math.random()+"";
            super.getConfHttpService().request  =reqObj;
		}
		
		override public function postConfirmEntryResultHandler(mapObj:Object):void
		{
			uConfSubmit.enabled=true;
			submitUserConfResult(mapObj);
		}
		
		override public function postConfirmAmendResultHandler(mapObj:Object):void
		{
			uConfSubmit.enabled=true;
			if(submitUserConfResult(mapObj)){				
	               	var titleWinInstance:TitleWindow = TitleWindow(this.parent.parent);
	               	titleWinInstance.showCloseButton = false;
	               	titleWinInstance.invalidateDisplayList();            	  
			}
		}
		override public function postConfirmCancelResultHandler(mapObj:Object):void
		{
			uCancelConfSubmit.enabled=true;
			if(submitUserConfResult(mapObj)){	
				var titleWinInstance:TitleWindow = TitleWindow(this.parent.parent);
	            titleWinInstance.showCloseButton = false;
	            titleWinInstance.invalidateDisplayList();     			
	        	cancelSubmitState = false;
	        	uCancelConfSubmitState = false;
	        	uConfLabel.includeInLayout = false;
				uConfLabel.visible = false;
			}
		} 
		
		 private function submitUserConfResult(mapObj:Object):Boolean{
    	//var mapObj:Object = mkt.userConfResultEvent(event);
    	if(mapObj!=null){    
    		//XenosAlert.info("object status : "+mapObj["errorFlag"].toString());		
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		errPage1.showError(mapObj["errorMsg"]);
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    		if(mode!="CANCEL")
	    		errPage.clearError(super.getConfResultEvent());
	    		
	    		errPage1.removeError();
	    		backState = false;
			   uConfSubmit.enabled = true;	
               uConfLabel.includeInLayout = false;
               uConfLabel.visible = false;
               uConfSubmitState = false;
               sConfLabel.includeInLayout = true;
               sConfLabel.visible = true;
               sConfSubmitState = true;    
                 
	    	   return true;
	    	}else{
	    		errPage.removeError();
	    		XenosAlert.info("Error Occurred");
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
    	var random:Number=Math.random();
    	reqObj.rnd=random;
    	if(mode=="entry"){
    		reqObj['method']="doEntry";
    		reqObj['SCREEN_KEY']="864";
    	}else{
    		reqObj['method']="doAmend";
    		reqObj['SCREEN_KEY']="866";
    	}    	
		reqObj['ledgerOb.ledgerCode']=ledgerCode.text;
		reqObj['ledgerOb.ledgerType']=ledgerType.selectedItem.value;
		reqObj['ledgerOb.shortName']=shortName.text;
		reqObj['ledgerOb.subcodeType']=subcodetype.selectedItem.value;
		reqObj['ledgerOb.longName']=longName.text;
		
		return populateSubCode(reqObj);
		
    }
    
    /**
     *This method populates the ledger sub code detail parameters 
     * @param obj
     * @return 
     * 
     */   
    private function populateSubCode(obj:Object):Object{
  	var reqObj:Object=obj;
  	var selectedArray:Array=new Array();
  	
	selectedArray.push("-1");
	if(strategyAdd.selected){
		selectedArray.push("0");
		reqObj['strategyLedgerSubcode.subcodeReqd']=strategyReqd.selectedItem.value;
		reqObj['strategyLedgerSubcode.defaultSubcode']=strategyDefaultValue.text;
		reqObj['strategyLedgerSubcode.ledgerSubcodeTypePk']=strategySubCodeType.selectedItem.value;
	}
    if(accountAdd.selected){
    	selectedArray.push("1");
    	reqObj['accountLedgerSubcode.subcodeReqd']=accountReqd.selectedItem.value;		
		reqObj['accountLedgerSubcode.ledgerSubcodeTypePk']=accountSubCodeType.selectedItem.value;
    }
    if(productAdd.selected){
    	selectedArray.push("2");
    	reqObj['productLedgerSubcode.subcodeReqd']=productReqd.selectedItem.value;		
		reqObj['productLedgerSubcode.ledgerSubcodeTypePk']=productValue;
    }	   
    if(affiliateAdd.selected){
    	selectedArray.push("3");
    	reqObj['affiliateLedgerSubcode.subcodeReqd']=affiliateReqd.selectedItem.value;		
		reqObj['affiliateLedgerSubcode.ledgerSubcodeTypePk']=affiliateValue;
    }
    if(rrnumberAdd.selected){
   		selectedArray.push("4");
		reqObj['rrnumberLedgerSubcode.subcodeReqd']=rrnumberReqd.selectedItem.value;		
		reqObj['rrnumberLedgerSubcode.ledgerSubcodeTypePk']=rrnumberValue;
   	}
   	
   	reqObj['selector']=selectedArray;
   	return reqObj;
  }
  
   override public function preResetEntry():void
   {
   	    var rndNo:Number= Math.random();
		super.getResetHttpService().url = "gle/gleLedgerEntryDispatchAction.action?method=initialExecute&mode=entry&rnd=" + rndNo;
   }
   override public function preResetAmend():void
   {
		    var rndNo:Number= Math.random(); 
        	super.getResetHttpService().url = "gle/gleLedgerAmendDispatchAction.action?";
        	var reqObject:Object = new Object();
        	reqObject.rnd = rndNo;
        	reqObject.method= "viewLedgerDetails";
	  		reqObject.mode=this.mode;
	  		reqObject.ledgerPkStr = this.ledgerPk;
	  		super.getResetHttpService().request = reqObject;
   }
   
   
	 override public function doEntrySystemConfirm(e:Event):void
	{
		     super.preEntrySystemConfirm();
	    	 this.dispatchEvent(new Event('entryReset'));
    		 backState = true;
             uConfLabel.includeInLayout = true;
             uConfLabel.visible = true;
             uConfSubmitState = true;
             sConfLabel.includeInLayout = false;
             sConfLabel.visible = false;
             sConfSubmitState = false;            
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
  
  private function doBack():void{
		vstack.selectedChild = qry;	
  }  		
	private function doSubmit():void
  	{  	
  		if(validateEntry()){
	  	  	if(this.mode == 'entry'){
			  	this.dispatchEvent(new Event('entrySave'));		  	
			}
			else{
			  	this.dispatchEvent(new Event('amendEntrySave'));
			}
  		}
  }
  
  private function validateEntry():Boolean{
  	var errorMsg:String="";
  	if(XenosStringUtils.isBlank(ledgerCode.text)){
  		errorMsg+="- Ledger Code\n";
  	}
  	if(XenosStringUtils.isBlank(shortName.text)){
  		errorMsg+="- Short Name\n";
  	}
  	if(XenosStringUtils.isBlank(errorMsg)){
  		return true;
  	}
  	else{
  		XenosAlert.error(errorMsg+"need to be filled.");
  		return false;
  	}
 }
 
 private function setSelectedSubCodes(selectorList:ArrayCollection):void{
 	for each(var index:String in selectorList){
 		if(index=="0") 		
 			strategyAdd.selected=true;
 		else if(index=="1")
 			accountAdd.selected=true;
 		else if(index=="2")
 			productAdd.selected=true;
 		else if(index=="3")
 			affiliateAdd.selected=true;
 		else if(index=="4")
 			rrnumberAdd.selected=true; 		
 	}
 }
 
 private function douConfSubmit():void{
 	uConfSubmit.enabled=false; 	
 	if(this.mode == 'entry'){
 		this.dispatchEvent(new Event('entryConf'))
 	}
 	else{
 		 this.dispatchEvent(new Event('amendEntryConf'));
 	}
 }
 
		