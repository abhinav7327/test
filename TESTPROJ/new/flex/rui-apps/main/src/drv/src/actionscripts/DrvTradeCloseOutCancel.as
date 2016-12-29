// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;

import flash.events.Event;
import flash.events.IEventDispatcher;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;
import mx.events.ResourceEvent;
import mx.resources.ResourceBundle;
import mx.rpc.events.ResultEvent;

  
	[Bindable]
	public var showDetails:Boolean = true;
	[Bindable]
	public var actionMode:String = "closeoutcancel";
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     private var tradeIndexs:ArrayCollection =new ArrayCollection();
     	 [Bindable]private var mode : String = "closeoutcancel";
     	 [Bindable]private var contractRefNoStr : String = "";
            [Bindable]private var contractPkStr : String = "";  
           [Bindable]private var  rowNoStr : String = ""; 
            [Bindable]private var openTrdSelectedIndx : int;  
           [Bindable]private var  closeTrdSelectedIndx : int; 
            private var keylist:ArrayCollection = new ArrayCollection();
           [Bindable]private var contractDetails:ArrayCollection = new ArrayCollection();
           [Bindable]private var closeOutData:ArrayCollection = new ArrayCollection();
          // [Bindable]private var closeTradeDetails:ArrayCollection = new ArrayCollection();
           [Bindable]private var confCloseOutData:ArrayCollection = new ArrayCollection();
           //[Bindable]private var confCloseTradeDetails:ArrayCollection = new ArrayCollection();
	 /*  private function changeCurrentState():void{
				//hdbox1.selectedChild = this.rslt;
				//currentState = "result";
				vstack.selectedChild = rslt;
	 } */
	 
    
			   public function loadAll():void{  
		       tradeIndexs = new ArrayCollection();
           	   parseUrlString();
           	   super.setXenosEntryControl(new XenosEntry());
           	   //XenosAlert.info("mode : "+mode);
           	  // if(this.mode == 'closeoutcancel'){
           	   	 this.dispatchEvent(new Event('cancelEntryInit'));
           	   	// this.appRole.setFocus();
				//hdbox1.selectedChild = this.qry;
           	   	 //this.currentState="entryState";
           	   	 //vstack.selectedChild = qry;
           	  // } 
           	     
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
	                           // XenosAlert.info("mode = " + mode);
	                            mode = tempA[1];
	                        }else if(tempA[0] == "contractPk"){
	                            this.contractPkStr = tempA[1];
	                        } else if(tempA[0] == "rowNo"){
	                            this.rowNoStr = tempA[1];
	                        } else if(tempA[0] == "contractRefNo"){
	                            this.contractRefNoStr = tempA[1];
	                        } 
	                    }                    	
                    }else{
                    	mode = "closeoutcancel";
                    }                 

                } catch (e:Error) {
                    trace(e);
                }               
            }
      private function doBack():void{
		  backService.send();
         submitActionBtnPanel.includeInLayout = true;
		 showDetails = true;
         submitActionBtnPanel.visible = true;
         selectRendererCol.visible = true;
         adg.dataProvider = closeOutData;
   	   	 app.submitButtonInstance = submit;
	 	actionBtnPanel.visible =false;
		this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('drv.label.closeout.cxl');
		uConfLabel.includeInLayout = false;  
		uConfLabel.visible = false;
     }  
      public function backResult(event:ResultEvent):void{
      	
      }
	 //entry actions
        override public function preCancelInit():void{            	
	        var rndNo:Number= Math.random(); 
        	super.getInitHttpService().url = "drv/drvCloseOutCancel.action?method=doCloseOutCancel&contractPK="+contractPkStr+"&mode=closeoutcancel&actionType=CLOSEOUT&rnd=" + rndNo;
        	var reqObject:Object = new Object();
	  	    reqObject.SCREEN_KEY = 10086;
	  	    super.getInitHttpService().request = reqObject; 
        }
        override public function preCancelResultInit():Object{
        	//addCommonKeys(); 
        	keylist = new ArrayCollection();
        	keylist.addItem("detailContractView");
        	keylist.addItem("closeOutDetailViewLists.closeOutDetailViewList");
        	return keylist;
        }
        
        override public function postCancelResultInit(mapObj:Object): void{
        	app.submitButtonInstance = submit;
        	contractDetails = (mapObj[keylist.getItemAt(0)] as ArrayCollection);
        	closeOutData = (mapObj[keylist.getItemAt(1)] as ArrayCollection);
        	var indx:int =0;
        	//XenosAlert.info(closeOutData.toString());
        	for each(var tradeData:Object in closeOutData){
        		tradeData["rowNo"] = indx;
			    tradeData["selected"] = false; 
        		indx++;
        	}
        	//commonInit(mapObj);	
        	
        }
        
         
		 
		 override public function preCancel():void{
		 	//setValidator();
		 	super._validator = null;
		 	super.getSaveHttpService().url = "drv/drvCloseOutCancel.action?"; 
		 	 var reqObj:Object = new Object();
		 	 reqObj.method="doCloseOutCancelConfirm";
		 	 //XenosAlert.info(" indx :  "+tradeIndexs);
		 	 reqObj["cancelSelector"] = tradeIndexs.toArray();
		 	 reqObj.mode=this.mode;
	  	    reqObj.SCREEN_KEY = 10087;
            super.getSaveHttpService().request  =reqObj;
		 	 super.getSaveHttpService().method = "POST";
		 }
		 
		 override public function preCancelResultHandler():Object{		 	 
        	keylist = new ArrayCollection();
        	keylist.addItem("cancelViewList.cancelView");
        	return keylist;
		 }
		 
		override public function postCancelResultHandler(mapObj:Object):void
		{
			if(mapObj!=null){    		
		    	if(mapObj["errorFlag"].toString() == "error"){
		    		//result = mapObj["errorMsg"] .toString();
		    		  errPage.showError(mapObj["errorMsg"]);
		    	}else if(mapObj["errorFlag"].toString() == "noError"){	
		    		 errPage.clearError(super.getConfResultEvent());	    	
					this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('drv.label.closeout.cxl.userconf');
					confCloseOutData = (mapObj[keylist.getItemAt(0)] as ArrayCollection);
					adg.dataProvider = confCloseOutData;
					selectRendererCol.visible = false;
					//userConfirmhb
					uConfLabel.includeInLayout = true;
					uConfLabel.visible = true;
		        	submitActionBtnPanel.visible = false;
		        	submitActionBtnPanel.includeInLayout = false;
		        	actionBtnPanel.visible = true;
		        	actionBtnPanel.includeInLayout = true;
		        	uConfSubmit.enabled = true;
		        	uConfSubmit.setFocus();
		        	//uCancelConfSubmit.visible = true;
		        	//uCancelConfSubmit.includeInLayout = true;
		        	showDetails = false;
		        	sConfSubmit.includeInLayout = false;
		        	sConfSubmit.visible = false;
		        	sConfLabel.includeInLayout = false;
		        	sConfLabel.visible = false;
			        app.submitButtonInstance = uConfSubmit;		    		
		    	}else{
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    	}    		
	    	}
		} 
		
		
		override public function preCancelConfirm():void
		{
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "drv/drvCloseOutCancel.action?";  
			reqObj.method= "doCloseOutCancelSave";
	  	    reqObj.SCREEN_KEY = 10088;
            super.getConfHttpService().request  =reqObj;
		 	actionBtnPanel.enabled =false;
		}
		override public function preConfirmCancelResultHandler():Object
		{
			keylist = new ArrayCollection();
			keylist.addItem("cancelViewList.cancelView");
			return keylist;
		}
		 
		override public function postConfirmCancelResultHandler(mapObj:Object):void
		{
			if(mapObj!=null){    		
		    	if(mapObj["errorFlag"].toString() == "error"){
		    		//result = mapObj["errorMsg"] .toString();
		    		  errPage.showError(mapObj["errorMsg"]);
		    	}else if(mapObj["errorFlag"].toString() == "noError"){
		    		
		    	 errPage.clearError(super.getSaveResultEvent());	
		    	 var cIndx:int =0;
		    	 var canRefList:ArrayCollection = (mapObj[keylist.getItemAt(0)] as ArrayCollection);
		    	 for each(var cancelItem:Object in canRefList){
		    	 	this.closeRefNo += cancelItem.referenceNo;
		    	 	cIndx++;
		    	 	if(cIndx < canRefList.length){
		    	 		this.closeRefNo +=",";
		    	 	}
		    	 }		    			
	            selectRendererCol.visible = false;
			 	actionBtnPanel.enabled =true;
			 	back.includeInLayout = false;
			 	back.visible = false;
		        sConfSubmit.includeInLayout = true;
		        sConfSubmit.visible = true;
		        sConfSubmit.enabled = true;
		        sConfSubmit.setFocus();
				this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('drv.label.closeout.cxl.sysconf');        	
	        	uConfSubmit.visible = false;
	        	uConfSubmit.includeInLayout = false;
	        	uConfLabel.includeInLayout = false;
				uConfLabel.visible = false;
	        	sConfLabel.includeInLayout = true;
				sConfLabel.visible = true;
				app.submitButtonInstance = sConfSubmit;		    		
		    	}else{
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    	}    		
	    	}
		}
	override public function doCancelSystemConfirm(e:Event):void
	{
		//this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
	    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
	}
  	
        
    public function checkSelectToModify(item:Object):void {
        var i:Number;
        var tempArray:Array = new Array();
        var isSelected:Boolean = (item.selected == "true")?true:false;
         item.selected=!isSelected;
    	//messageIds.removeAll();
        if(item.selected == true){ // needs to insert
    		tradeIndexs.addItem(item.rowNo);
    	}else { //needs to pop
    		tempArray=tradeIndexs.toArray();
    	    tradeIndexs.removeAll();
    		for(i=0; i<tempArray.length; i++){
    			if(tempArray[i] != item.rowNo){
    				//XenosAlert.info("tempArray[i]"+tempArray[i]);
    			    tradeIndexs.addItem(tempArray[i]);
    			}
    		}        		
    	}    
    	//XenosAlert.info("messageIds[i]length :"+messageIds.length);
    	//conformMessageIds=	messageIds.toArray();
    	//setIfAllSelected();    	    	
    }        
    
            