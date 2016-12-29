

import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.XenosStringUtils;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.events.FlexEvent;
import mx.events.ValidationResultEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;
import com.nri.rui.ref.validators.AccountCustodianValidator;
//import com.nri.rui.ref.validators.AccountCustodianValidator;
   
private static var CP_INTERNAL:String="INTERNAL";
private static var CP_BANKCUST:String="BANK/CUSTODIAN";
private static var CP_BROKER:String="BROKER";

[Bindable]public var xml:XML;
[Bindable]private var urlModeBind:String="";
[Bindable]private var bankAcTypeList:ArrayCollection=new ArrayCollection();

[Bindable]private var actNoTypeList:ArrayCollection=new ArrayCollection();
[Bindable]private var accountCodeList:ArrayCollection=new ArrayCollection();

[Bindable]private var tradeTypeCategoryList:ArrayCollection=new ArrayCollection();
[Bindable]private var charsetCodeList:ArrayCollection=new ArrayCollection();
[Bindable]private var accXRefDetails:ArrayCollection=new ArrayCollection();

[Bindable]private var cpDetailtype:String="";
[Bindable]private var counterpartyType:String="";
private var oldFininstCode:String="";
private var custPage:accountCustodianConfirmation;

private var concatenatedFinInstRoles:String="";
private var defaultAccountNoType:String="";
override public function populateRequest():Object{
	var reqObj:Object = new Object();
	reqObj.srcTabNo="10";
	
	
	
	//Populate account basic info
	reqObj['bankAccountOtherAttributes.defaultAccountNo']=defaultAcNo.text;
	
	//reqObj['bankAccount.fundCode']=fundCode.text;
	reqObj['bankAccount.bankAccountType']=bankAcType.selectedItem.value;	
	reqObj['bankAccount.brokerCode']=fininstcode.finInstCode.text;
	
	reqObj['defaultBankAccountFlag']=defaultAcSelect.selected;

	
	//Populate default account name info
	reqObj['bankAccount.shortName']=actShortName.text ;	
	reqObj['bankAccount.officialName1']=actOffName1.text;
	reqObj['bankAccount.officialName2']=actOffName2.text;
	reqObj['bankAccount.officialName3']=actOffName3.text;
	reqObj['bankAccount.officialName4']=actOffName4.text;	
	
	//Populate basic attributes
	reqObj['bankAccount.residentCountry']=residentcountry.countryCode.text;
	reqObj['bankAccount.contractCountry']=contractcountry.countryCode.text;
	reqObj['bankAccount.nationality']=nationality.countryCode.text;
	reqObj['bankAccount.remarks1']=remarks1.text;
	reqObj['bankAccount.remarks2']=remarks2.text;
	reqObj['bankAccount.remarks3']=remarks3.text;
	reqObj['bankAccount.remarks4']=remarks4.text;
	reqObj['bankAccount.memo']=memo.text;
	
	
	
	
	return reqObj;
}

override public function reset():void {
}

/*  override public function set mode(modeStr:String):void{
	super.mode=modeStr;
	
	 if(modeStr=="amend"){
		urlModeBind="Amend";
	}
	else if(modeStr=="entry"){
		urlModeBind="Entry";
	} 
} 
 */
 
/**
 *  Set the url of the dispatch action according to mode,cp detail type and flags
 * */
public function setURLModeBind(xmlObj:XML):void{
	var cpDetailtype:String=xmlObj.account.counterPartyDetailType.toString();
	var counterpartyType:String=xmlObj.account.counterPartyType.toString();
	var reOpenFlag:String=xmlObj.reopenFlag.toString();
	var fromImFundAccountInit:String=xmlObj.fromImFundAccountInit.toString();
	
	if(this.mode=="entry"){
		if(cpDetailtype==CP_INTERNAL){
			urlModeBind="FundEntry";
		}
		else if(cpDetailtype==CP_BANKCUST){
			urlModeBind="BankCustodianEntry";
		}
		else if(cpDetailtype==CP_BROKER){
			urlModeBind="BrokerEntry";
		}
	}
	else if(this.mode=="amend"){
		if(reOpenFlag=="true"){
			urlModeBind="Reopen";
		}
		else{
			urlModeBind="Amend";
		}
	}	
	else if(this.mode=="copy"){
		if(fromImFundAccountInit=="true"){
			urlModeBind="IMEntry";
		}
		else{
			urlModeBind="Copy";
		}		
	}
}

