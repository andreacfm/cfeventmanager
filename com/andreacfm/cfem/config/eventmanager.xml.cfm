<?xml version="1.0" encoding="UTF-8"?>
<!-- 
Project:     Cf Event Manager  http://code.google.com/p/cfeventmanager/
Author:      Andrea Campolonghi <andrea@getrailo.org>
Version:     1.0.3
Build Date:  domenica mar 14, 2010
Build:		 126

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
		<config name="asynchDispatcher">com.andreacfm.cfem.dispatch.AsynchDispatcher</config>	
		
		<!-- 
			Class used to dispatch synch events.
			Must Extend AbstractDispatcher and implement the abstract dispatch method.
		-->		
		<config name="synchDispatcher">com.andreacfm.cfem.dispatch.SynchDispatcher</config>		
		
		<!-- 
			Base Event Class used if no other type specified.
			Extends AbstractEvent and implement the init abstract method.
		-->		
		<config name="defaultBaseEventClass">com.andreacfm.cfem.events.Event</config>

		<!-- 
			Default Listener Class
		-->		
		<config name="defaultBaseListenerClass">com.andreacfm.cfem.listener.Listener</config>
		
		<!-- Event Interceptions Flows -->
		<config name="eventInterceptionsPoints">before,each,after</config>		
		
		<!-- Class used to create event interceptions -->
		<config name="defaultInterceptionClass">com.andreacfm.cfem.events.EventInterception</config>

		<!-- Cache Adapter -->
		<config name="cacheAdapter">com.andreacfm.cfem.caching.BasicCacheAdapter</config>
	
	</configs>	
	
	<actions>			

		<action name="stop" class="com.andreacfm.cfem.events.actions.Stop"/>
		
		<action name="throw" class="com.andreacfm.cfem.events.actions.Throw"/>
		
		<action name="dispatch" class="com.andreacfm.cfem.events.actions.Dispatch"/>
		
	</actions>
	
</event-manager>	