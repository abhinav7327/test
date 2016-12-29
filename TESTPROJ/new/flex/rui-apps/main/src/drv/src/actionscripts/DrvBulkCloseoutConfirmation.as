


// ActionScript file

 		import com.nri.rui.core.Globals;
 		import com.nri.rui.core.controls.XenosAlert;
 		import com.nri.rui.core.renderers.SelectAllItem;
 		import com.nri.rui.core.renderers.SelectItem;
 		import com.nri.rui.core.utils.XenosStringUtils;
 		import com.nri.rui.core.startup.XenosApplication;
 		
 		import mx.collections.ArrayCollection;
 		import mx.containers.TitleWindow;
 		import mx.controls.dataGridClasses.DataGridColumn;
 		import mx.events.CloseEvent;
 		import mx.managers.PopUpManager;
 		import mx.rpc.events.ResultEvent;

		[Bindable]private var selectedQryRslt:ArrayCollection = new ArrayCollection();
		[Bindable]private var warningList:ArrayCollection = new ArrayCollection();
   		[Bindable]public var selTrdPkArray:Array = new Array();
   		[Bindable]private var mode : String = Globals.MODE_RCVD_CONF;
   		[Bindable]private var app:XenosApplication = XenosApplication.getInstance(Globals.DEFAULT_ENTERPRISE);
		
		/**
		 * This method initializes the unmatch popup screen. 
		 */
		private function init():void {
			confStack.selectedChild = usrConfVBox;
			btnBack.enabled = true;
			btnConfirm.enabled = true;
			btnConfirm.setFocus();
			app.submitButtonInstance = btnConfirm;
			btnOk.enabled = true;
			hb.visible = false;
			hb.includeInLayout = false;
			errPageConf.removeError();
			selectedQryRslt =  this.parentDocument.owner.selectedQueryResult as ArrayCollection;

			softWarning.removeWarning();
			warningList = this.parentDocument.owner.softException as ArrayCollection;
			softWarning.showWarning(warningList);
	
		}
       
       
       /**
       * 
       * This method fires action method for going to unmatch
       * system confirmation screen.
       * 
       * */
       private function goToSystemConfirmation():void {
       		btnBack.enabled = false;
			btnConfirm.enabled = false;
	       	var obj:Object = new Object();
	       	obj['SCREEN_KEY'] = "12010";
		 	obj.method = "loadBulkCloseoutSystemConf";
	 		obj.rnd = Math.random();
	 		loadSystemConf.url = "drv/drvBulkCloseoutDispatch.action?"
		    loadSystemConf.request = obj;
		    loadSystemConf.send();
       }
       
       
       /**
       * This method loads the system confirmation page for trade unmatch.
       * */
       public function loadSystemConfPage(event:ResultEvent):void {
       		btnBack.enabled = true;
			btnConfirm.enabled = true;
			softWarning.removeWarning();
       	    if(event != null){
				if(event.result != null){
					var rs:XML = XML(event.result);
					if(rs.child("selectedTradeList").length()>0){
						btnConfirm.visible = false;
						btnConfirm.includeInLayout = false;
						btnBack.visible = false;
						btnBack.includeInLayout = false;
						btnOk.visible = true;
						btnOk.enabled = true;
						btnOk.includeInLayout = true;
						btnOk.setFocus();
						app.submitButtonInstance = btnOk;
						hb.visible = true;
						hb.includeInLayout = true;
						confLbl.text = this.parentApplication.xResourceManager.getKeyValue('drv.bulk.closeout.popup.sys.conf.title');
						confStack.selectedChild = sysConfVBox;
						errPageConf.removeError();
						selectedQryRslt = new ArrayCollection();
						for each ( var rec:XML in rs.selectedTradeList.selectedTrade ) {
		 				    selectedQryRslt.addItem(rec);
					    }
					}else if(rs.child("Errors").length()>0){
						hb.visible = false;
						hb.includeInLayout = false;
						errPageConf.removeError();
						var errorInfoList : ArrayCollection = new ArrayCollection();
						for each ( var error:XML in rs.Errors.error ) {
			 			   errorInfoList.addItem(error.toString());
						}
						errPageConf.showError(errorInfoList);
					}else{
						XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
					}
				}else{
					XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
				}
			}else{
				XenosAlert.info(this.parentApplication.xResourceManager.getKeyValue('inf.label.query.noresult'));
			}
       }
       
	   public function closeHandeler():void{
	        this.parentDocument.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
       }
