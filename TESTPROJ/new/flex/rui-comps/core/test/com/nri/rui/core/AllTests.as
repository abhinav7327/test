package com.nri.rui.core
{
	import flexunit.framework.TestSuite;
	import flexunit.framework.Test;
	import com.nri.rui.core.startup.XenosApplicationTestCase;
	
	public class AllTests extends TestSuite
	{
		public static function suite() : Test
		{
			var testSuite : TestSuite = new TestSuite();
			
			testSuite.addTest(new TestSuite(XenosApplicationTestCase) );
			return testSuite;

		}
	}
}