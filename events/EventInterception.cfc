<!--- 
				
Project:     Cf Event Manager http://www.cfeventmanager.com
Author:      Andrea Campolonghi <acampolonghi@gmail.com>
Version:     1.0
Build Date:  2009/10/25 16:16
Build:		 25

Copyright 2009 Andrea Campolonghi

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.	
						
--->

<cfcomponent extends="EventManager.events.AbstractEventInterception" output="false">
	
	<cffunction name="update" access="public" returntype="void">
		<cfargument name="event" type="EventManager.events.AbstractEvent" required="yes" />
		
		<cfset var condition = getCondition() />
		
		<!--- we have a condition --->
		<cfif len(condition)>
			<cfif isConditionTrue(event)>
				<cfset runActions(event)/>
			</cfif>
		<cfelse>
			<cfset runActions(event) />	
		</cfif>
				
	</cffunction>
	
</cfcomponent>