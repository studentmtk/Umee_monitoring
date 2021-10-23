#### Let's check how the script works (we will not wait for problems with the node, but we will simulate it like in football). 
![Architecture](https://i.ibb.co/nnsyTGj/34.jpg)

For example, comment out the REAL_BLOCK line and save the changes in the script
```
nano $HOME/Umee_alert_TG/Umee_alert_TG.sh
```
![Architecture](https://i.ibb.co/bBB4XJV/image.jpg)

run the script manually and you will receive a notification that the Nodes_Guru node has problems.
```
bash $HOME/Umee_alert_TG/Umee_alert_TG.sh
```

#### Let's simulate the situation that our node is lagging behind the network (we will compare it with the control node Nodus_guru)
Change a couple of parameters

```
nano $HOME/Umee_alert_TG/Umee_alert_TG.sh
```
![Architecture](https://i.ibb.co/wQg2nXr/image.jpg)

![Architecture](https://i.ibb.co/t2LVJVr/1.jpg)

```
bash $HOME/Umee_alert_TG/Umee_alert_TG.sh
```
You will receive an alert

#### Imagine that you are in prison. Change a couple of parameters.
```
nano $HOME/Umee_alert_TG/Umee_alert_TG.sh
```

![Architecture](https://i.ibb.co/nnTs0D1/image.jpg)

```
bash $HOME/Umee_alert_TG/Umee_alert_TG.sh
```
You will receive an alert.


### After you check all the alert situations, don't forget to restore the correct script settings !!!






