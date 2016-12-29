// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.ref.validators.IntraReconQueryValidator;
import com.nri.rui.core.controls.CustomizeSortOrder;
//import com.nri.rui.ref.validators.IntraReconQueryValidator;

import mx.collections.ArrayCollection;


     [Bindable]
      private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     [Bindable]
      private var queryResult:ArrayCollection= new ArrayCollection();
     
      private var keylist:ArrayCollection = new ArrayCollection(); 
     
     [Bindable] private var mode : String = "QUERY";
      
     [Bindable] private var reportIdList:ArrayCollection = null;
     [Bindable] private var matchStatusList:ArrayCollection = null;
     [Bindable] private var sortOrderList:ArrayCollection = null;
     
	  private var  csd:CustomizeSortOrder = null;
	  private var sortFieldArray:Array = new Array();
      private var sortFieldDataSet:Array = new Array();
      private var sortFieldSelectedItem:Array = new Array();
    
    
	 	 /**
	  	  * Set Item Renderer to the Document Id firld of Table
	  	  */
		
		 private function changeCurrentState():void{
				currentState = "result";
		
		 }
		 
					 
    	 public function loadAll():void{
           	   parseUrlString();
           	   reportId.setFocus();
           	   super.setXenosQueryControl(new XenosQuery());        
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
            super.getInitHttpService().url = "ref/intraReconQueryDispatch.action?method=initialExecute&mode=QUERY&SCREEN_KEY=11127"
       }
       
        override public function preResetQuery():void{
		     super.getResetHttpService().url = "ref/intraReconQueryDispatch.action?method=initialExecute&mode=QUERY&SCREEN_KEY=11127"        	
        }
        
   		override public function preQuery():void{
			setValidator();
            qh.resetPageNo();	           
            super.getSubmitQueryHttpService().url = "ref/intraReconQueryDispatch.action?";  
            super.getSubmitQueryHttpService().request  =populateRequestParams();
            super.getSubmitQueryHttpService().method="POST";
           
		}
		
 		private function setValidator():void{
		
		 	 var validateModel:Object={
                            reconQuery:{
                                 
                               baseDateFromStr:this.baseDateFromStr.text,
                               baseDateToStr:this.baseDateToStr.text
                                        
                            }
                           }; 
	         super._validator = new IntraReconQueryValidator();
	         super._validator.source = validateModel ;
	         super._validator.property = "reconQuery";
		}
		
		
 	   /**
  	 	* This method will populate the request parameters for the
    	* submitQuery call and bind the parameters with the HTTPService
    	* object.
    	*/
  		private function populateRequestParams():Object {
    	
    	       	var reqObj : Object = new Object();
		    	
		    	reqObj.method= "submitQuery";
		    	reqObj.reportId = this.reportId.selectedItem.value;
		    	reqObj.baseDateFromStr = this.baseDateFromStr.text;
		    	reqObj.baseDateToStr = this.baseDateToStr.text;
		    	reqObj.matchStatus = this.matchStatus.selectedItem.value;
		    	reqObj.sortOrder1 = (this.sortOrder1.selectedItem != null && this.sortOrder1.selectedItem.value  != " ") ? this.sortOrder1.selectedItem.value : "" ;
		    	reqObj.sortOrder2 = (this.sortOrder2.selectedItem != null && this.sortOrder2.selectedItem.value  != " ") ? this.sortOrder2.selectedItem.value : "" ;
		    	reqObj.SCREEN_KEY = 11128;
	
    			return reqObj;
   		 }
		
        
        private function addCommonKeys():void{  
     
        	keylist = new ArrayCollection();      	
	    	
	       	keylist.addItem("reportIdList.item");
	       	keylist.addItem("matchStatusList.item");	
	       	keylist.addItem("sortOrderList.item");	
	       
        }
        
        override public function preQueryResultInit():Object{
        	addCommonKeys();   	
	      	return keylist;        	
        }
        
         override public function postQueryResultInit(mapObj:Object):void{
         	
        	commonInit(mapObj);
	    		
        }
        
       
        
       private function commonInit(mapObj:Object):void{
       	
       	this.reportId.selectedIndex = 0;
       	this.matchStatus.selectedIndex = 0;
  		this.baseDateFromStr.text = "";
		this.baseDateToStr.text = "";
	
     
        	 if(this.mode == "QUERY"){
        	 	// Populate report Id Combo Box
	        	
	        	reportIdList = new ArrayCollection();
	        	reportIdList.addItem({label: " " , value : ""});
	        	
	        	for each(var obj1:Object in mapObj["reportIdList.item"] as ArrayCollection){
	        		reportIdList.addItem(obj1);
	        	}
	        	
	        	reportIdList.refresh();
	        	
	        	
	        	// Populate match Status Combo Box
	        	
	        	matchStatusList = new ArrayCollection();
	        	matchStatusList.addItem({label: " " , value : ""});
	        	
	        	for each(var obj2:Object in mapObj["matchStatusList.item"] as ArrayCollection){
	        		matchStatusList.addItem(obj2);
	        	}
	        	
	        	matchStatusList.refresh();
	        	
	        	// Populate sortOrder  Combo Box
	        	
	        	sortOrderList = new ArrayCollection();
	        	sortOrderList.addItem({label: " " , value : " "});
	        	
	        	for each(var obj3:Object in mapObj["sortOrderList.item"] as ArrayCollection){
	        		sortOrderList.addItem(obj3);
	        	}
	        	
	        	
	        	sortOrderList.refresh();
	    
	        	sortFieldDataSet[0] = sortOrderList; 	    	
	    		sortFieldSelectedItem[0] = sortOrderList[0];
	    		sortFieldArray[0] = sortOrder1;
	    		
	    		sortOrder2.dataProvider = sortOrderList;
	        	sortFieldDataSet[1] = sortOrderList;
		    	sortFieldSelectedItem[1] = sortOrderList[0];
		    	sortFieldArray[1] = sortOrder2;
		    	 
		    	csd = new CustomizeSortOrder(sortFieldArray, sortFieldDataSet, sortFieldSelectedItem);
		    	csd.init();
	        	
	        	        	
	        }else{
	        	reportId.visible = false;
	        	reportId.includeInLayout = false;
	        	
	        	matchStatus.visible = false;
	        	matchStatus.includeInLayout = false;
	        	
	        	sortOrder1.visible = false;
	        	sortOrder1.includeInLayout = false;
	        	
	        	sortOrder2.visible = false;
	        	sortOrder2.includeInLayout = false;

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
	                	
	                   
	                } else{
		               hb2.setVisible(false);
		               hb2.includeInLayout=false;
		               hb3.setVisible(true);
		               hb3.includeInLayout=true;
	                   
	                }*/
		    		
		    	}else{
		    		errPage.removeError();
		    		//XenosAlert.info(mapObj["errorFlag"].toString()); data not found
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
          
          override public function preGenerateXls():String{
        	 var url : String =null;
		     url = "ref/intraReconQueryDispatch.action?method=generateXLS";//&SCREEN_KEY=932
		     return url;
         }	
   		 override public function preGeneratePdf():String{
           //XenosAlert.info("preGeneratePdf");
    	    var url : String =null;
		    url = "ref/intraReconQueryDispatch.action?method=generatePDF";//&SCREEN_KEY=932
		    return url;
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
          
		/**
		 *  called on Sort fields combo onchange
		 */
		 
		 private function sortOrder1Update():void{
		 	csd.update(sortOrder1.selectedItem,0);
	     }
	     
	     private function sortOrder2Update():void{     	
	     	csd.update(sortOrder2.selectedItem,1);
	     }
