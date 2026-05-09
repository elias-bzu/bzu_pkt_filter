///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

class bzu_test_04_vlan_behavior extends bzu_test_base;
  function new(virtual bzu_pkt_filter_if vif_i, virtual bzu_pkt_filter_cfg_if vif_cfg_i);
    super.new(vif_i, vif_cfg_i, 10);
    verbose = 0;
  endfunction

  virtual task run_body();
    bzu_vlan_directed_seq seq_ok = new("vlan_valid_seq");
    seq_ok.num_txn        = 5;
    seq_ok.has_vlan_val   = 1'b1;
    seq_ok.disable_c_vlan = 1'b0;
    seq_ok.start(gen, cfg);

    for (int i = 0; i < 5; i++) begin
      bzu_vlan_directed_seq seq_inv = new($sformatf("vlan_inv_%0d_seq", i));
      seq_inv.num_txn        = 1;
      seq_inv.has_vlan_val   = 1'b1;
      seq_inv.disable_c_vlan = 1'b1;
      seq_inv.vlan_id_val    = (i % 2 == 0) ? 4'd0 : 4'd11;
      seq_inv.start(gen, cfg);
    end
  endtask
endclass
