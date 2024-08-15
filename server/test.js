const express = require('express');
//const session = require('express-session');
const app = express();
const Port = process.env.Port || 8000;
const path = require('path');
;

/* const WebsitePath = path.join(__dirname,"/public");
app.use(express.static(WebsitePath)) */

app.use(express.json());
app.use(express.urlencoded({ extended: true })) // for parsing application/x-www-form-urlencoded

//app.use(bonuslist);

   app.get("/",(req,res)=>{
    res.send("hello hii");
}); 

// app.listen(Port,(req,res)=>{
//     console.log("server connected")
// })