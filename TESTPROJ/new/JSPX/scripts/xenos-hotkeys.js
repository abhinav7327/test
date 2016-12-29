//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
(function(jQuery){jQuery.hotkeys={version:"0.8",specialKeys:{8:"backspace",9:"tab",13:"return",16:"shift",17:"ctrl",18:"alt",19:"pause",20:"capslock",27:"esc",32:"space",33:"pageup",34:"pagedown",35:"end",36:"home",37:"left",38:"up",39:"right",40:"down",45:"insert",46:"del",96:"0",97:"1",98:"2",99:"3",100:"4",101:"5",102:"6",103:"7",104:"8",105:"9",106:"*",107:"+",109:"-",110:".",111:"/",112:"f1",113:"f2",114:"f3",115:"f4",116:"f5",117:"f6",118:"f7",119:"f8",120:"f9",121:"f10",122:"f11",123:"f12",144:"numlock",145:"scroll",191:"/",224:"meta"},shiftNums:{"`":"~","1":"!","2":"@","3":"#","4":"$","5":"%","6":"^","7":"&","8":"*","9":"(","0":")","-":"_","=":"+",";":": ","'":"\"",",":"<",".":">","/":"?","\\":"|"}};function keyHandler(handleObj){if(typeof handleObj.data!=="string"){return}var origHandler=handleObj.handler,keys=handleObj.data.toLowerCase().split(" ");handleObj.handler=function(event){if(this!==event.target&&(/textarea|select/i.test(event.target.nodeName)||event.target.type==="text"||event.target.type==="password")){return}var special=event.type!=="keypress"&&jQuery.hotkeys.specialKeys[event.which],character=String.fromCharCode(event.which).toLowerCase(),key,modif="",possible={};if(event.altKey&&special!=="alt"){modif+="alt+"}if(event.ctrlKey&&special!=="ctrl"){modif+="ctrl+"}if(event.metaKey&&!event.ctrlKey&&special!=="meta"){modif+="meta+"}if(event.shiftKey&&special!=="shift"){modif+="shift+"}if(special){possible[modif+special]=true}else{possible[modif+character]=true;possible[modif+jQuery.hotkeys.shiftNums[character]]=true;if(modif==="shift+"){possible[jQuery.hotkeys.shiftNums[character]]=true}}for(var i=0,l=keys.length;i<l;i++){if(possible[keys[i]]){return origHandler.apply(this,arguments)}}}}jQuery.each(["keydown","keyup","keypress"],function(){jQuery.event.special[this]={add:keyHandler}})})(jQuery);

function setTopMost(){
	$('.topMost').removeClass('topMost');
	var maxZ = 0;
	$.each($('.ui-dialog'),function(index,el){
		if($(el).css('z-index') > maxZ){
			maxZ = $(el).css('z-index');
			$('.topMost').removeClass('topMost');
			$(el).addClass('topMost');
		}
	});
}

//Check if menu tree is opened
function isMenuTreeOpen(evt) {
	return $(evt.target).parents('ul.sf-menu').length >0;
}

