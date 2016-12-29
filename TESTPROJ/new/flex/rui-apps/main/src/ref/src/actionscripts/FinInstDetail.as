// ActionScript file
	import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    import com.nri.rui.core.containers.SummaryPopup;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Label;
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
    
    
    //Items returning through context - Non display objects for accountPopup
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    public var o:Object = {};
    
    public function submitQuery():void{
    	//XenosAlert.info("In submitQueryResult()");
    	parseUrlString();
    	
    	var req : Object = new Object();
    	req.finInstRolePk=finPk;
    	finInstDetailRequest.request=req;
    	
    	finInstDetailRequest.send();
	    PopUpManager.centerPopUp(this);
    }
    
    public function populateRoleList():void
    {
		var instRole:String = this.queryResult.finInstRolePage.refListValueArrayString;
		if(instRole.indexOf("<br>") != -1){
			 var label:Label;
			 instRole = instRole.replace(new RegExp("(<br>)", "g"),'\n');
			 var strParts:Array = instRole.split('\n');
			 for(var i:int = 0; i<strParts.length; i++)
			 {
			 	if(strParts[i] != "")
			 	{
				 	label = new Label();
				 	label.text = strParts[i];
				 	label.selectable = true;
				 	this.vbInstRole.addChild(label);
			 	}
			 }
	
		}
    }	   
            
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
                if (tempA[0] == Globals.FININST_PK) {
                    o.finInstPk = tempA[1];
                } 
                finPk = o.finInstPk;
                
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
	            eAddress.addEventListener(MouseEvent.CLICK,showAddress);
	            var accStr : String = queryResult.finInstRolePage.ourAccountPresentDisp;
	            if(accStr == 'Yes'){
	            	eAddress.visible = true;
	            }
	            populateRoleList();
            } 
        }else {
            //queryResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }
    }
   
   
    /**
   * This method is used for loading FinInst_E-Address_PopUp module 
   * 
   */  
   public function showAddress(event:MouseEvent):void{
			var sPopup : SummaryPopup;	
			sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
			
			//sPopup.title = "Financial Institution  View -  Delivery E-Address and Rule ";
			sPopup.title = this.parentApplication.xResourceManager.getKeyValue('ref.fininst.title') + " " + this.parentApplication.xResourceManager.getKeyValue('ref.fininst.label.fininstview') + " - "+this.parentApplication.xResourceManager.getKeyValue('ref.fininst.label.deliveryeaddressandrule');
			/* sPopup.width = 900;
			sPopup.height = 600; */
			sPopup.width = parentApplication.width - 100;
    		sPopup.height = parentApplication.height - 100;
			PopUpManager.centerPopUp(sPopup);		
			
			sPopup.moduleUrl = Globals.FININST_E_ADDRESS_DETAILS_SWF;
			
   }