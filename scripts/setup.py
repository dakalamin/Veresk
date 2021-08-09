import os
import sys
import subprocess as subproc

from pathlib import Path

import premake 


def script_help():
    print("usage: [your system path to python]/python setup.py [option] ...")
    print("Only one or no arguments is expected, otherwise Exception is raised")
    print("Options and arguments:")
    print("-help\t\t:" + " output reference information")
    premake.help(1)
    print("If no option or argument is specified, behaves like -default is passed\n")

    print("All debug information is provided during script runtime")
    print("In case any problems encountered, read debug carefully")
    premake.help(2)

    # so it doesn't run premake5 build
    exit()
    

def main():
    projname = 'Veresk'
    options = {
        '-default' : premake.default,
        '-update'  : premake.update,
        '-force'   : premake.force,
        '-help'    : script_help
    }


    # CWD - current working directory (whence the script was launched)
    cwd = Path(os.getcwd())

    # if currently not in "../Veresk" dir but inside some of its subdirs
    # changing CWD to "../Veresk"
    if not cwd.stem == projname:
        for parent in cwd.parents:
            if parent.stem == projname:
                os.chdir(parent)
                break
        else:
            errmsg = "This script must be executed only somewhere from '" + projname + "' project directory!"
            raise Exception(errmsg)


    if len(sys.argv) > 2:
        raise Exception("Too many options specified, only one expected!")

    # if no parameters passed, invoking default behavior
    if len(sys.argv) == 1:
        premake.default()
        
    elif sys.argv[1] not in options:
        errmsg = f"Option {sys.argv[1]} is undefined!"
        raise Exception(errmsg)

    # else, mapping the function from options dict and calling it
    else:
        options[sys.argv[1]]()


    print(f"\nRunning {premake.g_name}...")
    # running a cmd command like '[path_to_premake.exe]/premake5 vs2019'
    # that runs the lua script in project root dir
    # prebuilding it for Visual Studio 2019
    subproc.run((premake.g_path, 'vs2019'))


if __name__ == "__main__":
    main()
