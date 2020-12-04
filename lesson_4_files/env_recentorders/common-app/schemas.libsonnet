{
  shared:: {
    annotation:: {
      name: error 'annotation.name must be defined',
      value: error 'annotation.value must be defined',
    },

    port:: {
      name: error 'port.name must be defined',
      port: error 'port.port must be defined',
    },

    probe:: {
      httpGet: {
        path: error 'probe.httpGet.path must be defined',
        port: error 'probe.httpGet.port must be defined',
      },
      failureThreshold: error 'probe.failureThreshold must be defined',
      periodSeconds: error 'probe.periodSeconds must be defined',
      initialDelaySeconds: error 'probe.initialDelaySeconds must be defined',
    },

    resources:: {
      cpu: error 'resources.cpu must be defined',
      memory: error 'resources.memory must be defined',
    },
  },

  host:: {
    hostname: error 'host.hostname must be defined',
    paths: error 'host.paths must be defined',
  },

  hostPath:: {
    path: error 'hostPath.path must be defined',
    component: error 'hostPath.component must be defined',
  },

  tls:: {
    hostname: error 'tls.hostname must be defined',
    secret: error 'tls.secret must be defined',
  },

  deployment:: {
    component: error 'deployment.component must be defined',
    annotations: [],
    command: [],
    args: [],
    workingDir: error 'deployment.workingDir must be defined',
    resources: {
      limits: $.shared.resources,
      requests: $.shared.resources,
    },
    replicas: error 'deployment.replicas must be defined',
    ports: [],
    monitoring: error 'deployment.monitoring must be defined',
    probes: {
      ready: $.shared.probe,
      live: $.shared.probe,
    },
  },

  service:: {
    component: error 'service.component must be defined',
    type: error 'service.type must be defined',
    port: $.shared.port,
  },

  ingress:: {
    annotations: [],
    hosts: error 'ingress.hosts must be defined',
    tls: error 'ingress.tls must be defined',
  },

  job:: {
    component: error 'job.component must be defined',
    hook: {
      type: error 'job.hook.type must be defined',
      weight: error 'job.hook.weight must be defined',
    },
    command: [],
    args: [],
    workingDir: error 'deployment.workingDir must be defined',
    resources: {
      limits: $.shared.resources,
      requests: $.shared.resources,
    },
    restartPolicy: error 'job.restartPolicy must be defined',
  },

  cronJob:: {
    component: error 'cronJob.component must be defined',
    command: [],
    args: [],
    workingDir: error 'deployment.workingDir must be defined',
    resources: {
      limits: $.shared.resources,
      requests: $.shared.resources,
    },
    restartPolicy: error 'cronJob.restartPolicy must be defined',
    concurrencyPolicy: error 'cronJob.concurrencyPolicy must be defined',
    failedJobsHistoryLimit: error 'cronJob.failedJobsHistoryLimit must be defined',
    successfulJobsHistoryLimit: error 'cronJob.successfulJobsHistoryLimit must be defined',
    schedule: error 'cronJob.schedule must be defined',
    startingDeadlineSeconds: error 'cronJob.startingDeadlineSeconds must be defined',
  },

  secret:: {
    components: error 'secret.components must be defined',
    variable: error 'secret.variable must be defined',
    k8s_secret: error 'secret.k8s_secret must be defined',
    kv_secret: error 'secret.kv_secret must be defined',
    output: error 'secret.output muts be defined',
  },

  environment:: {
    name: error 'environment.name must be defined',
    value: error 'environment.value must be defined',
    components: error 'environment.components must be defined',
  },
}
