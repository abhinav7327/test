package com.nri.rui.core.themeControls
{
	import flexlib.mdi.containers.MDIWindowControlsContainer;
	
	public class DefaultWindowControls extends MDIWindowControlsContainer
	{
		
		public function DefaultWindowControls()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			setStyle("horizontalGap", 0);
		}

	}
}