// ActionScript file

 // ActionScript file for CAX Receive Notice - Raw MT566 Swift View
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    
    import mx.collections.ArrayCollection;
    import mx.rpc.events.ResultEvent;
    
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    
    [Bindable]
    private var content:String = new String();
    
    [Bindable]
    private var gwyReferenceNo:String = new String();
    
    [Bindable]
    private var mode:String = new String();
    	   
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
                if (tempA[0] == Globals.GWY_REFERENCE_NO) {
                    this.gwyReferenceNo = tempA[1];
                } else if(tempA[0] == Globals.MODE){                        
                    this.mode = tempA[1];
                }
            }
        } catch (e:Error) {
            trace(e);
        }
       
    }
    
    /**
     * This method works as the result handler of the Submit Query Http Services.
     */
    public function loadResultPage(event:ResultEvent):void {

    	var rs:XML = XML(event.result);

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
				if(rs.rawMT566Message == "") {
	             	XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.rawfile.mt566notfound'));
	           	 	return;
	           	}
	            content = rs.rawMT566Message.toString();
	  		}
		} else {
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		}
    }
   
   	private function populateRequestParams():Object {
   		var reqObj : Object = new Object();
   		
   		reqObj.gwyReferenceNo = gwyReferenceNo;
   		reqObj.mode = "MT566_VIEW";
         
        return reqObj;
    }
     		