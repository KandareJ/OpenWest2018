ruleset OpenWest2018.contact_info {
  meta {
    use module io.picolabs.pds alias store
    shares __testing
  }
  
  global {
    __testing = {"events" : [{"domain" : "contact", "type" : "get_info"}]}
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
