// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.ref.validators.BatchQueryValidator;


import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

import mx.collections.ArrayCollection;


     [Bindable]
      private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     [Bindable]
      private var queryResult:ArrayCollection= new ArrayCollection();
     
      private var keylist:ArrayCollection = new ArrayCollection(); 
     
     [Bindable] private var mode : String = "QUERY";
      
     [Bindable] private var batchIdList:ArrayCollection = null;
     [Bindable] private var groupIdList:ArrayCollection = null;

    
    
    
	 	 /**
	  	  * Set Item Renderer to the Document Id firld of Table
	  	  */
		
		 private function changeCurrentState():void{
				currentState = "result";
				app.submitButtonInstance= null;
		
		 }
			 
    	 public function loadAll():void{
           	   parseUrlString();
           	   super.setXenosQueryControl(new XenosQuery());        
           	   referenceNo.setFocus();
           	   if(this.mode == 'QUERY'){
           	  	 this.dispatchEvent(new Event('queryInit'));
           	   }  else { 
           	   	 // XenosAlert.info("Into cancelInit");
           	     this.dispatchEvent(new Event('cancelInit'));
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
                    //XenosAlert.info("Load Url : "+ this.loaderInfo.url.toString());
                    var s:String = this.loaderInfo.url.toString();
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
	                    }                    	
                    }else{
                    	mode = "QUERY";
                    }                 

                } catch (e:Error) {
                    trace(e);
                }      
                
                	         
            }     

         
        
        override public function preQueryInit():void{	
            super.getInitHttpService().url = "ref/batchStatusQueryDispatch.action?method=initialExecute";//&SCREEN_KEY=554
       }
       
        override public function preResetQuery():void{
		     super.getResetHttpService().url = "ref/batchStatusQueryDispatch.action?method=initialExecute"; //&SCREEN_KEY=554       	
        }
        
   		override public function preQuery():void{
			setValidator();
            qh.resetPageNo();	           
            super.getSubmitQueryHttpService().url = "ref/batchStatusQueryDispatch.action?"; //SCREEN_KEY=555
            super.getSubmitQueryHttpService().request  =populateRequestParams();
            super.getSubmitQueryHttpService().method="POST";
           
		}
		
 		private function setValidator():void{
		
		 	 var validateModel:Object={
                            batchQuery:{
                                 
                               batchStartDate:this.batchStartDate.text
                                        
                            }
                           }; 
	         super._validator = new BatchQueryValidator();
	         super._validator.source = validateModel ;
	         super._validator.property = "batchQuery";
		}
		
		
 	   /**
  	 	* This method will populate the request parameters for the
    	* submitQuery call and bind the parameters with the HTTPService
    	* object.
    	*/
  		private function populateRequestParams():Object {
    	
    	       	var reqObj : Object = new Object();
		    	
		    	reqObj.method= "submitQuery";
		    	reqObj.referenceNo = this.referenceNo.text;
		    	reqObj.batchStartDate = this.batchStartDate.text;
		    	reqObj.batchId = this.batchId.selectedItem.value;
		    	reqObj.groupId = this.groupId.selectedItem.value;
	
    			return reqObj;
   		 }
		
        
        private function addCommonKeys():void{  
     
        	keylist = new ArrayCollection();      	
	    	
	       	keylist.addItem("batchIdList.item");
	       	keylist.addItem("groupIdList.item");	
	       
        }
        
        override public function preQueryResultInit():Object{
        	addCommonKeys();   	
	      	return keylist;        	
        }
        
         override public function postQueryResultInit(mapObj:Object):void{
         	
        	commonInit(mapObj);
	    		
        }
        
       
        
       private function commonInit(mapObj:Object):void{
       	
       	this.batchId.selectedIndex = 0;
       	this.groupId.selectedIndex = 0;
  		this.batchStartDate.text="";
		this.referenceNo.text="";
	
     
        	 if(this.mode == "QUERY"){
        	 	// Populate batch Id Combo Box
	        	
	        	batchIdList = new ArrayCollection();
	        	batchIdList.addItem({label: " " , value : " "});
	        	
	        	for each(var obj1:Object in mapObj["batchIdList.item"] as ArrayCollection){
	        		batchIdList.addItem(obj1);
	        	}
	        	
	        	batchIdList.refresh();
	        	
	        	
	        	// Populate group id Combo Box
	        	
	        	groupIdList = new ArrayCollection();
	        	groupIdList.addItem({label: " " , value : " "});
	        	
	        	for each(var obj2:Object in mapObj["groupIdList.item"] as ArrayCollection){
	        		groupIdList.addItem(obj2);
	        	}
	        	
	        	groupIdList.refresh();
	        	
	        	
	        	        	
	        }else{
	        	batchId.visible = false;
	        	batchId.includeInLayout = false;
	        	
	        	groupId.visible = false;
	        	groupId.includeInLayout = false;

	        }    	
    		errPage.clearError(super.getInitResultEvent());
        }
       
		override public function postQueryResultHandler(mapObj:Object):void{
    		commonResult(mapObj);
  	 	}
    
   		private function commonResult(mapObj:Object):void{    	
    	 
	    	var result:String = "";
	    	if(mapObj!=null){   
	    		 		
		    	if(mapObj["errorFlag"].toString() == "error"){
		    		//result = mapObj["errorMsg"] .toString();
		    		queryResult.removeAll();
		    		errPage.showError(mapObj["errorMsg"]);
		    	}else if(mapObj["errorFlag"].toString() == "noError"){
		    	   errPage.clearError(super.getSubmitQueryResultEvent());
		    	   //errPage.removeError();
		    	  
	               queryResult.removeAll();
		    	 
	               queryResult=mapObj["row"];
				   changeCurrentState();
			            qh.setOnResultVisibility();
			            qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
			            qh.PopulateDefaultVisibleColumns();
			             // If Details List for batch not exist then dipay no result found else display the result
	              
	              /*  if(queryResult.length>0){
	                	hb2.setVisible(true);
	                	hb2.includeInLayout=true;
	                	hb3.setVisible(false);
	                	hb3.includeInLayout=false;
	                	
	                   
	                }else{
		               hb2.setVisible(false);
		               hb2.includeInLayout=false;
		               hb3.setVisible(true);
		               hb3.includeInLayout=true;
	                   
	                }*/
		    		
		    	}else{
		    		errPage.removeError();
		    		queryResult.removeAll();
		    		qh.resetPageNo();
		    		qh.setPrevNextVisibility(false,false);
		    		/*hb2.setVisible(false);
		            hb2.includeInLayout=false;
		            hb3.setVisible(true);
		            hb3.includeInLayout=true;*/
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    	}    		
	    	}
    	
        }   
       
        
    	 override    public function preNext():Object{
    	   var reqObj : Object = new Object();
    	   reqObj.method = "doNext";
    	   return reqObj;
          }
         	
    	  override public function prePrevious():Object{
    	   
    	    var reqObj : Object = new Object();
    	    reqObj.method = "doPrevious";
    	    return reqObj;
          }	
          
          private function dispatchPrintEvent():void{
              this.dispatchEvent(new Event("print"));
          }  
          private function dispatchPdfEvent():void{
               this.dispatchEvent(new Event("pdf"));
          }  
          private function dispatchXlsEvent():void{
              this.dispatchEvent(new Event("xls"));
          }   
          private function dispatchNextEvent():void{
              this.dispatchEvent(new Event("next"));
          }  
          private function dispatchPrevEvent():void{
              this.dispatchEvent(new Event("prev"));
          }    
          
         
