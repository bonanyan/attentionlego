// global parameters
`define BIT_WIDTH 8
`define VOCAB_SIZE 32000
`define MAX_SEQUENCE_LENGTH 2048
`define N_HEADS 32
`define N_LAYERS 32
`define D_MODEL 4096
`define D_ff 11008 //hidden_dimension of MLP
`define D_k 128 //hidden_dimension of one head

// WeightGenerator parameters
// for single apim module
`define DATA_WIDTH 8 // unit: bit
`define ADDR_WIDTH 14 // unit: bit, each pim 128*128
`define RAM_DEPTH 1 << `ADDR_WIDTH
// for single apim module
`define CIM_ROW_WIDTH 128
`define CIM_COL_WIDTH 128
`define ADDR_COL_WIDTH 7
`define ADDR_ROW_WIDTH 7
`define ADC_PRECISION 6             // unit: bit
`define CIM_INPUT_PRECISION 4        // unit: bit
`define CIM_INPUT_PARALLELISM 16    // unit: 1 (quantity)
`define CIM_INPUT_SHARE 8          // SHARE*PARALLEL=128
`define CIM_OUTPUT_PARALLELISM 16    // unit: 1 (quantity)
`define CIM_OUTPUT_SHARE 8           // SHARE*PARALLEL=128
`define RAM_DEPTH (`CIM_ROW_WIDTH * `CIM_COL_WIDTH)
// for macro weight generator module
`define CIM_NUM_COL 1                // column select, 8 default
`define COLUMN_SIZE `D_k          // this should equal COLUMN_NUM*CIM_COL_WIDTH
`define CIM_NUM_ROW 32                  // row select width, 32 default
`define ROW_SIZE `D_MODEL           // this should equal ROW_NUM*CIM_ROW_WIDTH
`define CIM_NUM `CIM_NUM_COL * `CIM_NUM_ROW 