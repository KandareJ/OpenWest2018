ruleset OpenWest2018.contact_info {
  meta {
    use module io.picolabs.pds alias store
    use module io.picolabs.subscription alias Subs
    shares __testing, testFunc
  }
  
  global {
    __testing = {"events" : [{"domain" : "contact", "type" : "getter"}],
                 "queries" : [{"name" : "testFunc"}]}
    
    
    testFunc = function() {
      Subs:established("Tx_role", "peer").map(function(x){x{"Tx"}});
    }
  }
  
  rule get_info {
    select when contact getter
    pre {
      info = store:read_all()
    }
    send_directive("say", {"info" : info})
  }
  
  rule set_info {
    select when contact setter
    
    foreach event:attr("info") setting (v, k)
    
      fired {
        raise store event "new_value" 
        attributes {"key" : k, "value" : v};
      }
    
  }

}
