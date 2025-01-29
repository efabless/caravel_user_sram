import re
import click

@click.command(
    help="""
    Add ram workaround to correctly simulate any gate-level netlist including the EF_SRAM 
    """
)
@click.option(
    "--gl",
    required=True, type=click.Path(exists=True, dir_okay=False),
    help="Gate-level netlist path"
)
def main(gl):
    # Read GL netlist 
    with open(gl, "r") as in_file:
        gl_lines = in_file.readlines()
    
    # The RAM Workaround
    ram_power_rx = re.compile(r"([\s\t]*)\.(vpwr[ap]c)\((.+?)\)\s*,")
    tracker = 0
    while tracker < len(gl_lines):
        line = gl_lines[tracker]
        if m := ram_power_rx.search(line):
            gl_lines[tracker] = f"`ifdef COCOTB_SIM\n{m[1]}.{m[2]}(1'b1),\n`else\n{m[1]}.{m[2]}({m[3]}),\n`endif\n"
        tracker += 1

    # Write the updated GL file
    with open(gl, "w") as out_gl:
        for line in gl_lines:
            out_gl.write(line)

if __name__ == "__main__":
    main()
