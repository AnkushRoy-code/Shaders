# usage: echo "[[0.758 0.648 1.538] [0.218 0.158 0.498] [0.688 1.028 0.430] [0.378 0.748 1.048]]" | python convert_glsl_pallete.py
# this is the only thing that is made by ai.
# this python script converts the inputs of https://dev.thi.ng/gradients/ to somthing usable in shadertoy.com

import sys
import re

def convert_to_vec3():
    try:
        input_data = sys.stdin.read().strip()
        vectors = re.findall(r'\[([\d.\s-]+)\]', input_data)

        if not vectors:
            print("Error: Invalid or empty input format. Could not find any vectors.", file=sys.stderr)
            print("Please provide input like: [[1 2 3] [4 5 6]]", file=sys.stderr)
            return

        var_names = [chr(ord('a') + i) for i in range(len(vectors))]

        for i, vec_str in enumerate(vectors):
            numbers = [num for num in vec_str.strip().split() if num]
            formatted_numbers = ", ".join(numbers)
            print(f"    vec3 {var_names[i]} = vec3({formatted_numbers});")
    except Exception as e:
        print(f"An unexpected error occurred: {e}", file=sys.stderr)

if __name__ == "__main__":
    convert_to_vec3()
