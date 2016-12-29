//$Id$
//$Author: pallabib $
//$Date: 2016-12-23 12:20:54 $
$(function(){

	/*	Window Manager Class 
	*	Properties
	*	parent		:	specifies the location of the tray holder.
	*	el			:	specifies the id of the element, which will hold all the tray items.
	*	$el			:	shortcut of jQuery(el)
	*	Methods
	*	init		:	Initialize the window manager and also created the tray.
	*	reg			:	Registers the newly activeed window in other words created an element
	*					in the tray holdre which represents the window.
	*	unreg		:	unregisters the closed window, in other words removes the element
	*					from the tray which represents the window.
	*	toggle		:	click handler of tray elements, handles the show/hide functionality of windows.
	*	minDialog	:	handles the click handler of minimize icon in the titlebar of ui.
	*/
	xenos.windowManagerClass = function(params){
		this.parent = params.parent;
		this.el = params.id ? params.id:"taskBar";
		this.dialogLimit = params.dialogLimit ? params.dialogLimit:6;
		//Window Manager should be initialized after the el is ready
		this.init = function() {
			$(this.parent).append('<div id="'+this.el+'"></div>');
			this.$el = $('#'+this.el);
			this.counter = 0;
			this.uniqueDialogIndex = 0;
		}
		this.allowDialog = function(){
			if(this.counter < this.dialogLimit){
				return true;
			}else{
				alert(xenos.i18n.message.popup_limit_reached);
				return false;
			}
		}
		this.toggle = function(ev){
			var taskBtn = $(ev.currentTarget);
			var dialogId = $(ev.currentTarget).attr('rel');
			var dialogContainer = $('#'+dialogId).closest('.ui-dialog');
			
			if(taskBtn.hasClass('active')){
				if($('.activedialog').size() >0){
					if($.ui.dialog.maxZ == dialogContainer.css('z-index')){
						dialogContainer.hide().removeClass('activedialog');
						taskBtn.removeClass('active');
						$('.taskBtn').removeClass('toTop');
					}else{
						$('#'+dialogId).dialog('moveToTop');
						$('.taskBtn').removeClass('toTop');
						taskBtn.addClass('toTop');
					}			
				}else{
					dialogContainer.hide().removeClass('activedialog');
					taskBtn.removeClass('active');
					$('.taskBtn').removeClass('toTop');
				}
			}else{
				$('#'+dialogId).dialog('moveToTop');
				dialogContainer.show().addClass('activedialog');
				taskBtn.addClass('active');
				$('.taskBtn').removeClass('toTop');
				taskBtn.addClass('toTop');
			}
			dialogContainer.trigger('resize');
		}
		this.minDialog = function(ev){
			var dialogId = $(ev.currentTarget).attr('rel');
			$('.taskBtn[rel='+dialogId+']').trigger('click');
		}
		this.maxDialog = function(ev){
			var dialogId = $(ev.currentTarget).attr('relm'),
				dialogContainer = $('#'+dialogId ).closest('.ui-dialog'),
				dialog = $('#'+dialogId);
			$('#'+dialogId).data('restoreData',{
				"width" : dialogContainer.width(),
				"height" : dialogContainer.height(),
				"position" : dialogContainer.position()
			});
			dialogContainer.find('.maxDialog').replaceWith('<a href="#" relm="'+dialogId+'" class="restoreDialog" role="button"><span class="maximizeIco">restore</span></a>');
			dialog.dialog( "option" , 'position' , [11,49]);
			dialog.dialog( "option" , 'width' , $('#content').innerWidth()-25);
			dialog.dialog( "option" , 'height' , $('#content').innerHeight()-10);
			dialog.dialog( "option" , 'resizable' , false);
			dialog.dialog( "option" , 'draggable' , false);
			dialogContainer.trigger('resize');
			$('.restoreDialog').bind('click',{me:ev.data.me},ev.data.me.restoreDialog);
		}
		this.restoreDialog = function(ev){
			var dialogId = $(ev.currentTarget).attr('relm'),
				dialogContainer = $('#'+dialogId ).closest('.ui-dialog'),
				restoreData = $('#'+dialogId).data('restoreData'),
				dialog = $('#'+dialogId);
			dialog.dialog( "option" , 'resizable' , true);
			dialog.dialog( "option" , 'width' , restoreData.width);
			dialog.dialog( "option" , 'height' , restoreData.height);
			dialog.dialog( "option" , 'draggable' , true);
			dialog.dialog( "option" , 'position' , [restoreData.position.left,restoreData.position.top]);			
			dialogContainer.find('.restoreDialog').replaceWith('<a href="#" relm="'+dialogId+'" class="maxDialog" role="button"><span class="maximizeIco">maximise</span></a>');
			$('.maxDialog',dialogContainer).bind('click',{me:ev.data.me},ev.data.me.maxDialog);
			dialogContainer.trigger('resize');
		}

        /*
        * The following method is called when close button in a detail dialog/popup dialog is clicked
        * but before the actual close operation occurs.
        * Following item(s) are destroyed/cleaned up
        * 1. Grid
        * */
        this.cleanup = function(){
            //1. Destroy all the grids in Dialog, before closing it.
            var grids = $("[class*=slickgrid_]",this);
            $.each(grids,function(ind,grid){
                $(grid).data("gridInstance").destroy();
            });
        }

		this.unreg = function(dialog){
            //UnBinding Listeners
            var dialogContainer = $('#'+dialog.id).closest('.ui-dialog');
            $('[rel='+dialog.id+']').unbind('click',this.toggle);
            $('.minDialog',dialogContainer).unbind('click',this.minDialog);
            $('.maxDialog',dialogContainer).unbind('click',{me:this},this.maxDialog);
			$('[rel='+dialog.id+']').remove();
			this.counter--;
		}
		this.reg = function(dialog){
			var taskBtn = '<span rel="'+dialog.id+'" class="taskBtn active"><span class="txt">'+dialog.title+'</span><span class="ico"></span></span>';
			this.$el.append(taskBtn);
			var dialogContainer = $('#'+dialog.id).closest('.ui-dialog');
			dialogContainer.addClass('activedialog');
			dialogContainer.find('.ui-dialog-titlebar').append('<a href="#" relm="'+dialog.id+'" class="maxDialog" role="button"><span class="maximizeIco">maximise</span></a><a href="#" rel="'+dialog.id+'" class="minDialog" role="button"><span class="minimizeIco">minimize</span></a>')
			
			//Binding Listeners
			$('[rel='+dialog.id+']').bind('click',this.toggle);
			$('.minDialog',dialogContainer).bind('click',this.minDialog);
			$('.maxDialog',dialogContainer).bind('click',{me:this},this.maxDialog);
			this.counter++;
		}
		this.init();
	};
});

//Initializing the window on document.ready for now.
$(function(){
	xenos.windowManager = new xenos.windowManagerClass({
		parent:'#footer',
		dialogLimit: 6
	});
})