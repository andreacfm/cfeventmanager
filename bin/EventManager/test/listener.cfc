<cfcomponent output="false">
	
	<!---init--->
	<cffunction name="init" output="false" returntype="any">
		<cfreturn this/>
	</cffunction>

	<cffunction name="addItem" output="false" access="private" returntype="void">
		<cfargument name="event" type="EventManager.events.AbstractEvent" />
		<cfset var item1 = arrayNew(1) />
		<cfset event.storeItem(item1) />
	</cffunction>

	<cffunction name="ResetItems" output="false" access="private" returntype="void">
		<cfargument name="event" type="EventManager.events.AbstractEvent" />
		<cfset event.resetItems() />
	</cffunction>

</cfcomponent>