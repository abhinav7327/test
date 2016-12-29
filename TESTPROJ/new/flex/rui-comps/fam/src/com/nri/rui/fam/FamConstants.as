package com.nri.rui.fam
{
	public final class FamConstants
	{
		public function FamConstants()
		{
		}
		//Can be movementInfoPk or cashMovementInfoPk or drvMovementInfoPk
        public static const FAM_MOVEMENT_PK:String = "movementPk";
        
        // Can be OnBalance, Cash, Drv , AdjustmentIncome
        public static const MOVEMENT_TYPE:String = "movementType";
        
        // OnBalance Movement
        public static const MOVEMENT_TYPE_ONBALANCE:String = "ON_BALANCE";
        
        // Cash Movement 
        public static const MOVEMENT_TYPE_CASH:String = "CASH_AND_MARGIN";
        
        // Drv Movement
        public static const MOVEMENT_TYPE_DRV:String = "DERIVATIVES";
		
		 // Adjustment Income  Movement 
        public static const MOVEMENT_TYPE_AJUSTMENT_INCOME:String = "ADJUSTMENT_INCOME";
		
		// Receivable Income  Movement 
        public static const MOVEMENT_TYPE_RECEIVABLE_INCOME_BALANCE:String = "RECEIVABLE_INCOME_BALANCE";
		       
        // Journal Currency
        public static const JOURNAL_TYPE:String = "journalType";
        
        //Local Currency
        public static const CURRENCY_CATEGORY_LC:String  = "LC";

	    // Base Currency
	    public static const CURRENCY_CATEGORY_BC :String = "BC";
	    
	    // Debit Credit Flag for Journal Details
	    public static const DEBIT_CREDIT_FLAG :String = "debitCreditFlag";
	   
	    // Debit value for Journal Details
        public static const DEBIT_FLAG :String = "D";
        
        // Credit value for Journal Details
        public static const CREDIT_FLAG :String = "C";
       
        //Journal PK
        public static const JOURNAL_PK:String = "journalPk";
        
        //Transaction PK
        public static const TRANSACTION_PK:String = "transactionPk";
        
        //PAYABLE_MGMT_FEE Voucher Type
        public static const PAYABLE_MGMT_FEE:String = "PAYABLE_MGMT_FEE";
        
        //ACCRUED_INTEREST_ADJUST Voucher Type
        public static const ACCRUED_INTEREST_ADJUST:String = "ACCRUED_INTEREST_ADJUST";
                
        //RECEIVABLE_DIV_INCOME_ADJUST Voucher Type
        public static const RECEIVABLE_DIV_INCOME_ADJUST:String = "RECEIVABLE_DIV_INCOME_ADJUST";
        
        //OTHER_PAY_EXPENSE Voucher Type
        public static const OTHER_PAY_EXPENSE:String = "OTHER_PAY_EXPENSE";
        
        //ACCRUED_INTEREST_PAID_ADJUST Voucher Type
        public static const ACCRUED_INTEREST_PAID_ADJUST:String = "ACCRUED_INTEREST_PAID_ADJUST";
        
        //SuspendedTransaction PK
        public static const SUSPENDED_TRANSACTION_PK:String = "suspendedTransactionPk";
        
        //BKG_DETAILS_SWF
        public static const BKG_DETAILS_SWF:String = "assets/appl/bkg/BkgTradeDetail.swf";
        
        //BKG_TRADE_PK
        public static const BKG_TRADE_PK:String = "bkgTradePk";
        
        //FRX_DETAILS_SWF
        public static const FRX_DETAILS_SWF:String = "assets/appl/frx/FrxTradeDetail.swf";
        
        //FRX_TRADE_PK
        public static const FRX_TRADE_PK:String = "frxTradePk";
        
        //DRV_DETAILS_SWF
        public static const DRV_DETAILS_SWF:String = "assets/appl/drv/TradeDetailView.swf";
        
     	//DRV_TRADE_PK
        public static const DRV_TRADE_PK:String = "tradePk";
        
    	public static const TRANSACTION_TYPE_TRANSACTION_CLOSE:String = "TRANSACTION_CLOSE";
		
		// The Transaction Type VOUCHER
		public static const TRANSACTION_TYPE_VOUCHER:String = "VOUCHER";
		// The Transaction Type CAM_CASH_DIVIDEND
		public static const TRANSACTION_TYPE_CAM_CASH_DIVIDEND:String = "CAM_CASH_DIVIDEND";
		// The Transaction Type COMP_STL_CAX_CASH_DIVIDEND
		public static const TRANSACTION_TYPE_COMP_STL_CAX_CASH_DIVIDEND:String = "COMP_STL_CAX_CASH_DIVIDEND";
        
	}
}