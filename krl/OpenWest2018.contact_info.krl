ruleset OpenWest2018.contact_info {
  meta {
    use module io.picolabs.pds alias store
    use module OpenWest2018.attendee alias Attendee
    shares __testing
  }
  
  global {
    __testing = {"events" : [{"domain" : "contact", "type" : "getter"}],
                 "queries" : [{"name" : "testFunc"}]}
    
    setterUI = function() {
      info = store:all();
      <<<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="picomobile.css">
    <link rel="stylesheet" href="https://use.typekit.net/miv2swc.css">

    <title>My Information</title>
    <script type="text/javascript">
        function openMenubar() {
          document.getElementById("myMenu").style.display = "block";
        }

        function closeMenubar() {
          document.getElementById("myMenu").style.display = "none";
        }
    </script>

  </head>
  <body>

<!-- No Variables -->
      <nav class="menubar block card" id="myMenu">
        <div class="container light-blue">
          <span onclick="closeMenubar()" class="button show-topright small">X</span>
          <br>
          <div class="padding center">
            <h2>Menu</h2>
          </div>
        </div>
        <p class="bar-item button" href="#">Home</p>
        <p class="bar-item button" href="#">Contacts</p>
        <p class="bar-item button" href="#">Settings</p>
      </nav>
<!-- end no variables -->


    <!-- COMBINED NAME AND PHRASE AND PUT IN CARD-->
    <header class="bar card blue">
      <button class="bar-item button large w3-hover-theme" onclick="openMenubar()">&#9776;</button>
        <h1 class="bar-item">My Information</h1>
    </header>
    <hr>
    <div class="row">
    <form action="http://picos.byu.edu:8080/sky/event/#{meta:eci}/contactTest/contact/setter">
      First Name:<br><input type="text" name="first name" required value=#{info{"first name"}}>
      <br><br>
      Last Name:<br><input type="text" name="last name" required value=#{info{"last name"}}>
      <br><br>
      *Home phone:<br><input type="text" name="home" value=#{info{"home"}}>
      <br><br>
      *Work phone:<br><input type="text" name="work" value=#{info{"work"}}>
      <br><br>
      *Cell phone:<br><input type="text" name="cell" value=#{info{"cell"}}>
      <br><br>
      *Email:<br><input type="text" name="email" value=#{info{"email"}}>
      <br><br>
      <input type="submit" value="Save Contact Information">
    </form>
    </div>

    <br>
    <br>
    <br>
    <br>
    <br>
    <br>
    <br>
    <br>
    <br>
    <br>

<!--    No variables here -->
  <footer class="container bottom blue">
    <div class="center"><h4>Contact. Connect. Collect!</h4></div>
  </footer>
  </body>
</html>
        >>
    }
    
    li = function(info) {
      noName = info.filter(function(v, k){not k.match(re#name#)});
      map = noName.map(function(v, k) {<<<li>#{k}: #{v}</li> >>});
      (map.values()[0].isnull()) => "No contact information available" | map.values().join("");
    }
    
    getterUI = function(map) {
      <<<html>
          <head>
            <title>Contact Information</title>
          </head>
          <body>
            
            <h2>#{map{"first name"}} #{map{"last name"}}</h2>
            #{li(map)}
            <br><a href="http://picos.byu.edu:8080/OpenWest2018.collection/about_pin.html?pin=#{Attendee:pin}">back</a>
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
