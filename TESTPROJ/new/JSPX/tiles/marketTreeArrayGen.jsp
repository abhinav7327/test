



<%@ page import="com.nri.xenos.inf.*,com.nri.xenos.startup.Application,com.nri.xenos.ref.*" %>
<%@ page import="java.util.*,org.apache.commons.beanutils.DynaBean" %>
<script>
	
   var market = new Array();
   
  // alert(window.parent.document.getElementById('mktChache').innerHTML);
   if (window.parent.document.getElementById('mktChache')) {

        if (window.parent.document.getElementById('mktChache').innerHTML == "") {
            marketTreeGenerator ();
        }
    } else if (window.parent.document.getElementById('mktChache').innerHTML == "") {
            marketTreeGenerator ();
    }
   
//marketTreeGenerator();


/**
 * This API will create the array to be used by thin client for market tree 
 *
 */

function marketTreeGenerator () {
	
    //var market = new Array();
    <%
	List mparents = Application.getInstance()
							   .getContext()
							   .getModuleContext(Module.REF)
							   .getService(MarketAccessor.class) .getAllMarketsWithParents();
	//Collections.reverse(mparents);
	int midx = 0 ;
	for(Iterator it = mparents.iterator(); it.hasNext(); ){
		DynaBean db = (DynaBean)it.next();
		String mtext = (String)db.get("fin_inst_role_code"); 
		Long mtype   = (Long)db.get("fin_inst_role_pk");
		Long mparent = (Long)db.get("fin_inst_role_pk_parent"); 
        String mshortName = (String)db.get("short_name"); 
		// System.out.println(midx+"="+mtext+":"+mtype+":"+mparent+":"+mshortName);
		if(mparent == null)
		{
			mparent = new Long(0);
		}	
    %>
		market[<%=midx%>]=["<%=mtype%>","<%=mparent%>","<%=mtext%>","<%=mshortName%>"]	
    <%
		midx++;
	}	
    %>

}

</script>