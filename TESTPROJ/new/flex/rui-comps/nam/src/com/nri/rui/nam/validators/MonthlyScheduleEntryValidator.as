package com.nri.rui.nam.validators
{
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;

	import mx.core.Application;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	public class MonthlyScheduleEntryValidator extends Validator
	{
		// Define Array for the return value of doValidation().
		private var results:Array;

		public function MonthlyScheduleEntryValidator()
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

			if (XenosStringUtils.isBlank(value.fundCodeGrid) || value.fundCodeGrid < 1)
			{
				results.push(new ValidationResult(true, "fundCodeGrid", "fundCodeMissing", Application.application.xResourceManager.getKeyValue('nam.monthlyReport.alert.validator.entry.fundCode')));
			}

			if (XenosStringUtils.isBlank(value.tempOrFinal))
			{
				results.push(new ValidationResult(true, "tempOrFinal", "tempOrFinalMissing", Application.application.xResourceManager.getKeyValue('nam.monthlyReport.alert.validator.entry.temporaryFinal')));
			}

			if (null != value.tempOrFinal && StringUtil.trim(value.tempOrFinal) == "Temporary")
			{
				if (XenosStringUtils.isBlank(value.reportPattern))
				{
					results.push(new ValidationResult(true, "reportPattern", "reportPatternMissing", Application.application.xResourceManager.getKeyValue('nam.monthlyReport.alert.validator.entry.reportPattern')));
				}
			}

			if (XenosStringUtils.isBlank(value.scheduleType))
			{
				results.push(new ValidationResult(true, "scheduleType", "scheduleTypeMissing", Application.application.xResourceManager.getKeyValue('nam.monthlyReport.alert.validator.entry.scheduleType')));
			}

			if (null != value.scheduleType && StringUtil.trim(value.scheduleType) == "Business Day")
			{
				if (XenosStringUtils.isBlank(value.generationDay))
				{
					results.push(new ValidationResult(true, "generationDay", "generationDayMissing", Application.application.xResourceManager.getKeyValue('nam.monthlyReport.alert.validator.entry.generationDay')));
				}
			}

			return results;
		}

	}
}
