# linux-bash-script-check-openvz-node-vpses-access-logs

Linux bash script to tail access logs of the VPSs hosted on the OpenVZ VPS host node server.
The aim is to discover which webpages are hosted on the VPSs and which subpages are visited.
Script sends an email report to the host node admin. Resulting file is attached to the email and also script create .txt file on public web path so admin can conveniently view the report.

Script so far supports these access logs: Apache,zPanel,cPanel

# Installation

chmod 700 /path/to/script
Update variables in the script (email, excluded VPS IDs(CTID) and the command that setup the .txt file in your web server path)
Do test run if you want to (./path/to/script)
Setup cronjob like weekly or monthly
