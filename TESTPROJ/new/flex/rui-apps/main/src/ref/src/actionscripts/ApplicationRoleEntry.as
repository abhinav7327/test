// ActionScript file
import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.ref.validators.ApplicationRoleEntryValidator;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.collections.IList;
import mx.events.CloseEvent;
import mx.rpc.events.ResultEvent;
            
      
     [Bindable]
     private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     
     
            [Bindable]private var mode:String = 'entry';
            [Bindable]private var appRolePkStr : String = "";
            [Bindable]public var remarkStr : String = "";
            [Bindable]private var menuDetails:ArrayCollection= new ArrayCollection();
            [Bindable]private var uConfMenuDetails:ArrayCollection= new ArrayCollection();
            [Bindable]private var uConfReportDetails:ArrayCollection= new ArrayCollection();
            [Bindable]private var reportDetails:ArrayCollection= new ArrayCollection();
            private var keylist:ArrayCollection = new ArrayCollection();
            [Bindable]private var exmDetails:ArrayCollection= new ArrayCollection();
            [Bindable]private var uConfExmDetails:ArrayCollection= new ArrayCollection();
            [Bindable]private var cnt:int = -1;
            [Bindable]private var editIndex:int = -1;
            [Bindable]private var groupPkStrForEdit:String = '';
      
      private function changeCurrentState():void{
                //hdbox1.selectedChild = this.rslt;
                //currentState = "result";
                vstack.selectedChild = rslt;
     }
    
               public function loadAll():void{
               parseUrlString();
               super.setXenosEntryControl(new XenosEntry());
               //XenosAlert.info("mode : "+mode);
               if(this.mode == 'entry'){
                 this.dispatchEvent(new Event('entryInit'));
                 this.appRole.setFocus();
                //hdbox1.selectedChild = this.qry;
                 //this.currentState="entryState";
                 vstack.selectedChild = qry;
               } else if(this.mode == 'amend'){
                 this.dispatchEvent(new Event('amendEntryInit'));
                 this.appRole.setFocus();
                //hdbox1.selectedChild = this.qry;
                 //this.currentState="entryState";
                 vstack.selectedChild = qry;
               } else { 
                 this.dispatchEvent(new Event('cancelEntryInit'));
                 if(mode == "view"){
                    //uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('ref.applrole.label.applroleinfo');
                    //close.includeInLayout = true;
                    //close.visible = true;
                    actionBtnPanel.includeInLayout = false;
                    actionBtnPanel.visible = false;
                    viewDisplay1.includeInLayout = true;
                    viewDisplay1.visible = true;
                    viewDisplay2.includeInLayout = true;
                    viewDisplay2.visible = true;
                    viewDisplay3.includeInLayout = true;
                    viewDisplay3.visible = true;
                                        
                 }
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
                            }else if(tempA[0] == "appRolePk"){
                                this.appRolePkStr = tempA[1];
                            } 
                        }                       
                    } else{
                        mode = "entry";
                    }                 

                } catch (e:Error) {
                    trace(e);
                }               
            }
            private function addMenus():void{
                //if(mode != nu)
                var requstObj:Object = populateAddMenuRequest();
                requstObj.method= "addMenuDetails";
                
                if(getAddMenuValidationResult(requstObj)["type"] != "Invalid"){                 
                   addMenuService.request = requstObj;
                   addMenuService.send();
                   btnAdd.enabled = false;
                }else{
                    XenosAlert.error(getAddMenuValidationResult(requstObj)["msg"]);
                }
            }
            
            private function populateAddMenuRequest():Object{
                var reqObj:Object = new Object();
                var menuArr:Array = new Array();
                for each(var item:Object in this.menuName.selectedItems){
                    //if(this.menuName.selectedItem)
                    menuArr.push(item.value);
                }
               reqObj.menuName = menuArr;
               reqObj.menuAccessType = this.accessType.selectedItem.value;
               return reqObj;
            }
            
            private function getAddMenuValidationResult(validateObj:Object):Object{
                var validationResult:Object = new Object();
                 validationResult["type"]="Valid";
                if(this.menuName.selectedItems.length == 0){
                    validationResult["type"]="Invalid";
                    validationResult["msg"]="Menu Name cannot be empty";
                    return validationResult;
                }else{                  
                 for each(var item:Object in this.menuName.selectedItems){                  
                    if(item.value == null || item.value == " "){
                      validationResult["type"]="Invalid";
                      validationResult["msg"]="Menu Name cannot be empty";   
                      return validationResult;                  
                    }
                  }              
                }
                if(this.accessType.selectedItem.value == " "){
                    validationResult["type"]="Invalid";
                    validationResult["msg"]="Menu Access Type cannot be empty";
                    return validationResult; 
                }
                return validationResult;
                
            }
            
            public function addMennuResultHandler(event:ResultEvent):void{
                menuGridCont.enabled = true;
                 var resultObj:XML = XML(event.result);
                this.menuDetails.removeAll();
                btnAdd.enabled = true;
                this.menuName.selectedIndex = 0;
                this.accessType.selectedIndex = 0;
                //(this.menuName.dataProvider as ArrayCollection).refresh();
                this.menuName.selectedIndex = 0;
                for each (var result:XML in resultObj.menuRoleParticipants.menuRoleParticipant){
                    //XenosAlert.info(keyPart[i]);
                    //XenosAlert.info(result);
                    this.menuDetails.addItem(result);
                }
                btnAddMenus.includeInLayout = true;
                btnAddMenus.visible = true;
                btnCancelMenus.includeInLayout = false;
                btnCancelMenus.visible = false;
                btnSaveMenus.includeInLayout = false;
                btnSaveMenus.visible = false;
                var index:int =0;
                for each(var item : Object in menuDetails){
                    item["rowNum"]=index;
                    item["btnVisible"] = true;                  
                    //BindingUtils.bindProperty(item,"btnVisible");
                    
                    index++;
                }
            }

            public function editMennuResultHandler(event:ResultEvent):void{
                 var resultObj:XML = XML(event.result);
                var initcol:ArrayCollection=new ArrayCollection();
                var indx:int = -1;
                initcol= this.menuName.dataProvider as ArrayCollection;
                //XenosAlert.info(resultObj.menuName);
                //XenosAlert.info(resultObj.menuAccessType +" indx :" +indx);
                for each(var item:Object in initcol){           
                    if(XenosStringUtils.equals(item.value,resultObj.menuName)){
                      //  XenosAlert.info(item.value);      
                        indx = initcol.getItemIndex(item);
                    }
                }
                //XenosAlert.info(resultObj.menuName +" indx :" +indx);
                this.menuName.selectedIndex = indx != -1 ? indx : 0;
                
                //initcol.removeAll();
                indx =-1;
                var initcol1:ArrayCollection= this.accessType.dataProvider as ArrayCollection;
                for each(item in initcol1){  
                    if(XenosStringUtils.equals(item.value,resultObj.menuAccessType)){
                       //XenosAlert.info(item.value);      
                        indx= initcol1.getItemIndex(item);
                    }
                }
                //XenosAlert.info(resultObj.menuAccessType +" indx :" +indx);
                this.accessType.selectedIndex  = indx != -1 ? indx : 0;
                menuGridCont.enabled = false;
            
            }
            
            public function handleEdit(data:Object):void{
                var reqObj:Object = new Object();
                reqObj.method="editMenuXref";
                reqObj.editMenuIndexNumber = data.rowNum;
                editMenuService.request = reqObj;
                editMenuService.send();
                btnAddMenus.includeInLayout = false;
                btnAddMenus.visible = false;
                btnCancelMenus.includeInLayout = true;
                btnCancelMenus.visible = true;
                btnSaveMenus.includeInLayout = true;
                btnSaveMenus.visible = true;
                data.btnVisible = false; 
                menuDetails.refresh();       
            }
            
            public function handleDelete(data:Object):void{
                
                var reqObj:Object = new Object();
                reqObj.method="deleteMenuXref";
                reqObj.editMenuIndexNumber = data.rowNum;
                deleteMenuService.request = reqObj;
                deleteMenuService.send();
                btnAddMenus.includeInLayout = false;
                btnAddMenus.visible = false;
                data.btnVisible = false;   
                menuDetails.refresh();                                          
            }
            private function cancelMenus():void{
                var requstObj:Object = populateAddMenuRequest();
                requstObj.method= "cancelMenu";
                if(getAddMenuValidationResult(requstObj)["type"] != "Invalid"){                 
                   addMenuService.request = requstObj;
                   addMenuService.send();
                   btnAdd.enabled = false;
                }else{
                    XenosAlert.error(getAddMenuValidationResult(requstObj)["msg"]);
                }
                
            }
            private function saveMenus():void{
                var requstObj:Object = populateAddMenuRequest();
                requstObj.method= "updateMenu";
                if(getAddMenuValidationResult(requstObj)["type"] != "Invalid"){                 
                   addMenuService.request = requstObj;
                   addMenuService.send();
                   btnAdd.enabled = false;
                }else{
                    XenosAlert.error(getAddMenuValidationResult(requstObj)["msg"]);
                }
                
            }
            
            // report control
            private function addItem():void{
                var requstObj:Object = new Object();
                
                var validationResult:Object = getReportServiceValidationResult(this.sourceReportName.selectedItem); 
                
                if(validationResult["type"] != "Invalid"){ 
                    var reportNameArray:Array = new Array();
                    for (var i:int = 0; i < this.sourceReportName.selectedItems.length; i++) {
                        var item:Object = this.sourceReportName.selectedItems[i];
                   	    reportNameArray.push(item.value);
                    }  
	 			    requstObj.reportIdArr = reportNameArray;
	 			    requstObj.method= "addReportDetails";                
	 			    addReportService.request = requstObj;
	 			    addReportService.send();
	    		    addRemoveBtnCont.enabled = false;
                    var srsRptArr:Array = new Array();
                    for (i = 0; i < this.sourceReportName.selectedItems.length; i++) {
                    	item = this.sourceReportName.selectedItems[i];
                    	srsRptArr.push(item);
                    }
                    trace("srsRptArr - before sorting : " + srsRptArr);
                    srsRptArr.sort();
                    trace("srsRptArr - after sorting : " + srsRptArr);
                    for (i = 0; i < srsRptArr.length; i++) {
                        item = srsRptArr[i];
	                    var selectedIndx:int = IList(sourceReportName.dataProvider).getItemIndex(item);
	                    IList(targetReportName.dataProvider).addItem(item);
	                    IList(sourceReportName.dataProvider).removeItemAt(selectedIndx);
                    }  
                } else {
                    XenosAlert.error(validationResult["msg"]);
                }
            }
            
            private function removeItem():void{
                
                var requstObj:Object = new Object();
                var validationResult:Object = getReportServiceValidationResult(this.targetReportName.selectedItem); 
                
                if(validationResult["type"] != "Invalid"){  
                	var deleteReportIndexArray:Array = new Array();
                    for (var i:int = 0; i < this.targetReportName.selectedItems.length; i++) {
                    	var item:Object = this.targetReportName.selectedItems[i];
                		var selectedIndx:int = IList(targetReportName.dataProvider).getItemIndex(item);
                		deleteReportIndexArray.push(selectedIndx);
                	}  
                    requstObj.deleteReportIndexArray = deleteReportIndexArray;
                    requstObj.method= "deleteReportXref";                    
                    deleteReportService.request = requstObj;
                    deleteReportService.send();
                    addRemoveBtnCont.enabled = false;
                    var tgtRptArr:Array = new Array();
                    for (i = 0; i < this.targetReportName.selectedItems.length; i++) {
                        item = this.targetReportName.selectedItems[i];
                        tgtRptArr.push(item);
                    }
                    trace("srsRptArr - before sorting : " + tgtRptArr);
                    tgtRptArr.sort();
                    trace("srsRptArr - after sorting : " + tgtRptArr);
                    for (i = 0; i < tgtRptArr.length; i++) {
                        item = tgtRptArr[i];
                        selectedIndx = IList(targetReportName.dataProvider).getItemIndex(item);
                        IList(sourceReportName.dataProvider).addItem(item);
                        IList(targetReportName.dataProvider).removeItemAt(selectedIndx);
                    }  
                } else {
                    XenosAlert.error(validationResult["msg"]);
                }
            }
            
            
            private function reportServiceResultHandler(event:ResultEvent):void{
                 addRemoveBtnCont.enabled = true;
//               var resultObj:XML = XML(event.result);
//               reportDetails.removeAll();
//               for each( var reportItem:XML in resultObj.reportParticipants.reportParticipant){
//                  reportDetails.addItem(reportItem);
//               }
            }
            
            private function getReportServiceValidationResult(validateObj:Object):Object{
                var validationResult:Object = new Object();
                 validationResult["type"]="Valid";
                if(validateObj == null || validateObj.value == " "){
                    validationResult["type"]="Invalid";
                    validationResult["msg"]="ReportId  cannot be empty";
                    return validationResult; 
                }
                return validationResult;
                
            }
            
        //report control end   
         
          private function doBack():void{
                        //hdbox1.selectedChild = this.qry;
                         //this.currentState="entryState";
                         vstack.selectedChild = qry;    
                 app.submitButtonInstance = submit;
          }  
           
        
        private function addCommonKeys():void{          
            keylist = new ArrayCollection();
            keylist.addItem("serviceOfficeList.officeId");
            keylist.addItem("accountRestrictions.item");
            keylist.addItem("menuNames.item");
            keylist.addItem("menuAccessTypes.item");
            keylist.addItem("reportIds.item");  
            keylist.addItem("exmMonitorRuleList.item");  
            keylist.addItem("accessTypeList.accessTypeListItem");  
        }
        
        
        private function commonInit(mapObj:Object):void{
            this.appRole.text = "";
            this.remarks.text = "";
            if(this.targetReportName.dataProvider != null){
                (this.targetReportName.dataProvider as ArrayCollection).removeAll();
            } 
            //menuName.selectedItems
            //accessType.dataProvider
            //accessType.getItemIndex(item)
            ///accessType.selectedIndex
            
            btnAddMenus.includeInLayout = true;
            btnAddMenus.visible = true;
            btnCancelMenus.includeInLayout = false;
            btnCancelMenus.visible = false;
            btnSaveMenus.includeInLayout = false;
            btnSaveMenus.visible = false;
            menuGridCont.enabled = true;
            errPage.clearError(super.getInitResultEvent());
            
            var index:int=-1;
            var initcol:ArrayCollection = null;
            
            initcol=new ArrayCollection();
            initcol.addItem(" ");
            index=-1;
            for each(var item:Object in (mapObj[keylist.getItemAt(0)] as ArrayCollection)){
                initcol.addItem(item);
                if(this.mode == "amend" && item == mapObj[keylist.getItemAt(6)].toString()){
                    index= (mapObj[keylist.getItemAt(0)] as ArrayCollection).getItemIndex(item);
                }
            }
            officeId.dataProvider = initcol;
            officeId.selectedIndex = index != -1 ? (index+1) : 0;
            
            initcol=new ArrayCollection();
            initcol.addItem({label:" ", value: " "});
            index=-1;
            for each(item in (mapObj[keylist.getItemAt(1)] as ArrayCollection)){
                initcol.addItem(item);
                if(this.mode == "amend" && item.label == mapObj[keylist.getItemAt(7)].toString()){
                    index= (mapObj[keylist.getItemAt(1)] as ArrayCollection).getItemIndex(item);
                }
            }
            acRestriction.dataProvider = initcol;
            acRestriction.selectedIndex = index != -1 ? (index+1) : 0;
            
            initcol=new ArrayCollection();
            initcol.addItem({label:" ", value: " "});
            index=0;
            for each(item in (mapObj[keylist.getItemAt(2)] as ArrayCollection)){
                initcol.addItem(item);
            }
            menuName.dataProvider = initcol;
            //acRestriction.selectedIndex = 0;
            
            initcol=new ArrayCollection();
            initcol.addItem({label:" ", value: " "});
            index=0;
            for each(item in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
                initcol.addItem(item);
            }
            accessType.dataProvider = initcol;
            accessType.selectedIndex = 0;
            
            if(targetReportName.dataProvider == null){
               targetReportName.dataProvider = new ArrayCollection();
                
            }
            initcol=new ArrayCollection();
            initcol.addItem({label:" ", value: " "});
            index=0;
            for each(item in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
            
                    initcol.addItem(item);
                
            }
            sourceReportName.dataProvider = initcol;
            //acRestriction.selectedIndex = 0;          
            
            initcol = new ArrayCollection();
            initcol.addItem({label: " ", value: " "});
            for each(item in (mapObj[keylist.getItemAt(5)] as ArrayCollection)){            
                initcol.addItem(item);                
            }
            exmRuleName.dataProvider = initcol;        

            initcol = new ArrayCollection();
            initcol.addItem(" ");
            for each(item in (mapObj[keylist.getItemAt(6)] as ArrayCollection)){            
                initcol.addItem(item);                
            }
            exmAccessType.dataProvider = initcol;        
        }
        
    
    private function populateRequestParams():Object {
        
        var reqObj : Object = new Object();
        
        reqObj.method= "doConfirm";
        
        reqObj.applicationRoleNameDisp = this.appRole.text;
        
        reqObj.officeId =  officeId.selectedItem;
        
        reqObj.accountAccessRestrFlag = this.acRestriction.selectedItem.value;
        
        reqObj.remarks = this.remarks.text;
        return reqObj;
    }
    
        
     
        private function addCommonResultKeys():void{
            keylist = new ArrayCollection();
            keylist.addItem("applicationRoleNameDisp");
            keylist.addItem("officeId");
            keylist.addItem("accountRestrictionExp");
            keylist.addItem("remarks");
            keylist.addItem("menuRoleParticipants.menuRoleParticipant");
            keylist.addItem("reportParticipants.reportParticipant");
            keylist.addItem("exmMonitorRuleParticipants.exmMonitorRuleParticipant");
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
                 app.submitButtonInstance = uConfSubmit;
                    
                }else{
                    errPage.removeError();
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.datanotfound'));
                }           
            }
        }
        
        private function submitUserConfResult(mapObj:Object):void{
        //var mapObj:Object = mkt.userConfResultEvent(event);
        if(mapObj!=null){    
            //XenosAlert.info("object status : "+mapObj["errorFlag"].toString());       
            if(mapObj["errorFlag"].toString() == "error"){
                XenosAlert.error(mapObj["errorMsg"].toString());
            }else if(mapObj["errorFlag"].toString() == "noError"){
                if(mode!="cancel")
                  errPage.clearError(super.getConfResultEvent());
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
               ruleBar.includeInLayout = true;
               ruleBar.visible =true;   
               app.submitButtonInstance = sConfSubmit;     
                
            }else{
                errPage.removeError();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.erroroccurred'));
            }           
        }
    }
    
       
        
        private function setValidator():void{
        
          var validateModel:Object={
                            appRoleEntry:{
                                 
                                 appRoleName:this.appRole.text,
                                 officeIdStr:officeId.selectedItem != null ? officeId.selectedItem : "",
                                 acRestrictionValue:this.acRestriction.selectedItem != null ? this.acRestriction.selectedItem.value : ""
                                        
                            }
                           }; 
             super._validator = new ApplicationRoleEntryValidator();
             super._validator.source = validateModel ;
             super._validator.property = "appRoleEntry";
        }
        
        
     //entry actions
        override public function preEntryInit():void{               
            var rndNo:Number= Math.random(); 
            super.getInitHttpService().url = "ref/applicationRoleDispatch.action?method=initialExecute&mode=entry&operation=entry&menuType=Y&rnd=" + rndNo;
        }
        override public function preEntryResultInit():Object{
            addCommonKeys(); 
            return keylist;
        }
        
        override public function postEntryResultInit(mapObj:Object): void{
            app.submitButtonInstance = submit;
            commonInit(mapObj);
            
        }
         override public function preEntry():void{
            setValidator();
            //XenosAlert.info("preEntry ");
            super.getSaveHttpService().url = "ref/applicationRoleDispatch.action?";  
            super.getSaveHttpService().request = populateRequestParams();
         }
         
        override public function preEntryResultHandler():Object
        {
             addCommonResultKeys();
             return keylist;
        }
        
        
        override public function postEntryResultHandler(mapObj:Object):void
        {
            commonResult(mapObj);
            uConfLabel.includeInLayout = true;
            uConfLabel.visible = true;
            uConfImg.includeInLayout = false;
            uConfImg.visible = false;
            usrCnfMessage.text =this.parentApplication.xResourceManager.getKeyValue('ref.applrole.label.entryuserconfirm');
        }
        
        private function commonResultPart(mapObj:Object):void {
            this.uConfAppRole.text = mapObj[keylist.getItemAt(0)].toString();
            this.uConfOffice.text = mapObj[keylist.getItemAt(1)].toString();
            this.uConfAcRest.text = mapObj[keylist.getItemAt(2)].toString();
            this.uConfRemarks.text = mapObj[keylist.getItemAt(3)].toString();
            this.uConfMenuDetails = (mapObj[keylist.getItemAt(4)] as ArrayCollection);
            this.uConfReportDetails = (mapObj[keylist.getItemAt(5)] as ArrayCollection);
            this.uConfExmDetails = (mapObj[keylist.getItemAt(6)] as ArrayCollection);
            remarkStr = this.uConfRemarks.text;

	        var index:int = 0;
	        for each(var item : Object in uConfExmDetails){
	            item['rowNum'] = index;
	            item['exmMonitorRule'] = item.groupPk.toString();          
	            item['exmAccessType'] = item.accessType.toString();          
	            index++;
	        }		
        }    
        
        override public function preEntryConfirm():void {
            var reqObj :Object = new Object();
            super.getConfHttpService().url = "ref/applicationRoleDispatch.action?";  
            reqObj.method= "doSave";
            super.getConfHttpService().request  =reqObj;
            actionBtnPanel.enabled =false;
        }
        
        
        override public function postConfirmEntryResultHandler(mapObj:Object):void
        {
            submitUserConfResult(mapObj);
            actionBtnPanel.enabled =true;
            uConfLabel.includeInLayout = true;
            uConfLabel.visible = true;
            uConfImg.includeInLayout =false;
            uConfImg.visible =false;
            usrCnfMessage.text =this.parentApplication.xResourceManager.getKeyValue('ref.applrole.label.entrysystemconfirm');
        }
        
    
        
       override public function preResetEntry():void
       {
          
                   var rndNo:Number= Math.random();
                    super.getResetHttpService().url = "ref/applicationRoleDispatch.action?method=resetPage&rnd=" + rndNo; 
       }
       
       override public function postResetEntry():void{
            (targetReportName.dataProvider as ArrayCollection).removeAll();
            this.menuDetails.removeAll();
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
                 this.uConfAppRole.text = "";
                 this.uConfOffice.text ="";
                 this.uConfAcRest.text = "";
                 this.uConfRemarks.text = "";
                 this.uConfMenuDetails.removeAll();
                 this.uConfReportDetails.removeAll();
                 this.exmDetails.removeAll();  
                
                 //hdbox1.selectedChild = this.qry;
                // this.currentState="entryState";
                 vstack.selectedChild = qry;    
                 super.postEntrySystemConfirm();
            
        }
    
    //amend actions
            override public function preAmendInit():void{     
                //initLabel.text = "Market Price Amend"         
                var rndNo:Number= Math.random(); 
                super.getInitHttpService().url = "ref/applicationRoleAmendDispatch.action?";
                var reqObject:Object = new Object();
                reqObject.rnd = rndNo;
                reqObject.method= "amendApplRole";
                reqObject.mode=this.mode;
                reqObject.operation=this.mode;
                reqObject.applRolePk = this.appRolePkStr;
                super.getInitHttpService().request = reqObject;
            }
          
          override public function postAmendInit():void{
            this.addMenuService.url="ref/applicationRoleAmendDispatch.action?";
            this.editMenuService.url="ref/applicationRoleAmendDispatch.action?";
            this.deleteMenuService.url="ref/applicationRoleAmendDispatch.action?";
            this.addReportService.url="ref/applicationRoleAmendDispatch.action?";
            this.deleteReportService.url="ref/applicationRoleAmendDispatch.action?";
          }
          
        override public function preAmendResultInit():Object{
            addCommonKeys(); 
            keylist.addItem("applicationRoleNameDisp");
            keylist.addItem("officeId");
            keylist.addItem("accountRestrictionExp");
            keylist.addItem("remarks");
            keylist.addItem("menuRoleParticipants.menuRoleParticipant");
            keylist.addItem("reportParticipants.reportParticipant");    
            keylist.addItem("exmMonitorRuleParticipants.exmMonitorRuleParticipant");    
            keylist.addItem("accountRestriction");    
            return keylist;
        }
            
        override public function postAmendResultInit(mapObj:Object): void{
            app.submitButtonInstance = submit;
            commonInit(mapObj);
            this.appRole.text = mapObj[keylist.getItemAt(7)].toString();
            this.officeId.selectedItem = mapObj[keylist.getItemAt(8)].toString();
            this.remarks.text = mapObj[keylist.getItemAt(10)] != null ? mapObj[keylist.getItemAt(10)].toString() : "";
                
            this.menuDetails = (mapObj[keylist.getItemAt(11)] as ArrayCollection);
            
                var index:int =0;
                for each(var item : Object in menuDetails){
                    item["rowNum"]=index;
                    item["btnVisible"] = true;                  
                    //BindingUtils.bindProperty(item,"btnVisible");
                    
                    index++;
                }
                
           for each(var reportItem:Object in (mapObj[keylist.getItemAt(12)] as ArrayCollection)){
                for each(item in (sourceReportName.dataProvider as ArrayCollection)){
                    if(XenosStringUtils.equals(item.value,reportItem.reportId)){
                       var selectedIndx:int = IList(sourceReportName.dataProvider).getItemIndex(item);
                       IList(targetReportName.dataProvider).addItem(item);
                       IList(sourceReportName.dataProvider).removeItemAt(selectedIndx);
                    }                   
                }
            }
            for each(item in (mapObj[keylist.getItemAt(13)] as ArrayCollection)) {
           	    exmDetails.addItem(item);
            }
                  
            index = 0;
	        for each(item in exmDetails){
	            item['rowNum'] = index;
	            item['exmMonitorRule'] = item.groupPk.toString();          
	            item['exmAccessType'] = item.accessType.toString();          
	            index++;
	        }
	        
            var initcol1:ArrayCollection= this.acRestriction.dataProvider as ArrayCollection;
            var indx:int = -1;
	        for each(item in initcol1){  
	            if(XenosStringUtils.equals(item.value, mapObj[keylist.getItemAt(14)].toString())){
	                indx = initcol1.getItemIndex(item);
	            }
	        }
	        this.acRestriction.selectedIndex  = (indx != -1 ? indx : 0);

            this.appRole.editable = false;
            this.appRole.enabled = false;
//          this.officeId.editable = false;
//          this.officeId.enabled = false;
//          this.acRestriction.editable = false;
//          this.acRestriction.enabled = false;
        }    
        
         override public function preAmend():void{
            setValidator();         
            super.getSaveHttpService().url = "ref/applicationRoleAmendDispatch.action?";  
            super.getSaveHttpService().request = populateRequestParams();
         } 
         
        override public function preAmendResultHandler():Object
        {
            addCommonResultKeys();
            return keylist;
        } 
        
        override public function postAmendResultHandler(mapObj:Object):void
        {
            commonResult(mapObj);
            this.parentDocument.title =this.parentApplication.xResourceManager.getKeyValue('ref.applrole.label.amenduserconfirm');
            ruleBar.includeInLayout = false;
            ruleBar.visible =true;
            app.submitButtonInstance = uConfSubmit;
        }
        override public function preAmendConfirm():void
        {
            var reqObj :Object = new Object();
            super.getConfHttpService().url = "ref/applicationRoleAmendDispatch.action?";  
            reqObj.method= "doSave";
            super.getConfHttpService().request  =reqObj;
            actionBtnPanel.enabled =false;
        }
        
        
        override public function postConfirmAmendResultHandler(mapObj:Object):void
        {
            submitUserConfResult(mapObj);
            actionBtnPanel.enabled =true;
            this.parentDocument.title =this.parentApplication.xResourceManager.getKeyValue('ref.applrole.label.amendsystemconfirm');
        }
        
       override public function preResetAmend():void
       {
          
                   var rndNo:Number= Math.random();
                    super.getResetHttpService().url = "ref/applicationRoleAmendDispatch.action?method=resetApplicationRoleAmend&rnd=" + rndNo; 
       }
       
            
        
        override public function doAmendSystemConfirm(e:Event):void
        {
            //this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
            this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
        }
        
        //cancel actions 
           
           override public function preCancelInit():void{               
                this.back.includeInLayout = false;
                this.back.visible = false;
                changeCurrentState();                           
                var rndNo:Number= Math.random(); 
                super.getInitHttpService().url = "ref/applicationRoleCancelDispatch.action?";
                var reqObject:Object = new Object();
                reqObject.rnd = rndNo;
                reqObject.method= "viewApplRole";
                reqObject.mode=this.mode;
                reqObject.operation=this.mode;
                reqObject.applRolePk = this.appRolePkStr;
                super.getInitHttpService().request = reqObject;
            }
        override public function preCancelResultInit():Object{
            addCommonResultKeys();  
            if(mode == "view"){
                keylist.addItem("appRegiDateStr");
                keylist.addItem("createdBy");
                keylist.addItem("appUpdDateStr");
                keylist.addItem("updatedBy");
                keylist.addItem("creationDateStr");
                keylist.addItem("updateDateStr");
            }           
            return keylist;
        }
        

       
        override public function postCancelResultInit(mapObj:Object): void{
                
            commonResultPart(mapObj);
            
            if(mode == "view"){
                uConfAppRegiDate.text = mapObj[keylist.getItemAt(7)].toString();
                uConfCreatedBy.text = mapObj[keylist.getItemAt(8)].toString();
                uConfAppUpdDate.text = mapObj[keylist.getItemAt(9)].toString();
                uConfUpdatedBy.text = mapObj[keylist.getItemAt(10)].toString();
                uConfCreationDate.text = mapObj[keylist.getItemAt(11)].toString();
                uConfUpdateDate.text = mapObj[keylist.getItemAt(12)].toString();
            }
            //uConfLabel.text="";   //Application Role Cancel Page
            uConfSubmit.includeInLayout = false;
            uConfSubmit.visible = false;
            cancelSubmit.visible = true;
            cancelSubmit.includeInLayout = true;
            app.submitButtonInstance = cancelSubmit;
        }
        
         
         
         override public function preCancel():void{
            //setValidator();
            super._validator = null;
            super.getSaveHttpService().url = "ref/applicationRoleCancelDispatch.action?"; 
             var reqObj:Object = new Object();
             reqObj.method="submitDelete";
             reqObj.mode=this.mode;
            super.getSaveHttpService().request  =reqObj;
         }
         
         
        override public function postCancelResultHandler(mapObj:Object):void
        {
            submitUserConfResult(mapObj);
            this.parentDocument.title = this.parentApplication.xResourceManager.getKeyValue('ref.applrole.label.cxluserconfirm');
            //userConfirmhb
            uConfLabel.includeInLayout = true;
            uConfLabel.visible = true;
            cancelSubmit.visible = false;
            cancelSubmit.includeInLayout = false;
            uCancelConfSubmit.visible = true;
            uCancelConfSubmit.includeInLayout = true;
            sConfSubmit.includeInLayout = false;
            sConfSubmit.visible = false;
            sConfLabel.includeInLayout = false;
            sConfLabel.visible = false;
            app.submitButtonInstance = uCancelConfSubmit;
        } 
        
        
        override public function preCancelConfirm():void
        {
            var reqObj :Object = new Object();
            super.getConfHttpService().url = "ref/applicationRoleCancelDispatch.action?";  
            reqObj.method= "commitDelete";
            super.getConfHttpService().request  =reqObj;
            actionBtnPanel.enabled =false;
        }
         
        override public function postConfirmCancelResultHandler(mapObj:Object):void
        {
            submitUserConfResult(mapObj);
            actionBtnPanel.enabled =true;
            this.parentDocument.title =this.parentApplication.xResourceManager.getKeyValue('ref.applrole.label.cxlsystemconfirm');
            cancelSubmit.visible = false;
            cancelSubmit.includeInLayout = false;
            uCancelConfSubmit.visible = false;
            uCancelConfSubmit.includeInLayout = false;
            uConfLabel.includeInLayout = false;
            uConfLabel.visible = false;
        }
    override public function doCancelSystemConfirm(e:Event):void
    {
        //this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    }

    private function addExmMonitorRule():void {
        var exmRule:Object = new Object();
        var valMsg:String = '';
        for each(var item:Object in this.exmRuleName.selectedItems) {
            if (item.value == '' || item.value == ' ') {
                valMsg = valMsg + 'Please select an exception monitor rule.\n';
                break;
            }
        }
        if (exmAccessType.text == 'Select' || exmAccessType.text == ' ' || exmAccessType.text == '') {
            valMsg = valMsg + 'Please select an access type.';
        }
        if (valMsg != '') {
            XenosAlert.info(valMsg);            
        } else {
            exmRule['exmAccessType'] = exmAccessType.text;
            var groupPkArr:Array = new Array();
	        for each(item in this.exmRuleName.selectedItems) {
	            for (var i:int = 0; i < this.exmDetails.length; i++) {
	            	var item1:Object = exmDetails[i];
                    if (XenosStringUtils.equals(item.value, item1.groupPk) &&
                            XenosStringUtils.equals(exmRule['exmAccessType'].toString(),item1.accessType)) {
                        if (!(this.editIndex != -1 && (XenosStringUtils.equals(this.groupPkStrForEdit, item1.groupPk)))) {
	                        XenosAlert.info('Exception Monitor Rule / Access Type [ ' +
	                            item1.exmMonitorRuleName + ' / ' + item1.accessType + ' ] already exists.');
	                        return;
                        }
                    }
	            }
                exmRule['exmMonitorRule'] = item.value;
                exmRule['exmMonitorRuleName'] = item.label;    
                groupPkArr.push(item.value);           
	        }
            
            exmAccessType.text = '';   
            this.exmRuleName.selectedIndex = 0;

            if (mode == 'amend') {
                addExmMonitorRuleService.url = "ref/applicationRoleAmendDispatch.action?";
            }
	        var requstObj:Object = new Object();
	        requstObj.exmMonitorRuleName = exmRule.exmMonitorRuleName;
            requstObj.groupPkStrArr = groupPkArr;
	        requstObj.accessType = exmRule.exmAccessType;
	        requstObj.editExmRuleIndexNumber = editIndex;
	        requstObj.method= "addExmMonitorRule";
            addExmMonitorRuleService.request = requstObj;
            addExmMonitorRuleService.send();  
            groupPkStrForEdit = '';
        }        
    }   
         
    public function addExmMonitorRuleResultHandler(event:ResultEvent):void{
        exmGridCount.enabled = true;
        
        var resultObj:XML = XML(event.result);
        this.exmDetails.removeAll();
        this.exmRuleName.selectedIndex = 0;
        this.exmAccessType.selectedIndex = 0;
        for each (var result:XML in resultObj.exmMonitorRuleParticipants.exmMonitorRuleParticipant){
            this.exmDetails.addItem(result);
        }
        var index:int = 0;
        for each(var item : Object in exmDetails){
            item['rowNum'] = index;
            item['exmMonitorRule'] = item.groupPk.toString();          
            item['exmAccessType'] = item.accessType.toString();          
            index++;
        }
        this.editIndex = -1;
    }

    public function editExmMonitorRuleResultHandler(event:ResultEvent):void{
        var resultObj:XML = XML(event.result);
        var initcol:ArrayCollection=new ArrayCollection();
        var indx:int = -1;
        
        initcol = this.exmRuleName.dataProvider as ArrayCollection;
        for (var i:int = 0; i < initcol.length; i++) {
        	var item:Object = initcol[i]; 
            if(XenosStringUtils.equals(item.value, resultObj.groupPkStr)){
                indx = initcol.getItemIndex(item);
            }
        }
        this.exmRuleName.selectedIndex = indx != -1 ? indx : 0;
        
        this.exmAccessType.text = resultObj.accessType.toString();
        exmGridCount.enabled = false;
        this.editIndex = resultObj.editExmRuleIndexNumber;
        this.groupPkStrForEdit = resultObj.groupPkStr;
    }
    
    public function handleEditExmRule(data:Object):void{
        var reqObj:Object = new Object();
        reqObj.method="editExmMonitorRule";
        reqObj.editExmRuleIndexNumber = data.rowNum;
        if (mode == 'amend') {
            editExmMonitorRuleService.url = "ref/applicationRoleAmendDispatch.action?";
        }
        editExmMonitorRuleService.request = reqObj;
        editExmMonitorRuleService.send();
        
        exmDetails.refresh();       
    }
    
    public function handleDeleteExmRule(data:Object):void{
        
        var reqObj:Object = new Object();
        reqObj.method="deleteExmMonitorRule";
        reqObj.editExmRuleIndexNumber = data.rowNum;
        if (mode == 'amend') {
            deleteExmMonitorRuleService.url = "ref/applicationRoleAmendDispatch.action?";
        }
        deleteExmMonitorRuleService.request = reqObj;
        deleteExmMonitorRuleService.send();
        
        exmDetails.refresh();                                          
    }    