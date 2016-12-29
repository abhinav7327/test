<%@ taglib uri="http://www.nri.co.jp/xenos" prefix="xenos" %>
<%@ include file="/WEB-INF/tiles/tldDefinition.jsp"%>
<%@ page import="com.nri.xenos.startup.Application" %> 
<%@page import="java.util.*" %>
<%@page import="java.text.*" %>
<html>
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>Welcome to I-STAR/GV</title>
		<!-- Include EXT Style Sheets -->
		<link rel="stylesheet" type="text/css" href="ext-3.2.1/resources/css/ext-all.css">

		<!-- Include I-STAR/GV Style Sheet -->
        <link href="styles/xenos-ui.css" rel="stylesheet" type="text/css" />
		<link href="styles/xenos-inner/style.css" rel="stylesheet" type="text/css" />
        <!--[if IE 6]>
		<link href="styles/xenos-inner/ie6.css" rel="stylesheet" type="text/css" />
        <![endif]-->
		
		<!--[if IE 7]>
		<link href="styles/xenos-inner/ie7.css" rel="stylesheet" type="text/css" />
        <![endif]-->
		
		<!--[if IE 8]>
		<link href="styles/xenos-inner/ie8-all.css" rel="stylesheet" type="text/css" />
        <![endif]-->
		
		<!--[if lt IE 8]>
		<link href="styles/xenos-inner/ie8.css" rel="stylesheet" type="text/css" />
        <![endif]-->

		<link href="styles/xenos-inner/TreeGrid.css" rel="stylesheet" type="text/css" />
		
		<link href="styles/desktop.css" rel="stylesheet" type="text/css" />
		<!--script src="scripts/jquery.min.js" type="text/javascript"></script-->
		<!-- Include EXT javascript -->
		<script type="text/javascript" src="ext-3.2.1/adapter/ext/ext-base.js"></script>
		<script type="text/javascript" src="ext-3.2.1/ext-all.js"></script>
		<!-- Locale Handling -->
		<script type="text/javascript" src="scripts/ext-xenos/desktop/namespace.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/validators/xenos_vtypes.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/XenosMenuItem.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/layout/fluid_formpanel.js"></script>
		<!-- <xenos:locale debuglocale="NO"/> -->
		
		
		<!-- Common Script -->
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_util.js"></script>		
		
		<!--  Desktop-->
		<!--script type="text/javascript" src="scripts/ext-xenos/desktop/FormManager.js"></script-->	
		<script type="text/javascript" src="scripts/ext-xenos/ux/gridfilters/menu/RangeMenu.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos//ux/gridfilters/menu/ListMenu.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/ux/tab/TabScrollerMenu.js"></script>
	
		<script type="text/javascript" src="scripts/ext-xenos/ux/colorPicker/color_field.js"></script>
	
		<script type="text/javascript" src="scripts/ext-xenos/ux/gridfilters/GridFilters.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/ux/gridfilters/filter/Filter.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/ux/gridfilters/filter/StringFilter.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/ux/gridfilters/filter/DateFilter.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/ux/gridfilters/filter/ListFilter.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/ux/gridfilters/filter/NumericFilter.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/ux/gridfilters/filter/BooleanFilter.js"></script>	
		<script type="text/javascript" src="scripts/ext-xenos/ux/gridfilters/filter/StatusFilter.js"></script>	
		<script type="text/javascript" src="scripts/ext-xenos/ux/multiSelect/MultiSelect.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/desktop/ApplicationCacheMap.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/XenosDbProvider.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/desktop/shortcutManager.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/desktop/App.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/desktop/StartMenu.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/desktop/TaskBar.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/desktop/Desktop.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_combobox.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_textfield.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_json_store.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/panels/base_form_panel.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/desktop/Module.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/desktop/AccessLogger.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/desktop/MenuBar.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/desktop/xenos_desktop.js"></script>
        <script type="text/javascript" src="scripts/ext-xenos/desktop/XenosMessageBox.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/desktop/MessageQue.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/popup/xenos_popup_fectory.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/desktop/XenosLoader.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/desktop/FormManager.js"></script>		
		<script type="text/javascript" src="scripts/ext-xenos/popup/popup_form_manager.js"></script>	
		<script type="text/javascript" src="scripts/ext-xenos/popup/xenos_popup_panel.js"></script>		
		<script type="text/javascript" src="scripts/ext-xenos/constants/application_standard_urls.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/constants/application_constants.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/data/xenos_data_store.js"></script>
		
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_desktop_button.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/XenosDropTarget.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/PagingStore.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_base_grid.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/grid.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/popupgrid.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_combotree.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_tabpanel.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_query_tabpanel.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_sortpanel.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenosSortOptionPanel.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_date_field.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_account_no_combopopup_grid.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_inventory_account_no_combopopup_grid.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_security_combopopup_grid.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_sales_code_combopopup_grid.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_combopopup.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_abstract_combo_popup.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_business_combopopup.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_label.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_display_label.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/XenosSortCombo.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_display.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_business_combotree.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_business_combo.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_dateto_field.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_single_date_field.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/XenosDateField.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/XenosDateMenu.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/XenosDatePicker.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_editor_grid.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/panels/base_query_form_panel.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/popup/xenos_popup_form_panel.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/popup/xenos_business_popup_form.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/desktop/cached_data.js"></script>

		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_reference_no_component.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_counter_party.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/XenosAccountRangeField.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_init_combo.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/xenos_base_wizard.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/XenosLabelifyPlugin.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/XenosTabentryPanel.js"></script>
		
		<script type="text/javascript" src="scripts/ext-xenos/ux/treegrid/TreeGrid.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/components/XenosTreeGrid.js"></script>
		
		<!-- Iframe -->
		<script type="text/javascript" src="scripts/ext-xenos/managed_iframe.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/panels/xenos_iframe.js"></script>
		
		<!-- resource bundle -->
		<script type="text/javascript" src="scripts/ext-xenos/i18n/global-variables.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/i18n/language.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/i18n/resource_en.js"></script>
		<script type="text/javascript" src="scripts/ext-xenos/i18n/resource_jp.js"></script>
		
		<!-- Display Details -->
		<script type="text/javascript" src="scripts/ext-xenos/forms/ref/ref.INENT.1.2.form.js"></script>
		
		<!-- form printing and grid printing -->
		<script type="text/javascript" src="scripts/ext-xenos/print_function/printComp.js"></script>
		<!-- Details View-->
		<script type="text/javascript" src="scripts/ext-xenos/view/xenos_popup_instrument_details.js"></script>	
		<script type="text/javascript" src="scripts/ext-xenos/view/xenos_util_popup_trade.js"></script>

		<!-- END -->
		
	</head>
