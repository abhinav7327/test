




package com.nri.rui.core.containers
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.controls.XenosEntry;
	import com.nri.rui.core.controls.XenosHTTPService;
	
	import flash.events.Event;
	
	import mx.events.ModuleEvent;
	import mx.modules.Module;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.validators.Validator;
	

	public class XenosEntryModule extends Module implements IXenosEntryModule
	{
		
		private var _xenosEntryControl:XenosEntry = null;
		
		private var _serviceArray : Array = new Array(5);
		
		protected var _validator : Validator = null;
		
	    private var _modeOfOperation:String = "entry";
	    private var _resultEvent:Array = new Array(5);
	   
	   /**
		 * 
		 */
		public function setXenosEntryControl(xenosEntry:XenosEntry):void{
			_xenosEntryControl = xenosEntry;
		}
		
		
		
		public function getInitHttpService():XenosHTTPService{
			return _serviceArray[0];
		}
		
		public function getResetHttpService():XenosHTTPService{
			return _serviceArray[2];
		}
		
		public function getSaveHttpService():XenosHTTPService{
			return _serviceArray[1];
		}
		public function getConfHttpService():XenosHTTPService{
			return _serviceArray[3];
		}
		
		public function getInitResultEvent():ResultEvent{
			return _resultEvent[0];
		}
		
		public function getSaveResultEvent():ResultEvent{
			return _resultEvent[1];
		}
		
		public function getConfResultEvent():ResultEvent{
			return _resultEvent[2];
		}
	   
		public function XenosEntryModule()
		{
			super();
			
			this.addEventListener("entryInit",doEntryInit);
			this.addEventListener("entryReset",doResetEntry);
			this.addEventListener("entrySave",doEntry);
			this.addEventListener("entryConf",doEntryConfirm);
			this.addEventListener("entrySysConf",doEntrySystemConfirm);
			this.addEventListener("amendEntryInit",doAmendInit);
			this.addEventListener("amendEntryReset",doResetAmend);
			this.addEventListener("amendEntrySave",doAmend);
			this.addEventListener("amendEntryConf",doAmendConfirm);
			this.addEventListener("amendEntrySysConf",doAmendSystemConfirm);
			this.addEventListener("cancelEntryInit",doCancelInit);
			//this.addEventListener("cancelEntryReset",doResetCancel);
			this.addEventListener("cancelEntrySave",doCancel);
			this.addEventListener("cancelEntryConf",doCancelConfirm);
			this.addEventListener("cancelEntrySysConf",doCancelSystemConfirm);
			
			this.addEventListener("reopenEntryInit",doReopenInit);
			this.addEventListener("reopenEntrySave",doReopen);
			this.addEventListener("reopenEntryConf",doReopenConfirm);
			this.addEventListener("reopenEntrySysConf",doReopenSystemConfirm);
			
			
			this.addEventListener(ModuleEvent.UNLOAD,destroyModule);
		}
		
		public function preEntryInit():void
		{
		}
		
		public function doEntryInit(e:Event):void
		{
			_modeOfOperation="entry";
			
			_serviceArray[0] = new XenosHTTPService();
			
			(_serviceArray[0] as XenosHTTPService).addEventListener(ResultEvent.RESULT, entryResultInit);
			
			(_serviceArray[0] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
			
			preEntryInit();
			
			(_serviceArray[0] as XenosHTTPService).resultFormat = "xml";
			
			try{
			   _xenosEntryControl.setInitService(_serviceArray[0]);
			
			   _xenosEntryControl.intialExecute();
			}catch(e:Error){
				XenosAlert.error(e.message);
			}
			
			postEntryInit();
		}
		
		public function postEntryInit():void
		{
		}
		
		public function preAmendInit():void
		{
		}
		
		public function doAmendInit(e:Event):void
		{
			_modeOfOperation="amend";
			
			_serviceArray[0] = new XenosHTTPService();
			
			(_serviceArray[0] as XenosHTTPService).addEventListener(ResultEvent.RESULT, amendResultInit);
			
			(_serviceArray[0] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
			
			preAmendInit();
			
			(_serviceArray[0] as XenosHTTPService).resultFormat = "xml";
			
			try{
			   _xenosEntryControl.setInitService(_serviceArray[0]);
			
			   _xenosEntryControl.intialExecute();
			}catch(e:Error){
				XenosAlert.error(e.message);
			}
			
			postAmendInit();
		}
		
		public function postAmendInit():void
		{
		}
		
		public function preCancelInit():void
		{
			
		}
		
		public function doCancelInit(e:Event):void
		{
			_modeOfOperation="cancel";
			
			_serviceArray[0] = new XenosHTTPService();
			
			(_serviceArray[0] as XenosHTTPService).addEventListener(ResultEvent.RESULT, cancelResultInit);
			
			(_serviceArray[0] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
			
			preCancelInit();
			
			(_serviceArray[0] as XenosHTTPService).resultFormat = "xml";
			
			try{
			   _xenosEntryControl.setInitService(_serviceArray[0]);
			
			   _xenosEntryControl.intialExecute();
			}catch(e:Error){
				XenosAlert.error(e.message);
			}
			
			postCancelInit();
		}
		
		public function postCancelInit():void
		{
		}
		
		public function preReopenInit():void
		{
			
		}
		
		
			public function doReopenInit(e:Event):void
		{
			_modeOfOperation="reopen";
			
			_serviceArray[0] = new XenosHTTPService();
			
			(_serviceArray[0] as XenosHTTPService).addEventListener(ResultEvent.RESULT, reopenResultInit);
			
			(_serviceArray[0] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
			
			preReopenInit();
			
			(_serviceArray[0] as XenosHTTPService).resultFormat = "xml";
			
			try{
			   _xenosEntryControl.setInitService(_serviceArray[0]);
			
			   _xenosEntryControl.intialExecute();
			}catch(e:Error){
				XenosAlert.error(e.message);
			}
			
			postReopenInit();
		}
		
		public function postReopenInit():void
		{
		}
		
		public function preEntryResultInit():Object
		{
			return null;
		}
		
		public function entryResultInit(resultEvent:ResultEvent):void
		{
			_resultEvent[0] = resultEvent;
			var keyList:Object=preEntryResultInit();
			var result:Object = _xenosEntryControl.resultHandler(resultEvent,keyList);
			postEntryResultInit(result);
		}
		
		public function postEntryResultInit(result:Object):void
		{
		}
		
		public function preAmendResultInit():Object
		{
			return null;
		}
		
		public function amendResultInit(resultEvent:ResultEvent):void
		{
			_resultEvent[0] = resultEvent;
			var keyList:Object=preAmendResultInit();
			var result:Object = _xenosEntryControl.resultHandler(resultEvent,keyList);
			postAmendResultInit(result);
		}
		
		public function postAmendResultInit(result:Object):void
		{
		}
		
		public function preCancelResultInit():Object
		{
			return null;
		}
		
		public function cancelResultInit(resultEvent:ResultEvent):void
		{
			_resultEvent[0] = resultEvent;
			var keyList:Object=preCancelResultInit();
			var result:Object = _xenosEntryControl.resultHandler(resultEvent,keyList);
			postCancelResultInit(result);
		}
		
		public function postCancelResultInit(result:Object):void
		{
		}
		
		
		public function preReopenResultInit():Object
		{
			return null;
		}
		
		public function reopenResultInit(resultEvent:ResultEvent):void
		{
			_resultEvent[0] = resultEvent;
			var keyList:Object=preReopenResultInit();
			var result:Object = _xenosEntryControl.resultHandler(resultEvent,keyList);
			postReopenResultInit(result);
		}
		
		public function postReopenResultInit(result:Object):void
		{
		}
		
		public function preEntry():void
		{
		}
		
		public function doEntry(e:Event):void
		{
			
			_serviceArray[1] = new XenosHTTPService();
			
			(_serviceArray[1] as XenosHTTPService).addEventListener(ResultEvent.RESULT, entryResultHandler);
			
			(_serviceArray[1] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
			
			preEntry();
			
			(_serviceArray[1] as XenosHTTPService).resultFormat = "xml";
			
			try{
			   _xenosEntryControl.setEntryService(_serviceArray[1],_validator);
			
			   _xenosEntryControl.sendUserEntry();
			}catch(e:Error){
				trace(e.getStackTrace());
				XenosAlert.error(e.message);
			}
			
			postEntry();
		}
		
		public function postEntry():void
		{
		}
		
		public function preAmend():void
		{
		}
		
		public function doAmend(e:Event):void
		{
			
			_serviceArray[1] = new XenosHTTPService();
			
			(_serviceArray[1] as XenosHTTPService).addEventListener(ResultEvent.RESULT, amendResultHandler);
			
			(_serviceArray[1] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
			
			preAmend();
			
			(_serviceArray[1] as XenosHTTPService).resultFormat = "xml";
			
			try{
			   _xenosEntryControl.setEntryService(_serviceArray[1],_validator);
			
			   _xenosEntryControl.sendUserEntry();
			}catch(e:Error){
				XenosAlert.error(e.message);
			}
			
			postAmend();
		}
		
		public function postAmend():void
		{
		}
		
		public function preCancel():void
		{
		}
		
		public function doCancel(e:Event):void
		{
			
			_serviceArray[1] = new XenosHTTPService();
			
			(_serviceArray[1] as XenosHTTPService).addEventListener(ResultEvent.RESULT, cancelResultHandler);
			
			(_serviceArray[1] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
			
			preCancel();
			
			(_serviceArray[1] as XenosHTTPService).resultFormat = "xml";
			
			try{
			   _xenosEntryControl.setEntryService(_serviceArray[1],_validator);
			
			   _xenosEntryControl.sendUserEntry();
			}catch(e:Error){
				XenosAlert.error(e.message);
			}
			
			postCancel();
		}
		
		public function postCancel():void
		{
		}
		
		
		public function preReopen():void
		{
		}
		
		public function doReopen(e:Event):void
		{
			
			_serviceArray[1] = new XenosHTTPService();
			
			(_serviceArray[1] as XenosHTTPService).addEventListener(ResultEvent.RESULT, reopenResultHandler);
			
			(_serviceArray[1] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
			
			preReopen();
			
			(_serviceArray[1] as XenosHTTPService).resultFormat = "xml";
			
			try{
			   _xenosEntryControl.setEntryService(_serviceArray[1],_validator);
			
			   _xenosEntryControl.sendUserEntry();
			}catch(e:Error){
				XenosAlert.error(e.message);
			}
			
			postReopen();
		}
		
		public function postReopen():void
		{
		}
		
		public function preEntryResultHandler():Object
		{
			return null;
		}
		
		public function entryResultHandler(resultEvent:ResultEvent):void
		{			
			_resultEvent[1] = resultEvent;
			var keyList:Object=preEntryResultHandler();
			var result:Object = _xenosEntryControl.userEntryResultEvent(resultEvent,keyList);
			postEntryResultHandler(result);
		}
		
		public function postEntryResultHandler(result:Object):void
		{
		}
		
		public function preAmendResultHandler():Object
		{
			return null;
		}
		
		public function amendResultHandler(resultEvent:ResultEvent):void
		{
			_resultEvent[1] = resultEvent;
			var keyList:Object=preAmendResultHandler();
			var result:Object = _xenosEntryControl.userEntryResultEvent(resultEvent,keyList);
			postAmendResultHandler(result);
		}
		
		public function postAmendResultHandler(result:Object):void
		{
		}
		
		public function preCancelResultHandler():Object
		{
			return null;
		}
		
		public function cancelResultHandler(resultEvent:ResultEvent):void
		{
			_resultEvent[1] = resultEvent;
			var keyList:Object=preCancelResultHandler();
			var result:Object = _xenosEntryControl.userEntryResultEvent(resultEvent,keyList);
			postCancelResultHandler(result);
		}
		
		public function postCancelResultHandler(result:Object):void
		{
		}
		
		public function preReopenResultHandler():Object
		{
			return null;
		}
		
		public function reopenResultHandler(resultEvent:ResultEvent):void
		{
			_resultEvent[1] = resultEvent;
			var keyList:Object=preReopenResultHandler();
			var result:Object = _xenosEntryControl.userEntryResultEvent(resultEvent,keyList);
			postReopenResultHandler(result);
		}
		
		public function postReopenResultHandler(result:Object):void
		{
		}
		
		public function preEntryConfirm():void
		{
		}
		
		public function doEntryConfirm(e:Event):void
		{
			
			_serviceArray[3] = new XenosHTTPService();
			
			(_serviceArray[3] as XenosHTTPService).addEventListener(ResultEvent.RESULT, entryConfirmResultHandler);
			
			(_serviceArray[3] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
			
			preEntryConfirm();
			
			(_serviceArray[3] as XenosHTTPService).resultFormat = "xml";
			
			try{
			   _xenosEntryControl.setUserConfService(_serviceArray[3]);
			
			   _xenosEntryControl.sendUserConf();
			}catch(e:Error){
				XenosAlert.error(e.message);
			}
			
			postEntryConfirm();
		}
		
		public function postEntryConfirm():void
		{
		}
		
		public function preAmendConfirm():void
		{
		}
		
		public function doAmendConfirm(e:Event):void
		{
			
			_serviceArray[3] = new XenosHTTPService();
			
			(_serviceArray[3] as XenosHTTPService).addEventListener(ResultEvent.RESULT, amendConfirmResultHandler);
			
			(_serviceArray[3] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
			
			preAmendConfirm();
			
			(_serviceArray[3] as XenosHTTPService).resultFormat = "xml";
			
			try{
			   _xenosEntryControl.setUserConfService(_serviceArray[3]);
			
			   _xenosEntryControl.sendUserConf();
			}catch(e:Error){
				XenosAlert.error(e.message);
			}
			
			postAmendConfirm();
		}
		
		public function postAmendConfirm():void
		{
		}
		
		public function preCancelConfirm():void
		{
		}
		
		public function doCancelConfirm(e:Event):void
		{
			
			_serviceArray[3] = new XenosHTTPService();
			
			(_serviceArray[3] as XenosHTTPService).addEventListener(ResultEvent.RESULT, cancelConfirmResultHandler);
			
			(_serviceArray[3] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
			
			preCancelConfirm();
			
			(_serviceArray[3] as XenosHTTPService).resultFormat = "xml";
			
			try{
			   _xenosEntryControl.setUserConfService(_serviceArray[3]);
			
			   _xenosEntryControl.sendUserConf();
			}catch(e:Error){
				XenosAlert.error(e.message);
			}
			
			postCancelConfirm();
		}
		
		public function postCancelConfirm():void
		{
		}
		
		
		public function preReopenConfirm():void
		{
		}
		
		public function doReopenConfirm(e:Event):void
		{
			
			_serviceArray[3] = new XenosHTTPService();
			
			(_serviceArray[3] as XenosHTTPService).addEventListener(ResultEvent.RESULT, reopenConfirmResultHandler);
			
			(_serviceArray[3] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
			
			preReopenConfirm();
			
			(_serviceArray[3] as XenosHTTPService).resultFormat = "xml";
			
			try{
			   _xenosEntryControl.setUserConfService(_serviceArray[3]);
			
			   _xenosEntryControl.sendUserConf();
			}catch(e:Error){
				XenosAlert.error(e.message);
			}
			
			postReopenConfirm();
		}
		
		public function postReopenConfirm():void
		{
		}
		
		public function preEntryConfirmResultHandler():Object
		{
			return null;
		}
		
		public function entryConfirmResultHandler(resultEvent:ResultEvent):void
		{			
			_resultEvent[1] = resultEvent;
			var keyList:Object=preEntryConfirmResultHandler();
			var result:Object = _xenosEntryControl.userConfResultEvent(resultEvent,keyList);
			postConfirmEntryResultHandler(result);
		}
		
		public function postConfirmEntryResultHandler(result:Object):void
		{
		}
		
		public function preConfirmAmendResultHandler():Object
		{
			return null;
		}
		
		public function amendConfirmResultHandler(resultEvent:ResultEvent):void
		{
			_resultEvent[1] = resultEvent;
			var keyList:Object=preConfirmAmendResultHandler();
			var result:Object = _xenosEntryControl.userConfResultEvent(resultEvent,keyList);
			postConfirmAmendResultHandler(result);
		}
		
		public function postConfirmAmendResultHandler(result:Object):void
		{
		}
		
		public function preConfirmCancelResultHandler():Object
		{
			return null;
		}
		
		public function cancelConfirmResultHandler(resultEvent:ResultEvent):void
		{
			_resultEvent[1] = resultEvent;
			var keyList:Object=preConfirmCancelResultHandler();
			var result:Object = _xenosEntryControl.userConfResultEvent(resultEvent,keyList);
			postConfirmCancelResultHandler(result);
		}
		
		public function postConfirmCancelResultHandler(result:Object):void
		{
		}
		
		public function preConfirmReopenResultHandler():Object
		{
			return null;
		}
		
		public function reopenConfirmResultHandler(resultEvent:ResultEvent):void
		{
			_resultEvent[1] = resultEvent;
			var keyList:Object=preConfirmReopenResultHandler();
			var result:Object = _xenosEntryControl.userConfResultEvent(resultEvent,keyList);
			postConfirmReopenResultHandler(result);
		}
		
		public function postConfirmReopenResultHandler(result:Object):void
		{
		}
		
		public function preEntrySystemConfirm():void
		{
		}
		
		public function doEntrySystemConfirm(e:Event):void
		{
		}
		
		public function postEntrySystemConfirm():void
		{
		}
		
		public function preAmendSystemConfirm():void
		{
		}
		
		public function doAmendSystemConfirm(e:Event):void
		{
		}
		
		public function postAmendSystemConfirm():void
		{
		}
		
		public function preCancelSystemConfirm():void
		{
		}
		
		public function doCancelSystemConfirm(e:Event):void
		{
		}
		public function doReopenSystemConfirm(e:Event):void
		{
		}
		
		public function postCancelSystemConfirm():void
		{
		}
		
		public function preResetEntry():void
		{
		}
		
		public function doResetEntry(e:Event):void
		{
			_serviceArray[2] = new XenosHTTPService();
			
			(_serviceArray[2] as XenosHTTPService).addEventListener(ResultEvent.RESULT, entryResultInit);
			
			(_serviceArray[2] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
			
			preResetEntry();
			
			(_serviceArray[2] as XenosHTTPService).resultFormat = "xml";
			
			try{
			   _xenosEntryControl.setInitService(_serviceArray[2]);
			
			   _xenosEntryControl.intialExecute();
			}catch(e:Error){
				XenosAlert.error(e.message);
			}
			
			postResetEntry();
		}
		
		public function postResetEntry():void
		{
		}
		
		public function preResetAmend():void
		{
		}
		
		public function doResetAmend(e:Event):void
		{
			_serviceArray[2] = new XenosHTTPService();
			
			(_serviceArray[2] as XenosHTTPService).addEventListener(ResultEvent.RESULT, amendResultInit);
			
			(_serviceArray[2] as XenosHTTPService).addEventListener(FaultEvent.FAULT,faultHandler);
			
			preResetAmend();
			
			(_serviceArray[2] as XenosHTTPService).resultFormat = "xml";
			
			try{
			   _xenosEntryControl.setInitService(_serviceArray[2]);
			
			   _xenosEntryControl.intialExecute();
			}catch(e:Error){
				XenosAlert.error(e.message);
			}
			
			postResetAmend();
		}
		
		public function postResetAmend():void
		{
		}
		
		
		public function destroyModule(event:ModuleEvent):void {
	
            this.removeEventListener("entryInit",doEntryInit);
			this.removeEventListener("entryReset",doResetEntry);
			this.removeEventListener("entrySave",doEntry);
			this.removeEventListener("entryConf",doEntryConfirm);
			this.removeEventListener("entrySysConf",doEntrySystemConfirm);
			this.removeEventListener("amendEntryInit",doAmendInit);
			this.removeEventListener("amendEntryReset",doResetAmend);
			this.removeEventListener("amendEntrySave",doAmend);
			this.removeEventListener("amendEntryConf",doAmendConfirm);
			this.removeEventListener("amendEntrySysConf",doAmendSystemConfirm);
			this.removeEventListener("cancelEntryInit",doCancelInit);
			//this.removeEventListener("cancelEntryReset",doResetCancel);
			this.removeEventListener("cancelEntrySave",doCancel);
			this.removeEventListener("cancelEntryConf",doCancelConfirm);
			this.removeEventListener("cancelEntrySysConf",doCancelSystemConfirm);
			
			this.removeEventListener("reopenEntryInit",doReopenInit);
			this.removeEventListener("reopenEntrySave",doReopen);
			this.removeEventListener("reopenEntryConf",doReopenConfirm);
			this.removeEventListener("reopenEntrySysConf",doReopenSystemConfirm);
			
			if(_serviceArray[0] != null){
				switch(_modeOfOperation){
					case "entry":
					 (_serviceArray[0] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,entryResultInit);
					 break;
					case "amend":
					 (_serviceArray[0] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.amendResultInit);
					  break;
					case "cancel":
					 (_serviceArray[0] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.cancelResultInit);
					  break;
					case "reopen":
					 (_serviceArray[0] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.reopenResultInit);
					  break;
				}			
			}
			if(_serviceArray[1] != null){
				switch(_modeOfOperation){
					case "entry":
					 (_serviceArray[1] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.entryResultHandler);
					 break;
					case "amend":
					 (_serviceArray[1] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.amendResultHandler);
					  break;
					case "cancel":
					 (_serviceArray[1] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.cancelResultHandler);
					  break;
					case "reopen":
					 (_serviceArray[1] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.reopenResultHandler);
					  break;
				}			
			} 
			if(_serviceArray[2] != null){
				switch(_modeOfOperation){
					case "entry":
					 (_serviceArray[2] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,entryResultInit);
					 break;
					case "amend":
					 (_serviceArray[2] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.amendResultInit);
					  break;
				}			
			}
			if(_serviceArray[3] != null){
				switch(_modeOfOperation){
					case "entry":
					 (_serviceArray[3] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.entryConfirmResultHandler);
					 break;
					case "amend":
					 (_serviceArray[3] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.amendConfirmResultHandler);
					  break;
					case "cancel":
					 (_serviceArray[3] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.cancelConfirmResultHandler);
					  break;
					case "reopen":
					 (_serviceArray[3] as XenosHTTPService).removeEventListener(ResultEvent.RESULT,this.reopenConfirmResultHandler);
					  break;
					  
				}			
			}
			var i:int= 0;
			for(i=0;i<_serviceArray.length;i++){
				if(_serviceArray[i] != null){
					(_serviceArray[i] as XenosHTTPService).removeEventListener(FaultEvent.FAULT,faultHandler);
				}
				_serviceArray[i] = null;
			}
			for(i=0;i<_resultEvent.length;i++){				
				_resultEvent[i] = null;
			}
			this.removeEventListener(ModuleEvent.UNLOAD,destroyModule); 
		}
				
		public function faultHandler(event:FaultEvent):void{
			XenosAlert.error('Error Occured :  ' + event.fault.faultString)
		}
		
	}
}