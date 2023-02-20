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
  const bit [3:0] edgevalues [3]=[4'b0000, 4'b1000, 4'b0111};
  
//Opcode error-check display msg
  const string opcode_name[byte]=[0: "Add", 1: "Sub", 2: "Bitwise Invert A", 3: "Reduction_OR_B"];
                                   
//generate clock
   always  // no sensitivity list, so it always executes 
      begin
    clk_t=1; #5; clk=0; #5 //10ns period
      end
                                   
//Display error message for varibles; time, output & input
   task print_td();
     $display("Time=%St, A=%4b, B=%4b, C=%5b, reset=%1b, opcode=$2b, opcodename=%s", $time(), A_t, B_t, C_t, reset_t, opcode_t, opcode_name[opcode_t]);
   endtask
  
//success display message  
    task print_s();
      $display("SUCCESS!");
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
       end    
  endtask
   
 //Test for opcode Add
    task add_test();
         begin                           
          reset_t=1'b0;
           
           //Testing for case A=0, B=0, Add, Sub
           @(negedge clk_t); 
           foreach (edgevalues[i])
             begin
               A_t=edgevalues[i]; //zero
               B_t=edgevalues[i]; //zero
           opcode_t=2'b00; //Add opcode
         @(negedge clk_t);
               if (A_t + B_t !== C_t) //monitor logic
             begin 
               print_td();
               print_ct();
             end else begin
               print_s();
             end
         end
         end 
    endtask
           
         //Test for opcode Sub
    task sub_test();
         begin                           
          reset_t=1'b0;
           
           //Testing for case A=0, B=0, Add, Sub
           @(negedge clk_t); 
           foreach (edgevalues[i])
             
             begin
               A_t=edgevalues[i]; //zero
               B_t=edgevalues[i]; //zero
           opcode_t=2'b01; //Add opcode
         @(negedge clk_t);
               
               if (A_t > B_t) //monitor sign of B
            begin 
              
              if (A_t - B_t !== C_t) //monitor logic
             begin 
               print_td();
               print_ct();
             end else begin
               print_s();
             end
            end
               
              else if (A_t < B_t) 
                begin
                  B_t = !B_t + 1; //take 1's complement and 2's complement to do A_t + (-B_t)
                  if (A_t + B_t !== C_t) //monitor logic
             begin   
               print_td();
               print_ct();
             end else begin
               print_s();
             end
                end
                        
         end
         end 
    endtask
           
 //Test for opcode NotA
     task NotA_test();
       begin
         reset_t=1'b0; 
         foreach(edgevalues[i]) begin
           
           @(negedge clk_t);
    
       A_t=edgevalues[i];
       opcode_t=2'b10; // not A opcode
           
           @(negedge clk_t);
           
           if (C_t !== !A_t) //monitor logic
          begin
            print_td();
            print_ct();
          end else begin 
            print_s(); end
          end
      end              
      endtask
           
           
 //Test for opcode Reduction_OR_B
  task Reduce_OR_B_test();  
        begin 
       reset_t=1'b0 
         foreach(edgevalues[i]) begin
           
           @(negedge clk_t);
    
       B_t=edgevalues[i];
       opcode_t=2'b11; // Reduction_OR_B opcode
           
           @(negedge clk_t);
           
           if (C_t !== |B)//monitor logic
          begin
            print_td();
            print_ct();
          end else begin 
            print_s(); end
          end   
        end 
    endtask 
           
           
  always #10 clk_t = ~clk_t;   
  
  
  initial begin
    
    // Populate waveforms for EPWave
    //	- Check EPWave box
    //	- in the "Compile Options" add -debug_access+all
    $vcdpluson;
    $vcdplusmemon;
    $dumpfile("dump.vcd"); 
    $dumpvars;
    
  	// Initialize clock
    clk_tb = 1'b1;
    @(posedge clk_tb);
    
    print_td();
    print_s();
    print_ct();
    add_test()
    sub_test()
    NotA_test();
    Reduce_OR_B_test()
    
    // Generate, drive, score, and check 50 random test vectors
    repeat(50) begin
       random_var_generate();
    end
    
    // End simulation
    $display("Total errors: %d", error_ct);
    $finish();
    
  end
  
  // Instance of regfile
  ALU_4_bit 
  ALU_inst(
      .clk(clk_t), 
    .reset(reset_t),
    .Opcode(opcode_t),
    .A(A_t),
    .B(B_t),
    .C(C_t) );
endmodule
           
           
           
           
  end
endmodule
