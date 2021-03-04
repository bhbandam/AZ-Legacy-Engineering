
Running Woodgrove Bank Customer Care using 3270 Emulation
1) Make sure you follow the steps in the following files found in %SNARoot%\..\SDK\Samples\EndToEndScenarios\WoodgroveBank  
   a) Readme-01-VTAM-LU0-LU2-Setup.txt 
   b) Readme-02-CICS-LU0-LU2-Setup.txt
   c) Readme-03-3270-Application-Setup.txt
   d) Readme-06-Configure-HIS.txt
2) Open the Woodgrove Bank Customer Care Solution found in 
   %SNARoot%\..\SDK\Samples\EndToEndScenarios\WoodgroveBank\CustomerCare
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
5) Configuration for a Scenario using 3270 Emulation
   a) Open the Customer Care Solution: %SNARoot%\..\SDK\Samples\EndToEndScenarios\WoodgroveBank\CustomerCare\CustomerCareClient.sln
   b) Start running or debugging the client        
   c) Click the "3270" Radio button on the Configuration property page
   d) Set the LUA Pool name and the CICS Alias name
      1) See the 3270 Parameters group on the left side of the of the main UI windows   
      2) Enter the LU Nme of Pool name that you configured above (e.g. TERMPOOL)
      3) Enter the name of the CICS region that you use for testing (e.g. WNWCI22C)
      4) Click the "Start Work" command button  
6) Operations
   a) After Start Work is successfully completed the "Work" property page is shown
   b) Enter a customer name (e.g. Kim Akers)
   c) Remember to click the "Finished with Customer" command button on the "Work" 
      Property page when you are finished 
   d) Click "Work with Customer" command button  
   e) When finished, click the "Finish work" command button
   f) Click the "Re-Configure" command button    
8) You can use the real 3270 Application for view any changes or addition made 
   during 3270 Emulation of Transaction Integration ATM usage or to 
   add/update Customer and Account information.
