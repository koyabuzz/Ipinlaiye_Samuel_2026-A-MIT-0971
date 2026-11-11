"use strict";
const database=db.getSiblingDB("media_portfolio");
const id="PRJ-INVALID-TEST";
database.projects.deleteOne({_id:id});
let rejected=false, errorCode=null;
try {
  database.projects.insertOne({_id:id,name:"Invalid validator test"});
} catch (error) {
  rejected=true;
  errorCode=error.code;
}
printjson({invalidDocumentRejected:rejected,errorCode,remaining:database.projects.countDocuments({_id:id})});
if(!rejected) {
  database.projects.deleteOne({_id:id});
  throw new Error("Validator failed to reject invalid document");
}
