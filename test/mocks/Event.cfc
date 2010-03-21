<cfcomponent output="false" extends="EventManager.events.Event">
	
	<cfset variables.instance.items = arraynew(1) />	

	<cffunction name="addItem" output="false" access="private" returntype="void">
		<cfargument name="items" type="any" />
		<cfset arrayAppend(variables.instance.items,item)/>
	</cffunction>

	<cffunction name="ResetItems" output="false" access="private" returntype="void">
		<cfset arrayClear(variables.instance.items) />
	</cffunction>

</cfcomponent>