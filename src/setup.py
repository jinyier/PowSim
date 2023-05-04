import math, re, time, sys, argparse, h5py
import numpy as np
from getpass import getuser
from socket import gethostname
from os.path import join, split, realpath, relpath, isdir, isfile
from os import makedirs, system, remove
from shutil import copy


def getToolLogo():
    logo = [
        '==========================================================================',
        '    _____               _____ _                                           ',
        '   |  __ \             / ____(_)                                          ',
        '   | |__) |____      _| (___  _ _ __ ___                                  ',
        '   |  ___/ _ \ \ /\ / /\___ \| | \'_ ` _ \                                 ',
        '   | |  | (_) \ V  V / ____) | | | | | | |                                ',
        '   |_|   \___/ \_/\_/ |_____/|_|_| |_| |_|                                ',
        '                                                                          ',
        '   Details: PowSim is designed to predict Power Security at gate level.   ',
        '==========================================================================',
        '   {} PowSim by {}@{}'.format(time.ctime()[4:], getuser(), gethostname()),
        '=========================================================================='
    ]

    logo = ['# ' + s + ' #' for s in logo]

    return '\n'.join(logo) + '\n'


def prepareFile(filepath):
    """ Prepare file for creation (create directory and get its absolute 
    path """
    path = realpath(filepath)
    tgtdir, tgtfile = split(path)
    if not isdir(tgtdir):
        makedirs(tgtdir, 0o700)
    return realpath(filepath)


def createFile(filepath):
    path = prepareFile(filepath)
    tgtdir, tgtfile = split(path)
    try:
        fp = open(filepath, 'w')
        fp.close()
        return path
    except IOError:
        print('Error: Can not open file {} for writting.'.format(realpath(filepath)))
        return False


def getVcsSim(filepath, seednum):
    """ Prepare setup script for VCS compilation and simulation """
    simfile = createFile(filepath)
    fp = open(simfile, 'w')

    # configure
    fp.write('vcs -Mupdate \\')
    fp.write('\n')
    fp.write('-timescale=1ns/1ps \\')
    fp.write('\n')
    fp.write('-debug_pp  \\')
    fp.write('\n')
    fp.write('-R \\')
    fp.write('\n')
    fp.write('+plusarg_save \\')
    fp.write('\n')
    fp.write('+libext+.v+.V \\')
    fp.write('\n')
    fp.write('+v2k \\')
    fp.write('\n')
    fp.write('+neg_tchk \\')
    fp.write('\n')
    fp.write('+no_lock_time \\')
    fp.write('\n')
    fp.write('+vcs+lic+wait \\')
    fp.write('\n')
    fp.write('+sdfverbose \\')
    fp.write('\n')
    fp.write('-notice \\')
    fp.write('\n')
    fp.write('-line \\')
    fp.write('\n')
    fp.write('-l ./iscas.log \\')
    fp.write('\n')
    fp.write('-f ./run.f \\')
    fp.write('\n')
    fp.write('-race \\')
    fp.write('\n')
    fp.write('-sverilog \\')
    fp.write('\n')
    fp.write('+ntb_random_seed=' + str(seednum))

    # finish
    fp.close()


def getTbGen(filepath):
    """ Prepare testbench for VCS compilation and simulation """
    # create testbench file using template file
    tmplpath = './data/tmplTestBench.v'
    copy(tmplpath, filepath)

    # delete existing stimuli files
    stimupath = 'StimuliFile.txt'
    if isfile(stimupath):
        ack = input('\nDo you want to delete stimuli file? [yes/no] ')
        if ack == 'yes':
            remove(stimupath)
        else:
            print('Cancelled.')


def runVcsSim(filepath):
    """ Run function simulation using Synopsys VCS """
    simfile = realpath(filepath)
    system('chmod +x ' + simfile)
    system(simfile)


