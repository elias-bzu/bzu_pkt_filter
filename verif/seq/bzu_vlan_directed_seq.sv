///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

// Directed VLAN behaviour:
//  - disable_c_vlan = 0 : valid VLAN, vlan_id picked from [vlan_min:vlan_max]
//  - disable_c_vlan = 1 : invalid VLAN, vlan_id forced to vlan_id_val
class bzu_vlan_directed_seq extends bzu_base_seq;
  bit         has_vlan_val   = 1'b1;
  logic [3:0] vlan_id_val    = 4'd5;
  bit         disable_c_vlan = 1'b0;

  function new(string name = "vlan_directed_seq");
    super.new(name);
  endfunction

  virtual task body();
    for (int unsigned i = 0; i < num_txn; i++) begin
      bzu_packet pkt = new();
      apply_cfg(pkt);

      if (disable_c_vlan) begin
        pkt.c_vlan_valid.constraint_mode(0);
        if (!pkt.randomize() with {
          has_vlan == local::has_vlan_val;
          vlan_id  == local::vlan_id_val;
        }) $fatal(1, "[%s] randomize invalid VLAN failed", name);
        send(pkt, "VLAN-INV");
      end else begin
        if (!pkt.randomize() with { has_vlan == local::has_vlan_val; })
          $fatal(1, "[%s] randomize valid VLAN failed", name);
        send(pkt, "VLAN-OK");
      end
    end
  endtask
endclass
