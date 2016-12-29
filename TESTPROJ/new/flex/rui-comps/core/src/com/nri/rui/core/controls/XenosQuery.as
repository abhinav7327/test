




package com.nri.rui.core.controls
{
	import mx.collections.ArrayCollection;
	import mx.events.ValidationResultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;
	import mx.validators.Validator;
	/**
	 * XenosQuery class is the base class for entry operation.
	 * 
	 */
	public class XenosQuery
	{
	
		protected var _service:HTTPService = null;
		
		protected var _reqObject: Object = null; 
		
		protected var _validatorObject: Validator = null; 
		
		protected var _modeOfOperation:String = "query";
		
		
		public function XenosQuery()
		{			
		}
		
		/**
		 * send initial HttpService to populate Query criteria Screen
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
				//XenosAlert.info("after check in _service.resultFormat");
				if(keys is ArrayCollection){
					//XenosAlert.info("after check in keys is ArrayCollection");
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
					    //XenosAlert.info(list);
						//if(list.length()>1){	
				    	    var initcol:ArrayCollection = new ArrayCollection();	    		
				    	    for each(var node: XML in list){
				    	      initcol.addItem(node);		    		
				    	    }	
						    map[key]=initcol;
				    	//}else{
				    	//	map[key]=list;
				    	//}
					}
				}
			}else{
				map = resultEventHandler(event);
			}
			
			return map;
		}
		
		/**
		 * If client side validation is required then this method will validate the query criteria and based on 
		 * the validation result type action will be taken.
		 * 
		 */
		public function sendUserQuery():void{
			//XenosAlert.info("I am in Comps sendUserQuery");
			var validationResult:ValidationResultEvent = null;
			if(_validatorObject != null){
				validationResult =_validatorObject.validate();
			}
			if(validationResult != null && validationResult.type ==ValidationResultEvent.INVALID){
             var errorMsg:String=validationResult.message;
             XenosAlert.error(errorMsg);
	        }
	        else{				
				//_service.request = _reqObject;
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
		public function userQueryResultEvent(event:ResultEvent,keys:Object):Object{
			var map:Object = new Object();
			
			//XenosAlert.info("I am in Comps userQueryResultEvent");
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
			  		if(keys != null){
			  		map=resultHandler(event,keys);	
			  		map["errorFlag"]=String("noError");	
			  		}else{
			  			if(rs.child("row").length()>0){
			  				var initcol:ArrayCollection = new ArrayCollection();
						    for each ( var rec:XML in rs.row ) {
						    	rec.mode =_modeOfOperation;
			 				    initcol.addItem(rec);
						    }
			  				map["row"]=initcol;
			  				map["prevTraversable"] = rs.prevTraversable;
			  				map["nextTraversable"] = rs.nextTraversable;
			  		        map["errorFlag"]=String("noError");	
			  			}else{
			  				map["errorFlag"]=String("dataNotFound");
			  			}
			  		}	  		
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
		public function setQueryService(service:HTTPService,vlidator:Validator):void{
			this._service = service;
			//this._reqObject = request;	
			this._validatorObject = vlidator;			
		}
		

	}
}