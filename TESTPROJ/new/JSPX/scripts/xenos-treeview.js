//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
// UI library should use their own object to encapsulate variables
// so that its' functions are able to see those variables
// otherwise it needs to use global variables or pass parameters to each functions if required
// it's strictly contradictory to OO design

$.fn.treeview = function(options){
    var $cache = $('div#footer>div#xenos-cache-container>span#cache'),
	    tree_content = options.content,
        tree_contentName = options.contentName,
	    type = options.type,
	    isPopUp = options.isPopUp,
        dataCheckInterval,
		dataTimeOut,
        me = this,
        generateTreeView = function(){
			//whether parent can be selected or not
            //default parent selection is ON
            var parentSelection = typeof options.parentSelection == 'undefined' ? true : false;

            var focus_handler = function(menu_div,type){
                menu_div.append('<div id="headerwrapper"><div id="treeviewheader"></div><div id="treeviewlastheader"><label id="lastheader"></label></div></div>').append('<div id="treeviewcontentwrapper"><div id="treeviewcontent"></div></div>');
                $wrapper = $('#treeviewcontentwrapper');
                $scroller = $('#treeviewcontentwrapper > #treeviewcontent');
                $tree_view_header = $('#treeviewheader');
                create_menu(tree_content,menu_div, type, parentSelection);
				$('#treeviewcontentwrapper').jScrollPane();
                $('#treeviewcontentwrapper').mousemove(function(e){
                    var content_div = $(this);
                    //scroll_div(e.pageY,$(this),$(this).children('#treeviewcontent'));
                });
            };
            var focus_out_handler = function(){
                $selecteddiv = null;
                notyet = false;
                $('#treeviewdiv').remove();
            };
            var key_up_handler = function(){
                if($selecteddiv) {
                    var $prevSelected = $selecteddiv.prevAll(':visible').first();
                    if($prevSelected.length > 0){
                        $selecteddiv.children().first().removeClass("focuson");
                        $selecteddiv = $prevSelected;
                        $selecteddiv.children().first().addClass("focuson");
                        scroll_to($selecteddiv);
                    }
                }

            };
            var key_down_handler = function(){
                if (!$selecteddiv) {
                    $selecteddiv = $('#treeviewcontentelement0');
                    $selecteddiv.children().first().addClass("focuson");
                } else {
                    var $nextSelected = $selecteddiv.nextAll(':visible').first();
                    if($nextSelected.length > 0)	{
                        $selecteddiv.children().first().removeClass("focuson");
                        $selecteddiv = $nextSelected;
                        $selecteddiv.children().first().addClass("focuson");
                        scroll_to($selecteddiv);
                    }
                }

            };
            var key_left_handler = function(){
                if($selecteddiv){
                    if($selecteddiv.attr('tree-depth') > 0) {
                        var depth = $selecteddiv.attr("tree-depth");
                        var curr_level = $selecteddiv.attr("tree-level");
                        var level = '';
                        var curr_level_arr = curr_level.split('-');
                        curr_level_arr.splice(curr_level_arr.length-2,2)
                        if(curr_level_arr.length > 0) level = curr_level_arr.join('-');
                        var target_depth = parseInt(depth)-1;
                        slide(999,level,target_depth,null);
                    }
                }

            };
            var key_right_handler = function(){
                if($selecteddiv) {
                    if($selecteddiv.find('span.navigationicon').size() > 0) {
                        var depth = $selecteddiv.attr("tree-depth");
                        var level = $selecteddiv.attr("tree-level");
                        var target_depth = parseInt(depth)+1;
                        var curr_data = $selecteddiv.data('node_data');
                        slide(depth,level,target_depth,curr_data);
                    }
                }

            };

            var key_enter_handler = function(){
                if($('#treeviewdiv').length > 0) {
                    if($selecteddiv) {
                        var this_node_data = $selecteddiv.data('node_data');
                        $textbox.attr('value',this_node_data.value);
						$textbox.trigger('blur').trigger('change');
                        destroy_menu();
                    }
                }
            };

            var key_escape_handler = function() {
                destroy_menu();
            };

            var typeahead = function(event,this_){
                countdown_reset();
            };

            return me.each(function() {

                //Creating a reference to the object
                var this_ = $(this);
                this_.focus(function(){
                    // initiates the process
                    notyet = false;

                    if($('div #treeviewdiv').length > 0){
                        if(this_.attr('id') != $('div #treeviewdiv').attr('viewtype')){
                            $selecteddiv = null;
                            notyet = false;
                            $('#treeviewdiv').remove();
                        }
                    }
                    if($('div #treeviewdiv').length == 0) {
                        this_.after('<div id="treeviewdiv" viewtype='+ this_.attr('id') +' style="position:absolute;"/>');
                        if(isPopUp===undefined){
                            $('#treeviewdiv').css('left',this_.parent().prev('label').width() + 1 +'px')
                                .css('top', this_.parent().parent().height() - 2 +'px')
                                .show()
                                .animate({height:"220px"},500);
                        }else{
                            var wd = this_.closest('label').width();
                            var ht = this_.closest('label').height();
                            $('#treeviewdiv')
                                .css({'left': wd, 'top':ht})
                                .show()
                                .animate({height:"220px"},500);
                        }
                        $textbox = this_;
                        focus_handler($('#treeviewdiv'),type);
                        if ($textbox[0].value != '') countdown_init();
                    }
                });

                this_.focusout(function(event){
                    if(!notyet) {
                        focus_out_handler();
                    }
                });

                this_.keydown(function(event){
                    if(event.keyCode == 13 || event.keyCode == 220) {
                        event.stopPropagation();
                        event.preventDefault();
                    }
                });

                this_.keyup(function(event){
                    switch (event.keyCode){
                        case 37:
                            key_left_handler();
                            break;
                        case 38:
                            key_up_handler();
                            break;
                        case 39:
                            key_right_handler();
                            break;
                        case 40:
                            key_down_handler();
                            break;
                        case 13:
                            key_enter_handler();
                            break;
                        case 27:
                            key_escape_handler();
                            break;
                        case 16:
                            break;
                        case 36:
                            break;
                        case 35:
                            break;
                        default:
                            typeahead(event,this_);
                    }
                });
            });
        };


    if($cache.data(tree_contentName)){
        tree_content = $cache.data(tree_contentName);
        generateTreeView();
    }else{
        dataCheckInterval = setInterval(function(){
			$cache = $('div#footer>div#xenos-cache-container>span#cache');
            if($cache.data(tree_contentName)){
                tree_content = $cache.data(tree_contentName);
                generateTreeView();
                clearInterval(dataCheckInterval);
                clearTimeout(dataTimeOut);
            }
        },500);

        //Wait for data for 10secs and then stop waiting.
        dataTimeOut = setTimeout(function(){
			clearInterval(dataCheckInterval);
        },10000);
    }
};


