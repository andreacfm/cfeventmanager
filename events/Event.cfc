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

<cfcomponent 
	output="false" 
	extends="AbstractEvent"
	hint="Basic event class implements the AbstractEvent interface and nothing more. Use it as safe base to build custom events on.">
	
	<!---   Implement Abstract Constructor   --->
	<cffunction name="init" output="false" returntype="EventManager.events.Event">
		<cfargument name="name" required="true" type="string"/>
		<cfargument name="data" required="true" type="struct"/>		
		<cfargument name="target" required="true" type="any"/>
		<cfargument name="mode" required="true" type="string"/>
		<cfargument name="type" required="true" type="string"/>
		<cfargument name="alias" required="false" type="string" default=""/>
		
		<cfscript>
		variables.instance.name = arguments.name;
		variables.instance.data = arguments.data;
		variables.instance.target = arguments.target;
		variables.instance.mode = arguments.mode;		
		variables.instance.type = arguments.type;
		variables.instance.alias = arguments.alias;
		</cfscript>
		
		<cfreturn this/>

	</cffunction>

</cfcomponent>