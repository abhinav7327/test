
package com.nri.rui.fam.validators
{
	import com.nri.rui.core.controls.XenosAlert;
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;
	/**
	 * Custom Validator for Fam Portfolio Balance Query Implementation.
	 *
	 */
	public class FamPortfolioBalanceQueryValidator extends Validator
	{

		/**
		 * The Constructor
		 */
		public function FamPortfolioBalanceQueryValidator()
		{
			super();
		}

		// Define Array for the return value of doValidation().
		private var results:Array;

		/**
		 *
		 * validate Portfolio Balance Query form
		 */
		override protected function doValidation(value:Object):Array
		{

			if (value == null)
			{
				XenosAlert.info(Application.application.xResourceManager.getKeyValue('fam.label.object.null'));
				return null;
			}

			var allFundRadioFlag:String=value.allFundRadioFlag;
			var fundCodeFlag:String=value.fundCodeFlag;
			var baseDate:String=value.baseDate;
			var securityCode:String=value.securityCode;

			// Clear results Array.
			results=[];
			// Call base class's doValidation().
			results=super.doValidation(value);
			// Return if there are errors.
			if (results.length > 0)
			{
				return results;
			}
			// Base Date Validation.           
			if (XenosStringUtils.isBlank(baseDate))
			{
				results.push(new ValidationResult(true, "", "noBaseDate", Application.application.xResourceManager.getKeyValue('fam.label.enter.basedate')));
				return results;
			}
			var baseDateObj:Date=null;
			var dateformat:CustomDateFormatter=new CustomDateFormatter();
			if (!XenosStringUtils.isBlank(baseDate))
			{
				if (DateUtils.isValidDate(baseDate))
				{
					baseDateObj=dateformat.toDate(CustomDateFormatter.customizedInputDateString(baseDate));
				}
				else
				{
					results.push(new ValidationResult(true, "baseDate", "invalidBaseDate", Application.application.xResourceManager.getKeyValue('fam.lebel.invalid.basedate',new Array([baseDate]))));
				}
			}
			if (results.length > 0)
			{
				return results;
			}
			if (allFundRadioFlag == "true") // Security Code validation if 'all fund' selected
			{
				if (XenosStringUtils.isBlank(securityCode))
				{
					results.push(new ValidationResult(true, "", "noSecurityCode", Application.application.xResourceManager.getKeyValue('fam.lebel.enter.securitycode')));
					return results;
				}
			}
			else // Fund Code validation if 'select fund' selected
			{
				if (fundCodeFlag == "false")
				{
					results.push(new ValidationResult(true, "", "noFundCode", Application.application.xResourceManager.getKeyValue('fam.lebel.enter.fundcode')));
					return results;
				}
			}
			return results;
		}
	}
}
