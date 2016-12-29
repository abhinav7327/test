//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
//
// xenos
//  - Infrastructure
//

// define console for IE
if (!window.console) {
  window.console = {
    log: function() {
      // no-op;
    },
    debug: function() {
      // no-op;
    },
    info: function() {
      // no-op;
    },
    warn: function() {
      // no-op;
    },
    error: function() {
      // no-op;
    }
  };
}


function GetIEVersion() {
  var sAgent = window.navigator.userAgent;
  var Idx = sAgent.indexOf("MSIE");

  // If IE, return version number.
  if (Idx > 0) 
    return parseInt(sAgent.substring(Idx+ 5, sAgent.indexOf(".", Idx)));

  // If IE 11 then look for Updated user agent string.
  else if (!!navigator.userAgent.match(/Trident\/7\./)) 
    return 11;

  else
    return 0; //It is not IE
}

if(GetIEVersion() > 0 && GetIEVersion() == 11){
  $.browser.msie = true;
} 
   



if (typeof xenos === 'undefined') {

  // define xenos
  window.xenos = function() {
    // loaded JavaScripts
    var scripts = {};

    // load JavaScripts
    var loadScript = function(_scripts, options) {
      // loader
      var loader = function() {
        // restore script
        var script = this;

        var _function = function() {
          var success = function() {
            if (script.success)
              script.success();

            scripts[script.path].loaded = true;
            script.loaded = true;
          };
          var error = function() {
            if (script.error)
              script.error();

            scripts[script.path].loaded = false;
            script.loaded = true;
          };

          if (scripts[script.path].loaded && !scripts.reload) {
            success();
          } else if (scripts[script.path].request) {
            scripts[script.path].request.always(function(content, status, xhr) {
              if (status == 'success') {
                success();
              } else {
                error();
              }
            });
          } else {
            scripts[script.path].request = jQuery.ajax({
              url: script.path,
              dataType: 'script',
              async: typeof script.async !== 'undefined' ? script.async : true,
              success: success,
              error: error
            }).always(function() {
                  delete scripts[script.path].request;
            });
          }
        };
        setTimeout(_function, 0);
      };


      // fix required _scripts
      var array = [];
      jQuery.each(_scripts, function(index, script) {
        // attach loader
        script.loader = loader;

        if (scripts[script.path] && scripts[script.path].loaded) {
          if ((typeof script.reload !== 'undefined' && script.reload)
              || (typeof script.reload === 'undefined' && options && options.reload)) {
            array.push(script);
          }
        } else {
          scripts[script.path] = {};
          array.push(script);
        }
      });


      // load required JavaScripts
      var _function = function() {
        if (options && options.ordered) {
          delegateToAll({targets: array, operation: 'loader', state: 'loaded'});
        } else {
          delegateToAll({targets: array, operation: 'loader'});
        }
      };
      setTimeout(_function, 0);


      // wait for JavaScripts
      _function = function() {
        waitForAll({
          targets: array,
          state: 'loaded',
          callback: function() {
            var success = true;
            jQuery.each(array, function(index, script) {
              if (!scripts[script.path].loaded) {
                success = false;
                return false;
              }
            });

            if (success) {
              if (options && options.success)
                options.success.apply(this, arguments);

              // trigger event
              jQuery(document).trigger('load-script-done', _scripts);
            } else {
              if (options && options.error)
                options.error.apply(this, arguments);

              // trigger event
              jQuery(document).trigger('load-script-failed', _scripts);
            }
          }
        });
      };
      setTimeout(_function, 0);
    };


    // load localized JavaScripts
    var loadLocalizedScript = function(_scripts, options) {
      // fixed scripts
      jQuery.each(_scripts, function(index, script) {
        var dotJs = script.path.indexOf('.js');
        if (dotJs != -1)
          script.path = script.path.substring(0, dotJs);

        if (xenos.context.locale != 'en')
          script.fallbackPath = script.path + '_en.js';

        script.path = script.path + '_' + xenos.context.locale + '.js';

        script.error = function() {
          scripts[script.path].loaded = false;
          script.loaded = true;

          if (script.fallbackPath)
            loadScript([{path: script.fallbackPath}]);
        };
      });

      loadScript(_scripts, options);
    };


    // post notice
    var postNotice = function(type, message, persistent) {
    	
      // Clear existing growl messages - only persistent error messages
      if(persistent && type === xenos.notice.type.error){
        if(jQuery('.growlBox', '.growlBoxarea').length > 0){
          jQuery('.growlBox', '.growlBoxarea').each(function(){
            $('#growlBoxClose', this).click();
          });
        }
      }
    
      // fix message
      if (typeof message !== 'string') {
        var messages = message;
        message = '';
        jQuery.each(messages, function(i, msg) {
           message += '<li>' + xenos.utils.escapeHtml(msg) + '</li>';
        });
      } else {
        message = '<li>' + xenos.utils.escapeHtml(message) + '</li>';
      }

      // fix markup
      var markup = ''
          + '<div class="growlBox">'
          + '  <a href="" onclick="return false;" rel="close">'
          + '    <div id="growlBoxClose"></div>'
          + '  </a>'
          + '  <div class="growlBoxbg">'
          + '    <div class="left ' + type + 'Icon"></div>'
          + '    <div class="content"><ul>%message%</ul></div>'
          + '  </div>'
          + '  <div class="bottomShadow"></div>'
          + '</div>';
	
		if(persistent){
			var container = jQuery('#content');
			var errIcoElement = $('.formTabErrorIco', container);
			if(typeof errIcoElement !== 'undefined'){
				if(type === xenos.notice.type.warning){
					if(!errIcoElement.hasClass('formTabWarningIco')){
						errIcoElement.addClass('formTabWarningIco');
					}
				} else {
					if(errIcoElement.hasClass('formTabWarningIco')){
						errIcoElement.removeClass('formTabWarningIco');
					}
				}
			}
		}
	    
      // fix growl function
      var _function = function() {
        // growl display timeout
        jQuery.growl.settings.displayTimeout = persistent ? -1 : 3500;

        // growl dock template
        jQuery.growl.settings.dockTemplate = '<div class="growlBoxarea"></div>';
        jQuery.growl.settings.dockCss = {};

        // growl notice template
        jQuery.growl.settings.noticeTemplate = markup;
        jQuery.growl.settings.noticeCss = {};

        // growl
        jQuery.growl('', message, type);
      };

      _function();
      if (persistent) return _function;
    };


    // delegation
    // options: target, operation, parameters, delegator
    var delegateTo = function(options) {
      if (!options) return;

      var target = options.target;
      var operation = options.operation;
      var parameters = options.parameters;
      var delegator = options.delegator;

      if (!target) return;

      if (jQuery.isFunction(operation)) {
        operation.apply(delegator ? delegator : target, parameters ? parameters : []);
      } else if (target[operation]) {
        target[operation].apply(delegator ? delegator : target, parameters ? parameters : []);
      } else {
        target.apply(delegator ? delegator : target, parameters ? parameters : []);
      }
    };
    // options: targets, order, operation, parameters, state, value, timeout, delegator
    var delegateToAll = function(options) {
      if (!options) return;

      var targets = options.targets;
      var order = options.order;
      var operation = options.operation;
      var parameters = options.parameters;
      var state = options.state;
      var value = options.value;
      var timeout = options.timeout;
      var delegator = options.delegator;

      if (!targets) return;

      if (state) {
        var array = [];
        if (order) {
          jQuery.each(order, function(index, reference) {
            array.push(targets[reference]);
          });
        } else {
          jQuery.each(targets, function(reference, target) {
            array.push(target);
          });
        }

        waitAndDelegateToAll({
          targets: array,
          index: 0,
          operation: operation,
          parameters: parameters,
          state: state,
          value: value,
          timeout: timeout,
          delegator: delegator
        });
      } else {
        if (order) {
          jQuery.each(order, function(index, reference) {
            delegateTo({
              target: targets[reference],
              operation: operation,
              parameters: parameters,
              delegator: delegator
            });
          });
        } else {
          jQuery.each(targets, function(reference, target) {
            delegateTo({
              target: target,
              operation: operation,
              parameters: parameters,
              delegator: delegator
            });
          });
        }
      }
    };


    // wait
    // options: target, state, value, timeout, callback, delegator
    var waitFor = function(options) {
      if (!options) return;

      var target = options.target;
      var state = options.state;
      var value = options.value;
      var timeout = options.timeout;
      var callback = options.callback;
      var delegator = options.delegator;

      if (!target || !state) return;

      var done = true;

      if (jQuery.isFunction(state)) {
        done = state.call(target);
      } else {
        if (!target[state]
            || (typeof value !== 'undefined' && target[state] != value))
          done = false;
      }

      if (done) {
        callback.call(delegator ? delegator : callback);
      } else {
        var _function = function() {
          waitFor({
            target: target,
            state: state,
            value: value,
            timeout: timeout,
            callback: callback,
            delegator: delegator
          });
        };
        setTimeout(_function, timeout ? timeout : 1);
      }
    };
    // options: targets, order, state, value, timeout, callback, delegator
    var waitForAll = function(options) {
      if (!options) return;

      var targets = options.targets;
      var state = options.state;
      var value = options.value;
      var timeout = options.timeout;
      var callback = options.callback;
      var delegator = options.delegator;

      if (!targets || !state) return;

      var done = true;

      jQuery.each(targets, function(reference, target) {
        if (jQuery.isFunction(state)) {
          done = state.call(target);
        } else {
          if (!target[state]
              || (typeof value !== 'undefined' && target[state] != value))
            done = false;
        }

        if (!done) return false;
      });

      if (done) {
        callback.call(delegator ? delegator : callback);
      } else {
        var _function = function() {
          waitForAll({
            targets: targets,
            state: state,
            value: value,
            timeout: timeout,
            callback: callback,
            delegator: delegator
          });
        };
        setTimeout(_function, timeout ? timeout : 1);
      }
    };


    // wait and delegate
    // options: targets, index, operation, parameters, state, value, timeout, delegator
    var waitAndDelegateToAll = function(options) {
      if (!options) return;

      var targets = options.targets;
      var index = options.index;
      var operation = options.operation;
      var parameters = options.parameters;
      var state = options.state;
      var value = options.value;
      var timeout = options.timeout;
      var delegator = options.delegator;

      if (!targets) return;

      var callback = function() {
        if (index == targets.length) return;

        var target = targets[index++];

        delegateTo({
          target: target,
          operation: operation,
          parameters: parameters,
          delegator: delegator
        });

        waitFor({
          target: target,
          state: state,
          value: value,
          timeout: timeout,
          callback: callback
        });
      };

      callback();
    };


    // loaded plugins
    var puid = 1;
    var plugins = {};

    // plugin structure
    // as well as default plugin
    var defaultPlugin = {
      // name
      name: 'unknown',

      // event
      event: {
        prefix: 'unknown',
        suffix: 'done'
      },

      // lifecycle phases
      data: function(parameters) {
        // data
        // no-op;
      },
      create: function(parameters) {
        // ui
        // no-op;
      },
      init: function(parameters) {
        // events, actions, etc
        // no-op;
      },
      destroy: function(parameters) {
        // cleanup
        // no-op;
      }
    };


    // plugin container
    var pluginContainer = function(plugin, reload, parameters) {
      // fixed reload
      if (jQuery.isArray(reload)) {
        parameters = reload;
        reload = undefined;
      }


      // manipulate the event type
      // for a given phase/method name
      var type = function(phase) {
        var type = '';

        if (plugin.event.prefix != '')
          type += plugin.event.prefix + '-';
        type += phase;
        if (plugin.event.suffix != '')
          type += '-' + plugin.event.suffix;

        return type;

      };
      // invoke the function
      // for a given phase/method name
      var invoke = function(phase, parameters) {
        // will invoke defined phase only
        if (plugin[phase]) {
          plugin[phase].apply(plugin, parameters ? parameters : []);
          jQuery(document).trigger(type(phase), plugin.name);
        }
      };

      // load plugin if necessary
      if (!plugin.puid) {
        plugin = jQuery.extend(true, {}, defaultPlugin, plugin);

        plugin.puid = puid++;
        plugin.neo = true;

        plugins[plugin.puid] = plugin;

        // prepare container
        plugin.container = {
          name: plugin.name,
          id: function() {
            return plugin.puid;
          },
          // dispose
          dispose: function(parameters) {
            // destroy plugin
            invoke('destroy', parameters);

            delete plugins[plugin.puid];

            delete plugin.puid;
            delete plugin.neo;
            delete plugin.container;

            // trigger event
            jQuery(document).trigger('dispose-plugin-done', plugin.name);

            // return the container
            // for syntactic sugar
            return this;
          },
          // invoke method
          invoke: function(method, parameters) {
            invoke(method, parameters);

            // return the container
            // for syntactic sugar
            return this;
          }
        };

        // prepare (data,create,init) plugin
        invoke('data', parameters);
        invoke('create', parameters);
        invoke('init', parameters);

        // trigger event
        jQuery(document).trigger('load-plugin-done', plugin.name);
      }

      // restore the plugin
      plugin = plugins[plugin.puid];
      if (plugin.neo) {
        plugin.neo = false;
      } else if (reload) {
        // prepare (data,create,init) plugin
        invoke('data', parameters);
        invoke('create', parameters);
        invoke('init', parameters);

        // trigger event
        jQuery(document).trigger('reload-plugin-done', plugin.name);
      }

      return plugin.container;
    };


    return {
      // load JavaScript
      loadScript: function(scripts, options) {
        loadScript(scripts, options);
        return this;
      },
      // load localized JavaScript
      loadLocalizedScript: function(scripts, options) {
        loadLocalizedScript(scripts, options);
        return this;
      },

      // post notice
      notice: {
        type: {
          info: 'info',
          warning: 'warning',
          error: 'error',
          success: 'success'
        },
        post: function(type, message, persistent) {
          return postNotice(type, message, persistent);
        }
      },
      postNotice: function(type, message, persistent) {
        return postNotice(type, message, persistent);
      },

      // delegation
      delegateTo: function(options) {
        delegateTo(options);
        return this;
      },
      delegateToAll: function(options) {
        delegateToAll(options);
        return this;
      },

      // wait
      waitFor: function(options) {
        waitFor(options);
        return this;
      },
      waitForAll: function(options) {
        waitForAll(options);
        return this;
      },

      // load plugin
      loadPlugin: function(plugin, reload, parameters) {
        // prepare plugin container
        return pluginContainer(plugin, reload, parameters);
      },
      // dispose plugin
      disposePlugin: function(plugin, parameters) {
        // prepare plugin container
        // and dispose as well
        return pluginContainer(plugin, false, parameters).dispose(parameters);
      },

      // invoke method on plugin
      invokePlugin: function(plugin, method, parameters) {
        // prepare plugin container
        // and invoke method as well
        return pluginContainer(plugin, false, parameters).invoke(method, parameters);
      }
    };
  }();


  // context
  xenos.context = {};
  jQuery('script').each(function() {
    if (jQuery(this).attr('locale'))
      xenos.context.locale = jQuery(this).attr('locale');
    if (jQuery(this).attr('path'))
      xenos.context.path = jQuery(this).attr('path');
	
	// xenos session time out, so that client takes the user to xenos login or error page (in case of CA service ON)
	// before 5 seconds of actual xenos session time out
	if (jQuery(this).attr('timeout'))
      xenos.context.timeout = jQuery(this).attr('timeout');
  });

  // handle locale
  if (!xenos.context.locale)
    xenos.context.locale = 'en';
  
  // UPDATE menu indentifier
  xenos.context.updateMenuParam = 'screenType=M';
  //default width of grid columns
  xenos.context.defaultWidth = {};
  // online restriction check for XMLHTTP.responseText
  xenos.context.isContentOnlineRestriction = function(XHR) {
	// don't change the indentifier text [__ONLINE_RESTRICTED_OOPS!!!__], for details please see WEB-INF/views/onlineRestriction.jspx
	return XHR.responseText.indexOf("__ONLINE_RESTRICTED_OOPS!!!__");
  };
  
  // from error JSON script, to identify data.onlineAccessRestriction is true or not
  // error message growl managed here, just caller cheks the return value false and retruns
  // otehrwise pass the control as it is
  // for details see @OnlineAccessRestrictionInterceptor
  xenos.context.isOnlineAccessRestricted = function(data) {
				
	/**Special care of handling online access restriction error page**/
	// see more @ OnlineAccessRestrictionInterceptor#prepareErrorJSONScript(...)
	if(typeof data.onlineAccessRestriction != 'undefined') {

		// error message according to JSON attribute
		// if validation fails (typically DB error) then different error message
		var errorMessage = ((typeof data.validationFails == 'undefined') ?
		xenos.i18n.accessvalidationmessage.application_closed :
			xenos.i18n.accessvalidationmessage.access_restricted) + data.module;
								
		// shows error message growl and returns back
		// persists the message block until user closes
		xenos.postNotice(xenos.notice.type.error, errorMessage, true);
								
		return true;
	} else {
		return false;
	}
  };

  // handle timeout
  /* xenos.context.timeoutFunction = function() {
	
	var href = window.location.href;

	var CAServiceOn = typeof CA_SERVICE_ON != 'undefined' && CA_SERVICE_ON == true;
	var expiryPage = (CAServiceOn && typeof xenos_ERROR_URI != 'undefined' && xenos_ERROR_URI != null) ? xenos_ERROR_URI : "";
  
    // only flushes expiry message if it's in APP, not in LOG IN screen
    if (href.indexOf('login') == -1 && href.indexOf(expiryPage) == -1) {
		var redirectedPage = (expiryPage == "") ? "/resources/j_spring_security_logout" : expiryPage;
	   // alert message according to CA on/off
      jAlert(xenos.i18n.message[CAServiceOn ? "xenos_error_page" : "your_session_expired"], null, function() {
	  // in case if CA service is ON and error page available it redirects to GV error page otherwise normal flow (spring logout)
        window.location.assign(xenos.context.path + redirectedPage, '_self');
      });
    }
  }; */
  
   // loads xenos eror page when internal AJAX call (JSON response) fails
   // or error page loaded into sub frame then top window loaded with error page itself
   //@content response content
   function handlexenosErrorPage(content) {
    // xenos error page indicator
	var errorPageIndicator = "__xenosSessionExpiry_indicator__[";
	// CA service ON and response content conatins error page indicator content
	// load error page into top window
	if(typeof CA_SERVICE_ON != 'undefined'
				&& typeof content === 'string') {
		var pos = content.indexOf(errorPageIndicator);
		// xenos error page loaded in subframe it needs to load on top window
		if(pos != -1) {
			var l = errorPageIndicator.length;
			var start = pos + l;
			var end = content.indexOf("]errorMessageKey__");
			// __[gets enclosed error key]errorMessageKey__
			var key = content.substring(start, end);
			// remove flag on to remove error message from app ctx as error page will be on top window
			window.open(xenos.context.path + xenos_ERROR_URI + "?errorKey=" + encodeURIComponent(key) + "&remove=Y", '_self');
		}
	}
  }
   
   // handle resource access, in case user use multiple tab and logout form one tab and access resource form another tab.
   xenos.context.handleSessionOut = function(e, xhr, options) {
	  // only flushes session out message if it's in APP, not in LOG IN screen
		   var _session_out_flag = options.sessionOutFlag
		   ? options.sessionOutFlag : (typeof xhr.responseText === 'string') 
		   && (xhr.responseText.indexOf('j_username') != -1) 
		   && (window.location.href.indexOf('login') == -1) 
		   && (typeof CA_SERVICE_ON == 'undefined'); 
       if (_session_out_flag) {	   
          jAlert(xenos.i18n.message["your_session_expired"], 'Confirm Dialog', function() {
				window.location.href = xenos.context.path;
                window.top.location.assign(xenos.context.path + "/resources/j_spring_security_logout",'_self');
				location.reload(true);
				return false;			  
           });
       }
   };
   
   // global ajax handler for error
    jQuery(document).ajaxError(function(ev, xhr, options, exception) {
		if(xhr.status == 999) {
            xenos.context.handleSessionOut(ev, xhr, {sessionOutFlag: true}); 
            return false;
        }   
    });
  
  // handler to call 5 seconds before of actual session expiry
  //xenos.context.timeoutHandler = setTimeout(xenos.context.timeoutFunction, (xenos.context.timeout - 5) * 1000);
  // AFTER each ajax call (after loading home page no request supposed to be through browser location, all are ajax) to reset the timer
  // and takes care also xenos error page reloading in case of CA service intregation
  jQuery(document).ajaxComplete(function(e, xhr, options) {
	
	if(xhr.status == 999) {
		xenos.context.handleSessionOut(e, xhr, {sessionOutFlag: true});
		return false;
	}
	// only for server status [OK] and not xenos-all.js
	// because js page itself contains those error message indicator string
	if(xhr.status == 200 && options.url.indexOf("xenos-all.js") == -1) {
		// handle error page loading if required
		// this is typically when CA service ON and CA session validation errors
		//handlexenosErrorPage(xhr.responseText);
		//Handle Session out
		xenos.context.handleSessionOut(e, xhr, options);
		return false;
	}
  });


  // force full caching and access deny handling
  jQuery.ajaxSetup({
    cache: true,
    statusCode: {
      403: function() {
        xenos.postNotice(xenos.notice.type.error, xenos.i18n.message.access_denied);
      },
	  400: function() {
        xenos.postNotice(xenos.notice.type.error, xenos.i18n.message.bad_request);
      },408: function() {
        xenos.postNotice(xenos.notice.type.warning, xenos.i18n.message.reuest_timeout,true);
      }
      
    },
    success: function(content, status, xhr) {
	
      // skips in CA service is ON
	  if (typeof CA_SERVICE_ON == 'undefined' && typeof content === 'string' && content.indexOf('j_username') != -1) {
        jAlert(xenos.i18n.message["your_session_expired"], 'Confirm Dialog', function() {              
				window.location.href = xenos.context.path;
                window.location.assign(xenos.context.path + "/resources/j_spring_security_logout",'_self');
				location.reload(true);
				return false;
           });
	  }
    }
  });


  // store jQuery.fn.dialog
  var jQueryDialog = jQuery.fn.dialog;

  // extends jQuery to plugin our decorated dialog
  jQuery.fn.extend({
    dialog: function() {
      // applying stored jQuery.fn.dialog
      var _return = jQueryDialog.apply(this, arguments);

      this.parent('.ui-dialog').draggable("option", "containment", "#content");

      // return
      return _return;
    }
  });


  // extends jQuery to plugin our plugin container
  jQuery.fn.extend({
    // load plugin
    loadPlugin: function(plugin, reload, parameters) {
      // load plugin container
      var container = xenos.loadPlugin(plugin, reload, [this].concat(parameters));

      // attach to context
      var plugins = this.data('plugins');
      if (!plugins)
        plugins = {};

      // attach
      plugins[container.id()] = container;

      this.data('plugins', plugins);
      return this;
    },
    // dispose plugin
    disposePlugin: function(plugin, parameters) {
      // fixed plugin
      if (jQuery.isArray(plugin)) {
        parameters = plugin;
        plugin = undefined;
      }

      // if no plugin specified
      // dispose all plugins
      if (!plugin) {
        // detach from context
        var plugins = this.data('plugins');
        if (!plugins) return this;

        jQuery.each(plugins, function(puid, container) {
          container.dispose([this].concat(parameters));
        });

        this.removeData('plugins');
        return this;
      }

      // prepare plugin container
      // and dispose as well
      var container = xenos.disposePlugin(plugin, [this].concat(parameters));

      // detach from context
      plugins = this.data('plugins');
      if (!plugins) return this;

      // detach
      delete plugins[container.id()];

      this.data('plugins', plugins);
      return this;
    },

    // invoke method on plugin
    invokePlugin: function(plugin, method, parameters) {
      // prepare plugin container
      // and invoke method as well
      var container = xenos.invokePlugin(plugin, method, [this].concat(parameters));

      // attach to context
      var plugins = this.data('plugins');
      if (!plugins)
        plugins = {};

      // attach
      plugins[container.id()] = container;

      this.data('plugins', plugins);
      return this;
    }
  });


  // trigger event
  jQuery(document).trigger('xenos-prepared');
}
//
// xenos
//  - Cache infrastructure
//