// below variables are decalred as globals
// in case of multiple tree view in a single page variables may be shared across
// so to make it proper work, it needs to use an object where each tree view will have their own encapsulated variables

var notyet = false;
var $selecteddiv;
var $textbox;
var $scroller;
var $wrapper;
var $tree_view_header;

/* implementing auto-complete delay */

var countdown;
var countdown_number;

function countdown_init(delay) {
    countdown_number = delay ? delay : 2; /* no of seconds to wait*/
    countdown_trigger();
}

function countdown_trigger() {
    if(countdown_number > 0) {
        countdown_number--;
        if(countdown_number > 0) {
            countdown = setTimeout('countdown_trigger()', 1000);
        } else {
			typeaheadcall();/* call auto complete function*/
		}
    }
}

function countdown_clear() {
    clearTimeout(countdown);
}

function countdown_reset(delay) {
    clearTimeout(countdown);
	countdown_init(delay);
}

function typeaheadcall(){
		if($selecteddiv) {
			$selecteddiv.children().first().removeClass('focuson');
			if ($selecteddiv.attr('tree-depth') != 0) {
				var $hwrapper = $('div #headerwrapper');
				var old_height = $hwrapper.height();
				$('#treeviewcontent > div.treeviewcontentelement').css('display','none');
				$('#lastheader').text('').attr('depth','').attr('level','');
				$tree_view_header.children().first().nextAll().remove();
				$('#treeviewcontent > div.treeviewcontentelement[tree-depth=0]').css('display','block');
				var new_height = $hwrapper.height();
				$('div#treeviewdiv').height($('div#treeviewdiv').height() + (new_height-old_height));
				
			} 
		}
		var regexp_special_chars = new RegExp('[.\\\\+*?\\[\\^\\]$(){}=!<>|:]', 'g');
		function regexp_escape(value) {
			return value.replace(regexp_special_chars, '\\$&');
		}
		
		var match = $textbox[0].value;
		if(match != '') {
		console.log(regexp_escape(match));
			var regEx = new RegExp('^'+regexp_escape(match),'i');
			$('#treeviewcontent > div.treeviewcontentelement').each(function(){
				$div = $(this);
				if($div.data('node_data').label.match(regEx)) {
					slide_to($div);
					return false;
				}
			});
		}
		
}

	
function slide_to($div){
	var target_level = $div.attr('tree-level');
	var target_level_arr = target_level.split('-');
	var curr_level = '';
	if(target_level_arr.length == 1){
		$selecteddiv = $div;
		$selecteddiv.children().first().addClass('focuson');
		scroll_to($selecteddiv);
	} else {
		for(var i=0; i<target_level_arr.length; i++){
			curr_level = curr_level == '' ? target_level_arr[i] : curr_level + '-' + target_level_arr[i];
			$selecteddiv = $('#treeviewcontent > div.treeviewcontentelement[tree-level = '+ curr_level +']');
			$selecteddiv.children().first().addClass('focuson');
			var depth = $selecteddiv.attr("tree-depth");
			var target_depth = parseInt(depth)+1;
			var curr_data = $selecteddiv.data('node_data');
			if (depth < target_level_arr.length - 1) {
				$selecteddiv.children().first().removeClass("focuson");
				slide(depth,curr_level,target_depth,curr_data,target_level,5)
			} else {
				scroll_to($selecteddiv);
			}
		}
	}
}

