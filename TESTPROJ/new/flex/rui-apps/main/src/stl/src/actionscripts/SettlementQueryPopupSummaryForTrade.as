// ActionScript file

 // ActionScript file for Trade Query
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.containers.SummaryPopup;
    import com.nri.rui.core.controls.CustomizeSortOrder;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.ref.popupImpl.CustomerPopUpHbox;
    import com.nri.rui.ref.popupImpl.FinInstitutePopUpHbox;
    
    import mx.collections.ArrayCollection;
    import mx.core.UIComponent;
    import mx.events.ResourceEvent;
    import mx.managers.PopUpManager;
    import mx.resources.ResourceBundle;
    import mx.rpc.events.ResultEvent;
    
    
    [Bindable]
    private var initColl:ArrayCollection;
    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var queryResult:ArrayCollection= new ArrayCollection();
    private var emptyResult:ArrayCollection= new ArrayCollection();
    private var rndNo:Number = 0;
    private var initCompFlg : Boolean = false;
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
    private var finInst:FinInstitutePopUpHbox = new FinInstitutePopUpHbox();
    [Bindable]
    private var customerPopup:CustomerPopUpHbox = new CustomerPopUpHbox();
    
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
    
    private var  csd:CustomizeSortOrder=null;
    public var o:Object = {};
    
    [Bindable]
    public var tradePk:String;
    [Bindable]
    public var startLegPk:String;
    [Bindable]
    public var endLegPk:String;
    [Bindable]
    public var path:String;
    [Bindable]	   
    public var settlementFor:String
    [Bindable]
    public var eventType:String;
            
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
                if (tempA[0] == Globals.DRV_TRADE_PK) {
                    o.tradePk = tempA[1];
                    tradePk = o.tradePk;
                } else if (tempA[0] == Globals.PATH) {
                    o.path = tempA[1];
                    path = o.path;
                } else if (tempA[0] == Globals.SETTLEMENT_FOR) {
                    o.settlementFor = tempA[1];
                    settlementFor = o.settlementFor;
                } else if (tempA[0] == Globals.START_LEG_PK) {
                    o.startLegPk = tempA[1];
                    startLegPk = o.startLegPk;
                } else if (tempA[0] == Globals.END_LEG_PK) {
                    o.endLegPk = tempA[1];
                    endLegPk = o.endLegPk;
                } else if (tempA[0] == Globals.EVENT_TYPE) {
                    o.eventType = tempA[1];
                    eventType = o.eventType;
                }
            } 
        } catch (e:Error) {
            trace(e);
        }
    }
 
    private function populateRequestParams():Object {
    	var reqObj : Object = new Object();
    	
    	reqObj.tradePk = tradePk;
    	reqObj.path = path;
    	reqObj.settlementFor = settlementFor;
    	reqObj.startLegPk = startLegPk;
    	reqObj.endLegPk = endLegPk;
    	reqObj.eventType = eventType;
    	
    	return reqObj;
    }
	
    private function loadAll():void {    	
    	submitQuery();
    }
    
    public function submitQuery():void{
    	parseUrlString();   	
     	//Set the request parameters
     	var requestObj :Object = populateRequestParams();
     	
     	settlementQueryRequest.request = requestObj; 
     	settlementQueryRequest.send(); 
    }
       
    /**
    * This method works as the result handler of the Submit Query Http Services.
    * 
    */
    public function LoadResultPage(event:ResultEvent):void {
    	
    	var rs:XML = XML(event.result);

		if (null != event) {
			if(rs.child("row").length()>0) {
				queryResult.removeAll();
				try {
					for each ( var rec:XML in rs.row ) {
						queryResult.addItem(rec);
					}
					
	             	if(queryResult.length == 1) {
						displayDetailView(queryResult[0].settlementInfoPk);
					}
				} catch(e:Error) {
					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				}
			} else {
				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				queryResult.removeAll(); // clear previous data if any as there is no result now.
			}
		} else {
			queryResult.removeAll();
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		}
    }
    
    /**
    * This method for Detail View
    */
    private function displayDetailView(stlPkStr:String):void{
    		
			var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
			
			sPopup.title = this.parentApplication.xResourceManager.getKeyValue('stl.stlqry.label.settlementviewheader');
			sPopup.width = 650;
    		sPopup.height = 420;
			PopUpManager.centerPopUp(sPopup);		
			//var tradePkStr : String = queryResult.tradePk;
			sPopup.moduleUrl = Globals.SETTLEMENT_DETAILS_SWF+Globals.QS_SIGN+Globals.SETTLEMENT_INFO_PK+Globals.EQUALS_SIGN+stlPkStr+Globals.AND_SIGN+Globals.VIEW_MODE+Globals.EQUALS_SIGN+"Settlement";
			
    }
    

    

        
    /**
	 * This method should be called on creationComplete of the datagrid 
	 */ 
/* 	 private function bindDataGrid():void {
		qh.dgrid = settlementQueryResult;
	}  */ 
   /**
    * This will generate the Xls report for the entire query result set 
    * and will open in a separate window.
    */
     private function generateXls():void {
    	var url : String = "stl/stlQueryDispatch.action?method=generateXLS";
    	var request:URLRequest = new URLRequest(url);
    	request.method = URLRequestMethod.POST;
    	 try {
                navigateToURL(request,"_blank");
            }
            catch (e:Error) {
                // handle error here
                trace(e);
            }
    } 



    /**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */ 
     /* private function doNext():void { 
        var reqObj : Object = new Object();
    	reqObj.method = "doNext";
    	settlementQueryRequest.request = reqObj;
        settlementQueryRequest.send();
    } */ 
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */ 
     /* private function doPrev():void { 
		var reqObj : Object = new Object();
    	reqObj.method = "doPrevious";
    	settlementQueryRequest.request = reqObj;
        settlementQueryRequest.send();
    } */  
 	