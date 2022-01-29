# grpcurl

Requires one of these [descriptor sources](https://github.com/fullstorydev/grpcurl#descriptor-sources):

- server with reflection
- .proto source files
- compiled protoset files.

List all service defined in proto source file

```
grpcurl -import-path ~/code3/ray/src/ray/protobuf -proto ray_client.proto list
```

Describe the ray.rpc.RayletDriver service

```
grpcurl -import-path ~/code3/ray/src/ray/protobuf -proto ray_client.proto -plaintext describe ray.rpc.RayletDriver
```

Invoke the service

```
grpcurl -import-path ~/code3/ray/src/ray/protobuf -proto ray_client.proto -plaintext  -d '{ "type": "PING" }' localhost:10001 ray.rpc.RayletDriver/ClusterInfo 
```
