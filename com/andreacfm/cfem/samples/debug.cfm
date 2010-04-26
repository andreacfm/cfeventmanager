<cfparam name="url.action" default="" />
<cfif url.action eq 'clear'>
	<cfset application.com.andreacfm.cfem.clearDebug() />	
</cfif>
<cfoutput>#application.com.andreacfm.cfem.renderDebug()#</cfoutput>