function isDialogOpen(){
	if($('.ui-dialog,#popup_container').size()>0 && $('.ui-dialog,#popup_container').is(":visible")){
		return true;
	}else{
		return false;
	}
}
//Handling Shortcuts for Right Key
jQuery(document).bind('keydown', 'Ctrl+right',function (evt){
	if($('#queryResultForm').size()>0){
		$('.next','#queryResultForm').trigger('click');
	}
	else if(isDialogOpen()){
		setTopMost();
		$('.next','.topMost').trigger('click');
	}else{
		$('.nextWorkspace').trigger('click');
	}
	return false;
});
//Handling Shortcuts for Left Key
jQuery(document).bind('keydown', 'Ctrl+left',function (evt){
	if($('#queryResultForm').size()>0){
		$('.prev','#queryResultForm').trigger('click');
	}
	else if(isDialogOpen()){
		setTopMost();
		$('.prev','.topMost').trigger('click');	
	}else{
		$('.previousWorkspace').trigger('click');
	}
	return false;
});
//Handling Shortcuts for Print
jQuery(document).bind('keydown', 'Shift+p',function (evt){
	if(isDialogOpen()){
		setTopMost();
		$('.printBtn','.topMost').trigger('click');	
	}else{
		$('.printBtn').trigger('click');
	}
	return false;
});
//Handling Shortcuts for Print PDF
jQuery(document).bind('keydown', 'Shift+d',function (evt){
	if(isDialogOpen()){
		setTopMost();
		$('.pdfBtn','.topMost').trigger('click');	
	}else{
		$('.pdfBtn').trigger('click');
	}
	return false;
});
//Handling Shortcuts for Print XLS
jQuery(document).bind('keydown', 'Shift+x',function (evt){
	if(isDialogOpen()){
		setTopMost();
		$('.excelBtn','.topMost').trigger('click');	
	}else{
		$('.excelBtn').trigger('click');
	}
	return false;
});
//Function to handle Return short cut key functionality
function keydownReturnScutsEvent(){
	if($("#app-menu a:focus").size()>0){
		$("#app-menu a:focus").trigger('click');
	}else if(isDialogOpen()){
		setTopMost();
		$('.popSubmitBtn input','.topMost').trigger('click');
		$('.popRequery input','.topMost').trigger('click');
	}else{
		if($('[type="submit"]','.submitBtn').size()>0){
		    if($('.submitBtn').is(":visible")){
				$('.submitBtn:visible').trigger('click');
			}
		}/* else{
			$('.tabs .query-tab:visible').trigger('click');
		} */
	}
	return false;
}
//Handling Shortcuts for Return Key
jQuery(document).bind('keydown', 'return', keydownReturnScutsEvent);
//Handling Shortcuts for keydown event
jQuery(document).bind('keydown',function(evt){
	if(!isDialogOpen() && !isMenuTreeOpen(evt)){
		if(evt.which === 13){
			$('.qrySubmitBtn').find(":enabled:not(:hidden)").trigger('click');
		}
	}
});
//Browser Specific Handling of the Shortcut key shift+return for input type file
jQuery(document).bind('keydown', 'shift+return', function (evt){
	if($('[type="file"]').size()>0){
		if(jQuery.browser.msie){
			//Fix for IE as this event for input type file shows HTTP Status 404,
			//hence Do Nothing for this event for file type input field in IE
			return false;
		}else{
			//For other browsers trigger the click event
			if($('[type="file"]')[0] === $(document.activeElement)[0]){
				$('[type="file"]').trigger('click');
			}
		}
	}else {
		keydownReturnScutsEvent();
	}	
	return false;
});
//Shortcut for closing the focussed dialog window.
jQuery(document).bind('keydown', 'Shift+w',function (evt){
	if(isDialogOpen()){
		var maxz = 0;
		$.each($('.ui-dialog'),function(index,el){
			if($(el).css('z-index') > maxz){
				$('.topMost').removeClass('topMost')
				maxz = $(el).css('z-index');
				$(el).addClass('topMost');
			}
		});
		$('.ui-dialog-titlebar-close','.topMost').trigger('click');	
	}
});
//Shortcut for minimizing the focussed dialog window.
jQuery(document).bind('keydown', 'Shift+z',function (evt){
	if(isDialogOpen()){
		var maxz = 0;
		$.each($('.ui-dialog'),function(index,el){
			if($(el).css('z-index') > maxz && $(el).css('display') == 'block'){
				$('.topMost').removeClass('topMost')
				maxz = $(el).css('z-index');
				$(el).addClass('topMost');
			}
		});
		if($('.topMost').css('display') == 'block')
			$('.minimizeIco','.topMost').trigger('click');
	}
});

//Setting Hot Key
jQuery(document).bind('keydown', 'home',function (evt){
    if($('.ui-dialog').length > 0){
        // Reverse the array to close the top-most dialog 1st, 2nd-most dialog 2nd and so on...
        var revDialogArray = $('a.ui-dialog-titlebar-close', $('.ui-dialog')).toArray().reverse();
        $.each(revDialogArray, function(idx, elm){
            $(elm).trigger('click');
        });
    }
    $('.minDialog').trigger('click');
    $('.dashboardIcon').trigger('click');
    return false;
});
jQuery(document).bind('keydown', 'Shift+f',function (evt){$('#search').trigger('click'); return false; });
jQuery(document).bind('keydown', 'insert',function (evt){$('.addWorkspace').trigger('click'); return false; });
jQuery(document).bind('keydown', 'del',function (evt){$('.removeWorkspace').trigger('click'); return false; });

//Setting Hot Key for Query
jQuery(document).bind('keydown', 'Shift+m',function (evt){$('.moreHandle .handler').click();return false;});

