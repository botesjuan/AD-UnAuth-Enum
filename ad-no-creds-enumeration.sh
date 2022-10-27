#!/bin/bash

hline="# --------------------------------------------------- "

# confirm target file provided as parameter
if [[ -z $1 ]];
then 
    	echo "Please Provide target filename and output filename as a parameters to the script."
    	exit 0
else
	echo "Target Filename = $1 "
	echo "Output Filename = $2 "
	targetfilename=$1
	captureedoutput=$2
fi

printf "$hline\n Active Directory UnAuthenticated Enumeration \n$hline \n\n" | tee -a $captureedoutput

# Kali Host Ethernet info

printf "$hline\n Kali Host Ethernet Network Info \n$hline \n" | tee -a $captureedoutput
nmcli dev show eth0 | tee -a $captureedoutput

# NMAP Scans

printf "$hline\n NMAP Classic Scan Network \n$hline \n" | tee -a $captureedoutput
nmap -sC -sV -iL $targetfilename | tee -a $captureedoutput

printf "$hline\n NMAP Full Scan Network \n$hline \n" | tee -a $captureedoutput
nmap -sC -sV -p- -iL $targetfilename | tee -a $captureedoutput

printf "$hline\n NMAP SMB Vuln Scan Network \n$hline \n" | tee -a $captureedoutput
nmap -PN --script smb-vuln* -p 139,445 -iL $targetfilename | tee -a $captureedoutput

printf "$hline\n CrackMapExec SMB Scan \n $hline \n" | tee -a $captureedoutput

# CrackMapExec SMB

while read -r line; do
	targetvalue=$line
	echo "Target scanned:" $targetvalue
	printf "$hline\n $targetvalue \n $hline \n" | tee -a $captureedoutput
	crackmapexec smb $targetvalue | tee -a $captureedoutput
    
done <$targetfilename 

# End.

printf "$hline\n End of Active Directory Report \n$hline \n" | tee -a $captureedoutput

highlight -i $captureedoutput -o ADReport.html -O html -l -T "Active Directory Report" --syntax py
