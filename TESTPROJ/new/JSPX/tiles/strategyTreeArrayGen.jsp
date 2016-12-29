


<%@ page import="com.nri.xenos.inf.*,com.nri.xenos.startup.Application,com.nri.xenos.ref.*" %>
<%@ page import="java.util.*,org.apache.commons.beanutils.DynaBean" %>
<script>
var strategy = new Array();
<%
	StrategyCodeAccessor strCodeAccessor = new StrategyCodeAccessor();
	List sparent = strCodeAccessor.getAllStrategyCodeWithParent();
	Collections.reverse(sparent);
	int sdx = 0 ;
	for(Iterator it = sparent.iterator(); it.hasNext(); ){
		DynaBean db = (DynaBean)it.next();
		Long scode   = (Long)db.get("strategy_pk");
		Long sparentpk = (Long)db.get("strategy_parent_pk"); 
		String stext = (String)db.get("strategy_code"); 
                String mshortName = (String)db.get("short_name"); 
                String mstatus = (String)db.get("status"); 
		if(sparentpk == null)
		{
			sparentpk =  new Long(0);
		}	
%>
		strategy[<%=sdx%>]=["<%=scode%>","<%=sparentpk%>","<%=stext%>","<%=mshortName%>","<%=mstatus%>"]
<%
		sdx++;
	}	
%>
</script>