///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Khalil
///////////////////////////////////////////

// Bundle of all packet-generation sequences. Tests get them via
// `import bzu_pkt_filter_seq_pkg::*;` (chained in test_base_pkg).
package bzu_pkt_filter_seq_pkg;
  import bzu_pkt_filter_dv_pkg::*;
  import bzu_pkt_filter_dv_components_pkg::*;

  `include "bzu_base_seq.sv"
  `include "bzu_random_valid_seq.sv"
  `include "bzu_eth_type_directed_seq.sv"
  `include "bzu_eth_type_weighted_seq.sv"
  `include "bzu_length_directed_seq.sv"
  `include "bzu_length_range_seq.sv"
  `include "bzu_invalid_length_seq.sv"
  `include "bzu_vlan_directed_seq.sv"
  `include "bzu_dst_mac_directed_seq.sv"
  `include "bzu_fixed_src_mac_seq.sv"
  `include "bzu_partial_random_seq.sv"
  `include "bzu_solve_order_seq.sv"
  `include "bzu_unique_eth_type_seq.sv"

endpackage
