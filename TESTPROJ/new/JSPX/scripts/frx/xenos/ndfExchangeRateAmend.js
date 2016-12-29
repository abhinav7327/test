//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
var xenos$Handler$ndfExchangeAmend = xenos$Handler$function({
	get : {
		requestType : xenos$Handler$default.requestType.asynchronous,
		target : '#content'
	},
	settings : {
		beforeSend : function(request) {
			request.setRequestHeader('Accept', 'text/html;type=ajax');

		},
		type : 'POST'
	},
	callback : {
		success : function(evt, options) {
			if (options) {
				$.each(options['gridInstance'] || [], function(ind, grid) {
					grid.destroy();
				});
			}
		}
	}
});

xenos.ns.ndfExchangeAmend.submithandler = function(e) {
	Slick.GlobalEditorLock.commitCurrentEdit();
	var $target = $(this);
	var gridInstanceArray = [];
	var context = $target.closest('.formContent');
	var reqObj = {};
	var uri = xenos.context.path;

	var grid = $('.xenos-grid', context).data("gridInstance");

	grid.getEditController().commitCurrentEdit();
	if (typeof grid == "undefined") {
		return false;
	}
	var gridData = grid.getData().getItems();
	uri += "/secure/frx/ndf/exchangerate/query/ndfExchangeRateAmendUC";

	var selectedGrid = grid.getSelectedRows();
	var isChecked = false;

	if (typeof gridData == "undefined") {
		return false;
	}

	var validationMessages = [];
	var reqObj = {};
	if (selectedGrid.length == 0) {
		xenos.utils.displayGrowlMessage(xenos.notice.type.error,
				'Select at least one NDF Revaluation exchange Rate to Amend');
		return false;
	}

	var lngth = selectedGrid.length;
	var ndfExchangeRatePkArr = [];
	var exchangeRateStrArr = [];
	var baseDateDispArr = [];
	var statusArr = [];
	var rowNoArray = [];
	xenos.ns.ndfExchangeAmend.selectedRecordsIndex = [];
	function customPush(val, arr) {
		if (val == "" || val == null)
			arr.push(" ");
		else
			arr.push(val);

	}

	for (i = 0; i < lngth; i++) {
	debugger;
		var format = /^[0.-]+$/;
		if (!isChecked) {
			isChecked = true;
		}

		if (($.trim(gridData[selectedGrid[i]]['baseDateDisp'])) == "") {
			validationMessages
					.push(xenos$FRX$i18n.ndfExchangeRateAmend.basedate_empty);

		}

		if (($.trim(gridData[selectedGrid[i]]['exchangeRate'])) == "") {
			validationMessages
					.push(xenos$FRX$i18n.ndfExchangeRateAmend.exchangerate_empty);

		} else if((($.trim(gridData[selectedGrid[i]]['exchangeRate'])) == "0")||(format.test($.trim(gridData[selectedGrid[i]]['exchangeRate'])) ==true)) {
			validationMessages
					.push(xenos$FRX$i18n.ndfExchangeRateAmend.exchangerate_zero);

		}else if(isNaN($.trim(gridData[selectedGrid[i]]['exchangeRate']).replace(/\,/g,"")))
		{
			
			validationMessages.push(xenos$FRX$i18n.ndfExchangeRateAmend.exchangerate_invalid);
			
		}
		else if(/^[, ]+$/.test(gridData[selectedGrid[i]]['exchangeRate']))
		{
			validationMessages.push(xenos$FRX$i18n.ndfExchangeRateAmend.exchangerate_invalid);
		}
		else if($.trim(gridData[selectedGrid[i]]['exchangeRate']).replace(/\,/g,"")<0)
		{
			validationMessages.push(xenos$FRX$i18n.ndfExchangeRateAmend.exchangerate_invalid);
		}
		else 
		{
			fldValueArr = ($.trim(gridData[selectedGrid[i]]['exchangeRate']).replace(/\,/g,"")).split(".");
			if(fldValueArr[0].length > 10){
				validationMessages.push(xenos$FRX$i18n.ndfExchangeRateAmend.valid_before_decimal);
			}
			if(typeof fldValueArr[1] !='undefined' && fldValueArr[1].length > 10)
			{
				validationMessages.push(xenos$FRX$i18n.ndfExchangeRateAmend.valid_after_decimal);
			}
		}
		rowNoArray.push(gridData[selectedGrid[i]]['rowID']);
		customPush(gridData[selectedGrid[i]]['ndfRevalExchangeRatePk'],
				ndfExchangeRatePkArr);
		customPush(gridData[selectedGrid[i]]['status'],
				statusArr);
		customPush(gridData[selectedGrid[i]]['baseDateDisp'], baseDateDispArr);
		customPush($.trim(gridData[selectedGrid[i]]['exchangeRate']).replace(
				/\,/g, ""), exchangeRateStrArr);
		xenos.ns.ndfExchangeAmend.selectedRecordsIndex
				.push(gridData[selectedGrid[i]]['rowID']);
	}
	if (validationMessages.length > 0) {
		xenos.utils.displayGrowlMessage(xenos.notice.type.error,
				validationMessages);
		return false;
	}
	var container = $("#content");
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&fragments=content';
	var context = $target.closest('#content');

	var requestUrl = xenos.context.path
			+ "/secure/frx/ndf/exchangerate/query/ndfExchangeRateAmendUC"
			+ commandFormId + fragmentName;

	$(e.target).attr('disabled', true);

	xenos$Handler$ndfExchangeAmend.generic(e,
			{
				requestUri : requestUrl,
				settings : {
					data : jQuery.param({
						fragments : 'content',
						rowNoArray : rowNoArray,
						ndfExchangeRatePkArr : ndfExchangeRatePkArr,
						exchangeRateStrArr : exchangeRateStrArr,
						baseDateDispArr : baseDateDispArr,
						statusArr : statusArr
					}, true),
					complete : function() {
						$('#queryResultForm .xenos-grid', container).xenosgrid(
								grid_result_data, grid_result_columns,
								grid_result_settings);
					}

				},
				onHtmlContent : function(e, options, $target, content) {

					$target.html(content);

					var msg = [];
					if (content.indexOf('xenosWarn') != -1) {
						$.each($('ul.xenosWarn li', container), function(index,
								value) {

							var msgStr = $(value).text();

							if (msgStr !== '')
								msg.push(msgStr);
						});

						xenos.utils.displayGrowlMessage(
								xenos.notice.type.warning, msg);
					}

					if (content.indexOf('xenosError') == -1) {

						$('.tabArea').hide();
						$('.ndfSubmitBtn', container).hide();
						$('.ndfBackBtn', container).show();
						$('.ndfCnfBtn', container).show();
						$('.okBtn', container).hide();
						$('.resetBtn', container).hide();

					} else {
						var msg = [];
						$.each($('.xenosError li', content), function(index,
								value) {
							msg.push($(value).text());
						});
						xenos.utils.displayGrowlMessage(
								xenos.notice.type.error, msg);
					}

				}

			});

};

