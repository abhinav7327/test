

<%

%>
<%@ include file="/WEB-INF/tiles/tldDefinition.jsp"%>

<html>
<head>

 <script type="text/javascript" src="scripts/inf/jquery-1.4.2.js"></script>
 <script type="text/javascript" src="scripts/inf/jquery.ui.core.js"></script>
 <script type="text/javascript" src="scripts/inf/jquery.ui.widget.js"></script>
 <script type="text/javascript" src="scripts/inf/jquery.ui.mouse.js"></script>
 <script type="text/javascript" src="scripts/inf/jquery.ui.sortable.js"></script>
 <!--script type="text/javascript" src="scripts/inf/jquery.ui.tooltip.js"></script-->
 <script type="text/javascript" src="scripts/inf/jquery.ui.position.js"></script>
 <script type="text/javascript" src="scripts/inf/jquery.ui.draggable.js"></script>
 <script type="text/javascript" src="scripts/inf/jquery.ui.resizable.js"></script>
 <script type="text/javascript" src="scripts/inf/jquery.ui.dialog.js"></script>
 <script type="text/javascript" src="scripts/inf/jquery.ui.tooltip.js"></script>
 <script type="text/javascript" src="scripts/inf/jquery.effects.core.js"></script>
 <script type="text/javascript" src="scripts/inf/jquery.confirm-1.3.js"></script>
 
 
 
<script type="text/javascript" charset="utf-8">

var groupNameArrayDyn = new Array();
var objArrDyn = new Array();
var groupNameOrderAssociationArry = new Array();

//var componentDetailsUrl =  "/istargv-ncs/rest/componentDetails.json";

//var componentCountUrlPrefix = "/istargv-ncs/rest/componentCount.json?componentName=" ;

//var linkFailedIcon = new Image(13,11); linkFailedIcon.src="/istargv-ncs/images/xn-link-failed.gif";

var componentDetailsUrl =  "<xenos:ctxpath/>rest/componentDetails.json";


var componentCountUrlPrefix = "<xenos:ctxpath/>rest/componentCount.json?componentName=" ;

