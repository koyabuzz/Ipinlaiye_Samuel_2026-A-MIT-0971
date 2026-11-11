"use strict";
const database=db.getSiblingDB("media_distributed");
printjson({host:db.getMongo().host,hello:db.hello(),count:database.projects.countDocuments({}),ids:database.projects.find({}, {_id:1}).sort({_id:1}).toArray().map(x=>x._id),failoverDocument:database.projects.findOne({_id:"DPRJ-0031"})});