<body scroll="no">
<div class="bg-graphic">
<!--  To format the application date-->
 <%!
	String getDate(){
	String pattern = "yyyy-MM-dd";
	SimpleDateFormat format = new SimpleDateFormat(pattern);
	return(format.format(Application.getInstance().getContext().getCallerIdentity().getCurrentLogDate()));
	}	
	%>
<!--  format END -->

<script type="text/javascript">
	// User ID
	var user = "<%= Application.getInstance().getContext().getCallerIdentity().getName()%>";
	
	//Application Enterprise ID
	var enterpriseId ='<c:out value="${applicationScope['enterprise.current']}"/>';
	var friendsId ='<c:out value="${applicationScope['enterprise.friends']}"/>';
	var finalArray = [];
	if(friendsId != ''){
		friendsId = friendsId.replace("{","").replace("}","");
		// extract each enterprize data
		var entArry = friendsId.split(',');
		for(var i=0;i<entArry.length;i++){
			var keyArry = entArry[i].split('=');
			var obj = new Object();
			obj.key = keyArry[0].trim();
			obj.value = keyArry[1].trim();
			finalArray.push(obj);
		}
	}	
	// @Return application date
	function getAppDate(){
		return "<%= getDate() %>"; //dt.format(_dateFormat);
	}
</script>

<div id="xenos-legacy-cache-container" style="display:none">
	<span id="mktChache" style="display:none"></span>
	<span id="instChache" style="display:none"></span>
</div>
<div id="ux-topbar"></div>
<div id="xenos-nav"></div>
<div id="x-desktop" style="z-index: 1">
	
	<div class="ribbon-area">  
		<div class="shadow">&nbsp;</div>
		<div class="ribbon-red">
			<span id="poc-shortcut">
				<!-- <script type="text/javascript">document.write(Xenos.Application.POC);</script> -->
			</span>
	</div>
	</div>
    <div class="logo_area"><img src="images/logo.png" /></div>
	<div id="x-shortcuts"></div>
	<div id="msgbox" class="msgbox-container" ></div>
</div>

<div id="taskbar-hide" class="taskbarHide"></div>

<div id="ux-taskbar">
	<div id="ux-taskbar-start"></div>
	<div id="ux-taskbuttons-panel"></div>
	<div class="x-clear"></div>
</div>

</div>
</body>
</html>
