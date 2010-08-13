<cfcomponent 
		extends="com.andreacfm.cfem.events.actions.AbstractAction" 
		output="false"
		accessors="true">

	<cfset variables.name = 'Dispatch' />
	
	<!---   Constructor --->
    <cffunction name="init" output="false"returntype="com.andreacfm.cfem.events.actions.AbstractAction" >
		<cfargument name="event" required="true" type="string"/>
		<cfargument name="persists" required="false" type="boolean" default="false"/>
		<cfargument name="mode" required="false" type="string" default="synch"/>		
		<cfargument name="data" required="false" type="any" default="{}"/>	
								
		<cfset setEvent(arguments.event)/>
		<cfset setPersists(arguments.persists)/>	
		<cfset setMode(arguments.mode)/>
		<cfset setData(arguments.data) />	
		
	    <cfreturn this/>
    </cffunction>
	
   <!---Event--->
   <cffunction name="setEvent" output="false" access="public" returntype="void">
    	<cfargument name="Event" required="true" type="string"/>
		<cfset variables.Event = arguments.Event />
    </cffunction>
   <cffunction name="getEvent" output="false" access="public" returntype="string">
    	<cfreturn variables.Event />
    </cffunction>
	
   <!---persist--->
   <cffunction name="setpersists" output="false" access="public" returntype="void">
    	<cfargument name="persists" required="true" type="boolean"/>
		<cfset variables.persists = arguments.persists />
    </cffunction>
    <cffunction name="eventPersists" output="false" access="public" returntype="boolean">
    	<cfreturn variables.persists />
    </cffunction>
	
	<!---Mode--->
    <cffunction name="setMode" output="false" access="public" returntype="void">
    	<cfargument name="mode" required="true" type="string"/>
		<cfset variables.mode = arguments.mode />
    </cffunction>	
    <cffunction name="getMode" output="false" access="public" returntype="string">
    	<cfreturn variables.mode />
    </cffunction>
	
	<!---setData--->
   <cffunction name="setData" output="false" access="public" returntype="void">
    	<cfargument name="data" required="true" type="any"/>
		<cfset variables.data = arguments.data />
    </cffunction>
   <cffunction name="getData" output="false" access="public" returntype="struct">
    	<cfif isSimpleValue(variables.data)>
 			<cfreturn deserializeJSON(variables.data) />
		</cfif>
    	<cfreturn variables.data/>
    </cffunction>
	
	<!---execute--->
    <cffunction name="execute" output="false" returntype="void">
    	<cfargument name="event" type="com.andreacfm.cfem.events.AbstractEvent" required="true"/>   	
		<cfset var eventManager = event.getEM() />
		
		<cfif eventPersists() and arguments.event.getMode() eq 'asynch'>
			<cfthrow type="com.andreacfm.cfem.ActionExeption" message="Cannot persists an event thrown in asynch mode" />
		</cfif>

		<cfif eventPersists()>
			<cfset com.andreacfm.cfem.dispatchEvent(getEvent(),arguments.event.getData(),this,getMode()) />			
		<cfelse>
			<cfset com.andreacfm.cfem.dispatchEvent(getEvent(),getData(),this,getMode()) />				
		</cfif>		
		
    </cffunction>

</cfcomponent>