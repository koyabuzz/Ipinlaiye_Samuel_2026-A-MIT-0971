"use strict";
const database = db.getSiblingDB("media_portfolio");
const names = ["projects","staff","mediaAssets","equipment","equipmentReservations"];
for (const name of names) {
  const count = database.getCollection(name).countDocuments({});
  if (count !== 0) throw new Error(`Safety stop: ${name} contains ${count} documents`);
}
const pad = (n, width) => String(n).padStart(width, "0");
const day = 86400000;
const roles = ["Producer","Director","Editor","Camera Operator","Sound Engineer"];
const projectTypes = ["video","audio","photography","animation","other"];
const projectStatuses = ["active","active","planned","completed","on_hold"];
const assetTypes = ["video","audio","image","document","other"];
const assetStatuses = ["raw","editing","review","approved","archived"];
const equipmentTypes = ["camera","lens","microphone","lighting"];
const reservationStatuses = ["pending","confirmed","checked_out","returned","cancelled"];

const staff = [];
for (let i=1;i<=50;i++) staff.push({
  _id:`STF-${pad(i,4)}`, firstName:`Staff${i}`, lastName:`Surname${i}`,
  email:`staff${i}@example.test`, jobTitle:roles[(i-1)%roles.length],
  employmentType:i%4===0?"freelancer":"employee", active:i<=45
});
database.staff.insertMany(staff, { ordered:true });

const projects = [];
for (let i=1;i<=200;i++) {
  const crewCount=3+(i%6), crew=[];
  for (let j=0;j<crewCount;j++) {
    const sid=((i*7+j*11)%50)+1;
    crew.push({ staffId:`STF-${pad(sid,4)}`, displayName:`Staff${sid} Surname${sid}`,
      role:roles[j%roles.length], assignedFrom:new Date(Date.UTC(2026,(i%12),1)), assignedUntil:null });
  }
  projects.push({ _id:`PRJ-${pad(i,4)}`, name:`Media Project ${pad(i,4)}`,
    type:projectTypes[(i-1)%5], status:projectStatuses[(i-1)%5],
    description:`Deterministic MongoDB project ${i}`,
    client:{ clientId:`CLI-${pad(((i-1)%50)+1,4)}`, name:`Client ${((i-1)%50)+1}`,
      contact:{ name:`Contact ${((i-1)%50)+1}`, email:`client${((i-1)%50)+1}@example.test` } },
    schedule:{ startDate:new Date(Date.UTC(2026,(i-1)%12,1)), endDate:new Date(Date.UTC(2026,(i-1)%12,28)) },
    crew, tags:["synthetic",projectTypes[(i-1)%5]],
    assetSummary:{ totalAssets:50, awaitingReview:10, totalBytes:NumberLong("62500000000") },
    createdAt:new Date(Date.UTC(2025,11,1)+(i%30)*day), updatedAt:new Date(Date.UTC(2026,0,1)+(i%60)*day) });
}
database.projects.insertMany(projects, { ordered:true });

const equipment=[];
for(let i=1;i<=100;i++) equipment.push({ _id:`EQP-${pad(i,4)}`, assetTag:`MONGO-EQ-${pad(i,4)}`,
  name:`Equipment ${i}`, type:equipmentTypes[(i-1)%4], manufacturer:`Maker ${((i-1)%10)+1}`,
  model:`Model ${((i-1)%20)+1}`, condition:i%25===0?"repair":"good", active:i%25!==0 });
database.equipment.insertMany(equipment,{ordered:true});

for(let batchStart=1;batchStart<=10000;batchStart+=1000){
  const batch=[];
  for(let i=batchStart;i<batchStart+1000;i++){
    const pid=((i-1)%200)+1, sid=((i*13-1)%50)+1, versionCount=1+((i-1)%5), versions=[];
    for(let v=1;v<=versionCount;v++) versions.push({ version:v,
      fileUri:`s3://simulated-mongo/PRJ-${pad(pid,4)}/AST-${pad(i,6)}-v${v}.dat`,
      format:["mp4","wav","png","pdf","mov"][(i+v)%5], fileSizeBytes:NumberLong(String(1000000+i*1000+v*10000)),
      durationSeconds:i%5===2||i%5===3?null:30+(i%1800), uploadedBy:`STF-${pad(sid,4)}`,
      createdAt:new Date(Date.UTC(2026,0,1)+((i+v)%365)*day) });
    batch.push({ _id:`AST-${pad(i,6)}`, projectId:`PRJ-${pad(pid,4)}`, name:`Asset ${i}`,
      type:assetTypes[(i-1)%5], status:assetStatuses[Math.floor((i-1)/200)%5], versions,
      currentVersion:versionCount, createdAt:new Date(Date.UTC(2026,0,1)+(i%365)*day) });
  }
  database.mediaAssets.insertMany(batch,{ordered:true});
}

const reservations=[];
for(let i=1;i<=2000;i++){
  const pid=((i*7-1)%200)+1, eid=((i-1)%100)+1, sid=((i*17-1)%45)+1;
  const start=new Date(Date.UTC(2026,0,1)+(i%365)*day+(i%12)*3600000);
  reservations.push({ _id:`RES-${pad(i,6)}`, projectId:`PRJ-${pad(pid,4)}`, equipmentId:`EQP-${pad(eid,4)}`,
    reservedByStaffId:`STF-${pad(sid,4)}`, startAt:start, endAt:new Date(start.getTime()+(2+i%7)*3600000),
    status:reservationStatuses[(i-1)%5], displaySnapshot:{ projectName:`Media Project ${pad(pid,4)}`,
      equipmentName:`Equipment ${eid}`, reservedByName:`Staff${sid} Surname${sid}` },
    purpose:`Synthetic MongoDB reservation ${i}`, createdAt:new Date(Date.UTC(2025,11,1)+(i%30)*day) });
}
database.equipmentReservations.insertMany(reservations,{ordered:true});

printjson(Object.fromEntries(names.map(n=>[n,database.getCollection(n).countDocuments({})])));

