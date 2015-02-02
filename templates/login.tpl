<!DOCTYPE html>
<html>

<head>

  <meta charset="UTF-8">

  <!--
Copyright (c) 2014 by Ace Subido (http://codepen.io/ace-subido/pen/Cuiep)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
-->

  <title>UNITEN INFO</title>

  <link rel='stylesheet' href='resources/css/bootstrap.min.css'>

  <style>body {
  background: #eee !important;
}

.wrapper {
  margin-top: 80px;
  margin-bottom: 80px;
}

.registerButton {
  max-width: 380px;
  padding: 15px 35px 45px;
  margin: 0 auto;
}

.form-signin {
  max-width: 380px;
  padding: 15px 35px 45px;
  margin: 0 auto;
  background-color: #fff;
  border: 1px solid rgba(0, 0, 0, 0.1);
}
.form-signin .form-signin-heading,
.form-signin .checkbox {
  margin-bottom: 30px;
}
.form-signin .checkbox {
  font-weight: normal;
}
.form-signin .form-control {
  position: relative;
  font-size: 16px;
  height: auto;
  padding: 10px;
  -webkit-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
}
.form-signin .form-control:focus {
  z-index: 2;
}
.form-signin input[type="text"] {
  margin-bottom: -1px;
  border-bottom-left-radius: 0;
  border-bottom-right-radius: 0;
}
.form-signin input[type="password"] {
  margin-bottom: 20px;
  border-top-left-radius: 0;
  border-top-right-radius: 0;
  


}

/* unvisited link */
a.reg:link {
    color: #000000;
}
/* visited link */
a.reg:visited {
    color: #000000;
}
/* mouse over link */
a.reg:hover {
    color: #FF0000;
    text-decoration:none;
}
/* selected link */
a.reg:active {
    color: #0000FF;
}

</style>

  <script>
    window.open    = function(){};
    window.print   = function(){};
    // Support hover state for mobile.
    if (false) {
      window.ontouchstart = function(){};
    }
  </script>

</head>

<body>

    <div class="wrapper">
    <form method="POST" class="form-signin" onsubmit="return authenticate()">       
    
      <h2 class="form-signin-heading"> <img src="resources/images/uniten-logo.jpg" width="50px" height="50px" /> UNITEN INFO</h2>
      

      <div id="errorAlert" style="display:none" class="alert alert-danger alert-dismissible" role="alert">
     <button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
     <strong>Error in authentication</strong>
      </div>

      
      <input type="text" id="studentId" class="form-control" name="studentId" placeholder="Student ID" required="" autofocus="" />
      <input type="password" id="password" class="form-control" name="password" placeholder="Password" required=""/>      

      <button class="btn btn-lg btn-primary btn-block" type="submit">Login</button>  
      
      <p style="padding-top:10px;"><a href="#">To reset password you need to go to ITMS</a></p>
      <hr />
      
      <p>This is Web Programming project for SEM 2 2014/2015 </p>
      <ul>
        <li>Mohamad Mahadir Ahmad</li>
        <li>Alif Fakhruddin Azhar</li>
      </ul>
      
      <p>Supervised by Mr. Azlan Yusof</p>
      <p>Presentation Date: 2nd Feb 2014</p>
      
    </form>
    
    


  </div>

<div id="loadingdialog" style="display:none;width:250px;">
        <h1>Please wait...</h1>
        <img style="position: relative;left: 100px;" src="resources/images/ajax-loader.gif" />
        
</div>   

<!-- JQUERY SCRIPTS -->
<script src="resources/js/jquery-1.10.2.js"></script>
<!-- Add mousewheel plugin (this is optional) -->
<script type="text/javascript" src="resources/fancybox/lib/jquery.mousewheel-3.0.6.pack.js"></script>

<!-- Add fancyBox -->
<link rel="stylesheet" href="resources/fancybox/source/jquery.fancybox.css?v=2.1.5" type="text/css" media="screen" />
<script type="text/javascript" src="resources/fancybox/source/jquery.fancybox.pack.js?v=2.1.5"></script>

<!-- Optionally add helpers - button, thumbnail and/or media -->
<link rel="stylesheet" href="resources/fancybox/source/helpers/jquery.fancybox-buttons.css?v=1.0.5" type="text/css" media="screen" />
<script type="text/javascript" src="resources/fancybox/source/helpers/jquery.fancybox-buttons.js?v=1.0.5"></script>
<script type="text/javascript" src="resources/fancybox/source/helpers/jquery.fancybox-media.js?v=1.0.6"></script>

<link rel="stylesheet" href="resources/fancybox/source/helpers/jquery.fancybox-thumbs.css?v=1.0.7" type="text/css" media="screen" />
<script type="text/javascript" src="resources/fancybox/source/helpers/jquery.fancybox-thumbs.js?v=1.0.7"></script>


<script type="text/javascript">
function authenticate() {

    $.fancybox(document.getElementById("loadingdialog"),
    {
		closeBtn	: false,
		modal     	: true,
		openEffect	: 'none',
		closeEffect	: 'none'
	});
    
    function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+d.toUTCString();
    document.cookie = cname + "=" + cvalue + "; " + expires;
    } 
    
    var studentId = $( "#studentId").val();
    var password = $( "#password").val();
    
    $.ajax({
		type: "POST",
		url: "authenticator",
		data: "studentId="+studentId+"&password="+password,
		success: function(msg){
            console.log(msg);
            if(msg.authenticated == true){
                setCookie("student_id",studentId,1);
                setCookie("encrypted_pass",msg.encrypted_pass,1);
                //redirect
                window.location.href = "home";
            }
            else{
                $("#errorAlert").show();            
            }
            
             $.fancybox.close( true );
		}
	});
    
    return false;
}
</script>



</body>

</html>
