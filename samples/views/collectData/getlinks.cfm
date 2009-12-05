<cfset ev = application.EventManager.createEvent('getLinks')/>
<cftry>
	<cfset application.EventManager.dispatchEvent(event=ev) />	
	<cfset links = ev.getItems() />
	<cfcatch type="ValidateLinkExeception">
		<cfset links = [{href = "",text = cfcatch.message}] />	
	</cfcatch>
</cftry>
	
<cfset data = ev.getData() />
<cfoutput>
<h3>My Links</h3>
	<ul>
	<cfloop array="#links#" index="link">
		<li>
			<a href="#link.href#">#link.text#</a>
		</li>	
	</cfloop>
	</ul>
	<cfif structKeyExists(data,'msg')>
		<strong>#data.msg#</strong>
	</cfif>
</cfoutput>
