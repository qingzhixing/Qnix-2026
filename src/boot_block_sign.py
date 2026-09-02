#!/usr/bin/python3

import argparse

if __name__ == "__main__":
	
# 创建解析器
	parser = argparse.ArgumentParser(description='MBR签名工具')
	parser.add_argument('-i', '--input', required=True, help='待签名文件')
	parser.add_argument('-o', '--output', required=True, help='输出文件')
	
	args = parser.parse_args()
 
	print("Input file:", args.input,"\n")
	print("Output file:", args.output,"\n")
 
	input_data = None
 
	try:
		with open(args.input, 'rb') as f:
			input_data = f.read(1000)
	except FileNotFoundError:
		print("Error: Input file not found.")
		exit(1)
	except Exception as e:
		print("Error:", e)
		exit(1)
  
	print("Input file size:", len(input_data), "bytes\n")
  
	if len(input_data) > 510:
		print("Error: Input file size is larger than 510 bytes.")
		exit(1)

	# 尾部填充0到510字节
	input_data += b'\x00' * (510 - len(input_data))
	## 签名0x55aa
	input_data += b'\x55\xaa'
	
	# 写入输出文件
	try:
		with open(args.output, 'wb') as f:
			f.write(input_data)
	except Exception as e:
		print("Error:", e)
		exit(1)
