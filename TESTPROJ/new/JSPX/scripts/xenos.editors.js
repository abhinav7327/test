//$Id$
//$Author: rajarsic $
//$Date: 2016-12-26 14:14:37 $
/***
 * Contains basic SlickGrid editors.
 * @module Editors
 * @namespace Slick
 */

(function ($) {
  // register namespace
  $.extend(true, window, {
    "Slick": {
      "Editors": {
        "xenosText": xenosTextEditor,
		"DropdownCellEditor": DropdownCellEditor,
		"Popup": PopupCellEditor,
		"xenosDate": xenosDateEditor,
		"xenosTextAndCheckbox" : xenosTextAndCheckboxEditor,
		"xenosButton" : xenosButtonEditor,
		"xenosDetailAndCheckbox" : xenosDetailAndCheckboxEditor,
		"xenosCheckbox"  : xenosCheckboxEditor,
		"ExerciseAmountEditer" : ExerciseAmountEditer,
		"ExerciseAmendCheckBox" : ExerciseAmendCheckBoxEditor,
		"exercisingQuantityEditor" : exercisingQuantityEditor,
		"exerciseAmendDateEditor" : exerciseAmendDateEditor,
		"exchangeRateEditor" : exchangeRateEditor,
		"ndfExchangeRateDateEditor" : ndfExchangeRateDateEditor
      }
    }
  });

  function xenosTextEditor(args) {
    var $input;
    var defaultValue;
    var scope = this;

    this.init = function () {
	  var column = args.column;
	  var readonly = false;
	  var isUpper = true;
	  var isInputFieldDisabled = false;
	  $input = $('<input type=text />');
	  if(column.options){
			if(column.options['editableFunction']){
				
				if(!column.options['editableFunction'](args)){
					$input.attr('readonly','readonly').attr('disabled','disabled');
					isInputFieldDisabled = true;
				}
			}
			if(column.options['styleClass']){
				$input.attr('class',column.options['styleClass']);
			}else{
				$input.attr('class','txtUpper').attr('style','height:20px;');
			}
			if(column.options['style']){
				$input.attr('style',column.options['style']);
			}			
			//MaxLength
			if(column.options['maxChars']){
				//alert(column.options['maxChars'] +' :' + column.options['maxChars'].value);
				$input.attr('maxlength',column.options['maxChars']);
			}
			// Size
			if(column.options['size']){
				$input.attr('size',column.options['size']);
			}
			// Width
			if(column.options['width']){
				$input.attr('width',column.options['width']);
			}else {
				$input.width($(args.container).innerWidth() - 10);  
			}
			// Amount Formatting
			// column.name has been passed to display the corresponding column name in error messages
			if(column.options['amountFormatReqrd']){
				$input.bind('change', function(e){
					formatAmount(this, column.name);
				})
			}
			// Quantity Formatting
			// column.name has been passed to display the corresponding column name in error messages
			if(column.options['quantityFormatReqrd']){
				$input.bind('change', function(e){
					formatQuantity(this, column.name);
				})
			}
	  }else {
		  $input.width($(args.container).innerWidth() - 10); 
	  }  
        $input.appendTo(args.container)
          .bind("keydown.nav", function (e) {
            if (e.keyCode === $.ui.keyCode.LEFT || e.keyCode === $.ui.keyCode.RIGHT) {
              e.stopImmediatePropagation();
            }
          });
		  args.item['_unLocked'] = false;
		//FIX for IE8 
		//IN IE8 version when a disabled field is clicked then a javascript error is shown as mentioned below:- 
		//Can't move focus to the control because it is invisible, not enabled, or of a type that does not accept the focus
        //Hence we need to check whether the cell clicked is disabled or not, if disabled, then do no focus the cell
		if(!isInputFieldDisabled){
			$input.focus();
			$input.select();
		}
    };

    this.destroy = function () {
	  args.item['_unLocked'] = true;
      $input.remove();
    };

    this.focus = function () {
      $input.focus();
    };

    this.getValue = function () {
      return $input.val();
    };

    this.setValue = function (val) {
      $input.val(val);
    };

    this.loadValue = function (item) {
      defaultValue = item[args.column.field] || "";
      $input.val(defaultValue);
      $input[0].defaultValue = defaultValue;
      $input.select();
    };

    this.serializeValue = function () {
      return $input.val();
    };

    this.applyValue = function (item, state) {
      item[args.column.field] = state;
    };

    this.isValueChanged = function () {
      return (!($input.val() == "" && defaultValue == null)) && ($input.val() != defaultValue);
    };

    this.validate = function () {
      if (args.column.validator) {
        var validationResults = args.column.validator($input.val());
        if (!validationResults.valid) {
          return validationResults;
        }
      }

      return {
        valid: true,
        msg: null
      };
    };
    this.init();
  }
  
  function DropdownCellEditor(args) {
            var $select;
            var defaultValue;
            var scope = this;
			var column = args.column;
			var option = column.options;
                      
            this.init = function() {
				var readonly = false;
				var tmpStr = "<select tabIndex='0' class='dropdowninput editable-select' ";
				if(column.options){
					if(column.options['editableFunction']){
						if(!column.options['editableFunction'](column,args.item)){
							readonly = true;
						} 
					}
				}
				if(readonly){
					tmpStr += "disabled='disabled' ";
				}
				tmpStr += "></select>";
				$select = $(tmpStr)
				
                var objCombo = $select;
				//objCombo.append($('<option></option>').attr('value', "").text("") )
				$.each(option.data,function(index,data){
					objCombo.append($('<option></option>').attr('value', data.value.toString()).text(data.label.toString()) )
				});
				
				//$select.width($(args.container).innerWidth() - 10); 
                $select.on('change', function(){
                  jQuery(document).trigger('xenos.dropdown-valueChanged', {value: $select.val(), args: args});
                });
                $select.appendTo(args.container);
                $select.focus();
            };

            this.destroy = function() {
                $select.remove();
            };

            this.focus = function() {
                $select.focus();
            };

            this.loadValue = function(item) {
                $select.val((defaultValue = item[args.column.field]));
                $select.select();
            };

            this.serializeValue = function() {
                return ($select.val() == "yes");
            };

            this.applyValue = function(item,state) {
                item[args.column.field] = $select.find(':selected').val();
            };
           
            this.isValueChanged = function() {
                return ($select.val() != defaultValue);
            };

            this.validate = function() {
                return {
                    valid: true,
                    msg: null
                };
            };

            this.init();
        }
  	/**
	 * SlickGrid editor which has a Enabled Text Box showing the value 
	 * and a popup alligned left by which the value can be selected and
	 * placed in the text box.
	 */
  	function PopupCellEditor(args) {
		var $input, $popupbtn, $popupIcon;
		var defaultValue;
		var scope = this;
		var column = args.column;
		var option = column.options || {};;

		this.init = function () {
			var textBoxOptions = option.textBox || {};
			var popUpOptions = option.popUp || {};
			
			var textBoxStyleClass = textBoxOptions['styleClass'] || "txtUpper";
			var textBoxDisabled = textBoxOptions['disabled'] || false;
			var textBoxReadOnly = textBoxOptions['readonly'] || false;
			$input = $("<input type=text class='textBox " + textBoxStyleClass + "' id='__popupTxt__'/>");
			if(textBoxDisabled){
				$input.attr('disabled', 'disabled');
			}
			if(textBoxReadOnly){
				$input.attr('readonly', 'readonly');
			}
			
			$input.attr('id', column.id);
			$input.width($(args.container).innerWidth() - 35);
			
			$input.appendTo(args.container);
			
			$popupbtn = $("<div class='popupBtn'/>").appendTo(args.container);
			
			$popupIcon = $("<input type='button' style='position:absolute;right:4px;'/>");
			$popupIcon.addClass('popupBtnIco');


			$popupIcon.attr('tgt', $input.attr('id'));

			$popupIcon.data('rowData',args.item);
			if(popUpOptions.popType){
				$popupIcon.attr('popType', popUpOptions.popType);
			}
			var popUpDisabled = popUpOptions['disabled'] || false;
			if(popUpDisabled){
				$popupIcon.attr('disabled', 'disabled');
			}
			var dialogCloseHandler = popUpOptions.dialogCloseHandler ? popUpOptions.dialogCloseHandler : function(){return {}}; 
			$popupIcon.attr('onDialogClose', popUpOptions.dialogCloseHandler); 
			var ctx = popUpOptions.ctx ? popUpOptions.ctx : [];
			for (i = 0; i < ctx.length; i++) {
				var tempArr = ctx[i].replace(/'/g, "").split(":");
				$popupIcon.attr(tempArr[0], tempArr[1]);
			}
			
			$popupIcon.val('');
			
			$popupbtn.append($popupIcon);
			$input.focus().select();
			
			//Currently,pressing Left/Right Arrow key to navigate textbox's content,leads to field switch.
			//Hence,the change is done.
			
			 $input.appendTo(args.container)
	          .bind("keydown.nav", function (e) {
	            if (e.keyCode === $.ui.keyCode.LEFT || e.keyCode === $.ui.keyCode.RIGHT) {
	              e.stopImmediatePropagation();
	            }
	          });
		};

		this.destroy = function () {
		   $input.unbind("keydown.nav");
		   $input.remove();
		   $popupbtn.remove();
		   $popupIcon.remove();
		};

		this.focus = function () {
			$input.focus();
		};

		this.getValue = function () {
			return $input.val();
		};

		this.setValue = function (val) {
			$input.val(val);
		};

		this.loadValue = function (item) {
			defaultValue = item[args.column.field] || "";
			$input.val(defaultValue);
			$input[0].defaultValue = defaultValue;
			if($input.hasClass('clearField')){
				$input.clearField();
			}
			$input.select();
		};

		this.serializeValue = function () {
			return $input.val();
		};

		this.applyValue = function (item, state) {
			item[args.column.field] = state;
		};

		this.isValueChanged = function () {
			return (!($input.val() == "" && defaultValue == null)) && ($input.val() != defaultValue);
		};

		this.validate = function () {
			if (args.column.validator) {
				var validationResults = args.column.validator($input.val());
				if (!validationResults.valid) {
				  return validationResults;
				}
			}
			return {
				valid: true,
				msg: null
			};
		};

		this.init();
  	}
		function xenosDateEditor(args){
			console.log("Date Editor");
			console.log(args);
			var $input;
			var defaultValue;
			var scope = this;
			var calendarOpen = false;
			var dateFormat = xenos$Cache.get('globalPrefs')['mappedUiDisplayDateFormat'];
			
			this.init = function () {
				$input = $("<input type=text class='dateinput' onchange='checkDate(this);' style='width:80px; height:20px;'/>");
				$input.appendTo(args.container);
				$input.focus().select();
				$input.datepicker({
					showOn: "button",
					buttonImageOnly: true,
					buttonImage: xenos.context.path + '/images/namrui/icon/calendarIco.png',
					dateFormat: dateFormat,
					beforeShow: function () {
					  calendarOpen = true
					},
					onClose: function () {
					  calendarOpen = false
					}
				});
                setTimeout(function(){$input.closest('div').find('.ui-datepicker-trigger').trigger('click');},100);
				//$input.width($input.width() - 18);
			}
		
			this.destroy = function () {
			  $.datepicker.dpDiv.stop(true, true);
			  $input.datepicker("hide");
			  $input.datepicker("destroy");
			  $input.remove();
			};

			this.show = function () {
			  if (calendarOpen) {
				$.datepicker.dpDiv.stop(true, true).show();
			  }
			};

			this.hide = function () {
			  if (calendarOpen) {
				$.datepicker.dpDiv.stop(true, true).hide();
			  }
			};

			this.position = function (position) {
			  if (!calendarOpen) {
				return;
			  }
			  $.datepicker.dpDiv
				  .css("top", position.top + 30)
				  .css("left", position.left);
			};

			this.focus = function () {
			  $input.focus();
			};

			this.loadValue = function (item) {
			  defaultValue = item[args.column.field];
			  $input.val(defaultValue);
			  $input[0].defaultValue = defaultValue;
			  $input.select();
			};

			this.serializeValue = function () {
			  return $input.val();
			};

			this.applyValue = function (item, state) {
			  item[args.column.field] = state;
			};

			this.isValueChanged = function () {
			  return (!($input.val() == "" && defaultValue == null)) && ($input.val() != defaultValue);
			};

			this.validate = function() {
                return {
                    valid: true,
                    msg: null
                };
            };

            this.init();		
	}
	/**
	 * SlickGrid editor which has a Disabled Text Box showing the value 
	 * and an editable Check Box just next to the disabled Text Box.
	 */
	function xenosTextAndCheckboxEditor(args) {

		var column = args.column;
		var $textSelect;
		var $select;
		var defaultTextValue="";
		var defaultValue;
		var scope = this;
		
		this.init = function () {
			var options = column.options || {};
			var textBoxOptions = options.textBox || {};
			var tbStyle = textBoxOptions.style || "";
			var checkBoxOptions = options.checkBox || {};
			var cbStyle = checkBoxOptions.style || "";
			var cbOnClick = checkBoxOptions.onClick || "";

			//ToDo
			//Currently the Text Box is kept as disabled by default, 
			//in future it should be externalized and hence the other change events should be handled in this editor
			//$textSelect = $("<input type='text' disabled='true' value='' hideFocus>");
			if(tbStyle != ""){
				$textSelect.attr('style', tbStyle);
			}
			$select = $("<input type=checkbox value='' name='" + column.checkBoxId + "' class='editor-checkbox'>");
			$textSelect.appendTo(args.container);
			$select.appendTo(args.container);
			if(cbStyle != ""){
				$select.attr('style', cbStyle);
			}
			if(cbOnClick != ""){
				$select.bind('click', [args], cbOnClick);	
			}
			$select.focus();	
			
		};

		this.destroy = function () {
		  $textSelect.remove();
		  $select.unbind('click');
		  $select.remove();
		};

		this.focus = function () {
		 $textSelect.focus();
		  $select.focus();
		};

		this.loadValue = function (item) {
		    defaultTextValue = item[column.field];
		    defaultValue = item[column.checkBoxId];
		    if(defaultTextValue != ""){
				$textSelect.val(defaultTextValue);
		    }
		    if (defaultValue == 'Y') {
			  $select.attr("checked", "checked");
			  $select.val('Y');
		    } else {
			  $select.removeAttr("checked");
		    }
		};

		this.serializeValue = function () {
			if($select.attr("checked") == 'checked'){
				return "Y";
			}else{
				return "";
			}
		};

		this.applyValue = function (item, state) {
		    item[column.checkBoxId] = state;
		};

		this.isValueChanged = function () {
		   return ($select.val() != defaultValue);
		};

		this.validate = function () {
		  return {
			valid: true,
			msg: null
		  };
		};

		this.init();
	}
	
	/**
	 * SlickGrid button editor
	 */
	function xenosButtonEditor(args) {
		var column = args.column;
		var options = column.options || {};
		var $select;
		var $tempHiddenInputArray = [];
		var onChangeHiddenInputId = "";
		var defaultValue;
		var scope = this;
		
		this.init = function () {
			$select = $("<input type='button' popType='' tgt='' value='' populateReq='' onDialogClose='' class='listBtn popupBtn inputBtnStyle'>");
			$select.appendTo(args.container);

			$select.attr('popType', options.popUpType); 
			$select.attr('tgt', options.tgt);
			
			var populateReqHandler = options.populateReqHandler ? options.populateReqHandler : function(){return {}}; 
		    var dialogCloseHandler = options.dialogCloseHandler ? options.dialogCloseHandler : function(){return {}}; 
			$select.attr('populateReq', populateReqHandler); 
			$select.attr('onDialogClose', dialogCloseHandler); 

			onChangeHiddenInputId = options.onChangeHiddenInputId ? options.onChangeHiddenInputId : '';

			var hiddenTgt = '';
			var hiddenTgtId = options.hiddenTgtId ? options.hiddenTgtId : [];
			for (i = 0; i < hiddenTgtId.length; i++) {
				if(i != 0){
					hiddenTgt += ",";
				}
				var tempArr = hiddenTgtId[i].replace(/'/g, "").split(":");
				hiddenTgt += (tempArr[0] + ":" + tempArr[1]);
				
				var $tempHiddenInput = $("<input type='hidden' id='" + tempArr[0] + "' value=''>");
				if(tempArr[0] == onChangeHiddenInputId){
					$tempHiddenInput.bind('change', [args], options.onChange);
				}
				$tempHiddenInputArray.push($tempHiddenInput);
				$tempHiddenInput.appendTo(args.container);
			}
			$select.attr('hiddentgt', hiddenTgt);
			$select.bind('click', [args], options.onClick);
			
			$select.focus();
			$select.trigger('click');
		};

		this.destroy = function () {
		    $select.unbind('click');
		    $select.remove();
		    for (i = 0; i < $tempHiddenInputArray.length; i++) {
				$tempHiddenInputArray[i].remove();
				if($tempHiddenInputArray[i].attr('id') == onChangeHiddenInputId){
					$tempHiddenInputArray[i].unbind('change');
				}
		    }
		};
		
		this.focus = function () {
		   $select.focus();
		};

		this.loadValue = function (item) {
		    defaultValue = item[column.field];
		    if(defaultValue != ""){
				$select.val(defaultValue);
		    }
		};

		this.serializeValue = function () {
			return $select.val();
		};

		this.applyValue = function (item, state) {
			item[args.column.field] = state;
		};

		this.isValueChanged = function () {
		   return true;
		};

		this.validate = function () {
		  return {
			valid: true,
			msg: null
		  };
		};

		this.init();
	}
	
	/**
	 * SlickGrid editor which has a detail area showing the value 
	 * and an editable Check Box just next to the disabled Text Box.
	 */
	function xenosDetailAndCheckboxEditor(args) {
		var column = args.column;
		var $textSelect;
		var $select;
		var defaultTextValue="";
		var defaultValue;
		var scope = this;
		
		this.init = function () {
			var options = column.options || {};
			var textBoxOptions = options.textBox || {};
			var tbStyle = textBoxOptions.style || "";
			var checkBoxOptions = options.checkBox || {};
			var cbStyle = checkBoxOptions.style || "";
			var cbOnClick = checkBoxOptions.onClick || "";
			var disabled = checkBoxOptions.disabled || false;
			var methodType = options.methodType ? options.methodType : "";
			var requestData = function(){return {}}; 
			if($.isFunction(options.requestData)){
				requestData = options.requestData(column, args.item);
			}
			$textSelect = $("<span>");
			var hyperLinkReqd = ((typeof options.hyperLinkReqd == 'undefined') ? true : options.hyperLinkReqd);
			if(hyperLinkReqd){
				$textSelect.attr("class", 'detail-view-hyperlink');
			}
			if(tbStyle != ""){
				$textSelect.attr('style', tbStyle);
			}
			
			var title = options.dialogTitle || "";
			var dialogTitleValueReqd = options.dialogTitleValueReqd || true;
			var dialogTitleValue = ($.trim(args.item[options.dialogTitleValue]) || $.trim(args.item[column.field]));
			if(dialogTitleValueReqd){
				dialogTitle = "[" + dialogTitleValue + "] ";
			}
			dialogTitle += title;
			$textSelect.attr("view",(options.view || ""))
						.attr('dialogTitle', dialogTitle)
						.attr('title',$.trim(args.item[column.field]));
			if($.trim(options.height)!= ""){
				$textSelect.attr('dialog_Height', options.height);
			}
			if($.trim(methodType) != ""){
				$textSelect.attr("method", methodType);
				if($.trim(requestData) != ""){
					$textSelect.attr("requestData", requestData);
				}
				var url = options.url.replace('{rowIndex}',args.item.id) + $.trim(args.item[options.pkFieldName]) + "?popup=true";
				$textSelect.attr("href", url);
			}
			
			$textSelect.off('click');
			$textSelect.appendTo(args.container);
			$select = $("<input type=checkbox value='' name='" + column.checkBoxId + "' class='editor-checkbox'>");
			$select.appendTo(args.container);
			
			if(disabled){
				$select.attr('disabled', disabled);
			}
			
			if(cbStyle != ""){
				$select.attr('style', cbStyle);
			}
			if(cbOnClick != "" && !disabled){
				$select.bind('click', [args], cbOnClick);
			}
			
			//FIX for IE8 
			//IN IE8 version when a disabled field is clicked then a javascript error is shown as mentioned below:- 
			//Can't move focus to the control because it is invisible, not enabled, or of a type that does not accept the focus
	        //Hence we need to check whether the cell clicked is disabled or not, if disabled, then do no focus the cell
			if(!disabled){
				$select.focus();
			}
		};

		this.destroy = function () {
		  $textSelect.unbind('click');
		  $textSelect.remove();
		  $select.unbind('click');
		  $select.remove();
		};

		this.focus = function () {
		  $textSelect.focus();
		  $select.focus();
		};

		this.loadValue = function (item) {
		    defaultTextValue = item[column.field];
		    defaultValue = item[column.checkBoxId];
		    if(defaultTextValue != ""){
				$textSelect.append(defaultTextValue);
		    }
		    if (defaultValue == 'Y') {
			  $select.attr("checked", "checked");
			  $select.val('Y');
		    } else {
			  $select.removeAttr("checked");
		    }
		};

		this.serializeValue = function () {
			if($select.attr("checked") == 'checked'){
				return "Y";
			}else{
				return "";
			}
		};

		this.applyValue = function (item, state) {
		    item[column.checkBoxId] = state;
		};

		this.isValueChanged = function () {
		   return ($select.val() != defaultValue);
		};

		this.validate = function () {
		  return {
			valid: true,
			msg: null
		  };
		};

		this.init();
	}

	function xenosCheckboxEditor(args) {
		 var $select;
    var defaultValue;
    var scope = this;

    this.init = function () {
      $select = $("<INPUT type=checkbox value='true' class='editor-checkbox' hideFocus>");
      $select.appendTo(args.container);
      $select.focus();
    };

    this.destroy = function () {
      $select.remove();
    };

    this.focus = function () {
      $select.focus();
    };

    this.loadValue = function (item) {
      defaultValue = item[args.column.field];
      if (defaultValue) {
        $select.attr("checked", "checked");
      } else {
        $select.removeAttr("checked");
      }
    };

    this.serializeValue = function () {
      return $select.attr("checked");
    };

    this.applyValue = function (item, state) {
      item[args.column.field] = state;
    };

    this.isValueChanged = function () {
      return ($select.attr("checked") != defaultValue);
    };

    this.validate = function () {
      return {
        valid: true,
        msg: null
      };
    };

    this.init();
  }

  
	function ExerciseAmountEditer(args){
		var $input;
		var $calculator;
	    var defaultValue;
	    var scope = this;
		 this.init = function () {
		  var column = args.column;
		  var readonly = false;
		  var isUpper = true;
		   var prev = args.item.prevFinalizeFlag;
		 var flag = args.item.exerciseFinalizeFlag;
		  $calculator =	$("<img class='ui-datepicker-trigger ui-calc-trigger editableGridCalcPos'"
						   + " src='"+xenos.context.path+"/images/xenos/icon/icon_calculator.png' alt='' title=''/>");
				
		  $input = $("<input type=text style='height:15px; text-align:right;font-size:12px;padding-top:0;padding-bottom:0;'/>");
				if(column.options){
					if(column.options['editableFunction']){
						if(!column.options['editableFunction'](args)){
							$input.attr('readonly','readonly');
						}
					} 
					if(column.options['styleClass']){
						$input.attr('class',column.options['styleClass']);
					}else{
						$input.attr('class','txtUpper').attr('style','height:20px;');
					} 
					//MaxLength
					if(column.options['maxChars']){
						$input.attr('maxlength',column.options['maxChars']);
					}
					//Bind the onclick event to the calculator image
					if(column.options['onClick']){
						$calculator.bind('click', [args], column.options['onClick']);
						function clickit(){
							$calculator.filter(':hover').trigger('click');	
						}
						setTimeout(clickit, 10); 
					}
					// Quantity Formatting
					// column.name has been passed to display the corresponding column name in error messages
					if(column.options['quantityFormatReqrd']){
						//alert(column.name);
						$input.bind('keydown', function(e){
							var key = e.which || e.keyCode;
							if(key == 9 || key ==13)
							{formatQuantity($(this),15,3,null,column.name);
							xenos$ExerciseAmend$Persist$TakeUpCost($(this).val(),args);
							if(key==13)
									 e.stopImmediatePropagation();
							}
						})
						$input.bind('change', function(e){
							{formatQuantity($(this),15,3,null,column.name);
							xenos$ExerciseAmend$Persist$TakeUpCost($(this).val(),args)}
						})
						
					}
					
				
				}
			if(prev == "Y")
			{
				$input.attr('readonly','readonly').attr('disabled','disabled');
				$calculator.unbind('click');
				//isInputFieldDisabled = true;
			}
			else if(flag == "Y")
					{
						$input.attr('readonly','readonly').attr('disabled','disabled');
						$calculator.unbind('click');
					}
					else
					{
						$input.removeAttr("readonly").removeAttr("disabled");
						$calculator.bind('click', [args], column.options['onClick']);
					}
		  
			  $input.width(130);
			  $input.appendTo(args.container)
	          .bind("keydown.nav", function (e) {
	            if (e.keyCode === $.ui.keyCode.LEFT || e.keyCode === $.ui.keyCode.RIGHT || e.keyCode === $.ui.keyCode.UP || e.keyCode === $.ui.keyCode.DOWN) {
	              e.stopImmediatePropagation();
	            }
	          });
			  $calculator.appendTo(args.container);
			  $input.focus();
			  $calculator.focus();
			  $calculator.select();
	    };

		this.destroy = function () {
	      $input.remove();
		  $calculator.remove();
	    };

	    this.focus = function () {
		    $input.focus();
			$calculator.focus();
	    };

	    this.getValue = function () {
	      return $input.val();
	    };

	    this.setValue = function (val) {
	      $input.val(val);
	    };

	    this.loadValue = function (item) {
	      defaultValue = item[args.column.field];
	      $input.val(defaultValue);
	      $input[0].defaultValue = defaultValue;
	      $input.select();
	    };
		  this.serializeValue = function () {
	      return $input.val();
	    };

	    this.applyValue = function (item, state) {
	      item[args.column.field] = state;
	    };

	    this.isValueChanged = function () {
	      return (!($input.val() == "" && defaultValue == null)) && ($input.val() != defaultValue);
	    };

	    this.validate = function () {
	      if (args.column.validator) {
	        var validationResults = args.column.validator($input.val());
	        if (!validationResults.valid) {
	          return validationResults;
	        }
	      }

	      return {
	        valid: true,
	        msg: null
	      };
	    };
	    this.init();
		}

	function ExerciseAmendCheckBoxEditor(args) {
		 var $select;
		 var column = args.column;
	    var defaultValue;
	    var scope = this;

	    this.init = function () {
	      var availableRightsStr = args.item.availableRightsStr;
		  var prev =  args.item.prevFinalizeFlag;
		  var isInputFieldDisabled;
	      $select = $("<INPUT type=checkbox value='true' class='editor-checkbox' hideFocus>");
	      $select.appendTo(args.container);
	      if(prev != "Y" && availableRightsStr == "0")
			{
				
				$select.attr('disabled','true');
				isInputFieldDisabled = true;
			}
		  if(column.options['onClick']){
						$select.bind('click', [args], column.options['onClick']);
					
				
						 function clickit(){
							if(!isInputFieldDisabled)
							$select.filter(':hover').trigger('click');	
						}
						setTimeout(clickit, 10); 
					}
	      $select.focus();
	    };

	    this.destroy = function () {
	      $select.remove();
	    };

	    this.focus = function () {
	      $select.focus();
	    };
	    this.loadValue = function (item) {
			
	      defaultValue = item[args.column.field];
	      if (defaultValue == "Y" || defaultValue == "checked" ) {
	        $select.attr("checked", "checked");
	      } else {
	        $select.removeAttr("checked");
	      }
	    };

	    this.serializeValue = function () {
	      return $select.attr("checked");
	    };

	    this.applyValue = function (item, state) {
		
	    };

	    this.isValueChanged = function () {
	      return ($select.attr("checked") != defaultValue);
	    };

	    this.validate = function () {
	      return {
	        valid: true,
	        msg: null
	      };
	    };

	    this.init();
	  }
	  
	function exercisingQuantityEditor(args) {
	    var $input;
	    var defaultValue;
	    var scope = this;

	    this.init = function () {
		  var column = args.column;
		  var readonly = false;
		  var isUpper = true;
		  var isInputFieldDisabled = false;
		 var prev = args.item.prevFinalizeFlag;
		 var flag = args.item.exerciseFinalizeFlag;
		  $input = $('<input type=text style="width:150px; height:15px;" />');
		  /* $input.bind('change',function(e){
				args.item.totalSubscriptionCostStr = "";
					}); */
		  if(column.options){
				if(column.options['editableFunction']){
					
					if(!column.options['editableFunction'](args)){
						$input.attr('readonly','readonly').attr('disabled','disabled');
						isInputFieldDisabled = true;
					}
				}
				if(column.options['styleClass']){
					$input.attr('class',column.options['styleClass']);
				}else{
					$input.attr('class','txtUpper').attr('style','height:20px;');
				}
				if(column.options['style']){
					$input.attr('style',column.options['style']);
				}			
				//MaxLength
				if(column.options['maxChars']){
					//alert(column.options['maxChars'] +' :' + column.options['maxChars'].value);
					$input.attr('maxlength',column.options['maxChars']);
				}
				// Size
				if(column.options['size']){
					$input.attr('size',column.options['size']);
				}
				// Width
				if(column.options['width']){
					$input.attr('width',column.options['width']);
				}else {
					$input.width($(args.container).innerWidth() - 10);  
				}
				// Amount Formatting
				// column.name has been passed to display the corresponding column name in error messages
				if(column.options['amountFormatReqrd']){
					$input.bind('change', function(e){
						formatAmount(this, column.name);
						
					})
				}
				// Quantity Formatting
				// column.name has been passed to display the corresponding column name in error messages
				if(column.options['quantityFormatReqrd']){
					//alert(column.name);
					$input.bind('keydown', function(e){
						var key = e.which || e.keyCode;
						if(key == 9 || key ==13)
							{
								
								formatQuantity($(this),15,3,null,column.name);
								xenos$ExerciseAmend$exercisingQty$Persist($(this).val(),args,key);}
								if(key==13)
									 e.stopImmediatePropagation();
						
					})
					$input.bind('change', function(e){

						formatQuantity($(this),15,3,null,column.name);
						xenos$ExerciseAmend$exercisingQty$Persist($(this).val(),args,0);
					})
					
				}
		  }else {
			  $input.width($(args.container).innerWidth() - 10); 
		  }
			if(prev == "Y")
			{
				$input.attr('readonly','readonly').attr('disabled','disabled');
				isInputFieldDisabled = true;
			}
			else if(flag == "Y")
					{
						$input.attr('readonly','readonly').attr('disabled','disabled');
				isInputFieldDisabled = true;
					}
					else
					{
						$input.removeAttr("readonly").removeAttr("disabled");
					isInputFieldDisabled = false;
					}
			 $input.appendTo(args.container)
	          .bind("keydown.nav", function (e) {
	            if (e.keyCode === $.ui.keyCode.LEFT || e.keyCode === $.ui.keyCode.RIGHT || e.keyCode === $.ui.keyCode.UP || e.keyCode === $.ui.keyCode.DOWN) {
	              e.stopImmediatePropagation();
	            }
	          });
			  args.item['_unLocked'] = false;
			//FIX for IE8 
			//IN IE8 version when a disabled field is clicked then a javascript error is shown as mentioned below:- 
			//Can't move focus to the control because it is invisible, not enabled, or of a type that does not accept the focus
	        //Hence we need to check whether the cell clicked is disabled or not, if disabled, then do no focus the cell
			if(!isInputFieldDisabled){
				$input.focus();
				$input.select();
			}
	    };

	    this.destroy = function () {
		  args.item['_unLocked'] = true;
	      $input.remove();
	    };

	    this.focus = function () {
	      $input.focus();
	    };

	    this.getValue = function () {
	      return $input.val();
	    };

	    this.setValue = function (val) {
	      $input.val(val);
	    };

	    this.loadValue = function (item) {
	      defaultValue = item[args.column.field] || "";
	      $input.val(defaultValue);
	      $input[0].defaultValue = defaultValue;
	      $input.select();
	    };

	    this.serializeValue = function () {
	      return $input.val();
	    };

	    this.applyValue = function (item, state) {
	      item[args.column.field] = state;
	    };

	    this.isValueChanged = function () {
	      return (!($input.val() == "" && defaultValue == null)) && ($input.val() != defaultValue);
	    };

	    this.validate = function () {
	      if (args.column.validator) {
	        var validationResults = args.column.validator($input.val());
	        if (!validationResults.valid) {
	          return validationResults;
	        }
	      }

	      return {
	        valid: true,
	        msg: null
	      };
	    };
	    this.init();
	  }
	  
	function exerciseAmendDateEditor(args){
		//console.log("Date Editor");
		//console.log(args);
		var $input;
		var defaultValue;
		var scope = this;
		var calendarOpen = false;
		var dateFormat = xenos$Cache.get('globalPrefs')['mappedUiDisplayDateFormat'];
		
		this.init = function () {
			 var prev = args.item.prevFinalizeFlag;
			var flag = args.item.exerciseFinalizeFlag;
			  var column = args.column;
			$input = $("<input type=text class='dateinput'  style='width:80px; height:15px;text-align:center;'/>");
			if(column.options['disableOption']){
				if(prev == "Y")
			{
				$input.attr('readonly','readonly').attr('disabled','disabled');
			}
			else if(flag == "Y")
			{
				$input.attr('readonly','readonly').attr('disabled','disabled');
			}
			else
			{
					$input.removeAttr("readonly").removeAttr("disabled");
					
			}
			}
			
			$input.bind('change',function(e)
					{
						var dateVal = $input.val();
						if(!checkDate(this))
						{
							$input.val("");
						}
						else
							{
								if(dateVal.length == 7){
									$input.val(dateVal.substr(0,6)+"0"+dateVal.substr(6));
								}
							}
					}
					);
					$input.bind('keydown', function(e){
						var key = e.which || e.keyCode;
						var dateVal = $input.val();
						if(key == 9 || key ==13)
						{
							
							if(!checkDate(this))
								{
									$input.val("");
								}
							else
							{
								if(dateVal.length == 7){
									$input.val(dateVal.substr(0,6)+"0"+dateVal.substr(6));
								}
							}
							if(key==13)
									e.stopImmediatePropagation();
						}
					});
			 $input.appendTo(args.container)
	          .bind("keydown.nav", function (e) {
	            if (e.keyCode === $.ui.keyCode.LEFT || e.keyCode === $.ui.keyCode.RIGHT || e.keyCode === $.ui.keyCode.UP || e.keyCode === $.ui.keyCode.DOWN) {
	              e.stopImmediatePropagation();
	            }
	          });
			$input.focus().select();
			$input.datepicker({
				showOn: "button",
				buttonImageOnly: true,
				buttonImage: xenos.context.path + '/images/namrui/icon/calendarIco.png',
				dateFormat: dateFormat,
				beforeShow: function () {
				  calendarOpen = true
				},
				onClose: function () {
				  calendarOpen = false
				}
			});
			if(column.options['disableOption']){
			if(prev == "Y")
			{
				$input.datepicker().datepicker('disable');
			}
			else if(flag == "Y")
			{
				$input.datepicker().datepicker('disable');
			}
			else
			{
					$input.removeAttr("readonly").removeAttr("disabled");
					
			}
			}
            setTimeout(function(){$input.closest('div').find('.ui-datepicker-trigger').trigger('click');},100);
			//$input.width($input.width() - 18);
		}
	
		this.destroy = function () {
		  $.datepicker.dpDiv.stop(true, true);
		  $input.datepicker("hide");
		  $input.datepicker("destroy");
		  $input.remove();
		};

		this.show = function () {
		  if (calendarOpen) {
			$.datepicker.dpDiv.stop(true, true).show();
		  }
		};

		this.hide = function () {
		  if (calendarOpen) {
			$.datepicker.dpDiv.stop(true, true).hide();
		  }
		};

		this.position = function (position) {
		  if (!calendarOpen) {
			return;
		  }
		  $.datepicker.dpDiv
			  .css("top", position.top + 30)
			  .css("left", position.left);
		};

		this.focus = function () {
		  $input.focus();
		};

		this.loadValue = function (item) {
		  defaultValue = item[args.column.field];
		  $input.val(defaultValue);
		  $input[0].defaultValue = defaultValue;
		  $input.select();
		};

		this.serializeValue = function () {
		  return $input.val();
		};

		this.applyValue = function (item, state) {
		  item[args.column.field] = state;
		};

		this.isValueChanged = function () {
		  return (!($input.val() == "" && defaultValue == null)) && ($input.val() != defaultValue);
		};

		this.validate = function() {
            return {
                valid: true,
                msg: null
            };
        };

        this.init();		
	}
	
	function exchangeRateEditor(args){
		var $input;
		
	    var defaultValue;
	    var scope = this;
	    this.init = function () {
	    	var column = args.column;
			var readonly = false;
			var isUpper = true;
		  	$input = $("<input type=text style='width:96%; height:15px; text-align:right;font-size:12px;padding-top:0;padding-bottom:0;'/>");
				if(column.options){
					if(column.options['editableFunction']){
						if(!column.options['editableFunction'](args)){
							$input.attr('readonly','readonly');
						}
					} 
					if(column.options['styleClass']){
						$input.attr('class',column.options['styleClass']);
					}else{
						$input.attr('class','txtUpper').attr('style','height:20px;');
					} 
					// Quantity Formatting
					// column.name has been passed to display the corresponding column name in error messages
					if(column.options['rateFormatReqrd']){
						//alert(column.name);
						$input.bind('keydown', function(e){
							var key = e.which || e.keyCode;
							if(key == 9 || key ==13){
							formatQuantity($(this),10,10,null,column.name);
							ndfAmendPersist($(this).val(),args);
							}
						})
						$input.bind('change', function(e){
							formatQuantity($(this),10,10,null,column.name);
							ndfAmendPersist($(this).val(),args);
						})
						
					}
				
				}
			
			  $input.appendTo(args.container)
	          .bind("keydown.nav", function (e) {
	            if (e.keyCode === $.ui.keyCode.LEFT || e.keyCode === $.ui.keyCode.RIGHT || e.keyCode === $.ui.keyCode.UP || e.keyCode === $.ui.keyCode.DOWN) {
	              e.stopImmediatePropagation();
	            }
	          });
			  $input.focus();
			
	    };

		this.destroy = function () {
	      $input.remove();
		 
	    };

	    this.focus = function () {
		    $input.focus();
		
	    };

	    this.getValue = function () {
	      return $input.val();
	    };

	    this.setValue = function (val) {
	      $input.val(val);
	    };

	    this.loadValue = function (item) {
	      defaultValue = item[args.column.field];
	      $input.val(defaultValue);
	      $input[0].defaultValue = defaultValue;
	      $input.select();
	    };
		  this.serializeValue = function () {
	      return $input.val();
	    };

	    this.applyValue = function (item, state) {
	      item[args.column.field] = state;
	    };

	    this.isValueChanged = function () {
	      return (!($input.val() == "" && defaultValue == null)) && ($input.val() != defaultValue);
		 
	    };

	    this.validate = function () {
	      if (args.column.validator) {
	        var validationResults = args.column.validator($input.val());
	        if (!validationResults.valid) {
	          return validationResults;
	        }
	      }

	      return {
	        valid: true,
	        msg: null
	      };
	    };
	    this.init();
		}
	
	function ndfExchangeRateDateEditor(args){
		var $input;
		var defaultValue;
		var scope = this;
		var calendarOpen = false;
		var dateFormat = xenos$Cache.get('globalPrefs')['mappedUiDisplayDateFormat'];
		
		this.init = function () {
			var column = args.column;
			$input = $("<input type=text class='dateinput'  style='width:80px; height:15px;text-align:center;'/>");
					
			$input.bind('change',function(e)
			{
				if(!checkDate(this))
				{
					$input.val("");
				}
				if(this.value.length == 7)
				{
					$input.val(this.value.substr(0,6)+"0"+this.value.substr(6));
				}
			}
			);
			$input.bind('keydown', function(e){
				var key = e.which || e.keyCode;
				if(key == 9 || key ==13)
				{
					if(!checkDate(this))
					{
							$input.val("");
					}
					if(this.value.length == 7)
					{
						$input.val(this.value.substr(0,6)+"0"+this.value.substr(6));
					}	
					if(key==13)
									 e.stopImmediatePropagation();
				}
			});
			 $input.appendTo(args.container)
	          .bind("keydown.nav", function (e) {
	            if (e.keyCode === $.ui.keyCode.LEFT || e.keyCode === $.ui.keyCode.RIGHT || e.keyCode === $.ui.keyCode.UP || e.keyCode === $.ui.keyCode.DOWN) {
	              e.stopImmediatePropagation();
	            }
	          });
			$input.focus().select();
			$input.datepicker({
				showOn: "button",
				buttonImageOnly: true,
				buttonImage: xenos.context.path + '/images/namrui/icon/calendarIco.png',
				dateFormat: dateFormat,
				beforeShow: function () {
				  calendarOpen = true
				},
				onClose: function () {
				  calendarOpen = false
				}
			});
            setTimeout(function(){$input.closest('div').find('.ui-datepicker-trigger').trigger('click');},100);
			//$input.width($input.width() - 18);
		}
	
		this.destroy = function () {
		  $.datepicker.dpDiv.stop(true, true);
		  $input.datepicker("hide");
		  $input.datepicker("destroy");
		  $input.remove();
		};

		this.show = function () {
		  if (calendarOpen) {
			$.datepicker.dpDiv.stop(true, true).show();
		  }
		};

		this.hide = function () {
		  if (calendarOpen) {
			$.datepicker.dpDiv.stop(true, true).hide();
		  }
		};

		this.position = function (position) {
		  if (!calendarOpen) {
			return;
		  }
		  $.datepicker.dpDiv
			  .css("top", position.top + 30)
			  .css("left", position.left);
		};

		this.focus = function () {
		  $input.focus();
		};

		this.loadValue = function (item) {
		  defaultValue = item[args.column.field];
		  $input.val(defaultValue);
		  $input[0].defaultValue = defaultValue;
		  $input.select();
		};

		this.serializeValue = function () {
		  return $input.val();
		};

		this.applyValue = function (item, state) {
		  item[args.column.field] = state;
		};

		this.isValueChanged = function () {
		  return (!($input.val() == "" && defaultValue == null)) && ($input.val() != defaultValue);
		};

		this.validate = function() {
            return {
                valid: true,
                msg: null
            };
        };

        this.init();		
	}




	})(jQuery);
