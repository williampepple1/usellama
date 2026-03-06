from PIL import Image
import sys

try:
    img_path = sys.argv[1]
    ico_path = sys.argv[2]
    img = Image.open(img_path)
    img.save(ico_path, format="ICO", sizes=[(256, 256), (128, 128), (64, 64), (32, 32), (16, 16)])
    print("DONE", file=open("py_out.txt", "w"))
except Exception as e:
    print("ERR: " + str(e), file=open("py_out.txt", "w"))
