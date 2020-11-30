// 2. functions / for loop
// make a function and generate 2 objects with different port and name

local port = 20005;
local appName = 'sushipricer-cal';

{
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
}
