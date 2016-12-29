/*
 *
 *
 * $LastChangedDate$
 * $Author: anubhavg $
 */

package com.nri.rui.core.utils
{
	import mx.controls.List;
	[Bindable]
	public class HiddenObject extends Object
	{
		//Data members
		public var m_propertyName:String;
		public var m_propertyValues:Array;
		
		//constructor
		public function HiddenObject (propertyName:String,
		                              propertyValues:Array){

		  this.m_propertyName = propertyName;
		  this.m_propertyValues = new Array(propertyValues.length);
		  
		  for(var i:int = 0; i<int (propertyValues.length); i++){
		  	this.m_propertyValues[i] = propertyValues[i];
		  }
		  
	    }
		
	}
}