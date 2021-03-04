
Running Woodgrove Bank Customer Care using Transaction Integrator for the AS/400
1) Make sure you follow the steps in the following files found in %SNARoot%\..\SDK\Samples\EndToEndScenarios\WoodgroveBank
   a) Readme-07-CustomerCare-TI-AS400-Setup.txt
2) Open the Woodgrove Bank Customer Care Solution found in 
   %SNARoot%\..\SDK\Samples\WoodgroveBank\CustomerCare 
   by double clicking on file "CustomerCareClient.sln"
3) Build the Woodgrove Bank Customer Care client
   a) Select the sample Woodgrove Bank Customer Care project named "CustomerCareClient" 
   b) Expand node "References" and remove the refernece to "WoodgroveBank_ELMLink" 
   c) Right click "References", click "Add Reference..." and browse to 
      "%SNARoot%\..\SDK\Samples\EndToEndScenarios\WoodgroveBank\CustomerCare\TransactionIntegrator\Assemblies"
   d) Select "WoodgroveBank_DPC.dll", click "OK"   
   e) Make sure all Reference are correctly set on you machine. If necessary Browse to
      the correct locations for the Microsoft.HostIntegration.TI.ClientContext and Microsoft.HostIntegration.TI.Managed3270LU0
   f) Double click "AccountHandler.cs"
   g) Find Account Handler for TI ("class AccountHandlerTI: AccountHandler")
   h) Make the following changes:
      1) Comment out the line containing "private CustomerCareELMLink _Handler = null;"
      2) Uncomment the line containing "//private CustomerCareDPC _Handler = null;"
      3) Comment out the line containing "_Handler = new CustomerCareELMLink();"
      4) Uncomment the line containing "//_Handler = new CustomerCareDPC();"
   i) If access to the AS/400 requires valid security credentials:
      1) Find funciton "ValidateCustomer()"
      2) Change "MYUSERID" to a valid user id on the AS/400 
      3) Change "MYPSWD" to a valid password for the user id used in the prior step
   j) Right click on the "CustomerCareClient" project and click Rebuild
4) Configuration for a Scenario using Tranasction Integrator
   a) Using the TI Manager, Import the RE and TI .NET objects.
   b) Right click on the "Windows-Initiated Processing" node and click "Import", then "Next"
   c) Click "Use Exported Definitions"
   d) Specify or browse to directory %SNARoot%\..\SDK\Samples\EndToEndScenarios\WoodgroveBank\CustomerCare\TransactionIntegrator\TIConfiguration
   e) Click "Next", then "Finish"
5) Update Remote Environment definitions with correct IP address and port details
   a) Start TI Manager
   b) Expand the "Transaction Integrator" node, then expand "Window-Initiated Processing" node, then expand the "Remote Environments" node
   c) Right click on the "OS400 DPC Woodgrove Bank" RE and click "Properties"
   d) Click the "TCP/IP tab and set the appropriate values for the "IP/DNS Address" and "Port list" fields, then click OK
   e) If access to the AS/400 requires security credentials, click on the "Security" tab and check 
      "Require client provided security" 
   f) Click "OK" 
6) Start the Customer Care Application
   f) Open the Customer Care Solution: %SNARoot%\..\SDK\Samples\EndToEndScenarios\WoodgroveBank\CustomerCare\CustomerCareClient.sln
   g) Start running or debugging the client        
   h) Click the "Tranasction Integrator" radio button on the Configuration property page
   i) Click the "Start Work" command button
7) Operations
   a) After Start Work is successfully completed the "Work" property page is shown
   b) Enter a customer name (e.g. Kim Akers)
   c) Remember to click the "Finished with Customer" command button on the "Work" 
      Property page when you are finished 
   d) Click "Work with Customer" command button  
   e) When finished, click the "Finish work" command button
   f) Click the "Re-Configure" command button    
