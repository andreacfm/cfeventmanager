<cfcomponent>

	<cffunction name="init" returntype="EventManager.samples.handlers.Handler2">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getPods" access="public" returntype="void" output="false">     
		<cfargument name="event" type="EventManager.events.AbstractEvent" />
		
		<cfset myPods = [
			{title = 'Search',content = 'Search Form'},
			{title = 'Categories', content = 'html with blog categories'} 
		] />
		
		<cfloop array="#myPods#" index="pod">
			<cfset event.addItem(pod) />		
		</cfloop>
		
	
	</cffunction>

</cfcomponent>