var linkFailedIcon = new Image(13,11); linkFailedIcon.src="<xenos:ctxpath/>images/xn-link-failed.gif";

 var linkFailedIcon ;
  function componentObject(groupName,name,viewResultColumn,componentViewName,restUrl,asyncInterval,groupOrder,groupId,componentId,isError)
 {
	this.groupName=groupName
	this.name=name
	this.viewResultColumn=viewResultColumn
	this.componentViewName=componentViewName
	this.restUrl=restUrl
	this.asyncInterval = asyncInterval
    this.groupOrder = groupOrder
	this.groupId = groupId;
	this.componentId = componentId;
	this.isError = false;
  }

	
	function addComponents() {
		var n = 0;
		for(i=1;i<=groupNameArrayDyn.length;i=i+1){
			var grName = groupNameArrayDyn[i-1];
			//alert('groupName:: '+grName+ ' groupId:: '+groupNameOrderAssociationArry[grName]);
			for(k=0;k<objArrDyn.length;k=k+1){
				var componentObject = objArrDyn[k];
				if(grName == componentObject.groupName){
					n = componentObject.groupOrder;
				}
			}
			
			if(n%3 == 1){
				
				//addGroup('col1',groupNameArrayDyn[i-1]);
				addGroupElement('col1',groupNameArrayDyn[i-1]);
				
			}else if(n%3 == 2){
				
				//addGroup('col2',groupNameArrayDyn[i-1]);
				addGroupElement('col2',groupNameArrayDyn[i-1]);
				
			}else if(n%3 == 0){
				
				//addGroup('col3',groupNameArrayDyn[i-1]);
				addGroupElement('col3',groupNameArrayDyn[i-1]);
			
			}
		}
					

	}
	function addGroupElement(columnId,groupName){

		var grId = groupNameOrderAssociationArry[groupName];
	
		
			$('#'+columnId).append('<div class="portlet"><div class="portlet-header"><span class="xn-portlet-title">'+groupName+'</span></div><div class="portlet-content"><ul class="xn-sortable connected-sortable" id="'+grId+'"></ul></div></div>');
			
			for(k=0;k<objArrDyn.length;k=k+1){
				var componentObject = objArrDyn[k];
				if(componentObject.groupId == grId){
					var attrId = 'span_gr'+grId+'_comp'+componentObject.componentId;
					var numId = 'gr'+grId+'_comp'+componentObject.componentId;
					var linkId = 'link_gr'+grId+'_comp'+componentObject.componentId;
					var href = "javascript:openNamedWindow('" + componentObject.restUrl + "','Popup_View',500,1000,false,true)";

					$('#'+grId).append('<li class="ui-state-default"><span class="xn-item-name" title="'+componentObject.name+'">'+componentObject.name+'</span><span class="xn-item-attributes" id="'+attrId+'"><span class="xn-item-number" id="'+numId+'"><a id="'+linkId+'" href="'+href+'">(0)</a></span></span></li>');
					getCountResult(componentObject,false);	
				}

			}
			//alert($('.portlet').html());
		
	}
	
	
	function updateRow(myoj,componentObject,isError,errorString){
		
		var id = 'gr'+componentObject.groupId+'_comp'+ componentObject.componentId;
		var linkId = 'link_gr'+componentObject.groupId+'_comp'+componentObject.componentId;
		
		if(isError==false){
		var count = myoj.dtoCount.componentCount;
			if($('#'+linkId)!=null){
				$('#'+linkId).text( '('+count+')' );
			}
		}else{
			if(componentObject.isError==false){
				componentObject.isError = true;
				if(errorString =='Unknown' || errorString =='Not Found'){
					errorString = 'Link is Down';
				}
				$("#span_"+id).prepend('<span title="'+errorString+'" id="" class="xn-link-failed" ><img src="<xenos:ctxpath/>images/xn-link-failed.gif" width="13" height="11"/></span>'); 
			}
		}
			
		}

	
    function waitForMsg(){
        /* This requests the url "/rest/dashboard/users/e.html"
        When it complete (or errors)*/

		
        $.ajax({
            type: "GET",
            url: componentDetailsUrl /*"http://localhost:8080/istargv-ncs/rest/componentDetails.json"*/,

            async: true, /* If set to non-async, browser shows page as "Loading.."*/
            cache: false,
            timeout:50000, /* Timeout in ms */
			success: function(data){ /* called when request completes */
			//alert(data);
			//var myObj = eval('(' + data + ')');//working for previous version
			var myObj =  data ;
			//alert(data.componentDTO.length);
			if(data.componentDTO.length>0){
				for (i=0;i<myObj.componentDTO.length;i=i+1)
				{
					var test = 'No';
						if(groupNameArrayDyn.length>0){
							for(j=0;j<groupNameArrayDyn.length;j=j+1){
								
								if(groupNameArrayDyn[j]==myObj.componentDTO[i].groupName){
									
									test = 'Yes';
									//return;
								}
								
							}
							if(test == 'No'){
								groupNameArrayDyn[groupNameArrayDyn.length] = myObj.componentDTO[i].groupName;
								groupNameOrderAssociationArry[myObj.componentDTO[i].groupName] = myObj.componentDTO[i].groupId;
								test= 'Yes';
							}
						}else{
							groupNameArrayDyn[groupNameArrayDyn.length] = myObj.componentDTO[i].groupName;
							groupNameOrderAssociationArry[myObj.componentDTO[i].groupName] = myObj.componentDTO[i].groupId;
						}
					
					

					objArrDyn[objArrDyn.length] = new componentObject(myObj.componentDTO[i].groupName,
								myObj.componentDTO[i].componentName,
								myObj.componentDTO[i].viewResultColumn,
								myObj.componentDTO[i].componentViewName,
								myObj.componentDTO[i].restUrl,
								myObj.componentDTO[i].asynInterval,
								myObj.componentDTO[i].groupOrder,
								myObj.componentDTO[i].groupId,
								myObj.componentDTO[i].componentId

						);
					

					
				}
				
			}
			
			addComponents();
		       

			columnsort();

			addfeatures();

			$(".portlet-header .xn-minimize").click(function() {
				$(this).toggleClass("ui-icon-minusthick").toggleClass("ui-icon-plusthick");
				$(this).parents(".portlet:first").find(".portlet-content").toggle();
			});
	
			$(".xn-close").click(function() {
				deletePortlet($(this).parents(".portlet:first"));
			});
			
			/*
			// This code is for confirmation while removing group
			
			$('.xn-close').confirm({
				msg:'Confirm: ',
				timeout:3000,
				wrapper: '<span class="xn-close-confirm"></span>',
				buttons: {
					ok:'Delete',
					cancel:'No',
					wrapper: '<span class="xn-close-confirm-option"></span>',
					separator:'  '
				}
			});
			
			*/
			$(".xn-refresh").click(function() {
                       refreshPortlet($(this).parents(".portlet:first"));
              });

 
			/*$(".xn-refresh").click(function() {
				refreshPortlet($(this).parents(".portlet:first").find(".xn-sortable"));
			});*/
			
			$(".portlet-header").dblclick(function(){
				$(this).find(".xn-minimize").toggleClass("ui-icon-minusthick").toggleClass("ui-icon-plusthick");
				$(this).parents(".portlet:first").find(".portlet-content").toggle();
			});
			
			itemsort();
			
			//enable();

			$("#dialog").dialog("destroy");

			var gname = $("#gname"),
				allFields = $([]).add(gname);
			
			$("#dialog-form").dialog({
				autoOpen: false,
				height: 130,
				width: 350,
				modal: true,
				resizable: false,
				draggable: false,
				buttons: {
					'Create': function() {

							var gid = gname.val().split(' ').join(''); // ID for newly created group
							
							$('#col1').append('<div class="portlet ui-widget ui-widget-content ui-helper-clearfix" id="' + gid + '">' +
								'<div class="portlet-header ui-widget-header"><span class="ui-icon ui-icon-minusthick xn-minimize"></span><span class="xn-portlet-title">' + gname.val() +'</span><span class="ui-icon ui-icon-refreshthick xn-refresh"></span><span class="ui-icon ui-icon-closethick xn-close"></span></div>' +
								'<div class="portlet-content">' +
								'<ul class="xn-sortable connected-sortable"> ' +
								'</ul>' +
								'</div>' +
								'</div>');

							$(this).dialog('close');
							
							columnsort();
							
							$("#"+gid).find(".portlet-header").bind('dblclick', (function(){
								$(this).find(".xn-minimize").toggleClass("ui-icon-minusthick").toggleClass("ui-icon-plusthick");
								$(this).parents(".portlet:first").find(".portlet-content").toggle();
							}));
							
							$("#"+gid).find(".portlet-header .xn-minimize").bind('click', (function() {
								$(this).toggleClass("ui-icon-minusthick").toggleClass("ui-icon-plusthick");
								$(this).parents(".portlet:first").find(".portlet-content").toggle();
							}));
							
							$("#"+gid).find(".xn-close").bind('click', (function() {
								deletePortlet($(this).parents(".portlet:first"));
							}));
							
							$("#"+gid).find(".xn-close").bind('click', (function() {
								refreshPortlet($(this).parents(".portlet:first").find(".xn-sortable"));
							}));
							
							$("#"+gid).find('.xn-close').confirm({
								msg:'Confirm: ',
								timeout:3000,
								wrapper: '<span style="float:right; background-color:none; color:#ffffff; font-size:10px; font-weight:normal; margin-top:2px;"></span>',
								buttons: {
									ok:'Delete',
									cancel:'No',
									wrapper: '<span style="background-color:#ffffff; color:#d67a16; font-size:10px; font-weight:normal; cursor:pointer; padding:1px 3px 1px 3px;"></span>',
									separator:'  '
								}
							});
							
							itemsort();
					},
					Cancel: function() {
						$(this).dialog('close');
					}
				},
				close: function() {
					allFields.val('');
				}
			});

           
			},
            error: function(XMLHttpRequest, textStatus, errorThrown){
            //setTimeout('waitForMsg()', 15000); 
			//alert('Unable to connect server');
            }
        });
    }
   
	 function getCountResult(componentObject,isRefresh){
		 
		 var urlString =componentCountUrlPrefix+componentObject.name+"&viewName="+componentObject.componentViewName+"&viewColumn="+componentObject.viewResultColumn+"&urlString="+componentObject.restUrl;  //componentObject.restUrl;
		// alert('from getCountResult:: '+urlString);
		 var asyncInterval =  componentObject.asyncInterval;
		 
		//alert(' testResult urlString:: '+urlString+' asyncInterval::'+asyncInterval);
		$.ajax({
            type: "GET",
            url: urlString,

            async: true, 
            cache: false,
            timeout:50000, 
			success: function(data){ 
				
			//var myObj = eval('(' + data + ')');
			var myObj = data ;

			
			updateRow(myObj,componentObject,false,null)
			
			if(isRefresh == false){
				setTimeout(function(){getCountResult(componentObject,false);}, asyncInterval);
			}
			//setTimeout( function() {Stuff(a_str, an_int, delay);}, delay);
				
			},
            error: function(XMLHttpRequest, textStatus, errorThrown){
           
			updateRow(null,componentObject,true,XMLHttpRequest.statusText)
				
            }
        });
	 }
	
	
    $(document).ready(function(){
		 //linkFailedIcon = $('<img width="13px" height="11px" />').attr('src', '/istargv-ncs/images/xn-link-failed.gif');
		 //alert(linkFailedIcon);
		 waitForMsg(); /* Start the inital request */
		 
		
    });
		function showNotice(){
			var winXCenterPos = Math.round($(window).width() / 2);
			var noteXPos = winXCenterPos - 200;
			$('#xn-dashboard')
				.prepend('<div class="xn-note-wrapper"><div id="xn-note" class="xn-note"><span class="xn-note-title">Note:</span> <span class="xn-note-text">Modified data has been saved.</span></div></div>')
				.find(".xn-note-wrapper").css("left", noteXPos);
				$(".xn-note-wrapper").delay(2000).fadeOut('slow');
		}
		
		function columnsort(){
			$(".column").sortable({
				connectWith: '.column', handle : ".portlet-header" , opacity: 0.35, containment: 'document',
				update: function(){
					// showNotice(); 
				}
			}).disableSelection();
		}
		
		function addfeatures(){
			$(".portlet").addClass("ui-widget ui-widget-content ui-helper-clearfix")
				.find(".portlet-header")
					.addClass("ui-widget-header")
					.prepend('<span class="ui-icon ui-icon-minusthick xn-minimize"></span>')
					/* cross button for cancel group is disabled
					.append('<span class="ui-icon ui-icon-refreshthick xn-refresh"></span><span class="ui-icon ui-icon-closethick xn-close"></span>')
					*/
					.append('<span class="ui-icon ui-icon-refreshthick xn-refresh"></span>')
					.end()
				.find(".portlet-content");
		}
		
		function itemsort(){
			$(".xn-sortable").sortable({
				connectWith: '.connected-sortable', opacity: 0.85,
				update: function(){
					//showNotice();
				}
			}).disableSelection();
		}
		
		function refreshPortlet(thisportlet){
			thisportlet.find(".xn-sortable").sortable('refresh');
			if(thisportlet.find(".xn-refreshing").length > 0){
				// do nothing
			}else{
				thisportlet.find(".xn-portlet-title").after('<span class="xn-refreshing">Refreshing...</span>');
				setTimeout(function(){thisportlet.find(".xn-refreshing").fadeOut() }, 1000);
				setTimeout(function(){thisportlet.find(".xn-refreshing").remove() }, 1000);
			}


			for(var i=0;i<$(thisportlet).find(".xn-item-number").length;i++)
			{
				
				var groupID = $(thisportlet).find(".xn-item-number")[i].id.split("_")[0].substring(2);
				var componentID = $(thisportlet).find(".xn-item-number")[i].id.split("_")[1].substring(4);
				
				for(j=0;j<objArrDyn.length;j=j+1){
					
					var componentObject1 = objArrDyn[j];
					
					if(componentObject1.groupId == groupID &&  componentObject1.componentId == componentID){
						//alert(' name '+componentObject1.groupName +' column '+ componentObject1.viewResultColumn + ' view '+componentObject1.componentViewName );
						getCountResult(componentObject1,true);
					
						//var comp = new componentObject(componentObject1.groupName,
						//					componentObject1.componentName,
						//					componentObject1.viewResultColumn,
						//					componentObject1.componentViewName,
						//					componentObject1.restUrl,
						//					componentObject1.asynInterval,
						//					componentObject1.groupOrder,
						//					componentObject1.groupId,
						//					componentObject1.componentId
//
						//			);
						//alert(comp.groupId + " "+ comp.componentId);
						//var urlString =componentCountUrlPrefix+componentObject1.name+"&viewName="+componentObject1.componentViewName+"&viewColumn="+componentObject1.viewResultColumn;  
							
							//	 var asyncInterval =  componentObject1.asyncInterval;
								
									/*$.ajax({
									type: "GET",
									url: urlString,

									async: true, 
									cache: false,
									timeout:50000, 
									success: function(data){ 
									
									
									var myObj = data ;
									//alert(myObj.dtoCount.componentCount);
							
									updateRow(myObj,comp,false,null)
											
									},
									error: function(XMLHttpRequest, textStatus, errorThrown){
								   
									//updateRow(null,comp,true,XMLHttpRequest.statusText)
										
									}
								});*/

					}
				}

			
			}
				
			//showNotice();
		}
		
		function deletePortlet(thisportlet){
			thisportlet.remove();
			//showNotice();
		}
		
		
