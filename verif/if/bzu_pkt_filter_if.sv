///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

// Packet datapath interface for the bzu_pkt_filter DUT.
// The configuration register-file bus lives in bzu_pkt_filter_cfg_if.
interface bzu_pkt_filter_if;
  logic        clk;
  logic        rst_n;

  // Packet inputs
  logic        valid_in;
  logic [47:0] dst_mac;
  logic [47:0] src_mac;
  logic [15:0] eth_type;
  logic [10:0] length;
  logic        has_vlan;
  logic [3:0]  vlan_id;

  // Packet outputs
  logic        valid_out;
  logic        accept;
  logic [2:0]  drop_reason;

  // Driver drives inputs on negedge so the DUT samples them on the next posedge.
  clocking cb_drv @(negedge clk);
    default input #1step output #0;
    output rst_n;
    output valid_in;
    output dst_mac;
    output src_mac;
    output eth_type;
    output length;
    output has_vlan;
    output vlan_id;
  endclocking

  // Monitor samples outputs on posedge.
  clocking cb_mon @(posedge clk);
    default input #1step;
    input valid_out;
    input accept;
    input drop_reason;
  endclocking

  modport drv (
    input  clk,
    input  rst_n,
    output valid_in,
    output dst_mac,
    output src_mac,
    output eth_type,
    output length,
    output has_vlan,
    output vlan_id
  );

  modport mon (
    input clk,
    input rst_n,
    input valid_out,
    input accept,
    input drop_reason
  );
endinterface
