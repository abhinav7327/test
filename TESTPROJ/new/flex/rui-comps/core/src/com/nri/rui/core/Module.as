
package com.nri.rui.core
{
	import mx.collections.*;
	
	/**
	 * Module - A class holds the information of modules for the application.
	 * This module names will be used to load their resource bundles to the Application.
	 * Each modules need a resource bundles must be included in the module array List.
	 * @author prabjyotk
	 * @version 
	 */
	public class Module
	{
		/**
		 * Array for holding modules names.
		 */ 
		private static var modules :Array  = ["INF",
											  "REF",
											  "TRD",	
											  "BKG",
											  "FRX",
											  "DRV",
											  "CAX",
											  "SLR",
										   	  "STL",
											  "NCM",
											  "GLE",
											  "CAM",
											  "EXM",
											  "REC",
										      "ICN",
										      "OMS",
										      "SMR",
										      "SWP",
										      "ADP",
										      "FAM"];
		/**																		
		 * Method to return the array of modules.
		 * @return <ArrayCollection> object which holds the list of modules. 
		 **/
		public static function getModules(): ArrayCollection {
			return new ArrayCollection(modules);
		}
	}
}