def getPtpxSimModeOne(filepath, outnum):
    """ ModeOne: VCS and PTPX simulations execute independently """
    """ Prepare TCL script for PTPX simulation """
    simfile = createFile(filepath)
    fp = open(simfile, 'w')

    # configure
    fp.write('########################################################################\n')
    fp.write('# set the power analysis mode\n')
    fp.write('########################################################################\n')
    fp.write('\n')
    fp.write('set power_enable_analysis TRUE\n')
    fp.write('\n')
    fp.write('set power_analysis_mode time_based\n')
    fp.write('\n')
    fp.write('########################################################################\n')
    fp.write('# read and link the gate level netlist\n')
    fp.write('########################################################################\n')
    fp.write('\n')
    fp.write('set search_path " ./data "\n')
    fp.write('\n')
    fp.write('set link_library "* fast.db"\n')
    fp.write('\n')
    fp.write('read_verilog aes_top.v\n')
    fp.write('\n')
    fp.write('current_design aes_top\n')
    fp.write('\n')
    fp.write('link\n')
    fp.write('\n')
    fp.write('########################################################################\n')
    fp.write('# read SDC and set transition time or annotate parasitics\n')
    fp.write('########################################################################\n')
    fp.write('\n')
    fp.write('read_sdc ./data/aes_top.sdc -echo\n')
    fp.write('\n')
    fp.write('read_parasitics ./data/aes_top.spef\n')
    fp.write('\n')
    fp.write('########################################################################\n')
    fp.write('# check, update, or report timing\n')
    fp.write('########################################################################\n')
    fp.write('\n')
    fp.write('check_timing\n')
    fp.write('\n')
    fp.write('update_timing\n')
    fp.write('\n')
    fp.write('report_timing\n')
    fp.write('\n')
    fp.write('########################################################################\n')
    fp.write('# read switching activity file\n')
    fp.write('########################################################################\n')
    fp.write('\n')
    fp.write('read_vcd ./SwitchFile.vcd -strip_path tb_main/uut\n')
    fp.write('\n')
    fp.write('report_switching_activity -list_not_annotated\n')
    fp.write('\n')
    fp.write('########################################################################\n')
    fp.write('# check, update, or report power\n')
    fp.write('########################################################################\n')
    fp.write('\n')
    fp.write('check_power\n')
    fp.write('\n')       
    fp.write('set_power_analysis_options -waveform_interval 1 -include top -waveform_format out -waveform_output ./PowerDirs/PowerFile' + str(outnum) + '\n')
    fp.write('\n')
    fp.write('update_power\n')
    fp.write('\n')
    fp.write('report_power -hierarchy\n')
    fp.write('\n')
    fp.write('quit\n')
    fp.write('\n')
    fp.write('########################################################################\n')
    fp.write('# finish power analysis\n')
    fp.write('########################################################################\n')

    # finish
    fp.close()


def getPtpxSimModeTwo(ptpxFilePath, vcsFilePath, outnum):
    """ ModeTwo: VCS and PTPX simulations execute together """
    """ Prepare TCL script for PTPX and VCS simulation """
    # copy setup commands for VCS compilation and simulation 
    fp = open(vcsFilePath, 'r')
    vcsfile = fp.read()
    fp.close()

    # create script to combine VCS and PTPX simulations
    ptpxfile = createFile(ptpxFilePath)
    fp = open(ptpxfile, 'w')

    # configure
    fp.write('########################################################################\n')
    fp.write('# set the power analysis mode\n')
    fp.write('########################################################################\n')
    fp.write('\n')
    fp.write('set power_enable_analysis TRUE\n')
    fp.write('\n')
    fp.write('set power_analysis_mode time_based\n')
    fp.write('\n')
    fp.write('########################################################################\n')
    fp.write('# read and link the gate level netlist\n')
    fp.write('########################################################################\n')
    fp.write('\n')
    fp.write('set search_path " ./data "\n')
    fp.write('\n')
    fp.write('set link_library "* fast.db"\n')
    fp.write('\n')
    fp.write('read_verilog aes_top.v\n')
    fp.write('\n')
    fp.write('current_design aes_top\n')
    fp.write('\n')
    fp.write('link\n')
    fp.write('\n')
    fp.write('########################################################################\n')
    fp.write('# read SDC and set transition time or annotate parasitics\n')
    fp.write('########################################################################\n')
    fp.write('\n')
    fp.write('read_sdc ./data/aes_top.sdc -echo\n')
    fp.write('\n')
    fp.write('read_parasitics ./data/aes_top.spef\n')
    fp.write('\n')
    fp.write('########################################################################\n')
    fp.write('# check, update, or report timing\n')
    fp.write('########################################################################\n')
    fp.write('\n')
    fp.write('check_timing\n')
    fp.write('\n')
    fp.write('update_timing\n')
    fp.write('\n')
    fp.write('report_timing\n')
    fp.write('\n')
    fp.write('########################################################################\n')
    fp.write('# read switching activity file\n')
    fp.write('########################################################################\n')
    fp.write('\n')
    fp.write('read_vcd -pipe_exec "')
    fp.write(vcsfile)
    fp.write('" SwitchFile.vcd -strip_path tb_main/uut\n')
    fp.write('\n')
    fp.write('########################################################################\n')
    fp.write('# check, update, or report power\n')
    fp.write('########################################################################\n')
    fp.write('\n')
    fp.write('check_power\n')
    fp.write('\n')       
    fp.write('set_power_analysis_options -waveform_interval 1 -include top -waveform_format out -waveform_output ./PowerDirs/PowerFile' + str(outnum) + '\n')
    fp.write('\n')
    fp.write('update_power\n')
    fp.write('\n')
    fp.write('report_power -hierarchy\n')
    fp.write('\n')
    fp.write('report_switching_activity -list_not_annotated\n')
    fp.write('\n')
    fp.write('quit\n')
    fp.write('\n')
    fp.write('########################################################################\n')
    fp.write('# finish power analysis\n')
    fp.write('########################################################################\n')

    # finish
    fp.close()


