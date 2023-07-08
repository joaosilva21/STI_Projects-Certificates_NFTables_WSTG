# STI_Project-NFTables and Suricata

- [x] Finished

## Index:
- [Description](#description)
- [To run this project](#to-run-this-project)
- [Notes important to read](#notes-important-to-read)

## Description:
Configuration of a firewall (type: packet filter) using NFTables to limit the access to some services in some VMs (networks). After that it's requested to configures an IDS/IPS, in our case we choose Suricata. This mechanisms must be able to block SQL Injection and DoS attacks

## To run this project:
You will need 4 VMs to create the scenario presented. It's recommended to read the report (unfortunately for you is in portuguese .-.).
You can simply put the files in your VMs like they are in this repository.<br>
To put the NFTables rules working use the following command:
 ```shellscript
 /home/stipl2:~$ nft -f router.nft
 ```

To run the suricata in inline mode (IPS) use the following command:
```shellscript
 /home/stipl2:~$ suricata -q 0
 ```

## Notes important to read
- To understand what are and how the commands work see the statement and the report files
