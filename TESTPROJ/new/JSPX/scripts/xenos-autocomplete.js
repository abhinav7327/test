//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
$.fn.xenosautocomplete = function(op){
	
	var iac = $.fn.xenosautocomplete;
	return this.each(function() {
		var this_ = $(this);
		var options = $.extend({},iac.defaults,op);
		
		if($.isFunction(options.requestContext)){
			options.requestContext = options.requestContext(this_);
		}
		this_.autocomplete({
				source: function( request, response ) {
					if (options.searchType == 'any') options.requestContext.any = request.term;
					if(options.searchType == 'prefix') options.requestContext.prefix = request.term;
					$.ajax({
						url: xenos.context.path + '/secure/ref/autocomplete/getdata.json',
						type: "POST",
						dataType: "json",
						data: {
							requestContext: JSON.stringify(options.requestContext) 
						},
						success: function( data ) {
							if(data.value.success) {
								var autoCompleteObj = $.parseJSON(data.value.data);
								response( $.map( autoCompleteObj, function( item ) {
										return {
												label: item.label,
												value: item.value
											   }
								}));
							} else {
								options.showError.call(this,data.value.data);
							}
						}
					});
				},
				disabled: options.disabled,
				appendTo: options.appendTo,
				autoFocus: options.autoFocus,
				minLength: options.minLength,
				delay: options.delay,
				position: options.position,
				create: options.create,
				search: options.search,
				open: options.open,
				focus: options.focus,
				select: options.select,
				close: options.close,
				change: options.change
		}).data( "autocomplete" )._renderItem = function( ul, item ) {
						var displayLabel = doHighlightTreeData(this_.attr('value'),xenos.utils.escapeHtml(item.label));
								return $( "<li></li>" )
								.data( "item.autocomplete", item )
								.append( "<a>" + displayLabel + "</a>" )
								.appendTo( ul );
		};
	})
};
var iac = $.fn.xenosautocomplete;
iac.defaults = {
	requestContext:  {},
	searchType: 'any',
	disabled: false,
	appendTo: $('body'),
	autoFocus: false,
	delay: 300,
	minLength: 1,
	position: {my: "left top",
			   at: "left bottom",
			   collision: "none"},
	source: {},
	create: function(){},
	search: function(){},
	open: function(){},
	focus: function(){},
	select: function(){},
	close: function(){},
	change: function(){},
	showError: function(err){
		xenos.postNotice(xenos.notice.type.error, err);
	}
};



