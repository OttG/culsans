`include "ace/assign.svh"
module culsans_tb
    import ariane_pkg::*;
    import snoop_test::*;
//    import axi_test::*;
    import ace_test::*;
    import culsans_tb_pkg::*;
#()();

    `define WAIT_CYC(CLK, N)            \
    repeat(N) @(posedge(CLK));


    `define WAIT_SIG(CLK,SIG)           \
    do begin                            \
        @(posedge(CLK));                \
    end while(SIG == 1'b0);

    // ID width of the Full AXI slave port, master port has ID `AxiIdWidthFull + 32'd1`
    parameter  int unsigned AxiIdWidth   = 32'd6;
    // Address width of the full AXI bus
    parameter  int unsigned AxiAddrWidth = 32'd64;
    // Data width of the full AXI bus
    parameter  int unsigned AxiDataWidth = 32'd64;
    localparam int unsigned AxiUserWidth = 32'd1;

    localparam              CLK_PERIOD       = 10ns;
    localparam int unsigned RTC_CLOCK_PERIOD = 30.517us;


    localparam ariane_cfg_t ArianeCfg = culsans_pkg::ArianeSocCfg;

    //--------------------------------------------------------------------------
    // Signals
    //--------------------------------------------------------------------------

    // TB signals
    dcache_req_i_t [culsans_pkg::NB_CORES-1:0][2:0] dcache_req_ports_i;
    dcache_req_o_t [culsans_pkg::NB_CORES-1:0][2:0] dcache_req_ports_o;
    logic                                           clk;
    logic                                           rst_n;
    logic                                           rtc;

    dcache_intf             dcache_if        [culsans_pkg::NB_CORES-1:0][2:0] (clk);
    amo_intf                amo_if           [culsans_pkg::NB_CORES-1:0]      (clk);
    culsans_tb_sram_if      sram_if          [culsans_pkg::NB_CORES-1:0]      (clk);
    culsans_tb_gnt_if       gnt_if           [culsans_pkg::NB_CORES-1:0]      (clk);

    dcache_driver           dcache_drv       [culsans_pkg::NB_CORES-1:0][2:0];
    dcache_monitor          dcache_mon       [culsans_pkg::NB_CORES-1:0][2:0];

    amo_driver              amo_drv          [culsans_pkg::NB_CORES-1:0];
    amo_monitor             amo_mon          [culsans_pkg::NB_CORES-1:0];

    mailbox #(dcache_req)   dcache_req_mbox  [culsans_pkg::NB_CORES-1:0][2:0];
    mailbox #(dcache_resp)  dcache_resp_mbox [culsans_pkg::NB_CORES-1:0][2:0];

    mailbox #(amo_req)      amo_req_mbox     [culsans_pkg::NB_CORES-1:0];
    mailbox #(amo_resp)     amo_resp_mbox    [culsans_pkg::NB_CORES-1:0];

    dcache_checker #(
        .AXI_ADDR_WIDTH ( AxiAddrWidth       ),
        .AXI_DATA_WIDTH ( AxiDataWidth       ),
        .AXI_ID_WIDTH   ( AxiIdWidth + 32'd1 ),
        .AXI_USER_WIDTH ( AxiUserWidth       )
    ) dcache_chk [culsans_pkg::NB_CORES-1:0];

    // ACE mailboxes
    mailbox aw_mbx [culsans_pkg::NB_CORES-1:0];
    mailbox w_mbx  [culsans_pkg::NB_CORES-1:0];
    mailbox b_mbx  [culsans_pkg::NB_CORES-1:0];
    mailbox ar_mbx [culsans_pkg::NB_CORES-1:0];
    mailbox r_mbx  [culsans_pkg::NB_CORES-1:0];

    // Snoop mailboxes
    mailbox ac_mbx [culsans_pkg::NB_CORES-1:0];
    mailbox cd_mbx [culsans_pkg::NB_CORES-1:0];
    mailbox cr_mbx [culsans_pkg::NB_CORES-1:0];

    //--------------------------------------------------------------------------
    // Clock & reset generation
    //--------------------------------------------------------------------------

    initial begin
        clk   = 1'b0;
        rst_n = 1'b0;

        repeat(8)
            #(CLK_PERIOD/2) clk = ~clk;

        rst_n = 1'b1;

        forever begin
            #(CLK_PERIOD/2) clk = ~clk;
        end

    end


    initial begin
        forever begin
            rtc = 1'b0;
            forever begin
                #(RTC_CLOCK_PERIOD/2) rtc = ~rtc;
            end
        end
    end

    //--------------------------------------------------------------------------
    // DUT
    //--------------------------------------------------------------------------
    culsans_top #(
        .InclSimDTM (1'b0),
        .NUM_WORDS  (4**10), // 4Kwords
        .BootAddress (culsans_pkg::DRAMBase + 64'h10_0000)
    ) i_culsans (
        .clk_i  (clk),
        .rtc_i  (rtc),
        .rst_ni (rst_n),
        .exit_o (exit_val)
    );

    //--------------------------------------------------------------------------
    // AXI/ACE bus interfaces
    //--------------------------------------------------------------------------

    ACE_BUS #(
        .AXI_ADDR_WIDTH ( AxiAddrWidth       ),
        .AXI_DATA_WIDTH ( AxiDataWidth       ),
        .AXI_ID_WIDTH   ( AxiIdWidth + 32'd1 ),
        .AXI_USER_WIDTH ( AxiUserWidth       )
    ) ace_bus [culsans_pkg::NB_CORES] ();

    ACE_BUS_DV #(
        .AXI_ADDR_WIDTH ( AxiAddrWidth       ),
        .AXI_DATA_WIDTH ( AxiDataWidth       ),
        .AXI_ID_WIDTH   ( AxiIdWidth + 32'd1 ),
        .AXI_USER_WIDTH ( AxiUserWidth       )
    ) ace_bus_dv [culsans_pkg::NB_CORES] (clk);

    ace_monitor #(
        .IW ( AxiIdWidth + 32'd1 ),
        .AW ( AxiAddrWidth       ),
        .DW ( AxiDataWidth       ),
        .UW ( AxiUserWidth       )
    ) ace_mon [culsans_pkg::NB_CORES];


    SNOOP_BUS #(
        .SNOOP_ADDR_WIDTH( AxiAddrWidth ),
        .SNOOP_DATA_WIDTH( AxiDataWidth )
    ) snoop_bus  [culsans_pkg::NB_CORES-1:0] ();

    SNOOP_BUS_DV #(
        .SNOOP_ADDR_WIDTH( AxiAddrWidth ),
        .SNOOP_DATA_WIDTH( AxiDataWidth )
    ) snoop_bus_dv  [culsans_pkg::NB_CORES-1:0] (clk);

    snoop_monitor #(
        .AW ( AxiAddrWidth ),
        .DW ( AxiDataWidth )
    ) snoop_mon [culsans_pkg::NB_CORES];


    //--------------------------------------------------------------------------
    // Create environment
    //--------------------------------------------------------------------------

    for (genvar core_idx=0; core_idx<culsans_pkg::NB_CORES; core_idx++) begin : CORE

        // connect signals to interface
        `ACE_ASSIGN_FROM_REQ    (ace_bus   [core_idx], i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.axi_req_o)
        `ACE_ASSIGN_FROM_RESP   (ace_bus   [core_idx], i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.axi_resp_i)

        `SNOOP_ASSIGN_FROM_REQ  (snoop_bus [core_idx], i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.axi_resp_i)
        `SNOOP_ASSIGN_FROM_RESP (snoop_bus [core_idx], i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.axi_req_o)

        // connect interfaces
        `ACE_ASSIGN_MONITOR   (ace_bus_dv   [core_idx], ace_bus   [core_idx])
        `SNOOP_ASSIGN_MONITOR (snoop_bus_dv [core_idx], snoop_bus [core_idx])

        initial begin : ACE_MON
            aw_mbx [core_idx] = new();
            w_mbx  [core_idx] = new();
            b_mbx  [core_idx] = new();
            ar_mbx [core_idx] = new();
            r_mbx  [core_idx] = new();

            ace_mon[core_idx] = new(ace_bus_dv[core_idx]);

            ace_mon[core_idx].aw_mbx = aw_mbx [core_idx];
            ace_mon[core_idx].w_mbx  = w_mbx  [core_idx];
            ace_mon[core_idx].b_mbx  = b_mbx  [core_idx];
            ace_mon[core_idx].ar_mbx = ar_mbx [core_idx];
            ace_mon[core_idx].r_mbx  = r_mbx  [core_idx];

            ace_mon[core_idx].monitor();
        end

        initial begin : SNOOP_MON
            ac_mbx [core_idx] = new();
            cd_mbx [core_idx] = new();
            cr_mbx [core_idx] = new();

            snoop_mon[core_idx] = new(snoop_bus_dv[core_idx]);

            snoop_mon[core_idx].ac_mbx = ac_mbx[core_idx];
            snoop_mon[core_idx].cd_mbx = cd_mbx[core_idx];
            snoop_mon[core_idx].cr_mbx = cr_mbx[core_idx];

            snoop_mon[core_idx].monitor();
        end

        // assign SRAM IF
        assign sram_if[core_idx].vld_sram = i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.i_nbdcache.valid_dirty_sram.gen_cut[0].gen_mem.i_tc_sram_wrapper.i_tc_sram.sram;
        for (genvar i = 0; i<DCACHE_SET_ASSOC; i++) begin : sram_block
            assign sram_if[core_idx].tag_sram[i]  = i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.i_nbdcache.sram_block[i].tag_sram.gen_cut[0].gen_mem.i_tc_sram_wrapper.i_tc_sram.sram;
            assign sram_if[core_idx].data_sram[i] = i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.i_nbdcache.sram_block[i].data_sram.gen_cut[0].gen_mem.i_tc_sram_wrapper.i_tc_sram.sram;
        end

        // assign Grant IF
        assign gnt_if[core_idx].gnt[0] = i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.i_nbdcache.gnt[0] && 
            i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.i_nbdcache.we[0];

        assign gnt_if[core_idx].gnt[1] = i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.i_nbdcache.gnt[1] && 
            !(|i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.i_nbdcache.updating_cache);

        assign gnt_if[core_idx].gnt[2] = i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.i_nbdcache.gnt[2] && 
            i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.i_nbdcache.we[2];

        assign gnt_if[core_idx].gnt[3] = i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.i_nbdcache.gnt[3] && 
            i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.i_nbdcache.we[3];

        assign gnt_if[core_idx].gnt[4] = i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.i_nbdcache.gnt[4] && 
            i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.i_nbdcache.we[4];

        assign gnt_if[core_idx].bypass_gnt[0] = i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.i_nbdcache.bypass_gnt[0];
        assign gnt_if[core_idx].bypass_gnt[1] = i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.i_nbdcache.bypass_gnt[1];
        assign gnt_if[core_idx].bypass_gnt[2] = i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.i_nbdcache.bypass_gnt[2];
        assign gnt_if[core_idx].bypass_gnt[3] = i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.i_nbdcache.bypass_gnt[3];

        for (genvar port=0; port<=2; port++) begin : PORT
            // assign dcache request/response to dcache_if
            assign i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.dcache_req_ports_ex_cache[port] = dcache_if[core_idx][port].req;
            assign dcache_if[core_idx][port].resp   = i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.dcache_req_ports_cache_ex[port];
            assign dcache_if[core_idx][port].wr_gnt = i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.i_nbdcache.gnt[port+2] &&
                                                      (i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.i_nbdcache.master_ports[port+1].i_cache_ctrl.state_q == 0); // IDLE
            initial begin : DCACHE_MON
                dcache_req_mbox  [core_idx][port] = new();
                dcache_resp_mbox [core_idx][port] = new();

                dcache_mon[core_idx][port] = new(dcache_if[core_idx][port], port, $sformatf("%s[%0d][%0d]","dcache_monitor",core_idx, port));

                dcache_mon[core_idx][port].req_mbox  = dcache_req_mbox[ core_idx][port];
                dcache_mon[core_idx][port].resp_mbox = dcache_resp_mbox[core_idx][port];
                
                dcache_mon[core_idx][port].monitor();
            end

            initial begin : DCACHE_DRV
                dcache_drv[core_idx][port] = new(dcache_if[core_idx][port], $sformatf("%s[%0d][%0d]","dcache_driver",core_idx, port));
            end

        end

        // assign AMO IF
        assign i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.amo_req = amo_if[core_idx].req;
        assign amo_if[core_idx].resp = i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.amo_resp;
        assign amo_if[core_idx].gnt  = (i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.i_nbdcache.i_miss_handler.state_q        == 0) && // IDLE
                                       (i_culsans.gen_ariane[core_idx].i_ariane.i_cva6.i_cache_subsystem.i_nbdcache.i_miss_handler.miss_req_valid == 0);
        initial begin : AMO_MON
            amo_req_mbox  [core_idx] = new();
            amo_resp_mbox [core_idx] = new();

            amo_mon[core_idx] = new(amo_if[core_idx], $sformatf("%s[%0d]","amo_monitor",core_idx));

            amo_mon[core_idx].req_mbox  = amo_req_mbox[core_idx];
            amo_mon[core_idx].resp_mbox = amo_resp_mbox[core_idx];
                
            amo_mon[core_idx].monitor();
        end

        initial begin : AMO_DRV
            amo_drv[core_idx] = new(amo_if[core_idx], $sformatf("%s[%0d]","amo_driver",core_idx));
        end


        initial begin : CACHE_CHK
            dcache_chk[core_idx] = new(sram_if[core_idx], gnt_if[core_idx], ArianeCfg, $sformatf("%s[%0d]","dcache_checker",core_idx));

            dcache_chk[core_idx].dcache_req_mbox  = dcache_req_mbox  [core_idx];
            dcache_chk[core_idx].dcache_resp_mbox = dcache_resp_mbox [core_idx];

            dcache_chk[core_idx].amo_req_mbox     = amo_req_mbox     [core_idx];
            dcache_chk[core_idx].amo_resp_mbox    = amo_resp_mbox    [core_idx];

            dcache_chk[core_idx].aw_mbx           = aw_mbx           [core_idx];
            dcache_chk[core_idx].w_mbx            = w_mbx            [core_idx];
            dcache_chk[core_idx].b_mbx            = b_mbx            [core_idx];
            dcache_chk[core_idx].ar_mbx           = ar_mbx           [core_idx];
            dcache_chk[core_idx].r_mbx            = r_mbx            [core_idx];

            dcache_chk[core_idx].ac_mbx           = ac_mbx           [core_idx];
            dcache_chk[core_idx].cd_mbx           = cd_mbx           [core_idx];
            dcache_chk[core_idx].cr_mbx           = cr_mbx           [core_idx];

            dcache_chk[core_idx].run();
        end

    end


    //--------------------------------------------------------------------------
    // Tests
    //--------------------------------------------------------------------------

    localparam timeout = 1000000;
    int test_id = -1;
    int rep_cnt;

    initial begin : TESTS
        logic [63:0] addr, base_addr;

        fork

            //------------------------------------------------------------------
            // Tests
            //------------------------------------------------------------------
            begin

                `WAIT_SIG(clk, rst_n)

                `WAIT_CYC(clk, 300)


