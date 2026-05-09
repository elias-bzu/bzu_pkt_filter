///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

virtual class bzu_test_base;
  virtual bzu_pkt_filter_if     vif;
  virtual bzu_pkt_filter_cfg_if vif_cfg;
  bzu_env env;
  bzu_generator gen;
  bzu_filter_cfg cfg;
  int unsigned num_txn;
  bit verbose = 0;

  function new(virtual bzu_pkt_filter_if     vif_i,
               virtual bzu_pkt_filter_cfg_if vif_cfg_i,
               int unsigned                  num_txn_i);
    vif     = vif_i;
    vif_cfg = vif_cfg_i;
    num_txn = num_txn_i;
    env     = new(vif, vif_cfg);
    gen     = env.agent.gen;
    cfg     = new();          // defaults: b_en=1, m_en=1, vmin=1, vmax=10
  endfunction

  // Tests override to randomize cfg or set directed values.
  // Default: keep the defaults set in bzu_filter_cfg::set_defaults().
  virtual task setup_cfg(); endtask

  virtual task run_body(); endtask

  task run();
    $display("\n============================================================");
    $display("[%s] START (num_txn=%0d) at time=%0t", get_type_name(), num_txn, $time);
    $display("============================================================");

    env.agent.chk.verbose = verbose;

    // Build the cfg, program it into the DUT, then start traffic.
    setup_cfg();
    env.program_cfg(cfg);

    fork
      env.run(num_txn);
      run_body();
    join

    if (env.agent.chk.errors == 0)
      $display("[%s] DONE: PASS", get_type_name());
    else
      $display("[%s] DONE: FAIL errors=%0d", get_type_name(), env.agent.chk.errors);
    $display("============================================================\n");
  endtask

  function string get_type_name();
    return "bzu_test";
  endfunction
endclass
