package com.nri.rui.core
{
	
	import com.nri.rui.core.controls.XenosAlert;
	
	import mx.core.IFactory;

	public class RendererFectory implements IFactory
	{
		private var _rendererClass:Class;
		
		private var _mode:String;
		
		public function RendererFectory(rendererClassName:Class,mode:String = "query")
		{
		 	this._rendererClass=rendererClassName;
			this._mode = mode;
		}

		public function newInstance():*
		{
           var obj:Object =  new _rendererClass();
           if(_mode != "query")
              obj._mode = this._mode;
              
           return obj;
		}
		
	}
}