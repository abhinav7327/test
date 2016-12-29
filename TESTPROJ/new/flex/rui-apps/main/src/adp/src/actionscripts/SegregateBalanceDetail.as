// ActionScript file

// ActionScript file for Segregate Balance Query
import com.nri.rui.core.Globals;
import com.nri.rui.core.containers.SummaryPopup;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosPopupUtils;

import mx.collections.ArrayCollection;
import mx.collections.XMLListCollection;
import mx.core.UIComponent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
    
    
[Bindable]private var errorColls:ArrayCollection = new ArrayCollection();
[Bindable]private var queryResult:XML= new XML();

private var initCompFlg : Boolean = false;
[Bindable]public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);

[Bindable]private var taxFeeResult:XMLListCollection= new XMLListCollection();
[Bindable]private var rrResult:XMLListCollection= new XMLListCollection();

//Items returning through context - Non display objects for accountPopup
[Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
public var o:Object = {};

[Bindable]private var mode:String = "view";
[Bindable]public var segregateBalancePk:String;
[Bindable]public var updateDate:String = "";
           
            
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
            if (tempA[0] == Globals.SEGREGATE_BALANCE_PK) {
                o.segregateBalancePk = tempA[1];
            } 
            segregateBalancePk = o.segregateBalancePk;
            if (tempA[0] == "mode") {
                o.mode = tempA[1];
            } 
            if(o.mode!=null){
                mode = o.mode;
            }else{
                mode = "view";
            }                 
        }        
    } catch (e:Error) {
        trace(e);
    }   
}

public function submitQueryResult():void
{
    parseUrlString();
    var req : Object = new Object();
    req.segregateBalancePk = segregateBalancePk;
    req.SCREEN_KEY = "12064";
    req.mode = mode;
    segregateBalanceDetailService.request=req;
    segregateBalanceDetailService.send(); 
    PopUpManager.centerPopUp(this);
}
     
/**
* This method works as the result handler of the Submit Query Http Services.
* 
*/
public function loadResultPage(event:ResultEvent):void {
    
    if (null != event) {            
        if(null == event.result){        
            if(null == event.result.XenosErrors){ // i.e. No result but no Error found.                  
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            }               
        }else {
            queryResult = event.result as XML;                        
        } 
    }else {            
        XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
    }
}