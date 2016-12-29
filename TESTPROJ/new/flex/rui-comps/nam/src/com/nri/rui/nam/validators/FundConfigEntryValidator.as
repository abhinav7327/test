
package com.nri.rui.nam.validators
{
	import com.nri.rui.core.formatters.CustomDateFormatter;
	import com.nri.rui.core.utils.DateUtils;
	import com.nri.rui.core.utils.XenosStringUtils;

	import mx.controls.Alert;
	import mx.core.Application;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	import mx.validators.ValidationResult;
	import mx.validators.Validator;

	/**
	 * Custom Validator for Nam Feed Execute Implementation.
	 *
	 */
	public class FundConfigEntryValidator extends Validator
	{
		// Define Array for the return value of doValidation().
		private var results:Array;


		public function FundConfigEntryValidator()
		{
			super();
		}

		/**
		 *
		 * validate Nam Feed Execute entry form
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

			if (null != value.fundCategory && StringUtil.trim(value.fundCategory) == "OTHERS")
			{
				if (XenosStringUtils.isBlank(value.defUndAssetFX))
				{
					results.push(new ValidationResult(true, "defUndAssetFX", "defUndAssetFXMissing", Application.application.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.amend.defUndAssetFXMissing')));
				}

				if (XenosStringUtils.isBlank(value.actualIntrimFlag))
				{
					results.push(new ValidationResult(true, "actualIntrimFlag", "actualIntrimMissing", Application.application.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.amend.actualIntrimMissing')));
				}

				if (XenosStringUtils.isBlank(value.autoCompletionForMT566Reqd))
				{
					results.push(new ValidationResult(true, "autoCompletionForMT566Reqd", "autoCompMT566ReqdMissing", Application.application.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.amend.autoCompMT566ReqdMissing')));
				}

				if (XenosStringUtils.isBlank(value.accountingInfoRequired))
				{
					results.push(new ValidationResult(true, "accountingInfoRequired", "accInfoReqMissing", Application.application.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.amend.accInfoReqMissing')));
				}
			}

			if (null != value.accountingInfoRequired && StringUtil.trim(value.accountingInfoRequired) == "Yes")
			{
				if (XenosStringUtils.isBlank(value.gXODWRequired))
				{
					results.push(new ValidationResult(true, "gXODWRequired", "gXODWReqMissing", Application.application.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.amend.gXODWReqMissing')));
				}

				if (XenosStringUtils.isBlank(value.smartPortRequired))
				{
					results.push(new ValidationResult(true, "smartPortRequired", "smartPortReqMissing", Application.application.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.amend.smartPortReqMissing')));
				}

				if (XenosStringUtils.isBlank(value.dEXRequired))
				{
					results.push(new ValidationResult(true, "dEXRequired", "dEXReqMissing", Application.application.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.amend.dEXReqMissing')));
				}

				if (XenosStringUtils.isBlank(value.balanceToNBL))
				{
					results.push(new ValidationResult(true, "balanceToNBL", "balToNBLMissing", Application.application.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.amend.balToNBLMissing')));
				}

				if (XenosStringUtils.isBlank(value.shariahFlag))
				{
					results.push(new ValidationResult(true, "shariahFlag", "shariahFlagMissing", Application.application.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.amend.shariahFlagMissing')));
				}

				if (XenosStringUtils.isBlank(value.gstFlag))
				{
					results.push(new ValidationResult(true, "gstFlag", "gstFlagMissing", Application.application.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.amend.gstFlagMissing')));
				}

				if (XenosStringUtils.isBlank(value.reportDateFormat))
				{
					results.push(new ValidationResult(true, "reportDateFormat", "repDateFormatMissing", Application.application.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.amend.repDateFormatMissing')));
				}

				if ((!XenosStringUtils.isBlank(value.gXODWRequired) && StringUtil.trim(value.gXODWRequired) == "Yes") || (!XenosStringUtils.isBlank(value.smartPortRequired) && StringUtil.trim(value.smartPortRequired) == "Yes"))
				{
					if (XenosStringUtils.isBlank(value.businessStartDate))
					{
						results.push(new ValidationResult(true, "businessStartDate", "businessStartDateMissing", Application.application.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.amend.businessStartDateMissing')));
					}

				}
				var dateformat:CustomDateFormatter=new CustomDateFormatter();
				dateformat.formatString="YYYYMMDD";

				var businessStartDate:String=value.businessStartDate;
				var businessEndDate:String=value.businessEndDate;

				var startDateObj:Date=null;

				if (!XenosStringUtils.isBlank(businessStartDate))
				{

					if (DateUtils.isValidDate(businessStartDate))
					{
						startDateObj=dateformat.toDate(CustomDateFormatter.customizedInputDateString(businessStartDate));
					}
					else
					{
						results.push(new ValidationResult(true, "BusinessStartDate", "invalidBusinessStartDate", Application.application.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.amend.InvalidStartDate')));
					}
				}
				var endDateObj:Date=null;
				if (!XenosStringUtils.isBlank(businessEndDate))
				{
					if (DateUtils.isValidDate(businessEndDate))
					{
						endDateObj=dateformat.toDate(CustomDateFormatter.customizedInputDateString(businessEndDate));
					}
					else
					{
						results.push(new ValidationResult(true, "BusinessEndDate", "invalidBusinessEndDate", Application.application.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.amend.InvalidEndDate')));
					}
				}

				if (null != startDateObj && null != endDateObj)
				{
					var comDate:int=ObjectUtil.dateCompare(startDateObj, endDateObj);
					if (comDate == 1)
					{
						results.push(new ValidationResult(true, "fromDate", "invalidFromDate", Application.application.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.amend.startDateLessEndDate')));
					}

				}
			}

			if (!XenosStringUtils.isBlank(value.investStartDate))
			{
				if (!DateUtils.isValidDate(value.investStartDate))
				{
					results.push(new ValidationResult(true, "investStartDate", "invalidInvestStartDate", Application.application.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.amend.InvalidInvStartDate')));
				}
			}
			if (XenosStringUtils.isBlank(value.crimSuppressReqd))
			{
				results.push(new ValidationResult(true, "crimSuppressReqd", "crimSuppressReqdMissing", Application.application.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.amend.crimSuppressReqdMissing')));
			}
			if (XenosStringUtils.isBlank(value.balanceSuppressReqd))
			{
				results.push(new ValidationResult(true, "balanceSuppressReqd", "balSuppressReqdMissing", Application.application.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.amend.balSuppressReqdMissing')));
			}

			if (XenosStringUtils.isBlank(value.mT54XRuleForShortAccReqd))
			{
				results.push(new ValidationResult(true, "mT54XRuleForShortAccReqd", "mT54XRuleAccReqdMissing", Application.application.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.amend.mT54XRuleAccReqdMissing')));
			}
			if (XenosStringUtils.isBlank(value.fpsAdjustment))
			{
				results.push(new ValidationResult(true, "fpsAdjustment", "fpsAdjustmentMissing", Application.application.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.amend.fpsAdjustmentMissing')));
			}
			if (XenosStringUtils.isBlank(value.sbaRequiredFlag))
			{
				results.push(new ValidationResult(true, "sbaRequiredFlag", "sbaRequiredFlagMissing", Application.application.xResourceManager.getKeyValue('nam.fundConfig.alert.validator.amend.sbaRequiredFlagMissing')));
			}


			return results;
		}
	}
}