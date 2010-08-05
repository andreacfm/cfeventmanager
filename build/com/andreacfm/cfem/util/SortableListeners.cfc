<cfcomponent displayname="SortableListener" extends="AbstractSortable" output="false" hint="">
 
	<cffunction name="LT" access="public" returntype="boolean" output="false">
		<cfargument name="Comparable" type="any" required="true"/>
 
		<cfreturn (
			VARIABLES.Instance.Target.getPriority() LT
			ARGUMENTS.Comparable.getPriority()
			) />
			
	</cffunction>
 
</cfcomponent>