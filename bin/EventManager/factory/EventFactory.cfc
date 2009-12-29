<!--- /*		
Project:     Cf Event Manager  http://code.google.com/p/cfeventmanager/
Author:      Andrea Campolonghi <andrea@getrailo.org>
Version:     1.0.1.1
Build Date:  martedì dic 29, 2009
Build:		 115

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
			
*/--->

<cfcomponent output="false" extends="EventManager.factory.AbstractFactory">

	<!---create--->
	<cffunction name="create" output="false" returntype="EventManager.events.AbstractEvent">
		<cfargument name="name" required="true" type="string"/>
		<cfargument name="data" required="false" type="struct" default="#structNew()#"/>		
		<cfargument name="target" required="false" type="any" default="" />
		<cfargument name="mode" required="false" type="string" default="synch" />
		<cfscript>
		var local = structNew();	
		local.event = getEventManager().getEvent(arguments.name);
		arguments.type = local.event.type;
		local.newInstance = createObject('component','#arguments.type#').init(argumentCollection=arguments);
		local.newInstance.setEM(getEventManager());
		if(arrayLen(local.event.interceptions) gt 0){
			local.it = local.event.interceptions.iterator();
			while(local.it.hasNext()){
				local.newInstance.registerObserver(local.it.next());
			}
		}	
		if(autowire()){
			getEventManager().getBeanInjector().autowire(local.newInstance);		
		}	
		return local.newInstance;
		</cfscript>
	</cffunction>

	

	

</cfcomponent>