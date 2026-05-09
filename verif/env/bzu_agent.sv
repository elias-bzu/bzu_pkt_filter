///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

class bzu_agent;
  virtual bzu_pkt_filter_if     vif;
  virtual bzu_pkt_filter_cfg_if vif_cfg;

  mailbox #(bzu_packet) mb_user;
  mailbox #(bzu_packet) mb_drv;
  mailbox #(bzu_packet) mb_chk;
  mailbox #(bzu_obs)    mb_act;

  bzu_generator  gen;
  bzu_driver     drv;
  bzu_monitor    mon;
  bzu_checker    chk;
  bzu_cfg_driver cfg_drv;

  function new(virtual bzu_pkt_filter_if     vif_i,
               virtual bzu_pkt_filter_cfg_if vif_cfg_i);
    vif     = vif_i;
    vif_cfg = vif_cfg_i;

    mb_user = new();
    mb_drv  = new();
    mb_chk  = new();
    mb_act  = new();

    gen     = new(mb_user);
    drv     = new(vif, mb_drv);
    mon     = new(vif, mb_act);
    chk     = new(mb_chk, mb_act);
    cfg_drv = new(vif_cfg);
  endfunction

  task run(int unsigned num_txn);
    fork
      begin : passer
        bzu_packet pkt;
        for (int unsigned i = 0; i < num_txn; i++) begin
          mb_user.get(pkt);
          mb_drv.put(pkt);
          mb_chk.put(pkt);
        end
      end
      drv.run(num_txn);
      mon.run(num_txn);
      chk.run(num_txn);
    join
  endtask
endclass