def runPtpxSim(filepath):
    """ Run power simulation using Primetime PX """
    command = 'pt_shell -f ' + filepath
    system(command)


def getPowRepoModeOne(simcycle):
    """ ModeOne: VCS and PTPX simulations execute independently """
    """ Run Vcs and Ptpx simulation to get power reports  """
    """ PTPX reads in a saved VCD file saved by VCS """
    """ After simulation, the VCD file still exists """
    # create power dirs to store power reports
    if not isdir('PowerDirs'):
        makedirs('PowerDirs', 0o700)
    
    # Prepare testbench for VCS compilation and simulation
    tbfile = 'tb_main.v'
    getTbGen(tbfile)

    for currcycle in range(simcycle):
        
        # Prepare setup script for VCS compilation and simulation
        simfile = 'sim'
        getVcsSim(simfile, currcycle + 1)
        
        # Run function simulation using Synopsys VCS
        runVcsSim(simfile)
        
        # Prepare TCL script for PTPX simulation
        tclfile = 'ptpx.tcl'
        getPtpxSimModeOne(tclfile, currcycle)
        
        # Run power simulation using Primetime PX
        runPtpxSim(tclfile)
    
    # finish to get power report


def getPowRepoModeTwo(simcycle):
    """ ModeTwo: VCS and PTPX simulations execute together """
    """ Run Vcs and Ptpx simulation to get power reports  """
    """ PTPX reads in a VCD file directly from VCS """
    """ After simulation, the VCD file does not exist """
    # create power dirs to store power reports
    if not isdir('PowerDirs'):
        makedirs('PowerDirs', 0o700)
    
    # Prepare testbench for VCS compilation and simulation
    tbfile = 'tb_main.v'
    getTbGen(tbfile)

    for currcycle in range(simcycle):
        
        # Prepare setup script for VCS compilation and simulation
        simfile = 'sim'
        getVcsSim(simfile, currcycle + 1)
        
        # Prepare TCL script for VCS and PTPX simulation
        tclfile = 'ptpx.tcl'
        getPtpxSimModeTwo(tclfile, simfile, currcycle)
        
        # Run power simulation using Primetime PX 
        runPtpxSim(tclfile)
    
    # finish to get power report


def getTimePeriod(timelist):
    """ get integer format of desired timeperiod and timescale """
    # get time period, interval from time list
    timeperiod = timelist[1]
    timescale = timelist[3]
    # judge whether timescale small than 1 
    if timescale < 1:
        # convert timescale into scientific notation 
        sciform = '%e' % timescale
        multiple = math.pow(10, int(sciform.partition('-')[2]))
        timeperiod = int(timeperiod * multiple)
        timescale = int(timescale * multiple)
    else:
        timeperiod = int(timeperiod)
        timescale = int(timescale)
    timelist[1] = timeperiod
    timelist[3] = timescale
    return timelist


