"use strict";
const status=rs.status();
const config=rs.conf();
printjson({set:status.set,term:status.term,myState:status.myState,members:status.members.map(m=>({name:m.name,state:m.stateStr,health:m.health,self:m.self||false,lastApplied:m.optimeDate})),config:{_id:config._id,version:config.version,writeConcernMajorityJournalDefault:config.settings.writeConcernMajorityJournalDefault,members:config.members.map(m=>({_id:m._id,host:m.host,priority:m.priority,votes:m.votes}))},hello:db.hello()});