/*
                test_id++;
                $display("--------------------------------------------------------------------------");
                $display("Running test %0d", test_id);
                $display("8 consecutive read misses in the same cache set");
                $display("--------------------------------------------------------------------------");
                addr = ArianeCfg.CachedRegionAddrBase[0];

                // write to address 0-7 and then some more
                for (int i=0; i<16; i++) begin
                    dcache_drv[0][2].wr(.addr(addr + (i << DCACHE_INDEX_WIDTH)), .data(i));
                end

                // read miss x 8 - fill cache 0
                for (int i=0; i<8; i++) begin
                    dcache_drv[0][1].rd(.addr(addr + (i << DCACHE_INDEX_WIDTH)));
                end
  
                `WAIT_CYC(clk, 100)
*/
/*
                test_id++;
                $display("--------------------------------------------------------------------------");
                $display("Running test %0d", test_id);
                $display("Write conflicts to single address");
                $display("--------------------------------------------------------------------------");
                addr = ArianeCfg.CachedRegionAddrBase[0];

                // make sure data 0 is in cache
                dcache_drv[0][0].rd(.addr(addr));
                `WAIT_CYC(clk, 100)
                dcache_drv[1][0].rd(.addr(addr));
                `WAIT_CYC(clk, 100)

                // simultaneous writes to same address
                for (int i=0; i<100; i++) begin
                    fork
                        begin
                            dcache_drv[0][2].wr(.addr(addr), .data(64'hBEEFCAFE0000 + i));
                            `WAIT_CYC(clk, 10)
                            dcache_drv[0][2].wr(.addr(addr), .data(64'hBEEFCAFE0100 + i));
                        end
                        begin
                            dcache_drv[1][2].wr(.addr(addr), .data(64'hBAADF00D0000 + i));
                            `WAIT_CYC(clk, (i%19))
                            dcache_drv[1][2].wr(.addr(addr), .data(64'hDEADABBA0000 + i));
                        end
                    join
                end

                `WAIT_CYC(clk, 100)
*/
/*
                test_id++;
                $display("--------------------------------------------------------------------------");
                $display("Running test %0d", test_id);
                $display("Write conflicts to addresses in the same cache set");
                $display("--------------------------------------------------------------------------");
                addr = ArianeCfg.CachedRegionAddrBase[0];

                // read x 8 - fill cache set 0 in CPU 0
                for (int i=0; i<8; i++) begin
                    dcache_drv[0][1].rd(.addr(addr + (i << DCACHE_INDEX_WIDTH)));
                end

                // simultaneous writes to same set
                for (int i=0; i<100; i++) begin
                    fork
                        begin
                            dcache_drv[0][2].wr(.addr(addr + ((i%8) << DCACHE_INDEX_WIDTH)),     .data(64'hBEEFCAFE0000 + i));
                            `WAIT_CYC(clk, 10)
                            dcache_drv[0][2].wr(.addr(addr + ((i%8) << DCACHE_INDEX_WIDTH) + 8), .data(64'hBEEFCAFE0100 + i));
                        end
                        begin
                            dcache_drv[1][2].wr(.addr(addr+ ((i%8) << DCACHE_INDEX_WIDTH)),     .data(64'hBAADF00D0000 + i));
                            `WAIT_CYC(clk, i%19)
                            dcache_drv[1][2].wr(.addr(addr+ ((i%8) << DCACHE_INDEX_WIDTH) + 8), .data(64'hDEADABBA0000 + i));
                        end
                    join
                end

                `WAIT_CYC(clk, 100)
*/
/*
                test_id++;
                $display("--------------------------------------------------------------------------");
                $display("Running test %0d", test_id);
                $display("Write + read conflicts to single address");
                $display("--------------------------------------------------------------------------");
                addr = ArianeCfg.CachedRegionAddrBase[0];
                // make sure data 0 is in cache
                dcache_drv[0][0].rd(.addr(addr));
                `WAIT_CYC(clk, 100)
                dcache_drv[1][0].rd(.addr(addr));
                `WAIT_CYC(clk, 100)

                // simultaneous writes and read to same address
                for (int i=0; i<100; i++) begin
                    fork
                        begin                            
                            `WAIT_CYC(clk, $urandom_range(5))
                            dcache_drv[0][0].rd(.addr(addr));
                        end
                        begin
                            `WAIT_CYC(clk, $urandom_range(5))
                            dcache_drv[1][2].wr(.addr(addr), .data(64'hBAADF00D0000 + i));
                        end
                    join
                end

                `WAIT_CYC(clk, 100)
*/
/*
                test_id++;
                $display("--------------------------------------------------------------------------");
                $display("Running test %0d", test_id);
                $display("Write + read conflicts to addresses in the same cache set");
                $display("--------------------------------------------------------------------------");
                addr = ArianeCfg.CachedRegionAddrBase[0];

                // read x 8 - fill cache set 0 in CPU 0
                for (int i=0; i<8; i++) begin
                    dcache_drv[0][1].rd(.addr(addr + (i << DCACHE_INDEX_WIDTH)));
                end

                // simultaneous writes to same set
                for (int i=0; i<500; i++) begin
                    fork
                        begin
                            dcache_drv[0][2].wr(.addr(addr + ((i%8) << DCACHE_INDEX_WIDTH)),     .data(64'hBEEFCAFE0000 + i));
                            `WAIT_CYC(clk, 10)
                            dcache_drv[0][2].wr(.addr(addr + ((i%8) << DCACHE_INDEX_WIDTH) + 8), .data(64'hBEEFCAFE0100 + i));
                        end
                        begin
                            dcache_drv[1][0].rd(.addr(addr+ ((i%8) << DCACHE_INDEX_WIDTH)));
                            `WAIT_CYC(clk, i%19)
                            dcache_drv[1][0].rd(.addr(addr+ ((i%8) << DCACHE_INDEX_WIDTH) + 8));
                        end
                    join
                end

                `WAIT_CYC(clk, 100)
*/

