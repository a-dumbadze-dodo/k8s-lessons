local templates = import 'templates.libsonnet';

{
  ports:: {
    http: templates.port('http', 80),
  },

  priorityClassName:: 'applications',

  resources:: {
    requests: templates.resources(cpu=0.1, memory='0.5G'),
    limits: templates.resources(cpu=1, memory='1G'),
  },

  job:: {
    before: function(component) templates.job(component, 'before', weight=1) {
      restartPolicy: 'Never',
    },
    after: function(component) templates.job(component, 'after', weight=1) {
      restartPolicy: 'Never',
    },
  },

  cronJob:: function(component, schedule) templates.cronJob(component, schedule) {
    backoffLimit: 6,
    restartPolicy: 'Never',
    concurrencyPolicy: 'Allow',
    failedJobsHistoryLimit: 3,
    successfulJobsHistoryLimit: 3,
    startingDeadlineSeconds: 60,
  },

  crons:: {
    eachDay:: function(day)
      if day < 0 || day > 31 then error 'Invalid value for days' else '* * */%s * *' % day,
    eachHour:: function(hour)
      if hour < 0 || hour > 23 then error 'Invalid value for hours' else '* */%s * * *' % hour,
    eachMinute:: function(minute)
      if minute < 0 || minute > 59 then error 'Invalid value for minutes' else '*/%s * * * *' % minute,
  },

  service:: {
    clusterIp: function(component) templates.service(component) {
      type: 'ClusterIP',
      port: $.ports.http,
    },

    loadBalancer: function(component) templates.service(component) {
      type: 'LoadBalancer',
      port: $.ports.http,
    },
  },

  probes:: {
    live: function(port) templates.probe('/health/live', port, threshold=3, delay=5, period=10),
    ready: function(port) templates.probe('/health/ready', port, threshold=5, delay=10, period=30),
  },
}
