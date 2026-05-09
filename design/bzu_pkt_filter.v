///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

`timescale 1ns/1ps

module bzu_pkt_filter (
   input  logic        clk,
   input  logic        rst_n,

   input  logic        valid_in,
   input  logic [47:0] dst_mac,
   input  logic [47:0] src_mac,
   input  logic [15:0] eth_type,
   input  logic [10:0] length,
   input  logic        has_vlan,
   input  logic [3:0]  vlan_id,

   // Configuration register file (programmed once before traffic).
   //   addr 2'd0 -> {7'd0, broadcast_enable}   default 8'h01
   //   addr 2'd1 -> {7'd0, multicast_enable}   default 8'h01
   //   addr 2'd2 -> {4'd0, vlan_min[3:0]}      default 8'h01
   //   addr 2'd3 -> {4'd0, vlan_max[3:0]}      default 8'h0A
   input  logic [1:0]  cfg_addr,
   input  logic [7:0]  cfg_wdata,
   input  logic        cfg_we,
   output logic [7:0]  cfg_rdata,

   output logic        valid_out,
   output logic        accept,
   output logic [2:0]  drop_reason
);

   localparam logic [2:0] DROP_NONE      = 3'd0;
   localparam logic [2:0] DROP_LENGTH    = 3'd1;
   localparam logic [2:0] DROP_BROADCAST = 3'd2;
   localparam logic [2:0] DROP_MULTICAST = 3'd3;
   localparam logic [2:0] DROP_ETH_TYPE  = 3'd4;
   localparam logic [2:0] DROP_VLAN      = 3'd5;

   // 4-entry x 8-bit configuration register file.
   logic [7:0] cfg_mem [0:3];

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         cfg_mem[0] <= 8'h01;  // broadcast_enable
         cfg_mem[1] <= 8'h01;  // multicast_enable
         cfg_mem[2] <= 8'h01;  // vlan_min
         cfg_mem[3] <= 8'h0A;  // vlan_max
      end
      else if (cfg_we) begin
         cfg_mem[cfg_addr] <= cfg_wdata;
      end
   end

   assign cfg_rdata = cfg_mem[cfg_addr];

   wire        broadcast_enable = cfg_mem[0][0];
   wire        multicast_enable = cfg_mem[1][0];
   wire [3:0]  vlan_min         = cfg_mem[2][3:0];
   wire [3:0]  vlan_max         = cfg_mem[3][3:0];

   logic is_broadcast;
   logic is_multicast;
   logic is_valid_length;
   logic is_valid_eth_type;
   logic is_valid_vlan;

   always_comb begin
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
   end

   always_ff @(posedge clk or negedge rst_n) begin
      if (!rst_n) begin
         valid_out   <= 1'b0;
         accept      <= 1'b0;
         drop_reason <= DROP_NONE;
      end
      else begin
         valid_out <= valid_in;

         if (!valid_in) begin
            accept      <= 1'b0;
            drop_reason <= DROP_NONE;
         end
         else if (!is_valid_length) begin
            accept      <= 1'b0;
            drop_reason <= DROP_LENGTH;
         end
         else if (is_broadcast && !broadcast_enable) begin
            accept      <= 1'b0;
            drop_reason <= DROP_BROADCAST;
         end
         else if (is_multicast && !multicast_enable) begin
            accept      <= 1'b0;
            drop_reason <= DROP_MULTICAST;
         end
         else if (!is_valid_eth_type) begin
            accept      <= 1'b0;
            drop_reason <= DROP_ETH_TYPE;
         end
         else if (!is_valid_vlan) begin
            accept      <= 1'b0;
            drop_reason <= DROP_VLAN;
         end
         else begin
            accept      <= 1'b1;
            drop_reason <= DROP_NONE;
         end
      end
   end

endmodule
