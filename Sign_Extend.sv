module Sign_Extend(
    input  [31:0] In,
    input         ImmSrc,
    output [31:0] Imm_Ext
);

assign Imm_Ext = ImmSrc ?
                 {{20{In[31]}}, In[31:25], In[11:7]} : // S-type
                 {{20{In[31]}}, In[31:20]};            // I-type

endmodule