if (typeof xenos$Cache === 'undefined') {

  // define xenos Cache
  window.xenos$Cache = function() {
    // cache
    var cache = {};

    // return empty
    return {
      // get from cache
      get: function(key) {
        return key ? cache[key] : cache;
      },
      // put to cache
      put: function(key, value) {
        if (key)
          cache[key] = value;
      },

      // remove from cache
      remove: function(key) {
        if (key)
          delete cache[key];
      }
    };
  }();


  // trigger event
  jQuery(document).trigger('xenos-cache-prepared');
}
//
// xenos
//  - Hook infrastructure
//

if (typeof xenos$Hook === 'undefined') {

  // define xenos Hook
  window.xenos$Hook = function() {
    // added hooks
    var huid = 1;


    // has function
    var has = function(context, type, position) {
      // hooks
      var hooks = context.data('hooks');
      if (!hooks || jQuery.isEmptyObject(hooks)) return false;

      // types
      var types = hooks[type];
      if (!types || jQuery.isEmptyObject(types)) return false;

      // positions
      var positions = types[position];
      return positions && !jQuery.isEmptyObject(positions);
    };

    // get function
    var get = function(context, type, position) {
      // hooks
      var hooks = context.data('hooks');
      if (!hooks) return;

      // types
      var types = hooks[type];
      if (!types) return;

      // positions
      var positions = types[position];
      if (!positions) return;

      return positions;
    };


    // on function
    // add the given hook to given content
    var on = function(context, type, position, hook) {
      // hooks
      var hooks = context.data('hooks');
      if (!hooks)
        hooks = {};

      // types
      var types = hooks[type];
      if (!types)
        types = hooks[type] = {};

      // positions
      var positions = types[position];
      if (!positions)
        positions = types[position] = {};

      // huid
      if (!hook.huid)
        hook.huid = huid++;

      positions[hook.huid] = hook;

      context.data('hooks', hooks);
      return context;
    };

    // off function
    // remove the given hook from given content
    var off = function(context, type, position, hook) {
      // huid
      if (hook && !hook.huid) return context;

      // hooks
      var hooks = context.data('hooks');
      if (!hooks) return context;

      // types
      var types = hooks[type];
      if (!types) return context;

      // positions
      if (!position) {
        delete hooks[type];
      } else {
        var positions = types[position];
        if (!positions) return context;

        // huid
        if (!hook) {
          delete types[position];
        } else {
          delete positions[hook.huid];
        }
      }

      context.data('hooks', hooks);
      return context;
    };


    // invoke function
    // invoke hooks for given type for given context
    var invoke = function(context, type, position, parameters) {
      // adjust parameters
      if (!parameters)
        parameters = [];

      // hooks
      var hooks = get(context, type, position);
      if (!hooks) return;

      // invoke all
      var $continue;
      jQuery.each(hooks, function(huid, hook) {
        // invoking defined hook only
        if (hook) {
          $continue = hook.apply(context, parameters);
          if ($continue == false) return false;
        }
      });
      return $continue;
    };


    return {
      // positions
      position: {
        pre: 'pre',
        post: 'post'
      },

      // has function
      has: function(context, type, position) {
        return has(context, type, position);
      },

      get: function(context, type, position) {
        return get(context, type, position);
      },

      // on function
      on: function(context, type, position, hook) {
        return on(context, type, position, hook);
      },
      // off function
      off: function(context, type, position, hook) {
        return off(context, type, position, hook);
      },

      // invoke function
      invoke: function(context, type, position, parameters) {
        return invoke(context, type, position, parameters);
      }
    }
  }();


  // extends jQuery to plugin our trigger hooks
  jQuery.fn.extend({
    preOn: function(type, hook) {
      xenos$Hook.on(this, type, xenos$Hook.position.pre, hook);
      return this;
    },
    preOff: function(type, hook) {
      xenos$Hook.off(this, type, xenos$Hook.position.pre, hook);
      return this;
    },

    postOn: function(type, hook) {
      xenos$Hook.on(this, type, xenos$Hook.position.post, hook);
      return this;
    },
    postOff: function(type, hook) {
      xenos$Hook.off(this, type, xenos$Hook.position.post, hook);
      return this;
    }
  });


  // trigger event
  jQuery(document).trigger('xenos-hook-prepared');
}
//
// xenos
//  - Event infrastructure
//

