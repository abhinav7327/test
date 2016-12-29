



</div> <!-- end of xenosPage-->
<div id="loading" style="display:none">
	<table cellspacing="0" border="0" cellpadding="0" width="826" >
  <tr >
	 <td class="dataWt" align="center">Page Loading in Progress... Please Wait.</td>
  </tr>
</table>
</div>

<!--  Populate the screen attributes and log the screen access information   -->

<jsp:useBean id="sa" class="com.nri.xenos.ref.web.base.AccessLogWriter" scope="request">
	<jsp:setProperty name="sa" property="logAccess" value="<%=request%>"/>
</jsp:useBean>
<%--
<script>
function updateTopFrame()
{
	top.topFrame.userid.innerHTML='<c:out value="${sa.userId}"/>';
	top.topFrame.screenid.innerHTML='';
	top.topFrame.appdate.innerHTML='';
	
	<c:if test="${sa.screenId != ''}">
		top.topFrame.screenid.innerHTML=': <c:out value="${sa.screenId}"/>';
		<c:if test="${sa.applicationDate != ''}">
			top.topFrame.appdate.innerHTML='<c:out value=": ${sa.applicationDate}"/>';
		</c:if>
	</c:if>
	<c:if test="${sa.screenId == ''}">
		<c:if test="${sa.applicationDate != ''}">
			top.topFrame.appdate.innerHTML='<c:out value=": ${sa.applicationDate}"/>';
		</c:if>
	</c:if>	
}
</script>
--%>
</body>
</html>
