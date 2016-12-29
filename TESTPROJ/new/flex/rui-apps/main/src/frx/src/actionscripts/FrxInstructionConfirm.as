// ActionScript file


import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;

import flash.events.Event;

import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

private var sortUtil: ProcessResultUtil= new ProcessResultUtil(); 
[Bindable]private var frxNoLbl: String = XenosStringUtils.EMPTY_STR;


private function removeFrxPop(event:Event):void {
    this.dispatchEvent(new Event("OkSystemConfirm"));
    PopUpManager.removePopUp(this);
 }
 
 private function  confirmData():void{
	//disable button after submit.Enable after result arrives. To prevent multiple clicks :XPI-48
  	 okButton.enabled=false;
  	 cancelButton.enabled=false;
  	var reqObj : Object = new Object();
  	reqObj..SCREEN_KEY = "12076";
  	 
  	 inxPreConfirm.request = reqObj;
  	 
  	 //Send the Http Service
  	 inxPreConfirm.send(); 
  	
  }
  
  private function changeCurrentState():void{
  	headertext.includeInLayout = true;
  	headertext.visible = true;
  	uconfirmOk.includeInLayout = false;
  	uconfirmOk.visible = false;
  	sconfirmOK.includeInLayout = true;
  	sconfirmOK.visible = true;
  }
  
  	private function preConfirm(event:ResultEvent):void{
  		okButton.enabled=true;
  		cancelButton.enabled=true;
  		var rs:XML = XML(event.result);
  		errPage.clearError(event);
  		if(null != event){
			if (rs.child("Errors").length()>0){
				//confirmResult.removeAll();
				var errorInfoList : ArrayCollection = new ArrayCollection();
				//populate the error info list                  
                for each ( var error:XML in rs.Errors.error ) {
                    errorInfoList.addItem(error.toString());
                }
                errPage.showError(errorInfoList);//Display the error
                return;
			} else {
				this.changeCurrentState();
			  	if(noOfSelectedRecord > 0){
			    	frxNoLbl = this.parentApplication.xResourceManager.getKeyValue('frx.inst.label.message.totalrecords')+" : "+noOfSelectedRecord+" record(s)";
			  	}else{
			  		frxNoLbl = XenosStringUtils.EMPTY_STR;
			  	}
			}
		} else {
            //confirmResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }
  		
  }
  
