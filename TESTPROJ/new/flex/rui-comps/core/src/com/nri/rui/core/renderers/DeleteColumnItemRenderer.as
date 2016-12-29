package com.nri.rui.core.renderers{

    import com.nri.rui.core.controls.XenosAlert;
    
    import flash.events.Event;
    import flash.events.MouseEvent;
    import mx.collections.ArrayCollection;
    import mx.containers.HBox;
    import mx.controls.Image;
    import mx.controls.listClasses.BaseListData;
    import mx.controls.listClasses.IDropInListItemRenderer;
    import com.nri.rui.core.controls.XenosHTTPService;
    import mx.rpc.events.FaultEvent;
    import mx.rpc.events.ResultEvent;
 

    public class DeleteColumnItemRenderer extends HBox implements IDropInListItemRenderer{
    	
       	// Make the listData property bindable.
    	[Bindable("dataChange")]
		private var _listData : BaseListData;
		[Embed(source="../../../../../assets/delete.png")]
		private static var removeIcon:Class;
		private var deleteIcon : Image;
		public var deleteEmpAppRole : XenosHTTPService;
		
		[Bindable] public var _mode:String = "amend";
		
		private var rs:XML;
		
		//Constructor
		public function DeleteColumnItemRenderer(){
		
			super();
			this.deleteIcon = new Image();
			this.deleteIcon.id="delete";
			this.deleteIcon.includeInLayout=true;
			this.deleteIcon.visible=true;
			this.deleteIcon.source=removeIcon;
			this.deleteIcon.addEventListener(MouseEvent.CLICK, deleteRecord);
			this.addChild(deleteIcon);
            //initialize the http service
            this.deleteEmpAppRole = new XenosHTTPService();
            this.deleteEmpAppRole.addEventListener("result", updateEmpAppRoleList);
            this.deleteEmpAppRole.addEventListener("fault", showErrorMessage);   
            this.deleteEmpAppRole.showBusyCursor=true;
            this.deleteEmpAppRole.useProxy=false;
            this.deleteEmpAppRole.resultFormat="xml";
            this.rs = new XML()       
		}
		
		public function get listData() : BaseListData{
		
			return _listData;
		}                                        
	
		public function set listData( value : BaseListData ) : void{
		
			_listData = value;
		}
     	
     	//Request to the server to delete selected row
		private function deleteRecord(e:Event) : void {
			populateUrl();
			this.deleteEmpAppRole.send();
		}
		// Populating the URL to be fired
		private function populateUrl () : void {
			var rndNo:Number;
			rndNo= Math.random();
			var index : int = data.selectedIndex;
			var reqObj : Object = new Object();
			reqObj.deleteIndexEmpApplnRoleParticipant = index;
			reqObj.rnd = rndNo;
			reqObj.method="deleteApplRoleNames";
			this.deleteEmpAppRole.request = reqObj;
			if(this._mode=="amend"){
				this.deleteEmpAppRole.url="ref/employeeAmendDispatch.action?";
			}else{
			this.deleteEmpAppRole.url="ref/employeeDispatch.action?";
			}
		}
		
		//Updating the list of record after server side processing
        private function updateEmpAppRoleList(event: ResultEvent):void {
        		
        	rs = XML(event.result);
		    if (null != event) {
				if(rs.child("empApplnRoleParticipantList").length()>0) {
					var recNo : int = 0;
					this.parentDocument.errPage.clearError(event);
		            this.parentDocument.empApplRoleList.removeAll();
					try {
					    for each ( var rec:XML in rs.empApplnRoleParticipantList.empApplnRoleParticipantPage) {
		 				    rec.selectedIndex = recNo++;
		 				    this.parentDocument.empApplRoleList.addItem(rec);
					    }
					 	this.parentDocument.empApplRoleList.refresh();
					}catch(e:Error){
					    //XenosAlert.error(e.toString() + e.message);
					    XenosAlert.error("No result found");
				    }
				}else if(rs.child("Errors").length()>0) {
	                //some error found
				 	var errorInfoList : ArrayCollection = new ArrayCollection();
	                //populate the error info list 			 	
				 	for each ( var error:XML in rs.Errors.error ) {
		 			   errorInfoList.addItem(error.toString());
					}
				 	this.parentDocument.errPage.showError(errorInfoList);//Display the error
				}
	        }
        }
        
        private function showErrorMessage(event: FaultEvent):void {
           var faultstring:String = event.fault.faultString;
           XenosAlert.error('Error Occured :  ' + faultstring );
           
        }
            
	}

}