//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
(function ($) {
  // register namespace
  $.extend(true, window, {
    "Slick": {
      "AutoTooltips": AutoTooltips
    }
  });


  function AutoTooltips(options) {
    var _grid;
    var _self = this;
    var _defaults = {
      maxToolTipLength: null
    };

    function init(grid) {
      options = $.extend(true, {}, _defaults, options);
      _grid = grid;
      _grid.onMouseEnter.subscribe(handleMouseEnter);
    }

    function destroy() {
      _grid.onMouseEnter.unsubscribe(handleMouseEnter);
    }

    function handleMouseEnter(e, args) {
      var cell = _grid.getCellFromEvent(e);
      if (cell) {
        var node = _grid.getCellNode(cell.row, cell.cell);
        if(node){
            if ($(node).innerWidth() <= node.scrollWidth) {
				//modification for detailed column tooltip showing
				var text = '';
				if(($('.detail-view-hyperlink.popupIconBtn',$(node))).length > 0 ){
					text = $.trim($('.detail-view-hyperlink.popupIconBtn',$(node)).attr('title'));
				}else{
					// If cell element is not a drop down
					if(!$('select',$(node)).length>0) {
						text = $.trim($(node).text());
					}else{
						// If cell element is a drop down then formatting texts
						var optionArray = $('select option',$(node));
						for(var i=0;i<optionArray.size();i++){
							if(i!=optionArray.size()-1 && optionArray[i].innerHTML != "")
								text = text + optionArray[i].innerHTML + ", ";
							else
								text = text + optionArray[i].innerHTML;
						}
					}
				}
                if (options.maxToolTipLength && text.length > options.maxToolTipLength) {
                    text = text.substr(0, options.maxToolTipLength - 3) + "...";
                }
                $(node).attr("title", text);
            } else {
                $(node).attr("title", "");
            }
        }
      }
    }

    $.extend(this, {
      "init": init,
      "destroy": destroy
    });
  }
})(jQuery);