// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;

	[Bindable] private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
	[Bindable]private var mode : String = "entry";
	[Bindable]private var exchangeRatePkStr : String = "";
	private var keylist:ArrayCollection = new ArrayCollection();
	[Bindable]private var selectedItemArray:Array;
	[Bindable]private var confResult:ArrayCollection = new ArrayCollection();
	[Bindable]private var SelectedExerciseRefrenceNo:ArrayCollection = new ArrayCollection();
	
	private function changeCurrentState():void {
//		vstack.selectedChild = rslt;
	}
	
	public function loadAll():void {
		parseUrlString();
		trace("selectedItemArray :: " + selectedItemArray);
		super.setXenosEntryControl(new XenosEntry());
		this.dispatchEvent(new Event('entrySave'));
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
            if(params != null) {
                for (var i:int = 0; i < params.length; i++) {
                    var tempA:Array = params[i].split("=");  
                    if (tempA[0] == "mode") {
                        mode = tempA[1];
                    } else if(tempA[0] == "selectedItems") {
                        this.selectedItemArray = (tempA[1] as String).split(",");
                    } 
                }                       
            } else {
                mode = "entry";
            }                 

        } catch (e:Error) {
            trace(e);
        }
    }
    
	private function addCommonResultKeys():void {
		keylist = new ArrayCollection();
		keylist.addItem("selectedTxnViewList.selectedView");
	}
	
	private function commonResult(mapObj:Object):void {
		softWarning.dataProvider = null;
		softWarning.visible = false;
		softWarning.includeInLayout = false;
		
		if(mapObj!=null) {
            if(mapObj["errorFlag"].toString() == "error") {
            	errPage.showError(mapObj["errorMsg"]);
            	displayErrorOnMain(mapObj["errorMsg"]);                        
            } else if(mapObj["errorFlag"].toString() == "noError") {
            	errPage.clearError(super.getSaveResultEvent());
            	confResult = mapObj[keylist.getItemAt(0)] as ArrayCollection;
            	app.submitButtonInstance = uConfSubmit;    
            } else{
            	errPage.removeError();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
            }           
        }
	}
	
	override public function preEntry():void {
		super.getSaveHttpService().url = "slr/noReturnDispatch.action?";
		super.getSaveHttpService().request = populateRequestParams();
	}
	
	override public function preEntryResultHandler():Object {
		addCommonResultKeys();
		return keylist;
	}
	
	override public function postEntryResultHandler(mapObj:Object):void {
		commonResult(mapObj);
	}
	
	override public function preEntryConfirm():void {
		var reqObj :Object = new Object();
		
		super.getConfHttpService().url = "slr/noReturnDispatch.action?";
		reqObj.method= "doConfirm";
		reqObj.SCREEN_KEY = "11166";
		super.getConfHttpService().request = reqObj;
	}
	
	override public function preEntryConfirmResultHandler():Object {
		keylist = new ArrayCollection();
		keylist.addItem("selectedTxnViewList.selectedView");
		return keylist;
	}
	
	override public function postConfirmEntryResultHandler(mapObj:Object):void {
		submitUserConfResult(mapObj);
	}
	
	private function submitUserConfResult(mapObj:Object):Boolean {
        if(mapObj!=null) {    
            if(mapObj["errorFlag"].toString() == "error") {
                errPage.showError(mapObj["errorMsg"]);
                uConfSubmit.enabled = true;
				uConfBack.enabled = true;
            } else if(mapObj["errorFlag"].toString() == "noError") {
            	errPage.clearError(super.getConfResultEvent());
            	confResult = mapObj[keylist.getItemAt(0)] as ArrayCollection;
            	uConfBack.visible = false;
            	uConfBack.includeInLayout = false;
            	uConfSubmit.includeInLayout = false;
            	uConfSubmit.visible = false;
            	
            	sConfLabel.includeInLayout = true;
            	sConfLabel.visible = true;
            	uConfLabel.includeInLayout = false;
            	uConfLabel.visible = false;
            	sConfSubmit.includeInLayout = true;
            	sConfSubmit.visible = true;
            	app.submitButtonInstance = sConfSubmit;
            	
            	return true;        
            } else {
                errPage.removeError();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.error.occurred'));
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
        var retQtyArray:Array = new Array();
        var holdQtyArray:Array = new Array();
        reqObj.method = "doSubmit";
        reqObj.SCREEN_KEY = "11165";
		for(var index:int=0; index<selectedItemArray.length; index++ ) {
            retQtyArray.push(this.parentDocument.owner.queryResult[selectedItemArray[index]].returnQtyStr);
            holdQtyArray.push(this.parentDocument.owner.queryResult[selectedItemArray[index]].holdQtyStr);
        }  
		reqObj.selectedIndexArray = selectedItemArray;
		reqObj.selectedReturnQtyArray = retQtyArray;
		reqObj.selectedHoldQtyArray = holdQtyArray;
		
        return reqObj;
    }
    
	override public function doEntrySystemConfirm(e:Event):void {
		super.preEntrySystemConfirm();
		
		uConfLabel.includeInLayout = true;
		uConfLabel.visible = true;
		uConfSubmit.includeInLayout = true;
		uConfSubmit.visible = true;
		uConfBack.visible = true;
		uConfBack.includeInLayout = true;
		
		sConfLabel.includeInLayout = false;
		sConfLabel.visible = false;
		sConfSubmit.includeInLayout = false;
		sConfSubmit.visible = false;
		
		this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
		super.postEntrySystemConfirm();
	}
	
	private function doBack():void {
       // this.parentDocument.owner.refreshQuery = true;      
        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
	}
	
	private function doSubmit():void{
		this.dispatchEvent(new Event('entryConf'));
		uConfSubmit.enabled = false;
		uConfBack.enabled = false;
	}
	private function displayErrorOnMain(errColl:ArrayCollection):void{
	    this.parentDocument.owner.showErrorFromPopup(errColl);
	    doBack();
	}