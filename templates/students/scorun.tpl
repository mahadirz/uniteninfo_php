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
                     <h2>SCORUN </h2>   
                    </div>
                </div>              

           
           <hr />   
      
            <div class="row">
                <div class="col-md-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            TOP 50
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
                                            <th>#</th>
                                            <th width="40%">Name</th>
                                            <th width="55%">Program</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {$i=1}
                                        {foreach from=$top_scorun item=s}
                                            <tr>
                                            <td>{$i}</td>
                                            <td>{$s.name|capitalize}</td>
                                            <td>{$s.program_name}</td>
                                            {$i = $i +1}
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
