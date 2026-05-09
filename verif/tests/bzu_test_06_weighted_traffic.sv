///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

class bzu_test_06_weighted_traffic extends bzu_test_base;
  function new(virtual bzu_pkt_filter_if vif_i, virtual bzu_pkt_filter_cfg_if vif_cfg_i);
    super.new(vif_i, vif_cfg_i, 120);
    verbose = 0;
  endfunction

  virtual task run_body();
    bzu_eth_type_weighted_seq seq = new("weighted_seq");
    seq.num_txn = num_txn;
    // weights default to 70/15/15 (IPv4/ARP/IPv6)
    seq.start(gen, cfg);
    if (!(seq.cnt_ipv4 > seq.cnt_arp && seq.cnt_ipv4 > seq.cnt_ipv6))
      $display("[Test6][WARN] IPv4 not dominant in this run (still ok for distribution test).");
  endtask
endclass
