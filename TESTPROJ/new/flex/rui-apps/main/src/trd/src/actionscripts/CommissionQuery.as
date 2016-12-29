// ActionScript file

 
import com.nri.rui.core.Globals;
import com.nri.rui.core.RendererFectory;
import com.nri.rui.core.containers.SummaryPopup;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.DateUtils;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.trd.validator.CommissionQueryValidator;
import com.nri.rui.trd.validator.TradeQueryValidator;

import mx.collections.ArrayCollection;
import mx.controls.TextInput;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.UIComponent;
import mx.managers.PopUpManager;
import mx.utils.StringUtil;
			
	     [Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
	     [Bindable]private var queryResult:ArrayCollection= new ArrayCollection();
	     [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
    	 [Bindable]private var initcol:ArrayCollection = new ArrayCollection();
    	 private var keylist:ArrayCollection = new ArrayCollection(); 
    	 private var selIndx:int = 0;
         private var i:int = 0;
         private var item:Object = new Object();
         private var tempColl: ArrayCollection = new ArrayCollection();
         private var REPORT_ID_BY_BROKER_ACCOUNT:String = "RPTBYBROKERAC";
         private var REPORT_ID_BY_BROKER_ACCOUNT_AND_FUND_ACCOUNT:String = "RPTBYFUNDBROKERAC";
         private var reportId:String = XenosStringUtils.EMPTY_STR;
		  
		  private function changeCurrentState():void{
			currentState = "result";
			if(reportId == REPORT_ID_BY_BROKER_ACCOUNT){
				rslt.selectedChild = rsltB;
			}else if(reportId == REPORT_ID_BY_BROKER_ACCOUNT_AND_FUND_ACCOUNT){
				rslt.selectedChild = rsltFB;
			}
			app.submitButtonInstance = null;
		  }
       public function loadAll():void{
       		currentState = 'criteria';
       	   super.setXenosQueryControl(new XenosQuery());
       	   this.dispatchEvent(new Event('queryInit'));
       }
        override public function preQueryInit():void{
		        var rndNo:Number= Math.random();
		        super.getInitHttpService().url = "trd/commissionQryDispatch.action?method=initialExecute&rnd=" + rndNo;
		        var req : Object = new Object();
		        req.SCREEN_KEY = "11176";
	            super.getInitHttpService().request = req;
        }
        
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection();      	
	    	keylist.addItem("reportIdList.item");
	    	keylist.addItem("tradeDateFromStr");
	    	keylist.addItem("tradeDateToStr");
	    	keylist.addItem("serviceOfficeList.item");
        }
        
        override public function preQueryResultInit():Object{
        	addCommonKeys();   	
	    	return keylist;        	
        }
        
        private function commonInit(mapObj:Object):void{
        	
        	//clears the errors if any
	        errPage.clearError(super.getInitResultEvent());
	        app.submitButtonInstance = submit;
	    	/* Populating Report ID drop down*/
	    	initcol = new ArrayCollection();
	    	item = new Object();
	    	if(mapObj[keylist.getItemAt(0)]!=null){
	    		if(mapObj[keylist.getItemAt(0)] is ArrayCollection){
	    			for each(item in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	    		}else{
	    			initcol.addItem(mapObj[keylist.getItemAt(0)]);
	    		}
	    	}
	    	this.reportIdCombo.dataProvider = initcol;
	    	/* End of Populating Report ID drop down */
	    	
	    	var dateStr:String = "";
	    	if(mapObj[keylist.getItemAt(1)]!= null && mapObj[keylist.getItemAt(2)] != null) {
	            dateStr = mapObj[keylist.getItemAt(1)];
	            if(!XenosStringUtils.isBlank(dateStr))
	                trdDateFrom.selectedDate = DateUtils.toDate(dateStr);                
	
	            dateStr = mapObj[keylist.getItemAt(2)];
	            if(!XenosStringUtils.isBlank(dateStr))
	                trdDateTo.selectedDate = DateUtils.toDate(dateStr);
	        } else {
	            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.error.initialize.date'));
	        }
	    	
	    	/* Populating IM Office ID drop down*/
	    	initcol = new ArrayCollection();
	    	item = new Object();
	    	initcol.addItem({label:" ", value: "-1"});
	    	if(mapObj[keylist.getItemAt(3)]!=null){
	    		if(mapObj[keylist.getItemAt(3)] is ArrayCollection){
	    			for each(item in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
		    			initcol.addItem(item);
		    		}
	    		}else{
	    			initcol.addItem(mapObj[keylist.getItemAt(3)]);
	    		}
	    	}
	    	this.imOfficeCombo.dataProvider = initcol;
	    	/* End of Populating IM Office ID drop down */
	    	this.inventoryAccountNo.accountNo.text = "";
	    	this.brokerAccountNo.accountNo.text = "";
	    	
	    	hideFields();
        }
        
        
        override public function postQueryResultInit(mapObj:Object):void{
        	commonInit(mapObj);
        }
        
        
        
    	private function setValidator():void{
		
	    var commissionQueryModel:Object={
                        commissionQuery:{
                             trddateFrom:this.trdDateFrom.text,
                             trddateTo:this.trdDateTo.text
                        }
                       }; 
         super._validator = new CommissionQueryValidator();
         super._validator.source = commissionQueryModel ;
         super._validator.property = "commissionQuery";
		}
		
		public function submitQuery():void {
			if(XenosStringUtils.isBlank(this.reportIdCombo.selectedItem != null ? 
										this.reportIdCombo.selectedItem.value : "")){
				XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('trd.commqry.error.reportidmissing'));
			}else{
				this.dispatchEvent(new Event('querySubmit'));
			}
		}
		
		override public function preQuery():void{
			setValidator();
			reportId = this.reportIdCombo.selectedItem != null ? this.reportIdCombo.selectedItem.value : "";
            reportId == REPORT_ID_BY_BROKER_ACCOUNT ? qhB.resetPageNo():qhFB.resetPageNo();
            super.getSubmitQueryHttpService().url = "trd/commissionQryDispatch.action?";  
            super.getSubmitQueryHttpService().request = populateRequestParams();
		}
		
		
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	reqObj.rnd = Math.random() + "";
     	reqObj.method = "submitQuery";
     	reqObj.reportId = this.reportIdCombo.selectedItem != null ? this.reportIdCombo.selectedItem.value : "";
     	reqObj.tradeDateFromStr = this.trdDateFrom.text; 
        reqObj.tradeDateToStr = this.trdDateTo.text; 
        reqObj.accountNo = this.brokerAccountNo.accountNo.text; 
        reqObj.officePk = this.imOfficeCombo.selectedItem != null ? this.imOfficeCombo.selectedItem.value : "-1"; 
     	if(XenosStringUtils.equals(REPORT_ID_BY_BROKER_ACCOUNT_AND_FUND_ACCOUNT,this.reportIdCombo.selectedItem.value)){
     		reqObj.SCREEN_KEY = "11177";
     		reqObj.inventoryAccountNo = this.inventoryAccountNo.accountNo.text;
     	}else if(XenosStringUtils.equals(REPORT_ID_BY_BROKER_ACCOUNT,this.reportIdCombo.selectedItem.value)){
     		reqObj.SCREEN_KEY = "11178";
     		reqObj.inventoryAccountNo = XenosStringUtils.EMPTY_STR;
     	}
    	
    	return reqObj;
    }
    
    override public function postQueryResultHandler(mapObj:Object):void{
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
	    	   if(queryResult != null && queryResult.length > 0){
	    	   	queryResult.removeAll();
	    	   }
               queryResult = mapObj["row"];
	    	   changeCurrentState();
			   initializeQueryHeader(reportId,mapObj);
	    	}else{
	    		errPage.removeError();
	    		queryResult.removeAll();
	    		currentState = "criteria";
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
	    	}    		
    	}
    }   
       
      
        override public function preResetQuery():void{
		       var rndNo:Number= Math.random();
		  		super.getResetHttpService().url = "trd/commissionQryDispatch.action?method=resetQuery&menuType=Y&rnd=" + rndNo;        	
        }
        
        override public function preGenerateXls():String{
		     return "trd/commissionQryDispatch.action?method=generateXLS";
         }	
   
   		override public function preGeneratePdf():String{
		   return "trd/commissionQryDispatch.action?method=generatePDF";;
          }	
            
   		override public function preNext():Object{
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
	          
	            //passing act type                
	            var actTypeArray:Array = new Array(1);
	                actTypeArray[0]="T|B";
	                //cpTypeArray[1]="CLIENT";
	            myContextList.addItem(new HiddenObject("invActTypeContext",actTypeArray));    
	                      
	            //passing counter party type                
	            var cpTypeArray:Array = new Array(1);
	                cpTypeArray[0]="INTERNAL";
	                //cpTypeArray[1]="CLIENT";
	            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
	        
	            //passing account status                
	            var actStatusArray:Array = new Array(1);
	            actStatusArray[0]="OPEN";
	            myContextList.addItem(new HiddenObject("actStatusContext",actStatusArray));
	            
	            //passing inv prefix                
	            var actInvPrefixArray:Array = new Array(1);
	            actInvPrefixArray[0]="";
	            myContextList.addItem(new HiddenObject("invPrefix",actInvPrefixArray));
	            
	            return myContextList;
	        }
	        
	        /**
          * This is the method to pass the Collection of data items
          * through the context to the account popup. This will be implemented as per specifdic  
          * requriment. 
          */
        private function populateCpActContext():ArrayCollection {
            //pass the context data to the popup
            var myContextList:ArrayCollection = new ArrayCollection(); 
           //passing counter party type                
            var cpTypeArray:Array = new Array(1);
                //cpTypeArray[0]="INTERNAL";
                cpTypeArray[0]="BROKER";
            myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
            //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("accountStatus",actStatusArray));
            return myContextList;
        }
        
        private function initializeQueryHeader(reportId:String,mapObj:Object):void {
        	if(reportId == REPORT_ID_BY_BROKER_ACCOUNT){
	           	qhB.setOnResultVisibility();
	           	qhB.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
	           	qhB.PopulateDefaultVisibleColumns();
	        }else{
	           	qhFB.setOnResultVisibility();
	           	qhFB.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
	           	qhFB.PopulateDefaultVisibleColumns();
	        }
        }
        
        private function loadFieldsForReportId():void {
        	var rId:String = this.reportIdCombo.selectedItem != null ? this.reportIdCombo.selectedItem.value : "";
        	if(XenosStringUtils.equals(rId,REPORT_ID_BY_BROKER_ACCOUNT)){
        		this.trdDateFromToLbl.visible = true;
        		this.trdDateFromToLbl.includeInLayout = true;
        		this.trdDateFrom.visible = true;
        		this.trdDateFrom.includeInLayout = true;
        		this.trdDateTo.visible = true;
        		this.trdDateTo.includeInLayout = true;
        		this.brkAccImOfficeRow.visible = true;
        		this.brkAccImOfficeRow.includeInLayout = true;
        		this.fundAccRow.visible = false;
        		this.fundAccRow.includeInLayout = false;
        	}else if(XenosStringUtils.equals(rId,REPORT_ID_BY_BROKER_ACCOUNT_AND_FUND_ACCOUNT)){
        		this.trdDateFromToLbl.visible = true;
        		this.trdDateFromToLbl.includeInLayout = true;
        		this.trdDateFrom.visible = true;
        		this.trdDateFrom.includeInLayout = true;
        		this.trdDateTo.visible = true;
        		this.trdDateTo.includeInLayout = true;
        		this.brkAccImOfficeRow.visible = true;
        		this.brkAccImOfficeRow.includeInLayout = true;
        		this.fundAccRow.visible = true;
        		this.fundAccRow.includeInLayout = true;
        	}else{
        		this.trdDateFromToLbl.visible = false;
        		this.trdDateFromToLbl.includeInLayout = false;
        		this.trdDateFrom.visible = false;
        		this.trdDateFrom.includeInLayout = false;
        		this.trdDateTo.visible = false;
        		this.trdDateTo.includeInLayout = false;
        		this.brkAccImOfficeRow.visible = false;
        		this.brkAccImOfficeRow.includeInLayout = false;
        		this.fundAccRow.visible = false;
        		this.fundAccRow.includeInLayout = false;
        	}
        }
        
        private function hideFields():void {
        	this.trdDateFromToLbl.visible = false;
    		this.trdDateFromToLbl.includeInLayout = false;
    		this.trdDateFrom.visible = false;
    		this.trdDateFrom.includeInLayout = false;
    		this.trdDateTo.visible = false;
    		this.trdDateTo.includeInLayout = false;
    		this.brkAccImOfficeRow.visible = false;
    		this.brkAccImOfficeRow.includeInLayout = false;
    		this.fundAccRow.visible = false;
    		this.fundAccRow.includeInLayout = false;
        }
