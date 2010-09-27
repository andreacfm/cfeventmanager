<cfcomponent displayname="AbstractSortable" output="false" hint="Defines the interface and base methods for a sortable object.">

	<cfscript>
		// Set the target object to which other objects will be compared.
		VARIABLES.Target = "";
	</cfscript>
 
	<cffunction name="Init" access="public" returntype="any" output="false" hint="Returns an initialized AbstractSortable instance.">
 
		<!--- Define arguments. --->
		<cfargument name="Target" type="any" required="false" default="" />
 
		<!--- Store the arguments. --->
		<cfset VARIABLES.Target = ARGUMENTS.Target />
 
		<!--- Return This reference. --->
		<cfreturn THIS />
	</cffunction>
 
	<cffunction name="SetTarget" access="public" returntype="void" output="false" hint="Sets the new target object.">
		<!--- Define arguments. --->
		<cfargument name="Target" type="any" required="true" />
		<!--- Store the arguments. --->
		<cfset VARIABLES.Target = ARGUMENTS.Target />
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
	<cffunction name="SortArray" access="public" returntype="array" output="false" hint="Sorts an array using this sortable instance.">
		<!--- Define arguments. --->
		<cfargument name="Data" type="array" required="true" />
		<cfargument name="Method" type="string" required="true" />
 
		<!--- Define the local scope. --->
		<cfset var LOCAL = StructNew() />
 
		<!--- Perform a bubble sort. --->
		<cfloop index="LOCAL.OuterIndex" from="1" to="#(ArrayLen( ARGUMENTS.Data ) - 1)#" step="1">
 
			<cfloop index="LOCAL.InnerIndex" from="1" to="#(ArrayLen( ARGUMENTS.Data ) - LOCAL.OuterIndex)#" step="1">
 
				<!--- Set the target to which we will comapre objects. --->
				<cfset THIS.SetTarget( ARGUMENTS.Data[ LOCAL.InnerIndex ] ) />
 
				<cfinvoke component="#this#" method="#arguments.method #" returnvariable="res"> 
					<cfinvokeargument name="comparable" value="#ARGUMENTS.Data[ LOCAL.InnerIndex + 1 ]#"> 
				</cfinvoke> 
 
			</cfloop>
 
		</cfloop>
 
 
		<!--- Return the updated array. --->
		<cfreturn ARGUMENTS.Data />
	</cffunction>
 
	<cffunction name="$LT" access="public" returntype="boolean" output="false"
		hint="Determins if this object is less than the passed in object.">
	</cffunction>
 
	<cffunction name="$LTE" access="public" returntype="boolean" output="false"
		hint="Determins if this object is less than or equal to the passed in object.">
	</cffunction>
 
	<cffunction name="$EQ" access="public" returntype="boolean" output="false"
		hint="Determins if this object is equal to the passed in object.">
	</cffunction>
 
	<cffunction name="$GTE" access="public" returntype="boolean" output="false"
		hint="Determins if this object is greater than or equal to the passed in object.">
	</cffunction>
 
	<cffunction name="$GT" access="public" returntype="boolean" output="false"
		hint="Determins if this object is greater than the passed in object.">
	</cffunction>
 
</cfcomponent>