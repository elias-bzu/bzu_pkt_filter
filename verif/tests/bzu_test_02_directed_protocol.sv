///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

class bzu_test_02_directed_protocol extends bzu_test_base;
  function new(virtual bzu_pkt_filter_if vif_i, virtual bzu_pkt_filter_cfg_if vif_cfg_i);
    super.new(vif_i, vif_cfg_i, 40);
    verbose = 0;
  endfunction

  virtual task run_body();
    bzu_eth_type_directed_seq seq_v4  = new("ipv4_seq");
    bzu_eth_type_directed_seq seq_arp = new("arp_seq");

    seq_v4.num_txn      = 20;
    seq_v4.eth_type_val = 16'h0800;
    seq_v4.start(gen, cfg);

    seq_arp.num_txn      = 20;
    seq_arp.eth_type_val = 16'h0806;
    seq_arp.start(gen, cfg);
  endtask
endclass
