-- Introduction --

The Managed Provider for Host Files provides a 'offline' capability which allows read-only access to host file data located locally in the Windows workstation hard-disk. In order to use the Managed Provider for Host Files in offline mode, you need first to download a existing Mainframe dataset using a file transfer method, like FTP.
After the file is downloaded, a property in the Managed Provider for Host Files should be used to indicate that the file access is local and will not use the network. This property is named ' Local Folder'  and it should point to the path of a local folder (not a UNC share) in which the host file resides. The host files should not be converted from EBCDIC. They should contain the data as it is on the host as data conversion will be performed by the Managed Provider for Host Files.
The host file should have the control information removed and should consist only of the record data (no record delimiters or VSAM control information). This can be achieved with the use of TSO's SORT command.
In order to use the offline capabilities with the Woodgrove Bank sample, you need to follow the below instructions.

-- Instructions --

1) Perform the steps described in the readme file named '<Installation Folder>\SDK\Samples\EndToEndScenarios\WoodgroveBank\Readme-AccountManagement-HostFileProvider.txt';

2) Use TSO's SORT command to create a copy of file MYUSERID.HIS85.WGRVBANK without the VSAM control information;

3) Use a FTP tool to connect to the Host and download the file created in step 2;

4) Add the following to the connection string created in the section 'Creating a Connection String' of file  'Readme-AccountManagement-HostFileProvider.txt';

4.1) Local Folder = <The name of the folder  where the download file was placed in step 3>;

5) Run the Woodgrove bank sample using the connection string created in the previous step. Please note that you will only be able to run the sample with the "Move records from the host file to XML" option. All the other commands will not execute with the offline capability as it only allows read access to the data.
