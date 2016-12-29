package com.nri.rui.nam.validators
{
	import com.nri.rui.core.utils.XenosStringUtils;
	
	import mx.core.Application;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	public class SbaFeedExecutionValidator extends Validator
	{
		// Define Array for the return value of doValidation().
		private var results:Array;

		public function SbaFeedExecutionValidator()
		{
			super();
		}

		/**
		*
		* validate Monthly Valuation Schedule Entry
		*/
		protected override function doValidation(value:Object):Array
		{
			// Clear results Array.
			results=[];

			// Call base class's doValidation().
			results=super.doValidation(value);

			// Return if there are errors.
			if (results.length > 0)
				return results;

			if (XenosStringUtils.isBlank(value.officeId))
			{
				results.push(new ValidationResult(true, "officeId", "officeIdSbaMissing", Application.application.xResourceManager.getKeyValue('nam.sbaFeedExecution.alert.validator.officeIdSbaMissing')));
			}

			if (XenosStringUtils.isBlank(value.fundCategory))
			{
				results.push(new ValidationResult(true, "fundCategory", "fundCategorySbaMissing", Application.application.xResourceManager.getKeyValue('nam.sbaFeedExecution.alert.validator.fundCategorySbaMissing')));
			}

			return results;
		}

	}
}
