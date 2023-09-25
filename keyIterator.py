import os
import sys
from pynput import keyboard

class keyIterator:
    def __init__(self, lines, curIdx, prev_line_no, max_lines, columns):
        self.lines = lines
        self.curIdx = curIdx
        self.prev_line_no = prev_line_no
        self.max_lines = max_lines
        self.columns = columns

    def erasePrevLine(self):
        UP = '\033[1A'
        CLEAR = '\x1b[2K'
        sys.stdout.write(UP + CLEAR)
        sys.stdout.flush()

    def clear(self):
        for _ in range(self.prev_line_no):
            self.erasePrevLine()

    def on_press(self, key):
        if key == keyboard.Key.esc:
            return False  # stop listener
        try:
            k = key.char  # single-char keys
        except:
            k = key.name  # other keys
        if k in ['up', 'down']:  # keys of interest  
            if len(self.lines) != 0:
                if k == "up":
                    self.curIdx -= 1
                    self.curIdx = max(0, self.curIdx)
                else:
                    self.curIdx += 1
                    self.curIdx = min(len(self.lines) - 1, self.curIdx)
                self.clear()
                for i in range(min(self.max_lines, len(self.lines) - self.curIdx)):
                    printout = "--> " + self.lines[self.curIdx + i] if i == 0 else self.lines[self.curIdx + i]
                    if len(printout) > self.columns:
                        printout = printout[:self.columns]
                    print(printout)
                self.prev_line_no = min(self.max_lines, len(self.lines) - self.curIdx)
        elif k == 'enter':
            self.clear()
            if len(self.lines) != 0:
                printout = self.lines[self.curIdx]
                print(printout)
                os.system("printf \'" + printout + "\' | pbcopy")
                print("Successfully copied!")
            return False
        else:
            return False  # stop listener; remove this if want more keys

def main():
    lines = []
    for line in sys.stdin:
        line = line.replace("\n", "")
        lines.append(line)
    magic_offset = 41 # Chinese charaters may not take just one unit in terminal
    columns = os.get_terminal_size()[0] - magic_offset
    for i in range(min(20, len(lines))):
        printout = "--> " + lines[i] if i == 0 else lines[i]
        if len(printout) > columns:
            printout = printout[:columns]
        print(printout)
    kiter = keyIterator(lines, 0, min(20, len(lines)), 20, columns)
    listener = keyboard.Listener(on_press=kiter.on_press, suppress=True)
    listener.start()  # start to listen on a separate thread
    listener.join()  # remove if main thread is polling self.keys

if __name__ == '__main__':
    main()
    
    