// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.drv.validators.DrvMarginDetailsValidator;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;			
	  
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     
            [Bindable]private var mode : String = "entry";
            [Bindable]private var drvMarginPkStr : String = "";
            [Bindable]private var tradeRefNoStr : String = "";
            private var keylist:ArrayCollection = new ArrayCollection();
	  
	  private function changeCurrentState():void{
				//hdbox1.selectedChild = this.rslt;
				//currentState = "result";
				vstack.selectedChild = rslt;
	 }
	 
    
			   public function loadAll():void{
           	   parseUrlString();
           	   super.setXenosEntryControl(new XenosEntry());
           	   //XenosAlert.info("mode : "+mode);
           	   if(this.mode == 'entry'){
           	   	 this.dispatchEvent(new Event('entryInit'));
           	   	 this.trdReferenceNo.setFocus();
				//hdbox1.selectedChild = this.qry;
           	   	 //this.currentState="entryState";
           	   	 vstack.selectedChild = qry;
           	   } else if(this.mode == 'marginamend'){
           	   	 this.dispatchEvent(new Event('amendEntryInit'));
           	   	 this.baseDate.setFocus();
				//hdbox1.selectedChild = this.qry;
           	   	 //this.currentState="entryState";
           	   	 vstack.selectedChild = qry;
           	   } else { 
           	     this.dispatchEvent(new Event('cancelEntryInit'));
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
	                        }
	                        if(tempA[0] == "marginPk"){
	                            this.drvMarginPkStr = tempA[1];
	                        }
	                        if(tempA[0] == "tradeRefNo"){
	                            this.tradeRefNoStr = tempA[1];
	                        } 
	                    }                    	
                    }else{
                    	mode = "entry";
                    }                 

                } catch (e:Error) {
                    trace(e);
                }               
            }
            
            override public function preEntryInit():void{            	
		        var rndNo:Number= Math.random(); 
            	super.getInitHttpService().url = "drv/drvMarginEntry.action?method=initialExecute&&mode=entry&&menuType=Y&SCREEN_KEY=11029&rnd=" + rndNo;
            }
            override public function preAmendInit():void{     
            	initLabel.text = this.parentApplication.xResourceManager.getKeyValue('drv.label.marginamend');      	
		        var rndNo:Number= Math.random(); 
            	super.getInitHttpService().url = "drv/drvMarginAmend.action?";
            	var reqObject:Object = new Object();
            	reqObject.rnd = rndNo;
            	reqObject.method= "doAmend";
		  		reqObject.mode=this.mode;
		  		reqObject.marginPk = this.drvMarginPkStr;
		  		reqObject.tradeRefNo = this.tradeRefNoStr;
		  		reqObject['SCREEN_KEY'] = "11036";
		  		super.getInitHttpService().request = reqObject;
            }
            override public function preCancelInit():void{            	
		        this.back.includeInLayout = false;
			    this.back.visible = false;
			    changeCurrentState(); 			             	
		        var rndNo:Number= Math.random(); 
            	super.getInitHttpService().url = "drv/drvMarginCancel.action?";
            	var reqObject:Object = new Object();
            	reqObject.rnd = rndNo;
            	reqObject.method= "doCancel";
		  		reqObject.mode=this.mode;
		  		reqObject.marginPk = this.drvMarginPkStr;
		  		reqObject.tradeRefNo = this.tradeRefNoStr;
		  		reqObject['SCREEN_KEY'] = "11041";
		  		super.getInitHttpService().request = reqObject;
            }
       
        
        private function addCommonKeys():void{        	
	    	keylist = new ArrayCollection();
	    	keylist.addItem("actionMode");
	    	keylist.addItem("dropDownListValues.marginTypeList.item");	
        }
        
        override public function preEntryResultInit():Object{
        	addCommonKeys(); 
        	return keylist;
        }
        
        override public function preAmendResultInit():Object{
        	addCommonKeys();
        	keylist.addItem("marginVO.referenceNo");
        	keylist.addItem("marginVO.marginTypeStr");
        	keylist.addItem("marginVO.baseDateStr");
        	keylist.addItem("marginVO.marginAmountStr");
        	keylist.addItem("marginVO.marginCcyStr");
        	
        	keylist.addItem("marginVO.marginType");
        		
        	return keylist;
        }
        override public function preCancelResultInit():Object{
        	addCommonResultKes();         	
        	return keylist;
        }
        
        private function commonInit(mapObj:Object):void{
        	this.trdReferenceNo.text = "";
	    	this.baseDate.text = "";
	    	this.marginAmount.text = "";
	    	this.marginCcy.ccyText.text = "";
	    	errPage.clearError(super.getInitResultEvent());
	    	
		    this.marginType.dataProvider = mapObj[keylist.getItemAt(1)] as ArrayCollection;
	    	
        }
        
        override public function postEntryResultInit(mapObj:Object): void{
        	app.submitButtonInstance = submit;
        	commonInit(mapObj);
        	this.marginType.selectedIndex = 1;
        	this.marginType.enabled = false;
        }
        
        override public function postAmendResultInit(mapObj:Object): void{
        	app.submitButtonInstance = submit;
        	commonInit(mapObj);
        	this.trdReferenceNo.text = this.tradeRefNoStr;
        	this.marginReferenceNo.text = mapObj[keylist.getItemAt(2)].toString();
	    	this.baseDate.text = mapObj[keylist.getItemAt(4)].toString();
	    	this.marginAmount.text = mapObj[keylist.getItemAt(5)].toString();
	    	this.marginCcy.ccyText.text = mapObj[keylist.getItemAt(6)].toString();
	    	
	    	var marginTypeStr:String = mapObj[keylist.getItemAt(7)].toString();
	    	if(XenosStringUtils.equals(marginTypeStr,"A")){
	    		this.marginType.selectedIndex = 1;
	    	}else if(XenosStringUtils.equals(marginTypeStr,"I")){
	    		this.marginType.selectedIndex = 0;
	    	}
	    	
	    	this.marginType.enabled = false;
	    	this.marginReferenceNo.visible = true;
	    	this.marginRefNoLebel.visible = true;
	    	this.trdReferenceNo.enabled = false;
	    	this.marginReferenceNo.enabled = false;
        	
        }
        private function commonResultPart(mapObj:Object):void{
    		 this.uConfTrdReferenceNo.text = mapObj[keylist.getItemAt(0)].toString();
             this.uConfMarginRefNo.text = mapObj[keylist.getItemAt(1)].toString();
             this.uConfMarginType.text = mapObj[keylist.getItemAt(2)].toString();
             this.uConfBaseDate.text = mapObj[keylist.getItemAt(3)].toString();             
             this.uConfMarginAmount.text = mapObj[keylist.getItemAt(4)].toString();
             this.uConfMarginCcy.text = mapObj[keylist.getItemAt(5)].toString();
        }
        override public function postCancelResultInit(mapObj:Object): void{
        		
            commonResultPart(mapObj);
        	uConfSubmit.includeInLayout = false;
        	uConfSubmit.visible = false;
        	cancelSubmit.visible = true;
        	cancelSubmit.includeInLayout = true;
        	app.submitButtonInstance = cancelSubmit;
        }
        private function addCommonResultKes():void{
        	keylist = new ArrayCollection();
        	keylist.addItem("marginVO.tradeRefNo");
        	keylist.addItem("marginVO.referenceNo");
        	keylist.addItem("marginVO.marginTypeStr");
        	keylist.addItem("marginVO.baseDateStr");
        	keylist.addItem("marginVO.marginAmountStr");
        	keylist.addItem("marginVO.marginCcyStr");
        }
        
        private function commonResult(mapObj:Object):void{
        	
		 	//XenosAlert.info("commonResult ");
		 	if(mapObj!=null){    		
		    	if(mapObj["errorFlag"].toString() == "error"){
		    		//result = mapObj["errorMsg"] .toString();
		    		if(mode != "cancel"){
		    		  errPage.showError(mapObj["errorMsg"]);		    			
		    		}else{
		    			XenosAlert.error(mapObj["errorMsg"]);
		    		}
		    	}else if(mapObj["errorFlag"].toString() == "noError"){
		    		if(mode != "cancel"){
		    	 		errPage.clearError(super.getSaveResultEvent());
		    	 	}			    			
             		commonResultPart(mapObj);
				 	changeCurrentState();
		    	 	app.submitButtonInstance = uConfSubmit;
		    		
		    	}else{
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    	}
	    	}
        }
        
    	private function setValidator():void{
			var validateModel:Object={
                            drvMarginEntry:{                                
                                trdRefNo:this.trdReferenceNo.text,
								marginType:this.marginType.selectedItem != null ? this.marginType.selectedItem.value : "",
								baseDate:this.baseDate.text,
								marginAmount:this.marginAmount.text
                            }
                           }; 
	         super._validator = new DrvMarginDetailsValidator();
	         super._validator.source = validateModel ;
	         super._validator.property = "drvMarginEntry";
		  
		}
		 override public function preEntry():void{
		 	setValidator();
		 	//XenosAlert.info("preEntry ");
		 	super.getSaveHttpService().url = "drv/drvMarginEntry.action?";  
            super.getSaveHttpService().request  =populateRequestParams();
            super.getSaveHttpService().method = 'POST';
		 }
		 
		 override public function preAmend():void{
		 	setValidator();
		 	super.getSaveHttpService().url = "drv/drvMarginAmend.action?";  
            super.getSaveHttpService().request  =populateRequestParams();
		 } 
		 override public function preCancel():void{
		 	//setValidator();
		 	super._validator = null;
		 	super.getSaveHttpService().url = "drv/drvMarginCancel.action?"; 
		 	 var reqObj:Object = new Object();
		 	 reqObj.method="doCancelConfirm";
		 	 reqObj.mode=this.mode;
		 	 reqObj['SCREEN_KEY'] = "11042";
            super.getSaveHttpService().request  =reqObj;
		 }
		 
		 
		override public function preEntryResultHandler():Object
		{
			 addCommonResultKes();
			 return keylist;
		}
		
		override public function preAmendResultHandler():Object
		{
			addCommonResultKes();
			return keylist;
		} 
		
		override public function postCancelResultHandler(mapObj:Object):void
		{
			submitUserConfResult(mapObj);
			if(mapObj!=null){    
	    		if( ! mapObj["errorFlag"].toString() == "error" ){
	    			this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('drv.label.margin.cxl.userconf');
					uConfLabel.includeInLayout = true;
					uConfLabel.visible = true;
					cancelSubmit.visible = false;
        			cancelSubmit.includeInLayout = false;
		        	uCancelConfSubmit.visible = true;
		        	uCancelConfSubmit.includeInLayout = true;
		        	sConfSubmit.includeInLayout = false;
		        	sConfSubmit.visible = false;
		        	sConfLabel.includeInLayout = false;
		        	sConfLabel.visible = false;
			        app.submitButtonInstance = uCancelConfSubmit;
		    	}
		 	}	
			
		} 
		
		override public function postEntryResultHandler(mapObj:Object):void
		{
			commonResult(mapObj);
			uConfLabel.includeInLayout = true;
			uConfLabel.visible = true;
			uConfImg.includeInLayout =false;
			uConfImg.visible =false;
			usrCnfMessage.text =this.parentApplication.xResourceManager.getKeyValue('drv.label.margin.entry.userconf');
		}
		
		override public function postAmendResultHandler(mapObj:Object):void
		{
			commonResult(mapObj);
			uConfLabel.includeInLayout = true;
			uConfLabel.visible = true;
			usrCnfMessage.text = this.parentApplication.xResourceManager.getKeyValue('drv.label.margin.amend.userconf');
			app.submitButtonInstance = uConfSubmit;
		}		 
		 
		
		override public function preEntryConfirm():void
		{
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "drv/drvMarginEntry.action?";  
			reqObj.method= "doEntrySave";
			reqObj['SCREEN_KEY'] = "11031";
            super.getConfHttpService().request  =reqObj;
            actionBtnPanel.enabled =false;
		}
		
		override public function preAmendConfirm():void
		{
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "drv/drvMarginAmend.action?";  
			reqObj.method= "doAmendSave";
			reqObj['SCREEN_KEY'] = "11038";
            super.getConfHttpService().request  =reqObj;
            actionBtnPanel.enabled =false;
		}
		
		override public function preCancelConfirm():void
		{
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "drv/drvMarginCancel.action?";  
			reqObj.method= "doCancelSave";
			reqObj['SCREEN_KEY'] = "11043";
            super.getConfHttpService().request  =reqObj;
            actionBtnPanel.enabled =false;
		}
		override public function preEntryConfirmResultHandler():Object
		{
			keylist = new ArrayCollection();
	    	keylist.addItem("marginVO.tradeRefNo");
	    	keylist.addItem("marginVO.referenceNo");
	    	keylist.addItem("marginVO.versionNo");
	    	return keylist;
		}
		override public function postConfirmEntryResultHandler(mapObj:Object):void
		{
			submitUserConfResult(mapObj);
			uConfLabel.includeInLayout = true;
			uConfLabel.visible = true;
			uConfImg.includeInLayout =false;
			uConfImg.visible =false;
			usrCnfMessage.text =this.parentApplication.xResourceManager.getKeyValue('drv.label.margin.entry.sysconf');
			marginRefConfMessage.text= this.parentApplication.xResourceManager.getKeyValue('drv.label.margin.refno')+ " : "+ mapObj[keylist.getItemAt(1)]+" - "+mapObj[keylist.getItemAt(2)];
			tradeRefConfMessage.text= this.parentApplication.xResourceManager.getKeyValue('drv.label.tradereferenceno')+ " : "+ mapObj[keylist.getItemAt(0)];
			actionBtnPanel.enabled =true;
		}
		override public function preConfirmAmendResultHandler():Object
		{
			keylist = new ArrayCollection();
	    	keylist.addItem("marginVO.tradeRefNo");
	    	keylist.addItem("marginVO.referenceNo");
	    	keylist.addItem("marginVO.versionNo");
	    	return keylist;
		}
		override public function postConfirmAmendResultHandler(mapObj:Object):void
		{
			submitUserConfResult(mapObj);
			this.parentDocument.title =this.parentApplication.xResourceManager.getKeyValue('drv.label.margin.amend.sysconf');
			marginRefConfMessage.text= this.parentApplication.xResourceManager.getKeyValue('drv.label.margin.refno')+" : "+ mapObj[keylist.getItemAt(1)]+" - "+mapObj[keylist.getItemAt(2)];
			tradeRefConfMessage.text= this.parentApplication.xResourceManager.getKeyValue('drv.label.tradereferenceno')+" : "+ mapObj[keylist.getItemAt(0)];
			actionBtnPanel.enabled =true;
		}
		override public function preConfirmCancelResultHandler():Object
		{
			keylist = new ArrayCollection();
	    	keylist.addItem("marginVO.tradeRefNo");
	    	keylist.addItem("marginVO.referenceNo");
	    	keylist.addItem("marginVO.versionNo");
	    	return keylist;
		}
		override public function postConfirmCancelResultHandler(mapObj:Object):void
		{
			submitUserConfResult(mapObj);
			this.parentDocument.title =this.parentApplication.xResourceManager.getKeyValue('drv.label.margin.cxl.sysconf');
        	cancelSubmit.visible = false;
        	cancelSubmit.includeInLayout = false;
        	uCancelConfSubmit.visible = false;
        	uCancelConfSubmit.includeInLayout = false;
        	uConfLabel.includeInLayout = false;
			uConfLabel.visible = false;
			marginRefConfMessage.text= this.parentApplication.xResourceManager.getKeyValue('drv.label.margin.refno')+" : "+ mapObj[keylist.getItemAt(1)]+" - "+mapObj[keylist.getItemAt(2)];
			tradeRefConfMessage.text= this.parentApplication.xResourceManager.getKeyValue('drv.label.tradereferenceno')+" : "+ mapObj[keylist.getItemAt(0)];
			actionBtnPanel.enabled =true;
		}
		
		private function submitUserConfResult(mapObj:Object):void{
    		if(mapObj!=null){
	    		//XenosAlert.info("object status : "+mapObj["errorFlag"].toString());		
		    	if(mapObj["errorFlag"].toString() == "error"){
		    		usrConfErrPage.showError(mapObj["errorMsg"]);
		    	}else if(mapObj["errorFlag"].toString() == "noError"){
		    		usrConfErrPage.clearError(super.getConfResultEvent());
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
	               app.submitButtonInstance = sConfSubmit;
		    	}else{
		    		usrConfErrPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred'));
		    	}    		
	    	}
    	}
    
      /**
	    * This method will populate the request parameters for the
	    * submitQuery call and bind the parameters with the HTTPService
	    * object.
	    */
	    private function populateRequestParams():Object {
	    	
	    	var reqObj : Object = new Object();
	    	
	    	if(this.mode == 'entry'){
		    	reqObj.method= "doEntryConfirm";
		    	reqObj['SCREEN_KEY'] = "11030";
		    }
		    if(this.mode == 'marginamend'){
	    		reqObj.method= "doAmendConfirm";
	    		reqObj['SCREEN_KEY'] = "11037";
		    }
	    	
	    	reqObj['marginVO.tradeRefNo'] = this.trdReferenceNo.text;
	    	reqObj['marginVO.marginType'] = this.marginType.selectedItem != null ? this.marginType.selectedItem.value : "";
	    	reqObj['marginVO.baseDateStr'] = this.baseDate.text;
	    	reqObj['marginVO.marginAmountStr'] = this.marginAmount.text;
	    	reqObj['marginVO.marginCcyStr'] = this.marginCcy.ccyText.text;
	
	    	return reqObj;
	    }
    
	   override public function preResetEntry():void
	   {
			 var rndNo:Number= Math.random();
			 super.getResetHttpService().url = "drv/drvMarginEntry.action?method=initialExecute&rnd=" + rndNo; 
	   }
	   override public function preResetAmend():void
	   {
			var rndNo:Number= Math.random();
			super.getResetHttpService().url = "drv/drvMarginAmend.action?method=doAmend&marginPk="+this.drvMarginPkStr+"&tradeRefNo="+this.tradeRefNoStr+"&rnd=" + rndNo; 
	   }
	   
	   
		override public function doEntrySystemConfirm(e:Event):void
		{
		      super.preEntrySystemConfirm();
	    	 this.dispatchEvent(new Event('entryReset'));
			 this.back.includeInLayout = true;
			 this.back.visible = true;
	         uConfLabel.includeInLayout = true;
	         uConfLabel.visible = true;
	         uConfSubmit.includeInLayout = true;
	         uConfSubmit.visible = true;
	         sConfLabel.includeInLayout = false;
	         sConfLabel.visible = false;
	         sConfSubmit.includeInLayout = false;
	         sConfSubmit.visible = false;
	         this.uConfTrdReferenceNo .text = "";
	         this.uConfMarginType .text = "";
	         this.uConfMarginRefNo .text = "";
	         this.uConfBaseDate.text = "";
	         this.uConfMarginAmount.text = "";
	         this.uConfMarginCcy.text = "";
	           
			
			 //hdbox1.selectedChild = this.qry;
	       	// this.currentState="entryState";
	       	 vstack.selectedChild = qry;	
			 super.postEntrySystemConfirm();
			
		}
	
		override public function doAmendSystemConfirm(e:Event):void
		{
			//this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
		    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
		}
		override public function doCancelSystemConfirm(e:Event):void
		{
			//this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
		    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
		}
  
	    private function doBack():void{
			//hdbox1.selectedChild = this.qry;
	   	   	 //this.currentState="entryState";
	   	   	 this.usrConfErrPage.removeError();
	   	   	 vstack.selectedChild = qry;
	   	   	 app.submitButtonInstance = submit;
	   	   	 if(XenosStringUtils.equals(this.mode,"marginamend")){
	   	   	 	this.parentDocument.title =this.parentApplication.xResourceManager.getKeyValue('drv.label.margin.amend');
	   	   	 }
	    }
		