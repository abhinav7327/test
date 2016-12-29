// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.RendererFectory;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.renderers.ImgSummaryRenderer;
import com.nri.rui.core.startup.XenosApplication;

import mx.collections.ArrayCollection;
import mx.controls.dataGridClasses.DataGridColumn;
			
	  //private var mkt:XenosQuery = new MarketPriceQuery();
	  private var  csd:CustomizeSortOrder=null;
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
    [Bindable]
    private var queryResult:ArrayCollection= new ArrayCollection();
     
     private var keylist:ArrayCollection = new ArrayCollection(); 
     
     [Bindable]private var mode : String = "query";
     
    private var sortFieldArray:Array =new Array();
    private var sortFieldDataSet:Array =new Array();
    private var sortFieldSelectedItem:Array =new Array();
	  
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
           	   app.submitButtonInstance = submit; 
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
		  		super.getInitHttpService().url = "ref/holidayQueryDispatch.action?method=initialExecute&modeOfOperation=VIEW&SCREEN_KEY=625&accessFlag=N&menuType=Y";        	
        }
        
        override public function preAmendInit():void{
		   var rndNo:Number= Math.random();
		   super.getInitHttpService().url = "ref/holidayAmendQueryDispatch.action?rnd=" + rndNo;
		    var reqObject:Object = new Object();
		  	reqObject.modeOfOperation="AMEND";
		  	reqObject.method="initialExecute";
		  	reqObject['SCREEN_KEY']=625;
		  	super.getInitHttpService().request = reqObject;     	
        }
        
        override public function preCancelInit():void{
		   var rndNo:Number= Math.random();
		   super.getInitHttpService().url = "ref/holidayCancelQueryDispatch.action?&rnd=" + rndNo;  
		    var reqObject:Object = new Object();
		  	reqObject.modeOfOperation="CANCEL";
		  	reqObject.method="initialExecute";
		  	reqObject['SCREEN_KEY']=625;
		  	super.getInitHttpService().request = reqObject;      	
        }        
        
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();      	
	    	keylist.addItem("holidayYear");	
	    	keylist.addItem("sortFieldList1.item");
	    	keylist.addItem("sortFieldList2.item");	
        }
        
        override public function preQueryResultInit():Object{        	
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
        	
        	this.calendarId.holidayCode.text="";
        	this.calendarName.text="";
        	this.calendarYear.text=mapObj[keylist.getItemAt(0)].toString();        	
    		errPage.clearError(super.getInitResultEvent());    		
    		
        	calendarId.holidayCode.setFocus();
    		
	        //errPage.removeError();   		
	    	
	    	var initcol:ArrayCollection =new ArrayCollection();	    	
	    	initcol.addItem({label:" ", value: " "});
	    	for each(var obj:Object in  mapObj[keylist.getItemAt(1)] as ArrayCollection){
	    		initcol.addItem(obj);
	    	}
	    	
	    	sortFieldDataSet[0]=initcol; 	    	
	    	sortFieldSelectedItem[0]=initcol[0];
	    	sortFieldArray[0]=sortField1;
	    	
	    	initcol=new ArrayCollection();	    	
	    	initcol.addItem({label:" ", value: " "});
	    	for each(var obj:Object in  mapObj[keylist.getItemAt(2)] as ArrayCollection){
	    		initcol.addItem(obj);
	    	}
	    	sortField2.dataProvider=initcol;
	    	sortFieldDataSet[1]=initcol;
	    	sortFieldSelectedItem[1]=initcol[0];
	    	sortFieldArray[1]=sortField2;
	    	 
	    	csd = new CustomizeSortOrder(sortFieldArray, sortFieldDataSet, sortFieldSelectedItem);
	    	csd.init();
	    	
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
        
        	/* private function setValidator():void{
			
    	    var validateModel:Object={
                            marketPriceQuery:{                                 
                                 baseDate:this.baseDate.text
                            }
                           }; 
             super._validator = new MarketPriceQueryValidator();
             super._validator.source = validateModel ;
             super._validator.property = "marketPriceQuery";
		} */
		
		override public function preQuery():void{
			//setValidator();
            qh.resetPageNo();	           
            super.getSubmitQueryHttpService().url = "ref/holidayQueryDispatch.action?";  
            super.getSubmitQueryHttpService().request  =populateRequestParams();
            super.getSubmitQueryHttpService().method="POST";
           
		}
		
		override public function preAmend():void{
			qh.resetPageNo();	           
            super.getSubmitQueryHttpService().url = "ref/holidayAmendQueryDispatch.action?";  
            super.getSubmitQueryHttpService().request  =populateRequestParams();
            super.getSubmitQueryHttpService().method="POST";
           
		}
		
		
		override public function preCancel():void{
			
			//setValidator();
			qh.resetPageNo();	           
            super.getSubmitQueryHttpService().url = "ref/holidayCancelQueryDispatch.action?";  
            super.getSubmitQueryHttpService().request  =populateRequestParams();
            super.getSubmitQueryHttpService().method="POST";
           
		}
		
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	
    	reqObj.method= "submitQuery";
    	
    	reqObj['SCREEN_KEY']=628;
    	
    	reqObj.calendarId = this.calendarId.holidayCode.text;
    	
    	reqObj.holidayYear =  calendarYear.text;
    	
    	reqObj.calendarName = this.calendarName.text;
    	
    	reqObj.sortField1 = (this.sortField1.selectedItem != null && this.sortField1.selectedItem.value!=" ") ? this.sortField1.selectedItem.value : "";
    	
    	reqObj.sortField2 = (this.sortField2.selectedItem != null && this.sortField2.selectedItem.value!=" ")? this.sortField2.selectedItem.value : "";
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
       
      
        override public function preResetQuery():void{
		       var rndNo:Number= Math.random();
		  	   super.getResetHttpService().url = "ref/holidayQueryDispatch.action?method=resetQueryPage&modeOfOperation=VIEW&rnd=" + rndNo;        	
        }
        
        override public function preResetAmend():void{
		  	   var rndNo:Number= Math.random();
		  	   super.getResetHttpService().url = "ref/holidayAmendQueryDispatch.action?method=resetQueryPage&modeOfOperation=AMEND&rnd=" + rndNo;    	
        }
        
        override public function preResetCancel():void{
		  		var rndNo:Number= Math.random();
		  	   super.getResetHttpService().url = "ref/holidayCancelQueryDispatch.action?method=resetQueryPage&modeOfOperation=CANCEL&rnd=" + rndNo;      	
        }       
        
        
        override   public function preGenerateXls():String{
        	 var url : String =null;
        	
		    	 if(mode == "query"){		    		
		    	  url = "ref/holidayQueryDispatch.action?method=generateXLS";
		    	}else if(mode == "amend"){
		    		url = "ref/holidayAmendQueryDispatch.action?method=generateXLS";
		    	}else{
		    		url = "ref/holidayCancelQueryDispatch.action?method=generateXLS";
		    	} 
		    	return url;
         }	
   override public function preGeneratePdf():String{
           //XenosAlert.info("preGeneratePdf");
    	   var url : String =null;
    	   
		    	if(mode == "query"){		    		
		    	  url = "ref/holidayQueryDispatch.action?method=generatePDF";
		    	}else if(mode == "amend"){
		    		url = "ref/holidayAmendQueryDispatch.action?method=generatePDF";
		    	}else{
		    		url = "ref/holidayCancelQueryDispatch.action?method=generatePDF";
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
		
	 private function sortOrder1Update():void{
     	 csd.update(sortField1.selectedItem,0);
     }
     
     private function sortOrder2Update():void{     	
     	csd.update(sortField2.selectedItem,1);
     }