//Reset Handler
xenos.ns.ndfExchangeAmend.resethandler = function(e) {
	var $target = $(this);
	var gridInstanceArray = [];
	var context = $target.closest('.formContent');
	var reqObj = {};
	var uri = xenos.context.path;

	var reqObj = {};

	var container = $("#content");
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&fragments=content';
	var context = $target.closest('#content');
	var requestUrl = xenos.context.path
			+ "/secure/frx/ndf/exchangerate/query/resetResult" + commandFormId
			+ fragmentName;

	$(e.target).attr('disabled', true);

	xenos$Handler$ndfExchangeAmend.generic(e, {
		requestUri : requestUrl,
		settings : {
			type : "POST"

		},

		onHtmlContent : function(e, options, $target, content) {

			$target.html(content);
			if ($('.xenos-grid', container).length > 0) {
				var xenosgrid = $('#queryResultForm .xenos-grid', container)
						.xenosgrid(grid_result_data, grid_result_columns,
								grid_result_settings);
			}

			if (content.indexOf('xenosError') == -1) {

				$('.ndfSubmitBtn', container).show();
				$('.ndfBackBtn', container).hide();
				$('.ndfCnfBtn', container).hide();
				$('.ndfOkBtn', container).hide();
				$('.ndfResetBtn', container).show();

			}

		}
	});

};


//Backhandler
xenos.ns.ndfExchangeAmend.backhandler = function(e) {

	var $target = $(this);
	var gridInstanceArray = [];
	var context = $target.closest('.formContent');
	var reqObj = {};
	var uri = xenos.context.path;

	var reqObj = {};
	var container = $("#content");
	var form = $('#queryResultForm', container);
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&fragments=content';
	var context = $target.closest('#content');
	var requestUrl = xenos.context.path
			+ "/secure/frx/ndf/exchangerate/query/backResult" + commandFormId
			+ fragmentName;
	$(e.target).attr('disabled', true);

	xenos$Handler$ndfExchangeAmend
			.generic(
					e,
					{
						requestUri : requestUrl,
						settings : {
							type : "POST",
							complete : function(jqXHR) {
								$target.removeAttr('disabled');
								var gridInstanceArray = [];
								var grids = $("[class*=slickgrid_]", form);
								$.each(grids, function(ind, grid) {
									var gridObject = $(grid).data(
											"gridInstance");
									if (typeof gridObject !== 'undefined')
										gridInstanceArray.push(gridObject);
								});
								container.html(jqXHR.responseText);
								//Check the return page if return page equal query result then render grid.
								if ($('#queryForm', container).length == 0) {
									$('#queryResultForm .xenos-grid', container)
											.xenosgrid(grid_result_data,
													grid_result_columns,
													grid_result_settings);
									var grid = $('.xenos-grid', container)
											.data().gridInstance;
									grid
											.setSelectedRows(xenos.ns.ndfExchangeAmend.selectedRecordsIndex);

									/* $.each(gridInstanceArray || [], function (ind, grid) {						
										grid.destroy();
										delete grid;
									}); */
								}
							}

						},

						onHtmlContent : function(e, options, $target, content) {
							$target.html(content);
						}
					});

};


