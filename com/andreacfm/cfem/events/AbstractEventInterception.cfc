<cfcomponent extends="com.andreacfm.cfem.util.IObserver" output="false">
	
	<cfset variables.actions = createObject('java','java.util.ArrayList').init()/>

	<!---init--->
    <cffunction name="init" output="false" returntype="com.andreacfm.cfem.events.AbstractEventInterception">
    	<cfargument name="eventManager" required="true" type="com.andreacfm.cfem.eventManager"/>
    	<cfargument name="point" required="true" type="string"/>
		<cfargument name="condition" required="false" type="string" default="true"/>
		
		<cfset setEventManager(arguments.eventManager)/>
		<cfset setpoint(arguments.point) />
		<cfset setCondition(arguments.condition)/>
		
		<cfreturn this />
    </cffunction>

	<!--- PUBLIC ------------------------------------------------------------------------------------------->
	
	<!---addAction--->
    <cffunction name="addAction" output="false" access="public" returntype="void">
    	<cfargument name="action" required="true" type="com.andreacfm.cfem.events.actions.AbstractAction" />
    	<cfset variables.actions.add(action) />
    </cffunction>

	<!---addActions--->
    <cffunction name="addActions" output="false" access="public" returntype="void">
    	<cfargument name="actions" required="true" type="Array" />
    	<cfset variables.actions.addAll(arguments.actions) />
    </cffunction>

	<!---execute--->
    <cffunction name="execute" output="false" access="public" returntype="void">
    	<cfargument name="event" type="com.andreacfm.cfem.events.AbstractEvent" required="true" />
    	<cfset var iterator = variables.actions.iterator() />
		<cfset var em = getEventManager() />
		<cfset var action = "" />
    	<cfloop condition="#iterator.hasNext()#">
    		<cfset action = iterator.next() />
 			<cfif em.islogging()>
				<cfset em.getLogger().debug("Event:#arguments.event.getname()# - Action #action.getName()#") />
			</cfif>       
			<cfset action.execute(arguments.event) />
		</cfloop>
    </cffunction>

	<!--- 
	hasActions
	 --->
	<cffunction name="hasActions" returntype="Boolean" output="false" access="public">
		<cfreturn javaCast("boolean",variables.actions.size()) />
	</cffunction>
			
    <!---   EventManager   --->
	<cffunction name="getEventManager" access="public" output="false" returntype="com.andreacfm.cfem.EventManager">
		<cfreturn variables.EventManager/>
	</cffunction>
	<cffunction name="setEventManager" access="public" output="false" returntype="void">
		<cfargument name="EventManager" type="com.andreacfm.cfem.EventManager" required="true"/>
		<cfset variables.EventManager = arguments.EventManager/>
	</cffunction>

    <!---   point   --->
	<cffunction name="getpoint" access="public" output="false" returntype="string">
		<cfreturn variables.point/>
	</cffunction>
	<cffunction name="setpoint" access="public" output="false" returntype="void">
		<cfargument name="point" type="string" required="true"/>
		<cfif listFind(getEventManager().getConfig('eventInterceptionsPoints'),arguments.point) eq 0>
			<cfthrow type="com.andreacfm.cfem.IllegalInterceptionPoint" message="point [#arguments.point#] is not valid. Add it to config xml file.">
		</cfif>
		<cfset variables.point = arguments.point/>
	</cffunction>	
	
    <!---   condition   --->
	<cffunction name="getcondition" access="public" output="false" returntype="string">
		<cfreturn variables.condition/>
	</cffunction>
	<cffunction name="setcondition" access="public" output="false" returntype="void">
		<cfargument name="condition" type="string" required="true"/>
		<cfset variables.condition = arguments.condition/>
	</cffunction>

	<!--- ABSTRACT UPDATE METHOD --->
	<cffunction name="update" access="public" returntype="void">
		<cfargument name="event" type="com.andreacfm.cfem.events.AbstractEvent" required="yes" />
		<cfthrow type="com.andreacfm.cfem.AbstractMethodException" message="Abstract method [update] has not been implemented" />
	</cffunction>

	<!---	isConditionTrue	--->
    <cffunction name="isConditionTrue" output="false" returntype="boolean" access="public">
    	<cfargument name="event" required="true" type="com.andreacfm.cfem.events.Event" />
		<cfset var result = "" />
		<cfset var debug = getEventManager().getDebug() />
		<cfset var tracer = "" />
		
		<cftry>
			<cfset result = evaluate(getCondition()) />			
			<cfcatch type="any">            
				<cfthrow type="com.andreacfm.cfem.ConditionEvaluationError" message="#cfcatch.message#" />
			</cfcatch>
		</cftry>

		<cfif not isBoolean(result)>
			<cfthrow type="com.andreacfm.cfem.IllegalConditionError" message="The evaluated condition is not a Boolean value."/>
		</cfif>

		<cfif debug>
			<cfset tracer =  getEventManager().getTracer() />
			<cfset tracer.trace('Condition','<ul><li>Evaluated : #getCondition()#</li><li>Result : #result#</li></ul>',arguments.event) />
		</cfif>
	   	<cfreturn result />
    </cffunction>
		
</cfcomponent>