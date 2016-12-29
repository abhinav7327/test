// ActionScript file
import mx.collections.ArrayCollection;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.rpc.events.ResultEvent;

import com.nri.rui.core.Globals;
import com.nri.rui.core.RendererFectory;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;

			
	  //private var mkt:XenosQuery = new MarketPriceQuery();
	  
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
    private var queryResult:ArrayCollection= new ArrayCollection();
     
     private var keylist:ArrayCollection = new ArrayCollection(); 
     private var appRoleColl:ArrayCollection = new ArrayCollection();
     [Bindable]private var mode : String = "query";
     [Bindable] private var offId:String = "";
           
	  
	  private function changeCurrentState():void{
				currentState = "result";
	 }
			 
           public function loadAll():void{
           	   parseUrlString();
           	   super.setXenosQueryControl(new XenosQuery());
           	   //XenosAlert.info("mode : "+mode);
           	   if(this.mode == 'query'){
           	   	 this.dispatchEvent(new Event('queryInit'));
           	   	 this.appRole.setFocus();
           	   } else if(this.mode == 'amend'){
           	   	 this.dispatchEvent(new Event('amendInit'));
           	   	 this.appRole.setFocus();
           	   	 addColumn();
           	   } else { 
           	     this.dispatchEvent(new Event('cancelInit'));
           	   	 this.appRole.setFocus();
           	   	 addColumn();
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
                    	mode = "query";
                    }                 

                } catch (e:Error) {
                    trace(e);
                }               
            }
        override public function preQueryInit():void{
	       	var rndNo:Number= Math.random();
	        var reqObj:Object = new Object();
	        reqObj.SCREEN_KEY = 113;
	        super.getInitHttpService().request = reqObj;
	  		super.getInitHttpService().url = "ref/applicationRoleQueryDispatch.action?method=initialExecute&mode=query&menuType=Y&rnd=" + rndNo;        	
        }
        
        override public function preAmendInit():void{
		   var rndNo:Number= Math.random();
		   super.getInitHttpService().url = "ref/applicationRoleQueryAmendDispatch.action?&rnd=" + rndNo;
		     var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="initialExecute";
		  		super.getInitHttpService().request = reqObject;     	
        }
        
        override public function preCancelInit():void{
		   var rndNo:Number= Math.random();
		   super.getInitHttpService().url = "ref/applicationRoleQueryCancelDispatch.action?&rnd=" + rndNo;  
		     var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="initialExecute";
		  		super.getInitHttpService().request = reqObject;      	
        }        
        
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();      	
	    	keylist.addItem("applicationRoleNames.applicationRoleName");
	    	keylist.addItem("serviceOfficeList.officeId");
        }
        
        override public function preQueryResultInit():Object{
        	//var keylist:ArrayCollection = new ArrayCollection(); 
        	addCommonKeys();    	
	    	return keylist;        	
        }
        
        override public function preAmendResultInit():Object{
        	//var keylist:ArrayCollection = new ArrayCollection(); 
        	addCommonKeys();   		    	
	    	return keylist;        	
        }
        
        override public function preCancelResultInit():Object{
        	//var keylist:ArrayCollection = new ArrayCollection(); 
        	addCommonKeys();   		    	
	    	return keylist;        	
        }
        
        
        private function commonInit(mapObj:Object):void{
        	
           	app.submitButtonInstance = submit;
    		errPage.clearError(super.getInitResultEvent());
    		queryResult.removeAll();
	        //errPage.removeError();
    		
	    	var index:int=-1;
	    	var initcol:ArrayCollection = new ArrayCollection();
	    	initcol.addItem(" ");
	    	for each(var item:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
	    		initcol.addItem(item);
	    		
	    	}
		    	
	    	appRole.dataProvider=initcol; 
	    	appRole.selectedIndex =  0;
	    	appRoleColl = initcol ;
	    	
	    	initcol=new ArrayCollection();
	    	initcol.addItem(" ");
	    	index=0;
	    	for each( item in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
	    	officeId.dataProvider = initcol;
	    	officeId.selectedIndex = 0;
	    			
    		
        }
        
        override public function postQueryResultInit(mapObj:Object):void{
        	commonInit(mapObj);
	
        }
        
        
        override public function postAmendResultInit(mapObj:Object):void{
        	commonInit(mapObj);	
        }
        
        override public function postCancelResultInit(mapObj:Object):void{
        	commonInit(mapObj);	
        }
        
        	
		
		override public function preQuery():void{
			//setValidator();
               qh.resetPageNo();	
           // XenosAlert.info("I am in preQuery ");
            super.getSubmitQueryHttpService().url = "ref/applicationRoleQueryDispatch.action?";  
            super.getSubmitQueryHttpService().request  =populateRequestParams();
           
		}
		
		override public function preAmend():void{
			//setValidator();
               qh.resetPageNo();	
            //XenosAlert.info("I am in preAmend ");
            super.getSubmitQueryHttpService().url = "ref/applicationRoleQueryAmendDispatch.action?";   
            super.getSubmitQueryHttpService().request  =populateRequestParams();  
           
		}
		
		
		override public function preCancel():void{
			
			//setValidator();
			 qh.resetPageNo();	
            //XenosAlert.info("I am in preCancel ");
            super.getSubmitQueryHttpService().url = "ref/applicationRoleQueryCancelDispatch.action?"; 
            super.getSubmitQueryHttpService().request = populateRequestParams();
           
		}
		
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	
    	reqObj.method= "submitQuery";

        reqObj.SCREEN_KEY = 114;
    	
    	reqObj.applicationRoleName = this.appRole.selectedItem;
    	
    	reqObj.officeId =  this.officeId.selectedItem ;
    	if(mode != 'query'){
    	   reqObj.status =  "OPEN" ;
    		
    	}
    	
    	return reqObj;
    }
    
    override public function postQueryResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    }
    override public function postAmendResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    }
    override public function postCancelResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
    }
       
        
    private function commonResult(mapObj:Object):void{    	
    	//XenosAlert.info("mapObj : "+mapObj.toString()); 
    	//var mapObj:Object = mkt.userQueryResultEvent(event,null);
    	var result:String = "";
    	if(mapObj!=null){   
    		//XenosAlert.info("mapObj : "+mapObj.toString()); 		
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		//result = mapObj["errorMsg"] .toString();
	    		queryResult.removeAll();
	    		errPage.showError(mapObj["errorMsg"]);
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    	   errPage.clearError(super.getSubmitQueryResultEvent());
	    	   //errPage.removeError();
	    	  // XenosAlert.info("I am in errPage ");
               queryResult.removeAll();
	    	  // XenosAlert.info("I am in queryResult : "+currentState);
               queryResult=mapObj["row"];
			   changeCurrentState();
		            qh.setOnResultVisibility();
		            qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
		            qh.PopulateDefaultVisibleColumns();
	    		
	    	}else{
	    		errPage.removeError();
	    		queryResult.removeAll();
	    		currentState = "";
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}    		
    	}
    	//XenosAlert.info(result);
    }   
       
      
        override public function preResetQuery():void{
		       var rndNo:Number= Math.random();
		  		super.getResetHttpService().url = "ref/applicationRoleQueryDispatch.action?method=initialExecute&mode=query&menuType=Y&rnd=" + rndNo;        	
        }
        
        override public function preResetAmend():void{
		   var rndNo:Number= Math.random();
		   super.getResetHttpService().url = "ref/applicationRoleQueryAmendDispatch.action?&rnd=" + rndNo;
		     var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="initialExecute";
		  		super.getResetHttpService().request = reqObject;     	
        }
        
        override public function preResetCancel():void{
		   var rndNo:Number= Math.random();
		   super.getResetHttpService().url = "ref/applicationRoleQueryCancelDispatch.action?&rnd=" + rndNo;  
		     var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="initialExecute";
		  		super.getResetHttpService().request = reqObject;      	
        }       
        
        
        override    public function preGenerateXls():String{
        	 var url : String =null;
		    	var rndNo:Number= Math.random();
		    	if(mode == "query"){		    		
		            url = "ref/applicationRoleQueryDispatch.action?method=generateXLS&rnd=" + rndNo;
		    	}else if(mode == "amend"){
		           url = "ref/applicationRoleQueryAmendDispatch.action?method=generateXLS&rnd=" + rndNo;
		    	}else{
		          url = "ref/applicationRoleQueryCancelDispatch.action?method=generateXLS&rnd=" + rndNo;
		    	}		    		
		    	
		      return url;
         }	
   override public function preGeneratePdf():String{
           //XenosAlert.info("preGeneratePdf");
    	   var url : String =null;	
    	   	var rndNo:Number= Math.random();
		    	if(mode == "query"){		    		
		            url = "ref/applicationRoleQueryDispatch.action?method=generatePDF&rnd=" + rndNo;
		    	}else if(mode == "amend"){
		           url = "ref/applicationRoleQueryAmendDispatch.action?method=generatePDF&rnd=" + rndNo;
		    	}else{
		          url = "ref/applicationRoleQueryCancelDispatch.action?method=generatePDF&rnd=" + rndNo;
		    	}		    		
		    	return url;
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
             // XenosAlert.info("dispatchEvent pdf");
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
      
		private function addColumn():void
		{
			//Add a object
			
			var dg :DataGridColumn = new DataGridColumn();
			dg.dataField="";
			dg.editable = false;
			dg.headerText = "";
			dg.width = 40;
			dg.itemRenderer = new RendererFectory(ImgSummaryRenderer);
			
			var cols :Array = resultSummary.columns;
			cols.unshift(dg);
			resultSummary.columns = cols;
			
		}
		/**
    	 * The function is used to call a httpservice
    	 * after changing the officeid combo
    	 */
		private function getApplicationRoleName():void {
			
			if (officeId.selectedItem !=" "){
		    	var reqObj:Object = new Object();
		    	reqObj.officeId = officeId.selectedItem.toString();
		    	if(mode == "query"){		
		    		httpService.url =  "ref/applicationRoleQueryDispatch.action?method=getApplRoleNames";
		    	}else if(mode == "amend"){
		    		httpService.url =  "ref/applicationRoleQueryAmendDispatch.action?method=getApplRoleNames";
		    	}else{
		    		httpService.url =  "ref/applicationRoleQueryCancelDispatch.action?method=getApplRoleNames";
		    	}		
		    	httpService.request = reqObj ;  
		    	httpService.send();
	  	  	
	  	  	}else{
	  	  		appRole.dataProvider = appRoleColl ;
	  	  	}
    	}
    	/**
    	 * The function is used to handle the http service result
    	 * after selecting the office id combo
    	 */
    	private function populateApplicationRole(event: ResultEvent):void {
    		var formObj:Object = event.result.applicationRoleQueryActionForm ;
    			    	
    		var tempcol:ArrayCollection = new ArrayCollection();
    		tempcol.addItem(" ");
    		if (formObj.applicationRoleNames.applicationRoleName is ArrayCollection){
    			for each (var objItem:Object in (formObj.applicationRoleNames.applicationRoleName 
    						as ArrayCollection)){
    			
    				tempcol.addItem(objItem);
    			}
    		}else {
    			tempcol.addItem(formObj.applicationRoleNames.applicationRoleName);
    		}
    		
    		appRole.dataProvider=tempcol; 
	    	appRole.selectedIndex =  0;
    	}
    	
