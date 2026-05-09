///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

class bzu_monitor;
  virtual bzu_pkt_filter_if vif;
  mailbox #(bzu_obs) mb_act;

  function new(virtual bzu_pkt_filter_if vif_i, mailbox #(bzu_obs) mb_act_i);
    vif = vif_i;
    mb_act = mb_act_i;
  endfunction

  task run(int unsigned num_txn);
    bzu_obs obs;
    int  got = 0;

    wait (vif.rst_n === 1'b1);

    while (got < num_txn) begin
      @(vif.cb_mon);
      if (vif.cb_mon.valid_out) begin
        obs = new();
        obs.accept = vif.cb_mon.accept;
        obs.drop_reason = vif.cb_mon.drop_reason;
        mb_act.put(obs);
        got++;
      end
    end
  endtask
endclass

