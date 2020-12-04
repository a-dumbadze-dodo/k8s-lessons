local templates = import 'templates.libsonnet';

{
  collections:: {
    zip:: function(left, right, selector) std.mapWithIndex(function(index, item) selector(item, right[index]), left),

    toObject:: function(items, property) {
      [item[property]]: item
      for item in items
    },

    overrideProperty:: function(override, array) std.map(function(item) {
      [property]: item[property]
      for property in std.objectFields(item)
    } + override(item), array),
  },

  objects:: {
    overrideIfExists:: function(default, overrideObject, overrideObjectKey)
      if std.objectHas(overrideObject, overrideObjectKey) then default + overrideObject[overrideObjectKey] else default,

    replaceIfExists:: function(default, overrideObject, overrideObjectKey)
      if std.objectHas(overrideObject, overrideObjectKey) then overrideObject[overrideObjectKey] else default,
  },

  arrays:: {
    overrideIfExists:: function(default, overrideObject, filterKey, overrideObjectKey)
      if std.objectHas(overrideObject, overrideObjectKey)
      then
        local overrideArray = std.set(overrideObject[overrideObjectKey], function(x) x[filterKey],);
        std.filter(function(x) !std.setMember(x, overrideArray, function(x) x[filterKey],), default) + overrideArray
      else default,
  },

  // TODO: Will be removed
  naming:: {
    keyvaults:: {
      app: $.keyvault.name.app,
      stand: function(namespace) $.keyvault.name.stand('dev', namespace),
    },
    tls:: $.ingress.tlsSecret,
    hostname:: $.ingress.hostName,
  },

  namespace:: {
    prefix: function(namespace) {
      local parts = std.split(namespace, '-'),

      result: if std.length(parts) == 1 then parts[0] else parts[1],
    }.result,
  },

  keyvault:: {
    name:: {
      app: function(cluster, application) '%(cluster)s-kv-%(app)s-dodo' % {
        cluster: cluster,
        app: std.substr(application, 0, 13),
      },
      stand: function(cluster, namespace) '%(cluster)s-%(namespace)s-keyvault-dodo' % {
        cluster: cluster,
        namespace: $.namespace.prefix(namespace),
      },
      infra: function(cluster) '%(cluster)s-keyvault-dodo' % {
        cluster: cluster,
      },
    },

    secrets:: {
      app: function(namespace, secrets) $.collections.overrideProperty(function(item) {
        k8s_secret: item.name,
        kv_secret: '%(namespace)s-%(name)s' % { namespace: namespace, name: item.name },
      }, secrets),

      stand: function(application, secrets) $.collections.overrideProperty(function(item) {
        k8s_secret: item.name,
        kv_secret: '%(app)s-%(name)s' % { app: application, name: item.name },
      }, secrets),
    },
  },

  environment:: {
    defaults:: function(environment, cluster, namespace, components) [
      templates.environment('ASPNETCORE_ENVIRONMENT', environment, components),
      templates.environment('ENVIRONMENT', environment, components),
      templates.environment('CLUSTER', cluster, components),
      templates.environment('NAMESPACE', namespace, components),
    ],

    clusterSpecific:: {
      chn: function(components) [
        templates.environment('AZURE_ENVIRONMENT', 'AZURECHINACLOUD', components),
      ],
    },
  },

  ingress:: {
    annotations:: {
      denyLocations:: function(locations) templates.annotation(
        'nginx.ingress.kubernetes.io/configuration-snippet',
        std.join('\n', ['location %s {\n  deny all;\n  return 404;\n}' % location for location in locations])
      ),
      readTimeout:: function(seconds) templates.annotation('nginx.ingress.kubernetes.io/proxy-read-timeout', '%ss' % seconds),
      sendTimeout:: function(seconds) templates.annotation('nginx.ingress.kubernetes.io/proxy-send-timeout', '%ss' % seconds),
      grpc:: function(application) [
        templates.annotation('nginx.ingress.kubernetes.io/backend-protocol', 'GRPC'),
        templates.annotation('nginx.ingress.kubernetes.io/grpc-backend', 'true'),
        templates.annotation('nginx.org/grpc-services', application),
      ],
    },

    tlsSecret:: function(environment, cluster, app) {
      local suffixes = {
        dev: 'dodois-ru',
        ld: 'dodois-ru',
        we: 'dodois-io',
        eu2: 'dodois-io',
        chn: 'dodois-cn',
      },

      result: 'tls-%(app)s-%(suffix)s' % {
        app: app,
        suffix: suffixes[cluster],
      },
    }.result,

    hostName:: function(environment, cluster, namespace, app) {
      local domains = {
        dev: 'dodois.ru',
        ld: 'dodois.ru',
        we: 'dodois.io',
        eu2: 'dodois.io',
        chn: 'dodois.cn',
      },
      local suffixes = {
        ld: '-ld',
        eu2: '-eu2',
      },

      result: '%(app)s%(namespace)s%(prefix)s.%(domain)s' % {
        app: app,
        namespace: if namespace == 'default' then '' else '.%s' % namespace,
        prefix: $.objects.overrideIfExists('', suffixes, cluster),
        domain: domains[cluster],
      },
    }.result,
  },
}
