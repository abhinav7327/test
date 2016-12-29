//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
//
// xenos
//  - Wizard infrastructure
//


function xenos$Wizard($context, title, message, pages, cursor, options) {
  // self
  var self = this;


  // evaluate
  this.evaluate = function(object) {
    return jQuery.isFunction(object) ? object.call(self) : object;
  };


  // attributes

  // jQuery context
  this.$context = $context;

  // title, message
  this.title = title;
  this.message = message;

  // pages
  this.pages = pages;
  this.length = pages.length;

  // cursor, history
  this.originalCursor = cursor;
  this.cursor = cursor;
  this.history = [cursor];


  // options
  // default
  this.options = {
    // rendering mode
    // EDIT, CONFIRM, VIEW
    mode: 'EDIT',

    // base
    base: self.$context.find('form').attr('action'),
	
	// After click on OK button entry page will be reinitialze as it was opened from menu.
	// But in some scenarios we need to keep the old state. To indicate this corresponding
	// page should modify this flag as TRUE. By default it will not keep the old state.
	keepOldState: false,

    // various uris
    uri: {
      edit: '',
      view: '',
      reset: '/reset',
      submit: '/submit',
      confirm: '/confirm',
	  submitAction: '/submitAction',
	  commitAction: '/commitAction',
	  queryFormInfo: '/queryFormInfo.json',
	  keepOldStateAction : '/restore'
    },

    // various urls
    url: {
      /*
       edit: '',
       view: '',
       reset: '/reset',
       submit: '/submit'
       submit: '/submit',
       confirm: '/confirm'
      */
    },
    navigations : {
   	 
    }
  };

  // apply
  jQuery.extend(true, this.options, options);
  this.apply = function(options) {
    jQuery.extend(true, self.options, options);
  };


  // urls
  this.url = function(type) {
    if (self.options.url && self.options.url[type])
      return self.evaluate(self.options.url[type]);

    return self.options.base + self.evaluate(self.options.uri[type]);
  };


  // hooks
  this.hooks = {};

  // register
  // available types: 'next', 'previous', 'reset', 'submit', 'back', 'confirm'
  this.register = function(type, hook, options) {
    var isRregistered = xenos$Hook.has(self.$context, type + '-at-' + self.cursor, xenos$Hook.position.pre);
    if(isRregistered){
    	xenos$Hook.off(self.$context, type + '-at-' + self.cursor, xenos$Hook.position.pre);
    }
    self.$context.preOn(type + '-at-' + self.cursor, hook);
    self.hooks[hook.huid] = options ? options : {};
  };
  // deregister
  this.deregister = function(type, hook) {
    var huid = hook.huid;
    delete self.hooks[hook.huid];
    self.$context.preOff(type + '-at-' + self.cursor, hook);
  };

  // invoke
  this.invoke = function(type) {
    var targets = xenos$Hook.get(self.$context, type + '-at-' + self.cursor, xenos$Hook.position.pre);
    if (!targets) return;

    var $continue;
    jQuery.each(targets, function(index, target) {
      if (target) {
        var options = self.hooks[target.huid];
	options = options ? options : {};
        if (options.once) {
          if (!options.happened) {
            options.happened = true;
            $continue = target.apply(self.$context);
          }
        } else {
          options.happened = true;
          $continue = target.apply(self.$context);
        }
      }
    });
    return $continue;
  };


  // communication
  // handler
  this.handler = xenos$Handler$function({
    get: {
      requestUri: function(e, options) {
        var url = xenos.context.path + self.url(options.type) + '/' + options.y;
        var commandFormId = '?commandFormId=' + self.$context.find('[name=commandFormId]').val();
        var mode = '&mode=' + self.options.mode;
        var validate =  '&validate=' + (self.options.mode == 'EDIT');
        return url + commandFormId + mode + validate;
      },
      requestType: xenos$Handler$default.requestType.asynchronous,
      target: function(e) {
        return self.$context.find('#wizard-page');
      }
    },
    settings: {
      beforeSend: function(request) {
        request.setRequestHeader('Accept', 'text/html;type=ajax');
      },
      type: 'POST'
    },
    callback: {
      render: function() {
        self.renderer.update();
      },
      onPageLoad: function() {
    	self.applyOtherFeatures();
		var _onPageLoadFuncName = 'xenos$Wizard$onPageLoad'+self.options.uniqueId;
		var _onPageLoadFunc = window[_onPageLoadFuncName];
        if (typeof _onPageLoadFunc !== 'undefined') {
          _onPageLoadFunc(self);
          _onPageLoadFunc = function(self){};
		  delete _onPageLoadFunc;
          self.applyFocus();
          self.applyKeyListener();
          self.applyTabindex();
        }
		self.applyAutoComplete();
		xenos.utils.afterFormRenderScuts();
		//enable toggling for more items
		self.$context.xenosmore({mode:'entry'});
      }
    }
  });


  // renderer
  this.renderer = new xenos$Wizard$renderer(this);


  // functions

  // prepare
  this.prepare = function() {
    // data
    self.$context.data('xenos$Wizard', self);
    // render
    self.renderer.render();
    self.applyOtherFeatures();
	var _onPageLoadFuncName = 'xenos$Wizard$onPageLoad'+self.options.uniqueId;
	var _onPageLoadFunc = window[_onPageLoadFuncName];
    if (typeof _onPageLoadFunc !== 'undefined') {
      _onPageLoadFunc(self);
      _onPageLoadFunc = function(self){};
      delete _onPageLoadFunc;
      self.applyFocus();
      self.applyKeyListener();
      self.applyTabindex();
    }
	
	$('input[type=submit][tabindex]',self.$context).unbind('keydown');
	$('input[type=submit][tabindex]',self.$context).bind('keydown',function(e){
		if(((e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)) && $(e.target).is(':focus')){
			$(e.target).trigger('click');
		}
	});
	self.applyAutoComplete();
	xenos.utils.afterFormRenderScuts();
	
	//enable toggling for more items
	//If already called, then do not call at this step
	//This check is required for a condition where the more handling is required in the Detail Dialog having Wizard Framework
	//As for such case the call to xenosmore is to be made by xenos-detail-dialog.js, hence to ensure if there is no double call on the same container for such framework, this check is required.
	if($.trim(self.$context.data('xenos$More$Handler')) !== 'Y'){
		self.$context.xenosmore({mode:'entry'});
	}
  };
  
  this.applyTabindex = function(){
	$('input,select,.ui-multiselect-input,textarea,button,submit',self.$context).not('input[type=hidden],input[readonly=readonly]').each(function(i) {
		var $input = $(this);
		$input.attr("tabindex", i+1);
	});
  };
  
  this.applyKeyListener = function(){
	//Add listener on button for enter key
	$('input[type=button]',self.$context).unbind('keydown');
	$('input[type=button]',self.$context).bind('keydown',function(e){
		if(((e.which && e.which == 13) || (e.keyCode && e.keyCode == 13)) && $(e.target).is(':focus')){
			$(e.target).trigger('click');
		}
	});
  };
  
  this.applyFocus = function(){
	//Set focus to the first element of the form
	$('input[type=text],input[type=password],input[type=file],textarea,select',self.$context).filter(':not([readonly]):enabled:visible:first').focus();
  };
  
  this.applyAutoComplete = function(){
	//Account Number
	$('input.accountNo',self.$context).xenosautocomplete({
		requestContext: function($target){
			var $popElm = $target.parent().siblings('div.popupBtn').find('input');
			var actcptypecontext = $popElm.attr('actCPTypeContext')
			return{
				type: 'AccountTypeAhead',
				actType: $popElm.attr('actTypeContext') || 'T|B',
				CPType: (actcptypecontext ?  actcptypecontext.replace("BANK/CUSTODIAN","BROKER") : actcptypecontext )|| 'CLIENT|INTERNAL|BROKER'
			}
		},
		minLength: 2,
		delay: 400,
		appendTo: $('div#footer>div#autocompletecontainer')
	});
	
	//Inventory Account Number
	$('input.invAccountNo',self.$context).xenosautocomplete({
		requestContext: function($target){
			var $popElm = $target.parent().siblings('div.popupBtn').find('input');
			return {
				type: 'AccountTypeAhead',
				actType: $popElm.attr('invActTypeContext') || 'T|B',
				CPType:  $popElm.attr('invCPTypeContext') || 'INTERNAL'
			}
		},
		minLength: 2,
		delay: 400,
		appendTo: $('div#footer>div#autocompletecontainer')
	});
	
	//Sales Code
	$('input.salesCode',self.$context).xenosautocomplete({
		requestContext: {
			type: 'SalesTypeAhead'
		},
		minLength: 1,
		delay: 400,
		appendTo: $('div#footer>div#autocompletecontainer')
	});
	
  };
	
   /*
	* This API is used to apply different market tree and date picker on
	* predefined class
	*/
	this.applyOtherFeatures = function(){
		//Instrument Type Tree
		$('input.instrumentType',self.$context).treeview2({
			contentName: 'instrumentJson',
			type: "Instrument Type"
		});

		//Market Tree
		$('input.market',self.$context).treeview2({
			contentName: 'marketJson',
			type: "market"
		});
		
		//Strategy Code
		$('input.strategyCode',self.$context).treeview2({
			contentName: 'strategyCodeTree',
			type: "Strategy Code"
		});
		//Date input
		$('input.dateinput',self.$context).xenosdatepicker();	
	};


  // navigation
  // move to
  this.moveTo = function(y, options) {
    if (-1 >= y && y >= self.length) return;
    if (y == self.cursor) return;
	// Close Error message
	this.closeErrorMessage();	
    // hooks
    if (options && options.type && self.invoke(options.type) == false) {
      self.renderer.update();
      return;
    }

    // unload
    self.invoke('unload');

    // type
    var type;
    if (self.options.mode == 'CONFIRM' || self.options.mode == 'VIEW' || self.options.mode == 'EXIT') {
      type = 'view';
    } else {
      type = 'edit';
    }

    // communication
    self.handler.generic(undefined, {
      x: self.cursor,
      y: y,
      type: type,
      history: options.history,
      settings: {
        data: self.$context.find('form').serialize()
      },
      onHtmlContent: function(e, options, $target, content) {
        self.invoke('postServerCall');
		$target.html(content);
        if (content.indexOf('xenosError') == -1) {
          if (self.options.mode == 'EDIT')
            self.originalCursor = options.y;

          self.cursor = options.y;

          if (self.options.mode == 'EDIT'){
            while(options.x <= options.y) {
              if (jQuery.inArray(options.x, self.history) == -1)
                self.history.push(options.x);
				options.x +=1;
            }
          }
		  if(options.history != 0){
			self.$context.find('.formTabErrorIco').css('display', 'none');
		  }
        } else {
          self.handleError();
        }
      }
    });
  };
  
  //Create Error Message
  this.getErrorMessage = function(){
	var msg = [];
	$.each(self.$context.find('ul.xenosError li'), function(index, value) { 
	  msg.push($(value).text())
	});
	return msg;
  }
  
  this.getSoftValidationMessage = function(){
		var msg = [];
		$.each(self.$context.find('ul.xenosWarn li'), function(index, value) { 
		  msg.push($(SoftValidationMessage).text())
		});
		return msg;
   }
  
  //Close the error message when user navigate to other page.
  this.closeErrorMessage = function(){
	self.$context.find('.formTabErrorIco').css('display', 'none');
	$.each($('#growlDock .growlBox'),function(ind,el){
		$(el).find('#growlBoxClose').trigger('click');
	});
  };

  // next
  this.next = function() {
    if (self.cursor < (self.length - 1))
      self.moveTo(self.cursor + 1, {type: 'next'});
  };
  // previous
  this.previous = function() {
    if (self.history.length > 1)
      self.moveTo(self.cursor - 1, {type: 'previous'});
  };

  // switch to
  this.switchTo = function(y) {
    if (y < self.length)
      self.moveTo(y, {
        type: y > self.cursor ? 'next' : 'previous',
        history: 0
      });
  };


  // reset
  this.reset = function() {
    // hooks
    if (self.invoke('reset') == false) {
      self.renderer.update();
      return;
    }

    // unload
    self.invoke('unload');

    var url = xenos.context.path + self.url('reset');
    var commandFormId = '?commandFormId=' + self.$context.find('[name=commandFormId]').val();

    self.handler.generic(undefined, {
      requestUri: url + commandFormId,
      settings: {
        data: self.$context.find('form').serialize()
      },
      onHtmlContent: function(e, options, $target, content) {
		self.invoke('postServerCall');
		$target.html(content);
        if (content.indexOf('xenosError') == -1) {
          self.$context.find('.formTabErrorIco').css('display', 'none');
        } else {
          self.handleError(); 
        }
      }
    });
  };

  // submit
  this.submit = function() {
	// Close Error message
	this.closeErrorMessage();
    // hooks
    if (self.invoke('submit') == false) {
      self.renderer.update();
      return;
    }

    // unload
    self.invoke('unload');
	
	if((self.options.actionType == 'ENTRY')){
		var url = xenos.context.path + self.url('submit');
		var commandFormId = '?commandFormId=' + self.$context.find('[name=commandFormId]').val();
		var validate =  '&validate=true';

		self.handler.generic(undefined, {
		  requestUri: url + commandFormId + validate,
      multipart: self.options.multipart,
      multipartForm: self.options.multipartForm,
		  settings: {
			data: self.$context.find('form').serialize()
		  },
		  onHtmlContent: function(e, options, $target, content) {
			self.invoke('postServerCall');
			$target.html(content);

			if (content.indexOf('xenosError') == -1) {
			  self.cursor = 0;
			  self.options.mode = 'CONFIRM';

			  self.$context.find('.formTabErrorIco').css('display', 'none');
			} else {
			  self.handleError();
			}
		  }
		});
	}else {
		self.submitAction();
	}
  };
  
  //Ok handler
  this.ok = function(){
	 // hooks
    if (self.invoke('ok') == false) {
      self.renderer.update();
      return;
    }

    // unload
    self.invoke('unload');
    
    //If the Okay Button Handler is defined at the page level, then honour that and return
    if (self.options.navigations['okHandler'] === 'backToQuerySummary') {
    	self.exitOk();
    	return;
    }
    
	if((self.options.actionType == 'ENTRY')){
		var commandFormId = '?commandFormId=' + $('[name=commandFormId]',self.$context).val();
		var fragmentName = '&fragments=content';
		var screenId = '&screenId='+$('[name=screenId]',self.$context).val();		
		var url = xenos.context.path + self.options.base;
		if(self.options.keepOldState){
			url = xenos.context.path + self.url('keepOldStateAction');
		} 
		url += commandFormId + screenId + fragmentName;
		xenos$Handler$asynchronous.generic(undefined, {requestUri: url});
		self.invoke('postServerCall');
	}else if((self.options.actionType == 'CANCEL') || (self.options.actionType == 'AMEND') || (self.options.actionType == 'AUTHORIZE') || (self.options.actionType == 'REOPEN')
			 || (self.options.actionType == 'COPY') ){
		self.exitOk();
	}
  };
  // back
  this.back = function() {
    // hooks
    if (self.invoke('back') == false) {
      self.renderer.update();
      return;
    }

    // unload
    self.invoke('unload');
    
    //If the Back Button Handler is defined at the page level, then honour that and return
    if (self.options.navigations['backHandler'] === 'backToQuerySummary' && self.options.mode == 'EDIT') {
    	self.exitOk();
    	return;
    }
	
	if((self.options.actionType == 'ENTRY') || ((self.options.actionType == 'AMEND') && (self.options.mode == 'CONFIRM')) || 
			((self.options.actionType == 'CANCEL') && (self.options.mode == 'CONFIRM') && (self.options.hasIntermediatePage == 'true')) || 
			((self.options.actionType == 'REOPEN') && ((self.options.mode == 'VIEW') || (self.options.mode == 'CONFIRM'))) || 
			((self.options.actionType == 'COPY') && (self.options.mode == 'CONFIRM'))){
		var url = xenos.context.path + self.url('edit') + '/' + self.originalCursor;
		var commandFormId = '?commandFormId=' + self.$context.find('[name=commandFormId]').val();
		var mode;
		if((self.options.actionType == 'CANCEL')){
			mode = '&mode=VIEW';
		}else if((self.options.actionType == 'REOPEN')){
			var mode=self.options.mode;
			//if mode is VIEW then as usual mode turns back 2 EDIT or only if mode is COFIRM and no intermidiate page defined
			//more precisely if no reson page defined and user is on cofirm page then back button takes to EDIT mode again
			if(mode == 'VIEW' || (mode == 'CONFIRM' && self.options.hasIntermediatePage == "false")){
				mode = '&mode=EDIT';
			}else{
				mode = '&mode=VIEW';
			}
		}else{
			mode = '&mode=EDIT';
		}
		var validate =  '&validate=false';

		self.handler.generic(undefined, {
		  requestUri: url + commandFormId + mode + validate,
		  settings: {
			data: self.$context.find('form').serialize()
		  },
		  onHtmlContent: function(e, options, $target, content) {
			self.invoke('postServerCall');
			$target.html(content);

			if (content.indexOf('xenosError') == -1) {
			if((self.options.actionType == 'CANCEL')){
				self.options.mode = 'VIEW';
				self.$context.find('div#wizardNavigation').css('display','block');
				}else if((self.options.actionType == 'REOPEN')){
					var mode=self.options.mode;
					//if mode is VIEW then as usual mode turns back 2 EDIT or only if mode is COFIRM and no intermidiate page defined
					//more precisely if no reson page defined and user is on cofirm page then back button takes to EDIT mode again
					if(mode == 'VIEW' || (mode == 'CONFIRM' && self.options.hasIntermediatePage == "false")){
						self.options.mode = 'EDIT';
					}else{
						self.options.mode = 'VIEW';
						self.$context.find('div#wizardNavigation').css('display','block');
					}
					 self.cursor = self.originalCursor;
			}else{
			  self.options.mode = 'EDIT'; 
			  self.cursor = self.originalCursor;
			}
			self.$context.find('.formTabErrorIco').css('display', 'none');
			} else {
			  self.handleError();
			}
		  }
		});
	}else if( ((self.options.actionType == 'CANCEL') && (self.options.mode == 'VIEW')) || 
			((self.options.actionType == 'CANCEL') && (self.options.mode == 'CONFIRM') && (self.options.hasIntermediatePage == 'false')) ||
			(((self.options.actionType == 'AMEND') || (self.options.actionType == 'REOPEN') || (self.options.actionType == 'COPY')) && (self.options.mode == 'EDIT'))		||
			((self.options.actionType == 'AUTHORIZE') && (self.options.mode == 'CONFIRM'))			){
		self.exitOk();
	}
  };

  // confirm
  this.confirm = function() {
    // hooks
    if (self.invoke('confirm') == false) {
      self.renderer.update();
      return;
    }

    // unload
    self.invoke('unload');
	if((self.options.actionType == 'ENTRY')){
		var url = xenos.context.path + self.url('confirm');
		var commandFormId = '?commandFormId=' + self.$context.find('[name=commandFormId]').val();

		self.handler.generic(undefined, {
		  requestUri: url + commandFormId,
		  settings: {
			data: self.$context.find('form').serialize()
		  },
		  onHtmlContent: function(e, options, $target, content) {
			self.invoke('postServerCall');
			$target.html(content);

			if (content.indexOf('xenosError') == -1) {
			  self.options.mode = 'VIEW';
			  self.originalCursor = 0;
			  self.cursor = 0;

			  self.$context.find('.formTabErrorIco').css('display', 'none');
			} else {
			  self.handleError();
			}
		  }
		});
	}else {
		self.commitAction();
	}
  };
  // dispose
  this.dispose = function() {
    // data
	self.$context.removeData('xenos$More$Handler');
    self.$context.removeData('xenos$Wizard');
    // remove
	self.invoke('unload');
	self.invoke('postServerCall');
    self.renderer.dispose();
  };
  
  this.handleError = function(){
	self.$context.find('.formTabErrorIco').css('display', 'block');
	self.$context.find('.formTabErrorIco').off('click');
	self.$context.find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.error, xenos.utils.getErrorMessage(self.$context), true)); 
  };
  
  this.handleWarning = function(){
		self.$context.find('.formTabErrorIco').css('display', 'block');
		self.$context.find('.formTabErrorIco').off('click');
		self.$context.find('.formTabErrorIco').on('click', xenos.postNotice(xenos.notice.type.warning, xenos.utils.getWarningMessage(self.$context), true)); 
  };
  
  // submit action
  this.submitAction = function() {
    var url = xenos.context.path + self.url('submitAction');
    var commandFormId = '?commandFormId=' + self.$context.find('[name=commandFormId]').val();

    self.handler.generic(undefined, {
      requestUri: url + commandFormId,
      settings: {
        data: self.$context.find('form').serialize()		
      },
      onHtmlContent: function(e, options, $target, content) {
		self.invoke('postServerCall');
        $target.html(content);

        if (content.indexOf('xenosError') == -1) {
		  if((self.options.actionType == 'CANCEL') || (self.options.actionType == 'AMEND') || (self.options.actionType == 'COPY') || (self.options.actionType == 'AUTHORIZE')){
			self.options.mode = 'CONFIRM';
			self.cursor = 0;
		  }
		   if((self.options.actionType == 'REOPEN')){
				if((self.options.hasIntermediatePage == 'true')){
					 if((self.options.mode == 'EDIT')){
						self.options.mode = 'VIEW';
					 }else if((self.options.mode == 'VIEW')){
						self.options.mode = 'CONFIRM';
						self.$context.find('div#wizardNavigation').css('display','none');
					 }
				}else{
					self.options.mode = 'CONFIRM';
				}
			self.cursor = 0;
		  }
		  if((self.options.actionType == 'CANCEL')){
			self.$context.find('div#wizardNavigation').css('display','none');
		  }
          self.$context.find('.formTabErrorIco').css('display', 'none');
        } else {
			self.$context.find('div#wizardNavigation').css('display','block');
			self.handleError(); 
        }
      }
    });
  };
  
   // confirm action
  this.commitAction = function() {
    var url = xenos.context.path + self.url('commitAction');
    var commandFormId = '?commandFormId=' + self.$context.find('[name=commandFormId]').val();

    self.handler.generic(undefined, {
      requestUri: url + commandFormId,
      settings: {
        data: self.$context.find('form').serialize()
      },
      onHtmlContent: function(e, options, $target, content) {
		self.invoke('postServerCall');
        $target.html(content);

        if (content.indexOf('xenosError') == -1) {
            self.cursor = 0;
			if((self.options.actionType == 'CANCEL') || (self.options.actionType == 'AMEND') || (self.options.actionType == 'COPY') || (self.options.actionType == 'AUTHORIZE')
					|| (self.options.actionType == 'REOPEN')){
				self.options.mode = 'EXIT';
				self.$context.find('div#wizardNavigation').css('display','block');
			}
          self.$context.find('.formTabErrorIco').css('display', 'none');
        } else {
          self.handleError();
        }
      }
    });
  };
   // Back to corresponding result page
  this.exitOk = function() {
   	var url = xenos.context.path + self.url('queryFormInfo');
	$.ajax({
			type: "POST",
			url: url,
			data: self.$context.find('form').serialize(),
			beforeSend: function (req) {
				req.setRequestHeader("Accept", "application/json;type=ajax");
			},
			success: function (data) {
				var queryFormId = data.modelMap['queryCommandFormId'];
				var queryScreenUrl = xenos.context.path + data.modelMap['queryScreenUrl'];
				if(queryFormId && queryFormId != '-1'){
					//Removing the data 'xenos$More$Handler' from the context for certain operations. This was set in xenos.more.js
					//1. For back operation (i.e switching back to Query Result Page from some Amend or Cancel Operation)
					//2. For Ok buttong handling (i.e on click of Ok button from any system confirmation screen)
					self.$context.removeData('xenos$More$Handler');
					
					var xenos$Handler$asyncCancelOk = xenos$Handler$function({
					get: {
						requestUri: function(event){
							var url = queryScreenUrl ;
							var commandFormIdUrl = '&commandFormId=' + queryFormId;
							var fragmentName = '?fragments=content';
							return url + fragmentName + commandFormIdUrl;
						},
						requestType: xenos$Handler$default.requestType.asynchronous,
						target: '#content'
					},
					settings: {
						beforeSend: function(request) {
							request.setRequestHeader('Accept', 'text/html;type=ajax');
						},
						type: 'POST',
						complete: function(jqXHR){
						    if(jqXHR.hasOwnProperty('statusText') && jqXHR.statusText == 'abort'){
								return;
							}
							var container = self.$context;
							self.invoke('postServerCall');
							$('.xenos-grid', container).xenosgrid(grid_result_data, grid_result_columns, grid_result_settings);
						}
					}
					});
					xenos$Handler$asyncCancelOk.generic(undefined);
				}else{
					//At the moment only growl message
					xenos.postNotice(xenos.notice.type.error, xenos$REF$i18n.account.common.command_id_empty);
				}
			}
	});
  };
  
  /**
   * Check data in the form items
   */
  this.isDirtyState = function($formItems){
	if(!$formItems || $formItems.length == 0){
		return;
	}
	var dirtyState = false, defaultValue = "", currentValue = "";
	$.each($formItems.find('input,select'), function(formOrder, elem){
		if(elem.readOnly || elem.disabled || elem.type == 'hidden' || elem.type == 'button'){
			return true;
		}
		defaultValue = currentValue = "";
		if(elem.type == 'text'){
			currentValue = elem.value;
			defaultValue = elem.defaultValue;
		} else if(elem.type == 'select-one' || elem.type == 'select-multiple'){
			currentValue = $(elem).val();
			if($.trim(currentValue) == ""){
				return true;
			}
			$.each(elem, function(optionOrder, optionItem){
				if(optionItem.defaultSelected){
					defaultValue = $(optionItem).val();
					return false;
				}
			});
		} else if(elem.type == 'checkbox'){
			dirtyState = elem.defaultChecked ? ($(elem).is(':checked') ? false : true)
								: ($(elem).is(':checked') ? true : false);
				if(dirtyState)
					return false;
				else
					return true;
		}
		if($.trim(currentValue) != $.trim(defaultValue)){
			dirtyState = true;
			return false;
		}
	});
	return dirtyState;
  };
  
  /**
   * Reset the form items
   */
  this.resetFormItems = function(){
	var $formItems = self.$context.find('#wizard-page').find('#formContainer').find('#formActionArea').siblings('div.formItem').filter(':not(.skipWarning)');
	var defaultValue = "";
	$.each($formItems.find('input,select'), function(order, elem){
		if(elem.readOnly || elem.disabled || elem.type == 'hidden' || elem.type == 'button'){
			return true;
		}
		if(elem.type == 'text'){
			elem.value = elem.defaultValue || "";
		} else if(elem.type == 'select-one' || elem.type == 'select-multiple'){
			defaultValue = "";
			$.each(elem, function(optionOrder, optionItem){
				if(optionItem.defaultSelected){
					defaultValue = $(optionItem).val();
					return false;
				}
			});
			elem.value = defaultValue || "";
		} else if(elem.type == 'checkbox'){
			$(elem).attr('checked', elem.defaultChecked);
		}
	});
  };
  
  /**
   * Check unsaved data where edit option is available.
   */
  this.isUnsavedData = function(){
	var dirtyFlag = false;
	var formActionAreas = self.$context.find('#wizard-page').find('#formContainer').find('#formActionArea');
	$(formActionAreas).filter(':visible').each(function(order, formActionArea){
		if($(formActionArea).find('.resetBtn:visible').length > 0){
			dirtyFlag = true;
			return false;
		}
		if(self.isDirtyState($(formActionArea).siblings('div.formItem').filter(':not(.skipWarning)'))){
			dirtyFlag = true;
			return false;
		}
	});
  	return dirtyFlag;
  };
}