</script>
<link type="text/css" href="styles/xenos.css" rel="stylesheet" />
<link type="text/css" href="styles/jquery.ui.all.css" rel="stylesheet" />

<!--link type="text/css" href="styles/jquery.ui.theme.css" rel="stylesheet" />
<link type="text/css" href="styles/jquery.ui.core.css" rel="stylesheet" /-->
<!--xenos:css href="styles/jquery.ui.base"/-->
<link type="text/css" href="styles/dashboard.css" rel="stylesheet" />


</head>
<body >
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
    <td class="bgStripes"><xenos:img srcKey="inf.image.whitespace"  width="1" height="22"/></td>
</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
    <td class="486D92">
        <table width="400" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="22"><xenos:img  srcKey="inf.image.leftmargin2"  width="7" height="21"/><xenos:img srcKey="inf.image.icon.icondocument"  width="13" height="21" align="absmiddle"/></td>
            <td width="378" class="subhead">
            Dashboard
            </td>
          </tr>
          
           <tr>
             <table width="100%" border="0" cellspacing="0" cellpadding="0">
               <tr>
                 <td width="7" class="bgLeftMargin"></td>
                 <td width="10"><xenos:img srcKey="inf.image.box2lefttop"  width="10" height="26"/></td>
                 <td width="*" class="bgBox2Top"> <span class="labelbold">&nbsp;</span></td>
                 <td width="11"><xenos:img srcKey="inf.image.box2righttop"  width="11" height="26"/></td>
                </tr>
             </table>
             <table width="100%" border="0" cellspacing="0" cellpadding="0">
               <tr>
                  <td width="7" class="bgLeftMargin"></td>
                  <td width="10" class="bgBox2Left"></td>
                  <td width="*" class="cacaca" height="35">
                     <table width="100%" border="0" cellspacing="0" cellpadding="0">
                       <tr  class="e4e4e4">
                         
                         <td width="100%" class="e4e4e4">
							<!-- -->
							<table width="100%" border="0">
							<tr>
							<td>
							<div id="xn-dashboard-wrapper">
							   
									<div id="xn-dashboard">
									
										<div class="column" id="col1" >
										</div>
										
										<div class="column" id="col2">
										</div>
										
										<div class="column" id="col3">
										</div>
									
										<div class="xn-clear"></div>
									
									</div><!-- End xn-dashboard -->

								</div><!-- End xn-dashboard-wrapper -->
							</td>
							</tr>
							</table>
							<!-- -->
                         </td>
                        </tr>
                      </table>
                    </td>
                  <td width="11" class="bgBox2Right"></td>
                </tr>
              </table>
            </tr>
          
        </table>
    </td>
</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
    <td width="7" class="bgLeftMargin"><xenos:img  srcKey="inf.image.spacer"  width="7" height="15"/></td>
    <td width="10"><xenos:img srcKey="inf.image.box2leftbottom"  width="10" height="15"/></td>
    <td width="*" class="bgBox2Bottom"><xenos:img  srcKey="inf.image.spacer"  width="7" height="15"/></td>
    <td width="11"><xenos:img srcKey="inf.image.box2rightbottom"  width="11" height="15"/></td>
</tr>
</table>
</body> 
</html>