if (typeof xenos$Event === 'undefined') {

  // define xenos Event
  window.xenos$Event = function() {
    // document
    var $document = jQuery(document);


    // on function
    var on = function(type, handler) {
      $document.on(type, handler);
    };

    // off function
    var off = function(type, handler) {
      $document.off(type, handler);
    };


    // trigger function
    var trigger = function(type, data) {
      $document.trigger(type, data);
    };


    return {
      // on function
      on: function(type, handler) {
        on(type, handler);
        return this;
      },
      // off function
      off: function(type, handler) {
        off(type, handler);
        return this;
      },

      // trigger function
      trigger: function(type, data) {
        trigger(type, data);
        return this;
      }
    }
  }();


  // store jQuery.fn.trigger
  var jQueryTrigger = jQuery.fn.trigger;

  // extends jQuery to plugin our decorated trigger
  jQuery.fn.extend({
    trigger: function(type, data) {
      // pre hook
      var $continue = xenos$Hook.invoke(this, type, xenos$Hook.position.pre, data);

      if ($continue != false) {
        // applying stored jQuery.fn.trigger
        var _return = jQueryTrigger.apply(this, arguments);

        // post hook
        xenos$Hook.invoke(this, type, xenos$Hook.position.post, data);

        // return
        return _return;
      } else {
        // trigger is prevented
        // by hooks
        return this;
      }
    }
  });


  // trigger event
  jQuery(document).trigger('xenos-event-prepared');
}
//
// xenos
//  - Handler `multipart` infrastructure
//

