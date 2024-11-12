function (doc, oldDoc, meta) {
    var branchs = getBranchs();
    branchs.forEach(function(branch){
       requireRole(branch);
       if(!isDelete){
         var channelId = "channel."+branch;
         channel(channelId);
         access("role:" + branch, "channel." + branch);
       }
    });
 
   
   function getBranchs(){
      return isDelete() ? oldDoc.channels : doc.channels;
   }
 }