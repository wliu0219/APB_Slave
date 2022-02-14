module apb_slave#(
//bus
parameter ADDRW = 32,
parameter DATAW = 32,
//mem
parameter WIDTH = 16 ,
parameter DEPTH = 256
)(
input               PCLK    ,
input               PRESETn ,

input [ADDRW-1:0]   PADDR   ,
input               PSEL    ,
input               PENABLE ,
input               PWRITE  ,
input [DATAW-1:0]   PWDATA  ,

output reg              PREADY  ,
output reg [ADDRW-1:0]  PRDATA  ,
output                  PSLVERR
);

//parameter IDLE   = 2'b00;
//parameter SETUP  = 2'b01;
//parameter ACCESS = 2'b10;

//reg [1:0] state_c;
//reg [1:0] state_n;
reg [WIDTH-1:0] mem [DEPTH-1:0];
reg PREADY_FF;

/*
wire Transfer;
assign Transfer = PSEL;

always  @(posedge PCLK or negedge PRESETn)begin
    if(PRESETn ==1'b0)begin
        state_c <= 0;
    end
    else begin
        state_c <= state_n;
    end
end

always  @(*)begin
  case(state_c)
      IDLE  :begin
          if(Transfer == 1)begin
            state_n = SETUP;
          end
          else begin
            state_n = IDLE;
          end
      end
      SETUP :begin
          state_n = ACCESS;
      end
      ACCESS:begin
          if(PREADY == 1 && Transfer == 1)begin
            state_n = SETUP;
          end
          else if(PREADY == 1 && Transfer == 0)begin
            state_n = IDLE;
          end
          else begin
            state_n = ACCESS;
          end
      end
      default:begin
          state_n = IDLE;
      end
  endcase
end

*/

always  @(posedge PCLK or negedge PRESETn)begin
    if(PRESETn ==1'b0)begin
        PREADY_FF <= 1;
    end
    else if(PSEL && PENABLE) begin
        PREADY_FF <= 1;
    end
    else begin
        PREADY_FF <= 0;
    end
end



always  @(posedge PCLK or negedge PRESETn)begin
    if(PRESETn ==1'b0)begin
        PREADY <= 1;
    end
    else if(PENABLE && PREADY_FF == 0) begin
        PREADY <= 1;
    end
    else begin
        PREADY <= 0;
    end
end




always  @(posedge PCLK or negedge PRESETn)begin
    if(PRESETn ==1'b0)begin
        PRDATA <= 0;
    end
    else if(PSEL && PENABLE && PWRITE == 0) begin
        PRDATA <= mem[PADDR];
    end
end

genvar i;
generate
for (i = 0; i < DEPTH; i = i+1)
always  @(posedge PCLK or negedge PRESETn)begin
    if(PRESETn==1'b0)begin
        mem[i] = 0;
    end
    else if(PSEL && PENABLE && PWRITE == 1) begin
        mem[PADDR] = PWDATA;
    end
end
endgenerate


//PSLVERR stands for error, error can be passed via this signal if slave module has an error flag.

assign PSLVERR = 0;


endmodule
