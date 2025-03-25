# Deploy Action

Official GitHub Action to create a CI/CD pipeline that deploys [Flows](https://kestra.io/docs/workflow-components/flow) to your Kestra server.

This action should be used within a workflow that runs only on your `main` branch.

## Important notes❗️

If no namespace is provided, every flow in the provided directory can be created/updated, but take care that if the `delete` property is not set to false, then every flows not in the folder will be deleted from your instance.

If a namespace is provided, every children of this namespace will be allowed.
Let say we have 3 namespaces:
- `prod`
- `prod.data`
- `prod.marketing`

The following will update our three namespaces :
```yaml
      - name: deploy-prod
        uses: kestra-io/deploy-flows-action@master
        with:
          namespace: prod
          directory: ./flows
```
While the following will update only the `prod.data` namespace, and will throw if a flow with the namespace `prod` or `prod.marketing` is found:
```yaml
      - name: deploy-prod
        uses: kestra-io/deploy-flows-action@master
        with:
          namespace: prod.data
          directory: ./flows
```

## What does the action do?

It takes a `directory` as an input argument, indicating the directory within your repository where your `Flow`YAML files are stored.

For each resource, the following outcomes are possible:
  * **Create** a flow, if the resource does not exist.
  * **Update** a flow, if the resource exists.
  * **Delete** a flow, if the resource exists, but the file does not exist anymore (i.e. the flow file got deleted).
      * You can disable the deletion of a given resource by setting `delete: false` in the action, as shown in the full example below.

The action logs all these outcomes by specifying which flows got updated, added or deleted.

## Usage

Note that the action will look recursively for yaml file in the provided directory.
For the example shown above, your directory structure could look as follows, and by provided `./flows` as the directory, only files in `flows` and `nested` folders will be read:
```bash
├── flows
│   ├── flow1.yml
│   ├── flow2.yml
│   ├── flow3.yml
│   └── nested
│       ├── nested_flow1.yml
│       ├── nested_flow2.yml
│       └── nested_flow3.yml
├── marketing
│   ├── marketing__flow1.yml
│   ├── marketing__flow2.yml
│   └── marketing__flow3.yml
```

### Inputs

| Inputs        | Required           | Default | Description                                                                                                                                                         |
|---------------|--------------------|---------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ``directory`` | :heavy_check_mark: |         | Folder containing your flows, can have nested folders                                                                                                                                    |
| ``server``    | :heavy_check_mark: |         | URL of your Kestra server                                                                                                                                           |
| ``namespace`` | :x: |         | Namespace containing your flows                                                                                          |
| ``user``      | :x:                |         | Username of your Kestra server                                                                                                                                     |
| ``password``  | :x:                |         | Password of your Kestra server                                                                                                                                      |
| ``delete``    | :x:                | true  | `Flows` found in Kestra server, but no longer existing in a specified directory, will be deleted by default. Set this to `false` if you want to avoid that behavior |
| ``tenant``    | :x:                |         | Tenant identifier (EE only, when multi-tenancy is enabled)                                                                                                          |
| ``apiToken``    | :x:                |         | Token to identify to your instance to                                                                                                          |


### Auth

Depending on your Kestra edition, you may need to include a `user` and `password` or an `apiToken` to authenticate the action with your Kestra server.

### Example

Example where we only update only the `prod.data` namespace and delete every flows not found in the folders from the Kestra instance:

```yaml
      - name: deploy-prod
        uses: kestra-io/deploy-flows-action@master
        with:
          namespace: prod.data
          directory: ./flows
```

Example where we only update only the `prod.data` namespace and keep everyflows created before:

```yaml
      - name: deploy-prod
        uses: kestra-io/deploy-flows-action@master
        with:
          namespace: prod.data
          directory: ./flows
          delete: false
```

Example where we synchronize every flows of our instance with flows in our flows folder:

```yaml
      - name: deploy-prod
        uses: kestra-io/deploy-flows-action@master
        with:
          directory: ./flows
```

Read more in the documentation [here](https://kestra.io/docs/version-control-cicd/cicd/github-action).
