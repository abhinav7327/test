/*



*/

    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    
    import mx.collections.ArrayCollection;
    import mx.managers.CursorManager;
    import mx.rpc.events.ResultEvent;
    
    
    [Bindable]private var xmlSource:ArrayCollection= new ArrayCollection();
    private var initCompFlg : Boolean = false;
    [Bindable]public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
    public var o:Object = {};
    [Bindable]public var instReferenceNo:String;
    [Bindable]public var mode:String;
    [Bindable]private var swiftContent:String = new String();
    private var rs:XML = null;	   
            
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
                if (tempA[0] == "instReferenceNo") {
                    o.instReferenceNo = tempA[1];
                    instReferenceNo = o.instReferenceNo;
                } 
                if (tempA[0] == "mode") {
                    o.mode = tempA[1];
                    mode = o.mode;
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
    	rs = XML(event.result);
    	
    	if (rs != null) {
    		if(rs.child("Errors").length()>0) {
    			var errorInfoList : ArrayCollection = new ArrayCollection();
				//populate the error info list 			 	
				for each ( var error:XML in rs.Errors.error ) {
					errorInfoList.addItem(error.toString());
				}
				errPage.showError(errorInfoList);//Display the error
    		} else {
    			errPage.clearError(event); //clears the error if any    			
    			handleMT54x();    									
    			
    		}
    	} else {
    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
    	}
    	CursorManager.removeBusyCursor();
    }
   
   private function populateRequestParams():Object {
	   var reqObj : Object = new Object();
	   reqObj.instReferenceNo = instReferenceNo;
	   reqObj.mode = mode;
	   return reqObj;
   }
   
   private function handleMT54x():void {
		if(rs.rawMT54xMessage == "") {
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('drv.rawfile.mt54xnotfound'));
		} else {
			swiftContent = rs.rawMT54xMessage.toString();
		}
   }
   
   