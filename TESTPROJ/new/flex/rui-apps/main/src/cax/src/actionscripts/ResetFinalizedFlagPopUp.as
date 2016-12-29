




import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;
import mx.rpc.events.ResultEvent;


            
      
     [Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     [Bindable]public var cxlMessage:String="will be cancelled";
     [Bindable]private var mode : String = "entry";
	 private var rndNo:Number = 0;            
     private var keylist:ArrayCollection = new ArrayCollection();
     [Bindable]private var selectedAuthRejectArray:Array; 
     [Bindable]private var selectedItemsArray:Array; 
     
     [Bindable]private var selectedFlagArray:Array; 
     [Bindable]private var selectedCashEntryPkArray:Array; 
     [Bindable]private var queryResult:ArrayCollection = new ArrayCollection();
     //[Bindable]private var refreshRequired:Boolean = false;
	 
 	 private function init():void{
		parseUrlString();
		var obj:Object=new Object();
		rndNo = Math.random();
		obj=populateRequestParams();
		obj.rnd = rndNo+"";
		obj.method="doPreConfirm";
		obj.SCREEN_KEY = "12150";
		revertCxlUconf.request = obj;
		revertCxlUconf.resultFormat = "xml";
		revertCxlUconf.send();
	}
           
            /**
             * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
             * 
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
                  
                    // Set the values of the salutation.
                    if(params != null){
                        for (var i:int = 0; i < params.length; i++) {
                            var tempA:Array = params[i].split("=");  
                            if(tempA[0] == "selectedItems"){
                                this.selectedItemsArray = (tempA[1] as String).split(",");
                            } else if(tempA[0] == "selectedFlagArray"){
                                this.selectedFlagArray = (tempA[1] as String).split(",");
                            } 
 
                        }                       
                    }                 

                } catch (e:Error) {
                    trace(e);
                }
            }
            
public function LoadUserConfirmPage(event:ResultEvent):void
{
	if(null != event){
	   var rs:XML = XML(event.result);
	   queryResult.removeAll();
	   if(rs.child("Errors").length()>0) {	   	    
           var errorInfoList : ArrayCollection = new ArrayCollection();
           for each ( var error:XML in rs.Errors.error ) {
               errorInfoList.addItem(error.toString());               
               trace(error.toString());                
            }
           errPage.showError(errorInfoList);//Display the error
	   }else{
	   	   errPage.clearError(event);
           if(rs.SelectedFlagList != null) {
	            for each(var objXml:XML in rs.SelectedFlagList.SelectedFlag){	            	                   
	                queryResult.addItem(objXml);
	           }
	       }
	    }	
	}
}
	    public function submitConfirm(event:Event):void {
	    	uConfSubmit.enabled = false;
	    	uConfBack.enabled = false;
	    	var reqObj:Object = new Object();
	   		reqObj.method = "doConfirmEntry";
			reqObj.SCREEN_KEY = "12151";	
	    	revertCxlSconf.request=reqObj;
			revertCxlSconf.send();
	    }
     private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();        
		reqObj.selectedDetailPkArray = selectedItemsArray;
		reqObj.selectedFlag = selectedFlagArray;
        return reqObj;
    }
    public function LoadSysConfirmPage(event:ResultEvent):void {
        	if (null != event) {
        		errPage.clearError(event);
    			if(null != event.result.XenosErrors){
    				errPage.displayError(event);	
    				uConfSubmit.enabled = true;
    				uConfBack.enabled = true;
    			}else{
    			//	finalizedFlag.
		    		uConfSubmit.includeInLayout = false;
					uConfSubmit.visible = false;
					uConfBack.includeInLayout = false;
					uConfBack.visible = false;
        			uConfLabel.includeInLayout = false;
               		uConfLabel.visible = false;
	    			sConfSubmit.includeInLayout = true;
        			sConfSubmit.visible = true;  
	    	        sConfLabel.includeInLayout = true;
    	            sConfLabel.visible = true;
    	            hb.includeInLayout = true;
    	            hb.visible = true;      			
    			}
        	}
               	
    }
    private function submitOkConfirm():void{
		        var obj:Object=new Object();
				obj.method="okSystemConformation";
			    obj.unique= new Date().getTime() + "" ;
				revertCxlOKConfirm.request=obj;
			    revertCxlOKConfirm.send();
				//refreshRequired = true;
    }
    private function closeHandlerOnError():void{
      	this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    }
   /**
	* Back to query result page. 
	*/
	 public function backToQueryResultPage():void {
		app.submitButtonInstance = null;
		//this.parentDocument.owner.submitQuery();
		closeHandeler();
	}
   /**
    * Closes the handler to close the popup.
    */
	 public function closeHandeler():void{		
		this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
	}
    
   

	  
    
        