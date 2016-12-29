// ActionScript file
// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.containers.SummaryPopup;
import com.nri.rui.core.controls.CustomizeSortOrder;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.ref.renderers.CPStandingViewAmmendCancelRenderer;
import com.nri.rui.ref.validators.CPStandingQueryvalidator;
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
     [Bindable]private var counterPartyCode:ArrayCollection=null;
     [Bindable]private var stlForList:ArrayCollection=null;
     [Bindable]private var stlTransactionTypeList:ArrayCollection=null;
     [Bindable]private var deliveryMethodList:ArrayCollection=null;
     [Bindable]private var sortFieldList:ArrayCollection=null;
     [Bindable]private var sortFieldList2:ArrayCollection=null;
     [Bindable]private var sortFieldList3:ArrayCollection=null;
     private var sortFieldArray:Array =new Array();
     private var sortFieldDataSet:Array =new Array();
     private var sortFieldSelectedItem:Array =new Array();
     private var  csd:CustomizeSortOrder=null;
     private var actionType:String="QUERY";
     private var sPopup : SummaryPopup;	
    
  /**
   * Set Item Renderer to the Document Id firld of Table
   */
	
	 private function changeCurrentState():void{
			currentState = "result";
	    	status.visible = (actionType=="QUERY"? true:false);
	       	viewAmmendCncl.itemRenderer=new RendererFectory(CPStandingViewAmmendCancelRenderer,mode);
	       	
		 }
			 
     public function loadAll():void{
           	   parseUrlString();
           	   super.setXenosQueryControl(new XenosQuery());      
               cntrPatyType.setFocus();           	            	             	      
           	   if(this.mode == 'QUERY' || this.mode == 'CANCEL' || this.mode=='AMEND'){
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
	                            actionType = mode;
	                            
	                        }
	                    }                    	
                    }else{
                    	mode = "QUERY";
                    }                 

                } catch (e:Error) {
                    trace(e);
                }      
                
                	         
            }     
            
            
            
         /**
         * Depending on Counter Party Type combo box value system swithch to either fininst search or customer search
         * 
         */   
            
         public function onChangeCounterPartyType():void{
           var cntrPrtyType:String = cntrPatyType.selectedItem.value;
           
           switch (cntrPrtyType){
           	 case "BROKER" : {
           	 	  
           	 	finInstBox.includeInLayout=true;
           	 	finInstBox.visible=true;
           		cstmrBoxh.includeInLayout=false;
           	 	cstmrBoxh.visible=false;
           	 	break;
     	
           	 }
           	 case "" :{
           	 	
      	 	 	finInstBox.includeInLayout=false;
           	 	finInstBox.visible=false;
           
           		cstmrBoxh.includeInLayout=false;
           	 	cstmrBoxh.visible=false;
           	 	break;
           	 
           	 }
           	 
          	 case "CLIENT" : {
      	 	  
           	    finInstBox.includeInLayout=false;
           	 	finInstBox.visible=false;
           		          		
           		cstmrBoxh.includeInLayout=true;
           	 	cstmrBoxh.visible=true;
           	 	break;
           	 	
           	 }
           	 case "INTERNAL" : {
           	   
           	 	finInstBox.includeInLayout=false;
           	 	finInstBox.visible=false;
           		
           		cstmrBoxh.includeInLayout=true;
           	 	cstmrBoxh.visible=true;
           	 	break;
         	
           	 }
                     	 
           }
        }

         
        
        override public function preQueryInit():void{	
//            super.getInitHttpService().url = "ref/cpStandingQueryDispatch.action?method=initialExecute&actionType="+actionType; 
           	var reqObj : Object = new Object();
	    	 if(this.mode == 'QUERY'){
	    	 	reqObj.SCREEN_KEY= 194;
	    	 	super.getInitHttpService().url = "ref/cpStandingQueryDispatch.action?method=initialExecute&actionType="+actionType;
	    	 }else  if( this.mode == 'CANCEL'){
	    	 	reqObj.SCREEN_KEY= 793;
	    	 	super.getInitHttpService().url = "ref/cpStandingCancelQueryDispatch.action?method=initialExecute&actionType="+actionType;
	    	 }
	    	 else if(this.mode=='AMEND'){
	    	 	reqObj.SCREEN_KEY= 792;
	    	 	super.getInitHttpService().url = "ref/cpStandingAmendQueryDispatch.action?method=initialExecute&actionType="+actionType;
	    	 }
	    	super.getInitHttpService().request = reqObj;
       }
       
        override public function preResetQuery():void{
//		     super.getResetHttpService().url = "ref/cpStandingQueryDispatch.action?method=resetQuery&actionType="+actionType;
		     if(this.mode == 'QUERY'){
	    	 	super.getResetHttpService().url = "ref/cpStandingQueryDispatch.action?method=resetQuery&actionType="+actionType;
	    	 }else  if( this.mode == 'CANCEL'){
	    	 	super.getResetHttpService().url = "ref/cpStandingCancelQueryDispatch.action?method=resetQuery&actionType="+actionType;
	    	 }
	    	 else if(this.mode=='AMEND'){
	    	 	super.getResetHttpService().url = "ref/cpStandingAmendQueryDispatch.action?method=resetQuery&actionType="+actionType;
	    	 }         	
        }
        
      override public function preQuery():void{
		    setValidator();
            qh.resetPageNo();	
//            super.getSubmitQueryHttpService().url = "ref/cpStandingQueryDispatch.action?";
            if(this.mode == 'QUERY'){
	    	 	super.getSubmitQueryHttpService().url = "ref/cpStandingQueryDispatch.action?";
	    	 }else  if( this.mode == 'CANCEL'){
	    	 	super.getSubmitQueryHttpService().url = "ref/cpStandingCancelQueryDispatch.action?";
	    	 }
	    	 else if(this.mode=='AMEND'){
	    	 	super.getSubmitQueryHttpService().url = "ref/cpStandingAmendQueryDispatch.action?";
	    	 }  
            super.getSubmitQueryHttpService().request  =populateRequestParams();
            super.getSubmitQueryHttpService().method="POST";
           
		}
		
		
		 private function setValidator():void{
		 var cntrPrtyCode:String ="";
		 if(cstmrBoxh.includeInLayout){
		 	cntrPrtyCode= customercodeSrchPopUp.customerCode.text;
		 }else{
		 	cntrPrtyCode= this.finInstPopUp.finInstCode.text;
		 }
		  var validateModel:Object={
                   cpStandingQueryv:{
                        sortField1:this.sortField1.text,   
                        sortField2:this.sortField2.text,
                        sortField3:this.sortField3.text,    
                        counterPartyType:this.cntrPatyType.selectedItem.value,
                        counterPartyCode : cntrPrtyCode,
                        accountNo:this.cntrPrtyacct.accountNo.text,
                        localAccountNo: this.localAcc.localAccountCode.text
                                                
                       }
                    }; 
	         super._validator = new CPStandingQueryvalidator();
	         super._validator.source = validateModel ;
	         super._validator.property = "cpStandingQueryv";
		}
		

		
		
 /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
  private function populateRequestParams():Object {
    	       	var reqObj : Object = new Object();
		    	reqObj.method= "submitQuery";
	    	 	reqObj.SCREEN_KEY= 197;
		    	reqObj.actionType = actionType;
		    	reqObj.counterPartyType = this.cntrPatyType.selectedItem.value;
		    	reqObj.counterPartyCode = this.finInstPopUp.finInstCode.text;
		    	reqObj.accountNo = this.cntrPrtyacct.accountNo.text;
		    	reqObj.stlFor= this.settleMentFor.selectedItem.value;
		    	reqObj.stlTransactionType = this.cshSecurity.selectedItem.value;
		    	reqObj.market=this.executionMarket.itemCombo != null ? this.executionMarket.itemCombo.text : "" ;
		    	reqObj.instrumentType= this.instrumentType.itemCombo != null ? this.instrumentType.itemCombo.text : "" ;
		    	reqObj.instrumentCode= this.securityCode.instrumentId.text;
		    	reqObj.stlCcy= this.stlCcy.ccyText.text;
		    	reqObj.deliveryMethod= this.form.selectedItem.value;
		    	reqObj.localAccountNo = this.localAcc.localAccountCode.text;
		    	reqObj.countryCode = this.countrycode.countryCode.text;
		    	reqObj.sortField1 = StringUtil.trim(this.sortField1.selectedItem.value);
		    	reqObj.sortField2 = StringUtil.trim(this.sortField2.selectedItem.value);
		    	reqObj.sortField3 = StringUtil.trim(this.sortField3.selectedItem.value);
	  	
    	return reqObj;
    }
		
        
        private function addCommonKeys():void{  
     
        	keylist = new ArrayCollection();  
        	keylist.addItem("actionType");    	
	      	keylist.addItem("cpTypeList.item");
	       	keylist.addItem("stlForList.item");	
	        keylist.addItem("stlTransactionTypeList.item");
	        keylist.addItem("deliveryMethodList.item");
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
				 this.cntrPatyType.selectedIndex=0;
				 this.finInstPopUp.finInstCode.text="";
				 this.cntrPrtyacct.accountNo.text="";
				 this.settleMentFor.selectedIndex=0
				 this.cshSecurity.selectedIndex=0
				 this.executionMarket.itemCombo.selectedIndex=0 
				 this.executionMarket.itemCombo.text = "" ;
				 this.instrumentType.itemCombo.selectedIndex=0 
				 this.instrumentType.itemCombo.text = "" ;
				 this.securityCode.instrumentId.text="";
				 this.stlCcy.ccyText.text="";
				 this.form.selectedIndex=0
				 this.localAcc.localAccountCode.text="";
				 this.countrycode.countryCode.text="";
				 this.sortField1.selectedIndex=0
				 this.sortField2.selectedIndex=0
				 this.sortField3.selectedIndex=0
     
        	 	// Populate Couner Party code Combo Box
	        	counterPartyCode=new ArrayCollection();
	        	counterPartyCode.addItem({label: "" , value : ""});
	        	
	        	for each(var obj:Object in mapObj["cpTypeList.item"] as ArrayCollection){
	              	counterPartyCode.addItem(obj);;
	        	}
	        	counterPartyCode.refresh();
	        	
	        	// Populate Settlement for Combo Box
	        	stlForList=new ArrayCollection();
	        	stlForList.addItem({label: "" , value : ""});
	        	for each(var obj1:Object in mapObj["stlForList.item"] as ArrayCollection){
	        	stlForList.addItem(obj1);
	        	}
	        	stlForList.refresh();
	        	
	        	// Populate Cash and Security Combo Box
	        	stlTransactionTypeList=new ArrayCollection();
	        	stlTransactionTypeList.addItem({label: "" , value : ""});
	        	for each(var obj2:Object in mapObj["stlTransactionTypeList.item"] as ArrayCollection){
	        	stlTransactionTypeList.addItem(obj2);
	        	}
	        	stlTransactionTypeList.refresh();
	        	
	        	// Populate Form  Combo Box
	        	deliveryMethodList=new ArrayCollection();
	        	deliveryMethodList.addItem({label: "" , value : ""});
	        	for each(var obj3:Object in mapObj["deliveryMethodList.item"] as ArrayCollection){
	        	deliveryMethodList.addItem(obj3);
	        	}
	        	deliveryMethodList.refresh();
	        	
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
	            sortFieldSelectedItem[0] = sortFieldList.getItemAt(0);
	             //For Sort Field 2 Combo
	            sortFieldArray[1]=sortField2;
	            sortFieldDataSet[1]=sortFieldList2;
	            //Set the default value object
	            sortFieldSelectedItem[1] = sortFieldList2.getItemAt(0);
	             //For Sort Field 2 Combo
	            sortFieldArray[2]=sortField3;
	            sortFieldDataSet[2]=sortFieldList3;
	            //Set the default value object
	            sortFieldSelectedItem[2] = sortFieldList3.getItemAt(0);
	        	
	        	csd=new CustomizeSortOrder(sortFieldArray,sortFieldDataSet,sortFieldSelectedItem);
      			csd.init();
	        	
	       	    actionType= mapObj["actionType"].toString();
	            onChangeCounterPartyType();  	        	
	    		errPage.clearError(super.getInitResultEvent());
        }
        
	     private function sortOrder1Update():void{
	        csd.update(sortField1.selectedItem,0);
	     }
	     
	     private function sortOrder2Update():void{      
	        csd.update(sortField2.selectedItem,1);
	     }
	     
	  /*   private function sortOrder3Update():void{      
	        csd.update(sortField3.selectedItem,2);
	     }*/
        
	 override public function postQueryResultHandler(mapObj:Object):void{
    	commonResult(mapObj);
  	  }
    
    private function commonResult(mapObj:Object):void{    	
    	var result:String = "";
    	app.submitButtonInstance= submit;
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
    		  if(this.mode=='AMEND'){
    		  	changeCurrentState();
    		  }
	    		errPage.removeError();
	    		queryResult.removeAll();
	    		queryResult.refresh();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}    		
    	}
    	
    }   
    
    	/**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specific  
          * requirement. 
          */
        private function populateInvAcContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
          
            //passing counter party type                
            var settleActTypeArray:Array = new Array(3);
                settleActTypeArray[0]="T";
                settleActTypeArray[1]="S";
                settleActTypeArray[2]="B";               
            myContextList.addItem(new HiddenObject("invActTypeContext",settleActTypeArray));
        
        	var cpTypeArray:Array = new Array(1);
                cpTypeArray[0]="BROKER";
               
            myContextList.addItem(new HiddenObject("CPType",cpTypeArray));
            
            return myContextList;
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
//        	 url = "ref/cpStandingQueryDispatch.action?method=generateXLS";
        	 if(this.mode == 'QUERY'){
	    	 	url = "ref/cpStandingQueryDispatch.action?method=generateXLS";
	    	 }else  if( this.mode == 'CANCEL'){
	    	 	url = "ref/cpStandingCancelQueryDispatch.action?method=generateXLS";
	    	 }
	    	 else if(this.mode=='AMEND'){
	    	 	url = "ref/cpStandingAmendQueryDispatch.action?method=generateXLS";
	    	 }
		     return url;
          }	
   override public function preGeneratePdf():String{
          
    	   var url : String =null;
//    	   url = "ref/cpStandingQueryDispatch.action?method=generatePDF";
			if(this.mode == 'QUERY'){
	    	 	url = "ref/cpStandingQueryDispatch.action?method=generatePDF";
	    	 }else  if( this.mode == 'CANCEL'){
	    	 	url = "ref/cpStandingCancelQueryDispatch.action?method=generatePDF";
	    	 }
	    	 else if(this.mode=='AMEND'){
	    	 	url = "ref/cpStandingAmendQueryDispatch.action?method=generatePDF";
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
          
          
          /*
          *Open Add PopUp
          */
		 public function openAddEntryPopUp():void{
		 
		 	var parentApp :UIComponent = UIComponent(this.parentApplication);
    		sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,true));
		 	sPopup.addEventListener(CloseEvent.CLOSE,closeHandler,false,0,true);
		 	sPopup.title = "Counterparty Settlement Standing  Entry";	
	     	sPopup.width = parentApp.width - 100;
    		sPopup.height = parentApp.height - 60;
	    	PopUpManager.centerPopUp(sPopup);	
	       	sPopup.moduleUrl = Globals.CP_STANDING_ADD_AMMEND_SWF+Globals.QS_SIGN+Globals.MODE_OF_TRAN+Globals.EQUALS_SIGN+"ADD";
					
		 }     
 
 	        /**
        	 * Event Handler for the custom event "OkSystemConfirm"
        	 */
        	public function closeHandler(event:Event):void {
                  dispatchEvent(new Event("querySubmit"));
                  sPopup.removeMe();
            }     
          
          
          
   
        
        