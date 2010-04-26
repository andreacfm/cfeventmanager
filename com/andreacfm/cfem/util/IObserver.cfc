<cfcomponent name="IObserver">

	<cffunction name="update" access="public" returntype="void">
		<cfargument name="event" required="true" type="com.andreacfm.cfem.events.AbstractEvent" />
		<cfthrow type="com.andreacfm.cfem.AbstractMethodException" message="Abstract method [update] has not been implemented" />
	</cffunction>

</cfcomponent>