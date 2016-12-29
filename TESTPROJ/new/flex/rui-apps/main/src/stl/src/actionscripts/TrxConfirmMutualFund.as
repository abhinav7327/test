
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.utils.XenosStringUtils;
 
 import flash.events.Event;
 
 import mx.managers.PopUpManager;
 import mx.rpc.events.ResultEvent;
 
 [Bindable]
 public var summary:ArrayCollection= new ArrayCollection();
 
 [Bindable]
 public var summaryReport:ArrayCollection= new ArrayCollection();
 
 [Bindable]
 public var trxNoLbl:String = XenosStringUtils.EMPTY_STR;
// ActionScript file
 private function removeTrxPop(event:Event):void {

    this.dispatchEvent(new Event("OkSystemConfirm"));
    PopUpManager.removePopUp(this);
 }
 
 private function  confirmData(event:Event):void{
 	//disable button after submit.Enable after result arrives. To prevent multiple clicks :XPI-48
  	 okButton.enabled=false;
  	 var reqObj : Object = new Object();
  	 reqObj.testKey = key.text;
  	 reqObj.priority = pr.text;
  	 reqObj.remarks1 = rm1.text;
  	 reqObj.remarks2 = rm2.text;
  	 reqObj.SCREEN_KEY = 13022;
  	 inxPreConfirm.request = reqObj;
  	 
  	 //Send the Http Service
  	 inxPreConfirm.send();
  	 
  	
  }
  
 private function  preConfirm(event:ResultEvent):void{
 	okButton.enabled=true;
 	var preSubmit : Boolean = false;
  	var trxNo : String = XenosStringUtils.EMPTY_STR;
  	var totalRecords:int = 0;
  	 
 	var rs:XML = XML(event.result);

		if (null != event) {
			if(rs.child("row").length()>0) {
				
				errPage.clearError(event);
				summary.removeAll();
				try {
					  	  
					preSubmit =(rs.preSubmit == "true")?true:false;
  					trxNo = rs.trxRefNo;
  					totalRecords = rs.child("row").length();
  					
  					if(totalRecords > 0){
  						trxNoLbl = this.parentApplication.xResourceManager.getKeyValue('stl.trxmaintenance.message.totalrecords')+" : "+totalRecords+" record(s)";
  					} else {
  						trxNoLbl = XenosStringUtils.EMPTY_STR;
  					}
					
					for each ( var rec:XML in rs.row ) {
						summary.addItem(rec);
					}						
						
				} catch(e:Error) {
					XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				}
				
				if(rs.child("reportRow").length()>0) {
					summaryReport.removeAll();
					try {
						for each ( var report:XML in rs.reportRow) {
							summaryReport.addItem(report);
						}						
					} catch(e:Error) {
						XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
					}
				} 
			} else if(rs.child("Errors").length()>0) {
				//some error found
				summary.removeAll(); // clear previous data if any as there is no result now.
				var errorInfoList : ArrayCollection = new ArrayCollection();
				//populate the error info list 			 	
				for each ( var error:XML in rs.Errors.error ) {
					errorInfoList.addItem(error.toString());
				}
				errPage.showError(errorInfoList);//Display the error
				return;
			} else {
				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				summary.removeAll(); // clear previous data if any as there is no result now.
				errPage.clearError(event); //clears the error if any
			}
		} else {
			summary.removeAll();
			XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		}
  		changeCurrentState(preSubmit);
  } 
  
  private function changeCurrentState(preSubmit:Boolean):void {
  	vstack.selectedChild = sconfirm;
  	if(preSubmit){  		
  		currentState = 'confirm';
  	}


  }
  
  private function submitConfirm():void{
  	//XenosAlert.info("Submit Confirm going");
  	 
  	 var reqObj : Object = new Object();
  	 reqObj.testKey = key.text;
  	 reqObj.priority = pr.text;
  	 reqObj.remarks1 = rm1.text;
  	 reqObj.remarks2 = rm2.text;
  	 
  	 inxSubmitConfirm.request = reqObj;
  	 inxSubmitConfirm.send();
  	 
  }