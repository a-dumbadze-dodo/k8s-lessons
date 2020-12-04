local schemas = import 'schemas.libsonnet';

{
  annotation:: function(name, value) schemas.shared.annotation {
    name: name,
    value: value,
  },

  environment:: function(name, value, components) schemas.environment {
    name: name,
    value: value,
    components: components,
  },

  secret:: function(variable, name, components) schemas.secret {
    variable: variable,
    k8s_secret: name,
    kv_secret: name,
    components: components,
    output: false,
  },

  secretTemplate:: function(variable, name, components) {
    variable: variable,
    name: name,
    components: components,
    output: false,
  },

  secretMountTemplate:: function(dataKey, name, mountPath, components) {
    variable: dataKey,
    name: name,
    mountPath: mountPath,
    output: true,
    components: components,
  },

  host:: function(hostname, paths) schemas.host {
    hostname: hostname,
    paths: paths,
  },

  hostPath:: function(path, component) schemas.hostPath {
    path: path,
    component: component,
  },

  tls:: function(hostname, secret) schemas.tls {
    hostname: hostname,
    secret: secret,
  },

  port:: function(name, value) schemas.shared.port {
    name: name,
    port: value,
  },

  probe:: function(path, port, threshold, delay, period) schemas.shared.probe {
    httpGet: {
      path: path,
      port: port,
    },
    failureThreshold: threshold,
    periodSeconds: period,
    initialDelaySeconds: delay,
  },

  resources:: function(cpu, memory) schemas.shared.resources {
    cpu: cpu,
    memory: memory,
  },

  deployment:: function(component) schemas.deployment {
    component: component,
    monitoring: true,
    workingDir: null,
  },

  service:: function(component) schemas.service {
    component: component,
  },

  job:: function(component, type, weight) schemas.job {
    component: component,
    hook: {
      type: type,
      weight: weight,
    },
    workingDir: null,
  },

  cronJob:: function(component, schedule) schemas.cronJob {
    component: component,
    schedule: schedule,
    workingDir: null,
  },

  ingress:: function() schemas.ingress {
    annotations: {
      certManagerInclude: true,
      externalDnsSkip: false,
      frontDoorProxyRealIpInclude: false,
      additional: [],
    },
  },

}
