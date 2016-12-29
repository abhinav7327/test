
// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.RendererFectory;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.ref.validators.CrossExchangeRateQueryValidator;

import mx.collections.ArrayCollection;
import mx.controls.dataGridClasses.DataGridColumn;
			
	  
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
    private var queryResult:ArrayCollection= new ArrayCollection();
     
     private var keylist:ArrayCollection = new ArrayCollection(); 
     private var sortFieldArray:Array =new Array();
     private var sortFieldDataSet:Array =new Array();
     private var sortFieldSelectedItem:Array =new Array();
     private var  csd:CustomizeSortOrder=null;
     
     [Bindable]private var mode : String = "query";
            
	  
	  private function changeCurrentState():void{
				currentState = "result";
	 }
			 
           public function loadAll():void{
           	   parseUrlString();
           	   super.setXenosQueryControl(new XenosQuery());
           	   this.dispatchEvent(new Event('queryInit'));
           	            	     
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
			var reqObject:Object = new Object(); 
		  	super.getInitHttpService().url = "ref/crossExchangeRateQueryDispatch.action?method=initialExecute&&mode=query&&menuType=Y&rnd=" + rndNo;     
			reqObject.SCREEN_KEY = "12101";
			super.getInitHttpService().request = reqObject;
        }    
        
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();
	    	keylist.addItem("calculationTypeList.item"); 
	    	keylist.addItem("exchangeRateTypeList.exchangeRateTypeList");
	    	keylist.addItem("sortFieldList1.item");	
	    	keylist.addItem("sortFieldList2.item");	
	    	keylist.addItem("sortFieldList3.item");
        }
        
        override public function preQueryResultInit():Object{ 
        	addCommonKeys();   		    	   	
	    	return keylist;        	
        }
        
        private function sortOrder1Update():void{
     	 csd.update(sortField1.selectedItem,0);
	     }
	     
	     private function sortOrder2Update():void{     	
	     	csd.update(sortField2.selectedItem,1);
	     }
        
        private function commonInit(mapObj:Object):void{
        	var i:int = 0;
	        var selIndx:int = 0;
	        var initcol:ArrayCollection = new ArrayCollection();
	        var tempColl: ArrayCollection = new ArrayCollection();
	        app.submitButtonInstance = submit;
	        //variables to hold the default values from the server
	        var sortField1Default:String = "EXCHANGE_RATE_TYPE";
	        var sortField2Default:String = "BASE_DATE";
	        var sortField3Default:String = "BASE_CURRENCY";   	
	        
	     	//initiate text fields
	     	exchangeRateTypeList.text="";
	     	baseDateFromStr.text="";
	     	baseDateToStr.text="";
	     	//calculationTypeList.text="";
	     	baseCcyBox.ccyText.text=""; 
	     	againstCcyBox.ccyText.text="";
	     	//exchangeRateStr.text=""; 
    		errPage.clearError(super.getInitResultEvent());
    		
	        //errPage.removeError();
	    	
	    	initcol=new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	//index=0;
	    	for each(var item:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
	    	//calculationTypeList.dataProvider = initcol;
	    	
	    	initcol=new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	//index=0;
	    	for each(var item:Object in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
	    	exchangeRateTypeList.dataProvider = initcol; 
	    	// set default value for exchangeRateTypeList
			exchangeRateTypeList.selectedItem=initcol.getItemAt(20);
	    	initcol=new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	selIndx = 0;
	    	//index=0;
	    	for each(var item:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
	        
	        sortFieldArray[0]=sortField1;
	        sortFieldDataSet[0]=initcol;
	        //Set the default value object
	        sortFieldSelectedItem[0] = initcol.getItemAt(0);
	        
	        
	        initcol=new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	selIndx = 0;
	    	//index=0;
	    	for each(var item:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
	        
	        sortFieldArray[1]=sortField2;
	        sortFieldDataSet[1]=initcol;
	        //Set the default value object
	        sortFieldSelectedItem[1] = initcol.getItemAt(0);
	        
	        initcol=new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	selIndx = 0;
	    	//index=0;
	    	for each(var item:Object in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}	    	

	        sortFieldArray[2]=sortField3;
	        sortFieldDataSet[2]=initcol;
	        //Set the default value object
	        sortFieldSelectedItem[2] = initcol.getItemAt(0);	
	    		
    		csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
	    	csd.init();
	    	
	    	exchangeRateTypeList.setFocus();
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
        
        private function setValidator():void{
            var validateModel:Object={
                           crossExchangeRateQuery:{                                
                                baseDateFromStr:this.baseDateFromStr.text ,     
                                baseDateToStr:this.baseDateToStr.text
                           }
                      }; 
            super._validator = new CrossExchangeRateQueryValidator();
            super._validator.source = validateModel ;
            super._validator.property = "crossExchangeRateQuery"; 
        } 
        
		override public function preQuery():void{
			setValidator();
            qh.resetPageNo();	
            super.getSubmitQueryHttpService().url = "ref/crossExchangeRateQueryDispatch.action?";  
            super.getSubmitQueryHttpService().request = populateRequestParams();
           
		}
				
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	reqObj.SCREEN_KEY = 12114
    	reqObj.method= "submitQuery";
    	
    	reqObj.exchangeRateType = (this.exchangeRateTypeList.selectedIndex != 0 ? this.exchangeRateTypeList.selectedItem.toString() : "");        
        reqObj.baseCcy = this.baseCcyBox.ccyText.text;
        reqObj.localCcy = this.againstCcyBox.ccyText.text;
        
        //Date Fields
        reqObj.baseDateFromStr = this.baseDateFromStr.text;
        reqObj.baseDateToStr = this.baseDateToStr.text;
        
        //Text Fields     
        reqObj.sortField1 = (this.sortField1.selectedItem != null ? this.sortField1.selectedItem.value : "");
        reqObj.sortField2 = (this.sortField2.selectedItem != null ? this.sortField2.selectedItem.value : "");
        reqObj.sortField3 = (this.sortField3.selectedItem != null ? this.sortField3.selectedItem.value : "");
        reqObj.rnd = Math.random() + "";
    	
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
    	var result:String = "";
    	if(mapObj!=null){   	
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		queryResult.removeAll();
	    		errPage.showError(mapObj["errorMsg"]);
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    	   errPage.clearError(super.getSubmitQueryResultEvent());
               queryResult.removeAll();
               queryResult=mapObj["row"];
			   changeCurrentState();
		            qh.setOnResultVisibility();
		            qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
		            qh.PopulateDefaultVisibleColumns();
	    		
	    	}else{
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.datanotfound'));
	    	}    		
    	}
    }   
       
      
        override public function preResetQuery():void{
		       var rndNo:Number= Math.random();
		  		super.getResetHttpService().url = "ref/crossExchangeRateQueryDispatch.action?method=resetQuery&&mode=query&&menuType=Y&rnd=" + rndNo;        	
        }
       
        
        override    public function preGenerateXls():String{
        	 var url : String =null;		    		
		     url = "ref/crossExchangeRateQueryDispatch.action?method=generateXLS&screenId=CEXRQ";
		     return url;
         }	
   override public function preGeneratePdf():String{
           //XenosAlert.info("preGeneratePdf");
    	    var url : String =null;			
	    	url = "ref/crossExchangeRateQueryDispatch.action?method=generatePDF";
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
