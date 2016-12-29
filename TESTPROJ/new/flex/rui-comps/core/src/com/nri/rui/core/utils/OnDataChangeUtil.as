package com.nri.rui.core.utils
{
	import com.nri.rui.core.controls.XenosHTTPService;
	import mx.controls.Label;
	import com.nri.rui.core.controls.XenosErrors;
	import com.nri.rui.core.controls.XenosAsynchronousRequestProcessor;
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	
	public final class OnDataChangeUtil
	{
		//private static var _service:XenosHTTPService = null;
		
		public function OnDataChangeUtil()
		{
			//TODO: implement function
		}
		
		public static function onChangeAccountNo(accountName:UIComponent,accountNo:String):void{
	    	if(XenosStringUtils.isBlank(accountNo)){
	    		if(accountName is TextInput)
	    			TextInput(accountName).text = "";
	    		else
	    			Label(accountName).text = "";
	    		//errPage.removeErrorWithKey("accountName");
	    		return;
	    	}
	    	var reqObj:Object = new Object();
	    	reqObj.method = "displayAccountName";
	    	reqObj.accountNumber = accountNo;
	    	var _service:XenosHTTPService = OnDataChangeUtil.configureService();
	    	_service.request = reqObj;
	    	var asyncReqProc:XenosAsynchronousRequestProcessor = new XenosAsynchronousRequestProcessor(_service);
	    	asyncReqProc.processRequest("accountName",accountName);
	    }
	    
	    public static function onChangeFundAccountNo(accountName:UIComponent,accountNo:String):void{
	    	if(XenosStringUtils.isBlank(accountNo)){
	    		if(accountName is TextInput)
	    			TextInput(accountName).text = "";
	    		else
	    			Label(accountName).text = "";
	    		//errPage.removeErrorWithKey("accountName");
	    		return;
	    	}
	    	var reqObj:Object = new Object();
	    	reqObj.method = "displayFundAccountName";
	    	reqObj.fundAccountNumber = accountNo;
	    	var _service:XenosHTTPService = OnDataChangeUtil.configureService();
	    	_service.request = reqObj;
	    	var asyncReqProc:XenosAsynchronousRequestProcessor = new XenosAsynchronousRequestProcessor(_service);
	    	asyncReqProc.processRequest("fundAccountName",accountName);
	    }
	    
	     public static function onChangeFundCode(fundName:UIComponent,fundCode:String):void{
	    	if(XenosStringUtils.isBlank(fundCode)){
	    		if(fundName is TextInput)
	    			TextInput(fundName).text = "";
	    		else
	    			Label(fundName).text = "";
	    		return;
	    	}
	    	var reqObj:Object = new Object();
	    	reqObj.method = "displayFundName";
	    	reqObj.fundCode = fundCode;
	    	var _service:XenosHTTPService = OnDataChangeUtil.configureService();
	    	_service.request = reqObj;
	    	var asyncReqProc:XenosAsynchronousRequestProcessor = new XenosAsynchronousRequestProcessor(_service);
	    	asyncReqProc.processRequest("fundName",fundName);
	    } 
	    
	    public static function onChangeSecurityCode(securityName:UIComponent,securityCode:String):void{
	    	if(XenosStringUtils.isBlank(securityCode)){
	    		if(securityName is TextInput)
	    			TextInput(securityName).text = "";
	    		else
	    			Label(securityName).text = "";
	    		//errPage.removeErrorWithKey("securityName");
	    		return;
	    	}
	    	var reqObj:Object = new Object();
	    	reqObj.method = "displaySecurityName";
	    	reqObj.securityCode = securityCode;
	    	var _service:XenosHTTPService = OnDataChangeUtil.configureService();
	    	_service.request = reqObj;
	    	var asyncReqProc:XenosAsynchronousRequestProcessor = new XenosAsynchronousRequestProcessor(_service);
	    	asyncReqProc.processRequest("securityName",securityName);
	    }
	    
	    public static function onChangeBankCode(bankName:UIComponent,bankCode:String):void{
	    	if(XenosStringUtils.isBlank(bankCode)){
	    		if(bankName is TextInput)
	    			TextInput(bankName).text = "";
	    		else
	    			Label(bankName).text = "";
	    		//errPage.removeErrorWithKey("securityName");
	    		return;
	    	}
	    	var reqObj:Object = new Object();
	    	reqObj.method = "displayFinInstName";
	    	reqObj.bankCode = bankCode;
	    	var _service:XenosHTTPService = OnDataChangeUtil.configureService();
	    	_service.request = reqObj;
	    	var asyncReqProc:XenosAsynchronousRequestProcessor = new XenosAsynchronousRequestProcessor(_service);
	    	asyncReqProc.processRequest("bankName",bankName);
	    }
	    
	    public static function configureService():XenosHTTPService{
	    	//if(_service == null)
	    	var _service:XenosHTTPService = new XenosHTTPService();
	    	_service.url = "ref/accountInfoQuery.action?";
	    	_service.useProxy = false;
	    	_service.method = "POST";
	    	_service.concurrency = "multiple";
	    	_service.showBusyCursor = true;
	    	_service.resultFormat = "xml";
	    	return _service;
	    }

	}
}