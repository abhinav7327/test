
// ActionScript file

 // ActionScript file for Trade Query
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.containers.SummaryPopup;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    
    import mx.collections.ArrayCollection;
    import mx.collections.XMLListCollection;
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
    public var employeePk:String;
    [Bindable]
    public var path:String;
    [Bindable]
    public var viewMode:String;
    [Bindable]
    public var empApplicationRolesList:ArrayCollection = new ArrayCollection();
    
    	   
            
    
     
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
        if (queryResult.employeeHistoryInfoList.employeeHistoryInfoList is ArrayCollection){
        	empApplicationRolesList = queryResult.employeeHistoryInfoList.employeeHistoryInfoList as ArrayCollection;
        }else{
        	empApplicationRolesList.addItem(queryResult.employeeHistoryInfoList.employeeHistoryInfoList);
        }
        
        
    }
   
    
     		

