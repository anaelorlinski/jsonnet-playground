// 6. template enfine
// multiple output + factory
// generateOne : generates 1 file
// iterate over params : generates all the files

local newServiceBase(name, params) = {
  // simplified
  kind: 'Service',
  metadata: {
    name: 'app-' + name,
  },
  spec: {
    type: 'ClusterIP',
    ports: [
      {
        port: params.port,
      },
    ],
  },
};

local newServiceFlexCal(params) =
  newServiceBase('sushipricer-cal', params);
local newServiceFlexFfp(params) =
  newServiceBase('sushipricer-ffp', params);

local factory = {
  'sushipricer-cal': newServiceFlexCal,
  'sushipricer-ffp': newServiceFlexFfp,
};

local generateOne(factory, name, params) = {
  [name + '.json']: factory[name](params),
};

local params = {
  'sushipricer-cal': { port: 20005, type: 'ClusterIP' },
  'sushipricer-ffp': { port: 20006, type: 'NodePort' },
};

local templateEngine(factory, params) = (
  std.mapWithKey(function(name, params) generateOne(factory, name, params), params)
);

{ nothing: 'yet' }
//generateOne(factory, 'sushipricer-cal', params['sushipricer-cal'])
//templateEngine(factory, params)