//Confirm Handler
xenos.ns.ndfExchangeAmend.confirmhandler = function(e) {
	var $target = $(this);
	var context = $target.closest('.formContent');
	var uri = xenos.context.path;
	var gridInstanceArray = [];

	var validationMessages = [];

	if (validationMessages.length > 0) {
		$('.formHeader').find('.formTabErrorIco').css('display', 'block');
		$('.formHeader').find('.formTabErrorIco').off('click');
		$('.formHeader').find('.formTabErrorIco').on(
				'click',
				xenos.postNotice(xenos.notice.type.error, validationMessages,
						true));
		return false;
	}

	var container = $("#content");
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&fragments=content';
	var context = $target.closest('#content');
	var requestUrl = xenos.context.path
			+ "/secure/frx/ndf/exchangerate/query/ndfExchangeRateAmendSC"
			+ commandFormId + fragmentName;
	$(e.target).attr('disabled', true);

	xenos$Handler$ndfExchangeAmend.generic(e, {
		requestUri : requestUrl,
		settings : {

			type : "POST",
			data : jQuery.param({
				fragments : 'content',

			}, true),

			complete : function() {
				$('#queryResultForm .xenos-grid', container).xenosgrid(
						grid_result_data, grid_result_columns,
						grid_result_settings);
			}
		},
		onHtmlContent : function(e, options, $target, content) {
			$target.html(content);
			xenos.utils.clearGrowlMessage();
		
			if (content.indexOf('xenosError') == -1) {
				xenos.utils.displayGrowlMessage(xenos.notice.type.info, 'Transaction completed successfully');
				$('.tabArea').hide();
				$('.ndfSubmitBtn', container).hide();
				$('.ndfBackBtn', container).hide();
				$('.ndfCnfBtn', container).hide();
				$('.ndfOkBtn', container).show();
				$('.ndfResetBtn', container).hide();

			} else {

				var msg = [];

				$.each($('ul.xenosError li', container),
						function(index, value) {

							var msgStr = $(value).text();

							if (msgStr !== '')
								msg.push(msgStr);
						});

				xenos.utils.displayGrowlMessage(xenos.notice.type.error, msg);
				$('.tabArea').hide();
				$('.ndfSubmitBtn', container).hide();
				$('.ndfBackBtn', container).show();
				$('.ndfCnfBtn', container).show();
				$('.ndfOkBtn', container).hide();
				$('.ndfResetBtn', container).hide();
				$.each(gridInstanceArray || [], function(ind, grid) {
					grid.destroy();
				});
			}
		}
	});

};

//Ok handler
xenos.ns.ndfExchangeAmend.okhandler = function(e) {

	var $target = $(this);
	var gridInstanceArray = [];
	var context = $target.closest('.formContent');
	var reqObj = {};
	var uri = xenos.context.path;

	var reqObj = {};

	var container = $("#content");
	var commandFormId = '?commandFormId=' + $('[name=commandFormId]').val();
	var fragmentName = '&fragments=content';
	var context = $target.closest('#content');
	var requestUrl = xenos.context.path
			+ "/secure/frx/ndf/exchangerate/query/resetResult" + commandFormId
			+ fragmentName;

	$(e.target).attr('disabled', true);

	xenos$Handler$ndfExchangeAmend.generic(e, {
		requestUri : requestUrl,
		settings : {
			type : "POST"

		},

		onHtmlContent : function(e, options, $target, content) {

			$target.html(content);
			if ($('.xenos-grid', container).length > 0) {
				var xenosgrid = $('#queryResultForm .xenos-grid', container)
						.xenosgrid(grid_result_data, grid_result_columns,
								grid_result_settings);
			}

			if (content.indexOf('xenosError') == -1) {

				$('.ndfSubmitBtn', container).show();
				$('.ndfBackBtn', container).hide();
				$('.ndfCnfBtn', container).hide();
				$('.ndfOkBtn', container).hide();
				$('.ndfResetBtn', container).show();

			}

		}
	});
};