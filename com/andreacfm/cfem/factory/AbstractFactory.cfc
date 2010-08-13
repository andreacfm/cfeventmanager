<cfcomponent>
	
	
	<!---init--->
    <cffunction name="init" output="false" access="public" returntype="com.andreacfm.cfem.factory.AbstractFactory">
    	<cfargument name="EventManager" type="com.andreacfm.cfem.EventManager" required="true" />
		<cfargument name="autowire" required="false" type="boolean" default="false"/>
		<cfset setEventManager(EventManager) />
		<cfset setAutowire(arguments.autowire) />
    	<cfreturn this />
    </cffunction>
	
	<!---create--->
    <cffunction name="create" output="false" access="public" returntype="any">
    	<cfthrow type="com.andreacfm.cfem.AbstractClassException" message="Abstract method [create] must be implemented"/>
    </cffunction>

	<!---   getEventManager   --->
	<cffunction name="getEventManager" access="public" output="false" returntype="com.andreacfm.cfem.EventManager">
		<cfreturn variables.EventManager/>
	</cffunction>
    
	<!---   setEventManager   --->
	<cffunction name="setEventManager" access="public" output="false" returntype="void">
		<cfargument name="EventManager" type="com.andreacfm.cfem.EventManager" required="true"/>
		<cfset variables.EventManager = arguments.EventManager/>
	</cffunction>
	
	
	<!--- autowire --->
 	<cffunction name="getautowire" access="public" output="false" returntype="boolean">
		<cfreturn variables.Autowire/>
	</cffunction>
	<cffunction name="setautowire" access="public" output="false" returntype="void">
		<cfargument name="autowire" type="boolean" required="true"/>
		<cfset variables.autowire = arguments.autowire/>
	</cffunction>

</cfcomponent>