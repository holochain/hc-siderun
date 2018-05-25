# hc-siderun

Helper utility for initializing a cluster of holochain nodes all connecting to a local bootstrap server (and thus, to each other)

## What is this?

Ever find yourself working on a holochain app, needing to quickly spin up a local cluster of nodes that can all talk to each other?

hc-siderun will set up a cluster of nodes to run your test app. It runs a bootstrap server, and connects all the nodes to it, so they have routing information.

## Quickstart

Put `./bin/hc-siderun` in your path (or `sudo cp ./bin/hc-siderun /usr/local/bin`)

Cd into your development app dir `cd HoloWorld`

Initialize the cluster:

```
hc-siderun init -p=.
```

Start up the cluster:

```
hc-siderun run
```

Browse to your nodes:

http://127.0.0.1:10001
http://127.0.0.1:10002
http://127.0.0.1:10003

## Cleanup

```
hc-siderun clean
```

## Working with cluster names

You can also initialize multiple clusters for different apps

```
hc-siderun init -c=cluster1 -p=project1
hc-siderun init -c=cluster2 -p=project2
```

```
$ hc-siderun list
cluster1
cluster2
```

```
$ hc-siderun del -c=cluster1
$ hc-siderun list
cluster2
```