override public function initPage(response:XML):void {

	xml = response as XML;
	/* try
	{ */
	
		try{
			errPage.removeError();
		}
		catch(e:Error){
			
		}
		//Control visibilty of fields on cpdetailType and mode		
		setVisibility(xml);
		setURLModeBind(xml);
		
		cpDetailtype=xml.bankAccount.counterPartyDetailType.toString();
		counterpartyType=xml.bankAccount.counterPartyType.toString();
		
		
		concatenatedFinInstRoles=xml.concatenatedFinInstRoles.toString();
		this.fininstcode.recContextItem=populateFininstContext();
		
		var obj:Object=new Object();
		
		//populate default code info
		cpType.text=cpDetailtype;
		fundCode.text=xml.bankAccount.fundCode.toString();
		
		
		bankAcTypeList.removeAll();
		bankAcTypeList.addItem({label:"",value:""});
		for each(obj in xml.dropDownListValues.bankAccountTypeList.item){
			bankAcTypeList.addItem(obj);
		}	
		bankAcType.selectedIndex=getIndexOfLabelValueBean(bankAcTypeList,xml.bankAccount.bankAccountType.toString());
		
		defaultAccountNoType=xml.bankAccountOtherAttributes.defaultAccountNoType.toString();
		defaultAcNo.text=xml.bankAccountOtherAttributes.defaultAccountNo.toString();
		
		fininstcode.finInstCode.text=xml.bankAccount.brokerCode.toString();
		
		oldFininstCode=xml.bankAccount.oldFinInstCode.toString();
		
		defaultAcSelect.selected=(xml.defaultBankAccountFlag.toString()=='true' || xml.defaultBankAccountFlag.toString()=='TRUE')?true:false;
		showAccountNoPopUp();
		
		//Account code info
		actNoTypeList.removeAll();	
		for each(obj in xml.dropDownListValues.accountNoTypeList.item){
			actNoTypeList.addItem(obj);
		}	
						
				
		//populate account code info grid
		accountCodeList.removeAll(); 
		try {				
		    for each ( var rec:XML in xml.bankAccountOtherAttributes.accountXrefDynaBeansWrapper.item) {
		    	if(XenosStringUtils.equals(xml.bankAccountOtherAttributes.defaultAccountNoType.toString(),
		    							 rec.entry.(@key=='accountNoType').value.toString())){		    	
		    		rec.isVisible=false;						 	
		 		}    	
		 		else
		 		{
		 			rec.isVisible=true;
		 		}
 			    accountCodeList.addItem(rec); 
		    }			    		   
        	accountCodeList.refresh();
		}catch(e:Error){
			trace(e);
		}
		
		
		//Populate default account name info
		actShortName.text= xml.bankAccount.shortName.toString();	
		actOffName1.text= xml.bankAccount.officialName1.toString();
		actOffName2.text= xml.bankAccount.officialName2.toString();
		actOffName3.text= xml.bankAccount.officialName3.toString();
		actOffName4.text= xml.bankAccount.officialName4.toString();
		
		//Populate basic attributes
		residentcountry.countryCode.text=xml.bankAccount.residentCountry.toString();
		contractcountry.countryCode.text=xml.bankAccount.contractCountry.toString();
		nationality.countryCode.text=xml.bankAccount.nationality.toString();		
		remarks1.text=xml.bankAccount.remarks1.toString();
		remarks2.text=xml.bankAccount.remarks2.toString();
		remarks3.text=xml.bankAccount.remarks3.toString();
		remarks4.text=xml.bankAccount.remarks4.toString();
		memo.text = xml.bankAccount.memo.toString();
		
		charsetCodeList.removeAll();
		charsetCodeList.addItem("");
		for each(obj in xml.dropDownListValues.charsetCodeList.charsetCode){
			charsetCodeList.addItem(obj.toString());
		}	
		languageCode.selectedIndex=getIndex(charsetCodeList,xml.bankAccountNameXref.charsetCode.toString());
		
		accXRefDetails.removeAll();
		for each (var rec:XML in xml.bankAccountOtherAttributes.accountNameXrefDynaBeansWrapper.item) {
			 rec.isVisible=true;
 		     accXRefDetails.addItem(rec);
	  	}			  
	/* }
	catch(e:Error){
		trace(e);	
	} */
	
}

