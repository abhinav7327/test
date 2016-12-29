
package com.nri.rui.core.utils
{
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.containers.SummaryPopup;
    
    import mx.core.UIComponent;
    import mx.managers.PopUpManager;
        
    /** This class is basically a Util class for the popups 
     *     to open in a TitleWindow. It has fininst, Account,
     *     Instrument etc pop ups. Respective pks need to be passed
     *     to the different functions.
     */ 
    public class XenosPopupUtils
    {
        public function XenosPopupUtils()
        {
        }
        /**
            * This method is used for loading Account Details popup module
            * 
            */  
        public static function showAccountDetails(accountPk : String, accountXml:XML, parentApplication:UIComponent):void {
            
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
            
            sPopup.title = "Account Details";
            sPopup.width = parentApplication.width - 100;
            sPopup.height = parentApplication.height - 100;
            sPopup.xmlData = accountXml;
            PopUpManager.centerPopUp(sPopup);
            
            sPopup.moduleUrl = Globals.ACCOUNT_DETAILS_SWF+Globals.QS_SIGN+Globals.ACCOUNT_PK+Globals.EQUALS_SIGN+accountPk;
        }
        /**
            * This method is used for loading Account Summary popup module
            * 
            */
        public static function showAccountSummary(accountPk : String,parentApplication:UIComponent, prefix:String = null):void {
            
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
            
            sPopup.title = "Account Summary";
            /* sPopup.width = parentApplication.width * 50/100;
            sPopup.height = parentApplication.height * 55/100; */
            sPopup.width = 750;
            sPopup.height = 375;
            PopUpManager.centerPopUp(sPopup);
            if(prefix == null)
                sPopup.moduleUrl = Globals.ACCOUNT_SUMMARY_SWF+Globals.QS_SIGN+Globals.ACCOUNT_PK+Globals.EQUALS_SIGN+accountPk;
            else
                sPopup.moduleUrl = Globals.ACCOUNT_SUMMARY_SWF+Globals.QS_SIGN+Globals.ACCOUNT_PK+Globals.EQUALS_SIGN+accountPk+Globals.AND_SIGN+"prefix"+Globals.EQUALS_SIGN+prefix;
        }
        /**
            * This method is used for loading Account Summary popup module
            * changed by s.paul
            */ 
            // public static function gleLedCodePkStr(accountPk : String,parentApplication:UIComponent, prefix:String = null):void {
         public static function showGleLedgerDetails(gleLedgerPk : String,parentApplication:UIComponent, prefix:String = null):void {
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
            
            sPopup.title = "Gle Ledger Details";
            sPopup.width = 620;
            sPopup.height = 330;
            PopUpManager.centerPopUp(sPopup);
			//sPopup.moduleUrl = GleConstraints.GLE_LEDGER_DETAILS_SWF+Globals.QS_SIGN+GleConstraints.LEDGER_PK+Globals.EQUALS_SIGN+ledgerPkStr;
			//sPopup.moduleUrl = GleConstraints.GLE_LEDGER_DETAILS_SWF+Globals.QS_SIGN+GleConstraints.LEDGER_PK+Globals.EQUALS_SIGN+gleLedgerPk;
			sPopup.moduleUrl = Globals.GLE_LEDGER_DETAILS_SWF+Globals.QS_SIGN+Globals.GLE_LEDGER_PK_STR+Globals.EQUALS_SIGN+gleLedgerPk;
        }   
        
  
            
        
        /**
            * This method is used for loading Instrument Details popup module
           * 
            */
        public static function showInstrumentDetails(instrumentPk : String,parentApplication:UIComponent):void {
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(parentApplication),SummaryPopup,false));
            
            sPopup.title = "Security/CCY Details";
            sPopup.width = parentApplication.width - 100;
            sPopup.height = parentApplication.height - 100;

            PopUpManager.centerPopUp(sPopup);
            
            sPopup.moduleUrl = Globals.INSTRUMENT_SUMMARY_SWF+Globals.QS_SIGN+Globals.INSTRUMENT_PK+Globals.EQUALS_SIGN+instrumentPk;
        }
        
        /**
         * This method is used for loading Bloomberg Details popup module
         * 
         */
        public static function showBloombergDetails(bbUniqueId : String,exchangeMrkt:String, parentApplication:UIComponent):void {
            var sPopup : SummaryPopup;
            sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(parentApplication),SummaryPopup,false));
            
            sPopup.title = "Detailed Information";
            sPopup.width = parentApplication.width - 100;
            sPopup.height = parentApplication.height - 100;
            PopUpManager.centerPopUp(sPopup);
            
            //sPopup.moduleUrl = Globals.BLOOMBERG_DETAILS_SWF+Globals.QS_SIGN+Globals.BB_UNIQUE_ID+Globals.EQUALS_SIGN+bbUniqueId;
            sPopup.moduleUrl = Globals.BLOOMBERG_DETAILS_SWF+Globals.QS_SIGN+Globals.BB_UNIQUE_ID+Globals.EQUALS_SIGN+bbUniqueId+Globals.AND_SIGN
                                   + Globals.EXCH_CODE+Globals.EQUALS_SIGN+exchangeMrkt;
        }
        
        /**
         * This method is used for loading FinInstPopUp module 
         * 
         */
        public static function showFinInstDetails(finInstPk : String,parentApplication:UIComponent):void {
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
            
            sPopup.title = "Financial Institution Details";
            sPopup.width = parentApplication.width - 100;
            sPopup.height = parentApplication.height - 100;
            /* sPopup.horizontalScrollPolicy="off";
            sPopup.verticalScrollPolicy="off"; */
            PopUpManager.centerPopUp(sPopup);
            sPopup.moduleUrl = Globals.FININST_DETAILS_SWF+Globals.QS_SIGN+Globals.FININST_PK+Globals.EQUALS_SIGN+finInstPk;        
        }
        /**
         * This method is used for loading Fund Code popup module
         * 
         */  
         public static function showFundCodeDetails(fundPk : String,parentApplication:UIComponent):void{
             var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
            
            sPopup.title = "Fund Details";
            sPopup.width = parentApplication.width - 200;
            sPopup.height = parentApplication.height - 150;
            PopUpManager.centerPopUp(sPopup);            
            sPopup.moduleUrl = Globals.FUND_DETAILS_SWF+Globals.QS_SIGN+Globals.FUND_PK+Globals.EQUALS_SIGN+fundPk;
             
         }

         /**
            * This method is used for loading Settlement Details popup module
            * 
            */  
        public static function showSettlementDetails(settlementPk:String, parentApplication:UIComponent,strHeader:String,viewMode:String=null):void {
            
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
            sPopup.title = strHeader;
            sPopup.width = 700;
            sPopup.height = 445;
            PopUpManager.centerPopUp(sPopup);
            
            sPopup.moduleUrl = Globals.SETTLEMENT_DETAILS_SWF+Globals.QS_SIGN+Globals.SETTLEMENT_INFO_PK+Globals.EQUALS_SIGN+settlementPk;
            if(viewMode != null){
                sPopup.moduleUrl = sPopup.moduleUrl + Globals.AND_SIGN + Globals.VIEW_MODE + Globals.EQUALS_SIGN + viewMode;
                //XenosAlert.info("moduleUrl :: "+sPopup.moduleUrl);
            }
            //XenosAlert.info("ModuleUrl :: "+sPopup.moduleUrl+"  "+viewMode);
        }
        
        /**
            * This method is used for loading Settlement History Details popup module
            * 
            */  
        public static function showSettlementHistoryDetails(settlementHistoryPk : String, parentApplication:UIComponent,strHeader:String):void {
            
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
            
            sPopup.title = strHeader;
            sPopup.width = 780;
            sPopup.height = 320;
            PopUpManager.centerPopUp(sPopup);
            
            sPopup.moduleUrl = Globals.SETTLEMENT_HISTORY_DETAILS_SWF+Globals.QS_SIGN+Globals.SETTLEMENT_DETAIL_HISTORY_PK+Globals.EQUALS_SIGN+settlementHistoryPk;
        }
        
        /**
            * This method is used for loading Cam Security Details popup module
            * 
            */  
        public static function showCamSecurityDetails(camEntryPk : String, parentApplication:UIComponent):void {
            
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
            
            sPopup.title = "NAM - Security Detail";
            sPopup.width = 800;
            sPopup.height = 430;
            PopUpManager.centerPopUp(sPopup);
            
            sPopup.moduleUrl = Globals.CAM_SECURITY_DETAILS_SWF+Globals.QS_SIGN+Globals.CAM_ENTRY_PK+Globals.EQUALS_SIGN+camEntryPk;
            //XenosAlert.info("Module URL :: "+sPopup.moduleUrl);
        }
        /**
         * 
         */
        public static function showCaxRightsDetails(rightsDetailPk : String, parentApplication:UIComponent, stlRefNo : String = null, slrRefNo:String=null):void {
            
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
            
            sPopup.title = "Entitlements Detail View";
            sPopup.width = 830;
            sPopup.height = 550;
            PopUpManager.centerPopUp(sPopup);
            
            sPopup.moduleUrl = Globals.CAX_RIGHTS_DETAILS_SWF+Globals.QS_SIGN+    
                                Globals.RIGHTS_DETAIL_PK+Globals.EQUALS_SIGN+rightsDetailPk+Globals.AND_SIGN+
                                Globals.STL_REF_NO+Globals.EQUALS_SIGN+stlRefNo+Globals.AND_SIGN+
                                Globals.SLR_REF_NO+Globals.EQUALS_SIGN+slrRefNo;
            
            
        }
        
        /**
         * 
         */
        public static function showCaxExerciseDetails(rightsExercisePk : String, parentApplication:UIComponent, stlRefNo : String = null, slrRefNo:String=null):void {
            
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
            
            sPopup.title = "Exercise Detail View";
            sPopup.width = 830;
            sPopup.height = 350;
            PopUpManager.centerPopUp(sPopup);
            
            sPopup.moduleUrl = Globals.CAX_RIGHTS_EXERCISE_SWF+Globals.QS_SIGN+    
                                Globals.RIGHTS_EXERCISE_PK+Globals.EQUALS_SIGN+rightsExercisePk;
            
            
        }
        public static function showCaxRightsConditionDetails(rightsConditionPk : String, parentApplication:UIComponent):void {
            
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
            
            sPopup.title = "Corporate Action Events View";
            sPopup.width = parentApplication.width - 100;  
            sPopup.height = parentApplication.height - 125;
            PopUpManager.centerPopUp(sPopup);
            
            sPopup.moduleUrl = Globals.RIGHTS_CONITION_QUERY_DETAILS_SWF+Globals.QS_SIGN+Globals.RIGHTS_CONDITION_PK+Globals.EQUALS_SIGN+rightsConditionPk;
            //XenosAlert.info("Module URL :: "+sPopup.moduleUrl);
        }
        public static function showTrdTradeDetails(trade_pk : String, parentApplication:UIComponent):void {
            
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
            
            sPopup.title = "Trade Detail";
            sPopup.width = 780;
            sPopup.height = 400;
            PopUpManager.centerPopUp(sPopup);
            
            sPopup.moduleUrl = Globals.TRADE_DETAILS_SWF+Globals.QS_SIGN+Globals.TRADE_PK+Globals.EQUALS_SIGN+trade_pk;
            //XenosAlert.info("Module URL :: "+sPopup.moduleUrl);
        }
        public static function showNcmAdjustmentDetails(ncmEntryPk : String, parentApplication:UIComponent):void {
            
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
            
            sPopup.title = "Adjustment Detail";
            sPopup.width = 780;
            sPopup.height = 400;
            PopUpManager.centerPopUp(sPopup);
            
            sPopup.moduleUrl = Globals.ADJUSTMENET_QRY_DETAILS_SWF+Globals.QS_SIGN+Globals.NCM_ENTRY_PK+Globals.EQUALS_SIGN+ncmEntryPk;
            //XenosAlert.info("Module URL :: "+sPopup.moduleUrl);
        }
        
        public static function showEmployeeDetails(employeePk : String, parentApplication:UIComponent):void {
            
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
            
            sPopup.title = "Employee Detail";
            sPopup.width = 780;
            sPopup.height = 520;
            PopUpManager.centerPopUp(sPopup);
            
            sPopup.moduleUrl = Globals.EMPLOYEE_QRY_DETAILS_SWF + Globals.QS_SIGN+Globals.EMPLOYEE_PK + Globals.EQUALS_SIGN+employeePk;
            //XenosAlert.info("Module URL :: "+sPopup.moduleUrl);
        }
        /**
	   	 * This method is used for loading Order Datail Summary popup module
	   	 * 
	   	 */
		public static function showOrderSummary(orderPk : String,orderRefNo : String,parentApplication:UIComponent, prefix:String = null):void {
			
			var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
			
			sPopup.title = "Order Details";
			sPopup.width = 620;
    		sPopup.height = 390;
			PopUpManager.centerPopUp(sPopup);
			if(prefix == null)
				sPopup.moduleUrl = Globals.ORDER_SUMMARY_SWF+Globals.QS_SIGN+Globals.ORDER_PK+Globals.EQUALS_SIGN+orderPk+Globals.AND_SIGN+ Globals.ORDER_REF_NO+Globals.EQUALS_SIGN+orderRefNo;
			else
				sPopup.moduleUrl = Globals.ORDER_SUMMARY_SWF+Globals.QS_SIGN+Globals.ORDER_PK+Globals.EQUALS_SIGN+orderPk+Globals.AND_SIGN+ Globals.ORDER_REF_NO+Globals.EQUALS_SIGN+orderRefNo+ Globals.AND_SIGN+ "prefix"+Globals.EQUALS_SIGN+prefix;
		}
		/**
	   	 * This method is used for loading Order Execution Datail Summary popup module
	   	 * 
	   	 */
		public static function showExecutionSummary(executionPk : String,executionRefNo : String,parentApplication:UIComponent, prefix:String = null):void {
			
			var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
			
			sPopup.title = "Execution Details";
			sPopup.width = 620;
    		sPopup.height = 410;
			PopUpManager.centerPopUp(sPopup);
			if(prefix == null)
				sPopup.moduleUrl = Globals.EXECUTION_SUMMARY_SWF+Globals.QS_SIGN+Globals.EXECUTION_PK+Globals.EQUALS_SIGN+executionPk+Globals.AND_SIGN+ Globals.EXECUTION_REF_NO+Globals.EQUALS_SIGN+executionRefNo;
			else
				sPopup.moduleUrl = Globals.EXECUTION_SUMMARY_SWF+Globals.QS_SIGN+Globals.EXECUTION_PK+Globals.EQUALS_SIGN+executionPk+Globals.AND_SIGN+ Globals.EXECUTION_REF_NO+Globals.EQUALS_SIGN+executionRefNo+Globals.AND_SIGN+"prefix"+Globals.EQUALS_SIGN+prefix;
		}
        /**
            * This method is used for loading Document Summary  popup module
            * 
            */
        public static function showDocumentSummary(legalAgreementPk : String,parentApplication:UIComponent):void {
            
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
            
            sPopup.title = "Document Summary";
        
            sPopup.width = 620;
            sPopup.height = 330;
            PopUpManager.centerPopUp(sPopup);
            
            sPopup.moduleUrl = Globals.DOCUMENT_ATTRIBUTES_DETAILS_SWF+Globals.QS_SIGN+Globals.LEGAL_AGREEMENT_PK+Globals.EQUALS_SIGN+legalAgreementPk;
        }
        
        /**
            * This method is used for loading Document Action Summary  popup module
            * 
            */
        public static function showDocumentActionSummary(accountAgreementPkStr : String,hiddenAccountNo : String,accountNo : String, mode : String, parentApplication:UIComponent):void {
            
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
            sPopup.title = "Document Action Summary";
            sPopup.width = 840;
            sPopup.height = 550;
            PopUpManager.centerPopUp(sPopup);
            sPopup.moduleUrl = Globals.DOCUMENT_ACTION_DETAILS_SWF+Globals.QS_SIGN+Globals.ACCOUNT_AGREEMENT_PK_STR+Globals.EQUALS_SIGN+accountAgreementPkStr+
            Globals.AND_SIGN+Globals.HIDDEN_ACCOUNT_NO+Globals.EQUALS_SIGN+hiddenAccountNo+Globals.AND_SIGN+Globals.ACCOUNT_NO+Globals.EQUALS_SIGN+accountNo
            +Globals.AND_SIGN+Globals.MODE+Globals.EQUALS_SIGN+mode;
        }
        
        /**
            * This method is used for loading Intra Recon Summary  popup
            * 
            */
        public static function showIntraReconSummary(intraReconPk : String,method : String,reportName : String,reportId : String,parentApplication:UIComponent):void {
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
            sPopup.title = "Intra Recon Details";
            sPopup.width = 840;
            sPopup.height = 250;
            PopUpManager.centerPopUp(sPopup);
            sPopup.moduleUrl = Globals.INTRA_RECON_QUERY_DETAILS_SWF+Globals.QS_SIGN+Globals.INTRA_RECON_PK_STR+Globals.EQUALS_SIGN+intraReconPk+
            Globals.AND_SIGN+Globals.METHOD+Globals.EQUALS_SIGN+method+Globals.AND_SIGN+Globals.REPORT_NAME+Globals.EQUALS_SIGN+reportName
            +Globals.AND_SIGN+Globals.REPORT_ID+Globals.EQUALS_SIGN+reportId; //+ "&SCREEN_KEY=933"
        }
        
        /**
            * This method is used for loading Fail Balance Summary popup
            * 
            */
        public static function showFailBalanceDetails(fundPk : String, ccy : String, dateFrom : String, 
                                                      bankPk : String, bankAccPk : String, drFlag : String,
                                                      parentApplication : UIComponent):void {
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication, SummaryPopup, false));
            sPopup.title = "Fail Balance Details";
            sPopup.width = 720;
            sPopup.height = 460;
            PopUpManager.centerPopUp(sPopup);
            sPopup.moduleUrl = Globals.FAIL_BALANCE_QUERY_DETAILS_SWF+Globals.QS_SIGN+Globals.FUND_CODE+
                           Globals.EQUALS_SIGN+fundPk+Globals.AND_SIGN+Globals.CURRENCY+Globals.EQUALS_SIGN+
                           ccy+Globals.AND_SIGN+
                           Globals.DATE_FROM+Globals.EQUALS_SIGN+dateFrom+Globals.AND_SIGN+Globals.BANK_CODE+
                           Globals.EQUALS_SIGN+bankPk+Globals.AND_SIGN+Globals.BANK_ACCOUNT_NO+
                           Globals.EQUALS_SIGN+bankAccPk+Globals.AND_SIGN+Globals.DR_FLAG+Globals.EQUALS_SIGN+drFlag;
        }
        /**
         * This method is used for loading Receive Notice Detail popup
         */
         public static function showReceiveNoticeDetail(receivedCompNoticeInfoPk : String, parentApplication:UIComponent):void{
             var sPopup : SummaryPopup;    
             sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
             sPopup.title = "Receive Notice Detail Query Result Summary";
             sPopup.width = 840;
             sPopup.height = 550;
             PopUpManager.centerPopUp(sPopup);
             sPopup.moduleUrl = Globals.RECEIVED_NOTICE_DETAIL_SWF+Globals.QS_SIGN+Globals.RECEIVED_COMP_NOTICE_INFO_PK+Globals.EQUALS_SIGN+receivedCompNoticeInfoPk;
         }
		/**
		 * 
		 */ 
		public static function showOrderEntryErrors(parentApplication:UIComponent):void {
			
			var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
			
			sPopup.title = "Order Entry Upload Errors";
        	sPopup.width = 620;
        	sPopup.height = 400;
        	PopUpManager.centerPopUp(sPopup);		
        	
        	sPopup.moduleUrl = Globals.ORDER_ENTRY_ERRORS_POPUP; //OrderEntryErrorsPopup;
        	//sPopup.moduleUrl = "assets/appl/oms/OrderMessageSummary.swf";
		}
		
        /**
         * This method is used for loading Cash Management Summary
         */
        public static function showCashManagementSummaryPopup(fundCode : String, ccy : String, 
                                                      	 parentApplication : UIComponent):void {
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication, SummaryPopup, false));
            sPopup.title = "Cash Management Summary";
            sPopup.width = 900;
            sPopup.height = 250;
            PopUpManager.centerPopUp(sPopup);
            sPopup.moduleUrl = Globals.CASH_MANAGEMENT_SUMMARY_SWF+Globals.QS_SIGN+Globals.FUND_CODE+
                           	   Globals.EQUALS_SIGN+fundCode+Globals.AND_SIGN+Globals.CURRENCY+
                           	   Globals.EQUALS_SIGN+ccy;
        }
        /**
         * This method is used for loading Receive Notice Detail popup
         */
        public static function showCaxReceiveNoticeDetail(receivedCompNoticeInfoPk : String, parentApplication:UIComponent):void{
            var sPopup : SummaryPopup;    
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
            sPopup.title = "CA Receive Notice Detail";
            sPopup.width = 840;
            sPopup.height = 500;
            PopUpManager.centerPopUp(sPopup);
            sPopup.moduleUrl = Globals.CAX_RECEIVED_NOTICE_DETAIL_SWF+Globals.QS_SIGN+
                               Globals.RECEIVED_COMP_NOTICE_INFO_PK+Globals.EQUALS_SIGN+
                               receivedCompNoticeInfoPk + Globals.AND_SIGN + "mode" + 
                               Globals.EQUALS_SIGN + "view";;
        }
        
        /**
         * This method is used for loading Transaction Details Popup
         */       
        public static function showTransactionDetails(transactionPk:String, commandFormId:String, parentApplication:UIComponent, title:String):void {
            var sPopup : SummaryPopup;	
    		sPopup= SummaryPopup(PopUpManager.createPopUp(parentApplication,SummaryPopup,false));
    		
    		sPopup.title = title;
            //set the width and height of the popup
            sPopup.width = parentApplication.width - 100;
    		sPopup.height = parentApplication.height - 100;
 
    		sPopup.horizontalScrollPolicy="auto";
    		sPopup.verticalScrollPolicy="auto";
    		PopUpManager.centerPopUp(sPopup);
           
    		sPopup.moduleUrl = Globals.FAM_TRANSACTION_DETAILS_SWF + Globals.QS_SIGN + Globals.TRANSACTION_PK + Globals.EQUALS_SIGN 
    						   + transactionPk + Globals.AND_SIGN + Globals.COMMAND_FORM_ID + Globals.EQUALS_SIGN + commandFormId;
        }
		
    }
}