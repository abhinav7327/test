// ActionScript file

 // ActionScript file for Trade Query
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    
    import mx.collections.ArrayCollection;
    import mx.rpc.events.ResultEvent;
    

    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var xmlSource:XML= new XML();

    private var initCompFlg : Boolean = false;
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
    public var lblAccNo:String;
    [Bindable]
    public var lblReferanceNo:String;
    [Bindable]
    public var valReferanceNo:String;

    
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
        
    [Bindable]
    public var rightsDetailPk:String;

    [Bindable]
    private var queryResult:ArrayCollection= new ArrayCollection();
    	   

    [Bindable]
    public var stlRefNo:String;	   
    [Bindable]
    public var slrRefNo:String;	 
            
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
                if (tempA[0] == Globals.RIGHTS_DETAIL_PK) {
                  //  o.rightsDetailPk = tempA[1];
                    rightsDetailPk = tempA[1];
                } 
                if (tempA[0] == Globals.STL_REF_NO) {
                  //  o.rightsDetailPk = tempA[1];
                    stlRefNo = tempA[1];
                }
                if (tempA[0] == Globals.SLR_REF_NO) {
                 //   o.rightsDetailPk = tempA[1];
                    slrRefNo = tempA[1];
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
	            
	             	xmlSource = event.result as XML;
	            	//taxFeeResult = queryResult.tradeEntryActionForm.taxFeeAmounts.taxFeeAmount as XMLListCollection; 
	            	 //settlementHistoryResult = event.result.stlQueryActionForm.detailView.completionHistoryDetailsList.completionHistoryDetails  as ArrayCollection; 
	            	//XenosAlert.info("stlHistory :: "+settlementHistoryResult.getItemAt(0));
	            	setLabel ();
	            	settlementDetails()
            } 
        }else {
            //queryResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }
    }
   
   private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
         reqObj.rightsDetailPk = rightsDetailPk;
         reqObj.slrRefNo = slrRefNo;
         reqObj.StlRefNo = stlRefNo;
         
         return reqObj;
    }
  private function setLabel():void{
  	var detailType:String = xmlSource.detailType;
  	var corporateActionId:String = xmlSource.detailType;
  	/*if (detailType =="NCM_RIGHTS_DETAIL"){
  		lblAccNo = this.parentApplication.xResourceManager.getKeyValue('cax.rightsdetail.label.bankaccountno');
  	}else if(detailType =="RIGHTS_DETAIL"){
  		lblAccNo = this.parentApplication.xResourceManager.getKeyValue('cax.rightsdetail.label.fundaccountno');
  	}else if(detailType =="NCM_RIGHTS_DETAIL"){
  		lblAccNo =this.parentApplication.xResourceManager.getKeyValue('cax.rightsdetail.label.accountno');
  		
  	}*/
  	if(detailType =="REPO_TRACKING"||detailType =='REVERSE_REPO_TRACKING'){
  		lblReferanceNo = this.parentApplication.xResourceManager.getKeyValue('cax.rightsdetail.label.slractionrefno');
  	}else if(detailType =="FAIL_TRACKING"||detailType =='INTERIM_ACCOUNTING'){
  		lblReferanceNo = this.parentApplication.xResourceManager.getKeyValue('cax.rightsdetail.label.settlementrefno');
  		
  	}
  	/*if (xmlSource.settlementInfoReqd=="true"){
  		button.visible = true;
  		button.includeInLayout = true;
  		
  	}*/

  }		
 private function settlementDetails():void{
 	var detailType:String = xmlSource.detailType;
 	var clientSttlementPk:String = xmlSource.clientSttlementPk;
 	if(detailType =="REPO_TRACKING"||detailType =='REVERSE_REPO_TRACKING'){
 		valReferanceNo =xmlSource.slrActionReferenceNo;
 	}else if(detailType =="FAIL_TRACKING"||detailType =='INTERIM_ACCOUNTING'){
 		valReferanceNo =xmlSource.settlementReferenceNo;
 		
 	}

 	
 }
private function showSettlementInfo():void{
	 
   		    var sPopup : SummaryPopup;	
			var parentApp :UIComponent = UIComponent(this.parentApplication);
            var rightsDetailPk:String = xmlSource.rightsDetailPk;
            var eventType:String = xmlSource.corporateActionId;
			sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
			sPopup.title = this.parentApplication.xResourceManager.getKeyValue('cax.stl.query.result.summary');
			sPopup.width = 780;
    		sPopup.height = 400;
			PopUpManager.centerPopUp(sPopup);
			
			sPopup.moduleUrl = Globals.SETTLEMENT_QUERY_POPUP_SUMMARY_TRADE+Globals.QS_SIGN+Globals.PATH+Globals.EQUALS_SIGN+"TRADE"+Globals.AND_SIGN+Globals.DRV_TRADE_PK+Globals.EQUALS_SIGN+rightsDetailPk+Globals.AND_SIGN+Globals.SETTLEMENT_FOR+Globals.EQUALS_SIGN+"CORPORATE_ACTION"+Globals.AND_SIGN+Globals.EVENT_TYPE+Globals.EQUALS_SIGN+eventType;
			//XenosAlert.info("Module URL :: "+sPopup.moduleUrl); 	
}
   /*  public function LoadStlResultPage(event:ResultEvent):void {
    	if (null != event) {            
            if(null == event.result.rows){
                queryResult.removeAll(); // clear previous data if any as there is no result now.
            	if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
            	    
            		XenosAlert.info("No Result Found!");
            	}            	
            }else {
            	  
 
	                    queryResult.removeAll();
	                    queryResult.addItem(event.result.rows.row);
	                    var sPopup : SummaryPopup;
			            var parentApp :UIComponent = UIComponent(this.parentApplication);
			           // var rightsDetailPk:String = xmlSource.rightsDetailPk;
			            var rightsDetailPk:String ="709358";
			            sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
			            sPopup.title = "Settlement Query Result Summary";
			            sPopup.width = 780;
    		            sPopup.height = 400;
			            PopUpManager.centerPopUp(sPopup);
			
			           sPopup.moduleUrl = Globals.SETTLEMENT_QUERY_POPUP_SUMMARY_TRADE+Globals.QS_SIGN+Globals.PATH+Globals.EQUALS_SIGN+"TRADE"+Globals.AND_SIGN+Globals.DRV_TRADE_PK+Globals.EQUALS_SIGN+rightsDetailPk+Globals.AND_SIGN+Globals.SETTLEMENT_FOR+Globals.EQUALS_SIGN+"CORPORATE_ACTION";	                         
	               
	              
	             
	              if(queryResult[0]==null){			             	
		            queryResult.removeAll();
		            XenosAlert.info("No Results Found");
		            return;
	             }
	
            
            } 
        }else {
            queryResult.removeAll();
            XenosAlert.info("No Results Found");
        }
    } */
