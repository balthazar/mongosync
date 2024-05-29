# mongosync

This project intent is to provide an easy way to deploy and run mongosync, a tool to synchronize data between Mongo clusters, on Kubernetes.

### Deployment

Update the `cluster0` and `cluster1` fields in the manifest and apply it to create the deployment.

```bash
kubectl apply -f ./deploy.yml
```

Expose the port

```bash
kubectl port-forward svc/mongosync 27182:27182
```

Verify the connection

```bash
curl http://localhost:27182/api/v1/progress
```

### Migration

Update the contents of the `payload.json` file following the [start API parameters spec](https://www.mongodb.com/docs/cluster-to-cluster-sync/current/reference/api/start/#request-body-parameters) and run

```bash
curl localhost:27182/api/v1/start -XPOST --data @payload.json
```

### Permissions

Refer to the [official documentation](https://www.mongodb.com/docs/cluster-to-cluster-sync/current/connecting/onprem-to-onprem/#roles) in regards to which role is
required for the kind of sync you want to perform.

Note that unlike what the docs say, I could not start a sync unless the destination cluster user was given the `clusterAdmin` permission, when it should
only require `clusterMonitor` and `clusterManager`.

The following are mere templates of role and user creation for easy copy-paste if [user-write blocking](https://www.mongodb.com/docs/cluster-to-cluster-sync/current/reference/api/start/#user-write-blocking) is needed.

```js
db.adminCommand({
  createRole: "reverseSync",
  privileges: [ {
    resource: { db: "", collection: "" },
    actions: [ "setUserWriteBlockMode", "bypassWriteBlockingMode" ]
  }],
  roles: []
})

use admin

db.createUser({
  user: "mongosync-user",
  pwd: "<strong-password>",
  roles: [ "readWrite", "dbAdmin", "reverseSync"]
})
```
