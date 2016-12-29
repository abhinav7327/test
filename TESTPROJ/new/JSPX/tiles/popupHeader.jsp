

<%

%>

<%@ include file="/WEB-INF/tiles/popupPageHeader.jsp"%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
		<td background="<%=request.getContextPath()%>/images/stripes.gif" align="right" width="*">&nbsp;</td>
		<td id="modalcell" bgcolor="white" width="100" align="center" style="display:none"><a href="javascript:void()" onclick="printWindow()"><img src="<%=request.getContextPath()%>/images/print_16.gif" border="0" title="Print"></a></td>
  </tr>
</table>
<logic:messagesPresent>
<bean:message key="inf.errors.header"/>
	<html:messages id="message" >
		<bean:message key="inf.errors.prefix"/><c:out value="${message}"  escapeXml="false"/><bean:message key="inf.errors.suffix"/>
	</html:messages>
<bean:message key="inf.errors.footer"/>
</logic:messagesPresent>
<script>
	if(top.location==self.location){
		document.getElementById('modalcell').style.display="block";
	}
</script>
<%@ include file="/WEB-INF/tiles/formHeader.jsp"%>
