* [Part 1.](https://github.com/studentmtk/Umee_monitoring/blob/main/README.md) Installation Instructions
* [Part 2.](https://github.com/studentmtk/Umee_monitoring/blob/main/Troubleshooting%20telegrafm.md)  Troubleshooting telegraf
* [Part 3.](https://github.com/studentmtk/Umee_monitoring/blob/main/Guidelines%20interpreting%20metrics.md) Interpreting monitoring metrics
 
# Troubleshooting telegraf

Diagnostics of the correct collection of metrics.
```
telegraf -test -config /etc/telegraf/telegraf.conf --input-filter=exec
```

Frequent bugs

![Architecture](https://i.ibb.co/sbqX96x/image.jpg)

Check  permissions. Make the script executable
```
sudo chmod 744 $HOME/Umee_monitoring/umee_monitor.sh
```
"Error in plugin: metric parse error"

![Architecture](https://i.ibb.co/T4Q55SS/image.jpg)

These errors are related to incorrect collection of metrics. Let's recreate this situation and look at an example. 
Let's edit the script so that it doesn't collect the VOTING_POWER metric.

![Architecture](https://i.ibb.co/dfsYff3/4324243.jpg)

Now, after executing the script, the value of VOTING_POWER is empty. This causes the error, remember this.

![Architecture](https://i.ibb.co/j8jFkcN/image.jpg)


The full guide can be found at the link https://github.com/influxdata/telegraf       https://docs.influxdata.com/telegraf/v1.20/

Read the description of the metrics.
* [Part 3.](https://github.com/studentmtk/Umee_monitoring/blob/main/Guidelines%20interpreting%20metrics.md) Interpreting monitoring metrics
