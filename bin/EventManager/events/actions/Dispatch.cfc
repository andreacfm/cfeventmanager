<!--- /*		
Project:     Cf Event Manager  http://code.google.com/p/cfeventmanager/
Author:      Andrea Campolonghi <andrea@getrailo.org>
Version:     1.0.3
Build Date:  Monday Apr 05, 2010
Build:		 155

Copyright 2010 Andrea Campolonghi

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.	
			
*/--->

<cfcomponent extends="EventManager.events.actions.AbstractAction" output="false">
	
	<cfset variables.instance.name = 'Dispatch' />
	
	<!---   Constructor --->
    <cffunction name="init" output="false"returntype="EventManager.events.actions.AbstractAction" >
		<cfargument name="event" required="true" type="string"/>
		<cfargument name="alias" required="false" type="boolean" default="false"/>
		<cfargument name="mode" required="false" type="string" default="synch"/>		
		<cfargument name="data" required="false" type="any" default="{}"/>	
								
		<cfset setEventName(arguments.event)/>
		<cfset setAlias(arguments.alias)/>	
		<cfset setMode(arguments.mode)/>
		<cfset setData(arguments.data) />	
		
	    <cfreturn this/>
    </cffunction>
	
   <!---EventName--->
   <cffunction name="setEventName" output="false" access="public" returntype="void">
    	<cfargument name="eventName" required="true" type="string"/>
		<cfset variables.instance.eventName = arguments.eventName />
    </cffunction>
   <cffunction name="getEventName" output="false" access="public" returntype="string">
    	<cfreturn variables.instance.eventName />
    </cffunction>
	
   <!---Alias--->
   <cffunction name="setAlias" output="false" access="public" returntype="void">
    	<cfargument name="alias" required="true" type="boolean"/>
		<cfset variables.instance.alias = arguments.alias />
    </cffunction>
    <cffunction name="getAlias" output="false" access="public" returntype="boolean">
    	<cfreturn variables.instance.alias />
    </cffunction>
	
	<!---Mode--->
   <cffunction name="setMode" output="false" access="public" returntype="void">
    	<cfargument name="mode" required="true" type="string"/>
		<cfset variables.instance.mode = arguments.mode />
    </cffunction>	
    <cffunction name="getMode" output="false" access="public" returntype="string">
    	<cfreturn variables.instance.mode />
    </cffunction>
	
	<!---setData--->
   <cffunction name="setData" output="false" access="public" returntype="void">
    	<cfargument name="data" required="true" type="any"/>
		<cfset variables.instance.data = arguments.data />
    </cffunction>
   <cffunction name="getData" output="false" access="public" returntype="struct">
    	<cfif isSimpleValue(variables.instance.data)>
 			<cfreturn deserializeJSON(variables.instance.data) />
		</cfif>
    	<cfreturn variables.instance.data/>
    </cffunction>
	
	<!---execute--->
    <cffunction name="execute" output="false" returntype="void">
    	<cfargument name="event" type="EventManager.events.Event" required="true"/>   	
		<cfset var eventManager = event.getEM() />
		
		<cfif getAlias() and arguments.event.getMode() eq 'asynch'>
			<cfthrow type="EventManager.ActionExeption" message="Cannot alias an event thrown in asynch mode" />
		</cfif>

		<cfif getAlias()>
			<cfset eventManager.dispatchEvent(getEventName(),arguments.event.getData(),this,getMode()) />			
		<cfelse>
			<cfset eventManager.dispatchEvent(getEventName(),getData(),this,getMode()) />				
		</cfif>		
		
    </cffunction>

</cfcomponent>