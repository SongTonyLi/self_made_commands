import re
import sys
import os

def iterate(path, keyword):
    for fileName in os.listdir(path):
        fullpath = f"{path}/{fileName}"
        if re.search(keyword, fileName) != None:
            print(fullpath)
        if os.path.isdir(fullpath):
            iterate(fullpath, keyword)

def main():
    args = sys.argv
    if len(args) < 2 or len(args) > 3 or (len(args) == 3 and args[1] != "-r"):
        print("Usage: regex-find <string> or regex-find -r <string>")
        return 
    keyword = args[1] if len(args) == 2 else args[2]
    iterate(".", keyword)

if __name__ == "__main__":
    main()