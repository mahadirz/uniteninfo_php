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
                     <h2>{$subject_code} </h2>   
                     <h3>{$subject_name}</h3>
                    </div>
                </div>              

           
           <hr />   
      
            <div class="row">
                <div class="col-md-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Subject's Fee 
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-md-12">
                                    
                                    
                    <!--   Kitchen Sink -->
                        <div class="panel-body">
                            <div class="table-responsive">
                                <table  class="table table-striped table-bordered table-hover">
                                    <thead>
                                        <tr>
                                            <th>Semester</th>
                                            <th>Fee</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {foreach from=$subject_list1 item=s}
                                            <tr>
                                            <td>{$s.semester_name}</td>
                                            <td>RM{$s.price}</td>
                                            </tr>
                                        {/foreach}

                                    </tbody>
                                </table>
                            </div>
                        </div>
                     <!-- End  Kitchen Sink -->
                                                        

                                 
                                </div>
                              

                                
                               
                            </div>
                        </div>
                    </div>
                     <!-- End Form Elements -->
                     
                     
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Lecturers 
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-md-12">
                                    
                                    
                    <!--   Kitchen Sink -->
                        <div class="panel-body">
                            <div class="table-responsive">
                                <table  class="table table-striped table-bordered table-hover">
                                    <thead>
                                        <tr>
                                            <th>Semester</th>
                                            <th>Lecturer's name</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {foreach from=$subject_list2 item=s}
                                            <tr>
                                            <td>{$s.semester_name}</td>
                                            <td>{$s.lecturer_name|capitalize}</td>
                                            </tr>
                                        {/foreach}

                                    </tbody>
                                </table>
                            </div>
                        </div>
                     <!-- End  Kitchen Sink -->
                                                        

                                 
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
