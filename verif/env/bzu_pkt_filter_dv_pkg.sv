///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

package bzu_pkt_filter_dv_pkg;

  typedef logic [2:0] drop_reason_t;

  localparam drop_reason_t DROP_NONE      = 3'd0;
  localparam drop_reason_t DROP_LENGTH    = 3'd1;
  localparam drop_reason_t DROP_BROADCAST = 3'd2;
  localparam drop_reason_t DROP_MULTICAST = 3'd3;
  localparam drop_reason_t DROP_ETH_TYPE  = 3'd4;
  localparam drop_reason_t DROP_VLAN      = 3'd5;

  function automatic void calc_expected(
    input  logic [47:0] dst_mac,
    input  logic [47:0] src_mac,
    input  logic [15:0] eth_type,
    input  logic [10:0] length,
    input  logic        has_vlan,
    input  logic [3:0]  vlan_id,
    input  logic        broadcast_enable,
    input  logic        multicast_enable,
    input  logic [3:0]  vlan_min,
    input  logic [3:0]  vlan_max,
    output logic        exp_accept,
    output drop_reason_t exp_drop_reason
  );
    logic is_broadcast;
    logic is_multicast;
    logic is_valid_length;
    logic is_valid_eth_type;
    logic is_valid_vlan;

    is_broadcast = (dst_mac == 48'hFFFF_FFFF_FFFF);
    is_multicast = dst_mac[40];

    is_valid_length = (length >= 11'd64) && (length <= 11'd1500);
    is_valid_eth_type =
      (eth_type == 16'h0800) ||
      (eth_type == 16'h0806) ||
      (eth_type == 16'h86DD);

    is_valid_vlan =
      (!has_vlan) ||
      ((vlan_id >= vlan_min) && (vlan_id <= vlan_max));

    if (!is_valid_length) begin
      exp_accept      = 1'b0;
      exp_drop_reason = DROP_LENGTH;
    end
    else if (is_broadcast && !broadcast_enable) begin
      exp_accept      = 1'b0;
      exp_drop_reason = DROP_BROADCAST;
    end
    else if (is_multicast && !multicast_enable) begin
      exp_accept      = 1'b0;
      exp_drop_reason = DROP_MULTICAST;
    end
    else if (!is_valid_eth_type) begin
      exp_accept      = 1'b0;
      exp_drop_reason = DROP_ETH_TYPE;
    end
    else if (!is_valid_vlan) begin
      exp_accept      = 1'b0;
      exp_drop_reason = DROP_VLAN;
    end
    else begin
      exp_accept      = 1'b1;
      exp_drop_reason = DROP_NONE;
    end
  endfunction

  `include "bzu_filter_cfg.sv"
  `include "bzu_packet.sv"

endpackage

