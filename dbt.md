
# dbt
[dbt](http://getdbt.com/) makes it easy for data teams to version control and collaborate on data transformations.

dbt turns raw data into transformed data inside your data warehouse.
![dbt](https://d33wubrfki0l68.cloudfront.net/18774f02c29380c2ca7ed0a6fe06e55f275bf745/a5007/ui/img/svg/product.svg)

## Git + CI/CD 
Store dbt projects in a git repo. This becomes the source of truth for all your table definitions and a shared body of knowledge. When combined with CI/CD this enables a workflow with approval via PR, tests in test schemas, and releases to production. See this [example](https://github.com/randypitcherii/cloud_cost_monitoring) which uses Github Actions. Every PR creates and deploys models into a new schema. Automated and exploratory tests run on sample data in the PR schema, before going to production ([video](https://www.youtube.com/watch?v=snp2hxxWgqk)).

## Features
* models are the core concept in dbt. One model = one table. Every model is a SQL SELECT statement.
* dbt turns models into tables and views in a warehouse using one of these [materialization strategies](https://docs.getdbt.com/docs/building-a-dbt-project/building-models/materializations):
  * table - dropped and recreated
  * view - dropped and recreated
  * incremental - run on a subset of data
  * ephemeral - i.e. a CTE
* models can reference other models and form a DAG. dbt uses the DAG to execute models in the correct sequence, and to perform [partial DAG updates to children/parents](https://docs.getdbt.com/reference/model-selection-syntax/) if requested.
* metadata - models can have [tags](https://docs.getdbt.com/docs/building-a-dbt-project/building-models/tags/) (e.g., PII, nightly) which can be referenced when running models or in the documentation 
* [documentation](https://blog.getdbt.com/using-dbt-docs/) can be auto-generated from the models into a static website. The docs include descriptions (with markdown support), a visualisation of the DAG, and search functionality. Deploy targets can be any web host, S3, or GitHub pages.
* [sources](https://docs.getdbt.com/docs/building-a-dbt-project/using-sources) define source tables. You can rerun all models that depend on them, run tests to check their validity, and also check their freshness.
* [seed data](https://docs.getdbt.com/docs/building-a-dbt-project/seeds) are CSV files in your project (and stored in git) loaded into your warehouse. Useful for mapping tables or loading test data (e.g., without PII) into a test schema ([example](https://github.com/stkbailey/fivethirtyeight-dbt-data)).
* [snapshots](https://docs.getdbt.com/docs/building-a-dbt-project/snapshots) implement type 2 slowly changing dimensions over mutable source tables
* [analyses](https://docs.getdbt.com/docs/building-a-dbt-project/analyses) are SQL templates compiled into .sql files, rather than materialized against the warehouse. Compilation resolves all references and substitutions.
* [packages](https://docs.getdbt.com/docs/guides/building-packages) enable sharing of models and their composition into other projects ([example](https://github.com/stkbailey/fivethirtyeight-dbt-data))
* [testing](https://docs.getdbt.com/docs/building-a-dbt-project/testing-and-documentation/testing/)
  * schema tests check constraints are valid
  * custom data tests are arbitrary SQL statements that fail when returning more than 1 row
* [macros](https://docs.getdbt.com/docs/writing-code-in-dbt/macros) are snippets of SQL reusable across models
* template with [Jinja](https://docs.getdbt.com/docs/writing-code-in-dbt/getting-started-with-jinja)
  * to create models in different schemas/[environments](https://docs.getdbt.com/docs/guides/managing-environments) (e.g., dev/test/prod)
  * to reference other models or avoid hard coding table names
  * to interpolate from variables provided in config or via the command line
  * to create conditionals, e.g., when running in a test schema only use a subset of data   
  * instead of using the capabilities of your scheduler (e.g., Airflow) to decouple and get the other benefits of dbt
* [supports](https://docs.getdbt.com/docs/supported-databases) Snowflake, Redshift, BigQuery, Postgres and Microsoft SQL Server
* [partially supports](https://docs.getdbt.com/docs/supported-databases) Presto and Spark (via the thrift-server)

## Limitations and challenges
* dbt doesn't build tables [partition-by-partition like hive](https://discourse.getdbt.com/t/on-the-limits-of-incrementality/303/6)
* [When rebuilding dev from scratch, use a subset of the data to speed things up](https://discourse.getdbt.com/t/how-we-treat-big-data-models-in-our-dbt-setup/704/2)


## Paid version
The paid version, called [dbt cloud](https://docs.getdbt.com/docs/dbt-cloud/cloud-overview/), is a SaaS product that provides an IDE and a way of executing your projects on schedule or commit.

## References
* [dbt coding conventions](https://github.com/fishtown-analytics/corp/blob/master/dbt_coding_conventions.md)
* [Only run changed models](https://discourse.getdbt.com/t/tips-and-tricks-about-working-with-dbt/287/2)
* [Script to autogenerate dbt commands for changed models against a chosen git branch](https://gist.github.com/jtalmi/c6265c8a17120cfb150c97512cb68aa6). See also this video on [dbt and git diff](https://www.youtube.com/watch?v=m-QlIVss0UA).