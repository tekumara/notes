# prefect api

Seems to have snake case (recommended) and pascal case versions of the API.

Create project (snake case):

```gql
mutation create_project {
  create_project(input: { name: "Test" }) {
    id
  }
}
```

Returns

```json
{
  "data": {
    "create_project": {
      "id": "ed91a397-d153-42bd-9f00-073c969ba3c9"
    }
  }
}
```

Delete project (pascal case):

```gql
mutation deleteProject {
  deleteProject(input: { projectId: "ed91a397-d153-42bd-9f00-073c969ba3c9" }) {
    success
    error
  }
}
```

Returns

```json
{
  "data": {
    "deleteProject": {
      "success": true,
      "error": null
    }
  }
}
```

Query project

```gql
query getProject($id: uuid!) {
  project_by_pk(id: $id) {
    created
    description
    id
    name
    tenant_id
    updated
  }
}
```

Example unauthorized response:

```json
{
  "errors": [
    {
      "path": ["create_project"],
      "message": "Unauthorized",
      "extensions": {
        "code": "FORBIDDEN"
      }
    }
  ],
  "data": {
    "create_project": null
  }
}
```

List all projects

```
query listProjects {
  project {
    created,
    description,
    id,
    name,
    tenant_id,
    updated
  }
}
```

Auth info

```
query auth_info {
  auth_info {
    user_id
    tenant_id
    role_id
    permissions
    token_type
    token_expires
    token_id
    api_token_scope
    license
    token_jti
    role
  }
}
```

Auth roles (READ_ONLY_USER, RUNNER, ENTERPRISE_LICENSE_ADMIN, TENANT_ADMIN, USER):

```
{
  auth_role {
    id
    name
    permissions
    tenant_id
  }
}
```

User memberships across roles and tenants

```
query User {
  user {
    id
    username
    email
    settings
    default_membership_id
    first_name
    last_name
    memberships {
      id
      tenant {
        id
        name
        slug
        __typename
      }
      role_detail {
        id
        name
        __typename
      }
      __typename
    }
    __typename
  }
}
```

Query tenants the user knows about

```
query Tenants {
  tenant {
    id
    created
    name
    info
    settings
    prefectAdminSettings: prefect_admin_settings
    stripe_customer
    license_id
    slug
    __typename
  }
}
```

All users in tenant

```
query TenantUsers {
  tenantUsers: user_view_same_tenant {
    id
    username
    email
    first_name
    last_name
    account_type
    memberships {
      id
      tenant_id
      role_detail {
        id
        name
        __typename
      }
      __typename
    }
    __typename
  }
}
```

All service accounts in tenant

```
query TenantUsers {
  tenantUsers: user_view_same_tenant(where: {account_type: {_eq: "SERVICE"}}) {
    id
    username
    email
    first_name
    last_name
    account_type
    memberships {
      id
      tenant_id
      role_detail {
        id
        name
        __typename
      }
      __typename
    }
    __typename
  }
}
```

Query all api keys (including user api keys)

```
query APIKeys {
  auth_api_key(order_by: {created: desc}) {
    id
    name
    created
    expires_at
    default_tenant_id
    user_id
    updated
    created_by {
      id
      username
      __typename
    }
    __typename
  }
}
```

Query current user

```
query User {
  user {
    id
    username
    email
    settings
    default_membership_id
    first_name
    last_name
    memberships {
      id
      tenant {
        id
        name
        slug
        __typename
      }
      role_detail {
        id
        name
        __typename
      }
      __typename
    }
    __typename
  }
}
```

## update projects

```
mutation setProjectName($projectId: UUID!, $name: String!) {
  setProjectName(
    input: { projectId: $projectId, name: $name }
  ) {
    project {
      name,
      description,
      tenant_id
    }
  }
}

mutation setProjectDescription($projectId: UUID!, $description: String!) {
  setProjectDescription(
    input: { projectId: $projectId, description: $description }
  ) {
    project {
      name,
      description,
      tenant_id
    }
  }
}
```

## gqlclient

Create project using gqlclient:

```
go run git.sr.ht/~emersion/gqlclient/cmd/gqlclient@latest -H Authorization:"Bearer $PREFECT__CLOUD__API_KEY" -v name=delete-me https://api.prefect.io/
mutation createProject($tenantId: UUID, $name: String!, $description: String) {
  create_project(
    input: {tenant_id: $tenantId, name: $name, description: $description}
  ) {
    id
  }
}
```

Get project using gqlclient:

```
go run git.sr.ht/~emersion/gqlclient/cmd/gqlclient@latest -H Authorization:"Bearer $PREFECT__CLOUD__API_KEY" -v id=ed91a397-d153-42bd-9f00-073c969ba3c9 https://api.prefect.io/
query getProject($id: uuid!) {
  project_by_pk(
    id: $id
  ) {
    created,
    description,
    id,
    name,
    tenant_id,
    updated
  }
}
```
