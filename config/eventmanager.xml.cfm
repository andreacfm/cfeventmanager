<?xml version="1.0" encoding="UTF-8"?>
<!-- 
@license			
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
	
	</configs>	
	
	<actions>			

		<action name="stop" class="EventManager.events.actions.Stop"/>
		
		<action name="throw" class="EventManager.events.actions.Throw"/>
		
		<action name="dispatch" class="EventManager.events.actions.Dispatch"/>
		
	</actions>
	
</event-manager>	