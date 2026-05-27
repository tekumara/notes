# openshell

Three runtime components -- the CLI, the Gateway, and the Supervisor.

## Architecture

### Supervisor

Inside a pod, there is a supervisor and agent process.

The supervisor (PID 1) is privileged (CAP_SYS_ADMIN, CAP_NET_ADMIN, CAP_SYS_PTRACE, CAP_SYSLOG, runAsUser: 0). It creates a network namespace, spawns the agent process inside it, applies Landlock filesystem restrictions, and seccomp filters. All Linux namespaces are shared between supervisor and agent except the network namespace.

Supervisors connect outbound to the gateway and establish a long-lived GRPC session rather than being dialed by it.

Enforces

- network policy (only allows network access via the HTTP CONNECT proxy)
- filesystem isolation (Landlock on Linux)
- syscall filtering (seccomp on Linux)
- tool call policy

The supervisor holds a workload identity (sandbox JWT) used for gateway RPCs. This is not shared with the sandboxed process.

#### Network proxy

The OpenShell CONNECT proxy runs inside each sandbox workload, as part of the openshell-sandbox supervisor process.

On Linux proxy mode, the supervisor creates a nested network namespace with a veth pair:

```text
Sandbox container
    ├─ Supervisor
    │    └─ CONNECT proxy on host-side veth, usually 10.200.0.1:3128
    └─ Agent process in nested netns
        └─ default route points at proxy side
```

[Proposal: Split Supervisor and Agent into Separate Pods with gVisor Isolation](https://github.com/NVIDIA/OpenShell/issues/981)

[RFC 0001 - Core Architecture](https://github.com/NVIDIA/OpenShell/blob/main/rfc/0001-core-architecture/README.md)

### Gateway

- compute for sandbox lifecycle
- credential injection
- inference routing
- sandbox-to-sandbox routing/relay
- logs sent from supervisor
- policy for sandboxes