def procPowRepo(stimunum, timelist, filepath):
    """ process power reports for security analysis """
    # open power reports obtained from ptpx simulation
    powerfile = open(filepath, 'r')

    # create empty list for power name, keyword and timepoint
    powerhier = []
    powerindex = []
    timepoint = []

    # create patterns used to extract parameters
    tmpl_index = r'.index Pc\(.*?\) [\d]+ Pc'
    tmpl_time = r'^\d+\n$'

    # add matched parameters into list
    for line in powerfile.readlines():
        if re.match(tmpl_index, line):
            tmp = line.split()
            powerhier.append(tmp[1])
            powerindex.append(int(tmp[2]))
        elif re.match(tmpl_time, line):
            timepoint.append(int(line.strip('\n')))
    powerfile.seek(0)
    # print("The maximum of the time points is ", timepoint[-1])
    timepoint = np.asarray(timepoint)
    powerindex = np.asarray(powerindex)
    
    # get time start, period, interval and scale
    start_timepoint = timelist[0]
    timeperiod = timelist[1]
    inter_timepoint = timelist[2]
    timescale = timelist[3]
    sum_timepoint = timeperiod + inter_timepoint
    # create array for all power traces
    powertrace = np.full((len(powerindex), stimunum, int(timeperiod/timescale)), 1e-11, dtype=np.float32)
    # create pattern used to extract power traces
    tmpl_power = r'[\d]+  [\d]+.*'

    # add matched power values into the array
    tracked_timepoint = 0
    stimunum_recorded = 0
    for line in powerfile.readlines():
        if stimunum_recorded > stimunum:
            break
        if re.match(tmpl_time, line):
            current_timepoint = int(line.strip('\n'))
            tracked_timepoint = current_timepoint - start_timepoint - (sum_timepoint * stimunum_recorded)
            if current_timepoint > start_timepoint + stimunum * sum_timepoint:
                break
            elif tracked_timepoint >= sum_timepoint:
                stimunum_recorded += 1
                tracked_timepoint = current_timepoint - start_timepoint - (sum_timepoint * stimunum_recorded)
        if re.match(tmpl_power, line):
            if tracked_timepoint < 0 or tracked_timepoint >= timeperiod:
                continue
            tmp = line.split()
            currindex = int(tmp[0]) - 1
            powertrace[currindex, stimunum_recorded, int(tracked_timepoint/timescale)] = float(tmp[1])
    powerfile.close()

    # post-process the power trace (replace the default value)
    for current_timepoint in range(np.shape(powertrace)[2]):
        for plaintext in range(stimunum):
            vertical = np.asarray(powertrace[:, plaintext, current_timepoint] == 1e-11).nonzero()
            if current_timepoint >= 1:
                powertrace[vertical, plaintext, current_timepoint] = powertrace[vertical, plaintext, current_timepoint - 1]
            else:
                powertrace[vertical, plaintext, current_timepoint] = powertrace[vertical, plaintext, current_timepoint]

    powertrace = powertrace[0, ...]
    print("The shape of the Power trace is ", np.shape(powertrace), '\n')
    return powertrace


# you may divide a complex task into mutiple sub-tasks, for example, 
# for the goal of 10W traces, we can run simcycle=50 simulations, 
# each consists of stimunum = 2000 input stimuli like plaintexts.
def main(simcycle, stimunum, timelist):
    # display the logo of our PowSim tool
    print(getToolLogo())
    
    # first, we get power reports by simulations
    print('# ========================================================================== #')
    print('#    We provide Two Modes to execute PowSim                                  #')
    print('#    ModeOne runs VCS and PTPX simulations independently                     #')
    print('#    ModeTwo runs VCS and PTPX simulations at once.                          #')
    print('# ========================================================================== #\n')
    ack = input('Which mode do you want to execute? [ModeOne/ModeTwo] ')
    if ack == 'ModeOne':
        getPowRepoModeOne(simcycle)
    elif ack == 'ModeTwo':
        getPowRepoModeTwo(simcycle)
    else:
        getPowRepoModeOne(simcycle)
    
    runtime = '{:.2f}'.format(time.time() - start_time)
    print('Run Time to get power reports:', runtime, 'seconds\n')

    # second, we process them for security analysis
    timelist = getTimePeriod(timelist)
    fp = h5py.File('PowerTrace.h5', 'w')
    for currcycle in range(simcycle):
        print('Process power reports from simulation cycle:', str(currcycle))
        powerfile = './PowerDirs/PowerFile' + str(currcycle) + '.out'
        powertrace = procPowRepo(stimunum, timelist, powerfile)
        fp.create_dataset(str(currcycle), data=powertrace)
    fp.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--simcycle", type=int, default=5,
                        help="number of simulation cycles for required traces")
    parser.add_argument("--stimunum", type=int, default=200,
                        help="number of input stimuli for each power simulation")
    parser.add_argument("--timelist", type=list, default=[7060, 3440, 3440, 1],
                        help="time settings about start, period, interval and scale")


    args = parser.parse_args()
    simcycle = args.simcycle
    stimunum = args.stimunum
    timelist = args.timelist

    start_time = time.time()
    try:
        sys.exit(main(simcycle, stimunum, timelist))
    except KeyboardInterrupt:
        sys.exit()
    finally:
        runtime = '{:.2f}'.format(time.time() - start_time)
        print("Run Time of PowSim:", runtime, "seconds")
