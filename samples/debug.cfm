<cfparam name="url.action" default="" />
<cfif url.action eq 'clear'>
	<cfset application.EventManager.clearDebug() />	
</cfif>
<cfoutput>#application.EventManager.renderDebug()#</cfoutput>