<cfcomponent name="AsynchDispatcher" extends="com.andreacfm.cfem.dispatch.Dispatcher">
	
	<cffunction name="dispatch" returntype="void" output="false">
		<cfthread name="#randRange(1,1000000)#" action="run">	
			<cfscript>
				super.dispatch(true);
			</cfscript>				
		</cfthread>		
	</cffunction>

</cfcomponent>