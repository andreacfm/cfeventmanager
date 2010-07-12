<!-----------------------------------------------------------------------
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************
Author 	  : Luis Majano
Date        : 5/25/2007
Description :
	Base Unit Test Component based on MXUnit.
	{ADD MORE DESCRIPTION HERE}
	
	This is a base test component for testing coldbox handlers. All you need
	to do is add the extends portions of your test cases to this base test
	and you will have a coldbox handler test.  The setup method will need
	to be changed in order to match your application path.

	MODIFY:
	1) instance.appMapping : To point to your application relative from the root
	                         or via CF Mappings.
	2) instance.ConfigMapping : The expanded path location of your coldbox configuration file.

	OPTIONAL:
	3) Execute the on App start handler. You will need to fill out the name
	   of the Application Start Handler to be executed.

<cfscript>
people = querySim('
id , name , mail
1 | weed | weed@theflowerpot.not
2 | bill | bill@theflowerpot.not
3 | ben | ben@theflowerpot.not
');
</cfscript>

---------------------------------------------------------------------->
<cfcomponent extends="mxunit.framework.TestCase" 
			 output="false" 
			 hint="A base test case for doing ColdBox Testing based on the MXUnit Framework">

	<cfscript>
		instance = structnew();
		
		// Internal Properties
		instance.appMapping = "";
		instance.configMapping = "";
		instance.controller = 0;
		instance.coldboxAppKey = "cbController";
		
		// Public Switch Properties
		this.loadColdbox = true;
		
		// Prepare MockBox
		instance.mockBox = createObject("component","mockbox.system.testing.MockBox").init();
	</cfscript>

	<!--- metadata Inspection --->
	<cffunction name="metadataInspection" access="private" returntype="void" hint="Inspect test case for annotations">
		<cfscript>
			var md = getMetadata(this);
			// Inspect for appMapping annotation
			if( structKeyExists(md,"appMapping") ){
				instance.appMapping = md.appMapping;
			}
			// Config.xml mapping
			if( structKeyExists(md,"configMapping") ){
				instance.configMapping = md.configMapping;
			}
			// ColdBox App Key
			if( structKeyExists(md,"coldboxAppKey") ){
				instance.coldboxAppKey = md.coldboxAppKey;
			}	
			// Load coldBox annotation
			if( structKeyExists(md,"loadColdbox") ){
				this.loadColdbox = md.loadColdbox;
			}		
		</cfscript>
	</cffunction>

	<!--- setup --->
	<cffunction name="setup" hint="The main setup method for running ColdBox enabled tests">
		<cfscript>
		var appRootPath = "";
		
		// metadataInspection
		metadataInspection();
		
		// Load ColdBox Application for testing?
		if( this.loadColdbox ){
			// Check on Scope Firsty
			if( structKeyExists(application,getColdboxAppKey()) ){
				instance.controller = application[getColdboxAppKey()];
			}
			else{
				// Verify App Root Path
				if( NOT len(instance.appMapping) ){ instance.appMapping = "/"; }
				appRootPath = expandPath(instance.appMapping);
				// Clean the path for nice root path.
				if( NOT reFind("(/|\\)$",appRootPath) ){
					appRootPath = appRootPath & "/";
				}
				
				// Config.xml by convention if not set before setup() call.
				if(NOT len(instance.configMapping) ){
					// check CFC First for convention testing.
					if( fileExists(appRootPath & "config/Coldbox.cfc") ){
						instance.configMapping = appRootPath & "config/Coldbox.cfc";
					}
					else{
						instance.configMapping = appRootPath & "config/coldbox.xml.cfm";
					}
				}
				
				//Initialize mock Controller
				instance.controller = CreateObject("component", "mockbox.system.testing.mock.web.MockController").init( appRootPath );
				
				// persist for mock testing in right name
				application[getColdboxAppKey()] = instance.controller;
				
				// Setup
				instance.controller.getLoaderService().loadApplication(instance.configMapping,instance.appMapping);
			}
			
			//Clean up Initial Event Context
			getRequestContext().clearCollection();
			getRequestContext().clearCollection(private=true);
		}
		</cfscript>
	</cffunction>
	
	<!--- tearDown --->
	<cffunction name="tearDown" hint="The main teardown for ColdBox enabled applications" >
		<cfscript>
			structDelete(application,getColdboxAppKey());
		</cfscript>
	</cffunction>

<!------------------------------------------- HELPERS ------------------------------------------->

	<!--- getMockBox --->
	<cffunction name="getMockBox" output="false" access="private" returntype="mockbox.system.testing.MockBox" hint="Get a reference to the MockBox framework">
		<cfreturn instance.mockBox>
	</cffunction>
	
	<!--- getMockRequestContext --->
	<cffunction name="getMockRequestContext" output="false" access="private" returntype="mockbox.system.web.context.RequestContext" hint="Builds an empty functioning request context mocked with methods via MockBox.  You can also optionally wipe all methods on it.">
		<cfargument name="clearMethods" type="boolean" required="false" default="false" hint="Clear Methods on it?"/>
		<cfscript>
			var mockRC = "";
			var rcProps = structnew();
			
			if( arguments.clearMethods ){
				return getMockBox().createMock(className="mockbox.system.web.context.RequestContext",clearMethods=true);
			}
			
			// Create functioning request context
			mockRC = getMockBox().createMock(className="mockbox.system.web.context.RequestContext");
			
			// Create mock properties
			rcProps.DefaultLayout = "";
			rcProps.DefaultView = "";
			rcProps.isSES = false;
			rcProps.sesBaseURL = "";
			rcProps.eventName = "event";
			rcProps.ViewLayouts = structnew();
			rcProps.FolderLayouts = structnew();
			rcProps.RegisteredLayouts = structnew();
			
			return mockRC.init(structnew(),structNew(),rcProps);
		</cfscript>
	</cffunction>
	
	<!--- Get a Mock Model --->
	<cffunction name="getMockModel" access="private" returntype="any" hint="*ColdBox must be loaded for this to work. Get a mock model object by convention. You can optional clear all the methods on the model object if you wanted to. The object is created but not initiated, that would be your job." output="false" >
		<cfargument name="name" 			type="string"   required="true" hint="The name of the model to mock">
		<cfargument name="clearMethods" 	type="boolean"  required="false" default="false" hint="If true, all methods in the target mock object will be removed. You can then mock only the methods that you want to mock"/>
		<cfscript>
			var mockLocation = getController().getPlugin("BeanFactory").locateModel(arguments.name,true);
			
			if( len(mockLocation) ){
				return getMockBox().createMock(className=mockLocation,clearMethods=arguments.clearMethods);
			}
			else{
				throwit(message="Model object #arguments.name# could not be located.",type="ModelNotFoundException");
			}
		</cfscript>
	</cffunction>

	<!--- Reset the persistence --->
	<cffunction name="reset" access="private" returntype="void" hint="Reset the persistence of the unit test coldbox app, basically removes the controller from application scope" output="false" >
		<cfset structDelete(application,getColdboxAppKey())>
	</cffunction>
	
	<!--- get/Set Coldbox App Key --->
	<cffunction name="getColdboxAppKey" access="private" output="false" returntype="string" hint="Get the coldboxAppKey used to store the coldbox controller in application scope.">
		<cfreturn instance.coldboxAppKey/>
	</cffunction>
	<cffunction name="setColdboxAppKey" access="private" output="false" returntype="void" hint="Override the coldboxAppKey, used to store the coldbox controller in application scope.">
		<cfargument name="coldboxAppKey" type="string" required="true"/>
		<cfset instance.coldboxAppKey = arguments.coldboxAppKey/>
	</cffunction>
	
	<!--- getter for AppMapping --->
	<cffunction name="getAppMapping" access="private" returntype="string" output="false" hint="Get the AppMapping used for this test case">
		<cfreturn instance.appMapping>
	</cffunction>
	
	<!--- setter for AppMapping --->
	<cffunction name="setAppMapping" access="private" output="false" returntype="void" hint="Set the AppMapping for this test case">
		<cfargument name="AppMapping" type="string" required="true"/>
		<cfset instance.appMapping = arguments.appMapping/>
	</cffunction>

	<!--- getter for ConfigMapping --->
	<cffunction name="getConfigMapping" access="private" returntype="string" output="false" hint="Get the ConfigMapping for this test case">
		<cfreturn instance.ConfigMapping>
	</cffunction>
	
	<!--- setter for ConfigMapping --->
	<cffunction name="setConfigMapping" access="private" output="false" returntype="void" hint="Set the ConfigMapping for this test case">
		<cfargument name="ConfigMapping" type="string" required="true"/>
		<cfset instance.ConfigMapping = arguments.ConfigMapping/>
	</cffunction>

	<!--- getter for controller --->
	<cffunction name="getController" access="private" returntype="any" output="false" hint="Get a reference to the ColdBox mock controller">
		<cfreturn instance.controller>
	</cffunction>
	
	<!--- getColdboxOCM --->
    <cffunction name="getColdboxOCM" output="false" access="private" returntype="any" hint="Get a reference to the cache manager">
    	<cfreturn getController().getColdboxOCM()>
    </cffunction>

	<!--- Get current request context --->
	<cffunction name="getRequestContext" access="private" output="false" returntype="any" hint="Get a reference to the current mock request context">
		<cfreturn getController().getRequestService().getContext() >
	</cffunction>
	
	<!--- getFlashScope --->
	<cffunction name="getFlashScope" output="false" access="private" returntype="mockbox.system.web.Flash.AbstractFlashScope" hint="Returns to you the currently used flash ram object">
		<cfreturn getController().getRequestService().getFlashScope()>
	</cffunction>

	<!--- Setup a request context --->
	<cffunction name="setupRequest" access="private" output="false" returntype="void" hint="Setup an initial request capture.  I basically look at the FORM/URL scopes and create the request collection out of them.">
		<cfargument name="event" 	required="true"  type="string" hint="The event to setup the request context with">
		<cfscript>
			// Setup the incoming event
			URL[getController().getSetting("EventName")] = arguments.event;
			// Capture the request
			getController().getRequestService().requestCapture();
		</cfscript>
	</cffunction>

	<!--- prepare request, execute request and retrieve request --->
	<cffunction name="execute" access="private" output="false" returntype="any" hint="Executes a framework lifecycle by executing an event.  This method returns a request context object that can be used for assertions">
		<cfargument name="event" 	required="true"  type="string" hint="The event to execute">
		<cfargument name="private" 	required="false" type="boolean" default="false" hint="Call a private event or not">
		<cfargument name="prepostExempt" type="boolean" required="false" default="false" hint="If true, pre/post handlers will not be fired.">
		<cfscript>
			var handlerResults  = "";
			var requestContext  = "";
			var relocationTypes = "TestController.setNextEvent,TestController.setNextRoute,TestController.relocate";
			var cbController    = getController();
				
			//Setup the request Context with setup FORM/URL variables set in the unit test.
			setupRequest(arguments.event);
			
			try{
			
				// App Start Handler
				if ( len(cbController.getSetting("ApplicationStartHandler")) ){
					cbController.runEvent(cbController.getSetting("ApplicationStartHandler"),true);
				}
				// preProcess
				cbController.getInterceptorService().processState("preProcess");
				// Request Start Handler
				if ( len(cbController.getSetting("RequestStartHandler")) ){
					cbController.runEvent(cbController.getSetting("RequestStartHandler"),true);
				}
			
				//TEST EVENT EXECUTION
				handlerResults = cbController.runEvent(event=arguments.event,private=arguments.private,prepostExempt=arguments.prepostExempt);
			
				// Request Start Handler
				if ( len(cbController.getSetting("RequestEndHandler")) ){
					cbController.runEvent(cbController.getSetting("RequestEndHandler"),true);
				}
				// postProcess
				cbController.getInterceptorService().processState("postProcess");
				
			}
			catch(Any e){
				// Exclude relocations so they can be asserted.
				if( NOT listFindNoCase(relocationTypes,e.type) ){
					$rethrow(e);
				}
			}
			
			//Return the correct event context.
			requestContext = getRequestContext();
			
			//If we have results save them in our context for assertions
			if ( isDefined("handlerResults") ){
				requestContext.setValue("cbox_handler_results", handlerResults);
			}
			
			return requestContext;
		</cfscript>
	</cffunction>
	
	<!--- Announce Interception --->
	<cffunction name="announceInterception" access="private" returntype="void" hint="Announce an interception in the system." output="false" >
		<cfargument name="state" 			required="true"  type="string" hint="The interception state to execute">
		<cfargument name="interceptData" 	required="false" type="struct" default="#structNew()#" hint="A data structure used to pass intercepted information.">
		<cfset getController().getInterceptorService().processState(argumentCollection=arguments)>
	</cffunction>

	<!--- Interceptor Facade --->
	<cffunction name="getInterceptor" access="private" output="false" returntype="any" hint="Get an interceptor">
		<!--- ************************************************************* --->
		<cfargument name="interceptorName" 	required="false" type="string" hint="The name of the interceptor to search for"/>
		<cfargument name="deepSearch" 		required="false" type="boolean" default="false" hint="By default we search the cache for the interceptor reference. If true, we search all the registered interceptor states for a match."/>
		<!--- ************************************************************* --->
		<cfscript>
			return getController().getInterceptorService().getInterceptor(argumentCollection=arguments);
		</cfscript>
	</cffunction>
	
	<!--- Get Model --->
	<cffunction name="getModel" access="private" returntype="any" hint="Create or retrieve model objects by convention" output="false" >
		<!--- ************************************************************* --->
		<cfargument name="name" 				required="true"  type="string" hint="The name of the model to retrieve">
		<cfargument name="useSetterInjection" 	required="false" type="boolean" default="false"	hint="Whether to use setter injection alongside the annotations property injection. cfproperty injection takes precedence.">
		<cfargument name="onDICompleteUDF" 		required="false" type="string"	default="onDIComplete" hint="After Dependencies are injected, this method will look for this UDF and call it if it exists. The default value is onDIComplete">
		<cfargument name="debugMode" 			required="false" type="boolean" default="false" hint="Debugging Mode or not">
		<!--- ************************************************************* --->
		<cfreturn getController().getPlugin("BeanFactory").getModel(argumentCollection=arguments)>
	</cffunction>
	
	<!--- Throw Facade --->
	<cffunction name="$throw" access="private" hint="Facade for cfthrow" output="false">
		<!--- ************************************************************* --->
		<cfargument name="message" 	type="string" 	required="yes">
		<cfargument name="detail" 	type="string" 	required="no" default="">
		<cfargument name="type"  	type="string" 	required="no" default="Framework">
		<!--- ************************************************************* --->
		<cfthrow type="#arguments.type#" message="#arguments.message#"  detail="#arguments.detail#">
	</cffunction>
	
	<!--- Dump facade --->
	<cffunction name="$dump" access="private" hint="Facade for cfmx dump" returntype="void">
		<cfargument name="var" required="yes" type="any">
		<cfargument name="isAbort" type="boolean" default="false" required="false" hint="Abort also"/>
		<cfdump var="#var#">
		<cfif arguments.isAbort><cfabort></cfif>
	</cffunction>
	
	<!--- Rethrow Facade --->
	<cffunction name="$rethrow" access="private" returntype="void" hint="Rethrow facade" output="false" >
		<cfargument name="throwObject" required="true" type="any" hint="The cfcatch object">
		<cfthrow object="#arguments.throwObject#">
	</cffunction>
	
	<!--- Abort Facade --->
	<cffunction name="$abort" access="private" hint="Facade for cfabort" returntype="void" output="false">
		<cfabort>
	</cffunction>
	
	<!--- Include Facade --->
	<cffunction name="$include" access="private" hint="Facade for cfinclude" returntype="void" output="false">
		<cfargument name="template" type="string">
		<cfinclude template="#template#">
	</cffunction>
	
	<!--- Query Sim --->
	<cffunction name="querySim" access="private" returntype="query" hint="Query Simulator" output="false" >
		<cfargument name="queryData"  type="string" required="true" hint="The data to create queries">
		<cfscript>
		return getMockBox().querySim(argumentCollection=arguments);
		</cfscript>
	</cffunction>

</cfcomponent>