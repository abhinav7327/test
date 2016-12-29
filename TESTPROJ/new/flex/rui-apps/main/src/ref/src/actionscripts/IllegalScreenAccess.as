
 
  	import com.nri.rui.core.Globals;
  	import com.nri.rui.core.controls.CustomizeSortOrder;
  	import com.nri.rui.core.controls.XenosAlert;
  	import com.nri.rui.core.startup.XenosApplication;
  	import com.nri.rui.core.utils.ProcessResultUtil;  	
  	import mx.collections.ArrayCollection;
  	
    [Bindable]
    public var mode : String = "query";
    
    /**
    * This method will be called at the time of the loading this module and pressing the reset button.
    * 
    */
    private function initPageStart():void {
		parseUrlString();          	
    }
    

    /**
     * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
     */ 
    public function parseUrlString():void {
        try {
            var myPattern:RegExp = /.*\?/; 
            var s:String = this.loaderInfo.url.toString();
            s = s.replace(myPattern, "");
            var params:Array = s.split(Globals.AND_SIGN); 
            var keyStr:String;
            var valueStr:String;
            var paramObj:Object = params;
          
            if(params != null) {
                for (var i:int = 0; i < params.length; i++) {
                    var tempA:Array = params[i].split("=");  
                    if (tempA[0] == "messageStr") {
                        mode = tempA[1];    
                        this.lblScreenClose.text=mode;                                            
                    }
                }                    	
            }                

        } catch (e:Error) {
            trace(e);
        }               
    }