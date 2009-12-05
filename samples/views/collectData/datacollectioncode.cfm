<h2>Data Collection Event Example Code</h2>
<p>Suppose we are implementing a blog engine that need to display a list of pods in a sidebar. We use a built in <b>Data Collection Event</b>
to allow listeners to add pod before to perform the display</p>

<h3>Application.cfc</h3>
<pre>
	
	&lt;cfset application.EventManager = CreateObject('component','EventManager.EventManager').init(
				debug = true,
				scope = 'instance'
				)/><br/>
		
	&lt;cfset application.EventManager.loadXml('/EventManager/samples/config/dataCollectionExample.xml')/><br/>	
		
</pre>

<h3>dataCollectionExample.xml</h3>
<pre>
&lt;?xml version="1.0" encoding="UTF-8"?>
&lt;event-manager><br/>
    
    &lt;events><br/>
        
        &lt;event name="getPods" type="EventManager.events.CollectDataEvent" /><br/>
    
    &lt;/events><br/>

    &lt;listeners><br/>
        
        &lt;listener 
            event="getPods" 
            listener="EventManager.samples.handlers.getpods" />
        /><br/>

        &lt;listener 
            event="getPods" 
            listener="EventManager.samples.handlers.getpods2"
            priority="10"
        />
                   
    &lt;/listeners><br/>

&lt;/event-manager>
</pre>
<p>We use an event of class EventManager.events.CollectDataEvent that is designed to internally store an array of 'items' and expose methods
   to add and getItems. We have 2 listeners that will listen to event 'getPods'</p>

<h3>getpods.cfm</h3>
<pre>

&lt;cfset ev = application.EventManager.createEvent('getPods')/><br/>
&lt;cfset application.EventManager.dispatchEvent(event=ev) /><br/>
&lt;cfset pods = ev.getItems() /><br/>
&lt;cfoutput>
&lt;cfloop array="#pods#" index="pod">
	&lt;h3>#pod.title#</h3>
	&lt;p>#pod.content#</p>
&lt;/cfloop>
&lt;/cfoutput>

</pre>
<p>The event is created and dispatched. As you see the event has a method 'getItems()' that return the array of items after that the listener
chain has been invoked ( if any ). Of course the array is empty at the event creation.
</p>

<h3>getpods.cfc</h3>
<pre>
.......<br/>

	&lt;cffunction name="getPods" access="public" returntype="void" output="false">     
		&lt;cfargument name="event" type="EventManager.events.AbstractEvent" /><br/>
		
		&lt;cfset var myPods = [
			{title = 'Advertise',content = 'Google Ads'},
			{title = 'Links', content = 'html with my links'} 
		] /><br/>
		
		&lt;cfloop array="#myPods#" index="pod">
			&lt;cfset event.addItem(pod) />		
		&lt;/cfloop><br/>
		
	
	&lt;/cffunction>

.......<br/>
</pre>

<h3>getpods2.cfc</h3>
<pre>
.......<br/>

	&lt;cffunction name="getPods" access="public" returntype="void" output="false">     
		&lt;cfargument name="event" type="EventManager.events.AbstractEvent" /><br/>
		
		&lt;cfset var myPods = [
			{title = 'Personal',content = 'My Peronal Pod'},
			{title = 'Search', content = 'Search Pod'} 
		] /><br/>
		
		&lt;cfloop array="#myPods#" index="pod">
			&lt;cfset event.addItem(pod) />	<br/>	
		&lt;/cfloop>
		
	
	&lt;/cffunction>

.......<br/>
</pre>

<p>These are the 2 listener.</p>
<p>If you see both just add 2 pods into the event data storage. If you run the example you will see that the 4 pods have being
collected and that those added by the listeners getpods2 are displayed first. If you check the xml you will see that the second listener has
higher priority and infact will be called first.</p>
<p>Note that the view and the 2 listeners are completely decoupled. Remove a listener from the xml. Restart the sample app ( add ?init to reset) 
and the output will change accordingly.</p>