if (typeof xenos$Handler$multipart === 'undefined') {

  // define xenos Handler `multipart`
  window.xenos$Handler$multipart = function() {
    // multipart id
    var muid = 1;


    // ajax
    var ajax = function(e, options, settings) {
      var $body = jQuery('body');

      // attributes
      var _always = [];
      var _aborted = false;
	  var _doneFunc = function(){};


      var always = function(f) {
        _always.push(f);
      };

      var abort = function() {
        _aborted = true;
      };
	  
	  var done = function(f) {
        _doneFunc = f;
      };


      // append iframe
      var iframe = 'iframe' + muid++;
      $body.append('<iframe id="' + iframe + '" name="' + iframe + '" style="display: none;"/>');

      var $iframe = jQuery('#' + iframe);
      $iframe.on('load', function() {
        var content = $iframe.contents().find('body').html();
        var formItemArea = $iframe.contents().find('.formItemArea');
		var xenosErrorEle = $iframe.contents().find('.xenosError');
        if (jQuery.browser.msie) {
          jQuery.each($iframe.contents().find('script'), function(index, s) {
            content += '<script>' + s.text + '</script>';
          });
        }

        if (!_aborted) {
        	
        	if((formItemArea.length == 0) && (xenosErrorEle.length == 0) && content.indexOf("408") > -1 && content.indexOf("Request Time Out") > -1){
				var requestTimeOut = 408;
				$.extend( options, {
						requestTimeOut : requestTimeOut
					} );
        	}
        	
          // success
          settings.success(content);

          // always
          jQuery.each(_always, function(index, f) {
            f();
          });

		  if(jQuery.isFunction(_doneFunc)){
			_doneFunc();
		  }
        }
        
        //Remove iframe
        setTimeout(function() {$iframe.remove();}, 500);
      });


      // form
      var $form = jQuery(options.multipartForm);
      var originalTarget = $form.attr('target');
      $form.attr('target', iframe);
      var originalAction = $form.attr('action');
      $form.attr('action', settings.url);
      $form.submit();
	  if(settings.beforeSend && jQuery.isFunction(settings.beforeSend)){
		  	//Request Object needs to be created at this place 
		    //and need to be passed to the beforeSend(requestObj) function
			//because this is a dummy ajax object and the request object is not available here
			var requestObj = {
				setRequestHeader : function(name, value){

				}
			};
			settings.beforeSend(requestObj);
	  }
      $form.attr('target', originalTarget);
      $form.attr('action', originalAction);

      return {
        always: function(f) {
          always(f);
        },
        abort: function() {
          abort();
        },
		done: function(f) {
		  done(f);
		}
      }
    };


    return {
      ajax: function(e, options, settings) {
        return ajax(e, options, settings);
      }
    }
  }();


  // trigger event
  jQuery(document).trigger('xenos-handler-multipart-prepared');
}
//
// xenos
//  - Handler infrastructure
//

