<cfcomponent extends="com.andreacfm.cfem.events.actions.AbstractAction" output="false">
	
	<cfset variables.name = 'Stop' />
	
	<!---execute--->
    <cffunction name="execute" output="false" returntype="void">
    	<cfargument name="event" type="com.andreacfm.cfem.events.Event" required="true"/>   	
		<cfset event.stopPropagation() />
    </cffunction>

</cfcomponent>