// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.containers.SummaryPopup;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.slr.validator.Sbr_BalanceQueryValidator;
import com.nri.rui.core.controls.XenosQuery;
import flash.events.Event;
import mx.collections.ArrayCollection;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;
import mx.utils.StringUtil;


     [Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     [Bindable]private var queryResult:ArrayCollection= new ArrayCollection();
     private var keylist:ArrayCollection = new ArrayCollection(); 
     [Bindable]private var mode : String = "QUERY";
     [Bindable]private var balanceBasisList:ArrayCollection=null;
     [Bindable]private var sortFieldList:ArrayCollection=null;
     [Bindable]private var sortFieldList2:ArrayCollection=null;
     [Bindable]private var sortFieldList3:ArrayCollection=null;
     [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
     private var sortFieldArray:Array =new Array();
     private var sortFieldDataSet:Array =new Array();
     private var sortFieldSelectedItem:Array =new Array();
     private var  csd:CustomizeSortOrder=null;
    
  /**
   * Set Item Renderer to the Document Id firld of Table
   */
	
	 private function changeCurrentState():void{
			currentState = "result";
		 }
			 
     public function loadAll():void{
     	trace("In Load All");
           	   parseUrlString();
          trace("Mode : "+mode);
           	   super.setXenosQueryControl(new XenosQuery());      
           	   if(this.mode == 'QUERY'){
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
           	var reqObj : Object = new Object();
	    	 if(this.mode == 'QUERY'){
	    	 	reqObj.SCREEN_KEY= 11151;
	    	 	super.getInitHttpService().url = "slr/borrowBalanceQueryDispatch.action?method=initialExecute";
	        	super.getInitHttpService().request = reqObj;
	      }
       }
       
        override public function preResetQuery():void{
		     if(this.mode == 'QUERY'){
	    	 	super.getResetHttpService().url = "slr/borrowBalanceQueryDispatch.action?method=doReset";
	    	 }
        }
        
      override public function preQuery():void{
		    setValidator();
            qh.resetPageNo();	
            if(this.mode == 'QUERY'){
	    	 	super.getSubmitQueryHttpService().url = "slr/borrowBalanceQueryDispatch.action?";
	    	 }
            super.getSubmitQueryHttpService().request  =populateRequestParams();
            super.getSubmitQueryHttpService().method="POST";
           
		}
		
		
	 private function setValidator():void{
		  var validateModel:Object={
                   sbrBalQryValidator:{
                        sortField1:this.sortField1.text,   
                        sortField2:this.sortField2.text,
                        sortField3:this.sortField3.text,    
                        baseDate:this.baseDate.text,
                        balancebasis : (this.balbasis.selectedItem != null ?this.balbasis.selectedItem.value :"")
                       }
                    }; 
	         super._validator = new Sbr_BalanceQueryValidator();
	         super._validator.source = validateModel ;
	         super._validator.property = "sbrBalQryValidator";
		}
		

		
		
 /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
  private function populateRequestParams():Object {
    	       	var reqObj : Object = new Object();
		    	reqObj.method= "submitQuery";
		    	reqObj.SCREEN_KEY= 11152;
		    	reqObj.baseDate  = this.baseDate.text; 
		    	reqObj.balanceBasis = (this.balbasis.selectedItem != null ?this.balbasis.selectedItem.value :"");
		    	reqObj.balanceBasisLbl = (this.balbasis.selectedItem != null ?this.balbasis.selectedItem.label :"");
		    	reqObj.fundCode = this.fundPopUp.fundCode.text;
				reqObj.fundAccountNo = this.fundactPopUp.accountNo.text;
				reqObj.instrumentCode = this.securityCode.instrumentId.text;
		    	reqObj.sortField1 = StringUtil.trim(this.sortField1.selectedItem.value);
		    	reqObj.sortField2 = StringUtil.trim(this.sortField2.selectedItem.value);
		    	reqObj.sortField3 = StringUtil.trim(this.sortField3.selectedItem.value);
    	return reqObj;
    }
		
        
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();  
        	keylist.addItem("baseDate");
        	keylist.addItem("defaultBalanceBasis");
	      	keylist.addItem("balbasisList.item");
	      	keylist.addItem("sortFieldList.item");
        }
        
        override public function preQueryResultInit():Object{
        	addCommonKeys();   	
	      	return keylist;        	
        }
        
         override public function postQueryResultInit(mapObj:Object):void{
        	commonInit(mapObj);
	    		
        }
        
    
       private function commonInit(mapObj:Object):void{
       			 app.submitButtonInstance= submit;
				 this.baseDate.text="";
				 this.balbasis.selectedIndex =0;
				 this.fundPopUp.fundCode.text="";
				 this.fundactPopUp.accountNo.text="";
				 this.securityCode.instrumentId.text="";
				 this.sortField1.selectedIndex=0
				 this.sortField2.selectedIndex=0
				 this.sortField3.selectedIndex=0
				 this.baseDate.setFocus();
     
        	 	// Populate balance Basis List Combo Box
	        	balanceBasisList=new ArrayCollection();
	        	var selectedIndx:int=0;
	        	
	        	for (var indx:int=0;indx<(mapObj["balbasisList.item"] as ArrayCollection).length;indx++){
	               	var obj:Object = (mapObj["balbasisList.item"] as ArrayCollection).getItemAt(indx);
	        		        	
	        		balanceBasisList.addItem(obj);
	        		if(obj.value==mapObj['defaultBalanceBasis'].toString()){
	        			selectedIndx=indx;
	        		}
	        			
	        	}
	           	balanceBasisList.refresh();
	        	balbasis.selectedIndex=selectedIndx;
	        	
	        	baseDate.text = mapObj["baseDate"].toString();
	        	
	        	sortFieldList=new ArrayCollection();
	        	sortFieldList.addItem({label: " " , value : " "});
	        	sortFieldList2=new ArrayCollection();
	        	sortFieldList2.addItem({label: " " , value : " "});
	        	sortFieldList3=new ArrayCollection();
	        	sortFieldList3.addItem({label: " " , value : " "});
	        
	        	for each(var obj4:Object in mapObj["sortFieldList.item"] as ArrayCollection){
	        		sortFieldList.addItem(obj4);
	        		sortFieldList2.addItem(obj4);
	        		sortFieldList3.addItem(obj4);
	        	}
	        	
		        //For Sort Field 1 Combo
	            sortFieldArray[0]=sortField1;
	            sortFieldDataSet[0]=sortFieldList;
	            //Set the default value object
	            sortFieldSelectedItem[0] = sortFieldList.getItemAt(1);
	             //For Sort Field 2 Combo
	            sortFieldArray[1]=sortField2;
	            sortFieldDataSet[1]=sortFieldList2;
	            //Set the default value object
	            sortFieldSelectedItem[1] = sortFieldList2.getItemAt(2);
	             //For Sort Field 2 Combo
	            sortFieldArray[2]=sortField3;
	            sortFieldDataSet[2]=sortFieldList3;
	            //Set the default value object
	            sortFieldSelectedItem[2] = sortFieldList3.getItemAt(3);
	        	
	        	csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
      			csd.init();
	    		errPage.clearError(super.getInitResultEvent());
        }
        
	     private function sortOrder1Update():void{
	        csd.update(sortField1.selectedItem,0);
	     }
	     
	     private function sortOrder2Update():void{      
	        csd.update(sortField2.selectedItem,1);
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
    
        
        /**
          * This is the method to pass the Collection of data items
          * through the context to the Fin Inst popup. This will be implemented as per specific  
          * requirement. 
          */
        private function populateFinInstContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
                
        	var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="Security Broker";
               
            myContextList.addItem(new HiddenObject("brokerRoles",cpTypeArray));
            
            return myContextList;
        }
        
        
	     override   public function preGenerateXls():String{
	        	 var url : String =null;
	        	 if(this.mode == 'QUERY'){
		    	 	url = "slr/borrowBalanceQueryDispatch.action?method=generateXLS";
	        	 }
	        	 return url;
	          }	
	   override public function preGeneratePdf():String{
	    	   var url : String =null;
				if(this.mode == 'QUERY'){
		    	 	url = "slr/borrowBalanceQueryDispatch.action?method=generatePDF";
		    	 }
			   return url;
	          }	
	        
	    override  public function preNext():Object{
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
          
           /**
	  * This is the method to pass the Collection of data items
	  * through the context to the account popup. This will be implemented as per specifdic  
	  * requriment. 
	  */
	    private function populateInvActContext():ArrayCollection {
	        //pass the context data to the popup
	        var myContextList:ArrayCollection = new ArrayCollection(); 
	      
	        //passing counter party type                
	        var cpTypeArray:Array = new Array(1);
	            cpTypeArray[0]="INTERNAL";
	            //cpTypeArray[1]="CLIENT";
	        myContextList.addItem(new HiddenObject("invCpTypeContext",cpTypeArray));
           
            // passing longShortFlag
	       var longShortFlagArray:Array = new Array(1);
                  longShortFlagArray[0]="S";
              myContextList.addItem(new HiddenObject("longShortFlagContext",longShortFlagArray));

	        //passing account status                
	        var actStatusArray:Array = new Array(1);
	        actStatusArray[0]="OPEN";
	        myContextList.addItem(new HiddenObject("actStatusContext",actStatusArray));
	        return myContextList;
	    }  
          
