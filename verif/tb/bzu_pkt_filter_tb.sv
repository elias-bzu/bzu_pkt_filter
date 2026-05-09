///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

`timescale 1ns/1ps

module bzu_pkt_filter_tb;
  // Two interfaces: one for the packet datapath, one for the cfg bus.
  bzu_pkt_filter_if     ifc();
  bzu_pkt_filter_cfg_if cifc();

  // Both interfaces share the same clk/rst_n.
  assign cifc.clk   = ifc.clk;
  assign cifc.rst_n = ifc.rst_n;

  bzu_pkt_filter dut (
    .clk         (ifc.clk),
    .rst_n       (ifc.rst_n),
    .valid_in    (ifc.valid_in),
    .dst_mac     (ifc.dst_mac),
    .src_mac     (ifc.src_mac),
    .eth_type    (ifc.eth_type),
    .length      (ifc.length),
    .has_vlan    (ifc.has_vlan),
    .vlan_id     (ifc.vlan_id),
    .cfg_addr    (cifc.cfg_addr),
    .cfg_wdata   (cifc.cfg_wdata),
    .cfg_we      (cifc.cfg_we),
    .cfg_rdata   (cifc.cfg_rdata),
    .valid_out   (ifc.valid_out),
    .accept      (ifc.accept),
    .drop_reason (ifc.drop_reason)
  );

  // 2 GHz clock => period 0.5 ns.
  initial begin
    ifc.clk = 1'b0;
    forever #0.25 ifc.clk = ~ifc.clk;
  end

  // Reset and idle the buses.
  initial begin
    ifc.rst_n     = 1'b0;
    ifc.valid_in  = 1'b0;
    ifc.dst_mac   = '0;
    ifc.src_mac   = '0;
    ifc.eth_type  = '0;
    ifc.length    = '0;
    ifc.has_vlan  = 1'b0;
    ifc.vlan_id   = '0;

    cifc.cfg_addr  = '0;
    cifc.cfg_wdata = '0;
    cifc.cfg_we    = 1'b0;

    repeat (4) @(posedge ifc.clk);
    ifc.rst_n = 1'b1;
  end

  `include "bzu_pkt_filter_test.sv"
endmodule
