<cfset ev = application.EventManager.createEvent('getPods')/>
<cfset application.EventManager.dispatchEvent(event=ev) />
<cfset pods = ev.getItems() />
<cfoutput>
<cfloop array="#pods#" index="pod">
	<h3>#pod.title#</h3>
	<p>#pod.content#</p>
</cfloop>
</cfoutput>
