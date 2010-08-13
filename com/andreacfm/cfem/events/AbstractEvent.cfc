<cfcomponent 
	name="AbstractEvent" 
	extends="com.andreacfm.cfem.util.IObservable"
	accessors="true">

	<cfproperty name="name" type="string"/>
	<cfproperty name="data" type="struct"/>
	<cfproperty name="target" type="any"/>
	<cfproperty name="isActive" type="boolean"/>
	<cfproperty name="type" type="string"/>
	<cfproperty name="mode" type="string"/>
	<cfproperty name="EM" type="com.andreacfm.cfem.EventManager"/>
	
	<cfscript>
	variables.state = true ;
	variables.point = "";
	variables.observers = createObject('java','java.util.ArrayList').init();
	</cfscript>
	
	<!---   constructor   --->
	<cffunction name="init" output="false" returntype="com.andreacfm.cfem.events.AbstractEvent">
		<cfthrow type="com.andreacfm.cfem.InitAbstractClassException" message="Abstract class [abstractEvent] cannot be initialized" />
	</cffunction>

	<!-----------------------------   public   ----------------------------------->
	
	<!---   name   --->
	<cffunction name="setName" access="public" output="false" returntype="void">
		<cfthrow type="com.andreacfm.cfem.AbstractEvent.NameCannotBeChanged" message="An event name cannot be changed at runtime.">
	</cffunction>

	<!---   target   --->
	<cffunction name="setTarget" access="public" output="false" returntype="void">
		<cfthrow type="com.andreacfm.cfem.AbstractEvent.TargetCannotBeChanged" message="The event target cannot be changed at runtime.">
	</cffunction>

	<!---   type   --->
	<cffunction name="setType" access="public" output="false" returntype="void">
		<cfthrow type="com.andreacfm.cfem.AbstractEvent.TypeCannotBeChanged" message="The event type cannot be changed at runtime.">
	</cffunction>

	<!---   mode   --->
	<cffunction name="setMode" access="public" output="false" returntype="void">
		<cfthrow type="com.andreacfm.cfem.AbstractEvent.ModeCannotBeChanged" message="The event mode cannot be changed at runtime.">
	</cffunction>

	
	
	<!---   stopPropagation   --->
	<cffunction name="stopPropagation" access="public" output="false" returntype="void">
		<cfset variables.state = false />
	</cffunction>

	<!---   isActive   --->
	<cffunction name="isActive" access="public" output="false" returntype="boolean">
		<cfreturn variables.state />
	</cffunction>

	<!---getEventId--->
	<cffunction name="getEventId" returntype="string" output="false" hint="Return the identityHashCode of the java object underling the cfc instance.">
		<cfreturn createObject("java", "java.lang.System").identityHashCode(this)/>
	</cffunction>



	<!--- INTERCEPTIONS SUPPORT --->
	
	<!--- 
	isObserved
	 --->
	<cffunction name="isObserved" returntype="Boolean" output="false" access="public">
		<cfreturn javaCast("boolean",variables.observers.size()) />
	</cffunction>
	
	<!--- 
	getObservers
	 --->
	<cffunction name="getObservers" returntype="Array" output="false" access="public">
		<cfreturn variables.observers />
	</cffunction>
	
	<!---updatePoint--->
	<cffunction name="updatePoint" output="false" returntype="void">
		<cfargument name="point" type="String" />
		<cfset variables.point = arguments.point/>
		<cfset notifyObservers(this) />
	</cffunction>

	<!---getPoint--->
	<cffunction name="getPoint" returntype="string" output="false">
		<cfreturn variables.point />
	</cffunction>
	

	
	<!--- IMPLEMENT IOBSERVABLE --->
	<cffunction name="notifyObservers" output="false" access="public">
		<cfloop array="#getObservers()#" index="int">
			<cfif int.getPoint() eq getPoint()>
				<cfset int.update(this) />
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="registerObserver" output="false" access="public">
		<cfargument name="observer" type="com.andreacfm.cfem.util.IObserver"/>
		<cfset variables.observers.add(observer) />
	</cffunction>
	
</cfcomponent>