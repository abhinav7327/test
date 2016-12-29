/*

$LastChangedDate$
$Author: anubhavg $  Amitp
*/


package com.nri.rui.core.utils
{
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;
	
	/**
	 * @class CursorUtil
	 * @brief Utility class to Set the cursor image 
	 * 
	 */
	public class CursorUtils{

		private static var currentType:Class = null;
				
		/**
		 * Remove the current cursor and set an image.
		 * @param type The image class
		 * @param xOffset The xOffset of the cursorimage
		 * @param yOffset The yOffset of the cursor image
		 */
		public static function changeCursor(type:Class, xOffset:Number = 0, yOffset:Number = 0):void{
			if(currentType != type){
				currentType = type;
				CursorManager.removeCursor(CursorManager.currentCursorID);
				if(type != null){
					CursorManager.setCursor(type, CursorManagerPriority.MEDIUM, xOffset, yOffset);
				}
			}
		}
	}
}