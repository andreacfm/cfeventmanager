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

	<!--- create --->
	<cffunction name="create" output="false" returntype="EventManager.dispatch.Dispatcher">
		<cfargument name="event" required="false" type="EventManager.events.AbstractEvent"/>
		<cfscript>
		var result = "";
		if(arguments.event.getMode() eq 'asynch'){
			result = createObject('component','#getEventManager().getConfig('AsynchDispatcher')#').init(getEventManager(),arguments.event);
		}else{
			result = createObject('component','#getEventManager().getConfig('SynchDispatcher')#').init(getEventManager(),arguments.event);		
		}
		if(autowire()){
			getEventManager().getBeanInjector().autowire(result);		
		}	
		return result;
		</cfscript>
	</cffunction>

	
</cfcomponent>