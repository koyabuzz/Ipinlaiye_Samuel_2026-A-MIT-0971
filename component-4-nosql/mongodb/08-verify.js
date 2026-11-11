"use strict";
const database=db.getSiblingDB("media_portfolio");
const counts={projects:database.projects.countDocuments({}),staff:database.staff.countDocuments({}),mediaAssets:database.mediaAssets.countDocuments({}),equipment:database.equipment.countDocuments({}),equipmentReservations:database.equipmentReservations.countDocuments({})};
const missingAssetProjects=database.mediaAssets.aggregate([{$lookup:{from:"projects",localField:"projectId",foreignField:"_id",as:"p"}},{$match:{p:{$size:0}}},{$count:"count"}]).toArray();
const missingAssetUploaders=database.mediaAssets.aggregate([{$unwind:"$versions"},{$lookup:{from:"staff",localField:"versions.uploadedBy",foreignField:"_id",as:"s"}},{$match:{s:{$size:0}}},{$count:"count"}]).toArray();
const missingCrewStaff=database.projects.aggregate([{$unwind:"$crew"},{$lookup:{from:"staff",localField:"crew.staffId",foreignField:"_id",as:"s"}},{$match:{s:{$size:0}}},{$count:"count"}]).toArray();
const missingReservationProjects=database.equipmentReservations.aggregate([{$lookup:{from:"projects",localField:"projectId",foreignField:"_id",as:"p"}},{$match:{p:{$size:0}}},{$count:"count"}]).toArray();
const missingReservationEquipment=database.equipmentReservations.aggregate([{$lookup:{from:"equipment",localField:"equipmentId",foreignField:"_id",as:"e"}},{$match:{e:{$size:0}}},{$count:"count"}]).toArray();
const missingReservationStaff=database.equipmentReservations.aggregate([{$lookup:{from:"staff",localField:"reservedByStaffId",foreignField:"_id",as:"s"}},{$match:{s:{$size:0}}},{$count:"count"}]).toArray();
const badCrew=database.projects.countDocuments({$expr:{$gt:[{$size:"$crew"},12]}});
const badTags=database.projects.countDocuments({$expr:{$gt:[{$size:"$tags"},8]}});
const badVersions=database.mediaAssets.countDocuments({$expr:{$or:[{$gt:[{$size:"$versions"},5]},{$lt:[{$size:"$versions"},1]}]}});
const badReservationPeriods=database.equipmentReservations.countDocuments({$expr:{$gte:["$startAt","$endAt"]}});
const inactiveReservationStaff=database.equipmentReservations.aggregate([{$lookup:{from:"staff",localField:"reservedByStaffId",foreignField:"_id",as:"s"}},{$match:{"s.active":{$ne:true}}},{$count:"count"}]).toArray();
const snapshotMismatches=database.equipmentReservations.aggregate([
 {$lookup:{from:"projects",localField:"projectId",foreignField:"_id",as:"p"}},{$lookup:{from:"equipment",localField:"equipmentId",foreignField:"_id",as:"e"}},{$lookup:{from:"staff",localField:"reservedByStaffId",foreignField:"_id",as:"s"}},
 {$match:{$expr:{$or:[
   {$ne:["$displaySnapshot.projectName",{$arrayElemAt:["$p.name",0]}]},
   {$ne:["$displaySnapshot.equipmentName",{$arrayElemAt:["$e.name",0]}]},
   {$ne:["$displaySnapshot.reservedByName",{$concat:[{$arrayElemAt:["$s.firstName",0]}," ",{$arrayElemAt:["$s.lastName",0]}]}]}
 ]}}},
 {$count:"count"}
]).toArray();
printjson({counts,total:Object.values(counts).reduce((a,b)=>a+b,0),referenceFailures:{missingAssetProjects,missingAssetUploaders,missingCrewStaff,missingReservationProjects,missingReservationEquipment,missingReservationStaff,inactiveReservationStaff},bounds:{badCrew,badTags,badVersions,badReservationPeriods},snapshotMismatches,crudDemoRemaining:database.projects.countDocuments({_id:"PRJ-DEMO-001"}),validators:database.getCollectionInfos({name:{$in:["projects","staff","mediaAssets","equipment","equipmentReservations"]}}).map(x=>({name:x.name,validator:x.options.validator,validationLevel:x.options.validationLevel,validationAction:x.options.validationAction}))});
print("PROJECT SAMPLE"); printjson(database.projects.findOne({_id:"PRJ-0001"}));
print("ASSET SAMPLE"); printjson(database.mediaAssets.findOne({_id:"AST-000001"}));
print("RESERVATION SAMPLE"); printjson(database.equipmentReservations.findOne({_id:"RES-000001"}));


