///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

// Demonstrate `solve A before B` ordering. We need a packet subclass to
// add the extra constraint, so the subclass lives next to the sequence
// that exercises it.
class bzu_packet_solve_order extends bzu_packet;
  constraint c_solve_order {
    solve has_vlan before vlan_id;
    solve vlan_min before vlan_id;
    solve vlan_max before vlan_id;
  }
endclass

class bzu_solve_order_seq extends bzu_base_seq;
  int unsigned cnt_vlan;

  function new(string name = "solve_order_seq");
    super.new(name);
  endfunction

  virtual task body();
    cnt_vlan = 0;
    for (int unsigned i = 0; i < num_txn; i++) begin
      bzu_packet_solve_order pkt = new();
      apply_cfg(pkt);
      if (!pkt.randomize()) $fatal(1, "[%s] randomize failed", name);
      if (pkt.has_vlan) cnt_vlan++;
      send(pkt);
    end
    $display("[%s] has_vlan=1 count=%0d/%0d (solve-before applied).",
             name, cnt_vlan, num_txn);
  endtask
endclass
