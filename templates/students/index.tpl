<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

{include file="students/head.tpl"}


</head>
<body>
    <div id="wrapper">
    
    {include file="students/top.tpl"}
    
    {include file="students/navigation.tpl"}
           
             
        <!-- /. NAV SIDE  -->
        <div id="page-wrapper" >
            <div id="page-inner">
                <div class="row">
                    <div class="col-md-12">
                    <p style="color:green"><img src="resources/images/Padlock.jpg" width="20" height="20" />You are in encrypted secure connections</p>
                     <h2>Student Dashboard</h2>   
                    </div>
                </div>              

           
           <hr />       
           
           <div class="row">
                <div class="col-md-12">
                    <!-- Form Elements -->
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Biodata
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-md-6">
    
    
                                
                                {if $update_profile_success == true}
                                <div class="alert alert-success alert-dismissible" role="alert">
                                <button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                                <strong>Success! </strong> Profiles updated!
                                </div>
                                {/if}

                                    <form method="POST" role="form">
                                    
                                       <div class="form-group">
                                            <label>Student ID</label>
                                            <input class="form-control" value="{$student_data->studentId}" disabled="true" />
                                        </div>
                                        
                                        
                                        <div class="form-group">
                                            <label>Full Name</label>
                                            <input disabled="true"value="{$student_data->name}" class="form-control" />
                                        </div>
                                        
                                        <div class="form-group">
                                            <label>Advisor</label>
                                            <input disabled="true"value="{$student_data->advisor}" class="form-control" />
                                        </div>
                                        
                                        <div class="form-group">
                                            <label>Campus</label>
                                            <input disabled="true"value="{$student_data->campus}" class="form-control" />
                                        </div>
                                        
                                        <div class="form-group">
                                            <label>Course</label>
                                            <input disabled="true"value="{$student_data->program_name}" class="form-control" />
                                        </div>
                                        

                                        
                                        <div class="form-group">
                                            <label>Scorun Points</label>
                                            <input disabled="true"value="{$student_data->scorun}" class="form-control" />
                                        </div>
                                        

                                        <div class="form-group">
                                            <label>Email</label>
                                            <input class="form-control" value="{$student_data->email}" name="email" />
                                        </div>
                                        
                                        <div class="form-group">
                                            <label>Phone Number</label>
                                            <input class="form-control" value="{$student_data->phone}" name="phone" />
                                        </div>
                                        
                                        <button name="edit_profiles" type="submit" class="btn btn-primary">Update</button>
                                        
                                        
                                        

                                    </form>
                                    <br />
                                     

                                 
    </div>
                                
                               
                            </div>
                        </div>
                    </div>
                     <!-- End Form Elements -->
                </div>
            </div>
                <!-- /. ROW  -->   
            
          
    </div>
             <!-- /. PAGE INNER  -->
            </div>
         <!-- /. PAGE WRAPPER  -->
        </div>
    
    {include file="students/bottom.tpl"}
   
</body>
</html>
