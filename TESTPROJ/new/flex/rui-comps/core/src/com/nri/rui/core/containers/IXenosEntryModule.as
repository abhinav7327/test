




package com.nri.rui.core.containers
{
	import flash.events.Event;
	
	import mx.rpc.events.ResultEvent;
	
	public interface IXenosEntryModule
	{
		
		//Init operation
		function preEntryInit():void;
		function doEntryInit(e:Event):void;
		function postEntryInit():void;
		function preAmendInit():void;
		function doAmendInit(e:Event):void;
		function postAmendInit():void;
		function preCancelInit():void;
		function doCancelInit(e:Event):void;
		function postCancelInit():void;
		
		//Init Result Handeler 
		function preEntryResultInit():Object;
		function entryResultInit(e:ResultEvent):void;
		function postEntryResultInit(result:Object):void;
		function preAmendResultInit():Object;
		function amendResultInit(e:ResultEvent):void;
		function postAmendResultInit(result:Object):void;
		function preCancelResultInit():Object;
		function cancelResultInit(e:ResultEvent):void;
		function postCancelResultInit(result:Object):void;
		
		//save user Entry operation
		function preEntry():void;
		function doEntry(e:Event):void;
		function postEntry():void;
		function preAmend():void;
		function doAmend(e:Event):void;
		function postAmend():void;
		function preCancel():void;
		function doCancel(e:Event):void;
		function postCancel():void;
		
		//save user Entry Result Handeler 
		function preEntryResultHandler():Object;
		function entryResultHandler(e:ResultEvent):void;
		function postEntryResultHandler(result:Object):void;
		function preAmendResultHandler():Object;
		function amendResultHandler(e:ResultEvent):void;
		function postAmendResultHandler(result:Object):void;
		function preCancelResultHandler():Object;
		function cancelResultHandler(e:ResultEvent):void;
		function postCancelResultHandler(result:Object):void;
		
		// user Confirmation operation
		function preEntryConfirm():void;
		function doEntryConfirm(e:Event):void;
		function postEntryConfirm():void;
		function preAmendConfirm():void;
		function doAmendConfirm(e:Event):void;
		function postAmendConfirm():void;
		function preCancelConfirm():void;
		function doCancelConfirm(e:Event):void;
		function postCancelConfirm():void;
		
		//user Confirmation Result Handeler 
		function preEntryConfirmResultHandler():Object;
		function entryConfirmResultHandler(e:ResultEvent):void;
		function postConfirmEntryResultHandler(result:Object):void;
		function preConfirmAmendResultHandler():Object;
		function amendConfirmResultHandler(e:ResultEvent):void;
		function postConfirmAmendResultHandler(result:Object):void;
		function preConfirmCancelResultHandler():Object;
		function cancelConfirmResultHandler(e:ResultEvent):void;
		function postConfirmCancelResultHandler(result:Object):void;
		
		// system Confirmation operation
		function preEntrySystemConfirm():void;
		function doEntrySystemConfirm(e:Event):void;
		function postEntrySystemConfirm():void;
		function preAmendSystemConfirm():void;
		function doAmendSystemConfirm(e:Event):void;
		function postAmendSystemConfirm():void;
		function preCancelSystemConfirm():void;
		function doCancelSystemConfirm(e:Event):void;
		function postCancelSystemConfirm():void;
		
		//Reset operation
		function preResetEntry():void;
		function doResetEntry(e:Event):void;
		function postResetEntry():void;
		function preResetAmend():void;
		function doResetAmend(e:Event):void;
		function postResetAmend():void;
		
		
	}
}