



<c:if test="${limitExceeded == 'true'}">
	<display:footer>
		<tr><td colspan=100><center><span class="columnDataRedBold">Query result is truncated as it exceeds the maximum permissible limit.</span></center></td></tr>
	</display:footer>
</c:if>