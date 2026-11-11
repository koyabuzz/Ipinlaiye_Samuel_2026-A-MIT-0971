"use strict";
const database = db.getSiblingDB("media_portfolio");
const expected = ["projects", "staff", "mediaAssets", "equipment", "equipmentReservations"];
const existing = database.getCollectionNames().filter(n => expected.includes(n));
if (existing.length !== 0) {
  throw new Error(`Safety stop: planned collections already exist: ${existing.join(", ")}`);
}

database.createCollection("staff", { validator: { $jsonSchema: {
  bsonType: "object", required: ["_id","firstName","lastName","email","jobTitle","employmentType","active"],
  properties: {
    _id: { bsonType: "string", pattern: "^STF-[0-9]{4}$" },
    firstName: { bsonType: "string" }, lastName: { bsonType: "string" },
    email: { bsonType: "string" }, jobTitle: { enum: ["Producer","Director","Editor","Camera Operator","Sound Engineer"] },
    employmentType: { enum: ["employee","freelancer"] }, active: { bsonType: "bool" }
  }
} }, validationLevel: "strict", validationAction: "error" });

database.createCollection("projects", { validator: { $jsonSchema: {
  bsonType: "object", required: ["_id","name","type","status","client","schedule","crew","tags","createdAt","updatedAt"],
  properties: {
    _id: { bsonType: "string", pattern: "^(PRJ-[0-9]{4}|PRJ-DEMO-001)$" },
    name: { bsonType: "string" }, type: { enum: ["video","audio","photography","animation","other"] },
    status: { enum: ["planned","active","on_hold","completed","cancelled"] },
    client: { bsonType: "object", required: ["clientId","name","contact"] },
    schedule: { bsonType: "object", required: ["startDate"], properties: { startDate: { bsonType: "date" }, endDate: { bsonType: ["date","null"] } } },
    crew: { bsonType: "array", maxItems: 12, items: { bsonType: "object", required: ["staffId","displayName","role","assignedFrom"] } },
    tags: { bsonType: "array", maxItems: 8, items: { bsonType: "string" } },
    assetSummary: { bsonType: "object" }, createdAt: { bsonType: "date" }, updatedAt: { bsonType: "date" }
  }
} }, validationLevel: "strict", validationAction: "error" });

database.createCollection("mediaAssets", { validator: { $jsonSchema: {
  bsonType: "object", required: ["_id","projectId","name","type","status","versions","currentVersion","createdAt"],
  properties: {
    _id: { bsonType: "string", pattern: "^AST-[0-9]{6}$" }, projectId: { bsonType: "string", pattern: "^PRJ-[0-9]{4}$" },
    name: { bsonType: "string" }, type: { enum: ["video","audio","image","document","other"] },
    status: { enum: ["raw","editing","review","approved","archived"] },
    versions: { bsonType: "array", minItems: 1, maxItems: 5, items: { bsonType: "object", required: ["version","fileUri","format","fileSizeBytes","uploadedBy","createdAt"], properties: { version: { bsonType: "int", minimum: 1 }, fileSizeBytes: { bsonType: "long", minimum: 0 }, durationSeconds: { bsonType: ["int","null"], minimum: 0 }, createdAt: { bsonType: "date" } } } },
    currentVersion: { bsonType: "int", minimum: 1, maximum: 5 }, createdAt: { bsonType: "date" }
  }
} }, validationLevel: "strict", validationAction: "error" });

database.createCollection("equipment", { validator: { $jsonSchema: {
  bsonType: "object", required: ["_id","assetTag","name","type","condition","active"],
  properties: {
    _id: { bsonType: "string", pattern: "^EQP-[0-9]{4}$" }, assetTag: { bsonType: "string" }, name: { bsonType: "string" },
    type: { enum: ["camera","lens","microphone","lighting"] }, condition: { enum: ["good","fair","damaged","repair","retired"] }, active: { bsonType: "bool" }
  }
} }, validationLevel: "strict", validationAction: "error" });

database.createCollection("equipmentReservations", { validator: { $jsonSchema: {
  bsonType: "object", required: ["_id","projectId","equipmentId","reservedByStaffId","startAt","endAt","status","displaySnapshot","createdAt"],
  properties: {
    _id: { bsonType: "string", pattern: "^RES-[0-9]{6}$" }, projectId: { bsonType: "string" }, equipmentId: { bsonType: "string" }, reservedByStaffId: { bsonType: "string" },
    startAt: { bsonType: "date" }, endAt: { bsonType: "date" }, status: { enum: ["pending","confirmed","checked_out","returned","cancelled"] },
    displaySnapshot: { bsonType: "object", required: ["projectName","equipmentName","reservedByName"] }, createdAt: { bsonType: "date" }
  }
} }, validationLevel: "strict", validationAction: "error" });

printjson({ acknowledged: true, createdCollections: expected });

