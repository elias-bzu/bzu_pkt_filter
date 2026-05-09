///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

// Drives the DUT's configuration register-file bus via the dedicated
// bzu_pkt_filter_cfg_if interface. Used by env.program_cfg() to push
// the four bzu_filter_cfg fields into the DUT's cfg_mem.
class bzu_cfg_driver;
  virtual bzu_pkt_filter_cfg_if vif;

  function new(virtual bzu_pkt_filter_cfg_if vif_i);
    vif = vif_i;
  endfunction

  task automatic write_reg(logic [1:0] addr, logic [7:0] data);
    @(vif.cb_cfg);
    vif.cb_cfg.cfg_addr  <= addr;
    vif.cb_cfg.cfg_wdata <= data;
    vif.cb_cfg.cfg_we    <= 1'b1;
    @(vif.cb_cfg);
    vif.cb_cfg.cfg_we    <= 1'b0;
  endtask

  task automatic read_reg(logic [1:0] addr, output logic [7:0] data);
    @(vif.cb_cfg);
    vif.cb_cfg.cfg_addr <= addr;
    @(vif.cb_cfg);
    data = vif.cb_cfg.cfg_rdata;
  endtask

  task automatic program_cfg(bzu_filter_cfg cfg);
    write_reg(2'd0, {7'd0, cfg.broadcast_enable});
    write_reg(2'd1, {7'd0, cfg.multicast_enable});
    write_reg(2'd2, {4'd0, cfg.vlan_min});
    write_reg(2'd3, {4'd0, cfg.vlan_max});
    $display("[bzu_cfg_driver] programmed %s", cfg.sprint());
  endtask
endclass
