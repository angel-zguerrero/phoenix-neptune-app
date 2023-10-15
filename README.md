# Phoenix Neptune App

Umbrella Corp's Web Application (fictional but functional) this web application allows the registration of experiments and associated complex scientific operations.

The scientific operations are sent to [Elixir Pendulum App](https://github.com/angel-zguerrero/elixir-pendulum-app) through [Node Tyrant Api](https://github.com/angel-zguerrero/node-tyrant-api), when the operation is resolved it will be returned to [Phoenix Neptune App](https://github.com/angel-zguerrero/phoenix-neptune-app) via webhook by [Node Tyrant Api](https://github.com/angel-zguerrero/node-tyrant-api).

Written in Elixir with Phoenix Framework and using Postgres database, [Phoenix Neptune App](https://github.com/angel-zguerrero/phoenix-neptune-app) use Live View and PubSub to display real-time experiment management.

### See in action

You can see all the ecosystem in action of this this distributed service deploying [Distributed Hive Network](https://github.com/angel-zguerrero/hive-docker/blob/main/distributed-hive-network).


## Installation

```bash
$ mix deps.get
```

## Configuring the app

Edit ***./config/config.exs*** file to use your own ENV VARS to configure Tyrant API Base url and the Application itself.

ENV VARS to configure:

* DATABASE_USER
* DATABASE_PASSWORD
* DATABASE_HOST
* TYRANT_API_BASE_URL   `base url for tyrant web api`

## Running the app

```bash
$ mix ecto.migrate
$ iex -S mix phx.server
```

## How to use

Open in the browser `http://127.0.0.1:4000`

Then you can use the web interface to:

* Create Users
* Create Experiments
* Create Scientific Operations


## Docker

This application can be easily run on Docker. You can use `Dockerfile` to create and push the image to a Docker repository for use in a production environment.

You can run this application and its services using the `compose-file.yaml` docker.

```bash
$ docker-compose up --build
```

### Note

Before running this service, you must first run these applications [Node Tyrant Api](https://github.com/angel-zguerrero/node-tyrant-api) and [Elixir Pendulum App](https://github.com/angel-zguerrero/elixir-pendulum-app).