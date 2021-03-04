
Running Woodgrove Bank Customer Care using Transaction Integrator
1) Make sure you follow the steps in the following files found in %SNARoot%\..\SDK\Samples\EndToEndScenarios\WoodgroveBank
   a) Readme-05-CustomerCare-TI-Setup.txt
2) Open the Woodgrove Bank Customer Care Solution found in 
   %SNARoot%\..\SDK\Samples\WoodgroveBank\CustomerCare 
   by double clicking on file "CustomerCareClient.sln"
3) Build the Woodgrove Bank Customer Care client
   a) Select the sample Woodgrove Bank Customer Care project named "CustomerCareClient" 
  b) Make sure all Reference are correctly set on your machine. If necessary Browse to
      the correct locations for the TI .NET Assembly:
      1. WoodGroveBank_ELMLink.dll or WoodGroveBank_DPC.dll
      2. Microsoft.HostIntegration.TI.ClientContext.dll
      3. Microsoft.HostIntegration.TI.Globals.dll
      4. Microsoft.HostIntegration.SNA.Session
   c) Right click on the "CustomerCareClient" project and click Rebuild
4) The Customer Care Application supports the following Scenarios
   a) 3270 emulation of the real CICS 3270 Application described above
   b) Transaction Integrator CICS Application that does similar activites as the 3270 Application
5) Configuration for a Scenario using Tranasction Integrator
   a) Using the TI Manager, Import the RE and TI .NET objects
   b) Right click on the "Windows-Initiated Processing" node and click "Import", then "Next"
   c) Click "Use Exported Definitions"
   d) Specify or browse to directory %SNARoot%\..\SDK\Samples\EndToEndScenarios\WoodgroveBank\CustomerCare\TIConfiguration
   e) Click "Next", then "Finish"
6) Update Remote Environment definitions with correct IP address and port details
   a) Start TI Manager
   b) Expand the "Transaction Integrator" node, then expand "Window-Initiated Processing" node, then expand the "Remote Environments" node
   c) Right click on the "CICS ELM Link Woodgrove Bank" RE and click "Properties"
   d) Click the "TCP/IP tab and set the appropriate values for the "IP/DNS Address" and "Port list" fields, then click OK 
   e) Right click on the "OS400 DPC Woodgrove Bank" RE and click "Properties"
   f) Click the "TCP/IP tab and set the appropriate values for the "IP/DNS Address" and "Port list" fields, then click OK
7) Start the Customer Care Application
   f) Open the Customer Care Solution: %SNARoot%\..\SDK\Samples\EndToEndScenarios\WoodgroveBank\CustomerCare\CustomerCareClient.sln
   g) Start running or debugging the client        
   h) Click the "Tranasction Integrator" radio button on the Configuration property page
   i) Click the "Start Work" command button
8) Operations
   a) After Start Work is successfully completed the "Work" property page is shown
   b) Enter a customer name (e.g. Kim Akers)
   c) Remember to click the "Finished with Customer" command button on the "Work" 
      Property page when you are finished 
   d) Click "Work with Customer" command button  
   e) When finished, click the "Finish work" command button
   f) Click the "Re-Configure" command button    
9) You can use the real 3270 Application for view any changes or addition made 
   during 3270 Emulation of Transaction Integration ATM usage or to 
   add/update Customer and Account information.
