// ActionScript file
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.XenosStringUtils;

import mx.collections.ArrayCollection;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;



  		[Bindable]
 		 private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
        [Bindable]
        private var mode : String = "ADD";
        public var keylist:ArrayCollection = new ArrayCollection();
	    [Bindable]
	    public var counterPartyCode:ArrayCollection=null;
	    [Bindable]	
	    public var stlForList:ArrayCollection=null;
	    [Bindable]
	    public var stlTransactionTypeList:ArrayCollection=null;
	    [Bindable]
	    public var stlTypeList:ArrayCollection=null;
	    [Bindable]
	    public var deliveryMethodList:ArrayCollection=null;
	    [Bindable]
	    public var priorityList:ArrayCollection=null;
	    [Bindable]
	    public var selectedIndxForStlFrLst:int=0;
	    [Bindable]
		public var selectedIndxForStlTrnscList:int=0;
		[Bindable]
		public var selectedIndxForStlType:int=0;
		[Bindable]
		public var selectedIndxForForm:int=0;
		[Bindable]
		public var selectedIndxForCntrPrty:int=0;	
	    public var cashDiff : String = "";
	    public var settlementMode : String = "";
	    public var secCash : String = "";
	    [Bindable]
	    public var xmlObj:XML;
	    private var isCash:Boolean=false;
	    
	    private var errList :ArrayCollection =null;
            
		
        /**
         * Depending on Counter Party Type combo box value system swithch to either fininst search or customer search
         * 
         */   
            
         public function onChangeCounterPartyType():void{
           var cntrPrtyType:String = cntrPatyType.selectedItem.value;
           
           switch (cntrPrtyType){
           	case "" :{
      	 	 	finInstBox.includeInLayout=false;
           	 	finInstBox.visible=false;
                finInstPopUp.finInstCode.text="";
           		cstmrBoxh.includeInLayout=false;
           	 	cstmrBoxh.visible=false;
           	 	customercodeSrchPopUp.customerCode.text="";
           	 	//counterPartyContext.removeAll();
           	 	this.cntrPrtyacct.cpCodePreset = "";
           	 	this.cntrPrtyacct.cpTypePreset = "";
           	 	//counterPartyCodeOutHandler();
           	 	
           	 	break;
           	 }
           	 case "BROKER" : {
           	 	finInstBox.includeInLayout=true;
           	 	finInstBox.visible=true;
           	 	finInstPopUp.finInstCode.text="";
           		cstmrBoxh.includeInLayout=false;
           	 	cstmrBoxh.visible=false;
           	 	customercodeSrchPopUp.customerCode.text="";
           	 	this.cntrPrtyacct.cpCodePreset = "";
           	 	this.cntrPrtyacct.cpTypePreset = "";
           	 	//counterPartyCodeOutHandler();
           	 	break;
           	 }
          	 case "CLIENT" : {
           	    finInstBox.includeInLayout=false;
           	 	finInstBox.visible=false;
           		finInstPopUp.finInstCode.text="";          		
           		cstmrBoxh.includeInLayout=true;
           	 	cstmrBoxh.visible=true;
           	 	customercodeSrchPopUp.customerCode.text="";
           	 	this.cntrPrtyacct.cpCodePreset = "";
           	 	this.cntrPrtyacct.cpTypePreset = "";
           	 	//counterPartyCodeOutHandler();
           	 	break;
           	 }
           	 case "INTERNAL" : {
           	 	finInstBox.includeInLayout=false;
           	 	finInstBox.visible=false;
           		finInstPopUp.finInstCode.text="";
           		cstmrBoxh.includeInLayout=true;
           	 	cstmrBoxh.visible=true;
           	 	customercodeSrchPopUp.customerCode.text="";
           	 	this.cntrPrtyacct.cpCodePreset = "";
           	 	this.cntrPrtyacct.cpTypePreset = "";
           	 	//counterPartyCodeOutHandler();
           	 	break;
           	 }
           }
        }
        
        
        public function onChangeStlForGeneral():void{
        	 var stlFor:String = settleMentFor.selectedItem.value;
			if(stlFor=="SECURITY_TRADE" || stlFor=="CORPORATE_ACTION" || stlFor=="SLR_TRADE")
			{   
				this.cashSecurityFlagLbl .includeInLayout=false;
				this.cashSecurityFlagLbl .visible=false;
				this.cashSecurityFlagFld .includeInLayout=true;
				this.cashSecurityFlagFld .visible=true;
				this.stlTran.selectedIndex = getIndexOfLabelValueBean(this.stlTran.dataProvider as ArrayCollection, "SECURITY");
				//this.stlTran.selectedLabel=="SECURITY"
			}
			else if(stlFor=="DERIVATIVE_TRADE")
			{   
				this.cashSecurityFlagLbl .includeInLayout=false;
				this.cashSecurityFlagLbl .visible=false;
				this.cashSecurityFlagFld .includeInLayout=true;
				this.cashSecurityFlagFld .visible=true;
				this.stlTran.selectedIndex = getIndexOfLabelValueBean(this.stlTran.dataProvider as ArrayCollection, "CASH");
				//this.stlTran.selectedLabel=="SECURITY"
			}
			
			else
			{
				this.cashSecurityFlagLbl .includeInLayout=true;
				this.cashSecurityFlagLbl .visible=true;
				//this.stlTran.selectedLabel=="CASH"
				this.stlTran.selectedIndex = getIndexOfLabelValueBean(this.stlTran.dataProvider as ArrayCollection, "CASH");
				this.cashSecurityFlagFld .includeInLayout=false;
				this.cashSecurityFlagFld .visible=false;
			}
			onChangeSecCashGeneral();
        }
        
        
        
          public function onChangeSecCashGeneral():void{
        	 var stlTranType:String = stlTran.selectedItem.value;
        	 if(stlTranType=="SECURITY"){
        	 	isCash = false;
				this.securitySettlementModeLbl .includeInLayout=true;
				this.securitySettlementModeLbl .visible=true;
				this.securitySettlementModeFld .includeInLayout=true;
				this.securitySettlementModeFld .visible=true;
				this.settlementTypeLbl .includeInLayout=false;
				this.settlementTypeLbl .visible=false;
				//this.stlType.selectedLabel=="AGAINST"
				this.stlType.selectedIndex=getIndexOfLabelValueBean(this.stlType.dataProvider as ArrayCollection, "AGAINST");
				this.settlementTypeFld .includeInLayout=true;
				this.settlementTypeFld .visible=true;
				this.form.enabled=true;
			}else{
				isCash=true;
			 	this.securitySettlementModeLbl .includeInLayout=false;
				this.securitySettlementModeLbl .visible=false;
				this.securitySettlementModeFld .includeInLayout=false;
				this.securitySettlementModeFld .visible=false;
				this.settlementTypeLbl .includeInLayout=true;
				this.settlementTypeLbl .visible=true;
				this.settlementTypeFld .includeInLayout=false;
				this.settlementTypeFld .visible=false;
				this.form.enabled=false;
				this.form.selectedIndex=0;
			}
        }
        
        /**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specific  
          * requirement. 
          */
        private function populateInvAcContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing counter party type                
            var settleActTypeArray:Array = new Array(3);
                settleActTypeArray[0]="T";
                settleActTypeArray[1]="S";
                settleActTypeArray[2]="B";               
            myContextList.addItem(new HiddenObject("invActTypeContext",settleActTypeArray));
        
        	var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="BROKER";
               
            myContextList.addItem(new HiddenObject("CPType",cpTypeArray));
            
            return myContextList;
        }
        
    /**
     * This is the focus out handler of the counter party code.
     */
    private function counterPartyCodeOutHandler():void {
        var cpCode : String = "";
        if(!XenosStringUtils.isBlank( this.finInstPopUp.finInstCode.text))
        	cpCode = this.finInstPopUp.finInstCode.text;
        
        
        //if(!XenosStringUtils.isBlank(cpCode)){
        	this.cntrPrtyacct.cpCodePreset = cpCode;
	    	this.cntrPrtyacct.cpTypePreset = "BROKER"; 
	    //}
    }
    
    
    
        /**
          * This is the method to pass the Collection of data items
          * through the context to the Fin Inst popup. This will be implemented as per specific  
          * requirement. 
          */
        private function populateFinInstContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
                
        	var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="Security Broker";
               
            myContextList.addItem(new HiddenObject("brokerRoles",cpTypeArray));
            
            return myContextList;
        }
        
        // Validate CP Standing add function
        private function validateCpSatndingAdd():Boolean{
	         var alertMsg :String="";
			 var countrPrtyCode :String="";
			 if(cstmrBoxh.includeInLayout){
			 	countrPrtyCode=this.customercodeSrchPopUp.customerCode.text;
			 }else{
			 	countrPrtyCode=this.finInstPopUp.finInstCode.text;
			 }
			 if(!XenosStringUtils.isBlank(cntrPatyType.selectedItem.value)){
			 	 if(XenosStringUtils.isBlank(countrPrtyCode)){
			 		 alertMsg = alertMsg+" Please Enter a valid Counterparty Code";
			 	 }
			 }else if(XenosStringUtils.isBlank(this.cntrPrtyacct.accountNo.text))
			 {
			 	 alertMsg = alertMsg+"Please Enter Counterparty Account";
			 }
				if(alertMsg!="") {
					XenosAlert.error(alertMsg);
			        return false;
			    }
			    return true;
		}
		
        
       		
			public function proceedEntry():void{
				var settleType:String;
				if(isCash){
					settleType = "FREE"
				}else{
					settleType = this.stlType.selectedItem.value;
				}
				if(validateCpSatndingAdd()){
				var req : Object = new Object();
				req.method = "onProceed";
				
			    req['cpSecRule.counterPartyType'] = this.cntrPatyType.selectedItem.value;
			 
			    req['cpSecRule.counterPartyCode'] = (this.finInstBox.includeInLayout && this.finInstBox.visible)? this.finInstPopUp.finInstCode.text :(this.cstmrBoxh.includeInLayout && this.cstmrBoxh.visible)?this.customercodeSrchPopUp.customerCode.text :XenosStringUtils.EMPTY_STR; 
			 
			    req['cpSecRule.tradingAccountNo'] = this.cntrPrtyacct.accountNo.text != null ? this.cntrPrtyacct.accountNo.text : "" ;
			    
			    req['cpSecRule.settlementFor'] = this.settleMentFor.selectedItem.value;
			    
			    req['cpSecRule.cashSecurityFlag'] = this.stlTran.selectedItem.value;
			    
			    req['cpSecRule.market'] = this.executionMarket.itemCombo != null ? this.executionMarket.itemCombo.text : "" ;
			    
			    req['countryCode'] = this.countrycode.countryCode.text != null ? this.countrycode.countryCode.text : "" ;
			     
			    req['cpSecRule.instrumentType'] = this.instrumentType.itemCombo != null ? this.instrumentType.itemCombo.text : "" ;
			    
			    req['cpSecRule.instrumentCode'] = this.securityCode.instrumentId.text != null ? this.securityCode.instrumentId.text : "" ;
			    
			    req['cpSecRule.settlementCcy'] = this.stlCcy.ccyText.text;
			    
			    req['cpSecRule.settlementType'] = settleType;
			    
			    req['cpSecRule.deliveryMethod'] = this.form.selectedItem.value;
			       
			    req['cpSecRule.priority'] = this.priority.selectedItem.value;
			          
			    req['cpSecRule.localAccountNo'] = this.localAcc.localAccountCode.text != null ? this.localAcc.localAccountCode.text : "" ;
			    
			    req['diffCash'] = this.cashDiff;
			    
			    req['cpCashRule.settlementMode'] = this.settlementMode;
			    
			    req['cpCashRule.secCash'] = this.secCash;
			    
			   	httpService.request=req;			
				httpService.send();
				}
			}
			
            private function httpService_fault(evt:FaultEvent):void {
                XenosAlert.error(evt.fault.faultDetail);
            }

            private function httpService_result(event:ResultEvent):void {
                    xmlObj = XML(Object(event.result));
                    if(xmlObj.child("Errors").length()>0){
                    	convertErrorToArray(xmlObj);
                    	if(errList.length>0){
                      	  errPage.showError(errList);
                    	}
					}
					else{
						this.parentDocument.setXMLObj(xmlObj);
	                    this.parentDocument.ammendEditDisplayDecider(xmlObj.pageView.toString());
					}
            }
            
            
   	 private function convertErrorToArray(tempXmlObj:XML):void{
   	 		errList	= new ArrayCollection();
//            if(xmlObj.child("Errors.error").length()>0){
				for each (var rec:String in tempXmlObj.Errors.error ) {					    	
			 	   errList.addItem(rec);		 				    
			   }
//			}
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
