<?xml version="1.0" encoding="UTF-8"?>
<!-- 
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
			
-->
<event-manager>
	
	<configs>
		
		<!-- 
			Class used to dispatch asynch events.
			Must Extend AbstractDispatcher and implement the abstract dispatch method.
		-->
		<config name="asynchDispatcher">EventManager.dispatch.AsynchDispatcher</config>	
		
		<!-- 
			Class used to dispatch synch events.
			Must Extend AbstractDispatcher and implement the abstract dispatch method.
		-->		
		<config name="synchDispatcher">EventManager.dispatch.SynchDispatcher</config>		
		
		<!-- 
			Base Event Class used if no other type specified.
			Extends AbstractEvent and implement the init abstract method.
		-->		
		<config name="defaultBaseEventClass">EventManager.events.Event</config>
		
		<!-- Event Interceptions Flows -->
		<config name="eventInterceptionsPoints">before,each,after</config>		
		
		<!-- Class used to create event interceptions -->
		<config name="defaultInterceptionClass">EventManager.events.EventInterception</config>

		<!-- Cache Adapter -->
		<config name="cacheAdapter">EventManager.caching.BasicCacheAdapter</config>
	
	</configs>	
	
	<actions>			

		<action name="stop" class="EventManager.events.actions.Stop"/>
		
		<action name="throw" class="EventManager.events.actions.Throw"/>
		
		<action name="dispatch" class="EventManager.events.actions.Dispatch"/>
		
	</actions>
	
</event-manager>	