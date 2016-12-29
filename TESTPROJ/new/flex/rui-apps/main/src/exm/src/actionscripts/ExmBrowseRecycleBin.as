

import com.nri.rui.core.Globals;
import com.nri.rui.core.containers.SummaryPopup;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosQuery;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.exm.ExmConstraints;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.UIComponent;
import mx.managers.PopUpManager;
			
	 
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     [Bindable]
   	 private var queryResult:ArrayCollection= new ArrayCollection();
     
     private var keylist:ArrayCollection = new ArrayCollection(); 
     
     [Bindable] public var messageIds : ArrayCollection=new ArrayCollection();
     public var selectAllBind:Boolean=false;
     public var conformMessageIds : Array;
	 public var opName:String="";
     
     [Bindable]
     private var selectedQueueList:ArrayCollection=null;   	 
     public var SelectedMessageIds : Array;
     public var sPopup : SummaryPopup;
     private var reQueryFlag:Boolean = false;
     
	  
	  private function changeCurrentState():void{
				currentState = "result";
	  }
	  
   		 
           public function loadAll():void{
           	   parseUrlString();
           	   
           	   super.setXenosQueryControl(new XenosQuery());           	   
     
           	   this.dispatchEvent(new Event('queryInit'));
       
           	   app.submitButtonInstance = submit;  
           	   selectQueue.setFocus();
           	   queryResult.refresh();
           }
           public function reQuery():void{
				
					this.dispatchEvent(new Event('querySubmit'));
					reQueryFlag=true;
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
	                    }                    	
                    }                 

                } catch (e:Error) {
                    trace(e);
                }               
            }
        
        override public function preQueryInit():void{  
		  		super.getInitHttpService().url = "exm/messageBrowserRecycleBin.action?method=viewRecycleBin&SCREEN_KEY=1";        	
        }      
        
        private function addCommonKeys():void{  
        	keylist = new ArrayCollection(); 	   	
	    	keylist.addItem("binQueueList.item");
        }
        
        override public function preQueryResultInit():Object{        	
        	addCommonKeys();
	    	return keylist;        	
        }
        
        
        private function commonInit(mapObj:Object):void{
        	
	        selectedQueueList=new ArrayCollection();
	     
			selectedQueueList = mapObj["binQueueList.item"] as ArrayCollection;
	       	
	        selectedQueueList.refresh();
	           	
    		errPage.clearError(super.getInitResultEvent());
        }
        
        override public function postQueryResultInit(mapObj:Object):void{
        	commonInit(mapObj);
        }
        
		
		override public function preQuery():void{
			selectAllBind=false;
			messageIds.removeAll();
			conformMessageIds=null;
            qh.resetPageNo();	           
            super.getSubmitQueryHttpService().url = "exm/messageBrowserRecycleBin.action?";  
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
    	reqObj.method= "viewDetailSummary";
    	reqObj.qid = "trashq";  
		reqObj.SCREEN_KEY = '2';
	
    	if(this.selectQueue.selectedItem!=null){
    		reqObj.binq = this.selectQueue.selectedItem.value;
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
               queryResult.removeAll();
	    	 
               queryResult=mapObj["row"];
               queryResult.refresh();
			   changeCurrentState();
		            qh.setOnResultVisibility();
		            qh.setPrevNextVisibility((mapObj["prevTraversable"] == "true")?true:false,(mapObj["nextTraversable"] == "true")?true:false );
		            qh.PopulateDefaultVisibleColumns();
	    		
	    	}else{
	    		errPage.removeError();
	    		if(reQueryFlag){
	    			queryResult.removeAll();
					currentState="";
					this.dispatchEvent(new Event('queryInit'));
					reQueryFlag=false;
	    		}else{
	    			XenosAlert.info("No records found matching the search criteria.");
	    		}
	    	}    		
    	}
    	
    }       
    
    
    	  
	  public function checkSelectToModify(item:Object):void {
        var i:Number;
        var tempArray:Array = new Array();
//		messageIds.removeAll();
//		conformMessageIds=null;
        if(item.selected == true){ // needs to insert
    		messageIds.addItem(item.messageId);
    	}else { //needs to pop
    		tempArray=messageIds.toArray();
    	    messageIds.removeAll();
    		for(i=0; i<tempArray.length; i++){
    			if(tempArray[i] != item.messageId){
    			    messageIds.addItem(tempArray[i]);
    			}
    		}        		
    	}
    	conformMessageIds=	messageIds.toArray();
    	setIfAllSelected();    	    	
     }
	  
	 public function setIfAllSelected() : void {
    	if(isAllSelected()){
    		selectAllBind=true;
    	} else {
    		selectAllBind=false;
    	}
    	queryResult.refresh();	
     } 
    
     public function isAllSelected(): Boolean {
    	var i:Number = 0;        	
    	if(queryResult == null)
    		return false;
    		
    	for(i=0; i<queryResult.length; i++){
    		if(queryResult[i].selected != true) {
    			
        		return false;
        	}
    	}
    	if(i == queryResult.length) {
    		return true;
         }else {			
    		return false;        		
    	}
     }
     
     
     public function selectAllRecords(flag:Boolean): void {
     	
    	var i:Number = 0;
    	messageIds.removeAll();
//		conformMessageIds=null;
    	for(i=0; i<queryResult.length; i++){
            queryResult[i].selected = flag;
            addOrRemove(queryResult[i]);
    	}
    	
    	conformMessageIds=	messageIds.toArray();
    	queryResult.refresh();
     }
    
     public function addOrRemove(item:Object):void {
    	var i:Number;
        var tempArray:Array = new Array();
        if(item.selected == true){ 
            messageIds.addItem(item.messageId);
    	}else { //needs to pop
    		tempArray=messageIds.toArray();
    	    messageIds.removeAll();
    		for(i=0; i<tempArray.length; i++){
    			if(tempArray[i] != item.messageId)
    			    messageIds.addItem(tempArray[i]);
    		}
    	}  		
     }
      

	public function restoreMessage(event:Event) :void {
         
          if(conformMessageIds!=null && conformMessageIds.length != 0) {
          		
          		var actionType : String = "Restore";
		 		createPopUp(actionType);
           }else{
     	    	XenosAlert.error("Please select a Message");	
     	 }	
      }
           
    public function deleteMessage(event:Event) :void{

		 if(conformMessageIds!=null && conformMessageIds.length != 0) {
		 		
				var actionType : String = "Delete";
		 		createPopUp(actionType);
		  }else{
     	    XenosAlert.error("Please select a Message");	
     	 }
       }

	public function createPopUp(actionType:String):void{
		
		sPopup= SummaryPopup(PopUpManager.createPopUp(UIComponent(this.parentApplication),SummaryPopup,true));
				
		sPopup.width = 800;
	    sPopup.height = 400;
	    sPopup.showCloseButton=false;
	    PopUpManager.centerPopUp(sPopup);
	    			
		SelectedMessageIds=this.conformMessageIds;
	    sPopup.moduleUrl =ExmConstraints.RECYCLE_BIN_MESSAGE_VIEW_SWF+Globals.QS_SIGN+"actionType"+Globals.EQUALS_SIGN+actionType+Globals.AND_SIGN+"mode"+Globals.EQUALS_SIGN+"home";				
 		sPopup.owner=this;
// 		this.conformMessageIds=null;
	}	
	/**
    * This method sends the HttpService for Next Set of results operation.
    * This is actually server side pagination for the next set of results.
    */        
  	 override    public function preNext():Object{
    	   var reqObj : Object = new Object();
    	   reqObj.method = "doNext";
    	   return reqObj;
         }	
         
    /**
    * This method sends the HttpService for Previous Set of results operation.
    * This is actually server side pagination for the previous set of results.
    */    
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
	
