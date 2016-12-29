




package com.nri.rui.core.controls
{
	import mx.collections.ArrayCollection;
	import mx.events.ValidationResultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	import mx.validators.Validator;
	/**
	 * BaseXenosEntry class is the base class for entry operation.
	 * 
	 */
	public class XenosEntry
	{
	
		protected var _service:HTTPService = null;
		
		protected var _reqObject: Object = null; 
		
		protected var _validatorObject: Validator = null; 
		
		
		public function XenosEntry()
		{			
		}
		
		/**
		 * send initial HttpService to populate Entry Screen
		 */
		public function intialExecute():void{
			_service.send();
		}
		
		public function resultEventHandler(event:ResultEvent):Object{
			//XenosAlert.info("I am in Comps resultEventHandler");
			var resultObj:Object = Object(event.result);		
			return resultObj;
		}
		
		/**
		 * This mathod will take ResultEvent and KeyList and populate object as <Key,Value> pair.
		 * @param  event ResultEvent
		 * @param  keys Object - KeyList
		 * @return Object return object as <Key,Value> pair if result format is XML 
		 *         otherwise it will send object without key value pair
		 */		
		public function resultHandler(event:ResultEvent,keys:Object):Object{
			//XenosAlert.info("I am in Comps resultHandler");
			var map:Object = new Object();
			if(_service.resultFormat == "xml"){
				if(keys is ArrayCollection){
					for each ( var key:String in keys ){
				        var resultObj:XML = XML(resultEventHandler(event));
						var keyPart:Array = key.split(".");
						var i:int =0 ;
						for(i=0;i<keyPart.length -1;i++){
							for each (var result:XML in resultObj.elements(keyPart[i])){
								//XenosAlert.info(keyPart[i]);
								//XenosAlert.info(result);
								resultObj=result;
							}
						}
						var list:XMLList =XMLList(resultObj.elements(keyPart[keyPart.length -1]));						
					   // XenosAlert.info(list);
						//if(list.length()>1){	
				    	    var initcol:ArrayCollection = new ArrayCollection();	    		
				    	    for each(var node: XML in list){
				    	      initcol.addItem(node);		    		
				    	    }	
						    map[key]=initcol;
//				    	}else{
//				    		map[key]=list;
//				    	}
					}
				}
			}else{
				map = resultEventHandler(event);
			}
			
			return map;
		}
		
		/**
		 * If client side validation is required then this method will validate the user entry page and based on 
		 * the validation result type action will be taken.
		 * 
		 */
		public function sendUserEntry():void{
			var validationResult:ValidationResultEvent = null;
			if(_validatorObject != null){
				validationResult =_validatorObject.validate();
			}
			if(validationResult != null && validationResult.type ==ValidationResultEvent.INVALID){
             var errorMsg:String=validationResult.message;
             XenosAlert.error(errorMsg);
	        }
	        else{				
				_service.send();
			}
		}
		
		/**
		 * This mathod will take ResultEvent and KeyList as argument and populate object as <Key,Value> pair.
		 * If severe side error is reported then errorFlag will be set as error. Otherwise errorFlag will be
		 * noError
		 * @param  event ResultEvent
		 * @param  keys Object - KeyList
		 * @return Object return object as <Key,Value> pair if result format is XML 
		 *         otherwise it will send object without key value pair
		 */
		public function userEntryResultEvent(event:ResultEvent,keys:Object):Object{
			var map:Object = new Object();
			//XenosAlert.info("userEntryResultEvent XenosEntry");
			if(null != event ){
			  var rs:XML = XML(resultEventHandler(event));
			  if(rs.child("Errors").length()>0){
			  	map["errorFlag"]=String("error");
			  	var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list 			 	
			 	for each ( var error:XML in rs.Errors.error ) {
	 			   errorInfoList.addItem(error.toString());
				}
			  	map["errorMsg"] = errorInfoList;
			  }else{
			  	try {
			  		if(keys!=null){
			  		   map=resultHandler(event,keys);	
			  		}
			  		if(rs.child("softExceptionList").length()>0){
			  			var warnInfoList : ArrayCollection = new ArrayCollection();
		                //populate the warning info list 			 	
					 	for each ( var warn:XML in rs.softExceptionList.item ) {
			 			   warnInfoList.addItem(warn.value);
						}
					  	map["softWarning"] = warnInfoList;
			  		}
			  		map["errorFlag"]=String("noError");		  		
			  	}catch(e:Error){
			  		map["errorFlag"]=String("dataNotFound");
			  	}
			  }
			  
			 //XenosAlert.info("base object status : "+map["errorFlag"]);
			  return map;
				
			}
			return null;
			
			
		}
		
		/**
		 * send user confirmation service for database commite 
		 */
		public function sendUserConf():void{			
		  _service.send();
		}
		
		/**
		 * This mathod will take ResultEvent and populate object as <Key,Value> pair.
		 * If severe side error is reported then errorFlag will be set as error. Otherwise errorFlag will be
		 * noError
		 * @param  event ResultEvent
		 * @return Object return object as <Key,Value> pair if result format is XML 
		 *         otherwise it will send object without key value pair
		 */
		public function userConfResultEvent(event:ResultEvent,keys:Object):Object{
			var map:Object = new Object();
			
			if(null != event ){
			  var rs:XML = XML(resultEventHandler(event));
			  if(rs.child("Errors").length()>0){
			  	map["errorFlag"]=String("error");
			  	var errorInfoList : ArrayCollection = new ArrayCollection();
                //populate the error info list 			 	
			 	for each ( var error:XML in rs.Errors.error ) {
	 			   errorInfoList.addItem(error.toString());
				}
			  	map["errorMsg"] = errorInfoList;
			  }else{
			  	try {	
			  		if(keys!=null){
			  			map=resultHandler(event,keys);
			  		}
			  		map["errorFlag"]=String("noError");		  		
			  	}catch(e:Error){
			  		map["errorFlag"]=String("dataNotFound");
			  	}
			  }
			  
			  //XenosAlert.info("base object status : "+map["errorFlag"]);
			  return map;
				
			}
			return null;
		}
		
		/**
		 * set httpService to populate entry page.
		 */
		public function setInitService(service:HTTPService):void{
			this._service=service;
		}
		
		/**
		 * set httpService,request object and validater object to populate user confirmation page.
		 * validator object maybe set as null if client side validation is not required. 
		 */
		public function setEntryService(service:HTTPService,vlidator:Validator):void{
			this._service = service;
			//this._reqObject = request;	
			this._validatorObject = vlidator;			
		}
		
		/**
		 * set httpService to populate system confirmation page
		 */
		public function setUserConfService(service:HTTPService):void{
			this._service = service;			
		}
		

	}
}