function scroll_to($div){
	var wrapper_height = $wrapper.height();
	var scrallable_height = $scroller.outerHeight();
	var scroll = $wrapper.offset().top + 
								$div.prevAll(':visible').length*$div.height()*wrapper_height*(0.95)/scrallable_height;
	if ($div.nextAll(':visible').length == 0) scroll = scroll + 5;
	if ($div.prevAll(':visible').length == 0) scroll = scroll - 5;
	scroll_div(scroll,$wrapper,$scroller);
}

function scroll_div(_y,$wrapper, $scrollable){
	var wrapperHeight = $wrapper.height()*(0.7); /* defining 70% of the wrapper as hotspot*/
	// Using outer height to include padding too
	var scrollableHeight = $scrollable.outerHeight();
	var hopspot_top = $wrapper.offset().top + wrapperHeight*(0.2); /* top of the hotspot*/
    // Scroll menu
	var top = (_y -  hopspot_top) * (scrollableHeight - wrapperHeight) / wrapperHeight;
	
    if (top < 0){
      top = 0;
    }
	$wrapper.scrollTop(top);
}

function blink($icon){
	$icon.delay(100).fadeTo(100,0.5).delay(100).fadeTo(100,1,function(){
		if($(this).data('blink')) blink($(this));
	});
}

function create_menu(tree_content,menu_div,type, parentSelection) {
	$tree_view_header.append('<label id="root" depth=0 class="headerlabel level0Header">'+type.toUpperCase()+'</label>');
	$tree_view_header.find('#root').mousedown(function(e){
		notyet = true;
		slide(999,'',0,null);
	}).mouseup(function(e){$textbox.focus();});
	var tree_view_content = menu_div.find('#treeviewcontent');
	for(var i=0; i<tree_content.length; i++){
		node_content = tree_content[i];
		tree_view_content.append('<div id="treeviewcontentelement' + i +'" class="treeviewcontentelement" tree-depth=0 tree-level=' + i + '></div>');
		var node_data = {};
		node_data.label = node_content.text;
		node_data.value = node_content.value;
		$('#treeviewcontentelement'+i).data('node_data',node_data)
									  .append('<a class="treeviewanchor">'+node_content.text+ '</a>');
		$('#treeviewcontentelement'+i+' > a.treeviewanchor').hover(function(){
			if($selecteddiv) {
				$selecteddiv.children().first().removeClass('focuson');
			}
			$selecteddiv = $(this).parent();
			$selecteddiv.children().first().addClass('focuson');
		});
		var isParent = node_content.children;
		$('#treeviewcontentelement'+i+' a.treeviewanchor').mousedown((function() {
			var _parent = isParent;
			
			// closure to get individual copy of isParent value
			return function() {
				//parent selection is ON || (selection is OFF && it's leaf node)
				if(parentSelection || !_parent) {
					//drop the value
					var this_node_data = $selecteddiv.data('node_data');
					$textbox.val(this_node_data.value);
					$textbox.trigger('blur').trigger('change');
					destroy_menu();
				} else {
					// if in case parent selection on root level zero
					// then focus out handler does not destroy the menu
					notyet = true;
				}
			};
		})());
		if(isParent){
			$('#treeviewcontentelement'+i).append('<div style="display:inline;"><span class="navigationicon"></span></div>');
			$('#treeviewcontentelement'+i+' > div').mouseenter( function() {
        if($selecteddiv) {
          $selecteddiv.children().first().removeClass('focuson');
        }
        $(this).addClass('focuson');
			}).mouseleave(function() {
            $(this).removeClass('focuson');
			}).mousedown(function(e){
				var parent = $(this).parent();
                $selecteddiv = $selecteddiv?$selecteddiv:parent;
				notyet = true;
				var depth = parent.attr("tree-depth");
				var level = parent.attr("tree-level");
				var target_depth = parseInt(depth)+1;
				var curr_data = parent.data('node_data');
				slide(depth,level,target_depth,curr_data);
			}).mouseup(function(e){$textbox.focus();});
			
			create_sub_menu(node_content.children,tree_view_content,i, parentSelection);
		}
	}
}

