# mongosync

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

Update the contents of the `payload.json` file and run

```bash
curl localhost:27182/api/v1/start -XPOST --data @payload.json
```

### Permissions

If you have doubts regarding roles required by `mongosync`, please refer to the [official documentation](https://www.mongodb.com/docs/cluster-to-cluster-sync/current/connecting/onprem-to-onprem/#roles).
Depending on the type of sync you want to do, you will not need to create the following role and user for the source and destination dbs, this is just an example.

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
