<!--- /*		
Project:     Cf Event Manager  http://code.google.com/p/cfeventmanager/
Author:      Andrea Campolonghi <andrea@getrailo.org>
Version:     1.0.3
Build Date:  Wednesday Mar 24, 2010
Build:		 140

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

<cfcomponent output="false">

	<cfset variables.instance.name = '' />
	
    <!---   Constructor --->
    <cffunction name="init" output="false"  returntype="EventManager.events.actions.AbstractAction" >
	    <cfreturn this/>
    </cffunction>

	<!---execute--->
	<cffunction name="execute" output="false" returntype="void">
		<cfargument name="event" type="EventManager.events.Event" required="true"/>
		<cfthrow type="EventManager.AbstractMethod" message="Method execute is abstract and must be implemented" />
	</cffunction>
	
	<!---getName--->
    <cffunction name="getName" output="false" access="public" returntype="string">
    	<cfreturn variables.instance.name />
    </cffunction>
		
</cfcomponent>