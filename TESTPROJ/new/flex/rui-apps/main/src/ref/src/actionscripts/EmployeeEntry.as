import com.nri.rui.core.Globals;
import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.controls.XenosEntry;
import com.nri.rui.core.startup.XenosApplication;
import com.nri.rui.ref.validators.EmployeeEntryValidator;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.core.utils.HiddenObject;
import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.events.CloseEvent;
import mx.events.ResourceEvent;
import mx.resources.ResourceBundle;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;
            
      
     
     [Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
     [Bindable]private var mode : String = "entry";
     [Bindable]private var employeePkStr : String = "";
     [Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
     [Bindable]
     private var rs:XML = new XML();
     private var recNo : int = 0;
     private var recNoAcc : int = 0;
     private var tempAccNo : String = "";
     [Bindable]public var empApplRoleList :ArrayCollection = new ArrayCollection();
     [Bindable]public var accAccessList :ArrayCollection = new ArrayCollection(); 
     private var keylist:ArrayCollection = new ArrayCollection();
      
     private var passwdVal : String = "";
     private var restrictPermission : String = "Y";
     
     [Bindable]
     private var tempMode:String;
      
     private function changeCurrentState():void{
         //currentState = "result";
         vstack.selectedChild = rslt;
     }
     
     public function callme() : void {
        //XenosAlert.info("calling the delete button");
     }
     
    
     
     public function addApplRoleNames() : void {
         var selectedAppRole : Array;
         var reqObj : Object = new Object();
         //populated office id
         if(String(StringUtil.trim(this.officeId.text)).length != 0)
             reqObj.officeId=this.officeId.selectedItem;
         //populate selected app role
         selectedAppRole = new Array(appRolesList.selectedItems.length);
         for( var i : int =0;i<appRolesList.selectedItems.length;i++)
             selectedAppRole[i]= appRolesList.selectedItems[i].value;
             reqObj.selectedApplRoles=selectedAppRole;
             appRoleNamehttp.request = reqObj;
             if(this.mode=="amend"){
                appRoleNamehttp.url= "ref/employeeAmendDispatch.action?method=addApplRoleNames";
             }
             appRoleNamehttp.send();
     }
     
     /*public function addAccountAccessInfo() : void {
     	accInfListContainer.enabled = true ;
     	var reqObjAccInf : Object = new Object();
     	//var sRole:String = this.salesRoleList.selectedItem.value;
     	//XenosAlert.info("sRole::"+sRole);
     	//populate sales role
     	if (this.salesRoleList.selectedItem != null){
     		reqObjAccInf.salesRole = this.salesRoleList.selectedItem.value ;
     		
     		//populate account
	     	if(!XenosStringUtils.isBlank(this.actPopUp.accountNo.text)){
	     		reqObjAccInf.accountNo = this.actPopUp.accountNo.text ;
	     		
	     		appAccountInfhttp.request = reqObjAccInf ;
	     		
	     		if(mode == "amend"){
                	appAccountInfhttp.url= "ref/employeeAmendDispatch.action?method=addAccountAccessInfo";
              }
              var index:int =0;
              for each(var item : Object in accAccessList){
              	if(item.accountNo == this.tempAccNo){
              		reqObjAccInf.editDeleteIndexEmpAccountAccessInfo = index ;
              	}
              	index ++ ;
              }
              
              appAccountInfhttp.send();
	     	}
	     	else
	     		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.employee.msg.error.mandatory.accno'));
     	}
     	else
     		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.employee.msg.error.mandatory.salesrole'));
     		
     	
     }*/
     private function displayEmpApplicationRole(event: ResultEvent): void{
        
        rs = XML(event.result);
        
        if (null != event) {
            if(rs.child("empApplnRoleParticipantList").length()>0) {
                recNo = 0;
                errPage.clearError(event);
                empApplRoleList.removeAll();
                try {
                    for each ( var rec:XML in rs.empApplnRoleParticipantList.empApplnRoleParticipantPage) {
                        //to keep track of the index number to be deleted
                        rec.selectedIndex = recNo++;
                        empApplRoleList.addItem(rec);
                    }
                    empApplRoleList.refresh();
                }catch(e:Error){
                    //XenosAlert.error(e.toString() + e.message);
                    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                }
            }else if(rs.child("Errors").length()>0) {
                //some error found
                var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list              
                for each ( var error:XML in rs.Errors.error ) {
                    errorInfoList.addItem(error.toString());
                }
                errPage.showError(errorInfoList);//Display the error
            }
        }
    }  
     
  /* private function displayAccountAccessInf(event: ResultEvent): void{
   
   rs = XML(event.result);
        
        if (null != event) {
            if(rs.child("empAccountAccessInfList").length()>0) {
                recNoAcc = 0;
                errPage.clearError(event);
                accAccessList.removeAll();
                try {
                    for each ( var rec:XML in rs.empAccountAccessInfList.empAccountAccessInfList) {
                        //to keep track of the index number to be deleted
                        //rec.selectedIndex = recNoAcc++;
                        accAccessList.addItem(rec);
                    }
                    accAccessList.refresh();
                    
                    if (!XenosStringUtils.isBlank(rs.accountNo.toString())){
                    	this.actPopUp.accountNo.text= rs.accountNo ;
                    	this.tempAccNo = rs.accountNo ;
                    }else
                    	this.actPopUp.accountNo.text= "" ;
                    
                    if (!XenosStringUtils.isBlank(rs.salesRole.toString())){
                    	
                    	var tempSalesRList : ArrayCollection = salesRoleList.dataProvider as ArrayCollection;
                    	for(var i:int=0; i<tempSalesRList.length; i++){
							if(tempSalesRList.getItemAt(i).label == rs.salesRole.toString()){
								salesRoleList.selectedIndex = i;
							}
						}
                    }else
                    	salesRoleList.selectedIndex = 0 ;
                    
                }catch(e:Error){
                    //XenosAlert.error(e.toString() + e.message);
                    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                }
            }else if(rs.child("Errors").length()>0) {
                //some error found
                var errorInfoListAcc : ArrayCollection = new ArrayCollection();
                //populate the error info list              
                for each ( var error:XML in rs.Errors.error ) {
                    errorInfoListAcc.addItem(error.toString());
                }
                errPage.showError(errorInfoListAcc);//Display the error
            }
        }
   }*/
    private function doBack():void{
        vstack.selectedChild = qry;    
        app.submitButtonInstance = submit;
	  } 
    public function loadAll():void{
        parseUrlString();
        addColumn();
        super.setXenosEntryControl(new XenosEntry());
        //XenosAlert.info("mode : "+mode);
        if(this.mode == 'entry'){
        	tempMode = "Entry";
            this.dispatchEvent(new Event('entryInit'));
            vstack.selectedChild = qry;
        }else if(this.mode == 'amend'){
        	tempMode = "Amend";
            this.dispatchEvent(new Event('amendEntryInit'));
            vstack.selectedChild = qry;
        }else if(this.mode=='cancel'){ 
        	tempMode = "Cancel";
            this.dispatchEvent(new Event('cancelEntryInit'));
        }else if(this.mode=='reopen'){ 
        	tempMode = "Reopen";
            this.dispatchEvent(new Event('reopenEntryInit'));
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
                    }else if(tempA[0] == "employeePk"){
                        this.employeePkStr = tempA[1];
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
        var rndNo:Number= Math.random(); 
        super.getInitHttpService().url = "ref/employeeDispatch.action?method=initialExecute&&mode=entry&menuType=Y&rnd=" + rndNo;
    }
    
    override public function preAmendInit():void{     
        initLabel.text = "Employee Amend"       
        super.getInitHttpService().url = "ref/employeeAmendDispatch.action?";
        var reqObject:Object = new Object();
        reqObject.method= "doView";
        reqObject.actionType = "edit";
        reqObject.employeePk = this.employeePkStr;
        super.getInitHttpService().request = reqObject;
        //super.getInitHttpService().method =  "POST";
    }
    
    override public function preCancelInit():void{        
    
        this.back.includeInLayout = false;
        this.back.visible = false;
        changeCurrentState();                           
        var rndNo:Number= Math.random(); 
        super.getInitHttpService().url = "ref/employeeCancelDispatch.action?";
        var reqObject:Object = new Object();
        reqObject.rnd = rndNo;
        reqObject.method= "doView";
        //reqObject.mode=this.mode;
        reqObject.actionType = "delete";
        reqObject.employeePk = this.employeePkStr;
        super.getInitHttpService().request = reqObject;
        
    }
    
    override public function preReopenInit():void{        
    
        this.back.includeInLayout = false;
        this.back.visible = false;
        changeCurrentState();                           
        var rndNo:Number= Math.random(); 
        super.getInitHttpService().url = "ref/employeeReopenDispatch.action?";
        var reqObject:Object = new Object();
        reqObject.rnd = rndNo;
        reqObject.method= "doView";
        //reqObject.mode=this.mode;
        reqObject.actionType = "REOPEN";
        reqObject.employeePk = this.employeePkStr;
        super.getInitHttpService().request = reqObject;
        
    }
    
    private function addCommonKeys():void{          
        keylist = new ArrayCollection();
        keylist.addItem("emppage.defaultOfficeStr");
        keylist.addItem("emppage.startDateStr");
        keylist.addItem("emppage.employeeOpenDateStr");
        keylist.addItem("emppage.employeeOpenedBy");
        keylist.addItem("officeList.officeList");
        keylist.addItem("empApplnRoleParticipantList.empApplnRoleParticipantPage");
		keylist.addItem("salesRoleListColl.item");
		keylist.addItem("empAccountAccessInfList.empAccountAccessInfList");       
       /*
        keylist.addItem("baseDate");
        keylist.addItem("dataSource");
        keylist.addItem("dataSourceList.item");
        keylist.addItem("inputPriceFormatList.item");
        keylist.addItem("priceTypeList.item");  
        */
    }
    
    override public function preEntryResultInit():Object{
        addCommonKeys(); 
        return keylist;
    }
        
    override public function preAmendResultInit():Object{
        addCommonKeys(); 
    
        keylist.addItem("emppage.userId");
        
        keylist.addItem("emppage.firstName");
        keylist.addItem("emppage.lastName");
        keylist.addItem("emppage.title");
        keylist.addItem("emppage.middleInitial");
        keylist.addItem("emppage.applPasswd");
        keylist.addItem("emppage.locked");
        
        keylist.addItem("emppage.restrictedPermission");
        
        return keylist;
    }
    
    override public function preCancelResultInit():Object{
        addCommonResultKes();  
        keylist.addItem("empApplnRoleParticipantList.empApplnRoleParticipantPage");
        keylist.addItem("empAccountAccessInfList.empAccountAccessInfList");
        //keylist.addItem("historyReasonCodeList.item");        
        return keylist;
    }
    override public function preReopenResultInit():Object{
        addCommonResultKes();                
        keylist.addItem("empApplnRoleParticipantList.empApplnRoleParticipantPage");
        keylist.addItem("empAccountAccessInfList.empAccountAccessInfList");
        //keylist.addItem("historyReasonCodeList.item");        
        return keylist;
    }
    
    /**
     * 
     * @return The Key List for cancelResultHandler
     * 
     */
    override public function preCancelResultHandler():Object{
        addCommonResultKes();   
        keylist.addItem("historyReasonCodeList.item");  
        
        return keylist;
    }
    
     /**
      *  
      * @return The key List for reopenResultHandler
      * 
      */
     override public function preReopenResultHandler():Object{
        addCommonResultKes();   
        keylist.addItem("historyReasonCodeList.item");  
        return keylist;
    }
    
    
    
    
    /**
    * This method sets the Application Roles for the corresponding Office Id
    * in Employee Entry Page.
    */
    private function setApplicationRoles() : void { 
        if(String(StringUtil.trim(this.officeId.text)).length != 0) {
            var reqObj : Object = new Object();
            reqObj.officeId=this.officeId.text;
            if(this.mode =="amend"){
                initializeApplicationRoles.url="ref/employeeAmendDispatch.action?method=loadApplRoleNames";
            }else{
            initializeApplicationRoles.url="ref/employeeDispatch.action?method=loadApplRoleNames";
            }
            initializeApplicationRoles.send(reqObj);
            
        } else {
            var tempColl: ArrayCollection = new ArrayCollection();
            tempColl.addItem({label:" ", value: " "});
            appRolesList.dataProvider=tempColl;
        }           
    }
    
    private function populateApplicationRoles(event: ResultEvent): void{
        var i:int = 0;
        var initColl:ArrayCollection = new ArrayCollection();
        var tempColl: ArrayCollection = new ArrayCollection();
        
        if(event.result.employeeActionForm.applRoleNames.item!=null){
            tempColl.addItem({label:" ", value: " "});
            if(event.result.employeeActionForm.applRoleNames.item is ArrayCollection)
                initColl = event.result.employeeActionForm.applRoleNames.item as ArrayCollection;
            else
                initColl.addItem(event.result.employeeActionForm.applRoleNames.item);   
             for(i=0;i<initColl.length;i++)
                tempColl.addItem(initColl.getItemAt(i));
             appRolesList.dataProvider=tempColl; 
            
        }else {
            XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.employee.msg.error.load.applrolelist'));
        } 
    }
        
    private function commonInit(mapObj:Object):void{
        
        var initcol:ArrayCollection = new ArrayCollection();
        
        this.userId.text="";
        this.firstName.text="";
        this.middleName.text="";
        this.lastName.text="";
        this.title.text="";
        this.passwd.text="";
        this.rePasswd.text="";
        //this.actPopUp.accountNo.text="";
        //accInfListContainer.enabled = true ;
        
        errPage.clearError(super.getInitResultEvent());
        
        //Setting the value of Default Office 
        if(mapObj[keylist.getItemAt(0)]!=null){
            this.defaultOffice.text=mapObj[keylist.getItemAt(0)];       
        }
        //Setting the value of Start Date
        if(mapObj[keylist.getItemAt(1)]!=null){
            this.startDate.text=mapObj[keylist.getItemAt(1)];       
        }
        //Setting the value of Employee Open Date
        if(mapObj[keylist.getItemAt(2)]!=null){
            this.empOpenDate.text=mapObj[keylist.getItemAt(2)];         
        }
        //Setting the value of Employee Opened By
        if(mapObj[keylist.getItemAt(3)]!=null){
            this.empOpenedBy.text=mapObj[keylist.getItemAt(3)];         
        }
        
        
        //var index:int=-1;
        
        //Setting values of Office Id
        initcol=new ArrayCollection();
        initcol.addItem(" ");
        for each(var item:Object in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
            initcol.addItem(item);
        }
        officeId.dataProvider = initcol;
        
        //setting emp appl roles
        this.empApplRoleList.removeAll();
        recNo = 0;
        for each(var itemRole:Object in (mapObj[keylist.getItemAt(5)] as ArrayCollection)){
            itemRole.selectedIndex = recNo++;
            this.empApplRoleList.addItem(itemRole);
        }
        this.empApplRoleList.refresh();
        //sutanu
        
        //setting sales role
       /* var initcoll:ArrayCollection = new ArrayCollection();
        	
		for each(var itemSL:Object in (mapObj[keylist.getItemAt(6)] as ArrayCollection)){
            initcoll.addItem(itemSL);
        }
        var i:int = 0;
        var tempColl: ArrayCollection = new ArrayCollection();
        tempColl.addItem({label:" ", value: " "});
        for(i = 0; i<initcoll.length; i++) {
            tempColl.addItem(initcoll[i]);    
        
        }
        salesRoleList.dataProvider = tempColl;
       
        this.accAccessList.removeAll();
//        recNo = 0;
        for each(var itemAccount:Object in (mapObj[keylist.getItemAt(7)] as ArrayCollection)){
            //itemAccount.selectedIndex = recNo++;
            this.accAccessList.addItem(itemAccount);
        }
        this.accAccessList.refresh();*/
    }
        
    override public function postEntryResultInit(mapObj:Object): void{
        commonInit(mapObj);
    }
    
    override public function postAmendResultInit(mapObj:Object): void{
        commonInit(mapObj);
        //Setting the value of Employee ID
        if(mapObj[keylist.getItemAt(6)]!=null){
            this.userId.text=mapObj[keylist.getItemAt(8)];          
        }
        this.firstName.text=mapObj[keylist.getItemAt(9)].toString();
        this.lastName.text=mapObj[keylist.getItemAt(10)].toString();
        this.title.text=mapObj[keylist.getItemAt(11)].toString();
        this.middleName.text=mapObj[keylist.getItemAt(12)].toString();
        
        this.passwdVal = mapObj[keylist.getItemAt(13)].toString();
        if(mapObj[keylist.getItemAt(14)].toString() == "Y"){
            this.lockedCh.selected = true ;
        }else{
            this.lockedCh.selected  = false ;
        }
        
        this.gridLocked.visible = true;
        this.gridLocked.includeInLayout = true;
        
        this.userId.editable = false;
        this.userId.enabled = false;
        this.startDate.editable = false;
        this.startDate.enabled = false;
        this.startDate.dropdown.visible=false;
    
        
        if(mapObj[keylist.getItemAt(15)]!=null){
            restrictPermission = mapObj[keylist.getItemAt(15)].toString();          
        }
        if(restrictPermission != "Y"){
            this.firstName.editable = false;
            this.firstName.enabled = false;
            this.middleName.editable = false;
            this.middleName.enabled = false;
            this.lastName.editable = false;
            this.lastName.enabled = false;
            this.title.editable = false;
            this.title.enabled = false;
            this.passwd.editable=false;
            this.passwd.enabled=false;
            this.rePasswd.editable=false;
            this.rePasswd.enabled=false;
            this.lockedCh.enabled = false;
        }
    
    }
    
    private function addCommonResultKes():void{
        keylist = new ArrayCollection();
        
        keylist.addItem("emppage.defaultOfficeStr");
        keylist.addItem("emppage.userId");
        keylist.addItem("emppage.firstName");
        keylist.addItem("emppage.middleInitial");
        keylist.addItem("emppage.lastName");
        keylist.addItem("emppage.title");
        keylist.addItem("emppage.startDateStr");
        keylist.addItem("emppage.employeeOpenDateStr");
        keylist.addItem("emppage.employeeOpenedBy");
        keylist.addItem("emppage.applPasswd");
        keylist.addItem("emppage.confirmPassword");
        keylist.addItem("emppage.locked");
        
    }
    private function commonResultPart(mapObj:Object):void{
        
        //XenosAlert.info("Common Result Part:"+mapObj[keylist.getItemAt(0)].toString());
        this.uConDefaultOffice.text=mapObj[keylist.getItemAt(0)].toString();
        this.uConUserId.text=mapObj[keylist.getItemAt(1)].toString();
        this.uConFirstName.text=mapObj[keylist.getItemAt(2)].toString();
        this.uConMiddleName.text=mapObj[keylist.getItemAt(3)].toString();
        this.uConLastName.text=mapObj[keylist.getItemAt(4)].toString();
        this.uConTitle.text=mapObj[keylist.getItemAt(5)].toString();
        this.uConStartDate.text=mapObj[keylist.getItemAt(6)].toString();
        this.uConEmpOpenDate.text=mapObj[keylist.getItemAt(7)].toString();
        this.uConEmpOpenedBy.text=mapObj[keylist.getItemAt(8)].toString();
        this.uConPasswd.text=mapObj[keylist.getItemAt(9)].toString();
        this.uConRePasswd.text=mapObj[keylist.getItemAt(10)].toString();
        if(this.mode == "amend"){
            this.uConGridUserPass.visible =false;
            this.uConGridUserPass.includeInLayout =false;
            this.uConGridLocked.visible = true;
            this.uConGridLocked.includeInLayout = true;
            this.uConEmpLocked.text = mapObj[keylist.getItemAt(11)];
        }
        if(this.mode == "cancel" || this.mode=="reopen"){
            this.uConGridUserPass.visible =false;
            this.uConGridUserPass.includeInLayout =false;
            this.uConGridLocked.visible = true;
            this.uConGridLocked.includeInLayout = true;
            this.uConEmpLocked.text = mapObj[keylist.getItemAt(11)];
        }
        
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
    // Setting The Validatior 
    private function setValidator():void{
        var validateModel:Object={
            employeeEntry:{
                userId:this.userId.text,
                firstName:this.firstName.text,
                lastName:this.lastName.text,
                startDate:this.startDate.text,
                passwd:this.passwd.text,
                rePasswd:this.rePasswd.text,
                restrictPermission:this.restrictPermission,
                mode:this.mode
            }
        };
        super._validator = new EmployeeEntryValidator();
        super._validator.source = validateModel ;
        super._validator.property = "employeeEntry";
    }
        
    
    
    override public function preEntry():void{
        setValidator();
        //XenosAlert.info("preEntry ");
        super.getSaveHttpService().url = "ref/employeeDispatch.action?";  
        super.getSaveHttpService().request  =populateRequestParams();
    }
     
    override public function preAmend():void{
        setValidator();
        super.getSaveHttpService().url = "ref/employeeAmendDispatch.action?";  
        super.getSaveHttpService().request = populateRequestParams();
    } 
    override public function preCancel():void{
        try {
            //XenosAlert.info("Start preCancel");
            var reqObj :Object = new Object();
            super.getSaveHttpService().url = "ref/employeeCancelDispatch.action?";  
            reqObj.method= "submitDelete";
            super.getSaveHttpService().request  =reqObj;
            //XenosAlert.info("End preCancel");
        }catch(e:Error){
                XenosAlert.error(e.message);
        }
    }
    
    override public function preReopen():void{
        try {
            //XenosAlert.info("Start preReopen");
            var rndNo:Number= Math.random();
            var reqObj :Object = new Object();
            super.getSaveHttpService().url = "ref/employeeReopenDispatch.action?&rnd="+rndNo;
            reqObj.method= "submitEmployeeReopen";
            super.getSaveHttpService().request  =reqObj;
            //XenosAlert.info("End preReopen");
        }catch(e:Error){
                XenosAlert.error(e.message);
        }
    }
    
    override public function preEntryResultHandler():Object{
        addCommonResultKes();
        return keylist;
    }
    
    override public function preAmendResultHandler():Object{
        addCommonResultKes();
        return keylist;
    } 
        
    override public function postCancelResultHandler(mapObj:Object):void{
        
        var initcol:ArrayCollection = new ArrayCollection();
        commonResultPart(mapObj);
        
        //Setting values of Close  Reasion 
        initcol=new ArrayCollection();
        //initcol.addItem({label:" ", value: " "});
        for each(var item:Object in (mapObj[keylist.getItemAt(12)] as ArrayCollection)){
            initcol.addItem(item);
        }
        uhistoryReasion.dataProvider = initcol;
        
        uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('ref.employee.label.userconfirmation')+tempMode;
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
        this.uCloseReasion.visible = true;
        this.uCloseReasion.includeInLayout = true;
        this.uReasonText.text=this.parentApplication.xResourceManager.getKeyValue('ref.employee.label.cancelreasoncode');
    } 
    
    /**
     * 
     * @param mapObj 
     * 
     */
    override public function postReopenResultHandler(mapObj:Object):void{
        
        var initcol:ArrayCollection = new ArrayCollection();
        commonResultPart(mapObj);
        
        //Setting values of Close  Reasion 
       initcol=new ArrayCollection();
        //initcol.addItem({label:" ", value: " "});
        for each(var item:Object in (mapObj[keylist.getItemAt(12)] as ArrayCollection)){
            initcol.addItem(item);
        }
        uhistoryReasion.dataProvider = initcol;
        
        uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('ref.employee.label.userconfirmation')+tempMode;
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
        this.uCloseReasion.visible = true;
        this.uCloseReasion.includeInLayout = true;
        this.uReasonText.text=this.parentApplication.xResourceManager.getKeyValue('ref.employee.label.reopenreasoncode');
    } 
    
    override public function postEntryResultHandler(mapObj:Object):void{
        commonResult(mapObj);
    }
    
    override public function postAmendResultHandler(mapObj:Object):void{
        commonResult(mapObj);
    }
    override public function preEntryConfirm():void{
        var rndNo:Number;
        rndNo= Math.random();
        var reqObj :Object = new Object();
        reqObj.rnd = rndNo;
        super.getConfHttpService().url = "ref/employeeDispatch.action?";  
        reqObj.method= "doSave";
        super.getConfHttpService().request  =reqObj;
    }
    override public function preAmendConfirm():void{
        var reqObj :Object = new Object();
        super.getConfHttpService().url = "ref/employeeAmendDispatch.action?";  
        reqObj.method= "doSave";
        super.getConfHttpService().request  =reqObj;
        super.getConfHttpService().method = "POST";
    }
    
     // Setting The Validatior 
    private function setReasionValidator():void{
        //XenosAlert.info("Inside Reasin Validator"+this.uhistoryReasion.selectedItem.value+this.mode);
        var validateModel:Object={
            cancelReasion:{
                uhistoryReasion:this.uhistoryReasion.selectedItem !=null ? this.uhistoryReasion.selectedItem.value :"",
                mode:this.mode
            }
        };
        super._validator = new EmployeeEntryValidator();
        super._validator.source = validateModel ;
        super._validator.property = "cancelReasion";
    }
    
    
    override public function preCancelConfirm():void{
        try {
            //XenosAlert.info("Start preCancelConfirm");
            //setReasionValidator();
            var reqObj :Object = new Object();
            super.getConfHttpService().url = "ref/employeeCancelDispatch.action?";  
            reqObj.method= "doSave";
            reqObj.historyReasonPk=(this.uhistoryReasion.selectedItem!=null)? this.uhistoryReasion.selectedItem.value:"";
            reqObj.historyRemarks=this.uRemarks;
            super.getConfHttpService().request  =reqObj;
            //XenosAlert.info("End preCancelConfirm");
        }catch(e:Error){
                XenosAlert.error(e.message);
        }
       
    }
    
    
    override public function preReopenConfirm():void{
        try {
            
            var reqObj :Object = new Object();
            var rndNo:Number= Math.random();
            super.getConfHttpService().url = "ref/employeeReopenDispatch.action?&rnd="+rndNo;  
            reqObj.method= "confirmEmployeeReopen";
            reqObj.historyReasonPk=(this.uhistoryReasion.selectedItem!=null)? this.uhistoryReasion.selectedItem.value:"";
            reqObj.historyRemarks=this.uRemarks;
            super.getConfHttpService().request  =reqObj;
            
        }catch(e:Error){
                XenosAlert.error(e.message);
        }
       
    }
    override public function postCancelConfirm() :void{
        //XenosAlert.info("postCancelConfirm");
    }
    override public function postConfirmEntryResultHandler(mapObj:Object):void{
        submitUserConfResult(mapObj);
    }
    override public function postConfirmAmendResultHandler(mapObj:Object):void{
        submitUserConfResult(mapObj);
    }
    
     override public function postCancelResultInit(mapObj:Object): void{
        //XenosAlert.info("Post Cancel Result Init");
        var initcol:ArrayCollection = new ArrayCollection();
        
        commonResultPart(mapObj);
        
        //Setting values of Close  Reasion 
       
        //initcol=new ArrayCollection();
        //initcol.addItem({label:" ", value: " "});
        //for each(var item:Object in (mapObj[keylist.getItemAt(12)] as ArrayCollection)){
            //initcol.addItem(item);
        //}
        //uhistoryReasion.dataProvider = initcol;
        
        //setting emp appl roles
        this.empApplRoleList.removeAll();
        recNo = 0;
        for each(var itemRole:Object in (mapObj[keylist.getItemAt(12)] as ArrayCollection)){
            itemRole.selectedIndex = recNo++;
            this.empApplRoleList.addItem(itemRole);
        }
        this.empApplRoleList.refresh();
        
        this.accAccessList=mapObj['empAccountAccessInfList.empAccountAccessInfList'] as ArrayCollection;
        this.accAccessList.refresh();
        
        uConfLabel.text=this.parentApplication.xResourceManager.getKeyValue('ref.employee.title.cancel');
        uConfSubmit.includeInLayout = false;
        uConfSubmit.visible = false;
        cancelSubmit.visible = true;
        cancelSubmit.includeInLayout = true;
        //this.uCloseReasion.visible = true;
        //this.uCloseReasion.includeInLayout = true;
        
    }
    
    override public function postReopenResultInit(mapObj:Object): void{
        //XenosAlert.info("postReopenResultInit");
        var initcol:ArrayCollection = new ArrayCollection();
        
        commonResultPart(mapObj);
        
        //Setting values of Close  Reasion 
       
        //initcol=new ArrayCollection();
        //initcol.addItem({label:" ", value: " "});
        //for each(var item:Object in (mapObj[keylist.getItemAt(12)] as ArrayCollection)){
            //initcol.addItem(item);
        //}
        //uhistoryReasion.dataProvider = initcol;
        
        //setting emp appl roles
        this.empApplRoleList.removeAll();
        recNo = 0;
        for each(var itemRole:Object in (mapObj[keylist.getItemAt(12)] as ArrayCollection)){
            itemRole.selectedIndex = recNo++;
            this.empApplRoleList.addItem(itemRole);
        }
        this.empApplRoleList.refresh();
        //setting up account access information
        this.accAccessList.removeAll();
        
       /*  for each(var itemRoleAcc:Object in (mapObj['empAccountAccessInfList.empAccountAccessInfList'] as ArrayCollection)){
        	
            this.accAccessList.addItem(itemRoleAcc);
        } */
        this.accAccessList=mapObj['empAccountAccessInfList.empAccountAccessInfList'] as ArrayCollection;
        this.accAccessList.refresh();
        
        uConfLabel.text=this.parentApplication.xResourceManager.getKeyValue('ref.employee.title.reopen');
        uConfSubmit.includeInLayout = false;
        uConfSubmit.visible = false;
        cancelSubmit.visible = true;
        cancelSubmit.includeInLayout = true;
        //this.uCloseReasion.visible = true;
        //this.uCloseReasion.includeInLayout = true;
        
    }
        
    
    override public function postConfirmCancelResultHandler(mapObj:Object):void{
        submitUserConfResult(mapObj);
        cancelSubmit.visible = false;
        cancelSubmit.includeInLayout = false;
        uCancelConfSubmit.visible = false;
        uCancelConfSubmit.includeInLayout = false;
        uConfLabel.includeInLayout = false;
        uConfLabel.visible = false;
        this.uCloseReasion.visible = false;
        this.uCloseReasion.includeInLayout = false;
    }
        
    override public function postConfirmReopenResultHandler(mapObj:Object):void{
        submitUserConfResult(mapObj);
        cancelSubmit.visible = false;
        cancelSubmit.includeInLayout = false;
        uCancelConfSubmit.visible = false;
        uCancelConfSubmit.includeInLayout = false;
        uConfLabel.includeInLayout = false;
        uConfLabel.visible = false;
        this.uCloseReasion.visible = false;
        this.uCloseReasion.includeInLayout = false;
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
                sysConfMessage.includeInLayout=true;   
         		sysConfMessage.visible=true;  
            }else{
                errPage.removeError();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.erroroccurred'));
            }           
        }
        
    }
    
    /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateRequestParams():Object {
        
        
        var reqObj : Object=new Object;
        
        reqObj.method="doConfirm";
        
        reqObj['emppage.defaultOfficeStr'] = this.defaultOffice.text;
        reqObj['emppage.userId'] = this.userId.text;
        reqObj['emppage.firstName'] = this.firstName.text;
        reqObj['emppage.middleInitial'] = this.middleName.text;
        reqObj['emppage.lastName'] = this.lastName.text;
        reqObj['emppage.title'] = this.title.text;
        reqObj['emppage.startDateStr'] = this.startDate.text;
        
        //reqObj['empApplnRoleParticipantList'] = this.emmpAppRoleList;
        
        reqObj['emppage.employeeOpenDateStr'] = this.empOpenDate.text;
        reqObj['emppage.employeeOpenedBy'] = this.empOpenedBy.text;
        
        if(this.mode == Globals.MODE_AMEND){
            reqObj['emppage.locked'] = this.lockedCh.selected? "Y":"N";
        }
        //GO FOR RESTRICTED FIELDS
        reqObj['emppage.restrictPermission'] = restrictPermission;
        if(restrictPermission == "Y"){
        reqObj['emppage.applPasswd'] = this.passwd.text;
        reqObj['emppage.confirmPassword'] = this.rePasswd.text;
        }else{
            reqObj['emppage.applPasswd'] = Globals.EMPTY_STRING;
            reqObj['emppage.confirmPassword'] = Globals.EMPTY_STRING;
        }
        //END RESTRICT FIELDS
        return reqObj;
        
    }
    
    override public function preResetEntry():void {
        
        var rndNo:Number= Math.random();
        super.getResetHttpService().url = "ref/employeeDispatch.action?method=initialExecute&rnd=" + rndNo; 
        
    }
    override public function preResetAmend():void{
        super.getResetHttpService().url = "ref/employeeAmendDispatch.action?method=resetEmployeeAmend&actionType=edit";
    }
    override public function doEntrySystemConfirm(e:Event):void{
        
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
        this.uConDefaultOffice.text="";
        this.uConUserId.text="";
        this.uConFirstName.text="";
        this.uConMiddleName.text="";
        this.uConLastName.text="";
        this.uConTitle.text="";
        this.uConStartDate.text="";
        this.uConEmpOpenDate.text="";
        this.uConEmpOpenedBy.text="";
        
      
        currentState = "";  
        vstack.selectedChild = qry;   
            super.postEntrySystemConfirm();
            
        
    }
    
    override public function doAmendSystemConfirm(e:Event):void{
        this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
    }
    override public function doCancelSystemConfirm(e:Event):void{
        
        this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
      
    }
    
    override public function doReopenSystemConfirm(e:Event):void{
        
        this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
      
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
	            actTypeArray[0]="T|S|B";
	            //cpTypeArray[1]="CLIENT";
	        myContextList.addItem(new HiddenObject("invActTypeContext",actTypeArray));    
	                  
	        //passing counter party type                
	        var cpTypeArray:Array = new Array(1);
	            cpTypeArray[0]="INTERNAL";
	            cpTypeArray[1]="BANK/CUSTODIAN";
	        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
	    
	        //passing account status                
	        var actStatusArray:Array = new Array(1);
	        actStatusArray[0]="TRADING|BOTH";
	        myContextList.addItem(new HiddenObject("actContext",actStatusArray));
	        return myContextList;
	    }
	    
        
    private function addColumn():void
      {
        var dg :DataGridColumn = new DataGridColumn();
        dg.dataField="";
        dg.editable = false;
        dg.headerText = "";
        dg.width = 40;
        dg.itemRenderer = new RendererFectory(DeleteColumnItemRenderer,this.mode);
        
        var cols :Array = emmpAppRoleList.columns;
        cols.unshift(dg);
        emmpAppRoleList.columns = cols;
      }
    
   /* public function editAccount(data:Object):void{
    	//if(accountAccessInfList.enabled){
    	//accInfListContainer.enabled = false ;
    	
		var reqObj : Object = new Object();
		reqObj.editDeleteIndexEmpAccountAccessInfo = accAccessList.getItemIndex(data);
		//restrictionSummaryResult.removeItemAt(reqObj.rowNo);
		//data.isVisible=false;
		//restrictionSummaryResult.refresh();
		 /*if(this.mode == "amend")
			editDeleteService.url = "ref/employeeAmendDispatch.action?method=editAccounts"
		else 
			editDeleteService.url = "ref/employeeDispatch.action?method=editAccounts"
		editDeleteService.request = reqObj;
		editDeleteService.send();
    	//}
	}
    public function deleteAccount(data:Object):void{
		var reqObj : Object = new Object();
		reqObj.editDeleteIndexEmpAccountAccessInfo = accAccessList.getItemIndex(data);
		 if(this.mode == "amend")
			editDeleteService.url = "ref/employeeAmendDispatch.action?method=deleteAccounts"
		else 
			editDeleteService.url = "ref/employeeDispatch.action?method=deleteAccounts"
		editDeleteService.request = reqObj;
		editDeleteService.send();
	}*/
        
        