"use strict";
const database=db.getSiblingDB("media_portfolio");
printjson({projects:database.projects.createIndex({status:1,type:1,"schedule.startDate":1},{name:"ix_project_status_type_start"})});
printjson({mediaAssets:database.mediaAssets.createIndex({status:1,createdAt:-1,projectId:1},{name:"ix_asset_status_created_project"})});
printjson({reservations:database.equipmentReservations.createIndex({equipmentId:1,startAt:1,endAt:1},{name:"ix_reservation_equipment_period"})});
printjson({staffEmail:database.staff.createIndex({email:1},{name:"uq_staff_email",unique:true})});
printjson({equipmentTag:database.equipment.createIndex({assetTag:1},{name:"uq_equipment_asset_tag",unique:true})});
printjson({indexes:{projects:database.projects.getIndexes(),mediaAssets:database.mediaAssets.getIndexes(),equipmentReservations:database.equipmentReservations.getIndexes()}});

