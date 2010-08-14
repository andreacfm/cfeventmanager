<?xml version="1.0" encoding="UTF-8"?>
<event-manager>
	
	<configs>

		<!-- Add any property
		<property name="out" value="file" />
		Are injected into init mode.
		-->

		<!-- 
			Class used to dispatch asynch events.
			Must Extend AbstractDispatcher and implement the abstract dispatch method.
		-->
		<config name="asynchDispatcher" value="com.andreacfm.cfem.dispatch.AsynchDispatcher"/>	
		
		<!-- 
			Class used to dispatch synch events.
			Must Extend AbstractDispatcher and implement the abstract dispatch method.
		-->		
		<config name="synchDispatcher" value="com.andreacfm.cfem.dispatch.SynchDispatcher"/>		
		
		<!-- 
			Base Event Class used if no other type specified.
			Extends AbstractEvent and implement the init abstract method.
		-->		
		<config name="defaultBaseEventClass" value="com.andreacfm.cfem.events.Event"/>

		<!-- 
			Default Listener Class
		-->		
		<config name="defaultBaseListenerClass" value="com.andreacfm.cfem.listener.Listener"/>
		
		<!-- Event Interceptions Flows -->
		<config name="eventInterceptionsPoints" value="before,each,after"/>		
		
		<!-- Class used to create event interceptions -->
		<config name="defaultInterceptionClass" value="com.andreacfm.cfem.events.EventInterception"/>

		<!-- Cache Adapter -->
		<config name="cacheAdapter" value="com.andreacfm.cfem.caching.BasicCacheAdapter"/>

		<!-- defaultLoggerClass -->
		<config name="logging">
			<property name="logboxConfigPath" value="/com/andreacfm/cfem/config/logbox.xml.cfm" />				
		</config>
		
	</configs>	
	
	<actions>			

		<action name="stop" class="com.andreacfm.cfem.events.actions.Stop"/>
		
		<action name="throw" class="com.andreacfm.cfem.events.actions.Throw"/>
		
		<action name="dispatch" class="com.andreacfm.cfem.events.actions.Dispatch"/>
		
	</actions>
	
</event-manager>	