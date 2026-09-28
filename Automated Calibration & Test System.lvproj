<?xml version='1.0' encoding='UTF-8'?>
<Project Type="Project" LVVersion="26008000">
	<Property Name="NI.LV.All.SaveVersion" Type="Str">Editor Version</Property>
	<Property Name="NI.LV.All.SourceOnly" Type="Bool">true</Property>
	<Property Name="NI.Project.Description" Type="Str"></Property>
	<Item Name="My Computer" Type="My Computer">
		<Property Name="IOScan.Faults" Type="Str"></Property>
		<Property Name="IOScan.NetVarPeriod" Type="UInt">100</Property>
		<Property Name="IOScan.NetWatchdogEnabled" Type="Bool">false</Property>
		<Property Name="IOScan.Period" Type="UInt">10000</Property>
		<Property Name="IOScan.PowerupMode" Type="UInt">0</Property>
		<Property Name="IOScan.Priority" Type="UInt">9</Property>
		<Property Name="IOScan.ReportModeConflict" Type="Bool">true</Property>
		<Property Name="IOScan.StartEngineOnDeploy" Type="Bool">false</Property>
		<Property Name="NI.SortType" Type="Int">3</Property>
		<Property Name="server.app.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.control.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="server.tcp.enabled" Type="Bool">false</Property>
		<Property Name="server.tcp.port" Type="Int">0</Property>
		<Property Name="server.tcp.serviceName" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.tcp.serviceName.default" Type="Str">My Computer/VI Server</Property>
		<Property Name="server.vi.callsEnabled" Type="Bool">true</Property>
		<Property Name="server.vi.propertiesEnabled" Type="Bool">true</Property>
		<Property Name="specify.custom.address" Type="Bool">false</Property>
		<Item Name="Project Documentation" Type="Folder">
			<Item Name="Documentation Images" Type="Folder">
				<Item Name="loc_continuous_measurement.png" Type="Document" URL="../documentation/loc_continuous_measurement.png"/>
			</Item>
			<Item Name="Continuous Measurement and Logging Documentation.html" Type="Document" URL="../documentation/Continuous Measurement and Logging Documentation.html"/>
		</Item>
		<Item Name="Support VIs" Type="Folder">
			<Property Name="NI.SortType" Type="Int">3</Property>
			<Item Name="Architecture" Type="Folder">
				<Item Name="Message Queue" Type="Folder">
					<Item Name="Message Queue.lvlib" Type="Library" URL="../support/Architecture/Message Queue/Message Queue.lvlib"/>
				</Item>
				<Item Name="User Event - Stop" Type="Folder">
					<Item Name="User Event - Stop.lvlib" Type="Library" URL="../support/Architecture/User Event - Stop/User Event - Stop.lvlib"/>
				</Item>
				<Item Name="Error Handler - Message Handling Loop.vi" Type="VI" URL="../support/Architecture/Error Handler - Message Handling Loop.vi"/>
				<Item Name="Check Loop Error.vi" Type="VI" URL="../support/Architecture/Check Loop Error.vi"/>
				<Item Name="Error Handler - Event Handling Loop.vi" Type="VI" URL="../support/Architecture/Error Handler - Event Handling Loop.vi"/>
			</Item>
			<Item Name="File IO" Type="Folder">
				<Item Name="Load System Config File.vi" Type="VI" URL="../support/File IO/Load System Config File.vi"/>
				<Item Name="Create Data Directory.vi" Type="VI" URL="../support/File IO/Create Data Directory.vi"/>
			</Item>
			<Item Name="UI Utilities" Type="Folder">
				<Item Name="Execute Test.vi" Type="VI" URL="../support/UI Utilities/Execute Test.vi"/>
				<Item Name="Find Setpoint.vi" Type="VI" URL="../support/UI Utilities/Find Setpoint.vi"/>
				<Item Name="Get Enum Text.vi" Type="VI" URL="../support/UI Utilities/Get Enum Text.vi"/>
				<Item Name="Initiate Test.vi" Type="VI" URL="../support/UI Utilities/Initiate Test.vi"/>
				<Item Name="Insert Calibration Session.vi" Type="VI" URL="../support/UI Utilities/Insert Calibration Session.vi"/>
				<Item Name="Login.vi" Type="VI" URL="../support/UI Utilities/Login.vi"/>
				<Item Name="Remove Zeroes.vi" Type="VI" URL="../support/UI Utilities/Remove Zeroes.vi"/>
				<Item Name="Remove Zeroes From Instrument Specs.vi" Type="VI" URL="../support/UI Utilities/Remove Zeroes From Instrument Specs.vi"/>
				<Item Name="Set Admin Visible .vi" Type="VI" URL="../support/UI Utilities/Set Admin Visible .vi"/>
				<Item Name="Set Enable State on Multiple Controls.vi" Type="VI" URL="../support/UI Utilities/Set Enable State on Multiple Controls.vi"/>
				<Item Name="Set Visible State on Multiple Controls.vi" Type="VI" URL="../support/UI Utilities/Set Visible State on Multiple Controls.vi"/>
				<Item Name="Set Visible State on Pages.vi" Type="VI" URL="../support/UI Utilities/Set Visible State on Pages.vi"/>
			</Item>
		</Item>
		<Item Name="Type Definitions" Type="Folder">
			<Item Name="UI" Type="Folder">
				<Item Name="Acq Settings.ctl" Type="VI" URL="../controls/UI/Acq Settings.ctl"/>
				<Item Name="Config Settings.ctl" Type="VI" URL="../controls/UI/Config Settings.ctl"/>
				<Item Name="Folder Name.ctl" Type="VI" URL="../controls/UI/Folder Name.ctl"/>
				<Item Name="Login Refs.ctl" Type="VI" URL="../controls/UI/Login Refs.ctl"/>
				<Item Name="Signal Enum.ctl" Type="VI" URL="../controls/UI/Signal Enum.ctl"/>
				<Item Name="Session Identfiers.ctl" Type="VI" URL="../controls/UI/Session Identfiers.ctl"/>
				<Item Name="Settings Cluster.ctl" Type="VI" URL="../controls/UI/Settings Cluster.ctl"/>
				<Item Name="Settings Refs.ctl" Type="VI" URL="../controls/UI/Settings Refs.ctl"/>
				<Item Name="System Config.ctl" Type="VI" URL="../controls/UI/System Config.ctl"/>
				<Item Name="Test Sequence Settings.ctl" Type="VI" URL="../controls/UI/Test Sequence Settings.ctl"/>
				<Item Name="Test Sequence Enum.ctl" Type="VI" URL="../controls/UI/Test Sequence Enum.ctl"/>
				<Item Name="UI Data.ctl" Type="VI" URL="../controls/UI/UI Data.ctl"/>
				<Item Name="UI List Type.ctl" Type="VI" URL="../controls/UI/UI List Type.ctl"/>
				<Item Name="UI State.ctl" Type="VI" URL="../controls/UI/UI State.ctl"/>
				<Item Name="Units Enum.ctl" Type="VI" URL="../controls/UI/Units Enum.ctl"/>
				<Item Name="Measurement Config.ctl" Type="VI" URL="../controls/UI/Measurement Config.ctl"/>
				<Item Name="Measurements Config.ctl" Type="VI" URL="../controls/UI/Measurements Config.ctl"/>
			</Item>
			<Item Name="Diagnostics" Type="Folder">
				<Item Name="Error Cluster.ctl" Type="VI" URL="../controls/Diagnostics/Error Cluster.ctl"/>
				<Item Name="Error Payload.ctl" Type="VI" URL="../controls/Diagnostics/Error Payload.ctl"/>
				<Item Name="Error_Payload.ctl" Type="VI" URL="../controls/Diagnostics/Error_Payload.ctl"/>
			</Item>
			<Item Name="Messaging Payloads" Type="Folder">
				<Item Name="Calibration Point Table Insert.ctl" Type="VI" URL="../controls/Messaging Payloads/Calibration Point Table Insert.ctl"/>
				<Item Name="DB Query Request Payload.ctl" Type="VI" URL="../controls/Messaging Payloads/DB Query Request Payload.ctl"/>
				<Item Name="Fetch Config Payload.ctl" Type="VI" URL="../controls/Messaging Payloads/Fetch Config Payload.ctl"/>
				<Item Name="MSG FetchConfiguration Payload.ctl" Type="VI" URL="../controls/Messaging Payloads/MSG FetchConfiguration Payload.ctl"/>
				<Item Name="Operator InsertRequest.ctl" Type="VI" URL="../controls/Messaging Payloads/Operator InsertRequest.ctl"/>
				<Item Name="Operator Table Insert.ctl" Type="VI" URL="../controls/Messaging Payloads/Operator Table Insert.ctl"/>
				<Item Name="Processed Calibration Point.ctl" Type="VI" URL="../controls/Messaging Payloads/Processed Calibration Point.ctl"/>
				<Item Name="Processed Calibration Points.ctl" Type="VI" URL="../controls/Messaging Payloads/Processed Calibration Points.ctl"/>
				<Item Name="Sensor CoreData.ctl" Type="VI" URL="../controls/Messaging Payloads/Sensor CoreData.ctl"/>
				<Item Name="Sensor FetchResponse.ctl" Type="VI" URL="../controls/Messaging Payloads/Sensor FetchResponse.ctl"/>
				<Item Name="Sensor InsertRequest.ctl" Type="VI" URL="../controls/Messaging Payloads/Sensor InsertRequest.ctl"/>
				<Item Name="TestRuns Table Insert.ctl" Type="VI" URL="../controls/Messaging Payloads/TestRuns Table Insert.ctl"/>
				<Item Name="Start Test Payload.ctl" Type="VI" URL="../controls/Messaging Payloads/Start Test Payload.ctl"/>
			</Item>
			<Item Name="Data Acquisition" Type="Folder">
				<Item Name="Acquired Data.ctl" Type="VI" URL="../controls/Data Acquisition/Acquired Data.ctl"/>
				<Item Name="Acquisition Loop State.ctl" Type="VI" URL="../controls/Data Acquisition/Acquisition Loop State.ctl"/>
				<Item Name="Channels.ctl" Type="VI" URL="../controls/Data Acquisition/Channels.ctl"/>
				<Item Name="Telemetry_Data_Type.ctl" Type="VI" URL="../controls/Data Acquisition/Telemetry_Data_Type.ctl"/>
			</Item>
			<Item Name="Loop Memory" Type="Folder">
				<Item Name="DB Session Data.ctl" Type="VI" URL="../controls/Loop Memory/DB Session Data.ctl"/>
			</Item>
			<Item Name="Controller" Type="Folder">
				<Item Name="Stimulus Role.ctl" Type="VI" URL="../controls/Controller/Stimulus Role.ctl"/>
			</Item>
		</Item>
		<Item Name="Admin.lvlib" Type="Library" URL="../Admin/Admin.lvlib"/>
		<Item Name="Acquisition.lvlib" Type="Library" URL="../Acquisition/Acquisition.lvlib"/>
		<Item Name="Analysis.lvlib" Type="Library" URL="../Analysis/Analysis.lvlib"/>
		<Item Name="Database.lvlib" Type="Library" URL="../Database/Database.lvlib"/>
		<Item Name="Logging.lvlib" Type="Library" URL="../Logging/Logging.lvlib"/>
		<Item Name="Settings.lvlib" Type="Library" URL="../Settings/Settings.lvlib"/>
		<Item Name="Processing_Engine.lvlib" Type="Library" URL="../Processing/Processing_Engine.lvlib"/>
		<Item Name="Main.vi" Type="VI" URL="../Main.vi"/>
		<Item Name="SystemConfig.ini" Type="Document" URL="../SystemConfig.ini"/>
		<Item Name="SystemConfig.template.ini" Type="Document" URL="../SystemConfig.template.ini"/>
		<Item Name="UUT Display Data.ctl" Type="VI" URL="../controls/UI/UUT Display Data.ctl"/>
		<Item Name="Dependencies" Type="Dependencies"/>
		<Item Name="Build Specifications" Type="Build">
			<Item Name="Continuous Measurement and Logging Application" Type="EXE">
				<Property Name="App_copyErrors" Type="Bool">true</Property>
				<Property Name="App_INI_aliasGUID" Type="Str">{F9752556-B5F3-4F2F-A3A7-B7C3E931318E}</Property>
				<Property Name="App_INI_GUID" Type="Str">{842B0EB8-E0F3-4463-9AE0-71DFD7EE5857}</Property>
				<Property Name="App_serverConfig.httpPort" Type="Int">8002</Property>
				<Property Name="App_serverType" Type="Int">1</Property>
				<Property Name="Bld_buildCacheID" Type="Str">{B71B40AD-A554-4390-B7EF-90894CE397AF}</Property>
				<Property Name="Bld_buildSpecName" Type="Str">Continuous Measurement and Logging Application</Property>
				<Property Name="Bld_excludeLibraryItems" Type="Bool">true</Property>
				<Property Name="Bld_excludePolymorphicVIs" Type="Bool">true</Property>
				<Property Name="Bld_localDestDir" Type="Path">../builds/NI_AB_PROJECTNAME/Continuous Measurement and Logging Application</Property>
				<Property Name="Bld_localDestDirType" Type="Str">relativeToCommon</Property>
				<Property Name="Bld_modifyLibraryFile" Type="Bool">true</Property>
				<Property Name="Bld_previewCacheID" Type="Str">{B1B2A711-D696-4C82-A956-2E5555B6D5C4}</Property>
				<Property Name="Bld_version.major" Type="Int">1</Property>
				<Property Name="Destination[0].destName" Type="Str">Main.exe</Property>
				<Property Name="Destination[0].path" Type="Path">../builds/NI_AB_PROJECTNAME/Continuous Measurement and Logging Application/Main.exe</Property>
				<Property Name="Destination[0].preserveHierarchy" Type="Bool">true</Property>
				<Property Name="Destination[0].type" Type="Str">App</Property>
				<Property Name="Destination[1].destName" Type="Str">Support Directory</Property>
				<Property Name="Destination[1].path" Type="Path">../builds/NI_AB_PROJECTNAME/Continuous Measurement and Logging Application/data</Property>
				<Property Name="DestinationCount" Type="Int">2</Property>
				<Property Name="Source[0].itemID" Type="Str">{0F75B76A-443B-4438-959B-EBE33F15004F}</Property>
				<Property Name="Source[0].type" Type="Str">Container</Property>
				<Property Name="Source[1].destinationIndex" Type="Int">0</Property>
				<Property Name="Source[1].itemID" Type="Ref">/My Computer/Main.vi</Property>
				<Property Name="Source[1].sourceInclusion" Type="Str">TopLevel</Property>
				<Property Name="Source[1].type" Type="Str">VI</Property>
				<Property Name="SourceCount" Type="Int">2</Property>
				<Property Name="TgtF_fileDescription" Type="Str">Continuous Measurement and Logging Application</Property>
				<Property Name="TgtF_internalName" Type="Str">Continuous Measurement and Logging Application</Property>
				<Property Name="TgtF_legalCopyright" Type="Str">Copyright © 2012 </Property>
				<Property Name="TgtF_productName" Type="Str">Continuous Measurement and Logging Application</Property>
				<Property Name="TgtF_targetfileGUID" Type="Str">{76FD73CC-C26C-4C57-8E1F-07C587D6546E}</Property>
				<Property Name="TgtF_targetfileName" Type="Str">Main.exe</Property>
			</Item>
		</Item>
	</Item>
</Project>
