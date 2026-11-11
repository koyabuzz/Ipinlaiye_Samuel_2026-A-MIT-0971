"use strict";
const database=db.getSiblingDB("media_portfolio");
const query={status:"review",createdAt:{$gte:ISODate("2026-01-01T00:00:00Z"),$lt:ISODate("2026-04-01T00:00:00Z")}};
printjson(database.mediaAssets.find(query,{projectId:1,status:1,createdAt:1}).sort({createdAt:-1}).explain("executionStats"));

