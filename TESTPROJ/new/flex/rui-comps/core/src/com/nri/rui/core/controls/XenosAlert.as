/*
 *
 *
 *$Author: anubhavg $
*/


package com.nri.rui.core.controls
{
	import mx.controls.Alert;
	
	public class XenosAlert extends Alert
	{
		[Embed(source="../../../../../assets/alert_error.png")]
		private static var iconError:Class;
		
		[Embed(source="../../../../../assets/alert_info.png")]
		private static var iconInfo:Class;
		
		[Embed(source="../../../../../assets/alert_confirm.png")]
		private static var iconConfirm:Class;

		public static function info(message:String, closehandler:Function=null):void{
			show(message, "Information", Alert.OK, null, closehandler, iconInfo);
		}
		
		public static function error(message:String, closehandler:Function=null):void{
			show(message, "Error", Alert.OK, null, closehandler, iconError);
		}
		
		public static function confirm(message:String, closehandler:Function=null):void{
			show(message, "Confirmation", Alert.YES | Alert.NO, null, closehandler, iconConfirm);
		}

	}
}