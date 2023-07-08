# STI_Project-Certificates and OpenVPN

- [x] Finished

## Index:
- [Description](#description)
- [To run this project](#to-run-this-project)
- [Notes important to read](#notes-important-to-read)

## Description:
Configuration of CA and respective certificates to create openvpn communications (tunnels) between some VMs. From this a client (Road Warrior) must be able to connect to a website in other network (Lisboa), but only if he has a valid certificate. For the Road Warrior is also necessary to configure MFA to create a tunnel. 

## To run this project:
You will need 3 VMs to create the scenario presented. It's recommended to read the report (unfortunately for you is in portuguese .-.).
You can simply put the files in your VMs like they are in this repository OR you can use our script "deploy.sh" :D<br>
This script have some functionalities, like create keys, CSRs and certificates and distribute all the necessary files for all the VMs automatically! It can be used to organize the files in the right folders. You can see how the files must be organized on page 20 and 21 of the report.

## Notes important to read
- To understand what are and how the commands work see the statement and the report files