jQuery(document).bind('keydown', 'Alt+f5',function (evt){
    var btnContainer = $('.formBtnBlock');

    // If the user is on the entry page
    if($('.resetBtn input:hidden',btnContainer).length == 0 && $('.resetBtn input',btnContainer).length > 0){
        $('.resetBtn input',btnContainer).click();
    }

    // Enable reset from user-confirmation page
    /*
    if($('.wizBack input:hidden',btnContainer).length == 0 && $('.wizBack input',btnContainer).length > 0){
        $('.wizBack input',btnContainer).click();
        $('.resetBtn input',btnContainer).click();
    }
    */

    return false;
});

jQuery(document).bind('keydown', 'Shift+s',function (evt){$('.save-btn').trigger('click'); return false; });

//Setting shortcut for menu	
	var currentList = null,lastfocussed = null,menustack = new Array();
	
	$(function(){
		lastfocussed = $('body');
		$.each($('.shortcut'),function(index,el){
			var menu = $(el).closest('li');
			var key = 'Shift+'+$(el).html();
			jQuery(document).bind('keydown', key ,function (evt){
                //To prevent menus from opening, in case overlay dialogue is active.
                if($('.ui-widget-overlay').length){
                    return;
                }
				currentList = menu;
				lastfocussed = $('a:first',currentList);
				lastfocussed.focus();
				return false;
			});
		})
	});
  /*
	jQuery(document).bind('keydown', 'down',function (evt){
		var focussedMenu = $('li a:focus',currentList).parent().next().children('a').last();
		lastfocussed.blur();
		 //console.log($("div.menuArea").contains($(evt.target)));
		 console.log($(evt.target).is('div.menuArea *'));
		 if($(evt.target).is('div.menuArea *')){
		if(focussedMenu.size()>0){
			lastfocussed = focussedMenu;
		} else{
			lastfocussed = $('li:first > a',currentList);
		}
		}else{
			return false;
		}
		lastfocussed.focus();
		return false;
	});
  */
  /*
	jQuery(document).bind('keydown', 'up',function (evt){
		var focussedMenu = $('li a:focus',currentList).parent().prev().children('a');
		lastfocussed.blur();
		if($(evt.target).is("div.menuArea *")){
		if(focussedMenu.size()>0){
			lastfocussed = focussedMenu;
		}
		}else{
			return false;
		}
		lastfocussed.focus();
		return false;
	});
  */
  /*
	jQuery(document).bind('keydown', 'right',function (evt){
		lastfocussed.blur();
		menustack.push(currentList);
		currentList = $('ul:visible:last','#app-menu ');
		lastfocussed = $('a:first',currentList)
		lastfocussed.focus();
		return false;
	});
  */
  /*
	jQuery(document).bind('keydown', 'left',function (evt){
		lastfocussed.blur();
		lastfocussed = $(currentList).parent().children('a:first')
		lastfocussed.focus();
		currentList = menustack.pop();
		return false;
	});
  */
	
	jQuery(document).bind('keydown', function(evt){
		if(evt.which === 27){
			if($(evt.target).parents('#formContainer').length>0){
				evt.preventDefault();
				$(evt.target).blur();
			} else {
				$('#app-menu a:focus').blur();
				$('#app-menu .sf-menu ul:visible').hide();
			}
		}
	});

//jGrowl Close when clicking anywhere
$('body').mousedown(function(e) {
    var targetEl = $(e.target);
    if(targetEl.parent().is(".wizNext,.wizPrev,.wizSubmit,.wizConfirm,.wizOk,.submitBtn")){
        return;
    }
    if(targetEl.closest('.formTabErrorIco').length || targetEl.closest('.popupFormTabErrorIco').length || targetEl.closest('#growlDock').length){
        return;
    }else{
        $.each($('#growlDock .growlBox'),function(ind,el){
            $(el).find('#growlBoxClose').trigger('click');
        });
    }
});


//convert text to upper case
jQuery(document).bind('keyup',function(e) {
	var textBox = $(e.target);
	if(textBox.hasClass('textBox')) {
		var start = (e.target).selectionStart, end = (e.target).selectionEnd;
		if (e.which >= 97 && e.which <= 122) {
			var newKey = e.which - 32;
			e.keyCode = newKey;
		}
		textBox.val((textBox.val()).toUpperCase());
		e.target.setSelectionRange(start, end);
	}
	
});
