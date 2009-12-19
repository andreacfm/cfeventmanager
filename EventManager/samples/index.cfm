<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>EventManager Samples</title>
<cfoutput>
	<link rel="stylesheet"  type="text/css" href="assets/css/style.css"/>
	<script type="text/javascript" src="#getContextRoot()#/EventManager/samples/assets/js/jquery-latest.pack.js"></script>
	<script type="text/javascript" src="#getContextRoot()#/EventManager/samples/assets/js/js.js"></script>
</cfoutput>
</head>
<body>
<div id="wrap">

	<div id="header">
		<span id="slogan">Event Manager Samples</span>
	</div>
	
	<div id="header-logo">
	
	</div>
	
		<cfoutput>
		<div id="sidebar">
	
			<a class="ajax" href="debug.cfm">show debug</a><br/>
			<a class="ajax" href="debug.cfm?action=clear">clear debug</a>
			<p>Debug is saved into session scope. Please clean your debug frequently.</p>
	
			<h1 onclick="toggleItems('a')">hello world</h1>
				<div id="a" class="left-box" style="display:none;">
	
					<ul class="sidemenu">
						<li><a class="ajax" href="#getContextRoot()#/EventManager/samples/views/helloworld/sayhello.cfm">say hello</a></li>
						<li><a class="ajax" href="#getContextRoot()#/EventManager/samples/views/helloworld/sayhellocode.cfm">view the code</a></li>
					</ul>
					<p>simple demo</p>		
								
				</div>
		
			<h1 onclick="toggleItems('b')">Data collection event</h1>
			
			<div id="b" class="left-box" style="display:none;">
				
				<ul class="sidemenu">
					<li><a class="ajax" href="#getContextRoot()#/EventManager/samples/views/collectdata/getpods.cfm">getpods</a></li>
					<li><a class="ajax" href="#getContextRoot()#/EventManager/samples/views/collectdata/datacollectioncode.cfm">view the code</a></li>
				</ul>
				<p>Use an event to collect data in the listener chain.</p>		
			
			</div>
			
			<h1 onclick="toggleItems('c')">Events interceptions</h1>
			
			<div id="c" class="left-box" style="display:none;">
				
				<ul class="sidemenu">
					<li><a class="ajax" href="#getContextRoot()#/EventManager/samples/views/interception/getlinks.cfm">getlinks 1</a></li>
				</ul>
				<p>event collect some link.</p>
	
				<ul class="sidemenu">
					<li><a class="ajax" href="#getContextRoot()#/EventManager/samples/views/interception/getlinks.cfm?nolink">getlinks 2</a></li>
				</ul>
				<p>no links are added, just the default.</p>
	
				<ul class="sidemenu">
					<li><a class="ajax" href="#getContextRoot()#/EventManager/samples/views/interception/getlinks.cfm?invalidlink">getlinks 3</a></li>
				</ul>
				<p>some link is invalid.</p>

				<ul class="sidemenu">
					<li><a class="ajax" href="#getContextRoot()#/EventManager/samples/views/interception/interceptioncode.cfm">view the code</a></li>
				</ul>
	
			</div>
	
		</div>
		</cfoutput>
			
	<div id="main">
	
	</div>
	
</div>
</body>
</html>

