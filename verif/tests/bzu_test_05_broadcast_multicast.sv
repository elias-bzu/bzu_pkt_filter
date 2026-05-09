///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

// Test 5 inherently exercises four different cfg combinations.
// It re-programs the DUT cfg register file via env.program_cfg() before
// each sub-sequence, demonstrating that the cfg memory is rewritable.
// Between sub-sequences it waits for the checker to drain the previous
// 5 packets so the new cfg only takes effect after the prior ones are done.
class bzu_test_05_broadcast_multicast extends bzu_test_base;
  function new(virtual bzu_pkt_filter_if vif_i, virtual bzu_pkt_filter_cfg_if vif_cfg_i);
    super.new(vif_i, vif_cfg_i, 20);
    verbose = 0;
  endfunction

  virtual task run_body();
    logic [47:0] bcast = 48'hFFFF_FFFF_FFFF;
    logic [47:0] mcast = 48'h0100_0000_0000; // dst_mac[40]=1, not broadcast
    bzu_dst_mac_directed_seq seq;

    // (1) broadcast accepted (b_en=1)
    cfg.set_defaults();
    cfg.broadcast_enable = 1'b1;
    cfg.multicast_enable = 1'b1;
    env.program_cfg(cfg);
    seq = new("bcast_ok_seq");
    seq.num_txn       = 5;
    seq.dst_mac_val   = bcast;
    seq.disable_c_dst = 1'b0;
    seq.start(gen, cfg);
    env.wait_until_processed(5);

    // (2) broadcast dropped (b_en=0)
    cfg.set_defaults();
    cfg.broadcast_enable = 1'b0;
    cfg.multicast_enable = 1'b1;
    env.program_cfg(cfg);
    seq = new("bcast_drop_seq");
    seq.num_txn       = 5;
    seq.dst_mac_val   = bcast;
    seq.disable_c_dst = 1'b1;
    seq.start(gen, cfg);
    env.wait_until_processed(10);

    // (3) multicast accepted (m_en=1)
    cfg.set_defaults();
    cfg.broadcast_enable = 1'b1;
    cfg.multicast_enable = 1'b1;
    env.program_cfg(cfg);
    seq = new("mcast_ok_seq");
    seq.num_txn       = 5;
    seq.dst_mac_val   = mcast;
    seq.disable_c_dst = 1'b0;
    seq.start(gen, cfg);
    env.wait_until_processed(15);

    // (4) multicast dropped (m_en=0)
    cfg.set_defaults();
    cfg.broadcast_enable = 1'b1;
    cfg.multicast_enable = 1'b0;
    env.program_cfg(cfg);
    seq = new("mcast_drop_seq");
    seq.num_txn       = 5;
    seq.dst_mac_val   = mcast;
    seq.disable_c_dst = 1'b1;
    seq.start(gen, cfg);
  endtask
endclass
