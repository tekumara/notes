# golang graphql client generators

[~emersion/gqlclient](https://git.sr.ht/~emersion/gqlclient) generates simpler and cleaner code because it doesn't generate per-query type structs. All query functions will return the same type struct defined in the schema. Even if the graphql query specifies a subset of fields from the type, the full struct will still be returned.

If each query returning the same type selects the same set of fields this isn't a problem and you get the simplicity benefits. You can handcraft the schema type to only include the fields you want.

Field names will be the same as the schema. This can be a problem when fields names collide with type names, or when the names aren't uppercase and so won't be exported. Post-processing is needed to resolve these issues.

Example:

```
func GetProject(client *gqlclient.Client, ctx context.Context, id uuid) (project_by_pk *project, err error) {
```

- The graphl Client is a pointer to a struct.
- The context location is non-standard and the second param.

[Khan/genqlient](https://github.com/Khan/genqlient) generates more complex code because it generates per-query structs with per-query names.

It also generates:

- a response struct for every query with a single field. This is exposed to your program. ~emersion/gqlclient returns the field directly and so has one less layer.
- internal structs for holding inputs

```
func getProject(
    ctx context.Context,
    client graphql.Client,
    id string,
)
```

- The graphql Client is a interface.
- Multi-line formatting.
