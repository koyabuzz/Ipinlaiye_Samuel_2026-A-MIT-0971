"use strict";
try {
  const existing=rs.conf();
  throw new Error(`Safety stop: replica set already configured as ${existing._id}`);
} catch (error) {
  if (error.codeName !== "NotYetInitialized" && error.code !== 94) throw error;
}
const result=rs.initiate({_id:"rs0",members:[
  {_id:0,host:"mongo1:27017",priority:2},
  {_id:1,host:"mongo2:27017",priority:1},
  {_id:2,host:"mongo3:27017",priority:1}
]});
printjson({operation:"rs.initiate",result});

