<cfcomponent>

	<cffunction name="init" returntype="com.andreacfm.cfem.samples.handlers.getpods">
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getPods" access="public" returntype="void" output="false">     
		<cfargument name="event" type="com.andreacfm.cfem.events.AbstractEvent" />
		
		<cfset var myPods = [
			{title = 'Advertise',content = 'Google Ads'},
			{title = 'Links', content = 'html with my links'} 
		] />
		
		<cfloop array="#myPods#" index="pod">
			<cfset event.addItem(pod) />		
		</cfloop>
		
	
	</cffunction>

</cfcomponent>