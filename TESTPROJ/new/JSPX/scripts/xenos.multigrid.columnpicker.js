//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
(function($) {
	function SlickMultiGridColumnPicker(columns,grid,options)
	{
		var $menu;
        
		var defaults = {
			fadeSpeed: 250,
			context: grid.context
		};

        // If it is a multi-query page get the grid id
        var gridId = grid.getOptions().gridId;

		function init() {
            if(options.isPopUpQuery === undefined){	
                //grid.onHeaderContextMenu.subscribe(handleHeaderContextMenu);
                $(".pagerWrap .queryColumns").filter('.gridId-' + gridId).on('click',handleHeaderContextMenu); 
                
                $('html').click(function(e,t) {
                    if($(e.target).closest('.slick-columnpicker').size()>0){
                        return;
                    }else{
                        $menu.fadeOut(options.fadeSpeed);
                    }
                 });
                options = $.extend({}, defaults, options);
                
                $menu = $("<ul class='slick-columnpicker' id='slick-columnpicker-"+gridId+"' style='display:none;position:absolute;z-index:100000;' />", grid.context).appendTo(document.body);

                //$menu.bind("mouseleave", function(e) { $(this).fadeOut(options.fadeSpeed) });
                $menu.bind("click",updateColumn);

            }
		}
        
        
		function handleHeaderContextMenu(e, args)
		{
			e.stopPropagation();
			
			e.preventDefault();
			$menu.empty();

			var $li, $input;
			for (var i=0; i<columns.length; i++) {
				$li = $("<li />").appendTo($menu);

				$input = $("<input type='checkbox' />")
                        .attr("id", "columnpicker_" + i)
                        .data("id", columns[i].id)
                        .appendTo($li);

                if (grid.getColumnIndex(columns[i].id) != null)
                    $input.attr("checked","checked");
				
				$("<label for='columnpicker_" + i + "' />")
					.html(columns[i].name)
					.appendTo($li);
					
				//empty or undefined
				var enterpriseVal=grid.enterprisePrefVal;
				if(grid.enterprisePrefVal == undefined){
				
				} else if((jQuery.inArray(columns[i].id,enterpriseVal)) == -1){
				   $li.css('display','none');				  
				} 
				
				//First position is set for consolidate screen so it should not be disabled
				if((columns[i].hasOwnProperty('excludeFromColumnPicker') && columns[i]['excludeFromColumnPicker']=== true) || ($.trim(columns[i].name)=="")){
					$li.css('display','none');
				}
			}
			$("<div class='hrBorder'></div>").appendTo($menu);


			$li = $('<li id="autoresize-par-'+gridId+'"></li>').data('gridId', gridId).appendTo($menu);

			$input = $("<input type='checkbox' id='autoresize-"+gridId+"' />").data('gridId', gridId).appendTo($li);			
			
			$("<label for='autoresize'>Force Fit Columns</label>").appendTo($li);
			if (grid.getOptions().forceFitColumns)
				$input.attr("checked", "checked");



			$li = $('<li id="syncresize-par-'+gridId+'"></li>').data('gridId', gridId).appendTo($menu);
			
			$input = $("<input type='checkbox' id='syncresize-"+gridId+"' />").data('gridId', gridId).appendTo($li);
			
			$("<label for='syncresize'>Synchronous Resizing</label>").appendTo($li);
			if (grid.getOptions().syncColumnCellResize)
				$input.attr("checked", "checked");


			
			if($menu.is(':visible')){
				$menu.fadeOut(options.fadeSpeed);
			}else{

                var btnPos = $('.queryColumns').filter('.gridId-'+gridId).offset(); 

				var left = btnPos.left-$('.slick-columnpicker').last().width()+7;                
                
                var btnht = $('.queryColumns').filter('.gridId-'+gridId).height();                
                
                var columnPickerHeight = $('.slick-columnpicker').height();

                var footerTop = $('#footer').offset().top;
                if(columnPickerHeight+btnPos.top > footerTop){
                    $menu
                        .css("top", $('#wrapper').height()-columnPickerHeight)
                        .css("left",left-17)
                        .fadeIn(options.fadeSpeed);
                }else{
                    $menu
                        .css("top", btnPos.top + btnht)
                        .css("left",left)
                        .fadeIn(options.fadeSpeed);
                }
			}
		}

		function updateColumn(e)            
		{
			if (e.target.id == 'autoresize-'+gridId) {
				if (e.target.checked) {
					grid.setOptions({forceFitColumns: true});
					grid.autosizeColumns();
				} else {
					grid.setOptions({forceFitColumns: false});
				}
				return;
			}

			if (e.target.id == 'syncresize-'+gridId) {
				if (e.target.checked) {
					grid.setOptions({syncColumnCellResize: true});
				} else {
					grid.setOptions({syncColumnCellResize: false});
				}
				return;
			}

			if ($(e.target).is(":checkbox")) {
				if ($menu.find(":checkbox:checked").length == 0) {
					$(e.target).attr("checked","checked");
					return;
				}
                var visibleColumns = [];
                $menu.find(":checkbox[id^=columnpicker]").each(function(i,e) {
                    if ($(this).is(":checked")) {
                        visibleColumns.push(columns[i]);
                    }
                });
                grid.setColumns(visibleColumns);
			}
		}


		init();
	}
	// Slick.Controls.ColumnPicker
	$.extend(true, window, { Slick: { Controls: { MultiGridColumnPicker: SlickMultiGridColumnPicker }}});
})(jQuery);
