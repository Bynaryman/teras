import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles, First, with_timeout

async def test_start(dut):
    dut.rst_n.value = 0

    await ClockCycles(dut.clk, 80)
    dut.rst_n.value = 1
    dut.rts_i.value = 0
    dut.data_i.value = 0

    print("Issue active low reset")


@cocotb.test()
async def test_all(dut):

    clock = Clock(dut.clk, 10, units="us")
    cocotb.fork(clock.start())

    dut.rtr_i.value = 1
    await test_start(dut)

    assert dut.rtr_o == 1
    await ClockCycles(dut.clk, 2)
    assert dut.rts_o == 0


    dut.rts_i.value = 1
    dut.data_i.value = 0b01000000011000000000010000000001
    await ClockCycles(dut.clk, 1)
    dut.rts_i.value = 1
    dut.data_i.value = 0b00000000000100000100000010000011
    # await ClockCycles(dut.clk, 1)
    # dut.rts_i.value = 1
    # dut.data_i.value = 0b00000000000000000110000000000000
    # await ClockCycles(dut.clk, 1)
    # dut.rts_i.value = 1
    # dut.data_i.value = 0b00000000000000000100000000000000
    # await ClockCycles(dut.clk, 1)
    # dut.rts_i.value = 1
    # dut.data_i.value = 0b00000000000000000100000000001100
    # await ClockCycles(dut.clk, 1)
    # dut.rts_i.value = 1
    # dut.data_i.value = 0b00000000000000000110000000000000
    # await ClockCycles(dut.clk, 1)
    # dut.rts_i.value = 1
    # dut.data_i.value = 0b00000000000000000100000000000000
    # await ClockCycles(dut.clk, 1)
    # dut.rts_i.value = 1
    # dut.data_i.value = 0b00000000000000000100000000000000
    # await ClockCycles(dut.clk, 1)
    # dut.rts_i.value = 1
    # dut.data_i.value = 0b00000000000000000100000000000000
    # await ClockCycles(dut.clk, 1)
    # dut.rts_i.value = 1
    # dut.data_i.value = 0b00000000000000000100000000000000
    await ClockCycles(dut.clk, 1)
    dut.rts_i.value = 1
    dut.data_i.value = 0b10000000000100000000100001011000
    await ClockCycles(dut.clk, 1)
    dut.rts_i.value = 0
    dut.data_i.value = 0

    await RisingEdge(dut.rts_o)
    await ClockCycles(dut.clk, 1)
    assert dut.data_o.value != 0

