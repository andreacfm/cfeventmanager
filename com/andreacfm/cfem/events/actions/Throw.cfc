<!--- /*		
Project:     @projectName  @projectUrl
Author:      @author <@authorEmail>
Version:     @projectVersion
Build Date:  @date
Build:		 @number

Copyright @year @author

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.	
			
*/--->

<cfcomponent extends="com.andreacfm.cfem.events.actions.AbstractAction" output="false">
	
	<cfset variables.instance.name = 'Throw' />
	
	<!---   Constructor --->
    <cffunction name="init" output="false"  returntype="com.andreacfm.cfem.events.actions.AbstractAction" >
		<cfargument name="type" required="false" type="String" default="" />
		<cfargument name="message" required="false" type="String" default="" />
		<cfset variables.instance.type = type/>
		<cfset variables.instance.message = message/>				
	    <cfreturn this/>
    </cffunction>

	<!--- PRIVATE -------------------------------------------------------------------------->

    <!---   type   --->
	<cffunction name="gettype" access="private" output="false" returntype="string">
		<cfreturn variables.instance.type/>
	</cffunction>
			
    <!---   message   --->
	<cffunction name="getmessage" access="private" output="false" returntype="string">
		<cfreturn variables.instance.message/>
	</cffunction>

	<!--- PUBLIC -------------------------------------------------------------------------->
	
	<!---execute--->
    <cffunction name="execute" output="false" returntype="void">
    	<cfargument name="event" type="com.andreacfm.cfem.events.Event" required="true"/>
		   	
		<cfthrow type="#getType()#" message="#getMessage()#" />
		
    </cffunction>

			
</cfcomponent>