




package com.nri.rui.core.containers
{
	import flash.events.Event;
	
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	/**
	 * 
	 * @author krishnendur
	 * 
	 */
	public interface IXenosQueryModule
	{
		
		//Init operation
		function preQueryInit():void;
		function doQueryInit(e:Event):void;
		function postQueryInit():void;
		function preAmendInit():void;
		function doAmendInit(e:Event):void;
		function postAmendInit():void;
		function preCancelInit():void;
		function doCancelInit(e:Event):void;
		function postCancelInit():void;
		
		//Init Result Handeler 
		function preQueryResultInit():Object;
		function doQueryResultInit(e:ResultEvent):void;
		function postQueryResultInit(result:Object):void;
		function preAmendResultInit():Object;
		function doAmendResultInit(e:ResultEvent):void;
		function postAmendResultInit(result:Object):void;
		function preCancelResultInit():Object;
		function doCancelResultInit(e:ResultEvent):void;
		function postCancelResultInit(result:Object):void;
				
		// operation
		function preQuery():void;
		function doQuery(e:Event):void;
		function postQuery():void;
		function preAmend():void;
		function doAmend(e:Event):void;
		function postAmend():void;
		function preCancel():void;
		function doCancel(e:Event):void;
		function postCancel():void;
		
		// Result Handeler 
		function preQueryResultHandler():Object;
		function queryResultHandler(e:ResultEvent):void;
		function postQueryResultHandler(result:Object):void;
		function preAmendResultHandler():Object;
		function amendQueryResultHandler(e:ResultEvent):void;
		function postAmendResultHandler(result:Object):void;
		function preCancelResultHandler():Object;
		function cancelQueryResultHandler(e:ResultEvent):void;
		function postCancelResultHandler(result:Object):void;
		
		
		
		//Reset operation
		function preResetQuery():void;
		function doResetQuery(e:Event):void;
		function postResetQuery():void;
		function preResetAmend():void;
		function doResetAmend(e:Event):void;
		function postResetAmend():void;
		function preResetCancel():void;
		function doResetCancel(e:Event):void;
		function postResetCancel():void;
		
		
		function prePrevious():Object;
		function doPrevious(e:Event):void;
		function postPrevious():void;
		function preNext():Object;
		function doNext(e:Event):void;
		function postNext():void;
		function preGenerateXls():String;
		function generateXls(e:Event):void;
		function postGenerateXls():void;
		function preGeneratePdf():String;
		function generatePdf(e:Event):void;
		function postGeneratePdf():void;
		function prePrint():Object;
		function doPrint(e:Event):void;
		function postPrint():void;
		
		
		
	}
}