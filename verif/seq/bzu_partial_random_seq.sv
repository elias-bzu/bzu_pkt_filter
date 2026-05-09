///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

// Partial randomization: dst_mac, src_mac, has_vlan and vlan_id are held
// constant via rand_mode(0); everything else (length, eth_type, payload, ...)
// keeps randomizing.
class bzu_partial_random_seq extends bzu_base_seq;
  logic [47:0] dst_mac_val  = 48'h0A0B_0C0D_0E0F;
  logic [47:0] src_mac_val  = 48'h2211_2233_4456;
  bit          has_vlan_val = 1'b0;
  logic [3:0]  vlan_id_val  = 4'd0;

  function new(string name = "partial_random_seq");
    super.new(name);
  endfunction

  virtual task body();
    for (int unsigned i = 0; i < num_txn; i++) begin
      bzu_packet pkt = new();
      apply_cfg(pkt);

      pkt.dst_mac.rand_mode(0);
      pkt.dst_mac = dst_mac_val;

      pkt.src_mac.rand_mode(0);
      pkt.src_mac = src_mac_val;

      pkt.has_vlan.rand_mode(0);
      pkt.has_vlan = has_vlan_val;

      pkt.vlan_id.rand_mode(0);
      pkt.vlan_id = vlan_id_val;

      if (!pkt.randomize()) $fatal(1, "[%s] randomize failed", name);

      if (pkt.dst_mac  !== dst_mac_val ) $fatal(1, "[%s] dst_mac changed", name);
      if (pkt.src_mac  !== src_mac_val ) $fatal(1, "[%s] src_mac changed", name);
      if (pkt.has_vlan !== has_vlan_val) $fatal(1, "[%s] has_vlan changed", name);
      if (pkt.vlan_id  !== vlan_id_val ) $fatal(1, "[%s] vlan_id changed", name);

      send(pkt);
    end
  endtask
endclass
