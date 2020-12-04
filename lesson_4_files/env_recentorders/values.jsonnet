local defaults = import './common-app/defaults.libsonnet';
local functions = import './common-app/functions.libsonnet';
local templates = import './common-app/templates.libsonnet';
local clusterDefault = function(name) {
  deployments: {
    backend: {
      replicas: 3,
    },
  },
  secrets: {
    keyvault: functions.naming.keyvaults.app(name, 'recentorders'),
    items: [
      templates.secret('RabbitMq__Endpoint', 'rabbitmq-connectionstring', ['backend']),
      templates.secret('CosmosDb__ConnectionString', 'database-connectionstring', ['backend', 'migrator']),
    ],
  },
  environment: [
    templates.environment('Jaeger__IsEnabled', 'true', ['backend']),
    templates.environment('JAEGER_SERVICE_NAME', 'recentorders', ['backend']),
  ],
  imagePullSecrets: false,
  dnsConfig: true,
};

local my_function(environment, cluster, namespace, image) =
  local overrides = {
    dev: clusterDefault('dev') {
      deployments: {
        backend: {
          replicas: 1,
        },
      },
      secrets+: {
        keyvault: functions.naming.keyvaults.stand(namespace),
        items: functions.collections.overrideProperty(function(item) { kv_secret: 'recentorders-%s' % item.kv_secret }, super.items),
      },
      environment+: [
        templates.environment('CosmosDB__CollectionNamePostfix', '-dev', ['backend', 'migrator']),
      ],
    },
    ld: clusterDefault('ld') {
      environment+: [
        templates.environment('CosmosDB__DatabaseName', 'orderstatus-ld', ['backend', 'migrator']),
      ],
    },
    we: clusterDefault('we'),
    eu2: clusterDefault('eu2') {
      deployments: {
        backend: {
          replicas: 2,
        },
      },
    },
    chn: clusterDefault('chn') {
      environment+: [
        templates.environment('AZURE_ENVIRONMENT', 'AZURECHINACLOUD', ['backend']),
      ],
      imagePullSecrets: true,
    },
  }[cluster];

  {
    deployments: [
      templates.deployment('backend') {
        priorityClassName: defaults.priorityClassName,
        resources: {
          requests: templates.resources(cpu=0.7, memory='0.25G'),
          limits: templates.resources(cpu=1, memory='0.5G'),
        },
        replicas: overrides.deployments.backend.replicas,
        ports: [
          defaults.ports.http,
        ],
        probes: {
          live: defaults.probes.live('http'),
          ready: defaults.probes.ready('http'),
        },
      },
    ],
    jobs: [
      defaults.job.before('migrator') {
        resources: {
          limits: defaults.resources.limits,
          requests: defaults.resources.requests,
        },
      },
    ],
    services: [
      defaults.service.loadBalancer('backend'),
    ],
    secrets: overrides.secrets,
    environment: overrides.environment,
    imagePullSecrets: overrides.imagePullSecrets,
    dnsConfig: overrides.dnsConfig,
    image: image,
  };

my_function('prod', 'we', 'drinkit', 'my-image-name')