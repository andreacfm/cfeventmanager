<cfcomponent>

	<cffunction name="init" returntype="EventManager.samples.handlers.handler1">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getPods" access="public" returntype="void" output="false">     
		<cfargument name="event" type="EventManager.events.AbstractEvent" />
		
		<cfset myPods = [
			{title = 'Advertise',content = 'Google Ads'},
			{title = 'Links', content = 'html with my links'} 
		] />
		
		<cfloop array="#myPods#" index="pod">
			<cfset event.addItem(pod) />		
		</cfloop>
		
	
	</cffunction>

</cfcomponent>