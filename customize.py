#!/usr/bin/env python

import argparse
import os
import sys
import tempfile

def customize():
    pass

def cli_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-p', '--prefix',
        help='Specify a prefix for each line of output.',
        default=''
    )
    parser.add_argument(
        '-t', '--tag',
        help='Specify a tag to search for.',
        default='##{0}##'.format(os.path.basename(__file__))
    )
    parser.add_argument(
        'files', metavar='path',
        nargs='+',
        help='Specify files to customize.'
    )
    return parser.parse_args()

if __name__ == '__main__':
    args = cli_args()
    for path in args.files:
        lines = []
        with open(path, 'r') as f:
            print('{0}{1}: Fix the following lines:'.format(args.prefix, path))
            for line in f.readlines():
                line = line.rstrip()
                l = line.split(args.tag)
                if len(l) == 1:
                    lines.append(line)
                    continue
                assert len(l) == 2, 'Only one tag is allowed per line!'
                before, after = l
                print(args.prefix)
                print(args.prefix+after)
                after = raw_input(args.prefix)
                lines.append(before+args.tag+after)
        with open(path, 'w') as f:
            for line in lines:
                f.write(line.replace(args.tag, '')+'\n')