override public function  validate():ValidationResultEvent{
	
	var validator:AccountCustodianValidator=new AccountCustodianValidator();
	var model:Object= populateRequest();
	model['cpType']=cpType;
	model['cpDetailType']=cpDetailtype;
	model['mode']=this.mode;
	return validator.validate(model);          	
	return new ValidationResultEvent(ValidationResultEvent.VALID);
}

/**
 * Calculates the index of a label value bean given its value, within a given 
 * array collection of such beans.
 * Returns 0 if the value is null or empty string.
 */
private function getIndexOfLabelValueBean(collection:ArrayCollection, value:String):int {
	var index:int = 0;
	if (value == null || value == XenosStringUtils.EMPTY_STR) {
		return index;
	}
	for (var count:int = 0; count < collection.length; count++) {
		var bean:Object = collection.getItemAt(count);
		if (bean['value'] == value) {
			index = count;
			break;
		}
	}
	return index;
}

/**
 * Calculates the index of an item, within a given 
 * array collection.
 * Returns 0 if the value is null or empty string.
 */
private function getIndex(collection:ArrayCollection, value:String):int {
	var index:int = 0;
	if (value == null || value == XenosStringUtils.EMPTY_STR) {
		return index;
	}
	for (var count:int = 0; count < collection.length; count++) {
		if (String(collection.getItemAt(count)) == value) {
			index = count;
			break;
		}
	}
	return index;
}

private function populateFininstContext():ArrayCollection {
        //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection();  
         var actStatusArray:Array=[];    
        //passing counter party type       
       
    	actStatusArray= new Array(3);
    	actStatusArray[0]="Security Broker";
    	actStatusArray[1]="Bank/Custodian";
    	actStatusArray[2]="Central Depository";
        myContextList.addItem(new HiddenObject("bankRoles",actStatusArray));
        return myContextList;
}

private function doDefaultAccountAdd():void{
	var reqObj:Object=new Object();
	reqObj['bankAccountOtherAttributes.defaultAccountNo']=defaultAcNo.text;
	addDefaultActService.request=reqObj;
	addDefaultActService.send();
}

private function addDefaultActServiceResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if (null != event) {
		 if(rs.child("Errors").length()>0) {
           	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
			}
		 	errPage.showError(errorInfoList);//Display the error
		 }
		 else{		
			errPage.clearError(event);			
            accountCodeList.removeAll(); 
			try {				
			    for each ( var rec:XML in rs.bankAccountOtherAttributes.accountXrefDynaBeansWrapper.item) {
			    	if(XenosStringUtils.equals(rs.bankAccountOtherAttributes.defaultAccountNoType.toString(),
			    							 rec.entry.(@key=='accountNoType').value.toString())){
			    	
			    		rec.isVisible=false;						 	
			 		}    	
			 		else
			 		{
			 			rec.isVisible=true;
			 		}
 				    accountCodeList.addItem(rec); 		
 				    		    
			    }			    
			    			    		   
            	accountCodeList.refresh();
            	defaultAcNo.text=rs.bankAccountOtherAttributes.defaultAccountNo.toString();            	
            	accountAdd.visible=true;
            	actCancelSave.includeInLayout=false;
            	actCancelSave.visible=false;
			}catch(e:Error){			    
			    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    }
		 } 
    }
}

public function editAccountNo(data:Object):void{
	var reqObj:Object=new Object();
	reqObj['editIndexBankAccountCode']=accountCodeList.getItemIndex(data);	
	editActCodeService.request=reqObj;
	editActCodeService.send(); 
}


public function deleteAccountNo(data:Object):void{
	var reqObj:Object=new Object();
	reqObj['editIndexBankAccountCode']=accountCodeList.getItemIndex(data);	
	deleteActCodeService.request=reqObj;
	deleteActCodeService.send()
}
private function accountNoAdd():void{
	if(XenosStringUtils.isBlank(StringUtil.trim(actNo.text))){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.accno'));
	}
	else{
		var reqObj:Object=new Object();
		reqObj['bankAccountOtherAttributes.accountNoType']=actNoType.selectedItem.value.toString();
		reqObj['bankAccountOtherAttributes.accountNo']=actNo.text;
		addActCodeService.request=reqObj;
		addActCodeService.send();
	} 
}

