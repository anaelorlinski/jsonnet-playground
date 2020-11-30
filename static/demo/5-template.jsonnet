// 5. template engine prerequisites
// note : multi file generation (jsonnet -m)
// the factory pattern in Jsonnet : mapping a key to a function

local newServiceBase(name, params) = {
  // simplified
  kind: 'Service',
  metadata: {
    name: 'app-' + name,
  },
  spec: {
    type: params.type,
    ports: [
      {
        port: params.port,
      },
    ],
  },
};

local paramsCal = { port: 20005, type: 'ClusterIP' };
local paramsFfp = { port: 20006, type: 'NodePort' };

local newServiceFlexCal(params) =
  newServiceBase('sushipricer-cal', params);
local newServiceFlexFfp(params) =
  newServiceBase('sushipricer-ffp', params);

//local factory = {
//  'sushipricer-cal':newServiceFlexCal,
//  'sushipricer-ffp':newServiceFlexFfp,
//};


{
  'sushipricer-cal.json':
    newServiceBase('sushipricer-cal', paramsCal),
  // factory['sushipricer-cal'](paramsCal),
  'sushipricer-ffp.json':
    newServiceBase('sushipricer-ffp', paramsFfp),
  // factory['sushipricer-ffp'](paramsFfp),
}
