<cfcomponent output="false">

	<cfset variables.name = '' />
	
    <!---   Constructor --->
    <cffunction name="init" output="false"  returntype="com.andreacfm.cfem.events.actions.AbstractAction" >
	    <cfreturn this/>
    </cffunction>

	<!---execute--->
	<cffunction name="execute" output="false" returntype="void">
		<cfargument name="event" type="com.andreacfm.cfem.events.Event" required="true"/>
		<cfthrow type="com.andreacfm.cfem.AbstractMethod" message="Method execute is abstract and must be implemented" />
	</cffunction>
	
	<!---getName--->
    <cffunction name="getName" output="false" access="public" returntype="string">
    	<cfreturn variables.name />
    </cffunction>
		
</cfcomponent>