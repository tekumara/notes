
# dbt

* uses git is a source of truth for all tables and enables gitops
* models - everything is a SELECT statement. Materializations determine how a model is persisted in the warehouse:
  * table - dropped and recreated
  * view - dropped and recreated
  * incremental - run on a subset of data
  * ephemeral - ie: a CTE
* models can reference other models and form a DAG
* [macros](https://docs.getdbt.com/docs/writing-code-in-dbt/macros) for reusing SQL across models
* sources - define source tables, so you can rerun all models that depend on it, and also check the freshness of sources
* seed data - eg: from a csv in the repo
* snapshot - snapshot tables (creates type 2 slowly changing dimensions)
* [analysis](https://docs.getdbt.com/docs/building-a-dbt-project/analyses) - create a SQL statement but don't execute it
* [packages](https://docs.getdbt.com/docs/guides/building-packages) eg: packaging from another git repo - [example](https://github.com/stkbailey/fivethirtyeight-dbt-data)
* testing
* documentation - shows model descriptions and DAG lineage (requires a host, eg: S3)
* metadata - models can have [tags](https://docs.getdbt.com/docs/building-a-dbt-project/building-models/tags/) (eg: pii, nightly) which can be referenced when running models or in the documentation 
* templating - ie: [SQL + Jinja](https://docs.getdbt.com/docs/writing-code-in-dbt/getting-started-with-jinja)
  * to create in different schemas
  * to reference other models or avoid hardcoding table names
  * to interpolate from variables provided in config or via the command line
  * is independent of the scheduler eg: Airflow     

Limitations
* Discussion on [partitioning ala hive](https://discourse.getdbt.com/t/on-the-limits-of-incrementality/303/6)
* [How we treat big data models in our dbt setup](https://discourse.getdbt.com/t/how-we-treat-big-data-models-in-our-dbt-setup/704)
* No scheduler - see dbt cloud

References
* [Only run changed models](https://discourse.getdbt.com/t/tips-and-tricks-about-working-with-dbt/287/2)
* [dbt coding conventions](https://github.com/fishtown-analytics/corp/blob/master/dbt_coding_conventions.md)
* [snowflake cost monitoring example](https://github.com/randypitcherii/cloud_cost_monitoring) uses Github Actions for CI/CD and deploys each PR to its own schems
* [seed data example](https://github.com/stkbailey/fivethirtyeight-dbt-data) from FiveThirtyEight