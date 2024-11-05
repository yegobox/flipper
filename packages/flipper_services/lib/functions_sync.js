function(doc, oldDoc, meta) {
    // Grant access to default channel
    channel("default");
    
    // If document has channels, grant access to those too
    if (doc.channels && doc.channels.length > 0) {
      for (var i = 0; i < doc.channels.length; i++) {
        channel(doc.channels[i]);
      }
    }
  }