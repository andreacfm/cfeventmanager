<!--- /*		
Project:     Cf Event Manager  http://code.google.com/p/cfeventmanager/
Author:      Andrea Campolonghi <andrea@getrailo.org>
Version:     1.0.3
Build Date:  Sunday Apr 04, 2010
Build:		 147

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
<cfcomponent output="false" extends="EventManager.listener.AbstractListener">
	
	<!---   constructor   --->
	<cffunction name="init" output="false" returntype="EventManager.listener.AbstractListener">
		<cfargument name="listener" type="any" required="true"/>
		<cfargument name="event" type="String" required="true"/>
		<cfargument name="method" type="string" default="" />
		<cfargument name="priority" required="false" type="numeric" default="5"/>
		<cfargument name="id" type="string" default="" />
		<cfargument name="initMethod" type="string" default="init"/>
		<cfargument name="factory" type="EventManager.factory.AbstractFactory"/>
		
		<cfscript>
		setMethod(arguments.method, arguments.event);	
		setListenerObject(arguments.listener,arguments.initmethod);
		setId(arguments.id);
		setPriority(arguments.priority);
		setAutowire(arguments.factory.getAutowire());
		return this;
		</cfscript>
		
		
	</cffunction>
	
	
</cfcomponent>