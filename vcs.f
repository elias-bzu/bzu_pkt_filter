///////////////////////////////////////////
// Birzeit University
// Faculty of Engineering and Technology
// ENCS5337 – Chip Design Verification
// Homework #5 – Packet Filter DUT
// 2nd semester 25/26
// Instructor: Elias Daoud Khalil
///////////////////////////////////////////

+incdir+verif/env
+incdir+verif/cfg
+incdir+verif/seq
+incdir+verif/tests

design/bzu_pkt_filter.v
verif/if/bzu_pkt_filter_if.sv
verif/if/bzu_pkt_filter_cfg_if.sv

verif/env/bzu_pkt_filter_dv_pkg.sv
verif/env/bzu_pkt_filter_dv_components.sv
verif/seq/bzu_pkt_filter_seq_pkg.sv
verif/env/bzu_pkt_filter_test_base_pkg.sv

verif/tb/bzu_pkt_filter_test.sv
verif/tb/bzu_pkt_filter_tb.sv
