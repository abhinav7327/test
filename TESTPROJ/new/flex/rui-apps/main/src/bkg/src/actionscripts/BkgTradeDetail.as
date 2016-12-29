
// ActionScript file

 // ActionScript file for Trade Query
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.containers.SummaryPopup;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    
    import mx.collections.ArrayCollection;
    import mx.collections.XMLListCollection;
    import mx.core.Application;
    import mx.core.UIComponent;
    import mx.managers.PopUpManager;
    import mx.rpc.events.ResultEvent;
    
    [Bindable]
    //private var initColl:ArrayCollection;
    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var queryResult:XML= new XML();
    //private var emptyResult:ArrayCollection= new ArrayCollection();
   // private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    
    [Bindable]
    private var taxFeeResult:XMLListCollection= new XMLListCollection();
    [Bindable]
    private var settlementHistoryResult:ArrayCollection= new ArrayCollection();
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    public var o:Object = {};
    
    [Bindable]
    public var bkgTradePk:String;
    [Bindable]
    public var path:String;
    [Bindable]
    public var viewMode:String;
    	   
            
    public function parseUrlString():void {
        try {
            // Remove everything before the question mark, including
            // the question mark.
            var myPattern:RegExp = /.*\?/; 
            var s:String = this.loaderInfo.url.toString();
            s = s.replace(myPattern, "");
            // Create an Array of name=value Strings.
            var params:Array = s.split("&"); 
             // Print the params that are in the Array.
            var keyStr:String;
            var valueStr:String;
            var paramObj:Object = params;
          
            // Set the values of the salutation.
            for (var i:int = 0; i < params.length; i++) {
                var tempA:Array = params[i].split("=");  
                if (tempA[0] == "bkgTradePk") {
                    o.bkgTradePk = tempA[1];
                    bkgTradePk = o.bkgTradePk;
                } 
                
                
                
            } 
            
        } catch (e:Error) {
            trace(e);
        }
       
    }
     
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    public function LoadResultPage(event:ResultEvent):void {
    	//var xmlData:XML = new XML();
    	if (null != event) {            
            if(null == event.result){
                //queryResult.removeAll(); // clear previous data if any as there is no result now.
            	if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
            	  //  errPage.clearError(event); //clears the errors if any
            		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            	} else { // Must be error
            		//errPage.displayError(event);	
            	}            	
            }else {
	            
	             	queryResult = event.result as XML;
	            	//taxFeeResult = queryResult.tradeEntryActionForm.taxFeeAmounts.taxFeeAmount as XMLListCollection; 
	            	 //settlementHistoryResult = event.result.stlQueryActionForm.detailView.completionHistoryDetailsList.completionHistoryDetails  as ArrayCollection; 
	            	//XenosAlert.info("stlHistory :: "+settlementHistoryResult.getItemAt(0));
            } 
        }else {
            //queryResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }
    }
   
   private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
         reqObj.bankingTradePk = bkgTradePk;
         return reqObj;
    }
    
    private function showSettlementInfo():void{
			
			var sPopup : SummaryPopup;
            var parentApp :UIComponent = UIComponent(this.parentApplication);
            
            var bankingTradePk:String = queryResult.bkgTrdData.bkgTradePk;
            var tradePkBelongsTo:String = queryResult.bkgTrdData.bkgTradeBelongsToPk;
            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
            sPopup.title = Application.application.xResourceManager.getKeyValue('bkg.settle.resultsummary.label');
            sPopup.width = 780;
            sPopup.height = 400;
            PopUpManager.centerPopUp(sPopup);

           //sPopup.moduleUrl = Globals.SETTLEMENT_QUERY_POPUP_SUMMARY_TRADE+Globals.QS_SIGN+Globals.PATH+Globals.EQUALS_SIGN+"TRADE"+Globals.AND_SIGN+Globals.DRV_TRADE_PK+Globals.EQUALS_SIGN+bankingTradePk+Globals.AND_SIGN+Globals.SETTLEMENT_FOR+Globals.EQUALS_SIGN+"DEPO";
           sPopup.moduleUrl = "assets/appl/stl/SettlementQueryPopupSummaryForTrade.swf?path=TRADE&startLegPk="+tradePkBelongsTo+"&endLegPk="+bankingTradePk+"&settlementFor=DEPO";
	
	}
     		