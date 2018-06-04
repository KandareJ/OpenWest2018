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
    
    foreach event:attrs setting (v, k)
    if not v.length() < 1 && k != "_headers" then noop();
      fired {
        raise store event "new_value" 
        attributes {"key" : k, "value" : v};
      }
    
  }

}
