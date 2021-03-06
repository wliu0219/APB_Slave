module apb_tb;
parameter ADDRW = 32;
parameter DATAW = 32;

reg PCLK = 0;
reg PRESETn;
reg [ADDRW-1:0]   PADDR   ;
reg               PSEL    ;
reg               PENABLE ;
reg               PWRITE  ;
reg [DATAW-1:0]   PWDATA  ;

always #10 PCLK = ~PCLK;

task write(input [ADDRW-1:0] addr, input [ADDRW-1:0] data);
begin
@(posedge PCLK)
PADDR = addr;
PWDATA = data;
PWRITE = 1;
PSEL = 1;
PENABLE = 0;
@(posedge PCLK)
PENABLE = 1;
@(posedge PCLK)
@(posedge PCLK)
PSEL = 0;
PENABLE = 0;
end
endtask

task read(input [ADDRW-1:0] addr);
begin
@(posedge PCLK)
PADDR = addr;
PWRITE = 0;
PSEL = 1;
PENABLE = 0;
@(posedge PCLK)
PENABLE = 1;
@(posedge PCLK)
@(posedge PCLK)
PSEL = 0;
PENABLE = 0;
end
endtask

initial begin
PRESETn = 0;
#20;
PRESETn = 1;
#10;
write(100,200);
//#60;
read(100);
end

apb_slave apb_slave_inst(
.PCLK    (PCLK   ),
.PRESETn (PRESETn),
          
.PADDR   (PADDR  ),
.PSEL    (PSEL   ),
.PENABLE (PENABLE),
.PWRITE  (PWRITE ),
.PWDATA  (PWDATA ),
          
.PREADY  (PREADY ),
.PRDATA  (PRDATA ),
.PSLVERR (PSLVERR)
);



endmodule
