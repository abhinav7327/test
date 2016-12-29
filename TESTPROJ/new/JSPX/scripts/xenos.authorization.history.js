//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
(function ($) {
    $.fn.loadAuthorizationHistory = function (option) {
		return this.each( function() {
			  var self = this;
			  // options
			  // default
			  this.defaultOptions = {
				
			  };

			  // apply
			  jQuery.extend(true, this.defaultOptions, option);
			
			  // communication
			  // handler
			  this.handler = xenos$Handler$function({
				get: {
				  requestUri: function(e, options) {
					  var uri  = self.defaultOptions.uri + 'authHistory';
					  var param = self.defaultOptions.param;
					  var extraQueryString = "";
					  if($.trim(self.defaultOptions.entityType) == 'TXN'){
						  uri += "/" + param['txnPk'] + "/" + param['actionType'] + "/" + param['txnTableName'];
					  } else {
						  uri += "/" + param['authPk'];
					  }
					  
					  if($.isFunction(option.queryString)){
						  extraQueryString = option.queryString();
					  }
					  
					  return xenos.context.path + uri + '.json?' + $.trim(extraQueryString);
				  },
				  requestType: xenos$Handler$default.requestType.asynchronous,
				  target: function(e) {
					return $(self);
				  }
				},
				settings: {
				  beforeSend: function(request) {
					request.setRequestHeader('Accept', 'application/json;type=ajax');
				  },
				  type: 'POST'
				}
			  });
			if(typeof self.defaultOptions.uri != 'undefined' && self.defaultOptions.param){
				// communication
				self.handler.generic(undefined, {
				  contentType:xenos$Handler$default.contentType.json,
				  onJsonContent: function(e, options, $target, content) {
						var result=content.modelMap.authHistory;
						if($.isArray(result) && result.length > 0){
							$(self).find('table.reportTbl').find("tr:gt(0)").remove();
							var cached = xenos$Cache.get('globalPrefs');
							var evenRowColor = cached.zebraColorEven ? cached.zebraColorEven : '#F9F9F9';
							var oddRowColor = cached.zebraColorOdd ? cached.zebraColorOdd : '#E5E9ED';
							for( var index in  result) {
									$(self).find('table.reportTbl').append('<tr class="'+(index%2==0? 'evenRow' : 'oddRow')+'">'
																						+'<td>' +result[index].action              +'</td>'
																						+'<td>' +result[index].actionBy            +'</td>'
																						+'<td>' +result[index].actionDateDisp      +'</td>'
																						+'<td>' +result[index].authorizedBy        +'</td>'
																						+'<td>' +result[index].authorizedDateDisp  +'</td>'
																						+'<td>' +result[index].authStatus          +'</td>'
																						+'</tr>');
							}
							$(self).find('table.reportTbl').find('tr.evenRow').css('background-color',evenRowColor);
							$(self).find('table.reportTbl').find('tr.oddRow').css('background-color',oddRowColor);
							
							$(self).show('slow');
						}
				  }
				});
			}  
        });
	} 
}(jQuery));