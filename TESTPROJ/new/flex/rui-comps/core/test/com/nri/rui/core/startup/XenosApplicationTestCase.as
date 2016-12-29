package com.nri.rui.core.startup
{
	import flexunit.framework.TestCase;
	
	/**
	 * Test case for XenosApplication.
	 */
	public class XenosApplicationTestCase extends TestCase
	{
		
		//~ Constructors -------------------------------------------------------
		
		/**
		 * Constructor.
		 */
		public function XenosApplicationTestCase(methodName : String = null)
		{
			super (methodName);
		}
		
		
		//~ Fixture Methods ----------------------------------------------------
		
		/**
		 * @see flexunit.framework.TestCase#setUp()
		 */
		override public function setUp() : void
		{
		}
		
		/**
		 * @see flexunit.framework.TestCase#tearDown()
		 */
		override public function tearDown() : void
		{
		}	
		
		
		//~ Test Methods -------------------------------------------------------
		
		/**
		 * Tests whether the application instance is singleton or not.
		 */
		public function testSingleton() : void
		{
			var instance : XenosApplication = XenosApplication.getInstance("NAM");
			assertFalse(instance.isPrototypeOf(XenosApplication));
		}	
		
	}
}