private function accountNoSave():void{
	if(XenosStringUtils.isBlank(StringUtil.trim(actNo.text))){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.accno'));
	}
	else{
		var reqObj:Object=new Object();
		reqObj['bankAccountOtherAttributes.accountNoType']=actNoType.selectedItem.value.toString();
		reqObj['bankAccountOtherAttributes.accountNo']=actNo.text;
		updateActCodeService.request=reqObj;
		updateActCodeService.send(); 
	}
}

public function accountNoCancel():void{
	var reqObj:Object=new Object();
	/* reqObj['editIndexAccountCode']=accountCodeList.getItemIndex(data);	
	deleteActCodeService.request=reqObj; */
	cancelActCodeService.send()
}
private function addActCodeServiceResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if (null != event) {
		 if(rs.child("Errors").length()>0) {
           	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString());
 			   			   
			}
		 	errPage.showError(errorInfoList);//Display the error
		 }
		 else{		
			errPage.clearError(event);			
            accountCodeList.removeAll(); 
			try {				
			    for each ( var rec:XML in rs.bankAccountOtherAttributes.accountXrefDynaBeansWrapper.item) {
			    	if(XenosStringUtils.equals(rs.bankAccountOtherAttributes.defaultAccountNoType.toString(),
			    							 rec.entry.(@key=='accountNoType').value.toString())){
			    	
			    		rec.isVisible=false;						 	
			 		}    	
			 		else
			 		{
			 			rec.isVisible=true;
			 		}
 				    accountCodeList.addItem(rec); 		
 				    		    
			    }			    		   
            	accountCodeList.refresh();
            	actNo.text="";
            	actNoType.selectedIndex=0;
            	accountAdd.visible=true;
            	actCancelSave.includeInLayout=false;
            	actCancelSave.visible=false;
			}catch(e:Error){			    
			    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    }
		 } 
    }
}
private function editActCodeServiceResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if (null != event) {
		 if(rs.child("Errors").length()>0) {
           	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString()); 			   
			}
		 	errPage.showError(errorInfoList);//Display the error
		 }
		 else{		
			errPage.clearError(event);			
            accountCodeList.removeAll(); 
			try {				
				var i:int=0;
			    for each ( var rec:XML in rs.bankAccountOtherAttributes.accountXrefDynaBeansWrapper.item) {
			    	
			    	if(XenosStringUtils.equals(rs.bankAccountOtherAttributes.defaultAccountNoType.toString(),rec.entry.(@key=='accountNoType').value.toString())
			    					|| int(rs.editIndexBankAccountCode.toString())==i){
			    	
			    		rec.isVisible=false;						 	
			 		}    	
			 		else
			 		{
			 			rec.isVisible=true;
			 		}
 				    accountCodeList.addItem(rec); 	
 				    i++;	
 				    		    
			    }			    		   
            	accountCodeList.refresh();
            	actNo.text=rs.bankAccountOtherAttributes.accountNo.toString();
            	actNoType.selectedIndex=getIndexOfLabelValueBean(actNoTypeList,rs.bankAccountOtherAttributes.accountNoType.toString());
            	accountAdd.visible=false;
            	actCancelSave.includeInLayout=true;
            	actCancelSave.visible=true;
			}catch(e:Error){			    
			    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    }
		 } 
    }
}

public function AccNameInfoDetails():void{

	if(DgDetails.visible==false){	
		if(validateBankAccountNameDetail()){		    	    
			DgDetails.visible=true;
		}
	}else{
		DgDetails.visible=false;    		
	}
}

private function validateBankAccountNameDetail():Boolean
{    
   var acShortName:String=StringUtil.trim(actShortName.text);
   var offName1:String=StringUtil.trim(actOffName1.text);
   var errMsg:String="";
	
	if(XenosStringUtils.isBlank(acShortName)){
		errMsg+="Short Name cannot be empty\n";
	}
	if(XenosStringUtils.isBlank(offName1)){
		errMsg+="Official Name 1st line cannot be empty\n";
	}
	if(!XenosStringUtils.isBlank(errMsg)){
		XenosAlert.error(errMsg);	
		return false;
	}
	else{
		return true
	}
}

