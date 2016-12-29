
 import com.nri.rui.core.Globals;
 import com.nri.rui.core.controls.XenosAlert;
 import com.nri.rui.core.controls.XenosButton;
 import com.nri.rui.core.controls.XenosEntry;
 import com.nri.rui.core.startup.XenosApplication;
 import com.nri.rui.core.utils.HiddenObject;
 import com.nri.rui.core.utils.XenosStringUtils;
 import com.nri.rui.ref.validators.FinInstEntryValidator;
 
 import flash.events.Event;
 import flash.events.IEventDispatcher;
 
 import mx.collections.ArrayCollection;
 import mx.containers.TitleWindow;
 import mx.events.CloseEvent;
 import mx.events.ListEvent;
 import mx.events.ResourceEvent;
 import mx.managers.PopUpManager;
 import mx.resources.ResourceBundle;
 import mx.rpc.events.ResultEvent;
 
 
 
 [Bindable]public var mode : String = "entry";
 private var keylist:ArrayCollection = new ArrayCollection();
 [Bindable]
 public var finInstCodeTypesList:ArrayCollection = new ArrayCollection();
 [Bindable]
 public var dp:ArrayCollection = new ArrayCollection();
 [Bindable]
 public var finCollIndex:int;
 [Bindable]
 public var addressIds:ArrayCollection = new ArrayCollection();
 [Bindable]
 public var addressTypes:ArrayCollection = new ArrayCollection();
 [Bindable]
 public var autoManFlags:ArrayCollection = new ArrayCollection();
 [Bindable]
 public var rptNames:ArrayCollection = new ArrayCollection();
 
 [Bindable]
 public var charCodes:ArrayCollection = new ArrayCollection();
 [Bindable]
 public var grpRptNames:ArrayCollection = new ArrayCollection();
 
 public var eaddressPopup:FinInstEAddressEntry;
 public var finInstNamePopup:FinInstNameDetails;    
 
 public var isForEdit:Boolean = false;
 public var isForDelete:Boolean = false;
 [Bindable]
 public var editIndex:int;
 [Bindable]
 public var finInstCodeTypes:ArrayCollection = new ArrayCollection();
 
 [Bindable]
 public var ucfinInstCodeTypes :ArrayCollection= new ArrayCollection();
 [Bindable]
 public var finInstNameDetailList:ArrayCollection = new ArrayCollection();
  [Bindable]
 public var deliveryEaddressList:ArrayCollection = new ArrayCollection();
 [Bindable]
 public var deliveryEAddressRulesList:ArrayCollection = new ArrayCollection();
 [Bindable]
  public var eaddressIdListList:ArrayCollection = new ArrayCollection();
  
  [Bindable]private var finInstPkStr : String = "";
 
 private var defaultFinInstCode:String = "";
 [Bindable]
 public var confirmPage:Boolean = false;
 
 private var showParentRoleAmend:Boolean = true;
 
 [Bindable]
 public var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
 
 [Bindable]
 public var defaultBtn : XenosButton;
 [Bindable]
  private var tempMode:String;
  
 public function escapeHTML(str:String):String {
    
    str = str.replace("<br>/g", ",");      
    //str = str.replace(/</g, "&lt;");      
    //str = str.replace(/>/g, "&gt;");      
    return str;  
 }
     /**
    * This method works as the result handler of the Initialization/Reset Http Services.
    * Once initial data is fetched from database to fill some form data, this method works
    * to actually show the data.
    */   
     private function initPage(event: ResultEvent) : void {
        errPage.clearError(event); //clears the errors if any 
     }
 
    /**
    * This is called at creationComplete of the module
    */
     private function loadAll():void {
        parseUrlString();
        super.setXenosEntryControl(new XenosEntry());
        if(this.mode == 'entry'){
        	tempMode = "Entry";
            this.dispatchEvent(new Event('entryInit'));
        }else if(this.mode == 'amendment'){
        	tempMode = "Amend";
           this.dispatchEvent(new Event('amendEntryInit'));
        //hdbox1.selectedChild = this.qry;
         //this.currentState="entryState";
           vstack.selectedIndex = 0;
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
                               // Alert.show("Mode :: " + mode);
                            }else if(tempA[0] == "finInstRolePk"){
                                this.finInstPkStr = tempA[1];
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
        super.getInitHttpService().url = "ref/finInstEntryDispatch.action?method=initialExecute&rnd=" + rndNo;
    }
    override public function preAmendInit():void{     
        //initLabel.text = "Exchange Rate Amend" 
        var rndNo:Number= Math.random(); 
        super.getInitHttpService().url = "ref/finInstAmendDispatch.action?";
        var reqObject:Object = new Object();
        reqObject.rnd = rndNo;
        reqObject.method= "finInstAmendExecute";
        reqObject.mode=this.mode;
        reqObject.finInstRolePk = this.finInstPkStr;
        super.getInitHttpService().request = reqObject;
        
    }
    
    override public function preCancelInit():void{  
    	uConfLabel.text=this.parentApplication.xResourceManager.getKeyValue('ref.fininst.label.fininstcancel');
        this.back.includeInLayout = false;
        this.back.visible = false;
        changeCurrentState();                           
        var rndNo:Number= Math.random(); 
        super.getInitHttpService().url = "ref/finInstCloseDispatch.action?";
        var reqObject:Object = new Object();
        reqObject.rnd = rndNo;
        reqObject.method= "finInstCloseExecute";
        reqObject.mode=this.mode;
        reqObject.finInstRolePk = this.finInstPkStr;
        super.getInitHttpService().request = reqObject;
    }
    
    private function addCommonKeys():void{  
        keylist = new ArrayCollection();
        keylist.addItem("finInstCodeTypes.item");
        keylist.addItem("finInstCodeType");
        keylist.addItem("defaultCharsetCode");
        keylist.addItem("finInstRolePage.ourAccountPresentList.item");
        keylist.addItem("finInstRolePage.roleList.roles");
        keylist.addItem("finInstRolePage.ourBankGroup.item");
        keylist.addItem("finInstRolePage.calendars.item");
        keylist.addItem("finInstRolePage.preferredCodeTypeList.preferredCodeType");
        keylist.addItem("finInstRolePage.preferredCodeType");
        keylist.addItem("finInstRolePage.preferredInstrumentCodeTypeList.preferredInstrumentCodeType");
        keylist.addItem("finInstRolePage.preferredInstrumentCodeType");
        keylist.addItem("finInstRolePage.preferredAccountTypeList.item");
        keylist.addItem("finInstRolePage.preferredAccountType");
        keylist.addItem("addressIds.item");
        keylist.addItem("addressTypes.item");
        keylist.addItem("autoManualFlags.item");
        keylist.addItem("reportNames.item");
        keylist.addItem("groupReportNames.grpReportName");
        keylist.addItem("charsetCodeValues.charsetCode");
    }
    override public function preEntryResultInit():Object{
        addCommonKeys(); 
        return keylist;
    }
    override public function preAmendResultInit():Object{
        addCommonKeys(); 
        keylist.addItem("defaultShortName");
        keylist.addItem("defaultOfficialName1");
        keylist.addItem("defaultOfficialName2");
        keylist.addItem("defaultOfficialName3");
        keylist.addItem("defaultOfficialName4");
        keylist.addItem("finInstRolePage.countryCode");
        keylist.addItem("finInstRolePage.ourAccountPresent");
        keylist.addItem("finInstRolePage.parentRole");
        keylist.addItem("finInstRolePage.bankGroupId");
        keylist.addItem("finInstRolePage.calendar");
        keylist.addItem("finInstRolePage.remarks");
        keylist.addItem("finInstRolePage.preferredCodeType");
        keylist.addItem("finInstRolePage.preferredInstrumentCodeType");
        keylist.addItem("finInstRolePage.preferredAccountType");
        keylist.addItem("finInstCrossRefs.finInstCrossRef");
        keylist.addItem("finInstNameCrossRefs.finInstNameCrossRef");
        keylist.addItem("deliveryEAddressRules.deliveryEAddressRule");
        keylist.addItem("electronicAddresses.electronicAddress"); 
        keylist.addItem("finInstRolePage.refListValueArray.refListValue"); 
        keylist.addItem("addressIdList.addressId");
        return keylist;
    }
    
    override public function preCancelResultInit():Object{
        addCommonResultKeys();  
        keylist.addItem("finInstNameCrossRefs.finInstNameCrossRef");
        keylist.addItem("deliveryEAddressRules.deliveryEAddressRule");
        keylist.addItem("electronicAddresses.electronicAddress");       
        return keylist;
    } 
    
    override public function postEntryResultInit(mapObj:Object): void{
        commonInit(mapObj);
        this.eaddressBtn.enabled=false;
        app.submitButtonInstance =  submit;
        defaultBtn = submit;
    }
    override public function postAmendResultInit(mapObj:Object): void{
        
        commonInit(mapObj);
        var tmpColl : ArrayCollection;
        this.shortName.text = mapObj[keylist.getItemAt(19)].toString();
        this.offName1.text = mapObj[keylist.getItemAt(20)].toString();
        this.offName2.text = mapObj[keylist.getItemAt(21)].toString();
        this.offName3.text = mapObj[keylist.getItemAt(22)].toString();
        this.offName4.text = mapObj[keylist.getItemAt(23)].toString();
        this.countryPopUp.countryCode.text = mapObj[keylist.getItemAt(24)].toString();
        var indx:int=0;
        tmpColl = ouraccountpresent.dataProvider as ArrayCollection;
        for(;indx < tmpColl.length;indx++){
            if (XenosStringUtils.equals(tmpColl[indx].value, mapObj[keylist.getItemAt(25)].toString())){
                break;
            }
        }
        ouraccountpresent.selectedIndex = indx;
        if(XenosStringUtils.equals(mapObj[keylist.getItemAt(25)].toString(),"Y")){
            this.eaddressBtn.enabled=true;
        }
        
        this.parentRolePopUp.finInstCode.text = mapObj[keylist.getItemAt(26)].toString();
        
        indx=0;
        
        tmpColl = bankgroup.dataProvider as ArrayCollection;
        for(;indx < tmpColl.length;indx++){
            if (XenosStringUtils.equals(tmpColl[indx].value, mapObj[keylist.getItemAt(27)].toString())){
                break;
            }
        }
        this.bankgroup.selectedIndex = indx;
        
        indx=0;
       
        tmpColl = calendar.dataProvider as ArrayCollection;
        for(;indx < tmpColl.length;indx++){
            if (XenosStringUtils.equals(tmpColl[indx].value, mapObj[keylist.getItemAt(28)].toString())){
                break;
            }
        }
        this.calendar.selectedIndex = indx;
        
        this.remarks.text = mapObj[keylist.getItemAt(29)].toString();
        
        indx=0;
       
        tmpColl = preferredfininstcodetype.dataProvider as ArrayCollection;
        for(;indx < tmpColl.length;indx++){
            if (XenosStringUtils.equals(tmpColl[indx], mapObj[keylist.getItemAt(30)].toString())){
                break;
            }
        }
        this.preferredfininstcodetype.selectedIndex = indx;
        
        indx=0;
       
        tmpColl = preferredseccodetype.dataProvider as ArrayCollection;
        for(;indx < tmpColl.length;indx++){
            if (XenosStringUtils.equals(tmpColl[indx], mapObj[keylist.getItemAt(31)].toString())){
                break;
            }
        }
        this.preferredseccodetype.selectedIndex = indx;
        
        indx=0;
       
        tmpColl = preferredaccnotype.dataProvider as ArrayCollection;
        for(;indx < tmpColl.length;indx++){
            if (XenosStringUtils.equals(tmpColl[indx].value, mapObj[keylist.getItemAt(32)].toString())){
                break;
            }
        }
        this.preferredaccnotype.selectedIndex = indx;
        
        finInstCodeTypes = mapObj[keylist.getItemAt(33)] as ArrayCollection;
        var chkForAmend:Boolean = true;
        modifyFinInstCrossRefs();
        addFinInstCodeDp.dataProvider = finInstCodeTypes;
        
        finInstNameDetailList = mapObj[keylist.getItemAt(34)] as ArrayCollection;
        
        deliveryEaddressList = mapObj[keylist.getItemAt(36)] as ArrayCollection;
        deliveryEAddressRulesList = mapObj[keylist.getItemAt(35)] as ArrayCollection;
        
        modifyEAddressAndNameDetails();
        var selIndices:Array = new Array();
        var tmpColl1:ArrayCollection = roles.dataProvider as ArrayCollection;
        var coll :ArrayCollection ;
        if(mapObj[keylist.getItemAt(37)] is ArrayCollection){
            coll = mapObj[keylist.getItemAt(37)] as ArrayCollection;
        }else{
            coll = new ArrayCollection();
            coll.addItem(mapObj[keylist.getItemAt(37)]);
        }
        
        for(var i:int=0;i < coll.length;i++){
             for(indx=0;indx < tmpColl1.length;indx++){
                if(XenosStringUtils.equals(tmpColl1[indx].toString(),coll[i].toString())){
                    selIndices.push(indx);
                }
            } 
        }
        this.roles.selectedIndices = selIndices;
        
        showParentRoleAmend = false;
        //Fire the OnChange Method
        this.roles.dispatchEvent(new ListEvent(ListEvent.CHANGE));
        
        if(mapObj[keylist.getItemAt(38)] is ArrayCollection){
            tmpColl= mapObj[keylist.getItemAt(38)] as ArrayCollection;
        } else {
            tmpColl.addItem(mapObj[keylist.getItemAt(38)]);
        }
        eaddressIdListList.addItem(" ");
        for each(var item:String in tmpColl){
            eaddressIdListList.addItem(item);
        }
        
        app.submitButtonInstance =  submit;
        defaultBtn = submit;
    }
    private function clearAllFields():void{
        finInstCodeTypes = new ArrayCollection();
        charCodes = new ArrayCollection();
        grpRptNames = new ArrayCollection();
        finInstNameDetailList = new ArrayCollection();
        deliveryEaddressList = new ArrayCollection();
        deliveryEaddressList = new ArrayCollection();
        eaddressIdListList = new ArrayCollection();
        autoManFlags = new ArrayCollection();
        addressTypes = new ArrayCollection();
        rptNames = new ArrayCollection();
        addressIds = new ArrayCollection();
        
        this.code.text = XenosStringUtils.EMPTY_STR;
        this.defaultCharCode.text = XenosStringUtils.EMPTY_STR;
        this.shortName.text = XenosStringUtils.EMPTY_STR;
        this.offName1.text = XenosStringUtils.EMPTY_STR;
        this.offName2.text = XenosStringUtils.EMPTY_STR;
        this.offName3.text = XenosStringUtils.EMPTY_STR;
        this.offName4.text = XenosStringUtils.EMPTY_STR;
        this.countryPopUp.countryCode.text = XenosStringUtils.EMPTY_STR;
        this.parentRolePopUp.finInstCode.text = XenosStringUtils.EMPTY_STR;
        this.remarks.text = XenosStringUtils.EMPTY_STR;
    }
    private function commonInit(mapObj:Object):void{
        
        clearAllFields();
        errPage.clearError(super.getInitResultEvent());
        
        var index:int=0;
        //Populate the finInstCodeTypesList to show in the XenosDataGrid
        finInstCodeTypesList = mapObj[keylist.getItemAt(0)] as ArrayCollection; 
        finCollIndex =0;
        defaultFinInstCode = mapObj[keylist.getItemAt(1)].toString();
        for each(var item:Object in finInstCodeTypesList as ArrayCollection){
            if(item.value == mapObj[keylist.getItemAt(1)].toString()){
                finCollIndex = (finInstCodeTypesList as ArrayCollection).getItemIndex(item);
            }
        }
        codeTypes.dataProvider = finInstCodeTypesList;
        codeTypes.selectedIndex = finCollIndex;
        //Populate the ourAccountPresentList
        var initcol:ArrayCollection = new ArrayCollection();
        
        for each(var item:Object in (mapObj[keylist.getItemAt(3)] as ArrayCollection)){
            initcol.addItem(item);
        }
        ouraccountpresent.dataProvider = initcol;
        
        //Populate Institution Roles
        initcol=new ArrayCollection();
        //initcol.addItem("");
        for each(var item:Object in (mapObj[keylist.getItemAt(4)] as ArrayCollection)){
            initcol.addItem(item);
        }
        roles.dataProvider = initcol;
        
        //Populate BankGroup
        initcol=new ArrayCollection();
        initcol.addItem({label:" ", value: ""});
        for each(var item:Object in (mapObj[keylist.getItemAt(5)] as ArrayCollection)){
            initcol.addItem(item);
        }
        bankgroup.dataProvider = initcol;
        
        //Populate Calendar
        initcol=new ArrayCollection();
        initcol.addItem({label:" ", value: " "});
        for each(var item:Object in (mapObj[keylist.getItemAt(6)] as ArrayCollection)){
            initcol.addItem(item);
        }
        calendar.dataProvider = initcol;
        
        //Populate Preferred Financial Institution Code Type
        initcol=new ArrayCollection();
        initcol.addItem("");
        index = -1 ;
        for each(var item:Object in (mapObj[keylist.getItemAt(7)] as ArrayCollection)){
            initcol.addItem(item);
            if(item == mapObj[keylist.getItemAt(8)].toString()){
                index = (mapObj[keylist.getItemAt(7)] as ArrayCollection).getItemIndex(item);
            }           
        }
        preferredfininstcodetype.dataProvider = initcol;
        preferredfininstcodetype.selectedIndex = index !=-1 ? index+1 : 0;
        
        //Populate Preferred Security Code Type
        initcol=new ArrayCollection();
        initcol.addItem("");
        index = -1 ;
        for each(var item:Object in (mapObj[keylist.getItemAt(9)] as ArrayCollection)){
            initcol.addItem(item);
            if(item == mapObj[keylist.getItemAt(10)].toString()){
                index = (mapObj[keylist.getItemAt(9)] as ArrayCollection).getItemIndex(item);
            }           
        }
        preferredseccodetype.dataProvider = initcol;
        preferredseccodetype.selectedIndex = index !=-1 ? index+1 : 0;
        
        //Populate Preferred Account No Type
        initcol=new ArrayCollection();
        initcol.addItem({label:" ", value: " "});
        index = -1 ;
        for each(var item:Object in (mapObj[keylist.getItemAt(11)] as ArrayCollection)){
            initcol.addItem(item);
            if(item.value == mapObj[keylist.getItemAt(12)].toString()){
                index = (mapObj[keylist.getItemAt(11)] as ArrayCollection).getItemIndex(item);
            }           
        }
        preferredaccnotype.dataProvider = initcol;
        preferredaccnotype.selectedIndex = index !=-1 ? index+1 : 0;
        
        //Prefetch the addressIds
        addressIds.addItem({label:" ", value: " "});
        for each(var item:Object in (mapObj[keylist.getItemAt(13)] as ArrayCollection)){
            addressIds.addItem(item);
        }
        //Prefetch Addresstypes
        addressTypes.addItem({label:" ", value: " "});
        for each(var item:Object in (mapObj[keylist.getItemAt(14)] as ArrayCollection)){
            addressTypes.addItem(item);
        }
        //Prefetch AutoManualFlags
        autoManFlags.addItem({label:" ", value: " "});
        for each(var item:Object in (mapObj[keylist.getItemAt(15)] as ArrayCollection)){
            autoManFlags.addItem(item);
        }
        //Prefetch ReportNames
        rptNames.addItem({label:" ", value: " "});
        for each(var item:Object in (mapObj[keylist.getItemAt(16)] as ArrayCollection)){
            rptNames.addItem(item);
        }
        
        //Default Character Code
        var charCode:String = mapObj[keylist.getItemAt(2)].toString();
        this.defaultCharCode.text = charCode;
        
        //Group Items
        grpRptNames.addItem(" ");
        for each(var item:Object in (mapObj[keylist.getItemAt(17)] as ArrayCollection)){
            grpRptNames.addItem(item);
        }
        //Charcodes
        charCodes.addItem(" ");
        for each(var item:Object in (mapObj[keylist.getItemAt(18)] as ArrayCollection)){
            charCodes.addItem(item);
        }
    }
    /**
    * To determine whether to show the Parent Role FinInst Pop up 
    * or not. To be shown only if Stock Exchange option is chosen.
    */
    private function onChangeParentRole(event:ListEvent):void{
        var selItems : Array = event.currentTarget.selectedItems as Array;
        var flag:Boolean = false;
        //trace(selItems);
        for(var indx:int=0; indx<selItems.length;indx++){
            //trace(selItems[indx]);
            if(XenosStringUtils.equals(selItems[indx],"Stock Exchange")){
                lprc.includeInLayout = true;
                lprc.visible = true;
                parentRolePopUp.includeInLayout = true;
                parentRolePopUp.visible = true;
                if(showParentRoleAmend){
                    parentRolePopUp.finInstCode.text=XenosStringUtils.EMPTY_STR;
                }
                flag = true;
                break;
            }
        }
        if(!flag){
            lprc.includeInLayout = false;
            lprc.visible = false;
            parentRolePopUp.includeInLayout = false;
            parentRolePopUp.visible = false;
            if(showParentRoleAmend){
                parentRolePopUp.finInstCode.text=XenosStringUtils.EMPTY_STR;
            }
        }
        showParentRoleAmend = true;
    }
    
    /**
      * This is the method to pass the Collection of data items
      * through the context to the FinInst popup. This will be implemented as per specific  
      * requirement. 
      */
    private function populateFinInstRole():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
        
        var bankRoleArray : Array = new Array(1);
        bankRoleArray[0] = "Stock Exchange";
       
        myContextList.addItem(new HiddenObject("stockExchangeRoles",bankRoleArray));
        
        return myContextList;
    }
    /** 
    * To determine whether the popup button should be shown or not.
    * Only shown if Firm maintains Account is true.
    */
    private function showHideEAddress(event:ListEvent):void{
        var target : Object = event.currentTarget.selectedItem as Object;
        var strValue:String = target.value;
        if(XenosStringUtils.equals(strValue,"Y")){
            eaddressBtn.enabled = true;
            
        }else{
            eaddressBtn.enabled = false;
            
        }
    }
    /**
    * Open the popup to enter the E-address related data.
    */
    private function openEAddressPopUp(event:Event):void{
        eaddressPopup = FinInstEAddressEntry(
                    PopUpManager.createPopUp(this, FinInstEAddressEntry, true));
        
        eaddressPopup.width = this.parentApplication.width - 100;
        eaddressPopup.height = 400;
        if(this.mode == "close" || confirmPage){
            eaddressPopup.eaddressGrid.includeInLayout = false;
            eaddressPopup.eaddressGrid.visible = false;
            eaddressPopup.eaddressRuleGrid.includeInLayout = false;
            eaddressPopup.eaddressRuleGrid.visible = false;
            eaddressPopup.resetButton.includeInLayout = false;
            eaddressPopup.resetButton.visible = false;
        }
        if(this.mode == "entry"){
            eaddressPopup.title="Financial Institution  Entry - Delivery E-Address and Rule";
        }else if(this.mode == "amendment"){
            eaddressPopup.title="Financial Institution  Amend - Delivery E-Address and Rule"
        }else{
            eaddressPopup.title="Financial Institution  Cancel - Delivery E-Address and Rule"
        }
        eaddressPopup.dpDeliveryEaddressList = deliveryEaddressList;    
        eaddressPopup.dpDeliveryEAddressRules = deliveryEAddressRulesList;
        eaddressPopup.addressIds = this.addressIds; 
        eaddressPopup.reportNames = this.rptNames;
        eaddressPopup.grpRptNames = this.grpRptNames;   
        eaddressPopup.addressTypes = this.addressTypes;
        eaddressPopup.autoManualFlags = this.autoManFlags;
        eaddressPopup.tmpAddressIds = eaddressIdListList;
        eaddressPopup.mode = this.mode;
        eaddressPopup.confirm = confirmPage;
        eaddressPopup.owner = this;
        focusManager.setFocus(eaddressPopup.okButton);
        app.submitButtonInstance = eaddressPopup.okButton;
        PopUpManager.centerPopUp(eaddressPopup);    
    }
    
    private function openDetailsPopUp(event:Event,confirm:Boolean=false):void{
        
        //Validate whether the required fields have been filledup
        var openPopup:Boolean= false;
        if(!confirm){
            openPopup = validateDefaultName();
        }
        if(confirm || openPopup){
            finInstNamePopup = FinInstNameDetails(
                    PopUpManager.createPopUp(this, FinInstNameDetails, true));
            finInstNamePopup.finInstNameDetails = finInstNameDetailList ;       
            finInstNamePopup.width = this.parentApplication.width - 100;
            finInstNamePopup.mode = this.mode;  
            finInstNamePopup.confirm = confirmPage; 
            finInstNamePopup.charCodeColl = charCodes;
            if(this.mode == "close" || confirmPage){
                finInstNamePopup.inputGrid.includeInLayout = false;
                finInstNamePopup.inputGrid.visible = false;
                finInstNamePopup.resetButton.includeInLayout = false;
                finInstNamePopup.resetButton.visible = false;
            }
            if(this.mode == "entry"){
                finInstNamePopup.title="Financial Institution  Entry - Name Info";
            }else if(this.mode == "amendment"){
                finInstNamePopup.title="Financial Institution  Amend - Name Info"
            }else{
                finInstNamePopup.title="Financial Institution  Cancel - Name Info"
            }
            finInstNamePopup.owner = this;
            focusManager.setFocus(finInstNamePopup.okButton);
            app.submitButtonInstance = finInstNamePopup.okButton;
            PopUpManager.centerPopUp(finInstNamePopup);
        }
     }
    /**
    * This validates whether at least one Fin Inst name Detail
    * has been correctly given with charCode,Short Name and 
    * Default Official Name. After this validation, clicking the
    * Details buton allows to open Fin Inst Entry Pop up.
    */
    private function validateDefaultName():Boolean{
        
        var alertStr:String = XenosStringUtils.EMPTY_STR;
        if(XenosStringUtils.isBlank(this.shortName.text)){
            alertStr += "Please enter Default Short Name. \n";
            this.shortName.setFocus();
        }
        if(XenosStringUtils.isBlank(this.offName1.text)){
            alertStr += "Please enter Default Official Name1. \n";
            this.offName1.setFocus();
        }
        if(!XenosStringUtils.equals(alertStr,XenosStringUtils.EMPTY_STR)){
            XenosAlert.error(alertStr);
            return false;
        }
        return true;    
    }
    /**
     * Handler for the Add button to enter the FinInstCode types
     * for the FinInst Entry. It validates whether the mandatory fields
     * are entered and send the Http Service to add the value
     * in the action form.
     */ 
    private function addCodeTypes(e:Event):void{
        var validate:Boolean= false;
        validate = validateFinInstCode();
        if(validate){
            sendHttpRequest();
        }
    }
    /**
     * Validates if all the mandatory fields have been required for
     * FinInst Code details have been entered. CodeType and
     * Code are required.
     */  
    private function validateFinInstCode():Boolean{
        var alertStr:String = XenosStringUtils.EMPTY_STR;
        var _CODE_TYPE_ABA :String = "ABA";
        var _CODE_TYPE_BIC :String = "BIC";
        var codeType:String = (this.codeTypes.selectedItem != null ? this.codeTypes.selectedItem.value : "");
        var codeStr : String = this.code.text;
        
        if(XenosStringUtils.isBlank(codeStr)) 
        {
             alertStr += "Please enter Financial Institution Code \n";
             this.code.setFocus();
        }
        
        
        if(!XenosStringUtils.equals(alertStr,XenosStringUtils.EMPTY_STR)){
            XenosAlert.error(alertStr);
            return false;
        }
        if(XenosStringUtils.equals(codeType.toUpperCase(), _CODE_TYPE_ABA)){
            if(!XenosStringUtils.isNumeric(codeStr)){
                alertStr += "Code should be numeric \n";
            }
            if(codeStr.length != 9){
                alertStr += "Code should be of 9 digit \n";
            }
        } 
        if(XenosStringUtils.equals(codeType.toUpperCase(), _CODE_TYPE_BIC)){
            
            if(!XenosStringUtils.isAlphaNumeric(codeStr)){
                alertStr += "Code should be alphanumeric \n";
            }
            if(codeStr.length != 11)
                alertStr += "Code should be of 11 digit \n";
        } 
        if(!XenosStringUtils.equals(alertStr,XenosStringUtils.EMPTY_STR)){
            XenosAlert.error(alertStr);
            return false;
        }
        return true;
    }
    /**
     * Http Service is being sent after populating the request
     * parameters to add the FinInstCodeTypes.ie. dispatch action 
     * is being called.
     */
    private function sendHttpRequest():void{
        isForEdit = false;
        var reqObj:Object = populateRequestParams(!isForEdit);
        if(this.mode == "entry"){
            addFinInstCodeType.url="ref/finInstEntryDispatch.action?"
        }else if(this.mode == "amendment"){
            addFinInstCodeType.url="ref/finInstAmendDispatch.action?"
        }
        addFinInstCodeType.request = reqObj;
        addFinInstCodeType.addEventListener(ResultEvent.RESULT,resultHandler);
        
        addFinInstCodeType.send();
    }
    /**
     * Populating the request parameters to add a FinInstCode Type.
     */
    private function populateRequestParams(flagForEntry:Boolean):Object{
        var reqObj:Object = new Object();
        if(flagForEntry){
            reqObj.method = "addFinInstCode";
        }else {
            reqObj.method = "updateFinInstCode";
            reqObj['editIndexFinInstCode']=editIndex;
        }
        reqObj.finInstCodeType = (this.codeTypes.selectedItem != null ? this.codeTypes.selectedItem.value : "");
        reqObj.finInstCode = this.code.text;
        
        return reqObj;
    }
    /**
     * The result handler for the Http Service to add the finInst codetype
     */  
    private function resultHandler(event:ResultEvent):void{
        var rs : XML = XML(event.result);
        if (null != event) {
            if(rs.child("finInstCrossRefs").length() > 0){
                var finInstCrossRef:XML = XML(rs.finInstCrossRefs);
                finInstCodeTypes.removeAll();
                
                if(finInstCrossRef.child("finInstCrossRef").length()>0) {
                    errPage.clearError(event);
                    //dpDeliveryEaddressList.removeAll();
                    try {
                        for each ( var rec:XML in finInstCrossRef.finInstCrossRef ) {
                            //trace("xml str.."+rec.toXmlString());
                            finInstCodeTypes.addItem(rec);
                        }
                        modifyFinInstCrossRefs();
                    }catch(e:Error){
                        //XenosAlert.error(e.toString() + e.message);
                        XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                    }
                }
                
                showHideAddBtn(isForEdit);
                if(!isForDelete){
                    resetFinInstXRefFields();
                }
            }else if(rs.child("Errors").length()>0) {
                //some error found
                var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list              
                for each ( var error:XML in rs.Errors.error ) {
                   errorInfoList.addItem(error.toString());
                }
                errPage.showError(errorInfoList);//Display the error
            }else {
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
                finInstCodeTypes.removeAll(); // clear previous data if any as there is no result now.
                errPage.removeError(); //clears the errors if any
             }
        }
        addFinInstCodeType.removeEventListener(ResultEvent.RESULT,resultHandler);
    }
    /**
     * Add the properties selected and index to the list values.
     */
    private function modifyFinInstCrossRefs(chkForAmend:Boolean = false):void{
        var i :int = 0;
        for(;i<finInstCodeTypes.length;i++){
            finInstCodeTypes[i].selected = true;
            if(this.mode == "amendment"){
                if(XenosStringUtils.equals(finInstCodeTypes[i].finInstRoleCodeType,defaultFinInstCode)){
                    finInstCodeTypes[i].selected = false;
                }
            }
            
            finInstCodeTypes[i].index = i;
         }
     }
     
     private function modifyEAddressAndNameDetails():void{
        var i :int = 0;
        for(;i<finInstNameDetailList.length;i++){
            finInstNameDetailList[i].selected = true;
            finInstNameDetailList[i].index = i;
        }
        
        i=0;
        for(;i<deliveryEaddressList.length;i++){
            deliveryEaddressList[i].selected = true;
            deliveryEaddressList[i].index = i;
        }
        i=0;
        for(;i<deliveryEAddressRulesList.length;i++){
            deliveryEAddressRulesList[i].selected = true;
            deliveryEAddressRulesList[i].index = i;
        }
     }
     private function resetFinInstXRefFields():void{
        this.codeTypes.selectedIndex =finCollIndex;
        this.code.text = XenosStringUtils.EMPTY_STR;
     }
     
     /**
     * This function determines which button should be shown among Add, 
     * or Cancel / Save. If a record is being edited then Cancel/Save is
     * shown, else Add is shown.
     */  
     private function showHideAddBtn(editFlag:Boolean):void{
 
        cxlCodeType.includeInLayout = editFlag;
        cxlCodeType.visible = editFlag;
        saveCodeType.includeInLayout = editFlag;
        saveCodeType.visible = editFlag;
        addCodeType.includeInLayout = !editFlag;
        addCodeType.visible = !editFlag;
     }  
     
    private function cxlCodeTypes(e:Event):void{
        isForEdit = false;
        var requestObj :Object = new Object();
        requestObj.method="cancelFinInstCode";
		 
		if(this.mode == "entry"){
            addFinInstCodeType.url="ref/finInstEntryDispatch.action?"
        }else {
            addFinInstCodeType.url="ref/finInstAmendDispatch.action?"
        }
		
        addFinInstCodeType.request = requestObj;
        // Done to reset if any other data has been clicked for modification.
        // and without saving another record has been clicked
        // for modification.
        modifyFinInstCrossRefs();
        showHideAddBtn(isForEdit);
        resetFinInstXRefFields();
        
        var dp : ArrayCollection = addFinInstCodeDp.dataProvider as ArrayCollection;
        dp.refresh();
        
        addFinInstCodeType.send();
    }
    /**
     * This handler is called when the Save button is clicked after
     * the user decides to save the changes during edit.
     */
    private function saveCodeTypes(e:Event):void{
        isForEdit = false;
        isForDelete = false;
        var validate:Boolean= false;
        validate = validateFinInstCode();
        if(validate){
            var requestObj :Object = populateRequestParams(isForEdit);
            addFinInstCodeType.request = requestObj;
            addFinInstCodeType.addEventListener(ResultEvent.RESULT,resultHandler);
            if(this.mode == "entry"){
           	 	addFinInstCodeType.url="ref/finInstEntryDispatch.action?"
        	}else {
            	addFinInstCodeType.url="ref/finInstAmendDispatch.action?"
       		 }
            addFinInstCodeType.send();
        }
    }
    
    public function finInstXRefEdit(e:Event,indx:int):void{
        editIndex = indx;
        var editableObj : XML = finInstCodeTypes[indx];
        // Done to reset if any other data has been clicked for modification.
        // and without saving another record has been clicked
        // for modification.
        modifyFinInstCrossRefs();
        
        editableObj.selected=false;
        for each(var item:Object in finInstCodeTypesList){
            if(XenosStringUtils.equals(item.value,editableObj.finInstRoleCodeType)){
            
                this.codeTypes.selectedItem = item;
                break;
            }
            
        }
        this.code.text = editableObj.finInstRoleCode;
        var dp : ArrayCollection = addFinInstCodeDp.dataProvider as ArrayCollection;
        dp.setItemAt(editableObj,indx);
        dp.refresh();
        
        isForEdit = true;
        showHideAddBtn(isForEdit);
    }
    
    public function finInstXRefDelete(e:Event,delIndex:int):void{
        isForDelete = true;
        
        var requestObj :Object = new Object();
        requestObj.method="deleteFinInstCode";
        requestObj['editIndexFinInstCode'] = delIndex;
        
        addFinInstCodeType.request = requestObj;
        addFinInstCodeType.addEventListener(ResultEvent.RESULT,resultHandler);
        
        if(this.mode == "entry"){
        	addFinInstCodeType.url="ref/finInstEntryDispatch.action?"
        }else {
        	addFinInstCodeType.url="ref/finInstAmendDispatch.action?"
       	}
        addFinInstCodeType.send();
    }
    
    override public function preEntry():void{
        setValidator();
        super.getSaveHttpService().url = "ref/finInstEntryDispatch.action?";  
        super.getSaveHttpService().request  =populateAllRequestParams();
        super.getSaveHttpService().method="POST";
     }
    
    override public function preAmend():void{
        setValidator();
        super.getSaveHttpService().url = "ref/finInstAmendDispatch.action?";  
        super.getSaveHttpService().request  =populateAllRequestParams();
        super.getSaveHttpService().method="POST";
     }
     override public function preCancel():void{
        setValidator();
        super._validator = null;
        super.getSaveHttpService().url = "ref/finInstCloseDispatch.action?"; 
        var reqObj:Object = new Object();
        reqObj.method="cancelFinInst";
        reqObj.mode=this.mode;
        super.getSaveHttpService().request  =reqObj;
        super.getSaveHttpService().method="POST";
     }  
     private function setValidator():void{
        var validateModel:Object={
                            finInstEntry:{
                                 refListValueArray:this.roles.selectedItems,
                                 countryCode:this.countryPopUp.countryCode.text,
                                 defaultOfficialName1:this.offName1.text,
                                 defaultShortName:this.shortName.text
                                        
                            }
                           }; 
         super._validator = new FinInstEntryValidator();
         super._validator.source = validateModel ;
         super._validator.property = "finInstEntry";
     }
     
     /**
    * This method will populate the request parameters for the
    * submitQuery call and bind the parameters with the HTTPService
    * object.
    */
    private function populateAllRequestParams():Object {
        var reqObj : Object = new Object();
        
        reqObj.method= "confirm";
        
        reqObj['defaultCharsetCode'] = this.defaultCharCode.text;
        reqObj['defaultShortName'] = this.shortName.text;
        reqObj['defaultOfficialName1'] = this.offName1.text;
        reqObj['defaultOfficialName2'] = this.offName2.text;
        reqObj['defaultOfficialName3'] = this.offName3.text;
        reqObj['defaultOfficialName4'] = this.offName4.text;
        reqObj['finInstRolePage.countryCode'] = this.countryPopUp.countryCode.text;
        reqObj['finInstRolePage.ourAccountPresent'] = (this.ouraccountpresent.selectedItem != null? this.ouraccountpresent.selectedItem.value : "")
        reqObj['finInstRolePage.refListValueArray'] = this.roles.selectedItems;
        reqObj['finInstRolePage.parentRole'] = this.parentRolePopUp.finInstCode.text;
        reqObj['finInstRolePage.bankGroupId'] = (this.bankgroup.selectedItem != null? this.bankgroup.selectedItem.value : "")
        reqObj['finInstRolePage.calendar'] = (this.calendar.selectedItem != null? this.calendar.selectedItem.value : "")
        reqObj['finInstRolePage.remarks'] = this.remarks.text;
        reqObj['finInstRolePage.preferredCodeType'] = (this.preferredfininstcodetype.selectedItem != null? this.preferredfininstcodetype.selectedItem : "")
        reqObj['finInstRolePage.preferredInstrumentCodeType'] = (this.preferredseccodetype.selectedItem != null? this.preferredseccodetype.selectedItem : "")
        reqObj['finInstRolePage.preferredAccountType'] = (this.preferredaccnotype.selectedItem != null? this.preferredaccnotype.selectedItem.value : "")
        
        return reqObj;
    }
    
    override public function preEntryResultHandler():Object
    {
         addCommonResultKeys();
         return keylist;
    }
    override public function preAmendResultHandler():Object
    {
        addCommonResultKeys();
        return keylist;
    }
    private function addCommonResultKeys():void{
        keylist = new ArrayCollection();
        keylist.addItem("finInstCrossRefs.finInstCrossRef");
        keylist.addItem("defaultCharsetCode");
        keylist.addItem("defaultShortName");
        keylist.addItem("defaultOfficialName1");
        keylist.addItem("defaultOfficialName2");
        keylist.addItem("defaultOfficialName3");
        keylist.addItem("defaultOfficialName4");
        keylist.addItem("finInstRolePage.countryCode");
        keylist.addItem("finInstRolePage.ourAccountPresentDisp");
        keylist.addItem("finInstRolePage.ourAccountPresent");
        keylist.addItem("finInstRolePage.refListValueArrayString");
        keylist.addItem("finInstRolePage.parentRole");
        keylist.addItem("finInstRolePage.bankGroupIdDisp");
        keylist.addItem("finInstRolePage.displaySeq");
        keylist.addItem("finInstRolePage.calendarStr");
        keylist.addItem("finInstRolePage.remarks");
        keylist.addItem("finInstRolePage.dataSource");
        keylist.addItem("finInstRolePage.preferredCodeType");
        keylist.addItem("finInstRolePage.preferredInstrumentCodeType");
        keylist.addItem("finInstRolePage.preferredAccountTypeDisp");
    }
    
    override public function postEntryResultHandler(mapObj:Object):void
    {
        commonResult(mapObj);
    }
    override public function postAmendResultHandler(mapObj:Object):void
    {
        commonResult(mapObj);
    }
    override public function postCancelResultHandler(mapObj:Object):void
    {
        if(submitUserConfResult(mapObj)){
        
        uConfLabel.text = this.parentApplication.xResourceManager.getKeyValue('ref.fininst.label.userconfirm')+tempMode;
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
        
        focusManager.setFocus(uCancelConfSubmit);
        app.submitButtonInstance = uCancelConfSubmit;
        defaultBtn = uCancelConfSubmit;
       }
    } 
    private function commonResult(mapObj:Object):void{
            
            if(mapObj!=null){           
                if(mapObj["errorFlag"].toString() == "error"){
                    if(mode != "cancel"){
                      errPage.showError(mapObj["errorMsg"]);                        
                    }else{
                        XenosAlert.error(mapObj["errorMsg"]);
                    }
                }else if(mapObj["errorFlag"].toString() == "noError"){
                    
                 errPage.clearError(super.getSaveResultEvent());                            
                 commonResultPart(mapObj);
                 changeCurrentState();
                 confirmPage = true;
                 focusManager.setFocus(uConfSubmit);
                 app.submitButtonInstance = uConfSubmit;
                 defaultBtn = uConfSubmit;  
                }else{
                    errPage.removeError();
                    XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.datanotfound'));
                }           
            }
        }
      
      private function commonResultPart(mapObj:Object):void{
         this.ucfinInstCodeTypes = mapObj[keylist.getItemAt(0)] as ArrayCollection;
         this.ucdefaultCharCode.text = mapObj[keylist.getItemAt(1)].toString();
         this.ucshortName.text = mapObj[keylist.getItemAt(2)].toString();
         this.ucoffName1.text = mapObj[keylist.getItemAt(3)].toString();
         this.ucoffName2.text = mapObj[keylist.getItemAt(4)].toString();
         this.ucoffName3.text = mapObj[keylist.getItemAt(5)].toString();
         this.ucoffName4.text = mapObj[keylist.getItemAt(6)].toString();
         this.uccountryCode.text = mapObj[keylist.getItemAt(7)].toString();
         this.ucouraccountpresent.text = mapObj[keylist.getItemAt(8)].toString();
         var str : String = mapObj[keylist.getItemAt(9)].toString();
         if(XenosStringUtils.equals(str,"Y")){
            uceaddressBtn.enabled = true;
         }else{
            uceaddressBtn.enabled = false;
         }
         this.ucroles.htmlText = mapObj[keylist.getItemAt(10)].toString();
         this.ucparentRole.text = mapObj[keylist.getItemAt(11)].toString();
         this.ucbankgroup.text = mapObj[keylist.getItemAt(12)].toString();
         this.ucdispSeq.text = mapObj[keylist.getItemAt(13)].toString();
         this.uccalendar.text = mapObj[keylist.getItemAt(14)].toString();
         this.ucremarks.text = mapObj[keylist.getItemAt(15)].toString();
         this.ucdatasource.text = mapObj[keylist.getItemAt(16)].toString();
         this.ucpreferredfininstcodetype.text = mapObj[keylist.getItemAt(17)].toString();
         this.ucpreferredseccodetype.text = mapObj[keylist.getItemAt(18)].toString();
         this.ucpreferredaccnotype.text = mapObj[keylist.getItemAt(19)].toString();
      }
      override public function postCancelResultInit(mapObj:Object): void{
            commonResultPart(mapObj);
            finInstNameDetailList = mapObj[keylist.getItemAt(20)] as ArrayCollection;
        
            deliveryEaddressList = mapObj[keylist.getItemAt(22)] as ArrayCollection;
            deliveryEAddressRulesList = mapObj[keylist.getItemAt(21)] as ArrayCollection;
//            uConfLabel.text=this.parentApplication.xResourceManager.getKeyValue('ref.fininst.label.fininstcancel');
            uConfSubmit.includeInLayout = false;
            uConfSubmit.visible = false;
            cancelSubmit.visible = true;
            cancelSubmit.includeInLayout = true;
            
            focusManager.setFocus(cancelSubmit);
            app.submitButtonInstance = cancelSubmit;
            defaultBtn = cancelSubmit;
      }
      private function changeCurrentState():void{
        vstack.selectedIndex = 1;
      } 
     private function doBack():void{
        app.submitButtonInstance = submit;
        defaultBtn = submit;
        confirmPage = false;
        vstack.selectedIndex = 0;
     }  
     override public function postConfirmEntryResultHandler(mapObj:Object):void
     {
        submitUserConfResult(mapObj);
     }
     override public function postConfirmAmendResultHandler(mapObj:Object):void
     {
        submitUserConfResult(mapObj);
     }
     override public function postConfirmCancelResultHandler(mapObj:Object):void
     {
        if(submitUserConfResult(mapObj)){
        cancelSubmit.visible = false;
        cancelSubmit.includeInLayout = false;
        uCancelConfSubmit.visible = false;
        uCancelConfSubmit.includeInLayout = false;
        uConfLabel.includeInLayout = false;
        uConfLabel.visible = false;
        if(mode=="close"){
            var par:TitleWindow = TitleWindow(this.parent.parent);
            par.showCloseButton = false;
            par.invalidateDisplayList();
        } 
       } 
     }
     override public function preEntryConfirm():void
     {
        var reqObj :Object = new Object();
        super.getConfHttpService().url = "ref/finInstEntryDispatch.action?";  
        reqObj.method= "commit";
        super.getConfHttpService().request  =reqObj;
     }
     override public function preAmendConfirm():void
     {
        var reqObj :Object = new Object();
        super.getConfHttpService().url = "ref/finInstAmendDispatch.action?";  
        reqObj.method= "commit";
        super.getConfHttpService().request  =reqObj;
     }
     override public function preCancelConfirm():void
     {
        var reqObj :Object = new Object();
        super.getConfHttpService().url = "ref/finInstCloseDispatch.action?";  
        reqObj.method= "CommitCancel";
        super.getConfHttpService().request  =reqObj;
     }
     private function submitUserConfResult(mapObj:Object):Boolean{
        if(mapObj!=null){    
            if(mapObj["errorFlag"].toString() == "error"){
                //XenosAlert.error(mapObj["errorMsg"].toString());
                errPage1.showError(mapObj["errorMsg"]);
            }else if(mapObj["errorFlag"].toString() == "noError"){
                if(mode!="close")
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
               confirmPage = true;
               
               sysConfMessage.includeInLayout=true;   
               sysConfMessage.visible=true;
               focusManager.setFocus(sConfSubmit);
               app.submitButtonInstance = sConfSubmit;
               defaultBtn = sConfSubmit;
               //Disable the details and Eaddress buttons
               /* if(mode=="close"){
                var par:TitleWindow = TitleWindow(this.parent.parent);
                par.showCloseButton = false;
                par.invalidateDisplayList();
               }   */       
               return true;     
            }else{
                errPage.removeError();
                errPage1.removeError();
                XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('ref.msg.common.info.erroroccurred'));
            }           
        }
        return false;
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
        //Disable the details and Eaddress buttons
         /* ucdetails.enabled = true;
         uceaddressBtn.enabled = true; */
         vstack.selectedIndex = 0;  
         confirmPage = false;
         
         focusManager.setFocus(submit);
         app.submitButtonInstance = submit;
         defaultBtn = submit;
         super.postEntrySystemConfirm();
        
     }
     override public function doAmendSystemConfirm(e:Event):void
     {
        confirmPage = false;
        //this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
        app.submitButtonInstance = null;
        defaultBtn = null;
        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
     } 
     
     override public function doCancelSystemConfirm(e:Event):void
     {
        confirmPage = false;
        app.submitButtonInstance = null;
        this.parentDocument.dispatchEvent(new Event("OkSystemConfirm"));
        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
     } 
     override public function preResetEntry():void
     {
         var rndNo:Number= Math.random();
         super.getResetHttpService().url = "ref/finInstEntryDispatch.action?method=resetPage&rnd=" + rndNo; 
     }
     
     override public function preResetAmend():void
     {
         var rndNo:Number= Math.random();
         super.getResetHttpService().url = "ref/finInstAmendDispatch.action?method=resetFinInstRoleForAmend&rnd=" + rndNo; 
     }