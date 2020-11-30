// 1. variables, string concat

{
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: 'app-sushipricer-cal',  // <--- name: 'app-'+appName,
    labels: {
      app: 'sushipricer-cal',  // <--- app: appName,
      name: 'app-sushipricer-cal',  // <---  name: 'app-'+appName,
      'service.sushi.com/chopsticks': 'activated',
    },
  },
  spec: {
    type: 'ClusterIP',
    ports: [
      {
        protocol: 'TCP',
        port: 20005,
        targetPort: 20005,
        name: 'wasabi-protocol',
      },
    ],
    selector: {
      name: 'ssp-sushipricer-cal',  // <--- name: 'ssp-'+appName,
    },
  },
}