private function setVisibility(xml:XML):void{
	trace("mode***:"+this.mode);
	
	cpDetailtype=xml.bankAccount.counterPartyDetailType.toString();
	counterpartyType=xml.bankAccount.counterPartyType.toString();
	
	if(counterpartyType==CP_BROKER){
		bankAcTypeGrid.visible=true;
	}
	else{
		bankAcTypeGrid.visible=false;
	}
	if(this.mode=="amend"){
		
		if(xml.account.defaultAccountFlag == "Y"){
			lastAcGrid.includeInLayout=true;
			defaultAcFlagGrid.includeInLayout=true
			defaultAccountAdd.includeInLayout=false;	
			actPopup.includeInLayout=true;	
			actPopup.accountNo.text=xml.bankAccountOtherAttributes.defaultAccountNo.toString();
			actPopup.accountNo.editable=false;
			actPopup.accountNo.addEventListener(FlexEvent.VALUE_COMMIT,defaultAcNoChange);
		}else{
			changeView();
		}
	}
	else  if(this.mode=="entry"){
		defaultAccountAdd.includeInLayout=true;		
		actPopup.includeInLayout=false;
	}else if(this.mode=="copy"){
			if(xml.account.defaultAccountFlag == "Y"){
				defaultAccountAdd.includeInLayout=true;		
				actPopup.includeInLayout=false;
			}else{
				changeView();
			}
	}
	
}

private function changeView():void{
	LMView.includeInLayout = false;
	LMView.visible = false;
	custPage = new accountCustodianConfirmation();
	custPage.setXml = xml;
	IMView.addChild(custPage);
}
private function showAccountNoPopUp():void{
	if(this.mode=="amend"){
		if(!defaultAcSelect.selected){
			actPopup.accountPopup.visible=true;
			actPopup.recContextItem=setCtxOfBankAccountNo();
		}
		else{
			actPopup.accountPopup.visible=false;
		}
	}
	
}
private function setCtxOfBankAccountNo():ArrayCollection{
	  //pass the context data to the popup
        var myContextList:ArrayCollection = new ArrayCollection(); 
               
    	var stlCPTypeContext:Array= new Array(1);
    	stlCPTypeContext[0]="BANK/CUSTODIAN";
    	
    	var fundCodeContext:Array= new Array(1);
    	fundCodeContext[0]=fundCode.text;
    	
        myContextList.addItem(new HiddenObject("stlCPTypeContext",stlCPTypeContext));
        myContextList.addItem(new HiddenObject("fundCodeContext",fundCodeContext));
        return myContextList;
}

private function defaultAcNoChange(e:Event):void{
	//Send loadExistingBankAccountAsDefaultBankAccount service
	var reqObj:Object=new Object();
	reqObj['bankAccountOtherAttributes.defaultAccountNo']=actPopup.accountNo.text;
	loadExistingBankAccountAsDefaultBankAccountService.request=reqObj;
	loadExistingBankAccountAsDefaultBankAccountService.send();
}


private function loadExistingBankAcResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if (null != event) {
		 if(rs.child("Errors").length()>0) {
           	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString()); 			   
			}
		 	errPage.showError(errorInfoList);//Display the error
		 }
		 else{	
		 	
			try{	
				errPage.clearError(event);			
	           	initPage(rs);
			}catch(e:Error){			    
			    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    }
		 } 
    }
}

public function editActXRef(data:Object):void{
	var reqObj:Object=new Object();
	reqObj['editIndexBankAccountNameXref']=accXRefDetails.getItemIndex(data);	
	editAcXrefService.request=reqObj;
	editAcXrefService.send(); 
}


public function deleteActXRef(data:Object):void{
	var reqObj:Object=new Object();
	reqObj['editIndexBankAccountNameXref']=accXRefDetails.getItemIndex(data);	
	deleteAcXrefService.request=reqObj;
	deleteAcXrefService.send()
}
private function ActXRefAdd():void{
	var charSetCode:String=StringUtil.trim(languageCode.selectedLabel);
	var acShortName:String=StringUtil.trim(actXrefShortName.text);
	var offName1:String=StringUtil.trim(actXrefOffName1.text);
	var errMsg:String="";
	if(XenosStringUtils.isBlank(charSetCode)){
		errMsg+="Charset code cannot be empty\n";
	}
	if(XenosStringUtils.isBlank(acShortName)){
		errMsg+="Short Name cannot be empty\n";
	}
	if(XenosStringUtils.isBlank(offName1)){
		errMsg+="Official Name 1st line cannot be empty\n";
	}
	if(!XenosStringUtils.isBlank(errMsg)){
		XenosAlert.error(errMsg);	
	}
	else{
		var reqObj:Object=new Object();		
		reqObj['bankAccountNameXref.charsetCode']=charSetCode;
		reqObj['bankAccountNameXref.shortName']=acShortName;
		reqObj['bankAccountNameXref.officialName1']=offName1;
		reqObj['bankAccountNameXref.officialName2']=actXrefOffName2.text;
		reqObj['bankAccountNameXref.officialName3']=actXrefOffName3.text;
		reqObj['bankAccountNameXref.officialName4']=actXrefOffName4.text;
		addAcXrefService.request=reqObj;
		addAcXrefService.send();
	} 
}

