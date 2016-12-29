//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
//
// xenos
//  - Wizard infrastructure
//


function xenos$WizardRev($context, title, uri, modes, pages, buttons, screenId) {
  // self
  var self = this;


  // attributes

  // jQuery context
  this.$context = $context;

  // title, messages, softMessages
  this.title = title;
  this.uri = uri;
  this.messages = [];
  this.softMessages = [];
  
  //screen id
  this.screenId = screenId;
  //hold the initial screenId for exit
  this.initialScreenId = '';

  // modes
  this.modes = modes;
  this.modeIndex = 0;

  // pages
  this.pages = pages;
  this.pageIndex = 0;
  this.pageIndexes = {};
  this.pageHistory = {0: {0: true}};

  // buttons
  this.buttons = buttons;
  this.getButtons = function() {
    var mode = self.modes[self.modeIndex];
    var page = self.pages[self.pageIndex];

    var buttons = page['buttons'];
    if (buttons && buttons[mode])
      return buttons[mode];

    return self.buttons[mode];
  };
  this.getExcludeButtons = function() {
    var mode = self.modes[self.modeIndex];
    var page = self.pages[self.pageIndex];

    var excludeButtons = page['excludeButtons'];
    if (excludeButtons && excludeButtons[mode])
      return excludeButtons[mode];

    return undefined;
  };


  // options
  this.options = {};
  this.apply = function(options) {
    jQuery.extend(true, self.options, options);

    self.renderer.update();
  };


  // hooks
  this.hooks = {};

  // register
  // available types: 'previous', 'next', 'back', 'reset', 'submit', 'confirm', 'ok', 'custom1', 'custom2', 'custom3'
  this.register = function(type, hook, options) {
    self.$context.preOn(type + '@' + self.pageIndex, hook);
    self.hooks[type + '@' + self.pageIndex + '#' + hook.huid] = options ? options : {};
  };
  // deregister
  this.deregister = function(type, hook) {
    delete self.hooks[type + '@' + self.pageIndex + '#' + hook.huid];
    self.$context.preOff(type + '@' + self.pageIndex, hook);
  };

  // invoke
  this.invoke = function(type) {
    var targets = xenos$Hook.get(self.$context, type + '@' + self.pageIndex, xenos$Hook.position.pre);
    if (!targets) return;

    var $continue;
    jQuery.each(targets, function(index, target) {
      if (target) {
        var options = self.hooks[type + '@' + self.pageIndex + '#' + target.huid];
        if (!options || (!options.once || !options.invoked)) {
          if (options)
            options.invoked = true;
          $continue = target.apply(self.$context);
        }
      }
    });
    return $continue;
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

  // invoke page load
  this.invokeOnPageLoad = function() {
    if (typeof xenos$Wizard$onPageLoad !== 'undefined') {
      xenos$Wizard$onPageLoad();
      xenos$Wizard$onPageLoad = function(){};
    }

    self.renderer.update();
	
	self.invoke('afterRendering');
	
	self.applyAutoComplete();
	xenos.utils.afterFormRenderScuts();
	//enable toggling for more items
	self.$context.xenosmore({mode:'entry'});
  };


  // communication
  // handler
  this.handler = xenos$Handler$function({
    settings: {
      beforeSend: function(request) {
        request.setRequestHeader('Accept', 'text/html;type=ajax');
      },
      type: 'POST'
    },
    callback: {
      onPageLoad: self.invokeOnPageLoad
    },
    get: {
      requestUri: function(e, options) {
        var url = xenos.context.path
            + '/'
            + self.uri;

        if (options.uri)
          url += '/' + options.uri;

        if (options.y)
          url += '/' + options.y;

        var commandFormId = '?commandFormId=' + self.$context.find('[name=commandFormId]').val();
        var validate =  '&validate=' + (self.modes[self.modeIndex] == 'EDIT');

		var operationType = self.$context.find('[name=operationType]').val();
		if(operationType && operationType != ''){
			return url + commandFormId + validate + '&operationType=' + operationType;
		}
        return url + commandFormId + validate;
      },
      requestType: xenos$Handler$default.requestType.asynchronous,
      target: function(e) {
        return self.$context.find('#wizard-page');
      }
    },
    process: {
      htmlContent: function(e, options, $target, content) {
        jQuery('.formTabErrorIco', self.$context).hide();
		self.invoke('postServerCall');
        $target.html(content);
        if (content.indexOf('xenosError') == -1) {
          if (options.y)
            self.pageIndex = options.y;

          if (!self.pageHistory[self.modeIndex])
            self.pageHistory[self.modeIndex] = {};

          var history = self.pageHistory[self.modeIndex];
          if (!history[self.pageIndex])
            history[self.pageIndex] = true;

          if (jQuery.isFunction(options.success))
            options.success();
        } else {
          self.renderer.error();

          if (jQuery.isFunction(options.error))
            options.error();
        }
      }
    }
  });
  
  //Close the error message when user navigate to other page.
  this.closeErrorMessage = function(){
	self.$context.find('.formTabErrorIco').css('display', 'none');
	$.each($('#growlDock .growlBox'),function(ind,el){
		$(el).find('#growlBoxClose').trigger('click');
	});
  };

  // renderer
  this.renderer = new xenos$WizardRev$renderer(this);


  // functions

  // prepare
  this.prepare = function() {
    // data
    self.$context.data('xenos$Wizard', self);
    self.initialScreenId = self.screenId;
    
    // render
    self.renderer.render();

    // others
    self.invokeOnPageLoad();
  };


  // navigation
  // move to
  this.moveTo = function(y, options) {
    if (-1 >= y && y >= self.pages.length) return;
    if (y == self.pageIndex) return;
	
	// Close Error message
	this.closeErrorMessage();	
	
    // hooks
    if (options && options.type && self.invoke(options.type) == false) {
      self.renderer.update();
      return;
    }

    // unload
    self.invoke('unload');

    // communication
    self.handler.generic(undefined, {
      multipartForm: options.multipartForm,
      multipart: options.multipart,
      uri: options.uri,
      y: y,

      settings: {
        data: self.$context.find('form').serialize()
      }
    });
  };

  // previous
  this.previousIndex = function() {
    var history = self.pageHistory[self.modeIndex];
    for (var i = self.pageIndex - 1; i >= 0; i--) {
      if (history[i])
        return i;
    }

    return self.pageIndex;
  };
  this.previous = function() {
    self.moveTo(self.previousIndex(), {type: 'previous'});
  };
  // next
  this.nextIndex = function() {
    return self.pageIndex < (self.pages.length - 1) ? self.pageIndex + 1: self.pageIndex;
  };
  this.next = function() {
    self.moveTo(self.nextIndex(), {type: 'next'});
  };

  // switch to
  this.switchTo = function(y) {
    if (y < self.length)
      self.moveTo(y, {type: y < self.pageIndex ? 'previous' : 'next'});
  };


  // operation
  // action
  this.action = function(type, y, options) {
    // hooks
    if (self.invoke(type) == false) {
      self.renderer.update();
      return;
    }

    // unload
    self.invoke('unload');

    if (!options)
      options = {};

    // communication
    self.handler.generic(undefined, {
      multipartForm: options.multipartForm,
      multipart: options.multipart,
      success: options.success,
      error: options.error,
      uri: type,
      y: y,

      settings: {
        data: self.$context.find('form').serialize()
      }
    });
  };

  // back
  this.back = function() {
	// Close Error message
	this.closeErrorMessage();
	
	if(self.options.back){
		if (jQuery.isFunction(self.options.back)){
			self.options.back();
		}else{
		  self.transition(self.options.back);
		}
	}else{
		self.action('back', undefined, {
			success: function() {
				if (self.modeIndex > 0) {
				  self.modeIndex -= 1;
				  self.pageIndex = self.pageIndexes[self.modeIndex];
				}
			  }
		});
	}
  };
  // reset
  this.reset = function() {
    self.action('reset', self.pageIndex);
  };
  // transition
  this.transition = function(type) {
    self.action(type, self.pageIndex, {
      multipartForm: self.options.multipartForm,
      multipart: self.options.multipart,
      success: function() {
        if (self.modeIndex < (self.modes.length - 1)) {
          self.pageIndexes[self.modeIndex] = self.pageIndex;
          self.modeIndex += 1;
          self.pageIndex = 0;
          self.pageHistory[self.modeIndex] = {0: true};
        }
      }
    });
  };

  // submit
  this.submit = function() {
	// Close Error message
	this.closeErrorMessage();
	
    if(self.options.submit){
		if (jQuery.isFunction(self.options.submit)){
			self.options.submit();
		}else{
		  self.transition(self.options.submit);
		}
	}else{
		self.transition('submit');
	}
  };
  // confirm
  this.confirm = function() {
	// Close Error message
	this.closeErrorMessage();
	
    self.transition('confirm');
  };

  // custom1
  this.custom1 = function() {
	// Close Error message
	this.closeErrorMessage();
	
    if (jQuery.isFunction(self.options.customAction1))
      self.options.customAction1();
    else
      self.transition(self.options.customAction1);
  };
  // custom2
  this.custom2 = function() {
	// Close Error message
	this.closeErrorMessage();
	
    if (jQuery.isFunction(self.options.customAction2))
      self.options.customAction2();
    else
      self.transition(self.options.customAction2);
  };
  // custom3
  this.custom3 = function() {
	// Close Error message
	this.closeErrorMessage();
	
    if (jQuery.isFunction(self.options.customAction3))
      self.options.customAction3();
    else
      self.transition(self.options.customAction3);
  };

  // ok
  this.ok = function() {
    // todo
  };


  // dispose
  this.dispose = function() {
	//Removing the data 'xenos$More$Handler' from the context for certain operations. This was set in xenos.more.js
	//1. For back operation (i.e switching back to Query Result Page from some Amend or Cancel Operation)
	//2. For Ok buttong handling (i.e on click of Ok button from any system confirmation screen)
	self.$context.removeData('xenos$More$Handler');
    
	// data
    self.$context.removeData('xenos$Wizard');
    // render
    self.renderer.dispose();

    // others
    self.invoke('unload');
    self.invoke('postServerCall');
  };
}


function xenos$WizardRev$renderer(object) {
  // self
  var self = this;


  // attributes
  this.object = object;
  this.modes;
  this.modeIndex;

  // actions
  // definitions
  this.actions = ['previous', 'next', 'back', 'reset', 'submit', 'confirm', 'ok', 'custom1', 'custom2', 'custom3'];
  // selectors
  this.actionSelectors = {
    previous: 'div.wizPrevious > input[type=button]',
    next: 'div.wizNext > input[type=button]',
    back: 'div.wizBack > input[type=button]',
    reset: 'div.wizReset > input[type=button]',
    submit: 'div.wizSubmit > input[type=submit]',
    confirm: 'div.wizConfirm > input[type=submit]',
    ok: 'div.wizOk > input[type=submit]',
    custom1: 'div.wizCustom1 > input[type=submit]',
    custom2: 'div.wizCustom2 > input[type=submit]',
    custom3: 'div.wizCustom3 > input[type=submit]'
  };

  // display
  this.showActions = function(actions) {
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


  // handlers
  // previous
  this.previous = function(e) {
    self.disableActions();
    e.preventDefault();
    self.object.previous();
  };
  // next
  this.next = function(e) {
    self.disableActions();
    e.preventDefault();
    self.object.next();
  };

  // switch to
  this.switchTo = function(e) {
    self.disableActions();
    e.preventDefault();
    self.object.switchTo(parseInt(jQuery(e.target).attr('pageIndex')));
  };

  // back
  this.back = function(e) {
    self.disableActions();
    e.preventDefault();
    self.object.back();
  };

  // reset
  this.reset = function(e) {
    self.disableActions();
    e.preventDefault();
    self.object.reset();
  };
  // submit
  this.submit = function(e) {
    self.disableActions();
    e.preventDefault();
    self.object.submit();
  };
  // confirm
  this.confirm = function(e) {
    self.disableActions();
    e.preventDefault();
		self.object.confirm();
  };
  // ok
  this.ok = function(e) {
    self.disableActions();
    e.preventDefault();
    self.object.ok();
  };
  // custom1
  this.custom1 = function(e) {
    self.disableActions();
    e.preventDefault();
    self.object.custom1();
  };
  // custom2
  this.custom2 = function(e) {
    self.disableActions();
    e.preventDefault();
    self.object.custom2();
  };
  // custom3
  this.custom3 = function(e) {
    self.disableActions();
    e.preventDefault();
    self.object.custom3();
  };

  // handlers
  this.actionHandlers = {
    previous: self.previous,
    next: self.next,
    back: self.back,
    reset: self.reset,
    submit: self.submit,
    confirm: self.confirm,
	  ok: self.ok,
    custom1: self.custom1,
    custom2: self.custom2,
    custom3: self.custom3
  };

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
  // render
  // do render
  this.doRender = function(action) {
    var modeIndex = self.object.modeIndex;
    var mode = self.object.modes[modeIndex];
    var pageIndex = self.object.pageIndex;
    var page = self.object.pages[pageIndex];
    var pageHistory = self.object.pageHistory[modeIndex];

    // handlers
    var $navigation = self.object.$context.find('div#wizardNavigation');

    // fix title
    self.object.$context.find('div.title h1').text(self.object.title);
    if(self.object.screenId !== undefined) {
		self.object.$context.find('[name=screenId]').val(self.object.screenId);
	}
    
    // fix messages
    var messages = self.object.messages;
    if (messages && messages.length > 0) {
      var $formContent = self.object.$context.find('.formContent');
      $formContent.find('.xenosSuccsmsg').remove();

      var markup = ''
          + '<div class="xenosSuccsmsg">'
          + ' <div class="xenosSuccBoxBg">'
          + '   <div class="left infoIcon"/>'
          + '   <div class="content entryConfirm">'
          + '   <ul>';

      jQuery.each(messages, function(index, message) {
         markup = markup
            + '     <li>'
            +         message
            + '     </li>';
      });

       markup = markup
          + '   </ul>'
          + ' </div>'
          + ' <div class="btmShadow"></div>'
          + '</div>'
		  + '</div>';

      $formContent.append(markup);
    }

    // render
    if (action == 'render') {
      if (self.object.pages.length > 1) {
        // navigation markup
        $navigation.find('ul#wizStep li:last-child').addClass('last');

        // elastislide plugin
        $navigation.parent('#carousel').elastislide({
          imageW: 150,
          minItems: 4,
          margin: 0,
          border: 'auto',
          current: 0
        });
      } 
	  
      // action handlers
      self.object.$context.find(self.actionSelectors['next']).on('click', self.next);
      self.object.$context.find(self.actionSelectors['previous']).on('click', self.previous);
      self.object.$context.find(self.actionSelectors['back']).on('click', self.back);
      self.object.$context.find(self.actionSelectors['reset']).on('click', self.reset);
      self.object.$context.find(self.actionSelectors['submit']).on('click', self.submit);
      self.object.$context.find(self.actionSelectors['confirm']).on('click', self.confirm);
      self.object.$context.find(self.actionSelectors['ok']).on('click', self.ok);
      self.object.$context.find(self.actionSelectors['custom1']).on('click', self.custom1);
      self.object.$context.find(self.actionSelectors['custom2']).on('click', self.custom2);
      self.object.$context.find(self.actionSelectors['custom3']).on('click', self.custom3);
    }

    // navigation mode
    if (self.modeIndex != modeIndex) {
      if (mode == 'EDIT') {
        $navigation.removeClass('wizStepArea');
        $navigation.addClass('tabStepArea');
      } else {
        $navigation.removeClass('wizStepArea');
        $navigation.addClass('tabStepArea');
      }
    }
    // navigation handlers
    $navigation.find('a').off('click');
    jQuery.each(self.object.pages, function(index, page) {
      if (mode == 'EDIT') {
        if (pageHistory[pageIndex]) {
          $navigation.find('[pageId=page' + index + ']').addClass('active');
          $navigation.find('[pageId=page' + index + ']').find('a').on('click', self.switchTo);
        }
      } else {
        $navigation.find('[pageId=page' + index + ']').removeClass('active');
        $navigation.find('[pageId=page' + index + ']').find('a').on('click', self.switchTo);
      }

      if (pageIndex == index) {
        $navigation.find('[pageId=page' + index + ']').addClass('current');
        $navigation.find('[pageId=page' + index + ']').find('a').off('click');
      } else {
      	$navigation.find('[pageId=page' + index + ']').removeClass('current');
      }
    });

    // actions
    self.enableActions();

    // custom action
    if (self.object.options.customLabel1 && self.object.options.customLabel1 != '')
      self.object.$context.find(self.actionSelectors['custom1']).val(self.object.options.customLabel1);
    if (self.object.options.customLabel2 && self.object.options.customLabel2 != '')
      self.object.$context.find(self.actionSelectors['custom2']).val(self.object.options.customLabel2);
    if (self.object.options.customLabel3 && self.object.options.customLabel3 != '')
      self.object.$context.find(self.actionSelectors['custom3']).val(self.object.options.customLabel3);

    // actions

    // page specific
    var actions = self.object.getButtons();
    var excludeActions = self.object.getExcludeButtons();
    jQuery.each(self.actions, function(index, action) {
      if (jQuery.inArray(action.toUpperCase(), actions) != -1)
        self.showActions([action]);
      else
        self.hideActions([action]);
    });

    // mode specific
    if (mode == 'EDIT') {
      self.showActions(['previous', 'next']);

      if (!excludeActions || (excludeActions && jQuery.inArray('RESET', excludeActions) == -1))
        self.showActions(['reset']);
    } else if (mode == 'USER_CONFIRMATION') {
      if (!excludeActions || (excludeActions && jQuery.inArray('BACK', excludeActions) == -1))
        self.showActions(['back']);
    } else if (mode == 'SYSTEM_CONFIRMATION') {
      if (!excludeActions || (excludeActions && jQuery.inArray('OK', excludeActions) == -1))
        self.showActions(['ok']);
    }

    // previous, next
    if (pageIndex == 0)
      self.hideActions(['previous']);
    if (pageIndex == (self.object.pages.length - 1))
      self.hideActions(['next']);

    self.modeIndex = modeIndex;
		
	self.wizardHeight();
  };


  // render
  this.render = function() {
    self.doRender('render');
  };
  
  // add css for fixed height on resize
  jQuery(window).on('resize',self.wizardHeight);
  
  // update
  this.update = function() {
    self.doRender('update');
  };


  // error
  this.error = function() {
    var messages = [];
    $.each(self.object.$context.find('ul.xenosError li'), function(index, value) {
      messages.push($(value).text())
    });
    self.object.$context.find('.formTabErrorIco')
						.show()
						.off('click')
						.on('click', xenos.postNotice(xenos.notice.type.error, messages, true));
  };


  // dispose
  this.dispose = function() {
	jQuery(window).off('resize',self.wizardHeight);
  };
}
