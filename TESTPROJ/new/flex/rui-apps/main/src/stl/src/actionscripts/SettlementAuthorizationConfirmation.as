// ActionScript file

import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;
import mx.events.ResourceEvent;
import mx.resources.ResourceBundle;

			
	  
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     
            [Bindable]private var mode : String = "entry";
            [Bindable]private var exchangeRatePkStr : String = "";
            private var keylist:ArrayCollection = new ArrayCollection();
	  		[Bindable]private var selectedItemArray:Array; 
	  		[Bindable]public var confResult:ArrayCollection = new ArrayCollection();
	  		[Bindable]private var SelectedExerciseRefrenceNo:ArrayCollection = new ArrayCollection();
	 
    /**
    * At the time of loading the module if the module specific Resource is not loaded then load them
    * 
    */ 
    public function loadResourceBundle():void
    {    	
        var locales:String = this.parentApplication.xResourceManager.localeChain[0];        
        var resourceModuleURL:String = "assets/appl/stl/stlResources_" + locales + ".swf";           
        var bundle:ResourceBundle = ResourceBundle(resourceManager.getResourceBundle(locales, "stlResources"));
           
        var eventDispatcher:IEventDispatcher = null;
           if(bundle == null){    
            eventDispatcher = this.parentApplication.xResourceManager.loadResourceModule(resourceModuleURL);
               
            eventDispatcher.addEventListener(ResourceEvent.ERROR, errorHandler);            
        }              
        this.parentApplication.xResourceManager.update();       
    }
    
    private function errorHandler(event:ResourceEvent):void{
        XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.loadstlresourcebundle') + event.errorText);
    }
		
	public function loadAll():void{		 
         parseUrlString();         
         super.setXenosEntryControl(new XenosEntry());
          
          if(this.mode == 'entry'){
           	  this.dispatchEvent(new Event('entrySave'));				
          } else if(this.mode == 'amend'){
           	   	 	this.dispatchEvent(new Event('amendEntrySave'));				
           	   } else { 
           	     	this.dispatchEvent(new Event('cancelEntrySave'));
          }           	     
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
                    
                    if(params != null){
	                    for (var i:int = 0; i < params.length; i++) {
	                        var tempA:Array = params[i].split("=");  
	                        if (tempA[0] == "mode") {	                            
	                            mode = tempA[1];	                           
	                        } 
	                    }                    	
                    }else{
                    	mode = "entry";
                    }                 

                } catch (e:Error) {
                    trace(e);
                }                        
            }    
        
       
       private function addCommonResultKeys():void{
        	keylist = new ArrayCollection();
	    	keylist.addItem("row");	    	
        } 
        
         private function commonResult(mapObj:Object):void{        	
		 	
		 	this.parentDocument.owner.errPageResultSum.removeError();
	    	if(mapObj!=null){    		
		    	if(mapObj["errorFlag"].toString() == "error"){		    		
		    		if(mode != "DELETE"){
		    		  this.parentDocument.owner.errPageResultSum.showError(mapObj["errorMsg"]);
					    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
//		    		  uConfSubmit.enabled = false;		    			
		    		}else{
		    			XenosAlert.error(mapObj["errorMsg"] + "Error......");
		    		}
		    	}else if(mapObj["errorFlag"].toString() == "noError"){
		    		
		    	 errPage.clearError(super.getSaveResultEvent());		    	 		    	 
		    	 confResult = mapObj["row"];	             
		    	 app.submitButtonInstance = uConfSubmit;	
		    	}else{
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    	}    		
	    	}
        }         
    	 
		  override public function preEntry():void{			  		 		
		 	var rndNo:Number = Math.random();	 	
		 	super.getSaveHttpService().url = "stl/authorizationQueryDispatchAction.action?rnd="+rndNo; 		 	
            super.getSaveHttpService().request  =populateRequestParams();            
		 } 		 
		 
		 
		 override public function preEntryResultHandler():Object
		{
			 addCommonResultKeys();
			 return keylist;
		}
		
		
		override public function postEntryResultHandler(mapObj:Object):void
		{
			commonResult(mapObj);
			
		}	 
		
		override public function preEntryConfirm():void
		{			
			uConfSubmit.enabled = false;
			var reqObj :Object = new Object();
			var rndNo:Number = Math.random();
			super.getConfHttpService().url = "stl/authorizationQueryDispatchAction.action?rnd="+rndNo;  
			reqObj.method= "submitPreConfirm";
			reqObj['SCREEN_KEY']="813";
            super.getConfHttpService().request  =reqObj;
		}	
		
		override public function preEntryConfirmResultHandler():Object
		{
			keylist = new ArrayCollection();
	    	keylist.addItem("row");
	    	return keylist;
		}
		
		
		override public function postConfirmEntryResultHandler(mapObj:Object):void
		{
			submitUserConfResult(mapObj);
		}		
		
		 private function submitUserConfResult(mapObj:Object):Boolean{    	
    	if(mapObj!=null){    				
	    	if(mapObj["errorFlag"].toString() == "error"){	    		
	    		uConfSubmit.enabled = true;
	    		errPage.showError(mapObj["errorMsg"]);
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    		if(mode!="cancel")
	    		  errPage.clearError(super.getConfResultEvent());	    		
	    	   confResult = mapObj[keylist.getItemAt(0)];			   	
               uConfLabel.includeInLayout = false;
               uConfLabel.visible = false;
               uConfSubmit.includeInLayout = false;
               uConfSubmit.visible = false;
               sConfLabel.includeInLayout = true;
               sConfLabel.visible = true;
               sConfSubmit.includeInLayout = true;
               sConfSubmit.visible = true; 
               app.submitButtonInstance = sConfSubmit;
               return true;        
	    		
	    	}else{
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred')+ mapObj["errorFlag"].toString());
	    	}    		
    	}
    	return false;
    } 
    
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
     private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	
    	reqObj.method = "submitSelectedRecords";
    	reqObj['SCREEN_KEY']="812";    	    	
    	var stlInfoPkArray:Array = new Array();
    	for(var index:int=0; index<this.parentDocument.owner.selectedResults.length; index++ ){
    		stlInfoPkArray[index] = this.parentDocument.owner.selectedResults[index].settlementInfoPk;
    	}
    	reqObj.stlInfoPkArray = stlInfoPkArray;
 
    	return reqObj;
    }
    
   
   
	 override public function doEntrySystemConfirm(e:Event):void {
		     super.preEntrySystemConfirm();	    	 
             uConfLabel.includeInLayout = true;
             uConfLabel.visible = true;
             uConfSubmit.includeInLayout = true;
             uConfSubmit.visible = true;
             sConfLabel.includeInLayout = false;
             sConfLabel.visible = false;
             sConfSubmit.includeInLayout = false;
             sConfSubmit.visible = false;
	   		 this.parentDocument.owner.dispatchEvent(new Event("querySubmit"));
	   		 this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
			 super.postEntrySystemConfirm();
		
	}  
   	
		