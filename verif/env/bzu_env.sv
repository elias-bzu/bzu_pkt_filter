///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

class bzu_env;
  virtual bzu_pkt_filter_if     vif;
  virtual bzu_pkt_filter_cfg_if vif_cfg;
  bzu_agent agent;

  function new(virtual bzu_pkt_filter_if     vif_i,
               virtual bzu_pkt_filter_cfg_if vif_cfg_i);
    vif     = vif_i;
    vif_cfg = vif_cfg_i;
    agent   = new(vif, vif_cfg);
  endfunction

  // Program the DUT cfg register file once and share the cfg handle with
  // the checker so its reference model uses the same values.
  task program_cfg(bzu_filter_cfg cfg);
    agent.cfg_drv.program_cfg(cfg);
    agent.chk.cfg = cfg;
  endtask

  // Block until the checker has evaluated at least `n` packets total.
  // Used by tests that reprogram the cfg mid-run (e.g. Test 5) to make
  // sure prior traffic has fully cleared the pipeline first.
  task wait_until_processed(int unsigned n);
    wait (agent.chk.processed >= n);
  endtask

  task run(int unsigned num_txn);
    agent.run(num_txn);
  endtask
endclass
