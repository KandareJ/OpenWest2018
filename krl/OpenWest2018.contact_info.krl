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
      pc_host = "http://picos.byu.edu:8080";
      pin = Attendee:pin();
      info = store:read_all();
      <<<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="http://picos.byu.edu:8080/css/picomobile.css">
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
        <a class="bar-item button" href="#{pc_host}/OpenWest2018.collection/about_pin.html?pin=#{pin}">Home</a>
        <a class="bar-item button" href="http://picos.byu.edu:8080/sky/event/#{meta:eci}/contactTest/contact/getter">Contacts</a>
        <a class="bar-item button" href="#">My Information</a>
      </nav>
<!-- end no variables -->


    <!-- COMBINED NAME AND PHRASE AND PUT IN CARD-->
    <header class="bar card blue">
      <button class="bar-item button large blue-theme" onclick="openMenubar()">&#9776;</button>
        <h1 class="bar-item">My Information</h1>
    </header>
    <hr>
    <div class="row">
    <form action="http://picos.byu.edu:8080/sky/event/#{meta:eci}/contactTest/contact/setter">
      First Name:<br><input type="text" name="first name" required value=#{info{"first name"}.defaultsTo("")}>
      <br><br>
      Last Name:<br><input type="text" name="last name" required value=#{info{"last name"}.defaultsTo("")}>
      <br><br>
      *Home phone:<br><input type="text" name="home" value=#{info{"home"}.defaultsTo("")}>
      <br><br>
      *Work phone:<br><input type="text" name="work" value=#{info{"work"}.defaultsTo("")}>
      <br><br>
      *Cell phone:<br><input type="text" name="cell" value=#{info{"cell"}.defaultsTo("")}>
      <br><br>
      *Email:<br><input type="text" name="email" value=#{info{"email"}.defaultsTo("")}>
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
      pc_host = "http://picos.byu.edu:8080";
      pin = Attendee:pin();
      <<<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="http://picos.byu.edu:8080/css/picomobile.css">
    <link rel="stylesheet" href="https://use.typekit.net/miv2swc.css">

    <title>Contacts</title>
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
        <a class="bar-item button" href="#{pc_host}/OpenWest2018.collection/about_pin.html?pin=#{pin}">Home</a>
        <a class="bar-item button" href="#">Contacts</a>
        <a class="bar-item button" href="http://picos.byu.edu:8080/sky/event/#{meta:eci}/contactTest/contact/setter_ui">My Information</a>
      </nav>
<!-- end no variables -->


    <!-- COMBINED NAME AND PHRASE AND PUT IN CARD-->
    <header class="bar card blue">
      <button class="bar-item button large blue-theme" onclick="openMenubar()">&#9776;</button>
        <h1 class="bar-item">Contacts</h1>
    </header>
    <hr>





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
    pre {html = setterUI()}
    send_directive("_html", {"content" : html})
    
  }
  

}
