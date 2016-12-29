import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.XenosStringUtils;

import mx.collections.ArrayCollection;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import com.nri.rui.core.utils.OnDataChangeUtil;
import mx.events.FlexEvent;
			
			  [Bindable]
			  private var xmlObj:XML;
			  private var modeOfTran:String="";
			  [Bindable]
			  private var custBankGlobalSecLst:ArrayCollection;
			 private var custBankGlobalSecIndx:int=0;
			 [Bindable]
			 private var wayOfPayLst:ArrayCollection;
			 private var wayOfPayIndx:int=0;
			 [Bindable]
			 private var secCustList:ArrayCollection;
		    [Bindable]
			 private var cashCustList:ArrayCollection;
	 
	 
	 
		       
        public function initializeView(xml:XML):void {
             xmlObj = xml;     
             initializeNormalEntry();
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
		        cpTypeArray[0]="Bank/Custodian";
		        myContextList.addItem(new HiddenObject("brokerRoles",cpTypeArray));
		    return myContextList;
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
            var settleActTypeArray:Array = new Array(2);
                settleActTypeArray[0]="SAFEKEEPING";
                settleActTypeArray[1]="BOTH";
                         
            myContextList.addItem(new HiddenObject("stlContext",settleActTypeArray));
            return myContextList;
        }
		
		public function setModeOfTran(mode:String):void{
			modeOfTran = mode;
		}
		
			private function populateCustBankGlobalSecCombo():void{
			
			 custBankGlobalSecLst =new ArrayCollection();
			if(xmlObj.child("CpBankCodeTypeList").length()>0){
	       	 var indx1:int = 0; 
			 for each(var obj:Object in xmlObj.CpBankCodeTypeList.item ){
			 	
			 	if(xmlObj.secCpBankCodeType.toString()==obj.value){
			 		custBankGlobalSecIndx=indx1;
			 	}
			  		indx1++;
			 	    custBankGlobalSecLst.addItem(obj);;
		        }
		       custBankGlobalSecLst.refresh();  
		      globalCustCodeType.selectedIndex =custBankGlobalSecIndx;
		      cashGlobalBankCodeType.selectedIndex =custBankGlobalSecIndx;
	       	}
       	
		}
		
		
		private function populateWayOfPaymentCombo():void{
			 wayOfPayLst =new ArrayCollection();
			if(xmlObj.child("wayOfPymnt").length()>0){
	       	 wayOfPayLst.addItem({label: "" , value : ""});
			 for each(var obj:Object in xmlObj.wayOfPymnt.item ){
			 	    wayOfPayLst.addItem(obj);;
		        }
		       wayOfPayLst.refresh();  
	       	}
		}
		
				// Populate Global Custodin sec datagrid
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
		
		
		
		private function showHideglobalCustdDtlsAcName():void
		{
			if(this.globalCustdDtlsAcName.includeInLayout){
				
				this.globalCustdDtlsAcName.includeInLayout =false;
				this.globalCustdDtlsAcName.visible =false;
			}
			 else
			 {
			 	this.globalCustdDtlsAcName.includeInLayout =true;
				this.globalCustdDtlsAcName.visible =true;
			 }
	
		}
		
		private function showHidelocalCustdDtlsAcName():void
		{
			if(this.localCustdDtlsAcName.includeInLayout){
				
				this.localCustdDtlsAcName.includeInLayout =false;
				this.localCustdDtlsAcName.visible =false;
			}
			 else
			 {
			 	this.localCustdDtlsAcName.includeInLayout =true;
				this.localCustdDtlsAcName.visible =true;
			 }
	 
	
		}
		
		private function showHidecashLocalCustdDtlsAcName():void
		{
			if(this.cashLocalCustdDtlsAcName.includeInLayout){
				
				this.cashLocalCustdDtlsAcName.includeInLayout =false;
				this.cashLocalCustdDtlsAcName.visible =false;
			}
			 else
			 {
			 	this.cashLocalCustdDtlsAcName.includeInLayout =true;
				this.cashLocalCustdDtlsAcName.visible =true;
			 }
	 
	
		}
		
		private function showHidecashGlobalCustdDtlsAcName():void
		{
			if(this.cashGlobalCustdDtlsAcName.includeInLayout){
				this.cashGlobalCustdDtlsAcName.includeInLayout =false;
				this.cashGlobalCustdDtlsAcName.visible =false;
			}
			 else
			 {
			 	this.cashGlobalCustdDtlsAcName.includeInLayout =true;
				this.cashGlobalCustdDtlsAcName.visible =true;
			 }
		}
		// Control the dispaly of Global Cash 
		private function showHideCashGlobalCustd():void
		{
		  cashdetailsbtn.includeInLayout=true;
		  cashdetailsbtn.visible=true;
		  cashLocalCustdBankLbl.includeInLayout=false;
		  cashLocalCustdBankLbl.visible=false;
		  cashLocalCustdBankFld.includeInLayout=true;
		  cashLocalCustdBankFld.visible=true;
		  stlCashLocalCust.accountPopup.includeInLayout=false;
		}
		
	  public function showHideAcronym():void{
         	if(xmlObj!=null){
        		if(xmlObj.cpSecRule.tradingAccountNo==""){
	        		labelacronym.includeInLayout=false;
	        		labelacronym.visible=false;
	        		valueacronym.includeInLayout=false;
	        		valueacronym.visible=false;
        		}else{
	        		labelacronym.includeInLayout=true;
	        		labelacronym.visible=true;
	        		valueacronym.includeInLayout=true;
	        		valueacronym.visible=true;
        	}
          }
        }
		
		// Cal CPStanding Edit.as showHideWayofPay method
	 public function showHideWayofPay():void{
	 	this.parentDocument.showHideWayofPay(xmlObj.cpSecRule.settlementType.toString());
		 	if(xmlObj.cpSecRule.settlementType.toString()=="AGAINST"){
		       if(!(xmlObj.cpSecRule.contraIdObject.contraId ||xmlObj.cpSecRule.dtcIndicator))
			   {
			   	diffcash.includeInLayout=true;
			   	diffcash.visible =true;
			   	samecash.includeInLayout=false;
			   	samecash.visible =false;
				}
			}
			else{
		   	  if(!(xmlObj.cpSecRule.contraIdObject.contraId ||xmlObj.cpSecRule.dtcIndicator))
			    {
			    diffcash.includeInLayout=false;
			   	diffcash.visible =false;
				 
				}
			}
		}


		// Control the dispaly of Glbal Sec 
		private function showHideSecGlobalCustd():void
		{
		   secLocalCustdBankLbl.includeInLayout=false;
		   secLocalCustdBankLbl.visible=false;
			
		   secLocalCustdBankFld.includeInLayout=true;
		   secLocalCustdBankFld.visible=true;
			
	   	   stlLocalCust.accountPopup.includeInLayout=false;
	   	   stlLocalCust.accountPopup.visible=false;
  
		}
		
    // Populate the Data for PopUp Boxes
	private function populatePopupBoxdata():void{
		// List of SECURITY Global Custodians  Custodian Bank
       	if(xmlObj.child("custBankGlobalSec").length()>0){
         finInstPopUp.finInstCode.text = xmlObj.custBankGlobalSec.toString();
        }else{
        	finInstPopUp.finInstCode.text="";
        }
        // Check is Local Sec Custodian node exist
        var childLocalSecCustodian:XMLList=xmlObj.child("localSecCustodian");
       	if(childLocalSecCustodian.length()>0){
       	
       	// List of Security Local Custodian  Custodian Bank
	       	if(childLocalSecCustodian.child("displayBankCode").length()>0){
	         secLocalCustdBankFldData.finInstCode.text = xmlObj.localSecCustodian.displayBankCode.toString();
	        }else{
	        	secLocalCustdBankFldData.finInstCode.text="";
	        }
	        
	        // List of Security Local Custodian  Settlement Account
	       	if(childLocalSecCustodian.child("displayAccountNo").length()>0){
	         stlLocalCust.accountNo.text = xmlObj.localSecCustodian.displayAccountNo.toString();
	        }else{
	        	stlLocalCust.accountNo.text="";
	        }
	        
     	}
     	
        // Diff Cash  List of Global Custodians  Custodian Bank
       	if(xmlObj.child("custBankGlobalCash").length()>0){
         finInstPopUpcsh.finInstCode.text = xmlObj.custBankGlobalSec.toString();
        }else{
        	 finInstPopUpcsh.finInstCode.text="";
        }
        
        // Check is Local Cash Custodian Node exist
        if(xmlObj.child("localCashCustodian").length()>0){
        // Diff Cash Local Custodian Custodian Bank
	       	if(xmlObj.child("localCashCustodian.displayBankCode").length()>0){
	         cshLocalCustdBankFldData.finInstCode.text = xmlObj.localCashCustodian.displayBankCode.toString();
	        }else{
	        	 cshLocalCustdBankFldData.finInstCode.text="";
	        }
	        
	        // Diff Cash Local Custodian Settlement Account
	       	if(xmlObj.child("localCashCustodian.displayAccountNo").length()>0){
	         stlCashLocalCust.accountNo.text = xmlObj.localCashCustodian.displayAccountNo.toString();
	        }else{
	        	stlCashLocalCust.accountNo.text="";
	        }
        }
        
	}	
	
	// Populate Data To Screen
	private function populateDataToScreen():void{
			//accronym grid
			// Broker bic field 
			var childcpSecRule:XMLList=xmlObj.child("cpSecRule");
		 	 if(childcpSecRule.child("brokerBic").length()>0){
		 	 	brkrBic.text =xmlObj.cpSecRule.brokerBic.toString();
		 	 }else{
		 	 	brkrBic.text="";
		 	 }
		 	//acronym field
		 	 if(childcpSecRule.child("acronym").length()>0){
		 	 	valueacronym.text =xmlObj.cpSecRule.acronym.toString();
		 	 }else{
		 	 	valueacronym.text="";
		 	 }
		 	//Beneficiary Name grid
		 	// beneficiaryName field
		 	 if(childcpSecRule.child("beneficiaryName").length()>0){
		 	 	benfcrnyNm.text =xmlObj.cpSecRule.beneficiaryName.toString();
		 	 }else{
		 	 	benfcrnyNm.text="";
		 	 }
		 	 
		 	// Participant Id Grid
		 	
		 	// Participant Id field
		 	 if(childcpSecRule.child("participantId").length()>0){
		 	 	participantId1.text =xmlObj.cpSecRule.participantId.toString();
		 	 }else{
		 	 	participantId1.text="";
		 	 }
		 	 // Participant Id 2 field
		 	 if(childcpSecRule.child("participantId2").length()>0){
		 	 	participantId2.text =xmlObj.cpSecRule.participantId2.toString();
		 	 }else{
		 	 	participantId2.text="";
		 	 }
		 	
		 	 
//		   }
			// List of SECURITY Global Custodians
		 	 // Custodian Bank filed
		 	 finInstPopUp.finInstCode.text="";
		 	 // Settlement Acct filed
		 	if(xmlObj.child("stlAcGlobalSec").length()>0){
		 		stlAcGlobalSec.text =xmlObj.stlAcGlobalSec.toString(); 
		 	}else{
		 	 	stlAcGlobalSec.text="";
		 	 }
		 	//Settleacnameline1 filed
		 	if(xmlObj.child("acName1GlobalSec").length()>0){
		 		acName1GlobalSec.text =xmlObj.acName1GlobalSec.toString(); 
		 	}else{
		 	 	acName1GlobalSec.text="";
		 	 }
		 	//Settleacnameline2 filed
		 	if(xmlObj.child("acName2GlobalSec").length()>0){
		 		acName2GlobalSec.text =xmlObj.acName2GlobalSec.toString(); 
		 	}else{
		 	 	acName2GlobalSec.text="";
		 	 }
		 	//Settleacnameline3 filed
		 	if(xmlObj.child("acName3GlobalSec").length()>0){
		 		acName3GlobalSec.text =xmlObj.acName3GlobalSec.toString(); 
		 	}else{
		 	 	acName3GlobalSec.text="";
		 	 }
		 	//Settleacnameline4 filed
		 	if(xmlObj.child("acName4GlobalSec").length()>0){
		 		acName4GlobalSec.text =xmlObj.acName4GlobalSec.toString(); 
		 	}else{
		 	 	acName4GlobalSec.text="";
		 	 }
		 	
		 	// Local Custodian Start
		 	secLocalCustdBankFldData.finInstCode.text=="";
		 	
		 	 if(xmlObj.child("enterprise").length()>0){
		 	 	secLocalCustdBankLblData.text=xmlObj.enterprise.toString();
		 	 }else{
		 	 	secLocalCustdBankLblData.text="";
		 	 }
		 	 
		 	 var childlocalSecCustodian:XMLList=xmlObj.child("localSecCustodian");
//		 	 if(xmlObj.child("localSecCustodian").length()>0){
		 	 	// Custodian Bank Name filed
	 	 	 if(childcpSecRule.child("wayOfPayment").length()>0){
	 	 	 	var wayOfPayStr:String =xmlObj.cpSecRule.wayOfPayment.toString();
	 	 	 	var count:int;
	 	 	 	for (count = 0; count < wayOfPayLst.length; count++){
	 	 	 		if(wayOfPayStr==wayOfPayLst.getItemAt(count).label){
	 	 	 			wayOfPay.selectedIndex = count;
	 	 	 			break;
	 	 	 		}
	 	 	 	}
				trace("wayOfPayStr"+wayOfPayLst.getItemAt(count)+":"+wayOfPayLst.getItemAt(count).label);
		 	 }else{
		 	 	wayOfPay.selectedItem.value="";
		 	 }
		 	 
	 	 	 if(childlocalSecCustodian.child("bankName").length()>0){
		 	 	lclSecCustBnkNm.text=xmlObj.localSecCustodian.bankName.toString(); ;
		 	 }else{
		 	 	lclSecCustBnkNm.text="";
		 	 }
		 	 // Settlement Account
		 	 stlLocalCust.accountNo.text="";
		 	 
		 	// Settlement Account 1
		 	  if(xmlObj.child("localSecCustodian.accountName1").length()>0){
		 	 	Settleacnameline1.text=xmlObj.localSecCustodian.accountName1.toString(); ;
		 	 }else{
		 	 	Settleacnameline1.text="";
		 	 }
		 	 // Settlement Account 2
		 	  if(xmlObj.child("localSecCustodian.accountName2").length()>0){
		 	 	Settleacnameline2.text=xmlObj.localSecCustodian.accountName2.toString(); ;
		 	 }else{
		 	 	Settleacnameline2.text="";
		 	 }
		 	 // Settlement Account 3
		 	  if(xmlObj.child("localSecCustodian.accountName3").length()>0){
		 	 	Settleacnameline3.text=xmlObj.localSecCustodian.accountName3.toString(); ;
		 	 }else{
		 	 	Settleacnameline3.text="";
		 	 }
		 	 // Settlement Account 4
		 	  if(xmlObj.child("localSecCustodian.accountName4").length()>0){
		 	 	Settleacnameline4.text=xmlObj.localSecCustodian.accountName4.toString(); ;
		 	 }else{
		 	 	Settleacnameline4.text="";
		 	 }	
		 	 	
		 	 var childcpCashRule:XMLList=xmlObj.child("cpCashRule");
		 	 
		 	 if(childcpCashRule.length() > 0) {
		 	  	 //Benificiary name start
		 	  	 if(childcpCashRule.child("beneficiaryName").length()>0){
			 	 	cshBenfcNm.text =xmlObj.cpCashRule.beneficiaryName.toString();
			 	 }else{
			 	 	cshBenfcNm.text="";
			 	 }
		 	 }
	 	 
	 	 //Diff Cash  List of Global Custodians start
	 	 // custodianbank field
	 	 if(xmlObj.child("custBankGlobalCash").length()>0){
	 	 	custBankGlobalCash.text=xmlObj.custBankGlobalCash.toString();
	 	 }else{
	 	 	custBankGlobalCash.text="";
	 	 }
	 	finInstPopUpcsh.finInstCode.text="";
	 	
	 	// settlementaccount filed
	 	if(xmlObj.child("stlAcGlobalCash").length()>0){
	 	 	stlAcGlobalCash.text=xmlObj.stlAcGlobalCash.toString();
	 	 }else{
	 	 	stlAcGlobalCash.text="";
	 	 }
	 	 // Settlement Acct 1 
	 	 if(xmlObj.child("acName1GlobalCash").length()>0){
	 	 	acName1GlobalCash.text=xmlObj.acName1GlobalCash.toString();
	 	 }else{
	 	 	acName1GlobalCash.text="";
	 	 }
	 	 
	 	  // Settlement Acct 2
	 	 if(xmlObj.child("acName2GlobalCash").length()>0){
	 	 	acName2GlobalCash.text=xmlObj.acName2GlobalCash.toString();
	 	 }else{
	 	 	acName2GlobalCash.text="";
	 	 }
	 	 
	 	  // Settlement Acct 3
	 	 if(xmlObj.child("acName3GlobalCash").length()>0){
	 	 	acName3GlobalCash.text=xmlObj.acName3GlobalCash.toString();
	 	 }else{
	 	 	acName3GlobalCash.text="";
	 	 }
	 	 
	 	  // Settlement Acct 4
	 	 if(xmlObj.child("acName4GlobalCash").length()>0){
	 	 	acName4GlobalCash.text=xmlObj.acName4GlobalCash.toString();
	 	 }else{
	 	 	acName4GlobalCash.text="";
	 	 }
	 	 
	 	// Diff Cash Local Custodian START
	 	//custodianbank start
	 	 if(xmlObj.child("enterprise").length()>0){
	 	 	cshLocalCustdBankLblData.text=xmlObj.enterprise.toString();
	 	 }else{
	 	 	cshLocalCustdBankLblData.text="";
	 	 }
	 	cshLocalCustdBankFldData.finInstCode.text="";
	 	
	 		
	 	// Cust bnk Name filed
	 		if(xmlObj.child("localCashCustodian.bankName").length()>0){
	 			lclCustBnkNm.text=xmlObj.localCashCustodian.bankName.toString();
	 		}else{
	 			lclCustBnkNm.text="";
	 		}
	 		//settlementaccount field
	 		stlCashLocalCust.accountNo.text="";
	 		// Future Credit filed
	 		if(xmlObj.child("cpCashRule.furtherCredit").length()>0){
	 			futureCrdt.text=xmlObj.cpCashRule.furtherCredit.toString();
	 		}else{
	 			futureCrdt.text="";
	 		}
	 		// Settlement Acct1
	 		if(xmlObj.child("localCashCustodian.accountName1").length()>0){
	 			accountName1.text=xmlObj.localCashCustodian.accountName1.toString();
	 		}else{
	 			accountName1.text="";
	 		}
	 		// Settlement Acct2
	 		if(xmlObj.child("localCashCustodian.accountName2").length()>0){
	 			accountName2.text=xmlObj.localCashCustodian.accountName2.toString();
	 		}else{
	 			accountName2.text="";
	 		}
	 		// Settlement Acct3
	 		if(xmlObj.child("localCashCustodian.accountName3").length()>0){
	 			accountName3.text=xmlObj.localCashCustodian.accountName3.toString();
	 		}else{
	 			accountName2.text="";
	 		}
	 		// Settlement Acct2
	 		if(xmlObj.child("localCashCustodian.accountName4").length()>0){
	 			accountName4.text=xmlObj.localCashCustodian.accountName4.toString();
	 		}else{
	 			accountName4.text="";
	 		}
//		 }		
	}
	
		// Initialize the screen
	public function initializeNormalEntry():void{
		errPage.removeError();
		// Method calling to populate  Combo and datagrid
			populateWayOfPaymentCombo();
			populateCustBankGlobalSecCombo();
			populateSecCustList();
			populateCashCustList();
	    // Method calling to populateScreens
	  		populateDataToScreen();
			populatePopupBoxdata();
			
		// Method calling to control the display of User interface 
			if(modeOfTran!="ADD"){
				chkCounterPartyType();
				onChangeSecCashAmend();
			}else{
				onChangeStlFor();
			}
			showHideWayofPay();
			showHideSecGlobalCustd();
			showHideCashGlobalCustd();
			showHideAcronym();
			showOnDiffSame();
			// For global Cust Sec
		if( xmlObj.firstGlobalCustodianAddedForSec.toString() =="true"){
				firstGlobalCustodianAddedForSec.includeInLayout=false;
				firstGlobalCustodianAddedForSec.visible=false;
				custBankGlobalSec.text="";
//				globalCustCodeType.selectedIndex=0;
				custBankGlobalSecPopUp.includeInLayout=true;
				custBankGlobalSecPopUp.visible=true;
					
			}else{
				firstGlobalCustodianAddedForSec.includeInLayout=true;
				firstGlobalCustodianAddedForSec.visible=true;
				custBankGlobalSec.text="";
//				globalCustCodeType.selectedIndex=0;
				custBankGlobalSecPopUp.includeInLayout=false;
				custBankGlobalSecPopUp.visible=false;
			}
			// For global Cust Cash
		if( xmlObj.firstGlobalCustodianAddedForCash.toString() =="true"){
				firstGlobalCustodianAddedForCash.includeInLayout=true;
				firstGlobalCustodianAddedForCash.visible=true;
				finInstPopUpcsh.finInstCode.text="";
				cashGlobalBankCodeType.selectedIndex=0;
				custBankGlobalCash.text="";
				firstGlCustodianAdded.includeInLayout=false;
				firstGlCustodianAdded.visible=false;
			}else{
				firstGlobalCustodianAddedForCash.includeInLayout=false;
				firstGlobalCustodianAddedForCash.visible=false;
				finInstPopUpcsh.finInstCode.text="";
				cashGlobalBankCodeType.selectedIndex=0;
				custBankGlobalCash.text="";
				firstGlCustodianAdded.includeInLayout=true;
				firstGlCustodianAdded.visible=true;
			}	
			secLocalCustdBankFldData.finInstCode.addEventListener(FlexEvent.VALUE_COMMIT, onChangeCustodianBank);	
		}
		
		private function onChangeCustodianBank(event:Event):void{
			OnDataChangeUtil.onChangeBankCode(lclSecCustBnkNm,secLocalCustdBankFldData.finInstCode.text);
    	}
		
		
		private function showOnDiffSame():void{
			if(xmlObj.diffSameFlg.toString()=="SAME"|| xmlObj.cpSecRule.cashSecurityFlag.toString()=="CASH"){
		       showHideDiffCash('SHOW');
			} else if(xmlObj.diffSameFlg.toString()=="DIFF") {
		       showHideDiffCash('HIDE');
			}
		}
		
		private function onChangeSecCashAmend():void{
			if((xmlObj.secCash.toString()).toUpperCase()=="SECURITY") {
				
				beneficiaryNameSec.includeInLayout=true;
				beneficiaryNameSec.visible=true;
				
				beneficiaryNameCash.includeInLayout=false;
				beneficiaryNameCash.visible=false;
			
			}else{
				
				beneficiaryNameSec.includeInLayout=false;
				beneficiaryNameSec.visible=false;
				
				beneficiaryNameCash.includeInLayout=true;
				beneficiaryNameCash.visible=true;
				
			}
			
			showHideSecCash((xmlObj.secCash.toString()).toUpperCase());
			
		}
		
		
		private function onChangeSecCash(secCash:String):void{
			if((xmlObj.cpSecRule.cashSecurityFlag.toString()).toUpperCase()=="SECURITY") {
				beneficiaryNameSec.includeInLayout=true;
				beneficiaryNameSec.visible=true;
				beneficiaryNameCash.includeInLayout=false;
				beneficiaryNameCash.visible=false;
				showHideDiffCash('HIDE');
			}else{
				beneficiaryNameSec.includeInLayout=false;
				beneficiaryNameSec.visible=false;
				beneficiaryNameCash.includeInLayout=true;
				beneficiaryNameCash.visible=true;
				showHideDiffCash('SHOW');
			}
			
			showHideSecCash(secCash);
			showHideWayofPay();
		}
		
		// Called on onload for Addition
		private	function onChangeStlFor():void{
			var objStlFor:String=xmlObj.cpSecRule.settlementFor.toString();
			var secCash:String = "";
			if(objStlFor=="SECURITY_TRADE" || objStlFor=="CORPORATE_ACTION" || objStlFor=="SLR_TRADE" || objStlFor=="DERIVATIVE_TRADE"){
				secCash = xmlObj.cpSecRule.cashSecurityFlag.toString();
			}
			else{
				secCash ="CASH";
			}
		    onChangeSecCash(secCash);
		}


		
	private	function showHideSecCash(secCash:String):void{
		    if(secCash=="SECURITY") {
		    	globalCustdDtls.includeInLayout=true;
		    	globalCustdDtls.visible=true;
		    	localCustdDtls.includeInLayout=true;
		    	localCustdDtls.visible=true;
		    	cashGlobalCustdDtls.includeInLayout=false;
		    	cashGlobalCustdDtls.visible=false;
		    	cashLocalCustdDtls.includeInLayout=false;
		    	cashLocalCustdDtls.visible=false;
			}
			else{
			 	globalCustdDtls.includeInLayout=false;
		    	globalCustdDtls.visible=false;
		    	localCustdDtls.includeInLayout=false;
		    	localCustdDtls.visible=false;
		    	cashGlobalCustdDtls.includeInLayout=true;
		    	cashGlobalCustdDtls.visible=true;
		    	cashGlobalBankCodeType.selectedIndex =custBankGlobalSecIndx;
		    	cashLocalCustdDtls.includeInLayout=true;
		    	cashLocalCustdDtls.visible=true;
			}
		}
		
	private function chkCounterPartyType():void
		{
		if((xmlObj.diffCash.toString()).toUpperCase()=="TRUE" && (xmlObj.diffSameFlg.toString()).toUpperCase()=="DIFF") {
				cashGlobalCustdDtls.includeInLayout=true;
				cashGlobalCustdDtls.visible=true;
				cashGlobalBankCodeType.selectedIndex =custBankGlobalSecIndx;
				cashLocalCustdDtls.includeInLayout=true;
				cashLocalCustdDtls.visible=true;
				
				beneficiaryNameCash.includeInLayout=true;
				beneficiaryNameCash.visible=true;
				
				diffcash.includeInLayout=false;
				diffcash.visible=false;
				samecash.includeInLayout=true;
				samecash.visible=true;
			
			}
			  else{
			  	cashGlobalCustdDtls.includeInLayout=false;
				cashGlobalCustdDtls.visible=false;
				
				cashLocalCustdDtls.includeInLayout=false;
				cashLocalCustdDtls.visible=false;
				
				beneficiaryNameCash.includeInLayout=false;
				beneficiaryNameCash.visible=false;
				
				diffcash.includeInLayout=true;
				diffcash.visible=true;
				
				samecash.includeInLayout=false;
				samecash.visible=false;
		      }
		      
		   if((xmlObj.cpSecRule.counterPartyType.toString()).toUpperCase()=="BROKER") {
		   		secLocalCustdBankLbl.includeInLayout=false;
				secLocalCustdBankLbl.visible=false;
				
				secLocalCustdBankFld.includeInLayout=true;
				secLocalCustdBankFld.visible=true;
				
				stlLocalCust.accountPopup.includeInLayout=false;
				stlLocalCust.accountPopup.visible=false;
				
				cashLocalCustdBankLbl.includeInLayout=false;
				cashLocalCustdBankLbl.visible=false;
				
				cashLocalCustdBankFld.includeInLayout=true;
				cashLocalCustdBankFld.visible=true;
				
				stlCashLocalCust.accountPopup.includeInLayout=false;
				stlCashLocalCust.accountPopup.visible=false;
			
			
			}
		}
 
	 

 
	
	
		private function httpService_fault(evt:FaultEvent):void {
                XenosAlert.error(evt.fault.faultDetail);
            }
            
		
		// Delete request for Global Sec details table
		public function globalSecHttpServiceDelete(data:Object):void{
			var req : Object = new Object();
			req.method = "deleteGlobalSecCustodian";
			req.modeofTran = modeOfTran;
			req.rowNum =secCustList.getItemIndex(data);  
			glblSecdHttpService.request=req;			
			glblSecdHttpService.send();
			
		}
		
	// Set Updated result to Global Sec list
        private function globalSecHttpService_Updated_Result(evt:ResultEvent):void {
                xmlObj = evt.result as XML;  
                if(xmlObj.child("Errors").length()>0){
		    		var errorInfoList : ArrayCollection = new ArrayCollection();
		            //populate the error info list 			 	
				 	for each ( var error:XML in xmlObj.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	errPage.showError(errorInfoList);//Display the error
		    	}else{ 
		    	errPage.removeError();
                populateSecCustList();
                // Re initialize iew
                initializeNormalEntry();
//                this.secCustListContainer.dataProvider=secCustList;
		    	}
         
        }
        
        // Add request for Global Sec details table
		private function globalSecHttpServiceAdd():void{
			if(validateSecGlobalCustodianEntry()){
			var req : Object = new Object();
			req['method'] = "addGlobalSecCustodian";
			req['modeofTran'] = modeOfTran;
			req['acName1GlobalSec'] = this.acName1GlobalSec.text;
			req['acName2GlobalSec'] = this.acName2GlobalSec.text;
			req['acName3GlobalSec'] = this.acName3GlobalSec.text;
			req['acName4GlobalSec'] = this.acName4GlobalSec.text;
			req['stlAcGlobalSec'] = this.stlAcGlobalSec.text;
			req['cpSecRule.brokerBic'] = this.brkrBic.text;
			req['cpSecRule.acronym'] = this.valueacronym.text;
			req['cpSecRule.beneficiaryName'] = this.benfcrnyNm.text;
			req['cpSecRule.participantId'] = this.participantId1.text;
			req['cpSecRule.participantId2'] = this.participantId2.text;
			if(secLocalCustdBankFld.includeInLayout){
				req['localSecCustodian.displayBankCode'] = this.secLocalCustdBankFldData.finInstCode.text;
			}
			req['localSecCustodian.bankName'] = this.lclSecCustBnkNm.text;
			req['localSecCustodian.displayAccountNo'] = this.stlLocalCust.accountNo.text;
			if(this.wayOfPay.selectedItem.value !=null){			
				req['cpSecRule.wayOfPayment'] = this.wayOfPay.selectedItem.value;			
			}
			if(firstGlobalCustodianAddedForSec.includeInLayout){
				req.custBankGlobalSec=custBankGlobalSec.text;
				req.secCpBankCodeType=this.globalCustCodeType.selectedItem.value;
			}else{
				req.custBankGlobalSec=this.finInstPopUp.finInstCode.text;
			}
			req.globalCustodianName="";
			
			glblSecdHttpService.request=req;			
			glblSecdHttpService.send();
		  }
		}
		
		
		
		
		
		// Delete request for Global Cash details table
		public function globalCashHttpServiceDelete(data:Object):void{
			var req : Object = new Object();
			req.method = "deleteGlobalCashCustodian";
			req.modeofTran = modeOfTran;
			req.rowNum =cashCustList.getItemIndex(data);  
			glblCashHttpService.request=req;			
			glblCashHttpService.send();
			
		}
		
	// Set Updated result to Global Cash list
        private function globalCashHttpService_Updated_Result(evt:ResultEvent):void {
                xmlObj = evt.result as XML;   
                populateCashCustList();
                // Re initialize iew
                initializeNormalEntry();
             //   this.cashCustListContainer.dataProvider=xmlObj.cashCustList;
         
        }
        
        // Add request for Global Cash details table
		private function globalCashHttpServiceAdd():void{
			if(validateCashGlobalCustodianEntry())
			{
				var req : Object = new Object();
				req.method = "addGlobalCashCustodian";
				req.modeofTran = modeOfTran;
				req.acName1GlobalCash = this.acName1GlobalCash.text;
				req.acName2GlobalCash = this.acName2GlobalCash.text;
				req.acName3GlobalCash = this.acName3GlobalCash.text;
				req.acName4GlobalCash = this.acName4GlobalCash.text;
				req.stlAcGlobalCash = this.stlAcGlobalCash.text;
				if(firstGlCustodianAdded.includeInLayout){
					req.custBankGlobalCash=this.custBankGlobalCash.text;
					req.cashCpBankCodeType=this.cashGlobalBankCodeType.selectedItem.value;
				}else{
					req.custBankGlobalCash=this.finInstPopUpcsh.finInstCode.text;
				}
				
				req.globalCustodianNameCash="";
				glblCashHttpService.request=req;			
				glblCashHttpService.send();
			
			}
			
		}
		
	// Validate Global Sec Custodian
	private function validateSecGlobalCustodianEntry():Boolean{
		var alertMsg :String = "";
	    var BIC_BANK_CODE:String = "BIC";
		var custBank :String= "";
		var cpBankCodeType:String="";
		if(firstGlobalCustodianAddedForSec.includeInLayout){
			custBank=custBankGlobalSec.text;
			cpBankCodeType=globalCustCodeType.selectedItem.value;
		}else{
			custBank=this.finInstPopUp.finInstCode.text;
			cpBankCodeType="";
		}
		
		if(XenosStringUtils.isBlank(custBank)){
      		alertMsg += this.parentApplication.xResourceManager.getKeyValue('ref.cpstd.empty.custdbank');
		}else{
			if(custBank.length > 35) {
				alertMsg += this.parentApplication.xResourceManager.getKeyValue('ref.cpstd.length.valid.custdbank');
			}
			
			if(cpBankCodeType == BIC_BANK_CODE) {
				if(alertMsg=="") {
					if(custBank.length != 11) {
						alertMsg += this.parentApplication.xResourceManager.getKeyValue('ref.cpstd.length.custdbankforbic');
					}
				}
			}
		} 

	    if(alertMsg!="") {
	        XenosAlert.error(alertMsg);
	        return false;
	    }
	    return true;
	}
	
	//List of Global Custodians start
	private function validateCashGlobalCustodianEntry():Boolean {
	    var alertMsg:String = "";
		var BIC_BANK_CODE:String = "BIC";
		var custBank:String ="";
		var cpBankCodeType:String ="";
		if(firstGlCustodianAdded.includeInLayout)
		{
			custBank=this.custBankGlobalCash.text;
			cpBankCodeType=cashGlobalBankCodeType.selectedItem.value;
		 }else
		 {
		    custBank=this.finInstPopUpcsh.finInstCode.text;
		    cpBankCodeType="";
		 }
	if(XenosStringUtils.isBlank(custBank)){
		alertMsg += "Global Cash Custodian cannot be empty";
	 }
	     
 
		if(cpBankCodeType == BIC_BANK_CODE) {
			if(alertMsg=="") {
				if(custBank.length != 11) {
					alertMsg += " Custodian Bank length Should be 11 for Bank Code Type BIC "
				}
			}
		}
	
	    if(alertMsg!="") {
	            XenosAlert.error(alertMsg);
	        return false;
	    }
    return true;
}

	public function showHideDiffCash(vDispType:String):void{
		
	   if(vDispType=='SHOW'){
	   	cashGlobalCustdDtls.includeInLayout=true;
	   	cashGlobalCustdDtls.visible=true;
	   	cashGlobalBankCodeType.selectedIndex =custBankGlobalSecIndx;
	   	
	   	cashLocalCustdDtls.includeInLayout=true;
	   	cashLocalCustdDtls.visible=true;
	   	
		beneficiaryNameCash.includeInLayout=true;
	   	beneficiaryNameCash.visible=true;
	     
	    diffcash.includeInLayout =false; 
	    diffcash.visible =false;
	    
	    samecash.includeInLayout =true; 
	    samecash.visible =true;
	 
	   } else{
	   	
	   	cashGlobalCustdDtls.includeInLayout=false;
	   	cashGlobalCustdDtls.visible=false;
	   	
	   	cashLocalCustdDtls.includeInLayout=false;
	   	cashLocalCustdDtls.visible=false;
	   	
		beneficiaryNameCash.includeInLayout=false;
	   	beneficiaryNameCash.visible=false;
	     
	    diffcash.includeInLayout =true; 
	    diffcash.visible =true;
	    
	    samecash.includeInLayout =false; 
	    samecash.visible =false;
	   
	   }
	}
	
	
	/**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
	public function populateNormalEntryParmeter(reqObj:Object):void{
		if(reqObj!=null){
			// Populate the data from Normal Entry Screen
			reqObj['cpSecRule.brokerBic'] = this.brkrBic.text;
			reqObj['cpSecRule.acronym'] = this.valueacronym.text;
			reqObj['cpSecRule.beneficiaryName'] = this.benfcrnyNm.text;
			reqObj['cpSecRule.participantId'] = this.participantId1.text;
			reqObj['cpSecRule.participantId2'] = this.participantId2.text;
			if(secLocalCustdBankFld.includeInLayout){
				reqObj['localSecCustodian.displayBankCode'] = this.secLocalCustdBankFldData.finInstCode.text;
			}
			reqObj['localSecCustodian.bankName'] = this.lclSecCustBnkNm.text;
			reqObj['localSecCustodian.displayAccountNo'] = this.stlLocalCust.accountNo.text;
			if(this.wayOfPay.selectedItem.value !=null){
				reqObj['cpSecRule.wayOfPayment'] = this.wayOfPay.selectedItem.value;
			}
			reqObj['localSecCustodian.accountName1'] = this.Settleacnameline1.text;
			reqObj['localSecCustodian.accountName2'] = this.Settleacnameline2.text;
			reqObj['localSecCustodian.accountName3'] = this.Settleacnameline3.text;
			reqObj['localSecCustodian.accountName4'] = this.Settleacnameline4.text;
			reqObj['cpCashRule.beneficiaryName'] = this.cshBenfcNm.text;
			if(cashLocalCustdBankFld.includeInLayout){
				reqObj['localCashCustodian.displayBankCode'] = this.cshLocalCustdBankFldData.finInstCode.text;
			}
			reqObj['localCashCustodian.bankName'] = this.lclCustBnkNm.text;
			reqObj['localCashCustodian.displayAccountNo'] = this.stlCashLocalCust.accountNo.text;
			reqObj['cpCashRule.wayOfPayment'] = this.lclCashWayOfPay.selectedItem.value;
			reqObj['cpCashRule.furtherCredit'] = this.futureCrdt.text;
			reqObj['localCashCustodian.accountName1'] = this.accountName1.text;
			reqObj['localCashCustodian.accountName2'] = this.accountName2.text;
			reqObj['localCashCustodian.accountName3'] = this.accountName3.text;
			reqObj['localCashCustodian.accountName4'] = this.accountName4.text;
		}
	}

		
	
		
		
		
