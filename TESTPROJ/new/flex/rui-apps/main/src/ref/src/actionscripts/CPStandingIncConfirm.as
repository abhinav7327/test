import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.utils.XenosPopupUtils;
import com.nri.rui.core.utils.XenosStringUtils;

import mx.collections.ArrayCollection;
import mx.core.UIComponent;

 	  [Bindable]
	   private var xmlObj:XML;
	   [Bindable]
	   private var accrnymCntrl:Boolean=false;
	   private var viewType :String=null;
	   [Bindable]
	   private var secCustList:ArrayCollection;
	   [Bindable]
	   private var cashCustList:ArrayCollection;
		   
		   /**
           * Initialize view with the XML
           **/
              	       
        public function initializeView(xml:XML):void 
        {  	  xmlObj = xml;    
         	 cntrlStlViewFlow();
        }
           
        public function setViewType(view:String):void{
        	viewType=view;
           }
                 
                 
           /**
           * Enable or diable particular area in view
           **/
              
         private function cntrlStlViewFlow():void{
         	if(xmlObj!=null){
            var cashSecurityFlg:String= xmlObj.cpSecRule.cashSecurityFlag.toString();
            var diffCash:String= xmlObj.cpSecRule.diffCash.toString();
             if(xmlObj.cpSecRule.tradingAccountNo!=null && xmlObj.cpSecRule.tradingAccountNo.toString()!=""){
       		    accrnymCntrl=true;
        	 }else{
        	 	accrnymCntrl=false;
        	 }
		    populateSecCustList();
            populateCashCustList();
			    
		   if(cashSecurityFlg=="SECURITY"){
			 if(diffCash=="TRUE"){
				  this.beneficiaryNameCash.includeInLayout=true;
				  this.beneficiaryNameCash.visible=true;
			      this.cashGlobalCustdDtls.includeInLayout=true;
				  this.cashGlobalCustdDtls.visible=true;
				  this.cashLocalCustdDtls.includeInLayout=true;
				  this.cashLocalCustdDtls.visible=true;
		     }
			  else {
			      this.beneficiaryNameCash.includeInLayout=false;
				  this.beneficiaryNameCash.visible=false;
			      this.cashGlobalCustdDtls.includeInLayout=false;
				  this.cashGlobalCustdDtls.visible=false;
				  this.cashLocalCustdDtls.includeInLayout=false;
				  this.cashLocalCustdDtls.visible=false;
			   }
		     }
		     
		   else if(cashSecurityFlg!=null && cashSecurityFlg=="CASH"){
		  		  this.beneficiaryNameSec.includeInLayout=false;
				  this.beneficiaryNameSec.visible=false;
			      this.globalCustdDtls.includeInLayout=false;
				  this.globalCustdDtls.visible=false;
				  this.localCustdDtls.includeInLayout=false;
				  this.localCustdDtls.visible=false;
				  
				  // Added for XGA-2368
				  this.beneficiaryNameCash.includeInLayout=true;
				  this.beneficiaryNameCash.visible=true;
	
		   }
         }else{
         	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.cpstd.msg.info.invalid.xml'));
         }
	   }
	   
	   
	       /*
             *Display Financial Institution Details Popup
             */  
         private function displayFinInstDetail(finInstRolePk:String):void {
         	if(!XenosStringUtils.isBlank(finInstRolePk)){
            var parentApp :UIComponent = UIComponent(this.parentApplication);
            XenosPopupUtils.showFinInstDetails(finInstRolePk,parentApp);
          }
        }
            
          /*
         *Display Account Detail Popup
         */
         
         private function accountView(acctPk:String):void {
          if(!XenosStringUtils.isBlank(acctPk)){
     
          var parentApp :UIComponent = UIComponent(this.parentApplication);
          XenosPopupUtils.showAccountSummary(acctPk,parentApp);
         	}
         }
         
         private function openFinInstDetailsPopUp(e:MouseEvent):void{
         	displayFinInstDetail(xmlObj.cpSecRule.cpBankPk.toString());
         
         }
         
          private function openAccountDetailsPopUp(e:MouseEvent):void{
         	accountView(xmlObj.cpSecRule.cpIntSettleAccountPk.toString());
         }
         
                  
       private function initializePopUpLinks():void{
               	
          if(viewType.toUpperCase()=="QUERY") {
               	// Add link to Local Custodian
               	lclCustBank.addEventListener(MouseEvent.CLICK,openFinInstDetailsPopUp);	
             	lclCustBank.useHandCursor=true;
            	lclCustBank.styleName="TextLink";
            	lclCustBank.buttonMode=true ;
            	lclCustBank.mouseChildren=false;
            	
            	// Add link to Local Custodian
               	glblCustBank.addEventListener(MouseEvent.CLICK,openFinInstDetailsPopUp);	
             	glblCustBank.useHandCursor=true;
            	glblCustBank.styleName="TextLink";
            	glblCustBank.buttonMode=true ;
            	glblCustBank.mouseChildren=false;
            	
            	
            	if(!XenosStringUtils.isBlank(xmlObj.cpSecRule.cpIntSettleAccountPk.toString())){
	            	stlAcc.addEventListener(MouseEvent.CLICK,openAccountDetailsPopUp);	
	             	stlAcc.useHandCursor=true;
	            	stlAcc.styleName="TextLink";
	            	stlAcc.buttonMode=true ;
	            	stlAcc.mouseChildren=false;
            	}
             }
        }		
        // Populate Sec cust list for data grid
        private function populateSecCustList():void
		{
			secCustList = new ArrayCollection();
			if(xmlObj.child("secCustList").length()>0){
				for each (var rec:Object in xmlObj.secCustList.item ) {					    	
			 	   secCustList.addItem(rec);		 				    
			   }
			}
	
		}
		
		// Populate Global Custodin sec datagrid
		private function populateCashCustList():void
		{
			cashCustList = new ArrayCollection();
			if(xmlObj.child("cashCustList").length()>0){
			for each (var rec:Object in xmlObj.cashCustList.item ) {					    	
			 	   cashCustList.addItem(rec);		 				    
			   }
			}
		
		}