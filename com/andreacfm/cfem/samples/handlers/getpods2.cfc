<cfcomponent>

	<cffunction name="init" returntype="com.andreacfm.cfem.samples.handlers.getpods2">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getPods" access="public" returntype="void" output="false">     
		<cfargument name="event" type="com.andreacfm.cfem.events.AbstractEvent" />
		
		<cfset var myPods = [
			{title = 'Personal',content = 'My Personal Pod'},
			{title = 'Search', content = 'Search Pod'} 
		] />
		
		<cfloop array="#myPods#" index="pod">
			<cfset event.addItem(pod) />		
		</cfloop>
		
	
	</cffunction>

</cfcomponent>