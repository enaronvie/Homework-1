module ALU_4_bit_tb();

//determining registers::independent variables/ stimulus
  reg clk_t(), reset_t();
  reg [1:0] opcode_t;
  reg signed [3:0] A_t, B_t;
  
//dependent varible/output
  wire signed [4:0] C_t;
  
//bookkeeping variables
  int error_ct; //error count varible initialization
  
// Signed 4-bit edge values (zero, minimum, maximum]
  const bit [3:0] edge values [3]=[4'b0000, 4'b1000, 4'b0111};
  
//Opcode error-check display msg
  const string opcode_name[byte]=[0: "Add", 1: "Sub", 2: "Bitwise Invert A", 3: "Reduction_OR_B"];
                                
//Display error message for varibles; time, output & input
   task print_td();
         $display("Time=%St, A=%4b, B=%4b, C=%5b, reset=%1b, opcode=$2b,opcodename=%s", $time(), A_t, B_t, C_t, reset_t, opcode_t, opcode_name[opcode_t]);
   endtask
  
  //error display message count
    task print_ct();
           $write("ERROR: ");
        print_td();
       error_ct=error_ct+1;
     endtask
  
 //Generate random signed inputs A, B, opcode, and a reset bit
  task random_var_generate();
       begin
         {A_t, B_t, opcode_t, reset_t}=$urandom_range(0, 2047); // Total: 2047=(2^11)-1 for; 1-bit reset, 2-bit opcode, x2 4-bit input
        print_td();
       end    
  endtask
   
 //Test for opcode Add and Sub
    task add_sub_test();
         begin                           
          reset_t=1'b0;
           //Testing for case A=0,B=0, Add, Sub
         @(negedge clk_t);
           A_t=edgevalues[0]; //zero
           B_t=edgevalues[0]; //zero
           opcode_t=2'b00; //Add
           @(negedge clk_t);
           
           
           
           
           
           
           
           
           
           
  end
endmodule
