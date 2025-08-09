// verilog_lint: waive-start explicit-parameter-storage-type
// verilog_lint: waive-start parameter-name-style

module BranchComparison_Unit (
    input wire [31:0] SrcA,
    input wire [31:0] SrcB,
    input wire [2:0] branch_d,
    output wire pc_srd_d
);

localparam [2:0] NO_BRANCH = 3'b000, BRANCH_EQUAL = 3'b001, BRANCH_NOT_EQUAL = 3'b010,
                 BRANCH_LT_ZERO = 3'b011, BRANCH_LTE_ZERO = 3'b100, BRANCH_GT_ZERO = 3'b101,
                 BRANCH_GTE_ZERO = 3'b110;

// Peforming the branch comparison
wire Is_Equal;
wire A_is_Negative;
wire A_is_Zero;

assign Is_Equal = (SrcA == SrcB);
assign A_is_Zero = ~|SrcA;         // SrcA == 32'd0
assign A_is_Negative = SrcA[31];   // Check the sign bit (MSB) for signed comparisons


wire equal_d;
wire not_equal_d;
wire lt_zero_d;
wire lte_zero_d;
wire gt_zero_d;
wire gte_zero_d;

assign equal_d     = Is_Equal;
assign not_equal_d = ~Is_Equal;
assign lt_zero_d   = A_is_Negative;
assign gte_zero_d  = ~A_is_Negative;
assign lte_zero_d  = A_is_Negative || A_is_Zero;
assign gt_zero_d   = ~A_is_Negative && ~A_is_Zero;


// Taking action based on the branch comparison
assign pc_srd_d = ((branch_d == BRANCH_EQUAL) & equal_d) ||
                  ((branch_d == BRANCH_NOT_EQUAL) & not_equal_d) ||
                  ((branch_d == BRANCH_LT_ZERO) & lt_zero_d) ||
                  ((branch_d == BRANCH_LTE_ZERO) & lte_zero_d) ||
                  ((branch_d == BRANCH_GT_ZERO) & gt_zero_d) ||
                  ((branch_d == BRANCH_GTE_ZERO) & gte_zero_d);



endmodule
