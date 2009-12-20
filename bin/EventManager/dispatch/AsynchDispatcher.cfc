<!--- /*		
Project:     Cf Event Manager  http://code.google.com/p/cfeventmanager/
Author:      Andrea Campolonghi <andrea@getrailo.org>
Version:     1.0.1.1
Build Date:  domenica dic 20, 2009
Build:		 114

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

<cfcomponent name="AsynchDispatcher" extends="EventManager.dispatch.Dispatcher">
	
	<cffunction name="dispatch" returntype="void" output="false">
		<cfthread name="#local.event.getEventId()#-#randRange(1,1000000)#" action="run" obj="this">	
			<cfscript>
				attributes.obj.dispatch();
			</cfscript>				
		</cfthread>		
	</cffunction>

</cfcomponent>