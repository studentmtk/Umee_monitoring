# **Umee monitornig**


* [Part 1.](https://github.com/studentmtk/Umee_monitoring/blob/main/README.md) Installation Instructions
* [Part 2.](https://github.com/studentmtk/Umee_monitoring/blob/main/Troubleshooting%20telegrafm.md)  Troubleshooting telegraf
* [Part 3.](https://github.com/studentmtk/Umee_monitoring/blob/main/Guidelines%20interpreting%20metrics.md) Interpreting monitoring metrics



## Introduction

### Telegraf | A Metrics Collector For InfluxDB

Telegraf can collect metrics from a wide array of inputs and write them to a wide array of outputs. It is plugin-driven for both collection and output of data so it is easily extendable. It is written in Go, which means that it is compiled and standalone binary that can be executed on any system with no need for external dependencies, or package management tools required.

Telegraf is an open-source tool. It contains over 200 plugins for gathering and writing different types of data written by people who work with that data.

### Telegraf benefits
- Easy to setup
- Minimal memory footprint
- Over 200 plugins available
- Able to send metrics to central InfluxDB over http(s) without the need of client configuration

### Architecture

![Architecture](https://i.imgur.com/xmbND94.png)

### Umee Monitoring
The solution consist of a standard telegraf installation and one bash script "umee_monitor.sh" that will get all server performance and validator performance metrics every 30 seconds and send all the metrics to a local or remote influx database server.


# Installation & Setup

In the example below we use Ubuntu 20.04.
To get all metrics from your local Validator RPC.

In the examples below we setup the validator with user "root" with it's home in /root/. It is required that the script is installed and run under that same user.
You need to install the telegraf agent on your validator nodes. 


```
# install telegraf
cat <<EOF | sudo tee /etc/apt/sources.list.d/influxdata.list
deb https://repos.influxdata.com/ubuntu bionic stable
EOF
```
```
sudo curl -sL https://repos.influxdata.com/influxdb.key | sudo apt-key add -

sudo apt-get update
sudo apt-get -y install telegraf jq bc
```
```
sudo adduser telegraf sudo
sudo adduser telegraf adm
sudo -- bash -c 'echo "telegraf ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers'
```
```
# Copy the original configuration file and and give it a new name
sudo cp /etc/telegraf/telegraf.conf /etc/telegraf/telegraf.conf.orig
sudo rm -rf /etc/telegraf/telegraf.conf
```
```
git clone https://github.com/studentmtk/Umee_monitoring.git
cd Umee_monitoring
sudo chmod 744 umee_monitor.sh; cd
```
Edit the variables in the script and replace them with your own values. To get the VAR_ADDR variable, you will need to enter the password your Umee wallet
replace $YOU_ME_WALLET with the name of your wallet
```
VAL_ADDR=$(umeed keys show $YOU_UMEE_WALLET --bech val -a)
```
```
moniker=$(curl -s localhost:26657/status | jq -r '."result"."node_info"."moniker"')
echo $VAL_ADDR $moniker
```
### If the command "echo $VAL_ADDR $moniker" does not output anything, you need to check the umeed service (systemctl status umeed  /journalctl -u umeed -f )
### If the echo command works correctly, continue the installation
```
sed -i "s/^umeevaloper*=.*/umeevaloper=$VAL_ADDR/" $HOME/Umee_monitoring/umee_monitor.sh
sed -i "s/^moniker*=.*/moniker=$moniker/" $HOME/Umee_monitoring/umee_monitor.sh
```
default path umeed=$HOME/go/bin/umeed  If your paths are different, make the necessary changes in $HOME/Umee_monitoring/umee_monitor.sh
the path to the umeed file can be found from you >>
```
which umeed
```
# Telegraf configuration
Add the configuration file /etc/telegraf/telegraf.conf based on the example below:

Change your hostname, mountpoints to monitor, location of the monitor script and the username. 
Use any text editor (nano, etc.)
```
sudo apt install nano
nano /etc/telegraf/telegraf.conf
```
```
# Global Agent Configuration
[agent]
  hostname = "Vasya-Petrovich" # set this to a name you want to identify your node in the grafana dashboard
  flush_interval = "15s"
  interval = "15s"

# Input Plugins
[[inputs.cpu]]
    percpu = true
    totalcpu = true
    collect_cpu_time = false
    report_active = false
[[inputs.disk]]
    ignore_fs = ["devtmpfs", "devfs"]
[[inputs.io]]
[[inputs.mem]]
[[inputs.net]]
[[inputs.system]]
[[inputs.swap]]
[[inputs.netstat]]
[[inputs.processes]]
[[inputs.kernel]]
[[inputs.diskio]]

# Output Plugin InfluxDB
[[outputs.influxdb]]
  database = "Umee"
  urls = [ "http://194.163.139.3:8086" ] # keep this to send all your metrics to the UMEE Community Validator Dashboard otherwise use http://yourownmonitoringnode:8086

[[inputs.exec]]
  commands = ["sudo su -c /root/Umee_monitoring/umee_monitor.sh -s /bin/bash root"] # change home and username to the us>
  interval = "10s"
  timeout = "5s"
  data_format = "influx"
  data_type = "integer"
   
```
```
sudo systemctl enable --now telegraf
sudo systemctl restart telegraf
systemctl status telegraf
# Ctrl-c
```
![Architecture](https://i.ibb.co/t3sx2QV/image.jpg)

Make sure that telegraf collects the script metrics correctly
```
telegraf -test -config /etc/telegraf/telegraf.conf --input-filter=exec
```
![Architecture](https://i.ibb.co/RhC6FFd/image.jpg)

Your dashboard will be available via the link
http://194.163.139.3:3000/
select your validator from the list 

![Architecture](https://i.ibb.co/K2rZh1S/132.jpg)


Please continue to [Part 2.](https://github.com/studentmtk/Umee_monitoring/blob/main/Troubleshooting%20telegrafm.md) # Troubleshooting telegraf



















