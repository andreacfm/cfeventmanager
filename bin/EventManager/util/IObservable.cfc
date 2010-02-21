<!--- /*		
Project:     Cf Event Manager  http://code.google.com/p/cfeventmanager/
Author:      Andrea Campolonghi <andrea@getrailo.org>
Version:     1.0.2
Build Date:  domenica feb 21, 2010
Build:		 121

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

<cfinterface>

	<cffunction name="notifyObservers" access="public">

	</cffunction>

	<cffunction name="registerObserver" access="public">
		<cfargument name="observer" type="EventManager.util.IObserver"/>
		
	</cffunction>
	
</cfinterface>