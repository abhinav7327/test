

import com.nri.rui.core.controls.XenosAlert;
import com.nri.rui.core.utils.HiddenObject;
import com.nri.rui.core.utils.XenosStringUtils;
import com.nri.rui.ref.validators.AccountGeneralValidator;

import mx.collections.ArrayCollection;
import mx.events.ValidationResultEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;
   
private static var CP_INTERNAL:String="INTERNAL";
private static var CP_BANKCUST:String="BANK/CUSTODIAN";
private static var CP_BROKER:String="BROKER";

[Bindable]public var xml:XML;
[Bindable]private var urlModeBind:String="";
[Bindable]private var officeList:ArrayCollection=new ArrayCollection();
[Bindable]private var salesRoleList:ArrayCollection=new ArrayCollection();
[Bindable]private var instructionSendOfficeList:ArrayCollection=new ArrayCollection();
[Bindable]private var incomeEntitlementGenFlagList:ArrayCollection=new ArrayCollection();
[Bindable]private var stlInxOutputFormatList:ArrayCollection=new ArrayCollection();
[Bindable]private var bankAcTypeList:ArrayCollection=new ArrayCollection();
[Bindable]private var cpTypeList:ArrayCollection=new ArrayCollection();
[Bindable]private var actNoTypeList:ArrayCollection=new ArrayCollection();
[Bindable]private var accountCodeList:ArrayCollection=new ArrayCollection();
[Bindable]private var salesList:ArrayCollection=new ArrayCollection();
[Bindable]private var salesRoleReqd:Boolean = false;
[Bindable]private var brokerOgCodeInfo:ArrayCollection=new ArrayCollection();
[Bindable]private var tradeTypeCategoryList:ArrayCollection=new ArrayCollection();
[Bindable]private var treatyCodeList:ArrayCollection=new ArrayCollection();
[Bindable]private var formaRecreatedAllowedList:ArrayCollection;
[Bindable]private var cpDetailtype:String="";
[Bindable]private var counterpartyType:String="";
private var oldFininstCode:String="";
[Bindable]private var charsetCodeList:ArrayCollection=new ArrayCollection();
[Bindable]private var accXRefDetails:ArrayCollection=new ArrayCollection();
[Bindable]private var longShortFlagList:ArrayCollection;
[Bindable]public var returnContextItem:ArrayCollection = new ArrayCollection();
[Bindable]private var mt54xLoadReqdList:ArrayCollection;

private var concatenatedFinInstRoles:String="";
private var defaultAccountNoType:String="";
private var formARequired:String = XenosStringUtils.EMPTY_STR;
override public function populateRequest():Object{
	var reqObj:Object = new Object();
	reqObj.srcTabNo="1";
	reqObj.ctxSalesStatus="NORMAL";
	
	
	//Populate account basic info
	reqObj['otherAttributes.defaultAccountNo']=defaultAcNo.text;
	
	reqObj['account.fundCode']=fundCode.fundCode.text;
	reqObj['account.bankAccountType']=bankAcType.selectedItem.value;	
	reqObj['account.brokerCode']=fininstcode.finInstCode.text;
	
	reqObj['defaultBankAccountFlag']=defaultAcSelect.selected;
	reqObj['otherAttributes.serviceOffice']=serviceOffice.selectedLabel;
	
	
	//Populate default account name info
	reqObj['account.shortName']=actShortName.text ;	
	reqObj['account.officialName1']=actOffName1.text;
	reqObj['account.officialName2']=actOffName2.text;
	reqObj['account.officialName3']=actOffName3.text;
	reqObj['account.officialName4']=actOffName4.text;	
	
	//Populate basic attributes
	reqObj['account.residentCountry']=residentcountry.countryCode.text;
	reqObj['account.contractCountry']=contractcountry.countryCode.text;
	reqObj['account.nationality']=nationality.countryCode.text;
	reqObj['account.remarks1']=remarks1.text;
	reqObj['account.remarks2']=remarks2.text;
	reqObj['account.remarks3']=remarks3.text;
	reqObj['account.remarks4']=remarks4.text;
	reqObj['account.treatyCode']=treatyCode.selectedLabel;	
	reqObj['account.memo']=memo.text;
	reqObj['account.longShortFlag']= longShortFlag.selectedItem != null? longShortFlag.selectedItem.value:"";
	reqObj['account.primeBrokerAccountNo']=primeBrokerAccount.accountNo.text;
	
	
	if(cpDetailtype==CP_INTERNAL){
		/*Start XGA-107*/
		reqObj['account.instructionSendOffice']=instructionSendOffice.selectedItem != null? instructionSendOffice.selectedItem.toString():"";
		/*End XGA-107*/
		reqObj['account.incomeEntitlementGen']=incomeEntitlementGenFlag.selectedItem != null? incomeEntitlementGenFlag.selectedItem.value:"";
		reqObj['account.stlInxOutputFormat']=stlInxOutputFormat.selectedItem != null? stlInxOutputFormat.selectedItem.value:"";
		reqObj['account.formaRecreatedAllowed']=formaRecreatedAllowed.selectedItem.value;
		reqObj['account.mt54xLoadReqd'] = mt54xLoadReqd.selectedItem != null? mt54xLoadReqd.selectedItem.value:"";
		reqObj['tradeTypeAccountRolePage.tradeTypeCategoryArray']=tradetypeCategory.selectedItems;
	} else {
		reqObj['account.formaRecreatedAllowed']="";
	}	
	
	
	return reqObj;
}