function create_sub_menu(node_content,tree_view_content,prev_level, parentSelection){
	for(var i=0; i<node_content.length; i++){
		var curr_level = prev_level + '-' + i;
		var curr_depth = curr_level.split('-').length - 1;
		child_node = node_content[i];
		tree_view_content.append('<div style="display:none;" id="treeviewcontentelement' + curr_level +'" class="treeviewcontentelement" tree-depth=' + curr_depth + ' tree-level=' + curr_level + ' ></div>');
		var node_data = {};
		node_data.label = child_node.text;
		node_data.value = child_node.value;
		$('#treeviewcontentelement'+curr_level).data('node_data',node_data)
											   .append('<a class="treeviewanchor">'+child_node.text+ '</a>');
		$('#treeviewcontentelement'+curr_level+' > a.treeviewanchor').hover(function(){
			if($selecteddiv) {
				$selecteddiv.children().first().removeClass('focuson');
			}
			$selecteddiv = $(this).parent();
			$selecteddiv.children().first().addClass('focuson');
		});
		var isParent = child_node.children;
		$('#treeviewcontentelement'+curr_level+' a.treeviewanchor').mousedown((function() {
			var _parent = isParent;
			return function() {
				//parent selection is ON || (selection is OFF && it's leaf node)
				if(parentSelection || !_parent) {
					//drop the value
					var this_node_data = $selecteddiv.data('node_data');
					$textbox.attr('value',this_node_data.value);
					$textbox.trigger('blur').trigger('change');
					destroy_menu();
				}
			};
		})());
		if(isParent){
			$('#treeviewcontentelement'+curr_level).append('<div style="display:inline;"><span class="navigationicon"></span></div>');
			$('#treeviewcontentelement'+curr_level+' > div').mouseenter( function() {
        if($selecteddiv) {
          $selecteddiv.children().first().removeClass('focuson');
        }
        $(this).addClass('focuson');
			}).mouseleave(function() {
            $(this).removeClass('focuson');
			}).mousedown(function(e){
				var parent = $(this).parent();
				notyet = true;
				var depth = parent.attr("tree-depth");
				var level = parent.attr("tree-level");
				var target_depth = parseInt(depth)+1;
				var curr_data = parent.data('node_data');
				slide(depth,level,target_depth,curr_data);
			}).mouseup(function(e){$textbox.focus();});
			create_sub_menu(child_node.children,tree_view_content,curr_level, parentSelection);
		}
	}
}

