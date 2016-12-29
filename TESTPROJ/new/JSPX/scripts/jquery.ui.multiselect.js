//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
/* jquery.ui.muliselect.js
 *
 * URL: http://corydorning.com/projects/multiselect
 *
 * @author: Cory Dorning
 * @modified: 02/27/2012
 *
 * Multiselect is a jQuery UI widget that transforms a <select>
 * box to provide a better User Experience when you need to select
 * multiple items, without the need to use the CTRL key.
 *
 * 
 * @TODO
 * 
 *
 */
;
(function($) {
  $.widget('ui.multiselect', {
    _version: 0.2,

    version: function() { return this._version; },
  
    // default options
    options: {
      change: function(){},
      deselect: function() {},
      label: '',
      minWidth: 200,
      maxWidth: null,
      scroll: 0,
      select: function() {}
    },

    items: [],

    _create: function() {
      var self = this,
          $select = self.element.hide(),
          items = self.items = $select.children('option').map(function(){
            return {
              label: $(this).text(),
              value: $(this).text(),
              option: this // this stores a reference of the option element it belongs to
            };
          }).get();

      var $input = self.input = $('<div class="ui-multiselect-input" />')
            .attr({
              // workaround to close menu on blur
              tabIndex: -1
            })
            .html('<span class="ui-multiselect-label" style="display: inline-block; margin: 3px 2px 2px 2px; padding: 1px;">' + self.options.label + '</span>')
            .insertAfter($select)
            .autocomplete({
              delay: 0,
			  appendTo: $select.parents('div.formItem'), //fix for iGV
              minLength: 0,
              source: function(req, resp) {
                var srcItems = [];

                $.each(items, function(i, o) {
                  if (!o.option.selected) {
                    srcItems.push(o);
                  }
                });
                resp(srcItems);
              },
              select: function(ev, ui) {
                $.each(items, function(i, o) {
                  if (ui.item.option === o.option) {
                    self.select(i);
                  }
                });
				//fix for iGV
				buttonNum = $('.ui-multiselect-item');
				btnLength = buttonNum.length;
				btnWidth = 0;
				 buttonNum.each(function(){
					btnWidth += $(this).width();
				 });
				if(btnWidth > 565){
					$('.ui-multiselect-input').append('<span class="multiSelMore">...</span>');
					$('.ui-multiselect-input').mouseover(function(){
					    if($(this).children('span').hasClass('multiSelMore')){
							$(this).addClass('multiSelHover');
						}else{
							$(this).removeClass('multiSelHover');
						}
					});
				}
				$('.ui-multiselect-input').mouseout(function(){
					if($(this).hasClass('multiSelHover')){
						$(this).removeClass('multiSelHover');
						$(this).parent().siblings('.ui-autocomplete').css('top',($(this).outerHeight()+2));
					}
					
				});
              }
            })
            .addClass('ui-widget ui-widget-content ui-corner-left')
            .css({
              display: 'inline-block',
              minWidth: self.options.minWidth,
              maxWidth: self.options.maxWidth || 'auto',
              padding: 1,
              verticalAlign: 'middle'
            })
            .click(function() {
              self.button.trigger('click');
            });

      self.button = $('<div>')
        .insertAfter($input)
        .button({
          icons: {
            primary: 'ui-icon-triangle-1-s'
          },
          text: false
        })
        .removeClass('ui-corner-all')
        .addClass('ui-corner-right')
        .css({
          height: $input.outerHeight(),
          verticalAlign: 'middle'
        })
        .click(function() {
          // close if already visible
          if ( $input.autocomplete('widget').is(':visible') ) {
            $input.autocomplete('close');
            return;
          }

          // work around a bug (likely same cause as #5265)
          $(this).blur();

          // pass empty string as value to search for, displaying all results
          $input.autocomplete('search', '');
          $input.focus();
        });

      if (self.options.scroll) {
        $('.ui-autocomplete').css({		  
          //maxHeight: self.options.scroll, //fix for iGV
          overflowY: 'auto',
          overflowX: 'hidden'		  
          //paddingRight: '20px' //fix for iGV
        })
      }
      
      $.each(items, function(i, o) {
        if (o.option.selected) {
          self.select(i);
        }
      });

    }, // _create

    destroy: function() {
      this.input.remove();
      this.button.remove();
      this.element.show();
      $.Widget.prototype.destroy.call( this );
    }, // destroy

    select: function(index) {
      var self = this,
          item = self.items[index];

      item.option.selected = true;
      $('<span class="ui-multiselect-item">' + item.label + '</span>')
        .button({
          icons: { secondary: 'ui-icon-close' }
        })
        .css({
          cursor: 'default',
          margin: 2
        })
        .children('.ui-button-text')
          .css({
            lineHeight: 'normal',
            paddingTop: 0,
            paddingBottom: 0,
            paddingLeft: '5px', //fix for iGV
			paddingRight: '15px' //fix for iGV
          })
		  .attr({title:item.label}) //add title for iGV
          .end()
        .children('.ui-icon-close')
          .css({
            cursor: 'pointer'
          })
          .click(function() {
			//fix for iGV
			buttonNum = $('.ui-multiselect-item');
			btnLength = buttonNum.length;
			btnWidth = -($(this).parent().width());
			buttonNum.each(function(){
				btnWidth += $(this).width();
			});
			if((btnWidth <= 565) && $(this).parent().parent().children().hasClass('multiSelMore')){
				$('.multiSelMore').remove();
				$(this).parent().parent().removeClass('multiSelHover');
			}
            $(this).parent().remove();
            self.deselect(item);
            return false;
          })
          .end()
        .appendTo(self.input);
        
        self.input.children('.ui-multiselect-label').hide();
        
        // call function on change
        self.options.change.call(item.option);
        
        // call function on select
        self.options.select.call(item.option);
    }, // select

    deselect: function(item) {
      var self = this;

      item.option.selected = false;

      if (!self.input.children('.ui-multiselect-item').length) {
        self.input.children('.ui-multiselect-label').show();
      }	  
      
      // call function on change
        self.options.change.call(item.option);
        
        // call function on deselect
        self.options.deselect.call(item.option);
    } // deselect

  }); // $.widget('multiselect')
})(jQuery);