"use strict";
const database=db.getSiblingDB("media_portfolio");
print("ASSET STORAGE BY TYPE AND STATUS");
printjson(database.mediaAssets.aggregate([
 {$group:{_id:{type:"$type",status:"$status"},assetCount:{$sum:1},latestAssetAt:{$max:"$createdAt"}}},
 {$sort:{"_id.type":1,"_id.status":1}}
]).toArray());
print("TOP PROJECTS AWAITING REVIEW");
printjson(database.mediaAssets.aggregate([
 {$match:{status:"review"}},{$group:{_id:"$projectId",reviewCount:{$sum:1},latestAssetAt:{$max:"$createdAt"}}},
 {$sort:{reviewCount:-1,_id:1}},{$limit:10},
 {$lookup:{from:"projects",localField:"_id",foreignField:"_id",as:"project"}},{$unwind:"$project"},
 {$project:{_id:0,projectId:"$_id",projectName:"$project.name",reviewCount:1,latestAssetAt:1}}
]).toArray());
print("STAFF WORKLOAD FROM EMBEDDED CREW");
printjson(database.projects.aggregate([
 {$match:{status:"active"}},{$unwind:"$crew"},{$group:{_id:"$crew.staffId",displayName:{$first:"$crew.displayName"},activeProjectRoles:{$sum:1}}},
 {$sort:{activeProjectRoles:-1,_id:1}},{$limit:10}
]).toArray());
print("CONFIRMED CAMERA SCHEDULE SAMPLE");
printjson(database.equipmentReservations.aggregate([
 {$match:{status:{$in:["confirmed","checked_out"]},startAt:{$gte:ISODate("2026-07-01T00:00:00Z"),$lt:ISODate("2026-07-08T00:00:00Z")}}},
 {$lookup:{from:"equipment",localField:"equipmentId",foreignField:"_id",as:"equipment"}},{$unwind:"$equipment"},
 {$match:{"equipment.type":"camera"}},{$sort:{startAt:1}},{$limit:20},
 {$project:{_id:1,projectId:1,equipmentId:1,startAt:1,endAt:1,status:1,"displaySnapshot.projectName":1,"equipment.name":1}}
]).toArray());

