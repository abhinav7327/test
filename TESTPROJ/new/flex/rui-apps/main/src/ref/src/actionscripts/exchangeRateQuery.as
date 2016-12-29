// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.RendererFectory;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.core.validators.XenosNumberValidator;

import mx.collections.ArrayCollection;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.ValidationResultEvent;
import mx.resources.ResourceBundle;
import mx.events.ResourceEvent;
			
	  //private var mkt:XenosQuery = new MarketPriceQuery();
	  
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
           	   //XenosAlert.info("mode : "+mode);
           	   if(this.mode == 'query'){
           	   	 this.dispatchEvent(new Event('queryInit'));
           	   } else if(this.mode == 'amend'){
           	   	 this.dispatchEvent(new Event('amendInit'));
           	   	 addColumn();
           	   } else { 
           	     this.dispatchEvent(new Event('cancelInit'));
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
		  		/* this.status.includeInLayout = true;
		  		this.status.visible = true;
		  		this.lblStatus.includeInLayout = true;
		  		this.lblStatus.visible = true; */
		  		super.getInitHttpService().url = "ref/exchangeRateQueryDispatch.action?method=initialExecute&&mode=query&&menuType=Y&rnd=" + rndNo;        	
        }
        
        override public function preAmendInit():void{
		   var rndNo:Number= Math.random();
		   super.getInitHttpService().url = "ref/exchangeRateAmendQueryDispatch.action?&rnd=" + rndNo;
		     var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="initialExecute";
		  		super.getInitHttpService().request = reqObject;     	
        }
        
        override public function preCancelInit():void{
		   var rndNo:Number= Math.random();
		   super.getInitHttpService().url = "ref/exchangeRateCancelQueryDispatch.action?&rnd=" + rndNo;  
		     var reqObject:Object = new Object();
		  		reqObject.mode=this.mode;
		  		reqObject.method="initialExecute";
		  		super.getInitHttpService().request = reqObject;      	
        }        
        
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();
	    	keylist.addItem("calculationTypeList.item"); //not in use
	    	keylist.addItem("exchangeRateTypeList.exchangeRateTypeList");
	    	keylist.addItem("sortFieldList1.item");	
	    	keylist.addItem("sortFieldList2.item");	
	    	keylist.addItem("sortFieldList3.item");
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
	     	againstCcyBox.ccyText.text=""; 
	     	exchangeRateStr.text=""; 
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
	    	
	    	initcol=new ArrayCollection();
	    	initcol.addItem({label:" ", value: " "});
	    	selIndx = 0;
	    	//index=0;
	    	for each(var item:Object in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
	    		initcol.addItem(item);
	    	}
	    	
	    	/* for(i = 0; i<initcol.length; i++) {
	        	//Get the default value object's index
                 if(XenosStringUtils.equals((initcol[i].value),sortField1Default)){                    
                    selIndx = i;
                } 
	        	
	           tempColl.addItem(initcol[i]);            
	        } */
	        
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
	    	
	    	/* for(i = 0; i<initcol.length; i++) {
	        	//Get the default value object's index
                 if(XenosStringUtils.equals((initcol[i].value),sortField2Default)){                    
                    selIndx = i;
                } 
	        	
	           tempColl.addItem(initcol[i]);            
	        } */
	        
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
	    	
	    	/* for(i = 0; i<initcol.length; i++) {
	        	//Get the default value object's index
                /* if(XenosStringUtils.equals((initcol[i].value),sortField3Default)){                    
                    selIndx = i;
                } */
	        	
	           //tempColl.addItem(initcol[i]);            
	        //} 
	        
	        sortFieldArray[2]=sortField3;
	        sortFieldDataSet[2]=initcol;
	        //Set the default value object
	        sortFieldSelectedItem[2] = initcol.getItemAt(0);	
	    		
    		csd = new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
	    	csd.init();
	    	
	    	exchangeRateStr.setFocus();
	    	
	    	//Set Array for Exchange Rate Type and Base CCy 
	    	
        }
        
        /**
	     * Method to Format and validate numbers(B,M,T)
	     */
	     /* private function numberHandler(numVal:XenosNumberValidator):void{
	     	//The source textinput control
	     	var source:Object=numVal.source; 
	     	    	
	     	var vResult:ValidationResultEvent;
	     	var tmpStr:String = source.text; 
	     	if(XenosStringUtils.isBlank(source.text)){
	     		return;
	     	}
	     	else{
				vResult = numVal.validate();
		        
		        if (vResult.type==ValidationResultEvent.VALID) {
		     		source.text=numberFormatter.format(source.text);     		
		        }else{
		        	source.text = tmpStr;        	
		        }
		        
		        if(vResult != null && vResult.type ==ValidationResultEvent.INVALID){
	             var errorMsg:String=vResult.message;
	             XenosAlert.error(errorMsg);
		        }else{
		        	var digitsAfterDecimalArray:Array = exchangeRateStr.text.split(".");
		        	var digitsAfterDecimal:String = digitsAfterDecimalArray[1];
		        	if(Number(digitsAfterDecimal) > 99999999){
		        		source.text = tmpStr;
		        		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.exchangerate.msg.error.digitlimit'));
		        	}
		        }
		     }
	        
	     } */
        
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
			
    	    /* var validateModel:Object={
                            marketPriceQuery:{                                 
                                 baseDate:this.baseDate.text
                            }
                           }; 
             super._validator = new MarketPriceQueryValidator();
             super._validator.source = validateModel ;
             super._validator.property = "marketPriceQuery"; */
		} 
		
		override public function preQuery():void{
			setValidator();
               qh.resetPageNo();	
           // XenosAlert.info("I am in preQuery ");
            super.getSubmitQueryHttpService().url = "ref/exchangeRateQueryDispatch.action?";  
            super.getSubmitQueryHttpService().request  =populateRequestParams();
           
		}
		
		override public function preAmend():void{
			setValidator();
               qh.resetPageNo();	
            //XenosAlert.info("I am in preAmend ");
            super.getSubmitQueryHttpService().url = "ref/exchangeRateAmendQueryDispatch.action?";   
            super.getSubmitQueryHttpService().request  =populateRequestParams();  
           
		}
		
		
		override public function preCancel():void{
			
			setValidator();
			 qh.resetPageNo();	
            //XenosAlert.info("I am in preCancel ");
            super.getSubmitQueryHttpService().url = "ref/exchangeRateCancelQueryDispatch.action?"; 
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
    	
    	reqObj.exchangeRateType = (this.exchangeRateTypeList.selectedIndex != 0 ? this.exchangeRateTypeList.selectedItem.toString() : "");        
      //  reqObj.calculationType = (this.calculationTypeList.selectedItem != null ? this.calculationTypeList.selectedItem.value : "");
        reqObj.againstCcy = this.againstCcyBox.ccyText.text;
        
        //Date Fields
        reqObj.baseDateFromStr = this.baseDateFromStr.text;
        reqObj.baseDateToStr = this.baseDateToStr.text;
        
        //Text Fields
        reqObj.exchangeRateStr = this.exchangeRateStr.text;       
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
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.datanotfound'));
	    	}    		
    	}
    	//XenosAlert.info(result);
    }   
       
      
        override public function preResetQuery():void{
		       var rndNo:Number= Math.random();
		  		super.getResetHttpService().url = "ref/exchangeRateQueryDispatch.action?method=resetQuery&&mode=query&&menuType=Y&rnd=" + rndNo;        	
        }
        
        override public function preResetAmend():void{
		   var rndNo:Number= Math.random();
		   super.getResetHttpService().url = "ref/exchangeRateAmendQueryDispatch.action?&rnd=" + rndNo;
		     var reqObject:Object = new Object();
		  		reqObject.actionType=this.mode;
		  		reqObject.method="initialExecute";
		  		super.getResetHttpService().request = reqObject;     	
        }
        
        override public function preResetCancel():void{
		   var rndNo:Number= Math.random();
		   super.getResetHttpService().url = "ref/exchangeRateCancelQueryDispatch.action?&rnd=" + rndNo;  
		     var reqObject:Object = new Object();
		  		reqObject.actionType=this.mode;
		  		reqObject.method="initialExecute";
		  		super.getResetHttpService().request = reqObject;      	
        }       
        
        
        override    public function preGenerateXls():String{
        	 var url : String =null;
        	 	 if(this.mode == "query")		    		
		    	 	url = "ref/exchangeRateQueryDispatch.action?method=generateXLS";
		    	 else if(this.mode == "amend")
		    	 	url = "ref/exchangeRateAmendQueryDispatch.action?method=generateXLS";
		    	 else
		    	 	url = "ref/exchangeRateCancelQueryDispatch.action?method=generateXLS";
		    	 return url;
         }	
   override public function preGeneratePdf():String{
           //XenosAlert.info("preGeneratePdf");
    	   var url : String =null;	
    	   	   if(this.mode == "query") 		
	    	   	url = "ref/exchangeRateQueryDispatch.action?method=generatePDF";
	    	   else if(this.mode == "amend")
	    	   	url = "ref/exchangeRateAmendQueryDispatch.action?method=generatePDF";
	    	   else
	    	   	url = "ref/exchangeRateCancelQueryDispatch.action?method=generatePDF";	
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