if (typeof xenos$Handler === 'undefined') {

  // define xenos Handler
  window.xenos$Handler = function() {
    // our great saver

    // save function
    var save = function($context, callback, delegator) {
      if (xenos$Hook.has($context, 'xenos-handler', xenos$Hook.position.pre)) {
    	//JConfirm doesn't support button label modification. To do so we retrieve 
    	//the original button label and store it to a local variable so that it can
    	//be reassigned.
    	var tempOkLabel = $.alerts.okButton;
  		var tempCancelLabel = $.alerts.cancelButton;
  		$.alerts.okButton = xenos.i18n.confirmlabel.okButton;
  		$.alerts.cancelButton = xenos.i18n.confirmlabel.cancelButton;
        jConfirm(xenos.i18n.message.save_your_change, null, function(confirmation) {
          var savers = xenos$Hook.get($context, 'xenos-handler', xenos$Hook.position.pre);
          if (savers) {
            jQuery.each(savers, function(suid, saver) {
              // invoking defined saver only
              if (saver)
                saver.apply(this, [confirmation]);
            });
          }

          xenos$Hook.off($context, 'xenos-handler', xenos$Hook.position.pre);
          callback.call(delegator ? delegator : callback);
        });
        $.alerts.okButton = tempOkLabel;
		$.alerts.cancelButton = tempCancelLabel;
      } else {
        callback.call(delegator ? delegator : callback);
      }
    };


    return {
      // last requests
      requests: {
      },

      // save function
      save: function($context, callback, delegator) {
        return save($context, callback, delegator);
      }
    }
  }();


  // extends jQuery to plugin our great saver
  jQuery.fn.extend({
    // add saver
    saverOn: function(saver) {
      this.preOn('xenos-handler', saver);
      return this;
    },
    // remove saver
    saverOff: function(saver) {
      this.preOff('xenos-handler', saver);
      return this;
    }
  });


  // trigger event
  jQuery(document).trigger('xenos-handler-prepared');
}


