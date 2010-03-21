<cfcomponent output="false">
	
	<!---init--->
	<cffunction name="init" output="false" returntype="any">
		<cfreturn this/>
	</cffunction>

	<cffunction name="addItem" output="false" access="public" returntype="void">
		<cfargument name="event" type="EventManager.events.AbstractEvent" />
		
		<cfset sleep(1000) />
		
		<cfloop from="1" to="100" index="i">
			<cfset event.addItem(i) />
		</cfloop>
			
	</cffunction>

</cfcomponent>