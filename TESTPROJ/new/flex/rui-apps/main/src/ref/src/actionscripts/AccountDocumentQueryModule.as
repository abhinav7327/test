// ActionScript file
// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.RendererFectory;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.ref.renderers.DocumentAttributesRenderer;
import com.nri.rui.ref.renderers.DocumentQueryDetailRenderer;
import com.nri.rui.ref.validators.AccountDocumentQueryValidator;

import flash.events.Event;

import mx.collections.ArrayCollection;


    [Bindable]
      private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
      private var queryResult:ArrayCollection= new ArrayCollection();
     
      private var keylist:ArrayCollection = new ArrayCollection(); 
     
     [Bindable]private var mode : String = "QUERY";
      
     [Bindable]
     private var officeIdList:ArrayCollection=null;
       [Bindable]	
     private var serviceIdList:ArrayCollection=null;
       [Bindable]
     private var documentIdList:ArrayCollection=null;
       [Bindable]
     private var documentStatusList:ArrayCollection=null;
    
    
  /**
   * Set Item Renderer to the Document Id firld of Table
   */
	
	 private function changeCurrentState():void{
			currentState = "result";
			// At the time of Displaying result system set the renderer to the table
			docIdCol.itemRenderer=new RendererFectory(DocumentAttributesRenderer,mode);
			if(mode=="QUERY"){
				viewDetails.visible= true;
				viewDetails.itemRenderer=new RendererFectory(DocumentQueryDetailRenderer,mode);
			}else{
			    viewDetails.visible= false;
			}
			
			
	 }
			 
     public function loadAll():void{
           	   parseUrlString();
           	   super.setXenosQueryControl(new XenosQuery());        
           	    officeId.setFocus();  
           	   if(this.mode == 'QUERY' || this.mode == 'ENTRY'){
           	  	 this.dispatchEvent(new Event('queryInit'));
           	   }  else { 
           	   	  //XenosAlert.info("Into cancelInit");
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
            super.getInitHttpService().url = "ref/documentQueryDispatch.action?method=initialExecute&modeOfOperation=VIEW"; 
            var reqObj : Object = new Object();
		    reqObj.SCREEN_KEY= 67;
            super.getInitHttpService().request = reqObj;
       }
       
        override public function preResetQuery():void{
		     super.getResetHttpService().url = "ref/documentQueryDispatch.action?method=initialExecute&modeOfOperation=VIEW";        	
        }
        
      override public function preQuery():void{
			setValidator();
            qh.resetPageNo();	           
            super.getSubmitQueryHttpService().url = "ref/documentQueryDispatch.action?";  
            super.getSubmitQueryHttpService().request  =populateRequestParams();
            super.getSubmitQueryHttpService().method="POST";
           
		}
		
 private function setValidator():void{
		
		  var validateModel:Object={
                            accountDocumentActionQuery:{
                                 
                               contractDateFromStr:this.contractDateFromStr.text,                                 
                               contractDateToStr:this.contractDateToStr.text,   
                               receiveDateFromStr:this.receiveDateFromStr.text,   
                               receiveDateToStr:this.receiveDateToStr.text,   
                               expiryDateToStr:this.expiryDateToStr.text,   
                               expiryDateFromStr:this.expiryDateFromStr.text  
                                        
                            }
                           }; 
	         super._validator = new AccountDocumentQueryValidator();
	         super._validator.source = validateModel ;
	         super._validator.property = "accountDocumentActionQuery";
		}
		
		
 /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
  private function populateRequestParams():Object {
    	
    	       	var reqObj : Object = new Object();
		    	
		    	reqObj.method= "submitQuery";
		    	reqObj.SCREEN_KEY= 68;
		    	reqObj.officeId = this.officeId.selectedItem.value;
		    	//reqObj.customerCode = this.customerCode.customerCode.text;
			    reqObj.fundCode = this.fundCode.fundCode.text;
			    reqObj.serviceId = this.serviceId.selectedItem.value;
			    reqObj.documentId = this.documentId.selectedItem.value;
			    reqObj.receiveDateFromStr = this.receiveDateFromStr.text;
			    reqObj.receiveDateToStr = this.receiveDateToStr.text;
			    reqObj.documentStatus = this.documentStatus.selectedItem.value;
			    
			    reqObj.outstandingPeriod = this.outstandingPeriod.text;
			    reqObj.accountNo = this.accountNo.accountNo.text;
			    reqObj.contractDateFromStr = this.contractDateFromStr.text;
			    reqObj.contractDateToStr = this.contractDateToStr.text;
			    reqObj.expiryDateFromStr = this.expiryDateFromStr.text;
			    reqObj.expiryDateToStr = this.expiryDateToStr.text;
	    	
    	
    	return reqObj;
    }
		
        
        private function addCommonKeys():void{  
     
        	keylist = new ArrayCollection();      	
	    	keylist.addItem("officeIdList.officeId");
	       	keylist.addItem("serviceIdList.item");
	       	keylist.addItem("documentIdList.item");	
	        keylist.addItem("documentStatusList.item");
	        keylist.addItem("documentStatus");
        }
        
        override public function preQueryResultInit():Object{
        	addCommonKeys();   	
	      	return keylist;        	
        }
        
         override public function postQueryResultInit(mapObj:Object):void{
         	
        	commonInit(mapObj);
	    		
        }
        
        public function documentStatusOnChange(event:Event):void{
         if (documentStatus.selectedItem.value=="OUTSTANDING"){
        		periodInDys.visible=true;
        	}else{
        		periodInDys.visible=false;
        	}
        }
        
       private function commonInit(mapObj:Object):void{
       	
       	this.officeId.selectedIndex=0;
       	//this.customerCode.customerCode.text="";
		this.fundCode.fundCode.text="";
		this.serviceId.selectedIndex=0;
        this.documentId.selectedIndex=0;
		this.receiveDateFromStr.text="";
	    this.receiveDateToStr.text="";
		this.documentStatus.selectedIndex=0;
		this.outstandingPeriod.text="";
		this.accountNo.accountNo.text="";
	    this.contractDateFromStr.text="";
        this.contractDateToStr.text="";
		this.expiryDateFromStr.text="";
		this.expiryDateToStr.text="";
		this.periodInDys.visible=false;
     
        	 if(this.mode == "QUERY" || this.mode == 'ENTRY'){
        	 	// Populate Office Id Combo Box
	        	officeIdList=new ArrayCollection();
	        	officeIdList.addItem({label: " " , value : " "});
	        	
	        	for each(var obj:String in mapObj["officeIdList.officeId"] as ArrayCollection){
	              	officeIdList.addItem({label: obj , value : obj});;
	        	}
	        	
	        	officeIdList.refresh();
	        	
	        	// Populate Service id Combo Box
	        	
	        	serviceIdList=new ArrayCollection();
	        	serviceIdList.addItem({label: " " , value : " "});
	        	
	        	for each(var obj1:Object in mapObj["serviceIdList.item"] as ArrayCollection){
	        	serviceIdList.addItem(obj1);
	        	}
	        	
	        	serviceIdList.refresh();
	        	
	        	// Populate Document id Combo Box
	        	
	        	documentIdList=new ArrayCollection();
	        	documentIdList.addItem({label: " " , value : " "});
	        	
	        	for each(var obj2:Object in mapObj["documentIdList.item"] as ArrayCollection){
	        	documentIdList.addItem(obj2);
	        	}
	        	
	        	documentIdList.refresh();
	        	
	        	// Populate Document Status Combo Box
	        	
	        	documentStatusList=new ArrayCollection();
	        	// documentStatusList.addItem({label: " " , value : " "});
	        	
	        	var selectedIndx:int=0;
	        	
	        	for (var indx:int=0;indx<(mapObj["documentStatusList.item"] as ArrayCollection).length;indx++){
	        	
	        	var obj3:Object = (mapObj["documentStatusList.item"] as ArrayCollection).getItemAt(indx);
	        		        	
	        		documentStatusList.addItem(obj3);
	        		
	        		if(obj3.value==mapObj['documentStatus'].toString()){
	        			selectedIndx=indx;
	        		}
	        			
	        	}
	           	documentStatusList.refresh();
	        	documentStatus.selectedIndex=selectedIndx;
	        	        	
	        }else{
	        	officeId.visible = false;
	        	officeId.includeInLayout = false;
	        	documentStatus.visible = false;
	        	documentStatus.includeInLayout = false;
	        	serviceId.visible = false;
	        	serviceId.includeInLayout = false;
	        	documentId.visible = false;
	        	documentId.includeInLayout = false;
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
	    		
	    	}else{
	    		errPage.removeError();
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
          
          
          
   
        
        