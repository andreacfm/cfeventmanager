<cfcomponent extends="com.andreacfm.cfem.events.Event" output="false">
	
	<!---   Implement Abstract Constructor   --->
	<cffunction name="init" output="false" returntype="com.andreacfm.cfem.events.Event">
		<cfargument name="name" required="true" type="string"/>
		<cfargument name="data" required="true" type="struct"/>		
		<cfargument name="target" required="true" type="any"/>
		<cfargument name="mode" required="true" type="string"/>
		<cfargument name="type" required="true" type="string"/>
		<cfargument name="alias" required="false" type="string" default=""/>
		
		<cfscript>
		super.init(argumentCollection=arguments);
		if(not structKeyExists(getData(),'items')){
			variables.instance.data.items = [];
		};
		</cfscript>
		
		<cfreturn this/>

	</cffunction>
	
	<!---addItem--->
    <cffunction name="addItem" output="false" access="public" returntype="void">
    	<cfargument name="Item" type="any" required="true" />
		<cfset variables.instance.data.items.add(item) />
    </cffunction>

	<!---addItems--->
    <cffunction name="addItems" output="false" access="public" returntype="void">
    	<cfargument name="Items" type="Array" required="true" />
		<cfset variables.instance.data.items.addAll(items) />
    </cffunction>
	
	<!---getItems--->
    <cffunction name="getItems" output="false" access="public" returntype="array">
  		<cfreturn variables.instance.data.items />
    </cffunction>
	
	
</cfcomponent>