"use strict";
const database=db.getSiblingDB("media_portfolio");
const id="PRJ-DEMO-001";
if(database.projects.countDocuments({_id:id})!==0) throw new Error("Safety stop: CRUD demo ID already exists");
const insertResult=database.projects.insertOne({_id:id,name:"CRUD Demonstration Project",type:"video",status:"planned",
  description:"Temporary exact-ID CRUD demonstration",client:{clientId:"CLI-DEMO-001",name:"Demonstration Client",contact:{name:"Test Contact"}},
  schedule:{startDate:ISODate("2026-08-01T00:00:00Z"),endDate:ISODate("2026-09-01T00:00:00Z")},crew:[],tags:["demonstration"],
  assetSummary:{totalAssets:0,awaitingReview:0,totalBytes:NumberLong("0")},createdAt:new Date(),updatedAt:new Date()});
printjson({operation:"create",acknowledged:insertResult.acknowledged,insertedId:insertResult.insertedId});
printjson({operation:"read",document:database.projects.findOne({_id:id},{name:1,status:1,crew:1})});
const updateResult=database.projects.updateOne({_id:id,"crew.staffId":{$ne:"STF-0001"}},{$push:{crew:{staffId:"STF-0001",displayName:"Staff1 Surname1",role:"Producer",assignedFrom:ISODate("2026-08-01T00:00:00Z"),assignedUntil:null}},$set:{status:"active",updatedAt:new Date()}});
printjson({operation:"update",matched:updateResult.matchedCount,modified:updateResult.modifiedCount,document:database.projects.findOne({_id:id},{name:1,status:1,crew:1})});
const deleteResult=database.projects.deleteOne({_id:id});
printjson({operation:"delete",deleted:deleteResult.deletedCount,remaining:database.projects.countDocuments({_id:id})});