if ((typeof xenos$Handler$function === 'undefined') && (typeof xenos$Handler$default === 'undefined')) {

  // define xenos Handler function
  window.xenos$Handler$function = function(handler) {
    // handler structure
    // as well as default handler
    var defaultHandler = {
      // handler constants
      // requestType
      // synchronous/asynchronous
      requestType: {
        synchronous: 'synchronous',
        asynchronous: 'asynchronous'
      },
      // target
      // _blank/_parent/_self/_top
      target: {
        _blank: '_blank',
        _parent: '_parent',
        _self: '_self',
        _top: '_top'
      },
      // contentType
      // html/json/xml
      contentType: {
        html: 'html',
        json: 'json',
        xml: 'xml'
      },


      // handler options
      // various attributes
      attributes: {
        requestUri: 'href',
        requestType: 'requestType',
        target: 'target',
        contentType: 'contentType',
        contentTemplate: 'contentTemplate'
      },
      // various uri patterns
      patterns: {
        jsonUri: '.json',
        xmlUri: '.xml'
      },


      // handler settings
      settings: {
      },


      // handler callback
      callback: {
      },


      // handler implementation
      // generic
      generic: function(e, options) {
        // let controller handle
        if (e)
          e.preventDefault();

        handler.controller(e, options);
        return this;
      },


      // other useful functions used by generic handler
      // which can be customized
      // metadata
      get: {
        // request uri
        requestUri: function(e, options) {
          if (!e) return;

          return jQuery(e.target).attr(handler.attributes.requestUri);
        },
        // request type
        // synchronous/asynchronous
        requestType: function(e, options) {
          if (!e) return;

          var requestType = jQuery(e.target).attr(handler.attributes.requestType);
          if (!requestType)
            requestType = handler.requestType.synchronous;

          return requestType;
        },
        // target
        // _blank/_parent/_self/_top/element
        target: function(e, options) {
          if (!e) return;

          var target = jQuery(e.target).attr(handler.attributes.target);
          if (!target)
            target = handler.target._self;

          return target;
        },
        // content type
        // html/json/xml
        contentType: function(e, options, requestUri) {
          if (!e) return handler.contentType.html;

          // first attribute
          var contentType = jQuery(e.target).attr(handler.attributes.contentType);
          if (contentType) return contentType;

          // then, second uri pattern
          contentType = handler.contentType.html;

          if (!requestUri) return contentType;

          if (requestUri.indexOf(handler.patterns.xmlUri) != -1) {
            contentType = handler.contentType.xml;
          } else if (requestUri.indexOf(handler.patterns.jsonUri) != -1) {
            contentType = handler.contentType.json;
          }

          return contentType;
        },
        // content template
        contentTemplate: function(e, options) {
          if (!e) return;

          return jQuery(e.target).attr(handler.attributes.contentTemplate);
        }
      },


      // evaluate
      evaluate: function(object, e, options, extra) {
        if (jQuery.isFunction(object)) {
          return object.call(this, e, options, extra);
        } else {
          return object;
        }
      },


      // controller
      controller: function(e, options) {
        // get request uri
        var requestUri
            = (options && options.requestUri)
                ? handler.evaluate(options.requestUri, e)
                : handler.evaluate(handler.get.requestUri, e, options);
        if (!requestUri) return;

        // get request type
        var requestType
            = (options && options.requestType)
                ? handler.evaluate(options.requestType, e)
                : handler.evaluate(handler.get.requestType, e, options);
        if (!requestType)
          requestType = handler.requestType.synchronous;

        // get target
        var target
            = (options && options.target)
                ? handler.evaluate(options.target, e)
                : handler.evaluate(handler.get.target, e, options);
        if (!target)
          target = handler.target._self;

        // let decide
        if (requestType == handler.requestType.synchronous) {
          handler.process.synchronousRequest(e, options, requestUri, target);

          // handle handler callback
          // callback specified?
          if (handler.callback) {
            jQuery.each(handler.callback, function(name, callback) {
              callback(e, options);
            });
          }
        } else {
          var $target = jQuery(target);

          // get content type
          var contentType
              = (options && options.contentType)
                  ? handler.evaluate(options.contentType, e)
                  : handler.evaluate(handler.get.contentType, e, options, requestUri);

          // define callback
          var callback;

          if (!contentType) {
            callback
                = (options && options.onContent)
                    ? options.onContent
                    : handler.process.content;
          } else if (contentType == handler.contentType.xml) {
            callback
                = (options && (options.onXmlContent || options.onContent))
                    ? (options.onXmlContent ? options.onXmlContent : options.onContent)
                    : (handler.process.xmlContent ? handler.process.xmlContent : handler.process.content);
          } else if (contentType == handler.contentType.json) {
            callback
                = (options && (options.onJsonContent || options.onContent))
                    ? (options.onJsonContent ? options.onJsonContent : options.onContent)
                    : (handler.process.jsonContent ? handler.process.jsonContent : handler.process.content);
          } else {
            callback
                = (options && (options.onHtmlContent || options.onContent))
                    ? (options.onHtmlContent ? options.onHtmlContent : options.onContent)
                    : (handler.process.htmlContent ? handler.process.htmlContent : handler.process.content);
          }

          handler.process.asynchronousRequest(e, options, requestUri, $target, contentType, function(content, status, xhr) {
            // spring web-flow hack
            if (xhr && xhr.getResponseHeader('Spring-Redirect-URL')) {
              handler.generic(e, {requestUri: xhr.getResponseHeader('Spring-Redirect-URL')});
              return;
            }

            callback(e, options, $target, content);
			
			//Set the screen title on title bar of the browser 
			if($(content).find('.queryFormTitleText:first h1').text().length>0){
				$('.applicationTitle:first ').text($(content).find('.queryFormTitleText:first h1').text());
			}
			
            delete xenos$Handler.requests[$target.selector];
            if (typeof xenos$Application$plugin !== 'undefined')
              xenos$Application$plugin.onReady();
              //jQuery(document).ready(xenos$Application$plugin.onReady);
          });
        }
      },
      // other useful functions used by generic controller
      // which can be customized
      // processes
      process: {
        // request processing
        // process synchronous request
        synchronousRequest: function(e, options, requestUri, target) {
          window.open(requestUri, target);
        },
        // process asynchronous request
        asynchronousRequest: function(e, options, requestUri, $target, contentType, callback) {
          if (xenos$Handler.requests[$target.selector]) {
            xenos$Handler.requests[$target.selector].abort();
            delete xenos$Handler.requests[$target.selector];
          }
		  var menuPk = undefined;
		  if(options !== undefined && options.menuPk !== undefined) {
			menuPk = options.menuPk;
		  } else {
			 var $cache = $('div#footer>div#xenos-cache-container>span#cache');
			 menuPk = $cache.data('menuPk');
		  }          
          var _function = function() {        	
            var settings = {
              url: requestUri,
			  headers:{
				  'menuPk' : menuPk
              },
              dataType: contentType,
              error: handler.process.error,
              success: callback
            };

            // settings specified?
            if (handler.settings) {
              // impose specified settings
              settings = jQuery.extend({}, settings, handler.settings);
            }

            // data specified
            if (options && options.settings) {
              // impose specified settings
              settings = jQuery.extend({}, settings, options.settings);
            }

            // ajax
            var _functionI = function() {
              //If the options are not defined and if options are defined but the 'loaderIconRequired' is not defined 
              //then by default the loader icon will always be shown
              // if(!(options && options.loaderIconRequired === false)){
   				 $target.xenosloader({});
   			  // }
            	
              xenos$Handler.requests[$target.selector]
                  = (options && options.multipart)
                      ? xenos$Handler$multipart.ajax(e, options, settings)
                      : jQuery.ajax(settings);

              xenos$Handler.requests[$target.selector].always(function() {
                // handle handler callback
                // callback specified?
                if (handler.callback) {
                  jQuery.each(handler.callback, function(name, callback) {
                    callback(e, options);
                  });
                }
                //Remove the loader Icon from the target
                $target.find('.detail-loader').remove();
                
              });
			  
			  xenos$Handler.requests[$target.selector].done(function() {
                $target.disposePlugin();
              });
            };
            setTimeout(_functionI, 0);

            // dispose plugins
            //$target.disposePlugin();
          };

          // great saver
          xenos$Handler.save($target, _function, this);
        },

        // request processing error
        error: function(xhr, status, e) {
        	//Handle Session out then throw exception
        	var _session_flag = ((typeof xhr.responseText === 'string') && (xhr.responseText.indexOf('j_username') != -1)) ||  (xhr.status == 999);
			if(_session_flag) {	
				xenos.context.handleSessionOut(e, xhr, {sessionOutFlag: _session_flag});
				return false;
			}				
			if(xhr.status != 0 && xhr.status != 400 && xhr.status != 403 && xhr.status != 408 && xhr.status != 999 && !_session_flag) 
				xenos.postNotice(xenos.notice.type.error, xenos.i18n.message.network_error,true);
				return false;
        },

        // content processing
        // generic
        content: function(e, options, $target, content) {
          handler.process.htmlContent(e, options, $target, content);
        },

        // html
        htmlContent: function(e, options, $target, content) {
          // replace the content
          if (typeof content === 'string' && content.indexOf('j_username') == -1)
            $target.html(content);
        },
        // json
        jsonContent: function(e, options, $target, content) {
          // replace the content
          var contentTemplate
              = (options && options.contentTemplate)
                  ? handler.evaluate(options.contentTemplate, e)
                  : handler.evaluate(handler.get.contentTemplate, e);

          $target.html(jQuery.tmpl(contentTemplate, content));
        },
        // xml
        xmlContent: function(e, options, $target, content) {
          // no-op;
        }
      }
    };

    if (handler) {
      // use implementation
      handler = jQuery.extend(true, {}, defaultHandler, handler);
    } else {
      // use default
      handler = defaultHandler;
    }

    return handler;
  };


  // define xenos Handler default
  window.xenos$Handler$default = xenos$Handler$function();


  // trigger event
  jQuery(document).trigger('xenos-handler-default-prepared');
}
//
// xenos
//  - Application infrastructure
//

