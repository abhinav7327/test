package com.nri.rui.core.startup.vo
{
	public class CachedVo
	{
		[Bindable]
		public var menuList : XMLList;
		
		[Bindable]
		public var ccyList : XMLList;
		
		[Bindable]
		public var instrumentTree : XMLList;
		
		[Bindable]
		public var marketTree : XMLList;
		
		[Bindable]
		public var bbInstrumentTree : XMLList;
		
		public var retentionDates : XMLList;
		
		public function CachedVo()
		{
		}

	}
}