<!--- /*		
Project:     Cf Event Manager  http://code.google.com/p/cfeventmanager/
Author:      Andrea Campolonghi <andrea@getrailo.org>
Version:     1.0.2
Build Date:  sabato feb 27, 2010
Build:		 122

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

<cfcomponent>
	
	<cfset variables.instance.factories = {} />
	
	<!---init--->
    <cffunction name="init" output="false" access="public" returntype="EventManager.factory.Factory">
    	<cfreturn this />
    </cffunction>
	
	<!---addFactory--->
    <cffunction name="addFactory" output="false" access="public" returntype="void">
    	<cfargument name="factoryName" required="true" type="string" />
		<cfargument name="factory" required="true" type="EventManager.factory.AbstractFactory" />
		
		<cfset variables.instance.factories[arguments.factoryName] = arguments.factory />
		
    </cffunction>

	<!---getFactory--->
    <cffunction name="getFactory" output="false" access="public" returntype="EventManager.factory.AbstractFactory">
    	<cfargument name="factoryName" required="true" type="string" />
    	<cfreturn variables.instance.factories[arguments.factoryName] />
    </cffunction>
	
	<!---createEvent--->
    <cffunction name="createEvent" output="false" access="public" returntype="EventManager.events.AbstractEvent">
    	<cfreturn getFactory('EventFactory').create(argumentCollection=arguments)/>
    </cffunction>
	
	<!---createDispatcher--->
    <cffunction name="createDispatcher" output="false" access="public" returntype="EventManager.dispatch.Dispatcher">
    	<cfreturn getFactory('DispatcherFactory').create(argumentCollection=arguments)/>
    </cffunction>
	
	<!---createAction--->
    <cffunction name="createAction" output="false" access="public" returntype="EventManager.events.actions.AbstractAction">
    	<cfreturn getFactory('ActionFactory').create(argumentCollection=arguments)/>
    </cffunction>
	
	<!---createInterception--->
    <cffunction name="createInterception" output="false" access="public" returntype="EventManager.events.AbstractEventInterception">
    	<cfreturn getFactory('InterceptionFactory').create(argumentCollection=arguments)/>
    </cffunction>

</cfcomponent>