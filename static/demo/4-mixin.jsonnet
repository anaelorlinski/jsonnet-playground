// 4. mixins
// use + notation and function to create 'patch'

local newService(appName, port) = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: 'app-' + appName,
    labels: {
      app: appName,
      name: 'app-' + appName,
      'service.sushi.com/chopsticks': 'activated',
    },
  },
  spec: {
    type: 'ClusterIP',
    ports: [
      {
        protocol: 'TCP',
        port: port,
        targetPort: port,
        name: 'wasabi-protocol',
      },
    ],
    selector: {
      name: 'ssp-' + appName,
    },
  },
};


[
  newService('sushipricer-cal', 20005),
  // + { spec+: { type: "NodePort" }},
  newService('sushipricer-ffp', 20006),
]


//local NoChopsticks() = {
//  metadata+: {
//    labels+: { 'service.sushi.com/chopsticks':: 'hidden_field with ::' },
//  },
//};



