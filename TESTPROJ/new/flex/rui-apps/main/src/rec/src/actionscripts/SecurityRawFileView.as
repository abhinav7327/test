// ActionScript file
// ActionScript file

 // ActionScript file for Trade Query
    import com.nri.rui.core.Globals;
    import com.nri.rui.core.controls.XenosAlert;
    import com.nri.rui.core.startup.XenosApplication;
    
    import mx.collections.ArrayCollection;
    import mx.controls.TextArea;
    import mx.rpc.events.ResultEvent;
    
    [Bindable]
    //private var initColl:ArrayCollection;
    [Bindable]
    private var errorColls:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var xmlSource:ArrayCollection= new ArrayCollection();
    private var initCompFlg : Boolean = false;
    [Bindable]
    public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    
    
    [Bindable]
    public var returnContextItem:ArrayCollection = new ArrayCollection();
    public var o:Object = {};
    
    [Bindable]
    public var gwySwiftPk:String;
    [Bindable]
    public var fileType:String;
    [Bindable]
    private var dataString:String = new String();
    	   
            
    public function parseUrlStringForSwiftPk():void {
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
                if (tempA[0] == "gwySwiftPk") {
                    o.gwySwiftPk = tempA[1];
                    gwySwiftPk = o.gwySwiftPk;
                } 
               	//XenosAlert.info(gwySwiftPk);
            }
        } catch (e:Error) {
            trace(e);
        }
       
    }
    
    
    public function parseUrlStringForFileType():void {
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
                if (tempA[0] == "fileType") {
                    o.fileType = tempA[1];
                    fileType = o.fileType;
                } 
                //XenosAlert.info(fileType);
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
            		XenosAlert.info("No Result Found!");
            	} else { // Must be error
            		//errPage.displayError(event);	
            	}
            } else {
	            	if(event.result.securityRawFileActionForm.fileShow == null){
	            		 XenosAlert.info("Nothing found to display");
	            		 return;
	            	}
	            	/*if(event.result.securityRawFileActionForm.fileShow.fileShowList is ArrayCollection){
	            		xmlSource = event.result.securityRawFileActionForm.fileShow.fileShowList as ArrayCollection;
	            	} else {
	            		xmlSource.removeAll();
	            		xmlSource.addItem(event.result.securityRawFileActionForm.fileShow.fileShowList);
	            	}*/
	            	dataString = event.result.securityRawFileActionForm.fileShow.fileShowList;
	            	//XenosAlert.info("Hello: "+dataString.length);
	            	resize(this.ta);
            } 
        } else {
            //queryResult.removeAll();
            XenosAlert.info("No Results Found");
        }
    }
   
   private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
         reqObj.gwySwiftPk = gwySwiftPk;
         reqObj.fileType = fileType;
         return reqObj;
    }
     		
    private function resize(field:TextArea):void {
    	var height:uint = 10;
		field.validateNow();
		for(var i:int=0; i < field .mx_internal::getTextField().numLines; i++) {
			height += field.mx_internal::getTextField().getLineMetrics(i).height;
		}
		field.height = height;
    }
    
     		