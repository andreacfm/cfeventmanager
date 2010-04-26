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
	
	<cfset variables.instance.name = 'Stop' />
	
	<!---execute--->
    <cffunction name="execute" output="false" returntype="void">
    	<cfargument name="event" type="com.andreacfm.cfem.events.Event" required="true"/>   	
		<cfset event.stopPropagation() />
    </cffunction>

</cfcomponent>