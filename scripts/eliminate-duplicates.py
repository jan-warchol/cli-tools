#!/usr/bin/python

#by Franciszek Boehlke <franio.kropka.b@gmail.com>

import os, sys

global args
args = None #set on main start

def parse_args():
    import argparse
    parser = argparse.ArgumentParser(description='Eliminate duplicated files.')
    parser.add_argument('--directory', '-d', default='.', help="directory to clean (default is current directory)")
    parser.add_argument('--hidden', '-H', action='store_true', help="look at hidden files and dirs also"
            +" (works like both --hidden-dirs and --hidden-files)")
    parser.add_argument('--hidden-dirs', action='store_true', help="look at hidden dirs also")
    parser.add_argument('--hidden-files', action='store_true', help="look at hidden files also")
    parser.add_argument('--dry-run', '-n', action='store_true', help="dry run")
    parser.add_argument('--protect-empty', '-e', action='store_true', help="don't remove empty files")
    parser.add_argument('--shortest', '-s', action='store_true', help="keep file with shortest name (abs path)")
    parser.add_argument('--recursive', '-r', action='store_true', help="eliminate duplicates in all subdirectories")
    parser.add_argument('--verbose', '-v', action='store_true', help="more verbose information")
    parser.add_argument('--quiet', '-q', action='store_true', help="prints only summaries")
    return parser.parse_args()

def getConfirmation():
    while not args.dry_run:
        print 'Do you really want to eliminate all duplicates from directory "%s"? (y/n)' % args.dirpath
        ans = sys.stdin.readline().lower()
        if ans == "y\n":
            break
        elif ans == "n\n":
            sys.exit(0)

def groupFilesBySize():
    dirpath = args.directory
    dictionary = dict()
    bytes_read = 0
    files_read = 0

    lastroot = None
    for root, dirs, filenames in os.walk(dirpath):
        if args.verbose and root != lastroot:
            print 'Indexing directory "%s"' % root
        lastroot = root
        if not args.recursive:
            dirs[:] = []
        if args.no_hidden_dirs:
            dirs[:] = [d for d in dirs if not d.startswith('.')]
        for f in filenames:
            path = os.path.join(root, f)
            if (not os.path.isfile(path) or os.path.islink(path) or 
                    (args.no_hidden_files and f.startswith('.'))):
                continue
            if args.verbose:
                print ' -> ', path
            l = os.stat(path).st_size
            files_read += 1
            bytes_read += l
            if l == 0 and args.protect_empty:
                continue
            dictionary[l] = dictionary.get(l, [])
            dictionary[l].append(path)
    return dictionary, bytes_read, files_read


def removeDups(orig, duplicates):
    removed = 0
    removed_size = 0
    if not duplicates:
        return
    if not args.quiet:
        dupstr = 'Duplicates of '
        print dupstr, orig, ':'
    size = os.stat(orig).st_size
    for fn in duplicates:
        if not args.quiet:
            print ' -> '.rjust(len(dupstr)), fn
        removed += 1
        removed_size += size
        if not args.dry_run:
            os.remove(fn)
    return removed, removed_size
    
def simplyEliminateList(duplicates):
    print 'simplyEliminateList'
    return removeDups(duplicates[0], duplicates[1:])
    
def shortestEliminateList(duplicates):
    orig = reduce(lambda a,x: a if len(a) < len(b) else b, duplicates[1:], duplicates[0])
    duplicates.remove(orig)
    return removeDups(orig, duplicates)

def generateDupsFromCandidatesList(candidate_lists):
    """Generator function; generates list of lists of possible duplicates"""
    for filelist in candidate_lists:
        if len(filelist) > 1:
            i = 0
            while i < len(filelist):
                fin = open(filelist[i],'r')
                data1 = fin.read()
                fin.close()
                j = i+1
                dups = [filelist[i], ]
                while j < len(filelist):
                    fin2 = open(filelist[j],'r')
                    data2 = fin2.read()
                    fin2.close()
                    if data1 == data2:
                        dups.append(filelist[j])
                        filelist.pop(j)
                    else:
                        j += 1
                if len(dups) > 1:
                    yield dups
                i += 1
            
def eliminate(dupslist, eliminator):
    total_removed = 0
    total_removed_size = 0
    for dups in dupslist:
        rmd, rmds = eliminator(dups)
        total_removed += rmd
        total_removed_size += rmds
    return total_removed, total_removed_size
        
if __name__ == '__main__':
    args = parse_args()
    args.dirpath = os.path.realpath(args.directory)
    args.no_hidden_dirs = not args.hidden and not args.hidden_dirs
    args.no_hidden_files = not args.hidden and not args.hidden_files
    
    getConfirmation()

    print ('Searching' if args.dry_run else 'Eliminating') + ' duplicates in dir "%s"' % args.dirpath

    dictionary, bytes_read, files_read = groupFilesBySize()

    print 'Indexed %s unique sizes of %s files (%s KiB).' % (len(dictionary), files_read, bytes_read/1024)
    print 'Searching for duplicates...'
    
    eliminator = simplyEliminateList
    if args.shortest:
        eliminator = shortestEliminateList
    
    total_removed, total_removed_size = eliminate(generateDupsFromCandidatesList(dictionary.itervalues()), eliminator)

    print
    print '%s duplicates %s %s, %s KiB in total' % (total_removed, 
            ('found in ' if args.dry_run else 'eliminated from '),
            args.dirpath, total_removed_size/1024,)