function slide(current_depth, 
			   current_level,
			   target_depth,
			   current_data,
			   target_level,
			   animate_time){
	var $hwrapper = $('div #headerwrapper');
	var new_header_height;
	var search_level = current_level;
	var is_back_slide = false;
	var return_level = 0;
	var $lastheader = $('#lastheader');
	$('div #treeviewcontent').animate({opacity:0},animate_time?animate_time:20,function(){
		var old_header_height = $hwrapper.height();
		if(parseInt(target_depth) > parseInt(current_depth)) {
			if($lastheader.text() != ''){
				$tree_view_header.append('<label id=' + $lastheader.attr('headerlabelid') + '" class="headerlabel" depth='+ $lastheader.attr('depth') +' level='+  $lastheader.attr('level') +'>'+$lastheader.text()+'</label>');
			}
			$tree_view_header.append('<span class="arrow"/>');
			$lastheader.attr('depth',target_depth)
					   .attr('level',current_level)
				       .text(current_data.label);
			$tree_view_header.find('label.headerlabel').last().not('[depth=0]').mousedown(function(e){
				notyet = true;
				slide(999,$(this).attr('level'),$(this).attr('depth'),null);
			}).mouseup(function(e){$textbox.focus();});
			$('div.treeviewcontentelement[tree-depth='+ current_depth +']').css('display','none');
		} else {
			is_back_slide = true;
			// find the previous selected label
			var $return_level_holder = $lastheader;
			if($tree_view_header.find('label.headerlabel[depth='+ target_depth +']').nextAll('label.headerlabel').length > 0){
				$return_level_holder = $tree_view_header.find('label.headerlabel[depth='+ target_depth +']').nextAll('label.headerlabel').first();
			} 
			return_level = $return_level_holder.attr('level');
			
			$tree_view_header.find('label.headerlabel[depth='+ target_depth +']').nextAll().unbind('mousedown').remove();
			var $lastlabel = $tree_view_header.find('label.headerlabel').last().not('[depth=0]');
			if($lastlabel.length > 0){
				$lastheader.attr('depth',$lastlabel.attr('depth'))
						   .attr('level',$lastlabel.attr('level'))
						   .text($lastlabel.text());
				$lastlabel.unbind('mousedown').remove();
			} else {
				$lastheader.text('');
			}
			$('div.treeviewcontentelement').css('display','none');
		}
		if(target_depth != 0) search_level = current_level + '-';
		$('div.treeviewcontentelement[tree-depth=' + target_depth + ']').filter('[tree-level^='+ search_level +']').css('display','block');
		new_header_height = $hwrapper.height();
		diff = new_header_height-old_header_height;
		if(diff != 0){
			$('div#treeviewdiv').height($('div#treeviewdiv').height() + diff);
		}
	});
	$('div #treeviewcontent').animate({opacity:1.0},animate_time?animate_time:20, function(){
		if($selecteddiv) {
			$selecteddiv.children().first().removeClass("focuson");
		}
		var wrapper_height = $wrapper.height();
		var scrallable_height = $scroller.outerHeight();
		if(!is_back_slide) {
			var scroll = $wrapper.offset().top + 5;
			if(target_level){
				$selecteddiv = $('div.treeviewcontentelement[tree-depth=' + target_depth + ']').filter('[tree-level='+ target_level +']');
				scroll = $wrapper.offset().top + 
							$selecteddiv.prevAll(':visible').length*$selecteddiv.height()*wrapper_height*(0.95)/scrallable_height;
				if($selecteddiv.nextAll(':visible').length == 0){
					scroll = scroll + 5;
				}
			} else {
				$selecteddiv = $('div.treeviewcontentelement[tree-depth=' + target_depth + ']').filter('[tree-level^='+ search_level +']').first();
			}
			$selecteddiv.children().first().addClass("focuson");
			scroll_div(scroll,$wrapper,$scroller);
			// jsscrollpane scrollbar
			$('#treeviewcontentwrapper').jScrollPane().data('jsp').reinitialise();
			
		} else {
			if(!return_level) return_level = 0;
			$selecteddiv = $('div.treeviewcontentelement[tree-depth=' + target_depth + ']').filter('[tree-level='+ return_level +']');
			$selecteddiv.children().first().addClass("focuson");
			var scroll = $wrapper.offset().top + 
							$selecteddiv.prevAll(':visible').length*$selecteddiv.height()*wrapper_height*(0.95)/scrallable_height;
			if($selecteddiv.nextAll(':visible').length == 0){
					scroll = scroll + 5;
			}
			scroll_div(scroll,$wrapper,$scroller);
			notyet = false;
			// jsscrollpane scrollbar
			$('#treeviewcontentwrapper').jScrollPane().data('jsp').reinitialise();
		}
		
		
	});
}

function destroy_menu() {
	$selecteddiv = null;
	notyet = false;
	$('#treeviewdiv').remove();
}