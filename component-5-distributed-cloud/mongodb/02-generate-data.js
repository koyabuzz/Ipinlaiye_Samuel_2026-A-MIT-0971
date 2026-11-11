"use strict";
const database=db.getSiblingDB("media_distributed");
if(database.getCollectionNames().includes("projects") || database.projects.countDocuments({})!==0)
  throw new Error("Safety stop: media_distributed.projects already exists or contains data");
database.createCollection("projects",{validator:{$jsonSchema:{bsonType:"object",required:["_id","name","type","status","client","region","createdAt"],properties:{_id:{bsonType:"string",pattern:"^DPRJ-[0-9]{4}$"},name:{bsonType:"string"},type:{enum:["video","audio","photography","animation","other"]},status:{enum:["planned","active","completed"]},client:{bsonType:"object",required:["clientId","name"]},region:{enum:["lagos","abuja","port-harcourt"]},createdAt:{bsonType:"date"}}}},validationLevel:"strict",validationAction:"error"});
const types=["video","audio","photography","animation","other"];
const statuses=["planned","active","completed"];
const regions=["lagos","abuja","port-harcourt"];
const documents=[];
for(let i=1;i<=30;i++) documents.push({_id:`DPRJ-${String(i).padStart(4,"0")}`,name:`Distributed Media Project ${i}`,type:types[(i-1)%5],status:statuses[(i-1)%3],client:{clientId:`DCLI-${String(((i-1)%10)+1).padStart(3,"0")}`,name:`Distributed Client ${((i-1)%10)+1}`},region:regions[(i-1)%3],createdAt:new Date(Date.UTC(2026,(i-1)%12,1))});
const result=database.projects.insertMany(documents,{ordered:true,writeConcern:{w:"majority",wtimeout:10000}});
printjson({acknowledged:result.acknowledged,insertedCount:Object.keys(result.insertedIds).length,firstId:documents[0]._id,lastId:documents[29]._id,writeConcern:{w:"majority",wtimeout:10000},count:database.projects.countDocuments({})});

