<!-- saved from url=(0022)http://internet.e-mail -->


<%

%>


<%
/********************************************************************
 *  Xenos Root Defination on Master Layout 
 *
*********************************************************************/
%> 
<tiles:definition id="rootDefinition" page="/WEB-INF/layouts/xenosLayout.jsp" scope="request">
	<tiles:put name="body" value="" />
</tiles:definition>



<%
/********************************************************************
 *  Xenos welcome  Defination on welCome Layout 
 *
*********************************************************************/
%> 
<tiles:definition id="welcomeDefinition"  page="/WEB-INF/layouts/welcomeLayout.jsp">
	<tiles:put name="body" value="/WEB-INF/modules/inf/pages/welcomeBody.jsp"/>	
</tiles:definition>

<%
/********************************************************************
 *  Xenos Query  Defination on xenosQueryLayout  
 *
*********************************************************************/
%> 
<tiles:definition id="queryDefinition"  page="/WEB-INF/layouts/xenosQueryLayout.jsp">	
	<tiles:put name="queryBody" value="" />
</tiles:definition>

<%
/********************************************************************
 *  Xenos Form  Defination on xenosFormLayout  
 *
*********************************************************************/
%> 
<tiles:definition id="formDefinition"  page="/WEB-INF/layouts/xenosFormLayout.jsp">	
	<tiles:put name="formBody" value="" />
</tiles:definition>


<%
/********************************************************************
 *  Xenos Framed Form  Defination on xenosFormLayout  
 *
*********************************************************************/
%> 
<tiles:definition id="framedFormDefinition"  page="/WEB-INF/layouts/xenosFrameLayout.jsp">	
	<tiles:put name="frameBody" value="" />
</tiles:definition>