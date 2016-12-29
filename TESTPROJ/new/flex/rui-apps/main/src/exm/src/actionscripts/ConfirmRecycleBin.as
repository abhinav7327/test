

import com.nri.rui.core.controls.XenosAlert;

import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

		   [Bindable]
		   private var xmlObj:XML; 
		   private var mode:String;
		   private var objMessageId:Object = {};
		   public var opName:String="";
		   public var operationName:String;
		   public var localMessageIds:Array;
		   public var modeUrl:String;   	   
          
            
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
		                
		                if (tempA[0] == "messageId") {
		                    objMessageId.messageId = tempA[1]+"="+tempA[2];
		                }
		                if (tempA[0] == "actionType") {
		                    objMessageId.actionType = tempA[1];
		                }
		                if (tempA[0] == "mode") {
		                    modeUrl = tempA[1];
		                }
                    }
                  
                } catch (e:Error) {
                    trace(e);
                }
               
            }
            
           public function setMode():void{
           		parseUrlString();
               if(modeUrl=="home"){
               		setUrl();
               }
           } 
            
		   /**
		   * Add return XML Object to the XML Source
		   *
		   **/
			public function set xmlSource(value:XML):void{
				xmlObj=value;
			}
			
			/**
			 * Populte the parameter value to Request Object befor call httpService
			 **/
			
			public function init(actionType:String):void{
							
				parseUrlString();
				var req : Object = new Object();
			   	req.mode="Restore";
			   	req.SCREEN_KEY = '2';
				httpService.request=req;			
				httpService.send();
				PopUpManager.centerPopUp(this);
				operationName=actionType;
			}
						
			public function setUrl():void{
				
				localMessageIds = this.parentDocument.owner.SelectedMessageIds;			
				parseUrlString();
				var req : Object = new Object();
			   	req.mode="Restore";
			   	req.messageIds=localMessageIds;
			   	req.SCREEN_KEY = '2';	
				httpService.request=req;			
				httpService.send();
				operationName=objMessageId.actionType;
			}
			
            private function httpService_fault(evt:FaultEvent):void {
                XenosAlert.error(evt.fault.faultDetail);
            }


            private function httpService_result(evt:ResultEvent):void {
                      	
                xmlObj = evt.result as XML;
            }
            
            public function OperationRequest(event:Event):void {
     					opName=operationName;    	
     	   	
     				 if(objMessageId.messageId!=null ) {
	     				var requestObj :Object = new Object();
	     				requestObj.random = Math.random();
	     				requestObj.SCREEN_KEY = '2';
						switch(operationName){
							case "Delete":
					       	requestObj.method = "shiftDeleteMessage";					       
				           	requestObj.queueId="trashq";
					        break;
							case "Restore":
					       	requestObj.method = "restoreMessage";
				           	requestObj.queueId="trashq";
					        break;				   
					
						}requestObj.messageIds=objMessageId.messageId;
						restoreXmlRequest.request=requestObj;
						restoreXmlRequest.send();
						
						visiblityControl();
						
						this.parentDocument.disableClosePopUp();
     	 			}
					else if(localMessageIds.length>0) {
	     				var reqObj :Object = new Object();
	     				reqObj.random = Math.random();
	     				reqObj.SCREEN_KEY = '2';
						switch(operationName){
							case "Delete":
					       	reqObj.method = "shiftDeleteMessage";					       
				           	reqObj.queueId="trashq";
					        break;
							case "Restore":
					       	reqObj.method = "restoreMessage";
				           	reqObj.queueId="trashq";
					        break;				   
					
						}
						reqObj.messageIds=localMessageIds;
						restoreXmlRequest.request=reqObj;
						restoreXmlRequest.send();
						
						visiblityControl();
     	 			}else{
     	    			  XenosAlert.error("Error Occured for Message " + operationName + "operation");	
     	 			}
    		}
    		
    		private function visiblityControl():void{
    			lblHead.text="Exm Browse RecycleBin Page- System Confirmation";
				btnConfirm.includeInLayout=false;
				btnConfirm.visible=false;
				btnCancel.includeInLayout=false;
				btnCancel.visible=false;
				btnOk.includeInLayout=true;
				btnOk.visible=true;
    		}
    		
    		public function cancelOperation():void{
    			if(modeUrl=="home"){
    				this.parentDocument.removeMe();
    			}else{
    				this.parentDocument.initializeDocumentQuery();
    			}
    		}
    		
    		public function okOperation():void{
    			if(modeUrl=="home"){    				
    				this.parentDocument.owner.conformMessageIds=null;
	             	this.parentDocument.owner.reQuery();
	    			this.parentDocument.removeMe();
	    		}else{
	    			this.parentDocument.initializeDataGrid();
	    		}
    		}
    		
    		private function OperationResult(event: ResultEvent) : void {
         
                if(null == event.result.XenosErrors){ // i.e. No result but no Error found.
                    errPage.clearError(event);
                } else { // Must be error
                    errPage.displayError(event);                
                }
     		} 