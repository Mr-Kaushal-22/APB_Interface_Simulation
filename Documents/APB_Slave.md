
# Entity: APB_Slave 
- **File**: APB_Slave.v

## Diagram
![Diagram](APB_Slave.svg "Diagram")
## Ports

| Port name | Direction | Type  | Description |
| --------- | --------- | ----- | ----------- |
| pclk      | input     |       |             |
| presetn   |           |       |             |
| penable   | input     |       |             |
| psel      | input     |       |             |
| pwrite    | input     |       |             |
| paddr     | input     | [7:0] |             |
| pwdata    | input     | [7:0] |             |
| prdata    | output    | [7:0] |             |
| pready    | output    |       |             |

## Signals

| Name      | Type      | Description |
| --------- | --------- | ----------- |
| mem[63:0] | reg [7:0] |             |

## Processes
- unnamed: ( @(*) )
  - **Type:** always
