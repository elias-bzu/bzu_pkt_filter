///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

class bzu_test_09_partial_randomization extends bzu_test_base;
  function new(virtual bzu_pkt_filter_if vif_i, virtual bzu_pkt_filter_cfg_if vif_cfg_i);
    super.new(vif_i, vif_cfg_i, 25);
    verbose = 0;
  endfunction

  virtual task run_body();
    bzu_partial_random_seq seq = new("partial_random_seq");
    seq.num_txn      = num_txn;
    seq.dst_mac_val  = 48'h0A0B_0C0D_0E0F;
    seq.src_mac_val  = 48'h2211_2233_4456; // multicast bit 40 = 0
    seq.has_vlan_val = 1'b0;
    seq.vlan_id_val  = 4'd0;
    seq.start(gen, cfg);
  endtask
endclass
