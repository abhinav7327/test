



<%@ include file="/WEB-INF/tiles/tldDefinition.jsp"%>
<xenos:css href="/styles/xenos.css"/>
<xenos:script src="/scripts/inf/utilPopup.js"/>

<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
  <td class="bgStripes"><xenos:img srcKey="inf.image.whitespace"  width="1" height="22"/></td>
</tr>
</table>
 <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="7" class="bgLeftMargin">&nbsp;</td>
      <td width="10"><xenos:img srcKey="inf.image.box2lefttop" /></td>
      <td width="*" class="bgBox2Top"><span class="labelbold"></span></td>
      <td width="*" class="bgBox2Top">&nbsp;</td>
      <td width="11"><xenos:img srcKey="inf.image.box2righttop"  width="11" height="26"/></td>
    </tr>
  </table>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="7" class="bgLeftMargin">&nbsp;</td>
      <td width="10" class="bgBox2Left">&nbsp;</td>
      <td width="*" class="dddddd" height="100%">
		<div class="scrollhead">
               <table border="0" cellspacing="1" cellpadding="0" class="cccccc" width="100%" table-layout="fixed">
                 <tr>
                   <td class="columnHead" width="15%">&nbsp;</td>
                   <td class="columnHead" width="17%">Currency</td>
                 </tr>
               </table>
             </div>
             <div style="overflow-y:scroll; height:270">
               <table border="0" cellspacing="1" cellpadding="0" class="cccccc" width="100%" >
                 <c:forEach var="cList" items='${popupForm.map.currencyList}'>
                   <tr class="rowWt">
                     <td width="15%" class="columnData">
						<a href="#" onclick="returnValuesToParentModalWindow(new Array('<c:out value="${cList}"/>'),document.forms[0])" ><xenos:img srcKey="inf.image.icon.iconselect"  border="0"/></a>					 
                     <td width="17%" class="columnData"><c:out value="${cList}"/></td></td>
                   </tr>
                 </c:forEach>
               </table>
             </div>
		<td width="11" class="bgBox2Right">&nbsp;</td>
    </tr>
  </table>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="7" class="bgLeftMargin"><xenos:img srcKey="inf.image.spacer"  width="7" height="15"/></td>
      <td width="10"><xenos:img srcKey="inf.image.box2leftbottom"  width="10" height="15"/></td>
      <td width="*" class="bgBox2Bottom"><xenos:img srcKey="inf.image.spacer"  width="7" height="15"/></td>
      <td width="11"><xenos:img srcKey="inf.image.box2rightbottom"  width="11" height="15"/></td>
    </tr>
  </table>
<form action="popupAction.action?method=initCurrency" method="post"  style="display:none">	 
		 <c:forEach var="target" items='${popupForm.map.targets}'>
		 <%--
			 <html:text name= "target" property="name"/>
			 <html:text name= "target" property="value"/>
		 --%>
			<html:text name= "target" property="key"/>
		 </c:forEach>
</form>

</body>