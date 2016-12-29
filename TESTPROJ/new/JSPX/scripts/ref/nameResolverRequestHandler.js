//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
/**
 * A handler function for xenospopup tag. xenos$nameResolver$Request$Handler initiate a server call based on given parameters
 * and upon execution of given events. Before execution, a preResolve hook is called, if application developer
 * wants to perform any task before execution of server call, they can do it here, but they can not post pond
 * or stop server call. After execution is completed successfully, a postResolve hook is called, this hook is called
 * with the resolve name. In case server name is not resolved then unresolve hook will be called. Please note that
 * name of this hook totally depends on calling function. xenos$nameResolver$Request$Handler does not impose
 * any rules on the function name, it is fine as long is the given reference is a function.
 * 
 * There will be no server call for empty value as well as empty events. Events are bind using jQuery 'on' api,
 * hence any function that 'on' api takes can be pass on.
 * 
 * xenos$nameResolver$Request$Handler follow the principal of object chaining design. Hence you can use it as follows
 * 
 * new xenos$nameResolver$Request$Handler()
 * 	.target(ele)
 *  .result(res)
 *  .bindEvents('change') // any valid jQuery 'on' api parameter
 *  .urlEndpoint('/secure/ref/nameresolver')
 *  .preResolve(function(){
 *  		//you stuffs goes here...
 *  	})
 *  .init();
 *  
 *  Without init(), xenos$nameResolver$Request$Handler will not act.
 */
(function($){
	
	var xenos$Handler$RequestHandler = xenos$Handler$function({
		get: {
			contentType: 'json',
			requestType: xenos$Handler$default.requestType.asynchronous
		},	
		settings: {
				beforeSend: function(request) {
					request.setRequestHeader('Accept', 'application/json');
					request.setRequestHeader('Content-Type', 'application/json');
			},
				type: 'POST'
			}
		});
	xenos$nameResolver$Request$Handler = function() {
    this.targetElement = undefined;
    this.resultElement = undefined;
    this.events = '';
    this.endpoint = '';
    this.xenos$nameResolver$preResolve = function(e) {}; //default is no-op function
    this.xenos$nameResolver$postResolve = function(e, resolvedName) {}; //default is no-op function
    this.xenos$nameResolver$unresolve = function(e){}; //default is no-op function
  };
  /*
   * Every function returns the current object to support object chaining
   */
  xenos$nameResolver$Request$Handler.prototype.target = function(element) {
    this.targetElement = element;
    return this;
  };
  
  xenos$nameResolver$Request$Handler.prototype.result = function(element) {
    this.resultElement = element;
    return this;
  };
  xenos$nameResolver$Request$Handler.prototype.bindEvents = function(events) {
    this.events = events;
    return this;
  };
  xenos$nameResolver$Request$Handler.prototype.urlEndpoint = function(endpoint) {
    this.endpoint = endpoint;
    return this;
  };
  xenos$nameResolver$Request$Handler.prototype.preResolve = function(preResolve) {
    this.xenos$nameResolver$preResolve = preResolve;
    return this;
  };
  xenos$nameResolver$Request$Handler.prototype.postResolve = function(postResolve) {
    this.xenos$nameResolver$postResolve = postResolve;
    return this;
  };
  xenos$nameResolver$Request$Handler.prototype.unresolve = function(unresolve) {
    this.xenos$nameResolver$unresolve = unresolve;
    return this;
  };
  xenos$nameResolver$Request$Handler.prototype.init = function() {
    var self = this;
    var resolvedName = '';
    if ( $.trim( self.events )  === '' ) {
	      return; //no processing for empty events
	    }
    function fetchData(e) {
      var value = self.targetElement.val().toUpperCase();
      self.resultElement.html(''); //we should remove the existing resolved name before going for next
      self.resultElement.attr(''); //we should remove the existing title before going for next
      if ($.trim(value) === '' )
             return; //no processing for empty value
      var obj = {"code": value};
      var requestUrl = xenos.context.path + "/" + self.endpoint;
      //pre resolver hook
      if ( typeof self.xenos$nameResolver$preResolve === 'function' ) {
        self.xenos$nameResolver$preResolve(e);
      }
      xenos$Handler$RequestHandler.generic(e, {	
    	  requestUri: requestUrl,
	      settings: {data : JSON.stringify(obj)},
	      onJsonContent :  function(e, options, $target, content) {
	
	        if(content.modelMap.success === true) {
	          resolvedName = content.modelMap.value[0].resolvedName;
	          self.resultElement.html(resolvedName);
	          self.resultElement.attr('title', resolvedName);
	          //post resolver hook
	          if ( typeof self.xenos$nameResolver$postResolve === 'function' ) {
	            self.xenos$nameResolver$postResolve(e, resolvedName);
	          }
	        } else {
	          //unsolved hook
	          if ( typeof self.xenos$nameResolver$unresolve === 'function' ) {
	            self.xenos$nameResolver$unresolve(e);
	          }
	        } 
	      }
     });
    }
    //this call is required to resolve name while user is clicking on Query tab from Result tab. Intended to support 'Back' and 'Amend' operation.
    fetchData({preventDefault: function() {}});
    self.targetElement.on(self.events, function(e) {
      fetchData(e);
	});
    return this;
  };
})(jQuery);