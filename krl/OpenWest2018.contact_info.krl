ruleset OpenWest2018.contact_info {
  meta {
    use module io.picolabs.pds alias store
    shares __testing
  }
  
  global {
    __testing = {"events" : [{"domain" : "contact", "type" : "getter"}],
                 "queries" : [{"name" : "testFunc"}]}
    
    setterUI = function() {
      <<<html>
        <head>
          <title>Contact Information</title>
        </head>

        <body>
          <h1>Contact Information</h1>
          <form action="http://picos.byu.edu:8080/sky/event/#{meta:eci}/contactTest/contact/setter">
            First Name:<input type="text" name="first name">
            <br><br>
            Last Name:<input type="text" name="last name">
            <br><br>
            *Home phone:<input type="text" name="home">
            <br><br>
            *Work phone:<input type="text" name="work">
            <br><br>
            *Cell phone:<input type="text" name="cell">
            <br><br>
            *Email:<input type="text" name="email">
            <br><br>
            <input type="submit" value="Save Contact Information">
          </form>
        </body>
        >>
    }
    
    li = function(info) {
      map = info.map(function(v, k) {<<<li>#{k}: #{v}</li> >>});
      map.values().join("");
    }
    
    getterUI = function(map) {
      <<<html>
          <head>
            <title>Contact Information</title>
          </head>
          <body>
            <h1>Contact Info</h1><br>
            #{li(map)}
          </body>
        </html>
        >>
    }
  }
  
  rule get_info {
    select when contact getter
    pre {
      info = store:read_all()
    }
    send_directive("_html", {"content" : getterUI(info)})
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
  
  rule set_info_ui {
    select when contact setter_ui
    
    send_directive("_html", {"content" : setterUI() })
  }

}
 
