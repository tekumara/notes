# graphQL

Companies I'm familiar with have started with traditional BFFs and have since implemented GraphQL. A quick overview follows (probably not all new to you)

GraphQL was implemented to improve cross-team velocity.

It acts as an aggregation service or middleware. GraphQL can build a single federated domain model across all teams/endpoints. It aids the discovery, exploration, and use of this domain model. As a frontend team, you can think in terms of this domain model, not endpoints.

GraphQL is a BFF. But whereas traditional BFFs serve one frontend, GraphQL can serve multiple frontends. So one way of thinking about GraphQL is as a more powerful/complex BFF than a traditional BFF. The "I know where everything is for everyone service"

Example: you have desktop and mobile frontend teams across multiple markets all with their own BFFs designed specifically for their interface. Now the Magic AI backend team creates a new backend API. Everyone wants this cool new feature. With traditional BFFs, each frontend team needs to add a new point-to-point backend integration. With GraphQL, the GraphQL team adds a resolver once and the frontend teams can pull the new data with only changes to their SPA.

The scope of building a whole-of-company GraphQL domain model is large and requires a lot of coordination. Plus the GraphQL team becomes a centralisation point, requiring management of complexity and throughput due to centralisation.

## Mutations

eg:

```
mutation createProject($tenantId: UUID!, $name: String!, $description: String) {
  create_project(
    input: {tenant_id: $tenantId, name: $name, description: $description}
  ) {
    id
  }
}
```

The first line names the mutation `createProject`. It has variables named `tenantId`, `name`, and `description`. These names are defined by the client and are arbitary.

The mutation calles the endpoint `create_project` which expects an `input` param. This is defined by the server.

## GQL Client

```
go run git.sr.ht/~emersion/gqlclient/cmd/gqlclient@latest https://countries.trevorblades.com/

query {
  countries { name }
}
```

With variables:

```
go run git.sr.ht/~emersion/gqlclient/cmd/gqlclient@latest -v code=OC https://countries.trevorblades.com/

query($code: String) {
  countries (filter: {continent: {eq: $code}} ) { name, continent { code, name} }
}
```
