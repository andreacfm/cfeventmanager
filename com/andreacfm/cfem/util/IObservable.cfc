<cfcomponent name="IObservable">

	<cffunction name="notifyObservers" access="public" output="false">
		<cfthrow type="com.andreacfm.cfem.AbstractMethodException" message="Abstract Method [notifyObservers] must be implemented" />	
	</cffunction>

	<cffunction name="registerObserver" access="public" output="false">
		<cfargument name="observer" type="com.andreacfm.cfem.util.IObserver"/>
		<cfthrow type="com.andreacfm.cfem.AbstractMethodException" message="Abstract Method [registerObserver] must be implemented" />	
	</cffunction>
	
</cfcomponent>