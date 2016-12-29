// ActionScript file

import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.ProcessResultUtil;
import com.nri.rui.core.utils.XenosStringUtils;
import flash.events.Event;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import com.nri.rui.core.Globals;
private var sortUtil: ProcessResultUtil= new ProcessResultUtil(); 
[Bindable]private var drvNoLbl: String = XenosStringUtils.EMPTY_STR;
[Bindable] public var actionMode:String = "query";
[Bindable] private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);


private function removeDrvPop(event:Event):void {
    this.dispatchEvent(new Event("OkSystemConfirm"));
    PopUpManager.removePopUp(this);
 }
 public function removeMe():void {
    this.dispatchEvent(new Event("OkSystemConfirm"));
  	PopUpManager.removePopUp(this);
}
 private function  confirmData():void{
  	 okButton.enabled=false;
  	 cancelButton.enabled=false;
  	var reqObj : Object = new Object();
  	reqObj..SCREEN_KEY = "13007";
  	app.submitButtonInstance = okBtn;
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
			    	drvNoLbl = this.parentApplication.xResourceManager.getKeyValue('drv.inst.label.message.totalrecords')+" : "+noOfSelectedRecord+" record(s)";
			  	}else{
			  		drvNoLbl = XenosStringUtils.EMPTY_STR;
			  	}
			}
		} else {
            //confirmResult.removeAll();
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        }		
  }
  