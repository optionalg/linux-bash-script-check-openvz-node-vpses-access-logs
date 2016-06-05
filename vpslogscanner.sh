# Empty report file populated in previous run
> /tmp/allvpslogscanneroutput

# This script tail webserver access logs on all VPSs using VZCTL OpenVZ utility and create report fille which can be sent via email and coppied to the public webserver path for admin to check
# If you are unable or do not wish to host resulting report on the OVZ server or any of its VPS, comment out line below line "# Create WebPage Out Of Log File command"# If you are unable or do not wish to host resulting report on the OVZ server or any of its VPS, comment out line below line "# Create WebPage Out Of Log File command", if you do wish to have web accessible report of all VPS access logs, then edit that line

# exclude CTIDs
exclude="860|1234|65432"
adminmail=adminmail@gmail.com

########### cPanel acccess logs

for ctid in $(vzlist -Ho ctid|grep -vE "$exclude");do

cmd="echo \"----------- CTID $ctid IP $(vzlist $ctid -Ho ip) cPanel access logs: -----------\" && tail -n 50 /usr/local/apache/domlogs/*|grep -vE \"bytes|offsetftp|ftpxfer\"|grep \".\""

vzctl exec $ctid $cmd 2>/dev/null >> /tmp/allvpslogscanneroutput

done

########### zPanel access logs

for ctid in $(vzlist -Ho ctid|grep -vE "$exclude");do

if [ "$(vzctl exec $ctid ls /var/zpanel/logs/domains/zadmin/*access.log 2>/dev/null)" == "" ];then
#echo "There is no such dir at $ctid, continue next iteration"
continue
fi

cmd="echo \"----------- CTID $ctid IP $(vzlist $ctid -Ho ip) zPanel access logs: -----------\" && tail -n 50 /var/zpanel/logs/domains/zadmin/*access*|grep -vE \".png|.gif|.ico|.jpg|robots|GET / HTTP\""

vzctl exec $ctid $cmd 2>/dev/null >> /tmp/allvpslogscanneroutput

# awk '{print $7}'

done

########### Nginx access logs

for ctid in $(vzlist -Ho ctid|grep -vE "$exclude");do

if [ "$(vzctl exec $ctid ls /var/log/nginx/*access.log* 2>/dev/null)" == "" ];then
#echo "There is no such dir at $ctid, continue next iteration"
continue
fi

cmd="echo \"----------- CTID $ctid IP $(vzlist $ctid -Ho ip) Nginx access logs: -----------\" && tail -n 50 /var/log/nginx/*access.log|grep -vE \".png|.gif|.ico|.jpg|robots|GET / HTTP\""

vzctl exec $ctid $cmd 2>/dev/null >> /tmp/allvpslogscanneroutput

done

########### Webmin/Virtualmin access logs

for ctid in $(vzlist -Ho ctid|grep -vE "$exclude");do

if [ "$(vzctl exec $ctid ls /var/log/virtualmin 2>/dev/null)" == "" ];then
#echo "There is no such dir at $ctid, continue next iteration"
continue
fi

cmd="echo \"----------- CTID $ctid IP $(vzlist $ctid -Ho ip) Webmin/Virtualmin access logs: -----------\" && tail -n 50 /var/log/virtualmin/*|grep -vE \".png|.gif|.ico|.jpg|robots|GET / HTTP\""

vzctl exec $ctid $cmd 2>/dev/null >> /tmp/allvpslogscanneroutput

done

########## Apache2 access logs (VestaCP..)

for ctid in $(vzlist -Ho ctid|grep -vE "$exclude");do

if [ "$(vzctl exec $ctid ls /var/log/apache2/domains 2>/dev/null)" == "" ];then
#echo "There is no such dir at $ctid, continue next iteration"
continue
fi

cmd="echo \"----------- CTID $ctid IP $(vzlist $ctid -Ho ip) Apache2 (VestaCP...) error logs: -----------\" && tail -n 50 /var/log/apache2/domains/*.error.log|grep -vE \".png|.gif|.ico|.jpg|robots|GET / HTTP\""

vzctl exec $ctid $cmd 2>/dev/null >> /tmp/allvpslogscanneroutput

done

########## Apache access logs

for ctid in $(vzlist -Ho ctid|grep -vE "$exclude");do

cmd="echo \"----------- CTID $ctid IP $(vzlist $ctid -Ho ip) Apache access logs: -----------\" && tail /var/log/httpd/access_log 2>/dev/null|grep -vE \"myadmin|MyAdmin|baidu\"| awk '{print $7}'|grep -vE \".png|.gif|.ico|.jpg\"|sort -u;tail /var/log/apache2/access.log 2>/dev/null|grep -vE \"myadmin|MyAdmin|baidu\"| awk '{print $7}'|grep -vE \".png|.gif|.ico|.jpg\"|sort -u"

vzctl exec $ctid $cmd 2>/dev/null >> /tmp/allvpslogscanneroutput

done

########## Create webpage out of logfile

# Create Web accessible page Out Of Log File (/tmp/allvpslogscanneroutput)
cp -f /tmp/allvpslogscanneroutput /vz/root/MYOPENVZVPSID/home/MYCPANELUSERNAME/public_html/vpslogs.txt; vzctl exec MYOPENVZID chown MYCPANELUSERNAME:MYCPANELUSERNAME /home/MYCPANELUSERNAME/public_html/vpslogs.txt

########## Send email

echo -e "Script /root/sh/vpslogscanner ran at $(hostname) on $(date) and attached are access logs of all hosted VPSs except CTID $exclude \nView the logs on the web: http://MYDOMAINNAME.cz/vpslogs.txt" | mutt -a "/tmp/allvpslogscanneroutput" -s "VPSs access logs Report" -- $adminmail
