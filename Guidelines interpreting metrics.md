# Interpreting monitoring metrics

*This post is Part 3 of a 3-part series about setting up proper monitoring on your Umee monitornig.*

* [Part 1.](https://github.com/studentmtk/Umee_monitoring/blob/main/README.md) Installation Instructions
* [Part 2.](https://github.com/studentmtk/Umee_monitoring/blob/main/Troubleshooting%20telegrafm.md) Troubleshooting telegraf
* [Part 3.](https://github.com/studentmtk/Umee_monitoring/blob/main/Guidelines%20interpreting%20metrics.md) Interpreting monitoring metrics

## Interpreting monitoring metrics

### Telegraf | A Metrics Collector For InfluxDB

Telegraf can collect metrics from a wide array of inputs and write them to a wide array of outputs. It is plugin-driven for both collection and output of data so it is easily extendable. It is written in Go, which means that it is compiled and standalone binary that can be executed on any system with no need for external dependencies, or package management tools required.

![Architecture](https://i.imgur.com/xmbND94.png)

### The Telegraf agent runs on the Validator node and sends metrics data to your InfluxDB database. 

### Metrics Explained

#### Server performance metrics:
- Server uptime
- Server Load Average
- Server memory utilization - Used, cached, free
- CPU utilization
- Swap - usage and IO
- Disk IO - requests, bytes and time per disk
- Disk Usage, ramdisk usage if used.

#### Umee Validator Application performance metrics:
- VOTING_POWER
- Missed blocks -The count starts from the moment the active validator is started. If you are in jail, then after the validator is resumed, the count of the missed blocks will start from 0
- Height your node
- STATUS - The node status is synchronized, not synchronized, the node is stopped.
- Height Nodes_guru node - the height of the Nodes guru node. (if you have just launched the validator, you will be able to see how far the network has run.) If the node Nodes_guru is stopped or not synchronized, you will see the corresponding inscription.
- Up_time - the percentage of signed blocks by your validator to the total number of blocks since the validator was launched.
- status_jailed

