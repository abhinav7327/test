// ActionScript file

import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.utils.XenosStringUtils;

import mx.core.UIComponent;
import mx.rpc.events.ResultEvent;

private var flagForceMatch:String = XenosStringUtils.EMPTY_STR;

private function doForceMatch():void {
    
    var objSelected1:Object;
    var objSelected2:Object;
    
    flagForceMatch = "FORCE_MATCH";
    if(operatopnArray.length < 2){
        XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.select1stlrecordand1rcvdrecord'));
        return;
    }else if(operatopnArray.length >= 2){
        var csiPk:String = XenosStringUtils.EMPTY_STR;
        var obj:Object = null;
        var receiveNoticeArray:Array = new Array();
        //extract settlement side and receive notice side
        for(var i:int=0; i<operatopnArray.length; i++){
            obj = operatopnArray[i];
            if(obj.clientSettlementInfoPk != "-1"){  //settlement Record
                csiPk = obj.clientSettlementInfoPk;
            }else{
                receiveNoticeArray.push(obj.receivedCompNoticeInfoPk);
                if(obj.typeOfRecord != "R" || obj.messageStatus != "OUTSTANDING" || obj.receivedCompNoticeInfoPk == "-1" ){
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.select.valid.mt566.record'));
                    return;
                }
            }
            
        }
        if(XenosStringUtils.isBlank(csiPk)){
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.select.stl.record'));
            return;            
        }else if(receiveNoticeArray.length == 0){
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.select.atleast.one.mt566.record'));
            return;            
        }else {        
            
            //Send information to the server
            var reqObj:Object = new Object();
            reqObj.method = "doForceMatch";
            reqObj.ClientSettlementInfoPk = csiPk;
            //reqObj.ReceivedCompNoticeInfoPk = rcvdInfoPk;
            reqObj.receivedCompNoticeInfoPkArray = receiveNoticeArray;
            reqObj.ActionType = "FORCE_MATCH";
            
            caxRcvdNoticeForceMatchRequest.request = reqObj;
            caxRcvdNoticeForceMatchRequest.send();
            
        }
    }/* else{
        XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.forcematchformorethantworecords'));
    }*/
}

private function doCxlForceMatch():void {    
    var objSelected:Object;
    
    flagForceMatch = "CXL_FORCE_MATCH";
    if(operatopnArray.length == 0 || operatopnArray.length > 1){
        XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.selectonercvdrecord'));
        return;
    }else if(operatopnArray.length == 1){
        objSelected = operatopnArray[0];            
        if(objSelected == null || objSelected.typeOfRecord != "R" || objSelected.messageStatus != "FORCE_MATCHED" ||  objSelected.receivedCompNoticeInfoPk == "-1"){
            XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('stl.message.error.selectvalidforcematchrcvdrecord'));
            return;
        }
        //Send information to the server

        var reqObj:Object = new Object();
        reqObj.method = "doCxlForceMatch";        
        reqObj.ReceivedCompNoticeInfoPk = objSelected.receivedCompNoticeInfoPk;
        reqObj.ActionType = "CXL_FORCE_MATCH";
        
        caxRcvdNoticeCxlForceMatchRequest.request = reqObj;
        caxRcvdNoticeCxlForceMatchRequest.send();        
        
        
    }
}

private function loadResultPage(event:ResultEvent):void {
    var rs:XML = XML(event.result);
    
    
    if (null != event && rs != null) {
        if(rs.child("Errors").length()>0) {
            //some error found			
			var errorInfoList : ArrayCollection = new ArrayCollection();
			//populate the error info list 			 	
			for each ( var error:XML in rs.Errors.error ) {
				errorInfoList.addItem(error.toString());
			}
			errPage2.showError(errorInfoList);//Display the error
        }else{
            errPage2.removeError();
            //TODO 
            //Open Completion Popup for Force match & Cxl Force Match  			
            openForceMatchPopup();
        }
    }else{        
		XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
        
    }
}

private function openForceMatchPopup():void{
    var parentApp :UIComponent = UIComponent(this.parentApplication);     
       
    sPopup= SummaryPopup(PopUpManager.createPopUp(parentApp,SummaryPopup,false));
    sPopup.addEventListener(CloseEvent.CLOSE,closeHandler,false,0,true);
    
    
    
    if(flagForceMatch == "FORCE_MATCH"){
        sPopup.title = this.parentApplication.xResourceManager.getKeyValue('stl.receivenoticepopup.title.completionentry');
        sPopup.width = 840;
        sPopup.height = 600;
        PopUpManager.centerPopUp(sPopup); //CompletionQuery.swf?target=ADD
        sPopup.moduleUrl = "assets/appl/stl/CompletionQuery.swf"+Globals.QS_SIGN+"target"+
                           Globals.EQUALS_SIGN + "CAX_RECEIVE_NOTICE" + Globals.AND_SIGN + "path" + 
                           Globals.EQUALS_SIGN + "CAX_RECEIVE_NOTICE";
    }else{         
        sPopup.title = this.parentApplication.xResourceManager.getKeyValue('stl.receivenoticepopup.title.completioncxluserconfirmation');
        sPopup.width = 820;
        sPopup.height = 330;
        PopUpManager.centerPopUp(sPopup);
        sPopup.owner = this;       
        sPopup.moduleUrl = "assets/appl/stl/CompletionEntryNCancel.swf" + Globals.QS_SIGN 
                           + "mode" + Globals.EQUALS_SIGN + "CXL_CAX_RECEIVE_NOTICE" + Globals.AND_SIGN + "path" + 
                           Globals.EQUALS_SIGN + "CANCEL_RECV_NOTICE" + Globals.AND_SIGN + 
                           "recvPk" + Globals.EQUALS_SIGN + (operatopnArray[0] as Object).receivedCompNoticeInfoPk;

    }
}