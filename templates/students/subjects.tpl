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
                     <h2>Subject Lookup </h2>   
                     <p>~ {$total_subjects} subjects in Database</p>
                    </div>
                </div>              

           
           <hr />   
           
           {if $block_search_access == true}
           <div class="row">
                <div class="col-md-12">
                    <!-- Form Elements -->
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Refresh...
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-md-6">


                                   <div id="loadingDiv">
                                   </div>
                                   <p id="loadingNum"></p>
                                   
                                   <p id="loadingError"></p>
                                     

                                 
                                </div>
                                
                               
                            </div>
                        </div>
                    </div>
                     <!-- End Form Elements -->
                </div>
            </div>
                <!-- /. ROW  -->    
            
            {else}  
           
           <div class="row">
                <div class="col-md-12">
                    <!-- Form Elements -->
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Search
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-md-6">


                                    <form method="POST" role="form">
                                    
                                       <div class="form-group">
                                            <input class="form-control"  name="searchSubject" />
                                        </div>
                                        
                                        
                                        <button name="edit_profiles" type="submit" class="btn btn-primary">Search Subject</button>
                                        
                                        
                                        

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
                
                
            {if $search_result}    
            <div class="row">
                <div class="col-md-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            Search Result
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-md-12">
                                    
                                    
                    <!--   Kitchen Sink -->
                        <div class="panel-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered table-hover">
                                    <thead>
                                        <tr>
                                            <th>Subject Code</th>
                                            <th>Subject Name</th>
                                            <th>Fee</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        
                                        {foreach from=$search_result item=s}
                                            <tr>
                                            <td> <a href="?code={$s.code}">{$s.code}</a></td>
                                            <td>{$s.name}</td>
                                            <td>RM {$s.price}</td>
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
            {/if}
            
            {/if}
            
          
    </div>
             <!-- /. PAGE INNER  -->
            </div>
         <!-- /. PAGE WRAPPER  -->
        </div>
    
    {include file="students/bottom.tpl"}
    
    {if $block_search_access == true}
    <script type="text/javascript">
        // A $( document ).ready() block.
        $( document ).ready(function() {
            var totalError =0;
            var settle=1;
            var list_tb = {$list_tb};
            var update_start_index = {$update_start_index};
            for(i=0; i<{$update_total};i++){
                console.log(list_tb[i]);
                $("#loadingDiv").html('<img style="position: relative;left: 5px;" src="resources/images/ajax-loader.gif" />');
                $("#loadingNum").html("Loading 0 of {$update_total}");
                    $.ajax({
    		          type: "POST",
    		          url: "subject-updater",
    		          data: "url="+encodeURIComponent(list_tb[update_start_index].url),
    		          success: function(msg){
                        $("#loadingNum").html('Loading '+settle+" of {$update_total}");
                        settle++;
                        if(msg.error == false){
                            console.log(msg.data);
                        }
                        else{
                            totalError++;    
                            console.log(msg.debug);    
                            var error = $("#loadingError").html();                            
                            $("#loadingError").html(error+ "<br>\n"+msg.debug);
                            
                        }
                        
                        if(settle == {$update_total}+1 ){
                            //complete
                            if(totalError == 0){
                                //refresh
                                $("#loadingDiv").html("Refresh contents");
                                window.location.href = "subject";
                            }
                            else{
                                $("#loadingDiv").html("There is an error, please inform admin by sending the error details");
                            }
                        }
                
    		          },
                      error: function (msg){
                        console.log(msg.debug);
                        totalError++;
                        settle++;
                        var error = $("#loadingError").html();                            
                        $("#loadingError").html(error+ "<br>\n"+msg.debug);
                        
                        
                        if(settle == {$update_total}+1 ){
                            //complete
                            if(totalError == 0){
                                //refresh
                                $("#loadingDiv").html("Refresh contents");
                                window.location.href = "subject";
                            }
                            else{
                                $("#loadingDiv").html("There is an error, please inform admin by sending the error details");
                            }
                        }
                        
                      }
                      
                    });
                    
                    update_start_index++;
            }//end for
        });
    </script>
    {/if}
   
</body>
</html>
