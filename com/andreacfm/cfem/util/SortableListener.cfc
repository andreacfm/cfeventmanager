<cfcomponent displayname="SortableListener" extends="AbstractSortable" output="false" hint="">
 
	<cffunction name="LT" access="public" returntype="boolean" output="false">
		<cfargument name="Comparable" type="any" required="true"/>
		
		<cfset var a = VARIABLES.Target.getPriority()>
		<cfset var b = ARGUMENTS.Comparable.getPriority()>		
		<cfset var res = a LT b >
 
		<cfreturn res />
			
	</cffunction>
 
</cfcomponent>