private function ActXRefSave():void{
	var charSetCode:String=StringUtil.trim(languageCode.selectedLabel);
	var acShortName:String=StringUtil.trim(actXrefShortName.text);
	var offName1:String=StringUtil.trim(actXrefOffName1.text);
	var errMsg:String="";
	if(XenosStringUtils.isBlank(charSetCode)){
		errMsg+="Charset code cannot be empty\n";
	}
	if(XenosStringUtils.isBlank(acShortName)){
		errMsg+="Short Name cannot be empty\n";
	}
	if(XenosStringUtils.isBlank(offName1)){
		errMsg+="Official name 1st line cannot be empty\n";
	}
	if(!XenosStringUtils.isBlank(errMsg)){
		XenosAlert.error(errMsg);	
	}
	else{
		var reqObj:Object=new Object();		
		reqObj['bankAccountNameXref.charsetCode']=charSetCode;
		reqObj['bankAccountNameXref.shortName']=acShortName;
		reqObj['bankAccountNameXref.officialName1']=offName1;
		reqObj['bankAccountNameXref.officialName2']=actXrefOffName2.text;
		reqObj['bankAccountNameXref.officialName3']=actXrefOffName3.text;
		reqObj['bankAccountNameXref.officialName4']=actXrefOffName4.text;
		updateAcXrefService.request=reqObj;
		updateAcXrefService.send();
	} 
}

public function ActXRefCancel():void{
	var reqObj:Object=new Object();	
	cancelAcXrefService.send()
}

private function addNameXrefDetailResult(event:ResultEvent):void{
	var rs:XML = XML(event.result);
	if (null != rs) {
		 if(rs.child("Errors").length()>0) {
           	var errorInfoList : ArrayCollection = new ArrayCollection();
            //populate the error info list 			 	
		 	for each ( var error:XML in rs.Errors.error ) {
 			   errorInfoList.addItem(error.toString()); 			   
			}
		 	errPage.showError(errorInfoList);//Display the error
		 }
		 else{		
			errPage.clearError(event);			
            accXRefDetails.removeAll(); 
			try {				
				var i:int=0;
			    for each ( var rec:XML in rs.bankAccountOtherAttributes.accountNameXrefDynaBeansWrapper.item) {
			    	if(int(rs.editIndexBankAccountNameXref.toString())==i){
			    		rec.isVisible=false;						 	
			 		}    	
			 		else
			 		{
			 			rec.isVisible=true;
			 		}
 				    accXRefDetails.addItem(rec); 	
 				    i++;	
 				    		    
			    }			    		   
            	accXRefDetails.refresh();
            	
            	languageCode.selectedIndex=getIndex(charsetCodeList,rs.bankAccountNameXref.charsetCode.toString());
				actXrefShortName.text=rs.bankAccountNameXref.shortName.toString();
				actXrefOffName1.text=rs.bankAccountNameXref.officialName1.toString();
				actXrefOffName2.text=rs.bankAccountNameXref.officialName2.toString();
				actXrefOffName3.text=rs.bankAccountNameXref.officialName3.toString();
				actXrefOffName4.text=rs.bankAccountNameXref.officialName4.toString();
				            	
            	if(int(rs.editIndexBankAccountNameXref.toString())==-1){
			    	ActXRefAddBtn.visible=true;
			    	ActXRefCancelSave.visible=false;			    						 	
			 	} 
			 	else{
			 		//edit mode
			 		ActXRefAddBtn.visible=false;
			    	ActXRefCancelSave.visible=true;	
			 	}
            	
			}catch(e:Error){			    
			    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    }
		 } 
    }
}
