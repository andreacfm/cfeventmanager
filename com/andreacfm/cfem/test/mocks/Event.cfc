<cfcomponent output="false" extends="com.andreacfm.cfem.events.Event">
	
	<cfset variables.items = arraynew(1) />	

	<cffunction name="addItem" output="false" access="private" returntype="void">
		<cfargument name="items" type="any" />
		<cfset arrayAppend(variables.items,item)/>
	</cffunction>

	<cffunction name="ResetItems" output="false" access="private" returntype="void">
		<cfset arrayClear(variables.items) />
	</cffunction>

</cfcomponent>