/*
                test_id++;
                $display("--------------------------------------------------------------------------");
                $display("Running test %0d", test_id);
                $display("AMO reads and writes to single address");
                $display("--------------------------------------------------------------------------");
                addr = ArianeCfg.CachedRegionAddrBase[0];

                // simultaneous writes to same address
                for (int i=0; i<10; i++) begin
                    fork
                        begin
                            amo_drv[0].wr(.addr(addr), .data(64'hBEEFCAFE0000 + i));
                            `WAIT_CYC(clk, 5)
                            amo_drv[0].rd(.addr(addr));
                        end
                        begin
                            amo_drv[1].wr(.addr(addr), .data(64'hBAADF00D0000 + i));
                            `WAIT_CYC(clk, (i))
                            amo_drv[1].rd(.addr(addr));
                        end
                    join
                end

                `WAIT_CYC(clk, 100)
*/

/*
                test_id++;
                $display("--------------------------------------------------------------------------");
                $display("Running test %0d", test_id);
                $display("AMO write while other core is active");
                $display("--------------------------------------------------------------------------");
                base_addr = ArianeCfg.CachedRegionAddrBase[0];
                rep_cnt   = 1000;
                fork
                    begin
                        `WAIT_CYC(clk, rep_cnt*10)
                        amo_drv[0].wr(.addr(base_addr), .data(64'hBEEFCAFE0000));
                        `WAIT_CYC(clk, 5)
                        amo_drv[0].rd(.addr(base_addr));
                    end
                    begin
                        automatic int port;
                        automatic int offset;
                        for (int i=0; i<rep_cnt; i++) begin
                            port   = $urandom_range(2);
                            offset = $urandom_range(1024);
                            if (port == 2) begin
                                dcache_drv[1][2].wr(.addr(base_addr + offset), .data(64'hBEEFCAFE00000000 + offset));
                            end else begin
                                dcache_drv[1][port].rd_wait(.addr(base_addr + offset));
                            end
                        end
                    end
                join


                `WAIT_CYC(clk, 100)
*/

                test_id++;
                $display("--------------------------------------------------------------------------");
                $display("Running test %0d", test_id);
                $display("Writes and reads to random cacheable addresses ");
                $display("--------------------------------------------------------------------------");
                base_addr = ArianeCfg.CachedRegionAddrBase[0];
                rep_cnt   = 1000;

                for (int core_idx=0; core_idx<culsans_pkg::NB_CORES; core_idx++) begin
                    fork
                        automatic int my_core_idx = core_idx;
                        automatic int port;
                        automatic int offset;
                        
                        begin
                            for (int i=0; i<rep_cnt; i++) begin
                                if ($urandom_range(99) < 99) begin
                                    port   = $urandom_range(2);
                                    offset = $urandom_range(1024);
                                    if (port == 2) begin
                                        dcache_drv[my_core_idx][2].wr(.addr(base_addr + offset), .data(64'hBEEFCAFE00000000 + offset));
                                    end else begin
                                        dcache_drv[my_core_idx][port].rd_wait(.addr(base_addr + offset));
                                    end
                                end else begin
                                    if ($urandom_range(1) > 0) begin
                                        amo_drv[my_core_idx].wr(.addr(base_addr+offset), .data(64'hBEEFCAFE00000000 + offset));
                                    end else begin
                                        amo_drv[my_core_idx].rd(.addr(base_addr+offset));
                                    end
                                end
                            end
                        end

                    join_none
                end
                wait fork;

                `WAIT_CYC(clk, 100)
/*
*/

/*
                test_id++;
                $display("--------------------------------------------------------------------------");
                $display("Running test %0d", test_id);
                $display("Writes and reads to random shareable addresses ");
                $display("--------------------------------------------------------------------------");
                base_addr = ArianeCfg.SharedRegionAddrBase[0];
                rep_cnt   = 1000;

                for (int core_idx=0; core_idx<culsans_pkg::NB_CORES; core_idx++) begin
                    fork
                        automatic int my_core_idx = core_idx;
                        automatic int port;
                        automatic int offset;
                        
                        begin
                            for (int i=0; i<rep_cnt; i++) begin
                                port   = $urandom_range(2);
                                offset = $urandom_range(1024);
                                if (port == 2) begin
                                    dcache_drv[my_core_idx][2].wr(.addr(base_addr + offset), .data(64'hBEEFCAFE00000000 + offset));
                                end else begin
                                    dcache_drv[my_core_idx][port].rd_wait(.addr(base_addr + offset));
                                end
                            end
                        end

                    join_none
                end
                wait fork;

                `WAIT_CYC(clk, 100)
*/
/*
                test_id++;
                $display("--------------------------------------------------------------------------");
                $display("Running test %0d", test_id);
                $display("Writes and reads to random non-shareable addresses ");
                $display("--------------------------------------------------------------------------");
                base_addr = 0;
                rep_cnt   = 1500;

                for (int core_idx=0; core_idx<culsans_pkg::NB_CORES; core_idx++) begin
                    fork
                        automatic int my_core_idx = core_idx;
                        automatic int port;
                        automatic int offset;
                        
                        begin
                            for (int i=0; i<rep_cnt; i++) begin
                                port   = $urandom_range(2);
                                offset = $urandom_range(1024);
                                if (port == 2) begin
                                    dcache_drv[my_core_idx][2].wr(.addr(base_addr + offset), .data(64'hBEEFCAFE00000000 + offset));
                                end else begin
                                    dcache_drv[my_core_idx][port].rd_wait(.addr(base_addr + offset));
                                end
                            end
                        end

                    join_none
                end
                wait fork;

                `WAIT_CYC(clk, 100)
*/

                // NOTE: this test currently fails at it hits bug described in PROJ-149
/*
                test_id++;
                $display("--------------------------------------------------------------------------");
                $display("Running test %0d", test_id);
                $display("Writes and reads to random addresses:");
                $display("  cacheable");
                $display("  shareable, non-cacheable");
                $display("--------------------------------------------------------------------------");
                base_addr = ArianeCfg.CachedRegionAddrBase[0];
                rep_cnt   = 1000;

                for (int core_idx=0; core_idx<culsans_pkg::NB_CORES; core_idx++) begin
                    fork
                        automatic int my_core_idx = core_idx;
                        automatic int port;
                        automatic int offset;
                        automatic int addr_region;

                        begin
                            for (int i=0; i<rep_cnt; i++) begin
                                port        = $urandom_range(2);
                                offset      = $urandom_range(1024);
                                addr_region = $urandom_range(1);

                                case (addr_region)
                                    0       : base_addr = ArianeCfg.CachedRegionAddrBase[0];
                                    default : base_addr = ArianeCfg.SharedRegionAddrBase[0];
                                endcase

                                if (port == 2) begin
                                    dcache_drv[my_core_idx][2].wr(.addr(base_addr + offset), .data(64'hBEEFCAFE00000000 + offset));
                                end else begin
                                    dcache_drv[my_core_idx][port].rd_wait(.addr(base_addr + offset));
                                end
                            end
                        end

                    join_none
                end
                wait fork;

                `WAIT_CYC(clk, 100)
*/

                // NOTE: this test currently fails at it hits bug described in PROJ-149
/*
                test_id++;
                $display("--------------------------------------------------------------------------");
                $display("Running test %0d", test_id);
                $display("Writes and reads to random addresses:");
                $display("  cacheable");
                $display("  non-shareable, non-cacheable");
                $display("--------------------------------------------------------------------------");
                base_addr = ArianeCfg.CachedRegionAddrBase[0];
                rep_cnt   = 1000;

                for (int core_idx=0; core_idx<culsans_pkg::NB_CORES; core_idx++) begin
                    fork
                        automatic int my_core_idx = core_idx;
                        automatic int port;
                        automatic int offset;
                        automatic int addr_region;

                        begin
                            for (int i=0; i<rep_cnt; i++) begin
                                port        = $urandom_range(2);
                                offset      = $urandom_range(1024);
                                addr_region = $urandom_range(1);

                                case (addr_region)
                                    0       : base_addr = ArianeCfg.CachedRegionAddrBase[0];
                                    default : base_addr = 0;
                                endcase

                                if (port == 2) begin
                                    dcache_drv[my_core_idx][2].wr(.addr(base_addr + offset), .data(64'hBEEFCAFE00000000 + offset));
                                end else begin
                                    dcache_drv[my_core_idx][port].rd_wait(.addr(base_addr + offset));
                                end
                            end
                        end

                    join_none
                end
                wait fork;

                `WAIT_CYC(clk, 1000)
*/
/*
                test_id++;
                $display("--------------------------------------------------------------------------");
                $display("Running test %0d", test_id);
                $display("Writes and reads to random addresses:");
                $display("  shareable, non-cacheable");
                $display("  non-shareable, non-cacheable");
                $display("--------------------------------------------------------------------------");
                base_addr = ArianeCfg.CachedRegionAddrBase[0];
                rep_cnt   = 1000;

                for (int core_idx=0; core_idx<culsans_pkg::NB_CORES; core_idx++) begin
                    fork
                        automatic int my_core_idx = core_idx;
                        automatic int port;
                        automatic int offset;
                        automatic int addr_region;

                        begin
                            for (int i=0; i<rep_cnt; i++) begin
                                port        = $urandom_range(2);
                                offset      = $urandom_range(1024);
                                addr_region = $urandom_range(1);

                                case (addr_region)
                                    0       : base_addr = ArianeCfg.SharedRegionAddrBase[0];
                                    default : base_addr = 0;
                                endcase

                                if (port == 2) begin
                                    dcache_drv[my_core_idx][2].wr(.addr(base_addr + offset), .data(64'hBEEFCAFE00000000 + offset));
                                end else begin
                                    dcache_drv[my_core_idx][port].rd_wait(.addr(base_addr + offset));
                                end
                            end
                        end

                    join_none
                end
                wait fork;

                `WAIT_CYC(clk, 100)
*/


/*
                // This test triggers issue described in JIRA Issue PROJ-149
                test_id = 98;
                $display("--------------------------------------------------------------------------");
                $display("Running test %0d", test_id);
                $display("writes and reads to random addresses in all address areas");
                $display("--------------------------------------------------------------------------");
                base_addr = ArianeCfg.CachedRegionAddrBase[0];
                rep_cnt   = 1000;

                for (int core_idx=0; core_idx<culsans_pkg::NB_CORES; core_idx++) begin
                    fork
                        automatic int my_core_idx = core_idx;
                        automatic int port;
                        automatic int offset;
                        automatic int addr_region;

                        begin
                            for (int i=0; i<rep_cnt; i++) begin
                                port        = $urandom_range(2);
                                offset      = $urandom_range(1024);
                                addr_region = $urandom_range(2);

                                case (addr_region)
                                    0       : base_addr = ArianeCfg.CachedRegionAddrBase[0];
                                    1       : base_addr = ArianeCfg.SharedRegionAddrBase[0];
                                    default : base_addr = 0;
                                endcase

                                if (port == 2) begin
                                    dcache_drv[my_core_idx][2].wr(.addr(base_addr + offset), .data(64'hBEEFCAFE00000000 + offset));
                                end else begin
                                    dcache_drv[my_core_idx][port].rd_wait(.addr(base_addr + offset));
                                end
                            end
                        end

                    join_none
                end
                wait fork;

                `WAIT_CYC(clk, 100)
*/


/*
                test_id = 99;
                $display("--------------------------------------------------------------------------");
                $display("Running test %0d", test_id);
                $display("rigger issue described in JIRA issue PROJ-147");
                $display("--------------------------------------------------------------------------");
                addr = ArianeCfg.CachedRegionAddrBase[0];

                // make sure data[0] is in cache
                dcache_drv[0][0].rd(.addr(addr));
                `WAIT_CYC(clk, 100)

                // read followed by 2 writes (here with 1 cc inbetween, could be back-to-back too)
                dcache_drv[0][0].rd(.addr(addr));
                dcache_drv[0][0].wr(.addr(addr), .data(32'hBBBBBBBB));
                `WAIT_CYC(clk, 1)
                dcache_drv[0][0].wr(.addr(addr), .data(32'hCCCCCCCC));
                `WAIT_CYC(clk, 1)
                // read 0 again to visualize in waveforms that the value 0xCCCCCCCC is not stored
                dcache_drv[0][0].rd(.addr(addr));

                `WAIT_CYC(clk, 100)
*/

                //--------------------------------------------------------------
                // end of tests
                //--------------------------------------------------------------
                `WAIT_CYC(clk, 100)
                $display("Test done");
                $finish();

            end

            //------------------------------------------------------------------
            // Timeout
            //------------------------------------------------------------------
            begin
                `WAIT_CYC(clk, timeout)
                $error("Timeout");
                $finish();
            end

        join_any
        disable fork;

    end

endmodule
