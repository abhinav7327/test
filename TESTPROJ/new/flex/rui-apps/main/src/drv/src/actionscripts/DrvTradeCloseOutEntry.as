// ActionScript file
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;

import flash.events.Event;
import flash.events.IEventDispatcher;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;
import mx.events.ResourceEvent;
import mx.resources.ResourceBundle;
import mx.utils.StringUtil;

  
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     	 [Bindable]private var mode : String = "closeoutentry";
     	 [Bindable]private var contractRefNoStr : String = "";
            [Bindable]private var contractPkStr : String = "";  
           [Bindable]private var  rowNoStr : String = ""; 
            [Bindable]private var openTrdSelectedIndx : int = -1;  
           [Bindable]private var  closeTrdSelectedIndx : int = -1; 
            private var keylist:ArrayCollection = new ArrayCollection();
           [Bindable]private var contractDetails:ArrayCollection = new ArrayCollection();
           [Bindable]private var openTradeDetails:ArrayCollection = new ArrayCollection();
           [Bindable]private var closeTradeDetails:ArrayCollection = new ArrayCollection();
           [Bindable]private var confOpenTradeDetails:ArrayCollection = new ArrayCollection();
           [Bindable]private var confCloseTradeDetails:ArrayCollection = new ArrayCollection();
	  private function changeCurrentState():void{
				//hdbox1.selectedChild = this.rslt;
				//currentState = "result";
				vstack.selectedChild = rslt;
	 }
	 
    
			   public function loadAll():void{
           	   parseUrlString();
           	   super.setXenosEntryControl(new XenosEntry());
           	   //XenosAlert.info("mode : "+mode);
           	   if(this.mode == 'closeoutentry'){
           	   	 this.dispatchEvent(new Event('entryInit'));
           	   	// this.appRole.setFocus();
				//hdbox1.selectedChild = this.qry;
           	   	 //this.currentState="entryState";
           	   	 vstack.selectedChild = qry;
           	   } 
           	     
           }
           
            /**
             * Extracts the parameters and set them to some variables for query criteria from the Module Loader Info.
             * 
             */ 
            public function parseUrlString():void {
                try {
                    // Remove everything before the question mark, including
                    // the question mark.
                    var myPattern:RegExp = /.*\?/; 
                    var s:String = this.loaderInfo.url.toString();
                    //XenosAlert.info("Load Url : "+ this.loaderInfo.url.toString());
                    s = s.replace(myPattern, "");
                    // Create an Array of name=value Strings.
                    var params:Array = s.split(Globals.AND_SIGN); 
                     // Print the params that are in the Array.
                    var keyStr:String;
                    var valueStr:String;
                    var paramObj:Object = params;
                  
                    // Set the values of the salutation.
                    if(params != null){
	                    for (var i:int = 0; i < params.length; i++) {
	                        var tempA:Array = params[i].split("=");  
	                        if (tempA[0] == "mode") {
	                            //XenosAlert.info("movArray param = " + tempA[1]);
	                            mode = tempA[1];
	                        }else if(tempA[0] == "contractPk"){
	                            this.contractPkStr = tempA[1];
	                        } else if(tempA[0] == "rowNo"){
	                            this.rowNoStr = tempA[1];
	                        }else if(tempA[0] == "contractRefNo"){
	                            this.contractRefNoStr = tempA[1];
	                        } 
	                    }                    	
                    }else{
                    	mode = "closeoutentry";
                    }                 

                } catch (e:Error) {
                    trace(e);
                }               
            }
            
            
		  private function doBack():void{
						//hdbox1.selectedChild = this.qry;
		           	   	 //this.currentState="entryState";
		           	   	 vstack.selectedChild = qry;	
           	   	 app.submitButtonInstance = submit;
		  }  
		  
		  	
		public function selectOpenTrade(data:Object):void{
			openTrdSelectedIndx = data["rowNo"];
			for each(var openTradeItem:Object in openTradeDetails){
			    openTradeItem["showSelect"] = false; 
			    openTradeItem["closeBalQty"] = "";
        	}
			data["showSelect"] = true;
			//if(StringUtil.trim(openTradeDetails.getItemAt(openTrdSelectedIndx).closeBalQty) != ""){
				var closeBal:int = openTradeDetails.getItemAt(openTrdSelectedIndx).openBalanceQuantity;
				//data.closeBalQty = data.openBalanceQuantity; 
				openTradeDetails.getItemAt(openTrdSelectedIndx).closeBalQty = closeBal;				
			//}
			openTradeDetails.refresh();
			//XenosAlert.info("openTrdSelectedIndx : " +openTrdSelectedIndx + " openTradeDetails openBalanceQuantity : "+openTradeDetails.getItemAt(openTrdSelectedIndx).openBalanceQuantity);
		} 	
		public function selectCloseTrade(data:Object):void{
			closeTrdSelectedIndx = data["rowNo"];
			for each(var closeTradeItem:Object in closeTradeDetails){
			    closeTradeItem["showSelect"] = false; 
			    closeTradeItem["closeBalQty"] = "";
        	}
			data["showSelect"] = true;
			//if(StringUtil.trim(closeTradeDetails.getItemAt(closeTrdSelectedIndx).closeBalQty) != ""){
				var closeBal:int =  closeTradeDetails.getItemAt(closeTrdSelectedIndx).openBalanceQuantity;
				//data.closeBalQty = data.openBalanceQuantity;			
				closeTradeDetails.getItemAt(closeTrdSelectedIndx).closeBalQty = closeBal;				
			//}
			closeTradeDetails.refresh();
			//XenosAlert.info("closeTrdSelectedIndx : " +closeTrdSelectedIndx + " closeTradeDetails openBalanceQuantity ::"+closeTradeDetails.getItemAt(closeTrdSelectedIndx).openBalanceQuantity);
		}  	
		public function openTradeValue(data:Object,value:Object):void{
			
			if(openTrdSelectedIndx != -1 && openTrdSelectedIndx == data["rowNo"]){	
			  openTradeDetails.getItemAt(openTrdSelectedIndx).closeBalQty = value;
			  openTradeDetails.refresh();		
			  //XenosAlert.info("openTradeDetails closeBalQty : " +openTradeDetails.getItemAt(openTrdSelectedIndx).closeBalQty);	
			 // data.closeBalQty = value; 
			}
		} 	
		public function closeTradeValue(data:Object,value:Object):void{
			//openTrdSelectedIndx = data["rowNo"];
			
			if(closeTrdSelectedIndx != -1 && closeTrdSelectedIndx == data["rowNo"]){	
			  closeTradeDetails.getItemAt(closeTrdSelectedIndx).closeBalQty = value;
			  closeTradeDetails.refresh();	
			  //XenosAlert.info("closeTradeDetails closeBalQty : " +closeTradeDetails.getItemAt(closeTrdSelectedIndx).closeBalQty);		
			 // data.closeBalQty = value; 
			} 
		} 
		
	 //entry actions
        override public function preEntryInit():void{            	
	        var rndNo:Number= Math.random(); 
        	super.getInitHttpService().url = "drv/drvCloseOutEntry.action?method=viewCloseOutTradeDetails&rowNum="+rowNoStr+"&contractPk="+contractPkStr+"&mode=closeoutentry&fromPage=closeOutQueryResult&rnd=" + rndNo;
	  	    var reqObject:Object = new Object();
	  	    reqObject.SCREEN_KEY = 10081;
	  	    super.getInitHttpService().request = reqObject; 
        }
        override public function preEntryResultInit():Object{
        	//addCommonKeys(); 
        	keylist = new ArrayCollection();
        	keylist.addItem("closeOutQuerySummaryView");
        	keylist.addItem("openTradeDetails.openTradeDetail");
        	keylist.addItem("closeTradeDetails.closeTradeDetail");
        	return keylist;
        }
        
        override public function postEntryResultInit(mapObj:Object): void{
        	app.submitButtonInstance = submit;
        	contractDetails = (mapObj[keylist.getItemAt(0)] as ArrayCollection);
        	openTradeDetails = (mapObj[keylist.getItemAt(1)] as ArrayCollection);
        	var indx:int =0;
        	for each(var openTrade:Object in openTradeDetails){
        		openTrade["rowNo"] = indx;
			    openTrade["showSelect"] = false; 
			    openTrade["closeBalQty"] = "";
        		indx++;
        	}
        	closeTradeDetails = (mapObj[keylist.getItemAt(2)] as ArrayCollection);
        	indx = 0;
        	for each(var closeTrade:Object in closeTradeDetails){
        		closeTrade["rowNo"] = indx;
			    openTrade["showSelect"] = false;
			    closeTrade["closeBalQty"] = "";
        		indx++;
        	}
        	//commonInit(mapObj);	
        	
        }
        
        override public function preEntry():void{
		 	super.getSaveHttpService().url = "drv/drvCloseOutEntry.action?";  
            super.getSaveHttpService().request  =populateRequestParams();
        	
        }
        
		override public function preEntryResultHandler():Object
		{
			 keylist = new ArrayCollection();
			 keylist.addItem("closeOutOpenTradeList.closeOutOpenTrade");
			 keylist.addItem("closeOutCloseTradeList.closeOutCloseTrade");
			 keylist.addItem("realizedPl");
			 return keylist;
		}
		
		
		override public function postEntryResultHandler(mapObj:Object):void
		{
			if(mapObj!=null){    		
		    	if(mapObj["errorFlag"].toString() == "error"){
		    		//result = mapObj["errorMsg"] .toString();
		    		if(mode != "cancel"){
		    		  errPage.showError(mapObj["errorMsg"]);		    			
		    		}else{
		    			XenosAlert.error(mapObj["errorMsg"]);
		    		}
		    	}else if(mapObj["errorFlag"].toString() == "noError"){
		    		
		    	 errPage.clearError(super.getSaveResultEvent());			    			
	             confOpenTradeDetails = (mapObj[keylist.getItemAt(0)] as ArrayCollection);	
	             confCloseTradeDetails = (mapObj[keylist.getItemAt(1)] as ArrayCollection);	
	             confPLValue.text = (mapObj[keylist.getItemAt(2)]);
				 changeCurrentState();
		    	 app.submitButtonInstance = uConfSubmit;
			     this.parentDocument.title  ="Derivative Closeout Entry - User Confirmation ";
		    		
		    	}else{
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    	}    		
	    	}
//			uConfLabel.includeInLayout = true;
//			uConfLabel.visible = true;
//			uConfImg.includeInLayout =false;
//			uConfImg.visible =false;
		}
        
        
		override public function preEntryConfirm():void
		{
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "drv/drvCloseOutEntry.action?";  
			reqObj.method= "closeOutEntrySave";
	  	    reqObj.SCREEN_KEY = 10083;
            super.getConfHttpService().request  =reqObj;
		 	actionBtnPanel.enabled =false;
		}
		override public function preEntryConfirmResultHandler():Object
		{
			keylist = new ArrayCollection();
			keylist.addItem("trdCloseOutEntryRefNo");
			return keylist;
		}
		
		
		override public function postConfirmEntryResultHandler(mapObj:Object):void
		{
			
    	if(mapObj!=null){    
    		//XenosAlert.info("object status : "+mapObj["errorFlag"].toString());		
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		XenosAlert.error(mapObj["errorMsg"].toString());
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    	   errPage.clearError(super.getConfResultEvent());
	    	   this.closeRefNo =  mapObj[keylist.getItemAt(0)];
	    	   this.back.includeInLayout = false;
	    	   this.back.visible = false;
			   uConfSubmit.enabled = true;	
               uConfLabel.includeInLayout = false;
               uConfLabel.visible = false;
               uConfSubmit.includeInLayout = false;
               uConfSubmit.visible = false;
               sConfLabel.includeInLayout = true;
               sConfLabel.visible = true;
               sConfSubmit.includeInLayout = true;
               sConfSubmit.visible = true; 
			   ruleBar.includeInLayout = true;
			   ruleBar.visible =true;   
               app.submitButtonInstance = sConfSubmit;    
			   this.parentDocument.title  =this.parentApplication.xResourceManager.getKeyValue('drv.label.closeout.entry.sysconf'); 
	    		
	    	}else{
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred'));
	    	}    		
    	}
		 	actionBtnPanel.enabled =true;
