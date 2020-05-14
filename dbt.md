
# dbt

[dbt](http://getdbt.com/) makes it easy for data teams to version control and collaborate on data transformations.

## Features
* uses git is a source of truth for all tables
* when combined with CI/CD provides a workflow with approval via PR, testing in test schemas, and releases to production
  * an [example](https://github.com/randypitcherii/cloud_cost_monitoring) which uses Github Actions. Every PR creates and deploys models into a new schema. Automated and exploratory tests run on sample data in the PR schema, before going to production ([video](https://www.youtube.com/watch?v=snp2hxxWgqk))
* models are the core concept in dbt. Every model is a SELECT statement.
* These [materialization strategies](https://docs.getdbt.com/docs/building-a-dbt-project/building-models/materializations) persist models in the warehouse:
  * table - dropped and recreated
  * view - dropped and recreated
  * incremental - run on a subset of data
  * ephemeral - i.e. a CTE
* models can reference other models and form a DAG
* metadata - models can have [tags](https://docs.getdbt.com/docs/building-a-dbt-project/building-models/tags/) (e.g., PII, nightly) which can be referenced when running models or in the documentation 
* [documentation](https://blog.getdbt.com/using-dbt-docs/) shows model descriptions and DAG lineage (requires a host, e.g., S3)
* [sources](https://docs.getdbt.com/docs/building-a-dbt-project/using-sources) define source tables. You can rerun all models that depend on them, run tests to check their validity, and also check their freshness.
* [seed data](https://docs.getdbt.com/docs/building-a-dbt-project/seeds) are CSV files in your project (and stored in git) loaded into your warehouse. Useful mapping tables or loading test data (e.g., without PII) into a dev schema ([example](https://github.com/stkbailey/fivethirtyeight-dbt-data)).
* [snapshots](https://docs.getdbt.com/docs/building-a-dbt-project/snapshots) implement type 2 slowly changing dimensions over mutable source tables
* [analyses](https://docs.getdbt.com/docs/building-a-dbt-project/analyses) are SQL templates compiled into .sql files, rather than materialized against the warehouse. Compilation resolves all references and substitutions.
* [packages](https://docs.getdbt.com/docs/guides/building-packages) enable sharing of models and their composition into other projects ([example](https://github.com/stkbailey/fivethirtyeight-dbt-data))
* [testing](https://docs.getdbt.com/docs/building-a-dbt-project/testing-and-documentation/testing/)
  * schema tests check constraints are valid
  * custom data tests are arbitrary SQL statements that fail when returning more than 1 row
* [macros](https://docs.getdbt.com/docs/writing-code-in-dbt/macros) are snippets of SQL reusable across models
* template with [Jinja](https://docs.getdbt.com/docs/writing-code-in-dbt/getting-started-with-jinja)
  * to create models in different schemas (e.g., dev/test/prod)
  * to reference other models or avoid hard coding table names
  * to interpolate from variables provided in config or via the command line
  * to create conditionals, e.g., when running in a test schema only use a subset of data   
  * instead of using the capabilities of your scheduler (e.g., Airflow) to decouple and get the other benefits of dbt

## Limitations and challenges
* Discussion on [partitioning ala hive](https://discourse.getdbt.com/t/on-the-limits-of-incrementality/303/6)
* [When rebuilding dev, use a subset of the data](https://discourse.getdbt.com/t/how-we-treat-big-data-models-in-our-dbt-setup/704/2)

## Paid version
The paid version, called [dbt cloud](https://docs.getdbt.com/docs/dbt-cloud/cloud-overview/), is a SaaS product that provides an IDE and a way of executing your projects on schedule or commit.

## References
* [dbt coding conventions](https://github.com/fishtown-analytics/corp/blob/master/dbt_coding_conventions.md)
* [Only run changed models](https://discourse.getdbt.com/t/tips-and-tricks-about-working-with-dbt/287/2)
* [Script to autogenerate dbt commands for changed models against a chosen git branch](https://gist.github.com/jtalmi/c6265c8a17120cfb150c97512cb68aa6). See also this video on [dbt and git diff](https://www.youtube.com/watch?v=m-QlIVss0UA).