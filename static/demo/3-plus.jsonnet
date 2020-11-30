// 3. plus notation
// we use the + notation to combine json parts
// only the first level is merged
// except if we use +: notation to merge contents

{
  hello: 'JSonnet',
  level1: {
    value1: '123',

    level2: {
      value2: '456',

      level3: {
        value3: '789',
      },
    },
  },
}

//+
//{
//  level1:{
//    value1:'456'
//  }
//}



