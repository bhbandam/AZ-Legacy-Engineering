Running the Woodgrove Bank ATM
1) Make sure you follow the steps in 
   a) Readme-01-VTAM-LU0-LU2-Setup.txt
   b) Readme-02-CICS-LU0-LU2-Setup.txt
   c) Readme-04-ATM-LU0-Setup.txt
   d) Readme-06-Configure-HIS.txt
1) Open the Woodgrove Bank ATM Solution found in 
   <installdir>\SDK\Samples\WoodgroveBank\ATM 
   by double clicking on file "ATMClient.sln"
2) Build the Woodgrove Bank ATM client
   a) Select the sample Woodgrove Bank ATM project named "ATMClient" 
   b) Right click on the "ATMClient" project and click Rebuild
3) Start running or debugging the client
4) Set the LUA Pool name and the CICS Alias name
   a) See the SNA Configuration group in the lower right corner of the main UI windows   
   b) Enter the LU Nme of Pool name that you configured above (e.g. LUAPOOL)
   c) Enter the name of the CICS region that you use for testing (e.g. WNWCI22C)
5) Click "Start work" in the lower right hand corner   
6) Operations
   a) Enter an account number (CHK4566112 is a predefined account number for Kim Akers)
   b) Enter the 4 digit Pin number for the account (1111 is a predefined pin for account CHK4566112)
   c) Click around on the ATM options
   d) Click Finish when done.
7) Use the 3270 Application for view any changes or addition made during ATM usage or to 
   add/update Customer and Account information.