// no-op hooks
var xenos$onLoad$Array = [];
function xenos$onLoad() {
  console.log('no-op onLoad');
}

var xenos$onFocus$Array = [];
function xenos$onFocus() {
  console.log('no-op onFocus');
}

var xenos$onClick$Array = [];
function xenos$onClick() {
  console.log('no-op onClick');
}

var xenos$onError$Array = [];
function xenos$onError() {
  console.log('no-op onError');
}

var xenos$onReady$Array = [];
function xenos$onReady() {
  console.log('no-op onReady');
}


if (typeof xenos$Application$plugin === 'undefined') {

  // define xenos Application plugin
  window.xenos$Application$plugin = function() {
    // application plugin
    var plugin = {
      name: 'xenos$Application',
      event: {
        prefix: 'xenos$Application'
      },

      init: function() {
        // set the on error handler
        window.onerror = plugin.onError;


        // set jQuery document ready
        var $document = jQuery(document);

        /**/
        /**/

        // always on
        $document.ready(function() {
          // Write all your global level handler binding below
          // Default OnReady Handler bounded for #xenosErrormsgClose
          $('#xenosErrormsgClose').live("click", function() {
            $(this).parent().css('display', 'none');
          });
          // Default OnReady Handler bounded for .formTabErrorIco
          $('.formTabErrorIco').live('click', function() {
            $('.xenosErrormsg').css('display', 'block');
          });
        });

        /**/
        /**/

        $document.ready(plugin.onReady);
      },

      // functions
      onLoad: function() {
        if (typeof xenos$onLoad !== 'undefined') {
          xenos$onLoad.call(this);
          xenos$onLoad = function(){};
        }

        for (var index = 0, length = xenos$onLoad$Array.length; index < length; index++)
          xenos$onLoad$Array[index].call(this);
        xenos$onLoad$Array = [];
		
		//To disable Browser Back Button functionality while user is logged-in
		var function_ = function(){
			window.location.href += "1";
		};
		
		if(window.location.href.search(/\/(login.*|#)$/) ==-1){
			window.location.href += "#";
			setTimeout(function_, 50); 
		}

		var storedHash = window.location.hash;
		window.setInterval(function () {
			if (window.location.hash != storedHash) {
				 window.location.hash = storedHash;
			}
		}, 50);
      },
      onFocus: function() {
        if (typeof xenos$onFocus !== 'undefined') {
          xenos$onFocus.call(this);
          xenos$onFocus = function(){};
        }

        for (var index = 0, length = xenos$onFocus$Array.length; index < length; index++)
          xenos$onFocus$Array[index].call(this);
        xenos$onFocus$Array = [];
      },
      onClick: function() {
        if (typeof xenos$onClick !== 'undefined') {
          xenos$onClick.call(this);
          xenos$onClick = function(){};
        }

        for (var index = 0, length = xenos$onClick$Array.length; index < length; index++)
          xenos$onClick$Array[index].call(this);
        xenos$onClick$Array = [];
      },

      onError: function(message, url, line) {
        if (typeof xenos$onError !== 'undefined') {
          xenos$onError.call(this, message, url, line);
          xenos$onError = function(){};
        }

        for (var index = 0, length = xenos$onError$Array.length; index < length; index++)
          xenos$onError$Array[index].call(this, message, url, line);
        xenos$onError$Array = [];

        // let growl to growl
        xenos.postNotice(xenos.notice.type.error, message + ' at ' + url + ':' + line);
        return false;
      },

      onReady: function() {
        if (typeof xenos$onReady !== 'undefined') {
          xenos$onReady.call(this);
          xenos$onReady = function(){};
        }

        for (var index = 0, length = xenos$onReady$Array.length; index < length; index++)
          xenos$onReady$Array[index].call(this);
        xenos$onReady$Array = [];
      }
    };


    // return
    return plugin;
  }();


  // load the plugin
  xenos.loadPlugin(xenos$Application$plugin);


  // trigger event
  jQuery(document).trigger('xenos-application-prepared');
}
