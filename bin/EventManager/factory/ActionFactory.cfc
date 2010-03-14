<!--- /*		
Project:     Cf Event Manager  http://code.google.com/p/cfeventmanager/
Author:      Andrea Campolonghi <andrea@getrailo.org>
Version:     1.0.3
Build Date:  domenica mar 14, 2010
Build:		 123

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

<cfcomponent output="false" extends="EventManager.factory.AbstractFactory">
 
	<!--- createAction --->
	<cffunction name="create" output="false" returntype="EventManager.events.actions.AbstractAction">
		<cfargument name="name" required="true" type="string"/>
		<cfset var actions = getEventManager().getConfig('Actions') />
		<cfset var actionClass = "" />
		<cfset var result = "" />
		<cftry>
			<cfset actionClass = actions[name] />
			<cfcatch type="any">
				<cfthrow type="EventManager.NoSuchActionException" message="Action [#arguments.name#] is unknown or cannot be created.">            
			</cfcatch>
		</cftry>
		
		<cfset result = createObject('component',#actionClass#).init(argumentCollection=arguments) />
		
		<cfif autowire()>
			<cfset getEventManager().getBeanInjector().autowire(result) />
		</cfif>
		
		<cfreturn result />		
	</cffunction>

</cfcomponent>