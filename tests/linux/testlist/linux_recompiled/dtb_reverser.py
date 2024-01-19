# Python script to read a file with hex dump output and write a new file with 8-byte words

def process_hex_dump_file(input_file_path, output_file_path):
    with open(input_file_path, 'r') as input_file, open(output_file_path, 'w') as output_file:
        for line in input_file:
            # Extract the bytes from the line
            bytes_hex = line[10:58].split()

            # Rearrange bytes into 8-byte words
            for i in range(0, len(bytes_hex), 8):
                word = ''.join(reversed(bytes_hex[i:i+8]))
                output_file.write(word + '\n')

# Specify the input file path (hex dump file) and output file path
input_file_path = 'pre-reverse.dtb'
output_file_path = 'dtb-right.mem'

# Call the function to process the file
# Note: This will not be executed here as it requires actual file paths.
process_hex_dump_file(input_file_path, output_file_path)
print('yo')
# Since the actual file processing can't be demonstrated in this environment,
# the code above shows how the script would be structured to read from an input file
# and write the processed output to another file. You would need to replace
# 'path/to/hex_dump.txt' and 'path/to/output_file.txt' with the actual file paths.
