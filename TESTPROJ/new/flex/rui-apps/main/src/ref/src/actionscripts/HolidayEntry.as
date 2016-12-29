// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.containers.TitleWindow;
import mx.controls.DateField;
import mx.events.CloseEvent;
import mx.events.ResourceEvent;
import mx.resources.ResourceBundle;
			
	  
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     [Bindable]
     public var entryList:ArrayCollection=new ArrayCollection();     
     
     [Bindable]
     public var result:ArrayCollection=new ArrayCollection();     
     
     [Bindable]
     public var cancelResult:ArrayCollection=new ArrayCollection();    
     
    [Bindable]private var mode : String = "entry";
    [Bindable]private var calendarPk : String = "";
    [Bindable]private var calYear:String="";
    [Bindable]private var viewOption:String="";
    [Bindable]private var marketPricePkStr:String=""; 
    
    //service URL for editable datagrid.Changes according to mode
    [Bindable]
    private var addServiceUrl:String="ref/holidayEntryDispatch.action?method=addHolidayEntry";
    [Bindable]
    private var editServiceUrl:String="ref/holidayEntryDispatch.action?method=updateHolidayEntry";
    [Bindable]
    private var deleteServiceUrl:String="ref/holidayEntryDispatch.action?method=deleteHolidayEntry";
    
    private var keylist:ArrayCollection = new ArrayCollection();
    [Bindable]
    private var tempMode:String;
	  
	  private function changeCurrentState():void{				
				vstack.selectedChild = rslt;
	 }
	 
   
			   public function loadAll():void{
           	   parseUrlString();
           	   super.setXenosEntryControl(new XenosEntry());
           	   //XenosAlert.info("mode : "+mode);
           	   if(this.mode == 'entry'){           	   
           	   	tempMode = "Entry";	
           	   	 this.dispatchEvent(new Event('entryInit'));
				//hdbox1.selectedChild = this.qry;
           	   	 //this.currentState="entryState";
           	   	 vstack.selectedChild = qry;
           	   } else if(this.mode == 'amend'){
           	   	tempMode = "Amend";
           	   	//change editable datagrid service urls
           	   	 addServiceUrl="ref/holidayAmendDispatch.action?method=addHolidayEntry";
   				 editServiceUrl="ref/holidayAmendDispatch.action?method=updateHolidayEntry";
    			 deleteServiceUrl="ref/holidayAmendDispatch.action?method=deleteHolidayEntry";
    			 //set dgrid mode
    			 entryGrid.dataGridMode="amend";    			 
    			 calId.editable=false;    			 
    			 
           	   	 this.dispatchEvent(new Event('amendEntryInit'));
				//hdbox1.selectedChild = this.qry;
           	   	 //this.currentState="entryState";
           	   	 vstack.selectedChild = qry;
           	   } else { 
           	   	tempMode = "Cancel";
           	     this.dispatchEvent(new Event('cancelEntryInit'));
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
                    //XenosAlert.info("Load Url : "+ this.loaderInfo.url.toString());
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
	                        }else if(tempA[0] == "calendarPk"){
	                            this.calendarPk = tempA[1];
	                        }else if(tempA[0] == "year"){
	                            this.calYear = tempA[1];
	                        } else if(tempA[0] == "viewOption"){
	                            this.viewOption = tempA[1];
	                        } 
	                    }                    	
                    }else{
                    	mode = "entry";
                    }                 

                } catch (e:Error) {
                    trace(e);
                }               
            }
            
            override public function preEntryInit():void{  
            	super.getInitHttpService().url = "ref/holidayEntryDispatch.action?method=initialExecute&SCREEN_KEY=624";
            }
            override public function preAmendInit():void{     
            	initLabel.text = "Holiday Amend"       	
		        var rndNo:Number= Math.random(); 
            	super.getInitHttpService().url = "ref/holidayAmendDispatch.action?";
            	var reqObject:Object = new Object();
            	reqObject.rnd = rndNo;
            	reqObject.method= "amendHoliday";
		  		reqObject.year=this.calYear;		  		
		  		reqObject.calendarPk = this.calendarPk;
		  		reqObject.viewOption=this.viewOption;
		  		reqObject['SCREEN_KEY']=626;
		  		super.getInitHttpService().request = reqObject;
            }
            override public function preCancelInit():void{            	
		        this.back.includeInLayout = false;
			    this.back.visible = false;
			    			    
			    vstack.selectedChild = cancel;
			    		             	
		        var rndNo:Number= Math.random(); 
            	super.getInitHttpService().url = "ref/holidayCancelDispatch.action?";
            	var reqObject:Object = new Object();
            	reqObject.rnd = rndNo;
            	reqObject.method= "closeHoliday";
		  		reqObject.year=this.calYear;		  		
		  		reqObject.calendarPk = this.calendarPk;
		  		reqObject.viewOption=this.viewOption;
		  		reqObject['SCREEN_KEY']=627;
		  		super.getInitHttpService().request = reqObject;
            }
            
       
        
       /*  override public function preEntryResultInit():Object{
        	addCommonKeys(); 
        	return keylist;
        } */
        
         override public function preAmendResultInit():Object{
        	addCommonResultKes();
        	keylist.addItem("Errors.error");
			return keylist;
        } 
        override public function preCancelResultInit():Object{
        	addCommonResultKes();         	
        	return keylist;
        }
        
        
        private function commonInit(mapObj:Object):void{        	
	    	errPage.clearError(super.getInitResultEvent());
        }
        
         override public function postEntryResultInit(mapObj:Object): void{
        	commonInit(mapObj);
        } 
        
        override public function postAmendResultInit(mapObj:Object): void{
        	
        	if((mapObj["Errors.error"]as ArrayCollection).length>0){        		
        		errPage.showError(mapObj["Errors.error"]);
        	}else{	    
        					
		    		errPage.removeError();
        			var tempEntryList:ArrayCollection=mapObj[keylist.getItemAt(0)] as ArrayCollection;
        			entryList=processResultForAmendInit(tempEntryList);
        			entryList.refresh();
        			//set amend data model for non-editable fields
        			var amendModel:Object=new Object();
        			amendModel['calendar.calendarId']=(entryList.getItemAt(0))['calendar.calendarId'].toString();
        			entryGrid.amendDataModel=amendModel;
        			calId.editable=false;
       			}
       		
        	
        }
        
        override public function postCancelResultInit(mapObj:Object): void{
        	
        	cancelResult = mapObj[keylist.getItemAt(0)] ; 
	        cancelResultGrid.dataProvider=cancelResult;
	        cancelResult.refresh(); 
        }
        private function addCommonResultKes():void{
        	keylist = new ArrayCollection();
	    	keylist.addItem("calendarDateParticipantList.calendarDateParticipant");	    	
        }
        
        private function commonResult(mapObj:Object):void{
        	
		 	//XenosAlert.info("commonResult ");
	    	if(mapObj!=null){    		
		    	if(mapObj["errorFlag"].toString() == "error"){
		    		//result = mapObj["errorMsg"] .toString();
		    		if(mode != "cancel"){
		    		  errPage.showError(mapObj["errorMsg"]);		    			
		    		}else{
		    			XenosAlert.error(mapObj["errorMsg"]);
		    		}
		    	}else if(mapObj["errorFlag"].toString() == "noError"){
		    		
		    	 errPage.clearError(super.getSaveResultEvent());			    			
	             commonResultPart(mapObj);
				 changeCurrentState();
		    		
		    	}else{
		    		errPage.removeError();
		    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.datanotfound'));
		    	}    		
	    	}
        }
        
       
       private function commonResultPart(mapObj:Object):void{
        		result = mapObj[keylist.getItemAt(0)] as ArrayCollection; 
	            resultGrid.dataProvider=result;
	            result.refresh(); 
        }
        
    	
		 override public function preEntry():void{		 	
		 	super.getSaveHttpService().url = "ref/holidayEntryDispatch.action?method=submitHolidayEntry&viewOption=ENTRY&SCREEN_KEY=628";  
           // super.getSaveHttpService().request  =populateRequestParams();          
            super.getSaveHttpService().method="POST";
		 }
		 
		 override public function preAmend():void{
		 	super.getSaveHttpService().url = "ref/holidayAmendDispatch.action?method=submitHolidayEntry&viewOption=AMEND&SCREEN_KEY=628";  
           // super.getSaveHttpService().request  =populateRequestParams();
            super.getSaveHttpService().method="POST";
		 } 
		 override public function preCancel():void{
		 	//setValidator();
		 	super._validator = null;
		 	super.getSaveHttpService().url = "ref/holidayCancelDispatch.action?"; 
		 	 var reqObj:Object = new Object();
		 	 reqObj.method="submitHolidayEntry";
		 	 reqObj.mode=this.mode;
		 	 reqObj['SCREEN_KEY']=628;
            super.getSaveHttpService().request  =reqObj;
		 }
		 
		 
		 override public function preEntryResultHandler():Object
		{
			 addCommonResultKes();
			 return keylist;
		} 
		
		override public function preAmendResultHandler():Object
		{
			addCommonResultKes();
			return keylist;
		} 
		
		 
		 override public function preCancelResultHandler():Object
		{
			 addCommonResultKes();
			 return keylist;
		} 
		
		override public function postCancelResultHandler(mapObj:Object):void
		{
			
			if(mapObj!=null){    		
		    	if(mapObj["errorFlag"].toString() == "error"){
		    		errPage2.showError(mapObj["errorMsg"]);
		    	}else if(mapObj["errorFlag"].toString() == "noError"){
		    		
		    		errPage2.removeError();
					result=mapObj[keylist.getItemAt(0)];
					vstack.selectedChild = rslt;// change to confirmation page
					resultGrid.dataProvider=result;
					result.refresh();
					
					//submitUserConfResult(mapObj);
					uConfSubmit.visible=false;
					uConfSubmit.includeInLayout=false;
					uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('ref.calendar.label.userconfirm')+tempMode;
					uConfLabel.includeInLayout = true;
					uConfLabel.visible = true;
					back.visible=true;
					back.includeInLayout=true;
		        	cancelSubmit.visible = false;
		        	cancelSubmit.includeInLayout = false;
		        	uCancelConfSubmit.visible = true;
		        	uCancelConfSubmit.includeInLayout = true;
		        	sConfSubmit.includeInLayout = false;
		        	sConfSubmit.visible = false;
		        	sConfLabel.includeInLayout = false;
		        	sConfLabel.visible = false;
		     }
		 	}
		} 
		
		 override public function postEntryResultHandler(mapObj:Object):void
		{
			commonResult(mapObj);
		} 
		
		override public function postAmendResultHandler(mapObj:Object):void
		{
			commonResult(mapObj);
		}
		 
		 
		
		override public function preEntryConfirm():void
		{
			super.getConfHttpService().url = "ref/holidayEntryDispatch.action?method=confirmHolidayEntry&SCREEN_KEY=629";
		}
		
		override public function preAmendConfirm():void
		{
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "ref/holidayAmendDispatch.action?";  
			reqObj.method= "confirmHolidayEntry";
			reqObj['SCREEN_KEY']=629;
            super.getConfHttpService().request  =reqObj;
		}
		
		override public function preCancelConfirm():void
		{
			var reqObj :Object = new Object();
			super.getConfHttpService().url = "ref/holidayCancelDispatch.action?";  
			reqObj.method= "confirmHolidayEntry";
			reqObj['SCREEN_KEY']=629;
            super.getConfHttpService().request  =reqObj;
		}
		
		override public function postConfirmEntryResultHandler(mapObj:Object):void
		{
			uConfSubmit.enabled=true;
			submitUserConfResult(mapObj);
		}
		override public function postConfirmAmendResultHandler(mapObj:Object):void
		{
			uConfSubmit.enabled=true;
			submitUserConfResult(mapObj);
		}
		override public function postConfirmCancelResultHandler(mapObj:Object):void
		{	
			uCancelConfSubmit.enabled=true;
			if(submitUserConfResult(mapObj)){
	        	cancelSubmit.visible = false;
	        	cancelSubmit.includeInLayout = false;
	        	uCancelConfSubmit.visible = false;
	        	uCancelConfSubmit.includeInLayout = false;
	        	uConfLabel.includeInLayout = false;
				uConfLabel.visible = false;
			}
		}
		
		private function submitUserConfResult(mapObj:Object):Boolean{
    	//var mapObj:Object = mkt.userConfResultEvent(event);
    	if(mapObj!=null){
	    	if(mapObj["errorFlag"].toString() == "error"){
	    		errPage1.showError(mapObj["errorMsg"].toString());
	    	}else if(mapObj["errorFlag"].toString() == "noError"){
	    		if(mode!="cancel")
	    		  errPage.clearError(super.getConfResultEvent());
	    		errPage1.clearError(super.getConfResultEvent());
	    		this.back.includeInLayout = false;
	    		this.back.visible = false;
			   uConfSubmit.enabled = true;	
               uConfLabel.includeInLayout = false;
               uConfLabel.visible = false;
               uConfSubmit.includeInLayout = false;
               uConfSubmit.visible = false;
               sConfLabel.includeInLayout = true;
               sConfLabel.visible = true;
               sConfSubmit.includeInLayout = true;
               sConfSubmit.visible = true;    
               sysConfMessage.includeInLayout=true;   
               sysConfMessage.visible=true;
               if(this.mode!="entry"){               	
               	TitleWindow(this.parent.parent).showCloseButton=false;
               	TitleWindow(this.parent.parent).invalidateDisplayList();
               }
               return true;
	    	}else{
	    		errPage.removeError();
	    		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.erroroccurred'));
	    	}    		
    	}
    	return false;
    }
    
      /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
    	
    	var reqObj : Object = new Object();
    	var calendarId:Array=new Array();
    	var holidayNames:Array=new Array();
    	var holidayDate:Array=new Array();
    	for each(var row:Object in entryList){
    		calendarId.push(row.calId);
    		holidayNames.push(row.holidayName);
    		holidayDate.push(DateField.dateToString(row.holidayDate,"YYYYMMDD"));
    	}
    	reqObj['calendarId']=calendarId; 
    	reqObj['holidayName']=holidayNames;
    	reqObj['holidayDate']=holidayDate;  	
    	return reqObj;
    }
    
   override public function preResetEntry():void
   {
		 super.getResetHttpService().url = "ref/holidayEntryDispatch.action?method=reset";
		// entryList.removeAll();
		entryGrid.reset();		 
   }
   override public function preResetAmend():void
   {
   		entryGrid.reset();
		super.getResetHttpService().url = "ref/holidayAmendDispatch.action"; 
		var reqObject:Object = new Object();
		var rndNo:Number= Math.random(); 
        reqObject.rnd = rndNo;
        reqObject.method= "resetHolidayAmend";
		/* reqObject.year=this.calYear;		  		
		reqObject.calendarPk = this.calendarPk;
		reqObject.viewOption=this.viewOption; */
		super.getResetHttpService().request = reqObject;
   }
   
   
	 override public function doEntrySystemConfirm(e:Event):void
	{
		     super.preEntrySystemConfirm();
	    	 this.dispatchEvent(new Event('entryReset'));
    		 this.back.includeInLayout = true;
    		 this.back.visible = true;
             uConfLabel.includeInLayout = true;
             uConfLabel.visible = true;
             uConfSubmit.includeInLayout = true;
             uConfSubmit.visible = true;
             sConfLabel.includeInLayout = false;
             sConfLabel.visible = false;
             sConfSubmit.includeInLayout = false;
             sConfSubmit.visible = false;
             
             sysConfMessage.includeInLayout=false;   
             sysConfMessage.visible=false;
             
             preResetEntry();
             
           	 vstack.selectedChild = qry;
           	 	
			 super.postEntrySystemConfirm();
		
	} 
	
	override public function doAmendSystemConfirm(e:Event):void
	{
		this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
	    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
	}
	override public function doCancelSystemConfirm(e:Event):void
	{
		this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
	    this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
	}
  
  private function doBack():void{
				
	if(this.mode=="cancel"){
		vstack.selectedChild = cancel;
	}
	else{
     	vstack.selectedChild = qry;	
 	}
  }  		
  
 
  
  private function doSubmit():void
  {
  	if(entryGrid.validateAllRecords()){
	  	if(this.mode == 'entry'){
	  		this.dispatchEvent(new Event('entrySave'));
	  	}
	  	else{
	  	  this.dispatchEvent(new Event('amendEntrySave'));
	  	}
  	}
  }
  /**
   * This method reads each object from the ArrayCollection received from server 
   * and adds it to the dataprovider of the entry grid with corresponding datafield name
   * @param list ArrayCollection received from server
   * @return processed ArrayCollection
   * 
   */  
  private function processResultForAmendInit(list:ArrayCollection):ArrayCollection{
  	var newCollection:ArrayCollection=new ArrayCollection();
  	
  	for each(var rowData:Object in list){
  		var tempObj:Object=new Object();
  		tempObj['calendar.calendarId']=rowData['calendarId'].toString();
  		tempObj['calendar.holidayName']=rowData['holidayName'].toString();
  		tempObj['calendar.holidayDate']=rowData['holidayDate'].toString(); 
  		
  		//required -special flag used by XenosEntryDataGrid
  		tempObj['isFreshObject']= false;
  		
  		newCollection.addItem(tempObj);  		
  	}
  	
  	return newCollection;
  }
  private function doUserConfSubmit():void{
  	uConfSubmit.enabled=false;
  	{this.mode == 'entry' ?  this.dispatchEvent(new Event('entryConf')) :  this.dispatchEvent(new Event('amendEntryConf'))};
  }
  