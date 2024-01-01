#!/usr/bin/python3
# -*- coding: utf-8 -*-

# General version of mkdisttap.pl
# v. 0.1 20171026 Allen Garvin (aurvondel@gmail.com) 
# BSD license

import argparse, struct, sys

def main(args, ap):
    tape_str = b""

    for f in args.file:
        if ":" in f:
            fn = f.split(":")[0]
            bs = f.split(":")[1]
            if not bs.isdigit():
                ap.print_help()
                print("\nERROR: {0} in {1} is not positive integer for blocksize".format(bs, f))
                sys.exit(1)
            bs = int(bs)
        else:
            fn = f
            bs = args.blocksize

        try:
            fd = open(fn, "rb")
        except IOError as e:
            print("{0}: errno {1}: {2}".format(fn, e.errno, e.strerror))
            sys.exit(1)
        except:
            print("{0}: unexpected error: {1}".format(fn, sys.exc_info()[0]))
            sys.exit(1)
        
        flag = True
        while flag:
            s = fd.read(bs)
            if len(s) == 0:
                break
            if len(s) < bs:
                s += b"\x00" * (bs-len(s))
                flag = False
        
            f_len = struct.pack("<I", bs)
            
            tape_str += f_len + s + f_len
        tape_str += b"\x00" * 4
    tape_str += b"\x00" * 4

    if args.output:
        try:
            ofd = open(args.output, "wb")
        except IOError as e:
            print("{0}: errno {1}: {2}".format(args.output, e.errno, e.strerror))
            sys.exit(1)
        except:
            print("{0}: unexpected error: {1}".format(args.output, sys.exc_info()[0]))
            sys.exit(1)
        ofd.write(tape_str)
    else:
        sys.stdout.write(tape_str)

            
            

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Create distribution tapes for simh")
    parser.add_argument("--blocksize", "-b", type=int, help="default block size (unset, def is 10240)", default=10240)
    parser.add_argument("-output", "-o", metavar="FILE", help="output to file (if omitted, sends to stdout)")
    parser.add_argument("file", nargs="+", help="files to add in order (append with :bs where bs is block size if diff from default)")
    args = parser.parse_args()
    main(args, parser)
