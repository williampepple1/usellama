@echo off
py -m pip install Pillow > py_out.txt 2>&1
py convert_icon.py C:\Users\PC\.gemini\antigravity\brain\9488c361-62da-4dc1-84af-bc0eb83bfc64\zeus_llama_icon_1772809053357.png app_icon.ico >> py_out.txt 2>&1
echo DONE
