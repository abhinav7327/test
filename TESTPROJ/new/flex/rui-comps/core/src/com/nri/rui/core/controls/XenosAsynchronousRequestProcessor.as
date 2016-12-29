package com.nri.rui.core.controls
{
	import mx.core.UIComponent;
	import mx.rpc.events.ResultEvent;
	import mx.collections.ArrayCollection;
	import mx.controls.Label;
	import mx.rpc.events.FaultEvent;
	import mx.controls.TextInput;
	
	
	
	/**
	 * This class is used to process http request asynchronously.
	 * 
	 */ 
	public class XenosAsynchronousRequestProcessor
	{
		/**
		 * This is the HTTPService instance which is used to send request asynchronously.
		 */ 
		private var _service:XenosHTTPService;
		
		/**
		 * This is the Error Control instance which is used to show proper error.
		 */ 
		private var _errorControlReference:XenosErrors;
		
		public function XenosAsynchronousRequestProcessor(serviceInstance:XenosHTTPService)
		{
			_service = serviceInstance;
			//_errorControlReference = errorControlInstance;
		}
		
		/**
		 * This method is used to get the request instance and send the request to server.
		 * This method also add some property name to the call object returned by the send method.
		 */ 
		public function processRequest(propName:String, resultControlInstance:UIComponent):void{
			_service.addEventListener(ResultEvent.RESULT,showResult);
			_service.addEventListener(FaultEvent.FAULT,faultHandler);
			var call:Object = _service.send();
	    	call.propName = propName;
	    	call.resultControl = resultControlInstance;	
		}
		
		/**
		 * This method is the result handler of the HTTPService.
		 */ 
		private function showResult(event:ResultEvent):void{
	    	var callObj:Object = event.token;
	    	var rs:XML = XML(event.result);
	    	if(rs.child("Errors").length()>0){
	    		var errorInfoList : ArrayCollection = new ArrayCollection();
	                //populate the error info list              
	               /*  for each ( var error:XML in rs.Errors.error ) {
	                   var errorObj:Object = new Object();
	                   errorObj.message = error.toString();
	                   errorObj.key = callObj.propName;	
	                   _errorControlReference.addError(errorObj);
	                } */
	                if(callObj.resultControl is TextInput)
		    			TextInput(callObj.resultControl).text = "";
		    		else
		    			Label(callObj.resultControl).text = "";
	    	}else{
	    		//_errorControlReference.removeErrorWithKey(callObj.propName);
	    		if(callObj.resultControl is TextInput)
	    			TextInput(callObj.resultControl).text = rs[callObj.propName];
	    		else
	    			Label(callObj.resultControl).text = rs[callObj.propName];
	    	}
	    	_service.removeEventListener(ResultEvent.RESULT,showResult);
			_service.removeEventListener(FaultEvent.FAULT,faultHandler);
	    }
	    
	    private function faultHandler(event:FaultEvent):void{
	    	XenosAlert.error('Error Occured Initialize :  ' + event.fault.faultString);
	    }

	}
}