function xenos$Wizard$renderer(object) {
  // self
  var self = this;


  // attributes
  this.object = object;
  this.mode = '';


  // handlers
  // Navigate to next
  this.navigateToNext = function(e) {
	self.disableActions();
	self.disableTabNavigation();
	self.object.next();
  };
  // next
  this.next = function(e) {
	e.preventDefault();
	if(self.object.isUnsavedData()){
		jConfirm(xenos.i18n.message.unsaved_data_alert, null, function(r) {
			if(!r) {
				return false;
			} else {
				self.object.resetFormItems();
				self.navigateToNext(e);
			}
		});
	} else {
		self.object.resetFormItems();
		self.navigateToNext(e);
	}
  };
  // Navigate to previous
  this.navigateToPrevious = function(e) {
	self.disableActions();
	self.disableTabNavigation();
	self.object.previous();
  };
  // previous
  this.previous = function(e) {
	e.preventDefault();
	if(self.object.isUnsavedData()){
		jConfirm(xenos.i18n.message.unsaved_data_alert, null, function(r) {
			if(!r) {
				return true;
			} else {
				self.object.resetFormItems();
				self.navigateToPrevious(e);
			}
		});
	} else {
		self.object.resetFormItems();
		self.navigateToPrevious(e);
	}
  };
  // Switch the tab
  this.switchTab = function(e){
	self.disableActions();
	self.disableTabNavigation();
	self.object.switchTo(parseInt(jQuery(e.target).attr('pageIndex')));
  };
  // switch to
  this.switchTo = function(e) {
	e.preventDefault();
	if(self.object.isUnsavedData()){
		jConfirm(xenos.i18n.message.unsaved_data_alert, null, function(r) {
			if(!r) {
				return false;
			} else {
				self.object.resetFormItems();
				self.switchTab(e);
			}
		});
	} else {
		self.object.resetFormItems();
		self.switchTab(e);
	}
  };

  // reset
  this.reset = function(e) {
    self.disableActions();
	self.disableTabNavigation();
    e.preventDefault();
    self.object.reset();
  };
  
  // Submit form
  this.submitForm = function(e) {
	self.disableActions();
	self.disableTabNavigation();
	self.object.submit();
  };
  // submit
  this.submit = function(e) {
	e.preventDefault();
	if(self.object.isUnsavedData()){
		jConfirm(xenos.i18n.message.unsaved_data_alert, null, function(r) {
			if(!r) {
				return false;
			} else {
				self.object.resetFormItems();
				self.submitForm(e);
			}
		});
	} else {
		self.object.resetFormItems();
		self.submitForm(e);
	}
  };

  // back
  this.back = function(e) {
    self.disableActions();
	self.disableTabNavigation();
    e.preventDefault();
    self.object.back();
  };
  // confirm
  this.confirm = function(e) {
    //self.disableActions();
	self.disableTabNavigation();
    e.preventDefault();
    //self.object.confirm();
	if((self.object.options.actionType == 'CANCEL') && 
		(self.object.options.hasIntermediatePage == 'true') && 
		(self.object.$context.find('#historyReasonPk')) && 
		(self.object.$context.find('#historyReasonPk').attr('value') == '')){
		
		xenos.postNotice(xenos.notice.type.error,xenos$REF$i18n.account.common.close_reason_cannot_empty);
	}else{
		self.disableActions();
		self.object.confirm();
	}
  };
  // confirm
  this.ok = function(e) {
    self.disableActions();
	self.disableTabNavigation();
    e.preventDefault();
    self.object.ok();
  };

  // actions
  // definitions
  this.actions = ['next', 'previous', 'reset', 'submit', 'back', 'confirm','ok'];
  // selectors
  this.actionSelectors = {
    next: 'div.wizNext > input[type=button]',
    previous: 'div.wizPrev > input[type=button]',
    reset: 'div.wizReset > input[type=button]',
    submit: 'div.wizSubmit > input[type=submit]',
    back: 'div.wizBack > input[type=button]',
    confirm: 'div.wizConfirm > input[type=submit]',
	ok: 'div.wizOk > input[type=submit]'
  };
  // handlers
  this.actionHandlers = {
    next: self.next,
    previous: self.previous,
    reset: self.reset,
    submit: self.submit,
    back: self.back,
    confirm: self.confirm,
	ok: self.ok
  };

  // display
  this.displayActions = function(actions) {
    if (!actions)
      actions = self.actions;

    jQuery.each(actions, function(index, action) {
      self.object.$context.find(self.actionSelectors[action]).css('display', 'inline-block');
    });
  };
  // hide
  this.hideActions = function(actions) {
    if (!actions)
      actions = self.actions;

	//First show the acttion Area then hide other action		  
	$('div.hideActionArea').show();
	
    jQuery.each(actions, function(index, action) {
      self.object.$context.find(self.actionSelectors[action]).css('display', 'none');
    });
  };

  // enable
  this.enableActions = function(actions) {
    if (!actions)
      actions = self.actions;

    jQuery.each(actions, function(index, action) {
      self.object.$context.find(self.actionSelectors[action]).removeAttr('disabled');
    });
  };
  // disable
  this.disableActions = function(actions) {
    if (!actions)
      actions = self.actions;

    jQuery.each(actions, function(index, action) {
      self.object.$context.find(self.actionSelectors[action]).attr('disabled', 'disabled');
    });
  };
  // disable click event on breadcrumb
  this.disableTabNavigation = function(){
	var $navigation = self.object.$context.find('div#wizardNavigation');
	$navigation.find('a').off('click');
  }

   // fix size
  this.wizardHeight = function() {
	var winHeight = $(window).height();
	var entryContHeight = (winHeight - 225);
	
	$('.entryContainer',self.object.$context).css('height',entryContHeight);
	$('.entryContainerConfirm',self.object.$context).css('height',entryContHeight);
	
	// fix for entry detail popup double scrollbar
	if($('.entryContainerConfirm','.ui-dialog-content')){
		$('.entryContainerConfirm','.ui-dialog-content').css('height','auto');
	}
	
  };
  
  this.isNonEditableMode = function(){
	var mode = self.object.options.mode;
	return (mode === 'CONFIRM' || mode === 'EXIT' || mode ==='NONINTERACTIVE' || mode==='VIEW');
  }

  // render
  // do render
  this.doRender = function(action) {
    // fix title
    self.object.$context.find('div.title h1').text(self.object.title);
    // fix message
	//******************************************Txn completion mEssages***************************
	var confirmMsg = self.object.message;
	var confirmMsgMode = self.object.options.mode;
	var actionType = self.object.options.actionType;

	var totalWidth = $(window).width();
	var msgWidth = 400;
	var leftMargin = ((totalWidth - msgWidth)/2);
	
	if( (actionType == 'ENTRY' &&  confirmMsgMode == 'VIEW') ||((actionType == 'CANCEL' || actionType == 'AMEND' || actionType == 'COPY' || actionType == 'AUTHORIZE' || actionType == 'REOPEN')
			&& (confirmMsgMode == 'EXIT')) ){

		if (confirmMsg && confirmMsg != '') {
		  self.object.$context.find('.formContent').append(
			  '<div class="xenosSuccsmsg">'+
				  '<div class="xenosSuccBoxBg">'+
				  '<div class="left infoIcon">'+'</div>'+'<div class="content entryConfirm">'+'<ul>'+'<li>'+confirmMsg +'</li>'+'</ul>'+'</div>'+'</div>'+'<div class="btmShadow"></div>'+'</div>');
		}
		var msgCount = $('.xenosSuccsmsg').length;
		//console.log(msgCount);
		if(msgCount > 1){
			self.object.$context.find('.xenosSuccsmsg').next('.xenosSuccsmsg').remove();
		}
		//$('.xenosSuccsmsg').css('left',leftMargin);
	}
	if(confirmMsgMode == 'EDIT'){
		self.object.$context.find('.entryConfirm').closest('.xenosSuccsmsg').remove();
	}
	
	self.object.$context.find('.xenosError').css('left', leftMargin);
	
	self.wizardHeight();
	
	self.object.$context.find('.tableStyle tr:odd').addClass('oddRow');
	 
	//********************************************************************************************
    // fix navigations and actions
    var $navigation = self.object.$context.find('div#wizardNavigation');
	
	// Done for update.
    if (self.object.pages.length <= 1 || (self.object.options.hasSingleViewTile == true && self.isNonEditableMode())) {
		 $navigation.hide();
	} else if(!(self.isNonEditableMode() || $navigation.is(':visible'))){
			$navigation.show();
	}
	
    // render
    if (action == 'render') {
		if (self.object.pages.length > 1) {
		  // markup
		  var markup = '';

		  jQuery.each(self.object.pages, function(index, page) {
			markup += '<li pageId="page' + index + '"><span>' + (index + 1) + '</span><a href="#" title="' + page.title + '" pageIndex="' + index + '">' + page.title + '</a></li>';
		  });

		  $navigation.find('ul#wizStep').append(markup);
		  $navigation.find('ul#wizStep li:last-child').addClass('last');
		  
		  //Elastislide plugin
		  
		  $navigation.parent('#carousel').elastislide({
			  imageW: 150,
			  minItems: 4,
			  margin: 0,
			  border: 'auto',
			  current: 0
			});
      } else {
        $navigation.hide();
        var height = $('.entryContainer').height()+$navigation.height();
		$('.entryContainer').height(height);
      }

	  var errorList = self.object.$context.find('ul.xenosError li') || [];
	  if(errorList.length > 0){
		self.object.handleError();
	  }

      // handlers
      self.object.$context.find(self.actionSelectors['next']).on('click', self.next);
      self.object.$context.find(self.actionSelectors['previous']).on('click', self.previous);
      self.object.$context.find(self.actionSelectors['reset']).on('click', self.reset);
      self.object.$context.find(self.actionSelectors['submit']).on('click', self.submit);
      self.object.$context.find(self.actionSelectors['back']).on('click', self.back);
      self.object.$context.find(self.actionSelectors['confirm']).on('click', self.confirm);
      self.object.$context.find(self.actionSelectors['ok']).on('click', self.ok);
    }

    // history and handlers
    $navigation.find('a').off('click');
    jQuery.each(self.object.pages, function(index, page) {
      if (self.object.options.mode == 'CONFIRM' || self.object.options.mode == 'VIEW' || self.object.options.mode == 'EXIT') {
        $navigation.find('[pageId=page' + index + ']').removeClass('active');
        $navigation.find('[pageId=page' + index + ']').find('a').on('click', self.switchTo);
      } else {
		  if(jQuery.inArray(index, self.object.history) != -1 || self.object.pages[index].submitOn){
			$navigation.find('[pageId=page' + index + ']').addClass('active');
			$navigation.find('[pageId=page' + index + ']').find('a').on('click', self.switchTo);
          }
      }

      if (self.object.cursor == index) {
        $navigation.find('[pageId=page' + index + ']').addClass('current');
        $navigation.find('[pageId=page' + index + ']').find('a').off('click');
      } else {
      	$navigation.find('[pageId=page' + index + ']').removeClass('current');
      }
    });

    // mode
    if (self.mode != self.object.options.mode) {
      if (self.object.options.mode == 'VIEW') {
        $navigation.removeClass('wizStepArea');
        $navigation.addClass('tabStepArea');

        self.hideActions();
		if((self.object.options.actionType == 'ENTRY')) {
			self.displayActions(['ok']);
		}else if((self.object.options.actionType == 'CANCEL') || (self.object.options.actionType == 'REOPEN')){
			self.displayActions(['back', 'submit']);
		}
      } else if (self.object.options.mode == 'CONFIRM') {
        $navigation.removeClass('wizStepArea');
        $navigation.addClass('tabStepArea');

        self.hideActions();
		if((self.object.options.actionType == 'ENTRY') || (self.object.options.actionType == 'AMEND') || (self.object.options.actionType == 'COPY')
				|| (self.object.options.actionType == 'CANCEL') || (self.object.options.actionType == 'AUTHORIZE') || (self.object.options.actionType == 'REOPEN')) {
			self.displayActions(['back', 'confirm']);
		}
      }else if (self.object.options.mode == 'EXIT') {
        $navigation.removeClass('wizStepArea');
        $navigation.addClass('tabStepArea');

        self.hideActions();
		if((self.object.options.actionType == 'CANCEL') || (self.object.options.actionType == 'AMEND') || (self.object.options.actionType == 'COPY')
				|| (self.object.options.actionType == 'AUTHORIZE') || (self.object.options.actionType == 'REOPEN')){
			self.displayActions(['ok']);
		}
      }else if (self.object.options.mode == 'NONINTERACTIVE') {
        $navigation.removeClass('wizStepArea');
        $navigation.addClass('tabStepArea');

        self.hideActions();
      }else {
        $navigation.removeClass('tabStepArea');
        $navigation.addClass('wizStepArea');

        self.hideActions();
        if (self.object.pages.length > 1) {
			if(self.object.options.actionType == 'ENTRY'){
				self.displayActions(['next', 'previous', 'reset', 'submit']);
				if(self.object.options.enableBackOnEntryAction == 'true'){
					self.displayActions(['back']);
				}
			}else{
				self.displayActions(['back','next', 'previous', 'reset', 'submit']);
			}
        } else {
        	if(self.object.options.actionType == 'ENTRY'){
				self.displayActions(['reset', 'submit']);
				if(self.object.options.enableBackOnEntryAction  == 'true'){
					self.displayActions(['back']);
				}
			}else{
				self.displayActions(['back','reset', 'submit']);
			}
        }
      }
    }

    // actions
    if (self.object.options.mode == 'VIEW') {
		if((self.object.options.actionType == 'ENTRY')) {
			self.enableActions(['ok']);
		}else if((self.object.options.actionType == 'CANCEL') || (self.object.options.actionType == 'REOPEN')){
			self.enableActions(['back', 'submit']);
		}
    } else if (self.object.options.mode == 'CONFIRM') {
		if((self.object.options.actionType == 'ENTRY') || (self.object.options.actionType == 'AMEND') || (self.object.options.actionType == 'COPY')
				|| (self.object.options.actionType == 'CANCEL') || (self.object.options.actionType == 'AUTHORIZE') || (self.object.options.actionType == 'REOPEN')) {
			self.enableActions(['back', 'confirm']);
		}
    }else if (self.object.options.mode == 'EXIT') {
		if((self.object.options.actionType == 'CANCEL') || (self.object.options.actionType == 'AMEND') || (self.object.options.actionType == 'COPY')
				|| (self.object.options.actionType == 'AUTHORIZE') || (self.object.options.actionType == 'REOPEN')){
			self.enableActions(['ok']);
		}
    } else {
		if(self.object.options.actionType == 'ENTRY'){
			self.enableActions(['next', 'previous', 'reset', 'submit']);
			if(self.object.options.enableBackOnEntryAction == 'true'){
				self.enableActions(['back']);
			}
		}else{
			self.enableActions(['back','next', 'previous', 'reset', 'submit']);
		}
      if (self.object.cursor == 0) {
        self.disableActions(['previous']);
      } else if (self.object.cursor == (self.object.length - 1)) {
        self.disableActions(['next']);
      }
      if (self.object.pages[self.object.cursor] && !self.object.pages[self.object.cursor].submitOn)
        self.disableActions(['submit']);
    }
	$('input[type=submit]',self.$context).filter(':enabled:visible:first').focus();
  };


  // render
  this.render = function() {
    self.doRender('render');
    this.mode = self.object.options.mode;
  };
  // add css for fixed height on resize
  jQuery(window).resize(self.wizardHeight);

  // update
  this.update = function() {
    self.doRender('update');
    this.mode = self.object.options.mode;
  };


  // dispose
  this.dispose = function() {
  };
}