override public function reset():void {
}

/* override public function set mode(modeStr:String):void{
	super.mode=modeStr;
	
	urlModeBind = XenosStringUtils.capitalize(modeStr);
} */

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
		//Control visibilty of fields on cpdetailType and mode
		setVisibility(xml);
		setURLModeBind(xml);
		try{
		errPage.removeError();
		}catch(e:Error){
		}
		cpDetailtype=xml.account.counterPartyDetailType.toString();
		counterpartyType=xml.account.counterPartyType.toString();
		
		concatenatedFinInstRoles=xml.concatenatedFinInstRoles.toString();
		this.fininstcode.recContextItem=populateFininstContext();
		
		var obj:Object=new Object();
		
		//Default account code properties
		cpTypeList.removeAll();
		for each(obj in xml.dropDownListValues.counterPartyDetailTypeList.item){
			cpTypeList.addItem(obj);
		}	
		cpType.selectedIndex=getIndexOfLabelValueBean(cpTypeList,cpDetailtype);
		
		fundCode.fundCode.text=xml.account.fundCode.toString();
		
		bankAcTypeList.removeAll();
		bankAcTypeList.addItem({label:"",value:""});
		for each(obj in xml.dropDownListValues.bankAccountTypeList.item){
			bankAcTypeList.addItem(obj);
		}	
		bankAcType.selectedIndex=getIndexOfLabelValueBean(bankAcTypeList,xml.account.bankAccountType.toString());
		
		fininstcode.finInstCode.text=xml.account.brokerCode.toString();
		
		oldFininstCode=xml.account.oldFinInstCode.toString();
		
		
		officeList.removeAll();
		officeList.addItem("");
		for each(obj in xml.dropDownListValues.serviceOfficeList.serviceOffice){
			officeList.addItem(obj.toString());
		}	
		serviceOffice.selectedIndex=getIndex(officeList,xml.otherAttributes.serviceOffice.toString());
		
		instructionSendOfficeList.removeAll();
		instructionSendOfficeList.addItem("");
		for each(obj in xml.dropDownListValues.instructionSendOfficeList.officeId){
			instructionSendOfficeList.addItem(obj.toString());
		}	
		instructionSendOffice.selectedIndex=getIndex(instructionSendOfficeList,xml.account.instructionSendOffice.toString());
		
		//Set Sales Role List
		salesRoleList.removeAll();
		salesRoleList.addItem("");
		for each(obj in xml.dropDownListValues.salesRoleList.salesRole){
			salesRoleList.addItem(obj.toString());
		}	
		salesRole.selectedIndex=getIndex(salesRoleList,xml.otherAttributes.salesRole.toString());
		
		instructionSendOfficeList.removeAll();
		instructionSendOfficeList.addItem("");
		for each(obj in xml.dropDownListValues.instructionSendOfficeList.officeId){
			instructionSendOfficeList.addItem(obj.toString());
		}	
		instructionSendOffice.selectedIndex=getIndex(instructionSendOfficeList,xml.account.instructionSendOffice.toString());
		
		//Set treat code list
		treatyCodeList.removeAll();
		treatyCodeList.addItem("");
		for each(obj in xml.dropDownListValues.treatyCodeList.treatyCode){
			treatyCodeList.addItem(obj.toString());
		}	
		treatyCode.selectedIndex=getIndex(treatyCodeList,xml.account.treatyCode.toString());
				
		
		//Account code info
		actNoTypeList.removeAll();	
		for each(obj in xml.dropDownListValues.accountNoTypeList.item){
			actNoTypeList.addItem(obj);
		}	
		
		defaultAccountNoType=xml.otherAttributes.defaultAccountNoType.toString();
		defaultAcNo.text=xml.otherAttributes.defaultAccountNo.toString();
		
		defaultAcSelect.selected=(xml.defaultBankAccountFlag.toString()=='true' || xml.defaultBankAccountFlag.toString()=='TRUE')?true:false;
		
		if(cpDetailtype==CP_INTERNAL){
			// Populate Income Entitlement Gen Flag List
			incomeEntitlementGenFlagList.removeAll();
			for each(obj in xml.dropDownListValues.incomeEntitlementGenFlagList.item){
				incomeEntitlementGenFlagList.addItem(obj);
			}	
			incomeEntitlementGenFlag.selectedIndex=getIndexOfLabelValueBean(incomeEntitlementGenFlagList,
											xml.account.incomeEntitlementGen);

			// Populate STL Instruction Output Format List
			stlInxOutputFormatList.removeAll();
			for each(obj in xml.dropDownListValues.stlInxOutputFormatList.item){
				stlInxOutputFormatList.addItem(obj);
			}	
			stlInxOutputFormat.selectedIndex=getIndexOfLabelValueBean(stlInxOutputFormatList,
											xml.account.stlInxOutputFormat);


			//populate the Long/Short Flag
			longShortFlagList = new ArrayCollection();
			for each(var xmlObj:XML in xml.dropDownListValues.longShortFlagList.item){
				longShortFlagList.addItem(xmlObj);
			}
			longShortFlag.selectedIndex = getIndexOfLabelValueBean(longShortFlagList, xml.account.longShortFlag);
			longShortFlagLabel.visible = true;			
            longShortFlagLabel.includeInLayout = true;
            longShortFlagValue.visible = true;			
            longShortFlagValue.includeInLayout = true;
			tradeTypeCategoryList.removeAll();
			tradeTypeCategoryList.addItem("");
			for each(obj in xml.dropDownListValues.tradeTypeCategoryList.tradeTypeCategory){
				tradeTypeCategoryList.addItem(obj);
			}	
			var tradeTypeSelectedIndex:Array=[];
			//Set selected trade type categories
			for each(obj in xml.tradeTypeAccountRolePage.tradeTypeCategory){
				for(var indx:int=0;indx<tradeTypeCategoryList.length;indx++){
					if(obj.toString()==tradeTypeCategoryList.getItemAt(indx).toString()){
						tradeTypeSelectedIndex.push(indx);						
					}
				}
			}
			tradetypeCategory.selectedIndices=tradeTypeSelectedIndex;
			
			//FormA Recreated Allowed List values
			formaRecreatedAllowedList = new ArrayCollection();
			formaRecreatedAllowedList.addItem({label:"",value:""});
			for each(obj in xml.dropDownListValues.formaRecreatedAllowedList.item){
				formaRecreatedAllowedList.addItem(obj);
			}	
			formaRecreatedAllowed.selectedIndex=getIndexOfLabelValueBean(formaRecreatedAllowedList,xml.account.formaRecreatedAllowed);
			
			//MT54X LOAD REQD List values
			mt54xLoadReqdList = new ArrayCollection();
			for each(obj in xml.dropDownListValues.mt54xLoadReqdList.item){
				mt54xLoadReqdList.addItem(obj);
			}	
			mt54xLoadReqd.selectedIndex = getIndexOfLabelValueBean(mt54xLoadReqdList , xml.account.mt54xLoadReqd);
			
			formARequired = xml.fund.formaRequired.toString();
			if( XenosStringUtils.equals("Y",formARequired)){
				formaRecreatedAllowed.enabled = true;
			}else{
				formaRecreatedAllowed.enabled = false;
				formaRecreatedAllowed.selectedIndex=getIndexOfLabelValueBean(formaRecreatedAllowedList,XenosStringUtils.EMPTY_STR);
			}
			primeBrokerAccount.accountNo.text = xml.account.primeBrokerAccountNo.toString();
			onChangeLongShortFlag();
			// for other CP type the long short flag should be hidden.
		} else {
			longShortFlagLabel.visible = false;			
            longShortFlagLabel.includeInLayout = false;
            longShortFlagValue.visible = false;			
            longShortFlagValue.includeInLayout = false;
            primeBrokerAccountId.includeInLayout = false;
            primeBrokerAccountId.visible = false;
		}
		
		//populate account code info grid
		accountCodeList.removeAll(); 
		try {				
		    for each ( var rec:XML in xml.otherAttributes.accountXrefDynaBeansWrapper.item) {
		    	if(XenosStringUtils.equals(xml.otherAttributes.defaultAccountNoType.toString(),
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
		
		//populate broker OG code
		if(cpDetailtype==CP_BROKER){
			brokerOgCodeInfo.removeAll(); 
			try {				
			   for each ( var rec:XML in xml.otherAttributes.brokerOgCodeDynaBeansWrapper.item) {
			   		rec.isVisible=true;		    	
	 			    brokerOgCodeInfo.addItem(rec);	    
			    }			    		   
	        	brokerOgCodeInfo.refresh();
			}catch(e:Error){
				trace(e);
			}		
		}
		
		//populate access info
		salesList.removeAll(); 
		try {				
		   for each ( var rec:XML in xml.otherAttributes.accountSalesDynaBeansWrapper.item) {
			 	rec.isVisible=true;
			 	salesList.addItem(rec);	
			}		    		   
        	salesList.refresh();
		}catch(e:Error){
			trace(e);
		}
		// Populate sales role reqd
		if (xml.hasOwnProperty("salesRoleReqd")) {
			salesRoleReqd = (XenosStringUtils.equals(xml.salesRoleReqd.toString(), "true"))? true:false;
		}
		
		//Populate default account name info
		actShortName.text= xml.account.shortName.toString();	
		actOffName1.text= xml.account.officialName1.toString();
		actOffName2.text= xml.account.officialName2.toString();
		actOffName3.text= xml.account.officialName3.toString();
		actOffName4.text= xml.account.officialName4.toString();
		
		//Populate basic attributes
		residentcountry.countryCode.text=xml.account.residentCountry.toString();
		contractcountry.countryCode.text=xml.account.contractCountry.toString();
		nationality.countryCode.text=xml.account.nationality.toString();
		remarks1.text=xml.account.remarks1.toString();
		remarks2.text=xml.account.remarks2.toString();
		remarks3.text=xml.account.remarks3.toString();
		remarks4.text=xml.account.remarks4.toString();
		//populating memo
		memo.text = xml.account.memo.toString();
		
		
		charsetCodeList.removeAll();
		charsetCodeList.addItem("");
		for each(obj in xml.dropDownListValues.charsetCodeList.charsetCode){
			charsetCodeList.addItem(obj.toString());
		}	
		languageCode.selectedIndex=getIndex(charsetCodeList,xml.accountNameXref.charsetCode.toString());
		
		accXRefDetails.removeAll();
		for each (var rec:XML in xml.otherAttributes.accountNameXrefDynaBeansWrapper.item) {
			 rec.isVisible=true;
 		     accXRefDetails.addItem(rec);
	  	}			  
          accessUserID.employeeText.text = xml.otherAttributes.accessUserId.toString();
          actNo.text = xml.otherAttributes.accountNo.toString();
}

override public function  validate():ValidationResultEvent{
	var validator:AccountGeneralValidator=new AccountGeneralValidator();
	var model:Object= populateRequest();
	model['cpType']=cpType;
	model['cpDetailType']=cpDetailtype;
	model['mode']=this.mode;
	return validator.validate(model);         	
	//return new ValidationResultEvent(ValidationResultEvent.VALID);
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
        if(cpDetailtype==CP_BANKCUST){
        	actStatusArray= new Array(3);
        	actStatusArray[0]="Security Broker";
        	actStatusArray[1]="Bank/Custodian";
        	actStatusArray[2]="Central Depository";
        }   
        else if(cpDetailtype==CP_BROKER){
        	actStatusArray= new Array(1);
        	actStatusArray[0]=concatenatedFinInstRoles;
        }      
       
                                    
        myContextList.addItem(new HiddenObject("bankRoles",actStatusArray));
        return myContextList;
}

private function doDefaultAccountAdd():void{
	var reqObj:Object=new Object();
	reqObj['otherAttributes.defaultAccountNo']=defaultAcNo.text;
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
			    for each ( var rec:XML in rs.otherAttributes.accountXrefDynaBeansWrapper.item) {
			    	if(XenosStringUtils.equals(rs.otherAttributes.defaultAccountNoType.toString(),
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
            	defaultAcNo.text=rs.otherAttributes.defaultAccountNo.toString();            	
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
	reqObj['editIndexAccountCode']=accountCodeList.getItemIndex(data);	
	editActCodeService.request=reqObj;
	editActCodeService.send(); 
}


public function deleteAccountNo(data:Object):void{
	var reqObj:Object=new Object();
	reqObj['editIndexAccountCode']=accountCodeList.getItemIndex(data);	
	deleteActCodeService.request=reqObj;
	deleteActCodeService.send()
}
private function accountNoAdd():void{
	if(XenosStringUtils.isBlank(actNo.text)){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.accno'));
	}
	else{
		var reqObj:Object=new Object();
		reqObj['otherAttributes.accountNoType']=actNoType.selectedItem.value.toString();
		reqObj['otherAttributes.accountNo']=actNo.text;
		addActCodeService.request=reqObj;
		addActCodeService.send();
	} 
}

private function accountNoSave():void{
	if(XenosStringUtils.isBlank(actNo.text)){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.accno'));
	}
	else{
		var reqObj:Object=new Object();
		reqObj['otherAttributes.accountNoType']=actNoType.selectedItem.value.toString();
		reqObj['otherAttributes.accountNo']=actNo.text;
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
 			   trace(error.toString()); 			   
			}
		 	errPage.showError(errorInfoList);//Display the error
		 }
		 else{		
			errPage.clearError(event);			
            accountCodeList.removeAll(); 
			try {				
			    for each ( var rec:XML in rs.otherAttributes.accountXrefDynaBeansWrapper.item) {
			    	if(XenosStringUtils.equals(rs.otherAttributes.defaultAccountNoType.toString(),
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
			    for each ( var rec:XML in rs.otherAttributes.accountXrefDynaBeansWrapper.item) {
			    	
			    	if(XenosStringUtils.equals(rs.otherAttributes.defaultAccountNoType.toString(),rec.entry.(@key=='accountNoType').value.toString())
			    					|| int(rs.editIndexAccountCode.toString())==i){
			    	
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
            	actNo.text=rs.otherAttributes.accountNo.toString();
            	actNoType.selectedIndex=getIndexOfLabelValueBean(actNoTypeList,rs.otherAttributes.accountNoType.toString());
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
	cpDetailtype=xml.account.counterPartyDetailType.toString();
	counterpartyType=xml.account.counterPartyType.toString();
	
	if(xml.account.defaultAccountFlag.toString()=='Y'){
		fundCode.enabled=false;
		fundCode.fundCode.text=xml.account.fundCode.toString();
		if(cpDetailtype==CP_BROKER){
			serviceOffice.enabled=true;
		}
		else{
			serviceOffice.enabled=false;
		}
		
	}else{
		serviceOffice.enabled=true;
		if(cpDetailtype==CP_INTERNAL){
			fundCode.enabled=false;
			fundCode.fundCode.text=xml.account.fundCode.toString();
		}
		else{
			fundCode.enabled=true;
			fundCode.fundCode.text=xml.account.fundCode.toString();
		}
	}
	
	if(counterpartyType!=CP_BROKER){
		bankAcTypeGrid.visible=false;
	}
	
	if(cpDetailtype==CP_BROKER){
		brokerOGCodeBox.visible=true;
		fundCodeGrid.visible=false;
		fundCodeGrid.includeInLayout=false;
		fininstLabel.text=this.parentApplication.xResourceManager.getKeyValue('ref.account.label.brokercode');
	}
	else{
		brokerOGCodeBox.visible=false;
		brokerOGCodeBox.includeInLayout=false;
	}
	if(cpDetailtype==CP_INTERNAL){
		tradetypegrid.visible=true;
		tradetypegrid.includeInLayout = true;
		fininstGrid.visible=false;
		formarecreatedallowedid.visible = true;	
		formarecreatedallowedid.includeInLayout=true;
	}
	
	if(cpDetailtype==CP_BANKCUST){
		this.serviceOfficeRow.includeInLayout = false;
		if(this.mode=="amend"){
			defaultAcFlagGrid.includeInLayout=true;
		}	
	}
	
	if(this.mode=="entry"){
		treatyCode.enabled=false;
	}
	else if(this.mode=="amend"){
		lastAcDateGrid.includeInLayout=true;
		if(cpDetailtype==CP_INTERNAL){
			treatyCode.enabled=false;
		}
	} 
	
	
	if(!(this.mode=="entry" || this.mode=="copy")){
		defaultAccountAdd.includeInLayout=false;
		defaultAccountAdd.visible=false;
		//trace("here1:"+this.mode);
	}
	//trace("mode***:"+this.mode);
	
	/* Start: XGA-107 "Office In charge of sending instruction" field is not required for BROKER and BANK/CUSTODIAN
    */
    /*
      XGA-422 Generate Income Entitlement Flag is also not required for BROKER and BANK/CUSTODIAN 
    */
	if(XenosStringUtils.equals(cpDetailtype, CP_INTERNAL)){
			attributesForFundOnly.includeInLayout=true;
			attributesForFundOnly.visible = true;
	}else{
		attributesForFundOnly.includeInLayout=false;
		attributesForFundOnly.visible = false;
	}
	/*End XGA-107*/
	
}

public function editSales(data:Object):void{
	var reqObj:Object=new Object();
	reqObj['editIndexAccountAccessInfo']=salesList.getItemIndex(data);	
	editSalesService.request=reqObj;
	editSalesService.send(); 
}


public function deleteSales(data:Object):void{
	var reqObj:Object=new Object();
	reqObj['editIndexAccountAccessInfo']=salesList.getItemIndex(data);	
	deleteSalesService.request=reqObj;
	deleteSalesService.send()
}
private function salesAdd():void{
	var userIdStr:String = accessUserID.employeeText.text;
	var salesRoleStr:String = salesRole.selectedItem != null? salesRole.selectedItem.toString() : "";
	var errStr:String = XenosStringUtils.EMPTY_STR;
	
	if(XenosStringUtils.isBlank(userIdStr)){
		//XenosAlert.error("User Id cannot be empty");
		errStr = errStr + "User Id cannot be empty.\n";
	}
	
	if(salesRoleReqd && XenosStringUtils.isBlank(salesRoleStr)){
		//XenosAlert.error("User Id cannot be empty");
		errStr = errStr + "Sales Role cannot be empty.";
	}
	
	if (!XenosStringUtils.isBlank(errStr)) {
		XenosAlert.error(errStr);
		return;
	}
	
	var reqObj:Object=new Object();		
	reqObj['otherAttributes.accessUserId']= userIdStr;
	reqObj['otherAttributes.salesRole']= salesRoleStr;
	addSalesService.request=reqObj;
	addSalesService.send();
	 
}

private function salesSave():void{
	
	var userIdStr:String = accessUserID.employeeText.text;
	var salesRoleStr:String = salesRole.selectedItem != null? salesRole.selectedItem.toString() : "";
	var errStr:String = XenosStringUtils.EMPTY_STR;
	
	if(XenosStringUtils.isBlank(userIdStr)){
		//XenosAlert.error("User Id cannot be empty");
		errStr = errStr + "User Id cannot be empty.\n";
	}
	
	if(salesRoleReqd && XenosStringUtils.isBlank(salesRoleStr)){
		//XenosAlert.error("User Id cannot be empty");
		errStr = errStr + "Sales Role cannot be empty.";
	}
	
	if (!XenosStringUtils.isBlank(errStr)) {
		XenosAlert.error(errStr);
		return;
	}
	
	var reqObj:Object=new Object();
	reqObj['otherAttributes.accessUserId']=accessUserID.employeeText.text;
	reqObj['otherAttributes.salesRole']= salesRole.selectedItem != null? salesRole.selectedItem.toString() : "";
	updateSalesService.request=reqObj;
	updateSalesService.send();
	 
}

public function salesCancel():void{
	var reqObj:Object=new Object();
	/* reqObj['editIndexAccountCode']=accountCodeList.getItemIndex(data);	
	deleteActCodeService.request=reqObj; */
	cancelSalesService.send()
}
private function addSalesResult(event:ResultEvent):void{
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
            salesList.removeAll(); 
			try {				
				var i:int=0;
			    for each ( var rec:XML in rs.otherAttributes.accountSalesDynaBeansWrapper.item) {
			    	
			    	if(int(rs.editIndexAccountAccessInfo.toString())==i){
			    	
			    		rec.isVisible=false;						 	
			 		}    	
			 		else
			 		{
			 			rec.isVisible=true;
			 		}
 				    salesList.addItem(rec); 	
 				    i++;	
 				    		    
			    }			    		   
            	salesList.refresh();
            	accessUserID.employeeText.text=rs.otherAttributes.accessUserId.toString();
            	salesRole.selectedIndex = getIndex(salesRoleList, rs.otherAttributes.salesRole.toString());
            	if(int(rs.editIndexAccountAccessInfo.toString())==-1){
			    	salesAddBtn.visible=true;
			    	salesCancelSave.visible=false;			    						 	
			 	} 
			 	else{
			 		//edit mode
			 		salesAddBtn.visible=false;
			    	salesCancelSave.visible=true;	
			 	}
            	
			}catch(e:Error){			    
			    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    }
		 } 
    }
}


public function editBrokerOG(data:Object):void{
	var reqObj:Object=new Object();
	reqObj['editIndexBrokerOgCode']=brokerOgCodeInfo.getItemIndex(data);	
	editBrokerOGCodeService.request=reqObj;
	editBrokerOGCodeService.send(); 
}


public function deleteBrokerOG(data:Object):void{
	var reqObj:Object=new Object();
	reqObj['editIndexBrokerOgCode']=brokerOgCodeInfo.getItemIndex(data);	
	deleteBrokerOGCodeService.request=reqObj;
	deleteBrokerOGCodeService.send()
}
private function brokerOGAdd():void{
	var brokerOGC:String=StringUtil.trim(brokerOGCode.text);
	if(serviceOffice.selectedLabel==""){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.order.serviceoffice'));
	}
	else if(XenosStringUtils.isBlank(brokerOGC)){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.brokerogcode'));
	}
	else{
		var reqObj:Object=new Object();		
		reqObj['otherAttributes.brokerOgCode']=brokerOGC;
		reqObj['otherAttributes.serviceOffice']=serviceOffice.selectedLabel;
		addBrokerOGCodeService.request=reqObj;
		addBrokerOGCodeService.send();
	} 
}

private function brokerOGSave():void{
	var brokerOGC:String=StringUtil.trim(brokerOGCode.text);
	if(serviceOffice.selectedLabel==""){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.order.serviceoffice'));
	}
	else if(XenosStringUtils.isBlank(brokerOGC)){
		XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('ref.account.msg.error.mandatory.brokerogcode'));
	}
	else{
		var reqObj:Object=new Object();
		reqObj['otherAttributes.brokerOgCode']=brokerOGC;
		reqObj['otherAttributes.serviceOffice']=serviceOffice.selectedLabel;
		updateBrokerOGCodeService.request=reqObj;
		updateBrokerOGCodeService.send(); 
	}
}

public function brokerOGCancel():void{
	var reqObj:Object=new Object();	
	cancelBrokerOGCodeService.send()
}
private function addBrokerOGCodeResult(event:ResultEvent):void{
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
            brokerOgCodeInfo.removeAll(); 
			try {				
				var i:int=0;
			    for each ( var rec:XML in rs.otherAttributes.brokerOgCodeDynaBeansWrapper.item) {
			    	
			    	if(int(rs.editIndexBrokerOgCode.toString())==i){
			    	
			    		rec.isVisible=false;						 	
			 		}    	
			 		else
			 		{
			 			rec.isVisible=true;
			 		}
 				    brokerOgCodeInfo.addItem(rec); 	
 				    i++;	
 				    		    
			    }			    		   
            	brokerOgCodeInfo.refresh();
            	brokerOGCode.text=rs.otherAttributes.brokerOgCode.toString();
            	if(int(rs.editIndexBrokerOgCode.toString())==-1){
			    	brokerOGAddBtn.visible=true;
			    	brokerOGCancelSave.visible=false;			    						 	
			 	} 
			 	else{
			 		//edit mode
			 		brokerOGAddBtn.visible=false;
			    	brokerOGCancelSave.visible=true;	
			 	}
            	
			}catch(e:Error){			    
			    XenosAlert.error(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
		    }
		 } 
    }
}


public function editActXRef(data:Object):void{
	var reqObj:Object=new Object();
	reqObj['editIndexNameXref']=accXRefDetails.getItemIndex(data);	
	editAcXrefService.request=reqObj;
	editAcXrefService.send(); 
}


public function deleteActXRef(data:Object):void{
	var reqObj:Object=new Object();
	reqObj['editIndexNameXref']=accXRefDetails.getItemIndex(data);	
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
		errMsg+="Official name 1st line cannot be empty\n";
	}
	if(!XenosStringUtils.isBlank(errMsg)){
		XenosAlert.error(errMsg);	
	}
	else{
		var reqObj:Object=new Object();		
		reqObj['accountNameXref.charsetCode']=charSetCode;
		reqObj['accountNameXref.shortName']=acShortName;
		reqObj['accountNameXref.officialName1']=offName1;
		reqObj['accountNameXref.officialName2']=actXrefOffName2.text;
		reqObj['accountNameXref.officialName3']=actXrefOffName3.text;
		reqObj['accountNameXref.officialName4']=actXrefOffName4.text;
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
		reqObj['accountNameXref.charsetCode']=charSetCode;
		reqObj['accountNameXref.shortName']=acShortName;
		reqObj['accountNameXref.officialName1']=offName1;
		reqObj['accountNameXref.officialName2']=actXrefOffName2.text;
		reqObj['accountNameXref.officialName3']=actXrefOffName3.text;
		reqObj['accountNameXref.officialName4']=actXrefOffName4.text;
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
			    for each ( var rec:XML in rs.otherAttributes.accountNameXrefDynaBeansWrapper.item) {
			    	if(int(rs.editIndexNameXref.toString())==i){
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
            	
            	languageCode.selectedIndex=getIndex(charsetCodeList,rs.accountNameXref.charsetCode.toString());
				actXrefShortName.text=rs.accountNameXref.shortName.toString();
				actXrefOffName1.text=rs.accountNameXref.officialName1.toString();
				actXrefOffName2.text=rs.accountNameXref.officialName2.toString();
				actXrefOffName3.text=rs.accountNameXref.officialName3.toString();
				actXrefOffName4.text=rs.accountNameXref.officialName4.toString();
				            	
            	if(int(rs.editIndexNameXref.toString())==-1){
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
/**
 * This method will be called on onchange event of  Long/Short Flag 
 */
  private function onChangeLongShortFlag():void
   {
	if(this.longShortFlag.selectedItem.value == "S"){
		this.primeBrokerAccountId.includeInLayout = true;
		this.primeBrokerAccountId.visible = true;
	} else {
		this.primeBrokerAccountId.includeInLayout = false;
		this.primeBrokerAccountId.visible = false;
		this.primeBrokerAccount.accountNo.text = "";
	}
} 
/**
      * This is the method to pass the Collection of data items
      * through the context to the account popup. This will be implemented as per specifdic  
      * requriment. 
      */
	  private function populatePrimeBrokerContext():ArrayCollection {
	        //pass the context data to the popup
	        var myContextList:ArrayCollection = new ArrayCollection(); 
	                  
	        //passing counter party type                
	        var cpTypeArray:Array = new Array(1);
	            cpTypeArray[0]="BROKER";
	        myContextList.addItem(new HiddenObject("invCPTypeContext",cpTypeArray));
	    
	        //passing account status                
            var actStatusArray:Array = new Array(1);
            actStatusArray[0]="OPEN";
            myContextList.addItem(new HiddenObject("actStatusContext",actStatusArray));
	        return myContextList;
	    } 


