<cfcomponent extends="com.andreacfm.cfem.events.actions.AbstractAction" output="false">
	
	<cfset variables.instance.name = 'Throw' />
	
	<!---   Constructor --->
    <cffunction name="init" output="false"  returntype="com.andreacfm.cfem.events.actions.AbstractAction" >
		<cfargument name="type" required="false" type="String" default="" />
		<cfargument name="message" required="false" type="String" default="" />
		<cfset variables.instance.type = type/>
		<cfset variables.instance.message = message/>				
	    <cfreturn this/>
    </cffunction>

	<!--- PRIVATE -------------------------------------------------------------------------->

    <!---   type   --->
	<cffunction name="gettype" access="private" output="false" returntype="string">
		<cfreturn variables.instance.type/>
	</cffunction>
			
    <!---   message   --->
	<cffunction name="getmessage" access="private" output="false" returntype="string">
		<cfreturn variables.instance.message/>
	</cffunction>

	<!--- PUBLIC -------------------------------------------------------------------------->
	
	<!---execute--->
    <cffunction name="execute" output="false" returntype="void">
    	<cfargument name="event" type="com.andreacfm.cfem.events.Event" required="true"/>
		   	
		<cfthrow type="#getType()#" message="#getMessage()#" />
		
    </cffunction>

			
</cfcomponent>