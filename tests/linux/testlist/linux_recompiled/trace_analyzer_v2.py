import re
import pdb;
import shutil

def is_hex_in_range(hex_number, hex_range):
    # Convert the hexadecimal numbers to integers
    start = int(hex_range[0], 16)
    end = int(hex_range[1], 16)
    number = int(hex_number, 16)

    # Check if the number falls within the range
    return start <= number <= end

def stack_trace(output_file, input_file, functionRanges):
    state = 'normal'
    currentFunction = None
    prevCommitted = None
    timestamp = None

    with open(output_file, 'w') as fs:
        with open(input_file, 'r') as fi:
            for line in fi:
                splitted_line = line.split()
                try:
                    committedAddr = splitted_line[3]
                except:
                    committedAddr = committedAddr
                timestamp     = splitted_line[0]

                if ('Exception' in line):
                    state = 'exception'
                    fs.write(line)
                elif (state == 'exception'):
                    state = 'normal'
                    fs.write(line)
                elif (state == 'normal'):
                    try:
                        newFunction = functionRanges[int(committedAddr, 16)]
                    except:
                        #print(f'Address not found: {committedAddr}')
                        pass
                    if (newFunction != currentFunction):
                        currentFunction = newFunction
                        fs.write(f'Function: {newFunction}, Timestamp {timestamp}, Entry point {committedAddr}, PrevCommitted {prevCommitted}\n')
                    prevCommitted = committedAddr

def func_def(inpFile, functionRanges):
    state = 'waitForParse'
    funcMatch = r'<(.*?)>'
    hexValue = r'([0-9a-fA-F]+)'

    # Open the disassembly and extract
    with open(inpFile, 'r') as fi:
        for line in fi:

            # Do not parse until we find the .text section
            if (state == 'waitForParse'):
                state = 'noFunc' if ('.text' in line and '.head' not in line) else 'waitForParse'

            # We are parsing but we haven't found a function yet in the disassembly
            elif(state == 'noFunc'):
                # If we have the beginning of a function, get the name and change state.
                if ('<' in line and '>' in line):
                    match = re.search(funcMatch, line)
                    if match:
                        funcName = match.group(1)
                    else:
                        raiseException('Error, somehow I could not match the function name')

                    # Regular expression to find hexadecimal number
                    match = re.search(hexValue, line)

                    # Extract and process the hexadecimal number if a match is found
                    if match:
                        # Convert the first address of the function to integer and store it with the function.
                        start_address = int(match.group(1), 16)
                        functionRanges[start_address] = funcName
                    else:
                        raiseException('Error, found no function starting address')

                    state = 'funcFound'

                # Last check, kill the parsing if we are not in a function and we are getting into a section
                # of the disassembly that is not .text
                if('Disassembly of section' in line and '.text' not in line or '.head' in line):
                    #pdb.set_trace()
                    state = 'waitForParse'

            # We found a function, get throught lines until we encouter an empty line or '...'
            # At the end of a function change state and record the last address.
            elif(state == 'funcFound'):
                # Check if the line is empty
                stripped_line = line.strip()
                if (stripped_line == '' or '...' in line):
                    # ranges = (start_address, last_address)
                    # functionRanges[ranges] = funcName
                    state = 'noFunc'
                else:
                    match = re.search(hexValue, line)
                    if match:
                        currentAddress = int(match.group(1), 16)
                        functionRanges[currentAddress] = funcName
                    else:
                        raiseException('Error, no address for the instruction!!!')

    print(f'Definition of fuctions in {inpFile} done!')
    return functionRanges

def main():
    function_ranges = {}
    function_ranges = func_def('linux.dis',      function_ranges)
    function_ranges = func_def('fw_payload.dis', function_ranges)

    # Open the instruciton trace from CVA6 and get log the function calls. Each time we enter
    # a new function print its name and the timestamp.

    # stack_trace('stack_core_0', 'trace_hart_0.log', functionRanges)
    # stack_trace('stack_core_1', 'trace_hart_1.log', functionRanges)
    print(f'Creating a copy of the core traces!')
    shutil.copy('trace_hart_0.log', 'trace_hart_0.copy')
    shutil.copy('trace_hart_1.log', 'trace_hart_1.copy')

    print(f'Analyzing traces!')
    stack_trace('stack_core_0', 'trace_hart_0.copy', function_ranges)
    stack_trace('stack_core_1', 'trace_hart_1.copy', function_ranges)

    print('Fixup missing addresses in the payload (fw_payload.bin)')
if __name__ == "__main__":
    main()
