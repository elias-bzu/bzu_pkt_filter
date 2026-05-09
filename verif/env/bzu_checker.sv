///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

class bzu_checker;
  mailbox #(bzu_packet) mb_exp;
  mailbox #(bzu_obs) mb_act;
  bzu_filter_cfg cfg;          // current DUT cfg, set by env.program_cfg
  int unsigned   errors;
  int unsigned   processed;    // packets evaluated so far (used for sync)
  bit            verbose;

  function new(mailbox #(bzu_packet) mb_exp_i, mailbox #(bzu_obs) mb_act_i);
    mb_exp    = mb_exp_i;
    mb_act    = mb_act_i;
    errors    = 0;
    processed = 0;
    verbose   = 0;
  endfunction

  task run(int unsigned num_txn);
    for (int unsigned i = 0; i < num_txn; i++) begin
      bzu_obs act;
      bzu_packet exp_pkt;
      logic exp_accept;
      drop_reason_t exp_drop;

      mb_act.get(act);
      mb_exp.get(exp_pkt);

      if (cfg == null)
        $fatal(1, "[bzu_checker] cfg handle is null - env.program_cfg never called");

      calc_expected(
        exp_pkt.dst_mac, exp_pkt.src_mac, exp_pkt.eth_type, exp_pkt.length,
        exp_pkt.has_vlan, exp_pkt.vlan_id,
        cfg.broadcast_enable, cfg.multicast_enable,
        cfg.vlan_min, cfg.vlan_max,
        exp_accept, exp_drop
      );

      if (act.accept !== exp_accept) begin
        errors++;
        $display("[bzu_checker] ERROR accept exp=%0b act=%0b pkt=%s", exp_accept, act.accept, exp_pkt.sprint());
      end
      if (act.drop_reason !== exp_drop) begin
        errors++;
        $display("[bzu_checker] ERROR drop_reason exp=%0d act=%0d pkt=%s", exp_drop, act.drop_reason, exp_pkt.sprint());
      end

      if (verbose) begin
        $display("[bzu_checker] PASS? pkt_id=%0d exp_accept=%0b exp_drop=%0d act_accept=%0b act_drop=%0d",
                 exp_pkt.pkt_id, exp_accept, exp_drop, act.accept, act.drop_reason);
      end

      processed++;
    end

    if (errors == 0)
      $display("[bzu_checker] PASS: %0d transactions.", num_txn);
    else
      $display("[bzu_checker] FAIL: %0d errors out of %0d transactions.", errors, num_txn);
  endtask
endclass