//			uConfLabel.includeInLayout = true;
//			uConfLabel.visible = true;
//			uConfImg.includeInLayout =false;
//			uConfImg.visible =false;
		}
		override public function doEntrySystemConfirm(e:Event):void
		{
			//this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
		    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
		}
        private function populateRequestParams():Object{
        	var req:Object = new Object();
        	req.method ="closeOutEntryConfirm";
	  	    req.SCREEN_KEY = 10082;
        	var openTrdCloseQtyArr:Array = new Array(openTradeDetails.length);
        	if(openTrdSelectedIndx != -1){
        	    req.openTradeRadio = openTrdSelectedIndx;
        		openTrdCloseQtyArr[openTrdSelectedIndx] = openTradeDetails.getItemAt(openTrdSelectedIndx).closeBalQty;       	  
        	    req.openTradeCloseOutQty = openTrdCloseQtyArr;
        	} 
        	var closeTrdCloseQtyArr:Array = new Array(closeTradeDetails.length);
        	if(closeTrdSelectedIndx != -1){
        	    req.closeTradeRadio = closeTrdSelectedIndx;
        	    closeTrdCloseQtyArr[closeTrdSelectedIndx] = closeTradeDetails.getItemAt(closeTrdSelectedIndx).closeBalQty;      	
        		req.closeTradeCloseOutQty = closeTrdCloseQtyArr;
        	}
        	
        	return req;
        }
        