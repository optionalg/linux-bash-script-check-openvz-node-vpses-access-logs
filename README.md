# About, what does it do

Linux bash script to tail webserver access logs of the VPSs hosted on the OpenVZ VPS host node server.

The aim is to discover which webpages are hosted on the VPSs and which subpages are visited.

Script sends an email report to the host node admin. Resulting file is attached to the email and also script create .txt file on public web path so admin can conveniently view the report.

Script so far supports these access logs: cPanel,zPanel,Nginx,Webmin,Apache,Apache2

# Requirements

Linux

"mutt" software is used to send out report file via email. Alternative is "mail", it can be used if report file in email attachment is not needed (script also create report file in public webserver path)

OpenVZ "vzctl" utility (script can be easilly tweaked to work with different VPS node management utility)

# Installation

chmod 700 /path/to/script

Update variables in the script (email, excluded VPS IDs(CTID) and the command that setup the .txt file in your web server path)

Do test run if you want to (./path/to/script)

Setup cronjob like weekly or monthly
