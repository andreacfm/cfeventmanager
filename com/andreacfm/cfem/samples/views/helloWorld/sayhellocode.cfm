<h2>Hello World Example Code</h2>

<h3>Application.cfc</h3>
<pre>
	
	&lt;cfset application.EventManager = CreateObject('component','com.andreacfm.cfem.EventManager').init(
				debug = true,
				scope = 'instance'
				)/><br/>
		
	&lt;cfset application.com.andreacfm.cfem.loadXml('/EventManager/samples/config/helloWorldExample.xml')/><br/>	
		
</pre>
<p>Event Manager is craeted. We then load the xml that add events and listeners.</p>
<h3>helloWorldExample.xml</h3>
<pre>
&lt;?xml version="1.0" encoding="UTF-8"?>
&lt;event-manager><br/>
    
    &lt;events><br/>
        
        &lt;event name="beforeWelcomeOutput" /><br/>
    
    &lt;/events><br/>

    &lt;listeners><br/>
        
        &lt;listener 
            event="beforeWelcomeOutput"
            listener="com.andreacfm.cfem.samples.handlers.helloWorld"
        /><br/>
                   
    &lt;/listeners><br/>

&lt;/event-manager>
</pre>
<p>Xml add the event 'beforeWelcomeOutput' that use the standard event class and a listener with class 'com.andreacfm.cfem.samples.handlers.helloWorld' that is registered 
to observe event 'beforeWelcomeOuput'.</p>
<p>At this point we know that anytime event 'beforeWelcomeOuput' is dispatched the method 'beforeWelcomeOutput' of listener 'com.andreacfm.cfem.samples.handlers.helloWorld' is invoked.</p>

<h3>SayHello.cfm</h3>
<pre>

&lt;cfset em = application.EventManager /><br/>

&lt;cfset output = {name = 'Guest'} /><br/>
&lt;cfset event = em.createEvent('beforeWelcomeOutput',output) /><br/>
&lt;cfset em.dispatchEvent(event=event) /><br/>

&lt;cfoutput><br/>
&lt;h1>Hello #output.name# !&lt;/h1>
&lt;p>Welcome to EventManager&lt;/p><br/>	
&lt;/cfoutput>

</pre>
<p>This is our view.</p>
<p>The view is designed to output the welcome message using as name the variable #output.name#. 
What make our view 'special' is the fact that before printing the output the event 'beforeWelcomeOutput' is dispatched carrying as data the
output structure that hold the name variable.</p>

<h3>HelloWorld.cfc</h3>
<pre>
&lt;cfcomponent><br/>
	&lt;cffunction name="init" output="false" access="public">
		&lt;cfreturn this/>
	&lt;/cffunction><br/>
	
	&lt;cffunction name="beforeWelcomeOutput" access="public" output="false">    
		&lt;cfargument name="event" type="com.andreacfm.cfem.events.Event" /><br/>
		
		&lt;cfset myName = 'Andrea' />
		&lt;cfset event.getData().name = myName /><br/>
	
	&lt;/cffunction><br/>	
		
&lt;/cfcomponent>

</pre>
<p>This is a very simple listener. When the event is dispatched the listener is called ( by default event manager looks for a method
in the listener that has the same name of the event itself ).</p>
<p>The listener can now maninulate the output acting on the data that event is carrying on.</p>
<p>Remember that complex types are passed by reference so when the listener manipulate the data 'event.getData().name = myName' is acting on the
output struct declared in the view.</p>
<p><i>This is a very simple example that shows the powerfull of events. The view code do not change while many listeners can act on the
output of the view itself.</i></p>