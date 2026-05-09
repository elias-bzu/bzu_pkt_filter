///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

// One-shot DUT configuration. A test creates an instance, either calls
// set_defaults() or randomize(), then env.program_cfg(cfg) writes the
// values into the DUT's internal register file via the cfg bus.
class bzu_filter_cfg;
  rand bit         broadcast_enable;
  rand bit         multicast_enable;
  rand logic [3:0] vlan_min;
  rand logic [3:0] vlan_max;

  constraint c_vlan_range {
    vlan_min <= vlan_max;
    vlan_max inside {[4'd1:4'd15]};
  }

  function new();
    set_defaults();
  endfunction

  function void set_defaults();
    broadcast_enable = 1'b1;
    multicast_enable = 1'b1;
    vlan_min         = 4'd1;
    vlan_max         = 4'd10;
  endfunction

  function string sprint();
    return $sformatf("cfg[b_en=%0b m_en=%0b vlan=%0d:%0d]",
                     broadcast_enable, multicast_enable, vlan_min, vlan_max);
  endfunction
endclass
