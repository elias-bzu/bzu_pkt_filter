///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

// Configuration register-file bus for the bzu_pkt_filter DUT.
// Programmed once per test (or whenever the cfg needs to change) by the
// bzu_cfg_driver class. Shares clk/rst_n with the data path interface.
//
// Address map (8-bit registers):
//   2'd0 -> {7'd0, broadcast_enable}   default 8'h01
//   2'd1 -> {7'd0, multicast_enable}   default 8'h01
//   2'd2 -> {4'd0, vlan_min[3:0]}      default 8'h01
//   2'd3 -> {4'd0, vlan_max[3:0]}      default 8'h0A
interface bzu_pkt_filter_cfg_if;
  logic        clk;
  logic        rst_n;

  logic [1:0]  cfg_addr;
  logic [7:0]  cfg_wdata;
  logic        cfg_we;
  logic [7:0]  cfg_rdata;

  clocking cb_cfg @(posedge clk);
    default input #1step output #0;
    output cfg_addr;
    output cfg_wdata;
    output cfg_we;
    input  cfg_rdata;
  endclocking

  modport cfg (
    input  clk,
    input  rst_n,
    output cfg_addr,
    output cfg_wdata,
    output cfg_we,
    input  cfg_rdata
  );
endinterface
