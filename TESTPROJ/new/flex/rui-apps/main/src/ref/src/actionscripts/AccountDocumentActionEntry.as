// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.ref.validators.AccountDocumentActionEntryValidator;


import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.events.ResourceEvent;
import mx.resources.ResourceBundle;

 	[Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     
     [Bindable]private var mode : String = "ENTRY";
     [Bindable]private var documentActionPkStr : String = "";
     [Bindable]
     private var actionIdList:ArrayCollection = null;
     private var keylist:ArrayCollection = new ArrayCollection();
      
	  
	  private function changeCurrentState():void{
				currentState = "result";
				vstack.selectedChild = rslt;
	 }
	 
   
    
    private function errorHandler(event:ResourceEvent):void{
        XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.load.recresource', new Array("event.errorText")));
    }
	  
	   public function loadAll():void{
            parseUrlString();
            super.setXenosEntryControl(new XenosEntry());
          
           	 if(this.mode == 'ENTRY'){
           	   	 this.dispatchEvent(new Event('entryInit'));
           	   	 this.actionId.setFocus();
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
	                        }else if(tempA[0] == "documentActionPkStr"){
	                            this.documentActionPkStr = tempA[1];
	                        } 
	                    }                    	
                    }else{
                    	mode = "ENTRY";
                    }                 

                } catch (e:Error) {
                    trace(e);
                }               
            }
            
            
          override public function preEntryInit():void{            	
          	
		        var rndNo:Number= Math.random(); 
            	super.getInitHttpService().url = "ref/documentActionDispatch.action?method=addEntry";
            	var reqObj : Object = new Object();
		   		reqObj.SCREEN_KEY= 70;
            	super.getInitHttpService().request = reqObj;
            }
            
         private function addCommonKeys():void{        	
	    	keylist = new ArrayCollection();
	    	keylist.addItem("mnemonicList.item");
	    	keylist.addItem("actionIdList.item");
	    	keylist.addItem("mnemonic");
	    	keylist.addItem("shortName");
	    	keylist.addItem("accountNo");
	    	keylist.addItem("documentName");
	    	keylist.addItem("documentActionDate");
	    	keylist.addItem("remarks"); 
	    		
        }
        
        override public function preEntryResultInit():Object{
        	addCommonKeys(); 
 
        	return keylist;
        }
        
      override public function postEntryResultInit(mapObj:Object): void{
        	commonInit(mapObj);
          
        } 
        
            
          private function commonInit(mapObj:Object):void{
        	
	    	errPage.clearError(super.getInitResultEvent());
	  
	  	     if(this.mode == 'ENTRY'){
        	        	
	        	// Populate Account No Text Box
	             accountNoDispNameTxt.text = mapObj["accountNo"].toString();
	             // Populate Document Id Text Box
	             mnemonicTxt.text= mapObj["mnemonic"].toString();
	             // Populate Account Name (Short) Text Box
	             shortNameTxt.text =  mapObj["shortName"].toString();
	             // Populate Account Name (Short) Text Box
	             documentNameTxt.text =  mapObj["documentName"].toString();
	             
	             // Populate Action Id Combo Box
	        	actionIdList=new ArrayCollection();
	        	actionIdList.addItem({label: " " , value : " "});
	        	
	        	for each(var obj:Object in mapObj["actionIdList.item"] as ArrayCollection){
	              	actionIdList.addItem(obj);;
	        	}
	        	actionIdList.refresh();
	        	
	        	 // Populate Document Action Date (Short) Text Box
	             documentActionDate.text =  mapObj["documentActionDate"].toString();
	             
	             remarks.text =mapObj["remarks"].toString();
	             
	             	        	        	
	        }
	        
        }
        
      private function setValidator():void{
		
		  var validateModel:Object={
                            accountDocumentActionEntry:{
                                 
                                 documentActionDate:this.documentActionDate.text,                                 
                                 actionId:this.actionId.selectedItem.value
                                        
                            }
                           }; 
	         super._validator = new AccountDocumentActionEntryValidator();
	         super._validator.source = validateModel ;
	         super._validator.property = "accountDocumentActionEntry";
		}
  
		 override public function preEntry():void{
			setValidator();
    	 	super.getSaveHttpService().url = "ref/documentActionDispatch.action?";  
            super.getSaveHttpService().request  = populateRequestParams();
            super.getSaveHttpService().method="POST";
		 } 
		 
		   /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	
    	reqObj.method= "submitEntry";
    	reqObj.actionId = this.actionId.selectedItem.value;
    	reqObj.documentActionDate =  this.documentActionDate.text ;
    	reqObj.remarks = this.remarks.text;

    	return reqObj;
    }
    
    	 override public function preEntryResultHandler():Object
		{
			 addCommonResultKeys();
			 return keylist;
		}
		
		 private function addCommonResultKeys():void{
        	keylist = new ArrayCollection();
	    	keylist.addItem("actionAndDescription");
	    	keylist.addItem("mnemonic");
	    	keylist.addItem("shortName");
	    	keylist.addItem("accountNo");
	    	keylist.addItem("documentName");
	    	keylist.addItem("documentActionDate"); 	
	    	keylist.addItem("remarks"); 	
	    	
        } 
        
        
        override public function postEntryResultHandler(mapObj:Object):void
		{
			commonResult(mapObj);
			uConfLabel.includeInLayout = true;
			uConfLabel.visible = true;
			//uConfImg.includeInLayout =false;
			//uConfImg.visible =false;
			usrCnfMessage.text = "Document Action Information";
			this.parentDocument.initializeTitle("Document Action Entry Page- User Confirmation");
			//this.parentDocument.actionEntryContainer.name = "Document Action Entry Page- User Confirmation";
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
		    		
		    	 errPage.clearError(super.getSaveResultEvent());			    			
	             commonResultPart(mapObj);
				 changeCurrentState();
		    	 app.submitButtonInstance = uConfSubmit;
		    		
		    	}else{
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.datanotfound'));
		    	}    		
	    	}
        }
        
        
        private function commonResultPart(mapObj:Object):void{
        	// Populate Account Number Text Box
        	    uConfAccountNoDispName.text = mapObj["accountNo"].toString();
	             // Populate Document Id Text Box
	             uConfMnemonic.text= mapObj["mnemonic"].toString();
	             // Populate Account Name (Short) Text Box
	             uConfShortName.text =  mapObj["shortName"].toString();
	             // Populate Document Name  Text Box
	             uConfDocumentName.text =  mapObj["documentName"].toString();
	             // Populate Action Id Text Box
	             uConfActionAndDescription.text =  mapObj["actionAndDescription"].toString();
	              // Populate Action Date Text Box
	             uConfDocumentActionDate.text =  mapObj["documentActionDate"].toString();
	              // Populate Remarks Text Box
	             uConfRemarks.text =  mapObj["remarks"].toString();
	             
	      }
	      
	      
	      
        
         override public function preResetEntry():void
   		{
   	  
		       var rndNo:Number= Math.random();
		  	   super.getResetHttpService().url = "ref/documentActionDispatch.action?method=resetEntry&rnd=" + rndNo; 
   		}
   		
   		
		override public function preEntryConfirm():void
		{
			var reqObj :Object = new Object();
			reqObj.SCREEN_KEY = 71;
			super.getConfHttpService().url = "ref/documentActionDispatch.action?";  
			reqObj.method= "submitConfirm";
            super.getConfHttpService().request  =reqObj;
          
		}
		override public function postConfirmEntryResultHandler(mapObj:Object):void
		{
			submitUserConfResult(mapObj);
			uConfLabel.includeInLayout = true;
			uConfLabel.visible = true;
			//uConfImg.includeInLayout =false;
			//uConfImg.visible =false;
			usrCnfMessage.text = "Document Action Information";
			this.parentDocument.initializeTitle("Document Action Entry Page- System Confirmation");
			//this.parentDocument.actionEntryContainer.name = "Document Action Entry Page- System Confirmation";
		}
		
		private function submitUserConfResult(mapObj:Object):void{
    	//var mapObj:Object = mkt.userConfResultEvent(event);
    	if(mapObj!=null){    
    		//XenosAlert.info("object status : "+mapObj["errorFlag"].toString());		
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		XenosAlert.error(mapObj["errorMsg"].toString());
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    	if(mode!="cancel")
	    	   this.errPage.clearError(super.getConfResultEvent());
	    	   this.back.includeInLayout = false;
	    	   this.back.visible = false;  
	    	   this.uConfSubmit.enabled = true;	
               this.uConfLabel.includeInLayout = false;
               this.uConfLabel.visible = false;
               this.uConfSubmit.includeInLayout = false;
               this.uConfSubmit.visible = false;
               this.sConfLabel.includeInLayout = true;
               this.sConfLabel.visible = true;
               this.sConfSubmit.includeInLayout = true;
               this.sConfSubmit.visible = true;   
               this.app.submitButtonInstance = sConfSubmit;       
	    		
	    	}else{
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.erroroccurred'));
	    	}    		
    	}
    }
    
    override public function doEntrySystemConfirm(e:Event):void
	{
		     super.preEntrySystemConfirm();
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
            // this.remarks.text = "";
            // this.actionId.selectedIndex = -1;
	    	 changeToDocumentDetailsState();
			 super.postEntrySystemConfirm();
		
	}
	
	   private function changeToDocumentDetailsState():void {
	      this.parentDocument.initializeDocumentQuery();
       }
            
            
	private function doBack():void{
	 vstack.selectedChild = qry;
	 this.parentDocument.initializeTitle("Document Action Entry");
     app.submitButtonInstance = submit;	
  } 
  
  
            
            
