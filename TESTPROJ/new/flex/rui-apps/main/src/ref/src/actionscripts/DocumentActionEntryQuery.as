import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;

import mx.managers.PopUpManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

		   [Bindable]
		   private var xmlObj:XML;
		   [Bindable]
		   private var accountAgreementPk:String; 
		   private var hiddenAccountNo:String; 
		   private var accountNo:String; 
		   private var mode:String; 
		  	   	   
          
            
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
                        if (tempA[0] == Globals.ACCOUNT_AGREEMENT_PK_STR) {
                            accountAgreementPk = tempA[1];
                        } 
                        else if (tempA[0] ==Globals.HIDDEN_ACCOUNT_NO) {
                            hiddenAccountNo = tempA[1];
                        }
                        else if (tempA[0] == Globals.ACCOUNT_NO) {
                            accountNo = tempA[1];
                        }
                        else if (tempA[0] == Globals.MODE) {
                            mode = tempA[1];
                        }
                        
                    }                    

                  
                } catch (e:Error) {
                    trace(e);
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
			
			public function init():void{
							
				parseUrlString();
				var req : Object = new Object();
				req.SCREEN_KEY=73;	
			   	req.accountAgreementPk=accountAgreementPk;	
				req.hiddenAccountNo=hiddenAccountNo;	
				req.accountNo=accountNo;	
				req.modeOfOperation=mode;	
				httpService.request=req;			
				httpService.send();
				PopUpManager.centerPopUp(this);
				
			}
			
            private function httpService_fault(evt:FaultEvent):void {
                XenosAlert.error(evt.fault.faultDetail);
            }


            private function httpService_result(evt:ResultEvent):void {
                      	
                xmlObj = evt.result as XML;
                              
           
             
             // Created the same no of row for Header List returned by the XML   
                var headerLenght:int= documentHeaderList.length;
                if(headerLenght>0){
                headerGrid.rowCount =headerLenght+1;
                  // If Mode== Entry then Display Add or Cancel button                
                if(this.mode=="ENTRY"){
                	cntrlBtn.visible=true;
                }
                }
                else{
                headerGrid.rowCount =1;
                }
                
                // If Details List for Document not exist then dipay no result found else display the result
                if(documentDetailList.length>0){
                	hb2.setVisible(true);
                	hb2.includeInLayout=true;
                	hb3.setVisible(false);
                	hb3.includeInLayout=false;
                	// Created the same no of row for detail List returned by the XML   
                	detailGrid.rowCount =documentDetailList.length;
                   
                }else{
	               hb2.setVisible(false);
	               hb2.includeInLayout=false;
	               hb3.setVisible(true);
	               hb3.includeInLayout=true;
                   
                }
            }
            
            
          private function changeToEntryState(event:Event):void {
              this.parentDocument.initializeActionEntry();
          }
            
            
            

		