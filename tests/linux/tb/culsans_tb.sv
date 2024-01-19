`timescale 1ns/1ps

module culsans_tb ();

    // Clock & reset generation

    logic clk;
    logic rst;

    localparam CLK_PERIOD = 12500ps;

   initial begin
        clk = 1'b0;
        rst = 1'b1;

        repeat(8)
            #(CLK_PERIOD) clk = ~clk;

        rst = 1'b0;

        forever begin
            #(CLK_PERIOD) clk = ~clk;
        end
    end

    logic rtc;

    localparam int unsigned RTC_CLOCK_PERIOD = 30.517us;

    initial begin
        forever begin
            rtc = 1'b0;
            forever begin
                #(RTC_CLOCK_PERIOD/2) rtc = ~rtc;
            end
        end
    end

    // Detect the end of the simulation

    logic [31:0] exit_val;

    initial begin

        int fd;

        forever begin

            wait (exit_val[0]);

            fd = $fopen("result.rpt", "w");

            if ((exit_val >> 1)) begin
                $error("*** FAILED *** (tohost = %0d)", (exit_val >> 1));
                $fdisplay(fd, "FAIL");
                $fdisplay(fd, "return code: 0x%x", (exit_val >> 1));
            end else begin
                $info("*** SUCCESS *** (tohost = %0d)", (exit_val >> 1));
                $fdisplay(fd, "PASS");
            end

            $fclose(fd);

            $finish();
        end
    end

    // Memory initialisation

    initial begin
        integer file;
        integer error;
        static string  mem_init_file = "main.hex";
        static string  dtb_file = "dtb-right.mem";
//        static string  instr_init_file = "main_instr.hex";
//        static string  data_init_file = "main_data.hex";

        @(negedge rst);
        #2

        // Load binary to SRAM
        $readmemh(mem_init_file, i_culsans.i_sram.i_tc_sram.sram);
        // Need to add the load of the DTB
        $readmemh(dtb_file,     i_culsans.i_sram.i_tc_sram.sram, 'h30_0000);
        // Need to set the PC to the entry point of linux
        //

        // repeat(100) @(negedge clk);
        // for(int i=0; i<64; i++)begin
        //     $display("%h", i_culsans.i_sram.i_tc_sram.sram[i + 'h2200000]);
        // end
    end

    // DUT

    culsans_top_usecase #(
        .InclSimDTM (1'b0),
        .NUM_WORDS  (80*1024*1024), // 4Kwords
        .BootAddress (culsans_pkg::DRAMBase /*+ 64'h100000*/)
    ) i_culsans (
        .clk_i (clk),
        .rtc_i (rtc),
        .rst_ni(~rst),
        .exit_o (exit_val)
    );



    // ...

endmodule
